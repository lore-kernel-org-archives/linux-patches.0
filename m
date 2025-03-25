Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7644A26B084;
	Tue, 25 Mar 2025 12:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906211; cv=none; b=VwP4Q9G5GUHUi8T/g6gqxHK99GQQI/H8eem3f5WjgZkHjgiIjxoGzdf+t8dvEe7rjJcw9WpIc7b3EwjuKlZYzuEfFKtOxTiKxZhE12RDSmai8+vTGtD27dJZvvCx88rhPf+vPmTDxMFDvfZgGO+liN+O6rFgcMCJCFcpOwj4nYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906211; c=relaxed/simple;
	bh=y6WSTEbqSaVwLMI/mrhxWe1OevroLVO+SubMV0a91Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umRYRILHhSbns48J9Gd7hi1YfD8JtofcJXLI5jg/KprntuFPJFbLzArTCurNAPMLwhtletYMSoqOD5VizLx9FMTK9AyMf5oWhuPQZ40pGNKnJXFwDs+NY9pLQdDYLc8liQNU7eoZTH/aGJMjFu+FCqfkdSS2yxp7SKJlaCPsa20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OTXvHkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OTXvHkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3588C4CEE4;
	Tue, 25 Mar 2025 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906210;
	bh=y6WSTEbqSaVwLMI/mrhxWe1OevroLVO+SubMV0a91Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OTXvHkPhbvpfqYBCYnWBckot/PCjE6/gQSh1l7sHW91CsQS8B01mp8tPUwZ2ZSV+
	 O2nhzvCaLrH6vyo6r9+jMoDL/GHenxsYYrXXEj+u1QK/AXw2nXtowsTBsL0x+ow5W5
	 ER6rYdmbcAJVrw6CiQpIHdvOFgiFqAkmAGepjIEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6.6 75/77] wifi: iwlwifi: support BIOS override for 5G9 in CA also in LARI version 8
Date: Tue, 25 Mar 2025 08:23:10 -0400
Message-ID: <20250325122146.406017762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

commit b1e8102a4048003097c7054cbc00bbda91a5ced7 upstream.

Commit 6b3e87cc0ca5 ("iwlwifi: Add support for LARI_CONFIG_CHANGE_CMD
cmd v9")
added a few bits to iwl_lari_config_change_cmd::oem_unii4_allow_bitmap
if the FW has LARI version >= 9.
But we also need to send those bits for version 8 if the FW is capable
of this feature (indicated with capability bits)
Add the FW capability bit, and set the additional bits in the cmd when
the version is 8 and the FW capability bit is set.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20241226174257.dc5836f84514.I1e38f94465a36731034c94b9811de10cb6ee5921@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h |    4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |   37 +++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -372,6 +372,8 @@ typedef unsigned int __bitwise iwl_ucode
  *      channels even when these are not enabled.
  * @IWL_UCODE_TLV_CAPA_DUMP_COMPLETE_SUPPORT: Support for indicating dump collection
  *	complete to FW.
+ * @IWL_UCODE_TLV_CAPA_BIOS_OVERRIDE_5G9_FOR_CA: supports (de)activating 5G9
+ *	for CA from BIOS.
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -468,7 +470,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_OFFLOAD_BTM_SUPPORT		= (__force iwl_ucode_tlv_capa_t)113,
 	IWL_UCODE_TLV_CAPA_STA_EXP_MFP_SUPPORT		= (__force iwl_ucode_tlv_capa_t)114,
 	IWL_UCODE_TLV_CAPA_SNIFF_VALIDATE_SUPPORT	= (__force iwl_ucode_tlv_capa_t)116,
-
+	IWL_UCODE_TLV_CAPA_BIOS_OVERRIDE_5G9_FOR_CA	= (__force iwl_ucode_tlv_capa_t)123,
 #ifdef __CHECKER__
 	/* sparse says it cannot increment the previous enum member */
 #define NUM_IWL_UCODE_TLV_CAPA 128
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1195,11 +1195,30 @@ static u8 iwl_mvm_eval_dsm_rfi(struct iw
 	return DSM_VALUE_RFI_DISABLE;
 }
 
+enum iwl_dsm_unii4_bitmap {
+	DSM_VALUE_UNII4_US_OVERRIDE_MSK		= BIT(0),
+	DSM_VALUE_UNII4_US_EN_MSK		= BIT(1),
+	DSM_VALUE_UNII4_ETSI_OVERRIDE_MSK	= BIT(2),
+	DSM_VALUE_UNII4_ETSI_EN_MSK		= BIT(3),
+	DSM_VALUE_UNII4_CANADA_OVERRIDE_MSK	= BIT(4),
+	DSM_VALUE_UNII4_CANADA_EN_MSK		= BIT(5),
+};
+
+#define DSM_UNII4_ALLOW_BITMAP (DSM_VALUE_UNII4_US_OVERRIDE_MSK		|\
+				DSM_VALUE_UNII4_US_EN_MSK		|\
+				DSM_VALUE_UNII4_ETSI_OVERRIDE_MSK	|\
+				DSM_VALUE_UNII4_ETSI_EN_MSK		|\
+				DSM_VALUE_UNII4_CANADA_OVERRIDE_MSK	|\
+				DSM_VALUE_UNII4_CANADA_EN_MSK)
+
 static void iwl_mvm_lari_cfg(struct iwl_mvm *mvm)
 {
 	int ret;
 	u32 value;
 	struct iwl_lari_config_change_cmd_v6 cmd = {};
+	u8 cmd_ver = iwl_fw_lookup_cmd_ver(mvm->fw,
+					   WIDE_ID(REGULATORY_AND_NVM_GROUP,
+						   LARI_CONFIG_CHANGE), 1);
 
 	cmd.config_bitmap = iwl_acpi_get_lari_config_bitmap(&mvm->fwrt);
 
@@ -1211,8 +1230,22 @@ static void iwl_mvm_lari_cfg(struct iwl_
 	ret = iwl_acpi_get_dsm_u32(mvm->fwrt.dev, 0,
 				   DSM_FUNC_ENABLE_UNII4_CHAN,
 				   &iwl_guid, &value);
-	if (!ret)
-		cmd.oem_unii4_allow_bitmap = cpu_to_le32(value);
+	if (!ret) {
+		u32 _value = cpu_to_le32(value);
+
+		_value &= DSM_UNII4_ALLOW_BITMAP;
+
+		/* Since version 9, bits 4 and 5 are supported
+		 * regardless of this capability.
+		 */
+		if (cmd_ver < 9 &&
+		    !fw_has_capa(&mvm->fw->ucode_capa,
+				 IWL_UCODE_TLV_CAPA_BIOS_OVERRIDE_5G9_FOR_CA))
+			_value &= ~(DSM_VALUE_UNII4_CANADA_OVERRIDE_MSK |
+				   DSM_VALUE_UNII4_CANADA_EN_MSK);
+
+		cmd.oem_unii4_allow_bitmap = cpu_to_le32(_value);
+	}
 
 	ret = iwl_acpi_get_dsm_u32(mvm->fwrt.dev, 0,
 				   DSM_FUNC_ACTIVATE_CHANNEL,


