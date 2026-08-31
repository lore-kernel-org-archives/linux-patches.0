Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E648473C66;
	Mon, 31 Aug 2026 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184267; cv=none; b=KbhrcjeOAh/GjlTns1uZ2ghXE4P8/zYFds73PzsXUEvlI+aCEPWOI5sNaPFdTD2E9u59eSKv1N9OwEhiAGPnnl7+KObOhYRE1zcopnfPqD3LO3blxTIx0glKsq8wjPqT6trsg+OE9Y40AemglaS5VwDIRD0LA6wOFDTEQRV953w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184267; c=relaxed/simple;
	bh=GbXKwCD488IDyKWs9NXSYumBNHDQ1fjLDQ7QcY66IJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ue5VXkXAUo35j9bK7hAtILZ5JrWQy7YzmQ6puCHTU5u2K15+lvfdk+UXup2TH8GiLoTc4bsJCQeOCZqqEaZnmgBoHIYl3xxDjAnk6zYAJmSLnXGmFuNm57ISlLROlLELajcZrrqB1Y66SOhg7F5f/rB3oM4vTt/6W17tdkFtDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kOkyBYiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kOkyBYiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341A31F00ADE;
	Mon, 31 Aug 2026 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184265;
	bh=VwejvtDxdJIHEGDbvCoGZfo+V3/4RcZvVrn5Yt5BNjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOkyBYiYAQAPb/DclFQLw8h84mZxXXvJEPnLng9NveLN69LGk25L3KM2TK25Yn9oa
	 YZrLlOWaKBIotJnp1oyuAkQW4MwumbKMzxUXoa+j+2cRPkXcCtBayBhbB4nJfJyvdP
	 DCRGsxqo+dtmmrLu9RSNGnRWY82S4KBPpWy5CHE2b0lUNgMJaK1QUq+whpB6n2toWX
	 jKsF0IzwrecBkrrILRHWv9Yp2UtXQpgxVQ+0bhSIbcBB5MKY2xaLYynB1vTxR6Yigd
	 Ey1pb8fuxmy/Udt9ydCrQWGUYaP+/Da821RsQ4G/zCiThbWhF4r2LFt85D0abmXCA9
	 R0IjAxX2q15cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mvm: verify scan id reported by firmware
Date: Mon, 31 Aug 2026 09:30:18 -0400
Message-ID: <20260831133314.4125787-590-sashal@kernel.org>
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

[ Upstream commit 1826215eb63b57a4ac8cb973785a84d703ff23f5 ]

The scan id reported by firmware in scan complete notification is
used as an index to the scan status array. Verify the reported id
does not exceed the array size.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Link: https://patch.msgid.link/20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: verify scan id reported
by firmware`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mvm]` `[verify]` — Validate firmware-
reported scan UID before using it as an array index in the UMAC scan-
complete notification handler.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Avraham Stern `<avraham.stern@intel.com>` (author)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (iwlwifi maintainer)
- **Link:** `https://patch.msgid.link/20260714141909.fdf31f494f1c.I70d01
  ed2023f6584fb23ea8ab344a93d222cc4c0@changeid`
- **Fixes:** `8d14ccd878e5` (present in lore submission; not in the
  user-provided message, but confirmed via lore fetch)
- **No** Reported-by, Tested-by, Cc: stable, or syzbot tags
- **Notable:** Part of `[PATCH iwlwifi-fixes 01/15]` series; **Reviewed-
  by: Ilan Peer** on lore submission

### Step 1.3: Body analysis
**Record:**
- **Bug:** Firmware-reported `uid` in `SCAN_COMPLETE_UMAC` notification
  is used directly as index into `mvm->scan_uid_status[]` without bounds
  checking.
- **Symptom:** Out-of-bounds array access if firmware reports `uid >=
  IWL_MAX_UMAC_SCANS` (4).
- **Root cause:** Missing validation of untrusted firmware input before
  array indexing.
- **Version info:** Fixes commit from May 2015; bug has been latent
  since UMAC scan UID indexing was introduced.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit defensive bounds-check fix, not
