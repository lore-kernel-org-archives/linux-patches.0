Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98FD313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301045; cv=none; b=BNfDQ4kNKBiaRi2oy93xMQEamM6sYGlx9ry2GwX41Hkx7MwVXYi5DcQTHetbCoTNtDQ1McEEyaIDDQqloQ6Dkun0r1WCCmBfGr53/bOLGsXRRFfBmBmBGDwcRgYQJVH4EACQs4Vu7J8QnX9OmF5MlSb1mj4zVTKAFj/yeflkaVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301045; c=relaxed/simple;
	bh=duYKQxbUiZ4D66YO/5JaoDWuTsaMDYH02wnYSPqw8Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk6yhSZEYkL1bmwrzuBtyyltKqgiEPTJib0y7fAteo624Gbg7rWyrsged7zyOQ/gE8MMPXDMSTuPByGtlIFgt3baJbIa1mxBURx9mUYaLiiErn7/V7c0ReLOqRI3/aUCppkDVBIbAnD3BAzLQgOGh6nisawDt9n4Syt6UzbxPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvsxFB2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvsxFB2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B1DC116D0;
	Sat, 28 Feb 2026 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301045;
	bh=duYKQxbUiZ4D66YO/5JaoDWuTsaMDYH02wnYSPqw8Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvsxFB2twqeb4Wo443hkPk3+MgBOD2Y10w084IsNjD2wS87QSdVW3K78eE/lW1nj8
	 j7YL+z50zWQFi4glWaAGNyZXtFnLkfRWBNSRQ+2s3tm5zjRNRP49LSv4Cu9QrFvjGj
	 FpgK/gbwDCflmBAknZxA+gv/cbcrkwNt9Cxk7Q1asNnPN2cjnmR/aAY7PX6KeJBO90
	 bWf/E4PwJ0ENwJlVXiOI57uGmNSnVxvdFEVAePvL4wGZv/Id+6KUWQucEnfxqsPfE2
	 vdag1edw2nwJ7+9KsNp1xCxZ5/RnXciBuTLgd5W8fFraujb8FyrTxNC//qcn51KaBz
	 +5CFEbgNROO7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Phillips <david@profile.sh>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/752] HID: elecom: Add support for ELECOM HUGE Plus M-HT1MRBK
Date: Sat, 28 Feb 2026 12:38:15 -0500
Message-ID: <20260228174750.1542406-184-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Phillips <david@profile.sh>

[ Upstream commit b8e5fdf0bd022cd5493a5987ef66f5a24f8352d8 ]

New model in the ELECOM HUGE trackball line that has 8 buttons but the
report descriptor specifies only 5. The HUGE Plus supports connecting via
Bluetooth, 2.4GHz wireless USB dongle, and directly via a USB-C cable.
Each connection type reports a different device id, 01AA for cable,
01AB for USB dongle, and 01AC for Bluetooth.

This patch adds these device IDs and applies the fixups similar to the
other ELECOM devices to get all 8 buttons working for all 3 connection
types.

For reference, the usbhid-dump output:
001:013:001:DESCRIPTOR         1769085639.598405
 05 01 09 02 A1 01 85 01 09 01 A1 00 05 09 19 01
 29 05 15 00 25 01 75 01 95 05 81 02 75 03 95 01
 81 01 05 01 09 30 09 31 16 01 80 26 FF 7F 75 10
 95 02 81 06 09 38 15 81 25 7F 75 08 95 01 81 06
 05 0C 0A 38 02 15 81 25 7F 75 08 95 01 81 06 C0
 C0 05 0C 09 01 A1 01 85 02 15 01 26 8C 02 19 01
 2A 8C 02 75 10 95 01 81 00 C0 05 01 09 80 A1 01
 85 03 09 82 09 81 09 83 15 00 25 01 19 01 29 03
 75 01 95 03 81 02 95 05 81 01 C0 06 01 FF 09 00
 A1 01 85 08 09 00 15 00 26 FF 00 75 08 95 07 81
 02 C0 06 02 FF 09 02 A1 01 85 06 09 02 15 00 26
 FF 00 75 08 95 07 B1 02 C0

Signed-off-by: David Phillips <david@profile.sh>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig      |  1 +
 drivers/hid/hid-elecom.c | 16 ++++++++++++++++
 drivers/hid/hid-ids.h    |  3 +++
 drivers/hid/hid-quirks.c |  3 +++
 4 files changed, 23 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 04420a713be08..03ad8b5c29a4d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -369,6 +369,7 @@ config HID_ELECOM
 	  - EX-G Trackballs (M-XT3DRBK, M-XT3URBK)
 	  - DEFT Trackballs (M-DT1DRBK, M-DT1URBK, M-DT2DRBK, M-DT2URBK)
 	  - HUGE Trackballs (M-HT1DRBK, M-HT1URBK)
+	  - HUGE Plus Trackball (M-HT1MRBK)
 
 config HID_ELO
 	tristate "ELO USB 4000/4500 touchscreen"
diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 2003d2dcda7cc..37d88ce57f671 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -5,6 +5,7 @@
  *  - EX-G Trackballs (M-XT3DRBK, M-XT3URBK, M-XT4DRBK)
  *  - DEFT Trackballs (M-DT1DRBK, M-DT1URBK, M-DT2DRBK, M-DT2URBK)
  *  - HUGE Trackballs (M-HT1DRBK, M-HT1URBK)
+ *  - HUGE Plus Trackball (M-HT1MRBK)
  *
  *  Copyright (c) 2010 Richard Nauber <Richard.Nauber@gmail.com>
  *  Copyright (c) 2016 Yuxuan Shui <yshuiv7@gmail.com>
@@ -123,12 +124,25 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 22, 30, 24, 16, 8);
 		break;
+	case USB_DEVICE_ID_ELECOM_M_HT1MRBK:
+	case USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB:
+	case USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC:
+		/*
+		 * Report descriptor format:
+		 * 24: button bit count
+		 * 28: padding bit count
+		 * 22: button report size
+		 * 16: button usage maximum
+		 */
+		mouse_button_fixup(hdev, rdesc, *rsize, 24, 28, 22, 16, 8);
+		break;
 	}
 	return rdesc;
 }
 
 static const struct hid_device_id elecom_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
@@ -142,6 +156,8 @@ static const struct hid_device_id elecom_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_019B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, elecom_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 240fcff0ca71e..f5715cf9468fc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,6 +466,9 @@
 #define USB_DEVICE_ID_ELECOM_M_HT1URBK_019B	0x019b
 #define USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D	0x010d
 #define USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C	0x011c
+#define USB_DEVICE_ID_ELECOM_M_HT1MRBK	0x01aa
+#define USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB	0x01ab
+#define USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC	0x01ac
 
 #define USB_VENDOR_ID_DREAM_CHEEKY	0x1d34
 #define USB_DEVICE_ID_DREAM_CHEEKY_WN	0x0004
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 11438039cdb7f..3217e436c052c 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -420,6 +420,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #if IS_ENABLED(CONFIG_HID_ELECOM)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
@@ -432,6 +433,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_019B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB) },
 #endif
 #if IS_ENABLED(CONFIG_HID_ELO)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, 0x0009) },
-- 
2.51.0

