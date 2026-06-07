Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E5B2AF1D;
	Sun,  7 Jun 2026 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829232; cv=none; b=gBleFE7qjNGJqo8Ws+eZpUHrwXb4/EcXRTKLTBbHhvXurX84rPvyZm75yLXJn+qKcdFqQAN+WxYb80CX1X851wbdGtFUzb7U52K6vyiB6Vw9lwbV9oLEujv9BT3QykgSgt6Lip5BjRt/5pUnMvO/5xvLexgEyXMraUurbWEP99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829232; c=relaxed/simple;
	bh=Bslrw6000OzW7/xlh7JdgxOlUJmDqQiii6I6UJNELF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwcX4rerZmzqHlHsqMv2LoMjxUb8jdPoMmL1j/XfiWbo7k/HArR/00jKtvoem3YkeqbzPMPSimKKjFOUlaktazB4Anjg9wV5ExwXLKKY2E+qQ4mOs4dM9vyS80GUElEMe2jYN0Mz/HpXZPllEBimqi19mM18/IZ6jRY6gHDb60Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgWjyB/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgWjyB/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3071F00893;
	Sun,  7 Jun 2026 10:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829231;
	bh=at1HUJmLdYoWm7YmLR9fS7/Q3YQJewCv7YRv+e0gE5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgWjyB/Ak/6DYVU1AFDMuAz9CeqgZIBl2WIbPvE6hcMKXNcFp7eqk4GlREbabujhf
	 /VScv4hLRLS2CpGNV2XR7+mlMhkuffJJPHW93vcOsDzggofhfqWuL4+6VjVJkgUTfV
	 WAEs40+kBZ5lOtI0NSsJhwvjx1h+F8eySOu6s41E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Zharov <contact@zharov.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 206/307] Input: xpad - add support for ASUS ROG RAIKIRI II
Date: Sun,  7 Jun 2026 12:00:03 +0200
Message-ID: <20260607095735.289652843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitriy Zharov <contact@zharov.dev>

commit c897cf120696b94f56ed0f3197ba9a77071a59ec upstream.

Add the VID/PIDs for the ASUS ROG RAIKIRI II controller to xpad_device
and the VID to xpad_table. The controller has a physical PC/XBOX toggle
which switches between XBOX360 and XBOXONE protocols.

Signed-off-by: Dmitriy Zharov <contact@zharov.dev>
Link: https://patch.msgid.link/20260430183522.122151-1-contact@zharov.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -215,6 +215,10 @@ static const struct xpad_device {
 	{ 0x07ff, 0xffff, "Mad Catz GamePad", 0, XTYPE_XBOX360 },
 	{ 0x0b05, 0x1a38, "ASUS ROG RAIKIRI", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x0b05, 0x1abb, "ASUS ROG RAIKIRI PRO", 0, XTYPE_XBOXONE },
+	{ 0x0b05, 0x1c91, "ASUS ROG RAIKIRI II", 0, XTYPE_XBOX360 },
+	{ 0x0b05, 0x1c92, "ASUS ROG RAIKIRI II WIRELESS", 0, XTYPE_XBOX360 },
+	{ 0x0b05, 0x1c96, "ASUS ROG RAIKIRI II XBOX", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
+	{ 0x0b05, 0x1d04, "ASUS ROG RAIKIRI II XBOX WIRELESS", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x0c12, 0x0005, "Intec wireless", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8801, "Nyko Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
@@ -528,6 +532,7 @@ static const struct usb_device_id xpad_t
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOXONE_VENDOR(0x0738),		/* Mad Catz FightStick TE 2 */
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz Gamepad */
+	XPAD_XBOX360_VENDOR(0x0b05),		/* ASUS controllers */
 	XPAD_XBOXONE_VENDOR(0x0b05),		/* ASUS controllers */
 	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0db0),		/* Micro Star International X-Box 360 controllers */


