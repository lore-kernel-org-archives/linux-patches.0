Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6B3FCB2F;
	Wed, 20 May 2026 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300313; cv=none; b=XnGoReJZ2p4HPU+wASPV+XMSQ0ES6/hJdGQPQIi1rtoT0YMsUFNDsz6w7SU7GXL+5IE5eRVMJXDQeKCD1U5CW+GTJXbf3hZKtjIwKQ4k6Vox68tUToh3MmNFsKfzecWtzwnx67TFL5Z9/p46GjBIVHPt0RQJKhKLlMrcX4CAyFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300313; c=relaxed/simple;
	bh=fDxacHg9Xgt4gAu2pijvAsx7n5rIm8k/rgTexNP0lpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxJS4kLWI53+wpssv0HFk1SDiernQ+ekzWZDIKDi7Tw2+e64oLdqmNUSC7AyuX0UbK4wLNZPAiguDZBwMw012VsETDfWX5Cj03k3ebOLRdQKBtHd5y+tWekcB4BqN0h0UBkmnDZVO6LJiluDbQutM0yKMiyI7JVgH7g/C2dTRyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/HRVy96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/HRVy96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC121F000E9;
	Wed, 20 May 2026 18:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300311;
	bh=gE0fg5P/qkrsH3fCNnjExXMEZrT/iTv+I9lpGldffDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/HRVy96BrqaFUWGk5ijX4LZoeJb7ORsOk6fyjHdf3H7eQZkD2enrw36oSJxsRiJ9
	 5H9RFZtJgJNxlFZCfLGt+K2lk36l2IlOb55AuAcbqcJr5wXd1MU5lzgyR5xEzKjO7N
	 SWF8ewCsrrkX12SmioUmiuC0GUQRZn2nWIGWEqQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/666] ASoC: add symmetric_ prefix for dai->rate/channels/sample_bits
Date: Wed, 20 May 2026 18:15:31 +0200
Message-ID: <20260520162113.818399856@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 1bd775da9ba919b87b2313a78d5957afc1a62dde ]

snd_soc_dai has rate/channels/sample_bits parameter, but it is only valid
if symmetry is being enforced by symmetric_xxx flag on driver.

