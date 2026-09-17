Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5C64DE720;
	Thu, 17 Sep 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665489; cv=none; b=T6/I2LTFKcCFdnnrk6vRcBkrcwjXXSl2WpEW4yL2AFlJ23VCtG184sGm+2bnvtk0ljmJdqa6nr+etFsh9OefYjSUME0srEiHyeqUg/F7inTtqr1srQmNRwmuEXx6NkqcmlYm+iSC0is1zOBkZK5mPd6jDEdLrzu06e0L6ZiFuqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665489; c=relaxed/simple;
	bh=TBYfZj30OQXeRtjJI3v+0Gzj+wCpocBzOLYaAkEFCKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBPVKXO6wYSh0OUPTMbxgKpH0QI7C+m18WtCYGuO9SRIk1BUIOtZ5vqmZH49lqA8/ipHTNBGBMB/QRu9b9Rgs6/hOSPJq4qPCHGb/mAjKpN4iRr/RgVeuZspaiZb11rqONnZny4GMSaCStLWy7Ab+V43FCWq4YKc2NXLpeEA/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQuyngcN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQuyngcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972701F000FF;
	Thu, 17 Sep 2026 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665488;
	bh=dCAZHWDJaE/+HtKBPItirGPop1wmTSrkCzY1FCx/RXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQuyngcNO6qrxmLqKmNG6JHTXJMEtghCYUncZanMMGtzoy5Ivs5y1w+33AMyuDz8m
	 J+TmZsLAumdSHX8hM12u8dF6j7ue5+n3kzaOw3Alz/avcSE54EUt4U4SAtRjoeXBNn
	 Cn3VT3NPZp9zO6eJnSVcnEzVVEt/O7fmvmkXAfVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0720/1250] ASoC: ux500: Remove obsolete PRCMU QoS calls
Date: Thu, 17 Sep 2026 16:08:35 +0100
Message-ID: <20260917151611.407385309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 7b819677b503667422b0b7bdb21853e0066f8606 ]

The DB8500 PRCMU QoS interface consists of unconditional inline stubs,
so the MSP calls and cached constraint state have no effect. Device
power and clocks are already represented by the regulator, power-domain
and common-clock frameworks.

Remove the dead calls and their private state instead of pretending to
change the APE operating point.

Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-7-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: dc1a1b1e2206 ("ASoC: ux500: Allow repeated MSP prepare calls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 26 --------------------------
 sound/soc/ux500/ux500_msp_dai.h |  2 --
 2 files changed, 28 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index b3de115d829a7..5b4b3126637e4 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -15,7 +15,6 @@
 #include <linux/of.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
-#include <linux/mfd/db8500-prcmu.h>
 
 #include <sound/soc.h>
 #include <sound/soc-dai.h>
@@ -393,12 +392,6 @@ static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
 	dev_dbg(dai->dev, "%s: MSP %d (%s): Enter.\n", __func__, dai->id,
 		snd_pcm_stream_str(substream));
 
-	if (drvdata->vape_opp_constraint == 1) {
-		prcmu_qos_update_requirement(PRCMU_QOS_APE_OPP,
-					"ux500_msp_i2s", 50);
-		drvdata->vape_opp_constraint = 0;
-	}
-
 	if (ux500_msp_i2s_close(drvdata->msp,
 				is_playback ? MSP_DIR_TX : MSP_DIR_RX)) {
 		dev_err(dai->dev,
@@ -440,21 +433,6 @@ static int ux500_msp_dai_prepare(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	/* Set OPP-level */
-	if ((drvdata->fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) &&
-		(drvdata->msp->f_bitclk > 19200000)) {
-		/* If the bit-clock is higher than 19.2MHz, Vape should be
-		 * run in 100% OPP. Only when bit-clock is used (MSP master)
-		 */
-		prcmu_qos_update_requirement(PRCMU_QOS_APE_OPP,
-					"ux500-msp-i2s", 100);
-		drvdata->vape_opp_constraint = 1;
-	} else {
-		prcmu_qos_update_requirement(PRCMU_QOS_APE_OPP,
-					"ux500-msp-i2s", 50);
-		drvdata->vape_opp_constraint = 0;
-	}
-
 	return ret;
 }
 
@@ -710,8 +688,6 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 			__func__, ret);
 		return ret;
 	}
-	prcmu_qos_add_requirement(PRCMU_QOS_APE_OPP, (char *)pdev->name, 50);
-
 	drvdata->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
 	if (IS_ERR(drvdata->pclk)) {
 		ret = PTR_ERR(drvdata->pclk);
@@ -780,8 +756,6 @@ static void ux500_msp_drv_remove(struct platform_device *pdev)
 
 	snd_soc_unregister_component(&pdev->dev);
 
-	prcmu_qos_remove_requirement(PRCMU_QOS_APE_OPP, "ux500_msp_i2s");
-
 	ux500_msp_i2s_cleanup_msp(pdev, drvdata->msp);
 }
 
diff --git a/sound/soc/ux500/ux500_msp_dai.h b/sound/soc/ux500/ux500_msp_dai.h
index 19058c238420e..ad4ce69bfbf5c 100644
--- a/sound/soc/ux500/ux500_msp_dai.h
+++ b/sound/soc/ux500/ux500_msp_dai.h
@@ -46,8 +46,6 @@ struct ux500_msp_i2s_drvdata {
 	struct clk *clk;
 	struct clk *pclk;
 
-	/* Regulators */
-	int vape_opp_constraint;
 };
 
 int ux500_msp_dai_set_data_delay(struct snd_soc_dai *dai, int delay);
-- 
2.53.0



