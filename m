Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060891;
	b=IuFpAbT4Fqjhqw17MQL6JVslpcwnSVrrrVZb7/DgXwJJHaH5BZPMC/PYV7l5WtXSB72c
	 hNSccMzj3d9SIoprd5c9BEswsRcZPxxuCsyesmpf8z/TdCnDQ1BdiT8v5/dXR3v+gczaK
	 v9/zY4Pe9VkjWg1ZsZ2weCOrMZckGuzdRh85Mrs6KDVV5odsp0KHVv3NI9ZLBKmg22B3Z
	 LJDMPr3lupikKD3KWfoqs/G+sgfF0hX1sFsbkpF9C3l4VD6YbaQIYa6Oujeno90kjMUO0
	 erJWahbvCB7vdPGd1nYIlz+T3xPPZWgfOQeAyKNy4PNk2P6FA1mhg9otIp2vz0OoYcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9d2xZdP37DbwInhsWn6qd625Mxb5kzYhai468kmYbQ=;
	b=ZUhgTOTMtvUSQ7b4dtL1vH6xjid3bIv+yI0AYgI5i71NJ+2k3XVpFDbBjoDa8pNNWKAU
	 W7fqzgnszjb5me+7TQzfjdJgHuJfkMNz49tDb4occs/PbU+o2JkiYR8aMBHEFsM0UpVvO
	 /HZCLi/E908B3UFckLzItaH083q/LE97q82jF25o2oguKGygSsU+ZsPRy4uwBYW2gd0fD
	 cHYccqEvY9m8ANFp9S6uouMwfYmLf4VRW8Wq7c6QnCtrkUYhQzyEro8l47TUUnpN6JHC8
	 lbfJp4tpnk9rd5hrE27QredFWKe8QsXko6uW4kE2RYjXVQNxgXzOS8USCBtqzecf/hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzkpDB9Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F12D606A325;
	Thu, 19 Nov 2026 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzkpDB9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13FA1F000C4;
	Thu, 19 Nov 2026 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060891;
	bh=+9d2xZdP37DbwInhsWn6qd625Mxb5kzYhai468kmYbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzkpDB9ZWJDKmPDc7uzCbaLivYP+REgcSENl4aOYm/XGmTyzsmY743LGruk0o0im9
	 k6Ij2hk4oAdJmf5Uw0/TK/hGAmY1xSL6Tdsa1kew/7h8eF0FNp8Mkrq5KizojlGzEU
	 J/IDxalaPg0hz/6Oa0Sx66evtCuLRQkOE3xOUOig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1360/1848] ASoC: mediatek: mt8183: Fix clock handling in mux disable path
Date: Wed, 18 Nov 2026 15:56:38 +0100
Message-ID: <20261118150016.536162224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d7a2617d44bd6..78c06b1a12059 100644
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



