Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E1C52F15B;
	Mon, 31 Aug 2026 13:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183895; cv=none; b=iGHs35TcYDaEIKtIYKDhBVXSDgLJGYKBZGHDbFsT8Gx/DbRUk00e9gak40zJD1c0LyMZvC9MLNuhY1rRBGwfk8tOtRrHAswQ89PT5bj5VpZFY4+PBgQDbLNATPeED7jawSfgeuClIt2jeXQTA8CUltY0GLwbxeMYDx5Je5UCrek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183895; c=relaxed/simple;
	bh=hrFcvzb5Iy4Qn6c3lsfcopO/hX/YFtt7ht+vNs4wL18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAH5vjDX5TOu/8lQmZ4sLFHo1NTX6ilx+5H2ZaF5EbcqkUMxgdcX3SIqZTk/QWcS/jyboZ9nBOsaEUITmlJXHOrFsLrEx/QCXoDEWSZTLUcN+TyBrpp7BPYH0Hzd49mi7Kt5IuMt1MSTbSp0eyk+IpR9ZcD/4lHXjBHx2YaShH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYcjO6O/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYcjO6O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41571F00ACA;
	Mon, 31 Aug 2026 13:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183892;
	bh=PuxItlRph/WPV55pacij2MW97sd3QALaiFtFO8FcCO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYcjO6O/Qd8eH5tMREISSCf2flh6ocFaGrTBl9PaySFx+6YGyO/SwBQLiDW8J+F35
	 1NS7LaBr4UISRrlsaf4nEpgczRF9DMP//7PINi9TcUbiW8/Nj3GwOp6gjjfPkFzamc
	 aGLk3PfMqfnX4hb1ojcWhP0zsQ34SKukKUVIGwDJSsZsPy/RB3fyLJpm/yxRNgVzNN
	 dSCbpyDfsrhIxzJlyKSuCMVX3eLyR3ZlR3y3sFjUVBmgXFYEKx2BaS/bi/Ux5br4zJ
	 Tnlf600qSuj09VdWW9uYhYjZqnYST5O5DGtdZM2l65B8kzfs76Yinz/tgiJmkjnXFf
	 dUFKZTwFZLhLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: don't WARN on WoWLAN suspend w/o netdetect
Date: Mon, 31 Aug 2026 09:26:33 -0400
Message-ID: <20260831133314.4125787-365-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 301b0dfa9db3f1e204de95e803bbd88fbd878c7c ]

Clearly, from a user perspective, it must be valid to configure
WoWLAN and then suspend while not connected to a network. Since
mac80211 doesn't distinguish these cases and simply calls the
driver to suspend whenever WoWLAN is configured, the driver has
to cleanly handle the case where it's called for WoWLAN, it's
not connected but there's also no netdetect configured.

Remove the WARN_ON() and keep returning 1 to disconnect and
then suspend.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260527230313.19720967372b.Iff30814510a26f9f609f98eeea3111c50c1afb31@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: don't WARN on WoWLAN
suspend w/o netdetect`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[don't WARN]` — Remove spurious
`WARN_ON()` when suspending with WoWLAN configured but not associated
and without netdetect.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Johannes Berg, Miri Korenblit (author SOBs; ignore
  pipeline SOBs per instructions)
- **Reviewed-by:** Emmanuel Grumbach \<emmanuel.grumbach@intel.com\>
  (iwlwifi maintainer)
- **Link:** https://patch.msgid.link/20260527230313.19720967372b.Iff3081
  4510a26f9f609f98eeea3111c50c1afb31@changeid
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** `WARN_ON(!wowlan->nd_config)` fires when WoWLAN is
  configured, the STA is not associated, and netdetect is not enabled.
- **Symptom:** Kernel warning + stack trace on a valid suspend path;
  behavior was already to `return 1`.
- **Root cause:** Incorrect assumption that “not associated ⇒ must be
  netdetect”; mac80211 calls the WoWLAN suspend path whenever WoWLAN is
  configured, without distinguishing netdetect vs. other WoWLAN
  triggers.
- **Fix approach:** Remove `WARN_ON()`, keep `return 1` so mac80211
  disconnects and falls back to normal suspend.

