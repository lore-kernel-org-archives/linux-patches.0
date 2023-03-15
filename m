Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C379440
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 12:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBADC433EF
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 12:22:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="Y/i7lHzd"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 21 Mar 2023 12:22:20 +0000
Resent-Message-ID: <ZBmhfOevJS6CaXyy@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 15 Mar 2023 15:48:03 +0000
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Q5NZ=7H=opensource.cirrus.com=prvs=843822f42b=vkarpovi@kernel.org>)
	id 1pcTM8-007KPo-Vw
	for broonie@sirena.co.uk; Wed, 15 Mar 2023 15:48:03 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id E341CB81D16
	for <broonie@sirena.co.uk>; Wed, 15 Mar 2023 15:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id C49CCC433D2; Wed, 15 Mar 2023 15:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EDD3C4339E;
	Wed, 15 Mar 2023 15:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 3EDD3C4339E
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FFMICO019360;
	Wed, 15 Mar 2023 10:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PODMain02222019;
 bh=bQStFoqbeGVMMU6tdxat9vYq90aSti2LujKJG0D9iPE=;
 b=Y/i7lHzdZEoTsUElplofd1etx3YW0ffHOPmlToQs3qcQOmMPHdRnDMvGQzFp3TmKnlhH
 v5LPawDfmIC3QHQk7ZuwEE5w2rvDaKAeIZHoruQye84qzbLAeLJsVceyIePcSUBTvTnM
 Z6fFSENRYkt/m11EZmxQW5CKCPfc7l0JK2PADR2MVaapTPw8igCKDY2MylOzpwzw4Uji
 fI/99Hjp/DmgIoMSR+bm5+YE1+TEMeURv+vbzGdcTlVVPY5t1k0G8p6o0Yg70j4EBLwO
 ZTSzf56eTV9mTGrqd8/qmygckCx/mamVSlysk3fNyBvLWuRrkj1yALEE0MbYvc+58dKx mQ== 
Received: from ediex01.ad.cirrus.com ([84.19.233.68])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 3pb7utgrqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Mar 2023 10:47:52 -0500
Received: from ediex01.ad.cirrus.com (198.61.84.80) by ediex01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.25; Wed, 15 Mar
 2023 10:47:51 -0500
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by ediex01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.2.1118.25 via Frontend
 Transport; Wed, 15 Mar 2023 10:47:51 -0500
Received: from vkarpovich-ThinkStation-P620.crystal.cirrus.com (vkarpovich-ThinkStation-P620.ad.cirrus.com [141.131.206.93])
	by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 732D02A1;
	Wed, 15 Mar 2023 15:47:49 +0000 (UTC)
From: Vlad Karpovich <vkarpovi@opensource.cirrus.com>
To: James Schulman <james.schulman@cirrus.com>,
        David Rhodes
	<david.rhodes@cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Rob Herring
	<robh+dt@kernel.org>
CC: <alsa-devel@alsa-project.org>, <patches@opensource.cirrus.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Vlad.Karpovich
	<vkarpovi@opensource.cirrus.com>
Date: Wed, 15 Mar 2023 10:47:22 -0500
Message-ID: <20230315154722.3911463-5-vkarpovi@opensource.cirrus.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315154722.3911463-1-vkarpovi@opensource.cirrus.com>
References: <20230315154722.3911463-1-vkarpovi@opensource.cirrus.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oA3mm_BNseWrPiJNZL9Xv9rx_dZoX7E2
X-Proofpoint-GUID: oA3mm_BNseWrPiJNZL9Xv9rx_dZoX7E2
X-Proofpoint-Spam-Reason: safe
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=Q5NZ=7H=opensource.cirrus.com=prvs=843822f42b=vkarpovi@kernel.org
Subject: [PATCH v3 5/5] ASoC: cs35l45: Hibernation support
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 64GAQ7f+Q5sI

From: "Vlad.Karpovich" <vkarpovi@opensource.cirrus.com>

