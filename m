Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052336;
	b=psML0g6R6dUCTn4Occt4dwNXpoF604RONVCvAgolssEEnj5MwfMw7iwTESGuvVECEHgs
	 qvy5tKmPjGUB9u7FZ6oBNV7NKqQd4gyBn8WOzR9XeYHSa/qEUVU6lcGn+sAL8XZPalGxW
	 QcHEsASkRS+GczsL9cbOyY5jV4RC1TBJk1jZXL8qLHUg7ue7WlBmZFl3rXiLSJcYGI5im
	 7cmCL5DdsbAFLzwJ4w3dOdPlfJZDHSTR8DJsWxXyQeIe6+/ZRBZcB2wLKCN8aZga+OXPV
	 EdCvUu9wCQKmbOGsLNcsrKuF3+wQsnEyjZTHRoj6vgocRo3gqjJs+sCQUvoMzIYKrxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3jPDsY0fsCEg7HnHzWwH14w6Dqbh6u8b3vgnIKVP7b4=;
	b=r/Fqqgjko3+zAr+doJpOVyIlNPA3VNQGS2d1nWELVBTVnz9+ZbpdfvzowW7SoWlGdQmU
	 HN+aveRVB28n/5jTvAeRc06PrQDzb6Deiwd3LD2qxTk5niciR+rUe1TAFFsB+YwmC4HVK
	 48edQ1tAMgt76iyvVohSCLs1aUU9B0AAw+1riLDovrWoRWVur+J/Gacn3d+genOHhHXam
	 PUYYkeK3fbSC0TriLLhHrp/uPtjaFbMiak86P353mKCTZpnfZMUXO8NlV4/c02f3pFbFr
	 i/vRGdjy1jKP/WCguXcMD59Vo7WXXW+kNvQpQc5ZA2P5oGNTNUr+TlbDFkFMrihfpjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jir0g0pd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346CB606A339;
	Thu, 19 Nov 2026 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jir0g0pd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BB61F000CD;
	Thu, 19 Nov 2026 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052336;
	bh=3jPDsY0fsCEg7HnHzWwH14w6Dqbh6u8b3vgnIKVP7b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jir0g0pd2TkBn5eJDUwzfjM3HLBuDDCB6hQheP4cPMDIpfwg0zGkBYXUQiYw3Onds
	 F/P2hZ7Zhxf3tgedj7OyK/XzAPgyC88nkh/zt3t1/FMKQ/F9vIqcEx+3bUIozo0aIg
	 DgEsEQ9PtTOavzj0Bajp1mEpHUazchT4HEQo0SFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0477/2214] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118150030.246885034@linuxfoundation.org>
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
index 5a2c7573b6927..d2413effc49e0 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -841,11 +841,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -857,6 +852,11 @@ static int msgdma_probe(struct platform_device *pdev)
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



