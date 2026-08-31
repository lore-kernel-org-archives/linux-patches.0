Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA414E9AF8;
	Mon, 31 Aug 2026 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183621; cv=none; b=UnLepFVrZ6zOrr36iEpC4Kb8hWUGiiFyp2ohqCn9LP2diadQrbA7TEqTUYJBqfk0pNFsNnFFb9/fSO11xpiju9kAiyEZky44m9VbOkkyhvxziHqsPcAfEDz2aFZIGdcP/DYFrX3deAN6jwKPF3mauBiBBr/HHtq1T9m8MwmWgxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183621; c=relaxed/simple;
	bh=y6csCL/R1rcLziRlPX6WrenEjIisHTB0PvmKJN+Gwyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcjIYfRKV0bKiVYRbWK+Bho7ybBpEpnmTwBx3a9lAgGBbtHIo/r/ooZurUtD4ql/iq3egmstMkkYZZyWSsqTKMNNjwPatrl5kPWg5kuup9yZJgXX9gzvFrQAFoW7PYTX7p6pt+y3bhuW5vhJoFAVjt076vijyq5l4aRhLrp5f74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CovSeabh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CovSeabh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120B11F00ACA;
	Mon, 31 Aug 2026 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183618;
	bh=F8rK4rLMFd335wHj57VD5rJSaaOzPj7rBxP3FPEcSaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CovSeabhvt8uAt3YNcL4YCrJUppC6e8e118fVxmpRpbnYUDjHi8d/XbfHzlgUZYQw
	 KpjXFNpsQs/xYGlUbCABBDMbC65cD2M2TWGSZNiXsXVDzfiAm2eQsHyyExcbBimBRL
	 acdfpRhNWo0eWNGjDHu7nUCdXzzPl8to217VTUQcz+tOnP2ohLyRw9brj9rUUcEROz
	 gByJ6p753ZOLmzesxlhTE90XB89EYcC41SI+5L1ABylyABsB/Tm0/0aAgCBl0sZrEs
	 +RVRqaxTzVv3ZYT+QRRD++sKLwmPVQVZswcyPddnDD+A/S5GT5le9XY79/yvQyhPLn
	 h49srBgxYWJrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems
Date: Mon, 31 Aug 2026 09:23:49 -0400
Message-ID: <20260831133314.4125787-201-sashal@kernel.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 6a4f64c3a3ada43e71ef1e06da89beb36bdaeefa ]

Some Qualcomm PCIe devices (WCN6855/WCN7850 WiFi cards, SDX62/SDX65 modems)
do not properly support Secondary Bus Reset (SBR).

Testing confirms this is device-specific, not deployment-specific:
MediaTek MT7925e successfully uses bus reset through the same passive
M.2-to-PCIe adapters where Qualcomm devices fail, proving PERST# is
properly wired through the adapters.

Prevent use of Secondary Bus Reset for these devices.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/all/20260609163649.319755-4-jtornosm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
# Stable Backport Analysis: PCI Qualcomm SBR Quirk

