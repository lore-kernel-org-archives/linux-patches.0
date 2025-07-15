Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A77192D8A;
	Tue, 15 Jul 2025 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585730; cv=none; b=PoS6yDxqm4omqjspzb3xqOVbr/bF1SCXQ+8qh1IcyxnYysWwLqrtYpRxeJY1qQ55FmHl74AONEBJQPtlBg4vGv0AweEnuGX2jc8YLNFKqzERBvzX7pBt58kK4L1jv0yQmMDYWuMkIXI4PUio1RHKRWc0emtyIpz5cCLHVPoAzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585730; c=relaxed/simple;
	bh=l10+plt18Mm/A/Vfnczk/HVYtUCZgb2qf+xrIuuRngA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djAr/73s6XTMTx4paAh1xM+GRf16Blf/YzICUgJaeao3ezEPXOWiyy8ywbjLvRxLmrgdmEsOiXI+gkzXL0oluiK1qpBO9yoDRrVjXwkWbyQbfcpSV/S+BQqnlTT8qIXcpkJ/gMN+EC8AiuPRAzA9MnrWKimkH0KzKk8zJnWg3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk7P/0Nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk7P/0Nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40546C4CEE3;
	Tue, 15 Jul 2025 13:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585730;
	bh=l10+plt18Mm/A/Vfnczk/HVYtUCZgb2qf+xrIuuRngA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tk7P/0NcHIyU4+iSQdzfejwxokQmcz3wLaMSZr1oDHMVOIGTNM6SP5R9PwH0T0XZZ
	 L+rAyccbyMKWglZCxkgGmc2v6DmPFCq80TtM5wVa9PH0KokzIzeEFeLEt3Ux6IehaX
	 KiIpHwrpkEomd4PnNfTeXm6JiOGqzYXfteGybL5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Inoue <niyarium@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/163] HID: lenovo: Add support for ThinkPad X1 Tablet Thin Keyboard Gen2
Date: Tue, 15 Jul 2025 15:13:37 +0200
Message-ID: <20250715130814.812043266@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Inoue <niyarium@gmail.com>

[ Upstream commit a8905238c3bbe13db90065ed74682418f23830c3 ]

Add "Thinkpad X1 Tablet Gen 2 Keyboard" PID to hid-lenovo driver to fix trackpoint not working issue.

Signed-off-by: Akira Inoue <niyarium@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-lenovo.c     | 8 ++++++++
 drivers/hid/hid-multitouch.c | 8 +++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c6424f6259487..49dc86981287a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -814,6 +814,7 @@
 #define USB_DEVICE_ID_LENOVO_TPPRODOCK	0x6067
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
+#define USB_DEVICE_ID_LENOVO_X1_TAB2	0x60a4
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
 #define USB_DEVICE_ID_LENOVO_X12_TAB2	0x61ae
diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index 56e530860caef..8482852c662dd 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -473,6 +473,7 @@ static int lenovo_input_mapping(struct hid_device *hdev,
 		return lenovo_input_mapping_tp10_ultrabook_kbd(hdev, hi, field,
 							       usage, bit, max);
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB2:
 	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		return lenovo_input_mapping_x1_tab_kbd(hdev, hi, field, usage, bit, max);
 	default:
@@ -587,6 +588,7 @@ static ssize_t attr_fn_lock_store(struct device *dev,
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB2:
 	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		ret = lenovo_led_set_tp10ubkbd(hdev, TP10UBKBD_FN_LOCK_LED, value);
 		if (ret)
@@ -781,6 +783,7 @@ static int lenovo_event(struct hid_device *hdev, struct hid_field *field,
 		return lenovo_event_cptkbd(hdev, field, usage, value);
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB2:
 	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		return lenovo_event_tp10ubkbd(hdev, field, usage, value);
 	default:
@@ -1062,6 +1065,7 @@ static int lenovo_led_brightness_set(struct led_classdev *led_cdev,
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB2:
 	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		ret = lenovo_led_set_tp10ubkbd(hdev, tp10ubkbd_led[led_nr], value);
 		break;
@@ -1293,6 +1297,7 @@ static int lenovo_probe(struct hid_device *hdev,
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB2:
 	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		ret = lenovo_probe_tp10ubkbd(hdev);
 		break;
@@ -1380,6 +1385,7 @@ static void lenovo_remove(struct hid_device *hdev)
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB2:
 	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		lenovo_remove_tp10ubkbd(hdev);
 		break;
@@ -1430,6 +1436,8 @@ static const struct hid_device_id lenovo_devices[] = {
 	 */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X1_TAB) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X1_TAB2) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X1_TAB3) },
 	{ }
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 93b5c648ef82c..641292cfdaa6f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2116,12 +2116,18 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_GENERIC,
 			USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_7010) },
 
-	/* Lenovo X1 TAB Gen 2 */
+	/* Lenovo X1 TAB Gen 1 */
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
 		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X1_TAB) },
 
+	/* Lenovo X1 TAB Gen 2 */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X1_TAB2) },
+
 	/* Lenovo X1 TAB Gen 3 */
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
 		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
-- 
2.39.5



