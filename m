Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF4F1EEF7;
	Mon, 27 May 2024 19:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838344; cv=none; b=s3c75/ycZFlVGrJS1YmfCBPXH5nZI0xWhAX7CD7tdIXNWBkJctuvnwgOoGEQFeXOo2PvdtsO/F6TAvPcIIHJq6NjpIJeFsV/ZnZIf7HWZ5lR12z9gT4h8RzgUmRJztwznb1SZff3JZxSXuKWREtgHM8TLDLAOzRy+jWBwNl9qcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838344; c=relaxed/simple;
	bh=P/9WdOKcURDnPlaP7/sB8ICoCXVuXZVKYSMPOsJQU6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGIM9eORK3tYLubuVHvGFcZPudxq8aju88nDOuWfBTPaXRPWuLLQM4VL4lTDK5qXwrchHExYeOBxal5TC+KvxnFvx3Q/ObwlIJ8ZzcLzbq7rZ3BH0m2Db76MleR1ghu0TWFhcPA0KoFmWCsln0uEfbP0T0dMx2G4RhEcj/9Q8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1Zz1OLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1Zz1OLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BDAC2BBFC;
	Mon, 27 May 2024 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838343;
	bh=P/9WdOKcURDnPlaP7/sB8ICoCXVuXZVKYSMPOsJQU6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1Zz1OLUcYi2v7VkMs/vwl2R9FiSPZe7QPrM5v/4vc6jmF1LegwtOj25UiDPz248d
	 2Ty0dJ/mlLfJD9YpCdB8N4jTojHYM+fMQ2vQ8BYVTlj6C9Dd96d8gxAnlITCbfYIzg
	 25OLNgA4BZDFRPwQFe/q5WXrrRSWF9d9Pl/NW23g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 306/493] net: ethernet: mediatek: use ADMAv1 instead of ADMAv2.0 on MT7981 and MT7986
Date: Mon, 27 May 2024 20:55:08 +0200
Message-ID: <20240527185640.307450842@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 5e69ff84f3e6cc54502a902043847b37ed78afd4 ]

ADMAv2.0 is plagued by RX hangs which can't easily detected and happen upon
receival of a corrupted Ethernet frame.

Use ADMAv1 instead which is also still present and usable, and doesn't
suffer from that problem.

Fixes: 197c9e9b17b1 ("net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset")
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/57cef74bbd0c243366ad1ff4221e3f72f437ec80.1715164770.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 46 ++++++++++-----------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3eefb735ce197..d7d73295f0dc4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -110,16 +110,16 @@ static const struct mtk_reg_map mt7986_reg_map = {
 	.tx_irq_mask		= 0x461c,
 	.tx_irq_status		= 0x4618,
 	.pdma = {
-		.rx_ptr		= 0x6100,
-		.rx_cnt_cfg	= 0x6104,
-		.pcrx_ptr	= 0x6108,
-		.glo_cfg	= 0x6204,
-		.rst_idx	= 0x6208,
-		.delay_irq	= 0x620c,
-		.irq_status	= 0x6220,
-		.irq_mask	= 0x6228,
-		.adma_rx_dbg0	= 0x6238,
-		.int_grp	= 0x6250,
+		.rx_ptr		= 0x4100,
+		.rx_cnt_cfg	= 0x4104,
+		.pcrx_ptr	= 0x4108,
+		.glo_cfg	= 0x4204,
+		.rst_idx	= 0x4208,
+		.delay_irq	= 0x420c,
+		.irq_status	= 0x4220,
+		.irq_mask	= 0x4228,
+		.adma_rx_dbg0	= 0x4238,
+		.int_grp	= 0x4250,
 	},
 	.qdma = {
 		.qtx_cfg	= 0x4400,
@@ -1107,7 +1107,7 @@ static bool mtk_rx_get_desc(struct mtk_eth *eth, struct mtk_rx_dma_v2 *rxd,
 	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd3 = READ_ONCE(dma_rxd->rxd3);
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
-	if (mtk_is_netsys_v2_or_greater(eth)) {
+	if (mtk_is_netsys_v3_or_greater(eth)) {
 		rxd->rxd5 = READ_ONCE(dma_rxd->rxd5);
 		rxd->rxd6 = READ_ONCE(dma_rxd->rxd6);
 	}
@@ -2028,7 +2028,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		if (mtk_is_netsys_v2_or_greater(eth)) {
+		if (mtk_is_netsys_v3_or_greater(eth)) {
 			u32 val = RX_DMA_GET_SPORT_V2(trxd.rxd5);
 
 			switch (val) {
@@ -2140,7 +2140,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->dev = netdev;
 		bytes += skb->len;
 
-		if (mtk_is_netsys_v2_or_greater(eth)) {
+		if (mtk_is_netsys_v3_or_greater(eth)) {
 			reason = FIELD_GET(MTK_RXD5_PPE_CPU_REASON, trxd.rxd5);
 			hash = trxd.rxd5 & MTK_RXD5_FOE_ENTRY;
 			if (hash != MTK_RXD5_FOE_ENTRY)
@@ -2690,7 +2690,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 
 		rxd->rxd3 = 0;
 		rxd->rxd4 = 0;
-		if (mtk_is_netsys_v2_or_greater(eth)) {
+		if (mtk_is_netsys_v3_or_greater(eth)) {
 			rxd->rxd5 = 0;
 			rxd->rxd6 = 0;
 			rxd->rxd7 = 0;
@@ -3893,7 +3893,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	else
 		mtk_hw_reset(eth);
 
-	if (mtk_is_netsys_v2_or_greater(eth)) {
+	if (mtk_is_netsys_v3_or_greater(eth)) {
 		/* Set FE to PDMAv2 if necessary */
 		val = mtk_r32(eth, MTK_FE_GLO_MISC);
 		mtk_w32(eth,  val | BIT(4), MTK_FE_GLO_MISC);
@@ -5169,11 +5169,11 @@ static const struct mtk_soc_data mt7981_data = {
 		.dma_len_offset = 8,
 	},
 	.rx = {
-		.desc_size = sizeof(struct mtk_rx_dma_v2),
-		.irq_done_mask = MTK_RX_DONE_INT_V2,
+		.desc_size = sizeof(struct mtk_rx_dma),
+		.irq_done_mask = MTK_RX_DONE_INT,
 		.dma_l4_valid = RX_DMA_L4_VALID_V2,
-		.dma_max_len = MTK_TX_DMA_BUF_LEN_V2,
-		.dma_len_offset = 8,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
@@ -5195,11 +5195,11 @@ static const struct mtk_soc_data mt7986_data = {
 		.dma_len_offset = 8,
 	},
 	.rx = {
-		.desc_size = sizeof(struct mtk_rx_dma_v2),
-		.irq_done_mask = MTK_RX_DONE_INT_V2,
+		.desc_size = sizeof(struct mtk_rx_dma),
+		.irq_done_mask = MTK_RX_DONE_INT,
 		.dma_l4_valid = RX_DMA_L4_VALID_V2,
-		.dma_max_len = MTK_TX_DMA_BUF_LEN_V2,
-		.dma_len_offset = 8,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN,
+		.dma_len_offset = 16,
 	},
 };
 
-- 
2.43.0



