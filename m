Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062807;
	b=GyP0bvuGLXx/8rcCLAP4ToDzDCyNCE4NVlon60+wLsl9j2CSuAzdmMCuZ2JJGiZg50WK
	 1AXJDIHnFdcpWClf1Eug4dHbIDW2Mcj/0R9R2Vvx1kDrJFDwp6g/XvM5+jbkuJj23hmKG
	 LqFRUQap7uj5i4LQo5K+F0AIHbOvykTKURGEja+xEgCN3Em9KhVI/mlhbWPQHiRPN5xbL
	 VUsXi7BuL+PzINOSow5mYPhaBJss2oeP6ocAV9pkZPCv8TmgYqHS6CXAl8TwZzg+Cns07
	 Y1gBCFvi3whksQRw6tXRN0veK+bPCDSv6QNWi2ersWeMGEtcUyH/15oiSeEHcNPOmOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AN8mPvbBrt+4VShweESQST5vt3SWqtYP5HAEjvhYwc8=;
	b=1Rvl4qb8OrOUv+AdQI1pb+guHyWOLja4Vl8E3bz+k0LaRr2CQVY3Tm7cl+3E44mK0xo3
	 6Lfq6ZlQS/8HTq4I3rfq17Gwln295Jz8BwJIIv2NK24k83dKnjFxE4tlZ0vBxhFfjj1V2
	 wvxwhHJmvmxsTxo9tCjOnEZ2G1rqBRO27wS8HkBTABfPGIG9/jRGxTC1GcJuDT7XI5ZFn
	 iUcQh5mImDHt44+nSeRPI1lcbWYOK/yxj3L3IEso/WLcJAsGXYUqirmq1gmWyqRdH42Fe
	 rVErL5WdrE3L2qwqzXd2nIKxsY3aLWYSUE64CtW2TwEx/rSwniEq3k6MJYBL65nSySA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYG+gkiJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B2606A332;
	Sat,  7 Nov 2026 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYG+gkiJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280F61F0089F;
	Sat,  7 Nov 2026 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062807;
	bh=AN8mPvbBrt+4VShweESQST5vt3SWqtYP5HAEjvhYwc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYG+gkiJ424VsMCAJZlOmlDVUwyGEW/gQuNSJf6qwl9334aBJBQrilf0E1aS+gcNy
	 BtupUxILuFLGj7CDhLuGY2evW4Bip5hZ8PMptSsCSkxPRfTmJ3jVA/6EKFMUkjUUvt
	 vw1C85ABULAItqR/i4hRffEiQ4Wl7UUvR1s7EtmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marvin Lin <kflin@nuvoton.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/869] media: nuvoton: npcm-video: quiesce VCD IRQ before teardown
Date: Sat,  7 Nov 2026 08:46:30 -0500
Message-ID: <20261107134856.264017039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit ae8a4b51df30e39c07704efd5500361d8138c4d0 ]

The VCD IRQ is devm-requested, but npcm_video_remove() frees the video
object before devres releases that IRQ.  The threaded handler dereferences
video->vcd_regmap before checking VIDEO_STREAMING, so an interrupt in that
interval can access freed memory.

Request the IRQ with IRQF_NO_AUTOEN.  Enable it after starting capture and
setting VIDEO_STREAMING, and disable it first in stop_streaming().
disable_irq() waits for an in-flight threaded handler to finish, after
which stop_streaming() can mask and reset the VCD without a handler
re-enabling it.

Use vb2_video_unregister_device() during remove.  It releases the vb2
queue and calls stop_streaming() for an active stream, ensuring that the
IRQ is disabled before the video object is freed.  Do not release the queue
separately.

If streaming is never started, IRQF_NO_AUTOEN keeps the IRQ disabled
until devres releases it.

This issue was found by an in-house static analysis tool.

Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Tested-by: Marvin Lin <kflin@nuvoton.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nuvoton/npcm-video.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/nuvoton/npcm-video.c b/drivers/media/platform/nuvoton/npcm-video.c
index c4c5c318f7865..d10bda3757efe 100644
--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -120,6 +120,7 @@ struct npcm_video {
 
 	struct list_head buffers;
 	struct mutex buffer_lock; /* buffer list lock */
+	int irq;
 	unsigned long flags;
 	unsigned int sequence;
 
@@ -1486,6 +1487,7 @@ static int npcm_video_start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 
 	set_bit(VIDEO_STREAMING, &video->flags);
+	enable_irq(video->irq);
 	return 0;
 }
 
@@ -1494,6 +1496,7 @@ static void npcm_video_stop_streaming(struct vb2_queue *q)
 	struct npcm_video *video = vb2_get_drv_priv(q);
 	struct regmap *vcd = video->vcd_regmap;
 
+	disable_irq(video->irq);
 	clear_bit(VIDEO_STREAMING, &video->flags);
 	regmap_write(vcd, VCD_INTE, 0);
 	regmap_write(vcd, VCD_STAT, VCD_STAT_CLEAR);
@@ -1707,9 +1710,10 @@ static int npcm_video_init(struct npcm_video *video)
 		dev_err(dev, "Failed to find VCD IRQ\n");
 		return -ENODEV;
 	}
+	video->irq = irq;
 
 	rc = devm_request_threaded_irq(dev, irq, NULL, npcm_video_irq,
-				       IRQF_ONESHOT, DEVICE_NAME, video);
+				       IRQF_ONESHOT | IRQF_NO_AUTOEN, DEVICE_NAME, video);
 	if (rc < 0) {
 		dev_err(dev, "Failed to request IRQ %d\n", irq);
 		return rc;
@@ -1807,8 +1811,7 @@ static void npcm_video_remove(struct platform_device *pdev)
 	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
 	struct npcm_video *video = to_npcm_video(v4l2_dev);
 
-	video_unregister_device(&video->vdev);
-	vb2_queue_release(&video->queue);
+	vb2_video_unregister_device(&video->vdev);
 	v4l2_ctrl_handler_free(&video->ctrl_handler);
 	v4l2_device_unregister(v4l2_dev);
 	if (video->ece.enable)
-- 
2.53.0



