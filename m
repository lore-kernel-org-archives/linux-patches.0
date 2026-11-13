Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585907;
	b=Zg+QWwu1BBqQynkBc6MKYpULsnVMUAgXupnsIHA+WEljDzLgzteSsJI7onRsvzBFmUsg
	 bTIj+vJhZL1HyUK1jHTqSUXg7qttVjvM2hC3Mp03wnUYD2xPnfov01sEK2KFapqjCLoch
	 hySs4g10i/bG9PvRUWkLU6NcJNoW3o4rclqyVdO0yr45IPksA2oWRGTYaOUTvY5X0QqA7
	 3KffG7L9TWmqE9/3XtsA77CQwWgJ/hwa5vZsmytk0H+EderSbg9ZA3/C+cBKi2F1RuioR
	 Aaa50ytUF3/vwdIfdyYBdrvIAIjmflqwhzmSKq7sWcqhbwaAc13ONP8Go44rZhl+gzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2lm1lBdJSXqgpMsSi4K0/9lkzUJnGjiZqwkxHk+PvGY=;
	b=e2a3fX3unXcQp3v0Zrku9vbXbjCMQY6JpU4kFkMMZo9zxCj46jm3UubKU7W1npdWz8iL
	 B+CgjKNTnHr87KmvKToOMIpJAVb6ipB0aRJAWcA7zmcE+SKAOG1EoY04ncjKIFiuDEFy4
	 JqyjIJO6+way4RI0BSLYkg81UOiEh5DYQoDI/glVYYTKWPxTEmCQtQMozgnhnWQr5axBg
	 Ar/D2oUlft6L/48qB0r9ZOeJQI5BDvcIpLNc8u9Vcdwdjn88gqt7Sen2S45YH9kznr6gG
	 /u0/lRwuaSKt7W1AUgoXcUCUJOnNOSwKhbpThoEHoabDXUf02518vk+pZ7UmMBGpgKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUrpk6V7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8DC6076226;
	Fri, 13 Nov 2026 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUrpk6V7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B5D1F01833;
	Fri, 13 Nov 2026 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585907;
	bh=2lm1lBdJSXqgpMsSi4K0/9lkzUJnGjiZqwkxHk+PvGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUrpk6V76/q2YvPv/u4onlSOAXgroqAk00wqL1AgxStZ2iSUEbjExgZhxPeJ4bATs
	 t1zs1WZTRr9fDa9q7AmVK+UGbW+YY3Z3W8Xs/W37vkM0dwtT+WDtVAA+65BZfnbWW1
	 tWzLepwIU4Xedfi33vh+2kk8iHgviiimq2vwOYUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 472/507] dmaengine: qcom: bam_dma: free interrupt before the clock in error path
Date: Fri, 13 Nov 2026 10:52:56 -0500
Message-ID: <20261113153812.845638435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/bam_dma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 94cb957d4b187..f67a93a37d48c 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1332,8 +1332,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_NONE, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_NONE,
+			  "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1366,7 +1366,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1385,6 +1385,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1410,7 +1412,7 @@ static void bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
+	free_irq(bdev->irq, bdev);
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
-- 
2.53.0



