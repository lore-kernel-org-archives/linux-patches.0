Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026654;
	b=NOEsSQm1wu96fBhejcKEzykFcXdQwkzDDId5A3e5mtTelBd2kLFe1us22k/lcX6h9+D0
	 9d0UPo54c5WGFoFIX2WduhxzqNWCfwqSQBHi0A8KB+b1HWSQ7O46ILjhy8yFJToKl1P8D
	 sw4mfECazPaQ+Jm3YuEIZdNMC2Gmg2KN+pLaoF2RYm9dpRkQFb/OdJ0LKj2arLRKZIjfV
	 Peks1sEqmJVDvwyXanGjPMgCsAFucOJvC6IpRkjp7u4m6a6iy0BThY79O0O+SMjugWnid
	 AsitaAhrojaFiZdCVs/p/AvGJurF7Yj//B7pPZ6smMKHDKKOEtBmE2j1nAqdCsyn0Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qO4gWj5Y36HWo9ECx6ZkdFiAauFY+3NuPTHmR+q/9+o=;
	b=JeJCo88rmbyTi3E5ynEH/nGrkyAS3HLu8JL9dlLEZTZLBK6K0nzElP7ymVashWTPOH/g
	 jSy1kL+NqW+BmgEMnSJocFvNQykgz59scV8H8gqM1Zxm2k0VMwiOg80mTNE+/hgK+mj3/
	 bIsvJcPwVXgak52L+xfsCgSf42LavXdZ2jPVtuafNkCxsj2iFL9Mi4NLiCgBQ0gA2tbl5
	 fpISCzqQDX0HnXktbNlbc6WnhX4A2srVdE0QLQgmjOrJA4/b9G1+gTxprVvt/JnoPjY7C
	 6NG02Tqu6Otan5g8GTJVR9KkPoxtIWm0CVNlo3ml5bPTLHFGsJLSulFfK0vWaa7iRoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmQ8+MMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263B6606A320;
	Wed, 18 Nov 2026 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmQ8+MMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331AD1F000C4;
	Wed, 18 Nov 2026 18:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026653;
	bh=qO4gWj5Y36HWo9ECx6ZkdFiAauFY+3NuPTHmR+q/9+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmQ8+MMy9wHHMpADjVauina+nXxf2aTjIE26/N/L1BjDhewk3MsKLgSxjedCXiPPB
	 QQIy2NSEMarn/IvKvAWHtDDjISoCfrKS0VA2/O3kWhUtFl2/ByrM5U+JA6s50QGdM4
	 GJ5UA/BHtpyQeIdXR++Y6IhhACjklFjv8p2x0C2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1469/2151] ASoC: codecs: wcd937x: request watchdog IRQs without devm
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150215.408952719@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit b3f17433a1eb9f89b79f8459d7661207abce0b9c ]

The watchdog IRQs are requested from the codec component probe and released
from its remove callback. Use the same non-devm lifetime for both
operations.

Use request_threaded_irq() and keep free_irq() in the component remove
callback. Return errors from each request and unwind only IRQs that were
successfully requested, including failures later in component probe.

Fixes: 9be3ec196da4 ("ASoC: codecs: wcd937x: add wcd937x codec driver")
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20261004102346.1203410-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd937x.c | 44 +++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/wcd937x.c b/sound/soc/codecs/wcd937x.c
index ed0ff45a89649..17c738693af80 100644
--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2524,23 +2524,23 @@ static int wcd937x_soc_codec_probe(struct snd_soc_component *component)
 						      WCD937X_IRQ_AUX_PDM_WD_INT);
 
 	/* Request for watchdog interrupt */
-	ret = devm_request_threaded_irq(dev, wcd937x->hphr_pdm_wd_int, NULL, wcd937x_wd_handle_irq,
-					IRQF_ONESHOT | IRQF_TRIGGER_RISING,
-					"HPHR PDM WDOG INT", wcd937x);
+	ret = request_threaded_irq(wcd937x->hphr_pdm_wd_int, NULL, wcd937x_wd_handle_irq,
+				   IRQF_ONESHOT | IRQF_TRIGGER_RISING,
+				   "HPHR PDM WDOG INT", wcd937x);
 	if (ret)
-		dev_err(dev, "Failed to request HPHR watchdog interrupt (%d)\n", ret);
+		goto err_free_clsh;
 
-	ret = devm_request_threaded_irq(dev, wcd937x->hphl_pdm_wd_int, NULL, wcd937x_wd_handle_irq,
-					IRQF_ONESHOT | IRQF_TRIGGER_RISING,
-					"HPHL PDM WDOG INT", wcd937x);
+	ret = request_threaded_irq(wcd937x->hphl_pdm_wd_int, NULL, wcd937x_wd_handle_irq,
+				   IRQF_ONESHOT | IRQF_TRIGGER_RISING,
+				   "HPHL PDM WDOG INT", wcd937x);
 	if (ret)
-		dev_err(dev, "Failed to request HPHL watchdog interrupt (%d)\n", ret);
+		goto err_free_hphr_irq;
 
-	ret = devm_request_threaded_irq(dev, wcd937x->aux_pdm_wd_int, NULL, wcd937x_wd_handle_irq,
-					IRQF_ONESHOT | IRQF_TRIGGER_RISING,
-					"AUX PDM WDOG INT", wcd937x);
+	ret = request_threaded_irq(wcd937x->aux_pdm_wd_int, NULL, wcd937x_wd_handle_irq,
+				   IRQF_ONESHOT | IRQF_TRIGGER_RISING,
+				   "AUX PDM WDOG INT", wcd937x);
 	if (ret)
-		dev_err(dev, "Failed to request Aux watchdog interrupt (%d)\n", ret);
+		goto err_free_hphl_irq;
 
 	/* Disable watchdog interrupt for HPH and AUX */
 	disable_irq_nosync(wcd937x->hphr_pdm_wd_int);
@@ -2552,23 +2552,33 @@ static int wcd937x_soc_codec_probe(struct snd_soc_component *component)
 						ARRAY_SIZE(wcd9375_dapm_widgets));
 		if (ret < 0) {
 			dev_err(component->dev, "Failed to add snd_ctls\n");
-			wcd_clsh_ctrl_free(wcd937x->clsh_info);
-			return ret;
+			goto err_free_irqs;
 		}
 
 		ret = snd_soc_dapm_add_routes(dapm, wcd9375_audio_map,
 					      ARRAY_SIZE(wcd9375_audio_map));
 		if (ret < 0) {
 			dev_err(component->dev, "Failed to add routes\n");
-			wcd_clsh_ctrl_free(wcd937x->clsh_info);
-			return ret;
+			goto err_free_irqs;
 		}
 	}
 
 	ret = wcd937x_mbhc_init(component);
-	if (ret)
+	if (ret) {
 		dev_err(component->dev, "mbhc initialization failed\n");
+		goto err_free_irqs;
+	}
+
+	return ret;
 
+err_free_irqs:
+	free_irq(wcd937x->aux_pdm_wd_int, wcd937x);
+err_free_hphl_irq:
+	free_irq(wcd937x->hphl_pdm_wd_int, wcd937x);
+err_free_hphr_irq:
+	free_irq(wcd937x->hphr_pdm_wd_int, wcd937x);
+err_free_clsh:
+	wcd_clsh_ctrl_free(wcd937x->clsh_info);
 	return ret;
 }
 
-- 
2.53.0



