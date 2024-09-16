Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA2415A85A;
	Mon, 16 Sep 2024 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488176; cv=none; b=J8oEThdbHmB5uxZeiC7Z4diefUhDjokTTOob0oTWOwwgZy70FBAxb1lturE+E2smceqQlI+JVsvEhiqRTeMCD8FHhb/cVHslg1PmLlxbEHJI6H2eYSo5sbO1DD34Oix9tjDfVPKDecgbFPudB/yxfa/yg5bW36+GyHwbOv+T1eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488176; c=relaxed/simple;
	bh=4b0weoTfbI20oeB+v1XhrUULqdN2BHVZwiswgXNlJLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF6zC4DwLINwA3LMFGJx4pipQ2A+RpY7hkP+XEi82xVxB0Gofla6zsg/njMXuQzkAsfBMq+o5HWW6JR8W28ONwxaPtYsItCCLeP9enMTTx7nq0k9NaYrA8bCQ4NBjSnIuxxoJlN0/iL0MYAHbOLcpdAacCIyUFGUD0U/uwtUyb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wm+er/H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wm+er/H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C347AC4CEC4;
	Mon, 16 Sep 2024 12:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488176;
	bh=4b0weoTfbI20oeB+v1XhrUULqdN2BHVZwiswgXNlJLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wm+er/H8GJ13671HHeJAes5l/V8RJKVw1PPJI9Jj1qdrUV/WEhA8gehFOVfS8HBLh
	 lTIoRkVlzTTLGMmI7aNr8FCB//qXmKuPL9x4k+UztzPNe4GYWV11/RrS9z9T04onEX
	 Fmfc9MtIGZqxKnUPeFz9iRj0o0XcG1JrlHl77U74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Savin <envelsavinds@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 022/121] HID: multitouch: Add support for GT7868Q
Date: Mon, 16 Sep 2024 13:43:16 +0200
Message-ID: <20240916114229.713651169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Savin <envelsavinds@gmail.com>

[ Upstream commit c8000deb68365b461b324d68c7ea89d730f0bb85 ]

GT7868Q has incorrect data in the report and needs a fixup.
The change enables haptic touchpad on Lenovo ThinkBook 13x Gen 4
and has been tested on the device.

Signed-off-by: Dmitry Savin <envelsavinds@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        |  2 ++
 drivers/hid/hid-multitouch.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6e3223389080..781c5aa29859 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -521,6 +521,8 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
+#define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
 
 #define USB_VENDOR_ID_GOODTOUCH		0x1aad
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 56fc78841f24..99812c0f830b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1441,6 +1441,30 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	return 0;
 }
 
+static __u8 *mt_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+			     unsigned int *size)
+{
+	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
+	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
+	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
+		if (rdesc[607] == 0x15) {
+			rdesc[607] = 0x25;
+			dev_info(
+				&hdev->dev,
+				"GT7868Q report descriptor fixup is applied.\n");
+		} else {
+			dev_info(
+				&hdev->dev,
+				"The byte is not expected for fixing the report descriptor. \
+It's possible that the touchpad firmware is not suitable for applying the fix. \
+got: %x\n",
+				rdesc[607]);
+		}
+	}
+
+	return rdesc;
+}
+
 static void mt_report(struct hid_device *hid, struct hid_report *report)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
@@ -2035,6 +2059,14 @@ static const struct hid_device_id mt_devices[] = {
 		MT_BT_DEVICE(USB_VENDOR_ID_FRUCTEL,
 			USB_DEVICE_ID_GAMETEL_MT_MODE) },
 
+	/* Goodix GT7868Q devices */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
+		     I2C_DEVICE_ID_GOODIX_01E8) },
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
+		     I2C_DEVICE_ID_GOODIX_01E8) },
+
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
@@ -2270,6 +2302,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.report_fixup = mt_report_fixup,
 	.report = mt_report,
 	.suspend = pm_ptr(mt_suspend),
 	.reset_resume = pm_ptr(mt_reset_resume),
-- 
2.43.0



