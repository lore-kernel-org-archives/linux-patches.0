Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597548CD47;
	Mon, 31 Aug 2026 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183506; cv=none; b=YBRMHuYcv5SAOzNSvigmCuXoujYRaSL0GISl/wexDb+5XyQVNnCNZpzC3SGGXeKRVnVisOJbkIUuqjqawLuMeFIrFuJrKq166/8TI4lQBB/TAAX7wdQGkq1FFoL61f0hjtH/aHGsevwEPKCmlioyi5qGZ2BsvdcdtIbLOtutqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183506; c=relaxed/simple;
	bh=BZaqUhVwE9M9AvVI1ckdH04/KyPfZsht/RVSbm0/E5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D7i4yJQfG/nY1dA23qos10prxnITaZ1XbC7gH9rj8B7s+mKnMzZKZBT6+LaMGmH2qQJeffKlZDQ/h3ZfT/y5fc6/BH0eOkNh3Ad5Ajjtuuyj8cZbS+tqJt3scT6kN2IIQQTClDPN8CmCFIzgoGShYU/+G0eQLx2b9k6cBzN6Fu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcKezk6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcKezk6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AF01F000E9;
	Mon, 31 Aug 2026 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183503;
	bh=zYjGexxpgR3gyp+1xzYD3nJSA80PSxg8RoXvPs2h2uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcKezk6SuwCs27ZYSUeRWBHtk6vTnTHCyNcs4CKlYbv2QdbHPyjlT7nnHljvjCxHb
	 RSrrCgwf95fO6DtiCb8NNxEhw6zwpIUxEiKuk5vUBnNMX26kNIPhqucCl6yPQWDuHi
	 NIAFl39lK+gL8Fsq4zAKWh4Gctkeu0ml8QLucTz+3TUMezC3j6KSsDQrqpuOGtDnXK
	 KsW91vvZ7rl6XumcOC+BcO3pDp3NeF1O25CzdkYA4bQZBTiBkJLnGl5QSYJwihQOiT
	 NiIA84xpCYy+YO9k61+sr2AdTxmFGYxuORl+Iu/IUx5e4StKZxcE1QLHufSJDabShK
	 +Xt7kGNykwCyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: adapt ND match notif sizing to fixed matches array
Date: Mon, 31 Aug 2026 09:22:43 -0400
Message-ID: <20260831133314.4125787-135-sashal@kernel.org>
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

[ Upstream commit a426d3227c669ef0ad9855b311a68129f10ac8bf ]

Switch iwl_scan_offload_match_info::matches to a fixed-size array and
adjust D3 netdetect size handling accordingly.

In MVM D3 paths, compute expected payload size as
offsetof(struct iwl_scan_offload_match_info, matches) + matches_len to
preserve previous behavior after the struct layout change.

In MLD D3 netdetect handling, keep the simple full-notification size
assumption and validate against sizeof(*notif) before accessing data.

