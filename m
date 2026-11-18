Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015710;
	b=AqgwpPZWyrpYCU1kJONScQRWXwoWK8Shgn8yDO6+jyPYWAlAS9WQsgB8OyUdig6lkKLn
	 wpgrZhfA5tUD1z06X9W1VywbPREFQrZsCs/SDvNbpkavndUE9pl5wD7pRGTM/ME7fN/8v
	 cWeGYcgpIXCJxkdyZjAYxL/RmQFlAxLyEEN5FcBqLmKzxLh45XyeFXQ6Utw2ym/jBnP9h
	 ZSIPa7jxGQr78wZ2JY8Y2N0DzWieXNb+na2kJ7PdRFCFuOp6ULLroLUYchjnBdEPmvlle
	 VYjHFrzDAFSlmmFj+5g3AgzCFfA+dPlHap4SWHcJ1DSFGxpNL/htLfV+fcHNUb7MYOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q5lY78zzlD4P7B5hS/IctXC19WJbu+xbHdmoU5wUkok=;
	b=y3gK+p2GkJVtfoYKA6QIu9eb24aldoat0jsShU596A865s2oBTUqWrjeOb8vBqEZf9kI
	 fKBFpEfL9XZ1wkGjqf9D0xVehNmPD1g5fw3QzY6OzGq1Elr/2lOX/UugVhFk7yx0cUlNd
	 l0DX4JcZbDsJuMTSyky8SskYhoDyIVmkbn+Cr/al7++5SFBWjplrB8Vf2yw4h0ijExNRs
	 Fv46+LOx2O4+iGQZjsC7iXjIP7F4DF574sWsJlIL5TkIEmkdGP5+Ue2g6QITJUbDmyGvG
	 yECxPhucPAOhVdXxfBBevaNQAX+n0+4AP7YD/O1Lsv8m8+4rBr/JhkCyYGlt1RoiSeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tg/dDuK1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1479D606A331;
	Wed, 18 Nov 2026 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tg/dDuK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B19A1F000C5;
	Wed, 18 Nov 2026 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015709;
	bh=Q5lY78zzlD4P7B5hS/IctXC19WJbu+xbHdmoU5wUkok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tg/dDuK1wDfSeyL7+z7p+ucRsnfrmNa73nkHSFNQ5CFQ7ZqFmFdXv8XdGCmdMdr1/
	 12gzC43okVcJXUt+xkPRiwN/JHe3el1pBQDQi/8+5Tx2VZqdeHBBEwr+DBavW0jkWu
	 6iIRUzpDeXX+tgC29xIL4tSB00kSFKL4MIwPIy7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0270/2651] ASoC: mediatek: mt8186: Fix APLL mux setting error handling
Date: Wed, 18 Nov 2026 15:25:10 +0100
Message-ID: <20261118150257.632362053@linuxfoundation.org>
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
index daaca36a2d085..aa8b2eaf7b958 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -98,7 +98,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_1;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_1],
 				     afe_priv->clk[CLK_TOP_APLL1_CK]);
@@ -106,7 +106,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_1],
 				aud_clks[CLK_TOP_APLL1_CK], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_1;
 		}
 
 		/* 180.6336 / 8 = 22.5792MHz */
@@ -114,7 +114,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_ENG1;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
 				     afe_priv->clk[CLK_TOP_APLL1_D8]);
@@ -122,7 +122,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_TOP_APLL1_D8], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_ENG1;
 		}
 	} else {
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1],
@@ -131,7 +131,7 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG1],
 				aud_clks[CLK_CLK26M], ret);
-			return ret;
+			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG1]);
 
@@ -141,12 +141,25 @@ static int apll1_mux_setting(struct mtk_base_afe *afe, bool enable)
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
@@ -159,7 +172,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_2;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_2],
 				     afe_priv->clk[CLK_TOP_APLL2_CK]);
@@ -167,7 +180,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_2],
 				aud_clks[CLK_TOP_APLL2_CK], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_2;
 		}
 
 		/* 196.608 / 8 = 24.576MHz */
@@ -175,7 +188,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 		if (ret) {
 			dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2], ret);
-			return ret;
+			goto ERR_ENABLE_CLK_TOP_MUX_AUD_ENG2;
 		}
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
 				     afe_priv->clk[CLK_TOP_APLL2_D8]);
@@ -183,7 +196,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_TOP_APLL2_D8], ret);
-			return ret;
+			goto ERR_SELECT_CLK_TOP_MUX_AUD_ENG2;
 		}
 	} else {
 		ret = clk_set_parent(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2],
@@ -192,7 +205,7 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
 			dev_err(afe->dev, "%s clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[CLK_TOP_MUX_AUD_ENG2],
 				aud_clks[CLK_CLK26M], ret);
-			return ret;
+			goto EXIT;
 		}
 		clk_disable_unprepare(afe_priv->clk[CLK_TOP_MUX_AUD_ENG2]);
 
@@ -202,12 +215,25 @@ static int apll2_mux_setting(struct mtk_base_afe *afe, bool enable)
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



