Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19F919923F;
	Thu,  6 Jun 2024 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683194; cv=none; b=EpiK3qgsbKL4BxwLdbjakbG6x6Rq2wy4mVqeMi+AXtsq7O1EEBJ3YMyMKbV6ISjQOHXQqzptalLMStxaeDOQ/LXb3lDEq92aL+r05WBcqpS5yrYpoi22ThL1wJ0QQG+e9tMKI7LGYladXq3yDIRw+LQCgCcPM7lEnxDi/mubqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683194; c=relaxed/simple;
	bh=ltgmatWwQkAV8oAlDMdQ+x7AtFDDo5OLME2Y8nimTP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZV1ADeZxSllc59fF7wmEVtTfR60NaxYJP8xpuMjRhAW+liei3IZWPlNOcFrmTG1r/a14lFptDMD7lXak238LeoLGEqyYFsSiaEWnPn3bV0a38Csjf7YSUHS8QXPrMfZdvBsi+ciTF1kl2j/sbsgPQtDfhhAibd5DFMeCCPjJqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzteLXN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzteLXN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFACCC32781;
	Thu,  6 Jun 2024 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683193;
	bh=ltgmatWwQkAV8oAlDMdQ+x7AtFDDo5OLME2Y8nimTP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzteLXN8sRAVwqkfQn4U66PD9NMCO5D09iKhRWuWodYjhlbbOjBgKqIDfV/RLN4pi
	 fcoyFvizgQKAdFTrAt4r+HFpCOciWjwX2RrvHzxQ06ZNfhSZp7H0U5Aiapo5LoPzNS
	 8+kM5h+5SVmGGcSiNWbeEjtSNdqEB+eyif0ZlwZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/744] wifi: iwlwifi: mvm: fix check in iwl_mvm_sta_fw_id_mask
Date: Thu,  6 Jun 2024 15:56:49 +0200
Message-ID: <20240606131736.814337204@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit d69aef8084cc72df7b0f2583096d9b037c647ec8 ]

In the previous commit, I renamed the variable to differentiate
mac80211/mvm link STA, but forgot to adjust the check. The one
from mac80211 is already non-NULL anyway, but the mvm one can
be NULL when the mac80211 isn't during link switch conditions.
Fix the check.

Fixes: 2783ab506eaa ("wifi: iwlwifi: mvm: select STA mask only for active links")
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240325180850.e95b442bafe9.I8c0119fce7b00cb4f65782930d2c167ed5dd0a6e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index 8f5b8b26909da..121da93e99c6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -36,7 +36,7 @@ u32 iwl_mvm_sta_fw_id_mask(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		mvm_link_sta =
 			rcu_dereference_check(mvmsta->link[link_id],
 					      lockdep_is_held(&mvm->mutex));
-		if (!link_sta)
+		if (!mvm_link_sta)
 			continue;
 
 		result |= BIT(mvm_link_sta->sta_id);
-- 
2.43.0



