Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040332;
	b=1ZwqDE4cqPZ0J1s6igsgDgOF1fkS6ehn1byzO67OM9YZFZIZ/lCk64eAZs36mfPyFBxx
	 t8SSSDmwTIWwfMaxOxfSjltKBbdK3oUY3vx6kbVkpB0wHbZjovKm+QKKvcDblaeFbJCvC
	 FNsDsCLUTNGcW5/pbYIJGsSqLQk4cVe8vGO8TD9CT6LmN3Hrav6EQEJR6udxGhaTGkhFg
	 TszVSFt9rXRsyt6XjIXTDJii/43J/8/umIV5f0Mt9/xfilUyiXQ7pjh6811RzatJE6OJ+
	 uy3VpnRAKMD9MDmpPsKF2BV95Lt5EscKN16bG+Wzlxl6o04/hBwlU5mS4vQsZTQdr5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3/Lzhd67Fwn6ER/Z0FLJUuaLCWUzyEOVnokUvliAQc=;
	b=cJw937pmzmYDUMtlQd3mDe8rNQpp7Re1m3JGShFaL/1B9yUrKgvGTKlNqrx36nkexaS9
	 9bVHG8Oabfd9HtIItKhCGMUZM6Todqy+/zLx5ybFOE7WUF2Rum1MZ4Vw0NR+HTMq/oOYL
	 K18F1qOghZkyNJP0FM2gCFJzdsi85Q4pisrJe7P4kD5RrVLTmZEBOqFSAmVYyRsV5Sa3/
	 B7x8qVHJwdGUjU6eLlzU0VwKZiWHWv9XxW5byj+BpkWfNMeMDMaHOGnLH4O5qvHW7xRgH
	 ecqTYHduFoDI/FgMJH+fUZpNw/WxdawK4sjzNaYhuKleXn63Nq74J7gPPMkn1t+5Cfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwCCSwzA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5013F606A320;
	Wed, 18 Nov 2026 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwCCSwzA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A113F1F000C4;
	Wed, 18 Nov 2026 22:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040332;
	bh=Z3/Lzhd67Fwn6ER/Z0FLJUuaLCWUzyEOVnokUvliAQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwCCSwzAciy2dQcD0LdyqO5mzxJXQEmYksURslAElEahP0BRNtjZG9SXzGHDWZhU6
	 og6dNSv4wol7Rdz6O5M92LSb8Zpw2O94GDHVYRhG7LQFab3p6XprbvW8gbITamryJW
	 5P67YLYNbXi9pqodPc+5UZ/N4hjue3z+Bnf5h8r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2420/3318] ASoC: mediatek: mt8192: fix APLL mux error handling
Date: Wed, 18 Nov 2026 15:50:42 +0100
Message-ID: <20261118150434.078908177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



