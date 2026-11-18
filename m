Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055499;
	b=0YxojPOX9DRQ3uUu0rvM4dHOq2UB79YfWhcSDrvgXWW/nOhs+7AXJnSGGsgn1/ChTqzi
	 CpTgN0FQwBCE7lX8zGuBiJbmEK2ciFbYJL3tbNMyYwuBwKa9LvM/cP8EVJIHSYGFTskr2
	 jxBekGnaN2PxAsrXfPOxAVSbDxhotGQhqZ2KE90GfS8W3aDxU8JCxq0fp1No0xMbiSgjj
	 Tzd0/HQz1lQ733JCSCi1eSrbQ4kPUkFTTv1gRtBHNPVBxiUrJYXQjQE2WwdZXAHw/obn6
	 +KoaXeECKRH+C223ASMpwcYWgh+hG42tdFfYeYe4tGJmD3LxMUjTdIy9UqOTVoe4IRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eGHSsbSRmAsHPjalvp3hsD3oRAKv2cUK/mm1biCFbJs=;
	b=338i+teGx7W+KNzErVo/DI3I5mmy1Wt8ja16SZzyQUaTXSHWgYNizC6fhUBmuUKU7SpI
	 bp521L5gVZoiREyh+MEGe21LZ8CVi0AyeyeZBpEc2Af+nAxAVqZVhweKR36qtmlAwN4et
	 CvNWU/BOTU7RJ2fXBr63gn6PcqkYkDEa9XEacXHptkbTLTzqycfQppOidI4NnnwXWDrbJ
	 T4yW/vica4tFIe+96A4D3+/OunfunaVanc+gy8uc0CxexXpPFl+xQcyqKULUPYDHUnG+Q
	 YQKek5qpxVRzvKUqSowA2GxUk+2rBe99D9KHiIMeo9Iaa33+Xjrpi9Q5BraAEO+AwlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtxCOwJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293A8606A325;
	Thu, 19 Nov 2026 02:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtxCOwJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB111F000C4;
	Thu, 19 Nov 2026 02:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055499;
	bh=eGHSsbSRmAsHPjalvp3hsD3oRAKv2cUK/mm1biCFbJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtxCOwJjXZ850f41nJoMea6cZki0OR+FdAhV72FeEAhebr3euq08ICCdcboCwQev4
	 +8oo1p9PSSv+mRf66sVr7BT8TKPLUOJJp/cYGrL4DJpJhsL+Z/D1TFjlb8hgCz6b8u
	 Nwi2/ozR8hRqcGyvGbUqikoWFIGX1aRxiXFpa+jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1654/2214] ASoC: mediatek: mt8192: Propagate errors in TDM DAI DAPM event handlers
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150118.056536531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 360259e60de84..dfb125ad37e65 100644
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



