Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040366;
	b=RcOvr/adS81WFNZvQLLLJRjhg3P+oneOyM2Cgz7WlQqFYoT4X4utWSgQd9r1fhDB+LQ3
	 VgSJXtR2WZs8Tuc1ER/AHqg8+5laCBGSJZM+IWOuZZr8OifJap4XGdBpaPOyyKtRc/pgM
	 gZ9Y+wMybMKpcDf0nk0PSlVAtn9KMZvsOXX2v4lHnT/CzvOQtgvmzNO4yp1Vb2jRb9t7b
	 u60LWl6vU90jNIdFCk8XWWMMnfl+u3afgOsHMdps5O7OMByflgZRIar0Vf9PxNB7PVrfd
	 TW1UCkGlzVLTW4vOGRouIW1t7cF1rWzpf+iBMqXbe4bcEHPgnQd9YOMXon/q8E7R5KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gDdFZxiV8kvG4+FILT/+hr7v1dOcjm4xGJPZje+hEgI=;
	b=mEXT1LjeNzYhCHgSuc0ato6iyRul3TKhpwXJTWwHvx0WARJlPN8zpA3uibbwwC8/vkqG
	 vHhkIrGpo9nyKlabdBjVV+woD8J8BF0aBtkNDsxcK3Ti5MIPfddAQunvE3L3Ooi85eKx4
	 Y3hmf0bhZt1Q/Ma+RVH6oK9OIfJatLgIU1pcseNRGYz0EKlMVcdh7vYjs7yx9Vf2zK4hr
	 DUlpaZzBjsGS0S80U2dWDMb/bLuV9PwO+HJbVvqvRqOgejvtoMsvXfjSlJZcGjTFt8Oz5
	 MaQC7ZaWKlBbOKj0wZvMm/FY+7Kmq2gFet1Y0eYmEhRwjH1Q93yM9IwHElyuiNKJIbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFv5B9KI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43406606A31C;
	Wed, 18 Nov 2026 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFv5B9KI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997C41F000C4;
	Wed, 18 Nov 2026 22:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040366;
	bh=gDdFZxiV8kvG4+FILT/+hr7v1dOcjm4xGJPZje+hEgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFv5B9KIIdqXOygXVANP2jreGX6UWqZaMUC054SnE48PoAetKGSci2JadfcvuMGH6
	 Nn3PC6c/bZT9G3fgMhz8BDSFtOR0DQadh1F+iLlG5GpvQDr/Trgt3uKt99/DvJaQl0
	 BVTukCs0YmunyjIfmCtA3rQPuE6+0fNwZhT2itxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2431/3318] ASoC: mediatek: mt8192: Handle component name prefix
Date: Wed, 18 Nov 2026 15:50:53 +0100
Message-ID: <20261118150434.395475050@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 86cfaf99e4d3c7b4707fb8cc9eb06d8db10c1414 ]

Use snd_soc_dapm_widget_name_cmp() helper when comparing widget names,
to include also the component's name prefix.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231023095428.166563-16-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 49aeb628d10e ("ASoC: mediatek: mt8192: Propagate errors in I2S DAI DAPM event handlers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-adda.c | 4 ++--
 sound/soc/mediatek/mt8192/mt8192-dai-i2s.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-adda.c b/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
index 577f625af789c..847d99826f748 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-adda.c
@@ -445,7 +445,7 @@ static int mtk_adda_mtkaif_cfg_event(struct snd_soc_dapm_widget *w,
 			regmap_write(afe->regmap, AFE_ADDA6_MTKAIF_CFG0,
 				     0x00010000);
 
-			if (strcmp(w->name, "ADDA_MTKAIF_CFG") == 0 &&
+			if (snd_soc_dapm_widget_name_cmp(w, "ADDA_MTKAIF_CFG") == 0 &&
 			    (afe_priv->mtkaif_chosen_phase[0] < 0 ||
 			     afe_priv->mtkaif_chosen_phase[1] < 0)) {
 				dev_warn(afe->dev,
@@ -454,7 +454,7 @@ static int mtk_adda_mtkaif_cfg_event(struct snd_soc_dapm_widget *w,
 					 afe_priv->mtkaif_chosen_phase[0],
 					 afe_priv->mtkaif_chosen_phase[1]);
 				break;
-			} else if (strcmp(w->name, "ADDA6_MTKAIF_CFG") == 0 &&
+			} else if (snd_soc_dapm_widget_name_cmp(w, "ADDA6_MTKAIF_CFG") == 0 &&
 				   afe_priv->mtkaif_chosen_phase[2] < 0) {
 				dev_warn(afe->dev,
 					 "%s(), mtkaif_chosen_phase[2]:%d\n",
diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c b/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
index ea516d63d94dd..47dc7ec4cae7e 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
@@ -623,13 +623,13 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		if (strcmp(w->name, APLL1_W_NAME) == 0)
+		if (snd_soc_dapm_widget_name_cmp(w, APLL1_W_NAME) == 0)
 			mt8192_apll1_enable(afe);
 		else
 			mt8192_apll2_enable(afe);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		if (strcmp(w->name, APLL1_W_NAME) == 0)
+		if (snd_soc_dapm_widget_name_cmp(w, APLL1_W_NAME) == 0)
 			mt8192_apll1_disable(afe);
 		else
 			mt8192_apll2_disable(afe);
-- 
2.53.0