Adds support for a low-power Hibernation State.
Add support for a low-power hibernation state for the DSP. In
this state the DSP RAM contents are maintained, such that
firmware does not need to be re-downloaded, but the rest of the
chip's register state is lost.
Entry to this state is achieved via the register interface
(either by an external driver using the control port, or the
programmable DSP). Exit from this state is triggered by activity
on device GPIO pins, intended SPI transaction, or I2C
transaction with intended slave address.

Signed-off-by: Vlad Karpovich <vkarpovi@opensource.cirrus.com>
---
 sound/soc/codecs/cs35l45-i2c.c    |  2 +
 sound/soc/codecs/cs35l45-spi.c    |  1 +
 sound/soc/codecs/cs35l45-tables.c |  6 +++
 sound/soc/codecs/cs35l45.c        | 80 +++++++++++++++++++++++++++++++
 sound/soc/codecs/cs35l45.h        | 29 +++++++++++
 5 files changed, 118 insertions(+)

diff --git a/sound/soc/codecs/cs35l45-i2c.c b/sound/soc/codecs/cs35l45-i2c.c
index 5224aaf584b8..1c644ddf66bc 100644
--- a/sound/soc/codecs/cs35l45-i2c.c
+++ b/sound/soc/codecs/cs35l45-i2c.c
@@ -33,6 +33,8 @@ static int cs35l45_i2c_probe(struct i2c_client *client)
 
 	cs35l45->dev = dev;
 	cs35l45->irq = client->irq;
+	cs35l45->bus_type = CONTROL_BUS_I2C;
+	cs35l45->i2c_addr = client->addr;
 
 	return cs35l45_probe(cs35l45);
 }
diff --git a/sound/soc/codecs/cs35l45-spi.c b/sound/soc/codecs/cs35l45-spi.c
index bfb79255783e..3ea2e6fd2b88 100644
--- a/sound/soc/codecs/cs35l45-spi.c
+++ b/sound/soc/codecs/cs35l45-spi.c
@@ -36,6 +36,7 @@ static int cs35l45_spi_probe(struct spi_device *spi)
 
 	cs35l45->dev = dev;
 	cs35l45->irq = spi->irq;
+	cs35l45->bus_type = CONTROL_BUS_SPI;
 
 	return cs35l45_probe(cs35l45);
 }
