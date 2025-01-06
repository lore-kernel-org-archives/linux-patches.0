Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1766E15855C;
	Mon,  6 Jan 2025 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177131; cv=none; b=sbLxitQA9Do6dGZ4oekHWOnEjlxLJ+ODqgNFEScHXyr+Ntq/Qx9vGCRe0bl7NCHqEUQhcq9z9V+yEeFApK1p3jb2aaic2kKshWQC8AkWnII3kcTQJL1lpaBLWglxEQUcW3rqXgUNhoeTf69DUhqABDBDcIHK/w6tq1rznGHx/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177131; c=relaxed/simple;
	bh=PTIipKF99XJ2zbJsyX7jWuB/k+FL7EJJGltx+6c3v/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPRtW+4EQ0okMYty7NBtxr4r1zyNHpk//09sYN7xwIUUIlpwJTZg9JP3fpa//44frxAxC+sx8mECoUc3qk86XGnanyUWaGKjr+iZHoYiUKOWNq13I1iRA7s7BmAvDQuBmRQGNHRfFacqwKsow/WChwUPX2FJLOfCp/8s+mlgz0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlvzM9gK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlvzM9gK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952DCC4CED2;
	Mon,  6 Jan 2025 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177131;
	bh=PTIipKF99XJ2zbJsyX7jWuB/k+FL7EJJGltx+6c3v/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlvzM9gKfBysyRQLUw0SQRQlEZGEKL1Dq6VctSrO+HynTGpITtivVGXibjp9r3FXH
	 pPEeeuCLFqoNeLXGESKDXfPeMxYIYbKHUARDzOgC/SowTiqmK+OS1Gl/FYBpdVw+/a
	 YN69V0g+aIKRPSoF9+FH0yjxWYA9uzal/kgA8kJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuliano Lotta <giuliano.lotta@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/222] media: uvcvideo: Force UVC version to 1.0a for 0408:4033
Date: Mon,  6 Jan 2025 16:13:53 +0100
Message-ID: <20250106151151.706368293@linuxfoundation.org>
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
index adf1abce5333..1b05890f99f4 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2520,6 +2520,17 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= UVC_PC_PROTOCOL_15,
 	  .driver_info		= (kernel_ulong_t)&uvc_ctrl_power_line_limited },
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
2.39.5



