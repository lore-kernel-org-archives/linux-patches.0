Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E94D51AFD5;
	Wed, 30 Sep 2026 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791498; cv=none; b=fE14ap3wkyBcMfxuSF861zbsBjb/0sXdY6Pq/PDUMFUgj2d+C7HUF6+6N+FzwJM07oDc6Udbe6Hr+H5GyJWn0PYr7jV/tL7WL7jgSGOdd34Hjd5Q+sxjPXAEb8k5vmJ9nZLgDF2yymvlB4OPEPiH64Fp7Wo8Tou+8WkPYl59z30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791498; c=relaxed/simple;
	bh=/F0K0QX+GeRC8O5TM1tVj7fG8Xjc6WrP4+rxXnyP38E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFfmb1xLI1bL/DDsfgnfrdX6gNKNHgajVFtjqaLGZ5eX1Bx7h1wiqNCn930i/yu+JK5Azz/k5MgY8O/kri3LONPy61aBrUJZv4Yr2WRdKFytlMl0lDesyGKEiGzbgYkl0ddlvqm/h2yb7SclfIzFBllVEQmbR0GQROUvlS4cc+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTGnVFEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTGnVFEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AE01F000FF;
	Wed, 30 Sep 2026 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791497;
	bh=ndLTH0f60RvdOL4OHUhAlvrGi8rpaYRMAUawjVEul24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTGnVFEJmZ9XmDg4+71XTasNEzsySVCKeYXM9a14odP2icW7wQ+I4VKPFxyKxtbX5
	 58fleN5dSSJ42UzA6j1s78mHte0QA2m/iZa917LZbXn/0ISVknMtusog/Sby8U4R9r
	 r7oVpcdmyB+I0RGblbb07XE43rJf/xWwPAP/zs1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/752] ASoC: ux500: remove platform_data support
Date: Wed, 30 Sep 2026 17:22:28 +0200
Message-ID: <20260930152404.305700898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1766ac5248063c25d1fe46e04bb936c46313ed89 ]

The platform data definition for ux500 sound devices was removed
six years ago after the DT conversion was completed, see commit
4b483ed0be8b ("ARM: ux500: cut some platform data").

Remove some leftover bits in the ASoC driver and just assume that
it always gets probed using DT.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230118161110.521504-3-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3415421a2b0b ("ASoC: ux500: Propagate MSP setup errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_data/asoc-ux500-msp.h | 20 ----------
 sound/soc/ux500/mop500.c                     |  8 ++--
 sound/soc/ux500/ux500_msp_dai.c              | 33 +--------------
 sound/soc/ux500/ux500_msp_i2s.c              | 33 +++------------
 sound/soc/ux500/ux500_msp_i2s.h              |  5 +--
 sound/soc/ux500/ux500_pcm.c                  | 42 ++------------------
 6 files changed, 15 insertions(+), 126 deletions(-)
 delete mode 100644 include/linux/platform_data/asoc-ux500-msp.h

diff --git a/include/linux/platform_data/asoc-ux500-msp.h b/include/linux/platform_data/asoc-ux500-msp.h
deleted file mode 100644
index b8d0f730dda8d..0000000000000
--- a/include/linux/platform_data/asoc-ux500-msp.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- */
-
-#ifndef __MSP_H
-#define __MSP_H
-
-#include <linux/platform_data/dma-ste-dma40.h>
-
-/* Platform data structure for a MSP I2S-device */
-struct msp_i2s_platform_data {
-	int id;
-	struct stedma40_chan_cfg *msp_i2s_dma_rx;
-	struct stedma40_chan_cfg *msp_i2s_dma_tx;
-};
-
-#endif
diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 4f41bb0ab2b00..aa5ba58891237 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -111,11 +111,9 @@ static int mop500_probe(struct platform_device *pdev)
 
 	mop500_card.dev = &pdev->dev;
 
-	if (np) {
-		ret = mop500_of_probe(pdev, np);
-		if (ret)
-			return ret;
-	}
+	ret = mop500_of_probe(pdev, np);
+	if (ret)
+		return ret;
 
 	dev_dbg(&pdev->dev, "%s: Card %s: Set platform drvdata.\n",
 		__func__, mop500_card.name);
diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index e63f8f8cf12f4..8d57ee06c46d6 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -17,7 +17,6 @@
 #include <linux/of.h>
 #include <linux/regulator/consumer.h>
 #include <linux/mfd/dbx500-prcmu.h>
-#include <linux/platform_data/asoc-ux500-msp.h>
 
 #include <sound/soc.h>
 #include <sound/soc-dai.h>
@@ -688,26 +687,6 @@ static int ux500_msp_dai_of_probe(struct snd_soc_dai *dai)
 	return 0;
 }
 
