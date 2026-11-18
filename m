Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054823;
	b=EVA9lWWmr47DgIQGv8W7XrpRJaEc9u3IVmHqRKpoDdx+OO64UkgXtewBPPHGpivV0Zje
	 p2sliWDZ01JMgbG3G80VNTTb/xdRXlI7N71CVE2EYz6ASh66eRPaevFq4AeJrhlA3Ifrh
	 kZTZHV/80KNoGfvOOqz1KUnqJCrW+hBK/zrW1lIS/LJjWsrQ3uQBZFWzOQVYjg0cEJBnG
	 GhK81GzsI0cHGnXw2PnLFZD7Tzn/vtHpb1opd82v0alyKSTKr8Uu3pUR49CkOCheeiOo1
	 mEaQiJWVsB4gojKp0ZoiqVOeL6A1JFQWio856PxcBDqa2xdE52Id0Gwv78xFqReWIAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jwGVEUmalXZqwLZZFIXjyJ1C+OnvzjI0xlOPH1SAncI=;
	b=rTBWpJ1wNlTZGBNe8NIYgR+jYSj8Xh81c/T38qh6yl2b52x7i6oQlN6Ls1MUG9BdfS6D
	 IMEGAa2NbZrnZwlW/wuKevmZLZVsGpDTAZjrzU1lBteaAVtSMeg6GSS0OMn0mbXOQz5/v
	 shRDb6mxoElg4JO7kVjh1E/cz/dF0TzCLUBX6/YzTtE7rM6eeWP1ogmpjFp59VE+mCvr4
	 wtghg/BOYVFGG0xFTFOQaCI6BHAEODO7V7rrthYI8IH626b7cUbxzNxdqvzyAZDFnil58
	 AJ/dClbmQlF8NIKmMyG5hzFIxvvr7gwOXGPK0n6eph55v31KZhCF4ZkMV+Kd6o3x9JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbK6Rfu9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7096606A325;
	Thu, 19 Nov 2026 02:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbK6Rfu9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114D81F000C4;
	Thu, 19 Nov 2026 02:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054823;
	bh=jwGVEUmalXZqwLZZFIXjyJ1C+OnvzjI0xlOPH1SAncI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbK6Rfu9JiGjL4qgx6XY0g3hHV79iSyhfqhdVWeNj5ZfBigR/uaiW2mQBcwOx1fMu
	 hd1DLe3Ms+aDeYjoS4NcoLbyC0GkNzqGPNFMa2tip6Sv/mDSs0RW+aOd/WZZHGv0EI
	 xFr2R16Qa8IGMCIayjCHPyUTlpn2fMMsKRhu/t/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pandith N <pandith.n@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1411/2214] dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8
Date: Wed, 18 Nov 2026 15:51:27 +0100
Message-ID: <20261118150107.697468368@linuxfoundation.org>
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

From: Pandith N <pandith.n@intel.com>

[ Upstream commit 824351668a413af7d6d88e4ee2c9bee7c60daad2 ]

Added support for DMA controller with more than 8 channels.
DMAC register map changes based on number of channels.

Enabling DMAC channel:
DMAC_CHENREG has to be used when number of channels <= 8
DMAC_CHENREG2 has to be used when number of channels > 8

Configuring DMA channel:
CHx_CFG has to be used when number of channels <= 8
CHx_CFG2 has to be used when number of channels > 8

Suspending and resuming channel:
DMAC_CHENREG has to be used when number of channels <= 8 DMAC_CHSUSPREG
has to be used for suspending a channel > 8

Signed-off-by: Pandith N <pandith.n@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Link: https://lore.kernel.org/r/20211001140812.24977-2-pandith.n@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c843417e6d6b ("dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dma/dw-axi-dmac/dw-axi-dmac-platform.c    | 105 +++++++++++++-----
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h         |  35 +++++-
 2 files changed, 109 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index decfd838df3f4..02f2f52fff2af 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -79,6 +79,32 @@ axi_chan_iowrite64(struct axi_dma_chan *chan, u32 reg, u64 val)
 	iowrite32(upper_32_bits(val), chan->chan_regs + reg + 4);
 }
 
