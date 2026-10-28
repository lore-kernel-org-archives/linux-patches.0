Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216623;
	b=O77Z5l04X8zl3OkL+RbHy1MP/BNxAfc7dchznEVQmozTnywhY3GOT/VrNvaPiewG2OX/
	 GEp9z8joy+cFdoeK+sgM9CIyHEvjgzzYklip6aUGpzlfG81VizO6+R/tSD1k8PM8hciw2
	 LO+O+4CERrrMjRROG0ovSrmRMGZ1bAWjxkCWPglncfoYNtIymGur6yJHEFiV8bdeclT7F
	 7eQO27TvDdcOBznbwjd/gxFNpIRIWpGrX+He8BkqhD/emADgWAzX3Wl3sAOgp3mVVtCh5
	 WRJa4TrSZfrJUcVYMmHqsDRz08BWonSuxZlrhOt6DO4q2hMRqFqTb+BXdMK0VwW16rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ZCkVOFpTC8dLubKJZfiEqFrtkZiKJ+8phIBqJbvlwQ=;
	b=wA2wtekVGhYSStpDfsUTmdULZoyPT6nG12OrdiQk/16ayT2jLgj67az6rG2/P90s4COK
	 ttooheR9yi2tmnq3W4zI7W3sXTjAp3Lru6bRlbrGDTwW1vDFot0dYGLNzA3fL0cJd3dfQ
	 5XumNjWZR6HaWG6NGxYy3YXcBJEyAU9PcbjxNYEuKo2goR4jiMMMyLlwdSKF2BTdp8C7Z
	 KnSiGT+F3lNhElHLcj/EXa+R8GRbpmgaUnitwTkswAxDVyukRvzBap7xucqA0ow2N7uI/
	 v5Qp2raEsfGgKlUSDVZ1Hj4LVQRZuNnFW5DPWsCDvskJ/t4bPJXM7Xm29zZL+Mzbu0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8Ek7j5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5838D606A31A;
	Wed, 28 Oct 2026 19:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8Ek7j5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC201F01825;
	Wed, 28 Oct 2026 19:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216623;
	bh=9ZCkVOFpTC8dLubKJZfiEqFrtkZiKJ+8phIBqJbvlwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8Ek7j5ZK4TypCWUzgAmpzJx6jHnEBaPlbuWJkncrQKwS6+w0RM3TDdqaKUPnppzw
	 1VhDG+hP1BCBgzJjdBnnnGBFb06yiTqMM8MXzo03zmfA5gnLsd3BAspxLUOqWVxvtl
	 6VvJ0rfcNZ0pRvv4+9qPI4Bsb+14rXDk5GqFLLn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1621/1887] wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments
Date: Wed, 28 Oct 2026 18:01:57 +0100
Message-ID: <20261028170536.357557634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 9318bc0c41b24705690cf80d1596cf6b711e7027 ]

Make sure we don't end-up with a num_frags = 0 situation.
For that, check that the required size is not 0 and put a checker on
num_frags as well.

Fixes: 14124b25780d ("iwlwifi: dbg_ini: implement monitor allocation flow")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.60121deecf2c.Iebc891c95a7bd1b2a093b0bb88532db446a758ee@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index a14a4437a0940..1e1d2ab871ff0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -597,6 +597,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 	    cpu_to_le32(IWL_FW_INI_LOCATION_DRAM_PATH))
 		return 0;
 
+	if (!fw_mon_cfg->req_size)
+		return -EIO;
+
 	num_frags = le32_to_cpu(fw_mon_cfg->max_frags_num);
 	if (fwrt->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
 		if (alloc_id != IWL_FW_INI_ALLOCATION_ID_DBGC1)
@@ -604,6 +607,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 		num_frags = 1;
 	}
 
+	if (!num_frags)
+		return -EIO;
+
 	remain_pages = DIV_ROUND_UP(le32_to_cpu(fw_mon_cfg->req_size),
 				    PAGE_SIZE);
 	num_frags = min_t(u32, num_frags, BUF_ALLOC_MAX_NUM_FRAGS);
-- 
2.53.0



