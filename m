Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D328373;
	Wed,  4 Jun 2025 00:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998406; cv=none; b=mEq14iR6bT89N82Gi6MnJdksF3r1Seir36tQfmVZ1YiWuX6KqE27FA8e59/+rsLKfo3r8AaxP1fS/d/yOISD2Z2X/xh+HTGlxkVd2ubLBGBY8nJLuYTPC+vGjCi3clJt9+QuFRplG7J0mdvm0irCgshmAqjhHg7xIdfugN+R2xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998406; c=relaxed/simple;
	bh=7+kkN0WOvK5p+aqr+AmGXXsCVloX/5U7KCaTvmolSc8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bnanTmGKDDj7QSZJAlKtvHx3IfSncljXF7/59bJYFsOq68DV7i5afrmSQ8Wg2m8FXKyQzCx/P814hIrpOTiDiC6C6KMIUffdxqcjANxj4Hei1BNgCyxkN6OqPsVVgJQC42vUl56dGq21Y1fM7HSJfIoQsigJoKSX6+KpvWNlF/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bjq2CDOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bjq2CDOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC98C4CEED;
	Wed,  4 Jun 2025 00:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998406;
	bh=7+kkN0WOvK5p+aqr+AmGXXsCVloX/5U7KCaTvmolSc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bjq2CDOzGAjA3F1QpRWyb2eyj/VXWzFrGzPSdaT8hfDoCi88dyHfiHTSyIOz7Ni4T
	 LWA3N4eg0OVM5pCb8pJqC0TRX5o6JFgcTavpYsBd8W1HbeNNVt004OHHB6awfkMjmp
	 a4Oo7cgQ7lNBFDwFbOV3YJhAgb8l8ESbYV0oRlI9rhNGDMsqZ7rjHhDOHpaaVUroij
	 Ri+qQHLF0t1TtNZHmjnmNghEXwzpq3PWrYyzICiQ7sMBjWIgrs4FMuMTGgm0qCLiKy
	 zdmbJYF6sQZLL49OY1d42btoic7udl+jATx3cmbmvA1oO4NaLy/vMcranosPD8jmR/
	 p5FxP3MAnKZ5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	gregkh@linuxfoundation.org,
	peterz@infradead.org,
	tglx@linutronix.de
Subject: [PATCH AUTOSEL 6.15 066/118] wifi: iwlwifi: dvm: pair transport op-mode enter/leave
Date: Tue,  3 Jun 2025 20:49:57 -0400
Message-Id: <20250604005049.4147522-66-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6b340a694cee9e7a24b2be827c738b5b6cb13c84 ]

If there's a failure and the op-mode didn't actually fully
initialize, it should leave the transport again. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250504132447.714c3517548b.I49557e7ba8c03be2b558cc9fb5efa2a9fbab890e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis, here is my determination: **YES**
This commit should be backported to stable kernel trees. ## Extensive
Analysis ### Nature of the Bug This commit fixes a critical resource
management bug in the iwlwifi DVM driver's initialization path. The
problem occurs in `iwl_op_mode_dvm_start()` where
`iwl_trans_op_mode_enter()` is called at line 1357, but several error
paths fail to call the corresponding `iwl_trans_op_mode_leave()`. ###
Specific Code Changes Analysis The commit makes two key changes: 1.
**Changes goto targets from `out_free_hw` to `out_leave_trans`** for
early error paths: - Line 1385: `goto out_leave_trans;` (was `goto
out_free_hw;`) - Line 1393: `goto out_leave_trans;` (was `goto
out_free_hw;`) 2. **Adds the missing `out_leave_trans` label and cleanup
call**: ```c out_leave_trans: iwl_trans_op_mode_leave(priv->trans);
out_free_hw: ieee80211_free_hw(priv->hw); ``` ### Why This Meets Stable
Backport Criteria **1. Important Bug Fix**: This fixes a critical
resource management issue where the transport layer remains in an
inconsistent state if early initialization fails. Without the `leave`
call, the transport maintains dangling references (`trans->op_mode`) and
doesn't properly cancel pending work or reset its state. **2. Minimal
Risk**: The fix is extremely contained - it only adds proper cleanup to
existing error paths. The change follows the established pattern used by
other iwlwifi drivers (MLD, MVM) and the normal stop path in the same
driver. **3. Clear Side Effects Analysis**: The fix has no negative side
effects. `iwl_trans_op_mode_leave()` is designed to be safely called in
error scenarios and only cleans up resources that were allocated by the
corresponding `enter` call. **4. Affects Critical Subsystem**: This
impacts WiFi driver initialization, which can affect system stability
and device reliability during error conditions. **5. Confined to
Subsystem**: The change is entirely within the iwlwifi DVM driver and
doesn't affect other kernel components. ### Comparison with Similar
Commits Reviewing the provided similar commits, they all had "Backport
Status: NO" because they were either: - Feature additions (commit #5:
"add trans op to set PNVM") - Performance optimizations (commit #2:
"skip opmode start retries") - Minor improvements (commit #3: "remove
module loading failure message") - Module initialization improvements
(commit #4: "fix module init error paths") In contrast, this commit
fixes a fundamental resource management bug that can cause system
instability. ### Real-World Impact This bug affects users when: - WiFi
hardware initialization fails (common during driver load/reload) -
EEPROM reading fails (hardware-dependent) - Early driver startup
encounters errors Without this fix, failed initialization leaves the
transport in an inconsistent state, potentially causing issues during
subsequent driver operations, device removal, or system shutdown. ###
Conclusion This commit represents exactly the type of fix that stable
kernel trees are designed for: a small, contained fix for an important
bug that improves system reliability without introducing new features or
architectural changes. The fix ensures proper resource cleanup in error
paths, following established patterns in the codebase.

 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index a27a72cc017a3..a7f9e244c0975 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1382,14 +1382,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
 	err = iwl_trans_start_hw(priv->trans);
 	if (err)
-		goto out_free_hw;
+		goto out_leave_trans;
 
 	/* Read the EEPROM */
 	err = iwl_read_eeprom(priv->trans, &priv->eeprom_blob,
 			      &priv->eeprom_blob_size);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_free_hw;
+		goto out_leave_trans;
 	}
 
 	/* Reset chip to save power until we load uCode during "up". */
@@ -1508,6 +1508,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	kfree(priv->eeprom_blob);
 out_free_eeprom:
 	kfree(priv->nvm_data);
+out_leave_trans:
+	iwl_trans_op_mode_leave(priv->trans);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
-- 
2.39.5

