Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BB82EA752;
	Tue, 22 Jul 2025 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193597; cv=none; b=SnCJwvk5UxMah/2iuwd9NSOsAIlcPVkJ2cIQfhyyYH5lpdaQ4hNYThZX4vyP3EbRkJ1lX3emOkfV1R5+pTWnZhMfjYaqX1dNpEpTg3FdkwM4HREpCK5qBuEschnQiJnPakOdrMVKjT0CmvKlJQvKZC8hoTj/Q0cx+3hYRD6K+Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193597; c=relaxed/simple;
	bh=XdVvzkzECuW7m1A6FPfpvU3QVVPkCsy9PHTcNU67l2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKxhpoVDy6sLb10tXM7v5J8WG7JblX/E694oMvCng45ioiAE/ECjv9SqAHG9yKie0sHHoYftDD9FXRz5SSduKSLp7EK8LgQ+kBEyCwjdCYtXjKz3EkDUCeY02j9JIA91ZNioPO/V6gu/ig8eYruNxYI2T0G9ggcGedcqDOLXero=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNFVD+SW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNFVD+SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BF8C4CEEB;
	Tue, 22 Jul 2025 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193597;
	bh=XdVvzkzECuW7m1A6FPfpvU3QVVPkCsy9PHTcNU67l2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNFVD+SWprWTkU5mIvoe3yz1UGrNcVXoiKVJybMxOwvkpoxJX3sEbZjHT3Cq7wMVV
	 qIVo3ZjnyFwzydhmOIfomBLgEQCUYuNGU/Ibs0FLWDGXemlgiJS2gSuLn18j52/IE8
	 ntC5bvkKHRqHC5JHGB0gVNhNM2UXNNHzpoyWPVmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 107/187] wifi: iwlwifi: mask reserved bits in chan_state_active_bitmap
Date: Tue, 22 Jul 2025 15:44:37 +0200
Message-ID: <20250722134349.753771979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit 5fde0fcbd7608dd5f97a5c0c23a316074d6f17f5 ]

Mask the reserved bits as firmware will assert if reserved bits are set.

Fixes: ef7ddf4e2f94 ("wifi: iwlwifi: Add support for LARI_CONFIG_CHANGE_CMD v12")
Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709065608.7a72c70bdc9d.Ic9be0a3fc3aabde0c4b88568f3bb7b76e375f8d4@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h | 5 +++--
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c  | 1 +
 drivers/net/wireless/intel/iwlwifi/mld/regulatory.c | 4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 5cdc09d465d4f..e90f3187e55c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -754,7 +754,7 @@ struct iwl_lari_config_change_cmd_v10 {
  *	according to the BIOS definitions.
  *	For LARI cmd version 11 - bits 0:4 are supported.
  *	For LARI cmd version 12 - bits 0:6 are supported and bits 7:31 are
- *	reserved. No need to mask out the reserved bits.
+ *	reserved.
  * @force_disable_channels_bitmap: Bitmap of disabled bands/channels.
  *	Each bit represents a set of channels in a specific band that should be
  *	disabled
@@ -787,6 +787,7 @@ struct iwl_lari_config_change_cmd {
 /* Activate UNII-1 (5.2GHz) for World Wide */
 #define ACTIVATE_5G2_IN_WW_MASK			BIT(4)
 #define CHAN_STATE_ACTIVE_BITMAP_CMD_V11	0x1F
+#define CHAN_STATE_ACTIVE_BITMAP_CMD_V12	0x7F
 
 /**
  * struct iwl_pnvm_init_complete_ntfy - PNVM initialization complete
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 6adcfa6e214a0..9947ab7c2f4b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -603,6 +603,7 @@ int iwl_fill_lari_config(struct iwl_fw_runtime *fwrt,
 
 	ret = iwl_bios_get_dsm(fwrt, DSM_FUNC_ACTIVATE_CHANNEL, &value);
 	if (!ret) {
+		value &= CHAN_STATE_ACTIVE_BITMAP_CMD_V12;
 		if (cmd_ver < 8)
 			value &= ~ACTIVATE_5G2_IN_WW_MASK;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index a75af8c1e8ab0..2116b717b9267 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -251,8 +251,10 @@ void iwl_mld_configure_lari(struct iwl_mld *mld)
 			cpu_to_le32(value &= DSM_UNII4_ALLOW_BITMAP);
 
 	ret = iwl_bios_get_dsm(fwrt, DSM_FUNC_ACTIVATE_CHANNEL, &value);
-	if (!ret)
+	if (!ret) {
+		value &= CHAN_STATE_ACTIVE_BITMAP_CMD_V12;
 		cmd.chan_state_active_bitmap = cpu_to_le32(value);
+	}
 
 	ret = iwl_bios_get_dsm(fwrt, DSM_FUNC_ENABLE_6E, &value);
 	if (!ret)
-- 
2.39.5



