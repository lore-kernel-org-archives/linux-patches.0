Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A485FEE7;
	Tue, 13 Feb 2024 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845647; cv=none; b=sm39S2DW/61Tg+ut4smeXB5QPejgUkGO5e9svncezNHik74+w3kpywc5TyOkwZYzo7OieTI821D2MfBwsIXB+ZtAh+LNKlMcqHuWnsmDmlobfkpx37VOkEtSPNBUOgJXBDXBnV7kf9H2sICp71F87LiNNcoRRVLzShgb3NYSlOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845647; c=relaxed/simple;
	bh=BqlAvf+YZWC7Z8DtOZlxzX1C3UAgM/zntHYjvKeDlJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEBQB4mBSo8o3TGcCUj1/i+GFBhHby87BuZ+8iYBF8yj+2PrsFGS6bEoXXrogO/lGi4rhYk6w5oRezqk5IIIZ7f3OcfNEWIvT5UyU46voxTJEWqfcAwlY77UJeSeEnubDdF6SpdShegXXhpIzHYT/CCcwSIvtEINbmcG6PBRKCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTHJh5Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTHJh5Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD8FC433F1;
	Tue, 13 Feb 2024 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845647;
	bh=BqlAvf+YZWC7Z8DtOZlxzX1C3UAgM/zntHYjvKeDlJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTHJh5Hvqo0Lz6KrEKy/l5JZ7WDEXZ37LaOvIcJyEn2kSLTEKFNl9Pp38kGqnf/pV
	 fb6Gsd6MHcWzcyApZpo8Mzfn1s7S7fXaZHL/7UIw86UQXpedyzrBmoxzY5yS6agbLe
	 krweOw1MppSWeTh4MSZtG+aPu/H7Fd29L4psnYV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 019/124] wifi: iwlwifi: mvm: skip adding debugfs symlink for reconfig
Date: Tue, 13 Feb 2024 18:20:41 +0100
Message-ID: <20240213171854.294181441@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 3a3ef3940798e85121066a859127e72a528dc32a ]

The function to add an interface may be called without a previous
removal if the HW is being reconfigured. As such, only add the symlink
if the hardware is not being reconfigured due to a HW_RESTART.

Fixes: c36235acb34f ("wifi: iwlwifi: mvm: rework debugfs handling")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240123200528.314395eacda4.I5823e962c3c3674b942383733debd10b3fe903e2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a64600f0ed9f..586334eee056 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1586,7 +1586,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC) {
-		iwl_mvm_vif_dbgfs_add_link(mvm, vif);
+		if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+			iwl_mvm_vif_dbgfs_add_link(mvm, vif);
 		ret = 0;
 		goto out;
 	}
@@ -1626,7 +1627,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 			iwl_mvm_chandef_get_primary_80(&vif->bss_conf.chandef);
 	}
 
-	iwl_mvm_vif_dbgfs_add_link(mvm, vif);
+	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		iwl_mvm_vif_dbgfs_add_link(mvm, vif);
 
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
 	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 61170173f917..1f36e934ef69 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -81,7 +81,8 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 		ieee80211_hw_set(mvm->hw, RX_INCLUDES_FCS);
 	}
 
-	iwl_mvm_vif_dbgfs_add_link(mvm, vif);
+	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		iwl_mvm_vif_dbgfs_add_link(mvm, vif);
 
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
 	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
-- 
2.43.0



