Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020118;
	b=I4sxiZXCUnUFhlq7uPm1x8cpx6NX8Javo68bnZffeDZ2BsEbUYwrA3oEgURiWTXxmL5n
	 vrGbroPtogYT0xW2Yyq9pnL/H9GWd3gjcNLFyy72clL9CzKzcmHcZkmd4d2p2jgt9EPJz
	 Hg1FoSlXpvoiewUFhOqrQVm0KJdERDYZnmQZfQD4OpTBgyIXR0Ix+dooq054wwX8ixmRW
	 w6NuymNbZj2RCUlrwfiGeGsNuO+bCk8Va1yx+Xv7NWldtSSH5XQCW0+gCw2AH7Ic8+ulS
	 wmCTzM+GhqEMVQEGgz2uOpcceWgMMpw4cL/Xv4iJwb73fQZ6whjhljG+wWbQA3FAPTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y+J7Vu1ehnxF/Az/9wE0jRHOLbAPuHKOWGEwVhQ3fvc=;
	b=jjYJk+bGX/q5tmM7sXrLu8npnfuEihP8NuNbQOZ4D459BE4mibDhH2UXnkAacmekRc1J
	 +of9tIYROSAP1kw5bnkzvIIIpGagXp2iAz4X+6Oey0yNm5U1uRg5HWx016cDRtYs0LNOH
	 cjWNitGwHs0MFYFCjXOM8H25qFgXtWnvMTSGEraHWQw71v2S/HE3+8fHHcRUGxwlFq0zh
	 Q1YiaupP9y8Ia6twU4wNoF+3q02e382119V2M7swuLfBWG9BngerRtWpLGgM0RNrZpuw3
	 10s0YH4RTW0rxMxsj2Ph7x5PE6MiXygXaY3QYt9/59XJfx9MwcAYI51aod7dGgJSf3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paDrTOTX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789AC606A325;
	Wed, 18 Nov 2026 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paDrTOTX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF661F000C5;
	Wed, 18 Nov 2026 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020118;
	bh=Y+J7Vu1ehnxF/Az/9wE0jRHOLbAPuHKOWGEwVhQ3fvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=paDrTOTXb2RaX3vgUMIyKVAHSyAsM3JwhEFpU0vPcePSfxnJCJ1ID944kd8iV1TOj
	 EMjprClYK1AcQdOc0iBznYwBn8SPY4jmhoH2tCkJmPHKABZd3ucd30UUzegZAoc8ss
	 /4MuLqsHGrYzSB/gz1tcNBDxp2CvL0BSyddXCAIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1797/2651] ASoC: mediatek: mt8196: propagate I2S clock errors
Date: Wed, 18 Nov 2026 15:50:37 +0100
Message-ID: <20261118150352.005844867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 6c14a59bc503fc9aa599f1ebc50777460145e8b4 ]

Propagate errors from APLL and MCK clock operations in the DAPM event
callbacks instead of always returning success.

Fixes: 65a195132669 ("ASoC: mediatek: mt8196: support I2S in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-dai-i2s.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-dai-i2s.c b/sound/soc/mediatek/mt8196/mt8196-dai-i2s.c
index ef5cde0ba829e..adebf75629bed 100644
--- a/sound/soc/mediatek/mt8196/mt8196-dai-i2s.c
+++ b/sound/soc/mediatek/mt8196/mt8196-dai-i2s.c
@@ -985,27 +985,30 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
+	int ret;
 
 	dev_dbg(cmpnt->dev, "name %s, event 0x%x\n", w->name, event);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		if (strcmp(w->name, APLL1_W_NAME) == 0)
-			mt8196_apll1_enable(afe);
+			ret = mt8196_apll1_enable(afe);
 		else
-			mt8196_apll2_enable(afe);
+			ret = mt8196_apll2_enable(afe);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		if (strcmp(w->name, APLL1_W_NAME) == 0)
 			mt8196_apll1_disable(afe);
 		else
 			mt8196_apll2_disable(afe);
+		ret = 0;
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
@@ -1015,6 +1018,7 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mtk_afe_i2s_priv *i2s_priv;
+	int ret;
 
 	dev_dbg(cmpnt->dev, "name %s, event 0x%x\n", w->name, event);
 
@@ -1025,17 +1029,18 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8196_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
+		ret = mt8196_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		i2s_priv->mclk_rate = 0;
-		mt8196_mck_disable(afe, i2s_priv->mclk_id);
+		ret = mt8196_mck_disable(afe, i2s_priv->mclk_id);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct snd_soc_dapm_widget mtk_dai_i2s_widgets[] = {
-- 
2.53.0



