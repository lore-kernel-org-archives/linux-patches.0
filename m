Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76DD321433;
	Mon, 18 Aug 2025 13:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524145; cv=none; b=bGbNe/oRucTMkGuf8ryGIXa7Vm1Vx4jwkHiFogdjTcyZ+xLQ8ni8/j15rHSlenWm8c5YAta8F9QBzdgfSQGs/K1UpQUaaE9JCKa3/NT2xudZMhx3Qpx8r9xxfzZAHf8tNEKX9xXAU1JVq57kDjt0P19HyHh5SfpfQHR/g7hQFyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524145; c=relaxed/simple;
	bh=TaAA5av1yr+FA/lXNHqpps5Fx9xbVkJHasrkt0AoFpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ukwa9naoY7md8VZYN7b0keDH9zc0xkkq6OiGNSZv5CiRAJhPqcXOBPuuaTC5q6OPfmXjjoEmFxfAu3oVmVQ9IgJFqdvedrsxVfbALULp63ETlIDQzlt8sN0nKlLuQxGA5JTf4gFNCN5DDgiX20LCPWOJGchQQPDwJiq+W0Pci/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o3cEXPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o3cEXPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE3AC4CEEB;
	Mon, 18 Aug 2025 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524145;
	bh=TaAA5av1yr+FA/lXNHqpps5Fx9xbVkJHasrkt0AoFpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o3cEXPC9LiEotIoXRGx3phnWD0J0rqgSiqy+YU5BDYGt4U3Lq6NqutN5Tv5xj6FZ
	 Ch818pfnXIEYAYVWFDdSfBT5UcsM/wtMM6lB1+yRU/eIejqIf4Cdhz6PlnbwNqJ+np
	 03IfEp4BnWeFh8sMwd7RLnN5JRBg4d79rmUIyzlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C3=ABl=20Melchiore?= <rohel01@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 381/515] media: uvcvideo: Add quirk for HP Webcam HD 2300
Date: Mon, 18 Aug 2025 14:46:07 +0200
Message-ID: <20250818124513.086681510@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 53b0b80e5240fec7c5a420bffb310edc83faf4fd ]

HP Webcam HD 2300 does not seem to flip the FID bit according to spec.

Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 [unknown]
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x03f0 HP, Inc
  idProduct          0xe207 HP Webcam HD 2300
  bcdDevice           10.20
  iManufacturer           3 Hewlett Packard
  iProduct                1 HP Webcam HD 2300
  iSerial                 0
  bNumConfigurations      1

Reported-by: Michaël Melchiore <rohel01@gmail.com>
Closes: https://lore.kernel.org/linux-media/CA+q66aRvTigH15cUyfvzPJ2mfsDFMt=CjuYNwvAZb29w8b1KDA@mail.gmail.com
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20250602-uvc-hp-quirk-v1-1-7047d94d679f@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 25e9aea81196..2f0865c1e6e7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2511,6 +2511,15 @@ static const struct uvc_device_info uvc_quirk_force_y8 = {
  * Sort these by vendor/product ID.
  */
 static const struct usb_device_id uvc_ids[] = {
+	/* HP Webcam HD 2300 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x03f0,
+	  .idProduct		= 0xe207,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= (kernel_ulong_t)&uvc_quirk_stream_no_fid },
 	/* Quanta ACER HD User Facing */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.39.5



