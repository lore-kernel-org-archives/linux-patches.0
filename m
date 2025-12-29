Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208B6330B2A;
	Mon, 29 Dec 2025 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025251; cv=none; b=PADsXZg5jt3oEHJhGlfqCBkVs3xZrZIl54Y8yPIzM0n5dUNnaO6My4FcjGYrQloNTzZvBlIxWukFwg6XUaRT4SMFW04zoYXpyMImuEZR52Iq0vy7tvQx+BevVgg61n/mvE4ygNets3LHwxJCiKauDzJyYzgB370HB2MTED3p/+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025251; c=relaxed/simple;
	bh=B6XYUcYvr8T1YoVS5APMQVZScSYdgxQ5Tn3M+fsHy1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO0dQmppY4+o/uWrim+2nfG+jxw3iI7supt+xBW+f/BabuWUq1pcdZhkbpoHARfhcxRjz1h5NRi0p59Bv05Vlz8Ykm9WBZQwl9kx93RFNlGulrpcGOHPYuZPQvxhR5UNNe9P04rYs9sOqZWUEhoz78eaHx9u/Q1tz/xuxXA6c+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hweBAt6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hweBAt6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C822C16AAE;
	Mon, 29 Dec 2025 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025251;
	bh=B6XYUcYvr8T1YoVS5APMQVZScSYdgxQ5Tn3M+fsHy1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hweBAt6tVSgfkfm90+krnpJU6pDNoB5ILgX6zdaaghDXBWL/siPOZYZzohBvRIkmr
	 eC8WoeFuFHMTf9NRjTSQyGhb1ihDoZRJxcpOvHq5bXatWW3UDTI7DLmO8kHTujxcAW
	 AoKfqY2+lPd31A9M5wpoUIx3YUWDsaGDJUMVGvlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Govind <sanjay.govind9@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 148/430] Input: xpad - add support for CRKD Guitars
Date: Mon, 29 Dec 2025 17:09:10 +0100
Message-ID: <20251229160729.808871904@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay Govind <sanjay.govind9@gmail.com>

commit 806ec7b797adc1cc9b11535307638a55ddfb873c upstream.

Add support for various CRKD Guitar Controllers.

Signed-off-by: Sanjay Govind <sanjay.govind9@gmail.com>
Link: https://patch.msgid.link/20251129073720.2750-2-sanjay.govind9@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -133,6 +133,8 @@ static const struct xpad_device {
 } xpad_device[] = {
 	/* Please keep this list sorted by vendor and product ID. */
 	{ 0x0079, 0x18d4, "GPD Win 2 X-Box Controller", 0, XTYPE_XBOX360 },
+	{ 0x0351, 0x1000, "CRKD LP Blueberry Burst Pro Edition (Xbox)", 0, XTYPE_XBOX360 },
+	{ 0x0351, 0x2000, "CRKD LP Black Tribal Edition (Xbox) ", 0, XTYPE_XBOX360 },
 	{ 0x03eb, 0xff01, "Wooting One (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x03eb, 0xff02, "Wooting Two (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x03f0, 0x038D, "HyperX Clutch", 0, XTYPE_XBOX360 },			/* wired */
@@ -420,6 +422,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
+	{ 0x3651, 0x1000, "CRKD SG", 0, XTYPE_XBOX360 },
 	{ 0x366c, 0x0005, "ByoWave Proteus Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE, FLAG_DELAY_INIT },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0x37d7, 0x2501, "Flydigi Apex 5", 0, XTYPE_XBOX360 },
@@ -518,6 +521,7 @@ static const struct usb_device_id xpad_t
 	 */
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* Xbox USB-IF not-approved class */
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 controller */
+	XPAD_XBOX360_VENDOR(0x0351),		/* CRKD Controllers */
 	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
 	XPAD_XBOX360_VENDOR(0x03f0),		/* HP HyperX Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x03f0),		/* HP HyperX Xbox One controllers */
@@ -578,6 +582,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x3651),		/* CRKD Controllers */
 	XPAD_XBOXONE_VENDOR(0x366c),		/* ByoWave controllers */
 	XPAD_XBOX360_VENDOR(0x37d7),		/* Flydigi Controllers */
 	XPAD_XBOX360_VENDOR(0x413d),		/* Black Shark Green Ghost Controller */


