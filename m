Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040216;
	b=0aSK3B8x7GV2pKxPujbZZs8YYvYYLjCiDoyfNegg35hozMIB9aMoN3DjqSvmNVWUNIlV
	 ahq80I90Oz3v6t+/ykVm5rrR3w6hDKB+MUyukgGu0VtKy8F7z3cVDgUFNwQXUOcpeL+o+
	 TK1kSLtzK+M+v0MTZFLc7F3w6sf+yBStbfPHaFty+IYtyEQkFPW1ZYXJJr8f3oQCuk816
	 rZo1o38gCHx77xmvM4IuFNhMyh+f3IcB/usrOkxFpoPkzBv/9F7GjGNmM1RZglsXuY4l0
	 LFCV2Su0lerXY2E+6n/ITwDrcONr3/5Qn5X6HUEuF04ijsBGkilNMcF8DXnxRAOcwtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQVPgdrAhxgX9VtTokSCVBYcwfg/V8VJU3CkmLgfPz8=;
	b=LPBR5hbHq7bP3ieFGsWDgSS+koBIgJ5ot1Q57Nw0ZxIZJsOEARnT7BIHQ5e/RTgQCHPY
	 J4e4LXr87Cbc91NkWWAG8OHAZxc5s+A7LJVnpi2BnQ15WWfILofBJNZAIY0cyOIahd3XS
	 IvJPXHgcjXJRFlRGgekaoWN/55wFtSkGc45VnWvdW8CY0TzKguGYhoC+a/dFE3YX5l1rV
	 tI3zQ+ThK7f5kJ/4Z6GaWzDDgvgyYRFOV/Ni+J+86nzZ5jEP/iaVdO7TNgWlBpGGvZ3bx
	 jqkwj+P16qTDc4qVBKS+nLMbSclcbDw8fT3cyDyNnmPfxkVE8RFrJDAFGzfIHZ/RC5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xka2MxZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8D3606A320;
	Wed, 18 Nov 2026 22:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xka2MxZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A771F000C4;
	Wed, 18 Nov 2026 22:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040215;
	bh=mQVPgdrAhxgX9VtTokSCVBYcwfg/V8VJU3CkmLgfPz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xka2MxZPiETHW3r1lGjL77i7/D5TfruhoQjADe/sIczs4gq4F816b5Q8k3BYm225i
	 E9x/3disHK2UmIQe/i/KMnABcD2SX+aFfVc/695VMLt0+y6cu+yvnnxj/9sVdtrDr+
	 DLjQjkFlNR4aypFY5QkKY8NLG8gAxiz5LOpnyTrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2361/3318] ASoC: mediatek: mt8188: mt8188-afe-pcm: Handle runtime resume errors
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118150432.416727149@linuxfoundation.org>
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

[ Upstream commit f5f6941d92972ba66829a99999fa825e63da5162 ]

Errors from clock enable and regcache synchronization are currently
ignored during runtime resume.
Check the return values from mt8188_afe_enable_reg_rw_clk(),
regcache_sync(), and mt8188_afe_enable_main_clock(), and abort the
runtime resume if any of them fails.
On failure, disable the previously enabled reg_rw clocks and restore
the regmap to cache-only mode.

Fixes: bf106bf09376 ("ASoC: mediatek: mt8188: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index b2e2eb959aa5f..ae2b21ac604e1 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -3009,22 +3009,33 @@ static int mt8188_afe_runtime_resume(struct device *dev)
 	struct mtk_base_afe *afe = dev_get_drvdata(dev);
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
 	struct arm_smccc_res res;
+	int ret;
 
 	arm_smccc_smc(MTK_SIP_AUDIO_CONTROL,
 		      MTK_AUDIO_SMC_OP_DOMAIN_SIDEBANDS,
 		      0, 0, 0, 0, 0, 0, &res);
 
-	mt8188_afe_enable_reg_rw_clk(afe);
+	ret = mt8188_afe_enable_reg_rw_clk(afe);
+	if (ret)
+		return ret;
 
 	if (!afe->regmap || afe_priv->pm_runtime_bypass_reg_ctl)
-		goto skip_regmap;
+		return 0;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret)
+		goto err;
+
+	ret = mt8188_afe_enable_main_clock(afe);
+	if (ret)
+		goto err;
 
-	mt8188_afe_enable_main_clock(afe);
-skip_regmap:
 	return 0;
+err:
+	mt8188_afe_disable_reg_rw_clk(afe);
+	regcache_cache_only(afe->regmap, true);
+	return ret;
 }
 
 static int init_memif_priv_data(struct mtk_base_afe *afe)
-- 
2.53.0



