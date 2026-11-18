Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055476;
	b=fs8eJsxeO18zAHs8gvYttO1G0ui/Y5D5hDJ1n56xKOu//+CLOS9bEo0MquW4DjWE3YeR
	 fiCDa+xpRKda7+PCQWeSpfKgHQvWlpXU2vJCuwlbyF5X/YGiiJYzoajc39GEZg1a9T9hP
	 dBJ7kwS/tdBcd7vGR6Rrq+r8j56n9IQxWyqiK0SQIP0E+ZtC5QDSaPdWEts1wDu4/2Bat
	 RQsyvJvIf2bgyzGKKRC010zZQUA87qblllozsel01KWgy+vNkQ9BIS8EPr26Pykizs4wV
	 aQsUp3/JNTqgqn1bgKR2VGLV7X/O9Tgv1oS3sR6Sbz2gD/7FdM6VrvsvYcdxTJ5U0Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5xd1xRMyvYDBWVeenY46yX7H5Ki4dQy/RTYr1vZxMc=;
	b=3etwtkq4qRD1/gM5AK4PfXbQ+hfVf4lDpIy5T2iXekOxtOu32ceULNsQaThwTxxB0p/M
	 CWBU2FZouCCGysKylFb+djeiIJdILsvgw76eb5NUFYq65aW8jOibtKEabPQ8onicva7XY
	 aw1yKekGLxqwVWQcQMssTvG/PCS4LQ6TMVh4Nl6Gs3/vw8ra+tMefOAoKbsqWF6exa05o
	 aXtKT0IhWDopHx3h3oa+Jx5h1PXOPOnR49qn3eeNqMv4n/9maWWWt7z40cY3o7z+byJ1d
	 AoeGI4QyW3TwwCI+kPAVsTYy5Wi20U9QBwIHmkwDBZ9qZDgr53qeggOEDIUdkI+c98A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTwViuM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E3606A31C;
	Thu, 19 Nov 2026 02:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTwViuM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8651F000C4;
	Thu, 19 Nov 2026 02:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055476;
	bh=u5xd1xRMyvYDBWVeenY46yX7H5Ki4dQy/RTYr1vZxMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTwViuM0+EGG0r/iLAh7+/H7hDc1cuW54mA+5tGzcfH65LdUkpArwAeRGeN868Hq7
	 Ma8IToPPvvmCa1UkrNdvwwgqdcPV0fogIqi3UAO5XeCcANHYFjT11zE0gogYAcQlY1
	 ZP+/NL1sprTWs42axzU2OQK0fnuHZ9NQlsV+60vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1646/2214] ASoC: mediatek: mt8192: fix error handling in APLL enable functions
Date: Wed, 18 Nov 2026 15:55:22 +0100
Message-ID: <20261118150117.756384751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 06200b57558b9..fdd7378f8e6cd 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -312,20 +312,22 @@ int mt8192_apll1_enable(struct mtk_base_afe *afe)
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
@@ -336,7 +338,13 @@ int mt8192_apll1_enable(struct mtk_base_afe *afe)
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
 
@@ -362,20 +370,22 @@ int mt8192_apll2_enable(struct mtk_base_afe *afe)
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
@@ -386,7 +396,13 @@ int mt8192_apll2_enable(struct mtk_base_afe *afe)
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



