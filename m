Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033174;
	b=gk3A4ltkC5+qxiK6GpMYaTSBpXOhjYGk10OeXzEAi0p3W3HGtVaNf5bb2RPSnssV6BpJ
	 OhvedMlLmspgkojQMoiP3UhjEj8cT8UBaAchgLsjnY2e60J0DN4X97ZT8jZOm7OvnZ2gm
	 8uJvgI3+GYoLCVNp2inOYgYExVk7eE1I6g8ybj0jPTHP3W83jDomEJhZIAhbuNo2qf9mp
	 20VzNPSfr75lfze23ii9vivtMXY8i0YnBtTLWzlmgRqNMEL6YnplEUErM7yDoKDxiMLVQ
	 u4k8hj0Q++7aWeUy9W/ByyACIXy7HwXX4LWbbY0wmRg/pPP3o0ws6GIR5k3RhnCzVdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=54hyGpbLII18p3ZLoeqnhVwqFKbIRonQIi49n6Z229Y=;
	b=qcHZLR/fdaQmDSxGWfCGXApccd9ro/U2QtZnhqM0dVKyGdD5QVY8YvlQigYdW/NlPiQP
	 v8VyrKujw8ds/ySFMttI+bcg2bo/ekK1a81X58btDiS4A9jDqqWUQ+qjB0Nn6+qbHfz3Q
	 6TvDjAv6CyN8nXFBafdvAGPbxg5lrNVhuJP3VdypEGv+DIyADEXKqdw8G/X0kdnqdnFaW
	 dQ3FRrmtDdlssHVnwBhmKT31d343ftqW/ZtUxwoTVp19irO4ISjbwQs9LKH9sx6L5/xW/
	 SoK2aYM63ripQMcxQufg6FMKMZ0r4I3LVRjQi1XuCI+7yrtbRi7uWtq1aV+rvADjarw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvTMXRAD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB31C606A33A;
	Wed, 18 Nov 2026 20:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvTMXRAD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBD91F000C6;
	Wed, 18 Nov 2026 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033174;
	bh=54hyGpbLII18p3ZLoeqnhVwqFKbIRonQIi49n6Z229Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvTMXRADoB9KHJ0uCumvvXjV2gXCR2AdbxJJSUjDedkK5MLyPrZyHC/terjO8EUr8
	 fS7VxZNmgOdaJbSXnt/WEqR+7jxwyGb/UcIXPSZ/3bZdBnDW5eu4g8Wa8jcjgNnqQ0
	 Q/kQTdffQ9IpNIe4ztFIV4uyvghBXAtpQCvs8HHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1647/1756] net: bcmgenet: consolidate dma initialization
Date: Wed, 18 Nov 2026 16:02:54 +0100
Message-ID: <20261118150115.315500690@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 58affb23b66793033f95cb4e9a57a388e0485edb ]

The functions bcmgenet_dma_disable and bcmgenet_enable_dma are
only used as part of dma initialization. Their functionality is
moved inside bcmgenet_init_dma and the functions are removed.

