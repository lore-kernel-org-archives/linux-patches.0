Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821F1DE8A0;
	Thu, 17 Apr 2025 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912668; cv=none; b=gy7A0anYtLZn1R9x1x6nhWgqyWDZtX7LE/sPAKiHp+EBuHlngiynvSzotZh57czByRGYuPNeze3Os50XJ8E3kUQHlHYvGJREtgSWmKABbKDGFqABJbxSqrL1wqz3WJ2DpvLxS/Od1zSOvTfIY8FNrUAtGqgZ5Yv8aLOUwPBucEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912668; c=relaxed/simple;
	bh=rOCyrwrlq9FmClgInGYLQqzq48Tv3xtEnwRg5tUCKeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJCRjcMrXwEh84GcYR03SyAHLHWu1rGjO+J9Kzd9SWxZmpO2TvZz647vsZyhYq6qnOYG5+YgnH213OBJ3UDs8W9qD0ILi1EqrEkb/9BltUVhW7Fbw198Hu71T0mmXlyboBQrq5BmO0FzmfdyvNy7sho14yBCawom4fhH4pQ6G2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11PJx7Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11PJx7Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DC3C4CEE4;
	Thu, 17 Apr 2025 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912668;
	bh=rOCyrwrlq9FmClgInGYLQqzq48Tv3xtEnwRg5tUCKeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11PJx7Vg+3aPil1SdXDowo2k7K7HZMiXVYAX3blgLOUFW548D7SAywPQR8eowTrBl
	 d+R50Xo+hRf9KghgQrk8iUB8+h9zHDda8zO1OE0OpRaeMB3E9kYvFDXi7pk7c3WZ/4
	 7LTqR5M4Ah5SxQxcJXwjHkmpn5yxOnZuzrB8X7D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 085/449] media: uvcvideo: Add quirk for Actions UVC05
Date: Thu, 17 Apr 2025 19:46:13 +0200
Message-ID: <20250417175121.391609200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index deadbcea5e227..11b04f6f60cd1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3062,6 +3062,15 @@ static const struct usb_device_id uvc_ids[] = {
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



