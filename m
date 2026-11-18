Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020110;
	b=3PEXKj+fdW5Qs75i2k2+DRLSwWGPrqM275QgbAQn5Y+VKIaXvwnNBGEsbWCyVdAxmFZk
	 RJiIoNfWcQHquxQj8VkEfSwA4hyMosOJC7pBHZQJa9laGXl+pjqzxh43b6qlP4ezQCxo9
	 bXAKCS5V7oYNAjglqkiwbWdL4lblkgbLdB8HVbYCsfLGkSX37ql2RpIDMz4O/XZpmIDe4
	 XGLgcRYXO3SEcvmPiHD+rMkL2mWv4GXkXi05ilYq8LqIgw75dmua08ZXr+4AcLsH0gglU
	 qdznyhaf/zzW0y3tUX7lCSpzXluhYLZ1xHQVGFYGYXELs/eR9Eh54bwFBw7lxgbHq1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jXn/4dd8sc5t0IBytLAqwffKngUIDlremp0K00OH7Lw=;
	b=FpOSFCP52Ip/bQ70p8cF+vnWF7Rnewf0AOepv0Gk4RDPc9kQNT7X45ZFspFGb0tN8tRY
	 yNYhSE/8qFY8XbnqHvf2jc2UN8Xq8bFwPHXgrrQxsA2l55VjF2y6sOdYvpWluXH0Tz44D
	 lbTbvHCdur6/F5gl8pcTj2uwbCiEs8Y/WfJuuPGZQZ1w4WoTTzxRX3ljZQ5V8kxboteQ7
	 rPkTKiZGYwOOJfAlE01cEYkF5CExLVmqchtrjMq6loHPhiFXaDJb3qqy3xVuSKKPu+OO4
	 LU5D6CTUV+A17JQkkOCkh0P9vKsh3N2nyOSnrVpGKduxksMW1tNYMCGS0GHe7gH5o1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gc0j9r05;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0E0606A320;
	Wed, 18 Nov 2026 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gc0j9r05
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502551F000C5;
	Wed, 18 Nov 2026 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020109;
	bh=jXn/4dd8sc5t0IBytLAqwffKngUIDlremp0K00OH7Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gc0j9r0546OWMQtn+KXw6UTuNFahZOd9iICZvCuh+NMDJemPBLwnZvT3A0ylyHJ6T
	 5btkgSZ8219J9o7FH3CnoyKGBgIEJWCTGYG2OmX+XpkSJuH7lfzM0B9lYE0H0585Ya
	 dX9ALdDT8zWksBJd2O1uRYskzvjPxnBqlzuphkhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1794/2651] ASoC: mediatek: mt8196: fix register access clock error handling
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118150351.902232133@linuxfoundation.org>
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

[ Upstream commit 2844ba593741a9c9061b8c99790a47ffeed4114d ]

Propagate errors from clock operations and disable previously enabled
clocks when a later operation fails.

This ensures that the register access clocks are properly cleaned up on
the error path.

Fixes: 7384ecab34eb ("ASoC: mediatek: mt8196: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-afe-clk.c | 25 +++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
index 1d107b85d03c1..6198711e01b5c 100644
--- a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
+++ b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
@@ -546,26 +546,41 @@ int mt8196_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 	int ret;
 
 	/* bus clock for AFE external access, like DRAM */
-	mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_TOP_ADSP_SEL]);
+	ret = mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_TOP_ADSP_SEL]);
+	if (ret)
+		return ret;
 
 	/* bus clock for AFE internal access, like AFE SRAM */
-	mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIOINTBUS]);
+	ret = mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIOINTBUS]);
+	if (ret)
+		goto err_disable_adsp_sel;
 	ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIOINTBUS],
 				      MT8196_AFE_26M);
 	if (ret)
-		return ret;
+		goto err_disable_audiointbus;
 
 	/* enable audio h clock */
-	mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
+	ret = mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
+	if (ret)
+		goto err_disable_audiointbus;
 	ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
 				      MT8196_AFE_26M);
 	if (ret)
-		return ret;
+		goto err_disable_audio_h;
 
 	/* AFE hw clock */
 	/* IPM2.0: USE HOPPING & 26M */
 	/* set in the regmap_register_patch */
 	return 0;
+
+err_disable_audio_h:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
+err_disable_audiointbus:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIOINTBUS]);
+err_disable_adsp_sel:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_TOP_ADSP_SEL]);
+
+	return ret;
 }
 
 int mt8196_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
-- 
2.53.0



