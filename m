Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD9F470425;
	Mon, 31 Aug 2026 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183309; cv=none; b=VCzxx54nbl5wOEL9RCFR4DUZPIVXjL1tmGcsDOVtOAIAVhpZ6k5pPq5x9Hi97dtMrxzocatq+KBP+6B2ceSv32M+PJ9QnEClDjjMDfta2icgqBMwlGOQBpCJ1arxdxEV49VAcgweqUU1kKNugDJureBJmN/Lv1BNDEGdOAxks0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183309; c=relaxed/simple;
	bh=9bYPH4i6sMhr3FXumGQ38VGAZJrjpK2FRekudR2SS5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANeN1u2pIHFgNPIsNtFThnTHpbImBcsVed3eskPTyp9wEiH196CtrZvmUFXHzUeY7cDV+HJpqhbVo1x8VaIpwO3K3ayWI8a5nwYbUVaMDZS9AHYXC0OeKsnJluSY5PMbkcJub/9Fdx+rZqkFxAHQgNQ9o2f3q+BHRoz9+OqO9FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQjdnF7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQjdnF7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BE61F00A3F;
	Mon, 31 Aug 2026 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183307;
	bh=5Bg1lfBohA9I8wzu4t89exo6jBiDi4Y9Xzh0HiOPs8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQjdnF7PIA8Yct544WUJBl8ki34KG+z3ic52YbRGvrurxeMsuCjKOCOIgqZ3K1j3M
	 tKHpUFQW67mEsjsaBA3s28aQkS+V9nj/7suQiq+4C1LJ6MQUE7P6DTGIhQUCTMQGvi
	 KagyOXnmP/hC4PfUlZ1rAnjIhPsKgs8ShBjsYFN/M/2W2z9ituAd+8xoCu7HSezYrP
	 zvSTZABNyjI7/oRHTwJPehWgI58ZT2LjW3SH08EKKb+rhLoOYlERVlPC25ThkKHHME
	 pwrWxLZRiBv903mqXWwlywrgXPUu2IVTTQyrrWSlL4zRcnELOXqHixGv5ugL+QE+b0
	 kNrv4Zo7/oMQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: add support for AX231
Date: Mon, 31 Aug 2026 09:21:38 -0400
Message-ID: <20260831133314.4125787-70-sashal@kernel.org>
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

[ Upstream commit 1821c068aa5ea852970b5c9ca05b21681f5d8e83 ]

AX231 is a device that is based on AX211 that doesn't support 6E and
its bandwidth is limited to 80 MHz.
Just reuse the radio config from AX203 which has the exact same
characteristics.
It has a specific subdevice ID to allow the driver to differentiate
between AX211 and AX231.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260512082114.0685ed313987.Ibcfa24e196ac778405d2843f0984b66ca167704e@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi]` `[add]` — Add support for Intel Wi-Fi 6
AX231 adapter in the existing iwlwifi driver.

### Step 1.2: Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Johannes Berg \<johannes.berg@intel.com\> (iwlwifi
  maintainer)
- **Acked-by:** none
- **Link:** https://patch.msgid.link/20260512082114.0685ed313987.Ibcfa24
  e196ac778405d2843f0984b66ca167704e@changeid
- **Cc: stable:** none (expected for manual review)
- **Signed-off-by:** Emmanuel Grumbach (author), Miri Korenblit
  (committer); Sasha Levin ignored per instructions

Notable: maintainer Reviewed-by, no syzbot/user bug reports.

### Step 1.3: Body analysis
**Record:**
- **Bug description:** AX231 is GF-family hardware (like AX211) but
  lacks 6 GHz (6E) support and is limited to 80 MHz bandwidth. It uses
  subdevice ID `0x0294` to distinguish it from AX211.
- **Symptom:** Without a dedicated table entry, the device is matched as
  a generic AX211 (`iwl_rf_gf`), getting 6E-capable, 160 MHz
  configuration instead of the 80 MHz, non-6E config needed (same as
  AX203).
- **Root cause:** Missing `iwl_dev_info_table` entry for subdevice
  `0x0294` with the correct RF config (`iwl_rf_hr_80mhz` aliased as
  `iwl_rf_ot`).

### Step 1.4: Hidden bug fix?
**Record:** Not disguised as a cleanup. It is hardware enablement, but
it also corrects a real misconfiguration: wrong `iwl_rf_cfg` would be
selected at probe, affecting `uhb_supported`, bandwidth limits, and
related driver behavior.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
| File | Changes | Functions/areas |
|------|---------|-----------------|
| `cfg/rf-gf.c` | +1 line (+ copyright year) | device name string |
| `iwl-config.h` | +2 lines (+ copyright year) | extern declaration,
`#define iwl_rf_ot` |
| `pcie/drv.c` | +1 line (+ copyright year) | `iwl_dev_info_table[]` |

