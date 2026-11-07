Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061958;
	b=jY9CsTzgD9wYlciI5twLn6dDXqbProFtoo7e517To+FVZa+XY9xj+iG6Xvxk1yVIQuFl
	 94YQeD1164p3tP/GFWbBxLpoOZqWW2UK+65mPKY8PaYIQ6Qp98l2BxfwbufktKjEUnqR5
	 GzzsgBocijN35cbNmr3unadgMf3/avzmlsO+qEqIWgF9BC54nJjgox4yDMZFxEy+L8EXt
	 UtQ3/Rjr0G8UhOd1Q1iVqsZ16zAZRD7obNwc7WC9YqIRdzMOH3ohTpH7rqdBZSWdG3Jwl
	 EKeHJwvKcRUXbUbd8WDGU6GZmJiU/9+UNCrQ7Anehjez98fAPtm9KBjso6/OrywsqQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yKozGTj5kXFPLZk69+5MOrsJayxYQ+h94ee1DfMXda0=;
	b=nWvqHJ5ceEy2djYqZmzXZNbsz1dArp+nvm5l9dJcm/h2C0nuz4+upHfLAe/l/wlMoZNd
	 O79zhH48CX1XQwmgFw3Gob2r9eBBTtrhAj3+Es//qGgsPtXmAXKF++TgOY7epLE1xRzJ7
	 D4hqGv5hoY7JKVb+tfFBmZtFjAC8ZxSrBY/1cIMRHPMCS9ruJ7Fj78M+Qfh7TuuGD+mla
	 gbkZBG420lKtlTyNL+Bc3ehSug0c+Dp+1iIKNepzHP8K5jDnd8K4XXmtSkB3TEsCzvp94
	 DDmHz3TpNu9+91aJX1l1apxUkXJcC5EEXxzy6D5GmYXZkbeKDdHBebY+V+hN+yGHqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHcB7XK9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20C6606A332;
	Sat,  7 Nov 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHcB7XK9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A891F008A1;
	Sat,  7 Nov 2026 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061957;
	bh=yKozGTj5kXFPLZk69+5MOrsJayxYQ+h94ee1DfMXda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHcB7XK9fQwXKLQrG+PNGbPs7eBRnpmLksZX7HlI5l0fBfZzAcjDUTflkU89Gns/g
	 frGtl3BETDMPfP2U5A0ibon9wXFguSWrSxbKAh1MH9TUeHYN3a9NQ6N3AP3KoF49qz
	 qAUhbx7UnLCHfDLFmdbosSpNp/c/9fUbDjXyyyxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0948/1536] media: microchip-isc: fix awb_mutex and lock lifecycle
Date: Sat,  7 Nov 2026 08:49:24 -0500
Message-ID: <20261107135024.284009237@linuxfoundation.org>
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
index 5bda866d29d87..44d50196bb304 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1705,7 +1705,6 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct isc_device *isc = container_of(notifier->v4l2_dev,
 					      struct isc_device, v4l2_dev);
-	mutex_destroy(&isc->awb_mutex);
 	cancel_work_sync(&isc->awb_work);
 	video_unregister_device(&isc->video_dev);
 	v4l2_ctrl_handler_free(&isc->ctrls.handler);
@@ -1769,8 +1768,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 	isc->current_subdev = container_of(notifier,
 					   struct isc_subdev_entity, notifier);
-	mutex_init(&isc->lock);
-	mutex_init(&isc->awb_mutex);
 
 	init_completion(&isc->comp);
 
@@ -1789,7 +1786,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = vb2_queue_init(q);
 	if (ret < 0) {
 		dev_err(isc->dev, "vb2_queue_init() failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	/* Init video dma queues */
@@ -1800,13 +1797,13 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
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
@@ -1826,7 +1823,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	ret = video_register_device(vdev, VFL_TYPE_VIDEO, -1);
 	if (ret < 0) {
 		dev_err(isc->dev, "video_register_device failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	ret = isc_scaler_link(isc);
@@ -1841,10 +1838,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
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



