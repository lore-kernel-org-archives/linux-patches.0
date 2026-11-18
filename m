Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033205;
	b=BqnrpfMoYWAvR1YkKpiwlX1pxFAO1oL+0lupoF25H20og7h0pyU8y6As4lLJH6CYpp5g
	 GguRh4Z19kD8UYynuwwgl/GyKgh+GaL64UUXkG5s3Qd1h74ooy8U1wiNsVEkCtCONC5Za
	 0oMINyz3QmF4NspDscCYBPeMqw9p5viZd+QLBngG04FZKz6okpsW0UVU1aKrRai5X6/bk
	 v3AyP3oSjRfT2LI/VTKazUwlo/3QJ44NhTPud6QKyXchjjHiZ9zoV2Pj92qwUQGwZuUAo
	 oLRI53yB7W6kUn4E5IeFKqv706bD7y7+hBk8GuuOzwKwTNNVbytRNaSyDAQVTLMCoDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+nzN7AIClMtPC8Y3leUMnsV+4fJ8JeLGwhaGSIUe4Q=;
	b=LS2vm4B6bj531uQVwW9DVQYPBjnYYwxle5FyLJFBkMWfvNvpRoIhx8X3wTH1VCkxeBik
	 F3o+QNAaorA5HqJaeICYVllTMWQdvOT56+Mn2eVvK+tX9E5MW5LDyRIgvuT9sqzgxDS9m
	 bNm+Ld6wlQbKtegvsCHJxv77lNjJs22YRN/tjS+s+/8gMYlF2ryarDj51CE97IcjJKeIU
	 a/pnkQnjG0GRHyFXqVTN5dw3TefaCJ/UKsPmSY/PjlkuKNqdxD6U3q4HrN7CBBagUVlWy
	 eSZzPm/tjhrN4GrH1KdH8DQsG/dU/6dIhgSh9O48NwccKEaavYcw+s5YhNphFk9DHIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQewDcLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FAB606A33B;
	Wed, 18 Nov 2026 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQewDcLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D221F000C4;
	Wed, 18 Nov 2026 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033205;
	bh=L+nzN7AIClMtPC8Y3leUMnsV+4fJ8JeLGwhaGSIUe4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQewDcLVgdE/rcHvSylmjkW5DGeYQ/VqisELnD1FBCAXQeVl290aPRgdF3GkSPFLm
	 kE/ta3dIua5bYHxTXX2QW2b4spsOvpNiDXqAx4WyC668WFblY6Jqi7AfAAz2F9qkt8
	 9Z8OGHvcvaaYTGqCD2+Mi+FPNn58GEFb9ORhatH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1648/1756] net: bcmgenet: introduce bcmgenet_[r|t]dma_disable
Date: Wed, 18 Nov 2026 16:02:55 +0100
Message-ID: <20261118150115.353493381@linuxfoundation.org>
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
index d02473abf9bb8..44bee231caab8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2789,6 +2789,52 @@ static void bcmgenet_fini_tx_napi(struct bcmgenet_priv *priv)
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
@@ -2911,26 +2957,9 @@ static int bcmgenet_init_rx_queues(struct net_device *dev)
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
@@ -2939,39 +2968,11 @@ static int bcmgenet_dma_teardown(struct bcmgenet_priv *priv)
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
 
@@ -2997,27 +2998,27 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
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



