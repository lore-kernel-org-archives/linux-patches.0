Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250E859A950;
	Mon, 31 Aug 2026 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184299; cv=none; b=UuVBWtNdE1ZMTGKjkESH86PD4PClHeZ7V4Pw7QgnO+VgUNun3bAIQaNJKyABI1MhM60qSXtPaFysJvDbpoNwe4VPiWO8VURZLeA4FhB92ZjqsjXD+/TeRq6Qcds4nGB4/f6FvmQc4KjXQWOAGfyOTZUxeeCeHYvN5Xbp99VWAik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184299; c=relaxed/simple;
	bh=T1tr1av3QJ/VTZ36RUanPPipkl7YvT0IjXBL4vUX3Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ppQduPVHa1sPU+oaAVc4GoQtrHc2Qx4VbalSqEiFLznYeuHwyM7P6fgN95CjV7++QDxylKxJ96TzVe1GXoAtZ1w5YoQwyQTGHs6LvTdrgafMfagT+WJggMoGyEzzjnNMHw+5PfmvncGK7UdBLv7nklyi28YI+RcraC4zO1WMR7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxBtHd88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxBtHd88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E41F00A3D;
	Mon, 31 Aug 2026 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184296;
	bh=KFrji6sAEM01oX6Klu9JH/k5CoftNiOX7x3iUh3LoAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxBtHd88uXelOluNaufe+NjtlDvdfT/eeqECvUk6KjWlIUGKKc/i0zLeeswXYBlxd
	 gRTopZz91WF39jAyQ7kx9bvVrKYmXHZWo0XLFeWY94+K/OXkGlfQEAIpDSYnJe1DyD
	 FTDR0yiwQfYiG3i3CIk5VmilK6pYP+Ye9qNoOMZAh+VSFz5s+2WfcDK6lP99E41hIx
	 IHSZ8kpVACum83Q15XszJRa4W9DUJpG/ebDX/8lAlrfYD0rOSRdHdYL9iLtwLcvF/C
	 +Orr+8+t4VVkdOXw9nqjHayzNs0KyMcgUOO2sVtwm5DUtTFpALX05Yl6+6pfZcLz+R
	 6xEO+pUu93cLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-i3c@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA
Date: Mon, 31 Aug 2026 09:30:36 -0400
Message-ID: <20260831133314.4125787-608-sashal@kernel.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c236563c8a84239d31a1e6ec4444887a7b5ed98f ]

i3c_master_add_i3c_dev_locked() no longer leaves the address marked as
free on failure, so aborting the DAA sequence on its error is unnecessary.

