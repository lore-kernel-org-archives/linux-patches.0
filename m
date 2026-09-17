Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABBA4E9C36;
	Thu, 17 Sep 2026 18:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669013; cv=none; b=LkjxyQp51qQb2+9JYPx0gufYmEDqMk6mWbkZTEj6YoDM5slOX+y14/i2L7GnwthcLat7pugB+XVrFdBHck+qL6LXQ8YMiEFfyOz66OXvVWn8K7F+wwhCF1nt/C059KoI8ZDMvZ1cpdzc99lCmPcPx08DaB0Kr7lF2A2ALnO423s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669013; c=relaxed/simple;
	bh=5IvN8KAjzLbXNwfUC614sBmGHKNkuY09Zn5FZLAM2Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4PreEdFOvRo4edq3DR7/3KrsTr0lZ95b74a+KZNQsyZuWzBMwethe4T/Q3vmGH+3PEJznXNb3rcLjGFE6enzEzJCb8ysUhRE3+tDcipTh+DFDbYnfRNgI4bVLcpD0KH4LODxIJCYlC4jGVLHxmxbDIOA6t6EcUDtj88F9ciHqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0/vdIwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0/vdIwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EEF1F000FF;
	Thu, 17 Sep 2026 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669012;
	bh=laRITpqa/i7GaL4NHp92OHxS/CMMS9Qslsmeg1asenI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0/vdIwNZF4OErFk2OD4Lqd/viABrKAtKgAUL48yn6onofZ/6MHod9MJWjZX8lua6
	 rW2amz4R5Pd5NBgL5tRdgIxpu6jeuoo4i1NP/bk4+sbPuqGxEPyMXjnn7sQIs/VD+Y
	 tEypbFlkDAmnEv0uOIjbi7d/owu9bksnfN1lCa1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0615/1102] ASoC: ux500: Remove obsolete PRCMU QoS calls
Date: Thu, 17 Sep 2026 16:09:18 +0100
Message-ID: <20260917151555.494124562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0c57bcbe9b694..c1e5850e9ca92 100644
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
 		ret = (int)PTR_ERR(drvdata->pclk);
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



