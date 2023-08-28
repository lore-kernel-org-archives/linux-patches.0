Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B66FAF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79939C433C9;
	Mon, 28 Aug 2023 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219818;
	bh=3teD5aaKIaPv6T0CA0EdUcyIvpqsJdAzjQky7woqXw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrDLoE/KC9hnPVYylecazHaq0hgmMAn/adS9KgmJwCmndtr/ifRHJC0nYiDYV0rbs
	 Wv9A5QIQ4uDDhMcvXjMbI5VvmzI2Lom5bLok0ofzbs4RPR8y2qsFsEGIdqjdjdqiK1
	 WMWzpdbAEKSFRuAKk388ro2+zxwT5Yp0Mkm4nEvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH 5.10 83/84] ASoC: Intel: sof_sdw: include rt711.h for RT711 JD mode
Date: Mon, 28 Aug 2023 12:14:40 +0200
Message-ID: <20230828101152.088045445@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit 8e6c00f1fdea9fdf727969d7485d417240d2a1f9 upstream.

We don't need to redefine enum rt711_jd_src.

Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210712203240.46960-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Philip Müller <philm@manjaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c        |   23 ++++++++++++-----------
 sound/soc/intel/boards/sof_sdw_common.h |    5 -----
 2 files changed, 12 insertions(+), 16 deletions(-)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -13,8 +13,9 @@
 #include <sound/soc.h>
 #include <sound/soc-acpi.h>
 #include "sof_sdw_common.h"
+#include "../../codecs/rt711.h"
 
-unsigned long sof_sdw_quirk = SOF_RT711_JD_SRC_JD1;
+unsigned long sof_sdw_quirk = RT711_JD1;
 static int quirk_override = -1;
 module_param_named(quirk, quirk_override, int, 0444);
 MODULE_PARM_DESC(quirk, "Board-specific quirk override");
@@ -63,7 +64,7 @@ static const struct dmi_system_id sof_sd
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "09C6")
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX),
 	},
 	{
@@ -73,7 +74,7 @@ static const struct dmi_system_id sof_sd
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0983")
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX),
 	},
 	{
@@ -82,7 +83,7 @@ static const struct dmi_system_id sof_sd
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "098F"),
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
@@ -92,7 +93,7 @@ static const struct dmi_system_id sof_sd
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0990"),
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
@@ -114,7 +115,7 @@ static const struct dmi_system_id sof_sd
 				  "Tiger Lake Client Platform"),
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD1 |
+					RT711_JD1 |
 					SOF_SDW_PCH_DMIC |
 					SOF_SSP_PORT(SOF_I2S_SSP2)),
 	},
@@ -125,7 +126,7 @@ static const struct dmi_system_id sof_sd
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A3E")
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD2 |
+					RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX),
 	},
 	{
@@ -135,7 +136,7 @@ static const struct dmi_system_id sof_sd
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A5E")
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD2 |
+					RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
@@ -173,7 +174,7 @@ static const struct dmi_system_id sof_sd
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
 					SOF_SDW_PCH_DMIC |
-					SOF_RT711_JD_SRC_JD2),
+					RT711_JD2),
 	},
 	/* TigerLake-SDCA devices */
 	{
@@ -183,7 +184,7 @@ static const struct dmi_system_id sof_sd
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A32")
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD2 |
+					RT711_JD2 |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
@@ -194,7 +195,7 @@ static const struct dmi_system_id sof_sd
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alder Lake Client Platform"),
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
+		.driver_data = (void *)(RT711_JD1 |
 					SOF_SDW_TGL_HDMI |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_PCH_DMIC),
--- a/sound/soc/intel/boards/sof_sdw_common.h
+++ b/sound/soc/intel/boards/sof_sdw_common.h
@@ -23,11 +23,6 @@
 #define SDW_MAX_GROUPS 9
 
 enum {
-	SOF_RT711_JD_SRC_JD1 = 1,
-	SOF_RT711_JD_SRC_JD2 = 2,
-};
-
-enum {
 	SOF_PRE_TGL_HDMI_COUNT = 3,
 	SOF_TGL_HDMI_COUNT = 4,
 };


