Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050652;
	b=EwUKMreYKtY5fld/cbT7nOsg+SpHSLa4Lx5iIpGNcHbztpPjkZyK/Ho5cZIUIFbdi0N3
	 65HhvG6eLrQu/6x/UM6Xk4JVVhcT6wVx27wcRlmvQZFoVGDylXcHXsCaiLIgq83JPGaHH
	 80xGXQE+6XGOJNtoV6WgyZKVKBzN9D+scMRkSDAEx1aR1NUxZwFCyI1ojoo2FlarvDn6s
	 ZMHJQlsr+AUEOe6GGkHJfKxjj1WcHehecrhp6sHj89cKi3muexzFq2VmCHr1tvpbXlXQX
	 qlL+P8q7DvJWFvGzOYiOk3zNKV539NVUX9l99vgDlzIY+9zLeSH1OeHX9rjKE3CKt+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f5h5pXpmezaTSbgztAydtj1FC/rt0QxfIgPqWRr0Ex0=;
	b=S9Z7rHjkEQEWcwEQuxbISKv/JitWaYC1uTdauN029RmlC2P4wY2P8s7OTZxTJY6uN0x2
	 skXAQLegQeNk/untowJTzKoNTl4E7BQ8qeLAgclz2Dh42Hph8PMSnfJAm2u0w4DcjQdVy
	 XEEeqsiMghkpjXKsSWSkyoYHuQmItJnkQvNmAK7mbhaV0FnOQCrswxoIzl+/19EqsmmIg
	 vyX1/j91AwdycB9pRUMu8C4dzFqd1Ypj/2npdVWdNW14pJdAan/wPt/F0FH6Ds8nMi8Xy
	 3Namo3Irg3VdBE99tuD8u2IOogNoAPZ8Y+rwjF7xysb/NPVu9ymnQwwZl1iSOi9IunA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA2ftmtV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D01606A330;
	Thu, 19 Nov 2026 01:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA2ftmtV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568301F000C4;
	Thu, 19 Nov 2026 01:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050651;
	bh=f5h5pXpmezaTSbgztAydtj1FC/rt0QxfIgPqWRr0Ex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AA2ftmtVUNV1hpNqLbWCfk8CVX5VvHVQ14/AVs78vIxJYY6NW5RGo/HfPrDJtWaWg
	 bhg3z6lBW5yd992kvTWzPm51B61N8wThNrRI79TOZeF/lL9RmphBqtwS9lrRUIy/fQ
	 l9Z7QGugah+CM4uvpmgUHnreyqIxQlb/qaIh+g94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2783/2857] net: bcmgenet: restore the Tx coalescing setting when the rings are rebuilt
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150341.811301772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit ff8a7c0c06762a2a2333fbd6148d637bbd3d5090 ]

bcmgenet_set_coalesce() writes tx_max_coalesced_frames straight into
DMA_MBUF_DONE_THRESH and keeps no copy of it, while
bcmgenet_init_tx_ring() programs a fixed 1. An ifdown and ifup or a resume
then puts the Tx coalescing back to one frame per interrupt.

Rx keeps its value per ring and reapplies it on init. Do the same for Tx.

Fixes: 2f9130709d2c ("net: bcmgenet: Implement TX coalescing control knobs")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261022-nb-genet-fini-dma-net-v3-2-6e9fc89c0156@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 10 ++++++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 8abdff23521dd..45bdfbad89fc8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -913,10 +913,13 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
 	/* Program all TX queues with the same values, as there is no
 	 * ethtool knob to do coalescing on a per-queue basis
 	 */
-	for (i = 0; i <= priv->hw_params->tx_queues; i++)
+	for (i = 0; i <= priv->hw_params->tx_queues; i++) {
+		priv->tx_rings[i].tx_max_coalesced_frames =
+			ec->tx_max_coalesced_frames;
 		bcmgenet_tdma_ring_writel(priv, i,
 					  ec->tx_max_coalesced_frames,
 					  DMA_MBUF_DONE_THRESH);
+	}
 
 	for (i = 0; i <= priv->hw_params->rx_queues; i++)
 		bcmgenet_set_ring_rx_coalesce(&priv->rx_rings[i], ec);
@@ -2686,7 +2689,8 @@ static void bcmgenet_init_tx_ring(struct bcmgenet_priv *priv,
 
 	bcmgenet_tdma_ring_writel(priv, index, 0, TDMA_PROD_INDEX);
 	bcmgenet_tdma_ring_writel(priv, index, 0, TDMA_CONS_INDEX);
-	bcmgenet_tdma_ring_writel(priv, index, 1, DMA_MBUF_DONE_THRESH);
+	bcmgenet_tdma_ring_writel(priv, index, ring->tx_max_coalesced_frames,
+				  DMA_MBUF_DONE_THRESH);
 	/* Disable rate control for now */
 	bcmgenet_tdma_ring_writel(priv, index, flow_period_val,
 				  TDMA_FLOW_PERIOD);
@@ -4094,6 +4098,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		priv->rx_rings[i].index = i;
 		priv->rx_rings[i].rx_max_coalesced_frames = 1;
 	}
+	for (i = 0; i <= priv->hw_params->tx_queues; i++)
+		priv->tx_rings[i].tx_max_coalesced_frames = 1;
 
 	/* Initialize u64 stats seq counter for 32bit machines */
 	for (i = 0; i <= GENET_MAX_MQ_CNT; i++) {
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 5f0cf8f1f634d..7ddffdf394a6a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -545,6 +545,7 @@ struct bcmgenet_tx_ring {
 	unsigned int	prod_index;	/* Tx ring producer index SW copy */
 	unsigned int	cb_ptr;		/* Tx ring initial CB ptr */
 	unsigned int	end_ptr;	/* Tx ring end CB ptr */
+	unsigned int	tx_max_coalesced_frames;
 	struct bcmgenet_priv *priv;
 };
 
-- 
2.53.0