diff --git a/sound/soc/codecs/cs35l45-tables.c b/sound/soc/codecs/cs35l45-tables.c
index 6b68773979ec..212d9cb5a4fb 100644
--- a/sound/soc/codecs/cs35l45-tables.c
+++ b/sound/soc/codecs/cs35l45-tables.c
@@ -47,6 +47,8 @@ static const struct reg_default cs35l45_defaults[] = {
 	{ CS35L45_INTB_GPIO2_MCLK_REF,		0x00000005 },
 	{ CS35L45_GPIO3,			0x00000005 },
 	{ CS35L45_PWRMGT_CTL,			0x00000000 },
+	{ CS35L45_WAKESRC_CTL,			0x00000008 },
+	{ CS35L45_WKI2C_CTL,			0x00000030 },
 	{ CS35L45_REFCLK_INPUT,			0x00000510 },
 	{ CS35L45_GLOBAL_SAMPLE_RATE,		0x00000003 },
 	{ CS35L45_ASP_ENABLES1,			0x00000000 },
@@ -126,6 +128,9 @@ static bool cs35l45_readable_reg(struct device *dev, unsigned int reg)
 	case CS35L45_INTB_GPIO2_MCLK_REF:
 	case CS35L45_GPIO3:
 	case CS35L45_PWRMGT_CTL:
+	case CS35L45_WAKESRC_CTL:
+	case CS35L45_WKI2C_CTL:
+	case CS35L45_PWRMGT_STS:
 	case CS35L45_REFCLK_INPUT:
 	case CS35L45_GLOBAL_SAMPLE_RATE:
 	case CS35L45_ASP_ENABLES1:
@@ -210,6 +215,7 @@ static bool cs35l45_volatile_reg(struct device *dev, unsigned int reg)
 	case CS35L45_GLOBAL_ENABLES:
 	case CS35L45_ERROR_RELEASE:
 	case CS35L45_AMP_PCM_HPF_TST:	/* not cachable */
+	case CS35L45_PWRMGT_STS:
 	case CS35L45_IRQ1_STATUS:
 	case CS35L45_IRQ1_EINT_1 ... CS35L45_IRQ1_EINT_18:
 	case CS35L45_IRQ1_STS_1 ... CS35L45_IRQ1_STS_18:
diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index e7b40b063eb2..8a351cb6d692 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -36,6 +36,8 @@ static bool cs35l45_check_cspl_mbox_sts(const enum cs35l45_cspl_mboxcmd cmd,
 		return (sts == CSPL_MBOX_STS_RUNNING);
 	case CSPL_MBOX_CMD_STOP_PRE_REINIT:
 		return (sts == CSPL_MBOX_STS_RDY_FOR_REINIT);
+	case CSPL_MBOX_CMD_HIBERNATE:
+		return (sts == CSPL_MBOX_STS_HIBERNATE);
 	default:
 		return false;
 	}
@@ -744,11 +746,81 @@ static const struct snd_soc_component_driver cs35l45_component = {
 	.endianness = 1,
 };
 
+static void cs35l45_setup_hibernate(struct cs35l45_private *cs35l45)
+{
+	unsigned int wksrc;
+
+	if (cs35l45->bus_type == CONTROL_BUS_I2C)
+		wksrc = CS35L45_WKSRC_I2C;
+	else
+		wksrc = CS35L45_WKSRC_SPI;
+
+	regmap_update_bits(cs35l45->regmap, CS35L45_WAKESRC_CTL,
+			   CS35L45_WKSRC_EN_MASK,
+			   wksrc << CS35L45_WKSRC_EN_SHIFT);
+
+	regmap_set_bits(cs35l45->regmap, CS35L45_WAKESRC_CTL,
+			   CS35L45_UPDT_WKCTL_MASK);
+
+	regmap_update_bits(cs35l45->regmap, CS35L45_WKI2C_CTL,
+			   CS35L45_WKI2C_ADDR_MASK, cs35l45->i2c_addr);
+
+	regmap_set_bits(cs35l45->regmap, CS35L45_WKI2C_CTL,
+			   CS35L45_UPDT_WKI2C_MASK);
+}
+
+static int cs35l45_enter_hibernate(struct cs35l45_private *cs35l45)
+{
+	dev_dbg(cs35l45->dev, "Enter hibernate\n");
+
+	cs35l45_setup_hibernate(cs35l45);
+
+	// Don't wait for ACK since bus activity would wake the device
+	regmap_write(cs35l45->regmap, CS35L45_DSP_VIRT1_MBOX_1, CSPL_MBOX_CMD_HIBERNATE);
+
+	return 0;
+}
+
+static int cs35l45_exit_hibernate(struct cs35l45_private *cs35l45)
+{
+	const int wake_retries = 20;
+	const int sleep_retries = 5;
+	int ret, i, j;
+
+	for (i = 0; i < sleep_retries; i++) {
+		dev_dbg(cs35l45->dev, "Exit hibernate\n");
+
+		for (j = 0; j < wake_retries; j++) {
+			ret = cs35l45_set_cspl_mbox_cmd(cs35l45, cs35l45->regmap,
+					  CSPL_MBOX_CMD_OUT_OF_HIBERNATE);
+			if (!ret) {
+				dev_dbg(cs35l45->dev, "Wake success at cycle: %d\n", j);
+				return 0;
+			}
+			usleep_range(100, 200);
+		}
+
+		dev_err(cs35l45->dev, "Wake failed, re-enter hibernate: %d\n", ret);
+
+		cs35l45_setup_hibernate(cs35l45);
+	}
+
+	dev_err(cs35l45->dev, "Timed out waking device\n");
+
+	return -ETIMEDOUT;
+}
+
 static int __maybe_unused cs35l45_runtime_suspend(struct device *dev)
 {
 	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
 
+	if (!cs35l45->dsp.preloaded || !cs35l45->dsp.cs_dsp.running)
+		return 0;
+
+	cs35l45_enter_hibernate(cs35l45);
+
 	regcache_cache_only(cs35l45->regmap, true);
+	regcache_mark_dirty(cs35l45->regmap);
 
 	dev_dbg(cs35l45->dev, "Runtime suspended\n");
 
@@ -760,9 +832,17 @@ static int __maybe_unused cs35l45_runtime_resume(struct device *dev)
 	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
 	int ret;
 
+	if (!cs35l45->dsp.preloaded || !cs35l45->dsp.cs_dsp.running)
+		return 0;
+
 	dev_dbg(cs35l45->dev, "Runtime resume\n");
 
 	regcache_cache_only(cs35l45->regmap, false);
+
+	ret = cs35l45_exit_hibernate(cs35l45);
+	if (ret)
+		return ret;
+
 	ret = regcache_sync(cs35l45->regmap);
 	if (ret != 0)
 		dev_warn(cs35l45->dev, "regcache_sync failed: %d\n", ret);
diff --git a/sound/soc/codecs/cs35l45.h b/sound/soc/codecs/cs35l45.h
index 87032619b341..0da28439f628 100644
--- a/sound/soc/codecs/cs35l45.h
+++ b/sound/soc/codecs/cs35l45.h
@@ -30,6 +30,9 @@
 #define CS35L45_INTB_GPIO2_MCLK_REF		0x00002434
 #define CS35L45_GPIO3				0x00002438
 #define CS35L45_PWRMGT_CTL			0x00002900
+#define CS35L45_WAKESRC_CTL			0x00002904
+#define CS35L45_WKI2C_CTL			0x00002908
+#define CS35L45_PWRMGT_STS			0x0000290C
 #define CS35L45_REFCLK_INPUT			0x00002C04
 #define CS35L45_GLOBAL_SAMPLE_RATE		0x00002C0C
 #define CS35L45_BOOST_CCM_CFG			0x00003808
@@ -348,6 +351,25 @@
 #define CS35L45_POST_GLOBAL_EN_US		5000
 #define CS35L45_PRE_GLOBAL_DIS_US		3000
 
+/* WAKESRC_CTL */
+#define CS35L45_WKSRC_SYNC_GPIO1		BIT(0)
+#define CS35L45_WKSRC_INT_GPIO2			BIT(1)
+#define CS35L45_WKSRC_GPIO3			BIT(2)
+#define CS35L45_WKSRC_SPI			BIT(3)
+#define CS35L45_WKSRC_I2C			BIT(4)
+#define CS35L45_UPDT_WKCTL_SHIFT		15
+#define CS35L45_UPDT_WKCTL_MASK			BIT(15)
+#define CS35L45_WKSRC_EN_SHIFT			8
+#define CS35L45_WKSRC_EN_MASK			GENMASK(12, 8)
+#define CS35L45_WKSRC_POL_SHIFT			0
+#define CS35L45_WKSRC_POL_MASK			GENMASK(3, 0)
+
+/* WAKEI2C_CTL */
+#define CS35L45_UPDT_WKI2C_SHIFT		15
+#define CS35L45_UPDT_WKI2C_MASK			BIT(15)
+#define CS35L45_WKI2C_ADDR_SHIFT		0
+#define CS35L45_WKI2C_ADDR_MASK			GENMASK(6, 0)
+
 #define CS35L45_SPI_MAX_FREQ			4000000
 
 enum cs35l45_cspl_mboxstate {
@@ -369,6 +391,11 @@ enum cs35l45_cspl_mboxcmd {
 	CSPL_MBOX_CMD_INVALID_SEQUENCE = -2,
 };
 
+enum control_bus_type {
+	CONTROL_BUS_I2C = 0,
+	CONTROL_BUS_SPI = 1,
+};
+
 #define CS35L45_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | \
 			 SNDRV_PCM_FMTBIT_S24_3LE| \
 			 SNDRV_PCM_FMTBIT_S24_LE)
@@ -439,6 +466,8 @@ struct cs35l45_private {
 	u8 slot_count;
 	int irq_invert;
 	int irq;
+	unsigned int i2c_addr;
+	enum control_bus_type bus_type;
 	struct regmap_irq_chip_data *irq_data;
 };
 
-- 
2.25.1

