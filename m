Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C8D565111;
	Mon, 31 Aug 2026 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184077; cv=none; b=un2m1gxrvrlsiSIKSyAbOXRhB1MNl/78cCi+G96lF8vN/uyOUQl78o4KdQWgE8bpI1kdMPEqvXYVjjC60f41+LDJiGQ2VEUC6P5o93VTawkEN7g75Jpm7d2bzScWYWy8CEzUdCOpeUrrpjgX0aROKR9dhyT1ur7h/5aVRdRguK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184077; c=relaxed/simple;
	bh=wVL1YIJPlbDy/sek2DgAlItW+ozYH1TUIDGq2UvPtF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Heng3J+xHSfUv+ayqPVQokJIMfwt5u8a+2u5zK+b87FFhudyxy+KskdLbLc35aZTvC6GCbQaUcLJUaiE01vb7gyOrnefFZ9rb8lan1mix3f71jmuZ0otw6Bd1KpbbOmgv7EYydO5t6GDoVz1Bx68YOVWuOnlmpN5QLVosETOuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Si3QEYnl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Si3QEYnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBE21F00A3E;
	Mon, 31 Aug 2026 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184075;
	bh=GjKDFAUDy91EhvmuMW3l0NSZA+T7hWB6tOHcKdnDrzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Si3QEYnlKBo5UV7lIryzxy+r3EAda+MbG+G0r1VHH5iWGpfTUg0Wjqv9u/BO2soAI
	 RYq3/tLXYN3Z11j4PF+OSUYYBrEk0ZzCvAffNWXI9FQ0EfmsMowXSaty+H7B5+MSR8
	 RUr0eqDfqcP4zgNYG33RY1/WiloV23IJYSVqamun0muKsYBF2n7n/moT/FFRVRUYfe
	 AC8L4gC1QVy2XzaTOiJS7XgBfDX+SR9o84UWgj+OU+iIcH9NDgs90yYJ6lcDS6dVW7
	 D0EWMbm5v+df29vuwiprRDOy2kC+X+wfK/An6MmboeIjjutX5cJIV44qJMrTH9WOYK
	 m+ZFtBPZ3T/AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: call iwl_mld_free_ap_early_key() for AP only
Date: Mon, 31 Aug 2026 09:28:24 -0400
Message-ID: <20260831133314.4125787-476-sashal@kernel.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit c35c44434329c6b3bd2c6c1e5add5ae10d933a4d ]

The driver supports intalling IGTK on a NAN device interface. When
the IGTK is removed, iwl_mld_free_ap_early_key() is called which
results in a warning since no links are attached to this interface.
The iwl_mld_free_ap_early_key() function should be called for AP or
IBSS interfaces only. Check the interface type before calling it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Link: https://patch.msgid.link/20260512222731.d67d658b421d.Ife2d1f3b17119ce696582ce6a2a69026d368d8af@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: call
iwl_mld_free_ap_early_key() for AP only`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[call/fix]` — Only call
`iwl_mld_free_ap_early_key()` on AP/IBSS interfaces, not on all non-
pairwise key removals.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Avraham Stern `<avraham.stern@intel.com>` (author)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (maintainer)
- **Link:** `https://patch.msgid.link/20260512222731.d67d658b421d...`
  (patch submission reference)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: no syzbot/fuzzer report; Intel iwlwifi maintainer sign-off

### Step 1.3: Body analysis
**Record:**
- **Bug:** IGTK can be installed on a NAN device interface. On removal,
  `iwl_mld_free_ap_early_key()` is called unconditionally for non-
  pairwise keys, but NAN has no attached links → `WARN_ON(!link)` fires
  inside that helper.
- **Symptom:** Kernel warning (`WARN_ON`) during IGTK removal on NAN.
- **Root cause:** `iwl_mld_free_ap_early_key()` is AP/IBSS-only logic
  (early key staging before bcast/mcast STAs exist), but the remove path
  called it for every non-pairwise key regardless of interface type.
- **Fix:** Gate the call on `vif->type == NL80211_IFTYPE_AP || vif->type
  == NL80211_IFTYPE_ADHOC`, matching the store path.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although not labeled "fix", this corrects an asymmetric
store/remove bug. The store path already restricts early-key handling to
AP/IBSS; the remove path did not.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c` (+2
  lines, scope unchanged)
- **Function:** `iwl_mld_set_key_remove()`
- **Scope:** Single-file, surgical (2-line condition extension)

### Step 2.2: Code flow change
**Record:**
- **Before:** Any non-pairwise key removal →
  `iwl_mld_free_ap_early_key()`.
- **After:** Non-pairwise key removal on AP or IBSS only →
  `iwl_mld_free_ap_early_key()`.
- **Affected path:** `DISABLE_KEY` → `iwl_mld_set_key_remove()` → early-
  key cleanup before `iwl_mld_remove_key()`.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix.** `iwl_mld_free_ap_early_key()`
dereferences `mld_vif->link[key->link_id]`:

```196:207:drivers/net/wireless/intel/iwlwifi/mld/ap.c
void iwl_mld_free_ap_early_key(struct iwl_mld *mld,
                               struct ieee80211_key_conf *key,
                               struct iwl_mld_vif *mld_vif)
{
        struct iwl_mld_link *link;

