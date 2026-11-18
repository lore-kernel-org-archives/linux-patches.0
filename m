Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022137;
	b=ANFYmb1h84LsPj44cegym3c/3kuPdcah1iVrV19usTkwworJDI4RWCIkRK9mip8KS5NT
	 OA3XEqiXvbRLnSOQTA9AhI1a9ZtgkUfJCMnEj6Z9zvyPGA4qNzDc5nJQhNyL0IwHJkX0G
	 5EwkhLygzvifyxdIX/UjWx4ftIwCNnzaHUGAh9DeoiJghzxV23UWmofYpgO+bQWzS4ny0
	 7Y4HSxN2W7zwT4wHCRlVEXIRkx7Pm/2us96g1chtsb0ATS1IJ6r/xvkX8X70g8nTi6Txw
	 K/4FetSDNHmqGyRrNe06SrarTCB+Fr5vGv9nKEBpnZq5q6Uv1MPUupV9ffOVZQ3hs+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=afXExIls/UOulS9AlsOmrZVvy8YHeuYlZBVRiCloXVo=;
	b=x793MIh9syXutYt1TGH3aHzHvRhGguCF2zA6o+7lVMxp5qgv3nEvLJLuMxAHR2cpzgu/
	 Fp+FFNIpDgGQdfZuBI2bczF0oJ9QNIIrLD/79b7Ou73uV2SjV6dlND8Ys+O3DYHHGFuGX
	 Q4YCbZSeRJrDEoQkIy1AVACXrUziN1H2iNGJWLWZi5hV2+AhBLamUVsuOmpqhj5NyFsgv
	 3HPOrqk6T1A7Tjcr8AwUygXHNb2zMXBGz7VkRD0g4u0Cl0ZXpmS7zcnqEKwHRRl24+ZVX
	 g/dqLpBYY34vsvOSTLlLASGP5z5Ng42SkNZrUJfa0Ti4YRVFLiUa6QBzc1azspp1LRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cpcr/XG/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A377606A320;
	Wed, 18 Nov 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cpcr/XG/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39461F000C4;
	Wed, 18 Nov 2026 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022137;
	bh=afXExIls/UOulS9AlsOmrZVvy8YHeuYlZBVRiCloXVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cpcr/XG/wilFdXJy1eVb8oqLzgeRZWJqZAdpXv33A8qF6oDva6aul9Or7A17Ko/s9
	 w3ZLvYMqJr519kSnNeCTIYrPRNJldy64oCWb6e89WL88PdHI2cLRzHsaCjw6DDgV0q
	 NI99sB3XY5wg8dEEptN457C3Db91dIyuKp/lFCys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2555/2651] net: bcmgenet: restore the Tx coalescing setting when the rings are rebuilt
Date: Wed, 18 Nov 2026 16:03:15 +0100
Message-ID: <20261118150416.462564096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e7dec73d5b1c0..f258997f20a9f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -931,10 +931,13 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
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
@@ -2758,7 +2761,8 @@ static void bcmgenet_init_tx_ring(struct bcmgenet_priv *priv,
 
 	bcmgenet_tdma_ring_writel(priv, index, 0, TDMA_PROD_INDEX);
 	bcmgenet_tdma_ring_writel(priv, index, 0, TDMA_CONS_INDEX);
-	bcmgenet_tdma_ring_writel(priv, index, 1, DMA_MBUF_DONE_THRESH);
+	bcmgenet_tdma_ring_writel(priv, index, ring->tx_max_coalesced_frames,
+				  DMA_MBUF_DONE_THRESH);
 	/* Disable rate control for now */
 	bcmgenet_tdma_ring_writel(priv, index, flow_period_val,
 				  TDMA_FLOW_PERIOD);
@@ -4176,6 +4180,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		priv->rx_rings[i].index = i;
 		priv->rx_rings[i].rx_max_coalesced_frames = 1;
 	}
+	for (i = 0; i <= priv->hw_params->tx_queues; i++)
+		priv->tx_rings[i].tx_max_coalesced_frames = 1;
 
 	/* Initialize u64 stats seq counter for 32bit machines */
 	for (i = 0; i <= GENET_MAX_MQ_CNT; i++) {
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 86f2aed20dbe8..e48ce39d3e7c8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -553,6 +553,7 @@ struct bcmgenet_tx_ring {
 	unsigned int	prod_index;	/* Tx ring producer index SW copy */
 	unsigned int	cb_ptr;		/* Tx ring initial CB ptr */
 	unsigned int	end_ptr;	/* Tx ring end CB ptr */
+	unsigned int	tx_max_coalesced_frames;
 	struct bcmgenet_priv *priv;
 };
 
-- 
2.53.0