**Local tree:** `v6.18.44` (6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[PCI] [avoid] Avoid Secondary Bus Reset (SBR) for Qualcomm
WCN6855/WCN7850 WiFi and SDX62/SDX65 modems`

### Step 1.2: Tags
**Record:**
- **Link:** `https://lore.kernel.org/all/20260609163649.319755-4-
  jtornosm@redhat.com`
- **Signed-off-by:** Jose Ignacio Tornos Martinez
  `<jtornosm@redhat.com>` (author)
- **Signed-off-by:** Bjorn Helgaas `<bhelgaas@google.com>` (PCI
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: maintainer sign-off from Bjorn Helgaas; part of v8 series
  `[PATCH v8 0/3]` per LWN

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Qualcomm PCIe devices (WCN6855/WCN7850 WiFi, SDX62/SDX65
  modems) do not properly support Secondary Bus Reset
- **Symptom:** Bus reset fails/hangs on these devices; LWN series
  context describes VFIO passthrough reset failures and potential system
  hang when SBR is attempted (same failure class as existing Atheros
  quirk in `quirks.c`)
- **Root cause:** Device-specific hardware limitation, not
  adapter/wiring issue (MT7925e works on same M.2-to-PCIe adapters)
- **Fix:** Mark devices with `quirk_no_bus_reset` to set
  `PCI_DEV_FLAGS_NO_BUS_RESET`

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — described as "avoid/prevent" rather than "fix", but it
is a hardware quirk preventing a known-broken reset path. Same pattern
as Atheros/Cavium/TI/ASM1164 quirks already in `quirks.c`, where SBR
causes link-down, inaccessible config space, and system hang.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/pci/quirks.c` only (+3 lines)
- **Functions:** No function changes; adds 3 `DECLARE_PCI_FIXUP_HEADER`
  entries after Atheros quirks
- **Scope:** Single-file surgical hardware quirk addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Qualcomm devices `0x17cb:0x1103`, `0x17cb:0x1107`,
  `0x17cb:0x0308` had no `NO_BUS_RESET` flag; `pci_reset_bus_function()`
  could probe/use SBR
- **After:** At PCI header fixup time, `quirk_no_bus_reset()` sets
  `PCI_DEV_FLAGS_NO_BUS_RESET`; `pci_parent_bus_reset()` and
  `pci_dev_reset_slot_function()` return `-ENOTTY` when flag is set
  (lines 4801, 4832 in `pci.c`)
- **Path affected:** PCI device reset enumeration and execution
  (`pci_init_reset_methods()`, `__pci_reset_function_locked()`), VFIO
  device reset, driver error recovery

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround / quirk
- **Mechanism:** Broken SBR on specific Qualcomm silicon; quirk prevents
  kernel from selecting a reset method that bricks the device or hangs
  the system. Analogous to Atheros quirk comment at lines 3767–3770:
  "config space of the device is never accessible again and typically
  causes the system to hang or reset"

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: identical pattern to ~10 existing
  `quirk_no_bus_reset` entries in the same file
- Minimal: 3 `DECLARE_PCI_FIXUP_HEADER` lines
- Low regression risk: only affects listed device IDs; other reset
  methods (FLR, PM, device-specific) remain available if supported

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `quirk_no_bus_reset()` introduced in `c3e59ee4e7668` (2015-01-15, Alex
  Williamson) — long-established infrastructure
- Insertion point (after Atheros quirks, before Cavium) matches current
  tree layout exactly

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no `Fixes:` tag. Bug is inherent to
hardware, not introduced by a specific kernel commit.

### Step 3.3: Related File History
**Record:**
- Recent similar quirks in this tree: ASM1164 (`a175a76147382`), Nvidia
  GB10 (`b8bd9fe67041c`)
- This commit is patch 3/3 of series "PCI: Add d3cold and device-
  specific reset for Qualcomm devices" (LWN v8 0/3). Patches 1–2 (d3cold
  reset method, Qualcomm device-specific reset) are **not** in this
  tree; patch 3 is standalone (only adds quirk entries, no code
  dependencies on patches 1–2)

### Step 3.4: Author Context
**Record:** Jose Ignacio Tornos Martinez — no prior PCI commits in this
6.18.44 tree; authored VFIO/PCI reset series merged to mainline v7.2
(June 2026). Bjorn Helgaas (PCI maintainer) signed off.

### Step 3.5: Dependencies
**Record:**
- **Standalone:** Yes — only uses existing `quirk_no_bus_reset` and
  `PCI_VENDOR_ID_QCOM`
