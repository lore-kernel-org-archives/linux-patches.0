Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175433BBF2;
	Tue, 15 Jul 2025 13:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585362; cv=none; b=lgzd9AtSDtgHKFBk4nWnw1Ky3hcUrMdd9fyiCq6MRl84J5c/nxjLz4nhr6DwwRBkTW2pNREVWVUdOwjvf5JiI10jZMqtfNa4o/bKfxStpxb2PEID6ouKZarJOw+nEWIz9iVaXwVTsGGg6+IafuyeRFp3WrclWSFLNnGl2B1Sv6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585362; c=relaxed/simple;
	bh=Uq65dV4HWM0r4nCheo5y6NdPvx1INRowXczOe3hgtQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2osdIazx7XBtBpN3AqKsOL2gcKct4RZb0VIfTf3ymdG32BKSdrwXwZwTRuTcpcRUZItvoNnFDf4rxk472rEHO/8KLwydzxuD1y+Vgg6gFRfbohqHYb9qtxE6E/mp2v25FC0FQX5WOxIAC1WjGkCCnZJz55YVuPtFQtglzam1+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MH229x3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MH229x3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B09AC4CEE3;
	Tue, 15 Jul 2025 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585361;
	bh=Uq65dV4HWM0r4nCheo5y6NdPvx1INRowXczOe3hgtQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MH229x3IAnxe+76jnJnf1ZAoKSW2y6F2Vt3yXI9LrA91m3ZTbcct7mBNUhBGToI/j
	 1OeatR4VJdu1wc4Y3NymPaiV+E9W3lCvfZeCSpYXDV41nK8ZesEAQJ/df84oPZQXqT
	 qrtRdSzLuQxZ3RmLLD4uyu4QKa2GScQ8kLpIApA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/163] ASoC: Intel: add sof_sdw_get_tplg_files ops
Date: Tue, 15 Jul 2025 15:11:20 +0200
Message-ID: <20250715130809.269683902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 2fbeff33381cf017facbf5f13d34693baa5a2296 ]

