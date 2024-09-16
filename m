Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42428156F54;
	Mon, 16 Sep 2024 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488536; cv=none; b=R9t91hzpaBlfFIrT/z91r7TJsY3IJRZVW0t4wMH6bYDm0BoFVS+JDjIY9sygjBR23G3OJ7U+soNIzhDcOHISbPPRjFyLukhwS5dnY4UdI9HnJQyCRWTkjS79ZQWI8kJCfU1k2KRiEChEHauI/6Y/M1YsFyYGbeW7fNgd+dTNsL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488536; c=relaxed/simple;
	bh=EIS/BnTIdz6ErpHUD5kXzzMcvDSQJgQyXF2r+/qdS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wekq9nQLSpSDR4pY5Bz2r0H7A7oeSqpAn0TzTeFdgDwpeFY5ns/9Cod0drc2cH3GrELmGkJ+q3jOlCS9WPBe5FC+tjtcgTASP+bgbXzV2zeM524mcMufGfLEj3GkjZuJk59vEnVuXfraZMdJtGi4VkzMhkHDgk1wr8CAlWER1/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLuknb45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLuknb45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C090AC4CEC4;
	Mon, 16 Sep 2024 12:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488536;
	bh=EIS/BnTIdz6ErpHUD5kXzzMcvDSQJgQyXF2r+/qdS9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLuknb455dVDzh38nQpMe3o2MDEnFrbR3NU7xE0b0g4nsc7QpxoXDUL3QwoJ7AJJ3
	 5z+S3tULJDLJDXdTM5RHTXlufWjKMzk3wF1K1/0VGISFZfn4ek8oqUF/2tJspXB7sk
	 JudEujytTzimbY9ENIwQVjmlgch8PcY/FerD++hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Savin <envelsavinds@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/91] HID: multitouch: Add support for GT7868Q
Date: Mon, 16 Sep 2024 13:44:02 +0200
Message-ID: <20240916114225.375352066@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4246348ca16e..a5987fafbedd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -515,6 +515,8 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
+#define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
 
 #define USB_VENDOR_ID_GOODTOUCH		0x1aad
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 17efe6e2a1a4..8ef41d6e71d4 100644
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
@@ -2038,6 +2062,14 @@ static const struct hid_device_id mt_devices[] = {
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
@@ -2273,6 +2305,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.report_fixup = mt_report_fixup,
 	.report = mt_report,
 #ifdef CONFIG_PM
 	.suspend = mt_suspend,
-- 
2.43.0



