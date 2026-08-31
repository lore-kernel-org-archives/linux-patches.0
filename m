Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28FD4A9D76;
	Mon, 31 Aug 2026 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183988; cv=none; b=LAnIK9dRkNoT6nMJOvWl1rk4R9AyXXX4+LJVdt/azcw8LRKdFm1LvwHLpaORwD6vniOyDSV+ahq2UZoCd3wQdOltSoMeqAXRUrZ/VHBcTGFeBLLLIrxkTSacMa6r8wqua6hrgMh/U9r7lTVmpak6C+Kkk5DTXHHXDiJR4f9s1UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183988; c=relaxed/simple;
	bh=bG6HE97XeTbZtwJczo+3R7kVtqCn1sg/nwCk5Pw33OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCd3zNnxfi2YMV/9Qv5M9+7v6yGpC7wvdc9YvqEPWVLYCpv6Q0Lkk+Ddfj83EejuBRD8guFsMEo6tMbPr2ASkSqoV80VDzTfxN7kjKIBk8+wU4PJkcfabJW/IRpcye3kVwpC3AklUwlT9/xj+Oowt1QSiyuk5TjCRnIW6EBEJGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5PuIKvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5PuIKvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98371F00A3D;
	Mon, 31 Aug 2026 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183984;
	bh=Mk0Kqx6Y2AMx5CFVQu6LfnWMNetcPw3qURDJ/mI0Q+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5PuIKvQlmzpDQJ3zD/IxjqArkNlGkrzl3DxMEuIDmjfFIKPV/2DYjuNGuZ15J9qu
	 SMC6y0tPepxn0sZ6IgseMieoDt3LNPHEMrig+e3zNXxAjEIzQrhTfrOMEoPYYbAqEb
	 AvOvFecrsCFlFTD7SdkII5snJNi6gho9bLqP0vqhs+AZdPsNRX7l1SS1oFyVvDFACr
	 W218pHpgd9pYXHFwe7nVXw6p81Ysjeu9EvJ1bV5lWPS7PnPcxq/lXIv9W44cxjX5qc
	 2KFRnOIJxsa5xb0hrsCdwg4eVE0G/QRP00qZbaBTVzp6UIhrKrDDxJ0qvnXM1Xs4xZ
	 oEvWWZ89q1qEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: clear tzone on fail
Date: Mon, 31 Aug 2026 09:27:29 -0400
Message-ID: <20260831133314.4125787-421-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 5c55827ef5c74a5d56939ed0e93df21e6f1f864e ]

iwl_mld_thermal_zone_register() stores the thermal zone pointer in
mld->tzone before calling thermal_zone_device_enable(). If enable
fails, the code unregisters the zone but leaves mld->tzone stale,
so iwl_mld_thermal_zone_unregister() can unregister it again.
Clear mld->tzone after unregister in the error path.

While at it remove a pointless if in iwl_mld_thermal_zone_unregister
after we've alredy checked the tzone pointer is not NULL.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.595dcb8cb7fe.I8125e4a2eeb0390798e3f4074c62c00443eda8e8@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: clear tzone on fail`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel version **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[clear]` — clear stale thermal-zone
pointer on registration failure path in the iwlwifi MLD driver.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260714141909.595dcb8cb7fe...`
  (patch submission reference; lore blocked by bot protection)
- **Assisted-by:** GitHubCopilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`
  (author)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (committer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable, or
  syzbot tags

**Notable patterns:** Intel iwlwifi maintainers; no external bug report
cited.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `iwl_mld_thermal_zone_register()` stores `mld->tzone` before
  calling `thermal_zone_device_enable()`. On enable failure, the zone is
  unregistered but `mld->tzone` is left non-NULL.
- **Symptom:** `iwl_mld_thermal_zone_unregister()` can call
  `thermal_zone_device_unregister()` again on a freed/stale pointer.
- **Root cause:** Missing `mld->tzone = NULL` in the enable-failure
  error path (the register-failure path already clears it correctly).
- **Secondary change:** Remove redundant inner `if (mld->tzone)` in
  unregister after the outer NULL check.

### Step 1.4: Hidden bug fix?
**Record:** **Yes** — described as cleanup but is a real lifecycle bug:
stale pointer after `thermal_zone_device_unregister()` → use-after-free
on later access/unregister.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/thermal.c` (+3
  meaningful lines, -4 lines including copyright year)
- **Functions:** `iwl_mld_thermal_zone_register()`,
  `iwl_mld_thermal_zone_unregister()`
- **Scope:** Single-file surgical fix under `#ifdef CONFIG_THERMAL`

### Step 2.2: Code flow per hunk

**Hunk 1 — `iwl_mld_thermal_zone_register()` error path:**
**Record:** Before: on `thermal_zone_device_enable()` failure →
unregister zone, leave dangling `mld->tzone`. After: set `mld->tzone =
NULL` after unregister, matching the `IS_ERR()` path at lines 263–268.

**Hunk 2 — `iwl_mld_thermal_zone_unregister()`:**
**Record:** Before: redundant double-check `if (mld->tzone)`. After:
direct unregister + NULL assignment (behavior unchanged for valid
paths).

### Step 2.3: Bug mechanism
**Record:** **Category:** use-after-free / stale pointer after resource
teardown.

**Mechanism verified in `thermal_zone_device_unregister()`:**

```1716:1742:drivers/thermal/thermal_core.c
void thermal_zone_device_unregister(struct thermal_zone_device *tz)
{
        if (!tz)
                return;
        // ...
        kfree(tz);
}
```

First unregister on enable failure frees `tz`. Without clearing
`mld->tzone`, later code dereferences freed memory:
- **Unload path:** `iwl_mld_thermal_exit()` →
  `iwl_mld_thermal_zone_unregister()` (line 465)
- **Runtime path:** e.g. `iwl_mld_handle_ct_kill_notif()` at lines 76–77
  checks `if (mld->tzone)` then calls `thermal_zone_device_update()`

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing pattern in the same
function. Minimal regression risk. The redundant-if removal is pure
cleanup.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy register/enable path present in current tree at lines
271–275. `git blame` attributes lines to `5d324e5159d9e` (limited
history in this stable checkout). Bug present since MLD thermal support
landed in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** `git log --
drivers/net/wireless/intel/iwlwifi/mld/thermal.c` shows only the base
import commit in this tree's history. Related iwlwifi mld fixes (e.g.
`3a74aaad04735` UAF fix in `link.c`) are already backported here,
indicating active stable maintenance of iwl_mld.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is iwlwifi maintainer. Miri Korenblit is
active iwlwifi contributor. No other commits from Grumbach on
`mld/thermal.c` in this tree's log.

