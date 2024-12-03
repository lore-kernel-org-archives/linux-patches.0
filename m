Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5211F7557;
	Tue,  3 Dec 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238731; cv=none; b=tE/K/ppbnKcuG1xRUT41omZ60cuirJCROC5sR8M3vAYRiqegCd/C1Teiw7JMYj2CB3+8V9Oz3+DR0Lo9t+dKJCBxdgNcHbGCAKbT8rOVPrOxH8GRecbCdGMlc+NK0CzC429Mxtn6AYXS77RVriemu6Fbk1+APucJP8HLFLXWAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238731; c=relaxed/simple;
	bh=tcnyrzlua745ru1VbMNprsjgVfW/zcd8YR6ihpjJqBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz55o/hlIZGIOMV6/dXXl9dJnWhquD73OjAoGt6zhq6u11PiV7hvMta2AtyO1T9wrZb2fd7nVHgEcI5I0E8tXdHg3rAOTTtM81TL1eF5YFaOlfRekLQKwcyUUtXK4vrypK3jQehwMzSEMVUw1Z8O0hOFrjwVgDPf6VtPTttliJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zt3vZfog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zt3vZfog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBE5C4CECF;
	Tue,  3 Dec 2024 15:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238730;
	bh=tcnyrzlua745ru1VbMNprsjgVfW/zcd8YR6ihpjJqBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zt3vZfog5tg33uhn1J+bexo7zIrOxNNCby/lk6P35C+iqiqG5gC03b/XFuhN0h9MN
	 X6OgPL7/VFHOjgl5eHhobHe1Ib/8tZHRs6sYwoNnFWs/1rFkoKOmVifnGYq/C2YneC
	 jI0dkkUHHZ9yrJFQ5QwGPXu1ux9cYRZ1LrXfMyto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 337/817] wifi: iwlwifi: allow fast resume on ax200
Date: Tue,  3 Dec 2024 15:38:29 +0100
Message-ID: <20241203144008.975792113@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit e53ebc72054efca12e0329d69342e3daf7250a5a ]

This feature can be used on ax200 as well. It'll avoid to restart the
firmware upon suspend / resume flow. Doing so also avoids releasing and
re-allocating all the device related memory which makes the memory's
subsystem task easier.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241028135215.514efe0ce4c7.I60061277526302a75cadbba10452e94c54763f13@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d1a54ec21b8e ("wifi: iwlwifi: mvm: tell iwlmei when we finished suspending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 63b2c6fe3f8ab..af4c2e7dab083 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1376,7 +1376,7 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm, bool suspend)
 		iwl_mvm_rm_aux_sta(mvm);
 
 	if (suspend &&
-	    mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+	    mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_22000)
 		iwl_mvm_fast_suspend(mvm);
 	else
 		iwl_mvm_stop_device(mvm);
-- 
2.43.0



