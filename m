Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FF81E7640;
	Tue, 15 Oct 2024 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992112; cv=none; b=tSez7I4ev3VkZ/lO9ER9L8bpA0VqPNFpJTV3/iUlW3zTuWfVJk7e4eNppzU+/aHWQg3p3TXvDjWtzTHJwJ/2+Uuum8+NtoC1R2k4jvjr8fP05yXT8cSuxFRxrJJsYQd3Tpow6EIhOOrZbxZqh9qkP9fFu25UPYVFw3E6wneZbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992112; c=relaxed/simple;
	bh=fBfReOmV2hd6DGkQ4S3HYZP3/KX3uU6CuBdSmCqwwjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6Q1LoK0hOYFgAK14ZyAcuyngXfFmxIF6ovr/26YXn4f7xnz1bNS8x6iKgvXLh+1DIxH+WfcjjGq3XlXrs3XpyE1e/Wh8pY/XaRkfC675v4QuaV1A8UBqD48m99pAqctLbgy8n0iFakjQC7ruvaKs25MF1w3QIphxHU1RftNZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XB3rgDOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB3rgDOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CD8C4CED2;
	Tue, 15 Oct 2024 11:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992111;
	bh=fBfReOmV2hd6DGkQ4S3HYZP3/KX3uU6CuBdSmCqwwjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XB3rgDOjpVEv9W+PwWbDKKpA++Ysa1hzJg7IFb5wM7YWpyvq8wIM5fNp0IBvWJY7g
	 zeJ0J/ruL0IhCy/21+5U363r3J3g2w1W1okm7pmhIHx5L4fmVW37/G2AL3cBEkH7HO
	 xwML0RuluYoH/DmlFIy2iEPHEEP5eQ9IN0LhmsSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Savin <envelsavinds@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/691] HID: multitouch: Add support for GT7868Q
Date: Tue, 15 Oct 2024 13:19:30 +0200
Message-ID: <20241015112441.215153723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5988d9c67a30..917207b0deef 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -484,6 +484,8 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
+#define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
 
 #define USB_VENDOR_ID_GOODTOUCH		0x1aad
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fea27d66d91c..36226f43ac5e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1442,6 +1442,30 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
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
@@ -2036,6 +2060,14 @@ static const struct hid_device_id mt_devices[] = {
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
@@ -2271,6 +2303,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.report_fixup = mt_report_fixup,
 	.report = mt_report,
 #ifdef CONFIG_PM
 	.suspend = mt_suspend,
-- 
2.43.0



