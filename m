Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038271;
	b=Xkz9Nb/ev/1ZmFFY79kAZJoW8ZRTqs/Cu1EqLW8PiKiHSjCneY1gQrXtVX1+63gBOzSh
	 hIlezo5oJDrExiKEyjPjmgHS90UPIhzLDovZ2yn/5kz0Ekfb3Cq5min8Hwlhty5Xy0yP9
	 C9ypLD9vIMgj5xdXlqanurbwgSwH8nebALKdvReiswBA8s7PZSRq2mnvFnSOH+mb1SYGd
	 P/GjvIDXkyRTE6EZ0MFXMiyWzjvh42OnXIxeMoC6XfMBdAUJka4m6jnkYQiV4OXMIvdRZ
	 syu4SxbecsoOUmyyWimRsM324bWMpfj2ah3CRKXkDzCXznYv+Q4r//JHVgrZmVBxa3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lXm6xmT0+Ifuj1e417ZB4RrAPhLY45CowLyiyA+CKyE=;
	b=eQ/V8P1OFSRz25mDqo74H9+zfMpCGzH75ei7WhT/4V1z6utJW+oDJMRwjiv5NQDMEF4F
	 GWDB85d8R5kE3Bb86aYROvwUFv+MiMS4RSjFg9MHBrkC9g3/YDSV6EfxNm7+04Ls0Qnb8
	 Pu6Mrw7dtd0WQ8zBtty6124Z0dyWzkgD8Fxjqa/w5Yg6tUatzGiO0qFQScavt7PNythOl
	 8CbD4J7gRbz8iEIr6qA3QMCD7FnUIr9T+UllekoiFWJbWMzI1ot6bateq7/sdH9hBOjV4
	 Rv1gQRqqFuE7YLV226SGrJNHPafBUUxfpxdcOyhOdt47Lroq88tO5Kpe+dNZBjAK9aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTTtk+vS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A87606A320;
	Wed, 18 Nov 2026 21:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTTtk+vS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6841F000C4;
	Wed, 18 Nov 2026 21:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038271;
	bh=lXm6xmT0+Ifuj1e417ZB4RrAPhLY45CowLyiyA+CKyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTTtk+vS7net/f5WpeOzofQ6ntnqjwWbQ6HmhYPe3UTKyf3g6UfGTHQ0h9d9guvqD
	 8bnnYEXSNYy+6Q0Rh8UzOUrMJuPXHrtlg8OClweNsmMGZnYWSM0e6vyzwys/Id2vTg
	 zJjzXjtTClv2M17Yvj+SbGEmP+t1RBRylENNNh18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1685/3318] dmaengine: qcom: bam_dma: free interrupt before the clock in error path
Date: Wed, 18 Nov 2026 15:38:27 +0100
Message-ID: <20261118150412.369296464@linuxfoundation.org>
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
index 03638e4f505ca..5955d92498861 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1322,8 +1322,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_NONE, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_NONE,
+			  "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1332,7 +1332,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_set_max_seg_size(bdev->common.dev, BAM_FIFO_SIZE);
 	if (ret) {
 		dev_err(bdev->dev, "cannot set maximum segment size\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	platform_set_drvdata(pdev, bdev);
@@ -1360,7 +1360,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1379,6 +1379,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1404,7 +1406,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
+	free_irq(bdev->irq, bdev);
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
-- 
2.53.0



