Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030295;
	b=TizV517yspQdM6AgJcX98ut7OkVC8YXjSlzkJvRnXK6UEvGRtrtowfSUoBfb6PBkAIFj
	 TBGEfgbYQlDz/dqAiL9Jiy/u5/pkBam6HAXTxSK87AdAlooqXYCXVCtQbyTwRHy/wsG3t
	 8I/gFwZR9dz2+TOhpUBWkDlemz/VWS6HCd6hNwKFHdhLOQpMwu7wSGW9QgwWMywtiUCSK
	 uyh3kvgcX5Pn1wXq4vFlL2WfHvl8Q8Awk6LkaYfW9YR7nKa2tFHWsm4WOd44YYkkuQoX3
	 adC2Pxq82tYd717jnPLDle0Zl65ctpRf47E3QiT8O1ZVGOg6xK3LhqrmfSN84+KAdGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wKGCe6I+kym7tHZPUAGjhpSQ7Mrn+Gd6mnGNwztrACA=;
	b=lZp8IhqN+jId6ObfIzO7eaDMCGIEHjc/jLE6kvkVCZgrzfLd6JTxCFDA+OXET7G1fjgQ
	 uRpfWFmfxGLO22vmbrRQQZmv+ZG3+Jkp5AZdPwUlSGE+ZZGXm5EJzNFDnp6Yw6q6FrRYM
	 dm+tz9qzYaI7iQdBFwKTTghDAOdNdjdR+CjAsDNJrJG52e2OX3Gm0bC2nn7blFam4WVkE
	 Gvsl0V0Aag3B9JhLYsjCNoQ7qRP4u/aYC1Qdb4XwoFgkM8DH7z2mgdJwi4TiVF+SuElxC
	 FRCpbKALqM6Ph0lLB418cOGdqWxusX+1WdUQJ0WdD/Z/yQezVmQNN1KhtGw19pAFimw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeLJAaOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA91606A7CA;
	Wed, 18 Nov 2026 19:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeLJAaOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DCF1F000C4;
	Wed, 18 Nov 2026 19:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030295;
	bh=wKGCe6I+kym7tHZPUAGjhpSQ7Mrn+Gd6mnGNwztrACA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeLJAaOB07IfAT4I+8kqcG15uCV78/6mtg3S2fz24dTsgTfRQwOZjFtI87EG+FLwc
	 hGMqtx8nVib16nz5lCsGHufWCJOrzmAQoOz7/3lLKniBwbTrm/GaWf3r5bOyittXWl
	 GqrfzGVYkaP4bjMgFRN6tLNj7Fvjfev2peEFrQmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0655/1756] ASoC: mediatek: mt8192: Propagate errors in TDM DAI DAPM event handlers
Date: Wed, 18 Nov 2026 15:46:22 +0100
Message-ID: <20261118150034.960069981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit d0bc9613bc2d9e20a7e4f3e447cd9427c95d194a ]

Currently, DAPM event handlers in mt8192-dai-tdm.c ignore return values
from mt8192_afe_gpio_request() and mt8192_mck_enable().
If GPIO configuration or master clock setup fails during DAPM events,
the error is silently ignored.

Fix this by checking and propagating error codes properly in all
TDM DAI DAPM event handlers.

Fixes: 52fcd65414ab ("ASoC: mediatek: mt8192: support tdm in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-14-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
index 49440db370af0..36fa0f32ed1cb 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
@@ -250,6 +250,7 @@ static int mtk_tdm_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	if (!tdm_priv) {
 		dev_warn(afe->dev, "%s(), tdm_priv == NULL", __func__);
@@ -261,16 +262,17 @@ static int mtk_tdm_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, tdm_priv->id, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, true, tdm_priv->id, 0);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		mt8192_afe_gpio_request(afe->dev, false, tdm_priv->id, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, false, tdm_priv->id, 0);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mtk_tdm_bck_en_event(struct snd_soc_dapm_widget *w,
@@ -282,6 +284,7 @@ static int mtk_tdm_bck_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	if (!tdm_priv) {
 		dev_warn(afe->dev, "%s(), tdm_priv == NULL", __func__);
@@ -293,7 +296,9 @@ static int mtk_tdm_bck_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_mck_enable(afe, tdm_priv->bck_id, tdm_priv->bck_rate);
+		ret = mt8192_mck_enable(afe, tdm_priv->bck_id, tdm_priv->bck_rate);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		mt8192_mck_disable(afe, tdm_priv->bck_id);
@@ -314,6 +319,7 @@ static int mtk_tdm_mck_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	if (!tdm_priv) {
 		dev_warn(afe->dev, "%s(), tdm_priv == NULL", __func__);
@@ -325,7 +331,9 @@ static int mtk_tdm_mck_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_mck_enable(afe, tdm_priv->mclk_id, tdm_priv->mclk_rate);
+		ret = mt8192_mck_enable(afe, tdm_priv->mclk_id, tdm_priv->mclk_rate);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		tdm_priv->mclk_rate = 0;
-- 
2.53.0



