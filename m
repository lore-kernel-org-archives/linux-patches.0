Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035832;
	b=WfBrtqL2ZzHPxymCFFe+Mx2KgZMNwH33Cc9wDJQVhA2KQAN7fVIEwaUsi7Es/Be5WGlH
	 yncbcNvAUm39R5Nv+FzbPe/6K5QTX9RogTdG9lEbyjXPcXqh5iRloNsT6tq0U+I1O6zYo
	 n6p9JtQeFjIPBtgc7AXgBilzo1ZI3pv49qzBgUdqcHQYHN7H2oID4LJ/l2xmafEFY/7z5
	 cMU7JCHy1eX3XRwb/Goop+6QDR7OS0/xfZxkeufzRQsNAnyTcWR8W2bMXxMV/zXE4PJJT
	 gAZqMmMXdIR69hHSBhxLJwLpzkr7bdbOuaHLk0IcMm9JoyypXpJPexnYDWzEf1dD79A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V0cw9gxJpyFUtOomi1w9uX0OOfBqoh/aDe6hfREqlGs=;
	b=jv6k6dOpzIZKJYC5jTK9Fb7W/90yoyFK8kVhYpI3MDmMrB9pcT7yr6qbw8/II+q4D+rb
	 0JkP74lruEymj9x0fElYfgR3wEEJLi5aX4TclEbO+J4aMRTxfSOK6YYzcVt04inscg1Hz
	 QsO1fm9WXAIyA/uJGs+0PKK/gsrhljJQJZ2oxGGQa2zdAkvJB8yl6D7/saoHQl2a/1Kzx
	 bGLELaduEbxj+2VTRmMOOPpp01Rbmu6RCmEmMHB9XAyR7OJ74bmUvma1KTsJn7WFuono3
	 o4+U8+BfwOI+ler4DWar+Nu+HLfy5/DxlZVKmxfTU8075rvXWYYsuj+q4/PyTRQTkTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POeOcPaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6217C60A2602;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POeOcPaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32F41F000CE;
	Wed, 18 Nov 2026 21:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035832;
	bh=V0cw9gxJpyFUtOomi1w9uX0OOfBqoh/aDe6hfREqlGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POeOcPaJLGTmodHq6GwkZOU4sEZ+LFNIAoPho4aj1qcLyFLkg0R3PaOpOvHbawMtE
	 yhjSEwWlxnzKgaEAxlE1r1uxJWtC1GYwuCFOum5GoeKb+hLLh5bqOTPsGSBYgXgs9e
	 GkO9Zr9UmePScWuv+KajWT0Yt/Hbrh5+CwkMkwq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0844/3318] media: microchip-isc: fix awb_mutex and lock lifecycle
Date: Wed, 18 Nov 2026 15:24:26 +0100
Message-ID: <20261118150344.505009303@linuxfoundation.org>
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
index 78a26babf3894..df3b36e9f7f25 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1745,7 +1745,6 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct isc_device *isc = container_of(notifier->v4l2_dev,
 					      struct isc_device, v4l2_dev);
-	mutex_destroy(&isc->awb_mutex);
 	cancel_work_sync(&isc->awb_work);
 	video_unregister_device(&isc->video_dev);
 	v4l2_ctrl_handler_free(&isc->ctrls.handler);
@@ -1809,8 +1808,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 	isc->current_subdev = container_of(notifier,
 					   struct isc_subdev_entity, notifier);
-	mutex_init(&isc->lock);
-	mutex_init(&isc->awb_mutex);
 
 	init_completion(&isc->comp);
 
@@ -1829,7 +1826,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = vb2_queue_init(q);
 	if (ret < 0) {
 		dev_err(isc->dev, "vb2_queue_init() failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	/* Init video dma queues */
@@ -1840,13 +1837,13 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
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
@@ -1866,7 +1863,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = video_register_device(vdev, VFL_TYPE_VIDEO, -1);
 	if (ret < 0) {
 		dev_err(isc->dev, "video_register_device failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	ret = isc_scaler_link(isc);
@@ -1881,10 +1878,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 isc_async_complete_unregister_device:
 	video_unregister_device(vdev);
-
-isc_async_complete_err:
-	mutex_destroy(&isc->awb_mutex);
-	mutex_destroy(&isc->lock);
 	return ret;
 }
 
diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 4033bfc96bb77..7cedfd29ac130 100644
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
index 58cfbf6fcd668..36f52ea38d55b 100644
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



