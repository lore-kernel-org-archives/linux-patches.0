Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E265529402;
	Mon, 31 Aug 2026 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183875; cv=none; b=hlIXv5q01eSZlL7CHKQ1aYJ0Ula+E1+41s+emmcdXGbz5u80EPrAMHPCWC+Go5z/6fbwJkJwY9bL116Zhh5uFDSGbcR/A1cc1DRJDc7rqJOSja4njIe46nvgBq49VL1O7+kZtR0MuN4/XlMh87VE+TjciI3OFvfSEB9xG9xJCbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183875; c=relaxed/simple;
	bh=nFXSYCry55EdaEUWfLjYeH4SpTT0xiTGgYhF7KRr9Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDb/wxUiUY3eHN7WolZc1cVNAh8yiwItWchCKAeBBaZen0cXsaBdwlaHA1NM7WRtUMnb57LYwFKdQ5pGc+FPpvOQQhAo//cIkdQMcW1w6ipAvtCw/azvJqeIwUOxbLMGoqJOMhFIV2HG5mhoAyJewHMDjjiglQr0HsLYe9MQdlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f48LC4EH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f48LC4EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F80B1F00A3F;
	Mon, 31 Aug 2026 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183873;
	bh=AVxcecYfqKzkf+K6sEeSD8U++FsBsTuA1nkqXpso3B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f48LC4EHoPgv9Hh7ToWohO1CH4oQM5yNsNnN8XQD2NaQsFsMtbeZc3UnXFGt8C9rP
	 bEyjL0oi/66pu1dn67dlcWLPv/An7UphVFK4BhPAW5T/yrhsY61JB9PCvq8pN/xOPB
	 JSPGGFcRwMjVnwmPkKnFLoG9Gg0snRD0k9UTTXI1+zB3HZKKBywnWMOVZyHmEQjJXa
	 sMCtHYV23kSXfciV99xS/YFsqHk63MZVeYBIGeFGcPlGRhBMo6s8rKk3Y9ViRDMi6O
	 SymT6g7K/MMgtZWAGLvmig1tCZL7lMFOqa89fLnxrGMqDdlwVmMWItMjTy7W00Z1w2
	 PI5W0B8DdLG/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: disallow puncturing in US/CA for WH
Date: Mon, 31 Aug 2026 09:26:22 -0400
Message-ID: <20260831133314.4125787-354-sashal@kernel.org>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit ce2edf7c3910cb3222d51c0a7457b7a71703a5b1 ]

FM continues to follow the BIOS/MCC policy, while WH sets
DISALLOW_PUNCTURING for US/CA and clears it for other MCC values.
Update the MCC handling accordingly.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260515150751.df1f1fdd141f.I900c9e2e3dd722619db12ba10d0879a56a2a55f2@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: disallow puncturing in
US/CA for WH`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[disallow]` — MLD driver regulatory
policy: block EHT channel puncturing on WH RF hardware when MCC is US or
Canada.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Pagadala Yesu Anjaneyulu, Miri Korenblit
- **Reviewed-by:** Emmanuel Grumbach (Intel iwlwifi maintainer)
- **Link:** patch.msgid.link URL (Anubis-protected; could not fetch
  content)
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  syzbot links

Notable: maintainer review present; no user/fuzzer bug report.

### Step 1.3: Body analysis
**Record:**
- **Bug described:** WH RF type does not apply the correct puncturing
  policy during MCC (Mobile Country Code) updates. FM follows BIOS/MCC
  policy via `iwl_puncturing_is_allowed_in_bios()`; WH should
  unconditionally disallow puncturing in US/CA and allow it elsewhere.
- **Symptom:** WH adapters in US/CA would not have
  `IEEE80211_HW_DISALLOW_PUNCTURING` set, so mac80211 would accept
  punctured channel definitions that should be blocked.
- **Root cause (author):** Incomplete MCC handling — only FM was covered
  in the existing `if` block; WH needs its own branch.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite no "fix" in the subject, this closes a
