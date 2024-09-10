Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA8192D91;
	Tue, 10 Sep 2024 10:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964117; cv=none; b=X6wZa1NRkX8PLIhPkSBqax3oMbuH9gtazOyrNJ9fgzGCZzi03+TaPoXQu5o1HA61+W+EtcLJr2VuD7qWFI65pSyxiH0mEt0VOabxCGtyQslYywf2k6eapSTZPywGCIiGrLFuOIaRUYHBGVJ3cOuw5WViw30heNamUArZSgyyda4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964117; c=relaxed/simple;
	bh=wD7rDLTBkoMXx1eWbBMHqUc0VT7UdhSfGXesqGPPcGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OolcbCF+VuECkn8vnuidEJXY8ZbJQ9zljJiDVslzKyDgwmkxR6pigcHllW9OObqBm5kOxkhPYYLsxqT98hDfqburSUhqhqdGAmcRIn1rQFcOaEVGGu1U/l0DRyPbwRPmZwJuzBCle240ZzS5VEPWfk6cmEd5aeHzNCGyXGl9Y8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrozB8nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrozB8nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13302C4CEC3;
	Tue, 10 Sep 2024 10:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964117;
	bh=wD7rDLTBkoMXx1eWbBMHqUc0VT7UdhSfGXesqGPPcGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrozB8ndYJAYhAwn7qVux81tIPEKvYJHobsaxlErBW5Uo65wO4GIrUi8Gpw8/yhKC
	 RrthrVVeetRq+PRXkJOrIpapN3OZw1/Xoppm5Hqz8OKrDH/lNZXyXP+uiGX3X7chu/
	 8G2y6bXWXmc3fqjDvil6h8Ys/9xluTRQK8e/h1zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/269] wifi: iwlwifi: mvm: use IWL_FW_CHECK for link ID check
Date: Tue, 10 Sep 2024 11:31:01 +0200
Message-ID: <20240910092610.839949424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

[ Upstream commit 9215152677d4b321801a92b06f6d5248b2b4465f ]

The lookup function iwl_mvm_rcu_fw_link_id_to_link_conf() is
normally called with input from the firmware, so it should use
IWL_FW_CHECK() instead of WARN_ON().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240625194805.4ea8fb7c47d4.I1c22af213f97f69bfc14674502511c1bc504adfb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c780e5ffcd59..bace9d01fd58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1318,7 +1318,8 @@ iwl_mvm_rcu_dereference_vif_id(struct iwl_mvm *mvm, u8 vif_id, bool rcu)
 static inline struct ieee80211_bss_conf *
 iwl_mvm_rcu_fw_link_id_to_link_conf(struct iwl_mvm *mvm, u8 link_id, bool rcu)
 {
-	if (WARN_ON(link_id >= ARRAY_SIZE(mvm->link_id_to_link_conf)))
+	if (IWL_FW_CHECK(mvm, link_id >= ARRAY_SIZE(mvm->link_id_to_link_conf),
+			 "erroneous FW link ID: %d\n", link_id))
 		return NULL;
 
 	if (rcu)
-- 
2.43.0



