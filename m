Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059259;
	b=WH5dn7Pt3tzfG/bW6TQlM56tXGI83T8gwgWVVSp4UAahphHPij7UTw90WBT/yJDhtEuN
	 tPQLN6ZMBoN7nbesUO+RvmaV2zccrxtuECtWqb/U07ZMR8mhoMj10PNLikafytlRe8atR
	 /J/ilDVCOrz86V7wj1HGY5Caw0w0NcANxPzFxIg6Txn63bBAwi9wzNW47SU+HvAoG3qMX
	 WQK1ElufUJeeish2g7aYsao1TUH1JUuz4X6B+SSBKLCKn17eW61CgCcBjVhFwaHOup6qk
	 suIJoeUY2Nr7sMV433WqmQRbxa6qbWXZO3CrO6/RDSFIhaiYT3dbcyGKU+cyAC3Izug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tXzeSME9OdardCfLmhZFy7JBaG+7JL1hxjhBw/ephd4=;
	b=RgaAI6DcsDrWOk09H1KonQWJdDK8cuCoybf/oNLMVJaO97OGy3WlDfwoM10sgKTEit8z
	 hXsuxwXlTmRU5vGjhmcmeKlg19dyybwjOZIr25yrXCw7OFlWInaqIz9xYXzb/VBmzIEl/
	 IrdkVfWtcMbtsBb+drNySTCIa1TcXPYE4wdqnJI+F6zKh/qJbPHOnp2ZNyM8uTPvAhsYu
	 bu1B0ixlgbD5B5BJvtowgSnwe4fHFuwTF3CX9XkBIwr31CaQyv0SjposuhbAZ6LBer3LK
	 J+FqdGiW8UgHxPtCfK/ptwPUMJP53e3+hqWjnQ9sFY7nP6jMNSlposjBEZxIyTwlfcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vj59BHoM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB74606A31C;
	Thu, 19 Nov 2026 03:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vj59BHoM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FD81F000C4;
	Thu, 19 Nov 2026 03:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059258;
	bh=tXzeSME9OdardCfLmhZFy7JBaG+7JL1hxjhBw/ephd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vj59BHoMkrJs0jQSh1mXglECssjwl5NlIlATLsPT9ooWePtYtECmce2gt0a0WmYbF
	 wHXIcsboAZ3O1lXW6GryJbBGlOU49eD8ppce0h1k7dbkPLGB1Rru08hhHxQ2CaT7Ia
	 BJr+Gyp+bLAHjvxNLkrxdoi/7Sndaq0BRhFUBTdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0778/1848] media: uvcvideo: Disable autosuspend for Insta360 Link
Date: Wed, 18 Nov 2026 15:46:56 +0100
Message-ID: <20261118145949.051142494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c2adc6854c540..e2dab556ec996 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2373,8 +2373,11 @@ static int uvc_probe(struct usb_interface *intf,
 			"supported.\n", ret);
 	}
 
+	if (!(dev->quirks & UVC_QUIRK_DISABLE_AUTOSUSPEND))
+		usb_enable_autosuspend(udev);
+
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
-	usb_enable_autosuspend(udev);
+
 	return 0;
 
 error:
@@ -3057,6 +3060,15 @@ static const struct usb_device_id uvc_ids[] = {
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



