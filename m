Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051059;
	b=aLvQhEqyCU+scedq3x0TYv172Shmik6+zz9Zob9JMKdOqba/WMJorjxZiUZM7a6P9bs9
	 n0K3KWohZPumwKLCqViHNMCoO+w1mVymHm+ojN71yt7OZbTsZA+2m1KLOdygodT49hE8T
	 1vKn+oO5vYgWBcHTLgzhqGv1+mrdZajPBrDh3wEaMfHzy1ildSC6oAo9Tsl9Vko1MiTHm
	 IEijGA2fFDt8XvktW7eDe4Z0K1MPX1oJJcU9yR7SHBnHLp1defCEZBbEI/6UnODCrHhET
	 v9hfcBIoWAm5PMwKrmQ0evpjiFc094meU6Zn7u8cgzAlYIfLhvy+AF5pNyF0aDcImqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ECBinTabp4ZQ51X23LLOY/8vowuNxrHytvMN0hRD+9E=;
	b=lSjHEpv6zmD94qzVP/5Nm040dYh496Elw/E0kt0O/dQ0AThZAx/xdb+zEE75zuc1znD3
	 MBhWfXNaol15pt+QVxg9wQ50SvjWu0p72/IXOvhGgmGlDjLgEM8oC4G9wOlGFyiTNcLSn
	 c5m0zBqVSM9WDpV5QUkEQtLejiGFTdSs5CLiJDPI1kJZImBDbn3wAHUUbVsYvBoPVKIhT
	 g3FIUz5XSSyLLsULC7i8YJBnm4VBWFr4QbefsyMBUERpk0lI6iuh3gXHTP72feN+K1dwN
	 2fKI8TB2SEqRpcWHl7Q6PSIPc+pFaPj5o9UnAOF4RN9XZ8CH85/33/EcK+bxmwyapLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBQjGfj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AF9606A32A;
	Thu, 19 Nov 2026 01:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBQjGfj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9752D1F000C4;
	Thu, 19 Nov 2026 01:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051059;
	bh=ECBinTabp4ZQ51X23LLOY/8vowuNxrHytvMN0hRD+9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBQjGfj6McbVwUfad4VxfK76T7rSQifQHyLm9BvjFGrJa4sEoRSBXPIQPlKGBIa9U
	 VMd7lNlco5eXxWbZ6nQMsU8URao2DbtSP/Ql2A2WJ9aUSqGgjdLaZSFCbCR+IOmOi7
	 jSpQMKwbaD+WBXbCT2UEFBubxltiI3Ldlg5inhvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0073/2214] media: em28xx: use vb2_video_unregister_device
Date: Wed, 18 Nov 2026 15:29:09 +0100
Message-ID: <20261118150012.896986161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 7c8bf63b79371f5b57da1bd1401bd420180ac6e6 ]

Use vb2_video_unregister_device instead of video_unregister_device
to ensure any streaming is correctly stopped at unregister time.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 15f90c25fab2b..a2cdde3bfe900 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2253,17 +2253,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		video_unregister_device(&v4l2->radio_dev);
+		vb2_video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vbi_dev));
-		video_unregister_device(&v4l2->vbi_dev);
+		vb2_video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vdev));
-		video_unregister_device(&v4l2->vdev);
+		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
@@ -2911,19 +2911,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		video_unregister_device(&v4l2->radio_dev);
+		vb2_video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vbi_dev));
-		video_unregister_device(&v4l2->vbi_dev);
+		vb2_video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vdev));
-		video_unregister_device(&v4l2->vdev);
+		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
-- 
2.53.0