regulatory-policy gap on supported WH hardware. Not a crash fix, but
incorrect driver behavior on real hardware in specific regions.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/mcc.c` (+11 / -2,
  ~13 net lines)
- **Function:** `iwl_mld_get_regdomain()`
- **Scope:** Single-file, surgical regulatory-policy fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Only `IWL_CFG_RF_TYPE_FM` sets/clears
  `DISALLOW_PUNCTURING` based on BIOS+MCC. WH (and PE) hit no branch —
  flag never set for US/CA.
- **After:** FM unchanged. New `else if` for `IWL_CFG_RF_TYPE_WH`: if
  MCC is `IWL_MCC_US` (0x5553) or `IWL_MCC_CANADA` (0x4341), set
  `DISALLOW_PUNCTURING`; otherwise clear it.
- **Path affected:** Every MCC/regdomain update (init, firmware
  notification, manual regdomain refresh) via `iwl_mld_get_regdomain()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / regulatory correctness fix
- **Mechanism:** WH hardware uses the MLD driver
  (`iwl_drv_is_wifi7_supported()` → RF type ≥ FM). Without the WH
  branch, `ieee80211_chandef_usable()` in mac80211 allows punctured
  chandefs when `DISALLOW_PUNCTURING` is not set:

```785:787:net/mac80211/mlme.c
        if (chandef->punctured &&
            ieee80211_hw_check(&sdata->local->hw, DISALLOW_PUNCTURING))
                return false;
```

FM already uses `iwl_puncturing_is_allowed_in_bios()` for the same
countries:

```716:728:drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
bool iwl_puncturing_is_allowed_in_bios(u32 puncturing, u16 mcc)
{
        /* Some kind of regulatory mess means we need to currently
disallow
  - puncturing in the US and Canada unless enabled in BIOS.
         */
        switch (mcc) {
        case IWL_MCC_US:
                return puncturing & IWL_UEFI_CNV_PUNCTURING_USA_EN_MSK;
        case IWL_MCC_CANADA:
                return puncturing &
IWL_UEFI_CNV_PUNCTURING_CANADA_EN_MSK;
        default:
                return true;
        }
}
```

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors existing FM pattern with WH-
specific unconditional US/CA block. Minimal diff. Low regression risk;
only affects WH RF type during MCC updates. Comment update clarifies
prior misleading "later always do puncturing" note.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Puncturing block in `mcc.c` lines 132–140 attributed to
commit `7e22de67e545d` (flattened history in this checkout — not the
true origin commit). Buggy omission (WH not handled) is present in
current tree at those lines.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: File history
**Record:** `git log --oneline` on `mld/mcc.c` returns only the
flattened import commit. History is not useful for dating the original
FM puncturing code. Patch is **15/15** in
`v2_20260515_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_14`
series; this commit is **standalone** within `mcc.c` and does not depend
on other series patches.

### Step 3.4: Author context
**Record:** Pagadala Yesu Anjaneyulu (Intel). Series collected by Miri
Korenblit (Intel iwlwifi). Reviewed by Emmanuel Grumbach (maintainer).

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses symbols already in tree:
`IWL_CFG_RF_TYPE_WH`, `IWL_MCC_US`, `IWL_MCC_CANADA`,
`ieee80211_hw_set()`, `DISALLOW_PUNCTURING`. All verified present.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Local mbox `v2_20260515_miriam_rachel_korenblit_wifi_iwlwifi
_updates_2026_05_14.mbx` contains patch `[PATCH v2 15/15]` with
identical diff and message. `b4 dig -c` could not be run (commit not in
tree). lore.kernel.org blocked by Anubis.

### Step 4.2: Reviewers
**Record:** Reviewed-by: Emmanuel Grumbach. Series cover lists multiple
Intel iwlwifi developers; no stable nomination found in mbox grep.

### Step 4.3: Bug report
**Record:** No Reported-by, no syzbot, no crash trace. Issue is
regulatory policy alignment, not a reported oops.

### Step 4.4: Series context
**Record:** Part of 15-patch iwlwifi update series (UHR, NAN, debugfs,
PCI IDs, etc.). This patch is independently applicable — only touches
`mcc.c`.

