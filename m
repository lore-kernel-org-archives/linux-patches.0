Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033682;
	b=fhAAApZxH88rBLojRH90CLVTaFaRCSFbrllsv4+5qr4DYMKjLD/3zMHwujmwsAne7LtD
	 Qrllu9Kx9C3vyJNysTuUUtpG8yu5LGj1n32mu6tqc+Gp5ZK8c4ftFEYPKDBDAE96z1XBn
	 RSVgQ1jK+W5XJkuqcpyhj9up8yJmFB5XltYWuPBJC6vHTIQ4W8Ho8kpjsr/rzNCB3GW8j
	 nDTT0FXlHJ2pZC21C3MLx5iZUn7rI4j/0+12E5OUarNY72YZhU554vJ/yY2xyU64CzVV/
	 0SOCoF/PODUIZbpyrsov8SzHZMzb0HwQ6+QccWDmy4mFFzP4mrgHI2coJWuv4HxFCOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=67PpYUMdVRzhaL7Cs0ykidMEnXPqLOM0s4fg8h0tWwE=;
	b=UnVirtF8rh6CVUThEYejcuN49dNKup53u7HXtJYZ9ymeLJd26zUH8KjLOSjFWa1sy8Ok
	 i5KJtJfp6PtTQjAueWi3Sj/Ur0JdLny65C2VGdkoVBxm3/Fl1T4DByx9gP4ADw2bUNdmU
	 T0fISsgYyTGApn8cMoUmgxTGHJmIkHExkWsjytFA/9ZuBo4EN6uVpDho41NBOX4F8RqoV
	 nd1R2LLrgfBfGl4gwaectG3CCe0lzVk3rbKutm19tutbDpkLWHsR/p24lss4pxPJFgfEg
	 oJejUGnkJnU2yPFm2sXLozFeiaxWY4pjGLRv8rOje86Blda0HAXT8YgXVQE+cWoSwNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyW41Z4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD20606A320;
	Wed, 18 Nov 2026 20:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyW41Z4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05251F000C4;
	Wed, 18 Nov 2026 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033682;
	bh=67PpYUMdVRzhaL7Cs0ykidMEnXPqLOM0s4fg8h0tWwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyW41Z4i5TsR5pra8buJAFCgsN1eB3msaSDf7RV7w+xDUwKcvXft+GULWBNVlhwlD
	 PP8dn8UVoaePaXbjPjtAjvI5D0DESCRgARPwicFSyNopsz4Cxh3Z4h0z3jYvkxHopZ
	 bX6vAr7u1B/38O40tAKne70VJT/fEvfbm7lJYYEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0100/3318] media: em28xx: use vb2_video_unregister_device
Date: Wed, 18 Nov 2026 15:12:02 +0100
Message-ID: <20261118150317.218318989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6ac9ad5aa25f6..acc2fbadc609c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2243,17 +2243,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
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
@@ -2901,19 +2901,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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



