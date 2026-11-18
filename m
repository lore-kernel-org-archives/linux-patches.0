Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030325;
	b=W/4HaTLJcKf3D/n5XEddKg4Uq+kfkH0IORFS9FZYLvRVwL6+V4fla6m/BDhVpdm29j5B
	 J68rPTLl/1NPltYpv2BbJHhRRHgTxg3rmQH8uPBUGCK+XI1njKUQfyOleotu8DISkt5US
	 M35M9r/R3ZWwzLIVeYO6/lIPkqqX+h21RohIfhnJlOmFZS12FGuImyJBOJQJ6g39tJ8QT
	 KOpceqXiRpdMjQlwO4qjWB3Q7DX6PcEGnsZJAtxDXZj+jWk4T0XYtuBNe5pT9W/scX5Wh
	 1VyGjzlalCVG+VIriqLDcGxEyRmC3a2eh4O1wZPWwSmtVDf+qFC5zl6tgP81j9JrRww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QBM5Huqk+W2wpCddT41NcRtD4nT8vKRrFP4fbImxhWU=;
	b=5NbycLpzkWVryr2+32Oex5u5r+S61gCCzOakuJISM/RqW9P3tCHUhIBa7PFinkCVQQGJ
	 TtHL8lO3JUFzO4J7k/JzqpYpe6nmIjcYD6+632QWvEWuch942pVlmFNADxhx+UYd0o0Zn
	 /SzKegMfc2DSEUccBpdUJ1C2Hu8VVjChMY94rwShyOl5t54LHAh/4sHKxr9TCvD97HV1e
	 NRQr7Wm0zrWn6zDztVjqnWf99nDOYvZ1YdnAotOz0tTLiY6957j+X1x5h798kDODD1TeJ
	 jNtlzuatrr2tYYiNzUIWmXQGHGvOC4pl67x6n/B/2sUDj8X6QwE2FMDZm2TSyB2zU7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcGkyLY5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D55606A333;
	Wed, 18 Nov 2026 19:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcGkyLY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615951F000C7;
	Wed, 18 Nov 2026 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030324;
	bh=QBM5Huqk+W2wpCddT41NcRtD4nT8vKRrFP4fbImxhWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcGkyLY5XwhSdGd4/f8dyGBjhVymKZwZ9VlwAJLYtMbMPXB9CQNPy4KFpi+3t5mkw
	 u18not8pArfq7tTlGQG9eHwOIx3e1nfkwWtPcwHtWuGx0czsT2dDNUnq2GLMQ+Otn4
	 WFyf4fhapmHWQAiZA7lPXLt0cFtHKcJ07nbRwadM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0647/1756] ASoC: mediatek: mt8192: fix error handling in APLL enable functions
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118150034.574453036@linuxfoundation.org>
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

[ Upstream commit 88760524ca995acd229c30ec69ced7d883a90a72 ]

If a clock operation fails in mt8192_apll1_enable() or apll2_enable(),
the functions return without checking the return value of mux settings or
unwinding previously enabled clocks and MUX configurations.

Fix this by checking the return value of apll1_mux_setting() and
apll2_mux_setting(), and adding proper unwind handling on failure.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 32 ++++++++++++++++------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 7647bdd463d9c..118dd48196828 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -308,20 +308,22 @@ int mt8192_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL22M]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_APLL22M], ret);
-		goto EXIT;
+		goto err_disable_mux_setting;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL1_TUNER]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_APLL1_TUNER], ret);
-		goto EXIT;
+		goto err_disable_apll22m;
 	}
 
 	regmap_update_bits(afe->regmap, AFE_APLL1_TUNER_CFG,
@@ -332,7 +334,13 @@ int mt8192_apll1_enable(struct mtk_base_afe *afe)
 			   AFE_22M_ON_MASK_SFT,
 			   0x1 << AFE_22M_ON_SFT);
 
-EXIT:
+	return 0;
+
+err_disable_apll22m:
+	clk_disable_unprepare(afe_priv->clk[CLK_APLL22M]);
+err_disable_mux_setting:
+	apll1_mux_setting(afe, false);
+
 	return ret;
 }
 
@@ -358,20 +366,22 @@ int mt8192_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL24M]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_APLL24M], ret);
-		goto EXIT;
+		goto err_disable_mux_setting;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL2_TUNER]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_APLL2_TUNER], ret);
-		goto EXIT;
+		goto err_disable_apll24m;
 	}
 
 	regmap_update_bits(afe->regmap, AFE_APLL2_TUNER_CFG,
@@ -382,7 +392,13 @@ int mt8192_apll2_enable(struct mtk_base_afe *afe)
 			   AFE_24M_ON_MASK_SFT,
 			   0x1 << AFE_24M_ON_SFT);
 
-EXIT:
+	return 0;
+
+err_disable_apll24m:
+	clk_disable_unprepare(afe_priv->clk[CLK_APLL24M]);
+err_disable_mux_setting:
+	apll2_mux_setting(afe, false);
+
 	return ret;
 }
 
-- 
2.53.0



