Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7911CAA82;
	Wed, 19 Feb 2025 08:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954899; cv=none; b=RJ48khkUtq89EcjiSfflNsQ/6LZJma+NMLpALKa/RMWv+W/5RYeovkdsH9yBdVPApj/wjqSZja3dMePb+8agn9olmikTIplKA6LmKBNZr8OH8DAHbhqAkEcXchzT8n3p0YxfEEOkqesSmWz8fyQCA7hQ19XUcEKcQIbAS52Sbew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954899; c=relaxed/simple;
	bh=bDCbZ1SjxwGsr47kpgJ0dDbE4GDM3XY1NyNoySvv/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1kyCioXRPv9WXmGoszpBffkS+nXMPO2n1d9s9rssCPx12yIruUs9tkbc3wQxaubWCpVLyHN7xtPkAywyQ3ovo7xJARtv4ke2wzXvpkuwVkbiieehRQAZniialdXnBY59aboylRG0lGYqFYkDRzhzugoPSuvMWdZH0+eL8W35eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHTCbMbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHTCbMbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E844C4CEE6;
	Wed, 19 Feb 2025 08:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954897;
	bh=bDCbZ1SjxwGsr47kpgJ0dDbE4GDM3XY1NyNoySvv/tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHTCbMbfZ1AMeFNzaB4CI22Fio9ySmu4Nlg7QQoBqtjYL4AWBzrxdF2J8M3FeS1wE
	 x40uaqj1z9qYlhNAa+GPahu68r+z7sFsys5FnZGIgmGSZ2xyiKzz/jpuqDE8CrVKRb
	 Xv+LzI+9wcc9zZsiHbP/qnCBfPmE9JFjWA0GHBPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/230] media: uvcvideo: Add Kurokesu C1 PRO camera
Date: Wed, 19 Feb 2025 09:26:27 +0100
Message-ID: <20250219082604.446323673@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Isaac Scott <isaac.scott@ideasonboard.com>

[ Upstream commit 2762eab6d4140781840f253f9a04b8627017248b ]

Add support for the Kurokesu C1 PRO camera. This camera experiences the
same issues faced by the Sonix Technology Co. 292A IPC AR0330. As such,
enable the UVC_QUIRK_MJPEG_NO_EOF quirk for this device to prevent
frames from being erroneously dropped.

Signed-off-by: Isaac Scott <isaac.scott@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 250c118e01bd4..4d8e00b425f44 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2846,6 +2846,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
+	/* Kurokesu C1 PRO */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x16d0,
+	  .idProduct		= 0x0ed1,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_MJPEG_NO_EOF) },
 	/* Syntek (HP Spartan) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.39.5



