Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694B14FECE0;
	Wed, 30 Sep 2026 16:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785084; cv=none; b=mbuC0twtvvad7M7/eJBcQaRv+DHRBstJsioR15F6tuf6pQHO1vwykwAPtMht8hddGFr000uGUPXReO13AwNfYcy8Yu4tNBaGYrAJP2E3wpKJo68L0r99+fK4X9z4slxu+DFV63375Azrsb5qeQlSJ1e8KitEaAeFZQx3+t027IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785084; c=relaxed/simple;
	bh=FoUcBYph8yhjLkbBmVYXOA4rgDKApGcmL5kUsueqvIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phQi23mefMZv0prH8mqmj/muu2/QSs2DNAESQf9dAGztJEKI1WdItkygLsw/AwMo+vLFSeON1efz3A6XGvA2MjrGjwCtjDIL1/h9mEZ2+Nyi8b0jxTzyLKxAy+wuAEzuM9xz1DtgB7rC/bZx9cR9NJj0ZLn+InCdwSZJNTOGsz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaILgVBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaILgVBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20EE1F000FF;
	Wed, 30 Sep 2026 16:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785079;
	bh=OO0t7ZaF/0dqCt7YXGMJStrgtoQDHWpMKjKSB+SA1VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaILgVBe2pT+RarxNazOFTkj26oufY7eblqZ6dQEExUigRGvymCtBF8BYTYAQArgD
	 jjoYZwPs5JvfAVLNyUg4wgEhU3ATAbdT2M1FYYRzR3yYDMshBKPv/QjH66QaLtCdur
	 +N8q5RU/DxNUD2YalLVe8yTJX6ufJIMa0hdjFeJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 381/982] ASoC: ux500: remove stedma40 references
Date: Wed, 30 Sep 2026 17:18:37 +0200
Message-ID: <20260930152424.992508863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit aafe9375b386010e28614f58499d199250a16874 ]

ux500_pcm_request_chan() is never called because the dma channels
are already set up from DT. Remove this, along with the
ux500_msp_dma_params structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230118161110.521504-4-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 4fb67925f33a ("ASoC: ux500: Request the MSP MMIO resource")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_dai.c |    4 +--
 sound/soc/ux500/ux500_msp_i2s.c |   41 --------------------------------------
 sound/soc/ux500/ux500_msp_i2s.h |    9 --------
 sound/soc/ux500/ux500_pcm.c     |   43 ----------------------------------------
 4 files changed, 5 insertions(+), 92 deletions(-)