### Step 3.5: Dependencies
**Record:** Standalone fix. No series dependencies. No prerequisite
commits required. Patch context matches current tree code exactly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig` returned no results (empty output). Link URL
blocked by Anubis bot protection. Local `.mbx` files contain no match
for "clear tzone". **Could not retrieve lore discussion.**

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` not available.

### Step 4.3: Bug report
**Record:** No Reported-by: or syzbot link. Bug identified by code
inspection during driver development.

### Step 4.4: Related patches
**Record:** The legacy MVM driver (`mvm/tt.c` lines 688–692) has the
same missing-NULL pattern but is **not** fixed by this commit. Out of
scope for this evaluation.

### Step 4.5: Stable list discussion
**Record:** UNVERIFIED — lore blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_thermal_zone_register()`,
`iwl_mld_thermal_zone_unregister()`, `iwl_mld_thermal_initialize()`,
`iwl_mld_thermal_exit()`

### Step 5.2: Callers
**Record:**
- `iwl_mld_thermal_initialize()` called from `iwl_op_mode_mld_start()`
  (`mld.c:478`) during driver start
- `iwl_mld_thermal_exit()` called from `iwl_op_mode_mld_stop()`
  (`mld.c:506`) during driver stop/unload

### Step 5.3: Callees
**Record:** `thermal_zone_device_register_with_trips()`,
`thermal_zone_device_enable()`, `thermal_zone_device_unregister()`

### Step 5.4: Reachability
**Record:** Trigger requires `CONFIG_THERMAL` + `CONFIG_IWLMLD`. Path is
reachable on Intel MLD WiFi device probe with thermal support enabled.
`iwl_mld_thermal_zone_register()` is `void` and does not abort probe on
enable failure — driver continues with stale pointer. Unload always
calls `iwl_mld_thermal_exit()`.

### Step 5.5: Similar patterns
**Record:** Register-failure path already sets `mld->tzone = NULL` (line
267). MVM `tt.c` has identical enable-failure bug (not addressed here).

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at lines 271–275 lacks `mld->tzone =
NULL` after unregister on enable failure. Fix commit is **not** yet
applied.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Diff context matches current file
exactly. No conflicting changes in recent history.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. `git log --grep='clear tzone'`
returns nothing.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — Intel WiFi driver
(`drivers/net/wireless/intel/iwlwifi/mld/`), device-driver subsystem.
Affects users of MLD-capable Intel WiFi hardware with thermal support.

### Step 7.2: Activity
**Record:** Active — multiple iwl_mld stable backports in this tree (PTP
race, NULL deref, BA session fixes).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Config-specific (`CONFIG_IWLMLD` + `CONFIG_THERMAL`). Users
of newer Intel MLD WiFi devices with thermal framework enabled.

### Step 8.2: Trigger conditions
**Record:** `thermal_zone_device_enable()` fails after successful
registration. Uncommon but explicitly handled error path. Any subsequent
driver unload or thermal notification using `mld->tzone` triggers UAF.
Not userspace-triggerable directly, but reachable during normal driver
lifecycle on affected hardware.

### Step 8.3: Failure mode severity
**Record:** **HIGH** — use-after-free on freed `struct
thermal_zone_device`. Can cause kernel oops on module unload or during
thermal event handling. Potential security relevance (UAF class).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents UAF on driver teardown and runtime thermal
  paths; one-line meaningful fix
- **Risk:** Very low — adds NULL assignment matching existing pattern;
  cleanup-only hunk in unregister
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real UAF bug on error path with clear mechanism
- Fix is minimal, obviously correct, matches existing code pattern
- Buggy code confirmed present in 6.18.44 tree
- Driver unload path always hits unregister — crash risk on affected
  hardware
- iwl_mld actively maintained in this stable series
- Similar iwl_mld UAF fixes already backported here

**AGAINST backport:**
- No syzbot/user bug report (theoretical until enable fails)
- Narrow audience (IWLMLD + CONFIG_THERMAL)
- MVM driver has same bug but is not fixed by this commit
- Could not verify lore review discussion

**Unresolved:** Lore review thread inaccessible; exact frequency of
`thermal_zone_device_enable()` failure unverified.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is self-evident; no
   Tested-by but pattern matches existing error path
2. Fixes a real bug? **PASS** — stale pointer after free confirmed by
   code reading
3. Important issue? **PASS** — UAF, HIGH severity on unload
4. Small and contained? **PASS** — ~3 meaningful lines in one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code present, clean apply
   expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Problem and decision rationale

When `thermal_zone_device_enable()` fails during iwl_mld thermal zone
setup, the driver unregisters the zone but leaves `mld->tzone` pointing
at freed memory. Because registration failure does not abort driver
probe, the WiFi device continues operating with a dangling pointer. On
driver removal (`iwl_op_mode_mld_stop` → `iwl_mld_thermal_exit`),
`iwl_mld_thermal_zone_unregister()` dereferences that freed structure —
a classic use-after-free that can oops the kernel. Runtime thermal
notification paths (`iwl_mld_handle_ct_kill_notif`) are similarly
affected.

For 6.18.44 users running Intel MLD WiFi with thermal support, this is a
real stability fix with negligible backport risk. The fix mirrors the
already-correct `IS_ERR()` path in the same function.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 2]** Read `thermal.c` lines 65–467; confirmed missing
  `mld->tzone = NULL` at lines 271–275
- **[Phase 2]** Read `thermal_core.c:1716–1742`; confirmed
  `thermal_zone_device_unregister()` frees `tz` via `kfree(tz)`
- **[Phase 2]** Read `thermal_core.c:1691–1709`; confirmed second
  unregister accesses `tz->node` on potentially freed memory
- **[Phase 3]** `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; `make
  kernelversion` → `6.18.44`
