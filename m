Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBFC3BCD3A
	for <patches@lists.linux.dev>; Wed, 20 May 2026 10:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779272817; cv=pass; b=fzWR+XPSw7OxBTwlcoaglhHJ25NwoFsSrJGe7BF0BrvhswCK2HezfYVCR6OoC0bcJbk697ixH1U/OFm3gVK/DdFxtxlYopJxbSdMvayMYuDcjsyw+14n7I2TcDHhdTe3R6BMQ6PKb5Nc1/XLR8GEFprBKMqGhuLAe3XxYRS9ZAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779272817; c=relaxed/simple;
	bh=Rk2XR8g22hN/t/d2G+pezcGNeXW4ZJGQjTEI7/QxJ8k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ld7ApjbBNzQQoNXXU3h96vfMd8LdDmnLu/AU5CNC1s0AmbFBKcDDMQ9llVjw3wXzDZv41afvpZZyUBRiKBIYXCGTKE182vwab2ZaGI0oQCkPyDHceu17QuqgQseSs1Ww/ZD5Z3ET/kDDb9R2knIFKEPX54eM2OPpaaOK1EAWDuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cllX8yWJ; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cllX8yWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B618C1F000E9
	for <patches@lists.linux.dev>; Wed, 20 May 2026 10:26:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=cllX8yWJ
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 20 May 2026 11:26:43 +0100
Resent-Message-ID: <ag2MYw3C-wmLsJZr@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id EF611200DD
	for <broonie@sirena.co.uk>; Wed, 20 May 2026 05:32:54 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEC1D60120
	for <broonie@sirena.co.uk>; Wed, 20 May 2026 05:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id ACE6E1F00893; Wed, 20 May 2026 05:32:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1779255173;
	b=oSxMX/4JKpFr3fN375y3Py/rvi0V7WMpSj0RFP+YBE4LHhBse6llZErGJcb3n836HsdA
	 fpm5vGgBRpc3cLTf4e0Pv00F9PGeWseo2zTTtjqb1wQdYMlI18fEYpkD/C2NOBB5DnWZZ
	 qWI35CBPRoBWLkzDji5pKgVzL9muVGOjOiMINZoR5pX5a99iByGsNxhXcR46IzLN11v6u
	 6IaUqqJkcYkiuKBb3k3GPjHIOYOtOFXH4wottT8VwAKnHucoSXMZWsxsFpxW+fyMPxTuh
	 7BUZR49BC3oo+WBNMDU9lu3ndvD1vVzur7RESqkrTET1Yk/98lTWi84YlIwP4UHSx5g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1779255173;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	bh=B2ZYvF4ymwNN6f1KYAnu/6LBZ9Nr2SSPD9i7o2i02+w=;
	b=D47uzhKXRoVz1q1evMHeqeGXO9uDXsLNwZSDhcRJI/AIHdvXz2JYxk4C41ahBuaUvNwh
	 SbqccqpgoKZjAivXGgnwNst4J5U314oi/p64dEtOPCbM4JPU8XIKbJlyFSBbmiSLxBTqU
	 TxEF3Mg3b1WMjw4JXi+qKT2Vtufcq8gz8AKDv5ylz5liz7qG/jhpx8th82MKueV4jxZNo
	 hoxuqmmPPGwEqu0XxDG7WcmLrCjBExTLF4HGOdmV4IcpsEfe1BcldmqCNpFuWE+SN4uz5
	 UaKs8c+6UWobR4Ndsha+rV4fCAk16TIFAKsLASOVjBQXrrM22sqfJ+fuhdUs/HUnXrA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=cllX8yWJ;
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	arc=none smtp.remote-ip=211.75.126.72
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EDE61F000E9
	for <broonie@kernel.org>; Wed, 20 May 2026 05:32:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 2EDE61F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=realtek.com
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64K5WlEF24006303, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1779255167; bh=B2ZYvF4ymwNN6f1KYAnu/6LBZ9Nr2SSPD9i7o2i02+w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=cllX8yWJAiPmRI1rSxsAoXg7BlYgpnxJoQiGyKhl+81rEYVZUAOmTMWGCWFzeFJ+l
	 8cGK6LfWuEbgdWLnLNPLY+evNSLL1jQoQHdQsoz6HPiwTFe4kcpV2aG4IYgfuvQB7g
	 PUosZei2rBUH469moxW9tZfvs1sUmgmgCg6yYxKmISY6fompA5BiRXigvSk2EHUrl7
	 kLuAIelTIVTG3U16xY5Sz5FJFafWVxRDo2MdapwI5EcfQnnbFyU6HqHJYlzKRm7dc0
	 bNwE4Zfk2B9uIlam8srfzckHXUWrip+60qpNvers8ub71GMStUhqAl9R22WSoQmeo+
	 DLeBEpmGiYjOA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 64K5WlEF24006303
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 13:32:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 May 2026 13:32:47 +0800
Received: from sw-server.localdomain (172.24.54.4) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server id
 15.2.2562.17 via Frontend Transport; Wed, 20 May 2026 13:32:47 +0800
