Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B522333D;
	Thu, 17 Apr 2025 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915276; cv=none; b=iZ4S/gy1yQl84grH1z4SFqvPqsHQ60PJQ4T7PSdCD1LQ0SNak5BNUL5fiITgukSpr4vDSUhwEWhnI/ASwZejjwYyj8p5i4B3bvrC6LUaGX+GeJ7P8SQTpAX58ze2IGEKG+ih7MWbCXVRPYX+kHU5ufW/qgB+jB+L2nD3V7RjxTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915276; c=relaxed/simple;
	bh=UwAc3DHzhNJV0nyIZ0pfAtSAkIdTaYaunr+d7Baneao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iERDez1sZzZkIhQW39QctjLXPywsCofQQz3/2/e8gl54JNA7UMZ/ggzbOOX7SyRHo9dw8YVb755IlsTzNDp8FCmb9k+ZYImM5k7QLTMe8q8mLNAF6eOphFyCJITx0GUcO/BGZtR3ifI1kJdCEIHcY2bTYqWOpwYYk2wAKf799PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGL2BDi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGL2BDi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803EBC4CEE4;
	Thu, 17 Apr 2025 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915275;
	bh=UwAc3DHzhNJV0nyIZ0pfAtSAkIdTaYaunr+d7Baneao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGL2BDi98mF66LPj+dPTyEbzaWOJimGFNyGknGMwY15/WEl7qupyrL3rARE8tk/+M
	 4YSwt6AyPY9Nqn4B627Ef/gIuP5HobXYrdLTniE4MS6vuVywg4BhVPmjRNzDwpoGTU
	 qdy6CXNqoAYPO85Yrgyd4p3COPW8Aie8eFqwr0H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/393] media: uvcvideo: Add quirk for Actions UVC05
Date: Thu, 17 Apr 2025 19:48:04 +0200
Message-ID: <20250417175110.610862942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4d8e00b425f44..a0d683d266471 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3039,6 +3039,15 @@ static const struct usb_device_id uvc_ids[] = {
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



