Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020062;
	b=x8YLFnc0LQIHxEMuglgCPuLTsfUgPxQgncqEIbX7E1GaZORQ28dZ3zXjdfw7FyFRxmiT
	 bANyoxPwUQKFkp76rRCxHUg/IP0OfH4l6qll0RTFkPB8+Pn81VfSLEnbpFn5Oa36H8UW2
	 dzDc8bMZPf668cEXjE39xN20OVnzCBZedC8EORkEbcePFCS+qH3bLbPLA3Mbf4fmQF3So
	 XBGHIk+jf5HSahxJHpB4cUtk99l+lxQdBGUdlKpJUd0svePJS4K50fdXGwIQKACr6h3Da
	 xw9OqxnVQbPLO9XPkztiJg3l9YFuHhqg16CU57OrpaEkBO0xDMzhvBoYbzi/PS0rgXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cDd41vbzKBDwtmXyBiskoWFMHM6KbyJ2jFTQQhzNZp0=;
	b=1wgnO07uJLavewBEUEOcuzgb1ZpYUbzrRpD4PaByFtpvSP210KYW2lC2p0Cz4LvB28vn
	 mfdvI8+gM8fNomyGrnBqXDy4t4sorYmjGpfYsmJMhqt39HJEMSfZ9iHHJk6I4oU/i5G/o
	 VpsUFg3uXRUvuf39ldZB6fQPHOoloKItynLK3ogfFXCuYcVRT5RtYoJeNU/yec4q2xzTm
	 KFPDfqLW7A1Vt/mWDhWmneDkRuTObLfDkju/rCVM6QukhAw8o4XoNIRbVKyTkKc1h/UgB
	 ttnvx13hFD0e/qVsnVXsUeemOJq5jA8cwUzVAw/pBm9GwyXccuQS9YGB2YndNuby71A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVbiq6WR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFC606A32F;
	Wed, 18 Nov 2026 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVbiq6WR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6C11F000C4;
	Wed, 18 Nov 2026 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020062;
	bh=cDd41vbzKBDwtmXyBiskoWFMHM6KbyJ2jFTQQhzNZp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVbiq6WR7EYMFDbJAK3cyaEiYYgC9EZn9w4QEbo8jmCbEYtm+zBQBhRDAU3xdOiZm
	 Ce0HZuy+AeeO8LUDVTI6QnPc4RL/S/eiAWnbCyQU6uEH+310RdvXeDHPUviZyoOVJn
	 O1ii53fuwY4XKKi1yPReQm5+Bn7doD1MfhhckIDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1791/2651] ASoC: mediatek: mt8196: fix APLL mux error handling
Date: Wed, 18 Nov 2026 15:50:31 +0100
Message-ID: <20261118150351.805451086@linuxfoundation.org>
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

[ Upstream commit 5a0caca149f2938cd82b96b631c5a144329bd30e ]

Propagate errors from clock operations in the enable path and clean up
previously enabled clocks when a later operation fails.

For the disable path, continue disabling all clocks even if a clock
operation fails. Do not propagate the errors so that the disable path
can perform as much cleanup as possible.

Fixes: 7384ecab34eb ("ASoC: mediatek: mt8196: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-afe-clk.c | 56 +++++++++++++---------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
index 286e39f53ae05..91ae440249492 100644
--- a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
+++ b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
@@ -220,33 +220,39 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG1],
 					      MT8196_AUD_ENG1_CLK);
 		if (ret)
-			return ret;
+			goto err_disable_eng1;
 
 		ret = mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
 		if (ret)
-			return ret;
+			goto err_restore_eng1;
 
 		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
 					      apll_rate);
 		if (ret)
-			return ret;
+			goto err_disable_audio_h;
 	} else {
-		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG1],
-					      MT8196_AFE_26M);
-		if (ret)
-			return ret;
+		mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG1],
+					MT8196_AFE_26M);
 
 		mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG1]);
 
-		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
-					      MT8196_AFE_26M);
-		if (ret)
-			return ret;
+		mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
+					MT8196_AFE_26M);
 
 		mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
 	}
 
 	return 0;
+
+err_disable_audio_h:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
+err_restore_eng1:
+	mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG1],
+				MT8196_AFE_26M);
+err_disable_eng1:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG1]);
+
+	return ret;
 }
 
 static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
@@ -268,33 +274,39 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG2],
 					      MT8196_AUD_ENG2_CLK);
 		if (ret)
-			return ret;
+			goto err_disable_eng2;
 
 		ret = mt8196_afe_enable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
 		if (ret)
-			return ret;
+			goto err_restore_eng2;
 
 		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
 					      apll_rate);
 		if (ret)
-			return ret;
+			goto err_disable_audio_h;
 	} else {
-		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG2],
-					      MT8196_AFE_26M);
-		if (ret)
-			return ret;
+		mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG2],
+					MT8196_AFE_26M);
 
 		mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG2]);
 
-		ret = mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
-					      MT8196_AFE_26M);
-		if (ret)
-			return ret;
+		mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H],
+					MT8196_AFE_26M);
 
 		mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
 	}
 
 	return 0;
+
+err_disable_audio_h:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUDIO_H]);
+err_restore_eng2:
+	mt8196_afe_set_clk_rate(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG2],
+				MT8196_AFE_26M);
+err_disable_eng2:
+	mt8196_afe_disable_clk(afe, afe_priv->clk[MT8196_CLK_VLP_MUX_AUD_ENG2]);
+
+	return ret;
 }
 
 int mt8196_apll1_enable(struct mtk_base_afe *afe)
-- 
2.53.0



