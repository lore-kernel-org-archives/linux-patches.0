Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0F952F9A2;
	Mon, 19 Oct 2026 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418628; cv=none; b=NNAFGHBsISr1zBpsO0uBplHHu8vFNeN85x99DwfLaOiURZyJz/W8xdmTyxi7WaYTnfAIAkZDKGBDxCFrUX4keaIIQETD1KJf0F+74FMMZcPZXpKvRqZGnXMvdVsq9xLlFVWQ3A8/qGjL5PyoqoDwDNuwikaJQnOpK1s3Q7+9mgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418628; c=relaxed/simple;
	bh=lEe040fMAo+CPU8jdV6O5Z2V4KBYzQ6++iuPEVT39zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQzzmwz1ucF9iYCs9WPjH4eDh47RbUoN+6e3GMSXp56MjajFMmMgw6X2p163iBdp7qTY9F/XtUfnO/FTmtzxp2ESYwoqf9t8rBb2Uc7fQPf8o4Pxp+qkot76LMKqBSkSdAwd5KeiQ3cUvgxxL1TZe9yN4LotgrlR0x6ivjAsL1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVRkXTD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVRkXTD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA57E1F000C8;
	Mon, 19 Oct 2026 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418625;
	bh=7BDK+crvFAJNRkrf+kIBvqU5VWEEIrHWQysBFcfsRbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVRkXTD9LSHNTi8xhIrw5YWaS183AG/rZ0vWfEO4A4yeh5UD5dcXKWBYAjW5OVqgc
	 29ws4s9+WGjjlQYE31KQGu1/uEQ/y6MxUHQvsocTCciXuvT5bSmdeQyJRnRTWj0c4f
	 nogw6N8D9L2ePtuib2asgrqL0i24DcY0U4JqEa1qxA/XUoZlzR6uAeKStkBAHqfOQC
	 4vOUBRsiEARZIYLvVPwcivC0sDxA0bI0apxFzJ4KVnFg8wcVZ4PvApa9ZSVbYznRrx
	 ZRmNaXOUXSPSSvKvgZfK5+gA8Y/FzHyiqk4utMSOndHpyj2BMNB97L4TEzH7PRjxFU
	 vunGNAj2zKWkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: support aborting an ongoing ftm request
Date: Mon, 19 Oct 2026 09:51:13 -0400
Message-ID: <20261019135441.1420968-382-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit ef704fc32ae1a519801ac4a06aa290fece5f403c ]

Add support for aborting an ongoing FTM request.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.340040bdc6a3.Ifbbf70021e42bf1d59db6ec45a73f1806a1c2289@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[iwlwifi/mld]** **[support]** add abort for an in-flight FTM
(Fine Timing Measurement / peer measurement) request.

**Step 1.2: Tags**
Record:
- Signed-off-by: Avraham Stern <avraham.stern@intel.com> (author)
- Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
  (iwlwifi maintainer)
- Link: https://patch.msgid.link/20260715220243.340040bdc6a3.Ifbbf70021e
  42bf1d59db6ec45a73f1806a1c2289@changeid
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence of the last two is expected for this review)

**Step 1.3: Body**
Record:
- Bug description from message: none. One sentence: “Add support for
  aborting an ongoing FTM request.”
- Symptom/failure mode: not stated
- Version information: none
- Root-cause explanation: none

**Step 1.4: Hidden bug fix?**
Record: **Yes.** The wording is feature-like, but the MLD path already
stores `mld->ftm_initiator.req` and later dereferences it. cfg80211
frees that object on abort whether or not the driver implements
`abort_pmsr`. Missing abort is a use-after-free / stuck-FTM hole, not a
new userspace API.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- `drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c`: +21 (new
  `iwl_mld_ftm_abort`)
- `drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h`: +1
  (prototype)
- `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c`: +10
  (`iwl_mld_abort_pmsr` + `.abort_pmsr` ops)
- Total: **+32 / −0**, single-driver surgical change

**Step 2.2: Code flow**
Record:
- Before: `.start_pmsr` was wired; `.abort_pmsr` was NULL. On netlink
  close or wdev teardown, cfg80211 still `kfree()`s the request while
  the driver keeps the pointer and firmware keeps ranging.
- After: abort sends `TOF_RANGE_ABORT_CMD`, cancels queued FTM RX
  notifications, then `iwl_mld_ftm_reset()` NULLs `req`/`req_wdev`.
- Path: abort/teardown only, not the normal completion path.

**Step 2.3: Bug mechanism**
Record: **Use-after-free + leftover firmware ranging**, fixed by
implementing the existing mac80211 `abort_pmsr` op (same pattern as
MVM). Also prevents the next `iwl_mld_ftm_start()` from returning
`-EBUSY` forever because `ftm_initiator.req` stayed non-NULL after the
object was freed.

