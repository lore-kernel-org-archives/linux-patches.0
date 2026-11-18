Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020029;
	b=oWklGXTam8Fvp9gfLuQTLDVCcDgwsik4HhH1c8M0UxrP2wlZwOwgC2M5L1FjwSEXnzyu
	 2se7f0n1ji4vZzs7XIr+dY2aacNU20u2yxlAYFqmexA4l0MztPdUDa0F+rMQiM9doxFV2
	 D1aWwsGBP0Fx9olcIZgTJhgy809sC2i65PN0FndArPK4Kr+wLjCobtBeyDjFf6ftjJTRw
	 hHOxG8gIL8aqZ+t1btBr6Qy6sJ7PKu2AT4mRa3kE+453wsd3nwn3Fcdn/+Kxdq3eb90xa
	 FxDDG0PiayrdSQygLY1zEqMy/rFYXpiq5g5/CGn+4HWKbneP7nZB6T2eIHxyO4xAhAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2Ub0VbfUdKvn5H323Ye3o4OVP0YS9rQMnpQxZ+PrpY=;
	b=2bqVVyL7RLhtBIvTMh0xw0IQsAkRQ4Vo/Zp9ZkxrlDRnyYTCgnshkC8ghOyuk0Ic9xki
	 Zv44hPUfzKwyILQa9tT/N91rP7STEAQUu4fxZE6yKb4tqplcpUma2ihWp53eH8XKkKyuM
	 huYe41xyKgBgu8boCQCHvvkmxkOwxeTJG/ToeYj9S58Gqv6Hv6jOH3rIFmDETrESq3DtT
	 ZXjHs3UyC7aG71WI52G/gheK8QZLI9f+N9h9ZMTGPTtLJkioYk3WlO5HCKwCy3gxu8z0G
	 8HaxVVs1rT2Lwfea+1pGAwflEdI1BnrRpWy/UUCzurMaAzU0iUMhar2ODW3E2WdkaLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsX+MfE1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3FC606A32C;
	Wed, 18 Nov 2026 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsX+MfE1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32EB1F000C6;
	Wed, 18 Nov 2026 16:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020029;
	bh=m2Ub0VbfUdKvn5H323Ye3o4OVP0YS9rQMnpQxZ+PrpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsX+MfE1JffoEbIosyPpBaeF8Kg9y0QeeGdEj14bzd4WW1UkRhjYrq9SDNsxDzNB1
	 p2HMOdY8RI5NJ19rtw6DdPi4AM4nLDX+Q7fszQwHckS4B3Exw4aPI5NIJj/jp2Yv+E
	 ZJb7mbHBojePpZFp1mX1+lL500ZeyZxAOlj79CoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1807/2651] ASoC: codecs: wcd937x: request watchdog IRQs without devm
Date: Wed, 18 Nov 2026 15:50:47 +0100
Message-ID: <20261118150352.308936963@linuxfoundation.org>
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
index 0dd05604f5b88..7ffbb445f8ac4 100644
--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2536,23 +2536,23 @@ static int wcd937x_soc_codec_probe(struct snd_soc_component *component)
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
@@ -2564,23 +2564,33 @@ static int wcd937x_soc_codec_probe(struct snd_soc_component *component)
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



