Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E582369215;
	Thu, 12 Mar 2026 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346997; cv=none; b=flW5Zx+QlMrnb0xmftM//CN5jzlool8wFkrQYlmDBykpqm4AeeniywBZslvPZZuu94LiwY3iEdCxO3s2nJVa6W4dRbsHrgYoDrzyYdXEClWlKa62MN7iOxmmzMA8W6ofGSaopXwTUWDMGp8FqPIG1qxcBlYEo5FvXOIFIkLFzS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346997; c=relaxed/simple;
	bh=9fGUalqeo9A4kZ4jLMUv705C7qGr3Xf+zWTeOGKvRK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDwG3AhJY44Ai5/+LFl98QL2iXUlrFx87S8Ok9asbsPMDZlOmiwz4BevM8/kIH6nnPDoUNmbc9chtBaLcPnFfXS3FxAxtGM4ib5EXZTowYZ/SIXAuxBZyC24o6Pui2+Y/28Yq2X25hn/e8kvWC0OIHOkipIVu3UaXyWv7ftnrv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASx/vObs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASx/vObs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE15C4CEF7;
	Thu, 12 Mar 2026 20:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346996;
	bh=9fGUalqeo9A4kZ4jLMUv705C7qGr3Xf+zWTeOGKvRK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASx/vObslOqLlb/SuGy1OXdBrWg+u0g08vHZ7KyhVUtu7vBd92PuBLlKH4nO4j9U8
	 CFJn5ngJIX6F4HihllIDXU2Y8QLx+zIq/Exxcl8IhblDqkrctrhh7j5yhcLRoT9TT+
	 7E0LZcQrdiP39jBT3e9OMZV2l1aOabfCKC4Hm12c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Howard <blhoward2@gmail.com>,
	Kris Fredrick <linux.baguette800@slmail.me>,
	Andrei Shumailov <gentoo1993@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/265] HID: multitouch: add quirks for Lenovo Yoga Book 9i
Date: Thu, 12 Mar 2026 21:09:23 +0100
Message-ID: <20260312201024.661770594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Brian Howard <blhoward2@gmail.com>

[ Upstream commit 822bc5b3744b0b2c2c9678aa1d80b2cf04fdfabf ]

The Lenovo Yoga Book 9i is a dual-screen laptop, with a single composite
USB device providing both touch and tablet interfaces for both screens.
All inputs report through a single device, differentiated solely by report
numbers. As there is no way for udev to differentiate the inputs based on
USB vendor/product ID or interface numbers, custom naming is required to
match against for downstream configuration. A firmware bug also results
in an erroneous InRange message report being received after the stylus
leaves proximity, blocking later touch events. Add required quirks for
Gen 8 to Gen 10 models, including a new quirk providing for custom input
device naming and dropping erroneous InRange reports.

Signed-off-by: Brian Howard <blhoward2@gmail.com>
Tested-by: Brian Howard <blhoward2@gmail.com>
Tested-by: Kris Fredrick <linux.baguette800@slmail.me>
Reported-by: Andrei Shumailov <gentoo1993@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220386
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: a2e70a89fa58 ("HID: multitouch: new class MT_CLS_EGALAX_P80H84")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        |  1 +
 drivers/hid/hid-multitouch.c | 72 ++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index dfa39a37405e3..0a65490dfcb43 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -832,6 +832,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
 #define USB_DEVICE_ID_LENOVO_X12_TAB2	0x61ae
+#define USB_DEVICE_ID_LENOVO_YOGABOOK9I	0x6161
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5aed9e320d306..15a3d1de1becd 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -73,6 +73,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
 #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
 #define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
+#define MT_QUIRK_YOGABOOK9I		BIT(24)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -217,6 +218,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_RAZER_BLADE_STEALTH		0x0112
 #define MT_CLS_SMART_TECH			0x0113
 #define MT_CLS_APPLE_TOUCHBAR			0x0114
+#define MT_CLS_YOGABOOK9I			0x0115
 #define MT_CLS_SIS				0x0457
 
 #define MT_DEFAULT_MAXCONTACT	10
@@ -413,6 +415,14 @@ static const struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE,
+	},
+		{ .name = MT_CLS_YOGABOOK9I,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_FORCE_MULTI_INPUT |
+			MT_QUIRK_SEPARATE_APP_REPORT |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_YOGABOOK9I,
+		.export_all_inputs = true
 	},
 	{ }
 };
@@ -1514,6 +1524,38 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 	if (rdata && rdata->is_mt_collection)
 		return mt_touch_report(hid, rdata);
 
+	/* Lenovo Yoga Book 9i requires consuming and dropping certain bogus reports */
+	if (rdata && rdata->application &&
+		(rdata->application->quirks & MT_QUIRK_YOGABOOK9I)) {
+
+		bool all_zero_report = true;
+
+		for (int f = 0; f < report->maxfield && all_zero_report; f++) {
+			struct hid_field *fld = report->field[f];
+
+			for (int i = 0; i < fld->report_count; i++) {
+				unsigned int usage = fld->usage[i].hid;
+
+				if (usage == HID_DG_INRANGE ||
+					usage == HID_DG_TIPSWITCH ||
+					usage == HID_DG_BARRELSWITCH ||
+					usage == HID_DG_BARRELSWITCH2 ||
+					usage == HID_DG_CONTACTID ||
+					usage == HID_DG_TILT_X ||
+					usage == HID_DG_TILT_Y) {
+
+					if (fld->value[i] != 0) {
+						all_zero_report = false;
+						break;
+					}
+				}
+			}
+		}
+
+		if (all_zero_report)
+			return;
+	}
+
 	if (field && field->hidinput && field->hidinput->input)
 		input_sync(field->hidinput->input);
 }
@@ -1704,6 +1746,30 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		break;
 	}
 
+	/* Lenovo Yoga Book 9i requires custom naming to allow differentiation in udev */
+	if (hi->report && td->mtclass.quirks & MT_QUIRK_YOGABOOK9I) {
+		switch (hi->report->id) {
+		case 48:
+			suffix = "Touchscreen Top";
+			break;
+		case 56:
+			suffix = "Touchscreen Bottom";
+			break;
+		case 20:
+			suffix = "Stylus Top";
+			break;
+		case 40:
+			suffix = "Stylus Bottom";
+			break;
+		case 80:
+			suffix = "Emulated Touchpad";
+			break;
+		default:
+			suffix = "";
+			break;
+		}
+	}
+
 	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
@@ -2186,6 +2252,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X12_TAB2) },
 
+	/* Lenovo Yoga Book 9i */
+	{ .driver_data = MT_CLS_YOGABOOK9I,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_YOGABOOK9I) },
+
 	/* Logitech devices */
 	{ .driver_data = MT_CLS_NSMU,
 		HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH_WIN_8,
-- 
2.51.0