From: <jack.yu@realtek.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <lars@metafoo.de>, <flove@realtek.com>,
        <oder_chiou@realtek.com>, <shumingf@realtek.com>,
        <derek.fang@realtek.com>, Jack Yu <jack.yu@realtek.com>
Subject: [PATCH v4] ASoC: rt722-sdca: Add a control to support CAE firmware update
Date: Wed, 20 May 2026 13:32:43 +0800
Message-ID: <20260520053243.3645180-1-jack.yu@realtek.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Jack Yu <jack.yu@realtek.com>

Realtek CAE requires specific tuning parameters based on
the system vendor and SKU.
This patch adds a kcontrol to trigger the firmware loading process.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
---
Changes in v4:
- Fix -Wframe-larger-than warning by using kasprintf()
  and removing large stack buffers.
- Prevent integer overflow in firmware bounds checking.
- Add payload size validation (size > 0).
- Fix PM reference leak in the error path of rt722_cae_update_put().

Changes in v3:
- Remove test robot tags from commit message.
- Add boundary checks during firmware parsing to prevent out-of-bounds reads.

Changes in v2:
- Fix the build error caught by kernel test robot. Replace the non-existent
  snd_soc_component_get_bias_level() with snd_soc_dapm_get_bias_level().
---
 sound/soc/codecs/rt722-sdca-sdw.c |  39 +++-
 sound/soc/codecs/rt722-sdca.c     | 292 +++++++++++++++++++++++++++++-
 sound/soc/codecs/rt722-sdca.h     |  23 +++
 3 files changed, 346 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index a5feba3d0c18..0f76492ff915 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -19,7 +19,9 @@
 static int rt722_sdca_mbq_size(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case 0x2f01 ... 0x2f0a:
+	case 0x22f0 ... 0x22f1:
+	case 0x2f01 ... 0x2f0c:
+	case 0x2f21 ... 0x2f24:
 	case 0x2f35 ... 0x2f36:
 	case 0x2f50 ... 0x2f52:
 	case 0x2f54:
@@ -84,6 +86,21 @@ static int rt722_sdca_mbq_size(struct device *dev, unsigned int reg)
 	case SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_CS31,
 			  RT722_SDCA_CTL_SAMPLE_FREQ_INDEX, 0):
 	case RT722_BUF_ADDR_HID1 ... RT722_BUF_ADDR_HID2:
+	case 0x44011000 ... 0x440115ff:
+	case 0x44012000:
+	case 0x44012021:
+	case 0x44012022:
+	case 0x44012025:
+	case 0x44021000 ... 0x440211ff:
+	case 0x44022000:
+	case 0x44022019:
+	case 0x4402201a:
+	case 0x4402201d:
+	case 0x44041000 ... 0x440415ff:
+	case 0x44042000:
+	case 0x44042019:
+	case 0x4404201a:
+	case 0x4404201d:
 		return 1;
 	case 0x2000000 ... 0x2000024:
 	case 0x2000029 ... 0x200004a:
