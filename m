Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020093;
	b=kPmxOlTvbzrBrUfLzdiAjmd3giKCMFExZxeP2H1pw6Y+LdG1EHuttHYp/KG/OExD2TR3
	 LdI6jFgtvOxFjObgmayarZZM91BhpVkyJzp3TX/3/Q8FE8O2EwUe32JCQ6ah4RgodrFzV
	 Mb+urdsIcBGso42uUdF/ORyc1+3C9OGr2TRRlxgUmbOX2y0qGV8juy9p/Vx2XlNa9iJQg
	 S4kFpWcmSWQvU0zh1tn1vETlgHWHtKaqiMeB8echHUlFHGiIjOycKY6G6JOL7LGEeY7Wg
	 mrofcaBfab1HQhliAxoOwfZC08jOBsz8x32xBZBvK0zxQpzFm2dAXof00mwFFVAPing==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9Mr7KF9nIlHzv56Jv9yoS35oRGkn2rDw1dPZKi/qC0=;
	b=4st+syFDb0VEMftkt52q/oIseINMZ6jAZkvEYbmjT2Epz44QvR2gxTuIc5aYvtWCLRMn
	 gklzku9m2Olcv03/UEZDemxYdHLOm/e2m9n/dacRg19dVCGM260HMp2JKp803bdC640na
	 Llh7nNIuVtXm5bidTeQivy8/h6Vi2QvphYjuKaDDf2P3yzf7d8RUUAXoJb0r6qJBmDPb5
	 w0eBhq30ei97CWNTnkWmJT6/aUFMBBvNBG1GP7UB+YKYKuMKCZNProN9WtI4LNZ0lU+ob
	 SHcPLxpy/JlRyIGGjnc9Tn2v6pePUyWNfsDG6hVRWkZ2D/uzMew0zRNJAEQeHJEV14w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14uKYdIR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88FC606A33F;
	Wed, 18 Nov 2026 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14uKYdIR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0481F000C6;
	Wed, 18 Nov 2026 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020093;
	bh=D9Mr7KF9nIlHzv56Jv9yoS35oRGkn2rDw1dPZKi/qC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14uKYdIRGfV549xU3mwMH/QDHC8OX45ow6aDnTu/F1OpTgpV5a1ydnMpD1D5B+Rq5
	 9XHfs2tfuOqXtuS/RRjMYsc7m0dJpErxvFKX+1+AokfDU4Z6b8gab6ovvzIaVh+1vV
	 JWxvx5It9iahG42X75PZoyqBgjY0WONm6v56EGrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1792/2651] ASoC: mediatek: mt8196: fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:50:32 +0100
Message-ID: <20261118150351.838507782@linuxfoundation.org>
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

[ Upstream commit 23239cabb6d130c81d2c5389ed2dbdcfc239a939 ]

Propagate errors from the APLL mux and clock enable operations instead of
ignoring them or returning success on failure.

Clean up previously enabled clocks and disable the APLL tuner when a
later clock operation fails, restoring the APLL mux state before
returning the error.

Fixes: 7384ecab34eb ("ASoC: mediatek: mt8196: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-afe-clk.c | 47 ++++++++++++++++------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
index 91ae440249492..1dc4210e58c71 100644
--- a/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
+++ b/sound/soc/mediatek/mt8196/mt8196-afe-clk.c
@@ -314,15 +314,17 @@ int mt8196_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = mt8196_afe_enable_top_cg(afe, MT8196_CG_APLL1_CK);
 	if (ret)
-		goto err_clk_apll1;
+		goto err_disable_mux;
 
 	ret = mt8196_afe_enable_top_cg(afe, MT8196_PDN_APLL_TUNER1);
 	if (ret)
-		goto err_clk_apll1_tuner;
+		goto err_disable_apll1_ck;
 
 	/* sel 44.1kHz:1, apll_div:7, upper bound:3 */
 	regmap_update_bits(afe->regmap, AFE_APLL1_TUNER_CFG,
@@ -336,14 +338,22 @@ int mt8196_apll1_enable(struct mtk_base_afe *afe)
 			   0x1 << FREQ_TUNER_EN_SFT);
 
 	/* audio apll1 on */
-	mt8196_afe_enable_top_cg(afe, MT8196_AUDIO_APLL1_EN_ON);
+	ret = mt8196_afe_enable_top_cg(afe, MT8196_AUDIO_APLL1_EN_ON);
+	if (ret)
+		goto err_disable_tuner;
 
 	return 0;
 
-err_clk_apll1_tuner:
+err_disable_tuner:
+	regmap_update_bits(afe->regmap, AFE_APLL1_TUNER_CFG,
+			   FREQ_TUNER_EN_MASK_SFT,
+			   0x0);
 	mt8196_afe_disable_top_cg(afe, MT8196_PDN_APLL_TUNER1);
-err_clk_apll1:
+err_disable_apll1_ck:
 	mt8196_afe_disable_top_cg(afe, MT8196_CG_APLL1_CK);
+err_disable_mux:
+	apll1_mux_setting(afe, false);
+
 	return ret;
 }
 
@@ -367,15 +377,17 @@ int mt8196_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = mt8196_afe_enable_top_cg(afe, MT8196_CG_APLL2_CK);
 	if (ret)
-		goto err_clk_apll2;
+		goto err_disable_mux;
 
 	ret = mt8196_afe_enable_top_cg(afe, MT8196_PDN_APLL_TUNER2);
 	if (ret)
-		goto err_clk_apll2_tuner;
+		goto err_disable_apll2_ck;
 
 	/* sel 48kHz: 2, apll_div: 7, upper bound: 3*/
 	regmap_update_bits(afe->regmap, AFE_APLL2_TUNER_CFG,
@@ -389,14 +401,23 @@ int mt8196_apll2_enable(struct mtk_base_afe *afe)
 			   0x1 << FREQ_TUNER_EN_SFT);
 
 	/* audio apll2 on */
-	mt8196_afe_enable_top_cg(afe, MT8196_AUDIO_APLL2_EN_ON);
+	ret = mt8196_afe_enable_top_cg(afe, MT8196_AUDIO_APLL2_EN_ON);
+	if (ret)
+		goto err_disable_tuner2;
+
 	return 0;
 
-err_clk_apll2_tuner:
+err_disable_tuner2:
+	regmap_update_bits(afe->regmap, AFE_APLL2_TUNER_CFG,
+			   FREQ_TUNER_EN_MASK_SFT,
+			   0x0);
 	mt8196_afe_disable_top_cg(afe, MT8196_PDN_APLL_TUNER2);
-err_clk_apll2:
+err_disable_apll2_ck:
 	mt8196_afe_disable_top_cg(afe, MT8196_CG_APLL2_CK);
-	return 0;
+err_disable_mux:
+	apll2_mux_setting(afe, false);
+
+	return ret;
 }
 
 void mt8196_apll2_disable(struct mtk_base_afe *afe)
-- 
2.53.0