-static int ux500_msp_dai_probe(struct snd_soc_dai *dai)
-{
-	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(dai->dev);
-	struct msp_i2s_platform_data *pdata = dai->dev->platform_data;
-	int ret;
-
-	if (!pdata) {
-		ret = ux500_msp_dai_of_probe(dai);
-		return ret;
-	}
-
-	drvdata->msp->playback_dma_data.data_size = drvdata->slot_width;
-	drvdata->msp->capture_dma_data.data_size = drvdata->slot_width;
-
-	snd_soc_dai_init_dma_data(dai,
-				  &drvdata->msp->playback_dma_data,
-				  &drvdata->msp->capture_dma_data);
-	return 0;
-}
-
 static const struct snd_soc_dai_ops ux500_msp_dai_ops[] = {
 	{
 		.set_sysclk = ux500_msp_dai_set_dai_sysclk,
@@ -722,7 +701,7 @@ static const struct snd_soc_dai_ops ux500_msp_dai_ops[] = {
 };
 
 static struct snd_soc_dai_driver ux500_msp_dai_drv = {
-	.probe                 = ux500_msp_dai_probe,
+	.probe                 = ux500_msp_dai_of_probe,
 	.playback.channels_min = UX500_MSP_MIN_CHANNELS,
 	.playback.channels_max = UX500_MSP_MAX_CHANNELS,
 	.playback.rates        = UX500_I2S_RATES,
@@ -742,15 +721,8 @@ static const struct snd_soc_component_driver ux500_msp_component = {
 static int ux500_msp_drv_probe(struct platform_device *pdev)
 {
 	struct ux500_msp_i2s_drvdata *drvdata;
-	struct msp_i2s_platform_data *pdata = pdev->dev.platform_data;
-	struct device_node *np = pdev->dev.of_node;
 	int ret = 0;
 
-	if (!pdata && !np) {
-		dev_err(&pdev->dev, "No platform data or Device Tree found\n");
-		return -ENODEV;
-	}
-
 	drvdata = devm_kzalloc(&pdev->dev,
 				sizeof(struct ux500_msp_i2s_drvdata),
 				GFP_KERNEL);
@@ -792,8 +764,7 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = ux500_msp_i2s_init_msp(pdev, &drvdata->msp,
-				pdev->dev.platform_data);
+	ret = ux500_msp_i2s_init_msp(pdev, &drvdata->msp);
 	if (!drvdata->msp) {
 		dev_err(&pdev->dev,
 			"%s: ERROR: Failed to init MSP-struct (%d)!",
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 2016549ecf9d2..0b266b682f8b1 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/of.h>
-#include <linux/platform_data/asoc-ux500-msp.h>
 
 #include <sound/soc.h>
 
@@ -737,18 +736,8 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 }
 
 static int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
-				struct ux500_msp *msp,
-				struct msp_i2s_platform_data **platform_data)
+				struct ux500_msp *msp);
 {
-	struct msp_i2s_platform_data *pdata;
-
-	*platform_data = devm_kzalloc(&pdev->dev,
-				     sizeof(struct msp_i2s_platform_data),
-				     GFP_KERNEL);
-	pdata = *platform_data;
-	if (!pdata)
-		return -ENOMEM;
-
 	msp->playback_dma_data.dma_cfg = devm_kzalloc(&pdev->dev,
 					sizeof(struct stedma40_chan_cfg),
 					GFP_KERNEL);
@@ -765,11 +754,9 @@ static int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
 }
 
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
-			struct ux500_msp **msp_p,
-			struct msp_i2s_platform_data *platform_data)
+			struct ux500_msp **msp_p)
 {
 	struct resource *res = NULL;
-	struct device_node *np = pdev->dev.of_node;
 	struct ux500_msp *msp;
 	int ret;
 
@@ -778,19 +765,9 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 	if (!msp)
 		return -ENOMEM;
 
-	if (!platform_data) {
-		if (np) {
-			ret = ux500_msp_i2s_of_init_msp(pdev, msp,
-							&platform_data);
-			if (ret)
-				return ret;
-		} else
-			return -EINVAL;
-	} else {
-		msp->playback_dma_data.dma_cfg = platform_data->msp_i2s_dma_tx;
-		msp->capture_dma_data.dma_cfg = platform_data->msp_i2s_dma_rx;
-		msp->id = platform_data->id;
-	}
+	ret = ux500_msp_i2s_of_init_msp(pdev, msp);
+	if (ret)
+		return ret;
 
 	msp->dev = &pdev->dev;
 
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index eb19f6392d19f..9b9500492dc73 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -13,7 +13,6 @@
 #define UX500_MSP_I2S_H
 
 #include <linux/platform_device.h>
-#include <linux/platform_data/asoc-ux500-msp.h>
 
 #define MSP_INPUT_FREQ_APB 48000000
 
@@ -488,10 +487,8 @@ struct ux500_msp {
 	struct ux500_msp_config config;
 };
 
-struct msp_i2s_platform_data;
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
-			struct ux500_msp **msp_p,
-			struct msp_i2s_platform_data *platform_data);
+			struct ux500_msp **msp_p);
 void ux500_msp_i2s_cleanup_msp(struct platform_device *pdev,
 			struct ux500_msp *msp);
 int ux500_msp_i2s_open(struct ux500_msp *msp, struct ux500_msp_config *config);
diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 18191084b8b84..c5c0d1c719e29 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -31,18 +31,6 @@
 #define UX500_PLATFORM_PERIODS_MAX		48
 #define UX500_PLATFORM_BUFFER_BYTES_MAX		(2048 * PAGE_SIZE)
 
-static const struct snd_pcm_hardware ux500_pcm_hw = {
-	.info = SNDRV_PCM_INFO_INTERLEAVED |
-		SNDRV_PCM_INFO_MMAP |
-		SNDRV_PCM_INFO_RESUME |
-		SNDRV_PCM_INFO_PAUSE,
-	.buffer_bytes_max = UX500_PLATFORM_BUFFER_BYTES_MAX,
-	.period_bytes_min = UX500_PLATFORM_PERIODS_BYTES_MIN,
-	.period_bytes_max = UX500_PLATFORM_PERIODS_BYTES_MAX,
-	.periods_min = UX500_PLATFORM_PERIODS_MIN,
-	.periods_max = UX500_PLATFORM_PERIODS_MAX,
-};
-
 static struct dma_chan *ux500_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
 	struct snd_pcm_substream *substream)
 {
@@ -86,21 +74,12 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 		struct dma_slave_config *slave_config)
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct msp_i2s_platform_data *pdata = asoc_rtd_to_cpu(rtd, 0)->dev->platform_data;
 	struct snd_dmaengine_dai_dma_data *snd_dma_params;
