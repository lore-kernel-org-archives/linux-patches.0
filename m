Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CB62550AD
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 12:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704507; cv=none; b=BCWA0sG3j3dyedhxw2EwAiiefEFOF61ruzyBGprQNfnOI/LTS5PP4Vhuvxg+vUOJrmnWYPY01TAV34+xw9Jw/zu0mUCvuWrZKRstz8UpdVxVmUBx6SJTpZhp2VaMz1DZ8ADpnkJ/rL0spiEkxysCLq5dMkv7ClS7nsVWD4W+B6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704507; c=relaxed/simple;
	bh=LKAidaA/R1YNE/9jhKq5TzVdVKa/sEyHhmUWW1QBB44=;
	h=From:To:CC:Date:Message-ID:MIME-Version:Content-Type:Subject; b=CmZZAl/tLyPgMNCv2cwIhT2+ZMrsIcMWCSyDTCcwMsz3ISV3Dwp4Y7BRSgwxzewDU5SCN90WZ6gNmGvzOjq6HUQbuXwAzoAK/GRAcX7Nf2O38dqgeBUG1VFK0ERTRzE8Zr3EwfVXMtBttvYIHGVY9tb5FGkX018Lm7PI1S304RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GqSdFGUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GqSdFGUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E2DC4CEE7
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 12:35:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GqSdFGUl"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 17 Oct 2025 13:35:02 +0100
Resent-Message-ID: <aPI39sdt9VBdJO0U@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 15 Oct 2025 11:35:23 +0100
Received: from tor.source.kernel.org ([2600:3c04:e001:324:0:1991:8:25])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=XNYv=4Y=realtek.com=oder_chiou@kernel.org>)
	id 1v8yqm-002SB0-P6
	for broonie@sirena.co.uk; Wed, 15 Oct 2025 11:35:23 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 947596258A
	for <broonie@sirena.co.uk>; Wed, 15 Oct 2025 10:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 60844C116C6; Wed, 15 Oct 2025 10:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E677C4CEFE
	for <broonie@kernel.org>; Wed, 15 Oct 2025 10:35:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 7E677C4CEFE
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=realtek.com
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 59FAYmrQ6782517, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1760524488; bh=QtWUabSW/AUDa9XT7eb54nrrlOXRfQhLgvhWF9uTjq4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=GqSdFGUlMsRV49sORMqHC+/smymRDk9UZiUMKnS0ZMo8fab6UAlnKeYentgGHptR0
	 jT3cLlCrdMgIBirlimAKKe0/PQlqoQKsQdh+xNp/4TTw8YfVnBEJTDx+BcaQzD0fiA
	 FxQ0imlIF+OcPqaxYQOItUsUdCOGyexvMOhQvAEOVHXvme8bFT+/UU1F281XaTIWQy
	 mrVC5eUdhVzwRjagFNLPcGGVgUK2su9Hd2sFgZJhJAoDY0BuaAEzGFwcfKrkYp+bHP
	 T61yU7ezsY4ZAGcfelGOt79I6ByBPlNjiW82XmL4EJEYmf4L01X4e26390v3Djhmjf
	 QdjtucapvarMA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.13/5.93) with ESMTPS id 59FAYmrQ6782517
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 18:34:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.27; Wed, 15 Oct 2025 18:34:49 +0800
Received: from sw-server.localdomain (172.24.54.4) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.27; Wed, 15 Oct 2025 18:34:49 +0800
From: Oder Chiou <oder_chiou@realtek.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <flove@realtek.com>, <shumingf@realtek.com>,
        <jack.yu@realtek.com>, <derek.fang@realtek.com>,
        "Oder Chiou" <oder_chiou@realtek.com>
Date: Wed, 15 Oct 2025 18:34:03 +0800
Message-ID: <20251015103404.3075684-1-oder_chiou@realtek.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTKEXHMBS06.realtek.com.tw (10.21.1.56)
X-SA-Exim-Connect-IP: 2600:3c04:e001:324:0:1991:8:25
X-SA-Exim-Mail-From: SRS0=XNYv=4Y=realtek.com=oder_chiou@kernel.org
Subject: [PATCH v5 1/2] ASoC: rt5575: Add the codec driver for the ALC5575
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: svRKEFooey4S

