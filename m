Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214889;
	b=ADPpwsldJJ37Vk7TacPiiDmTOwooNdJ4fi/TgWnanAp4z+DnpBUWxSqPozrNidP/auOC
	 ASRqFNcY+xUdRIVmgkhRUxtevv+UfYnyQ6y0FDHV8MMrAvAmZwzIiwkdGKf6XCpd5Q+aV
	 GLEKPVztwhexuGNiAE8JRsx3V7TT6ulYCMoPyVgXzVtiEhCx3x6O04lRt6cESZQyeEl5A
	 kvlvxqf4UEjOHXj9wyEyFm3u6+vhYoLl1I9Ic0qPD85tVI6vGPd9LunWO8hJ+YL/Guurs
	 wCb9eMCizOtD9rAoA6PevKXeg9c6dNa7YJrehRET3sVpLRxk28I1HD5HwUHxOm/gpkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lW9m68/sHILJcZoz0y/00Y0xnCKf+4Na48bPEgKxDIo=;
	b=A4EUAAPn1PbXuA2xcYdqq7NhthZ+WVgzKdA5l5HV4/vQk6nZeUKJSdHLtf5P4ScxfIEq
	 v4OUbpOfUmkN60DYHHe1+x8vVZB0wCNDJ4kgB3EKSy8G2+rT8Z/XoP3jq68BYQMy9DAxE
	 IB5MuRfh7enqiVwhq73jIgEEz+xd7lvgYg95PqapywdAvls8kLxmAMKH3qhMQITMoiaBt
	 weoem44wJqx7VGjtHMoRF/7jTPYyXn1aP3Jgbkuv5n+maJvS2p0KXUBzeovJ4aOvxJlMf
	 0Lg5WbHH1c4UtHmvTzSLHvq76KQtc/HsPe57geDKQ4RW7D/06mXiS62/o9Wl5TyMvvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgHFdFZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962B3606AB01;
	Wed, 28 Oct 2026 19:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgHFdFZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78501F01825;
	Wed, 28 Oct 2026 19:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214889;
	bh=lW9m68/sHILJcZoz0y/00Y0xnCKf+4Na48bPEgKxDIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgHFdFZBd8cqTZl6BKmpECyZm9zWhO+ZR5TO22P9XFubMBpNuldW5TUOpYRH1H+76
	 818AdAxSF+LlBesG653vIoWuFqaP/AzaJ+buKBQDsIeq1fkW4wOeb51xH95A6PwFS6
	 kkvF37M1yAP7KdCIkzazysdJLIr8NEII2Wz8wI1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1018/1887] ASoC: amd: acp: Refactor dai format implementation
Date: Wed, 28 Oct 2026 17:51:54 +0100
Message-ID: <20261028170522.582011376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit af830fc44a2d273b163e76b17f51b128ce694481 ]

Refactor dai format implementation in dai_link specific
snd_soc_ops.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://lore.kernel.org/r/20230109132104.1259479-3-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 30c64fb98399 ("ASoC: amd: acp-mach-common: Add missing error check for clock acquisition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 152 ++++++++++++++++++++++------
 1 file changed, 122 insertions(+), 30 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index a78cf29387a77..543d1fdc4976a 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -86,13 +86,6 @@ static int acp_card_rt5682_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != RT5682)
 		return -EINVAL;
 
-	ret =  snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF
-				   | SND_SOC_DAIFMT_CBP_CFP);
-	if (ret < 0) {
-		dev_err(rtd->card->dev, "Failed to set dai fmt: %d\n", ret);
-		return ret;
-	}
-
 	ret = snd_soc_dai_set_pll(codec_dai, RT5682_PLL2, RT5682_PLL2_S_MCLK,
 				  PCO_PLAT_CLK, RT5682_PLL_FREQ);
 	if (ret < 0) {
@@ -191,9 +184,41 @@ static void acp_card_shutdown(struct snd_pcm_substream *substream)
 		clk_disable_unprepare(drvdata->wclk);
 }
 
