Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2EA502D6C;
	Thu, 17 Sep 2026 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664997; cv=none; b=AC3pN4RnuJm4Zz/40Q7HRnVpDrAJd1ccsgCdxreN3/Z0yGEOMeO/kk/Gz/PJv1DxcOaTx+JjykgD6Vy0MPPc2hV9ticCyij3wAkGHxnxTt9aaJouUwEQYNfW7wqlkM9HiwkdKuQye9VtJcWnYnU0hoUgFfoi9ZdgWoLHQ4hBAiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664997; c=relaxed/simple;
	bh=J5/1OGHStZlZZvbpMt5JOIzDUALMwxpDrfATlORA+gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6d9XSu3kNVoeVgIrQBvY8PkC/FczJ7b20IQ4Y1uCr2hUxIsUoGe1dHCCnA5llU+Y2H3hIvi+XuodAqEOuCYfVeHbcSLtG1Qk4xSkhj7DdrhTuXKsA+VvRQzP7b/90VT4Ec8zKziLBhE/mFAr20KuoShV71iqYRz5sdt9jKT6wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwKCTfzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwKCTfzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DCE1F000FF;
	Thu, 17 Sep 2026 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664996;
	bh=lk33PriXsJMn51sjZzpL98l29l1rMS+x3qIy3LCsHNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwKCTfzGnbVctyKQiWp5EOoA9vNQ9NrgW34rAX79ptxt1r4DvSWFtkITUXEF1i8KI
	 PfMyEYw/cXw0H54lofMKP/mIjjdIew4ID3IwGextpvMYAOQVc4RGKE7v0ldh7UEmOe
	 B+PofAkCNT1HznG34id3XM764+YiE/Pu1dr8c7iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0518/1250] wifi: iwlwifi: mvm: validate mac_link_id in session protect notif
Date: Thu, 17 Sep 2026 16:05:13 +0100
Message-ID: <20260917151605.991163572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 71245daf7d58a3c407c7e1422facce13ff6a584b ]

Check the mac_id before accessing the vif_id_to_mac array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.547ea470e686.I931445ae6f37bf0e1ef6f112c811712fc48af9c9@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 1a3a8a3f0fb49..356f68f5e6ac3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -960,6 +960,11 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_vif *mvmvif;
 
+	if (IWL_FW_CHECK(mvm, id >= ARRAY_SIZE(mvm->vif_id_to_mac),
+			 "Invalid mac_link_id (%d) in session protect notif\n",
+			 id))
+		return;
+
 	rcu_read_lock();
 
 	/* note we use link ID == MAC ID */
-- 
2.53.0



