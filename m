Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E02612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D11FC433EF;
	Mon,  3 Apr 2023 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531727;
	bh=XTDuqyjgti2NWC470q43ZVMqGzKewYj4dalnHhFmmH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQl6UgSKdmAg4r/3IkJNO+FDL9XppF8y4rEHfOLm8gIzoZ3Zi9z6blCMdWYZEM47+
	 X90CRBC4MPWY0xbWH2km16i5jS2Qu85r2wAYmQdOoUzQx6GK2ua98WmVkPI424AO/q
	 08Qvsb4fBQufjmjLgGuqNVXK4FuhmJvshsEP2wYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 088/104] Input: focaltech - use explicitly signed char type
Date: Mon,  3 Apr 2023 16:09:20 +0200
Message-Id: <20230403140407.603872516@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
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
@@ -202,8 +202,8 @@ static void focaltech_process_rel_packet
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
@@ -218,8 +218,8 @@ static void focaltech_process_rel_packet
 	 */
 	finger2 = ((packet[3] >> 4) & 0x7) - 1;
 	if (finger2 < FOC_MAX_FINGERS) {
-		state->fingers[finger2].x += (char)packet[4];
-		state->fingers[finger2].y += (char)packet[5];
+		state->fingers[finger2].x += (s8)packet[4];
+		state->fingers[finger2].y += (s8)packet[5];
 	}
 }
 


