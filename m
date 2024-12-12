Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BE52EAE5;
	Thu, 12 Dec 2024 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016598; cv=none; b=QUi7P5C2TPyvXX5ZBBkY3Ik9EVGj+/WJx/K8U47i/c3+WFmRF4Jv1y8Y94iWpC6IuPdjn29jjpngnXSKouqSFdqChTXhoqqNTVaH0SL/f1NbN81JyfP0MT+CwE6aYyyHCEbYOz+oJww8BFbr5W93eQOkKMVkD/6Wy7hvrhW/7+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016598; c=relaxed/simple;
	bh=sQ/pFhZAxKM2KLImzB/SFX6m0xBTWmKIXfHfd96rgLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig+nZ3dO4k7lTV0wnLfsmhfcA1vR4QuQd3SKHBO/vSZ0cfn4hGTNdrBI3fed6Z9zqSpKI+IeUjQIcPmJDkdRNG/0CdLN9jgn4SwLk8IUSxp1UsiFUcjenEuMdD8pm7w4QhlZszwWEGz98LHw/URiYOmPqK/tZt8gHUQAuL6ldYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KulT993h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KulT993h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A33C4CECE;
	Thu, 12 Dec 2024 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016598;
	bh=sQ/pFhZAxKM2KLImzB/SFX6m0xBTWmKIXfHfd96rgLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KulT993h2NXqrG6+F7v7mJYlk6xt5R1wbDc1KTFGjryGW8MyTyP6dYB9aGJSQBZbs
	 n2fUJr1cSnwWSuVFD/R9l7CgtChdB7yXgCLpiM9zyci3/RhNpoZyLDEMj+QmSE3wAa
	 HKNTcLC8euKKnW0WyZeAnhLwJRDjR3HGW5BmtXB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuliano Lotta <giuliano.lotta@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/466] media: uvcvideo: Force UVC version to 1.0a for 0408:4033
Date: Thu, 12 Dec 2024 15:56:52 +0100
Message-ID: <20241212144316.385830644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit c9df99302fff53b6007666136b9f43fbac7ee3d8 ]

The Quanta ACER HD User Facing camera reports a UVC 1.50 version, but
implements UVC 1.0a as shown by the UVC probe control being 26 bytes
long. Force the UVC version for that device.

Reported-by: Giuliano Lotta <giuliano.lotta@gmail.com>
Closes: https://lore.kernel.org/linux-media/fce4f906-d69b-417d-9f13-bf69fe5c81e3@koyu.space/
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240924-uvc-quanta-v1-1-2de023863767@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 17aa313613356..9f38a9b23c018 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2479,6 +2479,17 @@ static const struct uvc_device_info uvc_quirk_force_y8 = {
  */
 static const struct usb_device_id uvc_ids[] = {
 	/* Quanta ACER HD User Facing */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0408,
+	  .idProduct		= 0x4033,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
+	  .driver_info		= (kernel_ulong_t)&(const struct uvc_device_info){
+		.uvc_version = 0x010a,
+	  } },
+	/* Quanta ACER HD User Facing */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
 	  .idVendor		= 0x0408,
-- 
2.43.0



