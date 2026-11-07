Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061960;
	b=cM7dp6avyWBKSwA+aGJGwGFoWlS2Py6s93J5240dBDseQ0G3trBJ6pl5HUlHJA2wC1vT
	 M2aj0XTKSkvp9UJ5LKfrY+MKVgY8FU+ycmoWgLq9XBSRrMTRvhoWwvnxSviezZ6cTD21x
	 1qRnfsfMRQWaSJI9xEz9iiLDEHvoHwfBLO7FYx7osxytsN57R31DN1YSJLboFSn/PrqmS
	 AtwqTE7ASZI3PXlR81CnUaUCqziHZOm+aUT6OXSHWePYBguPMhmDbUQtfcXi+eH9J9VpV
	 UYZEaG2Ivv9dgTm13r1tXUthg+mVYorZKoCXSSi12zmwdgtg4+qcubF1+aloF3JtXng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kRRK/2VRkUZpyX2+9FOSLUeN4KipoAiTMKReTxPPaHU=;
	b=C77EVRx/N9x12TmqfY/wiaRFPF/Iz7mpplntL5wmTlmyjnqnNOZl5AULlqUQdvi41z35
	 CL7/WBey8oEq2R+igTTzC408Lq8ImLODRsd43mHG+N/9NM0dD+DwpWHFOjppcKZbSgWpl
	 m6Dvt34Ravmc5OagEcih9Cc1EiNEOvedYMfPYS4Nj8RsOxwGg7GZVsII3HX2JWHXE0Mvw
	 Mv8//tbctuo8Je5hrLkx6s1DggrOnc1gTTf1ZlcLX2k5HRwEhdgbAwk06usqnj2E51AjL
	 DyJvbBxXU6pFU0+kdrg7gaxIBYvYbkQN5oT6WUJuRDc93VWLq0+BOkYG+mstZYmhbvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5IAwj1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E85606A330;
	Sat,  7 Nov 2026 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5IAwj1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12F81F0089F;
	Sat,  7 Nov 2026 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061960;
	bh=kRRK/2VRkUZpyX2+9FOSLUeN4KipoAiTMKReTxPPaHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5IAwj1yqUTBgKOFx+MZA+ppkz2Burnbw5tQxof6l6+O20OgG1bzLa7ttd6jd8p87
	 wBhyMF1PG/CDyUCLhkuTC5fcUq7kcF/Vl6Dt93Y+Y4tj32Qg5TxhWDX9nV7NGhD7st
	 lQVQhVur51vQ4Td/DZce3NPb106RyMy/PI/CMHbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marvin Lin <kflin@nuvoton.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0958/1536] media: nuvoton: npcm-video: quiesce VCD IRQ before teardown
Date: Sat,  7 Nov 2026 08:49:34 -0500
Message-ID: <20261107135024.559051423@linuxfoundation.org>
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
index 399401cfbc0fb..919a73b1ce496 100644
--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -120,6 +120,7 @@ struct npcm_video {
 
 	struct list_head buffers;
 	struct mutex buffer_lock; /* buffer list lock */
+	int irq;
 	unsigned long flags;
 	unsigned int sequence;
 
@@ -1483,6 +1484,7 @@ static int npcm_video_start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 
 	set_bit(VIDEO_STREAMING, &video->flags);
+	enable_irq(video->irq);
 	return 0;
 }
 
@@ -1491,6 +1493,7 @@ static void npcm_video_stop_streaming(struct vb2_queue *q)
 	struct npcm_video *video = vb2_get_drv_priv(q);
 	struct regmap *vcd = video->vcd_regmap;
 
+	disable_irq(video->irq);
 	clear_bit(VIDEO_STREAMING, &video->flags);
 	regmap_write(vcd, VCD_INTE, 0);
 	regmap_write(vcd, VCD_STAT, VCD_STAT_CLEAR);
@@ -1706,9 +1709,10 @@ static int npcm_video_init(struct npcm_video *video)
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
@@ -1806,8 +1810,7 @@ static void npcm_video_remove(struct platform_device *pdev)
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