It is very difficult to know about it from current naming, and easy to
misunderstand it. add symmetric_ prefix for it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87zfmd8bnf.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 07c774dd64ba ("ASoC: soc-compress: use function to clear symmetric params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dai.h                     |  6 ++---
 sound/soc/mediatek/mt8188/mt8188-dai-pcm.c  |  2 +-
 sound/soc/mediatek/mt8195/mt8195-dai-pcm.c  |  2 +-
 sound/soc/mediatek/mt8365/mt8365-dai-dmic.c |  6 ++---
 sound/soc/mediatek/mt8365/mt8365-dai-pcm.c  |  2 +-
 sound/soc/soc-compress.c                    |  4 +--
 sound/soc/soc-pcm.c                         | 29 +++++++++++----------
 7 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/include/sound/soc-dai.h b/include/sound/soc-dai.h
index 0d1b215f24f4f..4a3505674f2f2 100644
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -450,9 +450,9 @@ struct snd_soc_dai {
 	struct snd_soc_dai_stream stream[SNDRV_PCM_STREAM_LAST + 1];
 
 	/* Symmetry data - only valid if symmetry is being enforced */
-	unsigned int rate;
-	unsigned int channels;
-	unsigned int sample_bits;
+	unsigned int symmetric_rate;
+	unsigned int symmetric_channels;
+	unsigned int symmetric_sample_bits;
 
 	/* parent platform/codec */
 	struct snd_soc_component *component;
diff --git a/sound/soc/mediatek/mt8188/mt8188-dai-pcm.c b/sound/soc/mediatek/mt8188/mt8188-dai-pcm.c
index 5bc854a8f3df3..8ca7cc75e21dc 100644
--- a/sound/soc/mediatek/mt8188/mt8188-dai-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-dai-pcm.c
@@ -128,7 +128,7 @@ static int mtk_dai_pcm_configure(struct snd_pcm_substream *substream,
 	unsigned int lrck_inv;
 	unsigned int bck_inv;
 	unsigned int fmt;
-	unsigned int bit_width = dai->sample_bits;
+	unsigned int bit_width = dai->symmetric_sample_bits;
 	unsigned int val = 0;
 	unsigned int mask = 0;
 	int fs = 0;
diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c b/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c
index 6d6d79300d512..cdc16057d50e2 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c
@@ -127,7 +127,7 @@ static int mtk_dai_pcm_configure(struct snd_pcm_substream *substream,
 	unsigned int lrck_inv;
 	unsigned int bck_inv;
 	unsigned int fmt;
-	unsigned int bit_width = dai->sample_bits;
+	unsigned int bit_width = dai->symmetric_sample_bits;
 	unsigned int val = 0;
 	unsigned int mask = 0;
 	int fs = 0;
diff --git a/sound/soc/mediatek/mt8365/mt8365-dai-dmic.c b/sound/soc/mediatek/mt8365/mt8365-dai-dmic.c
index f9945c2a2cd13..0bac143b48bfb 100644
--- a/sound/soc/mediatek/mt8365/mt8365-dai-dmic.c
+++ b/sound/soc/mediatek/mt8365/mt8365-dai-dmic.c
@@ -118,13 +118,13 @@ static int mt8365_dai_configure_dmic(struct mtk_base_afe *afe,
 	unsigned int clk_phase_sel_ch1 = dmic_data->clk_phase_sel_ch1;
 	unsigned int clk_phase_sel_ch2 = dmic_data->clk_phase_sel_ch2;
 	unsigned int val = 0;
-	unsigned int rate = dai->rate;
-	int reg = get_chan_reg(dai->channels);
+	unsigned int rate = dai->symmetric_rate;
+	int reg = get_chan_reg(dai->symmetric_channels);
 
 	if (reg < 0)
 		return -EINVAL;
 
-	dmic_data->dmic_channel = dai->channels;
+	dmic_data->dmic_channel = dai->symmetric_channels;
 
 	val |= DMIC_TOP_CON_SDM3_LEVEL_MODE;
 
diff --git a/sound/soc/mediatek/mt8365/mt8365-dai-pcm.c b/sound/soc/mediatek/mt8365/mt8365-dai-pcm.c
index f85ec07249c3b..3373b88da28ea 100644
--- a/sound/soc/mediatek/mt8365/mt8365-dai-pcm.c
+++ b/sound/soc/mediatek/mt8365/mt8365-dai-pcm.c
@@ -44,7 +44,7 @@ static int mt8365_dai_configure_pcm1(struct snd_pcm_substream *substream,
 	bool lrck_inv = pcm_priv->lrck_inv;
 	bool bck_inv = pcm_priv->bck_inv;
 	unsigned int fmt = pcm_priv->format;
-	unsigned int bit_width = dai->sample_bits;
+	unsigned int bit_width = dai->symmetric_sample_bits;
 	unsigned int val = 0;
 
 	if (!slave_mode) {
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index e692aa3b8b22f..f787f60a16a11 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -69,10 +69,10 @@ static int soc_compr_clean(struct snd_compr_stream *cstream, int rollback)
 	snd_soc_dai_digital_mute(codec_dai, 1, stream);
 
 	if (!snd_soc_dai_active(cpu_dai))
-		cpu_dai->rate = 0;
+		cpu_dai->symmetric_rate = 0;
 
 	if (!snd_soc_dai_active(codec_dai))
-		codec_dai->rate = 0;
+		codec_dai->symmetric_rate = 0;
 
 	snd_soc_link_compr_shutdown(cstream, rollback);
 
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 0e21ff9f7b74e..83e6a76da7e63 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -462,13 +462,13 @@ static void soc_pcm_set_dai_params(struct snd_soc_dai *dai,
 				   struct snd_pcm_hw_params *params)
 {
 	if (params) {
-		dai->rate	 = params_rate(params);
-		dai->channels	 = params_channels(params);
-		dai->sample_bits = snd_pcm_format_physical_width(params_format(params));
+		dai->symmetric_rate	   = params_rate(params);
+		dai->symmetric_channels	   = params_channels(params);
+		dai->symmetric_sample_bits = snd_pcm_format_physical_width(params_format(params));
 	} else {
-		dai->rate	 = 0;
-		dai->channels	 = 0;
-		dai->sample_bits = 0;
+		dai->symmetric_rate	   = 0;
+		dai->symmetric_channels	   = 0;
+		dai->symmetric_sample_bits = 0;
 	}
 }
 
@@ -482,14 +482,14 @@ static int soc_pcm_apply_symmetry(struct snd_pcm_substream *substream,
 		return 0;
 
 #define __soc_pcm_apply_symmetry(name, NAME)				\
-	if (soc_dai->name && (soc_dai->driver->symmetric_##name ||	\
-			      rtd->dai_link->symmetric_##name)) {	\
+	if (soc_dai->symmetric_##name &&				\
+	    (soc_dai->driver->symmetric_##name || rtd->dai_link->symmetric_##name)) { \
 		dev_dbg(soc_dai->dev, "ASoC: Symmetry forces %s to %d\n",\
-			#name, soc_dai->name);				\
+			#name, soc_dai->symmetric_##name);		\
 									\
 		ret = snd_pcm_hw_constraint_single(substream->runtime,	\
 						   SNDRV_PCM_HW_PARAM_##NAME,\
-						   soc_dai->name);	\
+						   soc_dai->symmetric_##name);	\
 		if (ret < 0) {						\
 			dev_err(soc_dai->dev,				\
 				"ASoC: Unable to apply %s constraint: %d\n",\
@@ -525,9 +525,11 @@ static int soc_pcm_params_symmetry(struct snd_pcm_substream *substream,
 	if (symmetry)							\
 		for_each_rtd_cpu_dais(rtd, i, cpu_dai)			\
 			if (!snd_soc_dai_is_dummy(cpu_dai) &&		\
-			    cpu_dai->xxx && cpu_dai->xxx != d.xxx) {	\
+			    cpu_dai->symmetric_##xxx &&			\
+			    cpu_dai->symmetric_##xxx != d.symmetric_##xxx) { \
 				dev_err(rtd->dev, "ASoC: unmatched %s symmetry: %s:%d - %s:%d\n", \
-					#xxx, cpu_dai->name, cpu_dai->xxx, d.name, d.xxx); \
+					#xxx, cpu_dai->name, cpu_dai->symmetric_##xxx, \
+					d.name, d.symmetric_##xxx);	\
 				return -EINVAL;				\
 			}
 
@@ -798,8 +800,7 @@ static int soc_pcm_clean(struct snd_soc_pcm_runtime *rtd,
 
 		/* Make sure DAI parameters cleared if the DAI becomes inactive */
 		for_each_rtd_dais(rtd, i, dai) {
-			if (snd_soc_dai_active(dai) == 0 &&
-			    (dai->rate || dai->channels || dai->sample_bits))
+			if (snd_soc_dai_active(dai) == 0)
 				soc_pcm_set_dai_params(dai, NULL);
 		}
 	}
-- 
2.53.0