--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -640,8 +640,8 @@ static int ux500_msp_dai_of_probe(struct
 	if (!capture_dma_data)
 		return -ENOMEM;
 
-	playback_dma_data->addr = drvdata->msp->playback_dma_data.tx_rx_addr;
-	capture_dma_data->addr = drvdata->msp->capture_dma_data.tx_rx_addr;
+	playback_dma_data->addr = drvdata->msp->tx_rx_addr;
+	capture_dma_data->addr = drvdata->msp->tx_rx_addr;
 
 	playback_dma_data->maxburst = 4;
 	capture_dma_data->maxburst = 4;
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -377,20 +377,6 @@ static int enable_msp(struct ux500_msp *
 			return status;
 	}
 
-	/* Make sure the correct DMA-directions are configured */
-	if ((config->direction & MSP_DIR_RX) &&
-			!msp->capture_dma_data.dma_cfg) {
-		dev_err(msp->dev, "%s: ERROR: MSP RX-mode is not configured!",
-			__func__);
-		return -EINVAL;
-	}
-	if ((config->direction == MSP_DIR_TX) &&
-			!msp->playback_dma_data.dma_cfg) {
-		dev_err(msp->dev, "%s: ERROR: MSP TX-mode is not configured!",
-			__func__);
-		return -EINVAL;
-	}
-
 	reg_val_DMACR = readl(msp->registers + MSP_DMACR);
 	if (config->direction & MSP_DIR_RX)
 		reg_val_DMACR |= RX_DMA_ENABLE;
@@ -744,40 +730,17 @@ int ux500_msp_i2s_close(struct ux500_msp
 
 }
 
-static int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
-				struct ux500_msp *msp);
-{
-	msp->playback_dma_data.dma_cfg = devm_kzalloc(&pdev->dev,
-					sizeof(struct stedma40_chan_cfg),
-					GFP_KERNEL);
-	if (!msp->playback_dma_data.dma_cfg)
-		return -ENOMEM;
-
-	msp->capture_dma_data.dma_cfg = devm_kzalloc(&pdev->dev,
-					sizeof(struct stedma40_chan_cfg),
-					GFP_KERNEL);
-	if (!msp->capture_dma_data.dma_cfg)
-		return -ENOMEM;
-
-	return 0;
-}
-
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p)
 {
 	struct resource *res = NULL;
 	struct ux500_msp *msp;
-	int ret;
 
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
 	msp = *msp_p;
 	if (!msp)
 		return -ENOMEM;
 
-	ret = ux500_msp_i2s_of_init_msp(pdev, msp);
-	if (ret)
-		return ret;
-
 	msp->dev = &pdev->dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -787,9 +750,7 @@ int ux500_msp_i2s_init_msp(struct platfo
 		return -ENOMEM;
 	}
 
-	msp->playback_dma_data.tx_rx_addr = res->start + MSP_DR;
-	msp->capture_dma_data.tx_rx_addr = res->start + MSP_DR;
-
+	msp->tx_rx_addr = res->start + MSP_DR;
 	msp->registers = devm_ioremap(&pdev->dev, res->start,
 				      resource_size(res));
 	if (msp->registers == NULL) {
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -462,18 +462,11 @@ struct ux500_msp_config {
 	bool bclk_inverted;
 };
 
-struct ux500_msp_dma_params {
-	unsigned int data_size;
-	dma_addr_t tx_rx_addr;
-	struct stedma40_chan_cfg *dma_cfg;
-};
-
 struct ux500_msp {
 	int id;
 	void __iomem *registers;
 	struct device *dev;
-	struct ux500_msp_dma_params playback_dma_data;
-	struct ux500_msp_dma_params capture_dma_data;
+	dma_addr_t tx_rx_addr;
 	enum msp_state msp_state;
 	int def_elem_len;
 	unsigned int dir_busy;
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -13,7 +13,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/slab.h>
-#include <linux/platform_data/dma-ste-dma40.h>
 
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -29,44 +28,6 @@
 #define UX500_PLATFORM_PERIODS_MAX		48
 #define UX500_PLATFORM_BUFFER_BYTES_MAX		(2048 * PAGE_SIZE)
 
-static struct dma_chan *ux500_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
-	struct snd_pcm_substream *substream)
-{
-	struct snd_soc_dai *dai = asoc_rtd_to_cpu(rtd, 0);
-	u16 per_data_width, mem_data_width;
-	struct stedma40_chan_cfg *dma_cfg;
-	struct ux500_msp_dma_params *dma_params;
-
-	dma_params = snd_soc_dai_get_dma_data(dai, substream);
-	dma_cfg = dma_params->dma_cfg;
-
-	mem_data_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-
-	switch (dma_params->data_size) {
-	case 32:
-		per_data_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		break;
-	case 16:
-		per_data_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-		break;
-	case 8:
-		per_data_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-		break;
-	default:
-		per_data_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	}
-
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		dma_cfg->src_info.data_width = mem_data_width;
-		dma_cfg->dst_info.data_width = per_data_width;
-	} else {
-		dma_cfg->src_info.data_width = per_data_width;
-		dma_cfg->dst_info.data_width = mem_data_width;
-	}
-
-	return snd_dmaengine_pcm_request_channel(stedma40_filter, dma_cfg);
-}
-
 static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 		struct snd_pcm_hw_params *params,
 		struct dma_slave_config *slave_config)
@@ -98,7 +59,6 @@ static int ux500_pcm_prepare_slave_confi
 }
 
 static const struct snd_dmaengine_pcm_config ux500_dmaengine_of_pcm_config = {
-	.compat_request_channel = ux500_pcm_request_chan,
 	.prepare_slave_config = ux500_pcm_prepare_slave_config,
 };
 
@@ -107,8 +67,7 @@ int ux500_pcm_register_platform(struct p
 	int ret;
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev,
-					 &ux500_dmaengine_of_pcm_config,
-					 SND_DMAENGINE_PCM_FLAG_COMPAT);
+					 &ux500_dmaengine_of_pcm_config, 0);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"%s: ERROR: Failed to register platform '%s' (%d)!\n",


