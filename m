Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8F136348;
	Mon, 23 Jun 2025 21:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715329; cv=none; b=AJ/gkV4/LXdooTb9Upu56oqOlZFdl1XgS/RRyZAnw14tQGtP8rnH/Mb3CEHlyyjJconrkz+j5IdHUQEGcZBNtrOMAkFSJSLapoWvD/VZu7dD/ly0X2qD2fx/hmxUvnm5ow3W6dvm/dAoNi2ESAGW4yWWPn4PSBMq11DVMFzridI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715329; c=relaxed/simple;
	bh=EnHTfcbo39MC5bf9LEHjUpORicMi+0rGQihQJM0tnnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaZzJ7zYzNSsj/wfFPfDHe772mr3m7wVZ7ZyaHv9uRzeAPdvhf4JzEcK2OHTNr5HwTHGhT1BHAhDNsnrY9S3EW0M6b5w+HSoVG0k0ESKgNaQbl5xVxLwVeYO9GpGLU5MWF9rM3QEh+UYFaX0awCfR/TBk3lDiLyGMabzy1+B8gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc/EGSpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc/EGSpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D349CC4CEEA;
	Mon, 23 Jun 2025 21:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715329;
	bh=EnHTfcbo39MC5bf9LEHjUpORicMi+0rGQihQJM0tnnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc/EGSpO3ZlcExN8DDdfAqq/K+3ev/22b7gfX4tKVfkvi6w2SK25l8ebEGzTQI4TF
	 JEvnU1h1FP3jVK3P63fB500n8NzdnrdEjp12oIB5PXoyXbcFMvX7NbZd6s/z1t/nJp
	 RpwK2UjYzijDk5MHhPE++k+m5tIVyNVlCDTjYlYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Govindaraj Saminathan <quic_gsaminat@quicinc.com>,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/508] wifi: ath11k: remove unused function ath11k_tm_event_wmi()
Date: Mon, 23 Jun 2025 15:04:33 +0200
Message-ID: <20250623130650.870136066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Govindaraj Saminathan <quic_gsaminat@quicinc.com>

[ Upstream commit 86f85575a3f6a20cef1c8bb98e78585fe3a53ccc ]

The function ath11k_tm_event_wmi() is only defined and it is not used
anywhere. Hence remove the unused.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: Govindaraj Saminathan <quic_gsaminat@quicinc.com>
Signed-off-by: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230517135934.16408-2-quic_rajkbhag@quicinc.com
Stable-dep-of: 9f6e82d11bb9 ("wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/testmode.c | 64 +---------------------
 drivers/net/wireless/ath/ath11k/testmode.h |  8 +--
 2 files changed, 2 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/testmode.c b/drivers/net/wireless/ath/ath11k/testmode.c
index 4bf1931adbaae..ebeca5eb6a67a 100644
--- a/drivers/net/wireless/ath/ath11k/testmode.c
+++ b/drivers/net/wireless/ath/ath11k/testmode.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include "testmode.h"
@@ -20,69 +21,6 @@ static const struct nla_policy ath11k_tm_policy[ATH11K_TM_ATTR_MAX + 1] = {
 	[ATH11K_TM_ATTR_VERSION_MINOR]	= { .type = NLA_U32 },
 };
 
-/* Returns true if callee consumes the skb and the skb should be discarded.
- * Returns false if skb is not used. Does not sleep.
- */
-bool ath11k_tm_event_wmi(struct ath11k *ar, u32 cmd_id, struct sk_buff *skb)
-{
-	struct sk_buff *nl_skb;
-	bool consumed;
-	int ret;
-
-	ath11k_dbg(ar->ab, ATH11K_DBG_TESTMODE,
-		   "testmode event wmi cmd_id %d skb %pK skb->len %d\n",
-		   cmd_id, skb, skb->len);
-
-	ath11k_dbg_dump(ar->ab, ATH11K_DBG_TESTMODE, NULL, "", skb->data, skb->len);
-
-	spin_lock_bh(&ar->data_lock);
-
-	consumed = true;
-
-	nl_skb = cfg80211_testmode_alloc_event_skb(ar->hw->wiphy,
-						   2 * sizeof(u32) + skb->len,
-						   GFP_ATOMIC);
-	if (!nl_skb) {
-		ath11k_warn(ar->ab,
-			    "failed to allocate skb for testmode wmi event\n");
-		goto out;
-	}
-
-	ret = nla_put_u32(nl_skb, ATH11K_TM_ATTR_CMD, ATH11K_TM_CMD_WMI);
-	if (ret) {
-		ath11k_warn(ar->ab,
-			    "failed to put testmode wmi event cmd attribute: %d\n",
-			    ret);
-		kfree_skb(nl_skb);
-		goto out;
-	}
-
-	ret = nla_put_u32(nl_skb, ATH11K_TM_ATTR_WMI_CMDID, cmd_id);
-	if (ret) {
-		ath11k_warn(ar->ab,
-			    "failed to put testmode wmi even cmd_id: %d\n",
-			    ret);
-		kfree_skb(nl_skb);
-		goto out;
-	}
-
-	ret = nla_put(nl_skb, ATH11K_TM_ATTR_DATA, skb->len, skb->data);
-	if (ret) {
-		ath11k_warn(ar->ab,
-			    "failed to copy skb to testmode wmi event: %d\n",
-			    ret);
-		kfree_skb(nl_skb);
-		goto out;
-	}
-
-	cfg80211_testmode_event(nl_skb, GFP_ATOMIC);
-
-out:
-	spin_unlock_bh(&ar->data_lock);
-
-	return consumed;
-}
-
 static int ath11k_tm_cmd_get_version(struct ath11k *ar, struct nlattr *tb[])
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath11k/testmode.h b/drivers/net/wireless/ath/ath11k/testmode.h
index aaa122ed90697..ffdb0c30b276c 100644
--- a/drivers/net/wireless/ath/ath11k/testmode.h
+++ b/drivers/net/wireless/ath/ath11k/testmode.h
@@ -1,24 +1,18 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include "core.h"
 
 #ifdef CONFIG_NL80211_TESTMODE
 
-bool ath11k_tm_event_wmi(struct ath11k *ar, u32 cmd_id, struct sk_buff *skb);
 int ath11k_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  void *data, int len);
 
 #else
 
-static inline bool ath11k_tm_event_wmi(struct ath11k *ar, u32 cmd_id,
-				       struct sk_buff *skb)
-{
-	return false;
-}
-
 static inline int ath11k_tm_cmd(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				void *data, int len)
-- 
2.39.5



