Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0449F1A3178;
	Thu, 17 Apr 2025 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914016; cv=none; b=MZZ9DqnZpmjdLbgga/HxPDKBJjumXVQt4XI4kUSsKDSyakKFHF2P3TvC+MHgijbnYRjTGWRmCQCr2JG7AXCcnmqnZol9EaAR6/+1WteLvvc0pIURDiSNCPKQ0uFFHDBbAUDDN6JkWemAYwTqzHbyDHfH/nvLKjD84fvm9RZ0QWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914016; c=relaxed/simple;
	bh=RWVfGPqwDgwYkQU4z0SoDl92h3LM8bj0rxLjXMUN0yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHaQkTBLmTA8ImQPneXFHnjGWYqDMdVeizy9vC7NYL0a0UsJce8mLl95OyBLYoDT26PF3JrbbBRUEMPOCKCXAMdSvdtc3+Bx9snZqdIKTNU8vbQQQ3IEepIThg/Zcg3bcwyHFr7ZutJyxT6mqckPwn/PVxH/d8yVK2HhAKF5RLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU0XzhxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU0XzhxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887C0C4CEE4;
	Thu, 17 Apr 2025 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914015;
	bh=RWVfGPqwDgwYkQU4z0SoDl92h3LM8bj0rxLjXMUN0yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU0XzhxZV4IMddJFbK4xdYeYrRcSkXRczvb508MLyd35lgdTGrH4c7f8VVqgZr8S1
	 bfB3AnmIOCD0HAcX3r2+JE0lnaF6xwfJjR1CD1MKM59FZFgZOg/vCzQDJrEx5pzbzd
	 FRKFxhoaS1orZBymkZtpLCygLxPyNA58wCgwthTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 076/414] media: uvcvideo: Add quirk for Actions UVC05
Date: Thu, 17 Apr 2025 19:47:14 +0200
Message-ID: <20250417175114.502430292@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 8c54e58f94ed3ff28643aefd2c0c2c98313ee770 ]

Actions UVC05 is a HDMI to USB dongle that implements the UVC protocol.

When the device suspends, its firmware seems to enter a weird mode when it
does not produce more frames.

Add the device to the quirk list to disable autosuspend.

Bus 001 Device 007: ID 1de1:f105 Actions Microelectronics Co. Display
 capture-UVC05
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 [unknown]
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1de1 Actions Microelectronics Co.
  idProduct          0xf105 Display capture-UVC05
  bcdDevice            4.09
  iManufacturer           1 Actions Micro
  iProduct                2 Display capture-UVC05
  iSerial                 3 -1005308387
  bNumConfigurations      1

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20241210-uvc-hdmi-suspend-v1-1-01f5dec023ea@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 011a14506ea0b..396a04542c045 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3030,6 +3030,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
 					| UVC_QUIRK_IGNORE_SELECTOR_UNIT) },
+	/* Actions Microelectronics Co. Display capture-UVC05 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x1de1,
+	  .idProduct		= 0xf105,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_DISABLE_AUTOSUSPEND) },
 	/* NXP Semiconductors IR VIDEO */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.39.5



