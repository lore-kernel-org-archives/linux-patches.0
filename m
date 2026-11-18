Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042610;
	b=ZTDSnp8l8DxAAiIeUyUJzag3fiSLFaqmG8D2R8dtFwLrFZaVG157ihx8ji7zejeKSa72
	 O8KE8esLRYYXNZhXnavpQo5FU5jN5GSHovJupEd8vlJCY1hMp6N84INlAIOJFliznSu9q
	 tQ8WxdR/oO2Zx2yjhUORnLYUetC+CYbAD5l4VGnMP9zEaQDu8VnbLk+kfzPoeOW7LlB+L
	 55dE0HG977Ft/frlDTVY++QpKQM1EaAXK3wGtX47a0RdRdxoQmYaxXiIEwO047PG94dL5
	 4tDyvWbKd44hIpciih0GAJmYIbAJrcz3FZZb34KDRTs3bdLesOT04E9bWhS9so+EoMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jlC/PBOVr+RPlH74Cl2UH+4VeHTgetOk4roqwjk70E4=;
	b=zzhXgaArXmrFFP0o3To9c60AF390gz5Reur70nZJ8J9Kf46QAL9X2lsYtjr06egzyEsf
	 obyN9SiUiTcq2k+ufCyvC1/J3it5L36CexPIlcc2UVGsuo230a3zvTeNhgTf8ryXhFeop
	 QPUFViAGcrWDDBb3n6NwgGfaGeloZOFFQFBYqpQKhkEDtFYge29WkY+Jbi6WS1lBm0TtB
	 GOMkmSuBAlt8gozt/zLsf1wyqK3WNBI70V3aLoFSV5uuGgYxw++fFx9c4PSia4H3bEzCS
	 4NVBwNmooHguVx5S2Sv591iFxOPoJPhqxuCWCP52iyTs0Mhw4Q5NaLi+OffESqDNhpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BntyPA39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24A5606A31C;
	Wed, 18 Nov 2026 22:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BntyPA39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015D91F000C4;
	Wed, 18 Nov 2026 22:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042610;
	bh=jlC/PBOVr+RPlH74Cl2UH+4VeHTgetOk4roqwjk70E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BntyPA39Ro1Pdlc5wTWHzPPe+y83lAd17RMD366RQ4Eh1kpfRlCGdihJpgRO9f2v7
	 sJznek6z8G5SaUrY5ae2BkDyqksCxhq8OqucmecOALIb7MyHjgxJ5hGz1N1Y6qjKO+
	 QrsziXA9lbHHwjLiIw8+Dgzly1+LJ7/tI+770I2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3231/3318] net: bcmgenet: introduce bcmgenet_[r|t]dma_disable
Date: Wed, 18 Nov 2026 16:04:13 +0100
Message-ID: <20261118150456.637706143@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 791f349d02f73aa5c11e84994447adcaf76a92a4 ]

The bcmgenet_rdma_disable and bcmgenet_tdma_disable functions
are introduced to provide a common method for disabling each
dma and the code is simplified.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-11-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c1f51c3ee9c ("net: bcmgenet: recover from a failed resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 123 +++++++++---------
 1 file changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 1c59b5fde7175..53927c18295d8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2798,6 +2798,52 @@ static void bcmgenet_fini_tx_napi(struct bcmgenet_priv *priv)
 	}
 }
 
