Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514A12B73;
	Wed,  4 Jun 2025 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998658; cv=none; b=Gc7pvQpva5PuVDY5aO6iU603MvcvuzSD7E1j8dDwRg3yG9fwiiS4Un8W/HVUOLQcvdM8sSORHynslLTaCE/zDOP+QtjVWIx0jCClGA/oWoEI8B+ShUOjHMF7ODG6vM/xJIqPP/aJzm0bh1MQcpTHVh8wSTAcAyC5QUodMqslddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998658; c=relaxed/simple;
	bh=xBhyp9ExuPbziIn7Nz23eUfy5qumCTLAzTeVGTgUyYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CdO+ub61Ed0UZRiEgY7XFq5iufu9Ifo3EAVwl0p9UH5uxLlz6YxNT1NFKWDzowySmM78pxYGLDfRF4sVUfclXPK+b3989TbibDQUzl6iVg6Rd+cG1bz/uAwRxgyuPQlrcS0GO4mNy4lylji9Wr1NUxIuIWhG0g+sJxMIoK0pw9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4CdBO8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4CdBO8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FC9C4CEED;
	Wed,  4 Jun 2025 00:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998658;
	bh=xBhyp9ExuPbziIn7Nz23eUfy5qumCTLAzTeVGTgUyYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4CdBO8qW8d/OSyF3ZFR8uxTo0Qy+x2097nwukEFoaW+5I9lVyffbpSlyL0JLiQet
	 2cPC+bvyatPDvL76vRAuHTLnq6/cxMjvVzI2gryC2EXCPYai2KoOXQz0Psb7NacXkl
	 Ea5P4ToAmgYKH10Zs1Fqxt6loXU02UhoN25nHMbttwSPi9QPyNuE2N64Fvws87s7M6
	 ROi4Qz1gyHdtD1RRhd1eskqBwNnAKgdfk3FwyznzNROwWzacrXkQBHjdGH3nY1Udot
	 jd+FUGM+5lxxfFn6sRZuFXOyYtBu8jW5V2PfZ0kNdfnADmaCwG755CzrmEJFWikJxJ
	 H3BbussduQXFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	peterz@infradead.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de
Subject: [PATCH AUTOSEL 6.14 060/108] wifi: iwlwifi: dvm: pair transport op-mode enter/leave
Date: Tue,  3 Jun 2025 20:54:43 -0400
Message-Id: <20250604005531.4178547-60-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index 30789ba06d9d7..983a38bf02cb6 100644
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

