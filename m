Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D83B22E415;
	Mon, 10 Mar 2025 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628812; cv=none; b=kOFAnvW2LS0veE5q/LtLwX9JmbBmHinTz4D/Ot2BL+RYwwO14ON19dCTd4rWfoEsvp9kJ4n8l/GNoNgEbkZTg3wppYIuTQo6PUYj8dwVFSPtkeNYTlyI/xwwB71qcBKXObAaCSAMVOqDKWPjHp7mkXBknLWT8/gehkwF9X98uGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628812; c=relaxed/simple;
	bh=qna1RHSx7ROGJMMS+v2ZpbeE4cAixl6OfFvBC3WPiqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgBwfO2zyJIUaP0Uqhbxxrj3g+uQYeFpHWxwwDO+Q5iDbUHFOnTud49pvCQ+HxNdxDrYNxSY358B0Mupua5KifA+qe49DtNersJGgHXJYyT8/h33TmYvdAOyBaHg4HWG2wYigz7W/AfJUm1w0YvbDWrDqK3ou2v/s2g8luLAm6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oXpGvwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oXpGvwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033DAC4CEE5;
	Mon, 10 Mar 2025 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628812;
	bh=qna1RHSx7ROGJMMS+v2ZpbeE4cAixl6OfFvBC3WPiqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oXpGvwo3kIEqDvwOOr15KrtaCO2VF1oKvjDhIwRAxSp5FcY9DgBjUByY6bO2uAXE
	 6dK81hYCi5DkGewg7xPA2WTRoTY5ExWRJnxFJCMn9v0/b86MY1KgrQJzj3ZmK1psiZ
	 Jju7wMHGu6CplDCTgSeroqzZeVVRSvqvZclJS3x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	WangYuli <wangyuli@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/620] Revert "HID: multitouch: Add support for lenovo Y9000P Touchpad"
Date: Mon, 10 Mar 2025 17:58:12 +0100
Message-ID: <20250310170547.397314348@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 3d88ba86ba6f35a0467f25a88c38aa5639190d04 ]

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
Stable-dep-of: 8ade5e05bd09 ("HID: multitouch: fix support for Goodix PID 0x01e9")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 -
 drivers/hid/hid-multitouch.c | 8 ++------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 291f8d3a3dd37..81db294dda408 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -484,7 +484,6 @@
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define I2C_VENDOR_ID_GOODIX		0x27c6
-#define I2C_DEVICE_ID_GOODIX_01E0	0x01e0
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 196ed532baa5d..57e4ff1ab275d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1447,8 +1447,7 @@ static __u8 *mt_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 {
 	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
 	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
-	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9 ||
-		 hdev->product == I2C_DEVICE_ID_GOODIX_01E0)) {
+	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
 		if (rdesc[607] == 0x15) {
 			rdesc[607] = 0x25;
 			dev_info(
@@ -2071,10 +2070,7 @@ static const struct hid_device_id mt_devices[] = {
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
-- 
2.39.5



