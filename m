Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063909;
	b=kdlk3mCM4FBaLcI2Nx8aGoVBo/SOQ++qaJ3lFPJwOrTBytNBv6+01SIT30TF0gKs7Qf9
	 x/oSuSEuzV5m3vMDx55SmZGmb8WFQSQWSCgzX3Koc4FOPs26WXP3iOS1aEYmzBalsNyWr
	 7bTxMDZYZqB/xCf246kTTh38HBTGuCo7AfKx5k9EIxuBveMj3l+/hpK9HobiWCc5VPnfJ
	 yGofJJCvLnFZ2KQzJH0iYyC9YtU65/G9RDUl55+8Ky1MqIVSwjUHu22jQRJrPUFoqUgrU
	 pzk4G6O4KJPao5ZDHtS6+QpFo50CnphJcpWpBrzdlIfdHp1awMA1O8SAm4MLQwo5SSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QG/zLfShzHWtF7xFSXOmblkXGuG6FEoB88jDIhOZBgU=;
	b=e+MsIc/IlmeO+GUne5s53zMfmKYHXMVCNARb31hgoec2PqzNBwyEzGC4lMOoVQauFqNJ
	 PXkVcwjhsHztXL4+NKjv6a0cj9WehJFBChvdn25aszrtIEPLqGksHBUbzW9M5V5IyNFXF
	 cfC8QgaAOGo9PTmMWBPgCLEbDxmktSQITVs//vtY/S1DMtt83Dzu3svYIkXZvSW/pSv1r
	 /rbaIwye3wvnsnEiHaYlYQTvuox7s6cQLugKF84LmuX3P/uTVy/jeDlffa99FtIOHvDt7
	 OsRXMs3VNSBCWB5OaG1NMGVk82R2jxlDXXHFsIoSGxw6pp2pbzayCYzuNBdKGUjdjow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CsU7kYM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98584606E8E7;
	Sat,  7 Nov 2026 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsU7kYM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457251F0089F;
	Sat,  7 Nov 2026 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063909;
	bh=QG/zLfShzHWtF7xFSXOmblkXGuG6FEoB88jDIhOZBgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsU7kYM/x6e+c4zyaJetm/UcFbJNjED/8hEMzUSPZj2rzvTD2Jgq9VNuB7mXNmyNi
	 Utu1YwL3h4bQTV0eyejL8Wywo7kJtCldb0xMjbd2BjrhUXkSkw/YgfLXm6ohws0nDU
	 9FAatgsrOD5ZMLt8MLGP8SXqlw5axgJYOVamGdaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0108/1257] media: microchip-isc: fix awb_mutex and lock lifecycle
Date: Sat,  7 Nov 2026 08:40:04 -0500
Message-ID: <20261107134942.336755626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 5540b48c0702f6a1389db3d473d7fd0db930422a ]

isc->lock and awb_mutex were initialised in isc_async_complete() and
destroyed in isc_async_unbind(), tying their lifetime to the subdev
bind/unbind cycle instead of the device:

 - isc_async_unbind() destroyed awb_mutex before cancel_work_sync(),
   which takes it;
 - a failed .complete() left them initialised, and isc->lock was
   destroyed only on the .complete() error path, so the normal unbind
   path leaked it;
 - a rebind runs .complete() again and reinitialises a live mutex.

Initialise both with devm_mutex_init() at probe so they live for the
whole device lifetime and are freed at remove, and drop the init and
destroy from the .complete()/.unbind() callbacks.

isc_async_complete_err then only returned ret, so drop the label and
return directly at each error site.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/microchip/microchip-isc-base.c | 15 ++++-----------
 .../platform/microchip/microchip-sama5d2-isc.c    |  9 +++++++++
 .../platform/microchip/microchip-sama7g5-isc.c    |  9 +++++++++
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index 32bdeae04ad07..ca4f3b5f58aa9 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1703,7 +1703,6 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct isc_device *isc = container_of(notifier->v4l2_dev,
 					      struct isc_device, v4l2_dev);
-	mutex_destroy(&isc->awb_mutex);
 	cancel_work_sync(&isc->awb_work);
 	video_unregister_device(&isc->video_dev);
 	v4l2_ctrl_handler_free(&isc->ctrls.handler);
@@ -1767,8 +1766,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 	isc->current_subdev = container_of(notifier,
 					   struct isc_subdev_entity, notifier);
-	mutex_init(&isc->lock);
-	mutex_init(&isc->awb_mutex);
 
 	init_completion(&isc->comp);
 
@@ -1787,7 +1784,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = vb2_queue_init(q);
 	if (ret < 0) {
 		dev_err(isc->dev, "vb2_queue_init() failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	/* Init video dma queues */
@@ -1798,13 +1795,13 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = isc_set_default_fmt(isc);
 	if (ret) {
 		dev_err(isc->dev, "Could not set default format\n");
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	ret = isc_ctrl_init(isc);
 	if (ret) {
 		dev_err(isc->dev, "Init isc ctrols failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	/* Register video device */
@@ -1824,7 +1821,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = video_register_device(vdev, VFL_TYPE_VIDEO, -1);
 	if (ret < 0) {
 		dev_err(isc->dev, "video_register_device failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	ret = isc_scaler_link(isc);
@@ -1839,10 +1836,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 isc_async_complete_unregister_device:
 	video_unregister_device(vdev);
-
-isc_async_complete_err:
-	mutex_destroy(&isc->awb_mutex);
-	mutex_destroy(&isc->lock);
 	return ret;
 }
 
diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 88e6d8e1c6c9c..18e1ec0b94fa6 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/math64.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
@@ -424,6 +425,14 @@ static int microchip_isc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isc);
 	isc->dev = dev;
 
+	ret = devm_mutex_init(dev, &isc->lock);
+	if (ret)
+		return ret;
+
+	ret = devm_mutex_init(dev, &isc->awb_mutex);
+	if (ret)
+		return ret;
+
 	io_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(io_base))
 		return PTR_ERR(io_base);
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index 77c6c183451bf..07cfe1109ff09 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/math64.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
@@ -413,6 +414,14 @@ static int microchip_xisc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isc);
 	isc->dev = dev;
 
+	ret = devm_mutex_init(dev, &isc->lock);
+	if (ret)
+		return ret;
+
+	ret = devm_mutex_init(dev, &isc->awb_mutex);
+	if (ret)
+		return ret;
+
 	io_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(io_base))
 		return PTR_ERR(io_base);
-- 
2.53.0



