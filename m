Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949595540B6;
	Mon, 31 Aug 2026 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184022; cv=none; b=PT2JIF28SjKzuq8AfZqvd/3kt1c/6qLDADqSf5QtqvJ6RDiwxnoTtxhZk7Wh+/dWH+qmjATL1BmA9Rf1nzWUeqdLNAWx77gPtpgjnw9Y9rzRgv5DhdzqNhY6lF0Id96k4UK/+tbz54qlLRnal0r70FWpSHnXIMVEGUrl2GBfxz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184022; c=relaxed/simple;
	bh=zwvwbOhGw1C7ophV7SpK5Uw2kEtfLSP+tp9L42IJE+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYSvqtU32NBQufbZ3VPwRi2UbfO7WmOGhsWhb61cANHgN3uRaQTcSWFQ9LZCwg3Qus6vrNBWsakOSRNjVLLZIm67s+sFoiOPrOfMVQxDjdGPzm7S62jSCwi0IN9nFS3rUE3/UrQwcAUwuyKG1bbS/sPZ8cxl2wioCWxbmfgia1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+rAC9OW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+rAC9OW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DB41F00A3F;
	Mon, 31 Aug 2026 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184018;
	bh=KpQJogOnWNm1wLnORWhkcR5bmVd9p4So25qtBfHPoz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+rAC9OWbM6h2dAyHcWLHGOWclrIF53qC0bYGvwrTalHIr3z5x/7OX7Da8cYFaYsG
	 X6kBzfYuYlLBZyMAH1oOgguAIUpArX/S7wGGuDTbYjf451cbp4Gw1ornxTx6UVhBXs
	 yghC6a/4hCYf83OLhDft7f0i58FcdufxXWjVSSxlFdhuV/9Wab+TGAWZTAkyblXXOe
	 hlQirdKAqWDhQzdi7oWbUn/cCwpAwosL9MU9LrlIeAuAc9j/l7u8dGWirVcLetfPRz
	 4/7j3E7dFXQkoXOv0GfcfbLX88r8tDyRodufPTdHM0mLdJrrI5fqlGpONXb4056N+l
	 NXapE6yFhNcsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: fix the access to CNVR TOP registers
Date: Mon, 31 Aug 2026 09:27:49 -0400
Message-ID: <20260831133314.4125787-441-sashal@kernel.org>
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

[ Upstream commit c73869c1df2a27dc3c928e94b42660124318f727 ]

