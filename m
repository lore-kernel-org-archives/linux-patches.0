Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465E16FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF0C433EF;
	Mon,  3 Apr 2023 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533292;
	bh=b433K2IxkgY2T+vFMSNzzrQicmbc2Ss7MekLP91B3c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dcoe1AZ5vG6MHIn9xsGivXfQsm0hatMCPNNbZP0VAjhZJjxoPc8H/XDj17lRsPEeU
	 Y4RmurNVK1yvPYZZQPGYs2RF5zbFkRFnonvZiKTLJnouM30t0RQV9k8x6lDYSF/ESj
	 nlSRtOQGzBxHFugNxd++759qYDPsu2Q02Pc2cO9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.2 128/187] Input: i8042 - add TUXEDO devices to i8042 quirk tables for partial fix
Date: Mon,  3 Apr 2023 16:09:33 +0200
Message-Id: <20230403140420.199630345@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

commit cbedf1a33970c9b825ae75b81fbd3e88e224a418 upstream.

A lot of modern Clevo barebones have touchpad and/or keyboard issues after
suspend fixable with nomux + reset + noloop + nopnp. Luckily, none of them
have an external PS/2 port so this can safely be set for all of them.

I'm not entirely sure if every device listed really needs all four quirks,
but after testing and production use, no negative effects could be
observed when setting all four.

Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS on the Clevo N150CU
and the Clevo NHxxRZQ makes the keyboard very laggy for ~5 seconds after
boot and sometimes also after resume. However both are required for the
keyboard to not fail completely sometimes after boot or resume.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230321191619.647911-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1117,11 +1117,39 @@ static const struct dmi_system_id i8042_
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
+		/*
+		 * Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS makes
+		 * the keyboard very laggy for ~5 seconds after boot and
+		 * sometimes also after resume.
+		 * However both are required for the keyboard to not fail
+		 * completely sometimes after boot or resume.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "N150CU"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NH5xAx"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		/*
+		 * Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS makes
+		 * the keyboard very laggy for ~5 seconds after boot and
+		 * sometimes also after resume.
+		 * However both are required for the keyboard to not fail
+		 * completely sometimes after boot or resume.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "NHxxRZQ"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
 		.matches = {


