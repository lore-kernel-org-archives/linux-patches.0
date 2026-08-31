Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE14248B1;
	Mon, 31 Aug 2026 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183295; cv=none; b=hLssnxL7Eb/eCxHn1zGY/g39Uq5M6bIiOKXbWmLyqJG02QK7hVsCQRHZE5KcC4VmnJqTgLd2DkTjRL0g7tY5nkQrDnJQq8w2VYNtYFbgV2BGlgtGfUTtGcnl9eRZGNRKt58W/4K5votYU2MRWAZT+5vaulvFPGUZmyyEtnNMR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183295; c=relaxed/simple;
	bh=EqhjHYSX9krNTVwQTujEXEZPc1B+0co7dIpYNHV4XZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tq0JkuE8hlISrwsFiIrPIvs1qAp4uRMbOr3vhu68zXoJMZ2ColkN6/rmN355rjEX9P6ilxc7OUWwWFkylbNzG0WutwAsS88yUBFkoTk73+F9YlDBQ4N+Se5+5M0j6aUK4s5aHWmMVJFNzsNI/HLdnr1XHnNFJ7BpQrpptv5cdrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqbP8Va5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqbP8Va5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1541F00A3D;
	Mon, 31 Aug 2026 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183293;
	bh=f/BHtKG1ILdDWYf2I6M1OK8mDbPdlT+zrWqUYqJqrJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqbP8Va59gSekH3WaF0YSvssm1ssBxTDmg/u0OCvacTCYcdIAp/ToixefhUuistKR
	 fF1GFqXyW/99Q/iYkwBk0ZwW+zpoj2v9cnAd/OaGPkliXRX0n/Jf8CU1ySmNqudb9b
	 BnMQ1cbFsmgrqoCL973T9CMlsvcYSA3jMaMvuxuUGsQNF8xPDL5qJLUOW9Dj73ocDu
	 zc6LZkzcNnVYzNh9x2/t8VOAGMACrc8m/UnwyxQmAndyZST6vo6tpRD5s76GkWbolu
	 Nca8TANZXxLk57v0yokH6Ck/FQ+OHv13gDnGW1RLca9jfYcyhM5DFl/5P/gyTcRF9A
	 mv9ISyWcXWmPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] wifi: iwlwifi: mvm: fix sched scan IE sizing
Date: Mon, 31 Aug 2026 09:21:30 -0400
Message-ID: <20260831133314.4125787-62-sashal@kernel.org>
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

[ Upstream commit 4f155d262b31b9b17e0f9856bdabe0968eb4930f ]

Scheduled scan built the probe request before iwl_mvm_scan_fits(),
so oversized IEs could be copied into the fixed preq buffer before
length validation. Move iwl_mvm_build_scan_probe() after the fits
check.

