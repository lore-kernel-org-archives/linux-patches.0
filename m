Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120BB28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB45C433EF;
	Mon, 30 Jan 2023 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087773;
	bh=22vqKdte5+ZuoITYXeS0JfPR8v7M/2G5VV2jnLBEAhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryjP8mhiVzrqaicJ6P67jk97frgd5z1wf605ioMm6vkGJTlE6uTWNRFU0FN1vuaks
	 dNvredZbv+v1Y+B1EjqfKB5f802c+tC56ArqRT3xC41nAP+m6ERSs9XDBEm99oZ8OR
	 ssghkPuc7wWyq9X9p5adUkcMKYKQPs/+pAss9Z3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 305/313] Input: i8042 - add Clevo PCX0DX to i8042 quirk table
Date: Mon, 30 Jan 2023 14:52:20 +0100
Message-Id: <20230130134350.952521547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Werner Sembach <wse@tuxedocomputers.com>

commit 9c445d2637c938a800fcc8b5f0b10e60c94460c7 upstream.

The Clevo PCX0DX/TUXEDO XP1511, need quirks for the keyboard to not be
occasionally unresponsive after resume.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/20230110134524.553620-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1240,6 +1240,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "PCX0DX"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "X170SM"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