Since the dma is always disabled inside of bcmgenet_init_dma,
the initialization functions bcmgenet_init_rx_queues and
bcmgenet_init_tx_queues no longer need to attempt to manage its
state.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-10-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c1f51c3ee9c ("net: bcmgenet: recover from a failed resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 150 +++++++-----------
 1 file changed, 54 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0b9c7deab10de..d02473abf9bb8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2809,17 +2809,7 @@ static void bcmgenet_init_tx_queues(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned int start = 0, end = GENET_Q0_TX_BD_CNT;
-	u32 i, dma_enable;
-	u32 dma_ctrl, ring_cfg;
-	u32 dma_priority[3] = {0, 0, 0};
-
-	dma_ctrl = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	dma_enable = dma_ctrl & DMA_EN;
-	dma_ctrl &= ~DMA_EN;
-	bcmgenet_tdma_writel(priv, dma_ctrl, DMA_CTRL);
-
-	dma_ctrl = 0;
-	ring_cfg = 0;
+	u32 i, ring_mask, dma_priority[3] = {0, 0, 0};
 
 	/* Enable Weighted Round-Robin arbiter mode */
 	bcmgenet_tdma_writel(priv, DMA_ARBITER_WRR, DMA_ARB_CTRL);
@@ -2829,8 +2819,6 @@ static void bcmgenet_init_tx_queues(struct net_device *dev)
 		bcmgenet_init_tx_ring(priv, i, end - start, start, end);
 		start = end;
 		end += priv->hw_params->tx_bds_per_q;
-		ring_cfg |= (1 << i);
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 		dma_priority[DMA_PRIO_REG_INDEX(i)] |=
 			(i ? GENET_Q1_WEIGHT : GENET_Q0_WEIGHT)
 			<< DMA_PRIO_REG_SHIFT(i);
@@ -2841,13 +2829,13 @@ static void bcmgenet_init_tx_queues(struct net_device *dev)
 	bcmgenet_tdma_writel(priv, dma_priority[1], DMA_PRIORITY_1);
 	bcmgenet_tdma_writel(priv, dma_priority[2], DMA_PRIORITY_2);
 
-	/* Enable Tx queues */
-	bcmgenet_tdma_writel(priv, ring_cfg, DMA_RING_CFG);
+	/* Configure Tx queues as descriptor rings */
+	ring_mask = (1 << (priv->hw_params->tx_queues + 1)) - 1;
+	bcmgenet_tdma_writel(priv, ring_mask, DMA_RING_CFG);
 
-	/* Enable Tx DMA */
-	if (dma_enable)
-		dma_ctrl |= DMA_EN;
-	bcmgenet_tdma_writel(priv, dma_ctrl, DMA_CTRL);
+	/* Enable Tx rings */
+	ring_mask <<= DMA_RING_BUF_EN_SHIFT;
+	bcmgenet_tdma_writel(priv, ring_mask, DMA_CTRL);
 }
 
 static void bcmgenet_enable_rx_napi(struct bcmgenet_priv *priv)
@@ -2896,17 +2884,9 @@ static int bcmgenet_init_rx_queues(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned int start = 0, end = GENET_Q0_RX_BD_CNT;
-	u32 i, dma_enable, dma_ctrl = 0, ring_cfg = 0;
+	u32 i, ring_mask;
 	int ret;
 
-	dma_ctrl = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	dma_enable = dma_ctrl & DMA_EN;
-	dma_ctrl &= ~DMA_EN;
-	bcmgenet_rdma_writel(priv, dma_ctrl, DMA_CTRL);
-
-	dma_ctrl = 0;
-	ring_cfg = 0;
-
 	/* Initialize Rx priority queues */
 	for (i = 0; i <= priv->hw_params->rx_queues; i++) {
 		ret = bcmgenet_init_rx_ring(priv, i, end - start, start, end);
@@ -2915,17 +2895,15 @@ static int bcmgenet_init_rx_queues(struct net_device *dev)
 
 		start = end;
 		end += priv->hw_params->rx_bds_per_q;
-		ring_cfg |= (1 << i);
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	}
 
 	/* Configure Rx queues as descriptor rings */
-	bcmgenet_rdma_writel(priv, ring_cfg, DMA_RING_CFG);
+	ring_mask = (1 << (priv->hw_params->rx_queues + 1)) - 1;
+	bcmgenet_rdma_writel(priv, ring_mask, DMA_RING_CFG);
 
 	/* Enable Rx rings */
-	if (dma_enable)
-		dma_ctrl |= DMA_EN;
-	bcmgenet_rdma_writel(priv, dma_ctrl, DMA_CTRL);
+	ring_mask <<= DMA_RING_BUF_EN_SHIFT;
+	bcmgenet_rdma_writel(priv, ring_mask, DMA_CTRL);
 
 	return 0;
 }
@@ -3016,14 +2994,42 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 }
 
 /* init_edma: Initialize DMA control register */
