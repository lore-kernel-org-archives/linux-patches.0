Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024847;
	b=ey/QA+qgUbMSAH/YL6gAGyCDIBQh8kJkK5eWqKoRThHunA3pdMdAcvdbXLjO2yHbKX9Z
	 sjGqugb7/H4XeOoUTA6KOpV1xXhuT8vwI//03eqvsbRxxgJwS4LYu2v70saqeN2wl9cFe
	 v6f9m3mRj4EpfenoMN6kow01JagSCgh5Hp+1m+/9ZtNcOjzgLrpt1rpo3213nI8F0SK3O
	 yg2UwZsmyG0By6RgYqvrTTK5xtmLnwqSmzGVbqrT/BRN+X41lKij9eQmkjLVJiAwMhGoc
	 sHC8DfXSbHkAoIGlycLorLY1A+1IKDDeTvTUCv/tTiPW779XfOd00gdtyZXsJ9FImiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tZVmBHoEDOxNCda9luZeVKanSsosDlkSpV6/nP9XNV8=;
	b=CATwWV/zBEB5n6QJmCRKtfVHIFzVIP3EDTughdxCRsthnSxLs/piqkdZk2DAH+gcOt4+
	 xzqBxt0qUBSDyYUbrtudJaMssmgwJLoWxIR1x6BCDw90p5Y6d1zbO/cAgq2rLiQvlLaUo
	 Svp+BMjAT3B0GZImnIaxZdvr+s2potoomuC6hPoaM0FQcePuFccQplUIJ5F8KuQrLTcVa
	 cYmdNArybOS2HKU64MBacNgIDNYyAXPHiV2TglMTZrDN229YWCeMEEiu2Ha+g21R3v/qx
	 zt/1K6q6CHgnc+UKD31CRv9rmZdDDgBvhg7qrCg0JF4Fsl4/CRnEFbM/M7xJRRpRBDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2gpU6YC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9DB606A31C;
	Wed, 18 Nov 2026 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2gpU6YC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1E61F000C4;
	Wed, 18 Nov 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024847;
	bh=tZVmBHoEDOxNCda9luZeVKanSsosDlkSpV6/nP9XNV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2gpU6YC7nyEyRWrGyssWzAOvAp4I9KXgwxQrGE2ILymCBq8WCUU4NlBpAJzoOcUC
	 bm21Ai7Zk7pf5LoDODx+8strQwUQRaBcky7B3J2EysiY7bBJIjM6sPQ47WlfrFBVm0
	 oTuMPrtD+c8ViMwCJ34Sbn2M4nE+EIfJMAvDqIhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0828/2151] ASoC: mediatek: mt8192: Propagate mt8192_afe_gpio_request() errors in ADDA DAI
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118150152.299838160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 99de85b876435..9a29f2feb174d 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
@@ -218,10 +218,13 @@ static int mtk_adda_ul_event(struct snd_soc_dapm_widget *w,
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
@@ -239,7 +242,9 @@ static int mtk_adda_ul_event(struct snd_soc_dapm_widget *w,
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
@@ -257,11 +262,14 @@ static int mtk_adda_ch34_ul_event(struct snd_soc_dapm_widget *w,
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
@@ -291,8 +299,10 @@ static int mtk_adda_ch34_ul_event(struct snd_soc_dapm_widget *w,
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
@@ -446,15 +456,20 @@ static int mtk_adda_dl_event(struct snd_soc_dapm_widget *w,
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
@@ -469,17 +484,22 @@ static int mtk_adda_ch34_dl_event(struct snd_soc_dapm_widget *w,
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



