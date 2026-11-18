Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059265;
	b=SZN9XUfn20F1a5ZHUdVTkijOX26v+K7tFpa4USEWAKC3U+UfZ5uHumW2ntm8ncsYJ8Vp
	 77mGgkVpnTP671wirJDrRyyg5O/Bh6uA4kLODjx1fFJ/MbAfkPXs7quqb5LE2YP/DrCCQ
	 l8FTgaMT0yvYYtZieVZLjWXr+VSmGViz+632mlH6m1KnyN4Sqa4uPHbAUfUPhAWp9FD9b
	 aPVNE27aookHsg9GZ2jyyTbcseXioWqS8HOzhorJgyw+e3ZYyy+ZxpKH81FQxtp21S9nK
	 g2gSctxneCy2nSd92qRljpkhSZOLlny2lZGG6MazNmzNnSVHqQg1Xkk4VcIyuV3NliQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tpZAm4DJXsCEBcaBVQhboUWl+iE69C9fjTtFcZJ5irM=;
	b=3tS5/P3QdaKdqAkykKq/9bGZRgslZNBGshhabfP1BB606YHCOZLfAZyY59BiAbQZEi01
	 oOXRkskkGsU/rgXb3fRj8fPLGk3Cpdl+a39ofqSXRHmSu/VpkQoflaYdzCT+9g9I9zWKX
	 K+9EPEBbQWT0Lqyf88WaYJ6gMW/VhWzx298ObmmcNJyzU9h6zDN8ap7n1b4QzdsAilzKz
	 uQuei7xak6rQtrfEut6/KBKPB9xHXfQpKxBgT6pihUxwTLhKPBDvlwy7ZFH/zm5MDeUXj
	 oeK2ucQ4X3XSqBt6mwg5vsTPtvI6InheOIhQpom4GXC80Itg8IM0o+kb6qF7J7yLuLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6lUxLI9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8A1606A326;
	Thu, 19 Nov 2026 03:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6lUxLI9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E691F000C4;
	Thu, 19 Nov 2026 03:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059265;
	bh=tpZAm4DJXsCEBcaBVQhboUWl+iE69C9fjTtFcZJ5irM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6lUxLI9URO/C5MQg4y1+iJMEMqb6H2tITqb2lBlSUqlMFBLQIoy0j9PFpxIrAlr0
	 ut/0rwgcwWaTlpOAPhkYcIe9NEClJ6ox8v5O8qFxZW7qZ83JrzVe5V/70ihokcQXfV
	 Qa/56muKBn3xUrFi6l6keYTlKHPq3JiWAp4OJ61E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Doncho Minkov <donchominkov@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0780/1848] media: uvcvideo: Force UVC version to 1.0a for 1bcf:0b40
Date: Wed, 18 Nov 2026 15:46:58 +0100
Message-ID: <20261118145949.121817922@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit b400b6f28af040d55b4eb397ea7b8ece368c6b12 ]

The Shenzhen Aoni Electronic Co.,Ltd 2K FHD camera reports a UVC 1.10
version, but implements UVC 1.0a as shown by the UVC probe control being
26 bytes long. Force the UVC version for that device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reported-by: Doncho Minkov <donchominkov@gmail.com>
Tested-by: Doncho Minkov <donchominkov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 17 +++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 663f07f9ca018..d070711b4f2d3 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2342,6 +2342,12 @@ static int uvc_probe(struct usb_interface *intf,
 			"linux-uvc-devel mailing list.\n");
 	}
 
+	if (dev->info->uvc_version) {
+		dev->uvc_version = dev->info->uvc_version;
+		uvc_printk(KERN_INFO, "Forcing UVC version to %u.%02x\n",
+			   dev->uvc_version >> 8, dev->uvc_version & 0xff);
+	}
+
 	/* Register the V4L2 device. */
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
 		goto error;
@@ -3023,6 +3029,17 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
+	/* Shenzhen Aoni Electronic Co.,Ltd 2K FHD camera */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x1bcf,
+	  .idProduct		= 0x0b40,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= (kernel_ulong_t)&(const struct uvc_device_info){
+		.uvc_version = 0x010a,
+	  } },
 	/* SiGma Micro USB Web Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 4a1ff08453d77..184ff2c10560a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -654,6 +654,7 @@ static inline u32 uvc_urb_index(const struct uvc_urb *uvc_urb)
 struct uvc_device_info {
 	u32	quirks;
 	u32	meta_format;
+	u16	uvc_version;
 };
 
 struct uvc_device {
-- 
2.53.0



