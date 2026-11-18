Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030906;
	b=Ujgrj8eeO4Yd0R1fBQG6AQ/fpJeVPlSrqGuy7cBauiNbxfrFaVkMu8466oqDNNwOHF2r
	 xFCk/LKd/sI5EEz/e2raT/cwEiqHW56IgI1olu/L/7o0g1TnSJTs6Na2ZBu6qun9o8/I4
	 LrS+vMFNEQ3htkO5LEVnjCaxZ4smc65CoHmhH6Cft0rjbJONRALDiMaipOSMT5VIBnNT7
	 xPT5BEI60KrvW7Fequz3sMyLhtpilFyV4gXay9DCDipd+jbXw5vO2Z1D1gVdCSNs5TxYv
	 Ec8Sesm8vHGzjWIAYcSSCqIqSa6n/1Rww+GK68R2VC8Q2fdgLKMWJHS27dzNcc9HS8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/mLqGUSgvsQzoLI39aIv2yGNERt2S8bTNHVdg22lMH4=;
	b=B8DSZlN9buHjTBsFoj9UQodTXDjXvDf/9hIofjkM1XLPNPjGFcWH0Rx1McQUXB9Yiw/q
	 uTbbBp9B/CmQY/5F0N58t4PJno/78HfLHKaqtRQ1KS5xCJXUs0JtGWdZ2QEoq/oY/jnB6
	 XMapWVqjiw8qPvTt6G4PhUMLqOpsS6Y+wUfGX0V+xu+o32whyLkeZpboHsq0gYDH6yJ45
	 Zv6O+WUQR1EaNocblH4PizUCd/ib0ac3KtNBa+SBiVF84AQ20V7WEPmnIGiCcid8AcEaj
	 CxaM9GxTb7hgDItI8tooinnmn5CfiLlT5pv6jQXxhfkjvc7Z9Bl61Vj3I6sXqR86/6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIMyPGRO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CFB606DD30;
	Wed, 18 Nov 2026 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIMyPGRO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A300D1F000C4;
	Wed, 18 Nov 2026 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030906;
	bh=/mLqGUSgvsQzoLI39aIv2yGNERt2S8bTNHVdg22lMH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIMyPGROObuqn5HOI8pC2/nkZC/DeZjgKcUVsE9noy5qqqs9w9qfPOGx+4sdcU3Up
	 5guupmlOY6YB3rA8HGBKdBGUWb30yktjXQin8JfWXF5VLp486o2V1KmVQwK3ouPK6F
	 uwmCFM3vmHuMRT0DYQsiqd3XHJAldlXoENFkjQIo=
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
Subject: [PATCH 6.12 0869/1756] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:49:56 +0100
Message-ID: <20261118150043.896176455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



