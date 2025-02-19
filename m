Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86A61C3C1E;
	Wed, 19 Feb 2025 08:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954053; cv=none; b=EIGBdkbgLF3E7FOBo+/ACLdsBDKzQRLR7t4mOEvJZSYzhGrxjpJMwVmUVJ5pcNPHI8DgKv8xEEwr63vm5z7D2IGz7dIGGK8b52nkv674lAJyUQz22hf11uWT9eHljdwMEQtIZoJ1JmTminD2lCnZLPyBb4w2cuZlrVl+5U9V8No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954053; c=relaxed/simple;
	bh=0wNu4Sv2gdD3LZ9H77NLsTGdro3iQxdHKhQGuEx4rD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai+JbVwrSzWnbM6guaMTHgSXd12YZuEgTiTC4DLV5zqYsOeOwZFsmInZ0E/qKNDmMIyjqbfidUaBv0ofXWr035t6MHxAmUSNj6c3PAv2Ob/up0X/rFiYJIH/f4fl6i4YanghXudyZ7xz/1mbZEkPB/LmhF3/lBMWXhU8HiKeL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw/WDq3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw/WDq3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EE2C4CED1;
	Wed, 19 Feb 2025 08:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954053;
	bh=0wNu4Sv2gdD3LZ9H77NLsTGdro3iQxdHKhQGuEx4rD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw/WDq3ll7QJFiCRNp16FsrIF+WlIt9v4UQWwzWzkcDnCMFTAXKB5paabIGyh0Dj8
	 /8u5aKpBMvXiCjnoKIgs03R9F9tyXVZ0BaXM3HFlbl7gKV7OqmGOQ+3+Jo2RMrj4ap
	 r92KuQjpQcPtsfsSviS2ocCRpdEiszivW5N9p0S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/274] media: uvcvideo: Add new quirk definition for the Sonix Technology Co. 292a camera
Date: Wed, 19 Feb 2025 09:25:36 +0100
Message-ID: <20250219082612.831954572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Isaac Scott <isaac.scott@ideasonboard.com>

[ Upstream commit 81f8c0e138c43610cf09b8d2a533068aa58e538e ]

The Sonix Technology Co. 292A camera (which uses an AR0330 sensor), can
produce MJPEG and H.264 streams concurrently. When doing so, it drops
the last packets of MJPEG frames every time the H.264 stream generates a
key frame. Set the UVC_QUIRK_MJPEG_NO_EOF quirk to work around the
issue.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Isaac Scott <isaac.scott@ideasonboard.com>
Link: https://lore.kernel.org/r/20241128145144.61475-3-isaac.scott@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 31b4b54657fee..1e14fd0c51d2f 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2800,6 +2800,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
+	/* Sonix Technology Co. Ltd. - 292A IPC AR0330 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0c45,
+	  .idProduct		= 0x6366,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_MJPEG_NO_EOF) },
 	/* MT6227 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.39.5



