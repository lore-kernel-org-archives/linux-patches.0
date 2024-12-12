Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015FB13CA93;
	Thu, 12 Dec 2024 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023873; cv=none; b=DfwTSxHNwJGgVnLwqmIt/r59VuNEna7uSbcDIFsre/6rFCCTHEWCB/KR/QHunqfpcTQuN3th+aOJuV5T7GHE+cFuNNMBHZ/bpt4vi+A1ghP6ti4VUBxw4C3L2eB0TJJuwT0liqfmG9yGHTZoPhqFZq5Bpf193b/pzcbiUP2lrpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023873; c=relaxed/simple;
	bh=MCxMUKpqvWJUkLsfgVQkb05ovfCX3dpNXYGym+SyqNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcahA5mAGJJxBblcpZRbesnN8ZBLIDO+HgI2DrHdoArFBDvAevtx2GC9jgx1aIurgMkIEVlr05SmZtLGIEzAUaLyU4oQHcQ8u1VyhafP3IexiyFfm6NGGlMPtJsRC3WzE//ku75HPZTG/sY2jHm3jVX3dlXVZoOgnF04VzHS9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XA+W5MFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XA+W5MFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7258FC4CECE;
	Thu, 12 Dec 2024 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023872;
	bh=MCxMUKpqvWJUkLsfgVQkb05ovfCX3dpNXYGym+SyqNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XA+W5MFOe2UvDK7nZopNf9G6zna7EY1BzQDLuZoO0vUqGicdQC+QDRY3nncI7rit5
	 Rsxe7DUrgFI4+uOx4FDE7YLS9ocDR+ohIEZWc8MUrFvOpMG9f//Qk+lkLezvlkkPDE
	 3qtYJH6D9v2uHfHKc+1EknSXRMNhScsxTBvSDJig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/459] ASoC: fsl_micfil: do not define SHIFT/MASK for single bits
Date: Thu, 12 Dec 2024 15:57:28 +0100
Message-ID: <20241212144257.861066163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit bd2cffd10d79eb9280cb8f5b7cb441f206c1e6ac ]

