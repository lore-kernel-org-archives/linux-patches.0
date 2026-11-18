Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020004;
	b=e/0NTCVO0basfO8ZWvdhd3hc54oPgbqGi9WZpFwRWP1iO1rmh+VjCHmGrgGzv3TZzpqa
	 PyPtA35sowxnM0AwUzdJwGlDbi5as4PpbQvdxxMGinBbQcrAmuur85m1ltDfkPkexAUra
	 iRSReqSmNGgWG4/tfgjZpS281nVO9LFbFNiSVxwsSg/xyHWHF7bKYx+JdKfMlcmMIYCTU
	 Wm3hGb3Y4vYGb6SPq+oysIX4IA7BvrmNC4BDpNebO1RjRQdmXh36acrorGD8bskICkHyg
	 +0XCAMKcJxiKNUlhUIVi2+UWUR518rdiw6xc/pwsh+b8WzHdgBmNXV8xPTifT2k8eLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUkEiaxYjyDjuLyoH9jd9/GU4bg80bc2HjSq+ustuuQ=;
	b=yK3dlxIZx0DBiJJwU1gPX8wbFjvhYhR6q13SEqDe7Eu+SIJEF7UwZ0+0OsLPTUTpBNYN
	 GHGQbxs+CDpYSo9gMtXQ+DaP2bArl7rWpkgDj184sJ5jLg8vpgxOJO5Jbeb/JvsUJ4XPy
	 FBUg8Xg0NcUlbZfPjbTdBxaGq88MVYlX9+oHBXt0xU8UPWqmR2sAUFJJVfaLsS+NVMaWJ
	 sHr6jmeLDcRWirE7PDGTk/JRC7l1vOtgjTeXGV/9w6NcSyNia3bV7T5b6oAj5r9LdsRvY
	 iIz4dhba7q6sT6SIGcPa0ZnioI61+ZR/3Kej/t0Ybl+xE0xcKkBBFD/d6eYQy/2hWwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDmrSODV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C76F606A31C;
	Wed, 18 Nov 2026 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDmrSODV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADE51F000C4;
	Wed, 18 Nov 2026 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020004;
	bh=LUkEiaxYjyDjuLyoH9jd9/GU4bg80bc2HjSq+ustuuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDmrSODVGeHlehtXr8IBjSeb2gx6Ul59yNlGy1eph3jQScHSsF64IGw2NsAIQJifW
	 zBXmS2XknpthVEHOGswpjb+HgdtgtavpuOlfsrBHKjotXZehd99O+bkscj2cbpPmyG
	 sZhWu1oM0ni+Rqi5lWvV1KBIU1wilh5U7N4YK0/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1798/2651] ASoC: mediatek: mt8196: propagate TDM clock errors
Date: Wed, 18 Nov 2026 15:50:38 +0100
Message-ID: <20261118150352.035759745@linuxfoundation.org>
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

[ Upstream commit d09412f79d70402c44bb92d19eff5b9aea3087e6 ]

Propagate errors from BCK and MCK clock operations in the DAPM event
callbacks instead of always returning success.

Fixes: ede4d841111a ("ASoC: mediatek: mt8196: support TDM in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-11-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-dai-tdm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-dai-tdm.c b/sound/soc/mediatek/mt8196/mt8196-dai-tdm.c
index b7aeee939d888..44bd08f5c1fbe 100644
--- a/sound/soc/mediatek/mt8196/mt8196-dai-tdm.c
+++ b/sound/soc/mediatek/mt8196/mt8196-dai-tdm.c
@@ -256,22 +256,24 @@ static int mtk_tdm_bck_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8196_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	dev_dbg(cmpnt->dev, "name %s, event 0x%x, dai_id %d\n",
 		w->name, event, dai_id);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8196_mck_enable(afe, tdm_priv->bck_id, tdm_priv->bck_rate);
+		ret = mt8196_mck_enable(afe, tdm_priv->bck_id, tdm_priv->bck_rate);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		mt8196_mck_disable(afe, tdm_priv->bck_id);
+		ret = mt8196_mck_disable(afe, tdm_priv->bck_id);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mtk_tdm_mck_en_event(struct snd_soc_dapm_widget *w,
@@ -283,23 +285,25 @@ static int mtk_tdm_mck_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8196_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	dev_dbg(cmpnt->dev, "name %s, event 0x%x, dai_id %d\n",
 		w->name, event, dai_id);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8196_mck_enable(afe, tdm_priv->mclk_id, tdm_priv->mclk_rate);
+		ret = mt8196_mck_enable(afe, tdm_priv->mclk_id, tdm_priv->mclk_rate);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		tdm_priv->mclk_rate = 0;
-		mt8196_mck_disable(afe, tdm_priv->mclk_id);
+		ret = mt8196_mck_disable(afe, tdm_priv->mclk_id);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct snd_soc_dapm_widget mtk_dai_tdm_widgets[] = {
-- 
2.53.0