Failure to register a discovered device does not invalidate the entire
Dynamic Address Assignment (DAA) procedure.  Align with the behavior of
other I3C master drivers by ignoring errors from
i3c_master_add_i3c_dev_locked() and continuing enumeration.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260612080107.11606-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[i3c: mipi-i3c-hci]` `[Tolerate]` — Stop aborting DAA when
`i3c_master_add_i3c_dev_locked()` fails; continue enumeration instead.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Adrian Hunter `<adrian.hunter@intel.com>` (author)
- **Reviewed-by:** Frank Li `<Frank.Li@nxp.com>` (NXP I3C maintainer)
- **Link:** https://patch.msgid.link/20260612080107.11606-5-
  adrian.hunter@intel.com
- **Signed-off-by:** Alexandre Belloni `<alexandre.belloni@bootlin.com>`
  (I3C subsystem maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: Reviewed by subsystem expert; part of V4 4/7 series

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `mipi-i3c-hci` aborts the entire DAA loop when
  `i3c_master_add_i3c_dev_locked()` fails for one device.
- **Symptom:** Remaining I3C devices on the bus are never
  enumerated/registered after a single device-add failure.
- **Root cause (per author):** After commit `38d3d33` ("Prevent reuse of
  dynamic address on device add failure"), failed registration no longer
  frees the address slot, so aborting DAA is unnecessary and harmful.
- **Fix approach:** Ignore the return value and continue DAA, matching
  `svc-i3c-master`, `cdns`, `renesas`, `dw`, and `adi` drivers.
- No explicit kernel version range in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as alignment/cleanup, but it fixes a real
logic bug: premature DAA termination leaves devices undiscovered. Same
class of bug fixed in `svc-i3c-master` (commit `3b2ac810`, Cc: stable).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- `drivers/i3c/master/mipi-i3c-hci/cmd_v1.c`: −3 lines (remove ret check
  + break)
- `drivers/i3c/master/mipi-i3c-hci/cmd_v2.c`: −3 lines (same)
- Functions: `hci_cmd_v1_daa()`, `hci_cmd_v2_daa()`
- Scope: single-file surgical fix in one driver (2 command variants)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`cmd_v1.c`):** Before: assign address via hardware DAA →
  call `i3c_master_add_i3c_dev_locked()` → on error, `break` out of DAA
  loop. After: call function without checking return; loop continues to
  next device.
- **Hunk 2 (`cmd_v2.c`):** Identical behavioral change in v2 DAA path.
- Affected path: normal DAA enumeration loop during bus probe / hot-
  join.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness fix (error-path handling)
- **Mechanism:** Treating a per-device registration failure as fatal to
  the entire multi-device DAA sequence. With prerequisite `38d3d33`, the
  address is retained on failure, so continuing is safe. Aborting
  prevents registration of subsequently discovered devices.

### Step 2.4: Fix Quality
**Record:** Obviously correct — matches established pattern in five
other I3C master drivers. Minimal change. Low regression risk: only
removes an overly aggressive early-exit; real bus/transfer errors still
break the loop via `RESP_STATUS` checks.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `if (ret) break;` pattern introduced in
`9ad9a52cce282` (Nov 2020, "i3c/master: introduce the mipi-i3c-hci
driver"). Present since driver introduction.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Prerequisite identified from commit
message: `38d3d33bf42c2` / upstream `b3ba8383da4d0` ("Prevent reuse of
dynamic address on device add failure"), which changes
`i3c_master_add_i3c_dev_locked()` to mark addresses as occupied on
failure via `err_prevent_addr_reuse`. **Confirmed present in this tree**
(`git merge-base --is-ancestor` passes).

### Step 3.3: Related File History
**Record:** Recent related commits in tree:
- `38d3d33` — prerequisite (already backported to 6.18.y)
- `3b2ac810` — svc driver: identical "don't check return value" fix (in
  tree, Cc: stable)
- Fix commit `c236563c8a842` is in mainline but **not yet in this
  6.18.44 checkout**

### Step 3.4: Author Context
**Record:** Adrian Hunter is an active Intel I3C contributor. Multiple
related fixes in `drivers/i3c/` around DAA, hot-join, and address
management (Jun 2026 series).

### Step 3.5: Dependencies
**Record:**
- **Hard dependency:** `38d3d33` (already in tree) — without it,
  continuing DAA after failure could reassign addresses.
- **Not required:** Patches 1/7 (race fix), 2/7 (DISEC), 5–7/7 (return-
  void API change + reconciliation — **not merged to mainline**).
- **Standalone:** Yes, for stable purposes, given prerequisite is
  present.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260612080107.11606-5-
  adrian.hunter@intel.com
- **Series:** V1→V4, patch 4/7; applied version is latest (V4)
- **Cover letter (V4 0/7):** "Patches 3-7 fix address management
  issues... when DAA does not complete cleanly"
- **Reviewer feedback:** "Applied, thanks!" from maintainer on cover
  letter
- No explicit stable nomination found in mbox for this specific patch

### Step 4.2: Reviewers
**Record:** CC'd: `alexandre.belloni@bootlin.com`, `Frank.Li@nxp.com`,
`linux-i3c@lists.infradead.org`, `linux-kernel@vger.kernel.org`.
Reviewed-by Frank Li (NXP).

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified
through code review / series development. Precedent: `3b2ac810`
documented identical failure mode for svc driver with explicit I3C spec
violation scenario.

### Step 4.4: Related Patches
**Record:** Part of 7-patch V4 series. Patches 5–7 (API change to void
return + post-DAA reconciliation) were **not** merged upstream. This
patch was merged standalone with patch 3.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch.
Prerequisite `38d3d33` was backported to this tree (has upstream-commit
marker and Greg K commit).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `hci_cmd_v1_daa()`, `hci_cmd_v2_daa()`, called via
`i3c_hci_daa()` in `core.c`.

### Step 5.2: Callers
**Record:** `i3c_hci_daa()` → registered as `master->ops.do_daa` →
invoked by `i3c_master_do_daa()` / `i3c_master_do_daa_ext()` during bus
initialization and hot-join DAA. Called during device probe, not a hot
syscall path.

### Step 5.3: Callees
**Record:** `i3c_master_add_i3c_dev_locked()` — allocates device,
retrieves CCC info, attaches to bus. On failure (with `38d3d33`): logs
error, marks address slot occupied, returns error code.

### Step 5.4: Reachability
**Record:** Triggered during I3C bus enumeration on systems using
`mipi-i3c-hci` (Intel and other MIPI HCI platforms). Multi-device buses
are common (sensors, PMICs, etc.). Failure of one device's registration
is plausible (transient CCC errors, firmware quirks).

### Step 5.5: Similar Patterns
**Record:** All other I3C master drivers ignore
`i3c_master_add_i3c_dev_locked()` return during DAA:

```1224:1225:drivers/i3c/master/svc-i3c-master.c
        for (i = 0; i < dev_nb; i++)
                i3c_master_add_i3c_dev_locked(m, addrs[i]);