Add sof_sdw_get_tplg_files ops to get sub-topology file names for the
sof_sdw card.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250414063239.85200-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a7528e9beadb ("ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/Makefile               |   2 +-
 .../intel/common/sof-function-topology-lib.c  | 135 ++++++++++++++++++
 .../intel/common/sof-function-topology-lib.h  |  15 ++
 3 files changed, 151 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/intel/common/sof-function-topology-lib.c
 create mode 100644 sound/soc/intel/common/sof-function-topology-lib.h

diff --git a/sound/soc/intel/common/Makefile b/sound/soc/intel/common/Makefile
index 91e146e2487da..a9a740e249698 100644
--- a/sound/soc/intel/common/Makefile
+++ b/sound/soc/intel/common/Makefile
@@ -14,7 +14,7 @@ snd-soc-acpi-intel-match-y := soc-acpi-intel-byt-match.o soc-acpi-intel-cht-matc
 	soc-acpi-intel-lnl-match.o \
 	soc-acpi-intel-ptl-match.o \
 	soc-acpi-intel-hda-match.o \
-	soc-acpi-intel-sdw-mockup-match.o
+	soc-acpi-intel-sdw-mockup-match.o sof-function-topology-lib.o
 
 snd-soc-acpi-intel-match-y += soc-acpi-intel-ssp-common.o
 
diff --git a/sound/soc/intel/common/sof-function-topology-lib.c b/sound/soc/intel/common/sof-function-topology-lib.c
new file mode 100644
index 0000000000000..90fe7aa3df1cb
--- /dev/null
+++ b/sound/soc/intel/common/sof-function-topology-lib.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+//
+// This file is provided under a dual BSD/GPLv2 license.  When using or
+// redistributing this file, you may do so under either license.
+//
+// Copyright(c) 2025 Intel Corporation.
+//
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
+#include <sound/soc.h>
+#include <sound/soc-acpi.h>
+#include "sof-function-topology-lib.h"
+
+enum tplg_device_id {
+	TPLG_DEVICE_SDCA_JACK,
+	TPLG_DEVICE_SDCA_AMP,
+	TPLG_DEVICE_SDCA_MIC,
+	TPLG_DEVICE_INTEL_PCH_DMIC,
+	TPLG_DEVICE_HDMI,
+	TPLG_DEVICE_MAX
+};
+
+#define SDCA_DEVICE_MASK (BIT(TPLG_DEVICE_SDCA_JACK) | BIT(TPLG_DEVICE_SDCA_AMP) | \
+			  BIT(TPLG_DEVICE_SDCA_MIC))
+
+#define SOF_INTEL_PLATFORM_NAME_MAX 4
+
+int sof_sdw_get_tplg_files(struct snd_soc_card *card, const struct snd_soc_acpi_mach *mach,
+			   const char *prefix, const char ***tplg_files)
+{
+	struct snd_soc_acpi_mach_params mach_params = mach->mach_params;
+	struct snd_soc_dai_link *dai_link;
+	const struct firmware *fw;
+	char platform[SOF_INTEL_PLATFORM_NAME_MAX];
+	unsigned long tplg_mask = 0;
+	int tplg_num = 0;
+	int tplg_dev;
+	int ret;
+	int i;
+
+	ret = sscanf(mach->sof_tplg_filename, "sof-%3s-*.tplg", platform);
+	if (ret != 1) {
+		dev_err(card->dev, "Invalid platform name %s of tplg %s\n",
+			platform, mach->sof_tplg_filename);
+		return -EINVAL;
+	}
+
+	for_each_card_prelinks(card, i, dai_link) {
+		char *tplg_dev_name;
+
+		dev_dbg(card->dev, "dai_link %s id %d\n", dai_link->name, dai_link->id);
+		if (strstr(dai_link->name, "SimpleJack")) {
+			tplg_dev = TPLG_DEVICE_SDCA_JACK;
+			tplg_dev_name = "sdca-jack";
+		} else if (strstr(dai_link->name, "SmartAmp")) {
+			tplg_dev = TPLG_DEVICE_SDCA_AMP;
+			tplg_dev_name = devm_kasprintf(card->dev, GFP_KERNEL,
+						       "sdca-%damp", dai_link->num_cpus);
+			if (!tplg_dev_name)
+				return -ENOMEM;
+		} else if (strstr(dai_link->name, "SmartMic")) {
+			tplg_dev = TPLG_DEVICE_SDCA_MIC;
+			tplg_dev_name = "sdca-mic";
+		} else if (strstr(dai_link->name, "dmic")) {
+			switch (mach_params.dmic_num) {
+			case 2:
+				tplg_dev_name = "dmic-2ch";
+				break;
+			case 4:
+				tplg_dev_name = "dmic-4ch";
+				break;
+			default:
+				dev_warn(card->dev,
+					 "only -2ch and -4ch are supported for dmic\n");
+				continue;
+			}
+			tplg_dev = TPLG_DEVICE_INTEL_PCH_DMIC;
+		} else if (strstr(dai_link->name, "iDisp")) {
+			tplg_dev = TPLG_DEVICE_HDMI;
+			tplg_dev_name = "hdmi-pcm5";
+
+		} else {
+			/* The dai link is not supported by separated tplg yet */
+			dev_dbg(card->dev,
+				"dai_link %s is not supported by separated tplg yet\n",
+				dai_link->name);
+			return 0;
+		}
+		if (tplg_mask & BIT(tplg_dev))
+			continue;
+
+		tplg_mask |= BIT(tplg_dev);
+
+		/*
+		 * The tplg file naming rule is sof-<platform>-<function>-id<BE id number>.tplg
+		 * where <platform> is only required for the DMIC function as the nhlt blob
+		 * is platform dependent.
+		 */
+		switch (tplg_dev) {
+		case TPLG_DEVICE_INTEL_PCH_DMIC:
+			(*tplg_files)[tplg_num] = devm_kasprintf(card->dev, GFP_KERNEL,
+								 "%s/sof-%s-%s-id%d.tplg",
+								 prefix, platform,
+								 tplg_dev_name, dai_link->id);
+			break;
+		default:
+			(*tplg_files)[tplg_num] = devm_kasprintf(card->dev, GFP_KERNEL,
+								 "%s/sof-%s-id%d.tplg",
+								 prefix, tplg_dev_name,
+								 dai_link->id);
+			break;
+		}
+		if (!(*tplg_files)[tplg_num])
+			return -ENOMEM;
+		tplg_num++;
+	}
+
+	dev_dbg(card->dev, "tplg_mask %#lx tplg_num %d\n", tplg_mask, tplg_num);
+
+	/* Check presence of sub-topologies */
+	for (i = 0; i < tplg_num; i++) {
+		ret = firmware_request_nowarn(&fw, (*tplg_files)[i], card->dev);
+		if (!ret) {
+			release_firmware(fw);
+		} else {
+			dev_dbg(card->dev, "Failed to open topology file: %s\n", (*tplg_files)[i]);
+			return 0;
+		}
+	}
+
+	return tplg_num;
+}
+
diff --git a/sound/soc/intel/common/sof-function-topology-lib.h b/sound/soc/intel/common/sof-function-topology-lib.h
new file mode 100644
index 0000000000000..e7d0c39d07883
--- /dev/null
+++ b/sound/soc/intel/common/sof-function-topology-lib.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * soc-acpi-intel-get-tplg.h - get-tplg-files ops
+ *
+ * Copyright (c) 2025, Intel Corporation.
+ *
+ */
+
+#ifndef _SND_SOC_ACPI_INTEL_GET_TPLG_H
+#define _SND_SOC_ACPI_INTEL_GET_TPLG_H
+
+int sof_sdw_get_tplg_files(struct snd_soc_card *card, const struct snd_soc_acpi_mach *mach,
+			   const char *prefix, const char ***tplg_files);
+
+#endif
-- 
2.39.5



