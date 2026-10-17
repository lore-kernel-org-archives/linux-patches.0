Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A83AFCF4;
	Sat, 17 Oct 2026 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255294; cv=none; b=NvvzONUvj/YJ2UqN95WlwIK12dhFByPvG0N9Tfoo270RYfMtwlLMIDqPU7VulUZ+UGDBVGOyooc1iBpOCJPmOLAZM9Mhghp5b4RQSaM20BnE4pDjeEzWIM7tmVbUHe1sNpfyaUxaMliMDh8cqr8VaN0SZvNEEcOMtXbtsh+p2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255294; c=relaxed/simple;
	bh=8VL/kgQwaIzY8bYbNQ2wOe8iWe3INE9jPmDL3s1YEyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scr7Jzs+wEceyrrulzqxOYtTaSoZuxz5ZKsvb/LJaCbESxt9HGRD7XMY/JwK5MOHu9M0OpmOtGR8R/a7XMH3T4NDgSB9qTAUtPt51U92r/4FYC5Fa2WDBv0sc9a9LxUURVmOPZtkh/yJSbktd9wL3mU8XqFHYqtqopP1DNqChwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMLLCAlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMLLCAlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E201F000C5;
	Sat, 17 Oct 2026 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255293;
	bh=o3K7E6Mgs79ZD9E6NlBRyDo3RkLeEs1QFRZhWYlTepo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMLLCAlwwOymHHHcP4gvgoqJm0vnBOY3gIsZAAstXtjft2xIotz7cW3ejQ+pKrivX
	 NHFpF7Jco4v6brY/Zle8G7z3gbdkmdAOAsZmiBReP9Sw2+yq+L7YhntBxf9aOzs6uZ
	 aA7clmami8Uj8Ak+FgrTkgIEQ90Uou4sqLnLWaAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 728/869] wifi: iwlwifi: simplify nested if checks
Date: Sat, 17 Oct 2026 17:59:29 +0200
Message-ID: <20261017160055.615549141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 63a59880ec116cebb8a01ead28b1b23c3846ebb9 ]

In the absence of (an) else clause(s), "if (a) if (b)" is
equivalent to "if (a && b)", so simplify the code a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250102161730.7ddc9cb1ea50.If18bd94706d6c821e34c38a4704bf85dca6207b2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: b74e377cad92 ("wifi: iwlwifi: mvm: fix P2P-Device binding handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c     | 7 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/link.c        | 5 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 6 +++---
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index 458b97930059e..58e9a940024db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2012-2014, 2020 Intel Corporation
  * Copyright (C) 2016 Intel Deutschland GmbH
- * Copyright (C) 2022 Intel Corporation
+ * Copyright (C) 2022, 2024 Intel Corporation
  */
 #include <net/mac80211.h>
 #include "fw-api.h"
@@ -158,9 +158,8 @@ int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	ret = iwl_mvm_binding_update(mvm, vif, mvmvif->deflink.phy_ctxt,
 				     false);
 
-	if (!ret)
-		if (iwl_mvm_sf_update(mvm, vif, true))
-			IWL_ERR(mvm, "Failed to update SF state\n");
+	if (!ret && iwl_mvm_sf_update(mvm, vif, true))
+		IWL_ERR(mvm, "Failed to update SF state\n");
 
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index 2b06521680020..e886200924bdf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -410,9 +410,8 @@ int iwl_mvm_remove_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	ret = iwl_mvm_link_cmd_send(mvm, &cmd, FW_CTXT_ACTION_REMOVE);
 
-	if (!ret)
-		if (iwl_mvm_sf_update(mvm, vif, true))
-			IWL_ERR(mvm, "Failed to update SF state\n");
+	if (!ret && iwl_mvm_sf_update(mvm, vif, true))
+		IWL_ERR(mvm, "Failed to update SF state\n");
 
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 8903a5692dfbb..a822448ad5ea5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -139,9 +139,9 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (trans_pcie->is_down)
 		return;
 
-	if (trans->state >= IWL_TRANS_FW_STARTED)
-		if (trans_pcie->fw_reset_handshake)
-			iwl_trans_pcie_fw_reset_handshake(trans);
+	if (trans->state >= IWL_TRANS_FW_STARTED &&
+	    trans_pcie->fw_reset_handshake)
+		iwl_trans_pcie_fw_reset_handshake(trans);
 
 	trans_pcie->is_down = true;
 
-- 
2.53.0



