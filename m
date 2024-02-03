Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7E011193;
	Sat,  3 Feb 2024 04:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933857; cv=none; b=XOeaDJMI/YhxhZM3bdgJLkStIxlu2pYXpE0YgcPLe79HBG2+OqZYbKxDlkzGNj4hhUlBYwVeQHhn4YFcVfro83iZ751jrUxzWw7whQQtlo/mGwzuiVgn7LCNuPOHvyZYGtMrNLpdckEFfVQ4eyU40amLTORrV+vB85MJEWFO7Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933857; c=relaxed/simple;
	bh=FyWIx9tucYpufzDGqSnqMh6fIjubbbu+MquI1Zxrz2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jm6qxt/IYYiSfj19zx3j0CtTDOHvbXlx2hJD5tcVZ4Xt04bO3GBZSqb+VuhKpcyXiveGPdP0T69KdJ5StkOuZAKb2v9E+6IQp+NO3PsNOyynPxYUAe7i8NkorbYkDBi/IN1JPzawDUSqDR7O/6WUFbqC4NI7s1yXqDCqaVP3VPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4PIS/pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4PIS/pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B8BC433F1;
	Sat,  3 Feb 2024 04:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933857;
	bh=FyWIx9tucYpufzDGqSnqMh6fIjubbbu+MquI1Zxrz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4PIS/pd8QXswwMIny3SOzwbnD039E+3WaiFmCQ4csUkC+obEak9dRWpCmcIzV+BT
	 zd+PG7PUAVd8vvgWzn747p+Qe6ZIv1z4KLMHTxFM38/tsX5eSbHJDHLpm7NHalWbcY
	 phiT/lpD91u9leorGUN/EsvjZCvmZZcQJOqDghFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@chromium.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 189/353] media: uvcvideo: Fix power line control for SunplusIT camera
Date: Fri,  2 Feb 2024 20:05:07 -0800
Message-ID: <20240203035409.647745222@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 6180056b0e0c097dad5d1569dcd661eaf509ea43 ]

The device does not implement the power line frequency control
correctly. It is a UVC 1.5 device, but implements the control as a UVC
1.1 device.

Add the corresponding control mapping override.

Bus 003 Device 002: ID 2b7e:b752 SunplusIT Inc HD Camera
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.01
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x2b7e
  idProduct          0xb752
  bcdDevice            0.04
  iManufacturer           1 SunplusIT Inc
  iProduct                2 HD Camera
  iSerial                 3 01.00.00
  bNumConfigurations      1

Cc: Yunke Cao <yunkec@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4b5ea3501753..bbd90123a4e7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3003,6 +3003,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_FORCE_BPP) },
+	/* SunplusIT Inc HD Camera */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x2b7e,
+	  .idProduct		= 0xb752,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
+	  .driver_info		= (kernel_ulong_t)&uvc_ctrl_power_line_uvc11 },
 	/* Lenovo Integrated Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.43.0



