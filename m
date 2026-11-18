Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048783;
	b=uiCV3Qod1w2o0kRFR+6Mh/wUKesrp3JX2UrtrJN/+PrTIfy5nS/XLFyWV5VKd/saFuow
	 9pjPNTEEW4I6fEY0x+7rZz+sydAfRk0pw3bSH2F3f/QDirjl4AodiHMfsEqA9Q9tBHMAK
	 M9t6U+1IR0LNIFHRveztjv+2WP1o2yOfO92LZmdqW2qVcUXLhedDNkLLcNlVc9ozaN5WI
	 gp3EGZEpzFnqR92W1+rMXO2BzXlCZbrcesgnBKP8GLFaTs79/fMe9bii3Xhqdaw3ESvol
	 +BwpJb2fVd0CCEMGvkn2qkouqomT9Gquw9a/kwEcdcMNjrZ1+Gf9khRtWa2t3w5Pfhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PrVXb+gF0A7yaDUvBbvUSTgiHIARtGR/uUXaMyYSzV0=;
	b=SnUxuPjfu3wqn727Llzxuc2Iqr9W7wPdY3j9vRAC3r358vgUtoT8/dnHyV6iVKDur70I
	 TQICk4aKR+UrzLngrp9LDvIcFsRUPUF96yoCEejWi30xVhok1w2UeaqhXxkLPTfpiKYHR
	 0et69pAqv7Or0CKosgOLJZYBp2B6MR19oUSX8/IyUvUigcS68itMxjCvjQSCnTg6d6Sd5
	 ss6NOvnXatW/pNWmO6iuZICs031RvbibUgWN2yMEz/bQmaZ+6K9D+Mt2Sa4IqqfQ+J5jg
	 mumX1fNiwX7flqrrSLkDPXNB83DCBjY9zhF5nuJx9hZaR9p9woWvLWqAkKuQCthDqmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJjKwOTt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1535606A320;
	Thu, 19 Nov 2026 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJjKwOTt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140041F000C4;
	Thu, 19 Nov 2026 00:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048783;
	bh=PrVXb+gF0A7yaDUvBbvUSTgiHIARtGR/uUXaMyYSzV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJjKwOTtJ2JGFU61zObms6oMDRSB4bJj1rkLVywXabX+OYLQiDVLBkX5s99/xXOR9
	 xzZA5ql1/9FbzK2Y0zhkTHqGnyrtMlySPSRe4xp1KP9gVLLPIJsToSHerSTIv4NTMC
	 Gp3M+lF3MFXz4Z0Mm0QudNK+TjNSq32LDN4gz0Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2116/2857] ASoC: mediatek: mt8192-mt6359: Fix error handling in MTKAIF calibration
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150317.594858224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit d6c8a0b5bf696d89350e43bf554362de8929f801 ]

mt8192_mt6359_mtkaif_calibration() ignored the return values of
pm_runtime_get_sync() and mt8192_afe_gpio_request(), which could
leave PM runtime references or GPIO state unbalanced on failure.

Switch to pm_runtime_resume_and_get(), check each GPIO request,
and unwind on error.

Fixes: 18b13ff23fab ("ASoC: mediatek: mt8192: add machine driver with mt6359, rt1015 and rt5682")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-16-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mt8192/mt8192-mt6359-rt1015-rt5682.c      | 37 +++++++++++++------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index 6dedcc7aa68cb..fed0869da1515 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -160,12 +160,23 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 	int chosen_phase_1, chosen_phase_2, chosen_phase_3;
 	int counter;
 	int mtkaif_calib_ok;
+	int ret = 0;
 
-	pm_runtime_get_sync(afe->dev);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 1);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 0);
+	ret = pm_runtime_resume_and_get(afe->dev);
+	if (ret < 0)
+		return ret;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
+	if (ret)
+		goto err_pm_put;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
+	if (ret)
+		goto err_disable_adda_1;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 1);
+	if (ret)
+		goto err_disable_adda_0;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 0);
+	if (ret)
+		goto err_disable_adda_ch34_1;
 
 	mt6359_mtkaif_calibration_enable(cmpnt_codec);
 
@@ -286,10 +297,14 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 
 	mt6359_mtkaif_calibration_disable(cmpnt_codec);
 
-	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 1);
-	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 0);
-	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34, 1);
 	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34, 0);
+err_disable_adda_ch34_1:
+	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34, 1);
+err_disable_adda_0:
+	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 0);
+err_disable_adda_1:
+	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 1);
+err_pm_put:
 	pm_runtime_put(afe->dev);
 
 	dev_info(afe->dev, "%s(), mtkaif_chosen_phase[0/1/2]:%d/%d/%d\n",
@@ -298,7 +313,7 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 		 afe_priv->mtkaif_chosen_phase[1],
 		 afe_priv->mtkaif_chosen_phase[2]);
 
-	return 0;
+	return ret;
 }
 
 static int mt8192_mt6359_init(struct snd_soc_pcm_runtime *rtd)
@@ -316,9 +331,7 @@ static int mt8192_mt6359_init(struct snd_soc_pcm_runtime *rtd)
 	afe_priv->mtkaif_protocol = MTKAIF_PROTOCOL_2_CLK_P2;
 
 	/* mtkaif calibration */
-	mt8192_mt6359_mtkaif_calibration(rtd);
-
-	return 0;
+	return mt8192_mt6359_mtkaif_calibration(rtd);
 }
 
 static int mt8192_rt5682_init(struct snd_soc_pcm_runtime *rtd)
-- 
2.53.0