-static int bcmgenet_init_dma(struct bcmgenet_priv *priv)
+static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 {
-	int ret;
-	unsigned int i;
 	struct enet_cb *cb;
+	u32 reg, dma_ctrl;
+	unsigned int i;
+	int ret;
 
 	netif_dbg(priv, hw, priv->dev, "%s\n", __func__);
 
+	/* Disable RX/TX DMA and flush TX queues */
+	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->tx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
+	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
+	reg &= ~dma_ctrl;
+	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
+
+	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->rx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
+	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
+	reg &= ~dma_ctrl;
+	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
+
+	bcmgenet_umac_writel(priv, 1, UMAC_TX_FLUSH);
+	udelay(10);
+	bcmgenet_umac_writel(priv, 0, UMAC_TX_FLUSH);
+
+	if (flush_rx) {
+		reg = bcmgenet_rbuf_ctrl_get(priv);
+		bcmgenet_rbuf_ctrl_set(priv, reg | BIT(0));
+		udelay(10);
+		bcmgenet_rbuf_ctrl_set(priv, reg);
+		udelay(10);
+	}
+
 	/* Initialize common Rx ring structures */
 	priv->rx_bds = priv->base + priv->hw_params->rdma_offset;
 	priv->num_rx_bds = TOTAL_DESC;
@@ -3073,6 +3079,15 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv)
 	/* Initialize Tx queues */
 	bcmgenet_init_tx_queues(priv->dev);
 
+	/* Enable RX/TX DMA */
+	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
+	reg |= DMA_EN;
+	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
+
+	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
+	reg |= DMA_EN;
+	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
+
 	return 0;
 }
 
@@ -3224,53 +3239,6 @@ static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
 	put_unaligned_be16(addr_tmp, &addr[4]);
 }
 
-static void bcmgenet_dma_disable(struct bcmgenet_priv *priv, bool flush_rx)
-{
-	unsigned int i;
-	u32 reg;
-	u32 dma_ctrl;
-
-	/* disable DMA */
-	dma_ctrl = DMA_EN;
-	for (i = 0; i <= priv->hw_params->tx_queues; i++)
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
-	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	reg &= ~dma_ctrl;
-	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
-
-	dma_ctrl = DMA_EN;
-	for (i = 0; i <= priv->hw_params->rx_queues; i++)
-		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
-	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	reg &= ~dma_ctrl;
-	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
-
-	bcmgenet_umac_writel(priv, 1, UMAC_TX_FLUSH);
-	udelay(10);
-	bcmgenet_umac_writel(priv, 0, UMAC_TX_FLUSH);
-
-	if (flush_rx) {
-		reg = bcmgenet_rbuf_ctrl_get(priv);
-		bcmgenet_rbuf_ctrl_set(priv, reg | BIT(0));
-		udelay(10);
-		bcmgenet_rbuf_ctrl_set(priv, reg);
-		udelay(10);
-	}
-}
-
-static void bcmgenet_enable_dma(struct bcmgenet_priv *priv)
-{
-	u32 reg;
-
-	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	reg |= DMA_EN;
-	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
-
-	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	reg |= DMA_EN;
-	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
-}
-
 static void bcmgenet_netif_start(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -3322,18 +3290,13 @@ static int bcmgenet_open(struct net_device *dev)
 	/* HFB init */
 	bcmgenet_hfb_init(priv);
 
-	/* Disable RX/TX DMA and flush TX and RX queues */
-	bcmgenet_dma_disable(priv, true);
-
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
-	ret = bcmgenet_init_dma(priv);
+	ret = bcmgenet_init_dma(priv, true);
 	if (ret) {
 		netdev_err(dev, "failed to initialize DMA\n");
 		goto err_clk_disable;
 	}
 
-	bcmgenet_enable_dma(priv);
-
 	ret = request_irq(priv->irq0, bcmgenet_isr0, IRQF_SHARED,
 			  dev->name, priv);
 	if (ret < 0) {
@@ -4203,18 +4166,13 @@ static int bcmgenet_resume(struct device *d)
 		if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
 			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 
-	/* Disable RX/TX DMA and flush TX queues */
-	bcmgenet_dma_disable(priv, false);
-
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
-	ret = bcmgenet_init_dma(priv);
+	ret = bcmgenet_init_dma(priv, false);
 	if (ret) {
 		netdev_err(dev, "failed to initialize DMA\n");
 		goto out_clk_disable;
 	}
 
-	bcmgenet_enable_dma(priv);
-
 	if (!device_may_wakeup(d))
 		phy_resume(dev->phydev);
 
-- 
2.53.0