### Step 4.5: Stable list
**Record:** Could not search lore stable list (Anubis). No stable
nomination found in local mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_get_regdomain()` modified.

### Step 5.2: Callers
**Record:** `iwl_mld_get_regdomain()` called from:
- `iwl_mld_get_current_regdomain()` →
  `iwl_mld_update_changed_regdomain()`, `iwl_mld_init_mcc()`
- `iwl_mld_apply_last_mcc()` (init path)
- `iwl_mld_handle_update_mcc()` (firmware MCC notification)

All run on normal device operation / regdomain changes — common paths
for WH hardware users.

### Step 5.3: Callees
**Record:** `CSR_HW_RFID_TYPE()`, `le16_to_cpu()`, `ieee80211_hw_set()`,
`__clear_bit()`.

### Step 5.4: Reachability
**Record:** WH devices (BE211, BE213, AX221, Killer BE1775s/i) are
registered under `CONFIG_IWLMLD` in `pcie/drv.c`. Driver selection uses
MLD opmode for WiFi 7 (RF ≥ FM, fw ≥ 97). WH users in US/CA hit this
code on every MCC update. **Userspace-reachable** via normal WiFi
operation and regdomain changes.

### Step 5.5: Similar patterns
**Record:** FM branch in same function;
`iwl_puncturing_is_allowed_in_bios()` in `fw/regulatory.c`; TAS US/CA
block-list logic in `mld/regulatory.c` and `mvm/fw.c` for same
countries.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `mcc.c` lines 132–140 handle only FM; WH is
not covered. WH hardware support exists (`cfg/rf-wh.c`, PCI IDs in
`pcie/drv.c` lines 1062–1078). Commit not yet applied.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Target hunk matches current file
structure exactly. No conflicting changes in recent tree history for
this file.

### Step 6.3: Related fixes already present?
**Record:** FM puncturing logic already in tree. No WH branch found. No
duplicate fix.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/net/wireless/intel/iwlwifi` (Intel
WiFi, widely deployed). WH = WiFi 7 adapters (BE211/BE213/Killer
BE1775).

### Step 7.2: Activity
**Record:** iwlwifi MLD actively developed; WH is current-generation
hardware in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with **WH RF Intel WiFi 7 adapters**
(`CONFIG_IWLMLD=y/m`) in **US or Canada**. Not universal; driver- and
region-specific.

### Step 8.2: Trigger conditions
**Record:** WH device boot, MCC update from firmware/BIOS, or regdomain
change while MCC is US (0x5553) or Canada (0x4341). Common on WH laptops
in North America. Unprivileged users indirectly trigger via normal WiFi
stack operation.

### Step 8.3: Failure mode severity
**Record:** **Incorrect regulatory behavior** — punctured EHT channels
allowed when they must be disallowed. Not a kernel crash, UAF, or data
corruption. Potential FCC/ISED non-compliance and possible
connectivity/regulatory mismatch with firmware. **Severity: MEDIUM**
(regulatory/hardware correctness, not system stability).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Corrects regulatory policy on supported WH hardware in
  US/CA; aligns with FM precedent in same function.
- **Risk:** Very low — 9 lines of logic, WH-only, maintainer-reviewed.
- **Ratio:** Moderate benefit for WH US/CA users; very low risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug on supported WH hardware in this tree
- Small, surgical, maintainer-reviewed fix
- FM already has analogous logic; WH was an oversight
- WH adapters (BE211, BE213, Killer BE1775) are in `pcie/drv.c` for
  6.18.44
- Hardware-specific regulatory policy fix (stable-acceptable category)
- Clean apply to current tree

**AGAINST backport:**
- No crash, security issue, data corruption, or deadlock
- No user reports or fuzzer findings
- Pure regulatory/policy fix without demonstrated functional breakage
- Part of a larger feature series (though this hunk is independent)
- Stable rules emphasize crash/security/corruption class issues

**Unresolved:** Original lore thread content; exact mainline commit SHA;
date WH support landed (history flattened in this checkout).

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — simple MCC check;
Reviewed-by maintainer |
| 2. Fixes real bug affecting users? | **PASS** — WH US/CA users get
wrong puncturing policy |
| 3. Important issue? | **PASS (borderline)** — regulatory correctness
on active hardware, not crash class |
| 4. Small and contained? | **PASS** — 1 file, ~11 lines |
| 5. No new features/APIs? | **PASS** — enforces existing
`DISALLOW_PUNCTURING` flag |
| 6. Applies to local tree? | **PASS** — buggy code and WH support both
present in 6.18.44 |

### Step 9.3: Exception category
**Record:** Hardware-specific regulatory workaround for WH RF in US/CA —
analogous to existing FM puncturing policy and other iwlwifi US/CA
regulatory handling (TAS block lists).

