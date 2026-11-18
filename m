Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061730;
	b=PTlmknBUD6fV8cdzkmm7lg0kX5U7bxqMZoCeXQJ1v9kZIsMCcafTumgFZvmWzT7K1qnt
	 gPpEeXtT6r5VZ5g8hyH6qbuP6u2UxIih9Jvp7wKGa2dXlC+KKxjmb8yafB42RDea7FAFJ
	 FOWZluA+QGNCF9jUobfEOaTY/kPyUk4Jv/F7LaCnVZebU6Bl3VX4Kj9OgaD1mN5H1rNMQ
	 zdDHGtBiloYCrbGcKvy/1YuPGwuNabgplBHqnCiJhIF1kgwc2OzY6GXHInAWVzHk25DHl
	 cPMI8D0fXAXaFZ+Z3ebxW8Hv1IjpB+YGGiwYYI3TBTs/yg3q3ju7Ico2y6VNwGk2DLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hU9WBhWLQJYqVJwuDEr5zOtOjy1hHTdWxDy2WGVekvU=;
	b=lCy4IPByjPFkIJgWgKOK81ckfBzWz5lurV3/TX52zorEQgoXX8qpK4Fj/Sn0EDisoDUh
	 74wfbHOyHrjVcMVP7LwE0n9oc2gk394AYXOg2ymk9QuMPtl29v4KOoFO8vRuBMnKN5CMO
	 kItgNviHxuiPtgZ3TD6ZEQrQgd6LYC5tbfzD/BijBa1ZmDCXNxTyP/YaxXOVnABBR48cm
	 l3Ep02ry7Th2NYQl9uCelSw3g8yZR/KYzxYPl22lL6NYwcZm6cwdXlK3yelrijvbrClEF
	 fgjV4WXn9VeBKTXcgXVu90bwSCL0iy0zcOJ0FvVAVDQ/50rdjFE9/NtsNMVo0EvM3Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCiJQQfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F9C606A320;
	Thu, 19 Nov 2026 04:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCiJQQfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12681F000C4;
	Thu, 19 Nov 2026 04:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061730;
	bh=hU9WBhWLQJYqVJwuDEr5zOtOjy1hHTdWxDy2WGVekvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCiJQQfrnqJbaeuaA6jV/dOLGcWFEJeGy8isGuErpGrZ7SAAYCDIpaAA0Z4vUCXSY
	 VkU6nY0nN894nRNINCmqJpyMwmqnDc9YO8YtWdracx2QVS8i2oyyOa4ZQzqee9bQhP
	 /AJcAjJWyo8cVnSJNeY/daLVOzlFjsmgYT7AfOuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1658/1848] net: axienet: Clean up device used for DMA calls
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150029.129942982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 17882fd4256721451457ee57532bbae0cd5cacfe ]

Instead of using lp->ndev.parent to find the correct device to use for
DMA API calls, just use the dev attribute in the device structure.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0c20cb4cfb40 ("net: axienet: free outstanding TX buffers in axienet_dma_bd_release()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3253ace2b6014..fa3e2bbee7905 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -190,7 +190,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	/* If we end up here, tx_bd_v must have been DMA allocated. */
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 			  lp->tx_bd_v,
 			  lp->tx_bd_p);
@@ -215,12 +215,12 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		 */
 		if (lp->rx_bd_v[i].cntrl) {
 			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
-			dma_unmap_single(ndev->dev.parent, phys,
+			dma_unmap_single(lp->dev, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
 		}
 	}
 
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 			  lp->rx_bd_v,
 			  lp->rx_bd_p);
@@ -249,13 +249,13 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	lp->rx_bd_ci = 0;
 
 	/* Allocate the Tx and Rx buffer descriptors. */
-	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->tx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
 		return -ENOMEM;
 
-	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->rx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 					 &lp->rx_bd_p, GFP_KERNEL);
 	if (!lp->rx_bd_v)
@@ -285,9 +285,9 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 			goto out;
 
 		lp->rx_bd_v[i].skb = skb;
-		addr = dma_map_single(ndev->dev.parent, skb->data,
+		addr = dma_map_single(lp->dev, skb->data,
 				      lp->max_frm_size, DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, addr)) {
+		if (dma_mapping_error(lp->dev, addr)) {
 			netdev_err(ndev, "DMA mapping error\n");
 			goto out;
 		}
@@ -637,7 +637,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		/* Ensure we see complete descriptor update */
 		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys,
+		dma_unmap_single(lp->dev, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				 DMA_TO_DEVICE);
 
@@ -775,9 +775,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	phys = dma_map_single(ndev->dev.parent, skb->data,
+	phys = dma_map_single(lp->dev, skb->data,
 			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+	if (unlikely(dma_mapping_error(lp->dev, phys))) {
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
@@ -791,11 +791,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
-		phys = dma_map_single(ndev->dev.parent,
+		phys = dma_map_single(lp->dev,
 				      skb_frag_address(frag),
 				      skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
@@ -873,7 +873,7 @@ static void axienet_recv(struct net_device *ndev)
 			length = cur_p->app4 & 0x0000FFFF;
 
 			phys = desc_get_phys_addr(lp, cur_p);
-			dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
+			dma_unmap_single(lp->dev, phys, lp->max_frm_size,
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
@@ -906,10 +906,10 @@ static void axienet_recv(struct net_device *ndev)
 		if (!new_skb)
 			break;
 
-		phys = dma_map_single(ndev->dev.parent, new_skb->data,
+		phys = dma_map_single(lp->dev, new_skb->data,
 				      lp->max_frm_size,
 				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
@@ -1727,7 +1727,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 		if (cur_p->cntrl) {
 			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
 
-			dma_unmap_single(ndev->dev.parent, addr,
+			dma_unmap_single(lp->dev, addr,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
-- 
2.53.0



