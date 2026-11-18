Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030084;
	b=D21fT33li1iWeLzznMQ/hVeuWGc+y8g1IvS8Wrp55JsCirr4kZXW4lkE9GkKn7jAbFWb
	 SZXgL1MmBxvL2kALMk7BdsZrPG1IzFB32sPxywB2dM43KTgYuSTUgL4ZT6V1lDLBhY9hC
	 4JmptOLoYBWKwhpn8A3954rgHEe43WY+9lwUZFiL4qIU304MIOjLk7tGc/seNHzqj8ekS
	 Lo+MgTM1BQxrCIpJJrCNw222N6NNiUam3uHa8QHyrSsoXeKwHVzynBcKPngAsFpMQjEqo
	 vGUhb3SRTBSetUoG9++wQ17aMIxEYHovnS2YUHaMXk7Xb2dZJ1ZobMpD8BFMHztG9yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S+10Sz6ZETecEXqLantHGKfjvyxdcL9XoB52ELRebq0=;
	b=DETbqrV6QPU8sYrtV7w5gClQ9VUqCoYnntha3Phw97iCbxs68b0L9p4wGyzKbiEwzv2I
	 S0afAxL7M19XLUOIFjguR0V0QphMOycn0teWWDROX0BvYMJK6HIxERrs5JRWU7ytdEC4M
	 iGbayKSvI7RrryNWEdT303Tq1/Ne/RZyhtrLrkdx8e1qIftdnulO4NofkQ50O9Lpnb9pe
	 6hBDqlI+l2iIjHg/RIWjxak64MbMNJ0kWCmLfDNfUx0b9+PWTpcmbz1n2su5TIXp6q5vw
	 RwosrU1j0sJWFy9T3DH2xyQ5qjuzqjaK0yObMGpcKIl8AwEi2I4oj16I/rqdR1QoPoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIRTZ3KA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1A5606D355;
	Wed, 18 Nov 2026 19:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIRTZ3KA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19DB1F000C5;
	Wed, 18 Nov 2026 19:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030084;
	bh=S+10Sz6ZETecEXqLantHGKfjvyxdcL9XoB52ELRebq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIRTZ3KAbNFoa6wc3wc/YchMNFQeLqNiL+/ZSpScdfwU0UdShWPBY3002349Hhf4z
	 E/fIdEeiDJXgW/AXuNg282sZc5QpBK8cM8yPUsE/3U0LYn36zWZgSZwd2k9khE88nV
	 xXsd6sbAdK6go8oZtASwC1GdNIieqEQLC2gOBo+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0579/1756] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle clock enable errors
Date: Wed, 18 Nov 2026 15:45:06 +0100
Message-ID: <20261118150032.092054525@linuxfoundation.org>
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