No need to have defines for the mask of single bits. Also shift is
unused. Drop all these unnecessary defines.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20220414162249.3934543-5-s.hauer@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 06df673d2023 ("ASoC: fsl_micfil: fix regmap_write_bits usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c |  18 +++---
 sound/soc/fsl/fsl_micfil.h | 125 +++++++++----------------------------
 2 files changed, 40 insertions(+), 103 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index fe6d6c87a1c42..13d963a840333 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -172,7 +172,7 @@ static int fsl_micfil_reset(struct device *dev)
 
 	ret = regmap_update_bits(micfil->regmap,
 				 REG_MICFIL_CTRL1,
-				 MICFIL_CTRL1_MDIS_MASK,
+				 MICFIL_CTRL1_MDIS,
 				 0);
 	if (ret) {
 		dev_err(dev, "failed to clear MDIS bit %d\n", ret);
@@ -181,7 +181,7 @@ static int fsl_micfil_reset(struct device *dev)
 
 	ret = regmap_update_bits(micfil->regmap,
 				 REG_MICFIL_CTRL1,
-				 MICFIL_CTRL1_SRES_MASK,
+				 MICFIL_CTRL1_SRES,
 				 MICFIL_CTRL1_SRES);
 	if (ret) {
 		dev_err(dev, "failed to reset MICFIL: %d\n", ret);
@@ -274,7 +274,7 @@ static int fsl_micfil_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		/* Enable the module */
 		ret = regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL1,
-					 MICFIL_CTRL1_PDMIEN_MASK,
+					 MICFIL_CTRL1_PDMIEN,
 					 MICFIL_CTRL1_PDMIEN);
 		if (ret) {
 			dev_err(dev, "failed to enable the module\n");
@@ -287,7 +287,7 @@ static int fsl_micfil_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		/* Disable the module */
 		ret = regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL1,
-					 MICFIL_CTRL1_PDMIEN_MASK,
+					 MICFIL_CTRL1_PDMIEN,
 					 0);
 		if (ret) {
 			dev_err(dev, "failed to enable the module\n");
@@ -353,7 +353,7 @@ static int fsl_micfil_hw_params(struct snd_pcm_substream *substream,
 
 	/* 1. Disable the module */
 	ret = regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL1,
-				 MICFIL_CTRL1_PDMIEN_MASK, 0);
+				 MICFIL_CTRL1_PDMIEN, 0);
 	if (ret) {
 		dev_err(dev, "failed to disable the module\n");
 		return ret;
@@ -636,16 +636,16 @@ static irqreturn_t micfil_err_isr(int irq, void *devid)
 
 	regmap_read(micfil->regmap, REG_MICFIL_STAT, &stat_reg);
 
-	if (stat_reg & MICFIL_STAT_BSY_FIL_MASK)
+	if (stat_reg & MICFIL_STAT_BSY_FIL)
 		dev_dbg(&pdev->dev, "isr: Decimation Filter is running\n");
 
-	if (stat_reg & MICFIL_STAT_FIR_RDY_MASK)
+	if (stat_reg & MICFIL_STAT_FIR_RDY)
 		dev_dbg(&pdev->dev, "isr: FIR Filter Data ready\n");
 
-	if (stat_reg & MICFIL_STAT_LOWFREQF_MASK) {
+	if (stat_reg & MICFIL_STAT_LOWFREQF) {
 		dev_dbg(&pdev->dev, "isr: ipg_clk_app is too low\n");
 		regmap_write_bits(micfil->regmap, REG_MICFIL_STAT,
-				  MICFIL_STAT_LOWFREQF_MASK, 1);
+				  MICFIL_STAT_LOWFREQF, 1);
 	}
 
 	return IRQ_HANDLED;
diff --git a/sound/soc/fsl/fsl_micfil.h b/sound/soc/fsl/fsl_micfil.h
index bac825c3135a0..11ccc08523b2e 100644
--- a/sound/soc/fsl/fsl_micfil.h
+++ b/sound/soc/fsl/fsl_micfil.h
@@ -33,33 +33,17 @@
 #define REG_MICFIL_VAD0_ZCD		0xA8
 
 /* MICFIL Control Register 1 -- REG_MICFILL_CTRL1 0x00 */
-#define MICFIL_CTRL1_MDIS_SHIFT		31
-#define MICFIL_CTRL1_MDIS_MASK		BIT(MICFIL_CTRL1_MDIS_SHIFT)
-#define MICFIL_CTRL1_MDIS		BIT(MICFIL_CTRL1_MDIS_SHIFT)
-#define MICFIL_CTRL1_DOZEN_SHIFT	30
-#define MICFIL_CTRL1_DOZEN_MASK		BIT(MICFIL_CTRL1_DOZEN_SHIFT)
-#define MICFIL_CTRL1_DOZEN		BIT(MICFIL_CTRL1_DOZEN_SHIFT)
-#define MICFIL_CTRL1_PDMIEN_SHIFT	29
-#define MICFIL_CTRL1_PDMIEN_MASK	BIT(MICFIL_CTRL1_PDMIEN_SHIFT)
-#define MICFIL_CTRL1_PDMIEN		BIT(MICFIL_CTRL1_PDMIEN_SHIFT)
-#define MICFIL_CTRL1_DBG_SHIFT		28
-#define MICFIL_CTRL1_DBG_MASK		BIT(MICFIL_CTRL1_DBG_SHIFT)
-#define MICFIL_CTRL1_DBG		BIT(MICFIL_CTRL1_DBG_SHIFT)
-#define MICFIL_CTRL1_SRES_SHIFT		27
-#define MICFIL_CTRL1_SRES_MASK		BIT(MICFIL_CTRL1_SRES_SHIFT)
-#define MICFIL_CTRL1_SRES		BIT(MICFIL_CTRL1_SRES_SHIFT)
-#define MICFIL_CTRL1_DBGE_SHIFT		26
-#define MICFIL_CTRL1_DBGE_MASK		BIT(MICFIL_CTRL1_DBGE_SHIFT)
-#define MICFIL_CTRL1_DBGE		BIT(MICFIL_CTRL1_DBGE_SHIFT)
+#define MICFIL_CTRL1_MDIS		BIT(31)
+#define MICFIL_CTRL1_DOZEN		BIT(30)
+#define MICFIL_CTRL1_PDMIEN		BIT(29)
+#define MICFIL_CTRL1_DBG		BIT(28)
+#define MICFIL_CTRL1_SRES		BIT(27)
+#define MICFIL_CTRL1_DBGE		BIT(26)
 #define MICFIL_CTRL1_DISEL_SHIFT	24
 #define MICFIL_CTRL1_DISEL_WIDTH	2
 #define MICFIL_CTRL1_DISEL_MASK		((BIT(MICFIL_CTRL1_DISEL_WIDTH) - 1) \
 					 << MICFIL_CTRL1_DISEL_SHIFT)
-#define MICFIL_CTRL1_DISEL(v)		(((v) << MICFIL_CTRL1_DISEL_SHIFT) \
-					 & MICFIL_CTRL1_DISEL_MASK)
-#define MICFIL_CTRL1_ERREN_SHIFT	23
-#define MICFIL_CTRL1_ERREN_MASK		BIT(MICFIL_CTRL1_ERREN_SHIFT)
-#define MICFIL_CTRL1_ERREN		BIT(MICFIL_CTRL1_ERREN_SHIFT)
+#define MICFIL_CTRL1_ERREN		BIT(23)
 #define MICFIL_CTRL1_CHEN_SHIFT		0
 #define MICFIL_CTRL1_CHEN_WIDTH		8
 #define MICFIL_CTRL1_CHEN_MASK(x)	(BIT(x) << MICFIL_CTRL1_CHEN_SHIFT)
@@ -91,15 +75,9 @@
 					 & MICFIL_CTRL2_CLKDIV_MASK)
 
 /* MICFIL Status Register -- REG_MICFIL_STAT 0x08 */
