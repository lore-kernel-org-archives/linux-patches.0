Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040199;
	b=T8qhHntlBJlvQMITrnZuZFs3KQw0wVGzOmTs3Y+a5YylH+9Bp3WxcUKApqhqbrz1reni
	 rJGRNcWdlv0q+25jtR480ziOd3f/AHPQ/YMXqrpN7q/KqThat06pnbkF2LhptpWAIe6FZ
	 yFu+9YAnfXbixPd2iBmKmLCSi7Ils+m3qoNPsxYbw/u5HfrTXAJrcny6BYhBe3qU3Vc7R
	 Eho+rFI4DxlYybFunir9uosQghHk30EsE28gl5Z9T8OEduOVJBawjQY7oz/tdPbuq66b6
	 unnUzCzBK0sp1Q3DMywCeNO1JDPiS+o0mhaobh4qE9/+SCKxTDt68XNPGx0dQoz0mEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5MyAz7rY27EGbgxu5gOZOGVzStfwYmwcCZVwbT7xMAs=;
	b=kCGFtLtS6GkTZFnA5O+hQwoQ/bZQjGP/catjuf8yu8Q4/eV5C0y0+7tMm3Ed5+wzZiyr
	 f3+/kaOI5k7SwXyM9E4Ne31iEll4OlKJ8/mJbovE5tzvR6PBglP1fLquT2Jtchrhlye77
	 ld6hCwHfYHr4Lv1gvgxCfQmiPJQEeuNynJVVhCoAqGr3SFmhdAoyT4x4K79EnTir6AHWx
	 zy3FqFhVQiDLGfzabshlQS4J50gObKC4UUy7HqfpmFmSC0BrcShIr/FMlEr8ECHUiQPk6
	 dG1cudd6mqkJojCyR8msTUHOR3Y7v/Ml71pUXCwvKqXdqomoRA30eBggsw6klP4kwdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4hv+3Ge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7E3606A325;
	Wed, 18 Nov 2026 22:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4hv+3Ge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BD21F000C4;
	Wed, 18 Nov 2026 22:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040199;
	bh=5MyAz7rY27EGbgxu5gOZOGVzStfwYmwcCZVwbT7xMAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4hv+3GewFWXbWG25JNqfSfPF1yo+SfcGsMRC/cdoMKy6mw4WkR9lw/C+ciYO8U4m
	 kxy5lpK2Iw3Ot8pr0EqPYEvlRXrDJgYl00ecShZgLnQqtxWEnzRhS41IpX0yBjqje3
	 4/LsexFog9BHXbukjZHmYUNGLEd+UuZ6vrcV6hes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2373/3318] ASoC: mediatek: mt8183: Fix clock handling in mux disable path
Date: Wed, 18 Nov 2026 15:49:55 +0100
Message-ID: <20261118150432.745269303@linuxfoundation.org>
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

[ Upstream commit 4a0f9566ae0c3ad32620254342b266f37f4757de ]

In the disable path of the appl*_mux_setting() functions,
clk_disable_unprepare() is called after clk_set_parent().
If clk_set_parent() fails, clk_disable_unprepare() is skipped,
potentially leaving one of the clocks enabled.

Remove the goto exit paths so that all teardown steps are attempted
and any errors are only reported.

Fixes: a94aec035a12 ("ASoC: mediatek: mt8183: add platform driver")
Suggested-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260903045203.175337-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-clk.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
index 6ab0734ad1365..dd1a5925af96d 100644
--- a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
@@ -271,7 +271,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
 
@@ -281,7 +280,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 	}
@@ -298,7 +296,6 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		       afe_priv->clk[CLK_CLK26M]);
 	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_1]);
 ERR_ENABLE_CLK_TOP_MUX_AUD_1:
-EXIT:
 	return ret;
 }
 
@@ -345,7 +342,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
 
@@ -355,7 +351,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_CLK26M], ret);
-			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 	}
@@ -372,7 +367,6 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		       afe_priv->clk[CLK_CLK26M]);
 	clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_2]);
 ERR_ENABLE_CLK_TOP_MUX_AUD_2:
-EXIT:
 	return ret;
 }
 
-- 
2.53.0



