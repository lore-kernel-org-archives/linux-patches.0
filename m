Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048068;
	b=06ngohoivVdgE/V3LRRj0EvtvfrNKJHFHCdKFrnIwKGT/zT5pa+QXUbF+1UiwF3rWDON
	 zUbvmhpM3dZ3JpKEdudho1JAbEiRNc6vEMHyNnbf39fI4CLlEQrR3Y0XYkPq8eCUmhmlB
	 spU9tamAa/xSO15PlxFP2WVMlDvsaTpEUJuJyevDg1qSQCGLAIkSSJfV5SQIqn3oPIMvv
	 EG3XdOG95hf5R9y55kbWG+mmo/QZ/ni1Mh68IgAIh/5aba/YoNaEwmt3Al6lBhiXeHjTU
	 pYbMX8oK/bSeU6cKONKWsnaRaCavYmPXntwsBeSDztq54wUHBYbBJTGe6mRqsv4JDSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vKBnq3lswywIWDNOmvAuHqENybXwIcZy2o+8wFe6yDc=;
	b=ksUgLkKrGCfChMoTAiFpPhcpwKFIbd2YZaZ4KvYuV9H9D1hJLkh43UnDZqIg9//vx+5I
	 5rB22xYevh8YVZL46X7ah4hFNkDwzwOWZy5ej+WjkoklQUUaVEe5EZp/zdFTklj1jMkWU
	 KgC29RFp3956TGIBc+uRxhaLrnKvAfWxN5c+R7pOjfD2mk0Rt2V0TAC8Jn9yUmGNIDLrU
	 HFfRHGnrF/6DgotRdZdp89LMQ8lr/6jYKBcKBfG6vsA3allRmwlOnhgN5OiUE9EWOmTcI
	 EXQvBkUqonSA09+IgjltVXvupYXDjiR9VexhKPcpF8P+7Vb6KjJkqMMrzXBPlWR2UJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4UzmPe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8C0606A320;
	Thu, 19 Nov 2026 00:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4UzmPe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8181F000C4;
	Thu, 19 Nov 2026 00:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048067;
	bh=vKBnq3lswywIWDNOmvAuHqENybXwIcZy2o+8wFe6yDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4UzmPe9mQ066COWo1h7ju6RaYMxR0dfEBj8j3dUw0YNkd7dOGqxN5Ikh0eO6bU/D
	 PTEZ9U/8Xfbhxzu3Dw8yEdzJPp6Vwxj37A2kWBxTtGdDS7OqfTY6edl0uW51Ei7fsl
	 XWkXy/vXoruBkLC/aFDqCTBbn5oIzviBKty17/0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1813/2857] ASoC: mediatek: mt8186: Fix APLL mux setting error handling
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118150306.522716215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5ee5987fadf6ae15678a654b4d909225c97f0299 ]

The APLL mux setup functions return immediately when a clock operation
fails, without undoing the clock changes already made. This can leave
clocks enabled or muxes configured to an unexpected parent.

Restore the affected muxes to CLK26M and disable previously enabled
clocks on error before propagating the original error.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 50 ++++++++++++++++------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index 539e3a023bc4e..e29fed4a18d65 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -100,7 +100,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_1;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_1],
 				     afe_priv->clk[CLK_TOP_APLL1_CK]);
@@ -108,7 +108,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_TOP_APLL1_CK], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_1;
 		}
 
 		/* 180.6336 / 8 = 22.5792MHz */
@@ -116,7 +116,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_ENG1;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
 				     afe_priv->clk[CLK_TOP_APLL1_D8]);
@@ -124,7 +124,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_TOP_APLL1_D8], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_ENG1;
 		}
 	} else {
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
@@ -133,7 +133,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_CLK26M], ret);
-			return ret;
+			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
 
@@ -143,12 +143,25 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_CLK26M], ret);
-			return ret;
+			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 	}
 
 	return 0;
+
+ERR_SELECT_CLK_TOP_MUX_AUD_ENG1:
+	clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
+		       afe_priv->clk[CLK_CLK26M]);
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
+ERR_ENABLE_CLK_TOP_MUX_AUD_ENG1:
+ERR_SELECT_CLK_TOP_MUX_AUD_1:
+	clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_1],
+		       afe_priv->clk[CLK_CLK26M]);
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
+ERR_ENABLE_CLK_TOP_MUX_AUD_1:
+EXIT:
+	return ret;
 }
 
 static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
@@ -161,7 +174,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_2;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_2],
 				     afe_priv->clk[CLK_TOP_APLL2_CK]);
@@ -169,7 +182,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_TOP_APLL2_CK], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_2;
 		}
 
 		/* 196.608 / 8 = 24.576MHz */
@@ -177,7 +190,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_ENG2;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
 				     afe_priv->clk[CLK_TOP_APLL2_D8]);
@@ -185,7 +198,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_TOP_APLL2_D8], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_ENG2;
 		}
 	} else {
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
@@ -194,7 +207,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_CLK26M], ret);
-			return ret;
+			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
 
@@ -204,12 +217,25 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_CLK26M], ret);
-			return ret;
+			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 	}
 
 	return 0;
+
+ERR_SELECT_CLK_TOP_MUX_AUD_ENG2:
+	clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
+		       afe_priv->clk[CLK_CLK26M]);
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
+ERR_ENABLE_CLK_TOP_MUX_AUD_ENG2:
+ERR_SELECT_CLK_TOP_MUX_AUD_2:
+	clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_2],
+		       afe_priv->clk[CLK_CLK26M]);
+	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
+ERR_ENABLE_CLK_TOP_MUX_AUD_2:
+EXIT:
+	return ret;
 }
 
 int mt8186_afe_enable_cgs(struct mtk_base_afe *afe)
-- 
2.53.0