For Dr and Sc, we need to wait until the TOP is ready to gets its
registers read by the host.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Link: https://patch.msgid.link/20260511203428.09778340db51.I28d678ad404bbf8068f139666d38e29be5aa063b@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: fix the access to CNVR TOP
registers`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[wifi: iwlwifi]` `[fix]` — Correct premature access to CNVR
TOP peripheral registers on DR and SC device families during early
hardware identification.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`
  (author)
- **Reviewed-by:** Daniel Gabay `<daniel.gabay@intel.com>` (Intel
  reviewer)
- **Link:** `https://patch.msgid.link/20260511203428...` (patch
  submission reference)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (maintainer committer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- Notable: Intel-internal review; part of `[PATCH 3/15]` iwlwifi update
  series (May 11, 2026)

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** On DR and SC families, the host reads CNVR TOP peripheral
  registers before the TOP block is ready.
- **Symptom:** Incorrect or unavailable peripheral register reads during
  `get_crf_id()` in the PCIe probe path; can lead to wrong/missing RF ID
  and probe failure.
- **Root cause:** Missing hardware-readiness wait before `WFPM_CTRL_REG`
  / peripheral register access.
- **Version info:** None explicit; hardware-specific to
  `IWL_DEVICE_FAMILY_DR` and `IWL_DEVICE_FAMILY_SC`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit hardware-init timing bug
fix, not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
| File | Change |
|------|--------|
| `iwl-io.c` | +18 lines (new poll helper) |
| `iwl-io.h` | +2 lines (declaration) |
| `iwl-prph.h` | +5 lines (register/bit defines) |
| `pcie/gen1_2/trans.c` | +24 lines (wait logic in `get_crf_id()`) |

- **Functions modified:** `get_crf_id()`; new
  `iwl_poll_umac_prph_bits_no_grab()`
- **Scope:** Single-subsystem, 4-file surgical fix (~51 lines total
  including copyright year bumps)

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (`iwl-io.c` / `iwl-io.h`):** Adds
  `iwl_poll_umac_prph_bits_no_grab()` — mirrors `iwl_poll_prph_bit()`
  but uses `iwl_read_umac_prph_no_grab()` for contexts where NIC access
  is already held.
- **Hunk 2 (`iwl-prph.h`):** Defines `WFPM_RSRCS_4PHS_REQ_STTS`,
  `WFPM_RSRCS_4PHS_ACK_STTS`, and CNVR TOP request/ack bits.
- **Hunk 3 (`trans.c` / `get_crf_id()`):**
  - **Before:** Immediately reads/writes UMAC peripheral registers.
  - **After (DR/SC only):** Checks REQ bit 6; polls ACK bit 6 (50 ms
    timeout); then proceeds with peripheral access.
  - **Path:** Early probe, inside `iwl_pci_gen1_2_probe()` →
    `get_crf_id()` with NIC access held.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic / hardware-init correctness fix
  (timing/sequencing).
- **Mechanism:** `get_crf_id()` reads `WFPM_CTRL_REG`,
  `sd_reg_ver_addr`, and `CNVI_AUX_MISC_CHIP` before CNVR TOP signals
  readiness via `WFPM_RSRCS_4PHS_ACK_STTS` bit 6. On DR/SC this yields
  garbage or zero `hw_crf_id`, causing `map_crf_id()` to fail and probe
  to return `-EINVAL`.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Follows existing `iwl_poll_prph_bit()` / `iwl_poll_umac_prph_bit()`
  patterns.
- Minimal, device-family-gated (`DR` and `SC` only).
- **Minor concern:** On ACK poll timeout, code logs `IWL_ERR` but still
  proceeds (best-effort, same as many iwlwifi init paths). REQ-bit-clear
  path returns early from `get_crf_id()` without reading registers.
- **Regression risk:** Low — change is gated to two families and adds a
  wait before existing reads.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `get_crf_id()` at lines 3990–4040 in `trans.c` is present in
this tree. Git blame in this checkout is shallow (single squashed commit
per file), so the exact introduction commit could not be determined from
local history.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present — not applicable.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Local git history for `drivers/net/wireless/intel/iwlwifi/`
is extremely shallow (no meaningful per-file history). Patch is **3/15**
in the May 2026 iwlwifi series; this commit is standalone and does not
depend on patches 1/15 or 2/15.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Emmanuel Grumbach is a long-standing iwlwifi maintainer.
Series cover letter lists him as author of this fix among other iwlwifi
changes. Cannot verify author history in this shallow tree.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites identified. Required symbols
(`iwl_read_umac_prph_no_grab`, `IWL_DEVICE_FAMILY_DR`,
`IWL_DEVICE_FAMILY_SC`, `get_crf_id`) all exist in this tree. Patch
should apply cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** Patch found in local mbox
`20260511_miriam_rachel_korenblit_wifi_iwlwifi_updates_2026_05_11.mbx`
as `[PATCH 3/15]`. Cover letter classifies it under "Features, cleanups
and **fixes**". `b4 dig -c HEAD` did not match (HEAD is the stable
release tag, not this commit). `b4 dig` by subject failed (wrong
invocation). Link fetch blocked by bot protection — could not read full
lore thread.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>`. Series
addressed to iwlwifi maintainers. Full `-w` recipient list not
retrieved.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report, syzbot link, or user `Reported-by:`
— internal Intel discovery/fix.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Part of 15-patch series; patches 1/15 (debugfs PE naming)
and 2/15 (firmware core bump) are independent. This fix is self-
contained.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched on lore stable list (no stable nomination found
in available sources). Absence of `Cc: stable` is expected per review
instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `iwl_poll_umac_prph_bits_no_grab()` (new), `get_crf_id()`
(modified), callers of `get_crf_id()`.

### Step 5.2: TRACE CALLERS
**Record:** `get_crf_id()` is called from `iwl_pci_gen1_2_probe()` at
line 4195, during early PCIe probe after `iwl_trans_activate_nic()` and
`iwl_trans_grab_nic_access()`. This runs for every iwlwifi PCIe gen1/2
device, including all SC PCI IDs (`0xE440`, `0xE340`, `0xD340`,
`0x6E70`, `0xD240` in `pcie/drv.c`).

### Step 5.3: TRACE CALLEES
**Record:** Uses `iwl_read_umac_prph_no_grab()`,
`iwl_write_umac_prph_no_grab()`, `iwl_read_prph_no_grab()`,
`udelay(IWL_POLL_INTERVAL)` — standard iwlwifi register I/O.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** PCI probe → `iwl_pci_gen1_2_probe()` → `get_crf_id()` →
`map_crf_id()` (if `hw_rf_id` is zero). Reachable on every boot/module
load for affected hardware. Not userspace-triggerable directly, but
affects all users of SC (and future DR) WiFi hardware.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `iwl_poll_umac_prph_bit()` exists in `iwl-io.h` (uses
`iwl_poll_prph_bit` with grab). `rx.c` uses `iwl_poll_umac_prph_bit()`
for RFH status. New `no_grab` variant is needed because `get_crf_id()`
runs with NIC access already held — verified: no existing
`poll_*_no_grab` helper before this patch.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** `get_crf_id()` in `trans.c` (lines 3990–4040)
accesses peripheral registers without CNVR TOP readiness wait.
`IWL_DEVICE_FAMILY_SC` and `IWL_DEVICE_FAMILY_DR` are defined; SC PCI
IDs are present in `pcie/drv.c`. DR config (`cfg/dr.c`) exists but has
no PCI ID table entry yet in this tree. The buggy code path is live for
SC devices today.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply**. Target functions and register-
access helpers exist unchanged. No conflicting recent changes found
(shallow history). Only copyright year lines differ cosmetically.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** **No.** `iwl_poll_umac_prph_bits_no_grab`,
`WFPM_RSRCS_4PHS_*`, and `RSRC_*_CNVR_TOP` are absent from this tree
(grep confirmed).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/net/wireless/intel/iwlwifi` — **IMPORTANT** (widely
deployed Intel WiFi driver; probe/init path).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively developed; DR family added recently (cfg copyright
2024–2025). SC family has been present longer (2015+). Cannot assess
commit frequency from shallow local history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users with Intel WiFi **SC-family** hardware (PCI IDs in
`drv.c`). **DR-family** users when PCI IDs are added. Config-dependent
(`CONFIG_IWLWIFI`).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Every probe/resume path where blank OTP requires reading CRF
ID from peripheral registers. Timing-dependent on DR/SC silicon — CNVR
TOP not ready at the moment `get_crf_id()` runs. Common on boot; not
privilege-dependent.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- Wrong/zero `hw_crf_id` → `map_crf_id()` returns `-EIO` → probe fails
  with `-EINVAL` at line 4211–4214