This keeps scan offload / netdetect functionality unchanged while
making length checks consistent with the new struct definition.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.4c4346140bcc.I44313ac41daca352e6aecdba09a1c3570c3eea06@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: iwlwifi]` `[adapt]` — adapt ND (netdetect) match-
notification sizing after changing
`iwl_scan_offload_match_info::matches` to a fixed-size array.

### Step 1.2: Tags
**Record:**
- **Assisted-by:** GitHubCopilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach \<emmanuel.grumbach@intel.com\>
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\>
- **Link:** https://patch.msgid.link/20260715215523.4c4346140bcc.I44313a
  c41daca352e6aecdba09a1c3570c3eea06@changeid

No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
stable tags. Absence of Cc: stable is expected per review instructions.

Notable: authored/signed by Intel iwlwifi maintainers; patch 15/15 in
the "wifi: iwlwifi: fixes - 07-15-2026" series (local mbox).

### Step 1.3: Body Analysis
**Record:**
- **Bug described:** After switching `matches[]` (flexible array) to
  `matches[IWL_SCAN_MAX_PROFILES_V2]` (fixed array), `sizeof(struct
  iwl_scan_offload_match_info)` changes from header-only (24 bytes) to
  header + 8 profile slots (144 bytes). Existing length checks that use
  `sizeof()` become wrong.
- **Symptom/failure mode:** Incorrect length validation can allow out-
  of-bounds reads when copying match data in D3/WoWLAN netdetect paths,
  or reject valid notifications if checks double-count match data.
- **Root cause:** Flexible-array `sizeof()` semantics vs. fixed-array
  `sizeof()` semantics; `iwl_mvm_netdetect_query_results()` only
  validated the header size while copying `matches_len` bytes.
- **Version info:** None in commit message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — disguised as a struct-layout adaptation, but it fixes
real out-of-bounds read conditions in WoWLAN netdetect handling. The MVM
query path and MLD notification path both validate too few bytes
relative to what `memcpy()` consumes.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/net/wireless/intel/iwlwifi/fw/api/scan.h` | Copyright year;
`matches[]` → `matches[IWL_SCAN_MAX_PROFILES_V2]` |
| `drivers/net/wireless/intel/iwlwifi/mvm/d3.c` | 3 hunks in
`iwl_mvm_netdetect_query_results()` and
`iwl_mvm_nd_match_info_handler()` |

**Functions modified:** `iwl_mvm_netdetect_query_results()`,
`iwl_mvm_nd_match_info_handler()`
**Scope:** Single-subsystem, surgical (~8 insertions, ~5 deletions
across 2 files).

### Step 2.2: Code Flow Changes

**Hunk 1 — `scan.h` struct:**
- **Before:** `matches[]` flex array; `sizeof(struct)` = 24 (header
  only).
- **After:** `matches[8]` fixed array; `sizeof(struct)` = 144 (header +
  8 × 15-byte entries).

**Hunk 2 — `iwl_mvm_netdetect_query_results()` V2 path:**
- **Before:** `query_len = sizeof(struct iwl_scan_offload_match_info)`
  (= 24); then `memcpy(..., matches_len)` where `matches_len` can be up
  to 120 bytes.
- **After:** `query_len = offsetof(..., matches) + matches_len` (= 24 +
  matches_len). Validation now covers data actually copied.

**Hunk 2 — V1 path:**
- **Before:** `query_len = sizeof(v1 struct)` (= 24 header only).
- **After:** `query_len = sizeof(v1 struct) + matches_len`.

**Hunk 3 — `iwl_mvm_nd_match_info_handler()`:**
- **Before:** `len < sizeof(struct) + matches_len` (= 24 + matches_len)
  — correct with flex array (already fixed by dd90880 in this tree).
- **After:** `len < offsetof(..., matches) + matches_len` (= 24 +
  matches_len) — equivalent numerically, but required to avoid breaking
  the check after the struct change (without it, `sizeof + matches_len`
  would be 144 + matches_len, wrongly rejecting valid notifications).

### Step 2.3: Bug Mechanism
**Record:** **Category:** Memory safety / out-of-bounds read.

**Specific mechanism:**
1. `iwl_mvm_netdetect_query_results()` accepted responses as short as 24
   bytes but copied up to `matches_len` bytes (up to 120 for V2, more
   for V1).
2. `iwl_mld_netdetect_match_info_handler()` (MLD, unchanged in diff)
   checks `len < sizeof(*notif)` (= 24 with flex array) then
   `memcpy(..., NETDETECT_QUERY_BUF_LEN)` (= 120 bytes). The struct
   change makes `sizeof(*notif)` = 144, aligning validation with the
   copy.
3. The `offsetof` change in `iwl_mvm_nd_match_info_handler()` prevents a
   regression from the struct layout change.

### Step 2.4: Fix Quality
**Record:** Fix is minimal and logically sound. Using `offsetof +
matches_len` is the standard pattern for variable-length trailing data
with a fixed-maximum struct. Regression risk is low: MVM paths preserve
prior effective thresholds; MLD gets stricter validation matching what
`memcpy` already required. No public API changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `matches[]` at `scan.h:1277` comes from merge
`5d324e5159d9e` (6.18-rc8 era). The flex-array layout and insufficient
query-path validation have been present since this code landed in the
6.18.y lineage.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no Fixes: tag in this commit.