@@ -95,8 +112,10 @@ static int rt722_sdca_mbq_size(struct device *dev, unsigned int reg)
 	case 0x200007f:
 	case 0x2000082 ... 0x200008e:
 	case 0x2000090 ... 0x2000094:
+	case 0x20000b1:
+	case 0x20000b4:
 	case 0x3110000:
-	case 0x5300000 ... 0x5300002:
+	case 0x5300000 ... 0x5300300:
 	case 0x5400002:
 	case 0x5600000 ... 0x5600007:
 	case 0x5700000 ... 0x5700004:
@@ -175,6 +194,7 @@ static bool rt722_sdca_volatile_register(struct device *dev, unsigned int reg)
 	case SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_PDE23, RT722_SDCA_CTL_ACTUAL_POWER_STATE, 0):
 	case RT722_BUF_ADDR_HID1 ... RT722_BUF_ADDR_HID2:
 	case 0x2000000:
+	case 0x2000007:
 	case 0x200000d:
 	case 0x2000019:
 	case 0x2000020:
@@ -186,6 +206,21 @@ static bool rt722_sdca_volatile_register(struct device *dev, unsigned int reg)
 	case 0x3110000:
 	case 0x5800003:
 	case 0x5810000:
+	case 0x44011000 ... 0x440115ff:
+	case 0x44012000:
+	case 0x44012021:
+	case 0x44012022:
+	case 0x44012025:
+	case 0x44021000 ... 0x440211ff:
+	case 0x44022000:
+	case 0x44022019:
+	case 0x4402201a:
+	case 0x4402201d:
+	case 0x44041000 ... 0x440415ff:
+	case 0x44042000:
+	case 0x44042019:
+	case 0x4404201a:
+	case 0x4404201d:
 		return true;
 	default:
 		return false;
diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index 23d2f63d68ef..1b6729f363fc 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -7,19 +7,21 @@
 //
 
 #include <linux/bitops.h>
-#include <sound/core.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
+#include <linux/firmware.h>
 #include <linux/init.h>
-#include <sound/initval.h>
-#include <sound/jack.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <sound/pcm.h>
 #include <linux/pm_runtime.h>
-#include <sound/pcm_params.h>
-#include <linux/soundwire/sdw_registers.h>
 #include <linux/slab.h>
+#include <linux/soundwire/sdw_registers.h>
+#include <sound/core.h>
+#include <sound/initval.h>
+#include <sound/jack.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
 #include <sound/soc-dapm.h>
 #include <sound/tlv.h>
 
@@ -344,6 +346,280 @@ static int rt722_sdca_set_jack_detect(struct snd_soc_component *component,
 	return 0;
 }
 