-#define MICFIL_STAT_BSY_FIL_SHIFT	31
-#define MICFIL_STAT_BSY_FIL_MASK	BIT(MICFIL_STAT_BSY_FIL_SHIFT)
-#define MICFIL_STAT_BSY_FIL		BIT(MICFIL_STAT_BSY_FIL_SHIFT)
-#define MICFIL_STAT_FIR_RDY_SHIFT	30
-#define MICFIL_STAT_FIR_RDY_MASK	BIT(MICFIL_STAT_FIR_RDY_SHIFT)
-#define MICFIL_STAT_FIR_RDY		BIT(MICFIL_STAT_FIR_RDY_SHIFT)
-#define MICFIL_STAT_LOWFREQF_SHIFT	29
-#define MICFIL_STAT_LOWFREQF_MASK	BIT(MICFIL_STAT_LOWFREQF_SHIFT)
-#define MICFIL_STAT_LOWFREQF		BIT(MICFIL_STAT_LOWFREQF_SHIFT)
+#define MICFIL_STAT_BSY_FIL		BIT(31)
+#define MICFIL_STAT_FIR_RDY		BIT(30)
+#define MICFIL_STAT_LOWFREQF		BIT(29)
 #define MICFIL_STAT_CHXF_SHIFT(v)	(v)
 #define MICFIL_STAT_CHXF_MASK(v)	BIT(MICFIL_STAT_CHXF_SHIFT(v))
 #define MICFIL_STAT_CHXF(v)		BIT(MICFIL_STAT_CHXF_SHIFT(v))
