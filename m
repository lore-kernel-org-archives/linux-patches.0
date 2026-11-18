Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024707;
	b=XBlk2M+k6d+M8GhcU1hn6Gu9E8pI+j5J9oR7RdHB7MRj+mmTV6wi7YxTsWsCEqOejV/a
	 OsqEjI3WWDNm7OiJO64GZ5o60TMmNzGgriLt/my/sG9KZbieWXhpQN1AhHFfIuh7IqTSh
	 p/SRHMYM+vxNLt7LsbiqLokwsckaqaI0kNfGJcfj/obL3Or3MCzf9u0NOCGptj3HKbxC7
	 UMLLLYTA515g3ZoLolZdU6qHVBKlglb86UuIZFmneWiuC0ovI5+XKgf6hg7IGFN6Tm9gq
	 NnChJbB4mjXxJO3EhsSP5NbGaE7WJZLf+P4CV9lXoGSCJIAG1O3gpGyxjlqyRDMfcHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TNfEVM4jVC6YjU9LmI8c6Pc69XOilBwQoodR3GRmcLM=;
	b=Fj4Q0VlbGTWsp15/R0RlBNFj5zcyYs1HC/SPt0XI649BLCTZQJHGqM/8xn7iiFINs2dQ
	 6CR8ps2L2HNN0ehokeuTYNsL9/ACrRL4Sr8UzDAaG7cXyoBxGk694dM2tNtMgPY/dXh70
	 BVgxA5LxrOJT4EbYol278svHt29opXJcgpL1nJ07XL99ubvmrSGtTx5JTIRyAeLbdOvwn
	 VaexZSD5us72pIiDgG+GiHdydm8xcJRJ6DNZDj6Cqv9jJsrlnQm/3YHYc4OfdhKpmq1vO
	 TRwprtUUcrnr47TdXi7cYYSGpwg1wa0a68T0tuIuyYbWH+tsxaSwM3k90WUIi34G5fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkzH29LL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A23606A325;
	Wed, 18 Nov 2026 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkzH29LL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DFE1F000C6;
	Wed, 18 Nov 2026 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024707;
	bh=TNfEVM4jVC6YjU9LmI8c6Pc69XOilBwQoodR3GRmcLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkzH29LLpbvjQUcgEgK9SHMb5AyxEmbY4icAE0tFlJ9PgoR/I99vMpPSTC9ABO/jT
	 M7WHN22tC6SxIda9CH+/BYJXnb0tyhYTB55OpKVQmZWqwJlCoGbPdcCb0erY/wtoMe
	 SDyF3kVQ1bPmuqPNhICkOZy5wvERajbdJd820Qfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0819/2151] ASoC: mediatek: mt8192: fix APLL mux error handling
Date: Wed, 18 Nov 2026 15:42:34 +0100
Message-ID: <20261118150151.969963957@linuxfoundation.org>
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

[ Upstream commit e8c263e0ef957fd8286e299b2be9266b902cec16 ]

Propagate errors from clock operations in the enable path and clean up
previously enabled clocks when a later operation fails.

For the disable path, continue disabling all clocks even if a clock
operation fails. Log the error without returning it, so the disable path
can perform as much cleanup as possible.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 54 +++++++++++++---------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 416aff7262539..bd778e5663b56 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -87,7 +87,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1], ret);
-			goto EXIT;
+			return ret;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_1],
 				     afe_priv->clk[CLK_TOP_APLL1_CK]);
@@ -95,7 +95,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_TOP_APLL1_CK], ret);
-			goto EXIT;
+			goto err_disable_mux_aud_1;
 		}
 
 		/* 180.6336 / 4 = 45.1584MHz */
@@ -103,7 +103,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1], ret);
-			goto EXIT;
+			goto err_set_parent_mux_aud_1;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
 				     afe_priv->clk[CLK_TOP_APLL1_D4]);
@@ -111,31 +111,36 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_TOP_APLL1_D4], ret);
-			goto EXIT;
+			goto err_disable_mux_aud_eng1;
 		}
 	} else {
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
 				     afe_priv->clk[CLK_CLK26M]);
-		if (ret) {
+		if (ret)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
-		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
 
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_1],
 				     afe_priv->clk[CLK_CLK26M]);
-		if (ret) {
+		if (ret)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
-		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 	}
 
-EXIT:
+	return 0;
+
+err_disable_mux_aud_eng1:
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
+err_set_parent_mux_aud_1:
+	clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_1],
+		       afe_priv->clk[CLK_CLK26M]);
+err_disable_mux_aud_1:
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
+
 	return ret;
 }
 
@@ -149,7 +154,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2], ret);
-			goto EXIT;
+			return ret;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_2],
 				     afe_priv->clk[CLK_TOP_APLL2_CK]);
@@ -157,7 +162,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_TOP_APLL2_CK], ret);
-			goto EXIT;
+			goto err_disable_mux_aud_2;
 		}
 
 		/* 196.608 / 4 = 49.152MHz */
@@ -165,7 +170,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2], ret);
-			goto EXIT;
+			goto err_set_parent_mux_aud_2;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
 				     afe_priv->clk[CLK_TOP_APLL2_D4]);
@@ -173,31 +178,36 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_TOP_APLL2_D4], ret);
-			goto EXIT;
+			goto err_disable_mux_aud_eng2;
 		}
 	} else {
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
 				     afe_priv->clk[CLK_CLK26M]);
-		if (ret) {
+		if (ret)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
-		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
 
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_2],
 				     afe_priv->clk[CLK_CLK26M]);
-		if (ret) {
+		if (ret)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
-		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 	}
 
-EXIT:
+	return 0;
+
+err_disable_mux_aud_eng2:
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
+err_set_parent_mux_aud_2:
+	clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_2],
+		       afe_priv->clk[CLK_CLK26M]);
+err_disable_mux_aud_2:
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
+
 	return ret;
 }
 
-- 
2.53.0