+static int rt722_cae_load(struct rt722_sdca_priv *rt722)
+{
+	struct device *dev = &rt722->slave->dev;
+	static const char func_tag[] = "FUNC";
+	static const char xu_tag[] = "XU";
+	const char *dmi_vendor, *dmi_product, *dmi_sku;
+	char *cae_filename;
+	const struct firmware *cae_fw = NULL;
+	unsigned int cae_st_spk, cae_st_hp, cae_st_mic;
+	unsigned int func, value;
+	unsigned int combined_val;
+	unsigned int addr, size;
+	unsigned int fw_offset;
+	unsigned char mbq_high_val = 0;
+	unsigned char *param_data;
+	unsigned char *fw_data;
+	char tag[5];
+	char *space;
+	int v_len, p_len, s_len;
+	int ret = 0, i;
+	int retry = 50;
+
+	dmi_vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	dmi_product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	dmi_sku = dmi_get_system_info(DMI_PRODUCT_SKU);
+
+	if (!dmi_vendor || !dmi_product || !dmi_sku) {
+		dev_warn(dev, "%s: Incomplete DMI info\n", __func__);
+		return -EINVAL;
+	}
+	space = strchr(dmi_vendor, ' ');
+	v_len = space ? space - dmi_vendor : strlen(dmi_vendor);
+
+	space = strchr(dmi_product, ' ');
+	p_len = space ? space - dmi_product : strlen(dmi_product);
+
+	space = strchr(dmi_sku, ' ');
+	s_len = space ? space - dmi_sku : strlen(dmi_sku);
+
+	cae_filename = kasprintf(GFP_KERNEL,
+				 "realtek/rt722/rt722_RAE_%.*s_%.*s_%.*s.dat",
+				 v_len, dmi_vendor,
+				 p_len, dmi_product,
+				 s_len, dmi_sku);
+	if (!cae_filename)
+		return -ENOMEM;
+	dev_dbg(dev, "%s: try to load CAE file %s\n", __func__, cae_filename);
+
+	regmap_write(rt722->regmap, RT722_SPK_CAE_PARAM1, 0x5f);
+	regmap_write(rt722->regmap, RT722_HP_CAE_PARAM39, 0x5f);
+	regmap_write(rt722->regmap, RT722_MIC_CAE_PARAM39, 0x5f);
+	usleep_range(50000, 60000);
+
+	request_firmware(&cae_fw, cae_filename, dev);
+	kfree(cae_filename);
+	if (!cae_fw) {
+		dev_err(dev, "%s: Failed to load CAE firmware\n", __func__);
+		return -ENOENT;
+	}
+
+	regmap_read(rt722->regmap, RT722_SPK_CAE_PARAM38, &cae_st_spk);
+	regmap_read(rt722->regmap, RT722_HP_CAE_PARAM68, &cae_st_hp);
+	regmap_read(rt722->regmap, RT722_MIC_CAE_PARAM99, &cae_st_mic);
+	cae_st_spk &= 0x80;
+	cae_st_hp &= 0x80;
+	cae_st_mic &= 0x80;
+
+	dev_dbg(dev, "%s(%d) spk_crc:%x, hp_crc:%x, mic_crc:%x\n",
+		__func__, __LINE__, cae_st_spk, cae_st_hp, cae_st_mic);
+
+	if (cae_st_spk)
+		rt722_sdca_index_update_bits(rt722, RT722_VENDOR_EQ_CAE,
+			RT722_EQ_CTRL_SPK, 0x0008, 0x0008);
+	else if (cae_st_hp)
+		rt722_sdca_index_update_bits(rt722, RT722_VENDOR_EQ_CAE,
+			RT722_EQ_CTRL_HP, 0x0008, 0x0008);
+	else if (cae_st_mic)
+		rt722_sdca_index_update_bits(rt722, RT722_VENDOR_EQ_CAE,
+			RT722_EQ_CTRL_DMIC, 0x0008, 0x0008);
+
+	rt722_sdca_index_update_bits(rt722, RT722_VENDOR_REG,
+			RT722_MISC_CTRL1, 0x8000, 0x8000);
+
+	regmap_update_bits(rt722->regmap, RT722_SPK_CAE_PARAM34, 0x1, 0x0);
+	regmap_update_bits(rt722->regmap, RT722_HP_CAE_PARAM64, 0x1, 0x0);
+	regmap_update_bits(rt722->regmap, RT722_MIC_CAE_PARAM95, 0x1, 0x0);
+
+	while (--retry) {
+		regmap_read(rt722->regmap, RT722_SPK_CAE_PARAM35, &cae_st_spk);
+		regmap_read(rt722->regmap, RT722_HP_CAE_PARAM65, &cae_st_hp);
+		regmap_read(rt722->regmap, RT722_MIC_CAE_PARAM96, &cae_st_mic);
+		dev_dbg(dev, "%s(%d) cae_st_spk:%x, cae_st_hp:%x, cae_st_mic:%x\n",
+			__func__, __LINE__, cae_st_spk, cae_st_hp, cae_st_mic);
+		if ((cae_st_spk & 0x40) && (cae_st_hp & 0x40) && (cae_st_mic & 0x40))
+			break;
+		usleep_range(1000, 1100);
+	}
+
+	if (!retry && !((cae_st_spk & 0x40) && (cae_st_hp & 0x40)
+		&& (cae_st_mic & 0x40))) {
+		dev_err(dev, "%s: CAE is not ready to be loaded.\n", __func__);
+		ret = -ETIMEDOUT;
+		goto out_release;
+	}
+
+	dev_dbg(dev, "%s, cae_fw size=0x%zx, start\n", __func__, cae_fw->size);
+
+	rt722_sdca_index_write(rt722, RT722_VENDOR_EQ_CAE,
+		RT722_EQ_CTRL_AMIC, 0x8000);
+	rt722_sdca_index_write(rt722, RT722_VENDOR_EQ_CAE,
+		RT722_EQ_CTRL_DMIC, 0x8004);
+	rt722_sdca_index_write(rt722, RT722_VENDOR_EQ_CAE,
+		RT722_EQ_CTRL_HP, 0x8074);
+	rt722_sdca_index_write(rt722, RT722_VENDOR_EQ_CAE,
+		RT722_EQ_CTRL_SPK, 0xa074);
+
+	regcache_cache_bypass(rt722->regmap, true);
+	for (fw_offset = 0; fw_offset < cae_fw->size;) {
+
+		if (fw_offset + 12 > cae_fw->size) {
+			dev_err(dev, "%s: Unexpected end of firmware\n", __func__);
+			ret = -EINVAL;
+			goto verify_abort;
+		}
+
+		fw_data = (unsigned char *)&cae_fw->data[fw_offset];
+		memcpy(tag, fw_data, 4);
+		tag[4] = '\0';
+
+		if (strcmp(tag, xu_tag) == 0) {
+			dev_dbg(dev, "%s: This is a XU tag", __func__);
+			memcpy(&addr, (fw_data + 4), 4);
+			memcpy(&size, (fw_data + 8), 4);
+
+			if (size == 0 || size > cae_fw->size - fw_offset - 12) {
+				dev_err(dev, "%s: Invalid payload size: %u\n", __func__, size);
+				ret = -EINVAL;
+				goto verify_abort;
+			}
+
+			param_data = (unsigned char *)(fw_data + 12);
+
+			dev_dbg(dev, "%s: addr=0x%x, size=0x%x\n", __func__, addr, size);
+
+			if ((addr <= 0x05302300 && addr >= 0x05300000) ||
+				(addr <= 0x020020b4 && addr >= 0x020000b1)) {
+				if (addr & BIT(13)) {
+					mbq_high_val = param_data[0];
+					dev_dbg(dev, "MBQ: High Byte 0x%02x\n", mbq_high_val);
+					fw_offset += (size + 12);
+
+					continue;
+				} else {
+					regcache_cache_bypass(rt722->regmap, false);
+					combined_val = (mbq_high_val << 8) | param_data[0];
+					if (addr == 0x20000b1 || addr == 0x20000b4)
+						combined_val |= (0x2 << 8);
+					ret = regmap_write(rt722->regmap, addr, combined_val);
+					if (ret) {
+						dev_err(dev,
+							"MBQ fail: addr=0x%x ret=%d\n", addr, ret);
+						regcache_cache_bypass(rt722->regmap, true);
+						goto verify_abort;
+					}
+
+					dev_dbg(dev, "MBQ-reg=0x%x, value=0x%x\n",
+						addr, combined_val);
+
+					fw_offset += (size + 12);
+					regcache_cache_bypass(rt722->regmap, true);
+					continue;
+				}
+			}
+
+			for (i = 0; i < size; i++) {
+				ret = regmap_write(rt722->regmap, addr + i, param_data[i]);
+				if (ret) {
+					dev_err(dev,
+						"CAE write fail: addr=0x%x ret=%d\n",
+						addr + i, ret);
+					goto verify_abort;
+				}
+			}
+			fw_offset += (size + 12);
+		} else if (strcmp(tag, func_tag) == 0) {
+			dev_dbg(dev, "%s: This is a FUNC tag", __func__);
+
+			memcpy(&func, (fw_data + 4), 4);
+			memcpy(&value, (fw_data + 8), 4);
+			dev_dbg(dev, "%s: func=0x%x, value=0x%x\n",
+				__func__, func, value);
+
+			if (func == 1)
+				msleep(value);
+
+			fw_offset += 12;
+		} else {
+			dev_err(dev, "%s: No XU/FUNC tag at fw_offset=0x%x\n",
+				__func__, fw_offset);
+			ret = -EINVAL;
+			goto verify_abort;
+		}
+	}
+
+	rt722_sdca_index_update_bits(rt722, RT722_VENDOR_REG,
+			RT722_MISC_CTRL1, 0x8000, 0x0000);
+	regcache_cache_bypass(rt722->regmap, false);
+	rt722->cae_update_done = 1;
+	dev_dbg(dev, "%s: CAE FW update done.\n", __func__);
+	release_firmware(cae_fw);
+	return 0;
+
+verify_abort:
+	regcache_cache_bypass(rt722->regmap, false);
+	if (!ret)
+		ret = -EIO;
+out_release:
+	rt722_sdca_index_update_bits(rt722, RT722_VENDOR_REG,
+			RT722_MISC_CTRL1, 0x8000, 0x0000);
+	release_firmware(cae_fw);
+	dev_err(dev, "%s: CAE FW update aborted (ret=%d).\n", __func__, ret);
+	return ret;
+}
+
+static int rt722_cae_update_put(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
+	struct rt722_sdca_priv *rt722 = snd_soc_component_get_drvdata(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
+	int ret, changed = 0;
+
+	if (!rt722->hw_init)
+		return 0;
+
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0 && ret != -EACCES)
+		return ret;
+
+	if (ucontrol->value.integer.value[0]) {
+		if (snd_soc_dapm_get_bias_level(dapm) == SND_SOC_BIAS_OFF) {
+			ret = rt722_cae_load(rt722);
+			if (ret) {
+				dev_err(component->dev, "CAE load failed: %d\n", ret);
+				goto out;
+			} else
+				changed = 1;
+		}
+	} else {
+		if (rt722->cae_update_done) {
+			rt722->cae_update_done = 0;
+			changed = 1;
+		}
+	}
+
+out:
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
+	return ret < 0 ? ret : changed;
+}
+
+static int rt722_cae_update_get(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
+	struct rt722_sdca_priv *rt722 = snd_soc_component_get_drvdata(component);
+
+	ucontrol->value.integer.value[0] = rt722->cae_update_done;
+
+	return 0;
+}
+
+
 /* For SDCA control DAC/ADC Gain */
 static int rt722_sdca_set_gain_put(struct snd_kcontrol *kcontrol,
 		struct snd_ctl_elem_value *ucontrol)
