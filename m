Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D56618FDAB;
	Mon, 10 Mar 2025 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628798; cv=none; b=tNuvDYS4WOt1vKX+lufoZxZjwIWTEkzOGbv/kfS/z7Sfmow3VvPxdtrWU2z/ZmqeGX+N1liZpwrsPnu/jZYYYtBDDFXrzzT74WQMb81gBQQ07j5N5FJBGbwnaUBLxtAtJNvI3ptcSSqRXTr3mckkrGVsqme5PJwX5jLJix1WXUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628798; c=relaxed/simple;
	bh=RO2733Lp7tAMSbcL1K4zizSOM0QfIE5wyhs47YCisUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZo4PxquT4+SrGkg9borqAE7DiPby0AZ7CfcbrMOd2Ee2GiYfXnr+fUHjN/LSN+8YMFACUQfva244q4mD0Sr1oB6FIVClxkuOW0ycwLrHyLfhz+RGdyx5wuhj/1K9pqt7LKoYe0CZf/UNk8sCUsVnsyaif3Hhm97MJbn9sAevuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlYTXvH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlYTXvH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE2DC4CEE5;
	Mon, 10 Mar 2025 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628797;
	bh=RO2733Lp7tAMSbcL1K4zizSOM0QfIE5wyhs47YCisUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlYTXvH/Zlw+GGGCcPpuGmPoWcpFq91//GWbJicDTumNai1IunQmBWgU7PuAR8jIo
	 qdg8RYNsM2otc14g2SHM0mWWIyMgOMhAw9Hw5+JfI7WCf2FqqNDjQcxYRrDXOKukhc
	 KahXiFcy2eq7/cHiWPtX2ingrYNc/jf1A7Mw0/iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/620] HID: multitouch: Add support for lenovo Y9000P Touchpad
Date: Mon, 10 Mar 2025 17:58:11 +0100
Message-ID: <20250310170547.359243518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Lugang <helugang@uniontech.com>

[ Upstream commit 251efae73bd46b097deec4f9986d926813aed744 ]

The 2024 Lenovo Y9000P which use GT7868Q chip also needs a fixup.
The information of the chip is as follows:
I2C HID v1.00 Mouse [GXTP5100:00 27C6:01E0]

Signed-off-by: He Lugang <helugang@uniontech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 8ade5e05bd09 ("HID: multitouch: fix support for Goodix PID 0x01e9")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 81db294dda408..291f8d3a3dd37 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -484,6 +484,7 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E0	0x01e0
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 57e4ff1ab275d..196ed532baa5d 100644
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
@@ -2070,7 +2071,10 @@ static const struct hid_device_id mt_devices[] = {
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
2.39.5



