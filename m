Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030087;
	b=bwidJv+K0vzp0dOUE5ltif2tkux/Hi55+up/OjO6qJ0Mph0vom/UATToYxzguPgWEVj/
	 vzgyNTCUPELhXV1v0GLKhS1XMI3s2drJZFmKtKJncKF9e2l2T68Lue5ZI8LChPyIyVPJT
	 xGZUFahnZm48nMXBz23Z5aOVbIKa7Y32VJrM2N1gGgq8UzEBf60IjyhfPBBeJgEmH6w7r
	 3Rtdh4CrMpFET+hKK/1reJXyZScKXhs8/A9fQwPobq6M9+Y7lq9j5c0IJXn9y3KmQldZs
	 cmhR4MrHURJC9pt6S9bOkcZjy9E/PcnhTvoaeATvdpkr7sNAv8q0l1SljsXDYaRANvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R6X7WzfLYWSt1i+mYV06ymPtwHEujmIE82g8q5vHsfs=;
	b=iv/MYUwn4oDWSR/hX1gNtq2rr912oHuZjGzRn43hvn5M4mjLM6DC8AgC5xefVX8x0CRM
	 oOqetMF1QU9swWkyBp/vBG5uy9LQBsAWGsT7q+HHhDZKrGaVayH6e/bjHtiyg1zLCugjK
	 6TcdX6HETJm07Us7EE7t1pyKj9xK8byiooz7miLf7TP2R/a7G5Z8bazCwR8LcxSiiv1gm
	 /kxDMDYycf0Waibu1XxDNk3vmGSYBm1jOgpTXFf3Tyjwxrk2hUK7d1TuqQvZljxFur2gw
	 wFaCD0mH4Zt8AM/oTy9Jzq57dCPLUA+yTk3GNwLv4t5TB2nGD4BMJHXbY1TE5lWiwlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WrtNruTV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA8060A263F;
	Wed, 18 Nov 2026 19:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WrtNruTV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD271F000C9;
	Wed, 18 Nov 2026 19:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030087;
	bh=R6X7WzfLYWSt1i+mYV06ymPtwHEujmIE82g8q5vHsfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrtNruTVZOUREnRYPGfeiLikToRLJ3XfdZ1QS0hPgyeqijoeiWPU8h8QlUF5QbQLi
	 8jcSgXMIAZGQUR2/4vAs9ZLe/R/M7qJ3f0+Z5jGdSqA1Mpzs60323ed31ue6JzEx8z
	 yNsw3LZe98YYDvkqmidDWxY8VR0EWoBncTVAjlZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0580/1756] ASoC: mediatek: mt8188: mt8188-afe-pcm: Handle runtime resume errors
Date: Wed, 18 Nov 2026 15:45:07 +0100
Message-ID: <20261118150032.131113622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d36520c6272dd..884a4656c6f11 100644
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



