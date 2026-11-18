Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054804;
	b=UcWgMMQ/rVu+pduKlTfR40nM6TisgrIstWsBrcTbT7JArSq/C03bGQjG6tkzAmjVjk6a
	 8iNbj+2dNi4xnU1oSbnygfo2u31Y0W8Ebr0PIhU1c1OJ6FTrPoe7FuqinhD+JPD2JAdBH
	 J1sQ2pIwqz5BWTGlFHz5Myo6yOBl0c6XujHeW35CBtxWa4JFqP42NSJdFLxE5o8X9L6C3
	 GTj4TdNSQPp9UpcqNikNdDrrSJm4FfLs7vgCOjyWPp5tAHHBLx7QHB9r1t3j94SfrzQrt
	 XATSmcyZfLl5g17zmb8m3ag2HgnxRnybplgC7o3FEjWHfg5/yOAitncz9wjjGJY+l8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P8SHfBpQ2JyF+r2lNdH2hj0ep4MjF5D8edR2pV0ZQJ0=;
	b=IZbHPNy8+u+AHjb+VLaqcpIuI3h7fTzdE2IKGUxHNLua6Yjqz2JaKHKKGxmag+QBLuvO
	 +lTGV5y5Ik5qcz2oMhG1h5ygFpcbtTx7ZxCft4tcztgp+vxSB430XBmIdkjkC/zcILuui
	 nzXKdYPHfaBaSPoZrhWIAX4J6wTFghmPPMjf03zJfsZYh72PUpZAspVaqCLOk+2I5Yb4h
	 ABqvpBRSDv1WN+6gOfkK5jpSVrcmQsi9LIXjVL8C6p3vymR8YJ6TO2QvzcCUZD9hFNuzk
	 AUZdgSRV0R9sU0/a/E2+ntXqPMfBnjcIYcAwidOCPohTbc7hdXKA8Q43F3TROIDeybQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XOoybOkv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBF5606A31C;
	Thu, 19 Nov 2026 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XOoybOkv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809161F000C4;
	Thu, 19 Nov 2026 02:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054804;
	bh=P8SHfBpQ2JyF+r2lNdH2hj0ep4MjF5D8edR2pV0ZQJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOoybOkvZBqcqjpQEtUqVCInU+mEXi9ON7B6cbcaOrGRP1BpePW72+c8HaNYs11ZE
	 wjZElMUu5nD7AMZm7TVy3IOBXpwLlXcwUnmbBppKndYVB9tvC6iFrXpguApU2WIjZA
	 m4MPkny/ex5oKqE83aixbLGlNNN9yXwllkzs4eAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <maxime@cerno.tech>,
	Samuel Holland <samuel@sholland.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1404/2214] dmaengine: sun6i: Do not use virt_to_phys
Date: Wed, 18 Nov 2026 15:51:20 +0100
Message-ID: <20261118150107.445150877@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 9aa48806edb8c37e82532dbc6098b03f6bd4245e ]

This breaks on RISC-V, because dma_pool_alloc returns addresses which
are not in the linear map. Instead, plumb through the physical address
which is already known anyway.

Acked-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220424172759.33383-3-samuel@sholland.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: f472919f4c06 ("dmaengine: sun6i-dma: Fix use-after-free in error handling paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sun6i-dma.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index a075f33c1c61a..4f331c30f83ed 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -241,9 +241,7 @@ static inline void sun6i_dma_dump_com_regs(struct sun6i_dma_dev *sdev)
 static inline void sun6i_dma_dump_chan_regs(struct sun6i_dma_dev *sdev,
 					    struct sun6i_pchan *pchan)
 {
-	phys_addr_t reg = virt_to_phys(pchan->base);
-
-	dev_dbg(sdev->slave.dev, "Chan %d reg: %pa\n"
+	dev_dbg(sdev->slave.dev, "Chan %d reg:\n"
 		"\t___en(%04x): \t0x%08x\n"
 		"\tpause(%04x): \t0x%08x\n"
 		"\tstart(%04x): \t0x%08x\n"
@@ -252,7 +250,7 @@ static inline void sun6i_dma_dump_chan_regs(struct sun6i_dma_dev *sdev,
 		"\t__dst(%04x): \t0x%08x\n"
 		"\tcount(%04x): \t0x%08x\n"
 		"\t_para(%04x): \t0x%08x\n\n",
-		pchan->idx, &reg,
+		pchan->idx,
 		DMA_CHAN_ENABLE,
 		readl(pchan->base + DMA_CHAN_ENABLE),
 		DMA_CHAN_PAUSE,
@@ -387,17 +385,16 @@ static void *sun6i_dma_lli_add(struct sun6i_dma_lli *prev,
 }
 
 static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
-				      struct sun6i_dma_lli *lli)
+				      struct sun6i_dma_lli *v_lli,
+				      dma_addr_t p_lli)
 {
-	phys_addr_t p_lli = virt_to_phys(lli);
-
 	dev_dbg(chan2dev(&vchan->vc.chan),
-		"\n\tdesc:   p - %pa v - 0x%p\n"
+		"\n\tdesc:\tp - %pad v - 0x%p\n"
 		"\t\tc - 0x%08x s - 0x%08x d - 0x%08x\n"
 		"\t\tl - 0x%08x p - 0x%08x n - 0x%08x\n",
-		&p_lli, lli,
-		lli->cfg, lli->src, lli->dst,
-		lli->len, lli->para, lli->p_lli_next);
+		&p_lli, v_lli,
+		v_lli->cfg, v_lli->src, v_lli->dst,
+		v_lli->len, v_lli->para, v_lli->p_lli_next);
 }
 
 static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
@@ -447,7 +444,7 @@ static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
 	pchan->desc = to_sun6i_desc(&desc->tx);
 	pchan->done = NULL;
 
-	sun6i_dma_dump_lli(vchan, pchan->desc->v_lli);
+	sun6i_dma_dump_lli(vchan, pchan->desc->v_lli, pchan->desc->p_lli);
 
 	irq_reg = pchan->idx / DMA_IRQ_CHAN_NR;
 	irq_offset = pchan->idx % DMA_IRQ_CHAN_NR;
@@ -672,7 +669,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
 
 	sun6i_dma_lli_add(NULL, v_lli, p_lli, txd);
 
-	sun6i_dma_dump_lli(vchan, v_lli);
+	sun6i_dma_dump_lli(vchan, v_lli, p_lli);
 
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
@@ -748,14 +745,16 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 	}
 
 	dev_dbg(chan2dev(chan), "First: %pad\n", &txd->p_lli);
-	for (prev = txd->v_lli; prev; prev = prev->v_lli_next)
-		sun6i_dma_dump_lli(vchan, prev);
+	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
+	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
+		sun6i_dma_dump_lli(vchan, v_lli, p_lli);
 
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (prev = txd->v_lli; prev; prev = prev->v_lli_next)
-		dma_pool_free(sdev->pool, prev, virt_to_phys(prev));
+	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
+	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
+		dma_pool_free(sdev->pool, v_lli, p_lli);
 	kfree(txd);
 	return NULL;
 }
@@ -822,8 +821,9 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (prev = txd->v_lli; prev; prev = prev->v_lli_next)
-		dma_pool_free(sdev->pool, prev, virt_to_phys(prev));
+	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
+	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
+		dma_pool_free(sdev->pool, v_lli, p_lli);
 	kfree(txd);
 	return NULL;
 }
-- 
2.53.0