### Step 9.4: Decision rationale
For **6.18.44**, WH WiFi 7 hardware is fully supported under
`CONFIG_IWLMLD`, but `iwl_mld_get_regdomain()` omits WH from puncturing
restrictions that FM already enforces. Without this fix, WH adapters in
US/Canada incorrectly permit EHT channel puncturing. The fix is minimal,
obviously correct, independently applicable, and corrects wrong behavior
on shipping hardware in this tree. It does not meet the strongest stable
signals (crash/security/corruption), but it is a real, user-visible
regulatory bug on supported hardware with very low backport risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message and local mbox
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/syzbot tags
- **[Phase 2]** Read full diff; verified FM and new WH branches
- **[Phase 2]** Read `net/mac80211/mlme.c:785-787` —
  `DISALLOW_PUNCTURING` gates punctured chandefs
- **[Phase 2]** Read `fw/regulatory.c:716-728` — FM US/CA BIOS
  puncturing policy
- **[Phase 3]** `git describe HEAD` → v6.18.44; Makefile VERSION 6.18.44
- **[Phase 3]** `git blame -L 130,145 mcc.c` — puncturing block present,
  FM-only
- **[Phase 3]** Read local mbox cover + patch 15/15 — standalone in
  mcc.c
- **[Phase 4]** Read `v2_20260515_miriam_rachel_korenblit_wifi_iwlwifi_u
  pdates_2026_05_14.mbx` — no stable Cc found
- **[Phase 4]** WebFetch lore/patch.msgid.link — blocked (Anubis)
- **[Phase 4]** `b4 dig` — commit not in tree; could not match by SHA
- **[Phase 5]** Grep `iwl_mld_get_regdomain` — 4 call sites in mcc.c
- **[Phase 5]** Read `iwl-drv.c:180-183,1861-1864` — WH uses MLD opmode
  (RF ≥ FM)
- **[Phase 5]** Read `pcie/drv.c:1062-1078` — WH PCI device entries
  present
- **[Phase 5]** Read `cfg/rf-wh.c` — BE211, BE213, AX221, Killer BE1775
  names
- **[Phase 6]** Read current `mcc.c:132-140` — FM-only, WH missing (bug
  confirmed)
- **[Phase 6]** Grep `IWL_CFG_RF_TYPE_WH`, `IWL_MCC_US`,
  `IWL_MCC_CANADA` — all symbols exist
- **[Phase 7]** Confirmed `CONFIG_IWLMLD` in Kconfig/Makefile
- **[Phase 8]** Assessed impact: WH + US/CA + MLD path; regulatory
  MEDIUM severity
- **UNVERIFIED:** Exact mainline commit date; lore reviewer discussion
  beyond mbox headers

**YES**The background `git show` on `7e22de67e545d` finished: that
commit is actually `drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()`,
not iwlwifi work. The iwlwifi `mcc.c` lines show up under it because
this 6.18.44 checkout has flattened history, so blame/log can’t reliably
date when FM puncturing support or WH hardware landed.

That doesn’t change the backport call: WH adapters are supported in this
tree, the FM-only puncturing logic is present, and the missing WH US/CA
handling is a real regulatory-policy gap. Verdict remains **YES** for
6.18.44.

 drivers/net/wireless/intel/iwlwifi/mld/mcc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
index 16bb1b4904f99..8502129abe493 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 
 #include <net/cfg80211.h>
@@ -129,7 +129,7 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 
 	mld->mcc_src = resp->source_id;
 
-	/* FM is the earliest supported and later always do puncturing */
+	/* FM follows BIOS/MCC policy, WH disallows puncturing only in US/CA. */
 	if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) == IWL_CFG_RF_TYPE_FM) {
 		if (!iwl_puncturing_is_allowed_in_bios(mld->bios_enable_puncturing,
 						       le16_to_cpu(resp->mcc)))
@@ -137,6 +137,15 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 		else
 			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
 				    mld->hw->flags);
+	} else if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) ==
+			IWL_CFG_RF_TYPE_WH) {
+		u16 mcc = le16_to_cpu(resp->mcc);
+
+		if (mcc == IWL_MCC_US || mcc == IWL_MCC_CANADA)
+			ieee80211_hw_set(mld->hw, DISALLOW_PUNCTURING);
+		else
+			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
+				    mld->hw->flags);
 	}
 
 out:
-- 
2.53.0