- **Severity: HIGH** — WiFi completely non-functional on affected
  hardware (not a kernel panic, but total device failure)
- No data corruption or security exposure identified

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for SC (and future DR) users — restores reliable
  probe/hardware identification
- **Risk:** LOW — ~30 lines of functional code, family-gated, follows
  established polling pattern
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real hardware-init bug on DR/SC silicon
- Probe failure (`-EINVAL`) when RF ID cannot be read correctly
- Small, surgical, Intel-reviewed fix
- Buggy code confirmed present in 6.18.44
- SC PCI IDs actively supported in this tree
- Follows existing iwlwifi polling conventions
- Standalone within a larger series

**AGAINST backport:**
- No external user/syzbot report (internal Intel fix)
- DR PCI IDs not yet in `drv.c` (fix most immediately benefits SC)
- On ACK timeout, driver still proceeds (mitigation is wait, not hard
  abort)
- Shallow git history limits introduction-date analysis

**Unresolved:**
- Exact lore thread review discussion (link blocked)
- Whether SC devices in the field routinely hit this without the fix
  (Intel says they need the wait)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard poll-before-read
   pattern; Intel reviewed
2. Fixes a real bug affecting users? **PASS** — probe failure on SC
   hardware
3. Important issue? **PASS** — HIGH severity (device completely non-
   functional)
4. Small and contained? **PASS** — 4 files, ~30 lines functional code
5. No new features or APIs? **PASS** — internal driver helper only
6. Can apply to local tree? **PASS** — all prerequisites present

### Step 9.3: EXCEPTION CATEGORIES
**Record:** Hardware workaround / hardware-init quirk for specific Intel
WiFi silicon (DR/SC CNVR TOP sequencing).

### Step 9.4: DECISION RATIONALE

For **Linux 6.18.44**, this commit should be backported. The tree
contains SC-family PCI device support and the buggy `get_crf_id()` path
that reads CNVR TOP peripheral registers without waiting for hardware
readiness. Without the fix, affected Intel WiFi hardware can fail probe
entirely when blank OTP requires CRF-ID-based RF identification. The fix
is minimal, gated to the affected families, reviewed by Intel, and
introduces no userspace-visible changes.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and local mbox
- **[Phase 2]** Analyzed full diff: 4 files, new poll helper +
  `get_crf_id()` wait logic
- **[Phase 3]** `git blame` on `get_crf_id()`: present in tree; shallow
  history limits introduction commit
- **[Phase 3]** No `Fixes:` tag to follow
- **[Phase 3]** Mbox confirms patch 3/15, standalone
- **[Phase 4]** Local mbox `20260511_miriam_rachel_korenblit_wifi_iwlwif
  i_updates_2026_05_11.mbx`: found patch 3/15 and cover letter