-	struct ux500_msp_dma_params *ste_dma_params;
 	dma_addr_t dma_addr;
 	int ret;
 
-	if (pdata) {
-		ste_dma_params =
-			snd_soc_dai_get_dma_data(asoc_rtd_to_cpu(rtd, 0), substream);
-		dma_addr = ste_dma_params->tx_rx_addr;
-	} else {
-		snd_dma_params =
-			snd_soc_dai_get_dma_data(asoc_rtd_to_cpu(rtd, 0), substream);
-		dma_addr = snd_dma_params->addr;
-	}
+	snd_dma_params = snd_soc_dai_get_dma_data(asoc_rtd_to_cpu(rtd, 0), substream);
+	dma_addr = snd_dma_params->addr;
 
 	ret = snd_hwparams_to_dma_slave_config(substream, params, slave_config);
 	if (ret)
@@ -120,13 +99,6 @@ static int ux500_pcm_prepare_slave_config(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static const struct snd_dmaengine_pcm_config ux500_dmaengine_pcm_config = {
-	.pcm_hardware = &ux500_pcm_hw,
-	.compat_request_channel = ux500_pcm_request_chan,
-	.prealloc_buffer_size = 128 * 1024,
-	.prepare_slave_config = ux500_pcm_prepare_slave_config,
-};
-
 static const struct snd_dmaengine_pcm_config ux500_dmaengine_of_pcm_config = {
 	.compat_request_channel = ux500_pcm_request_chan,
 	.prepare_slave_config = ux500_pcm_prepare_slave_config,
@@ -134,16 +106,10 @@ static const struct snd_dmaengine_pcm_config ux500_dmaengine_of_pcm_config = {
 
 int ux500_pcm_register_platform(struct platform_device *pdev)
 {
-	const struct snd_dmaengine_pcm_config *pcm_config;
-	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
-	if (np)
-		pcm_config = &ux500_dmaengine_of_pcm_config;
-	else
-		pcm_config = &ux500_dmaengine_pcm_config;
-
-	ret = snd_dmaengine_pcm_register(&pdev->dev, pcm_config,
+	ret = snd_dmaengine_pcm_register(&pdev->dev,
+					 &ux500_dmaengine_of_pcm_config,
 					 SND_DMAENGINE_PCM_FLAG_COMPAT);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
-- 
2.53.0



