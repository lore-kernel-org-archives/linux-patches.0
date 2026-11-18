Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035866;
	b=rU0FSJSP+EqssSSIrkX/5PQox6u70WYM7+hfmkL1kTHMWPI5sRwVNWsmxIWhtJs2Ft80
	 c4JkAK7JP+q0GjpztifQIuPrZEGOLpJAaUOYmL51AyRhOlhz5lkIrWsVeYCmMAvjDFMMV
	 yDRf2IbeVbOcpSIpnlS+sUuOlUJtLznnKDuwH0QhjWf6GxW9hrg7TnEsytGmdeNhHJav3
	 +B5pG9y7lbSkljGPDcdo1NJVVA4ITa2F84uakDNp823uCOTt8k43LbZurdxN+k2V99CxJ
	 DZH15cI1JHJ0ZnDbkOAENUUdiiFqFQ74tQKUopF3IBa0jDZGKNtCX+luXegSgoUJrMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lt6m0/1DNmFaGVVf38JszoLzDIZEGyxGBwGjPm1ZHSQ=;
	b=MIH0pHygK4mLM+wu1d0yAohD2oJ0Za0hj2iQ4uxk938ZNcAx+vRKLLEnKR6WsEuWwxH5
	 kwo/wHk1GjsdMhbRf41z9H5r9mloOq7vsz2I8azeggFlHWOEx42DxiiuCrUCeDH+oxArr
	 iNmOyPXn3Ip51DtC5w+pMda+hhg561OdYu7TycvFULnwi2GnU5C2H49MaSJ3vM25HIMmJ
	 bBLf/+IKST3IIiqIvUy6lF90iybRe7tpk8DsgH2ff0/bf3aBIbOGIIaFG1SCvtc2adxzJ
	 ZDTpeansWu9oL+2TNjtWZop8C9+3a2T1ab0djgZnqi2TMeszV8VIBfdmGOPWYeOXfBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfQIj8Ww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FF8606BE17;
	Wed, 18 Nov 2026 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfQIj8Ww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CB91F000C4;
	Wed, 18 Nov 2026 21:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035865;
	bh=lt6m0/1DNmFaGVVf38JszoLzDIZEGyxGBwGjPm1ZHSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfQIj8Wwr82ifeIjH1MTHF3M7y9MwrT06gvixKW2WU26IaE+ih53rTPVNFMWTK8Hu
	 2rELvShz03Y2ZRanqwDEKjlQ8OuwcYG31b3YdY/7wF454tk1HnyDZv0TRM92+cNbW7
	 pwC+P0gMfnJojvt0WGctSOHyr1O7gJ7uF4PimL+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0855/3318] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:24:37 +0100
Message-ID: <20261118150344.892385164@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit a5f8e3471fc20567df888267885dec3eb340eb37 ]

msgdma_probe() registers the IRQ before initializing the tasklet, lock,
and descriptor lists used by the interrupt handler. A pending interrupt
can access incomplete state during probe.

Initialize the handler state before requesting the IRQ so the interrupt
path observes ready software state.

Fixes: a85c6f1b2921 ("dmaengine: Add driver for Altera / Intel mSGDMA IP core")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260830053308.2190597-1-runyu.xiao@seu.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/altera-msgdma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index 711e3756a39a5..3632c63cce14f 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -838,11 +838,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -854,6 +849,11 @@ static int msgdma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&mdev->done_list);
 	INIT_LIST_HEAD(&mdev->free_list);
 
+	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
+			       0, dev_name(&pdev->dev), mdev);
+	if (ret)
+		return ret;
+
 	dma_dev = &mdev->dmadev;
 
 	/* Set DMA capabilities */
-- 
2.53.0



