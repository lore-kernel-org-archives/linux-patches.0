Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3D227E1CA;
	Tue, 27 May 2025 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364854; cv=none; b=jppRSiCgZlO79e/bqLMjKMgtELPdt1qEVE9mP+6Hwag05No4tV3rNEGRdun2webdKmD+qENbA2GLX6hsYrssEZvFbK31GGagmFQBKzYSM4K7hUGvsgyUPaUurtyJT/WA/rVPNeiFuXE/0k9mhrfdSJKQ/Gsk+kHRnxg99ThTVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364854; c=relaxed/simple;
	bh=Xf6XMGJmtyKqapGEUxKX0Rk9VLw4IRIbsA9pDVix7RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+piJtLWEdaBk2022y0LdjGMGBjKdWEgfrZiBno134mkpP+OV4W9Edky2m1dfMfyq4CEQynw9ed1YuHTJonVxL2SBUW9OJBNzZMv1auDvkjObDbvzu2pGe/UuHY25AMoyNzJK/fTu4C+nmlgUan469tmA3OtOnX9U7Z5D31tW40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+uvDs1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+uvDs1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEA4C4CEE9;
	Tue, 27 May 2025 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364854;
	bh=Xf6XMGJmtyKqapGEUxKX0Rk9VLw4IRIbsA9pDVix7RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+uvDs1MsEhQO5o7/7XbVvuTHDwZcP32jMdpaL7MZkaVjrLUGIga4VrL2xp2QE3BE
	 A/BSzfkufO6PeJxPHWsVI6yENkPvrrVmdrMZeKbBOMCIYLfyHcGZ+NfvJ7XqIddKXR
	 L3kPnVKAsu46/QnDkJa8t7FIY194Fae5iO5ErTrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/626] wifi: iwlwifi: fix the ECKV UEFI variable name
Date: Tue, 27 May 2025 18:21:21 +0200
Message-ID: <20250527162452.653520373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 3ea2970b0578011ab8402ad0cff39712255f63df ]

This UEFI variable name was badly named. Fix its name and also use the
right GUID to find it: we need to use the BT_WIFI (a.k.a. Common) GUID.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231426.78c998d0fa71.I2bc9d72c1dc2c4d7028f0265634a940c2fadbbb5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 8 +++++---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 834f7c9bb9e92..86d6286a15378 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright(c) 2021-2024 Intel Corporation
+ * Copyright(c) 2021-2025 Intel Corporation
  */
 
 #include "iwl-drv.h"
@@ -673,8 +673,10 @@ int iwl_uefi_get_eckv(struct iwl_fw_runtime *fwrt, u32 *extl_clk)
 	struct uefi_cnv_var_eckv *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_ECKV_NAME,
-					      "ECKV", sizeof(*data), NULL);
+	data = iwl_uefi_get_verified_variable_guid(fwrt->trans,
+						   &IWL_EFI_WIFI_BT_GUID,
+						   IWL_UEFI_ECKV_NAME,
+						   "ECKV", sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index e525d449e656e..c931f5cedb0b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright(c) 2021-2024 Intel Corporation
+ * Copyright(c) 2021-2025 Intel Corporation
  */
 #ifndef __iwl_fw_uefi__
 #define __iwl_fw_uefi__
@@ -19,7 +19,7 @@
 #define IWL_UEFI_WTAS_NAME		L"UefiCnvWlanWTAS"
 #define IWL_UEFI_SPLC_NAME		L"UefiCnvWlanSPLC"
 #define IWL_UEFI_WRDD_NAME		L"UefiCnvWlanWRDD"
-#define IWL_UEFI_ECKV_NAME		L"UefiCnvWlanECKV"
+#define IWL_UEFI_ECKV_NAME		L"UefiCnvCommonECKV"
 #define IWL_UEFI_DSM_NAME		L"UefiCnvWlanGeneralCfg"
 #define IWL_UEFI_WBEM_NAME		L"UefiCnvWlanWBEM"
 #define IWL_UEFI_PUNCTURING_NAME	L"UefiCnvWlanPuncturing"
-- 
2.39.5



