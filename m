Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729811AB51B;
	Mon, 14 Oct 2024 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920049; cv=none; b=LPdiEHanuAsprnn8mrrh0zBHae58lbXJGqEvBTdABex7oP9O1Ps2HLydGc3eyW4N2ucteKr7uvUIWV3zwrewDQQv0WktSswOPqx5SwI2OvbZAA/qfuuggzWe+MYfd7GlWWBDqUREvnnejRE/Y3LZCwNo7bwFy8kddTpvBLwIPtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920049; c=relaxed/simple;
	bh=pF4r/P5pLWXM/bepUwMaqQYB9h9NluTq626LWp0aKw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjZ8Fz87C3IkgErzkVs0akeuwgXawjmQJDJkRz96H+tZIurBP8LCItHF0CL0gTES4NveF+zFxas3t9z91oOtX3QaHF60hiNtY873UrQqDzglE08y0QAh6LOImCDHcYP7xWy807R9N7heo38Rw9JoPy8y0fD0zADpzbs0aTmQzNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIheH9Ln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIheH9Ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D532CC4CEC3;
	Mon, 14 Oct 2024 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920049;
	bh=pF4r/P5pLWXM/bepUwMaqQYB9h9NluTq626LWp0aKw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIheH9LniKlWJgyjNKI90YHhVJ4DBY1RFgrP0AxkaAs3SXD7ZUzOPWEKb3ub4/rNS
	 2ggRPye/Kvk39/QG+SfEY/kINf7AfTIPHZVWvmSCcbpmf+fbWoocImmQ+lNj4a76p6
	 mQk493irlUEix90IOBAWxuC7ypwGvrl937AK5wY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 766/798] HID: multitouch: Add support for lenovo Y9000P Touchpad
Date: Mon, 14 Oct 2024 16:22:00 +0200
Message-ID: <20241014141248.161623357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Lugang <helugang@uniontech.com>

[ Upstream commit 251efae73bd46b097deec4f9986d926813aed744 ]

The 2024 Lenovo Y9000P which use GT7868Q chip also needs a fixup.
The information of the chip is as follows:
I2C HID v1.00 Mouse [GXTP5100:00 27C6:01E0]

Signed-off-by: He Lugang <helugang@uniontech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ede3a052ead55..5f98c33ed67ba 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -506,6 +506,7 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E0	0x01e0
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6d76463f5896f..e7199ae2e3d91 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1447,7 +1447,8 @@ static __u8 *mt_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 {
 	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
 	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
-	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
+	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9 ||
+		 hdev->product == I2C_DEVICE_ID_GOODIX_01E0)) {
 		if (rdesc[607] == 0x15) {
 			rdesc[607] = 0x25;
 			dev_info(
@@ -2068,7 +2069,10 @@ static const struct hid_device_id mt_devices[] = {
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E8) },
+		     I2C_DEVICE_ID_GOODIX_01E9) },
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
+		     I2C_DEVICE_ID_GOODIX_01E0) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
-- 
2.43.0