@@ -137,32 +115,16 @@
 					 << MICFIL_VAD0_CTRL1_INITT_SHIFT)
 #define MICFIL_VAD0_CTRL1_INITT(v)	(((v) << MICFIL_VAD0_CTRL1_INITT_SHIFT) \
 					 & MICFIL_VAD0_CTRL1_INITT_MASK)
-#define MICFIL_VAD0_CTRL1_ST10_SHIFT	4
-#define MICFIL_VAD0_CTRL1_ST10_MASK	BIT(MICFIL_VAD0_CTRL1_ST10_SHIFT)
-#define MICFIL_VAD0_CTRL1_ST10		BIT(MICFIL_VAD0_CTRL1_ST10_SHIFT)
-#define MICFIL_VAD0_CTRL1_ERIE_SHIFT	3
-#define MICFIL_VAD0_CTRL1_ERIE_MASK	BIT(MICFIL_VAD0_CTRL1_ERIE_SHIFT)
-#define MICFIL_VAD0_CTRL1_ERIE		BIT(MICFIL_VAD0_CTRL1_ERIE_SHIFT)
-#define MICFIL_VAD0_CTRL1_IE_SHIFT	2
-#define MICFIL_VAD0_CTRL1_IE_MASK	BIT(MICFIL_VAD0_CTRL1_IE_SHIFT)
-#define MICFIL_VAD0_CTRL1_IE		BIT(MICFIL_VAD0_CTRL1_IE_SHIFT)
-#define MICFIL_VAD0_CTRL1_RST_SHIFT	1
-#define MICFIL_VAD0_CTRL1_RST_MASK	BIT(MICFIL_VAD0_CTRL1_RST_SHIFT)
-#define MICFIL_VAD0_CTRL1_RST		BIT(MICFIL_VAD0_CTRL1_RST_SHIFT)
-#define MICFIL_VAD0_CTRL1_EN_SHIFT	0
-#define MICFIL_VAD0_CTRL1_EN_MASK	BIT(MICFIL_VAD0_CTRL1_EN_SHIFT)
-#define MICFIL_VAD0_CTRL1_EN		BIT(MICFIL_VAD0_CTRL1_EN_SHIFT)
+#define MICFIL_VAD0_CTRL1_ST10		BIT(4)
+#define MICFIL_VAD0_CTRL1_ERIE		BIT(3)
+#define MICFIL_VAD0_CTRL1_IE		BIT(2)
+#define MICFIL_VAD0_CTRL1_RST		BIT(1)
+#define MICFIL_VAD0_CTRL1_EN		BIT(0)
 
 /* MICFIL HWVAD0 Control 2 Register -- REG_MICFIL_VAD0_CTRL2*/
-#define MICFIL_VAD0_CTRL2_FRENDIS_SHIFT	31
-#define MICFIL_VAD0_CTRL2_FRENDIS_MASK	BIT(MICFIL_VAD0_CTRL2_FRENDIS_SHIFT)
-#define MICFIL_VAD0_CTRL2_FRENDIS	BIT(MICFIL_VAD0_CTRL2_FRENDIS_SHIFT)
-#define MICFIL_VAD0_CTRL2_PREFEN_SHIFT	30
-#define MICFIL_VAD0_CTRL2_PREFEN_MASK	BIT(MICFIL_VAD0_CTRL2_PREFEN_SHIFT)
-#define MICFIL_VAD0_CTRL2_PREFEN	BIT(MICFIL_VAD0_CTRL2_PREFEN_SHIFT)
-#define MICFIL_VAD0_CTRL2_FOUTDIS_SHIFT	28
-#define MICFIL_VAD0_CTRL2_FOUTDIS_MASK	BIT(MICFIL_VAD0_CTRL2_FOUTDIS_SHIFT)
-#define MICFIL_VAD0_CTRL2_FOUTDIS	BIT(MICFIL_VAD0_CTRL2_FOUTDIS_SHIFT)
+#define MICFIL_VAD0_CTRL2_FRENDIS	BIT(31)
+#define MICFIL_VAD0_CTRL2_PREFEN	BIT(30)
+#define MICFIL_VAD0_CTRL2_FOUTDIS	BIT(28)
 #define MICFIL_VAD0_CTRL2_FRAMET_SHIFT	16
 #define MICFIL_VAD0_CTRL2_FRAMET_WIDTH	6
 #define MICFIL_VAD0_CTRL2_FRAMET_MASK	((BIT(MICFIL_VAD0_CTRL2_FRAMET_WIDTH) - 1) \
