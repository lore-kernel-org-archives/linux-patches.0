Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016432;
	b=rh5Rg6tsIESywNtwsIsZ+Mku2XlSWLkuF1tGufj20X5GMLDDnvvfFDP+GSazclnu2ue/
	 jMk2CSlzmtN941DXprU4F1UM8bcmZ1RmJTyViOCcu0H4bhBLVb6vUmq16tFK39zZjT9yL
	 tBaLLt8A9xuoSReFFNTRmm3ryB9VSNJbYudML6xtzTNbWqwltOXsN8ZvtprAnaiMGExzH
	 QAm7GMU27JMcVaSFRq1mBURBGuruYdUsprYsxPopxMibqee6BnX7zbc2MJmePD5i84LvL
	 ol0jsrKEH8qOCKeGSHNI5e7Lu3eV+ejp+fYrnQWxYaHAO2dCYsrrYVQK/juITvwlyyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IgKbuEweYoX23PzoTlNr4LjR5Oa7MD56ixChovwMBIE=;
	b=Mp7N7F4a+xcb9E8YT9mYbmMuY2HTLRDMMaaLDn6vy4aWtafbYHv94PKJFaVRqAwKeDWR
	 /Mr5Y05VzAfXe3uAFb0NXjN+kdXcuDmbp8RIvMxA5KtGDP33+HyZKpoJteOp+TFnnaIox
	 8MdVHtQwkAlipaEsozxSe8ppMQaS8Bx8piAD6VYhReDW2gdMdn3YwWKlM2oT0ZEQafoRd
	 o2sVlZ0f5xFjJbjOgGa6gSD1SmkyMMieb/2HRU6ZCtzgt4XK4yKZr4mJS0sjQGQr/J9G4
	 znC6yqzhILYSZUXzj9Lks7AiIocAMLdvOeFvC1KNqOz/Wr/f/aGdIkf5c7vcSdy6RRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4FBripb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919CE606A330;
	Wed, 18 Nov 2026 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4FBripb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FBD1F000CA;
	Wed, 18 Nov 2026 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016432;
	bh=IgKbuEweYoX23PzoTlNr4LjR5Oa7MD56ixChovwMBIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4FBripbHGcJwn+8O80V8r41d/T4vVlbw8kD44eS4fidSpcGTpygpxqbsrB/fQ8tF
	 ed0whdz9OHQgURg/q7cfvrvNRsZ/s96emljDvjpaymA3SuNYiIWoA8y7kTNjOjjudM
	 Zccv8E2AhrMKjxSrr6c3VtHXvcY7Zyk/n9Xh0nZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0528/2651] ASoC: mediatek: mt8189: Propagate reg_rw clock errors
Date: Wed, 18 Nov 2026 15:29:28 +0100
Message-ID: <20261118150306.776743953@linuxfoundation.org>
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

[ Upstream commit 29de6666879997c9dc375344fd046363d0c3bcdb ]

mt8189_afe_enable_reg_rw_clk() currently ignores errors from clock
enable and parent operations.

Propagate these errors and clean up the clocks before returning the
error.

Fixes: dc637ffeed6c ("ASoC: mediatek: mt8189: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260916050020.14575-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-afe-clk.c | 31 +++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-afe-clk.c b/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
index 7fe9d01006d51..1132c924158d7 100644
--- a/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
+++ b/sound/soc/mediatek/mt8189/mt8189-afe-clk.c
@@ -700,17 +700,36 @@ int mt8189_mck_disable(struct mtk_base_afe *afe, int mck_id)
 int mt8189_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8189_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	/* bus clock for AFE internal access, like AFE SRAM */
-	mt8189_afe_enable_clk(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIOINTBUS]);
-	mt8189_afe_set_clk_parent(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIOINTBUS],
-				  afe_priv->clk[MT8189_CLK_TOP_CLK26M]);
+	ret = mt8189_afe_enable_clk(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIOINTBUS]);
+	if (ret)
+		return ret;
+
+	ret = mt8189_afe_set_clk_parent(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIOINTBUS],
+					afe_priv->clk[MT8189_CLK_TOP_CLK26M]);
+	if (ret)
+		goto err_disable_audiointbus_clk;
+
 	/* enable audio clock source */
-	mt8189_afe_enable_clk(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIO_H]);
-	mt8189_afe_set_clk_parent(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIO_H],
-				  afe_priv->clk[MT8189_CLK_TOP_CLK26M]);
+	ret = mt8189_afe_enable_clk(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIO_H]);
+	if (ret)
+		goto err_disable_audiointbus_clk;
+
+	ret = mt8189_afe_set_clk_parent(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIO_H],
+					afe_priv->clk[MT8189_CLK_TOP_CLK26M]);
+	if (ret)
+		goto err_disable_audio_h_clk;
 
 	return 0;
+
+err_disable_audio_h_clk:
+	mt8189_afe_disable_clk(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIO_H]);
+err_disable_audiointbus_clk:
+	mt8189_afe_disable_clk(afe, afe_priv->clk[MT8189_CLK_TOP_MUX_AUDIOINTBUS]);
+
+	return ret;
 }
 
 int mt8189_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
-- 
2.53.0



