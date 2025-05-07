Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BD9217733
	for <patches@lists.linux.dev>; Wed,  7 May 2025 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746617370; cv=none; b=XchKvkmiSQ0KI5FMlEuNr4rhXRxQEulCBMEgThQip+YKWEjyAoOYw4H0MV3K77nsVpCVVefeNgniKNBl5OKnN4IfLe935gXVQ0xZeRFyz7QOAYzSmd1CTSW6LJy8lo1VAkbWkkm5NxLt5Gqj0utM7upq3X7ujCYfcgLjI/AIll0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746617370; c=relaxed/simple;
	bh=GjLQcIDf12y2SGWWyn0Ez/IHDLYCTa8Zfsqcwm+0CXI=;
	h=From:To:CC:Date:Message-ID:MIME-Version:Content-Type:Subject; b=VsCQlribFkwNF1Xee4u5eAWdPQ39AERn/pAASnnU9lhqfo6du/3aSdtJJtojIpI9VowWQl1zIL+ePJUT0qmKWlzPQUOgPNQleEcuMohf9r52NFWwv5SoKA8or3xxdAI9ss8KyiOYrIXiggKfznEoDmPq6oYrBC2ssCk70gNDY0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=xIvnYgjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="xIvnYgjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62DFC4CEE7
	for <patches@lists.linux.dev>; Wed,  7 May 2025 11:29:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="xIvnYgjn"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Wed, 7 May 2025 20:29:27 +0900
Resent-Message-ID: <aBtEFw0YOEY8otOz@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 07 May 2025 10:46:40 +0100
Received: from sea.source.kernel.org ([172.234.252.31])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=/P2C=XX=ti.com=shenghao-ding@kernel.org>)
	id 1uCbMM-005Pqv-52
	for broonie@sirena.co.uk; Wed, 07 May 2025 10:46:40 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BED734A432
	for <broonie@sirena.co.uk>; Wed,  7 May 2025 09:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id B20CDC4CEEB; Wed,  7 May 2025 09:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F34D6C4CEE7
	for <broonie@kernel.org>; Wed,  7 May 2025 09:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org F34D6C4CEE7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=ti.com
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 5479kOAD786684
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 May 2025 04:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1746611184;
	bh=JLGWaJhpTGIOofa9iqPj/lFIPP6WIJ9d71MLwRpwkJ0=;
	h=From:To:CC:Subject:Date;
	b=xIvnYgjnuLSw4axbXoV89qu07IVbrf48aAyQudeUquE7Rv4zvoSsMGfm/YaPHXpUI
	 RUHMvaF3L+VxFO7jMr1c44TrVRHH3xGoNW6ONIZ7H2UtyiEqr84gOlTjMrvJZsskbC
	 hZlkqjF3x7Ly3m9NdSynF0hEmCAifK5yzYLgAajk=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 5479kOei001875
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 May 2025 04:46:24 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 7
 May 2025 04:46:23 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 7 May 2025 04:46:23 -0500
Received: from LT5CG31242FY.dhcp.ti.com (lt5cg31242fy.dhcp.ti.com [10.85.15.5])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 5479kJud068828;
	Wed, 7 May 2025 04:46:20 -0500
From: Shenghao Ding <shenghao-ding@ti.com>
To: <broonie@kernel.org>
CC: <andriy.shevchenko@linux.intel.com>, <tiwai@suse.de>,
        <13916275206@139.com>, <13564923607@139.com>,
        <alsa-devel@alsa-project.org>, <baojun.xu@ti.com>, <jesse-ji@ti.com>,
        Shenghao Ding <shenghao-ding@ti.com>
Date: Wed, 7 May 2025 17:46:15 +0800
Message-ID: <20250507094616.210-1-shenghao-ding@ti.com>
X-Mailer: git-send-email 2.33.0.windows.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-SA-Exim-Connect-IP: 172.234.252.31
X-SA-Exim-Mail-From: SRS0=/P2C=XX=ti.com=shenghao-ding@kernel.org
Subject: [PATCH v5] ASoC: tas2781: Add a debugfs node for acoustic tuning
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: AA6X7rNkSn14

"Acoustic Tuning" debugfs node is a bridge to the acoustic tuning tool
which can tune the chips' acoustic effect.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>