**Scope:** 3 files, ~4 functional lines (+ copyright bumps). Single-
subsystem, surgical.

### Step 2.2: Code flow per hunk
**Record:**
1. **rf-gf.c:** Adds `iwl_ax231_name[]` display string.
2. **iwl-config.h:** Declares `iwl_ax231_name`; defines `iwl_rf_ot` as
   alias for existing `iwl_rf_hr_80mhz`.
3. **pcie/drv.c:** Adds `IWL_DEV_INFO(iwl_rf_ot, iwl_ax231_name,
   RF_TYPE(GF), SUBDEV(0x0294))` in GF RF section.

**Before:** AX231 (GF RF, subdev `0x0294`) matches generic
`IWL_DEV_INFO(iwl_rf_gf, iwl_ax211_name, RF_TYPE(GF))` → `iwl_rf_gf`
(`.uhb_supported = true`, no `bw_limit`).

**After:** Subdevice `0x0294` matches dedicated entry →
`iwl_rf_hr_80mhz` (`.bw_limit = 80`, no `uhb_supported`).

### Step 2.3: Bug mechanism
**Record:** **Category:** Hardware quirk / device-ID matching +
logic/correctness fix.

Without the entry, `iwl_pci_find_dev_info()` in probe assigns wrong
`trans->cfg`. Verified configs:

```41:57:drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c
const struct iwl_rf_cfg iwl_rf_gf = {
        .uhb_supported = true,
        // ... no bw_limit
};
```

```71:74:drivers/net/wireless/intel/iwlwifi/cfg/rf-hr.c
const struct iwl_rf_cfg iwl_rf_hr_80mhz = {
        IWL_DEVICE_HR,
        .bw_limit = 80,
};
```

`uhb_supported` and `bw_limit` are used in `mvm/fw.c`, `iwl-nvm-
parse.c`, etc.

### Step 2.4: Fix quality
**Record:** Minimal, follows existing AX203 pattern (`iwl_rf_hr_80mhz`
for 80 MHz limited device). Reviewed by maintainer. **Regression risk:**
Very low — only affects hardware with subdevice `0x0294`.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** GF device table lines introduced in `7f3791cbe3cf0`
(Johannes Berg, 2025-05-10) "wifi: iwlwifi: cfg: clean up GF device
matching". Generic AX211 GF entry has been present since then. AX231
hardware post-dates this; the gap is missing ID, not a regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Similar backported commits in this tree:
- `9d713f4f8bb0e` — "wifi: iwlwifi: cfg: add new device names" (SUBDEV
  entries, backported to 6.18.y)
- `019f71a6760a6` — "wifi: iwlwifi: cfg: add back more lost PCI IDs"
- `2f84d5e9c1c57` — "wifi: iwlwifi: disable EHT if the device doesn't
  allow it"

Standalone patch (5/15 in iwlwifi-next series, but functionally
independent).

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is a senior iwlwifi developer. Commit
committed by Miri Korenblit (Intel iwlwifi maintainer team). Reviewed by
Johannes Berg (wireless maintainer).