**Step 2.4: Fix quality**
Record: Obviously correct relative to `iwl_mvm_ftm_abort()`. Minimal.
Regression risk is low: new code runs only on abort; on firmware abort
failure it still resets local state (the UAF-critical part). Helpers it
calls already exist in this tree.

## Phase 3: Git history

**Step 3.1: Blame / introduction**
Record: Buggy pattern came in with **`d1e879ec600f9`** (“wifi: iwlwifi:
add iwlmld sub-driver”, 2025-02-16). FTM start stored `req` and
registered `RX_HANDLER_OF_FTM_REQ` / `IWL_MLD_OBJECT_TYPE_FTM_REQ` from
day one, but never called cancel/abort. MVM has had abort since
**`fc36ffda32670`** (2019, “support FTM initiator”).

**Step 3.2: Fixes: tag**
Record: None. Not applicable.

**Step 3.3: File history**
Record: Recent FTM-initiator commits are unrelated (location BW
encoding, switch indentation). Neighbor **`71ac392d8b5c2`** (FW recovery
reset) is a different path. No prerequisite refactor for this hunk.

**Step 3.4: Author**
Record: Avraham Stern is a regular iwlwifi FTM contributor. Maintainer
Miri Korenblit signed off. Related later Stern commits in this tree are
MEI length checks, not FTM abort follow-ups. **No follow-up fix** to
`iwl_mld_ftm_abort` after this commit.

