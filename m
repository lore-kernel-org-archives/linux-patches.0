Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054826;
	b=M/d1dJXadVpw0qOoSO77DKs/9RVac0R7/bkUTBa9S1OBo+TeHzIwMN2K5doXhGr0rTvA
	 YCQubdCv4fgNwieZvrkjF1K7oLgaVXyugOPnGurPKB1AJGjNZndgKJK9Gz+nW3FXSR6t1
	 /jGLaeFOlRWCNK3nyDD1RCHUfTpp9aCw0pb4Mq5w+frzNvM579hu9+5yPDELlsVtUM36M
	 LV4ilQDwptlIMPghgcPUxRVeUiZawlJGN630Km57czWlmxPf9LsbHHftWGZsL4FWnqTdG
	 Q1Hj/GfjT0NcmWLQYzsKwhsdotflKp3OJPBGLWy+0DZ6CV2iDbInlBt0AFwYD/3LcXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J6wI2h6h2zeM8xoSfxlCoj6jGQT6NQzVWM+CE06Epn4=;
	b=ks+UkCAfJheUtJBW+oO+Il/e7PabXzt7N6A8BYa0F07JTg3HgEtIZHplDN2BFzZfBmR0
	 ywXnwn2EmxfjStNdA6MeVpLft7U5CTINrtVRI/gkxLY6oP3DdVor17l6wMEimhK1rDUOB
	 6RNNBeEvDrrxEZYTeufnTbjTeywMBC5Oq7dZa/WaLOEtPaCyYO611R3qEXNpHXWNdw67c
	 SbjBCoYB7P8v/A6dwKjk9rDNAWBIBXgeA2yxNvorQhPFlID/iSOHBdFsKR7OXE+U1wgyo
	 q/5xwv2fULnQIvfPSdSy+V6eADMkLRWGKsnKplfw2JiCWvtbIatzoZhdTYXPpLmltXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFMvk1oK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F94606A31C;
	Thu, 19 Nov 2026 02:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFMvk1oK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67BF1F000C4;
	Thu, 19 Nov 2026 02:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054826;
	bh=J6wI2h6h2zeM8xoSfxlCoj6jGQT6NQzVWM+CE06Epn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFMvk1oKHHon+sHFpM9YS8mM2oG6Da2tt1vSWH5b6Lsxgm8EChlnh0FK5eQYScsp4
	 h7idXodOWh4G9LN4b4SgkuujHqvMqKtfcr3FsuPB94WURppDn+T3U3ewtBO2UTKuqg
	 DMLrzNLDJSSfg/ufHuThHE+bTs01W8z1z8WNyUKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Walker Chen <walker.chen@starfivetech.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1412/2214] dmaengine: dw-axi-dmac: Add support for StarFive JH7110 DMA
Date: Wed, 18 Nov 2026 15:51:28 +0100
Message-ID: <20261118150107.736008318@linuxfoundation.org>
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

From: Walker Chen <walker.chen@starfivetech.com>

[ Upstream commit 790f3c8b8f9f63b1f5a3ffd06630ed3d0df9804c ]

Add DMA reset operation in device probe and use different configuration
on CH_CFG registers according to match data. Update all uses of
of_device_is_compatible with of_device_get_match_data.

Signed-off-by: Walker Chen <walker.chen@starfivetech.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Link: https://lore.kernel.org/r/20230322094820.24738-3-walker.chen@starfivetech.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c843417e6d6b ("dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dma/dw-axi-dmac/dw-axi-dmac-platform.c    | 38 ++++++++++++++++---
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h         |  1 +
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 02f2f52fff2af..2a57c49c8d3b1 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -21,10 +21,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/of_dma.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/property.h>
+#include <linux/reset.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -46,6 +48,10 @@
 	DMA_SLAVE_BUSWIDTH_32_BYTES	| \
 	DMA_SLAVE_BUSWIDTH_64_BYTES)
 