Related prior fix in this tree: `dd90880eb5ec5` (stable backport of
upstream `744fabc338e87`) fixed the same class of OOB read in
`iwl_mvm_nd_match_info_handler()` only. It did **not** fix
`iwl_mvm_netdetect_query_results()` or MLD netdetect validation.

### Step 3.3: File History
**Record:** Recent iwlwifi D3 changes in this tree include `dd90880`
(nd_match_info_handler OOB) and `2d5dec5` (wake packet handler). This
commit is the logical follow-up for adjacent netdetect paths. It is
patch 15/15 in a series but only touches `scan.h` and `mvm/d3.c` — no
dependency on patches 1–14 for these hunks.

### Step 3.4: Author Context
**Record:** Emmanuel Grumbach is a long-standing Intel iwlwifi
maintainer (11 of 15 patches in the series). Miri Korenblit is the
series submitter. High subsystem credibility.

### Step 3.5: Prerequisites
**Record:** Self-contained. Verified with `git apply --check` — applies
cleanly to this tree (minor line offsets only). No prerequisite commits
required.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <commit>` unavailable (commit not yet in git).
Local mbox
`20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`
contains the patch. Lore/patch.msgid.link fetches blocked by bot
protection. Cover letter describes series as "bugfixes" with no per-
patch stable nominations.

### Step 4.2: Reviewers
**Record:** UNVERIFIED for patch 15 specifically — no Reviewed-by on
this individual patch. Series patch 2 has Reviewed-by: Johannes Berg.
Maintainers Grumbach/Korenblit are authors.

### Step 4.3: Bug Reports
**Record:** No Reported-by or syzbot link. Same bug class as SVACE-found
dd90880 (already in 6.18.y). Mechanism verified by code inspection.

### Step 4.4: Series Context
**Record:** Part of 15-patch iwlwifi validation-hardening series. This
patch is independently applicable; it does not require other series
patches.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore.kernel.org/stable search blocked. Related
fix dd90880 was explicitly Cc: stable and is already in this 6.18.y
tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `iwl_mvm_netdetect_query_results()`,
`iwl_mvm_nd_match_info_handler()`, and (indirectly via struct change)
`iwl_mld_netdetect_match_info_handler()`.

### Step 5.2: Callers
**Record:**
- `iwl_mvm_netdetect_query_results()` — called from D3 resume/WoWLAN
  netdetect reporting path (`d3.c:~2610`) when firmware uses query-based
  ND results.
- `iwl_mvm_nd_match_info_handler()` — called from D3 notification
  handler on `OFFLOAD_MATCH_INFO_NOTIF` (`d3.c:~2967`).
- `iwl_mld_netdetect_match_info_handler()` — called from MLD D3 resume
  notification dispatch (`mld/d3.c:~1322`).

All are WoWLAN suspend/resume (D3) paths on Intel wireless hardware.

### Step 5.3: Callees
**Record:** `iwl_mvm_send_cmd()`, `iwl_rx_packet_payload_len()`,
`memcpy()`, `le32_to_cpu()`, `IWL_ERR()`, `IWL_FW_CHECK()`.

### Step 5.4: Reachability
**Record:** Triggered during system suspend with WoWLAN netdetect
configured — common laptop use case. Requires
`CONFIG_IWLMVM`/`CONFIG_IWLMVM` module and compatible Intel firmware.
Reachable from normal userspace power-management (suspend), not a root-
only obscure ioctl.

### Step 5.5: Similar Patterns
**Record:** Same `sizeof(flex_array_struct) + trailing_data` under-
validation pattern that dd90880 fixed in
`iwl_mvm_nd_match_info_handler()`. The query path
(`iwl_mvm_netdetect_query_results`) was left unfixed. MLD path has the
identical pattern with `sizeof(*notif)`.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is `stable/linux-6.18.y` at v6.18.44
(`git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`). Confirmed:
- `matches[]` flex array at `scan.h:1277`
- `query_len = sizeof(struct iwl_scan_offload_match_info)` without
  `matches_len` at `mvm/d3.c:2473`
- MLD `len < sizeof(*notif)` (= 24) before 120-byte `memcpy` at
  `mld/d3.c:1134-1152`

### Step 6.2: Backport Complications
**Record:** Clean apply expected — `git apply --check` succeeded with
only line-offset adjustments. No conflicting refactors in these
functions on 6.18.y.

### Step 6.3: Related Fixes Already Present?
**Record:** `dd90880eb5ec5` fixed `iwl_mvm_nd_match_info_handler()`
length check (flex-array era). The query-path and MLD-path bugs remain
unfixed. This commit's `offsetof` change in `nd_match_info_handler`
preserves dd90880's effective threshold after the struct change.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **Subsystem:** `drivers/net/wireless/intel/iwlwifi` — WiFi
driver (IMPORTANT). Affects Intel laptop/desktop WiFi users using WoWLAN
netdetect.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent stable backports include dd90880
and wake-packet fixes in the same D3 code.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Intel iwlwifi (MVM and MLD) with WoWLAN network-
detection enabled during suspend. Config-dependent (`CONFIG_IWLWIFI`,
`CONFIG_IWLMVM`/`CONFIG_IWLMLO`), but affects a large installed base of
Intel WiFi laptops.

### Step 8.2: Trigger Conditions
**Record:** System suspend with netdetect profiles configured; firmware
returns a scan-offload match query response or notification shorter than
header + match data. Unprivileged users trigger suspend via normal power
management. If firmware always sends full payloads, the bug is latent;
if firmware sends truncated/malformed data, OOB read occurs.

### Step 8.3: Failure Mode Severity
**Record:** Out-of-bounds kernel read from firmware notification buffer
→ potential kernel oops, info leak, or corrupted netdetect results.
**Severity: HIGH** (memory safety in kernel, WoWLAN resume path).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — closes OOB reads in netdetect query and
  notification paths; aligns validation with actual `memcpy` sizes;
  complements dd90880 already in tree.
- **Risk:** LOW — ~13 lines, 2 files, no behavior change for correctly-
  sized firmware payloads; MLD gets stricter validation that matches
  existing `memcpy` requirements.
- **Ratio:** Strong benefit, low risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real out-of-bounds read in `iwl_mvm_netdetect_query_results()`
  (both V1 and V2 API branches) — only 24-byte header validated, up to
  120+ bytes copied.
- Fixes MLD netdetect under-validation via struct `sizeof` correction
  (24 → 144 bytes required before 120-byte `memcpy`).
- Same bug class as dd90880, already backported to this 6.18.y tree.
- WoWLAN/D3 suspend path — user-visible laptop functionality.
- Small, surgical, from Intel iwlwifi maintainers.
- Applies cleanly to this tree.
- No new features or APIs.

**AGAINST backport:**
- Struct layout change (flex → fixed array) is slightly broader than a
  one-line check fix, but necessary and internal to firmware API
  headers.
- No explicit Reported-by or Cc: stable (not a negative signal per
  instructions).
- Part of a 15-patch series (but this patch is standalone).

**Unresolved:** Lore discussion and stable-list history could not be
fetched (bot protection).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic verified by size
   arithmetic; Intel maintainer authorship.
2. Fixes a real bug affecting users? **PASS** — OOB read in WoWLAN
   netdetect paths.
3. Important issue? **PASS** — memory safety / potential crash on
   suspend resume.
4. Small and contained? **PASS** — 2 files, ~13 lines.
5. No new features or APIs? **PASS** — correctness/validation fix only.
6. Can apply to local tree? **PASS** — `git apply --check` succeeded.

### Step 9.3: Exception Categories
**Record:** Not applicable (not a device ID, quirk, DT, build, or docs-
only change). Qualifies as a memory-safety bug fix.

### Step 9.4: Problem Summary for Stable Users

This commit addresses insufficient payload-length validation in Intel
iwlwifi WoWLAN network-detection (netdetect) handling during D3
suspend/resume. The MVM query-results path validates only the 24-byte
notification header but then copies up to 120 bytes of match data; the
MLD path has the same under-validation. A short or malformed firmware
response can cause an out-of-bounds kernel read. The patch also changes
the firmware API struct from a flexible to a fixed-size matches array (8
entries, matching `IWL_SCAN_MAX_PROFILES_V2`) and adjusts MVM length
calculations with `offsetof()` so checks remain correct.

This is a natural companion to dd90880 (already in 6.18.y), which fixed
the same under-validation pattern in the MVM notification handler but
left the query path and MLD path unfixed.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
  and local mbox patch 15/15.
- [Phase 2] Diff analysis: 2 files, functions
  `iwl_mvm_netdetect_query_results` and `iwl_mvm_nd_match_info_handler`;
  computed sizes (header=24, profile_match=15, fixed struct=144,
  matches_len up to 120 for V2).
- [Phase 3] `git blame scan.h:1277` → merge 5d324e5159d9e; `git log`
  shows dd90880 already in tree for nd_match_info_handler; upstream
  744fabc338e87 present.
- [Phase 3] `git apply --check` on patch hunks → applies cleanly to
  6.18.44 tree.
- [Phase 4] Local mbox cover letter read; lore/patch.msgid.link blocked
  by bot protection — UNVERIFIED for list discussion.
- [Phase 4] `b4 dig -c` not usable (commit not in git history).
- [Phase 5] `grep` call chains: netdetect_query from d3.c:2610;
  nd_match_info_handler from d3.c:2967; mld handler from mld/d3.c:1322.
- [Phase 5] Read current `mvm/d3.c:2471-2492`, `mvm/d3.c:2838`,
  `mld/d3.c:1134-1152` — confirmed under-validation before memcpy.
- [Phase 6] `git describe HEAD` → v6.18.44 on `stable/linux-6.18.y`;
  buggy code confirmed present.
- [Phase 6] No duplicate fix for query path found in tree.
- [Phase 8] Failure mode: OOB read, severity HIGH; trigger: WoWLAN
  netdetect during suspend.

**YES**

 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c      | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 46fcc32608e34..b05948fbb2a37 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1274,7 +1274,7 @@ struct iwl_scan_offload_match_info {
 	u8 resume_while_scanning;
 	u8 self_recovery;
 	__le16 reserved;
-	struct iwl_scan_offload_profile_match matches[];
+	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES_V2];
 } __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_3 and
 	     * SCAN_OFFLOAD_MATCH_INFO_NOTIFICATION_S_VER_1
 	     */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 82dca6ba56c7f..58384d7e7cd35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2481,13 +2481,15 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 
 	if (fw_has_api(&mvm->fw->ucode_capa,
 		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
-		query_len = sizeof(struct iwl_scan_offload_match_info);
 		matches_len = sizeof(struct iwl_scan_offload_profile_match) *
 			max_profiles;
+		query_len = offsetof(struct iwl_scan_offload_match_info,
+				     matches) + matches_len;
 	} else {
-		query_len = sizeof(struct iwl_scan_offload_profiles_query_v1);
 		matches_len = sizeof(struct iwl_scan_offload_profile_match_v1) *
 			max_profiles;
+		query_len = sizeof(struct iwl_scan_offload_profiles_query_v1) +
+			matches_len;
 	}
 
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
@@ -2846,7 +2848,8 @@ static void iwl_mvm_nd_match_info_handler(struct iwl_mvm *mvm,
 	if (IS_ERR_OR_NULL(vif))
 		return;
 
-	if (len < sizeof(struct iwl_scan_offload_match_info) + matches_len) {
+	if (len < offsetof(struct iwl_scan_offload_match_info, matches) +
+		    matches_len) {
 		IWL_ERR(mvm, "Invalid scan match info notification\n");
 		return;
 	}
-- 
2.53.0