        if (WARN_ON(key->link_id < 0))
                return;

        link = iwl_mld_link_dereference_check(mld_vif, key->link_id);
        if (WARN_ON(!link))
                return;
```

Called from interfaces that never use early-key storage → spurious
`WARN_ON`.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing store guard at lines
2099–2102. Minimal regression risk. No new APIs or behavior changes
beyond suppressing incorrect helper calls.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** All lines in this file blame to `7e22de67e545d` (squashed
stable snapshot). Meaningful per-line history unavailable in this
checkout.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: File history
**Record:** `git log` on `mld/mac80211.c` returns only the squashed HEAD
commit. Cannot trace introduction of the asymmetry via git history in
this tree.

### Step 3.4: Author context
**Record:** Avraham Stern (Intel iwlwifi). Miri Korenblit signed off —
iwlwifi maintainer. Part of May 2026 iwlwifi update series (NAN/IGTK
work in
`20260511_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_11.mbx`).

### Step 3.5: Dependencies
**Record:** Standalone. No series dependency. Applies to existing
`iwl_mld_set_key_remove()` without prerequisite commits.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` did not match this patch (HEAD is unrelated
amdgpu commit). No `.mbx` file for this specific patch in the workspace.
Lore.kernel.org blocked by bot protection. Link tag points to May 12,
2026 submission; not directly fetchable.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not retrieve thread via b4/lore.

### Step 4.3: Bug report
**Record:** No external bug report referenced. Bug described in commit
message only (NAN IGTK removal warning).

### Step 4.4: Related patches
**Record:** Related iwlwifi mld NAN/IGTK work in
`20260511_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_11.mbx`
(patches 8–10 add NAN TLC, NAN data, separate TX/RX IGTK tracking). This
fix is a follow-on to that work.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore stable search inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_set_key_remove()`, `iwl_mld_free_ap_early_key()`,
`iwl_mld_store_ap_early_key()`, `iwl_mld_mac80211_set_key()`.

### Step 5.2: Callers
**Record:**
- `iwl_mld_set_key_remove()` ← `iwl_mld_mac80211_set_key()`
  (`DISABLE_KEY`)
- `iwl_mld_mac80211_set_key()` is the mac80211 `set_key` driver callback
  — reachable on normal WiFi key install/remove from userspace
  (wpa_supplicant, hostapd, NetworkManager).

### Step 5.3: Callees
**Record:** `iwl_mld_free_ap_early_key()` →
`iwl_mld_link_dereference_check()` → `WARN_ON` on invalid/missing link.
`iwl_mld_remove_key()` handles actual FW key removal afterward.

### Step 5.4: Reachability
**Record:** **Yes, from userspace.** Any `DISABLE_KEY` for a group key
(GTK/IGTK/BIGTK) triggers this path. Store path is already AP/IBSS-only:

```2094:2102:drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
        /* After exiting from RFKILL, hostapd configures GTK/ITGK before
the
  - AP is started, but those keys can't be sent to the FW before the
  - MCAST/BCAST STAs are added to it (which happens upon AP start).
  - Store it here to be sent later when the AP is started.
         */
        if ((vif->type == NL80211_IFTYPE_ADHOC ||
             vif->type == NL80211_IFTYPE_AP) && !sta &&
             !mld_vif->ap_ibss_active)
                return iwl_mld_store_ap_early_key(mld, key, mld_vif);
```

For STA, `key->link_id` is often `-1` (non per-link keys per `key.c`),
which also triggers `WARN_ON(key->link_id < 0)` in the helper today.

### Step 5.5: Similar patterns
**Record:** Store/remove asymmetry is the only instance. Fix aligns
remove with store.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at lines 2160–2162 still has the
unconditional call:

```2160:2162:drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
        /* if this key was stored to be added later to the FW - free it
here */
        if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
                iwl_mld_free_ap_early_key(mld, key, mld_vif);
```

`iwl_mld` driver fully present (65 files under `mld/`).

### Step 6.2: Backport difficulty
**Record:** Clean apply expected — 2-line condition change, no conflicts
anticipated.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. `git log --grep` found nothing
(squashed history).

### NAN-specific note for this tree
**Record:** `NL80211_IFTYPE_NAN` is **not** in `wiphy->interface_modes`
in this tree (lines 268–273). Full NAN IGTK support from the May 11
series (patches 8–10) is **not** present (no `tx_igtk`/`rx_igtk`, no
`NL80211_IFTYPE_NAN` in mac80211.c). The commit-message NAN scenario is
not yet reachable here, but the STA group-key removal path **is**
reachable and can hit the same helper incorrectly.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mld` — IMPORTANT (Intel
WiFi driver, iwl_mld for newer MLD-capable hardware). Not core kernel,
but affects WiFi users on supported Intel hardware.

### Step 7.2: Activity
**Record:** Actively developed; iwl_mld is relatively new (copyright
2024–2025) with ongoing NAN/MLO work.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Intel iwl_mld hardware (WiFi 6E/7 MLD-capable
devices). All interface types that remove group keys (STA most common
today; NAN when that support lands).

### Step 8.2: Trigger conditions
**Record:** Removing any non-pairwise key (GTK/IGTK/BIGTK) on a non-
AP/IBSS interface. Common during STA disconnect/roaming. Unprivileged
users trigger via normal WiFi stack operations.

### Step 8.3: Failure mode severity
**Record:** `WARN_ON` in driver — **MEDIUM**. No crash, corruption, or
deadlock by default. Can spam dmesg; with `panic_on_warn` enabled, could
panic. Functional key removal continues via `iwl_mld_remove_key()`.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates spurious warnings on STA (and future NAN)
  group-key removal; corrects logic bug; trivial fix.
- **Risk:** Very low — 2 lines, mirrors existing store guard, no
  behavior change for AP/IBSS.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real logic bug: remove path calls AP-only helper for all non-pairwise
  keys
- Reachable today on STA group-key removal (common path)
- Matches existing store-path guard — obviously correct
- 2-line, contained fix; no new APIs
- iwl_mld code exists in v6.18.44; fix applies cleanly
- Intel maintainer sign-off

**AGAINST backport:**
- Failure mode is `WARN_ON` only, not crash/corruption (borderline
  importance)
- NAN-specific scenario from commit message not yet reachable in 6.18.44
  (NAN not exposed)
- iwl_mld user base still growing vs legacy mvm

**UNRESOLVED:**
- No mailing-list review thread retrieved
- Cannot confirm via git when asymmetry was introduced (squashed tree)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors store guard;
   maintainer SOB; logic verifiable by inspection. No independent
   Tested-by.
2. Fixes a real bug affecting users? **PASS** — spurious `WARN_ON` on
   group-key removal for non-AP/IBSS interfaces.
3. Important issue? **PASS (borderline)** — `WARN_ON` spam; possible
   panic with `panic_on_warn`; not data corruption or security.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code confirmed present.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).