Also advertise max_sched_scan_ie_len using iwl_mvm_max_scan_ie_len()
so userspace limits account for driver-inserted DS/TPC bytes.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260714141909.53d2722c79e7.Iebb922efa6173c92f14cd8aa8b4e7f372c0a0fb7@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: fix sched scan IE
sizing`

**Local tree:** `v6.18.44` (Makefile: 6.18.44). The buggy code is
present; this fix is not yet applied.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mvm]` `[fix]` — correct scheduled-scan
probe-request IE sizing/ordering.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260714141909.53d2722c79e7.Iebb92
  2efa6173c92f14cd8aa8b4e7f372c0a0fb7@changeid`
- **Reviewed-by:** Ilan Peer \<ilan.peer@intel.com\>
- **Assisted-by:** GitHubCopilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach \<emmanuel.grumbach@intel.com\>
  (author)
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\> (maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: Intel iwlwifi maintainer/reviewer sign-offs; no external bug
  report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `iwl_mvm_build_scan_probe()` ran before
  `iwl_mvm_scan_fits()`, so oversized IEs were `memcpy()`’d into the
  fixed 512-byte `preq.buf` before length validation.
- **Symptom:** Stack buffer overflow in `iwl_mvm_sched_scan_start()`;
  userspace could also be misled by an inflated `max_sched_scan_ie_len`.
- **Root cause:** Wrong ordering vs. the regular-scan path;
  `max_sched_scan_ie_len` used `SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2`
  instead of `iwl_mvm_max_scan_ie_len()` (which accounts for driver-
  inserted DS/TPC bytes).
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly a bug fix (buffer overflow + incorrect wiphy
limit advertisement).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `drivers/net/wireless/intel/iwlwifi/mvm/scan.c`: reorder one call (~2
  net lines)
- `drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c`: change
  `max_sched_scan_ie_len` assignment (~3 net lines)
- **Functions:** `iwl_mvm_sched_scan_start()`,
  `iwl_mvm_mac_setup_register()`
- **Scope:** Two-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`scan.c`):** Before: build probe → filter 6 GHz PSC channels
  → `iwl_mvm_scan_fits()` → send. After: filter channels →
  `iwl_mvm_scan_fits()` → build probe → send. Validation now precedes
  all `memcpy()` into `preq.buf`.
- **Hunk 2 (`mac80211.c`):** Before: `max_sched_scan_ie_len = 486`.
  After: `max_sched_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm)` (477 or
  474 depending on DS support), matching `max_scan_ie_len` and
  `iwl_mvm_scan_fits()`.

### Step 2.3: Bug mechanism
**Record:** **Buffer overflow / out-of-bounds write (memory safety).**
- `params.preq` is `struct iwl_scan_probe_req` with `u8 buf[512]` on the
  stack inside `iwl_mvm_sched_scan_start()`.
- `iwl_mvm_build_scan_probe()` copies band/common IEs via unchecked
  `memcpy()` and may add DS (+3) and TPC (+9) bytes.
- `iwl_mvm_scan_fits()` caps total IE length at
  `iwl_mvm_max_scan_ie_fw_cmd_room()` (474–477), but ran too late.
- Advertised `max_sched_scan_ie_len` was 486, so cfg80211 could accept
  IEs 9 bytes larger than the driver’s internal limit.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors the regular-scan path
(`iwl_mvm_scan_fits()` at line 2996 before `iwl_mvm_build_scan_probe()`
at line 3033). Minimal diff, no API changes. Regression risk: very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Shallow clone (`git rev-parse --is-shallow-repository` →
`true`); blame points all relevant `iwl_mvm_sched_scan_start()` lines to
merge base `5d324e5159d9e` (v6.18-rc8 era). Buggy ordering is present in
this 6.18.44 tree; cannot pinpoint original introduction commit from
local history.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in the commit message.

### Step 3.3: Related file history
**Record:** Shallow history limits `git log` on these files to the merge
commit only. Related iwlwifi scan fixes (`iwl_mvm_scan_fits()` 6 GHz
accounting, `iwl_mvm_max_scan_ie_fw_cmd_room()` WFA TPC) were previously
backported to older stable trees (e.g. 4.19, 5.15, 6.6, 6.10 per web
search). This commit completes that work for the sched-scan build-order
and wiphy-advertisement gaps.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach and Miri Korenblit are iwlwifi
maintainers. Ilan Peer (Reviewed-by) is a regular Intel iwlwifi
reviewer.

### Step 3.5: Dependencies
**Record:** Standalone. Requires only existing symbols:
`iwl_mvm_build_scan_probe()`, `iwl_mvm_scan_fits()`,
`iwl_mvm_max_scan_ie_len()` — all present in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <hash>` unavailable — commit not in local repo.
Lore/patch.msgid.link blocked by Anubis bot protection. Web search found
related iwlwifi scan-sizing threads but not this exact July 2026 patch
thread.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via `b4 dig -w` (no local commit hash). Commit
message lists Reviewed-by: Ilan Peer and maintainer SOB from Miri
Korenblit.

### Step 4.3: Bug report
**Record:** No Reported-by or syzbot link. Bug identified by code
inspection (build-before-validate ordering).

