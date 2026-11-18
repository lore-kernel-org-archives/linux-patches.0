Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020116;
	b=Mkl2g6+h57o8uJbdyxmsVKlIheAlvG5W5kWToWshjDTGV1noxuEXpnhN8Kn+zEoX3K5k
	 RZuRdPioAC5hjtDRXpPSQZ1Pl2JdMlSCFSDWVFKeaIzLO5JmQvMFafvA3RsCiVVsOv/XK
	 P8CkASnIH1W4EZqi4oTwDsT1t/M1IeZRZpIy/fNsrPKRvL9n7sPL+VMysv1TmkhiM0XUh
	 WTjYbuZvYk2SLYOZW7Ynpa/LTdcR0eKYNuyUHkNfskF/fkQKdwffsGpsW8PcdWF7dwWvw
	 FFCvi2ns8CUw6DwGIqGGsDMwb4dZFhONjY5v9vtkI4RymrAmhiCj2wVWmDiSC28uIlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gOjWm/jiLni4OwnIe7lVbPrRWUmZtjxAVtjnyr9puKE=;
	b=Cp/d+yT9/dM/p4Ktf6eJKEwN/Qso22O2bG0VjipVK3D+LnI+3ch0PfR/I5rKuiWhx4DE
	 olZszeTlEZRwo/nSE6mhN50vwHXVNmL/0KtR/CP2ymbovz6/qDoYu5iPxFuxoMEWtjeB7
	 kumDsUfyAjKmhyuvlKJmhmpaT6WCiZ/AGNZb0rnEZanbX4uynRtbe2Kwatm81IZCVzC0g
	 6Ry0/U3z9E4W3icC8NxwqKiA+7pozkmZ0gA0XMpSS2Ls4d9dwzj1N2sjANc2nKcMRZy8y
	 vIWnCMQoxWSm2Cj2HJS+PmMVIyxd92jo3t/XSOjbocxRoAAXlfyFpr5ouV7tts44Xrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZZuJwvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4FB606A33D;
	Wed, 18 Nov 2026 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZZuJwvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A931F000C5;
	Wed, 18 Nov 2026 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020115;
	bh=gOjWm/jiLni4OwnIe7lVbPrRWUmZtjxAVtjnyr9puKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZZuJwvSQ+dThcYNcTxBAYNJq/gjZu4L1stArIXxldaM3nHY9KTkxsqadUImd73Jh
	 joSdzvaBp0oq5tFxrkZ4OiyMyGJGtXzK7UoW+WqpH7GhdTY4MI+g2bk9cviLeX1673
	 lI5h3swXz5+meRppedal/vxhZuVIuJgRQQl/6Mcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1796/2651] ASoC: mediatek: mt8196: fix runtime resume error handling
Date: Wed, 18 Nov 2026 15:50:36 +0100
Message-ID: <20261118150351.973398037@linuxfoundation.org>
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

[ Upstream commit 3a9a93cafb376541fecac10c5bb734cd2f26bfc8 ]

Propagate errors from regcache_sync() and main clock enable operations
instead of ignoring them.

On failure, restore cache-only mode, disable register access clocks, and
clear the 26M clock request as needed to clean up the runtime resume
state.

Fixes: 7384ecab34eb ("ASoC: mediatek: mt8196: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260929061121.124001-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8196/mt8196-afe-pcm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8196/mt8196-afe-pcm.c b/sound/soc/mediatek/mt8196/mt8196-afe-pcm.c
index a1ae8322d8b6c..f8e9059170a52 100644
--- a/sound/soc/mediatek/mt8196/mt8196-afe-pcm.c
+++ b/sound/soc/mediatek/mt8196/mt8196-afe-pcm.c
@@ -2211,7 +2211,7 @@ static int mt8196_afe_runtime_suspend(struct device *dev)
 static int mt8196_afe_runtime_resume(struct device *dev)
 {
 	struct mtk_base_afe *afe = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	ret = mt8196_afe_enable_reg_rw_clk(afe);
 	if (ret)
@@ -2222,7 +2222,9 @@ static int mt8196_afe_runtime_resume(struct device *dev)
 		goto skip_regmap;
 	}
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret)
+		goto err_set_cache_only;
 
 	/* set audio 26M request */
 	regmap_update_bits(afe->regmap, AFE_SPM_CONTROL_REQ, 0x1, 0x1);
@@ -2233,10 +2235,20 @@ static int mt8196_afe_runtime_resume(struct device *dev)
 			   CPU_HD_ALIGN_MASK_SFT, 0 << CPU_HD_ALIGN_SFT);
 
 	/* enable AFE */
-	mt8196_afe_enable_main_clock(afe);
+	ret = mt8196_afe_enable_main_clock(afe);
+	if (ret)
+		goto err_reset_26m_req;
 
 skip_regmap:
 	return 0;
+
+err_reset_26m_req:
+	regmap_update_bits(afe->regmap, AFE_SPM_CONTROL_REQ, 0x1, 0x0);
+err_set_cache_only:
+	regcache_cache_only(afe->regmap, true);
+	mt8196_afe_disable_reg_rw_clk(afe);
+
+	return ret;
 }
 
 static int mt8196_afe_component_probe(struct snd_soc_component *component)
-- 
2.53.0