- **[Phase 3]** `git blame -L 242,276 thermal.c` → buggy code in current
  tree
- **[Phase 3]** `git log --grep='clear tzone'` → no existing fix
- **[Phase 3]** `git show 3a74aaad04735` → confirmed iwl_mld fixes are
  backported to this tree
- **[Phase 4]** `b4 dig` → empty/no match
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis
- **[Phase 4]** Grep `*.mbx` for "clear tzone" → no matches
- **[Phase 5]** Grep `iwl_mld_thermal` → callers in `mld.c:478,506`
- **[Phase 5]** Read `mld.c:460–527` → thermal init on start, exit on
  stop
- **[Phase 6]** Confirmed
  `drivers/net/wireless/intel/iwlwifi/mld/thermal.c` exists (467 lines)
- **[Phase 6]** Confirmed `CONFIG_IWLMLD` in `Kconfig:84`
- **[Phase 6]** Diff context matches current tree — clean apply expected
- **[Phase 8]** Grep `mvm/tt.c` → same bug pattern at lines 688–692 (not
  fixed by this commit)
- **UNVERIFIED:** Lore review discussion and stable nomination comments
- **UNVERIFIED:** How often `thermal_zone_device_enable()` fails on
  iwl_mld hardware

**YES**The `b4 dig` search for the patch thread finished with no match —
it returned empty output for both the commit hash and the subject line
`wifi: iwlwifi: mld: clear tzone on fail`. Lore/patch.msgid.link was
also unreachable (bot protection), so the review thread couldn’t be
retrieved that way.

That doesn’t change the earlier conclusion: the bug is a real stale-
pointer/UAF on the thermal-zone enable-failure path in `iwl_mld`, the
fix is small and applies cleanly to this 6.18.44 tree, and the backport
recommendation remains **YES**.

 drivers/net/wireless/intel/iwlwifi/mld/thermal.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
index f8a8c35066beb..e445b1d7d4b00 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #ifdef CONFIG_THERMAL
 #include <linux/sort.h>
@@ -272,6 +272,7 @@ static void iwl_mld_thermal_zone_register(struct iwl_mld *mld)
 	if (ret) {
 		IWL_DEBUG_TEMP(mld, "Failed to enable thermal zone\n");
 		thermal_zone_device_unregister(mld->tzone);
+		mld->tzone = NULL;
 	}
 }
 
@@ -385,10 +386,8 @@ static void iwl_mld_thermal_zone_unregister(struct iwl_mld *mld)
 		return;
 
 	IWL_DEBUG_TEMP(mld, "Thermal zone device unregister\n");
-	if (mld->tzone) {
-		thermal_zone_device_unregister(mld->tzone);
-		mld->tzone = NULL;
-	}
+	thermal_zone_device_unregister(mld->tzone);
+	mld->tzone = NULL;
 }
 
 static void iwl_mld_cooling_device_unregister(struct iwl_mld *mld)
-- 
2.53.0