### Step 4.4: Related patches/series
**Record:** Part of ongoing iwlwifi scan IE sizing hardening;
complements already-stable commits fixing `iwl_mvm_scan_fits()` and
`iwl_mvm_max_scan_ie_fw_cmd_room()`. Standalone — no “patch X/Y”
dependency.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore stable search blocked. Prior related
iwlwifi scan fixes were autosel’d to stable (evidence from lkml autosel
posts).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mvm_sched_scan_start()`, `iwl_mvm_build_scan_probe()`,
`iwl_mvm_scan_fits()`, `iwl_mvm_max_scan_ie_len()`,
`iwl_mvm_mac_setup_register()`.

### Step 5.2: Callers
**Record:**
- `iwl_mvm_sched_scan_start()` ← `iwl_mvm_mac_sched_scan_start()`
  (mac80211 `sched_scan_start` op, nl80211 path) and
  `iwl_mvm_d3_configure()` in `d3.c` (net-detect scheduled scan).
- Reachable whenever userspace starts scheduled scan on Intel iwlwifi
  hardware.

### Step 5.3: Callees
**Record:** `iwl_mvm_build_scan_probe()` uses `memcpy()`,
`iwl_mvm_copy_and_insert_ds_elem()` (+3 bytes),
`iwl_mvm_add_tpc_report_ie()` (+9 bytes). `iwl_mvm_scan_fits()` compares
IE totals against `iwl_mvm_max_scan_ie_fw_cmd_room()`.

### Step 5.4: Reachability
**Record:** Triggered via `NL80211_CMD_START_SCHED_SCAN` → cfg80211 →
`iwl_mvm_mac_sched_scan_start()`. Requires `CAP_NET_ADMIN` for nl80211
scan operations. Common path: wpa_supplicant / NetworkManager scheduled
scanning on laptops with Intel WiFi.

### Step 5.5: Similar patterns
**Record:** Regular scan in the same file validates first (line 2996),
then builds (line 3033). Sched scan had the inverted order (build at
3151, validate at 3181). `max_scan_ie_len` already uses
`iwl_mvm_max_scan_ie_len()` at line 585; only `max_sched_scan_ie_len`
was inconsistent.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree has:
- `iwl_mvm_build_scan_probe()` before `iwl_mvm_scan_fits()` in
  `iwl_mvm_sched_scan_start()` (lines 3151 vs 3181).
- `max_sched_scan_ie_len = SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2` (486
  bytes) in `mac80211.c` line 629–630.

### Step 6.2: Backport complications
**Record:** Expected **clean apply** — current lines match the patch’s
“before” state exactly. No structural refactor blocking the change.

### Step 6.3: Related fixes already present?
**Record:** `iwl_mvm_scan_fits()` already includes 6 GHz IE length (line
841–842). `iwl_mvm_max_scan_ie_fw_cmd_room()` already subtracts WFA TPC
(line 310). Those prerequisite fixes are in-tree; this commit addresses
the remaining sched-scan-specific gaps.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/net/wireless/intel/iwlwifi` (Intel
WiFi, widely deployed on laptops/desktops).

### Step 7.2: Activity
**Record:** Actively maintained; recent iwlwifi update series in repo
mbox files (May–July 2026).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Intel iwlwifi (mvm) with scheduled scanning enabled
— typical laptop WiFi roaming/background scan scenarios.

### Step 8.2: Trigger conditions
**Record:** Starting scheduled scan with probe IEs near the advertised
`max_sched_scan_ie_len` (up to 486 bytes). With the buggy wiphy limit,
cfg80211 accepts IEs up to 486 (`nl80211.c` line 10807) while the driver
buffer only safely holds ~474–477 bytes of IE payload plus overhead.
**Likelihood:** moderate for scan-heavy configs; not every boot, but
realistic for wpa_supplicant with vendor IEs.

### Step 8.3: Failure mode severity
**Record:** **HIGH** — stack buffer overflow in kernel context (`params`
on stack in `iwl_mvm_sched_scan_start()`). Can cause oops/panic or
memory corruption. Not theoretical: 9-byte wiphy/driver mismatch plus
build-before-validate makes overflow reachable with legally accepted IE
sizes.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents kernel memory corruption on a common
  driver.
- **Risk:** LOW — 4-line reorder + consistent limit assignment.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real stack buffer overflow in `iwl_mvm_sched_scan_start()`
- Incorrect wiphy limit lets userspace submit oversize IEs
- Small, surgical, maintainer-reviewed fix
- Buggy code confirmed in v6.18.44 tree
- Same subsystem had related scan-sizing fixes backported to older
  stables
- Regular-scan path already does validation-first; fix aligns sched scan

**AGAINST backport:**
- Requires `CAP_NET_ADMIN` (not arbitrary unprivileged syscall)
- No syzbot/user crash report attached
- Lore review thread not accessible for stable nomination confirmation

**Unresolved:**
- Original mailing-list thread and any explicit “Cc: stable” discussion
  (Anubis blocked)
