Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EACF1607B0;
	Mon, 27 May 2024 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836567; cv=none; b=ApUQU62KeMQvenx7V2HxKpe2XQspr/P8Wp6GJqdGPN5p9AaRFHF5R3I+ilUxw3vjwjGUOjvx5Dd1d9DF7yxHSBycfYDmcEZuapUqeAH6RFrja3VZ0fiNgS7g94an2kPLXT7cwkQplFERJG9hO3p0bSKSp4FgCgHkuZpv4S2wbWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836567; c=relaxed/simple;
	bh=HQVn0yuVX0pmczZH5B/KYmQUfuEdy+GqYPM81OISfvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4DCkDmDdxPkJbMc18pboWuxyI4vylCgszKtMnv7GdR1esVAyTHzU9LCuUj2F5RhX6kjLrNpBZbNsbBDv8EzbXJWO7gCYUK31IHRCS3WpkJlkRmADsJFLK9E2wpcU8wdE9KTNBqeASfPHmGSaW+d0fsIahsIs8F+OgdYaYzAtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVV9Pe2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVV9Pe2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE37C32782;
	Mon, 27 May 2024 19:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836566;
	bh=HQVn0yuVX0pmczZH5B/KYmQUfuEdy+GqYPM81OISfvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVV9Pe2jvyJJkwIdExI+nD359KANzdqbBiyz68OJGlytYC5SPFdyJJs+zu1BPhrs8
	 2WYR5wRL3x9rfCqgXB4FY09eEBZ/vZccR1WgwQdWYle2x+91xbZAVjJadNwJFgrOSP
	 UrSpDHMGVPUjLJSYe3Rma/7MlYgEl33OTLv0UQlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 105/427] wifi: iwlwifi: mvm: set wider BW OFDMA ignore correctly
Date: Mon, 27 May 2024 20:52:32 +0200
Message-ID: <20240527185611.582273775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b97b0c04f895003ec60b08879180068889d19c9e ]

Clearly, I put this flag into the wrong place: devices using the
code in mac80211.c only do not support EHT, so this isn't even
relevant. Fix this by moving the code to the right function.

Fixes: 32a5690e9acb ("wifi: iwlwifi: mvm: support wider-bandwidth OFDMA")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.0d5fb0e971e4.I3b67c5e0ddcbe6e58143ec0bc4e40dd6dba4f863@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     | 3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8f4b063d6243e..5d937d647d98d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1651,9 +1651,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 				     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 	}
 
-	if (vif->p2p || iwl_fw_lookup_cmd_ver(mvm->fw, PHY_CONTEXT_CMD, 1) < 5)
-		vif->driver_flags |= IEEE80211_VIF_IGNORE_OFDMA_WIDER_BW;
-
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		mvm->p2p_device_vif = vif;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index d18304ac126cd..5a4973431c8b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -92,6 +92,9 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->csme_vif = vif;
 	}
 
+	if (vif->p2p || iwl_fw_lookup_cmd_ver(mvm->fw, PHY_CONTEXT_CMD, 1) < 5)
+		vif->driver_flags |= IEEE80211_VIF_IGNORE_OFDMA_WIDER_BW;
+
 	goto out_unlock;
 
  out_free_bf:
-- 
2.43.0