+static int acp_card_rt5682_hw_params(struct snd_pcm_substream *substream,
+				      struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_card *card = rtd->card;
+	struct acp_card_drvdata *drvdata = card->drvdata;
+	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	int ret;
+	unsigned int fmt;
+
+	if (drvdata->soc_mclk)
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
+	else
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
+	if (ret && ret != -ENOTSUPP) {
+		dev_err(rtd->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
+	ret =  snd_soc_dai_set_fmt(codec_dai, fmt);
+	if (ret < 0) {
+		dev_err(rtd->card->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static const struct snd_soc_ops acp_card_rt5682_ops = {
 	.startup = acp_card_hs_startup,
 	.shutdown = acp_card_shutdown,
+	.hw_params = acp_card_rt5682_hw_params,
 };
 
 /* Define RT5682S CODEC component*/
@@ -212,7 +237,6 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 	struct acp_card_drvdata *drvdata = card->drvdata;
 	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
 	struct snd_soc_component *component = codec_dai->component;
-	unsigned int fmt;
 	int ret;
 
 	dev_info(rtd->dev, "codec dai name = %s\n", codec_dai->name);
@@ -220,17 +244,6 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != RT5682S)
 		return -EINVAL;
 
-	if (drvdata->soc_mclk)
-		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
-	else
-		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
-
-	ret =  snd_soc_dai_set_fmt(codec_dai, fmt);
-	if (ret < 0) {
-		dev_err(rtd->card->dev, "Failed to set dai fmt: %d\n", ret);
-		return ret;
-	}
-
 	ret = snd_soc_dai_set_pll(codec_dai, RT5682S_PLL2, RT5682S_PLL_S_MCLK,
 				  PCO_PLAT_CLK, RT5682_PLL_FREQ);
 	if (ret < 0) {
@@ -281,8 +294,40 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 	return snd_soc_dapm_add_routes(&rtd->card->dapm, rt5682s_map, ARRAY_SIZE(rt5682s_map));
 }
 
+static int acp_card_rt5682s_hw_params(struct snd_pcm_substream *substream,
+				      struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_card *card = rtd->card;
+	struct acp_card_drvdata *drvdata = card->drvdata;
+	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	int ret;
+	unsigned int fmt;
+
+	if (drvdata->soc_mclk)
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
+	else
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
+	if (ret && ret != -ENOTSUPP) {
+		dev_err(rtd->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
+	ret =  snd_soc_dai_set_fmt(codec_dai, fmt);
+	if (ret < 0) {
+		dev_err(rtd->card->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static const struct snd_soc_ops acp_card_rt5682s_ops = {
 	.startup = acp_card_hs_startup,
+	.hw_params = acp_card_rt5682s_hw_params,
 };
 
 static const unsigned int dmic_channels[] = {
@@ -351,13 +396,26 @@ static int acp_card_rt1019_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_card *card = rtd->card;
 	struct acp_card_drvdata *drvdata = card->drvdata;
 	struct snd_soc_dai *codec_dai;
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
 	int srate, i, ret = 0;
+	unsigned int fmt;
 
 	srate = params_rate(params);
 
 	if (drvdata->amp_codec_id != RT1019)
 		return -EINVAL;
 
+	if (drvdata->soc_mclk)
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
+	else
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
+	if (ret && ret != -ENOTSUPP) {
+		dev_err(rtd->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
 		if (strcmp(codec_dai->name, "rt1019-aif"))
 			continue;
@@ -426,9 +484,33 @@ static int acp_card_maxim_init(struct snd_soc_pcm_runtime *rtd)
 				       ARRAY_SIZE(max98360a_map));
 }
 
+static int acp_card_maxim_hw_params(struct snd_pcm_substream *substream,
+				    struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_card *card = rtd->card;
+	struct acp_card_drvdata *drvdata = card->drvdata;
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	unsigned int fmt;
+	int ret;
+
+	if (drvdata->soc_mclk)
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
+	else
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
+	if (ret && ret != -ENOTSUPP) {
+		dev_err(rtd->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
 static const struct snd_soc_ops acp_card_maxim_ops = {
 	.startup = acp_card_amp_startup,
 	.shutdown = acp_card_shutdown,
+	.hw_params = acp_card_maxim_hw_params,
 };
 
 /* Declare nau8825 codec components */
@@ -446,7 +528,6 @@ static int acp_card_nau8825_init(struct snd_soc_pcm_runtime *rtd)
 	struct acp_card_drvdata *drvdata = card->drvdata;
 	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
 	struct snd_soc_component *component = codec_dai->component;
-	unsigned int fmt;
 	int ret;
 
 	dev_info(rtd->dev, "codec dai name = %s\n", codec_dai->name);
@@ -454,16 +535,6 @@ static int acp_card_nau8825_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != NAU8825)
 		return -EINVAL;
 
-	if (drvdata->soc_mclk)
-		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
-	else
-		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
-
-	ret =  snd_soc_dai_set_fmt(codec_dai, fmt);
-	if (ret < 0) {
-		dev_err(rtd->card->dev, "Failed to set dai fmt: %d\n", ret);
-		return ret;
-	}
 	ret = snd_soc_card_jack_new(card, "Headset Jack",
 					 SND_JACK_HEADSET | SND_JACK_LINEOUT |
 					 SND_JACK_BTN_0 | SND_JACK_BTN_1 |
@@ -492,8 +563,12 @@ static int acp_nau8825_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *params)
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_card *card = rtd->card;
+	struct acp_card_drvdata *drvdata = card->drvdata;
 	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
 	int ret;
+	unsigned int fmt;
 
 	ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_FLL_FS,
 				     (48000 * 256), SND_SOC_CLOCK_IN);
@@ -507,6 +582,23 @@ static int acp_nau8825_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
+	if (drvdata->soc_mclk)
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
+	else
+		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBP_CFP;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
+	if (ret && ret != -ENOTSUPP) {
+		dev_err(rtd->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
+	ret =  snd_soc_dai_set_fmt(codec_dai, fmt);
+	if (ret < 0) {
+		dev_err(rtd->card->dev, "Failed to set dai fmt: %d\n", ret);
+		return ret;
+	}
+
 	return ret;
 }
 
-- 
2.53.0



