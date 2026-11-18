Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031747;
	b=jl1/RnYHNhu9/HpTFgZG230uUl7pBscj5VBUlhQXUYscA8pmLeTejTY54JiBQOv7JpoN
	 8Q2z5ahERVJhlJEyosp1rvFWocm5ossGNODMn+f41vD8wmMXCIlxSugdl3yWJ1g0xrIpB
	 MwCDc7TiMvv/A7iYAQoHakQQLE3cKmUA5LT8l1/yQBAGQhEx4Q6g8KtUXHp7mxs0SpDNo
	 Yb4hpfslIMmcdjUkK9mIpvMC9ooJx4PfjTmn2wVwlvw2XquJI/0x1hTH1ce6i1GmZKnoW
	 IYuA16ReM0Dxn4j9+hj1M98oEkamQDQXAqiFJDqdXCrY3RcsfEMKpHCTN+qxfy69M+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7iibyYiGl1Lz5o0E9dSd8n7xB3kRqEOVoiTmhmHHFno=;
	b=Iq50OagIJvJhLfvbg09UHQhSDtEfJNq3oU9JvnBMw9hbBKrLoihQ3YZq4b267+yROOWZ
	 knxv2r/BaPFNqF39rg8CapF5V/JW5DIr8SgIgELsyHhmdQ3xA6mEFfATOeWf5vPcZhCIo
	 OIrqsj0cWzRwGhN2wKrPShpP5RQtTlVm+RkEs0vMeK5XlT43yhXrgd/VyUoKDzCLx0Ftw
	 FBmVs7sLHHLbeEmjHBiVqvV9PwUp0/O9cB4xMf6721i0/iy5ibcTX58qGp40OzObAKyUk
	 tjwROUFzkzZUDsJPuXd1Oi5OfX5sMJaUOGlE7ClF2jXT8K8MBWhqMFYCFL0PsdK/G2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6ds58xF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA5A606A320;
	Wed, 18 Nov 2026 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6ds58xF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9405E1F000C4;
	Wed, 18 Nov 2026 19:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031747;
	bh=7iibyYiGl1Lz5o0E9dSd8n7xB3kRqEOVoiTmhmHHFno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6ds58xFuXWpF/p07Yz5umrFRX+5skpwxjwJY3CwElo9bWXVFfv+6F+zL2nAsMsLn
	 6RVTPKm2U9yDVgAXjvuIhO6ZYFZpehcfGxJPKBMYVmiwfEx4GS0bYAs/y3JQKPXoJ3
	 d8zIGq+PQnB6tYobkO7SVJFmJXKR2tEOSx6VW+HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1167/1756] ASoC: codecs: wcd937x: request watchdog IRQs without devm
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150056.437214662@linuxfoundation.org>
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
index 17ddd91eac5fc..94ffcd32aedf4 100644
--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2535,23 +2535,23 @@ static int wcd937x_soc_codec_probe(struct snd_soc_component *component)
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
@@ -2563,23 +2563,33 @@ static int wcd937x_soc_codec_probe(struct snd_soc_component *component)
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



