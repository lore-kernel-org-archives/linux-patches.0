Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040360;
	b=Ae0nf/TljwvaSGoXiO9c9NWdXu+NTDukKylKVomF1yu64a0bayKGxDU2nzTDbo/uFrqh
	 CFw5vO2GHL98BZdteuUPhEfDww3v0E44cLIMnPG0P976PrKOWsXDoAptOxRpawpNYHJtS
	 64WCC4kAjMDlu86tw/HSYTZ6Rf0U47BJuR95U3mJep19MS1ZFFlNKq/MqcdDQBcmTdtMw
	 Cqn9lWyoGkyGRpD1/FXKd2Tx3tpaFTXcI1KM4nsg9T2AXsvzj0qk5ATsjktlSn7e4yLEI
	 iqpbdWfP6FkC8eYZkBmmmftSY7KG9OVT0uattZ38V+HrE+qq2w3NVLS5X4X7VWoUNmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=orPamqT+5YsZSRL1FDUyEcaZbUJricoAf0KR80KCiLw=;
	b=ocQ2Ob0KbpckjFEgoB55fqUZ0g5RSpdLH/ruYojtv6OwLi/ZRMZHHUsBks867cPw9S1g
	 G/X+JpoweLuNUhZ5oPB65iH786FhEZGBl7+4nmB8kcNUbmYX8UbM1Zoe7fMGvbYVO0ltl
	 7U6hTiEDaL5byN3r1yzwubD2jH2+oWXBsF0nSOwMO61U8wAeqsTqipYsmopbT0wozNQNL
	 T/w0x2O1eOh1Llrr2nOCUlyCWmzZxZ9GzqwY2Gke9nuaD8sSiB//LxumZMUDLX4QWuaWM
	 BDC8x0+FB0lHYyGeaJLAFewhblx4Vn2epbV2tGmcaSaynWOeI/mdgZUxm5IrO0ImVYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+HvKe9F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C85606A332;
	Wed, 18 Nov 2026 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+HvKe9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04491F000C5;
	Wed, 18 Nov 2026 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040360;
	bh=orPamqT+5YsZSRL1FDUyEcaZbUJricoAf0KR80KCiLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+HvKe9F5UHYUuuQZodolH++y7ZQNF5VuSpM8O6Ym5Y/QkOgdJ0/qHWUW/WuQk37A
	 A+PEqjYpRlkZQZfzLsEE81okgJhElP20BVRui9cEJPKNBKHxKm6JrpZqi06E9Wg3AU
	 FoSP82jFc5YmyjfcWA0EpVV+RuyeB36qkqNHoOuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2429/3318] ASoC: mediatek: mt8192: Propagate mt8192_afe_gpio_request() errors in ADDA DAI
Date: Wed, 18 Nov 2026 15:50:51 +0100
Message-ID: <20261118150434.330884952@linuxfoundation.org>
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

[ Upstream commit eed9414a1b075e2df308e7222e3786981bd42b32 ]

Currently, DAPM event handlers in mt8192-dai-adda.c ignore the return
value of mt8192_afe_gpio_request(). If GPIO configuration fails during
PRE_PMU or POST_PMD events, the error is silently ignored.

Fix this by checking and propagating error codes from
mt8192_afe_gpio_request() in all ADDA DAPM event handlers.

Fixes: 607ac4859564 ("ASoC: mediatek: mt8192: support adda in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-adda.c | 44 +++++++++++++++------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-adda.c b/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
index 4919535e2759d..577f625af789c 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
@@ -302,10 +302,13 @@ static int mtk_adda_ul_event(struct snd_soc_dapm_widget *w,
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int mtkaif_dmic = afe_priv->mtkaif_dmic;
+	int ret;
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
+		ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
+		if (ret)
+			return ret;
 
 		/* update setting to dmic */
 		if (mtkaif_dmic) {
@@ -323,7 +326,9 @@ static int mtk_adda_ul_event(struct snd_soc_dapm_widget *w,
 	case SND_SOC_DAPM_POST_PMD:
 		/* should delayed 1/fs(smallest is 8k) = 125us before afe off */
 		usleep_range(125, 135);
-		mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 1);
+		ret = mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 1);
+		if (ret)
+			return ret;
 		break;
 	default:
 		break;
@@ -341,11 +346,14 @@ static int mtk_adda_ch34_ul_event(struct snd_soc_dapm_widget *w,
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int mtkaif_dmic = afe_priv->mtkaif_dmic_ch34;
 	int mtkaif_adda6_only = afe_priv->mtkaif_adda6_only;
+	int ret;
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34,
-					1);
+		ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34,
+					      1);
+		if (ret)
+			return ret;
 
 		/* update setting to dmic */
 		if (mtkaif_dmic) {
@@ -375,8 +383,10 @@ static int mtk_adda_ch34_ul_event(struct snd_soc_dapm_widget *w,
 	case SND_SOC_DAPM_POST_PMD:
 		/* should delayed 1/fs(smallest is 8k) = 125us before afe off */
 		usleep_range(125, 135);
-		mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34,
-					1);
+		ret = mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34,
+					      1);
+		if (ret)
+			return ret;
 
 		/* reset dmic */
 		afe_priv->mtkaif_dmic_ch34 = 0;
@@ -530,15 +540,20 @@ static int mtk_adda_dl_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
+	int ret;
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		/* should delayed 1/fs(smallest is 8k) = 125us before afe off */
 		usleep_range(125, 135);
-		mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 0);
+		if (ret)
+			return ret;
 		break;
 	default:
 		break;
@@ -553,17 +568,22 @@ static int mtk_adda_ch34_dl_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
+	int ret;
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34,
-					0);
+		ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34,
+					      0);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		/* should delayed 1/fs(smallest is 8k) = 125us before afe off */
 		usleep_range(125, 135);
-		mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34,
-					0);
+		ret = mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34,
+					      0);
+		if (ret)
+			return ret;
 		break;
 	default:
 		break;
-- 
2.53.0



