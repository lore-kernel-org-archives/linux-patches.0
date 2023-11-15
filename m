Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC033DB92
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHI9pd/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D6EC433CC;
	Wed, 15 Nov 2023 19:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076852;
	bh=Svh4VBjL1vGekOSyhGtAd2P1uns8ImDTTNYplEiszgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHI9pd/CvbNZhKbpdS69zNCfD4eq5rQ6Fi1HzwTaTUpmfEehXX3rxvIHia7EzkQ1s
	 DK5I+ZepPZNmFb0i7KNJZww5deUNyLMjtLJ/LgeMEUsUV15ZR9cG2r5Rrqa4kMCTVY
	 TTRePTPJDldyWDF9R6xJYMmGDSVNsMXODz32FSGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/603] wifi: iwlwifi: dont use an uninitialized variable
Date: Wed, 15 Nov 2023 14:09:51 -0500
Message-ID: <20231115191616.380055314@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c46fcc6e43d617252945e706f04e5f82a59f2b8e ]

Don't use variable err uninitialized.
The reason for removing the check instead of initializing it
in the beginning of the function is because that way
static checkers will be able to catch issues if we do something
wrong in the future.

Fixes: bf976c814c86 ("wifi: iwlwifi: mvm: implement link change ops")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230830112059.431b01bd8779.I31fc4ab35f551b85a10f974a6b18fc30191e9c35@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index b719843e94576..778a311b500bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -1089,9 +1089,6 @@ iwl_mvm_mld_change_vif_links(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (err)
-		goto out_err;
-
 	err = 0;
 	if (new_links == 0) {
 		mvmvif->link[0] = &mvmvif->deflink;
-- 
2.42.0