### Step 9.4: Decision rationale

This is a small, obviously correct fix for a real driver logic error.
The store path already limits early-key handling to AP/IBSS; the remove
path should match. Without the fix, removing group keys on STA (and
eventually NAN) triggers unnecessary `WARN_ON` calls inside
`iwl_mld_free_ap_early_key()`. While severity is medium (warning, not
crash), the fix is minimal, low-risk, and aligns two code paths that
should never have diverged. It meets stable criteria for iwlwifi driver
bug fixes.

---

## Verification

- **[Phase 1]** Parsed commit message, tags, and body from user query
- **[Phase 2]** Read diff and `iwl_mld_free_ap_early_key()` in `ap.c`;
  confirmed `WARN_ON` mechanism
- **[Phase 2]** Read `iwl_mld_set_key_remove()` and store-path guard in
  `mac80211.c`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`
- **[Phase 3]** `git blame -L 2160,2162` → lines present, squashed
  history
- **[Phase 3]** `git log --oneline --
  drivers/net/wireless/intel/iwlwifi/mld/mac80211.c` → single squashed
  commit
- **[Phase 4]** `b4 dig -c HEAD` → no match for this patch
- **[Phase 4]** Searched workspace `.mbx` files → no mbox for this
  specific patch
- **[Phase 4]** WebFetch lore.kernel.org → blocked (bot protection)
- **[Phase 4]** Read
  `20260511_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_11.mbx`
  → related NAN/IGTK series context
- **[Phase 5]** `rg iwl_mld_free_ap_early_key` → call sites in
  `mac80211.c`, definition in `ap.c`
- **[Phase 5]** Traced `iwl_mld_mac80211_set_key()` → `DISABLE_KEY` →
  `iwl_mld_set_key_remove()`
- **[Phase 5]** Read `key.c` `iwl_mld_get_key_sta_mask()` →
  `key->link_id < 0` common for non per-link STA keys
- **[Phase 6]** Confirmed buggy code at lines 2160–2162 without AP/IBSS
  check
- **[Phase 6]** Confirmed `NL80211_IFTYPE_NAN` not in `interface_modes`
  (lines 268–273)
- **[Phase 6]** Confirmed no `tx_igtk`/`rx_igtk` NAN IGTK refactor from
  May series in current tree
- **[Phase 6]** Confirmed `iwl_mld` driver present (65 files)
- **[Phase 7]** Identified subsystem as iwlwifi mld driver
- **[Phase 8]** Assessed failure mode as `WARN_ON` (MEDIUM severity)
- **UNVERIFIED:** Mailing-list review discussion and explicit stable
  nominations
- **UNVERIFIED:** Whether `panic_on_warn` reports exist for this issue
- **UNVERIFIED:** Exact commit SHA on mainline (not in this tree's git
  log)

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 322669d78b193..27ae06e208402 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2164,7 +2164,9 @@ static void iwl_mld_set_key_remove(struct iwl_mld *mld,
 	}
 
 	/* if this key was stored to be added later to the FW - free it here */
-	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
+	    (vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_ADHOC))
 		iwl_mld_free_ap_early_key(mld, key, mld_vif);
 
 	/* We already removed it */
-- 
2.53.0