This codec driver is for the ALC5575 that has a built-in audio DSP. The
firmware can be loaded by the SPI from the SOC or the external flash.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
---
 sound/soc/codecs/Kconfig      |   9 +
 sound/soc/codecs/Makefile     |   4 +
 sound/soc/codecs/rt5575-spi.c | 110 +++++++++
 sound/soc/codecs/rt5575-spi.h |  37 +++
 sound/soc/codecs/rt5575.c     | 421 ++++++++++++++++++++++++++++++++++
 sound/soc/codecs/rt5575.h     |  58 +++++
 6 files changed, 639 insertions(+)
 create mode 100644 sound/soc/codecs/rt5575-spi.c
 create mode 100644 sound/soc/codecs/rt5575-spi.h
 create mode 100644 sound/soc/codecs/rt5575.c
 create mode 100644 sound/soc/codecs/rt5575.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 18131144ebbd..4c8f61a610a6 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -210,6 +210,7 @@ config SND_SOC_ALL_CODECS
 	imply SND_SOC_RT1305
 	imply SND_SOC_RT1308
 	imply SND_SOC_RT5514
+	imply SND_SOC_RT5575
 	imply SND_SOC_RT5616
 	imply SND_SOC_RT5631
 	imply SND_SOC_RT5640
@@ -1739,6 +1740,14 @@ config SND_SOC_RT5514_SPI_BUILTIN
 	bool # force RT5514_SPI to be built-in to avoid link errors
 	default SND_SOC_RT5514=y && SND_SOC_RT5514_SPI=m
 
+config SND_SOC_RT5575
+	tristate
+	depends on I2C
+
+config SND_SOC_RT5575_SPI
+	tristate
+	depends on SPI_MASTER
+
 config SND_SOC_RT5616
 	tristate "Realtek RT5616 CODEC"
 	depends on I2C
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index bd95a7c911d5..2317b830b79a 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -251,6 +251,8 @@ snd-soc-rt286-y := rt286.o
 snd-soc-rt298-y := rt298.o
 snd-soc-rt5514-y := rt5514.o
 snd-soc-rt5514-spi-y := rt5514-spi.o
+snd-soc-rt5575-y := rt5575.o
+snd-soc-rt5575-spi-y := rt5575-spi.o
 snd-soc-rt5616-y := rt5616.o
 snd-soc-rt5631-y := rt5631.o
 snd-soc-rt5640-y := rt5640.o
@@ -682,6 +684,8 @@ obj-$(CONFIG_SND_SOC_RT298)	+= snd-soc-rt298.o
 obj-$(CONFIG_SND_SOC_RT5514)	+= snd-soc-rt5514.o
 obj-$(CONFIG_SND_SOC_RT5514_SPI)	+= snd-soc-rt5514-spi.o
 obj-$(CONFIG_SND_SOC_RT5514_SPI_BUILTIN)	+= snd-soc-rt5514-spi.o
+obj-$(CONFIG_SND_SOC_RT5575)	+= snd-soc-rt5575.o
+obj-$(CONFIG_SND_SOC_RT5575_SPI)	+= snd-soc-rt5575-spi.o
 obj-$(CONFIG_SND_SOC_RT5616)	+= snd-soc-rt5616.o
 obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
 obj-$(CONFIG_SND_SOC_RT5640)	+= snd-soc-rt5640.o
