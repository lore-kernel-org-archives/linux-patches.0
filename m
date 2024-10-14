Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9DB481B3;
	Mon, 14 Oct 2024 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917303; cv=none; b=pAa+BHr8mgetmYMDs45PFucznUqSLwf/BgA1TZQmYzJ06SY4jY/M8yAGtbtxUlEGEEsW+0Ew5sO3yZdPRrMmf19WfsgIEIPdvkS751+t+Egm9VaCLFVMdkqETDgc/tBp/QOSk+WOPOMzii61xYbZC6ri/CRqb00uS+Br0gFQudw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917303; c=relaxed/simple;
	bh=t672hWjjwfLSIvSldNplw6xnVxqlBYZfpy+wsv0BDIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIUBX3/6x2my9i2+zps1DuP5KgOnbugr849xBsSm5syqhnGEywZ0/urxwDlnlqdfBaqYHlu5J2aroOn5090YrG1ZsoQnz9q+vLLnpqKJ2eR2s80rByEoRMldG/ErppnoQjH3WBrquuaP4Dih76DaoS2c0neb+3Ve5eA2u2Lodds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DG0NF7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DG0NF7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730B0C4CEC3;
	Mon, 14 Oct 2024 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917302;
	bh=t672hWjjwfLSIvSldNplw6xnVxqlBYZfpy+wsv0BDIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DG0NF7EyIrRSIvdpXNVhQs/Tl9rtxcsIF2loCg3wsFmkGiJj9K3yns1FbFlf9HID
	 nyJzMTaH1TaO1VS6ntyYQIuN3k6efjmEqAjCF3abHEdlPfeH4/PqiIMy6w9iDjuUWP
	 EIk6c5xvashnTRNsx1VYQLRTleArIjy+eRX0iCvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 180/213] HID: multitouch: Add support for lenovo Y9000P Touchpad
Date: Mon, 14 Oct 2024 16:21:26 +0200
Message-ID: <20241014141049.991924776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: He Lugang <helugang@uniontech.com>

commit 251efae73bd46b097deec4f9986d926813aed744 upstream.

The 2024 Lenovo Y9000P which use GT7868Q chip also needs a fixup.
The information of the chip is as follows:
I2C HID v1.00 Mouse [GXTP5100:00 27C6:01E0]

Signed-off-by: He Lugang <helugang@uniontech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -505,6 +505,7 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
+#define I2C_DEVICE_ID_GOODIX_01E0	0x01e0
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1447,7 +1447,8 @@ static __u8 *mt_report_fixup(struct hid_
 {
 	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
 	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
-	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
+	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9 ||
+		 hdev->product == I2C_DEVICE_ID_GOODIX_01E0)) {
 		if (rdesc[607] == 0x15) {
 			rdesc[607] = 0x25;
 			dev_info(
@@ -2068,7 +2069,10 @@ static const struct hid_device_id mt_dev
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


