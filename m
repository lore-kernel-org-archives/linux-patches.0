Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95F61891A5;
	Tue, 10 Sep 2024 09:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961561; cv=none; b=qifNR2YNJX5lXX2OjmiuY4BTep+tr18bRjnIXP8LXuu1Lfu1aPi6GkSJvUSHl4+grMITwNnd4kqXpUVypz1mz4ucmmrcx23LkHmClwT1GlTDtRu7KGGO44rOHF251JJUmlMyi8p7Wr7o+i2cE0p+D7MdZUXSW0UeOS6ws2p2N8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961561; c=relaxed/simple;
	bh=vp7uIAkoFfD1gtxyamANXAEAbCzPG2BSOza5I0SuqPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWp4pAK3jIUs+yaoyPn4E2n6Z5AySk2ENwdSSY8WpBNG0ibc3pDtbG1Wpm33re7u+YciLIJEbXfN+enMLflq00PC/2AYlxTi9HFStl7TrKVFKAEYL5Z1OoWti9Chu6DB2+LMVRY7dSdS0EVw5SdkpIQ3Aal5363giknI80OqR3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yn+iiGEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yn+iiGEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6FDC4CEC3;
	Tue, 10 Sep 2024 09:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961561;
	bh=vp7uIAkoFfD1gtxyamANXAEAbCzPG2BSOza5I0SuqPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn+iiGEUxbwKNozX5cHanO1010g0o4EEzZJJ5MkQdbmPyTP2duSfAk1MwAOmDwAud
	 0OQ9vmkNTOz3Acof0stFqf7a3g98Ofc5mS5XnPMlJL2W1AP4JTqdDrrjQWffiqvavB
	 kPhPHJwa16wbNyHz1xEgo0MW177rB4CP41JkMZt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 112/375] wifi: iwlwifi: mvm: use IWL_FW_CHECK for link ID check
Date: Tue, 10 Sep 2024 11:28:29 +0200
Message-ID: <20240910092626.167835994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ded094b6b63d..bc40242aaadd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1442,7 +1442,8 @@ iwl_mvm_rcu_dereference_vif_id(struct iwl_mvm *mvm, u8 vif_id, bool rcu)
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



