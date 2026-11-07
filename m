Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063930;
	b=viPnTX97OXsh+QNTtFM8uK6cz/RpdBaheV3idlYeChkCQqRy406zRIMoTPNmDZkKEHVb
	 vXQ0RgCtr9T4mbEdZ9JZYV8K69Sj59Cp6TrTHkpnrpogfnOgenI8BPupf9FGbtMuhmqfw
	 OfhxC509AwfnqFQwJ6yy2GHLDFaGNCsVrgYzRkc6k/jv3fkR+3Xo8w0XY/DhKFDvFeJgj
	 rTwhaLnKZIMgCvdusSG7NQYyQ1BnVBFYMzXQByFC9arjXRb8yuOC+DpJavEcEfBKU/dmc
	 Unw+Hr3DbXfjveaz8UBK/PmcfQDoVBBflQcBu6d2BlVUQTc8NJnVfZuOF0gLiYGCyCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8s9cJRPSOHFQ4cV6NtFwotQr4IL+lgXlZ9h9piYlLU=;
	b=MrrzBvWhjCxdNkdArv9yB+47IRTlj0M77g0fCW68bNXCu0IvOQzyBnIhdrXw88swSIFO
	 L+M/AB+Kks+NdMWPCWhtEziPwH1b/P47RWD0MUlPbQA3XfeSYtMFp54PoGfYTzvZlhDok
	 IHBEqwAgEFvSV+taCkT8aYVR3jgEGPrtmPdRFQIkltIJGB2uPJGgPiMXoPTzT/f8OVKtc
	 AUKpoub94N9Dpb1B+flyP9B5/w6JUz4OtgXaEb2Z7XHr2nuxkmFsfN6l14ZbgXXIUcmAL
	 hJuRQXqflc7yV9Qsz1l11H8RM6Ky3tdOOVdPCHnAweG2glPxpfa1BuchPi5VpiLwciQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gUn1/3kk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80537606EEB3;
	Sat,  7 Nov 2026 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUn1/3kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1F41F0089F;
	Sat,  7 Nov 2026 15:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063930;
	bh=m8s9cJRPSOHFQ4cV6NtFwotQr4IL+lgXlZ9h9piYlLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUn1/3kk5/l2bLWOgbLiYJngBevI2TmZzlIEMu6cyLYr8sD+WIS+v5kGV6klYdF74
	 AG8ukniqr4Rvjb8xcRVhaRJpM9gyjHKWvs+IaayV3pV725WMWW1QKr3bIE8J1fiQUD
	 d+fEm+3MfrXk588Sz3Zw76sDzRJOy2NArrTJLUgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marvin Lin <kflin@nuvoton.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0123/1257] media: nuvoton: npcm-video: quiesce VCD IRQ before teardown
Date: Sat,  7 Nov 2026 08:40:19 -0500
Message-ID: <20261107134942.727076015@linuxfoundation.org>
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
index 52505af35c087..c28d9d7edd834 100644
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