### Step 3.5: Dependencies
**Record:** No prerequisites. All referenced symbols (`iwl_rf_hr_80mhz`,
`RF_TYPE(GF)`, `SUBDEV`, `iwl_rf_gf` infrastructure) exist in 6.18.44.
Commit `1821c068aa5e` exists in object store but is **not** an ancestor
of HEAD (not yet applied).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c 1821c068aa5e` → https://patch.msgid.link/20260512
082114.0685ed313987.Ibcfa24e196ac778405d2843f0984b66ca167704e@changeid.
Part of iwlwifi-next series, patch 5/15 (Ratatoskr/lore). `b4 dig -a`
returned no extra revisions. Direct lore fetch blocked by bot
protection; patch content verified via `git show` and GitHub mirror.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned only the lore URL (no recipient list).
Reviewed-by: Johannes Berg confirmed in commit message.

### Step 4.3: Bug report
**Record:** N/A — no user/syzbot report. Intel internal hardware
enablement.

### Step 4.4: Series context
**Record:** Patch 5/15 of iwlwifi-next May 2026 series. This patch is
self-contained; other series patches are unrelated features.

### Step 4.5: Stable list
**Record:** Not searched on lore stable list. No stable nomination found
in available sources.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `iwl_pci_find_dev_info()`, `iwl_pci_gen1_2_probe()` (via
`gen1_2/trans.c`), `iwl_dev_info_table[]` initialization.

### Step 5.2: Callers
**Record:** `iwl_pci_find_dev_info()` called from
`pcie/gen1_2/trans.c:4221` during PCI probe — standard device
enumeration path for all iwlwifi PCIe devices.

### Step 5.3: Callees
**Record:** Table lookup sets `iwl_trans->cfg` and `info.name` at probe;
downstream affects firmware loading, band capabilities, NVM parsing.

### Step 5.4: Reachability
**Record:** Triggered at driver probe when AX231 hardware is present
(laptop/desktop with Intel AX231). Requires `CONFIG_IWLMVM`. Userspace
cannot directly trigger, but any user with this hardware hits this path
at boot/module load.

### Step 5.5: Similar patterns
**Record:** AX203 uses `IWL_DEV_INFO(iwl_rf_hr_80mhz, iwl_ax203_name,
RF_TYPE(HR2), BW_LIMITED)` at line 1012. Killer variants use `SUBDEV()`
entries in same table. Same pattern as backported `9d713f4f8bb0e`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Tree is `v6.18.44` / `6.18.44`. Generic
`IWL_DEV_INFO(iwl_rf_gf, iwl_ax211_name, RF_TYPE(GF))` at line 1016
matches any GF device without a more specific entry. No `iwl_ax231`,
`0x0294`, or `iwl_rf_ot` present (grep confirmed). iwlwifi driver and
all prerequisite configs exist.

### Step 6.2: Backport complications
**Record:** `git apply --check` fails on `rf-gf.c` due to line-
offset/context mismatch (stable tree still has `IWL_FW_AND_PNVM` macros
that mainline base for this commit had moved). Functional insertion
point is unchanged (after `iwl_ax211_name` at line 73). **Minor manual
adjustment needed**, not a structural rework.

### Step 6.3: Related fixes already present?
**Record:** No AX231-specific fix. Related mitigations (`2f84d5e9c1c57`
EHT disable, `c0b3fa5e0eaec` 6E command guard) are present but do not
replace correct cfg selection at probe.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi` — **IMPORTANT** (widely
deployed WiFi hardware, affects connectivity for AX231 users).

### Step 7.2: Activity
**Record:** Actively maintained; recent commits in this tree include
resume flow, EHT handling, device name additions.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users with Intel Wi-Fi 6 AX231 hardware on systems running
iwlwifi with `CONFIG_IWLMVM`. Driver-specific, but iwlwifi is extremely
common on Intel laptops.