+static int bcmgenet_tdma_disable(struct bcmgenet_priv *priv)
+{
+	int timeout = 0;
+	u32 reg, mask;
+
+	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
+	mask = (1 << (priv->hw_params->tx_queues + 1)) - 1;
+	mask = (mask << DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	reg &= ~mask;
+	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
+
+	/* Check DMA status register to confirm DMA is disabled */
+	while (timeout++ < DMA_TIMEOUT_VAL) {
+		reg = bcmgenet_tdma_readl(priv, DMA_STATUS);
+		if ((reg & mask) == mask)
+			return 0;
+
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int bcmgenet_rdma_disable(struct bcmgenet_priv *priv)
+{
+	int timeout = 0;
+	u32 reg, mask;
+
+	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
+	mask = (1 << (priv->hw_params->rx_queues + 1)) - 1;
+	mask = (mask << DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	reg &= ~mask;
+	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
+
+	/* Check DMA status register to confirm DMA is disabled */
+	while (timeout++ < DMA_TIMEOUT_VAL) {
+		reg = bcmgenet_rdma_readl(priv, DMA_STATUS);
+		if ((reg & mask) == mask)
+			return 0;
+
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
 /* Initialize Tx queues
  *
  * Queues 1-4 are the priority queues, each one has 32 descriptors.
@@ -2920,26 +2966,9 @@ static int bcmgenet_init_rx_queues(struct net_device *dev)
 static int bcmgenet_dma_teardown(struct bcmgenet_priv *priv)
 {
 	int ret = 0;
-	int timeout = 0;
-	u32 reg;
-	u32 dma_ctrl;
-	int i;
 
 	/* Disable TDMA to stop add more frames in TX DMA */
-	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	reg &= ~DMA_EN;
-	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
-
-	/* Check TDMA status register to confirm TDMA is disabled */
-	while (timeout++ < DMA_TIMEOUT_VAL) {
-		reg = bcmgenet_tdma_readl(priv, DMA_STATUS);
-		if (reg & DMA_DISABLED)
-			break;
-
-		udelay(1);
-	}
-
-	if (timeout == DMA_TIMEOUT_VAL) {
+	if (-ETIMEDOUT == bcmgenet_tdma_disable(priv)) {
 		netdev_warn(priv->dev, "Timed out while disabling TX DMA\n");
 		ret = -ETIMEDOUT;
 	}
@@ -2948,39 +2977,11 @@ static int bcmgenet_dma_teardown(struct bcmgenet_priv *priv)
 	usleep_range(10000, 20000);
 
 	/* Disable RDMA */
-	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	reg &= ~DMA_EN;
-	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
-
-	timeout = 0;
-	/* Check RDMA status register to confirm RDMA is disabled */
-	while (timeout++ < DMA_TIMEOUT_VAL) {
-		reg = bcmgenet_rdma_readl(priv, DMA_STATUS);
-		if (reg & DMA_DISABLED)
-			break;
-
-		udelay(1);
-	}
-
-	if (timeout == DMA_TIMEOUT_VAL) {
+	if (-ETIMEDOUT == bcmgenet_rdma_disable(priv)) {
 		netdev_warn(priv->dev, "Timed out while disabling RX DMA\n");
 		ret = -ETIMEDOUT;
 	}
 
-	dma_ctrl = 0;
-	for (i = 0; i <= priv->hw_params->rx_queues; i++)
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
-	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	reg &= ~dma_ctrl;
-	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
-
-	dma_ctrl = 0;
-	for (i = 0; i <= priv->hw_params->tx_queues; i++)
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
-	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	reg &= ~dma_ctrl;
-	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
-
 	return ret;
 }
 
@@ -3006,27 +3007,27 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 {
 	struct enet_cb *cb;
-	u32 reg, dma_ctrl;
 	unsigned int i;
 	int ret;
+	u32 reg;
 
 	netif_dbg(priv, hw, priv->dev, "%s\n", __func__);
 
-	/* Disable RX/TX DMA and flush TX queues */
-	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
-	for (i = 0; i < priv->hw_params->tx_queues; i++)
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
-	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	reg &= ~dma_ctrl;
-	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
+	/* Disable TX DMA */
+	ret = bcmgenet_tdma_disable(priv);
+	if (ret) {
+		netdev_err(priv->dev, "failed to halt Tx DMA\n");
+		return ret;
+	}
 
-	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
-	for (i = 0; i < priv->hw_params->rx_queues; i++)
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
-	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	reg &= ~dma_ctrl;
-	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
+	/* Disable RX DMA */
+	ret = bcmgenet_rdma_disable(priv);
+	if (ret) {
+		netdev_err(priv->dev, "failed to halt Rx DMA\n");
+		return ret;
+	}
 
+	/* Flush TX queues */
 	bcmgenet_umac_writel(priv, 1, UMAC_TX_FLUSH);
 	udelay(10);
 	bcmgenet_umac_writel(priv, 0, UMAC_TX_FLUSH);
-- 
2.53.0



