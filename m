Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024400;
	b=ppmt6Hxs3/N6GuBN7cPc+d23xrtjVCRB1uyw/imxsrcJ0BEQq0vI5SMpypnqaq8p9hrl
	 Ih6ChpRrypRMKdmbRIvt480e+CIynO6L5HP8q57f7iAjOVFcmPk6CBtN3GMWRSHAcFiz3
	 /TSCHYdBVDPdx16dhZxbdPkrqQBNGauXk3gpEuDK/sdWc3qwii0/8VkWw0EOx/gaqXF5k
	 Zt7Y8g2+2Vv6DYIFwjl32Yn2YIYeYWZr0iu9wRFN9XTvNNwuqmpMVuy3lokZ6fMPTK3a5
	 uTpfK2qeuwc46JTpsoW8a21jFCd8Um7Xtau4nKupS521X28GeKinrQiKrYDRXsvg3Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2bhypw0OCXjNgxVok32WYtJBXfqO/ssMeXcp7+ngF8=;
	b=iTV6z+l4YuP3iHvhmzSu1FLLlVMJHyoPCnrZJQDUnEKh+jRxLns7REGM5+NsMSttjA57
	 r0WdY8iybBXn7H0nQ+XzNlzdXMrUU/B9vo1nJoFEXMXiw7P/52IoXPketkiEjj+t4PSUR
	 +iYSub/KYWYU5/oM7rB80JG6qFzhMdBtQAcZCPspuPHTWB2Y9Wjc02QIN6ILopkuFJRTa
	 71vUPWomFMCoBZDC8t5mPnXd4FM9LsqkF4y/hMxJNu8bJnviyJR2bcL86QWWTI69rxOfS
	 EGzcpCCCFl6A6qULyWn2mmeAiBLdoSIr7X8t0K1McmRX2XVj2sj4uYk9HKXUg4CIjEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5P43LUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E68606A320;
	Wed, 18 Nov 2026 17:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5P43LUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDE31F000C5;
	Wed, 18 Nov 2026 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024400;
	bh=s2bhypw0OCXjNgxVok32WYtJBXfqO/ssMeXcp7+ngF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5P43LUVEiRKJe9Jpf0LFmTVeLV+UDa2eJdoBn5Y9UHQ82RBM95++/0il5tiy5hUr
	 qW5wOMwSQX1nv+ZSgAaDCn34dN09ugKnHswlejgBMV8k2a2HTbaqdqeyLdyMtbaeFo
	 6ISBGR9nPqOQpw8MUqjWCvvuGIq54M/S8SNzqjvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0712/2151] ASoC: mediatek: mt8188: mt8188-afe-pcm: Handle runtime resume errors
Date: Wed, 18 Nov 2026 15:40:47 +0100
Message-ID: <20261118150147.816316246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac4fdf8ba78fd..4a7baa53f709a 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -3032,22 +3032,33 @@ static int mt8188_afe_runtime_resume(struct device *dev)
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



