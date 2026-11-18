Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040372;
	b=CHBeHrmG8xTDVBtEEVHzOP+068+mAkQSzO+KJTFztsCLxTDRtnQeEwbEB/+4IQ18C6TY
	 667QOetPZ/W06JzLtwg+wT2P1QJjDo5gMxyunrR+pnNrWh5elhNk1vmZcLkXG/mfK5S5i
	 2cq5mRvfO7rgUd8J40FFu2P8TXLF/VYS/4vMge0pBOnKW5y4WingbsQvFDJRtHU5/EYk4
	 kKBbrpfcvZxDC3iVDr+GHSz82mS7v46OCm8MFtBhkXGo89uPIScwIt2Vbd+MdPnFX1SWR
	 ScZmvJOnqPcdLWD8QuRRToew8TFpmbSpjTbJA3wNtdS3D7nZZO+mVpllmafPbsLbnDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMVG1WnOaSCTXKmyVkxEORWMyA+UPJXa8GzzVM+6tV4=;
	b=ERzlKCHsUfE6vwkdd0i1sGtl73KkvWr99SwWWISUFjtjxe07kX/BxKGQnagyaY/HW36x
	 6lNr53+XLh5iefInO9G7ZndmWaj8ySWo4kID5hmvZcMqo87NwwwNymhgPM9sLQmLc2jzD
	 MR7LW07iHyuc+absWB91OS9hL79ty1TIeww91XL4/pT+as5Ot2WgJF5fSwo3K+/4EIHMj
	 gJ1C4JPUq+ZOAZfml+EU4jBj6D5ZUCe7IT9BwhZ7d+l5RmvGEoI2LXUEnXFgkZtjiVaIX
	 lsZTeLSuWrFucxfS0SrvgnLkJJb1eK8to6twZn87oiU6tmkJwol/0iJXLJvAboBhJ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1V0sv37;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25545606A31C;
	Wed, 18 Nov 2026 22:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1V0sv37
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7141F000C5;
	Wed, 18 Nov 2026 22:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040371;
	bh=BMVG1WnOaSCTXKmyVkxEORWMyA+UPJXa8GzzVM+6tV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1V0sv37dNv8QcVWu6/uMvT0YTgbkA+ndgM2S1QDca0g4InaJD7TiihLvw3RrL7lf
	 YAT4WoVQR5JbJkSXQkCL+vySDJA6+hKiGJ0jIsbAIb5XPerVIjJFJTd+1wYrUWAOi3
	 znmN5arvE3KdaVOHvtcM7ZLrJDLM5ro2cWPTptYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2432/3318] ASoC: mediatek: mt8192: Propagate errors in I2S DAI DAPM event handlers
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118150434.421786471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 49aeb628d10ef3d5694c39b7a3427d34bde06bb2 ]

Currently, DAPM event handlers in mt8192-dai-i2s.c ignore return values
from mt8192_afe_gpio_request(), mt8192_apll1_enable(),
mt8192_apll2_enable(), and mt8192_mck_enable(). If GPIO configuration or
clock setup fails during DAPM events, the error is silently ignored.

Fix this by checking and propagating error codes properly in all I2S DAI
DAPM event handlers.

Fixes: 2c37b4ed730b ("ASoC: mediatek: mt8192: support i2s in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-15-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-i2s.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c b/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
index 47dc7ec4cae7e..374df85411b7c 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
@@ -586,6 +586,7 @@ static int mtk_i2s_en_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mtk_afe_i2s_priv *i2s_priv;
+	int ret;
 
 	i2s_priv = get_i2s_priv_by_name(afe, w->name);
 
@@ -599,16 +600,17 @@ static int mtk_i2s_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, i2s_priv->id, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, true, i2s_priv->id, 0);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		mt8192_afe_gpio_request(afe->dev, false, i2s_priv->id, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, false, i2s_priv->id, 0);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mtk_apll_event(struct snd_soc_dapm_widget *w,
@@ -617,6 +619,7 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
+	int ret;
 
 	dev_dbg(cmpnt->dev, "%s(), name %s, event 0x%x\n",
 		__func__, w->name, event);
@@ -624,9 +627,11 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		if (snd_soc_dapm_widget_name_cmp(w, APLL1_W_NAME) == 0)
-			mt8192_apll1_enable(afe);
+			ret = mt8192_apll1_enable(afe);
 		else
-			mt8192_apll2_enable(afe);
+			ret = mt8192_apll2_enable(afe);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		if (snd_soc_dapm_widget_name_cmp(w, APLL1_W_NAME) == 0)
@@ -704,6 +709,7 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mtk_afe_i2s_priv *i2s_priv;
+	int ret;
 
 	dev_dbg(cmpnt->dev, "%s(), name %s, event 0x%x\n",
 		__func__, w->name, event);
@@ -716,7 +722,9 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
+		ret = mt8192_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		i2s_priv->mclk_rate = 0;
-- 
2.53.0