+static inline void axi_chan_config_write(struct axi_dma_chan *chan,
+					 struct axi_dma_chan_config *config)
+{
+	u32 cfg_lo, cfg_hi;
+
+	cfg_lo = (config->dst_multblk_type << CH_CFG_L_DST_MULTBLK_TYPE_POS |
+		  config->src_multblk_type << CH_CFG_L_SRC_MULTBLK_TYPE_POS);
+	if (chan->chip->dw->hdata->reg_map_8_channels) {
+		cfg_hi = config->tt_fc << CH_CFG_H_TT_FC_POS |
+			 config->hs_sel_src << CH_CFG_H_HS_SEL_SRC_POS |
+			 config->hs_sel_dst << CH_CFG_H_HS_SEL_DST_POS |
+			 config->src_per << CH_CFG_H_SRC_PER_POS |
+			 config->dst_per << CH_CFG_H_DST_PER_POS |
+			 config->prior << CH_CFG_H_PRIORITY_POS;
+	} else {
+		cfg_lo |= config->src_per << CH_CFG2_L_SRC_PER_POS |
+			  config->dst_per << CH_CFG2_L_DST_PER_POS;
+		cfg_hi = config->tt_fc << CH_CFG2_H_TT_FC_POS |
+			 config->hs_sel_src << CH_CFG2_H_HS_SEL_SRC_POS |
+			 config->hs_sel_dst << CH_CFG2_H_HS_SEL_DST_POS |
+			 config->prior << CH_CFG2_H_PRIORITY_POS;
+	}
+	axi_chan_iowrite32(chan, CH_CFG_L, cfg_lo);
+	axi_chan_iowrite32(chan, CH_CFG_H, cfg_hi);
+}
+
 static inline void axi_dma_disable(struct axi_dma_chip *chip)
 {
 	u32 val;
@@ -154,7 +180,10 @@ static inline void axi_chan_disable(struct axi_dma_chan *chan)
 
 	val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
 	val &= ~(BIT(chan->id) << DMAC_CHAN_EN_SHIFT);
-	val |=   BIT(chan->id) << DMAC_CHAN_EN_WE_SHIFT;
+	if (chan->chip->dw->hdata->reg_map_8_channels)
+		val |=   BIT(chan->id) << DMAC_CHAN_EN_WE_SHIFT;
+	else
+		val |=   BIT(chan->id) << DMAC_CHAN_EN2_WE_SHIFT;
 	axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
 }
 
@@ -163,8 +192,12 @@ static inline void axi_chan_enable(struct axi_dma_chan *chan)
 	u32 val;
 
 	val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
-	val |= BIT(chan->id) << DMAC_CHAN_EN_SHIFT |
-	       BIT(chan->id) << DMAC_CHAN_EN_WE_SHIFT;
+	if (chan->chip->dw->hdata->reg_map_8_channels)
+		val |= BIT(chan->id) << DMAC_CHAN_EN_SHIFT |
+			BIT(chan->id) << DMAC_CHAN_EN_WE_SHIFT;
+	else
+		val |= BIT(chan->id) << DMAC_CHAN_EN_SHIFT |
+			BIT(chan->id) << DMAC_CHAN_EN2_WE_SHIFT;
 	axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
 }
 
