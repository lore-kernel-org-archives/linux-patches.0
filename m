Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AAD3A8DB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKeDnAlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C276AC433C9;
	Wed, 15 Nov 2023 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076056;
	bh=/Q13S/NuJUrwJBmVRDZgU4x+jKl3vpbiJIMJh/+KJe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKeDnAlqsBWptXZZoydyX1q21WrywdxG2J9oa38/6wSFn+UjqmgKF0RfJawfuVcv3
	 iSSFjYr5/ZLl/ojDM9PJ5olMzWm5Gwcu7dImW7crLCR6jKerNEkBL2d8V/Wkd00cTv
	 hjhGshbFpwSgQ/iCEJbjX+w4AlXPnm/Ecqb5S1J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 047/550] wifi: iwlwifi: dont use an uninitialized variable
Date: Wed, 15 Nov 2023 14:10:31 -0500
Message-ID: <20231115191603.968711639@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



