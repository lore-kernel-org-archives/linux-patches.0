Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F1C1B87F8;
	Thu, 30 Jan 2025 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247426; cv=none; b=YyYtwrQKDkRSHViQp2eQ7VcYDFoJglLKtbO7MVpnv+ninZbbiQ0JwBITIIa8ABziDuIocQwWFgROAeyLqoaHMYdKSp3FpeKJLoaQB8UPCm4g0KjoDsykQQaldrNCJPmQ+6/9Y80d2xLmNXfkZpbdmqMJ/bKGV2erULmcOMtFVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247426; c=relaxed/simple;
	bh=J/jduN65z9m0d8BpYrQnHCKx9DO3y5LbmFzBSgR6I2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bewudRAt9CH99QuVPOUV7GXlsaua/46+XSfAoKUuZJ8g3rA7i0LdmjlQQVmC04Ge4Y5PAB1jZKiFzXINordjSCnecD9TN/H/1qguKl5tGLBK7X5kUwptCVd6RrjgoXwL12yaOYSwgZ30lFJoPTceWDJ7uLLGz1abKF5zcqCn2Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkiMx5Ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkiMx5Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FED8C4CED2;
	Thu, 30 Jan 2025 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247426;
	bh=J/jduN65z9m0d8BpYrQnHCKx9DO3y5LbmFzBSgR6I2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkiMx5Wwqd3brmvGpyptZyhi2e7bP5pw28NDDQVR3iJnfs1qWs3pQCAeeVQgPObVO
	 yMx7UthGWNfTfky3PsjtB7scXlMQK8vXiUGt22JKzDoyIllqFlfPheHIHFbyKRAlDk
	 sUdkYAPJvBYQB8UFQFkOlnVe79F5HdIpn1by6KT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	WangYuli <wangyuli@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 35/49] Revert "HID: multitouch: Add support for lenovo Y9000P Touchpad"
Date: Thu, 30 Jan 2025 15:02:11 +0100
Message-ID: <20250130140135.243602274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

commit 3d88ba86ba6f35a0467f25a88c38aa5639190d04 upstream.

This reverts commit 251efae73bd46b097deec4f9986d926813aed744.

Quoting Wang Yuli:

	"The 27C6:01E0 touchpad doesn't require the workaround and applying it
	would actually break functionality.

	The initial report came from a BBS forum, but we suspect the
	information provided by the forum user may be incorrect which could
	happen sometimes. [1]

	Further investigation showed that the Lenovo Y9000P 2024 doesn't even
	use a Goodix touchpad. [2]

	For the broader issue of 27c6:01e0 being unusable on some devices, it
	just need to address it with a libinput quirk.

	In conclusion, we should revert this commit, which is the best
	solution."

Reported-by: Ulrich Müller <ulm@gentoo.org>
Reported-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/all/uikt4wwpw@gentoo.org/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h        |    1 -
 drivers/hid/hid-multitouch.c |    8 ++------
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -507,7 +507,6 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
-#define I2C_DEVICE_ID_GOODIX_01E0	0x01e0
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1447,8 +1447,7 @@ static __u8 *mt_report_fixup(struct hid_
 {
 	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
 	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
-	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9 ||
-		 hdev->product == I2C_DEVICE_ID_GOODIX_01E0)) {
+	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
 		if (rdesc[607] == 0x15) {
 			rdesc[607] = 0x25;
 			dev_info(
@@ -2073,10 +2072,7 @@ static const struct hid_device_id mt_dev
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E9) },
-	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
-	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E0) },
+		     I2C_DEVICE_ID_GOODIX_01E8) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,