@@ -795,6 +1071,9 @@ static const struct snd_kcontrol_new rt722_sdca_controls[] = {
 			RT722_SDCA_CTL_FU_CH_GAIN, CH_01),
 		rt722_sdca_dmic_set_gain_get, rt722_sdca_dmic_set_gain_put,
 			4, 3, boost_vol_tlv),
+	/* CAE firmware update */
+	SOC_SINGLE_EXT("CAE Update", SND_SOC_NOPM, 0, 1, 0,
+		rt722_cae_update_get, rt722_cae_update_put),
 };
 
 static const char * const adc22_mux_text[] = {
@@ -1376,6 +1655,7 @@ int rt722_sdca_init(struct device *dev, struct regmap *regmap, struct sdw_slave
 	rt722->fu0f_mixer_l_mute = rt722->fu0f_mixer_r_mute = true;
 	rt722->fu1e_mixer_mute[0] = rt722->fu1e_mixer_mute[1] =
 		rt722->fu1e_mixer_mute[2] = rt722->fu1e_mixer_mute[3] = true;
+	rt722->cae_update_done = 0;
 
 	return devm_snd_soc_register_component(dev,
 			&soc_sdca_dev_rt722, rt722_sdca_dai, ARRAY_SIZE(rt722_sdca_dai));
diff --git a/sound/soc/codecs/rt722-sdca.h b/sound/soc/codecs/rt722-sdca.h
index fc50beff9424..b654b14334d4 100644
--- a/sound/soc/codecs/rt722-sdca.h
+++ b/sound/soc/codecs/rt722-sdca.h
@@ -44,6 +44,7 @@ struct  rt722_sdca_priv {
 	bool fu1e_dapm_mute;
 	bool fu1e_mixer_mute[4];
 	int hw_vid;
+	int cae_update_done;
 };
 
 struct rt722_sdca_dmic_kctrl_priv {
@@ -55,6 +56,7 @@ struct rt722_sdca_dmic_kctrl_priv {
 
 /* NID */
 #define RT722_VENDOR_REG			0x20
+#define RT722_VENDOR_EQ_CAE			0x53
 #define RT722_VENDOR_CALI			0x58
 #define RT722_VENDOR_SPK_EFUSE			0x5c
 #define RT722_VENDOR_IMS_DRE			0x5b
@@ -64,6 +66,7 @@ struct rt722_sdca_dmic_kctrl_priv {
 /* Index (NID:20h) */
 #define RT722_JD_PRODUCT_NUM			0x00
 #define RT722_ANALOG_BIAS_CTL3			0x04
+#define RT722_MISC_CTRL1			0x07
 #define RT722_JD_CTRL1				0x09
 #define RT722_LDO2_3_CTL1			0x0e
 #define RT722_LDO1_CTL				0x1a
@@ -79,6 +82,12 @@ struct rt722_sdca_dmic_kctrl_priv {
 #define RT722_SW_CONFIG1			0x8a
 #define RT722_SW_CONFIG2			0x8b
 
+/* Index (NID:53h) */
+#define RT722_EQ_CTRL_SPK			0x00
+#define RT722_EQ_CTRL_HP			0x100
+#define RT722_EQ_CTRL_DMIC			0x200
+#define RT722_EQ_CTRL_AMIC			0x300
+
 /* Index (NID:58h) */
 #define RT722_DAC_DC_CALI_CTL0			0x00
 #define RT722_DAC_DC_CALI_CTL1			0x01
@@ -156,6 +165,20 @@ struct rt722_sdca_dmic_kctrl_priv {
 #define RT722_BUF_ADDR_HID1			0x44030000
 #define RT722_BUF_ADDR_HID2			0x44030020
 
+/* RT722 CAE parameter settings */
+#define RT722_SPK_CAE_PARAM1			0x44012000
+#define RT722_SPK_CAE_PARAM34			0x44012021
+#define RT722_SPK_CAE_PARAM35			0x44012022
+#define RT722_SPK_CAE_PARAM38			0x44012025
+#define RT722_HP_CAE_PARAM39			0x44022000
+#define RT722_HP_CAE_PARAM64			0x44022019
+#define RT722_HP_CAE_PARAM65			0x4402201a
+#define RT722_HP_CAE_PARAM68			0x4402201d
+#define RT722_MIC_CAE_PARAM39			0x44042000
+#define RT722_MIC_CAE_PARAM95			0x44042019
+#define RT722_MIC_CAE_PARAM96			0x4404201a
+#define RT722_MIC_CAE_PARAM99			0x4404201d
+
 /* RT722 SDCA Control - function number */
 #define FUNC_NUM_JACK_CODEC			0x01
 #define FUNC_NUM_MIC_ARRAY			0x02
-- 
2.54.0

