Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42922321F43;
	Mon, 18 Aug 2025 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526059; cv=none; b=slVPW/4FuB2SuX3An63CX23MdZcjEfRwbR/QyRtPEEdZSg3YYrQ7KMSSCYWWNp0NWxZaXmlzswQvPH9neH25Mv6TwuwMLBZ+lkz+8ijPrIn/i4MDm49pY96Rh3yy5N9Cshi8eaLRYMMyQNldG2fUf1cWsBHQp3iBGiRYOcWalYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526059; c=relaxed/simple;
	bh=4VuVLXAvx81QmyjiGPEm8LD9VK3wLJT2KoHlfTyfFlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/rih0w9ZDH3yS/ta7U9WERecySc0DxH4z+D2yFZ3o/YqfB+vX75rK8soau4GNPZDwlbIKcOiGFxFe7aLyE51U5AB47mly5R4IFruD9066d+75gFJIdZtqbsdvZgaPDaIebDwIYB3kMAqe3CO1Z/HbH9qKSaYzvg88keNHLeBCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQ7S5lhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQ7S5lhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A6C4CEEB;
	Mon, 18 Aug 2025 14:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526059;
	bh=4VuVLXAvx81QmyjiGPEm8LD9VK3wLJT2KoHlfTyfFlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQ7S5lhihtz2pRaP8WQVjkQb3h9SGBRBLIXeVKwoK0k5mdymzNP1hFEFz47t2o2/9
	 +Q6FiMZZi/qibyGEviBZR5Ht7PGDANgvm6zybs3oLDXs03boc5m1dMOmLVvtYvewHh
	 g7MBqEbyV5OWKBg6rUyy1kK/TlXxFLrCzIGz80gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C3=ABl=20Melchiore?= <rohel01@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 414/570] media: uvcvideo: Add quirk for HP Webcam HD 2300
Date: Mon, 18 Aug 2025 14:46:41 +0200
Message-ID: <20250818124521.794003252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index da24a655ab68..bd875d35ec81 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2514,6 +2514,15 @@ static const struct uvc_device_info uvc_quirk_force_y8 = {
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



