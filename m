Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017218;
	b=Ul34wcoZ/knR1o/45WKSW0KYnuHzVxciZEALZvhzbn4R09WMwhkwwtis/fYMfYyrz+zK
	 9k/G1qtTiN2RrwdIewguO4iCWchg5mUvqIIxDQqeyR+COCxEnbDv8ZhXoL9u4B38DNojP
	 1CkSU1tFjLXC0m3cgBQhtpWJ9bsHz49FgzSgGkPGGx5hM9QnKQGjyllmc+I5zl4v0FQEi
	 2J8LU7U770PCFUXWhvdfJ567bu3iwFzIoTtQc75qRGnJu/E9BW5Re/F73Fahulh02zdic
	 iOdi8HEQLIpeCKsWd6bKc2SN11mNq9+A9Dm4r+IfsDO8YZltHC085UQD005iePPZ5fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rH+X63imr66xBj1EpV58L2nOupHgIol/mXNpFJOEQ28=;
	b=sraPgNPue9MtCxfhw3ZKtVRVEDVPj50Rognw5/QndmeU3TSAZwEQY7FYuk3Vls6NKgEK
	 mqcIirDGkE2cfTI+PmZ3nqup5AkmsbYkFr8NnNulEnB14iyNgpUB0MXyXLPii7myBan74
	 hpnqxE/8PmmqDnzehIDpYOjBBIkR/qxHGnUfxADJCncW19xLd4pUvrwYO6pSLB2UBZiCI
	 jx2NmEnmpgajLolVRxlh0+2rQu58q3jWnNLbzrmxVlUn4KSyP2rl4bqbxBbOtg6xenUFu
	 RZm5wxnIwRY17tdGqp+uX83+M6vb41Xz4N7LoFMFl5uUPbGrnjTqv79MBxUdNRuDhtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqKOzYsw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6300606A33D;
	Wed, 18 Nov 2026 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqKOzYsw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AF51F000C4;
	Wed, 18 Nov 2026 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017218;
	bh=rH+X63imr66xBj1EpV58L2nOupHgIol/mXNpFJOEQ28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqKOzYswSVJDy7JB89O89qxmxCDmvQP4i5IO+WC/jMi4JaumTX2MsTrDFeokXMTHS
	 fZumZ3G1oUSc7FWdmgqZzhFeEIlOU87oAUJ889LygEyyNCFAsJ1lCovt33o270Yr0j
	 rMbEAcGD8X8GXu8sCaPYGY6qw15Lu+BhNx+R+o+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0806/2651] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle clock enable errors
Date: Wed, 18 Nov 2026 15:34:06 +0100
Message-ID: <20261118150316.893576284@linuxfoundation.org>
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

[ Upstream commit 1b65c13d1af99170e2a855ca9212a03daa3e7f04 ]

Clock enable errors are currently ignored by several AFE clock
control functions.

Check the return values and roll back previously enabled clocks when
a subsequent clock enable fails.

Fixes: f6b026479b13 ("ASoC: mediatek: mt8188: support audio clock control")
Fixes: 9be0213a6858 ("ASoC: mediatek: mt8188: refine APLL control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c | 69 ++++++++++++++++++----
 1 file changed, 58 insertions(+), 11 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
index 7360cbf6671b4..1ff975ef98eca 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -582,22 +582,47 @@ static int mt8188_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 int mt8188_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
-
+	int ret;
 	/* bus clock for AFE external access, like DRAM */
-	mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_TOP_AUDIO_LOCAL_BUS_SEL]);
+	ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_TOP_AUDIO_LOCAL_BUS_SEL]);
+	if (ret)
+		goto err_local_bus;
 
 	/* bus clock for AFE internal access, like AFE SRAM */
-	mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_TOP_AUD_INTBUS_SEL]);
+	ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_TOP_AUD_INTBUS_SEL]);
+	if (ret)
+		goto err_intbus;
 
 	/* audio 26m clock source */
-	mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_ADSP_AUDIO_26M]);
+	ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_ADSP_AUDIO_26M]);
+	if (ret)
+		goto err_26m;
 
 	/* AFE hw clock */
-	mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_AFE]);
-	mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A1SYS_HP]);
-	mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A1SYS]);
+	ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_AFE]);
+	if (ret)
+		goto err_afe;
+	ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A1SYS_HP]);
+	if (ret)
+		goto err_a1sys_hp;
+	ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A1SYS]);
+	if (ret)
+		goto err_a1sys;
 
 	return 0;
+
+err_a1sys:
+	mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A1SYS_HP]);
+err_a1sys_hp:
+	mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_AFE]);
+err_afe:
+	mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_ADSP_AUDIO_26M]);
+err_26m:
+	mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_TOP_AUD_INTBUS_SEL]);
+err_intbus:
+	mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_TOP_AUDIO_LOCAL_BUS_SEL]);
+err_local_bus:
+	return ret;
 }
 
 int mt8188_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
@@ -633,7 +658,13 @@ static int mt8188_afe_enable_a1sys(struct mtk_base_afe *afe)
 	if (ret)
 		return ret;
 
-	return mt8188_afe_enable_top_cg(afe, MT8188_TOP_CG_A1SYS_TIMING);
+	ret = mt8188_afe_enable_top_cg(afe, MT8188_TOP_CG_A1SYS_TIMING);
+	if (ret) {
+		mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A1SYS]);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int mt8188_afe_disable_a1sys(struct mtk_base_afe *afe)
@@ -654,7 +685,13 @@ static int mt8188_afe_enable_a2sys(struct mtk_base_afe *afe)
 	if (ret)
 		return ret;
 
-	return mt8188_afe_enable_top_cg(afe, MT8188_TOP_CG_A2SYS_TIMING);
+	ret = mt8188_afe_enable_top_cg(afe, MT8188_TOP_CG_A2SYS_TIMING);
+	if (ret) {
+		mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_A2SYS]);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int mt8188_afe_disable_a2sys(struct mtk_base_afe *afe)
@@ -742,8 +779,18 @@ int mt8188_apll2_disable(struct mtk_base_afe *afe)
 
 int mt8188_afe_enable_main_clock(struct mtk_base_afe *afe)
 {
-	mt8188_afe_enable_top_cg(afe, MT8188_TOP_CG_26M_TIMING);
-	mt8188_afe_enable_afe_on(afe);
+	int ret;
+
+	ret = mt8188_afe_enable_top_cg(afe, MT8188_TOP_CG_26M_TIMING);
+	if (ret)
+		return ret;
+
+	ret = mt8188_afe_enable_afe_on(afe);
+	if (ret) {
+		mt8188_afe_disable_top_cg(afe, MT8188_TOP_CG_26M_TIMING);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