---
v5:
 - Drop the define CONFIG_SND_SOC_TAS2781_ACOUST_I2C in Kconfig, anyone
   who wants to use acoustic tool have to edit the source due to the
   whole directly exposing the registers.
v4:
 - Add name_prefix as part of the name of debugfs node in case of multiple
   devices.
v3:
 - Remove unnessary indentation.
 - Add a special build CONFIG_SND_SOC_TAS2781_I2C_ACOUST for acoustic
   tuning debugfs node
v2:
 - Implement the "Acoustic Tuning" as debugfs node instead of kcontrol.
v1:
 - Add "Acoustic Tuning" kcontrol for acoustic tuning.
---
 include/sound/tas2781.h        |  23 +++++
 sound/soc/codecs/tas2781-i2c.c | 154 +++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index 8192a94d783a..442126aa124a 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -161,10 +161,33 @@ struct calidata {
 	unsigned int cali_dat_sz_per_dev;
 };
 
+/*
+ * To enable CONFIG_SND_SOC_TAS2781_ACOUST_I2C will create a bridge to the
+ * acoustic tuning tool which can tune the chips' acoustic effect. Due to the
+ * whole directly exposing the registers, there exist some potential risks. So
+ * this define is invisible in Kconfig, anyone who wants to use acoustic tool
+ * have to edit the source manually.
+ */
+#ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
+#define TASDEV_DATA_PAYLOAD_SIZE	128
+struct acoustic_data {
+	unsigned char len;
+	unsigned char id;
+	unsigned char addr;
+	unsigned char book;
+	unsigned char page;
+	unsigned char reg;
+	unsigned char data[TASDEV_DATA_PAYLOAD_SIZE];
+};
+#endif
+
 struct tasdevice_priv {
 	struct tasdevice tasdevice[TASDEVICE_MAX_CHANNELS];
 	struct tasdevice_rca rcabin;
 	struct calidata cali_data;
+#ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
+	struct acoustic_data acou_data;
+#endif
 	struct tasdevice_fw *fmw;
 	struct gpio_desc *speaker_id;
 	struct gpio_desc *reset;
diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 9a329c561a53..f7d71ee4f627 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -14,6 +14,9 @@
 //
 
 #include <linux/crc8.h>
+#ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
+#include <linux/debugfs.h>
+#endif
 #include <linux/firmware.h>
 #include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
@@ -1423,10 +1426,150 @@ static int tasdevice_create_cali_ctrls(struct tasdevice_priv *priv)
 		nctrls < i ? nctrls : i);
 }
 
