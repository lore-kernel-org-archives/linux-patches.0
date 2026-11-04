Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829523;
	b=M5CneqZqfrFemOtS13YkzvmDfUelFJNznUhPIUiPmViSkpsld7fYyCu0P3zWMRvXiGgQ
	 LbFSd6hBs87xRq7vwYr/CYGaInoq/YOklFyqQhZ/w+0RueL58Dnb5zrsLh3/pBvslvF1Z
	 N+LeN+BjuyvWDWmhzxGa8fHgpG3pz2FJ0RoXfXYUG9Kjigl5COOlEVFRvjGWPRg0KdMa/
	 tFIPfY0LR24j4IXENrwfaw2zVw+qlAH3sHZuJblIhTz5ULONw5jwkzuAsePLWud/KcRqo
	 6bCtswApJuXy4R7xObtf6fCb3l4SIq3Hf+aRr0ymU3d8f6QKTSv+ssmcVeRNl7lVjxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=78rTosI2bkC2Zoef1ygM7IZ9/XCSBlY3pf3scHDTSGI=;
	b=upyqUVwIAU6hxicYfjwyXkv/acajPNRe7SL2uUNpOIxAXktjA9tLkvwbJD33aGbSuw7E
	 4Ep7gRrxvX4IKDfta3snoU/Ne0TwKrVHERm9dg0Xv14x7q9g2vpdztxKhKuLyFhHvH4Rc
	 yr4h4w2qd45UR5p3cRwcRbreKoPDVh0zQEjFP+2zB/b/gnmLVuDZ32CGl3nR2O4nK7r3s
	 VSLe5cZq23O4+5CdFDXXgabOa4p+YvakBOKTEm9XJn76vc/iQL+cZK7tiQePnwtL7H9ru
	 Tu1dFiQiQ2/fNV9C+9fj8F3O+SpNQeOU54KiAuLNYbbvKk0jT3FLIltAoHdgiLka37Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbCZCGNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49735606AB17;
	Wed,  4 Nov 2026 21:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbCZCGNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89151F000C1;
	Wed,  4 Nov 2026 21:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829523;
	bh=78rTosI2bkC2Zoef1ygM7IZ9/XCSBlY3pf3scHDTSGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbCZCGNfhnLZgTnm+FvyEZe7JNbtAfQxbuhihkUVRwyDCpgIHPEmx4YaLJNE1Ah3a
	 9xGFgxNV2n6LUqnxWHBqMGIWukY2t7iNcaEpLaD12LsULQRd/nIkh+LjPqZu+bQASV
	 4JhdUTqdaT+r+buv5wW21Fj8Y1nRnAci83VS2I8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0140/1005] media: em28xx: use vb2_video_unregister_device
Date: Wed,  4 Nov 2026 15:57:53 -0500
Message-ID: <20261104211047.621292540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e0a69309687b0..e2907b56220b7 100644
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



