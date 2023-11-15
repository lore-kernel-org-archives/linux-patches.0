Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0592D31725
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WABVMcJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7AFC433C7;
	Wed, 15 Nov 2023 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077166;
	bh=nyXd9pkV2hyd0bW9i29JGQVGLxXfi1LeRhjedBp20oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WABVMcJgdYepIO9VwVTfkjWEoV5/hrHVWy67ofco7SCllGl8Yqcp4Zuppkve6L27q
	 ONiBJd/MKKFi5TlKD1BxMvhZ4Mt1icfvZV7Tw9iOm2wNZWFj38JBOugwz9j/hkAnFU
	 Ur/YVgQ/fB53ZOtPMt8MqLp03bErA+rfzteG820I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/603] wifi: iwlwifi: mvm: remove TDLS stations from FW
Date: Wed, 15 Nov 2023 14:11:27 -0500
Message-ID: <20231115191623.020763884@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b404c5cff3d4270fcd5212b6776c8484623ac74 ]

When we remove TDLS stations, we need to remove them from FW
immediately, even while associated. Some previous refactoring
here lost the sta ID condition, add it back.

Fixes: 57974a55d995 ("wifi: iwlwifi: mvm: refactor iwl_mvm_mac_sta_state_common()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231011130030.933011e710a9.I77c069c781e8b2b698b86cc3f43fc3c7e2dde114@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ebbe165510587..2c231f4623893 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2059,7 +2059,8 @@ bool iwl_mvm_sta_del(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		*status = IWL_MVM_QUEUE_FREE;
 	}
 
-	if (vif->type == NL80211_IFTYPE_STATION) {
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    mvm_link->ap_sta_id == sta_id) {
 		/* if associated - we can't remove the AP STA now */
 		if (vif->cfg.assoc)
 			return true;
-- 
2.42.0