@@ -183,12 +145,8 @@
 					 & MICFIL_VAD0_CTRL2_HPF_MASK)
 
 /* MICFIL HWVAD0 Signal CONFIG Register -- REG_MICFIL_VAD0_SCONFIG */
-#define MICFIL_VAD0_SCONFIG_SFILEN_SHIFT	31
-#define MICFIL_VAD0_SCONFIG_SFILEN_MASK		BIT(MICFIL_VAD0_SCONFIG_SFILEN_SHIFT)
-#define MICFIL_VAD0_SCONFIG_SFILEN		BIT(MICFIL_VAD0_SCONFIG_SFILEN_SHIFT)
-#define MICFIL_VAD0_SCONFIG_SMAXEN_SHIFT	30
-#define MICFIL_VAD0_SCONFIG_SMAXEN_MASK		BIT(MICFIL_VAD0_SCONFIG_SMAXEN_SHIFT)
-#define MICFIL_VAD0_SCONFIG_SMAXEN		BIT(MICFIL_VAD0_SCONFIG_SMAXEN_SHIFT)
+#define MICFIL_VAD0_SCONFIG_SFILEN		BIT(31)
+#define MICFIL_VAD0_SCONFIG_SMAXEN		BIT(30)
 #define MICFIL_VAD0_SCONFIG_SGAIN_SHIFT		0
 #define MICFIL_VAD0_SCONFIG_SGAIN_WIDTH		4
 #define MICFIL_VAD0_SCONFIG_SGAIN_MASK		((BIT(MICFIL_VAD0_SCONFIG_SGAIN_WIDTH) - 1) \
@@ -197,17 +155,10 @@
 						 & MICFIL_VAD0_SCONFIG_SGAIN_MASK)
 
 /* MICFIL HWVAD0 Noise CONFIG Register -- REG_MICFIL_VAD0_NCONFIG */
-#define MICFIL_VAD0_NCONFIG_NFILAUT_SHIFT	31
-#define MICFIL_VAD0_NCONFIG_NFILAUT_MASK	BIT(MICFIL_VAD0_NCONFIG_NFILAUT_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NFILAUT		BIT(MICFIL_VAD0_NCONFIG_NFILAUT_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NMINEN_SHIFT	30
-#define MICFIL_VAD0_NCONFIG_NMINEN_MASK		BIT(MICFIL_VAD0_NCONFIG_NMINEN_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NMINEN		BIT(MICFIL_VAD0_NCONFIG_NMINEN_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NDECEN_SHIFT	29
-#define MICFIL_VAD0_NCONFIG_NDECEN_MASK		BIT(MICFIL_VAD0_NCONFIG_NDECEN_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NDECEN		BIT(MICFIL_VAD0_NCONFIG_NDECEN_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NOREN_SHIFT		28
-#define MICFIL_VAD0_NCONFIG_NOREN		BIT(MICFIL_VAD0_NCONFIG_NOREN_SHIFT)
+#define MICFIL_VAD0_NCONFIG_NFILAUT		BIT(31)
+#define MICFIL_VAD0_NCONFIG_NMINEN		BIT(30)
+#define MICFIL_VAD0_NCONFIG_NDECEN		BIT(29)
+#define MICFIL_VAD0_NCONFIG_NOREN		BIT(28)
 #define MICFIL_VAD0_NCONFIG_NFILADJ_SHIFT	8
 #define MICFIL_VAD0_NCONFIG_NFILADJ_WIDTH	5
 #define MICFIL_VAD0_NCONFIG_NFILADJ_MASK	((BIT(MICFIL_VAD0_NCONFIG_NFILADJ_WIDTH) - 1) \
