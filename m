Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040335;
	b=CghbFFjs2ljIODKu75fh9vaoMTFSRFZNbKptJkmuUyKEgNTca83z4NsXhc5jIUILVTzY
	 TvtEGeKT3M3+6q+8z23HsWyNU3PUPphkAZvoS+dVgyAIhMHMBOkx9PsF7erIXsGL2ybCf
	 9ohVJ0TYz/uI4s0O72eEIBSb9Qe15zb8Zb5AjbvSRzAuKeVV6UopYy/UgHp6ILAwjZh1U
	 DFQCAl6IYQDhJWSd6cqLelcwZEVgHw2GjXtO/4TL2GUjc2xsLfpbuvPD4mXgKwMUhtzoU
	 FfCMr9iRIccNezURHo82WxGxUbq10XxFUYimSzkS0dahf8hWI7EcsuFDUvQP8qRs3ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBwjBjX0fD0MuCk9TEO0s5YnsTpCfQG75CmJ1eLQf6M=;
	b=qmrytm4jty6FPZpDcMUvnz6Dypg8snJ20N5/IIHSeH4IxXyscfHNASFbIY/amQc8zgGU
	 OpOqLBVZFaZ4WdYLFGWPsM+Kj9xkReTBYjRv/mvagcFGhUd4cJ+D3cYccyW4tPpQKkxOT
	 M/uuqKoqggd4JKNBhuCWpeY+s4LgR8M+KewiSeEiXcLTlPrNV9cTmndZolztbnKte+h5b
	 UdDmWQdi6aQTR+1kJzu6Pse6OShqWx8kJpXWlC5dppeotM+YqWTmzwCBYeiQjrgAZJnnL
	 WAtWWyg+pPdFxWshmAO1R1K8R/VHz7eseMNH9aVezq8Mg4sxGbxF3bYGXVSZuFynWfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qUDt9zwC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A201606A334;
	Wed, 18 Nov 2026 22:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qUDt9zwC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDE21F000C4;
	Wed, 18 Nov 2026 22:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040335;
	bh=sBwjBjX0fD0MuCk9TEO0s5YnsTpCfQG75CmJ1eLQf6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUDt9zwCS5phlnyXOq4B9RYkyAdGXQrXJZh9uWZpzlnWNEqRK1d3lUvjlNfVDlKL3
	 7So+BORjFmV8EAO8ADTuH7+ilYYFph7tQfg3XZvhy+N44LuqO+3NNzE77lR7ulG9AT
	 rNEtgEmzAi146n0oCl8xgXUPfaUPDP8pO//cSbjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2421/3318] ASoC: mediatek: mt8192: fix AFE clock error handling
Date: Wed, 18 Nov 2026 15:50:43 +0100
Message-ID: <20261118150434.105093721@linuxfoundation.org>
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

[ Upstream commit 7c54781e6e60681af8d0858148d613becb582328 ]

If a clock operation fails in mt8192_afe_enable_clock(), the function
returns immediately via the EXIT label without disabling the clocks
that were successfully enabled earlier in the sequence. This leaves
unneeded clocks running and causes a resource leak.

Properly unwind clocks enabled before an error by jumping to appropriate
cleanup labels on failure.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 28 +++++++++++++++-------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index bd778e5663b56..7647bdd463d9c 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -220,21 +220,21 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_INFRA_SYS_AUDIO], ret);
-		goto EXIT;
+		return ret;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_INFRA_AUDIO_26M]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_INFRA_AUDIO_26M], ret);
-		goto EXIT;
+		goto err_disable_infra_sys_audio;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_MUX_AUDIO]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIO], ret);
-		goto EXIT;
+		goto err_disable_infra_audio_26m;
 	}
 	ret = clk_set_parent(afe_priv->clk[CLK_MUX_AUDIO],
 			     afe_priv->clk[CLK_CLK26M]);
@@ -242,14 +242,14 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIO],
 			aud_clks[CLK_CLK26M], ret);
-		goto EXIT;
+		goto err_disable_mux_audio;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIOINTBUS], ret);
-		goto EXIT;
+		goto err_disable_mux_audio;
 	}
 
 	ret = mt8192_set_audio_int_bus_parent(afe, CLK_CLK26M);
@@ -257,7 +257,7 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIOINTBUS],
 			aud_clks[CLK_CLK26M], ret);
-		goto EXIT;
+		goto err_disable_mux_audiointbus;
 	}
 
 	ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUDIO_H],
@@ -266,17 +266,27 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_TOP_MUX_AUDIO_H],
 			aud_clks[CLK_TOP_APLL2_CK], ret);
-		goto EXIT;
+		goto err_disable_mux_audiointbus;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_AFE]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[CLK_AFE], ret);
-		goto EXIT;
+		goto err_disable_mux_audiointbus;
 	}
 
-EXIT:
+	return 0;
+
+err_disable_mux_audiointbus:
+	clk_disable_unprepare(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
+err_disable_mux_audio:
+	clk_disable_unprepare(afe_priv->clk[CLK_MUX_AUDIO]);
+err_disable_infra_audio_26m:
+	clk_disable_unprepare(afe_priv->clk[CLK_INFRA_AUDIO_26M]);
+err_disable_infra_sys_audio:
+	clk_disable_unprepare(afe_priv->clk[CLK_INFRA_SYS_AUDIO]);
+
 	return ret;
 }
 
-- 
2.53.0



