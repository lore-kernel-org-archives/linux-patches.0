Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4525A627;
	Tue, 27 May 2025 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367015; cv=none; b=XBrdRIZ0NaPk2k5vQ9OPit5UqxGCeB6HUr3Uqx0AeMaaquodD0gKeVjP1SUmkIbCVLWFAGhMmcabQOfxDN9TRiUq5MlxbrjM6vnyeD/J9RmZ2QW/ZwXSl3WJLEr4qtc5amsqm5qOAoWj2gxN0a8Lq+2TF7hHaC/0/KRmAQ+CpZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367015; c=relaxed/simple;
	bh=w6Dr/vKjgmaMsnL9ESLVYzlX0cB3yF66lhvoWL/Sqk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtDlUDzUbX8JI+bHb+wWrdSpJXrEo0/sVTULlL15zaJ41wrucM8XS8Tlt9TvKUTft+wNVpDR6/9WXUHMFez+tqQvSjWjKVAhXg4Bh6h/HHnHKCq3TS2EeE1f2a3HSKyaJSUL4pEE5n73oAJlUZ0yPL75ishmXLeclJvAh1+Wjwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avbkIlZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avbkIlZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9BCC4CEE9;
	Tue, 27 May 2025 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367014;
	bh=w6Dr/vKjgmaMsnL9ESLVYzlX0cB3yF66lhvoWL/Sqk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avbkIlZyxDW+GIxVw2lqtFpZIVGl4HRh0/DciCXcL0I1doZWpGF8Zpgmn5Ua3HTmX
	 i8l3eOIdZGH579d29UIvkFgYibgZaQwtLnMdfR1bJjLxl7vYp3MAfvctj57M0Buh6Z
	 O8lYhDDn/5fR4p0lZu60zxdo+Gq3soUAXPSR4sWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 220/783] wifi: iwlwifi: fix the ECKV UEFI variable name
Date: Tue, 27 May 2025 18:20:17 +0200
Message-ID: <20250527162522.081947274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 434eed4130b90..91bcff499311d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright(c) 2021-2024 Intel Corporation
+ * Copyright(c) 2021-2025 Intel Corporation
  */
 
 #include "iwl-drv.h"
@@ -678,8 +678,10 @@ int iwl_uefi_get_eckv(struct iwl_fw_runtime *fwrt, u32 *extl_clk)
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
index 0c8943a8bd011..eb3c05417da37 100644
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