### Step 1.4: Hidden bug fix?
**Record:** Yes — labeled as warning cleanup, but it corrects a wrong
invariant on the system suspend path. Functional handling was already
correct (`return 1`); the bug is the spurious `WARN_ON()` on a
legitimate user scenario.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/d3.c` (+5 / -2
  lines)
- **Function:** `iwl_mld_wowlan_suspend()`
- **Scope:** Single-file, surgical change

### Step 2.2: Code flow change
**Record:**
- **Hunk (not associated branch):**
  - **Before:** `WARN_ON(!wowlan->nd_config)` then `return 1` — logs
    warning on valid path.
  - **After:** `if (!wowlan->nd_config) return 1` — same control flow,
    no warning.
- **Path:** WoWLAN suspend when STA is not associated and netdetect is
  disabled.

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic / correctness — incorrect assertion on
valid error/fallback path. **Mechanism:** Driver treated “no netdetect
while disconnected” as impossible; mac80211 can legitimately reach this
case. `return 1` is the intended mac80211 contract (disconnect then
suspend normally).

### Step 2.4: Fix quality
**Record:** Obviously correct; matches existing `iwl_mvm` behavior (see
below). Minimal diff. **Regression risk:** Very low — only removes a
warning; return value unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `WARN_ON(!wowlan->nd_config)` introduced in
**d1e879ec600f9** (`wifi: iwlwifi: add iwlmld sub-driver`, 2025-03-05).
Present since iwl_mld was added; iwl_mld is in v6.18.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `d3.c` changes are WoWLAN API updates and null-check
fixes; no duplicate fix for this issue. Patch is **12/15** in an
iwlwifi-next series but this hunk is **standalone** (no series
dependency for this change).

### Step 3.4: Author context
**Record:** Johannes Berg is mac80211/iwlwifi lead. Reviewed by Emmanuel
Grumbach (maintainer).

### Step 3.5: Prerequisites
**Record:** None. `git format-patch -1 dc71bf31e0159 | git apply
--check` succeeds on current HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c dc71bf31e0159` found thread: [PATCH iwlwifi-next
12/15] at lore URL above. Part of v1 15-patch series (2026-05-27, Miri
Korenblit). **UNVERIFIED:** Full thread content (stable nominations,
NAKs) — WebFetch blocked by bot protection.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd linux-wireless, Johannes Berg, Emmanuel
Grumbach.

### Step 4.3: Bug report
**Record:** N/A — no external bug report or syzbot link.

### Step 4.4: Series context
**Record:** Patch 12/15 of iwlwifi-next series; this change is
independent.