- Patches 1–2 from the same series would improve VFIO reset capability
  but are **not prerequisites** for this quirk; LWN describes patch 3 as
  a "safety net" that independently prevents broken SBR

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- Direct lore fetch blocked (Anubis bot protection)
- LWN article found: [PCI: Add d3cold and device-specific reset for
  Qualcomm devices](https://lwn.net/Articles/1077236/) — covers full v8
  0/3 series
- `b4 dig -c <commit>` failed: commit not present in local repository
- Mainline merge: `44105c5d0a13` (pci/virtualization branch, 2026-06-23)

### Step 4.2: Reviewers
**Record:** CC list from LWN: `bhelgaas@google.com`, `alex@shazbot.org`
(VFIO), `linux-pci@`, `linux-wireless@`, `ath11k@`, `ath12k@`, `mhi@` —
appropriate subsystem coverage

### Step 4.3: Bug Report
**Record:** No formal bugzilla/syzbot report. Failure mode documented in
series cover letter: VFIO passthrough reset failures; device-specific
SBR breakage confirmed by comparative testing with MT7925e on same
adapters.

### Step 4.4: Series Context
**Record:**
- Patch 1/3: D3cold general reset method (not in 6.18.44)
- Patch 2/3: Qualcomm device-specific reset via D3cold (not in 6.18.44)
- Patch 3/3: **This commit** — disable broken SBR (standalone,
  backportable independently)

### Step 4.5: Stable List History
**Record:** No stable-list discussion found (lore blocked). Not a
negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `quirk_no_bus_reset()` (unchanged); reset path functions:
`pci_reset_bus_function()`, `pci_parent_bus_reset()`,
`pci_dev_reset_slot_function()`, `pci_slot_resettable()`

### Step 5.2: Callers
**Record:**
- `pci_init_reset_methods()` probes reset methods during device setup
- `__pci_reset_function_locked()` / `pci_reset_function()` used by VFIO,
  error handlers, sysfs `reset` attribute
- `pci_slot_resettable()` used during slot-level reset decisions
- All check `PCI_DEV_FLAGS_NO_BUS_RESET` — verified in `pci.c` lines
  4801, 4832, 5218, 5222, 5291, 5297

### Step 5.3: Callees
**Record:** `quirk_no_bus_reset()` only sets `dev->dev_flags |=
PCI_DEV_FLAGS_NO_BUS_RESET` — no allocations, locks, or I/O

### Step 5.4: Reachability
**Record:**
- Triggered during PCI enumeration (HEADER fixup) and whenever reset is
  attempted on these devices
- Userspace-reachable via VFIO passthrough, driver reload, error
  recovery, sysfs reset
- WiFi cards (WCN6855/WCN7850) and cellular modems (SDX62/SDX65) are
  commonly deployed hardware

### Step 5.5: Similar Patterns
**Record:** Identical pattern for Atheros (6 devices), Cavium, TI,
ASM1164, Nvidia — all `DECLARE_PCI_FIXUP_HEADER(...,
quirk_no_bus_reset)` in same section of `quirks.c`

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** The quirk entries are **missing** from this tree.
Affected hardware **is supported:**
- `WCN6855` (`0x1103`): `drivers/net/wireless/ath/ath11k/pci.c` (since
  2021)
- `WCN7850` (`0x1107`): `drivers/net/wireless/ath/ath12k/pci.c` (since
  2022)
- `SDX62/SDX65` (`0x0308`): `drivers/bus/mhi/host/pci_generic.c` (SDX65
  since July 2025)
- `PCI_VENDOR_ID_QCOM` (`0x17cb`): `include/linux/pci_ids.h`

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Target location (after Atheros
quirks at line 3778, before Cavium at 3785) matches the provided diff
exactly. No conflicting changes in that region.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git log --grep="Avoid SBR for Qualcomm"` returns
nothing. Qualcomm `quirk_no_bus_reset` entries for `0x1103`, `0x1107`,
`0x0308` absent from `quirks.c`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/pci/` — **CORE** subsystem. PCI reset affects all
PCI/PCIe devices; VFIO virtualization is a significant use case.

### Step 7.2: Activity
**Record:** Actively maintained — recent bus-reset quirks added (ASM1164
2024, Nvidia GB10 2025). Pattern is well-established and trusted.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Qualcomm WCN6855/WCN7850 WiFi (ath11k/ath12k) and
SDX62/SDX65 cellular modems (MHI) — laptops, M.2 WiFi cards, embedded
modems, VFIO passthrough setups.

### Step 8.2: Trigger Conditions
**Record:**
- Any PCI reset attempt that would use Secondary Bus Reset (VFIO VM
  teardown, driver unbind/rebind, error recovery, manual sysfs reset)
- Not timing-dependent; deterministic hardware limitation
- Unprivileged users can trigger via VFIO if permitted by admin

### Step 8.3: Failure Mode Severity
**Record:** Without quirk: device becomes inaccessible, link down,
potential **system hang or reset** (per Atheros quirk precedent in same
file). Severity: **CRITICAL** for affected hardware.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents device bricking and system hang on common
  reset paths
- **Risk:** VERY LOW — 3-line quirk using proven infrastructure, scoped
  to 3 device IDs
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Hardware quirk — established stable exception category
- Prevents system hang/device brick on SBR (CRITICAL severity)
- Surgical 3-line fix, obviously correct
- PCI maintainer (Bjorn Helgaas) signed off
- Affected devices fully supported in 6.18.44
- Infrastructure (`quirk_no_bus_reset`) present since 2015
- Identical to multiple existing stable-worthy quirks in same file
- Standalone — no dependency on patches 1–2 of the series

**AGAINST backport:**
- Part of a 3-patch series; patches 1–2 (alternative reset methods) not
  in tree — but patch 3 independently prevents catastrophic SBR failure
- No syzbot/fuzzer report — but hardware-specific, confirmed by author
  testing
- Without patches 1–2, VFIO reset may still fail for these devices — but
  that is strictly better than hanging

**Unresolved:** Direct lore thread unreadable (bot protection); `b4 dig`
unavailable (commit not in local repo).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — proven quirk pattern; author
   tested device-specific behavior vs MT7925e
2. Fixes real bug affecting users? **PASS** — broken SBR on shipping
   Qualcomm hardware
3. Important issue? **PASS** — CRITICAL (hang, device brick)
4. Small and contained? **PASS** — 3 lines, 1 file
5. No new features/APIs? **PASS** — hardware quirk only
6. Can apply to local tree? **PASS** — clean apply to existing code

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — automatic stable
qualification per instructions.

### Step 9.4: Decision Rationale
This commit adds PCI quirks preventing Secondary Bus Reset on Qualcomm
devices that do not support it. The 6.18.44 tree supports these devices
(ath11k, ath12k, MHI) but lacks the quirk, leaving users exposed to the
same failure mode documented for Atheros devices in the same file. The
fix is minimal, standalone, and follows a well-established pattern
already present in stable trees.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified as hardware quirk fix
- [Phase 1] LWN v8 0/3 series context retrieved from
  https://lwn.net/Articles/1077236/
- [Phase 2] Diff: 3 `DECLARE_PCI_FIXUP_HEADER` lines in
  `drivers/pci/quirks.c`
- [Phase 2] Read `quirk_no_bus_reset()` at lines 3741–3744
- [Phase 2] Read Atheros quirk hang description at lines 3767–3770
- [Phase 3] `git blame`: `quirk_no_bus_reset` from `c3e59ee4e7668`
  (2015)
- [Phase 3] `git log -S quirk_no_bus_reset`: 12 historical commits,
  pattern established
- [Phase 3] `git log --grep`: commit NOT in 6.18.44 tree
- [Phase 3] Confirmed patches 1–2 (d3cold, device-specific reset) NOT in
  tree via `git log --grep`
- [Phase 4] lore.kernel.org fetch blocked by Anubis
- [Phase 4] `b4 dig -c`: failed (commit not in local repo)
- [Phase 4] LWN series: patch 3/3 standalone safety net for broken SBR
- [Phase 4] GitHub merge `44105c5d0a13`: confirms mainline integration
  June 2026
- [Phase 5] `grep NO_BUS_RESET drivers/pci/pci.c`: 6 check sites
  verified
- [Phase 5] Read `pci_reset_fn_methods[]` at lines 5008–5017
- [Phase 5] Read `pci_parent_bus_reset()` at lines 4796–4812
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `make kernelversion`: 6.18.44
- [Phase 6] `grep 0x1103`: WCN6855 in `ath11k/pci.c`
- [Phase 6] `grep 0x1107`: WCN7850 in `ath12k/pci.c`
- [Phase 6] `grep 0x0308`: SDX65 in `mhi/host/pci_generic.c`
- [Phase 6] `grep PCI_VENDOR_ID_QCOM`: present in `pci_ids.h` as
  `0x17cb`
- [Phase 6] Confirmed quirk entries absent from current `quirks.c`
- [Phase 6] Target insertion point matches diff (after line 3778)
- [Phase 8] Hardware support dates: WCN6855 (2021), WCN7850 (2022),
  SDX65/0x0308 (2025) — all predate 6.18.44
- **UNVERIFIED:** Direct lore thread review (bot-blocked)
- **UNVERIFIED:** Explicit `Cc: stable` nomination in mailing list

**YES**

 drivers/pci/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 88d4a3f76bf3b..fbbdcbaf5aa01 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3776,6 +3776,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003e, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1103, quirk_no_bus_reset); /* WCN6855 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1107, quirk_no_bus_reset); /* WCN7850 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x0308, quirk_no_bus_reset); /* SDX62/SDX65 */
 
 /*
  * Root port on some Cavium CN8xxx chips do not successfully complete a bus
-- 
2.53.0