@@ -335,7 +368,8 @@ static void axi_chan_block_xfer_start(struct axi_dma_chan *chan,
 				      struct axi_dma_desc *first)
 {
 	u32 priority = chan->chip->dw->hdata->priority[chan->id];
-	u32 reg, irq_mask;
+	struct axi_dma_chan_config config;
+	u32 irq_mask;
 	u8 lms = 0; /* Select AXI0 master for LLI fetching */
 
 	if (unlikely(axi_chan_is_hw_enable(chan))) {
@@ -347,36 +381,32 @@ static void axi_chan_block_xfer_start(struct axi_dma_chan *chan,
 
 	axi_dma_enable(chan->chip);
 
-	reg = (DWAXIDMAC_MBLK_TYPE_LL << CH_CFG_L_DST_MULTBLK_TYPE_POS |
-	       DWAXIDMAC_MBLK_TYPE_LL << CH_CFG_L_SRC_MULTBLK_TYPE_POS);
-	axi_chan_iowrite32(chan, CH_CFG_L, reg);
-
-	reg = (DWAXIDMAC_TT_FC_MEM_TO_MEM_DMAC << CH_CFG_H_TT_FC_POS |
-	       priority << CH_CFG_H_PRIORITY_POS |
-	       DWAXIDMAC_HS_SEL_HW << CH_CFG_H_HS_SEL_DST_POS |
-	       DWAXIDMAC_HS_SEL_HW << CH_CFG_H_HS_SEL_SRC_POS);
+	config.dst_multblk_type = DWAXIDMAC_MBLK_TYPE_LL;
+	config.src_multblk_type = DWAXIDMAC_MBLK_TYPE_LL;
+	config.tt_fc = DWAXIDMAC_TT_FC_MEM_TO_MEM_DMAC;
+	config.prior = priority;
+	config.hs_sel_dst = DWAXIDMAC_HS_SEL_HW;
+	config.hs_sel_dst = DWAXIDMAC_HS_SEL_HW;
 	switch (chan->direction) {
 	case DMA_MEM_TO_DEV:
 		dw_axi_dma_set_byte_halfword(chan, true);
-		reg |= (chan->config.device_fc ?
-			DWAXIDMAC_TT_FC_MEM_TO_PER_DST :
-			DWAXIDMAC_TT_FC_MEM_TO_PER_DMAC)
-			<< CH_CFG_H_TT_FC_POS;
+		config.tt_fc = chan->config.device_fc ?
+				DWAXIDMAC_TT_FC_MEM_TO_PER_DST :
+				DWAXIDMAC_TT_FC_MEM_TO_PER_DMAC;
 		if (chan->chip->apb_regs)
-			reg |= (chan->id << CH_CFG_H_DST_PER_POS);
+			config.dst_per = chan->id;
 		break;
 	case DMA_DEV_TO_MEM:
-		reg |= (chan->config.device_fc ?
-			DWAXIDMAC_TT_FC_PER_TO_MEM_SRC :
-			DWAXIDMAC_TT_FC_PER_TO_MEM_DMAC)
-			<< CH_CFG_H_TT_FC_POS;
+		config.tt_fc = chan->config.device_fc ?
+				DWAXIDMAC_TT_FC_PER_TO_MEM_SRC :
+				DWAXIDMAC_TT_FC_PER_TO_MEM_DMAC;
 		if (chan->chip->apb_regs)
-			reg |= (chan->id << CH_CFG_H_SRC_PER_POS);
+			config.src_per = chan->id;
 		break;
 	default:
 		break;
 	}
-	axi_chan_iowrite32(chan, CH_CFG_H, reg);
+	axi_chan_config_write(chan, &config);
 
 	write_chan_llp(chan, first->hw_desc[0].llp | lms);
 
@@ -1136,10 +1166,17 @@ static int dma_chan_pause(struct dma_chan *dchan)
 
 	spin_lock_irqsave(&chan->vc.lock, flags);
 
-	val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
-	val |= BIT(chan->id) << DMAC_CHAN_SUSP_SHIFT |
-	       BIT(chan->id) << DMAC_CHAN_SUSP_WE_SHIFT;
-	axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
+	if (chan->chip->dw->hdata->reg_map_8_channels) {
+		val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
+		val |= BIT(chan->id) << DMAC_CHAN_SUSP_SHIFT |
+			BIT(chan->id) << DMAC_CHAN_SUSP_WE_SHIFT;
+		axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
+	} else {
+		val = 0;
+		val |= BIT(chan->id) << DMAC_CHAN_SUSP2_SHIFT |
+			BIT(chan->id) << DMAC_CHAN_SUSP2_WE_SHIFT;
+		axi_dma_iowrite32(chan->chip, DMAC_CHSUSPREG, val);
+	}
 
 	do  {
 		if (axi_chan_irq_read(chan) & DWAXIDMAC_IRQ_SUSPENDED)
@@ -1163,9 +1200,15 @@ static inline void axi_chan_resume(struct axi_dma_chan *chan)
 	u32 val;
 
 	val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
-	val &= ~(BIT(chan->id) << DMAC_CHAN_SUSP_SHIFT);
-	val |=  (BIT(chan->id) << DMAC_CHAN_SUSP_WE_SHIFT);
-	axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
+	if (chan->chip->dw->hdata->reg_map_8_channels) {
+		val &= ~(BIT(chan->id) << DMAC_CHAN_SUSP_SHIFT);
+		val |=  (BIT(chan->id) << DMAC_CHAN_SUSP_WE_SHIFT);
+		axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
+	} else {
+		val &= ~(BIT(chan->id) << DMAC_CHAN_SUSP2_SHIFT);
+		val |=  (BIT(chan->id) << DMAC_CHAN_SUSP2_WE_SHIFT);
+		axi_dma_iowrite32(chan->chip, DMAC_CHSUSPREG, val);
+	}
 
 	chan->is_paused = false;
 }
@@ -1257,6 +1300,8 @@ static int parse_device_properties(struct axi_dma_chip *chip)
 		return -EINVAL;
 
 	chip->dw->hdata->nr_channels = tmp;
+	if (tmp <= DMA_REG_MAP_CH_REF)
+		chip->dw->hdata->reg_map_8_channels = true;
 
 	ret = device_property_read_u32(dev, "snps,dma-masters", &tmp);
 	if (ret)
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index 58fc6310ee364..79521bb0c69b8 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -18,7 +18,7 @@
 
 #include "../virt-dma.h"
 
-#define DMAC_MAX_CHANNELS	8
+#define DMAC_MAX_CHANNELS	16
 #define DMAC_MAX_MASTERS	2
 #define DMAC_MAX_BLK_SIZE	0x200000
 
@@ -30,6 +30,8 @@ struct dw_axi_dma_hcfg {
 	u32	priority[DMAC_MAX_CHANNELS];
 	/* maximum supported axi burst length */
 	u32	axi_rw_burst_len;
+	/* Register map for DMAX_NUM_CHANNELS <= 8 */
+	bool	reg_map_8_channels;
 	bool	restrict_axi_burst_len;
 };
 
@@ -104,6 +106,17 @@ struct axi_dma_desc {
 	u32				nr_hw_descs;
 };
 
+struct axi_dma_chan_config {
+	u8 dst_multblk_type;
+	u8 src_multblk_type;
+	u8 dst_per;
+	u8 src_per;
+	u8 tt_fc;
+	u8 prior;
+	u8 hs_sel_dst;
+	u8 hs_sel_src;
+};
+
 static inline struct device *dchan2dev(struct dma_chan *dchan)
 {
 	return &dchan->dev->device;
@@ -140,6 +153,8 @@ static inline struct axi_dma_chan *dchan_to_axi_dma_chan(struct dma_chan *dchan)
 #define DMAC_CHEN		0x018 /* R/W DMAC Channel Enable */
 #define DMAC_CHEN_L		0x018 /* R/W DMAC Channel Enable 00-31 */
 #define DMAC_CHEN_H		0x01C /* R/W DMAC Channel Enable 32-63 */
+#define DMAC_CHSUSPREG		0x020 /* R/W DMAC Channel Suspend */
+#define DMAC_CHABORTREG		0x028 /* R/W DMAC Channel Abort */
 #define DMAC_INTSTATUS		0x030 /* R DMAC Interrupt Status */
 #define DMAC_COMMON_INTCLEAR	0x038 /* W DMAC Interrupt Clear */
 #define DMAC_COMMON_INTSTATUS_ENA 0x040 /* R DMAC Interrupt Status Enable */
@@ -188,6 +203,7 @@ static inline struct axi_dma_chan *dchan_to_axi_dma_chan(struct dma_chan *dchan)
 #define DMA_APB_HS_SEL_BIT_SIZE	0x08 /* HW handshake bits per channel */
 #define DMA_APB_HS_SEL_MASK	0xFF /* HW handshake select masks */
 #define MAX_BLOCK_SIZE		0x1000 /* 1024 blocks * 4 bytes data width */
+#define DMA_REG_MAP_CH_REF	0x08 /* Channel count to choose register map */
 
 /* DMAC_CFG */
 #define DMAC_EN_POS			0
@@ -196,12 +212,20 @@ static inline struct axi_dma_chan *dchan_to_axi_dma_chan(struct dma_chan *dchan)
 #define INT_EN_POS			1
 #define INT_EN_MASK			BIT(INT_EN_POS)
 
+/* DMAC_CHEN */
 #define DMAC_CHAN_EN_SHIFT		0
 #define DMAC_CHAN_EN_WE_SHIFT		8
 
 #define DMAC_CHAN_SUSP_SHIFT		16
 #define DMAC_CHAN_SUSP_WE_SHIFT		24
 
+/* DMAC_CHEN2 */
+#define DMAC_CHAN_EN2_WE_SHIFT		16
+
+/* DMAC_CHSUSP */
+#define DMAC_CHAN_SUSP2_SHIFT		0
+#define DMAC_CHAN_SUSP2_WE_SHIFT	16
+
 /* CH_CTL_H */
 #define CH_CTL_H_ARLEN_EN		BIT(6)
 #define CH_CTL_H_ARLEN_POS		7
@@ -290,6 +314,15 @@ enum {
 	DWAXIDMAC_MBLK_TYPE_LL
 };
 
+/* CH_CFG2 */
+#define CH_CFG2_L_SRC_PER_POS		4
+#define CH_CFG2_L_DST_PER_POS		11
+
+#define CH_CFG2_H_TT_FC_POS		0
+#define CH_CFG2_H_HS_SEL_SRC_POS	3
+#define CH_CFG2_H_HS_SEL_DST_POS	4
+#define CH_CFG2_H_PRIORITY_POS		20
+
 /**
  * DW AXI DMA channel interrupts
  *
-- 
2.53.0



