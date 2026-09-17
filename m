Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61D54F3ED6;
	Thu, 17 Sep 2026 16:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664088; cv=none; b=Exw7SNdHbRqZGDMMt7Fcw4klWcDhv+m9+nizIpaDB+caAJGPXw1EW5S4oaeifA9rVlniTDUPlo7Eq6OAbyavnitPLbcBEJoUOTNhqhK14LMOmYVblriSRPfi3RIylXZOfjB8LkUSmkYOq1/ocdC5FzUWPkyFfzwLGebYU1uujqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664088; c=relaxed/simple;
	bh=AtBmawzEmeAYGQiXDTLL26gD7wFTwF1gk4WUDuxuLW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXvVcHplnS+1BT928D3zFOEWv00y58MyDtbqNnsyKHmanwT+C+0rVQz6Gf/vUCQDsmGFAzz6Shl25lbbCHaXnKSKVKYJrwyng+bvLk4dsSXIOqZQjz4i6UwZ3NH2o+ig9+bmDi2LiRFp/zxX9YpW3CM74P8Zor+RhFSxSTyBzqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWDK4KtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWDK4KtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0823B1F000FF;
	Thu, 17 Sep 2026 16:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664087;
	bh=Xllc9YY3fQvd8mKH9n4kinvFuUqPFwQdywedYRq0LRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWDK4KtD1tr6iJHPVtDoXC2dMwXg/cx/FIEDU3KGX8qcDQ+bTw2SbeMH6LNuEFfVw
	 xAfdy2uEgNJu24aJw763v9J//+2mwxD0feG5HaP+7Wy4SUBEjAla/CZHN3C69cypJy
	 21F61Ob4aQEcMoEwIRKyO2cUkth5gy+PiH9HdFWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0217/1250] wifi: iwlwifi: mld: disallow puncturing in US/CA for WH
Date: Thu, 17 Sep 2026 16:00:12 +0100
Message-ID: <20260917151558.017395090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit ce2edf7c3910cb3222d51c0a7457b7a71703a5b1 ]

FM continues to follow the BIOS/MCC policy, while WH sets
DISALLOW_PUNCTURING for US/CA and clears it for other MCC values.
Update the MCC handling accordingly.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260515150751.df1f1fdd141f.I900c9e2e3dd722619db12ba10d0879a56a2a55f2@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
index 16bb1b4904f99..8502129abe493 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 
 #include <net/cfg80211.h>
@@ -129,7 +129,7 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 
 	mld->mcc_src = resp->source_id;
 
-	/* FM is the earliest supported and later always do puncturing */
+	/* FM follows BIOS/MCC policy, WH disallows puncturing only in US/CA. */
 	if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) == IWL_CFG_RF_TYPE_FM) {
 		if (!iwl_puncturing_is_allowed_in_bios(mld->bios_enable_puncturing,
 						       le16_to_cpu(resp->mcc)))
@@ -137,6 +137,15 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 		else
 			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
 				    mld->hw->flags);
+	} else if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) ==
+			IWL_CFG_RF_TYPE_WH) {
+		u16 mcc = le16_to_cpu(resp->mcc);
+
+		if (mcc == IWL_MCC_US || mcc == IWL_MCC_CANADA)
+			ieee80211_hw_set(mld->hw, DISALLOW_PUNCTURING);
+		else
+			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
+				    mld->hw->flags);
 	}
 
 out:
-- 
2.53.0