disguised cleanup. It prevents out-of-bounds memory access.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/scan.c` (+4
  functional lines, copyright year bump)
- **Function:** `iwl_mvm_rx_umac_scan_complete_notif()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `uid` from firmware notification used immediately in
  `IWL_DEBUG_SCAN` and `mvm->scan_uid_status[uid]` accesses with no
  bounds check.
- **After:** `IWL_FW_CHECK()` validates `uid <
  ARRAY_SIZE(mvm->scan_uid_status)` immediately after parsing `uid`;
  early return on failure, before any array access.
- **Path affected:** Firmware RX notification handler
  (`SCAN_COMPLETE_UMAC`), normal scan-completion path.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds access (memory safety)
- **Mechanism:** `scan_uid_status` is `u32
  scan_uid_status[IWL_MAX_UMAC_SCANS]` where `IWL_MAX_UMAC_SCANS` is 4.
  Invalid `uid` from firmware causes OOB read (and potential write at
  line 3278) into adjacent `struct iwl_mvm` fields. Current code at line
  3239 always evaluates `mvm->scan_uid_status[uid]` inside `WARN_ON()`.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — matches established pattern in `mld/scan.c`
  (`iwl_mld_handle_scan_complete_notif()` already has identical check at
  lines 1938–1940).
- **Risk:** Very low — adds early-return guard only; no behavior change
  for valid UIDs.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Current function body dates to merge `5d324e5159d9e` in this