@@ -234,29 +185,15 @@
 					 << MICFIL_VAD0_ZCD_ZCDADJ_SHIFT)
 #define MICFIL_VAD0_ZCD_ZCDADJ(v)	(((v) << MICFIL_VAD0_ZCD_ZCDADJ_SHIFT)\
 					 & MICFIL_VAD0_ZCD_ZCDADJ_MASK)
-#define MICFIL_VAD0_ZCD_ZCDAND_SHIFT	4
-#define MICFIL_VAD0_ZCD_ZCDAND_MASK	BIT(MICFIL_VAD0_ZCD_ZCDAND_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDAND		BIT(MICFIL_VAD0_ZCD_ZCDAND_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDAUT_SHIFT	2
-#define MICFIL_VAD0_ZCD_ZCDAUT_MASK	BIT(MICFIL_VAD0_ZCD_ZCDAUT_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDAUT		BIT(MICFIL_VAD0_ZCD_ZCDAUT_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDEN_SHIFT	0
-#define MICFIL_VAD0_ZCD_ZCDEN_MASK	BIT(MICFIL_VAD0_ZCD_ZCDEN_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDEN		BIT(MICFIL_VAD0_ZCD_ZCDEN_SHIFT)
+#define MICFIL_VAD0_ZCD_ZCDAND		BIT(4)
+#define MICFIL_VAD0_ZCD_ZCDAUT		BIT(2)
+#define MICFIL_VAD0_ZCD_ZCDEN		BIT(0)
 
 /* MICFIL HWVAD0 Status Register - REG_MICFIL_VAD0_STAT */
-#define MICFIL_VAD0_STAT_INITF_SHIFT	31
-#define MICFIL_VAD0_STAT_INITF_MASK	BIT(MICFIL_VAD0_STAT_INITF_SHIFT)
-#define MICFIL_VAD0_STAT_INITF		BIT(MICFIL_VAD0_STAT_INITF_SHIFT)
-#define MICFIL_VAD0_STAT_INSATF_SHIFT	16
-#define MICFIL_VAD0_STAT_INSATF_MASK	BIT(MICFIL_VAD0_STAT_INSATF_SHIFT)
-#define MICFIL_VAD0_STAT_INSATF		BIT(MICFIL_VAD0_STAT_INSATF_SHIFT)
-#define MICFIL_VAD0_STAT_EF_SHIFT	15
-#define MICFIL_VAD0_STAT_EF_MASK	BIT(MICFIL_VAD0_STAT_EF_SHIFT)
-#define MICFIL_VAD0_STAT_EF		BIT(MICFIL_VAD0_STAT_EF_SHIFT)
-#define MICFIL_VAD0_STAT_IF_SHIFT	0
-#define MICFIL_VAD0_STAT_IF_MASK	BIT(MICFIL_VAD0_STAT_IF_SHIFT)
-#define MICFIL_VAD0_STAT_IF		BIT(MICFIL_VAD0_STAT_IF_SHIFT)
+#define MICFIL_VAD0_STAT_INITF		BIT(31)
+#define MICFIL_VAD0_STAT_INSATF		BIT(16)
+#define MICFIL_VAD0_STAT_EF		BIT(15)
+#define MICFIL_VAD0_STAT_IF		BIT(0)
 
 /* MICFIL Output Control Register */
 #define MICFIL_OUTGAIN_CHX_SHIFT(v)	(4 * (v))
-- 
2.43.0