+#define AXI_DMA_FLAG_HAS_APB_REGS	BIT(0)
+#define AXI_DMA_FLAG_HAS_RESETS		BIT(1)
+#define AXI_DMA_FLAG_USE_CFG2		BIT(2)
+
 static inline void
 axi_dma_iowrite32(struct axi_dma_chip *chip, u32 reg, u32 val)
 {
@@ -86,7 +92,8 @@ static inline void axi_chan_config_write(struct axi_dma_chan *chan,
 
 	cfg_lo = (config->dst_multblk_type << CH_CFG_L_DST_MULTBLK_TYPE_POS |
 		  config->src_multblk_type << CH_CFG_L_SRC_MULTBLK_TYPE_POS);
-	if (chan->chip->dw->hdata->reg_map_8_channels) {
+	if (chan->chip->dw->hdata->reg_map_8_channels &&
+	    !chan->chip->dw->hdata->use_cfg2) {
 		cfg_hi = config->tt_fc << CH_CFG_H_TT_FC_POS |
 			 config->hs_sel_src << CH_CFG_H_HS_SEL_SRC_POS |
 			 config->hs_sel_dst << CH_CFG_H_HS_SEL_DST_POS |
@@ -1359,11 +1366,12 @@ static int parse_device_properties(struct axi_dma_chip *chip)
 
 static int dw_probe(struct platform_device *pdev)
 {
-	struct device_node *node = pdev->dev.of_node;
 	struct axi_dma_chip *chip;
 	struct resource *mem;
 	struct dw_axi_dma *dw;
 	struct dw_axi_dma_hcfg *hdata;
+	struct reset_control *resets;
+	unsigned int flags;
 	u32 i;
 	int ret;
 
@@ -1392,12 +1400,25 @@ static int dw_probe(struct platform_device *pdev)
 	if (IS_ERR(chip->regs))
 		return PTR_ERR(chip->regs);
 
-	if (of_device_is_compatible(node, "intel,kmb-axi-dma")) {
+	flags = (uintptr_t)of_device_get_match_data(&pdev->dev);
+	if (flags & AXI_DMA_FLAG_HAS_APB_REGS) {
 		chip->apb_regs = devm_platform_ioremap_resource(pdev, 1);
 		if (IS_ERR(chip->apb_regs))
 			return PTR_ERR(chip->apb_regs);
 	}
 
+	if (flags & AXI_DMA_FLAG_HAS_RESETS) {
+		resets = devm_reset_control_array_get_exclusive(&pdev->dev);
+		if (IS_ERR(resets))
+			return PTR_ERR(resets);
+
+		ret = reset_control_deassert(resets);
+		if (ret)
+			return ret;
+	}
+
+	chip->dw->hdata->use_cfg2 = !!(flags & AXI_DMA_FLAG_USE_CFG2);
+
 	chip->core_clk = devm_clk_get(chip->dev, "core-clk");
 	if (IS_ERR(chip->core_clk))
 		return PTR_ERR(chip->core_clk);
@@ -1550,8 +1571,15 @@ static const struct dev_pm_ops dw_axi_dma_pm_ops = {
 };
 
 static const struct of_device_id dw_dma_of_id_table[] = {
-	{ .compatible = "snps,axi-dma-1.01a" },
-	{ .compatible = "intel,kmb-axi-dma" },
+	{
+		.compatible = "snps,axi-dma-1.01a"
+	}, {
+		.compatible = "intel,kmb-axi-dma",
+		.data = (void *)AXI_DMA_FLAG_HAS_APB_REGS,
+	}, {
+		.compatible = "starfive,jh7110-axi-dma",
+		.data = (void *)(AXI_DMA_FLAG_HAS_RESETS | AXI_DMA_FLAG_USE_CFG2),
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, dw_dma_of_id_table);
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index 79521bb0c69b8..1fcc9662c61f5 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -33,6 +33,7 @@ struct dw_axi_dma_hcfg {
 	/* Register map for DMAX_NUM_CHANNELS <= 8 */
 	bool	reg_map_8_channels;
 	bool	restrict_axi_burst_len;
+	bool	use_cfg2;
 };
 
 struct axi_dma_chan {
-- 
2.53.0