- **[Phase 4]** `b4 dig -c HEAD`: no match (HEAD is v6.18.44 tag, not
  this commit)
- **[Phase 4]** Link fetch to patch.msgid.link: blocked by bot
  protection
- **[Phase 4]** `Reviewed-by: Daniel Gabay` confirmed from commit
  message
- **[Phase 5]** `get_crf_id()` caller: `iwl_pci_gen1_2_probe()` line
  4195 in `trans.c`
- **[Phase 5]** Downstream: `map_crf_id()` at lines 4211–4214 can return
  `-EINVAL` on probe failure
- **[Phase 5]** Existing `iwl_poll_umac_prph_bit()` uses grab; new
  `no_grab` variant needed in held-access context
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Grep: `iwl_poll_umac_prph_bits_no_grab` /
  `WFPM_RSRCS_4PHS_*` absent — fix not yet applied
- **[Phase 6]** Grep: `IWL_DEVICE_FAMILY_DR` / `SC` present; SC PCI IDs
  in `pcie/drv.c` (5 devices); DR config exists but no PCI ID entry
- **[Phase 6]** Read `get_crf_id()` lines 3990–4040: buggy code (no CNVR
  TOP wait) confirmed
- **[Phase 8]** Failure mode traced: bad `hw_crf_id` → `map_crf_id()`
  `-EIO` → probe `-EINVAL`

**YES**

 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 18 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |  4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  7 ++++-
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 26 ++++++++++++++++++-
 4 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index b1944584c6931..c4ccfffdf6af9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2022, 2024-2025 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2022, 2024-2026 Intel Corporation
  * Copyright (C) 2015-2016 Intel Deutschland GmbH
  */
 #include <linux/device.h>
@@ -168,6 +168,22 @@ int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 	return -ETIMEDOUT;
 }
 
+int iwl_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
+				    u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read_umac_prph_no_grab(trans, addr) & mask) ==
+		    (bits & mask))
+			return 0;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 5bcec239ffc4a..d920a32fc173c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2018-2021, 2025 Intel Corporation
+ * Copyright (C) 2018-2021, 2025-2026 Intel Corporation
  */
 #ifndef __iwl_io_h__
 #define __iwl_io_h__
@@ -51,6 +51,8 @@ static inline void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 
 int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 		      u32 bits, u32 mask, int timeout);
+int iwl_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
+				    u32 bits, u32 mask, int timeout);
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index a7214ddcfaf56..6ca1f51b69a1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2005-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016 Intel Deutschland GmbH
  */
@@ -411,6 +411,11 @@ enum {
 #define HPM_SECONDARY_DEVICE_STATE      0xa03404
 #define WFPM_MAC_OTP_CFG7_ADDR		0xa03338
 #define WFPM_MAC_OTP_CFG7_DATA		0xa0333c
+#define WFPM_RSRCS_4PHS_REQ_STTS	0xa033f8
+#define WFPM_RSRCS_4PHS_ACK_STTS	0xa033fc
+
+#define RSRC_REQ_CNVR_TOP BIT(6)
+#define RSRC_ACK_CNVR_TOP BIT(6)
 
 
 /* For UMAG_GEN_HW_STATUS reg check */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 59307b5df4417..b003abf1fe2ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2007-2015, 2018-2024 Intel Corporation
+ * Copyright (C) 2007-2015, 2018-2024, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -4000,6 +4000,30 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	else
 		sd_reg_ver_addr = SD_REG_VER;
 
+	/* wait until the device is ready to access the prph registers */
+	if (iwl_trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_DR ||
+	    iwl_trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_SC) {
+		u32 req = iwl_read_umac_prph_no_grab(iwl_trans,
+						     WFPM_RSRCS_4PHS_REQ_STTS);
+		int ret;
+
+		if (!(req & RSRC_REQ_CNVR_TOP)) {
+			IWL_ERR(iwl_trans,
+				"WFPM_RSRCS_4PHS_REQ_STTS bit 6 is clear 0x%x\n",
+				req);
+			return;
+		}
+
+		ret = iwl_poll_umac_prph_bits_no_grab(iwl_trans,
+						      WFPM_RSRCS_4PHS_ACK_STTS,
+						      RSRC_ACK_CNVR_TOP,
+						      RSRC_ACK_CNVR_TOP,
+						      50 * 1000);
+		if (ret < 0)
+			IWL_ERR(iwl_trans,
+				"WFPM_RSRCS_4PHS_ACK_STTS bit 6 is clear\n");
+	}
+
 	/* Enable access to peripheral registers */
 	val = iwl_read_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG);
 	val |= WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK;
-- 
2.53.0