### Step 8.2: Trigger conditions
**Record:** Boot or `modprobe iwlwifi` with AX231 present (GF RF type,
subdevice `0x0294`). Deterministic at probe — not a race.

### Step 8.3: Failure mode severity
**Record:** Wrong RF config → 6E enabled on non-6E hardware, no 80 MHz
bandwidth limit → WiFi may not work correctly or at all. **Severity:
HIGH** for affected users (loss of connectivity); not a kernel
crash/Oops, but a serious functional failure.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for AX231 users — correct driver config and device
  naming
- **Risk:** VERY LOW — 4 functional lines, subdevice-specific,
  maintainer-reviewed
- **Ratio:** Strong benefit, minimal risk. Matches established iwlwifi
  device-ID backport pattern in this tree.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Standard iwlwifi hardware enablement (subdevice ID + correct RF
  config)
- Falls under stable exception for device ID additions to existing
  drivers
- Wrong config without patch (`iwl_rf_gf` vs `iwl_rf_hr_80mhz`) verified
  in source
- Small, maintainer-reviewed, self-contained
- Precedent: `9d713f4f8bb0e`, `019f71a6760a6` backported to this tree
- All prerequisites present in 6.18.44

**AGAINST backport:**
- Not a crash/security/data-corruption fix
- New hardware may have limited deployment on 6.18.y initially
- Patch needs trivial context adjustment to apply (not bit-exact `git
  apply`)

**Unresolved:** No user bug reports; lore thread content not fully
readable due to bot protection.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — maintainer reviewed, mirrors
   AX203 pattern
2. Fixes real bug affecting users? **PASS** —
   misidentified/misconfigured hardware for AX231 owners
3. Important issue? **PASS** — WiFi non-functional or degraded on
   affected hardware (HIGH for those users)
4. Small and contained? **PASS** — ~4 functional lines, 3 files
5. No new features/APIs? **PASS** — device table entry exception; no new
   uapi
6. Can apply to local tree? **PASS** — minor context offset in `rf-
   gf.c`; all symbols exist

### Step 9.3: Exception category
**Record:** **NEW DEVICE ID / hardware quirk** — subdevice ID `0x0294`
with correct RF config for existing iwlwifi driver.

### Step 9.4: Decision rationale

This commit enables Intel AX231 Wi-Fi hardware on the 6.18.44 stable
tree by adding a subdevice-specific `iwl_dev_info_table` entry that
selects the 80 MHz, non-6E RF configuration (`iwl_rf_hr_80mhz`) instead
of the generic AX211 GF config. Without it, AX231 devices get incorrect
capabilities at probe time. The change is minimal, follows an
established iwlwifi pattern already backported to this tree, and carries
very low regression risk since it only affects one subdevice ID.

---

## Verification

- [Phase 1] Parsed commit message and tags from provided diff and `git
  show 1821c068aa5e`
- [Phase 2] Diff analysis: 4 functional lines across 3 files; verified
  `iwl_rf_gf` vs `iwl_rf_hr_80mhz` struct differences
- [Phase 3] `git describe HEAD` → v6.18.44; `make kernelversion`
  equivalent → 6.18.44
- [Phase 3] `git blame` on drv.c:1015-1018 → `7f3791cbe3cf0`
  (2025-05-10)
- [Phase 3] `git merge-base --is-ancestor 1821c068aa5e HEAD` → not
  ancestor (commit not applied)
- [Phase 3] Found backport precedent: `9d713f4f8bb0e`, `019f71a6760a6`
- [Phase 4] `b4 dig -c 1821c068aa5e` → lore URL found; `-w`/`-a` minimal
  output
- [Phase 4] Web search confirmed commit `1821c068aa5e`, patch 5/15 of
  iwlwifi-next series
- [Phase 4] UNVERIFIED: Full lore thread content (bot protection on
  patch.msgid.link)