+#ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
+/*
+ * This debugfs node is a bridge to the acoustic tuning application
+ * tool which can tune the chips' acoustic effect.
+ *
+ * package structure for PPC3 communications:
+ *	Pkg len (1 byte)
+ *	Pkg id (1 byte, 'r' or 'w')
+ *	Dev id (1 byte, i2c address)
+ *	Book id (1 byte)
+ *	Page id (1 byte)
+ *	Reg id (1 byte)
+ *	switch (pkg id) {
+ *	case 'w':
+ *		1 byte, length of data to read
+ *	case 'r':
+ *		data payload (1~128 bytes)
+ *	}
+ */
+static ssize_t acoustic_ctl_read(struct file *file, char __user *to,
+	size_t count, loff_t *ppos)
+{
+	struct snd_soc_component *comp = file->private_data;
+	struct tasdevice_priv *tas_priv = snd_soc_component_get_drvdata(comp);
+	struct acoustic_data *p = &tas_priv->acou_data;
+	int ret = -1;
+
+	if (p->id == 'r' && p->len == count && count <= sizeof(*p))
+		ret = simple_read_from_buffer(to, count, ppos, p, p->len);
+	else
+		dev_err(tas_priv->dev, "Not ready for get.\n");
+	return ret;
+}
+
+static ssize_t acoustic_ctl_write(struct file *file,
+	const char __user *from, size_t count, loff_t *ppos)
+{
+	struct snd_soc_component *comp = file->private_data;
+	struct tasdevice_priv *priv = snd_soc_component_get_drvdata(comp);
+	struct acoustic_data *p = &priv->acou_data;
+	unsigned int max_pkg_len = sizeof(*p);
+	unsigned char *src;
+	int j, len, reg, val;
+	unsigned short chn;
+	int ret = -1;
+
+	if (count > sizeof(*p)) {
+		dev_err(priv->dev, "count(%u) is larger than max(%u).\n",
+			(unsigned int)count, max_pkg_len);
+		return ret;
+	}
+
+	src = memdup_user(from, count);
+	if (IS_ERR(src))
+		return PTR_ERR(src);
+
+	if (src[0] > max_pkg_len && src[0] != count) {
+		dev_err(priv->dev, "pkg(%u), max(%u), count(%u) dismatch.\n",
+			src[0], max_pkg_len, (unsigned int)count);
+		ret = 0;
+		goto exit;
+	}
+
+	switch (src[1]) {
+	case 'r':
+		/* length of data to read */
+		len = src[6];
+		break;
+	case 'w':
+		/* Skip 6 bytes for package type and register address */
+		len = src[0] - 6;
+		break;
+	default:
+		dev_err(priv->dev, "%s Wrong code %02x.\n", __func__, src[1]);
+		ret = 0;
+		goto exit;
+	}
+
+	if (len < 1) {
+		dev_err(priv->dev, "pkg fmt invalid %02x.\n", len);
+		ret = 0;
+		goto exit;
+	}
+
+	for (j = 0; j < priv->ndev; j++)
+		if (src[2] == priv->tasdevice[j].dev_addr) {
+			chn = j;
+			break;
+		}
+	if (j >= priv->ndev) {
+		dev_err(priv->dev, "no such device 0x%02x.\n", src[2]);
+		ret = 0;
+		goto exit;
+	}
+
+	reg = TASDEVICE_REG(src[3], src[4], src[5]);
+
+	guard(mutex)(&priv->codec_lock);
+
+	if (src[1] == 'w') {
+		if (len > 1)
+			ret = tasdevice_dev_bulk_write(priv, chn, reg,
+				 &src[6], len);
+		else
+			ret = tasdevice_dev_write(priv, chn, reg, src[6]);
+	} else {
+		struct acoustic_data *p = &priv->acou_data;
+
+		memcpy(p, src, 6);
+		if (len > 1) {
+			ret = tasdevice_dev_bulk_read(priv, chn, reg,
+				p->data, len);
+		} else {
+			ret = tasdevice_dev_read(priv, chn, reg, &val);
+			p->data[0] = val;
+		}
+		p->len = len + 6;
+	}
+
+	if (ret)
+		dev_err(priv->dev, "i2c communication error.\n");
+	else
+		ret = count;
+exit:
+	kfree(src);
+	return ret;
+}
+
+static const struct file_operations acoustic_ctl_fops = {
+	.open = simple_open,
+	.read = acoustic_ctl_read,
+	.write = acoustic_ctl_write,
+};
+#endif
+
 static void tasdevice_fw_ready(const struct firmware *fmw,
 	void *context)
 {
 	struct tasdevice_priv *tas_priv = context;
+#ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
+	struct snd_soc_component *comp = tas_priv->codec;
+	struct dentry *debugfs_root = comp->debugfs_root;
+	char *acoustic_debugfs_node;
+#endif
 	int ret = 0;
 	int i;
 
@@ -1500,6 +1643,17 @@ static void tasdevice_fw_ready(const struct firmware *fmw,
 
 	tasdevice_prmg_load(tas_priv, 0);
 	tas_priv->cur_prog = 0;
+
+#ifdef CONFIG_SND_SOC_TAS2781_ACOUST_I2C
+	if (tas_priv->name_prefix)
+		acoustic_debugfs_node = devm_kasprintf(tas_priv->dev,
+			GFP_KERNEL, "%s_acoustic_ctl", tas_priv->name_prefix);
+	else
+		acoustic_debugfs_node = devm_kstrdup(tas_priv->dev,
+			"acoustic_ctl", GFP_KERNEL);
+	debugfs_create_file(acoustic_debugfs_node, 0644, debugfs_root,
+		comp, &acoustic_ctl_fops);
+#endif
 out:
 	if (tas_priv->fw_state == TASDEVICE_RCA_FW_OK) {
 		/* If DSP FW fail, DSP kcontrol won't be created. */
-- 
2.43.0

