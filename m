Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACA2DC34C;
	Tue,  8 Jul 2025 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992898; cv=none; b=tDxP27SnquNPi4WB21n9uI2YQ6rHgCeb7EeFZ9d8DaPPHogJY/A5s2wbgNEZwvAXpl8ANAPxfSJNCp0O7pYZ/vBOza69BNEnmaRc6/CfNpG4nCX2iqxuIz9PqTRPmJvz2VY1W7Qzt/wopolspwVJKNDByXBn6CT46SoTdqafzeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992898; c=relaxed/simple;
	bh=ctcuUiYQc5GDd4B+RvNZ8nCk7zIoH6bT02oiVDd8ApE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKvW+jf16be/H0bhlaB6+RrQfUB5exGDKgNmLVO1Y/fSzF+a4SBqhB+C4nib/EJA/OXpA5k+vbYonlMLhfohU4vGYKinUkuh8NgRTfGGCBMx4p21C5rqzYoTWgyVk8RAmR9o6WsyI1nUPhIoC4pNmRuRH83OkvAb9C+twmyP8Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtMPmA6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtMPmA6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4550BC4CEED;
	Tue,  8 Jul 2025 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992897;
	bh=ctcuUiYQc5GDd4B+RvNZ8nCk7zIoH6bT02oiVDd8ApE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtMPmA6N/197meso2FVdwjOxF5DUiZt+YbRvcf++mOLeftP259irUMBwXH9vAB6kk
	 I4GXrvSUlo7+vJ1fVtiw+AacqKtGO78myquhBIDeqUUVlUS8Uvz1fzeLe/pyD1O1QL
	 De2TZ0nzvK8VsAr5mu+0OMKvNL4X7C2njuT6S9e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/232] ASoC: tas2764: Extend driver to SN012776
Date: Tue,  8 Jul 2025 18:21:54 +0200
Message-ID: <20250708162244.528147466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit ad18392962df46a858432839cc6bcaf2ede7cc86 ]

SN012776 is a speaker amp chip found in Apple's 2021 laptops. It appears
similar and more-or-less compatible to TAS2764. Extend the TAS2764
driver with some SN012776 specifics and configure the chip assuming
it's in one of the Apple machines.

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250227-apple-codec-changes-v3-3-cbb130030acf@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 592ab3936b09 ("ASoC: tas2764: Reinit cache on part reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 43 +++++++++++++++++++++++++++++++++++---
 sound/soc/codecs/tas2764.h |  3 +++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 4326555aac032..fb34d029f7a6d 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -14,6 +14,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <sound/pcm.h>
@@ -23,6 +24,11 @@
 
 #include "tas2764.h"
 
+enum tas2764_devid {
+	DEVID_TAS2764  = 0,
+	DEVID_SN012776 = 1
+};
+
 struct tas2764_priv {
 	struct snd_soc_component *component;
 	struct gpio_desc *reset_gpio;
@@ -30,7 +36,8 @@ struct tas2764_priv {
 	struct regmap *regmap;
 	struct device *dev;
 	int irq;
-	
+	enum tas2764_devid devid;
+
 	int v_sense_slot;
 	int i_sense_slot;
 
@@ -525,10 +532,16 @@ static struct snd_soc_dai_driver tas2764_dai_driver[] = {
 	},
 };
 
+static uint8_t sn012776_bop_presets[] = {
+	0x01, 0x32, 0x02, 0x22, 0x83, 0x2d, 0x80, 0x02, 0x06,
+	0x32, 0x46, 0x30, 0x02, 0x06, 0x38, 0x40, 0x30, 0x02,
+	0x06, 0x3e, 0x37, 0x30, 0xff, 0xe6
+};
+
 static int tas2764_codec_probe(struct snd_soc_component *component)
 {
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
-	int ret;
+	int ret, i;
 
 	tas2764->component = component;
 
@@ -577,6 +590,27 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	if (ret < 0)
 		return ret;
 
+	switch (tas2764->devid) {
+	case DEVID_SN012776:
+		ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
+					TAS2764_PWR_CTRL_BOP_SRC,
+					TAS2764_PWR_CTRL_BOP_SRC);
+		if (ret < 0)
+			return ret;
+
+		for (i = 0; i < ARRAY_SIZE(sn012776_bop_presets); i++) {
+			ret = snd_soc_component_write(component,
+						TAS2764_BOP_CFG0 + i,
+						sn012776_bop_presets[i]);
+
+			if (ret < 0)
+				return ret;
+		}
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
@@ -708,6 +742,8 @@ static int tas2764_i2c_probe(struct i2c_client *client)
 	if (!tas2764)
 		return -ENOMEM;
 
+	tas2764->devid = (enum tas2764_devid)of_device_get_match_data(&client->dev);
+
 	tas2764->dev = &client->dev;
 	tas2764->irq = client->irq;
 	i2c_set_clientdata(client, tas2764);
@@ -744,7 +780,8 @@ MODULE_DEVICE_TABLE(i2c, tas2764_i2c_id);
 
 #if defined(CONFIG_OF)
 static const struct of_device_id tas2764_of_match[] = {
-	{ .compatible = "ti,tas2764" },
+	{ .compatible = "ti,tas2764",  .data = (void *)DEVID_TAS2764 },
+	{ .compatible = "ti,sn012776", .data = (void *)DEVID_SN012776 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tas2764_of_match);
diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 9490f2686e389..69c0f91cb4239 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -29,6 +29,7 @@
 #define TAS2764_PWR_CTRL_ACTIVE		0x0
 #define TAS2764_PWR_CTRL_MUTE		BIT(0)
 #define TAS2764_PWR_CTRL_SHUTDOWN	BIT(1)
+#define TAS2764_PWR_CTRL_BOP_SRC	BIT(7)
 
 #define TAS2764_VSENSE_POWER_EN		3
 #define TAS2764_ISENSE_POWER_EN		4
@@ -116,4 +117,6 @@
 #define TAS2764_INT_CLK_CFG             TAS2764_REG(0x0, 0x5c)
 #define TAS2764_INT_CLK_CFG_IRQZ_CLR    BIT(2)
 
+#define TAS2764_BOP_CFG0                TAS2764_REG(0X0, 0x1d)
+
 #endif /* __TAS2764__ */
-- 
2.39.5