- Exact upstream commit hash (not in shallow local repo)

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic mirrors working
regular-scan path; Reviewed-by present |
| 2. Fixes a real bug? | **PASS** — buffer overflow + wrong wiphy limit
|
| 3. Important issue? | **PASS** — kernel memory corruption / crash
(HIGH) |
| 4. Small and contained? | **PASS** — ~4 effective lines, 2 files |
| 5. No new features/APIs? | **PASS** — behavior correction only |
| 6. Applies to local tree? | **PASS** — buggy code present, clean apply
expected |

### Step 9.3: Exception category
**Record:** N/A — standard bug fix, not device-ID/quirk/docs/build
exception.

### Step 9.4: Decision rationale
This fix closes a genuine memory-safety hole in Intel iwlwifi scheduled
scanning on the v6.18.44 tree. Userspace can legally submit probe IEs
larger than the driver’s fixed 512-byte buffer can hold, and the driver
copies them before validating. The patch is minimal, obviously correct,
and follows the same pattern already used for regular scans. The
CAP_NET_ADMIN requirement reduces but does not eliminate stable
relevance — memory corruption from a privileged scan request is still a
serious kernel bug.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message.
- **[Phase 2]** Read `scan.c` lines 303–334, 751–819, 834–844,
  2996–3033, 3147–3211; `mac80211.c` lines 585–630, 4217–4229;
  `fw/api/scan.h` line 55 (`SCAN_OFFLOAD_PROBE_REQ_SIZE = 512`).
- **[Phase 2]** Confirmed `struct iwl_mvm_scan_params` embeds `struct
  iwl_scan_probe_req preq` (scan.c:97).
- **[Phase 2]** Calculated size mismatch: buggy `max_sched_scan_ie_len`
  = 486 vs `iwl_mvm_max_scan_ie_fw_cmd_room` = 477 (474 with DS).
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git rev-parse --is-
  shallow-repository` → true.
- **[Phase 3]** `git blame -L 3147,3185 scan.c` → buggy order at 3151
  before 3181.
- **[Phase 3]** Web search: related iwlwifi scan fixes autosel’d to
  4.19/5.15/6.6/6.10.
- **[Phase 4]** `b4 dig` — cannot run without local commit hash; syntax
  verified via `b4 dig -h`.
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link — blocked
  by Anubis.
- **[Phase 5]** `grep iwl_mvm_sched_scan_start` → callers in
  `mac80211.c:4229`, `d3.c:1205`.
- **[Phase 5]** `grep max_sched_scan_ie_len` in `nl80211.c` → validation
  at 10807, advertisement at 2698.
- **[Phase 6]** Confirmed buggy code present; fix not applied in current
  tree.
- **[Phase 6]** Confirmed prerequisites (`iwl_mvm_scan_fits` 6 GHz, WFA
  TPC in `max_scan_ie_fw_cmd_room`) already in tree.
- **UNVERIFIED:** Original lore thread content and explicit stable
  nomination.
- **UNVERIFIED:** Upstream commit SHA (commit not in shallow repo).
- **UNVERIFIED:** `git apply --check` (heredoc formatting error; manual
  line comparison confirms match).

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 +---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 83fb3f9af4745..a0bf9815aef6b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -625,9 +625,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->wiphy->max_sched_scan_reqs = 1;
 	hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
 	hw->wiphy->max_match_sets = iwl_umac_scan_get_max_profiles(mvm->fw);
-	/* we create the 802.11 header and zero length SSID IE. */
-	hw->wiphy->max_sched_scan_ie_len =
-		SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
+	hw->wiphy->max_sched_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm);
 	hw->wiphy->max_sched_scan_plans = IWL_MAX_SCHED_SCAN_PLANS;
 	hw->wiphy->max_sched_scan_plan_interval = U16_MAX;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 7bf8236cea6d4..7f5fb93cffff8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3148,8 +3148,6 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
-
 	/* for 6 GHZ band only PSC channels need to be added */
 	for (i = 0; i < params.n_channels; i++) {
 		struct ieee80211_channel *channel = params.channels[i];
@@ -3183,6 +3181,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		goto out;
 	}
 
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
+
 	uid = iwl_mvm_build_scan_cmd(mvm, vif, &hcmd, &params, type);
 	if (uid < 0) {
 		ret = uid;
-- 
2.53.0