tree. **Fixes: `8d14ccd878e5`** ("iwlwifi: mvm: make UMAC scans use the
stopping scan status", May 7, 2015) introduced `scan_uid_status[uid]`
indexing in `iwl_mvm_rx_umac_scan_complete_notif()` without bounds
check. Bug present since ~v4.1 era; certainly present in 6.18.44.

### Step 3.2: Fixes tag
**Record:** **Fixes: `8d14ccd878e5`** confirmed in lore submission.
Commit exists in this tree at `drivers/net/wireless/iwlwifi/mvm/scan.c`
(path moved from `drivers/net/wireless/iwlwifi/`). Original handler
already used `scan_uid_status[uid]` without validation.

### Step 3.3: Related file history
**Record:** Recent iwlwifi stable backports in this tree include similar
validation fixes:
- `dd90880eb5ec5` — OOB read in `iwl_mvm_nd_match_info_handler()` (Cc:
  stable in upstream)
- `2d5dec517b539` — validate payload before read in wake-packet handler
- `a076b0c457c71` — validate SAR GEO response payload size

This fix is standalone (01/15 in series, but self-contained).

### Step 3.4: Author context
**Record:** Avraham Stern (Intel iwlwifi developer). Miri Korenblit
(maintainer) signed off. Ilan Peer (Intel) reviewed on lore. Consistent
with ongoing iwlwifi firmware-validation hardening.

### Step 3.5: Dependencies
**Record:** No dependencies. `IWL_FW_CHECK` macro available via `mvm.h`
→ `fw/dbg.h`. `ARRAY_SIZE` and `scan_uid_status` array already exist.
Patch applies cleanly to current `scan.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Lore thread fetched via curl from
`https://lore.kernel.org/linux-wireless/20260714141909.fdf31f494f1c.I70d
01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid/t.mbox.gz`. Subject:
`[PATCH iwlwifi-fixes 01/15] wifi: iwlwifi: mvm: verify scan id reported
by firmware`. `b4 dig -c` failed (commit not in local git); lore mbox
fetch succeeded.

### Step 4.2: Reviewers
**Record:** CC'd to `johannes@sipsolutions.net`, `linux-
wireless@vger.kernel.org`, Avraham Stern. **Reviewed-by: Ilan Peer** on
submission. No NAKs found in thread headers.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Proactive hardening
against invalid firmware input, consistent with iwlwifi-fixes series
theme.

### Step 4.4: Series context
**Record:** Part of 15-patch iwlwifi-fixes series (Jul 14, 2026) focused
on firmware notification validation. This patch is independent; other
patches address separate handlers.

### Step 4.5: Stable list
**Record:** No explicit `Cc: stable` on this patch (unlike
`dd90880eb5ec5`). Absence is not a negative signal per instructions. No
stable-list discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mvm_rx_umac_scan_complete_notif()` — only function
modified.

### Step 5.2: Callers
**Record:** Registered in `drivers/net/wireless/intel/iwlwifi/mvm/ops.c`
line 372:
```372:374:drivers/net/wireless/intel/iwlwifi/mvm/ops.c
        RX_HANDLER(SCAN_COMPLETE_UMAC,
iwl_mvm_rx_umac_scan_complete_notif,
                   RX_HANDLER_ASYNC_LOCKED,
                   struct iwl_umac_scan_complete),
```
Called from iwlwifi firmware RX path when firmware completes a UMAC scan
— common during WiFi scanning.

### Step 5.3: Callees
**Record:** Uses `IWL_FW_CHECK`, `IWL_DEBUG_SCAN`,
`ieee80211_scan_completed()`, `ieee80211_sched_scan_stopped()`,
`cancel_delayed_work()`. Fix only adds validation before existing logic.

### Step 5.4: Reachability
**Record:** Triggered by Intel WiFi firmware notifications during
active/scheduled scans. Reachable on any system with `CONFIG_IWLWIFI` +
MVM driver during normal WiFi operation (scanning is routine). Not
userspace-triggerable directly, but firmware bugs during scanning are
realistic.

### Step 5.5: Similar patterns
**Record:** MLD driver already validates identically:
```1938:1940:drivers/net/wireless/intel/iwlwifi/mld/scan.c
        if (IWL_FW_CHECK(mld, uid >= ARRAY_SIZE(mld->scan.uid_status),
                         "FW reports out-of-range scan UID %d\n", uid))
                return;
```
MVM driver was missing the same guard — clear oversight now corrected.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES.** In 6.18.44, `iwl_mvm_rx_umac_scan_complete_notif()`
at lines 3214–3278 uses `uid` as index without bounds check. Fix is
**not yet applied**.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Target function and `IWL_FW_CHECK`
macro both present. No structural conflicts. Insertion point is
unambiguous (after `mei_scan_filter` reset, before first
`scan_uid_status[uid]` use).

### Step 6.3: Related fixes already present?
**Record:** No equivalent bounds check for scan UID in MVM driver (`git
log --grep` found nothing). MLD driver has the check. Similar OOB
validation fixes (`dd90880eb5ec5`, `2d5dec517b539`) are already in this
tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/net/wireless/intel/iwlwifi/mvm/`
Intel WiFi driver used widely on laptops, desktops, and servers. Not
core kernel, but affects a very large installed base.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple iwlwifi fixes backported to
6.18.y in recent history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel WiFi (`CONFIG_IWLWIFI`, MVM firmware)
performing scans. Large population on x86 laptops and many servers.

### Step 8.2: Trigger conditions
**Record:** Firmware sends `SCAN_COMPLETE_UMAC` with `uid >= 4`.
Unlikely in normal operation but possible with firmware bugs or
corruption. Scanning is routine (roaming, network discovery, scheduled
scans).

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds read/write on kernel heap within `struct
iwl_mvm`. Can cause kernel oops, memory corruption, or unpredictable
behavior. **Severity: HIGH** (potential crash/corruption). Not a
security CVE per se, but memory safety issue in kernel context.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents OOB access on common WiFi scan path; bug
  latent since 2015
- **Risk:** VERY LOW — 4-line bounds check, proven pattern in same
  subsystem
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real out-of-bounds array access bug in production RX handler
- Bug present since 2015 (`Fixes: 8d14ccd878e5`), confirmed in 6.18.44
- Small (4 lines), obviously correct, matches MLD driver pattern
- Same class of fix already backported to this tree (`dd90880eb5ec5`,
  `2d5dec517b539`)
- Reviewed by Intel iwlwifi developer; maintainer sign-off
- iwlwifi widely deployed; scan completion is routine

**AGAINST backport:**
- Requires firmware to report invalid UID (not a typical userspace bug)
- No syzbot report or user crash report attached
- Part of larger hardening series (but this patch is self-contained)

**Unresolved:** Whether any specific firmware version actually triggers
bad UIDs (unverified; defensive fix is still warranted).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard `IWL_FW_CHECK`
   pattern; reviewed on lore
2. Fixes a real bug? **PASS** — OOB array index from firmware input
3. Important issue? **PASS** — memory safety / potential kernel crash
   (HIGH)
4. Small and contained? **PASS** — 4 lines, one function
5. No new features or APIs? **PASS** — defensive validation only
6. Can apply to local tree? **PASS** — buggy code present, fix not yet
   applied, clean apply

### Step 9.3: Exception categories
**Record:** Not a device ID/quirk/DT/docs/build fix. Standard bug fix.

### Step 9.4: Decision rationale
For **6.18.44**, the vulnerable code exists and the fix is absent. The
patch adds a minimal, proven bounds check before indexing
`scan_uid_status[uid]`, mirroring what the MLD driver already does and
following the same validation pattern as other iwlwifi fixes already in
this stable tree. The failure mode (OOB access in a firmware
notification handler during WiFi scanning) is serious enough to warrant
backport despite the trigger requiring a firmware bug.

---

## Verification

- [Phase 1] `make kernelversion`: 6.18.44; `git describe HEAD`:
  v6.18.44-1-g2736c32da98b9
- [Phase 1] Parsed tags from user message and lore mbox fetch
- [Phase 2] Read `scan.c` lines 3214–3278: confirmed no bounds check on
  `uid`
- [Phase 2] `grep IWL_MAX_UMAC_SCANS`: value is 4 in `fw/api/scan.h`
- [Phase 2] Read `fw/dbg.h` lines 334–342: confirmed `IWL_FW_CHECK`
  macro behavior (log + return true on failure)
- [Phase 3] `git show 8d14ccd878e5`: Fixes commit exists (May 2015);
  original handler used `scan_uid_status[uid]` without check
- [Phase 3] `git blame -L 3214,3250 scan.c`: function present in current
  tree
- [Phase 3] `git log --oneline -20 drivers/net/wireless/intel/iwlwifi/`:
  found similar backported fixes
- [Phase 4] `b4 dig -c` on message-id: failed (commit not in tree)
- [Phase 4] curl lore mbox.gz: found patch, Fixes tag, Reviewed-by: Ilan
  Peer, series 01/15
- [Phase 4] WebFetch lore search page: blocked by bot protection; used
  curl instead
- [Phase 5] `grep iwl_mvm_rx_umac_scan_complete_notif`: caller in
  `mvm/ops.c` line 372
- [Phase 5] Read `mld/scan.c` lines 1938–1940: identical check already
  present in MLD
- [Phase 6] Confirmed fix NOT in tree: `grep "out-of-range scan UID"
  mvm/` returns no matches
- [Phase 6] Confirmed `IWL_FW_CHECK` available: `mvm.h` includes
  `fw/dbg.h`
- [Phase 8] `git show dd90880eb5ec5`: confirmed similar OOB fix
  backported with Cc: stable upstream

**YES**The background git history search finished successfully. It found
that `iwl_mvm_rx_umac_scan_complete_notif` and the `SCAN_COMPLETE_UMAC`
handler registration both trace to merge commit `5d324e5159d9e` in this
6.18.44 tree — consistent with the earlier finding that the vulnerable
code is present here and the bounds-check fix is still missing.

That supports the prior conclusion: this is a small, valid firmware-
input validation fix worth backporting to this tree.

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index b588f1dcf20d5..7bf8236cea6d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -3221,6 +3221,10 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 
 	mvm->mei_scan_filter.is_mei_limited_scan = false;
 
+	if (IWL_FW_CHECK(mvm, uid >= ARRAY_SIZE(mvm->scan_uid_status),
+			 "FW reports out-of-range scan UID %d\n", uid))
+		return;
+
 	IWL_DEBUG_SCAN(mvm,
 		       "Scan completed: uid=%u type=%u, status=%s, EBS=%s\n",
 		       uid, mvm->scan_uid_status[uid],
-- 
2.53.0

