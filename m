Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040814;
	b=OoviWRY/x5ybO4UDMnre662kLOjsLUJcGc/7G6wVGUN7geXzv/0Qv/CWe+7xk/8/jP5F
	 Nx4IqnFcMPhDToGUQAg0lst5veXKUlHJWY3ChS7AMqEs/gfej3M5VZtzwi3RKgPsMkfZ/
	 KNrKmf7rrg+dgX8Q2KGIpu1xjtkZQnToYWYxoEDEjxdBpthEXK4fpBmYBRXMNcWFpUDJZ
	 YmRunRnBXdOG5WEaXWU7xXq5xwkDJulnGY8+Z2uEAGLqFSQZstFCAFkRprZkKC1VqN5UQ
	 4yBopIvIgBRorwH43r+XxKrjCjtmoD09ibGRa6w6XZZ74EO1h9+enMT3Lt7Wj1zsVNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0p9W8gLOoLWriSRnl/Q6vbcqOpTLdLjQ4rFs+QbIL0=;
	b=iURv0RXMElGKPrHtNrYGaUUjJw1162Ov1jbWVYDOoD3TThD+1PkNAijeFhvAG/KE1axN
	 Q9jtzJqLOfR4a7r91RCDjM/9tm97KMu4AT3pLJ8Dobr/1hh5TjN2P9qJHLVxAqxf0pus/
	 lhoXTMRgOi3nZs6an7K6FIcc5uLJyAE68d7/npTx6SkxOcvo/6Ymn3He3g5YL/8t9fAz3
	 kIkV0e5ZU2HbbYoa9AbGKxZwQlN63qIrWNUiJIbK749rd4epMpDzzruwIdU/ypc9/raxr
	 xmVazjAw/xPulrpvWdhplH1it+rdpKtqXyEwkgW3AlX4/nrc4J4TrqZ18WVjxpYL4EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rb4jxaLy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3AD606A320;
	Wed, 18 Nov 2026 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rb4jxaLy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ACA1F000C4;
	Wed, 18 Nov 2026 22:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040814;
	bh=O0p9W8gLOoLWriSRnl/Q6vbcqOpTLdLjQ4rFs+QbIL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rb4jxaLyNIRLLt6DPXv7SeGAndXimjB2E79VDotJNrgGNt0sFzA/DCycFpEJtis4P
	 TkJebVDDkF6VZg88XYaphq6lHSsWzbeZMbRmONFdmMj4BD/J57yNfprnep5Ae4jAQ2
	 eoZH/CDChnVDuJU5GeEHxyIpxcjWYdi2L4VdV70Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2592/3318] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:53:34 +0100
Message-ID: <20261118150438.935169027@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit f3017892457d8bb664ea4b912910dc254e2dd825 ]

plx_dma_create() registered the interrupt handler with request_irq()
before initializing plxdev->bar. If the device raised an interrupt in
that window, plx_dma_isr() would dereference the still-NULL bar.

Move the bar assignment ahead of request_irq() so everything the
handler can touch is initialized before it can run.

Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Link: https://lore.kernel.org/all/20260610112121.676561-1-jjy600901@snu.ac.kr
Fixes: c2dbcaa8c672 ("dmaengine: plx-dma: Implement hardware initialization and cleanup")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/all/20260610112121.676561-1-jjy600901@snu.ac.kr/T/#u
Link: https://patch.msgid.link/20260902062153.31048-11-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/plx_dma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/plx_dma.c b/drivers/dma/plx_dma.c
index 34b6416c3287e..5e98a8509aa46 100644
--- a/drivers/dma/plx_dma.c
+++ b/drivers/dma/plx_dma.c
@@ -505,17 +505,17 @@ static int plx_dma_create(struct pci_dev *pdev)
 	if (!plxdev)
 		return -ENOMEM;
 
-	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
-			 KBUILD_MODNAME, plxdev);
-	if (rc)
-		goto free_plx;
-
 	spin_lock_init(&plxdev->ring_lock);
 	tasklet_setup(&plxdev->desc_task, plx_dma_desc_task);
 
 	RCU_INIT_POINTER(plxdev->pdev, pdev);
 	plxdev->bar = pcim_iomap_table(pdev)[0];
 
+	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
+			 KBUILD_MODNAME, plxdev);
+	if (rc)
+		goto free_plx;
+
 	dma = &plxdev->dma_dev;
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
-- 
2.53.0



