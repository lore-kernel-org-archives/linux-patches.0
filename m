Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38DC13B5B9;
	Thu, 11 Apr 2024 10:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830166; cv=none; b=SFSzh3toi8O2jkeu6l59LZLD9mzDSUE4i3lXFEtJQ4eSQsPLl9tDUhsBcqzbEHeyNVBKxFw19xKxk4tnYTf62pmwFO8kLhFRrTj6+GCAS+mEqFm2Loa68tHEJIAIM57HiStaEbelmDiM9IhDCo90+TlX8R1XP/GMHDbv9LqdEgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830166; c=relaxed/simple;
	bh=z2weGZX0j3WbRPViWegI3NEw26qaumEb6QRPkKgX0cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdtcWw3hzvbnBny5GoQ/fZgmpnT3tQ0o164nhss6DpTf0y1vZ9J59rpmI65/fjNyJtcWirtb8zBKi3Vnz1rrUwJN/6uU1/k4ZJi8bp4BqCq/Jb8A5PIpEUf+njYbkwsK+TtsQqJSAS9lzkjFpG2wgNTltRtpO4aISnZReBSLCF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN50LHGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN50LHGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48547C433C7;
	Thu, 11 Apr 2024 10:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830166;
	bh=z2weGZX0j3WbRPViWegI3NEw26qaumEb6QRPkKgX0cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN50LHGOTOjok/XU6cHmCPWDdJxmvI+vL9xTzWNnEisbBR1zLIYIM3W99mqlU/olH
	 /sL80yuaBXI5IRAa3IC7fptc6pUMOcdehQodieYrmdN4UThTQw2Q6+4gY7OxXxgbBF
	 MyTlIBdFQlIQBBU8FPH7LbKQlb+NShoBvq54j5YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 018/143] wifi: iwlwifi: pcie: Add new PCI device id and CNVI
Date: Thu, 11 Apr 2024 11:54:46 +0200
Message-ID: <20240411095421.458633389@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 5f4e0994996fa08d57711b5b247a0cb3085ec66a ]

Add the support for a new PCIE device-id 0x272E and a new CNVI
type.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240206175739.506db9b4a664.Ia2e3a77b880c449ac0e8d20b8cea25e6f07f1b81@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c   | 38 +++++++++++++++++--
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  8 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 15 +++++++-
 3 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index 80eb9b4995389..156c428547497 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  */
 #include <linux/module.h>
 #include <linux/stringify.h>
@@ -33,6 +33,10 @@
 #define IWL_SC_A_GF_A_FW_PRE		"iwlwifi-sc-a0-gf-a0"
 #define IWL_SC_A_GF4_A_FW_PRE		"iwlwifi-sc-a0-gf4-a0"
 #define IWL_SC_A_WH_A_FW_PRE		"iwlwifi-sc-a0-wh-a0"
+#define IWL_SC2_A_FM_C_FW_PRE		"iwlwifi-sc2-a0-fm-c0"
+#define IWL_SC2_A_WH_A_FW_PRE		"iwlwifi-sc2-a0-wh-a0"
+#define IWL_SC2F_A_FM_C_FW_PRE		"iwlwifi-sc2f-a0-fm-c0"
+#define IWL_SC2F_A_WH_A_FW_PRE		"iwlwifi-sc2f-a0-wh-a0"
 
 #define IWL_SC_A_FM_B_FW_MODULE_FIRMWARE(api) \
 	IWL_SC_A_FM_B_FW_PRE "-" __stringify(api) ".ucode"
@@ -48,6 +52,14 @@
 	IWL_SC_A_GF4_A_FW_PRE "-" __stringify(api) ".ucode"
 #define IWL_SC_A_WH_A_FW_MODULE_FIRMWARE(api) \
 	IWL_SC_A_WH_A_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_SC2_A_FM_C_FW_MODULE_FIRMWARE(api) \
+	IWL_SC2_A_FM_C_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_SC2_A_WH_A_FW_MODULE_FIRMWARE(api) \
+	IWL_SC2_A_WH_A_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_SC2F_A_FM_C_FW_MODULE_FIRMWARE(api) \
+	IWL_SC2F_A_FM_C_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_SC2F_A_WH_A_FW_MODULE_FIRMWARE(api) \
+	IWL_SC2F_A_WH_A_FW_PRE "-" __stringify(api) ".ucode"
 
 static const struct iwl_base_params iwl_sc_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
