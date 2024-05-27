Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBA415FD01;
	Mon, 27 May 2024 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836574; cv=none; b=SYOFAVaUtA/F4yHqFtZW9VorANCG4TvX8yqmnENUN+yAIXfQWHv8BGckzmODGJK22OsFNdUCuiPRvohbS0iIyAdV5EMl1IXf0muIz/IKuG4NekGUcxLw6Q4za+s0EhoiWQiohmHCVpWRR142yQlxK7xUY0374ZtCEdp6NZtNzrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836574; c=relaxed/simple;
	bh=zhx5jqtIqM+cODDhkBexyHuGpLNJmMEPvQzSX12ubQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQK2eiJCHyDWpm8i214ikfXS9uekQvYiVBALQSrdTz1jIVocQm7KEHnIQBxQp3xGs0WmOG3e+31NNUSuET7N7DZhrc2P/eLWjGFo7b7qfacf13jzRBXSoEExO3rz6pZZQIgn8bTmTSktWM7C4JGKm54Ile9gwWalH6NJlOYtOiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwrHzQft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwrHzQft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F609C2BBFC;
	Mon, 27 May 2024 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836574;
	bh=zhx5jqtIqM+cODDhkBexyHuGpLNJmMEPvQzSX12ubQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwrHzQft/qVx6ffDq5J7zXSV5Q5JavjQBgVSUuvZsigCbmuXudNpK/soHQ12drqbF
	 ll/h/bjQnPIZMf3Ip6FUVv2TKr5JLx+RCkhdMyyi6l/jPvvcPDoMtIxUPzHrX46zpL
	 knd9p6X6pDy55Qxt4XJNd1bSRohOoki2qI8/yadg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 108/427] wifi: iwlwifi: mvm: fix check in iwl_mvm_sta_fw_id_mask
Date: Mon, 27 May 2024 20:52:35 +0200
Message-ID: <20240527185611.880007144@linuxfoundation.org>
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
index dffdd00f8ab62..36dc291d98dd6 100644
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



