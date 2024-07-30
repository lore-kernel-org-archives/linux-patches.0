Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC681A6192;
	Tue, 30 Jul 2024 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357130; cv=none; b=bfVyVsSpdWsaJjVcrNB5zoCFiKe707lC7Bz0wB8Uq9ZhEaG0nAlsCthEabrkaOUc3hFUxt1/BMhj3d9f3zRjCNYZBloC/jDgj3V+GCVqGuidxkNYtrHMdYhLCCYd5PGNNu9DM6J4IsoiNIBV8TPZ8HfYQJEakLiZOAXE4b5xwIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357130; c=relaxed/simple;
	bh=GlpTgxn5oeO6vFPcU+SsU7b7Z4dKFYUbVLUCBdT2z48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ixi6TBlGvdXCmL4AaT3YoGhjVWudTOJTN8goKtNc9j4S8tmCVv+c0IpvcwuVxjGy7T46tq4Ij/FjPOZRd63dlieYSTKLs/eWTwseDobfprCte6p4RiqKOJR1QnuFT8PPdYz2OP7tZ8JMAVKC4rh8KpXdfSkHgpMeCnrTJjSINR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/AABomL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/AABomL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6040DC32782;
	Tue, 30 Jul 2024 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357129;
	bh=GlpTgxn5oeO6vFPcU+SsU7b7Z4dKFYUbVLUCBdT2z48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/AABomLC9edNorO+v5KkH5sIv1O9npAC3pfDFXITl8vT3KwzNEI3w9ZIQiUTIguw
	 ANDdfUg7Ra509TID3uowfEqJ6dPLP1elILtQt7TpmioDQMdW/auaD8NcheQm9GLScP
	 emqqjqPSY32c3x1Y8ME8IdA3HBnsBx6foFttvx38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/568] media: uvcvideo: Disable autosuspend for Insta360 Link
Date: Tue, 30 Jul 2024 17:45:09 +0200
Message-ID: <20240730151647.772076869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 3de6df64f92d8633eb51a5e957ffc43ebdb2156e ]

When the device suspends, it keeps power-cycling.

The user notices it because the LED constanct oscillate between
blue (ready) and no LED (off).

<6>[95202.128542] usb 3-3-port4: attempt power cycle
<6>[95206.070120] usb 3-3.4: new high-speed USB device number 49 using xhci_hcd
<6>[95206.212027] usb 3-3.4: New USB device found, idVendor=2e1a, idProduct=4c01, bcdDevice= 2.00
<6>[95206.212044] usb 3-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=<Serial: 1>
<6>[95206.212050] usb 3-3.4: Product: Insta360 Link
<6>[95206.212075] usb 3-3.4: Manufacturer: Amba
<7>[95206.214862] usb 3-3.4: GPIO lookup for consumer privacy
<7>[95206.214866] usb 3-3.4: using lookup tables for GPIO lookup
<7>[95206.214869] usb 3-3.4: No GPIO consumer privacy found
<6>[95206.214871] usb 3-3.4: Found UVC 1.10 device Insta360 Link (2e1a:4c01)
<3>[95206.217113] usb 3-3.4: Failed to query (GET_INFO) UVC control 14 on unit 1: -32 (exp. 1).
<3>[95206.217733] usb 3-3.4: Failed to query (GET_INFO) UVC control 16 on unit 1: -32 (exp. 1).
<4>[95206.223544] usb 3-3.4: Warning! Unlikely big volume range (=32767), cval->res is probably wrong.
<4>[95206.223554] usb 3-3.4: [9] FU [Mic Capture Volume] ch = 1, val = -32768/-1/1
<6>[95210.698990] usb 3-3.4: USB disconnect, device number 49
<6>[95211.963090] usb 3-3.4: new high-speed USB device number 50 using xhci_hcd
<6>[95212.657061] usb 3-3.4: new full-speed USB device number 51 using xhci_hcd
<3>[95212.783119] usb 3-3.4: device descriptor read/64, error -32
<3>[95213.015076] usb 3-3.4: device descriptor read/64, error -32
<6>[95213.120358] usb 3-3-port4: attempt power cycle

Bus 001 Device 009: ID 2e1a:4c01 Amba Insta360 Link
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x2e1a
  idProduct          0x4c01
  bcdDevice            2.00
  iManufacturer           1 Amba
  iProduct                2 Insta360 Link
  iSerial                 0
  bNumConfigurations      1

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20221101-instal-v1-0-d13d1331c4b5@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Stable-dep-of: 85fbe91a7c92 ("media: uvcvideo: Add quirk for invalid dev_sof in Logitech C920")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 91a41aa3ced24..69602f2ed51d8 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2236,8 +2236,11 @@ static int uvc_probe(struct usb_interface *intf,
 	if (dev->quirks & UVC_QUIRK_NO_RESET_RESUME)
 		udev->quirks &= ~USB_QUIRK_RESET_RESUME;
 
+	if (!(dev->quirks & UVC_QUIRK_DISABLE_AUTOSUSPEND))
+		usb_enable_autosuspend(udev);
+
 	uvc_dbg(dev, PROBE, "UVC device initialized\n");
-	usb_enable_autosuspend(udev);
+
 	return 0;
 
 error:
@@ -3043,6 +3046,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
 	  .driver_info		= (kernel_ulong_t)&uvc_ctrl_power_line_uvc11 },
+	/* Insta360 Link */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x2e1a,
+	  .idProduct		= 0x4c01,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_DISABLE_AUTOSUSPEND) },
 	/* Lenovo Integrated Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 88218693f6f0b..3653b2c8a86cb 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -74,6 +74,7 @@
 #define UVC_QUIRK_FORCE_BPP		0x00001000
 #define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
 #define UVC_QUIRK_NO_RESET_RESUME	0x00004000
+#define UVC_QUIRK_DISABLE_AUTOSUSPEND	0x00008000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.43.0