diff --git a/sound/soc/codecs/rt5575-spi.c b/sound/soc/codecs/rt5575-spi.c
new file mode 100644
index 000000000000..54c23c2d9c34
--- /dev/null
+++ b/sound/soc/codecs/rt5575-spi.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * rt5575-spi.c  --  ALC5575 SPI driver
+ *
+ * Copyright 2022 Realtek Semiconductor Corp.
+ * Author: Oder Chiou <oder_chiou@realtek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/spi/spi.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/regulator/consumer.h>
+#include <linux/pm_qos.h>
+#include <linux/sysfs.h>
+#include <linux/clk.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+#include <sound/tlv.h>
+
+#include "rt5575-spi.h"
+
+static struct spi_device *rt5575_spi;
+
+/**
+ * rt5575_spi_burst_write - Write data to SPI by rt5575 address.
+ * @addr: Start address.
+ * @txbuf: Data Buffer for writng.
+ * @len: Data length.
+ *
+ *
+ * Returns true for success.
+ */
+int rt5575_spi_burst_write(u32 addr, const u8 *txbuf, size_t len)
+{
+	u8 spi_cmd = RT5575_SPI_CMD_BURST_WRITE;
+	u8 *write_buf;
+	unsigned int end, offset = 0;
+
+	write_buf = kmalloc(RT5575_SPI_BUF_LEN + 6, GFP_KERNEL);
+
+	while (offset < len) {
+		if (offset + RT5575_SPI_BUF_LEN <= len)
+			end = RT5575_SPI_BUF_LEN;
+		else
+			end = len % RT5575_SPI_BUF_LEN;
+
+		write_buf[0] = spi_cmd;
+		write_buf[1] = ((addr + offset) & 0x000000ff) >> 0;
+		write_buf[2] = ((addr + offset) & 0x0000ff00) >> 8;
+		write_buf[3] = ((addr + offset) & 0x00ff0000) >> 16;
+		write_buf[4] = ((addr + offset) & 0xff000000) >> 24;
+
+		memcpy(&write_buf[5], &txbuf[offset], end);
+
+		if (end % 8)
+			end = (end / 8 + 1) * 8;
+
+		spi_write(rt5575_spi, write_buf, end + 6);
+
+		offset += RT5575_SPI_BUF_LEN;
+	}
+
+	kfree(write_buf);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt5575_spi_burst_write);
+
+static int rt5575_spi_probe(struct spi_device *spi)
+{
+	rt5575_spi = spi;
+
+	return 0;
+}
+
+static const struct of_device_id rt5575_of_match[] = {
+	{ .compatible = "realtek,rt5575", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rt5575_of_match);
+
+static struct spi_driver rt5575_spi_driver = {
+	.driver = {
+		.name = "rt5575",
+		.of_match_table = of_match_ptr(rt5575_of_match),
+	},
+	.probe = rt5575_spi_probe,
+};
+module_spi_driver(rt5575_spi_driver);
+
+MODULE_DESCRIPTION("ALC5575 SPI driver");
+MODULE_AUTHOR("Oder Chiou <oder_chiou@realtek.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/rt5575-spi.h b/sound/soc/codecs/rt5575-spi.h
new file mode 100644
index 000000000000..59ac348b101f
--- /dev/null
+++ b/sound/soc/codecs/rt5575-spi.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * rt5575-spi.h  --  ALC5575 SPI driver
+ *
+ * Copyright 2022 Realtek Semiconductor Corp.
+ * Author: Oder Chiou <oder_chiou@realtek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __RT5575_SPI_H__
+#define __RT5575_SPI_H__
+
+#define RT5575_SPI_BUF_LEN		240
+
+/* SPI Command */
+enum {
+	RT5575_SPI_CMD_16_READ = 0,
+	RT5575_SPI_CMD_16_WRITE,
+	RT5575_SPI_CMD_32_READ,
+	RT5575_SPI_CMD_32_WRITE,
+	RT5575_SPI_CMD_BURST_READ,
+	RT5575_SPI_CMD_BURST_WRITE,
+};
+
+#if IS_ENABLED(CONFIG_SND_SOC_RT5575_SPI)
+int rt5575_spi_burst_write(u32 addr, const u8 *txbuf, size_t len);
+#else
+static inline int rt5575_spi_burst_write(u32 addr, const u8 *txbuf, size_t len)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* __RT5575_SPI_H__ */
diff --git a/sound/soc/codecs/rt5575.c b/sound/soc/codecs/rt5575.c
new file mode 100644
index 000000000000..0444a3a0a890
--- /dev/null
+++ b/sound/soc/codecs/rt5575.c
@@ -0,0 +1,421 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * rt5575.c  --  ALC5575 ALSA SoC audio component driver
+ *
+ * Copyright 2022 Realtek Semiconductor Corp.
+ * Author: Oder Chiou <oder_chiou@realtek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/regmap.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/firmware.h>
+#include <linux/property.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+#include <sound/tlv.h>
+
+#include "rt5575.h"
+#include "rt5575-spi.h"
+
+static bool rt5575_readable_register(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case RT5575_ID:
+	case RT5575_ID_1:
+	case RT5575_MIXL_VOL:
+	case RT5575_MIXR_VOL:
+	case RT5575_PROMPT_VOL:
+	case RT5575_SPK01_VOL:
+	case RT5575_SPK23_VOL:
+	case RT5575_MIC1_VOL:
+	case RT5575_MIC2_VOL:
+	case RT5575_WNC_CTRL:
+	case RT5575_MODE_CTRL:
+	case RT5575_I2S_RATE_CTRL:
+	case RT5575_SLEEP_CTRL:
+	case RT5575_ALG_BYPASS_CTRL:
+	case RT5575_PINMUX_CTRL_2:
+	case RT5575_GPIO_CTRL_1:
+	case RT5575_DSP_BUS_CTRL:
+	case RT5575_SW_INT:
+	case RT5575_DSP_BOOT_ERR:
+	case RT5575_DSP_READY:
+	case RT5575_DSP_CMD_ADDR:
+	case RT5575_EFUSE_DATA_2:
+	case RT5575_EFUSE_DATA_3:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const DECLARE_TLV_DB_SCALE(ob_tlv, -9525, 75, 0);
+
+#if IS_ENABLED(CONFIG_SND_SOC_RT5575_SPI)
+static int rt5575_spi_fw_run_get(struct snd_kcontrol *kcontrol,
+		struct snd_ctl_elem_value *ucontrol)
+{
+	return 0;
+}
+
+static int rt5575_spi_fw_run_put(struct snd_kcontrol *kcontrol,
+		struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
+	struct rt5575_priv *rt5575 = snd_soc_component_get_drvdata(component);
+	const struct firmware *firmware;
+	int i, ret;
+
+	if (!ucontrol->value.bytes.data[0])
+		return 0;
+
+	regmap_write(rt5575->dsp_regmap, 0xfafafafa, 0x00000004);
+	regmap_write(rt5575->dsp_regmap, 0x18008064, 0x00000000);
+	regmap_write(rt5575->dsp_regmap, 0x18008068, 0x0002ffff);
+
+	ret = request_firmware(&firmware, "realtek/rt5575/0x70000000.dat",
+		component->dev);
+	if (ret == 0) {
+		rt5575_spi_burst_write(0x5f400000, firmware->data,
+			firmware->size);
+		release_firmware(firmware);
+	}
+
+	ret = request_firmware(&firmware, "realtek/rt5575/0x70200000.dat",
+		component->dev);
+	if (ret == 0) {
+		rt5575_spi_burst_write(0x5f600000, firmware->data,
+			firmware->size);
+		release_firmware(firmware);
+	}
+
+	ret = request_firmware(&firmware, "realtek/rt5575/0x703fe000.dat",
+		component->dev);
+	if (ret == 0) {
+		rt5575_spi_burst_write(0x5f7fe000, firmware->data,
+			firmware->size);
+		release_firmware(firmware);
+	}
+
+	ret = request_firmware(&firmware, "realtek/rt5575/0x703ff000.dat",
+		component->dev);
+	if (ret == 0) {
+		rt5575_spi_burst_write(0x5f7ff000, firmware->data,
+			firmware->size);
+		release_firmware(firmware);
+	}
+
+	regmap_write(rt5575->dsp_regmap, 0x18000000, 0x00000000);
+
+	regmap_update_bits(rt5575->regmap, RT5575_SW_INT, 1, 1);
+
+	ret = 1;
+	for (i = 0; i < 100 && ret; i++) {
+		regmap_read(rt5575->regmap, RT5575_SW_INT, &ret);
+		msleep(100);
+	}
+
+	if (ret) {
+		dev_err(component->dev, "Firmware failure\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#endif
+
+static const struct snd_kcontrol_new rt5575_snd_controls[] = {
+	SOC_DOUBLE("Speaker01 Playback Switch", RT5575_SPK01_VOL, 31, 15, 1, 1),
+	SOC_DOUBLE_TLV("Speaker01 Playback Volume", RT5575_SPK01_VOL, 17, 1,
+		167, 0, ob_tlv),
+	SOC_DOUBLE("Speaker23 Playback Switch", RT5575_SPK23_VOL, 31, 15, 1, 1),
+	SOC_DOUBLE_TLV("Speaker23 Playback Volume", RT5575_SPK23_VOL, 17, 1,
+		167, 0, ob_tlv),
+	SOC_DOUBLE("Mic1 Capture Switch", RT5575_MIC1_VOL, 31, 15, 1, 1),
+	SOC_DOUBLE_TLV("Mic1 Capture Volume", RT5575_MIC1_VOL, 17, 1, 167,
+		0, ob_tlv),
+	SOC_DOUBLE("Mic2 Capture Switch", RT5575_MIC2_VOL, 31, 15, 1, 1),
+	SOC_DOUBLE_TLV("Mic2 Capture Volume", RT5575_MIC2_VOL, 17, 1, 167,
+		0, ob_tlv),
+	SOC_DOUBLE_R("Mix Playback Switch", RT5575_MIXL_VOL, RT5575_MIXR_VOL,
+		31, 1, 1),
+	SOC_DOUBLE_R_TLV("Mix Playback Volume", RT5575_MIXL_VOL,
+		RT5575_MIXR_VOL, 1, 127, 0, ob_tlv),
+	SOC_DOUBLE("Prompt Playback Switch", RT5575_PROMPT_VOL, 31, 15, 1, 1),
+	SOC_DOUBLE_TLV("Prompt Playback Volume", RT5575_PROMPT_VOL, 17, 1, 167,
+		0, ob_tlv),
+#if IS_ENABLED(CONFIG_SND_SOC_RT5575_SPI)
+	SND_SOC_BYTES_EXT("SPI FW run", 1, rt5575_spi_fw_run_get,
+		rt5575_spi_fw_run_put),
+#endif
+};
+
+static const struct snd_soc_dapm_widget rt5575_dapm_widgets[] = {
+	SND_SOC_DAPM_AIF_IN("AIF1RX", "AIF1 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("AIF1TX", "AIF1 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("AIF2RX", "AIF2 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("AIF2TX", "AIF2 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("AIF3RX", "AIF3 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("AIF3TX", "AIF3 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("AIF4RX", "AIF4 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("AIF4TX", "AIF4 Capture", 0, SND_SOC_NOPM, 0, 0),
+
+	SND_SOC_DAPM_INPUT("INPUT"),
+	SND_SOC_DAPM_OUTPUT("OUTPUT"),
+};
+
+static const struct snd_soc_dapm_route rt5575_dapm_routes[] = {
+	{ "AIF1TX", NULL, "INPUT" },
+	{ "AIF2TX", NULL, "INPUT" },
+	{ "AIF3TX", NULL, "INPUT" },
+	{ "AIF4TX", NULL, "INPUT" },
+	{ "OUTPUT", NULL, "AIF1RX" },
+	{ "OUTPUT", NULL, "AIF2RX" },
+	{ "OUTPUT", NULL, "AIF3RX" },
+	{ "OUTPUT", NULL, "AIF4RX" },
+};
+
+static long long rt5575_getuuid(struct rt5575_priv *rt5575)
+{
+	int efuse_uuid_low, efuse_uuid_high;
+
+	regmap_write(rt5575->regmap, RT5575_EFUSE_PID, 0xa0000000);
+	regmap_read(rt5575->regmap, RT5575_EFUSE_DATA_2, &efuse_uuid_low);
+	regmap_read(rt5575->regmap, RT5575_EFUSE_DATA_3, &efuse_uuid_high);
+	regmap_write(rt5575->regmap, RT5575_EFUSE_PID, 0);
+
+	return ((long long)efuse_uuid_high << 32) | (long long)efuse_uuid_low;
+}
+
+static int rt5575_probe(struct snd_soc_component *component)
+{
+	struct rt5575_priv *rt5575 = snd_soc_component_get_drvdata(component);
+
+	rt5575->component = component;
+
+	dev_info(component->dev, "UUID: %llx\n", rt5575_getuuid(rt5575));
+
+	return 0;
+}
+
+#define RT5575_STEREO_RATES SNDRV_PCM_RATE_8000_192000
+#define RT5575_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE | \
+			SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S8 | \
+			SNDRV_PCM_FMTBIT_S32_LE)
+
+static struct snd_soc_dai_driver rt5575_dai[] = {
+	{
+		.name = "rt5575-aif1",
+		.id = RT5575_AIF1,
+		.playback = {
+			.stream_name = "AIF1 Playback",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+		.capture = {
+			.stream_name = "AIF1 Capture",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+	},
+	{
+		.name = "rt5575-aif2",
+		.id = RT5575_AIF2,
+		.playback = {
+			.stream_name = "AIF2 Playback",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+		.capture = {
+			.stream_name = "AIF2 Capture",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+	},
+	{
+		.name = "rt5575-aif3",
+		.id = RT5575_AIF3,
+		.playback = {
+			.stream_name = "AIF3 Playback",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+		.capture = {
+			.stream_name = "AIF3 Capture",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+	},
+	{
+		.name = "rt5575-aif4",
+		.id = RT5575_AIF4,
+		.playback = {
+			.stream_name = "AIF4 Playback",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+		.capture = {
+			.stream_name = "AIF4 Capture",
+			.channels_min = 1,
+			.channels_max = 8,
+			.rates = RT5575_STEREO_RATES,
+			.formats = RT5575_FORMATS,
+		},
+	},
+};
+
+const struct snd_soc_component_driver rt5575_soc_component_dev = {
+	.probe = rt5575_probe,
+	.controls = rt5575_snd_controls,
+	.num_controls = ARRAY_SIZE(rt5575_snd_controls),
+	.dapm_widgets = rt5575_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(rt5575_dapm_widgets),
+	.dapm_routes = rt5575_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(rt5575_dapm_routes),
+	.use_pmdown_time = 1,
+	.endianness = 1,
+};
+
+static const struct regmap_config rt5575_dsp_regmap = {
+	.name = "dsp",
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 2,
+};
+
+static int rt5575_i2c_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct i2c_client *client = context;
+	struct rt5575_priv *rt5575 = i2c_get_clientdata(client);
+
+	regmap_read(rt5575->dsp_regmap, reg | RT5575_DSP_MAPPING, val);
+
+	return 0;
+}
+
+static int rt5575_i2c_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct i2c_client *client = context;
+	struct rt5575_priv *rt5575 = i2c_get_clientdata(client);
+
+	regmap_write(rt5575->dsp_regmap, reg | RT5575_DSP_MAPPING, val);
+
+	return 0;
+}
+
+static const struct regmap_config rt5575_regmap = {
+	.reg_bits = 16,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.max_register = 0xfffc,
+	.readable_reg = rt5575_readable_register,
+	.reg_read = rt5575_i2c_read,
+	.reg_write = rt5575_i2c_write,
+	.use_single_read = true,
+	.use_single_write = true,
+};
+
+static const struct i2c_device_id rt5575_i2c_id[] = {
+	{ "rt5575", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rt5575_i2c_id);
+
+static int rt5575_i2c_probe(struct i2c_client *i2c)
+{
+	struct rt5575_priv *rt5575;
+	int ret, val;
+
+	rt5575 = devm_kzalloc(&i2c->dev, sizeof(struct rt5575_priv),
+				GFP_KERNEL);
+	if (rt5575 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, rt5575);
+
+	rt5575->i2c = i2c;
+
+	rt5575->dsp_regmap = devm_regmap_init_i2c(i2c, &rt5575_dsp_regmap);
+	if (IS_ERR(rt5575->dsp_regmap)) {
+		ret = PTR_ERR(rt5575->dsp_regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	rt5575->regmap = devm_regmap_init(&i2c->dev, NULL, i2c, &rt5575_regmap);
+	if (IS_ERR(rt5575->regmap)) {
+		ret = PTR_ERR(rt5575->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	regmap_read(rt5575->regmap, RT5575_ID, &val);
+	if (val != RT5575_DEVICE_ID) {
+		dev_err(&i2c->dev,
+			"Device with ID register %08x is not rt5575\n", val);
+		return -ENODEV;
+	}
+
+	regmap_read(rt5575->regmap, RT5575_ID_1, &val);
+	if (!val) {
+		dev_err(&i2c->dev, "This is not formal version\n");
+		return -ENODEV;
+	}
+
+	return devm_snd_soc_register_component(&i2c->dev, &rt5575_soc_component_dev,
+				      rt5575_dai, ARRAY_SIZE(rt5575_dai));
+}
+
+static const struct of_device_id rt5575_of_match[] = {
+	{.compatible = "realtek,rt5575"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, rt5575_of_match);
+
+static struct i2c_driver rt5575_i2c_driver = {
+	.driver = {
+		.name = "rt5575",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(rt5575_of_match),
+	},
+	.probe = rt5575_i2c_probe,
+	.id_table = rt5575_i2c_id,
+};
+module_i2c_driver(rt5575_i2c_driver);
+
+MODULE_DESCRIPTION("ASoC ALC5575 driver");
+MODULE_AUTHOR("Oder Chiou <oder_chiou@realtek.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/rt5575.h b/sound/soc/codecs/rt5575.h
new file mode 100644
index 000000000000..3203b1653573
--- /dev/null
+++ b/sound/soc/codecs/rt5575.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * rt5575.h  --  ALC5575 ALSA SoC audio driver
+ *
+ * Copyright 2022 Realtek Semiconductor Corp.
+ * Author: Oder Chiou <oder_chiou@realtek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __RT5575_H__
+#define __RT5575_H__
+
+#define RT5575_DEVICE_ID	0x10ec5575
+#define RT5575_DSP_MAPPING	0x18000000
+
+#define RT5575_ID		0x8008
+#define RT5575_ID_1		0x800c
+#define RT5575_MIXL_VOL		0x8a14
+#define RT5575_MIXR_VOL		0x8a18
+#define RT5575_PROMPT_VOL	0x8a84
+#define RT5575_SPK01_VOL	0x8a88
+#define RT5575_SPK23_VOL	0x8a8c
+#define RT5575_MIC1_VOL		0x8a98
+#define RT5575_MIC2_VOL		0x8a9c
+#define RT5575_WNC_CTRL		0x80ec
+#define RT5575_MODE_CTRL	0x80f0
+#define RT5575_I2S_RATE_CTRL	0x80f4
+#define RT5575_SLEEP_CTRL	0x80f8
+#define RT5575_ALG_BYPASS_CTRL	0x80fc
+#define RT5575_PINMUX_CTRL_2	0x81a4
+#define RT5575_GPIO_CTRL_1	0x8208
+#define RT5575_DSP_BUS_CTRL	0x880c
+#define RT5575_SW_INT		0x0018
+#define RT5575_DSP_BOOT_ERR	0x8e14
+#define RT5575_DSP_READY	0x8e24
+#define RT5575_DSP_CMD_ADDR	0x8e28
+#define RT5575_EFUSE_DATA_2	0xc638
+#define RT5575_EFUSE_DATA_3	0xc63c
+#define RT5575_EFUSE_PID	0xc660
+
+enum {
+	RT5575_AIF1,
+	RT5575_AIF2,
+	RT5575_AIF3,
+	RT5575_AIF4,
+	RT5575_AIFS,
+};
+
+struct rt5575_priv {
+	struct i2c_client *i2c;
+	struct snd_soc_component *component;
+	struct regmap *dsp_regmap, *regmap;
+};
+
+#endif /* __RT5575_H__ */
-- 
2.34.1