### Step 4.5: Stable list
**Record:** **UNVERIFIED** — could not search stable@ lore due to fetch
limitations.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_wowlan_suspend()`, called from `iwl_mld_suspend()`.

### Step 5.2: Callers
**Record:**
- `iwl_mld_suspend()` → `iwl_mld_wowlan_suspend()` (`mac80211.c:1996`)
- `iwl_mld_suspend()` registered as mac80211 `.suspend` op
- mac80211 `__ieee80211_suspend()` → `drv_suspend()` (`pm.c:116`)
- Triggered on system suspend when WoWLAN is configured

### Step 5.3: Callees
**Record:** On the affected path: early `return 1` (no netdetect
config). Otherwise `iwl_mld_netdetect_config()` or
`iwl_mld_wowlan_config()`.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** via system suspend with WoWLAN
enabled, STA disconnected, netdetect not configured. Common laptop
scenario (WoWLAN enabled, not connected).

### Step 5.5: Similar patterns
**Record:** `iwl_mvm` already handles this without `WARN_ON`:

```1289:1294:drivers/net/wireless/intel/iwlwifi/mvm/d3.c
        if (mvm_link->ap_sta_id == IWL_INVALID_STA) {
                /* if we're not associated, this must be netdetect */
                if (!wowlan->nd_config) {
                        ret = 1;
                        goto out_noreset;
                }
```

MLD incorrectly added `WARN_ON()` where MVM silently returns 1.

When driver returns 1, mac80211 handles it explicitly:

```132:141:net/mac80211/pm.c
                } else if (err > 0) {
                        WARN_ON(err != 1);
                        /* cfg80211 will call back into mac80211 to
disconnect
    - all interfaces, allow that to proceed properly
                         */
                        ieee80211_wake_queues_by_reason(hw,
                                        IEEE80211_MAX_QUEUE_MAP,
IEEE80211_QUEUE_STOP_REASON_SUSPEND,
                                        false);
                        return err;
```

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes** — current HEAD still has:

```1944:1948:drivers/net/wireless/intel/iwlwifi/mld/d3.c
        if (!bss_vif->cfg.assoc) {
                int ret;
                /* If we're not associated, this must be netdetect */
                if (WARN_ON(!wowlan->nd_config))
                        return 1;
```

`d1e879ec600f9` is an ancestor of HEAD; iwl_mld has been in tree since
v6.18.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
rework needed.

### Step 6.3: Related fixes already present?
**Record:** **No** — `git merge-base --is-ancestor dc71bf31e0159 HEAD` →
fix **NOT** in HEAD.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — Intel iwlwifi MLD driver (`CONFIG_IWLMLD`),
WoWLAN/system suspend on laptops.

### Step 7.2: Activity
**Record:** Actively developed; multiple recent mld fixes in this tree
(race fixes, null checks, WoWLAN updates).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Intel WiFi chips using iwl_mld (new MLD-capable
devices) on 6.18.y with WoWLAN configured.

### Step 8.2: Trigger conditions
**Record:** System suspend while disconnected, WoWLAN enabled, netdetect
not configured. **Common** on laptops. Any user can trigger via suspend.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM** — spurious `WARN_ON()` (kernel warning + stack
trace, taints debugging). Suspend still proceeds via `return 1`. Could
panic only with `panic_on_warn=1`. Not data corruption or security.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates false warnings on a real suspend path; aligns
  MLD with MVM; cleaner logs for production/monitoring.
- **Risk:** Very low — 3-line behavioral-equivalent change.
- **Ratio:** Moderate benefit, very low risk. Precedent in this tree for
  iwlwifi/mac80211 “don’t WARN” stable fixes.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: spurious `WARN_ON()` on valid WoWLAN suspend path
- Bug present in 6.18.44 since iwl_mld introduction
- Fix is minimal, reviewed by maintainer, matches proven MVM pattern
- Applies cleanly
- Affects laptop suspend — important PM path
- Similar “don’t WARN” iwlwifi/mac80211 fixes exist in tree history

**AGAINST backport:**
- Functional suspend already works (`return 1` unchanged)
- Severity is warning-only under default config
- Does not meet “critical” bar (crash/corruption/security/deadlock)
- No user bug report or syzbot

**UNRESOLVED:**
- Lore thread review comments / stable nomination (fetch blocked)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches MVM; Reviewed-by
   maintainer
2. Fixes real bug affecting users? **PASS** — spurious warning on real
   suspend scenario
3. Important issue? **PASS (low-medium)** — not crash/corruption, but
   incorrect behavior on PM path for new driver in this tree
4. Small and contained? **PASS** — 7 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

For **Linux 6.18.44**, iwl_mld is part of this stable series and the
buggy `WARN_ON()` has been present since the driver landed. The fix
removes a developer assertion that fires on a legitimate user workflow
(WoWLAN configured, disconnected suspend without netdetect). The iwl_mvm
driver already handles this case correctly without warning. The change
is trivial, safe, and applies cleanly. While severity is moderate rather
than critical, this is an appropriate stable fix for a new driver’s
suspend path in a tree that already carries similar iwlwifi/mac80211
warning fixes.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show dc71bf31e0159`
- **[Phase 2]** Read current `d3.c:1929-1958`; confirmed diff scope
  (nd_config WARN_ON only)
- **[Phase 3]** `git blame -L 1944,1955`: buggy code from d1e879ec600f9
  (2025-03-05)
- **[Phase 3]** `git log -S 'WARN_ON(!wowlan->nd_config)'`: only
  d1e879ec600f9 introduced it
- **[Phase 3]** `git merge-base --is-ancestor d1e879ec600f9 HEAD`: MLD
  driver in this tree
- **[Phase 3]** `git merge-base --is-ancestor d1e879ec600f9 v6.18`: MLD
  in v6.18 release
- **[Phase 3]** `git merge-base --is-ancestor dc71bf31e0159 HEAD`: fix
  NOT in HEAD
- **[Phase 3]** `git format-patch -1 dc71bf31e0159 | git apply --check`:
  applies cleanly
- **[Phase 4]** `b4 dig -c dc71bf31e0159`: found lore thread URL
- **[Phase 4]** `b4 dig -a`: patch 12/15 of iwlwifi-next v1 series
- **[Phase 4]** `b4 dig -w`: CC'd linux-wireless, Berg, Grumbach
- **[Phase 4]** WebFetch lore URL: **FAILED** (bot protection) — review
  discussion UNVERIFIED
- **[Phase 5]** Traced call chain: `__ieee80211_suspend` →
  `iwl_mld_suspend` → `iwl_mld_wowlan_suspend`
- **[Phase 5]** Compared with `mvm/d3.c:1289-1294`: MVM returns 1
  without WARN
- **[Phase 5]** Read `pm.c:132-141`: return 1 triggers disconnect-then-
  suspend flow
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: 6.18.44
- **[Phase 6]** Confirmed buggy code at `d3.c:1947`
- **[Phase 7]** `Kconfig`: `CONFIG_IWLMLD` exists
- **[Phase 8]** Assessed trigger: WoWLAN + disconnected suspend
- **UNVERIFIED:** Lore review comments and stable@ discussion

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index dd85be94433cc..0cb7bfcd6420e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1943,8 +1943,11 @@ int iwl_mld_wowlan_suspend(struct iwl_mld *mld, struct cfg80211_wowlan *wowlan)
 
 	if (!bss_vif->cfg.assoc) {
 		int ret;
-		/* If we're not associated, this must be netdetect */
-		if (WARN_ON(!wowlan->nd_config))
+		/*
+		 * If not associated we can only do netdetect, if
+		 * that's not enabled then just suspend normally.
+		 */
+		if (!wowlan->nd_config)
 			return 1;
 
 		ret = iwl_mld_netdetect_config(mld, bss_vif, wowlan);
-- 
2.53.0