```

Same pattern in `renesas-i3c.c`, `i3c-master-cdns.c`, `dw-i3c-master.c`,
`adi-i3c-master.c`. `mipi-i3c-hci` is the only outlier.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** Local tree is **linux-6.18.y** (`v6.18.44`). Both
`cmd_v1.c:365-367` and `cmd_v2.c:303-305` still have `ret =
i3c_master_add_i3c_dev_locked(...); if (ret) break;`. Bug present since
driver introduction (2020).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git cherry-pick --no-commit c236563c8a842`
auto-merged both files without conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:**
- Prerequisite `38d3d33` — **present**
- Svc driver equivalent fix `3b2ac810` — **present**
- This specific mipi-i3c-hci fix — **not present**

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/i3c/master/mipi-i3c-hci/` — **IMPORTANT** (bus
driver affecting all I3C peripherals on HCI-based platforms, but
hardware-specific).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — multiple mipi-i3c-hci fixes in 6.18.y
(hot-join, DMA, IRQ handling).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of `CONFIG_I3C` with `mipi-i3c-hci` hardware and
multiple I3C devices on the bus.

### Step 8.2: Trigger Conditions
**Record:** DAA discovers ≥2 devices; `i3c_master_add_i3c_dev_locked()`
fails for an early device (allocation failure, CCC retrieval error,
duplicate handling, etc.). Not timing-dependent. Requires `CONFIG_I3C` +
mipi-i3c-hci. Unprivileged users cannot directly trigger, but affects
system hardware functionality at boot/probe.

### Step 8.3: Failure Mode Severity
**Record:** Subsequent I3C devices fail to register —
sensors/peripherals missing, potential bus state inconsistency (hardware
has address assigned, kernel unaware). **Severity: MEDIUM-HIGH** for
affected hardware (functional failure, not kernel crash). Pre-`38d3d33`,
could also cause address conflicts on hot-join (documented in svc fix);
that part is fixed, but partial enumeration remains.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected platforms — restores multi-device
  enumeration; completes behavior change started by `38d3d33` backport
- **Risk:** VERY LOW — 6-line total removal, matches five other drivers,
  prerequisite already in tree
- **Ratio:** Strong benefit, minimal risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real functional bug with documented precedent (`3b2ac810`, Cc: stable)
- Prerequisite `38d3d33` already in 6.18.y
- Surgical 6-line fix, reviewed by NXP maintainer
- Applies cleanly
- Aligns mipi-i3c-hci with all other I3C master drivers
- Completes address-management fix series partially backported to stable

**AGAINST backport:**
- No crash, security issue, or data corruption
- Hardware-specific (mipi-i3c-hci only)
- Requires `i3c_master_add_i3c_dev_locked()` failure (not everyday, but
  plausible)
- Part of larger series (but this patch is self-contained with
  prerequisite)

**Unresolved:** No user bug report or syzbot reproduction; impact
inferred from code analysis and svc-driver precedent.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — matches established driver
   pattern; Reviewed-by Frank Li
2. Fixes a real bug? **PASS** — premature DAA abort leaves devices
   undiscovered
3. Important issue? **PASS** — functional hardware failure on multi-
   device I3C buses (MEDIUM-HIGH for affected users)
4. Small and contained? **PASS** — 2 files, 6 lines removed
5. No new features/APIs? **PASS** — behavior alignment only
6. Can apply to local tree? **PASS** — clean cherry-pick; prerequisite
   present

### Step 9.3: Exception Categories
**Record:** N/A — not a device ID, quirk, DT, build, or docs fix.
Standard driver bug fix.

### Step 9.4: Decision Rationale
This fix should be backported to **linux-6.18.y** because the
prerequisite commit changing `i3c_master_add_i3c_dev_locked()` failure
semantics is already in the tree, but `mipi-i3c-hci` still aborts DAA on
registration failure — leaving subsequent devices undiscovered. The
identical issue was fixed and stable-nominated for the svc driver. This
is the companion fix for the HCI driver, small and low-risk.

---

## Verification

- [Phase 1] `git show c236563c8a842`: parsed subject, tags, body
- [Phase 2] Diff: 2 files, `hci_cmd_v1_daa`/`hci_cmd_v2_daa`, 6 lines
  removed
- [Phase 3] `git blame cmd_v1.c:365-367`: introduced `9ad9a52` (2020)
- [Phase 3] `git merge-base --is-ancestor 38d3d33bf42c2 HEAD`:
  prerequisite present
- [Phase 3] `git show 38d3d33`: `err_prevent_addr_reuse` handler
  confirmed
- [Phase 3] `git show 3b2ac810`: svc driver identical fix with Cc:
  stable
- [Phase 3] `git merge-base --is-ancestor 3b2ac810 HEAD`: svc fix in
  tree
- [Phase 4] `b4 dig -c c236563c8a842`: lore URL found
- [Phase 4] `b4 dig -a`: V1–V4 series, patch 4/7
- [Phase 4] `b4 dig -w`: maintainers CC'd
- [Phase 4] `/tmp/i3c_daa.mbox`: cover letter, patches 1–7 subjects;
  patch 7 not merged upstream
- [Phase 5] `grep i3c_master_add_i3c_dev_locked drivers/i3c/master/`: 5
  other drivers ignore return
- [Phase 5] `core.c:266-270`: `i3c_hci_daa` → `perform_daa` call chain
- [Phase 6] `git describe HEAD`: v6.18.44 (linux-6.18.y)
- [Phase 6] Read `cmd_v1.c:365-367`, `cmd_v2.c:303-305`: buggy code
  present
- [Phase 6] `git cherry-pick --no-commit c236563c8a842`: clean apply
- [Phase 6] `git log HEAD..c236563c8a842 --
  drivers/i3c/master/mipi-i3c-hci/`: fix not in tree
- [Phase 7] `git log -20 -- drivers/i3c/master/mipi-i3c-hci/`: active
  subsystem
- [Phase 8] Read `svc-i3c-master.c:1205-1225`: documented failure mode

**YES**

 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c | 4 +---
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c b/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
index efb7a1f92641c..b6ba18ccdd2d3 100644
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
@@ -362,9 +362,7 @@ static int hci_cmd_v1_daa(struct i3c_hci *hci)
 		 * TODO: Extend the subsystem layer to allow for registering
 		 * new device and provide BCR/DCR/PID at the same time.
 		 */
-		ret = i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
-		if (ret)
-			break;
+		i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
 	}
 
 	if (dat_idx >= 0)
diff --git a/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c b/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
index 5fc2e4c55ebb0..d7999d341a227 100644
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
@@ -300,9 +300,7 @@ static int hci_cmd_v2_daa(struct i3c_hci *hci)
 		 * TODO: Extend the subsystem layer to allow for registering
 		 * new device and provide BCR/DCR/PID at the same time.
 		 */
-		ret = i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
-		if (ret)
-			break;
+		i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
 	}
 
 	hci_free_xfer(xfer, 2);
-- 
2.53.0

