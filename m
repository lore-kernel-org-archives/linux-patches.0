Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053763;
	b=K0pdpJV7YAnZNLz25gBJ13+/4VsIYL55WlnY/ckI0ZsWMkXLfmE/cgD+azlmSR0zsXpK
	 InG40qQmn3zDVyMcWEKrHp02bzPWZXMZZCf8vSEMPNWK9xnbqEDkutvQCgOf/vDAQ7jUm
	 YX3KqcZfHRiWcSUYHimdoH5U+12/zJPDn5rwEPuu0Wu2nu7pH7LblpPK2fjBZfXZIkyBJ
	 aZwrnmF7xkUAFW7FQzQyQsrQ4YxRJaXmtiJChoKIeFnT4L/T7SYZ8GYiRCmnJDpfN0b6a
	 IdyfWPNDFGpKlJQck0A5suDiKxl/cuL3Uov8dPSNkGWBbLFUNQgP4z2lwPlY7DAfxug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lu6uLz6tdVaU/y62FsE2NV4uf0sU5mnbztAlhNWE6U8=;
	b=nG1rWLKGvPStZFcthBqx113OTBgfEgcSdG2F7uGui53xTQgHSfMncxg60y5CtH+FQiNE
	 upc/S7K7OM6p+ztsZQFI2gN5XVjdR8QPpEdfVjYixwi+Lj4q1u7Bj47F3Cf2sg61ER3+w
	 FRk3+HIe9C9PS5mtys/+rGyIS+iZnOr9z2s2ZO0hK4jfiVYfLavhkPcjNM6B0QC2paR4C
	 JQ7aao19RpskhK3HmmcjzA2Ie3kDnXOH5i3uLm4jMHwZZHH3DbLNUfNwxhigyEPj1sVtZ
	 dUQmGu8zDt60GDpnqRt0IA3as1nCbJcWiYdukjrqMlnQCKPT0vhIZ1DVCNAlqfJJ5Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPQOU34d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A3E606A31C;
	Thu, 19 Nov 2026 02:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPQOU34d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2691F000C4;
	Thu, 19 Nov 2026 02:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053763;
	bh=Lu6uLz6tdVaU/y62FsE2NV4uf0sU5mnbztAlhNWE6U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPQOU34dl9pD+zOj0JL7z5Cm/3knIM06f02d/Mkc9FanHrFWZx643woC2wbSYg0cP
	 gLD2E/gjqHwYMvs1rLUMkQOm6cBQ6wJUtQtL2z5+iAPjfjoewii85y6zwj9TlXoGgk
	 GD5fVNCOc+dZkzPuNA4+IqvPRojlvKvy/HaWKjf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1035/2214] dmaengine: qcom: bam_dma: free interrupt before the clock in error path
Date: Wed, 18 Nov 2026 15:45:11 +0100
Message-ID: <20261118150053.775429735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 91a0669881c9c..5bce8e193156c 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1300,8 +1300,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_NONE, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_NONE,
+			  "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1310,7 +1310,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_set_max_seg_size(bdev->common.dev, BAM_FIFO_SIZE);
 	if (ret) {
 		dev_err(bdev->dev, "cannot set maximum segment size\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	platform_set_drvdata(pdev, bdev);
@@ -1338,7 +1338,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1357,6 +1357,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1382,7 +1384,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
+	free_irq(bdev->irq, bdev);
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
-- 
2.53.0



