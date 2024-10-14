Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0D610B;
	Mon, 14 Oct 2024 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916332; cv=none; b=hdGdmLX7LSaQkR3fmQSWaTeSi1G6bXsHoy06SI1UeKN0KqwHwp4Q5+jR0kmhYuhFXZQWJcFFtARL4dZ8ivwZDtldMB6n/aI+wpDBvIufp3IQ581aKbkVG1V/iFIfGMt/WcJhODm7Haqj93hXickCYSm17jYGKFLgiokXH6lKKpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916332; c=relaxed/simple;
	bh=QpGCqjbp3UtRuU52U4RUneqi5xt+RuPfIEGturMYkis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRklGIrPI6hj23POEkVrF/NX/3rc0eFQQnZTnFqgm/nIj6bpQSWPEv72HMY0vmCA2B80fjOFeEKr5rHV9pfjWsypDI8Ycqn5StoKpiUMUX+TjMXV6om7AoxJXICCy8G/vGsgctiQZpR9W3zzFNLudxNVi8JgxH4EiW7U2367n/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQLVMSkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQLVMSkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AEAC4CEC3;
	Mon, 14 Oct 2024 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916331;
	bh=QpGCqjbp3UtRuU52U4RUneqi5xt+RuPfIEGturMYkis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQLVMSkjGS46r6/VoCWKZSI1S/1ixbFCiqKCzGhodwGPsfLOP+d1ASEKOUZ2O+mxv
	 XzDASdIKwaMGC5YHvVQ3YpsJOmlMqzk+gx2qJzYGWrHtmPhxu0xcbz/O+6xkf/pWgN
	 /ui0MDDEUAxacYcH+D+CagC85/aMPLlDLI6Xx+lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 152/214] HID: multitouch: Add support for lenovo Y9000P Touchpad
Date: Mon, 14 Oct 2024 16:20:15 +0200
Message-ID: <20241014141050.920223686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 06104a4e0fdc1..86820a3d9766d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -505,6 +505,7 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E0	0x01e0
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c4a6908bbe540..847462650549e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1446,7 +1446,8 @@ static __u8 *mt_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 {
 	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
 	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
-	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
+	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9 ||
+		 hdev->product == I2C_DEVICE_ID_GOODIX_01E0)) {
 		if (rdesc[607] == 0x15) {
 			rdesc[607] = 0x25;
 			dev_info(
@@ -2065,7 +2066,10 @@ static const struct hid_device_id mt_devices[] = {
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



