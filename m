Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383F0157E82;
	Mon,  6 Jan 2025 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177128; cv=none; b=IR01ClGP4zanBYbZX7JAjIRXQ18XR3Z/GW9EJHh6439y5piXi41cbr/jlduCnqYU5kjA3pfYE6ZoXa8fDbwPWw4+0qtA7rPDHw/1LgMs67YFts1TbmNPW9sgG17bdRhmGGvXRmKAqy3EisxHD1K3RxOQAicXL3ttmELh+Lq+XMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177128; c=relaxed/simple;
	bh=lzMI9YDRitQDaBTgqRV7cIL5zm9tmH0KVbjBPoz8Jpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDtSYnG4PPlB8aboT/4lT5wiG8gyCprJUAMjO0lEmSpmoRJghSduspTdBzxH0G7NjSlY5ZUhYdl9ao3WAX+d+EuGW6M+t3H/rsBH4iX8ICRL35Vu4Ute4hJ0bPnTb/oorJK/58IE5f0w0EDMnbs2ErOFA2jT5PX743GD0TVojQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj2qiHc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj2qiHc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21C3C4CED2;
	Mon,  6 Jan 2025 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177128;
	bh=lzMI9YDRitQDaBTgqRV7cIL5zm9tmH0KVbjBPoz8Jpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj2qiHc6IazeuUUlwtYJPg4ypO26UJQ/AaPc2WufXoMO2A5UVOwOv4myjHO8nzg5l
	 ajOkYbqn+Rtmpc73ApgRabl+BwbtuX6bduMqT+Yi+iewbq1/mQwOi0YllqydQky9ID
	 CWrbJvV1MJVQY+D/gg+UlYFXkHhcYc++WRTxArl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuliano Lotta <giuliano.lotta@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/222] media: uvcvideo: Force UVC version to 1.0a for 0408:4035
Date: Mon,  6 Jan 2025 16:13:52 +0100
Message-ID: <20250106151151.666662065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit c397e8c45d911443b4ab60084fb723edf2a5b604 ]

The Quanta ACER HD User Facing camera reports a UVC 1.50 version, but
implements UVC 1.0a as shown by the UVC probe control being 26 bytes
long. Force the UVC version for that device.

Reported-by: Giuliano Lotta <giuliano.lotta@gmail.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2000947
Link: https://lore.kernel.org/r/20230115205210.20077-1-laurent.pinchart@ideasonboard.com
Tested-by: Giuliano Lotta <giuliano.lotta@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Stable-dep-of: c9df99302fff ("media: uvcvideo: Force UVC version to 1.0a for 0408:4033")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5a3e933df633..adf1abce5333 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2519,6 +2519,17 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
 	  .driver_info		= (kernel_ulong_t)&uvc_ctrl_power_line_limited },
+	/* Quanta ACER HD User Facing */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0408,
+	  .idProduct		= 0x4035,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
+	  .driver_info		= (kernel_ulong_t)&(const struct uvc_device_info){
+		.uvc_version = 0x010a,
+	  } },
 	/* LogiLink Wireless Webcam */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.39.5



