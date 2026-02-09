Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892DF37A496;
	Mon,  9 Feb 2026 14:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647384; cv=none; b=JskbsPshBgM+RVxqLZPch7WnJi6UxeEMUbpgaIXncYSfpdhhdlnKmUQ9SWvnyPCClTM9f8Vfn5QLugX0vsmyv8uZFElA7A6FqlIq4KFwZcxc722khgH9RpVe2pz6rf49QOA5ZR8uiWTOaOkLx2uLensJuXTzu5PaXGgGvGZmLZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647384; c=relaxed/simple;
	bh=h85Jy/4aJAC+6FEuo7XyKi5IuriXfszphqM88TjCOuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJZejCpbIJjy+tzaj1+hbdk4TSv3EsjSssSBicOAQDZ7aEuBgvrHlvZTdkTkPfr+mdaXZeIrXzL84eVpyw8qqYfCAg6T9ClyKiNCFWUn5owghWwPy4KN4FgXiMfqRBbWLpecNl5fwmHY1RJNMRY3VGVGXNdN+6K3uBro6tD5Tt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOje40NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOje40NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB05C116C6;
	Mon,  9 Feb 2026 14:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647384;
	bh=h85Jy/4aJAC+6FEuo7XyKi5IuriXfszphqM88TjCOuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOje40NLusy/awzRgpBxM24tX78iISkkEJ3jKrTVhrKD/3N2raOYGyBYy9cmu8g9b
	 w+Xf3YaqCR9/Au+TAX8hWeHlFBISVFcjWuHJ0oWd57TkPcxjzzaDSxHVwlkVygwOtN
	 aNPKw30DppXswqVtih7swlmHoJGvcFxSWJ2JPPRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnoud Willemsen <mail@lynthium.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/175] HID: Elecom: Add support for ELECOM M-XT3DRBK (018C)
Date: Mon,  9 Feb 2026 15:22:36 +0100
Message-ID: <20260209142323.424855548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Arnoud Willemsen <mail@lynthium.com>

[ Upstream commit 12adb969658ec39265eb8c7ea9e1856867fb9ceb ]

Wireless/new version of the Elecom trackball mouse M-XT3DRBK has a
product id that differs from the existing M-XT3DRBK.
The report descriptor format also seems to have changed and matches
other (newer?) models instead (except for six buttons instead of eight).
This patch follows the same format as the patch for the M-XT3URBK (018F)
by Naoki Ueki (Nov 3rd 2025) to enable the sixth mouse button.

dmesg output:
[  292.074664] usb 1-2: new full-speed USB device number 7 using xhci_hcd
[  292.218667] usb 1-2: New USB device found, idVendor=056e, idProduct=018c, bcdDevice= 1.00
[  292.218676] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  292.218679] usb 1-2: Product: ELECOM TrackBall Mouse
[  292.218681] usb 1-2: Manufacturer: ELECOM

usbhid-dump output:
001:006:000:DESCRIPTOR         1765072638.050578
 05 01 09 02 A1 01 09 01 A1 00 85 01 05 09 19 01
 29 05 15 00 25 01 95 08 75 01 81 02 95 01 75 00
 81 01 05 01 09 30 09 31 16 00 80 26 FF 7F 75 10
 95 02 81 06 C0 A1 00 05 01 09 38 15 81 25 7F 75
 08 95 01 81 06 C0 A1 00 05 0C 0A 38 02 95 01 75
 08 15 81 25 7F 81 06 C0 C0 06 01 FF 09 00 A1 01
 85 02 09 00 15 00 26 FF 00 75 08 95 07 81 02 C0
 05 0C 09 01 A1 01 85 05 15 00 26 3C 02 19 00 2A
 3C 02 75 10 95 01 81 00 C0 05 01 09 80 A1 01 85
 03 19 81 29 83 15 00 25 01 95 03 75 01 81 02 95
 01 75 05 81 01 C0 06 BC FF 09 88 A1 01 85 04 95
 01 75 08 15 00 26 FF 00 19 00 2A FF 00 81 00 C0
 06 02 FF 09 02 A1 01 85 06 09 02 15 00 26 FF 00
 75 08 95 07 B1 02 C0

Signed-off-by: Arnoud Willemsen <mail@lynthium.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elecom.c | 15 +++++++++++++--
 drivers/hid/hid-ids.h    |  3 ++-
 drivers/hid/hid-quirks.c |  3 ++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 981d1b6e96589..2003d2dcda7cc 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -77,7 +77,7 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		break;
 	case USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB:
 	case USB_DEVICE_ID_ELECOM_M_XT3URBK_018F:
-	case USB_DEVICE_ID_ELECOM_M_XT3DRBK:
+	case USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC:
 	case USB_DEVICE_ID_ELECOM_M_XT4DRBK:
 		/*
 		 * Report descriptor format:
@@ -102,6 +102,16 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 12, 30, 14, 20, 8);
 		break;
+	case USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C:
+		/*
+		 * Report descriptor format:
+		 * 22: button bit count
+		 * 30: padding bit count
+		 * 24: button report size
+		 * 16: button usage maximum
+		 */
+		mouse_button_fixup(hdev, rdesc, *rsize, 22, 30, 24, 16, 6);
+		break;
 	case USB_DEVICE_ID_ELECOM_M_DT2DRBK:
 	case USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C:
 		/*
@@ -122,7 +132,8 @@ static const struct hid_device_id elecom_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index bec913a005a5d..b75d9d2f4dc73 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -455,7 +455,8 @@
 #define USB_DEVICE_ID_ELECOM_M_XGL20DLBK	0x00e6
 #define USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB	0x00fb
 #define USB_DEVICE_ID_ELECOM_M_XT3URBK_018F	0x018f
-#define USB_DEVICE_ID_ELECOM_M_XT3DRBK	0x00fc
+#define USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC	0x00fc
+#define USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C	0x018c
 #define USB_DEVICE_ID_ELECOM_M_XT4DRBK	0x00fd
 #define USB_DEVICE_ID_ELECOM_M_DT1URBK	0x00fe
 #define USB_DEVICE_ID_ELECOM_M_DT1DRBK	0x00ff
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 31b2a5d1cd98f..11438039cdb7f 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -422,7 +422,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
-- 
2.51.0



