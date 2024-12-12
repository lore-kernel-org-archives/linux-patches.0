Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F2221579F;
	Thu, 12 Dec 2024 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016588; cv=none; b=uFav1BP1OjX+4/+hvTolRzAnGFHXSaxIdQJEPQ6flDwvT1b+ei8b41Dgl6GvcCyO5m3fhcs34PsP7vJj+2a4Npc4pgGs1ufqePW+2ejHvpO5vvtooaEl2wNsFJvLoeN+YEZkzbk1AkOVZgviGbs94Y2683BGc3hz4LMb6ESo8lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016588; c=relaxed/simple;
	bh=cHZniohbqTcyIf+pJHhfgmaNjW3orAipTriHLkEVDps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq7DR6i3vvM/XRmT/ZtS7PpRRvUIqyiQ1TXyL3/bkXqlIsma5MfrTbX6V+M1FSeKv3mOG0aNjznLccwZrODeTY+eT//yNSHBwXPui/dWIDF3MjPXssZT+AC8TRSAlXlw8EAeZcinoXaJoN6Km5v22vp6QUwgzQGDCcXBHwkBYLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuFpPDjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuFpPDjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68266C4CECE;
	Thu, 12 Dec 2024 15:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016588;
	bh=cHZniohbqTcyIf+pJHhfgmaNjW3orAipTriHLkEVDps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuFpPDjkdsodu5f1PxKu+niwOJFiRKwiTEH1MejEbMxiusyewDbqddHDinUlK4Prc
	 +JcWYWcTxOy0ChaoWJ94OMvZw8CD2dwvlfQzjAWDqrs9mxobWhFZBo5S8EqzgqJC76
	 K8Zg7Nlu4AAbEYUId5HCPGX7WBoZlUQq7xEyP/+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Perchanov <dmitry.perchanov@intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/466] media: uvcvideo: RealSense D421 Depth module metadata
Date: Thu, 12 Dec 2024 15:56:50 +0100
Message-ID: <20241212144316.303276077@linuxfoundation.org>
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

From: Dmitry Perchanov <dmitry.perchanov@intel.com>

[ Upstream commit c6104297c965a5ee9d4b9d0d5d9cdd224d8fd59e ]

RealSense(R) D421 Depth module is low cost solution for 3D-stereo
vision. The module supports extended sensor metadata format D4XX.

Signed-off-by: Dmitry Perchanov <dmitry.perchanov@intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/d1fbfbbff5c8247a3130499985a53218c5b55c61.camel@intel.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 675be4858366f..03aa6e5f117c7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3118,6 +3118,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_INFO_META(V4L2_META_FMT_D4XX) },
+	/* Intel D421 Depth Module */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x8086,
+	  .idProduct		= 0x1155,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_META(V4L2_META_FMT_D4XX) },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
-- 
2.43.0



