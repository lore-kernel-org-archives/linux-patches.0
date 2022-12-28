Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA96C433D2;
	Wed, 28 Dec 2022 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242597;
	bh=PBBpVCg0l7zWlUPjh9wrXLw6LnhsziQPkz7+SKKEros=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRjsIZL/vohUkCWpe3cRQkbsmuqHj/2E6PKwzxvfqDRKFYuoovzCh8piCiti8FROf
	 8qa+2gRa2l4ZPN7/TLmihryyYztRBqby848g6Cqx4QU7APIg0GEcIg6qhQwotH6MSs
	 M3oyMaftxf439SsaVCh44G+/xgzf9W/hqpBCjJrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxin Yu <jiaxin.yu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0392/1146] ASoC: mediatek: mt8186: Correct I2S shared clocks
Date: Wed, 28 Dec 2022 15:32:11 +0100
Message-Id: <20221228144340.812658596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxin Yu <jiaxin.yu@mediatek.com>

[ Upstream commit 248579fc9a4f3bf36e7cfe9f6a354cee0f9848dc ]

In mt8186 platform, I2S2 should be the main I2S port that provide
the clock, on the contrary I2S3 should be the second I2S port that
use this clock.

Fixes: 9986bdaee477 ("ASoC: mediatek: mt8186: Configure shared clocks")
Signed-off-by: Jiaxin Yu <jiaxin.yu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221124023050.4470-1-jiaxin.yu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.c | 2 +-
 sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.c b/sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.c
index cfca6bdee834..90ec0d0a8392 100644
--- a/sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8186/mt8186-mt6366-da7219-max98357.c
@@ -192,7 +192,7 @@ static int mt8186_mt6366_da7219_max98357_hdmi_init(struct snd_soc_pcm_runtime *r
 	struct mt8186_mt6366_da7219_max98357_priv *priv = soc_card_data->mach_priv;
 	int ret;
 
-	ret = mt8186_dai_i2s_set_share(afe, "I2S3", "I2S2");
+	ret = mt8186_dai_i2s_set_share(afe, "I2S2", "I2S3");
 	if (ret) {
 		dev_err(rtd->dev, "Failed to set up shared clocks\n");
 		return ret;
diff --git a/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c b/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
index 2414c5b77233..60fa55d0c91f 100644
--- a/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
+++ b/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
@@ -168,7 +168,7 @@ static int mt8186_mt6366_rt1019_rt5682s_hdmi_init(struct snd_soc_pcm_runtime *rt
 	struct mt8186_mt6366_rt1019_rt5682s_priv *priv = soc_card_data->mach_priv;
 	int ret;
 
-	ret = mt8186_dai_i2s_set_share(afe, "I2S3", "I2S2");
+	ret = mt8186_dai_i2s_set_share(afe, "I2S2", "I2S3");
 	if (ret) {
 		dev_err(rtd->dev, "Failed to set up shared clocks\n");
 		return ret;
-- 
2.35.1



