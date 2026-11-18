Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059505;
	b=MrPTYBtAVUEZfUo2q/AwypPxKmeZC9sGungFePUqfZc2Mx7oFQOGr0Og/4FnYNw7Z30Q
	 ddPb034PVJq8IzaCFVYKX7CTaRyG/KfqCko55mRt3rENioVNYhLrFTpz2QjNqGiwXD828
	 pe7Ev5j95mGzlihREGo+5xJaGoB82NXPy9OXO27z4V9NijSvRZDu9qejHh9DB67+jH+1a
	 M7Wc7mZXk7tOK2Lb9oKYQviYZ/VvzzYJyfMr/sCHLOzE0m8oowhUg3lAPJH2TS2GUdqSk
	 BnIjgjrOQY3Fv+xE+ZUhEXoeQ5QcZcbWn/qnrnUFe0uThsogrXOtG9t5oFDdWNV2fOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eOJB5GrCVJreRUIPqKYGfyVFoxuc4B5xHipF44r+EuA=;
	b=cRqQ44IyYUNkZWt4P05rWQxa2Q6pZ7IJbsHTXYZ9jfS7HOHM5UXFmAg4UpjW2dhYVWhh
	 QGSema0slHjc1dntPDEa9a+swKaq0VEt+0jwSB8VnskWFffg8jFh2YPgtS8DAt+EAaAgf
	 XOP2NQOMeRuU6UVHyLwhVDaqpB3UrVHESjtGqoRQ05vJJ/WkcigMG+YGKiuWvG8MpgEgC
	 nOWFkiLuse/aXjmbOK8s7Tdg+KBjHAKsktNBV4/QMYOl/tsK1G1hipXYtrWiwhIvMxGZF
	 276egyfrB0n11BdAsUceR9D95Wrr78+EBYsEmgKxhX9w+9bG65qyQ6p08XWsHhK1GSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnf3BsFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A55606A325;
	Thu, 19 Nov 2026 03:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnf3BsFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365C51F000C4;
	Thu, 19 Nov 2026 03:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059505;
	bh=eOJB5GrCVJreRUIPqKYGfyVFoxuc4B5xHipF44r+EuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnf3BsFD0eQ0qcsuIjTuQFw08vUS73WZyLaUWnnam5rOgyEPPbDGQfHUQCG2o51KA
	 QK/HFSNw4MeV95esjAbJmmkKcicY4g4wOb00YY9lWeORhPK5Ebh3ohP0ANj+hH5Mt+
	 kWMXdEvijmQ8fjLcCS/zPwN2wekcEsOM3ucP54g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0866/1848] dmaengine: qcom: bam_dma: free interrupt before the clock in error path
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118145952.728410278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 82eed160cfa7a296ae4eb5acb8dd8f493323eea7 ]

The BAM interrupt is requested with a devres helper and so on error it's
freed after probe() returns. We disable the clock before freeing or
masking it so it may still fire and we may end up reading BAM registers
with clock disabled.

Stop using devres for interrupts as we free it in remove() manually
anyway. Add an appropriate label and free the interrupt before disabling
the clock in error path and in remove().

Cc: stable@vger.kernel.org
Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=2
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261008-bam-dma-free-irq-v28-1-5e5b10de441e@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ sashal: also free the IRQ when dma_set_max_seg_size() fails, a check upstream no longer has ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/bam_dma.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index f931f074dcdb8..cc6b58162a275 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1312,8 +1312,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_NONE, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_NONE,
+			  "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1322,7 +1322,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_set_max_seg_size(bdev->common.dev, BAM_FIFO_SIZE);
 	if (ret) {
 		dev_err(bdev->dev, "cannot set maximum segment size\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	platform_set_drvdata(pdev, bdev);
@@ -1350,7 +1350,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1374,6 +1374,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1399,7 +1401,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
+	free_irq(bdev->irq, bdev);
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
-- 
2.53.0



