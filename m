Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060692;
	b=0LZGFGJPhAV/HwC82k1d0do+HmS46K251RYnJcoOiFWCN5pU4gAwSPpswSPNYnUYLWSZ
	 Jnt6NFuRLkhy1y/9pV1Apg9pNYiB36XIXhQPTiGDbDyoWbFUFeYY8aTAmCW9P5VBjacC6
	 UtapmFIX6eTFx9cDU+9ZnOjVzr9ru/DGLjC0CHS9n9v5ovsn8z0XpwZQ3b5yHuvauc4Yk
	 OEjk29eqJIWpBaTaFOA3vvSuuxd6ORrw83BNXW5pEvvq9vE64A3diQinGu4mIjAr9a9OO
	 JpAoeVfduz0NtSJcxzHSg6rmsFvOXtNFT1iLQqOMW4bS0iAZjxFKqXmNBSn5o3Toh7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MLt+0ydrsnC0a4arboOarFfLMgreZZylZSi/rZXrVv8=;
	b=sw+UXT9Q+ql12SyCzdvzIaD2hey7Yx5TDRyPJo0mfzabuj7I1WfKutW1Tfiyw8JpuPOG
	 oUPqZYi6qR2HbBxinrvQyL4WdoNS8i6vhCVO9AFo50+WsgR/6x9cLN8ADU8A9mqw2/Pow
	 Ny+zBA0aTdh0gmdY1h0TJB3KzBqc2HIiSJipTqW41aiGQ3ddgjh0yUJ5hjCG/bSfQx/on
	 Kg2U/ShoBn3sz85/5ZFm0DNvYOe2NkUXPGjV2D+jDKenAYA8GnBFPmmUTMBid+ZqYMuBY
	 WjBy2uPywqt9qgsq46UmNNwQ34Uwe5UOIpxCe32V3d3hTWuXxdQKv97N8/ADfRwc+Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QH+vCuAV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA16606A326;
	Sat,  7 Nov 2026 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QH+vCuAV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A513A1F0089F;
	Sat,  7 Nov 2026 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060692;
	bh=MLt+0ydrsnC0a4arboOarFfLMgreZZylZSi/rZXrVv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QH+vCuAVCCr2RLDpV3VaRLRt0PQhWgicytADJXdlFn3XfzDd/dIusclz1kEZ4gUgr
	 AK5Gmz+5eM2pGM/Kkioa2sLBmCwPDC0Rcf/gen83laEq3ZYzJefA5W4YYsgbdpFoCX
	 j8ua8kJK7ULnvhoSiLWcWId7JTNuiZ3QKm4bDqS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0120/1536] media: em28xx: use vb2_video_unregister_device
Date: Sat,  7 Nov 2026 08:35:36 -0500
Message-ID: <20261107135001.057726269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f044e1c325707..d473f8dd5cdc1 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2245,17 +2245,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
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
@@ -2903,19 +2903,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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



