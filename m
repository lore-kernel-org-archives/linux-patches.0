Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046955;
	b=tRFxNYsWGBzzLDcm3AK4UB4dLl/EsEX+Q8DyG2iLEdL2EFOSlZ/ERKyuIK5J6XiruGxF
	 rdlSx9HI1GQTrtCnYAGVGYhjNnj84vxlX4Q4JlLk4HyPWMG9t4Cu84DINA2QoJkt0UFQ1
	 Vr1HV0zhKdpFpwKqkJVkB8rIL0tv57TE2cYfoGDwTzIaz3jslOIr83zCTz6dJj72fIaaH
	 7PrJISBOqAVsgbIF4drI/7ArQbsEMDDgbpbHS86IaIn/GZcLy5WDiXOCFCjOaA/SoCxIp
	 TbWOyQqFijLejQbsa0DoyRU4b11eNXIE8CvgA1g3TcVVU0iL9KNXouOVnaH4B6LH22Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f76TQGSSAhDSFdJ+xNg/VcKhPBlSWm1DB3nRBt/cXo0=;
	b=wX7HKjOV9MojsbBG6uBsOMapQ4wADYOE1cEdMVdubtl4DegI7WIIYFUNsT4buTjyubtp
	 825afIsMKklwTA5hVpuXyjqMTZjfs1OGe/58Fd+E1smin8iyg82Kwzr6wBUcPKm5CiaG1
	 XJCZWZzTdtv5snGmbNwUpMfF613arF4jkpbjVqCABvzFqPaRd3xc2+7pqk+9TgfWOQHZK
	 kGMLCtBNlliX1ftNpw4YNJjMci6oBnogJOUQHsKgpWZmO2aFI5malwEaaYso8Ec2hQqQp
	 bCm5N/i3MJJVoFQrGq4J0BG0ylKKWVaB88dF8Q5guy0afFp6Go3A0rCoIDK2OXmA7Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5ambWzq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A61606A31C;
	Thu, 19 Nov 2026 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5ambWzq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909701F000C8;
	Thu, 19 Nov 2026 00:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046955;
	bh=f76TQGSSAhDSFdJ+xNg/VcKhPBlSWm1DB3nRBt/cXo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5ambWzqWWcm4FD696sVoOxhFjm7gZL5seOSj8dwnqcUu9iVCfU4JBRXLbQzzuPln
	 ItGlWsR7jo0u3sUUa0o7acAk4+oN9nHl26iPCb5L/H7Pz3SpT3vK+VBsgvBZiYHaW1
	 cl8niDQ1foQ3zIUD+P6UVj6o4ElT6+p+6pgn8MDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1425/2857] dmaengine: qcom: bam_dma: free interrupt before the clock in error path
Date: Wed, 18 Nov 2026 15:40:59 +0100
Message-ID: <20261118150252.628646476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a8cf834867353..d2fc5a6f8c6aa 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1324,8 +1324,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_NONE, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_NONE,
+			  "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1334,7 +1334,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_set_max_seg_size(bdev->common.dev, BAM_FIFO_SIZE);
 	if (ret) {
 		dev_err(bdev->dev, "cannot set maximum segment size\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	platform_set_drvdata(pdev, bdev);
@@ -1362,7 +1362,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1381,6 +1381,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1406,7 +1408,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
+	free_irq(bdev->irq, bdev);
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
-- 
2.53.0



