Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024397;
	b=nyVaTgKiU3sgKB1MERGA6x/oi4bY1kqHe2gEzpGqKp++Hiw3CduO8shu6WEvdResxGr0
	 c59l1xw3p+1t6qJNCoz5dJc5NMilM2gkhfp1QGDGgDd7T/SQp26YtrGm3L8rbPIIG+py0
	 /y/f/F3B9qAM/COGMkmhOVGswCLgJzbczPZ6+tI/X5xwBHOKyr7DCwXmvyxKjT8FWLV/j
	 EjXFOqq2cAZB4TIQRXMwQo+2XVJ0hB14LubumiioUeI/1yBbh0UM650IFnkH+bL4B2jdT
	 qdqHBIdF6gLWLJozXCDup7C+KKIFQ/RaFPPzYudHCOrJVeEaNm5veuuLXUINyCk03tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e7CkEYCXIzpf/GVefdOXcagmfeNRBaRh4pzajQsoc1Q=;
	b=olT8KmsrkbTAhe1EfRUCa7IWtHxNgQaETnXygDICzuMtA+LAHV2xvqVPjxcc3lgkTo5/
	 iGOHTKmoNM6g2wL55Mj27hN+cSoO0/DIb/1t2yvSRwGaJ74HoeCbTHq/kjubGtyP6ZbJ2
	 FtRCr4j7PNYHN12u4LWybAxS/+uAYMCJofto47AhGmsch8m6VpyzFCVU7bQuQICmt5o8s
	 jr9jqxF6Rz3n+XGZVpQd2oH9kwkLz3PCqHoroTGIQSxcsM5LwLmFWmIOgVaiZSWDgZTU9
	 u+3gKHaJBgX2UvQBbZZDM3sTierMFGhJ/1JW5pxYMKzjK3lwVBPWWNz+gCvezfttxOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXbTbOxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D412A606A320;
	Wed, 18 Nov 2026 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXbTbOxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390CF1F000C5;
	Wed, 18 Nov 2026 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024397;
	bh=e7CkEYCXIzpf/GVefdOXcagmfeNRBaRh4pzajQsoc1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXbTbOxYUEopnFhvFLKyHgDnr39uRrXYzZt2MirJeh55T6ogmf+fDVnxuvuhGJAi3
	 2gkNvcm3KTvOtynKOjHa01UPjyAz8m8oiPzLCvA3lNmqj5lZw1JdQnOaHFAjz9mCmQ
	 D+UFLY8LNvhRvMOquMk0k7BAgMBRLHAARmJ1Ism0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0711/2151] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle clock enable errors
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118150147.780579398@linuxfoundation.org>
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
index 516b9b4ee0339..94f21cb15d23e 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -589,22 +589,47 @@ static int mt8188_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
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
@@ -640,7 +665,13 @@ static int mt8188_afe_enable_a1sys(struct mtk_base_afe *afe)
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
@@ -661,7 +692,13 @@ static int mt8188_afe_enable_a2sys(struct mtk_base_afe *afe)
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
@@ -749,8 +786,18 @@ int mt8188_apll2_disable(struct mtk_base_afe *afe)
 
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



