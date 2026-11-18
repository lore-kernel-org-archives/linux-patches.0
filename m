Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016441;
	b=ryZWlXcxyIniD6Pli2JhpO1J9mUwC2v3aNy/9AgqQLJe3c6CnwNAC00GOkelnzoAsqrv
	 XWrrTBmdc6zJSoyKa3drmaGZc/GyRz3DFzBcZehoBJQHWzODACsQO2MZhEXjHuiECcPMO
	 X8fUvqyyarx1VeqcFGc2wZJD5hblkr5eMs3P/s6XrsJ29nsUELuiIR4UgBRoFqRSBwLOy
	 qAQtvr0W6+MxDg3xjXMY0maPg3RterCHByHuhzPRjns6l9OG1bIz6qR9S4crAqkr9uGXr
	 pCdHDsbzo0M8dus8cJjmx9fNTiJoCjGWcV0Wzor1CTpTdT0A2KCT9ENTi5so1pXSuxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fDIs+CjpIGDrlwswVnG7NGsYzvPJ/F70dBVqlx616kg=;
	b=g6ADt3DV2Y8S+JUbmVd/MA6yofrvufcmHCEoOR9M2rd0o6VUOmUjQqy+RLh70+HuTMtS
	 Nf9MoJSgLZIR5muh1efel8IKC6F2FO5o6Gf54MaDOTfiXA5n2Pt+R6+vrrQkgjFcEe8Ts
	 3piZJnkZInWvoenBXqp+fZ2DShJeA0ehgM3ndNM5V0BlsRSh9FJnEjkKOSB62ZBUl2VIL
	 y1U3zjm8EeeSMoR2ORwid2gzr16rm3VVUJzjUm8WIc4JDe0Z9JHOzF47TAPtPtjL27o0j
	 07pgaM1cFnN3tSkn4eiLbGBByzLZvMAxdBHsXLzRjaBatBUUhMrMW/EdX/p0jNutytw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boUTKQt8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEAC606A31C;
	Wed, 18 Nov 2026 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boUTKQt8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB081F000C4;
	Wed, 18 Nov 2026 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016440;
	bh=fDIs+CjpIGDrlwswVnG7NGsYzvPJ/F70dBVqlx616kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boUTKQt8oHTnTjIZQ5DITqVtQ290u+U7eLRv9eG4avspiFDEWIqh/P0TzqUsIzdC3
	 2V3RH7ZvDu36JJlVH7KyrUK8PJLVIT/E5leO4cj2E1b5Zl7CpnLtnw/ctER0vdEUVD
	 fzBQYJ7nermBxMQmpLEGmPdT4Dsa8gcL7UqqiuyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0531/2651] ASoC: mediatek: mt8189: Propagate MCLK errors
Date: Wed, 18 Nov 2026 15:29:31 +0100
Message-ID: <20261118150306.880132277@linuxfoundation.org>
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

[ Upstream commit 65b9d4a783cc266d057a64c1f04f690e9abb1bd3 ]

mtk_mclk_en_event() currently ignores errors returned by the MCK
enable and disable functions.

Propagate these errors.

Fixes: 7eb153585598 ("ASoC: mediatek: mt8189: add platform driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260916050020.14575-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-dai-i2s.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c b/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
index 4826ee250d703..8cd5ddf62d467 100644
--- a/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
+++ b/sound/soc/mediatek/mt8189/mt8189-dai-i2s.c
@@ -519,6 +519,7 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mtk_afe_i2s_priv *i2s_priv;
+	int ret;
 
 	dev_dbg(cmpnt->dev, "%s(), name %s, event 0x%x\n",
 		__func__, w->name, event);
@@ -529,17 +530,18 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8189_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
+		ret = mt8189_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		i2s_priv->mclk_rate = 0;
-		mt8189_mck_disable(afe, i2s_priv->mclk_id);
+		ret = mt8189_mck_disable(afe, i2s_priv->mclk_id);
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



