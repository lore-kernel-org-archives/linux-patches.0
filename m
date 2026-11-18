Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053512;
	b=WPfASCfRcUWv9w0H92U+knxbWkN+APzap2ytoN/3hx9Bw4j7oH6i4vdACW5yqT2Jelmc
	 HPyFMlp9gQKPB4x6Uif8yx4yUlxMdQUvOkPxB9UIaqLJri2hYlM7E9fatIjf+jFMBQ3nR
	 F9jeD3kwvRV8ZE4gog7hqT+7FaElHEzf+QRL/Awkp3AONdn9MLhddKvdqTi1bamnG9wt6
	 KpzHV9seVGWpFNm3QEcXqKmQVFj7FMhk3IJLg1bX+7jq4RjLi+zokEcxuqZzwfVIIFMEb
	 QHTe3IOXcDzHjmwm8epTcYdPrXRO0Q5zWpnQXt0oDoyhgMUk6/3b7PwPJYQsDSXxxVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6doXJL+zgFInT56Ia7A40sNe3IlDa2FhpEXACdF4is0=;
	b=ueUHPC6RECcI74od/QFGLhzdOJlirDcQiDbBAFHPBt6b9+xb4ayY6ONPr++ets1zJ++F
	 QTo4lyG/VlJPbBmxppeMkXG4CNp66Lh20AOH885gXJ8mFk0bAefFshWnfo33yemmrlUAw
	 OVpevCvWcOLzfOo6zfYanqUXPZ4XLRMBR4BIcrpp8Ygx9ac6kF0/TySCdCGd2zJkVZrqN
	 AprVZkbC1TasTGodxi81mFGfPG9/alCr/2wqoR9YnsRd8MH4+6zJi12H7RKChaYGo/LZ8
	 UInxRjxwWe8edPmg7Wp21Dhx01tMTcvbc48cJQw5aIm0j7lj8CxwKhR9Lwv1A+IjiKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9JvvtbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2FF606A31C;
	Thu, 19 Nov 2026 01:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9JvvtbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C997D1F000C5;
	Thu, 19 Nov 2026 01:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053512;
	bh=6doXJL+zgFInT56Ia7A40sNe3IlDa2FhpEXACdF4is0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9JvvtbQ1YeteMLlEkOcMfkBrwyDtnMQf7rMqRp/vkpxxaiXKs4hu6Twfg3FPrAyX
	 +PUYB7wuHRU8vkUv6qjGcgHu/f5ZEMGVJ2GU1UVI8wjrbMMi42N29jmdrp5vgh0Q6A
	 iH941DLL2ZTRsMfRjv3madzzLjWlqYlfjWXuofFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0947/2214] media: uvcvideo: Disable autosuspend for Insta360 Link
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118150050.223450116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 1cd68501fdc50..f35c8d0ae0da2 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2562,8 +2562,11 @@ static int uvc_probe(struct usb_interface *intf,
 		goto error;
 	}
 
+	if (!(dev->quirks & UVC_QUIRK_DISABLE_AUTOSUSPEND))
+		usb_enable_autosuspend(udev);
+
 	uvc_dbg(dev, PROBE, "UVC device initialized\n");
-	usb_enable_autosuspend(udev);
+
 	return 0;
 
 error:
@@ -3257,6 +3260,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_FORCE_BPP) },
+	/* Insta360 Link */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x2e1a,
+	  .idProduct		= 0x4c01,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_DISABLE_AUTOSUSPEND) },
 	/* Intel RealSense D4M */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.53.0



