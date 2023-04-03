Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A35683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C12C433EF;
	Mon,  3 Apr 2023 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531502;
	bh=zjEk9E6e7qe1JmkTXMOwfLHd9Pot19JP8A+Cy+lz/Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHF7Gz0jMZnoTksUgSw81jdpum4ncX9NQYg2MegL90RzYiL6Vwt3THw7r309X0+8X
	 8Lz9lIkNWzYyh+oU61KN7/z5QecA3IerOEWRlbBvH8MygnJAarXh96OGh31BGIv9Lp
	 Imkx4ocpjhAsaiHjd1fDb4MefSLBW/fCyu07djXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 68/84] Input: focaltech - use explicitly signed char type
Date: Mon,  3 Apr 2023 16:09:09 +0200
Message-Id: <20230403140355.780763292@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 8980f190947ba29f23110408e712444884b74251 upstream.

The recent change of -funsigned-char causes additions of negative
numbers to become additions of large positive numbers, leading to wrong
calculations of mouse movement. Change these casts to be explicitly
signed, to take into account negative offsets.

Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217211
Link: https://lore.kernel.org/r/20230318133010.1285202-1-Jason@zx2c4.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/focaltech.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -206,8 +206,8 @@ static void focaltech_process_rel_packet
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;
 	if (finger1 < FOC_MAX_FINGERS) {
-		state->fingers[finger1].x += (char)packet[1];
-		state->fingers[finger1].y += (char)packet[2];
+		state->fingers[finger1].x += (s8)packet[1];
+		state->fingers[finger1].y += (s8)packet[2];
 	} else {
 		psmouse_err(psmouse, "First finger in rel packet invalid: %d\n",
 			    finger1);
@@ -222,8 +222,8 @@ static void focaltech_process_rel_packet
 	 */
 	finger2 = ((packet[3] >> 4) & 0x7) - 1;
 	if (finger2 < FOC_MAX_FINGERS) {
-		state->fingers[finger2].x += (char)packet[4];
-		state->fingers[finger2].y += (char)packet[5];
+		state->fingers[finger2].x += (s8)packet[4];
+		state->fingers[finger2].y += (s8)packet[5];
 	}
 }
 


