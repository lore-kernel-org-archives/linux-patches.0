Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B911EF398;
	Wed, 19 Mar 2025 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394961; cv=none; b=dY5AOLpLDzFiz0ocyuxSRt307v4vK4fpo5I4bQoouxqYrVxAjR/VGJPi8yrMkIp5EdmkqnkspuhqhctaIVtlyBwVGi9S1ZJce5oxktaKoC3gJTDMfsbfkGUy2XyOMQ7CiOJo/dYmrue6zi1tlW1wkvt/zzVDhrqu7lGzunM2ZMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394961; c=relaxed/simple;
	bh=RwJNqV1W+MNdFVtw3uQDDen4aCt2Le5pIJMYplYaRaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKS5p6nMC3x9XGWrTPg12pL67mgm9fK/EZewaCPreLY/7gPMRw+gu/qifJ/ulbjOlxTDh5gpRMomy8VDTBJLtIg5/NMHpbw9MUHKobFQHtYKHAlcu3mMj3d6z5uq2gsQSYfNIS/DVbjev1GxNK/Vkvgita9BCVgCYdzi56TXlh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yW/NPC7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yW/NPC7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7EDC4CEE4;
	Wed, 19 Mar 2025 14:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394961;
	bh=RwJNqV1W+MNdFVtw3uQDDen4aCt2Le5pIJMYplYaRaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yW/NPC7uL2BUPj61r87RJs9qcpUJoHTVxefM2SWcp/pQSXVkPW/ahhUDrfXyHgxgO
	 Mdbw0MOQD9qDVU+JloLKnYocdipIoHxV7lSYr8cDPqk0bEdm/cuThnA7T4W2A79W56
	 Hi/5TGPJwiCn5mucleknm/d50yrozMPr36RAaA3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 154/241] Input: xpad - add multiple supported devices
Date: Wed, 19 Mar 2025 07:30:24 -0700
Message-ID: <20250319143031.531810858@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Rojtberg <rojtberg@gmail.com>

commit 3492321e2e60ddfe91aa438bb9ac209016f48f7a upstream.

This is based on multiple commits at https://github.com/paroj/xpad
that had bouncing email addresses and were not signed off.

Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250123175404.23254-1-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -140,6 +140,7 @@ static const struct xpad_device {
 	{ 0x044f, 0x0f00, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f03, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
+	{ 0x044f, 0xd01e, "ThrustMaster, Inc. ESWAP X 2 ELDEN RING EDITION", 0, XTYPE_XBOXONE },
 	{ 0x044f, 0x0f10, "Thrustmaster Modena GT Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0xb326, "Thrustmaster Gamepad GP XID", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", 0, XTYPE_XBOX },
@@ -177,6 +178,7 @@ static const struct xpad_device {
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0201, "Saitek Adrenalin", 0, XTYPE_XBOX },
 	{ 0x06a3, 0xf51a, "Saitek P3600", 0, XTYPE_XBOX360 },
+	{ 0x0738, 0x4503, "Mad Catz Racing Wheel", 0, XTYPE_XBOXONE },
 	{ 0x0738, 0x4506, "Mad Catz 4506 Wireless Controller", 0, XTYPE_XBOX },
 	{ 0x0738, 0x4516, "Mad Catz Control Pad", 0, XTYPE_XBOX },
 	{ 0x0738, 0x4520, "Mad Catz Control Pad Pro", 0, XTYPE_XBOX },
@@ -238,6 +240,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x015d, "PDP Mirror's Edge Official Wired Controller for Xbox One", XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0162, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0163, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
@@ -276,12 +279,15 @@ static const struct xpad_device {
 	{ 0x0f0d, 0x0078, "Hori Real Arcade Pro V Kai Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x00c5, "Hori Fighting Commander ONE", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x00dc, "HORIPAD FPS for Nintendo Switch", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
+	{ 0x0f0d, 0x0151, "Hori Racing Wheel Overdrive for Xbox Series X", 0, XTYPE_XBOXONE },
+	{ 0x0f0d, 0x0152, "Hori Racing Wheel Overdrive for Xbox Series X", 0, XTYPE_XBOXONE },
 	{ 0x0f30, 0x010b, "Philips Recoil", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x0202, "Joytech Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", 0, XTYPE_XBOX },
 	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x1038, 0x1430, "SteelSeries Stratus Duo", 0, XTYPE_XBOX360 },
 	{ 0x1038, 0x1431, "SteelSeries Stratus Duo", 0, XTYPE_XBOX360 },
+	{ 0x10f5, 0x7005, "Turtle Beach Recon Controller", 0, XTYPE_XBOXONE },
 	{ 0x11c9, 0x55f0, "Nacon GC-100XF", 0, XTYPE_XBOX360 },
 	{ 0x11ff, 0x0511, "PXN V900", 0, XTYPE_XBOX360 },
 	{ 0x1209, 0x2882, "Ardwiino Controller", 0, XTYPE_XBOX360 },
@@ -366,6 +372,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5510, "Hori Fighting Commander ONE (Xbox 360/PC Mode)", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x551a, "PowerA FUSION Pro Controller", 0, XTYPE_XBOXONE },
 	{ 0x24c6, 0x561a, "PowerA FUSION Controller", 0, XTYPE_XBOXONE },
+	{ 0x24c6, 0x581a, "ThrustMaster XB1 Classic Controller", 0, XTYPE_XBOXONE },
 	{ 0x24c6, 0x5b00, "ThrustMaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5b02, "Thrustmaster, Inc. GPX Controller", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
@@ -376,10 +383,12 @@ static const struct xpad_device {
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
-	{ 0x2dc8, 0x6001, "8BitDo SN30 Pro", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x6001, "8BitDo SN30 Pro", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x2e24, 0x1688, "Hyperkin X91 X-Box One pad", 0, XTYPE_XBOXONE },
+	{ 0x2e95, 0x0504, "SCUF Gaming Controller", MAP_SELECT_BUTTON, XTYPE_XBOXONE },
 	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
@@ -387,12 +396,16 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1230, "Wooting Two HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0603, "Nacon Pro Compact controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0614, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
+	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
+	{ 0x413d, 0x2104, "Black Shark Green Ghost Gamepad", 0, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
 };
@@ -491,6 +504,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x03f0),		/* HP HyperX Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x03f0),		/* HP HyperX Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster Xbox 360 controllers */
+	XPAD_XBOXONE_VENDOR(0x044f),		/* Thrustmaster Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech Xbox 360-style controllers */
@@ -537,11 +551,13 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Controllers */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Controllers */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOXONE_VENDOR(0x2e95),		/* SCUF Gaming Controller */
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x413d),		/* Black Shark Green Ghost Controller */
 	{ }
 };
 
@@ -694,7 +710,9 @@ static const struct xboxone_init_packet
 	XBOXONE_INIT_PKT(0x045e, 0x0b00, xboxone_s_init),
 	XBOXONE_INIT_PKT(0x045e, 0x0b00, extra_input_packet_init),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_led_on),
+	XBOXONE_INIT_PKT(0x20d6, 0xa01a, xboxone_pdp_led_on),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_auth),
+	XBOXONE_INIT_PKT(0x20d6, 0xa01a, xboxone_pdp_auth),
 	XBOXONE_INIT_PKT(0x24c6, 0x541a, xboxone_rumblebegin_init),
 	XBOXONE_INIT_PKT(0x24c6, 0x542a, xboxone_rumblebegin_init),
 	XBOXONE_INIT_PKT(0x24c6, 0x543a, xboxone_rumblebegin_init),