- [Phase 5] `grep iwl_pci_find_dev_info` → called from
  `pcie/gen1_2/trans.c:4221` at probe
- [Phase 5] `grep uhb_supported/bw_limit` → used in `mvm/fw.c`, `iwl-
  nvm-parse.c`
- [Phase 6] `grep AX231/0x0294/iwl_rf_ot` → no matches (fix not present)
- [Phase 6] Verified `iwl_rf_hr_80mhz`, `iwl_ax203_name`, `SUBDEV`
  macro, GF table section all exist
- [Phase 6] `git apply --check` → fails on `rf-gf.c` line offset;
  insertion point at line 73 confirmed manually
- [Phase 7] iwlwifi is actively maintained in this tree
- [Phase 8] Failure mode: wrong RF config at probe → WiFi
  broken/degraded on AX231 hardware

**YES****Verdict: YES** — backport to this tree (6.18.44).

The commit adds Intel AX231 support via subdevice `0x0294`, mapping it
to the 80 MHz, non-6E RF config (`iwl_rf_hr_80mhz`) instead of the
generic AX211 GF entry. Without it, AX231 hardware gets the wrong
capabilities at probe.

It’s a small, maintainer-reviewed device-ID enablement patch in line
with other iwlwifi backports already in this tree (e.g.
`9d713f4f8bb0e`). It may need a trivial context tweak in `rf-gf.c` when
applying, but all prerequisites are present.

 drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c  | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 4 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c b/drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c
index c16cda087a7c3..307b557dce997 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include "iwl-config.h"
 
@@ -71,6 +71,7 @@ const char iwl_ax411_killer_1690i_name[] =
 
 const char iwl_ax210_name[] = "Intel(R) Wi-Fi 6E AX210 160MHz";
 const char iwl_ax211_name[] = "Intel(R) Wi-Fi 6E AX211 160MHz";
+const char iwl_ax231_name[] = "Intel(R) Wi-Fi 6 AX231";
 const char iwl_ax411_name[] = "Intel(R) Wi-Fi 6E AX411 160MHz";
 
 IWL_FW_AND_PNVM(IWL_SO_A_GF_A_FW_PRE, IWL_GF_UCODE_API_MAX);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 3b4f990a8d0bb..cfdea6afe3bf6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2005-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #ifndef __IWL_CONFIG_H__
 #define __IWL_CONFIG_H__
@@ -670,6 +670,7 @@ extern const char iwl_ax411_killer_1690s_name[];
 extern const char iwl_ax411_killer_1690i_name[];
 extern const char iwl_ax210_name[];
 extern const char iwl_ax211_name[];
+extern const char iwl_ax231_name[];
 extern const char iwl_ax411_name[];
 extern const char iwl_killer_be1750s_name[];
 extern const char iwl_killer_be1750i_name[];
@@ -739,6 +740,7 @@ extern const struct iwl_rf_cfg iwl_rf_hr;
 extern const struct iwl_rf_cfg iwl_rf_hr_80mhz;
 
 extern const struct iwl_rf_cfg iwl_rf_gf;
+#define iwl_rf_ot iwl_rf_hr_80mhz
 #endif /* CONFIG_IWLMVM */
 
 #if IS_ENABLED(CONFIG_IWLMLD)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index cd0c416e927a7..0e8481219839b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2005-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1016,6 +1016,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 
 /* GF RF */
 	IWL_DEV_INFO(iwl_rf_gf, iwl_ax211_name, RF_TYPE(GF)),
+	IWL_DEV_INFO(iwl_rf_ot, iwl_ax231_name, RF_TYPE(GF), SUBDEV(0x0294)),
 	IWL_DEV_INFO(iwl_rf_gf, iwl_ax411_name, RF_TYPE(GF), CDB),
 	IWL_DEV_INFO(iwl_rf_gf, iwl_ax210_name, DEVICE(0x2725)),
 
-- 
2.53.0

