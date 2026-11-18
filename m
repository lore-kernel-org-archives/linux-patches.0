Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015712;
	b=FL8k16Oq7KoXyhERPeTBVJ5lDQ+ttLl+TwduNpd49RecN6CnnyckzHZ0ZKdLMzjjk/SM
	 ndcz0zOIfp+UzI2+OWhapwYrlNY+XXmOdIm9rGel4ayrbQ5Zp+gNxrbD2nKNy7qtPtI9k
	 rundTFZ63FLaIVfSMxy6HnfxxwfB0UPhR3XEAhROJ3N+EcQpXRQ9/YUl4brHrjrqywlla
	 AydxrF3JYyy1MU6joL8McCxv8DFoFUjvtDbqHMuK/LDA7c1Fn25/1RYdrcc1IvM02mOKX
	 qTHlcefEeoTx9Dl+EQDUuyBYS05d9habjnJq9cR4GbzMPkSMZZZ1CQ269PLrHnT6owA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQnNViqBAD/C8RKBCawa3B7h2keJxS7coTMv+1CCDss=;
	b=ILaaP/BE8Vyk+yW92NuzugnaM8PjzaCYRlM5QpgTwWvbcPihqliiUCb5V4Tk5F0Jn8cp
	 3zHGwc1mwKlqZFFTbc+oETD2soBeq6e20eHiqqGx0zmNtBEtOzd1DSE3s/1S6pztOlvOV
	 bipMy5wabzCNnI+MI9iETw8OkTcClK7/69EuAgTeAPbJqr0uDPATRpEmPv9Zmgi5eZhLR
	 AC4ivfs8lciiPAW/n6dwG/iT0pTCncSMOqm8JkY5KSi2epwdO2rFB9wXiUCS67NjHny7w
	 0NHfiiTLP1v2ybBHr2zwgI6hUowaf/m7F/zb3jtaxi+p9tp/qzcBqXh0mqEysA1+R0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sx2ZAMN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19BF606A330;
	Wed, 18 Nov 2026 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sx2ZAMN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0874A1F000C4;
	Wed, 18 Nov 2026 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015712;
	bh=MQnNViqBAD/C8RKBCawa3B7h2keJxS7coTMv+1CCDss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sx2ZAMN0KtpEGKmhlduoxNo2enc0WVpcrKrPMk7amjxgCaoQR79Fkhxbh4E6N7L4m
	 P62cu59GM7mT1cWjt7nIRFn68I/SG+hIocrwSatLHjnutQ0yhrwSYpYmCaM7Oq5bkG
	 +KdYWdBs9aAnI79tJz0pZXo+r1VpTf8RI/GAfH3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0271/2651] ASoC: mediatek: mt8186: Fix clock handling in mux disable path
Date: Wed, 18 Nov 2026 15:25:11 +0100
Message-ID: <20261118150257.668035320@linuxfoundation.org>
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

[ Upstream commit d70109f5510b423e72894dadfbab27087a7b26b0 ]

In the disable path of the appl*_mux_setting() functions,
clk_disable_unprepare() is called after clk_set_parent().
If clk_set_parent() fails, clk_disable_unprepare() is skipped,
potentially leaving one of the clocks enabled.

Remove the goto exit paths so that all teardown steps are attempted
and any errors are only reported.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index aa8b2eaf7b958..3edd0dd20eed0 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -131,7 +131,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
 
@@ -141,7 +140,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 	}
@@ -158,7 +156,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		       afe_priv->clk[CLK_CLK26M]);
 	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 ERR_ENABLE_CLK_TOP_MUX_AUD_1:
-EXIT:
 	return ret;
 }
 
@@ -205,7 +202,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
 
@@ -215,7 +211,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 	}
@@ -232,7 +227,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		       afe_priv->clk[CLK_CLK26M]);
 	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 ERR_ENABLE_CLK_TOP_MUX_AUD_2:
-EXIT:
 	return ret;
 }
 
-- 
2.53.0



