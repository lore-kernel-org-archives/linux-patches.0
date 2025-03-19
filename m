Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6301B422A;
	Wed, 19 Mar 2025 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394884; cv=none; b=hHb94OOMYbMmgo9EJS//Vbnfjzk7BfUDpCrA+bI0icDi0RU7I4ZNowYYyiZ3Y1OI4YvA6tjAmBcEKP6KddVFVwTpqXhG8juMZgiFYLfoZ0C8Ejkog1B8ADWJMLq+TeIA/yXNcVjVzOVOvHdsTJnItQZ5KTnbzIfVz7gsqzJdLfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394884; c=relaxed/simple;
	bh=AHNzIsyjGqZQphEFJ777gb8DlnucUq4qms2umzsXutg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyMLc2mhXUQJzgy9uAEJTBNx/SRnzcOPbjdAyvEUEWlttNYkWvGUjqeRfFtXFH7xElAC9Cr6OLFwk/SpHRHA9nWfsFxOyIojSaoGxkdGrnFg7DejcqQxKCHF2yzt2U/tdSuxDSqJ+bh+STgNq3/WZA7ByiCac0mQBuGjRkUTYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moRHHeb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moRHHeb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7299FC4CEE4;
	Wed, 19 Mar 2025 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394884;
	bh=AHNzIsyjGqZQphEFJ777gb8DlnucUq4qms2umzsXutg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moRHHeb4LJV45SIu9Kq5TweKdujZ+jq/9jwZEu3g0kCvKQjzSWvQ4NPCKafayn7cA
	 yIgjw8SQrczX/HhURl1Rt0SfhyZkLV9jmYSqx6yJxBIepAGcscvHRLPHnTdoYrv6Cm
	 YJUeORjMdpXW+9AvWRzFDtR1S3Y800J11Rehvyks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ievgen Vovk <YevgenVovk@ukr.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/241] HID: hid-apple: Apple Magic Keyboard a3203 USB-C support
Date: Wed, 19 Mar 2025 07:29:15 -0700
Message-ID: <20250319143029.831972492@linuxfoundation.org>
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
index 7e1ae2a2bcc24..3c3f67d0bfcfe 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -474,6 +474,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2015)
 			table = magic_keyboard_2015_fn_keys;
 		else if (hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021 ||
+			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2024 ||
 			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021 ||
 			 hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021)
 			table = apple2021_fn_keys;
@@ -1150,6 +1151,10 @@ static const struct hid_device_id apple_devices[] = {
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
index 4df0bfc3c8413..c4ca7a579e3d4 100644
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



