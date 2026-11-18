Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017221;
	b=KnocXD+Ko4Kdv8yHNx6hxPLDCyiCQesk3hIJkAC13Y7fE0aPxw9sQgxUXhsyPM63rbiW
	 Q3VmM1Sjum81xHhGkX0XTOjGYXlzTx3BTtRqEhBXkWXiJoePooEVFN4W7w7EkytoDmvmS
	 8tzGPcmw2a1KpuQ8f8vqQFBIADG8mVjqfMir36cvGXJ+yOm5+/8UHewMil4GtBOWQaDEA
	 ItA9gcRlulIKLjEgrta21UqnwgvaMVGDqiGcXjbMRRlbpjK+CGkH7PfLJtBPZ4zIV/ck+
	 pZNWAVjMmvBQ/4gprb9U0h7CvtDfmD9+2mxAKi7Df4Ge11BzWOR2RyD5ZVwpksVE3fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2mEAVq4sV200h5wqdNcoJSFtvR9pVaajj5fPC5sWx1U=;
	b=Ds1HQbZWskm5egIOKcUbt1/w7qTRK2m0bGl/uRZdRqL7CYZttVaKz2bf5qY6KEq5zoDz
	 TJzv8fIWFDdVhe7G5wwE1b5f3BYmnN8VbClsNKCefUPiup9GZaOTb+7yh/pY/pTe4JQdB
	 Xq3ipQPM0rMss7F5Nea0UiaQdwfD54QWN4j4yZQZCifusHPmpYcy+Be6I3Bzxhagn0SS9
	 4Payq5LeF+S2jeiGkLLqmp3x25eBYIEN72heXc45CmF7LjJqPDtEWPllHcAOnK4iKFcEJ
	 FYV65AIbpudogsJfnGRYXLYaowQY1lpuxPt3UmEUstu9PPZwgi+VQmjqewE6L3tsRag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cslZPnB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BC1606A31C;
	Wed, 18 Nov 2026 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cslZPnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073ED1F000C4;
	Wed, 18 Nov 2026 15:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017221;
	bh=2mEAVq4sV200h5wqdNcoJSFtvR9pVaajj5fPC5sWx1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cslZPnBrVb+ycUnBiNZ16Z6+f+meknfOVQpcSmZePWGYip+M7fjKbf7gK9l6Ow2V
	 58Tn2kbfYZ4vk0oe3ggl1vBTvwJesxQTyvss9mwU2Frd2SK13uGW0YvAiagHzDxrHE
	 xdjDT8A7PH6hZzv7mxBDXGDHh9nSLRW719eKmRJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0807/2651] ASoC: mediatek: mt8188: mt8188-afe-pcm: Handle runtime resume errors
Date: Wed, 18 Nov 2026 15:34:07 +0100
Message-ID: <20261118150316.944437254@linuxfoundation.org>
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
index 7b1f5d05f4d61..f8cbe7bac36de 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -3030,22 +3030,33 @@ static int mt8188_afe_runtime_resume(struct device *dev)
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



