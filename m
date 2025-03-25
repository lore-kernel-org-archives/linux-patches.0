Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEE625A2B9;
	Tue, 25 Mar 2025 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905621; cv=none; b=WRO8clMT41NzBoU8yib6Um7Yb/DXTIkbgyqYZNUSakYSIJGbQdeufYDAbQt5MvtYMqiPUZGhq7og1qi4OU893PriCGL7Oe9gY8Yc9TVY5vOJd3cnfv4EgKd/yf66qPlmRuP0WzYd9flDO7Fa08blMsaZw4+hWWyG852KpYHE+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905621; c=relaxed/simple;
	bh=f/lPOkDyWPonbyNl5bdWiX1Z7CESb8if3O9ggwgSuXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1ZjmuiCia8HO/JGOF8geVlNjkqm2orl625bgEdfzZZr3A8yQYt8i0DXu5/kZgiVi+6EDzi0hKYLwznOAn2+2WacrtR/nw499aMzmeJRY9H0Ub4KHleAZEflj67uXIOR9yaoDONx3oPH7yw+k2UHHfLTE2zmz0sUmxJKKnd6trU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AndALMew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AndALMew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436A4C4CEEE;
	Tue, 25 Mar 2025 12:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905621;
	bh=f/lPOkDyWPonbyNl5bdWiX1Z7CESb8if3O9ggwgSuXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AndALMewR96L4hdauz8tjWfiPBOXi/tmn+UlrqI5Lx+A0fSRkQLr5DklXilj9Kghm
	 8VNwMhuzVmFg/tHLUy0sr6F+21btYoHuWRZV6Rz2rr4NHPK3u8OvlpXNjo8EQzHZpN
	 7tvZfgheGjD1LyAIZkpf2shHNSfwgZeVbV5NcDyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ievgen Vovk <YevgenVovk@ukr.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/198] HID: hid-apple: Apple Magic Keyboard a3203 USB-C support
Date: Tue, 25 Mar 2025 08:20:06 -0400
Message-ID: <20250325122157.793386726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ievgen Vovk <YevgenVovk@ukr.net>

[ Upstream commit 2813e00dcd748cef47d2bffaa04071de93fddf00 ]

Add Apple Magic Keyboard 2024 model (with USB-C port) device ID (0320)
to those recognized by the hid-apple driver. Keyboard is otherwise
compatible with the existing implementation for its earlier 2021 model.

Signed-off-by: Ievgen Vovk <YevgenVovk@ukr.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 5 +++++
 drivers/hid/hid-ids.h   | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 37b2ce9b50fe8..da8751601534f 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -425,6 +425,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2015)
 			table = magic_keyboard_2015_fn_keys;
 		else if (hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021 ||
+			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2024 ||
 			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021 ||
 			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021)
 			table = apple2021_fn_keys;
@@ -1030,6 +1031,10 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2024),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
+	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2024),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021),
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 29b8c96ce9f4d..4187d890bcc1a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -184,6 +184,7 @@
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
 #define USB_DEVICE_ID_APPLE_IRCONTROL5	0x8243
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021   0x029c
+#define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2024   0x0320
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021   0x029a
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021   0x029f
 #define USB_DEVICE_ID_APPLE_TOUCHBAR_BACKLIGHT 0x8102
-- 
2.39.5