@@ -124,6 +136,9 @@ static const struct iwl_base_params iwl_sc_base_params = {
 
 #define IWL_DEVICE_SC							\
 	IWL_DEVICE_BZ_COMMON,						\
+	.uhb_supported = true,						\
+	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.num_rbds = IWL_NUM_RBDS_SC_EHT,				\
 	.ht_params = &iwl_22000_ht_params
 
 /*
@@ -149,10 +164,21 @@ const char iwl_sc_name[] = "Intel(R) TBD Sc device";
 
 const struct iwl_cfg iwl_cfg_sc = {
 	.fw_name_mac = "sc",
-	.uhb_supported = true,
 	IWL_DEVICE_SC,
-	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,
-	.num_rbds = IWL_NUM_RBDS_SC_EHT,
+};
+
+const char iwl_sc2_name[] = "Intel(R) TBD Sc2 device";
+
+const struct iwl_cfg iwl_cfg_sc2 = {
+	.fw_name_mac = "sc2",
+	IWL_DEVICE_SC,
+};
+
+const char iwl_sc2f_name[] = "Intel(R) TBD Sc2f device";
+
+const struct iwl_cfg iwl_cfg_sc2f = {
+	.fw_name_mac = "sc2f",
+	IWL_DEVICE_SC,
 };
 
 MODULE_FIRMWARE(IWL_SC_A_FM_B_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
@@ -162,3 +188,7 @@ MODULE_FIRMWARE(IWL_SC_A_HR_B_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_SC_A_GF_A_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_SC_A_GF4_A_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_SC_A_WH_A_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_SC2_A_FM_C_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_SC2_A_WH_A_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_SC2F_A_FM_C_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_SC2F_A_WH_A_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index ae6f1cd4d6605..e99d691362a86 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2005-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  */
 #ifndef __IWL_CONFIG_H__
 #define __IWL_CONFIG_H__
@@ -418,6 +418,8 @@ struct iwl_cfg {
 #define IWL_CFG_MAC_TYPE_BZ		0x46
 #define IWL_CFG_MAC_TYPE_GL		0x47
 #define IWL_CFG_MAC_TYPE_SC		0x48
+#define IWL_CFG_MAC_TYPE_SC2		0x49
+#define IWL_CFG_MAC_TYPE_SC2F		0x4A
 
 #define IWL_CFG_RF_TYPE_TH		0x105
 #define IWL_CFG_RF_TYPE_TH1		0x108
@@ -527,6 +529,8 @@ extern const char iwl_ax231_name[];
 extern const char iwl_ax411_name[];
 extern const char iwl_bz_name[];
 extern const char iwl_sc_name[];
+extern const char iwl_sc2_name[];
+extern const char iwl_sc2f_name[];
 #if IS_ENABLED(CONFIG_IWLDVM)
 extern const struct iwl_cfg iwl5300_agn_cfg;
 extern const struct iwl_cfg iwl5100_agn_cfg;
@@ -632,6 +636,8 @@ extern const struct iwl_cfg iwl_cfg_bz;
 extern const struct iwl_cfg iwl_cfg_gl;
 
 extern const struct iwl_cfg iwl_cfg_sc;
+extern const struct iwl_cfg iwl_cfg_sc2;
+extern const struct iwl_cfg iwl_cfg_sc2f;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 271be64ce19ae..ba3db601ab878 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2005-2014, 2018-2023 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2024 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -509,6 +509,9 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* Sc devices */
 	{IWL_PCI_DEVICE(0xE440, PCI_ANY_ID, iwl_sc_trans_cfg)},
+	{IWL_PCI_DEVICE(0xE340, PCI_ANY_ID, iwl_sc_trans_cfg)},
+	{IWL_PCI_DEVICE(0xD340, PCI_ANY_ID, iwl_sc_trans_cfg)},
+	{IWL_PCI_DEVICE(0x6E70, PCI_ANY_ID, iwl_sc_trans_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
@@ -1116,6 +1119,16 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_cfg_sc, iwl_sc_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SC2, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_sc2, iwl_sc2_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SC2F, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_sc2f, iwl_sc2f_name),
 #endif /* CONFIG_IWLMVM */
 };
 
-- 
2.43.0