**Step 3.5: Dependencies**
Record: Standalone. Uses existing `iwl_mld_send_cmd_pdu`,
`iwl_mld_cancel_notifications_of_object`, `IWL_MLD_OBJECT_TYPE_FTM_REQ`,
`iwl_mld_ftm_reset`, `TOF_RANGE_ABORT_CMD`. Series membership is **01/15
of an iwlwifi-next “updates” dump**; other patches (MEI, WoWLAN, LARI,
etc.) are unrelated. Can apply alone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c ef704fc32ae1a`: https://patch.msgid.link/20260715220243.340
  040bdc6a3.Ifbbf70021e42bf1d59db6ec45a73f1806a1c2289@changeid
- Cover: `[PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates -
  07-15-2026` — “Cleanups, features, and fixes from our internal tree.”
- `b4 dig -a`: **v1 only**, this is the applied version
- No reviewer comments, NAKs, or Cc: stable on this patch in the saved
  thread
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m`

**Step 4.2: Recipients**
Record: To Johannes Berg; Cc linux-wireless, Avraham Stern. Subsystem
maintainer (Miri) submitted the series.

**Step 4.3: Bug report**
Record: None. No syzbot/bugzilla.

**Step 4.4: Series**
Record: Mixed iwlwifi-next batch. This patch does not depend on 02–15.

**Step 4.5: Stable list**
Record: No stable-list discussion found (search did not surface this
subject).

## Phase 5: Semantic / call-chain

**Step 5.1: Functions**
Record: `iwl_mld_ftm_abort` (new), `iwl_mld_abort_pmsr` (new),
`iwl_mld_hw_ops.abort_pmsr` assignment.

**Step 5.2: Callers**
Record:
- `cfg80211_release_pmsr()` from `nl80211.c` on netlink port release
- `cfg80211_pmsr_wdev_down()` from `net/wireless/core.c` on wdev
  teardown
- both → `cfg80211_pmsr_process_abort()` → `rdev_abort_pmsr()` →
  `ieee80211_abort_pmsr()` → `drv_abort_pmsr()` → `iwl_mld_abort_pmsr()`
- `drv_abort_pmsr` only calls the driver if `local->ops->abort_pmsr` is
  set; cfg80211 **always kfree()s** afterward (`pmsr.c` around the abort
  loop)

**Step 5.3: Callees**
Record: firmware abort PDU; `iwl_mld_cancel_notifications_of_object()`;
`iwl_mld_ftm_reset()`.

**Step 5.4: Reachability**
Record: Yes, from userspace: start peer measurement
(`NL80211_CMD_PEER_MEASUREMENT_START`), then close the netlink socket or
take the interface down while ranging is in progress. Typically
privileged (`nl80211`), but a crashing location/RTT helper is a
realistic trigger (Android Wi-Fi RTT uses this API).

**Step 5.5: Similar patterns**
Record: Only iwlwifi MVM/MLD and mac80211_hwsim implement `.abort_pmsr`.
MVM has had it since FTM was added; MLD start without abort was the
incomplete copy.

Verified UAF path in this tree:

```246:247:drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
        if (mld->ftm_initiator.req)
                return -EBUSY;
```

```267:270:drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
        if (!ret) {
                mld->ftm_initiator.req = req;
                mld->ftm_initiator.req_wdev =
ieee80211_vif_to_wdev(vif);
        }
```

```340:342:drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
        if (IWL_FW_CHECK(mld, !mld->ftm_initiator.req,
                         "FTM response without a pending request\n"))
                return;
```

That NULL check does not save a dangling pointer.
`cfg80211_pmsr_process_abort()` kfree’s the request after the (optional)
abort op.

## Phase 6: This checkout

**Step 6.1: Local tree and buggy code**
Record:
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion`: **7.3.0-rc4**
- MLD FTM initiator **is present**. Bug introduced with MLD
  (`d1e879ec600f9`), long before 7.3 branched.
- Candidate SHA **`ef704fc32ae1a`**; `git merge-base --is-ancestor
  ef704fc32ae1a HEAD` → already in this mainline snapshot (landed in
  **7.3-rc1**, not in 7.2). Evaluation is still on technical merit, not
  “already selected.”

**Step 6.2: Backport difficulty**
Record: Clean apply on this tree. Structures and helpers match the hunk.

**Step 6.3: Related fixes already here**
Record: `iwl_mld_ftm_restart_cleanup()` covers FW restart only, not
userspace abort. No earlier abort implementation.

## Phase 7: Subsystem context

**Step 7.1**
Record: **iwlwifi MLD** (Intel Wi-Fi 7 opmode). Criticality:
**IMPORTANT** (common client Wi-Fi driver), not core mm/VFS. FTM itself
is a subset of users (RTT / indoor location).

**Step 7.2**
Record: Actively developed; MLD is the current Intel path. This is a
missing piece from the original MLD port, not a brand-new subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Intel MLD devices using nl80211 peer measurement (FTM
initiator). Not universal.

**Step 8.2: Trigger**
Record: Start FTM, then abort via socket close or iface down before
firmware completes. Not every boot; realistic for location stacks and
interface teardown. Unprivileged trigger: unverified (nl80211 PMSR is
typically admin-capable).

**Step 8.3: Failure mode**
Record:
- Firmware response after abort: **UAF** of `cfg80211_pmsr_request`
  (crash / KASAN / potential memory corruption)
- Without a later notification: FTM stays “busy” (`-EBUSY`) until driver
  reset
- Firmware keeps ranging until timeout
Severity: **HIGH** (UAF), not a panic on every probe.

**Step 8.4: Risk/benefit**
Record: Benefit medium-high for MLD FTM users (UAF + stuck session).
Risk **low** (32 lines, abort path only, same design as MVM). Ratio
favors taking it.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Verified UAF: driver borrows cfg80211’s request; abort path frees it
  without clearing the driver pointer
- Also stuck `-EBUSY` on later FTM starts
- Small, self-contained, copies a long-standing MVM abort
- Cancel infrastructure (`IWL_MLD_OBJECT_TYPE_FTM_REQ`) was already
  registered; abort was the missing caller
- Maintainer-signed; applies cleanly here
- Same class of “missing stop/abort op” that stable routinely takes

AGAINST:
- Message sells it as “add support,” no crash report, no Fixes/syzbot
- Sent to **iwlwifi-next** in a mixed updates series
- FTM is not a hot path for most desktops
- Adds a new ops pointer (looks like a feature if you only read the
  subject)

UNRESOLVED:
- Could not fetch lore HTML (403); used `b4` mbox instead
- No evidence of a real-world crash report
- Unverified whether unprivileged users can start PMSR on typical
  distros

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (MVM analogue; Intel-authored)
2. Real user-visible bug? **PASS** (UAF / stuck FTM after abort)
3. Important (crash/security/corruption)? **PASS** (UAF is crash/memory-
   safety; FTM-specific but real)
4. Small and contained? **PASS** (32 lines, one driver)
5. No new features/APIs? **PASS** — implements an existing mac80211 op;
   not a new syscall/uAPI
6. Can apply to this tree? **PASS** (MLD FTM code is here; helpers
   exist)

**Step 9.3: Exception category**
Record: Not ID/quirk/DT/build/docs. Ordinary driver correctness fix.

**Step 9.4: Decision**
This is a missing abort handler on a driver that caches a cfg80211-owned
object. That is a UAF fix, even though the subject says “support.” It is
small, applies here, and does not need the rest of the 15-patch series.

### What it solves for this tree
On 7.3-rc4, iwlwifi MLD FTM start stores `req` and handles firmware
range responses. Without abort, closing the measurement netlink socket
or taking the wdev down frees `req` while the driver and firmware still
use it. That is a use-after-free and can pin FTM at `-EBUSY`. The patch
aborts firmware, drops queued FTM notifs, and clears driver state.

### Risk vs benefit
Low risk, high severity if the abort path is hit. Benefit is limited to
Intel MLD + FTM users, which is enough given UAF.

Verification:
- [Phase 1] Parsed tags: SOB Stern + Korenblit; Link msgid; no
  Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +32 lines, `iwl_mld_ftm_abort` + `.abort_pmsr`
- [Phase 3] `git show ef704fc32ae1a`; ancestor of HEAD; introduced with
  `d1e879ec600f9`; MVM abort `fc36ffda32670`
- [Phase 3] `git merge-base --is-ancestor ef704fc32ae1a 8d3ae59288f1e` →
  not in 7.2; in 7.3-rc1
- [Phase 3] No follow-ups on `ftm-initiator.c` after this commit
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 iwlwifi-next 01/15, To Johannes, no
  review replies in mbox
- [Phase 4] WebFetch lore/msgid.link → 403; used local mbox
- [Phase 5] Call chain: `cfg80211_release_pmsr` /
  `cfg80211_pmsr_wdev_down` → kfree after optional abort;
  `iwl_mld_handle_ftm_resp_notif` derefs `ftm_initiator.req`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4; MLD FTM present
- [Phase 8] Failure mode: UAF on FTM abort + `-EBUSY` stuck state,
  severity HIGH
- UNVERIFIED: unprivileged PMSR start; no user crash report

**YES**

 .../intel/iwlwifi/mld/ftm-initiator.c         | 21 +++++++++++++++++++
 .../intel/iwlwifi/mld/ftm-initiator.h         |  1 +
 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 10 +++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
index 3464b32687124..6e174c4d8b75e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
@@ -449,3 +449,24 @@ void iwl_mld_ftm_restart_cleanup(struct iwl_mld *mld)
 			       mld->ftm_initiator.req, GFP_KERNEL);
 	iwl_mld_ftm_reset(mld);
 }
+
+void iwl_mld_ftm_abort(struct iwl_mld *mld, struct cfg80211_pmsr_request *req)
+{
+	struct iwl_tof_range_abort_cmd cmd = {
+		.request_id = req->cookie,
+	};
+
+	lockdep_assert_wiphy(mld->wiphy);
+
+	if (req != mld->ftm_initiator.req)
+		return;
+
+	if (iwl_mld_send_cmd_pdu(mld, WIDE_ID(LOCATION_GROUP,
+					      TOF_RANGE_ABORT_CMD),
+				 &cmd))
+		IWL_ERR(mld, "failed to abort FTM process\n");
+
+	iwl_mld_cancel_notifications_of_object(mld, IWL_MLD_OBJECT_TYPE_FTM_REQ,
+					       mld->ftm_initiator.req->cookie);
+	iwl_mld_ftm_reset(mld);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
index 3fab25a52508a..e82237b314673 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
@@ -25,5 +25,6 @@ int iwl_mld_ftm_start(struct iwl_mld *mld, struct ieee80211_vif *vif,
 void iwl_mld_handle_ftm_resp_notif(struct iwl_mld *mld,
 				   struct iwl_rx_packet *pkt);
 void iwl_mld_ftm_restart_cleanup(struct iwl_mld *mld);
+void iwl_mld_ftm_abort(struct iwl_mld *mld, struct cfg80211_pmsr_request *req);
 
 #endif /* __iwl_mld_ftm_initiator_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 69a066904a808..5234229a070a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2609,6 +2609,15 @@ static int iwl_mld_start_pmsr(struct ieee80211_hw *hw,
 	return iwl_mld_ftm_start(mld, vif, request);
 }
 
+static void iwl_mld_abort_pmsr(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_pmsr_request *request)
+{
+	struct iwl_mld *mld = IWL_MAC80211_GET_MLD(hw);
+
+	iwl_mld_ftm_abort(mld, request);
+}
+
 static enum ieee80211_neg_ttlm_res
 iwl_mld_can_neg_ttlm(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     struct ieee80211_neg_ttlm *neg_ttlm)
@@ -2696,5 +2705,6 @@ const struct ieee80211_ops iwl_mld_hw_ops = {
 	.prep_add_interface = iwl_mld_prep_add_interface,
 	.set_hw_timestamp = iwl_mld_set_hw_timestamp,
 	.start_pmsr = iwl_mld_start_pmsr,
+	.abort_pmsr = iwl_mld_abort_pmsr,
 	.can_neg_ttlm = iwl_mld_can_neg_ttlm,
 };
-- 
2.53.0

