Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048750;
	b=o9Smc1JMmbHgasFX62pNHsPkHPM1XZtywSgMakigme1jYYiDwLE2pEeAezTnsIXjVKeb
	 lMOYLqFRfVO3kZibLsZ9eG9ULa/ziAAnrYD+/VS7BHTA0MDhHQvfBTEuMr3nR5Cq8orSX
	 YHSLDT5rKLZ6Vmc0J3e0pfute7lJzMCgOfsrkAGxSCIYFVZLLquuc5nLqiSUqFJ1e7O8s
	 1EzXZjzDrxWiK5uBIWJlfv2gnTjhXTPKAW6zrDQ/MLuFSgTWBm9dnSGoRc1/1GVqdq7UV
	 psmY/25GaEbgZzTYPxiWMhNejGmnkfSrihZzKFjXGCgOVgEKcG86ZgQ1/HrNleZgbXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1UPjUJ90HkfcDIBfXVMCpVpP7qA5NncVPKjrCGNXuew=;
	b=fi00M8D5iHL38kRrKalN4I9qMTSBz7Sa0RYTjpd9yD5ZIXda0KeLwe8YHBJHifO3MScU
	 22AvJ+JDoHE0HVcBcbdhu98QWJVpC+dLauoHNGdOw1r+p+u7foyiarcNKGsUbHfy3zG92
	 KTB9g5y28+fbAwCZXTzkW4iXFZGNOYndUItxumGF+X1XTSE5XZSqdcdFRwaSNzfQpML4S
	 ODh4Rvhjto2F/Yq7tuPS4okKiXEDn3EfPlJGNWJLIBUIamIjaXsU2AWbTVnQ63FMOdF/b
	 Th87C0/bM1rxFDfOG2egUmpRz64FjaPcTDEkyu3YLTuD7Eeg9tPtuv1S2Lg06Y6TTDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNTSfD2m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A562606A31C;
	Thu, 19 Nov 2026 00:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNTSfD2m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB31F000C4;
	Thu, 19 Nov 2026 00:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048750;
	bh=1UPjUJ90HkfcDIBfXVMCpVpP7qA5NncVPKjrCGNXuew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNTSfD2mS9sEqeKd9L3NcHzHApC4ckClhMC2EI/nXL2J3M50V2nEQ4jOasPhyQZ8j
	 Z2G6aVFhv4MWSsJ4WO0zP6nKRSLAwvOE9lrxXwfkz9/d0y6x4U56BROQiyFG9hUCG+
	 ASahWcKEQ/+vtA1kHoR2T5Qpvjf/FN/7u24cO/a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2105/2857] ASoC: mediatek: mt8192: fix AFE clock error handling
Date: Wed, 18 Nov 2026 15:52:19 +0100
Message-ID: <20261118150317.206253389@linuxfoundation.org>
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
index 9d430f43aa7dd..06200b57558b9 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -222,21 +222,21 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
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
@@ -244,14 +244,14 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
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
@@ -259,7 +259,7 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIOINTBUS],
 			aud_clks[CLK_CLK26M], ret);
-		goto EXIT;
+		goto err_disable_mux_audiointbus;
 	}
 
 	ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUDIO_H],
@@ -268,17 +268,27 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
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



