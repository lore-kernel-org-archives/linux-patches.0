Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992FF222D65;
	Thu, 12 Dec 2024 15:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018207; cv=none; b=sYdq6qIme9SXYYZWaY6AgdsHwbQBOfDAdLEAV8d9CzjLm2RwByQhAlrgF9I5aIOqwoTu2oLwIG6EnOIQ1BcW3qQR+wdAq0k8um3p7cLdHaKouIkOPVh6ekhVB56Iz1O5G+TPffUlxEHix1Ft5QmwGZCc9g9rjCZifLOfq2NgdQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018207; c=relaxed/simple;
	bh=CNJvhRCi0JpVgZYknR90CACYTPsw2ObyzOBHQIrlzKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs+uJQtriSghQrTnDTugCI8rfrTFovTb/BdViIeWRra39ETIS68JTPx+bP+dDvhi/2X2mxtyEkBmU/4BbglREekIT/KNDT4oApl2J2QT1Qm4g8hNxg+mxlyAy90gmQhdXpUsPnTjZqASLWTYpygHxaeqY6zEXItPJiHck6VsSaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOa1n6bU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOa1n6bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082CAC4CECE;
	Thu, 12 Dec 2024 15:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018207;
	bh=CNJvhRCi0JpVgZYknR90CACYTPsw2ObyzOBHQIrlzKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOa1n6bUpPq1gyCJ7uHZNX9mMCqFhhuCpn8TrETpxJ7wiZxYExOd7gyjBby0gtjJX
	 Tq8cdI9XcqItlP2eGhRsszARJwbLBSMGEbxehZSZu9aixUSK3IsMh/NPh85/gPQHT+
	 oQAwuSWqeA+yBAmhAps9FkSiCVyQPpAqDk8mbuVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Perchanov <dmitry.perchanov@intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/356] media: uvcvideo: RealSense D421 Depth module metadata
Date: Thu, 12 Dec 2024 15:58:36 +0100
Message-ID: <20241212144252.406613205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1385cbf462d17..f85cbe56a679a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3229,6 +3229,15 @@ static const struct usb_device_id uvc_ids[] = {
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



