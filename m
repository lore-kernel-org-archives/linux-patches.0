Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54A2474258;
	Mon, 31 Aug 2026 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183326; cv=none; b=kFSiu+1h3X9a37C/hUziu0UgxxbPyEcKsJ9nSiH3LNSjPBINSrjdSnVkL7NuF2kFBMmU+z/XmYg4hYT3SNtOt1cvZ7aMppdBeWDXejiy/FCXTyfyVmUSVkJ05k/7r6KmUDCVdDeULCgdltACKJ/MyvthAySfKxkRU44grZDcft0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183326; c=relaxed/simple;
	bh=36ZgMRRKntp4B8DGjMzrNi2XYz3DsHrJaW4Cgbe008c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hWGvnAFjFgE2wlIWekD1qEk/njSm9hf9Twouf1gPu9YFqjF+BTMgrIacnMTfgbQrliA/s5wN61A7Ed1kGEWhG6DTzqyK0TX36uq5LZPzMt9C2sGGBPqccttj7nQER5/ehmrlF2KAEYHpOcpzON4o2JiafBbk2Zu6d1juUf438nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYafd/05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYafd/05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5531F00A3D;
	Mon, 31 Aug 2026 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183323;
	bh=N0O6I1zwkNwuKXCKIF2Z7pqp/tBwQXmxHfsjJfPeqHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYafd/05bY0F2j2zYZfceP224frRcDQmbGY3FQCWnoy0O6DKk5c6iwiuyaRhWnCX2
	 qCHddyumNdV8L0ip2xkj0epk8WpqG04rBppPheKZd5PT37wqZlav+Nb+yAIVtqABM5
	 NWekCLvgO7A0z6hzS2jdpnI9NeP74mp2Mt2VeAst7nwd3yvYPN8oG3Wfn1QX80BWpT
	 0RiWnJ1iuj3YmMFq1tPkxY1pdQ7bgtUle88+t3d0qXic7lFP0NVtP30r6578McKM60
	 6j+o5NMTAA76pvZyS3agiUDuxNwxILvDvoUsRwO7rGuUYvtjJ1f4cuNbCdXUOsddiI
	 ksizRNzzALwuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] xhci: Prevent queuing new commands if xhci is inaccessible
Date: Mon, 31 Aug 2026 09:21:48 -0400
Message-ID: <20260831133314.4125787-80-sashal@kernel.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 82b70c799281cc24506085be978b829149ba0ca4 ]

Refuse to queue a new command on the command ring if xHC is marked
inaccessible with the HCD_FLAG_HW_ACCESSIBLE.

HCD_FLAG_HW_ACCESSIBLE is set and cleared in suspend and resume.

Also print a warning if xhci is being suspended with commands
still pending on the command ring.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260603091132.1110849-13-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `xhci: Prevent queuing new commands if xhci
is inaccessible`

## Phase 1: Commit Message Forensics

**Step 1.1 – Subject line**
- Record: `[xhci] [Prevent] refuse to queue commands when xHC is marked
  inaccessible via HCD_FLAG_HW_ACCESSIBLE`

**Step 1.2 – Tags**
- Record:
  - `Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>`
    (author)
  - `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
    (USB maintainer)
  - `Link: https://patch.msgid.link/20260603091132.1110849-13-
    mathias.nyman@linux.intel.com`
  - No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
    by:`, or `Reviewed-by:` tags
  - Notable: no fuzzer or user bug report cited

**Step 1.3 – Body analysis**
- Record:
  - **Bug:** `queue_command()` can still queue TRBs after
    `HCD_FLAG_HW_ACCESSIBLE` is cleared during suspend
  - **Symptom:** commands may be queued to an inaccessible controller;
    suspend may proceed while commands are still pending
  - **Version info:** none stated
  - **Root cause:** `HCD_FLAG_HW_ACCESSIBLE` is cleared in
    `xhci_suspend()` before the controller is fully stopped, but the
    command-ring path did not honor that flag (unlike URB submission)

**Step 1.4 – Hidden bug fix?**
- Record: **Yes.** Although the subject says “Prevent” rather than
  “fix”, this closes a real suspend/resume race: command submission
  bypasses the same hardware-accessibility guard already used on the URB
  path.

---

## Phase 2: Diff Analysis

**Step 2.1 – Inventory**
- Record:
  - `drivers/usb/host/xhci-ring.c`: +6 lines
  - `drivers/usb/host/xhci.c`: +4 lines
  - Total: 10 lines added, 0 removed
  - Functions modified: `queue_command()`, `xhci_suspend()`
  - Scope: single-subsystem, surgical, 2-file fix

**Step 2.2 – Code flow change**
- Record:
  - **`queue_command()` before:** only rejected commands when
    `XHCI_STATE_DYING` or `XHCI_STATE_HALTED`
  - **`queue_command()` after:** also rejects when
    `!HCD_HW_ACCESSIBLE(hcd)`, returning `-ESHUTDOWN`
  - **`xhci_suspend()` before:** cleared `HCD_FLAG_HW_ACCESSIBLE`, then
    stopped xHC and cleared command ring, with no visibility into
    pending commands
  - **`xhci_suspend()` after:** warns if `cmd_list` is non-empty before
    stopping the controller

**Step 2.3 – Bug mechanism**
- Record:
  - **Category:** logic / synchronization gap during suspend
  - **Mechanism:** `xhci_suspend()` clears `HCD_FLAG_HW_ACCESSIBLE` at
    line 999 while holding `xhci->lock`, then later calls
    `xhci_clear_command_ring()`. `queue_command()` had no equivalent
    check, unlike `xhci_urb_enqueue()` which already checks
    `HCD_HW_ACCESSIBLE` at line 1658. Command callers such as
    `xhci_setup_device()` use `xhci->mutex`, not `xhci->lock`, so they
    are not serialized against suspend. A thread can pass the
    `xhci->xhc_state` check, then lose the race to suspend, queue a
    command, and ring the doorbell via `xhci_ring_cmd_db()` against
    inaccessible hardware.

**Step 2.4 – Fix quality**
- Record:
  - Fix is minimal and mirrors an existing pattern in the same driver
  - Centralized in `queue_command()`, protecting all command submission
    paths
  - Low regression risk: returns `-ESHUTDOWN`, same as dying/halted case
  - Warning in suspend is diagnostic only; no behavior change beyond
    logging

---

## Phase 3: Git History Investigation

**Step 3.1 – Blame**
- Record:
  - `queue_command()` core logic dates to Sarah Sharp, 2009–2010
  - `HCD_FLAG_HW_ACCESSIBLE` clearing in `xhci_suspend()` introduced in
    `5535b1d5f88856` (Andiry Xu, 2010-10-14)
  - Shared-HCD mirroring of the flag in `873f323618c202` /
    `b320937972d45` (2022/2011)
  - Buggy missing check has been present since HW_ACCESSIBLE was added
    to suspend

**Step 3.2 – Fixes: tag**
- Record: N/A — no `Fixes:` tag in commit message

**Step 3.3 – Related file history**
- Record:
  - Recent xhci work in this tree includes suspend/resume fixes
    (`ff9a09b3e09c7`), command-timeout handling, and HCE interrupt-storm
    fixes
  - This patch is **standalone** — patch 12/15 in the “xhci features for
    usb-next” series; it does not depend on patches 1–11 or 13–15

**Step 3.4 – Author context**
- Record: Mathias Nyman is a long-time xhci maintainer with many xhci
  suspend/command-ring fixes in this tree

**Step 3.5 – Dependencies**
- Record: No prerequisites. Uses `HCD_HW_ACCESSIBLE()` /
  `xhci_to_hcd()`, both present in this tree. `git apply --check`
  succeeds cleanly.

---

## Phase 4: Mailing List and External Research

**Step 4.1 – Original discussion**
- Record:
  - Lore thread fetched via `b4 mbox`: `/tmp/xhci_b4/20260603091132.1110
    849-13-mathias.nyman@linux.intel.com.mbx`
  - Patch is `[PATCH 12/15]` in series `[PATCH 00/15] xhci features for
    usb-next`
  - Cover letter describes the series as “generic improvements,
    cleanups, refactoring and some DbC hung state detection and
    recovery”
  - No explicit stable nomination found in thread for patch 12/15
  - No NAKs found for this specific patch

**Step 4.2 – Reviewers**
- Record: Series sent to `linux-usb@vger.kernel.org`; Greg Kroah-Hartman
  Signed-off-by on the committed form

**Step 4.3 – Bug report**
- Record: No external bug report, syzbot link, or stack trace. Related
  RFT DbC runtime-suspend work exists in the same thread but is a
  separate patch.

**Step 4.4 – Series context**
- Record: Other patches in the series are mostly cleanups/refactors/DbC
  features; this patch is independently backportable

**Step 4.5 – Stable list history**
- Record: Not searched separately; no stable-list discussion found in
  fetched thread

---

## Phase 5: Code Semantic Analysis

**Step 5.1 – Key functions**
- Record: `queue_command()`, `xhci_suspend()`, and indirectly all
  `xhci_queue_*()` wrappers

**Step 5.2 – Callers**
- Record: `queue_command()` is reached from many paths including:
  - `xhci_queue_address_device()` → `xhci_setup_device()`
  - `xhci_queue_configure_endpoint()` / `xhci_queue_evaluate_context()`
  - `xhci_queue_slot_control()` (enable/disable slot)
  - `xhci_queue_stop_endpoint()` (hub suspend, endpoint stop)
  - `xhci_set_tr_deq()` (Set TR Dequeue Pointer)
  - All are on device enumeration, configuration, disconnect, and
    suspend/resume paths

**Step 5.3 – Callees**
- Record: `prepare_ring()`, `queue_trb()`, `list_add_tail()` to
  `cmd_list`; callers then often invoke `xhci_ring_cmd_db()` which does
  `writel()`/`readl()` on doorbell registers

**Step 5.4 – Reachability**
- Record: Reachable from normal USB operations and from suspend/resume.
  `xhci_setup_device()` is reachable during enumeration; suspend can
  interleave because it uses a different lock (`xhci->lock` vs
  `xhci->mutex`). Buggy path is realistically triggerable during system
  suspend on laptops/desktops with xHCI.

**Step 5.5 – Similar patterns**
- Record:
  - `xhci_urb_enqueue()` already checks `HCD_HW_ACCESSIBLE` (line 1658)
  - `xhci-hub.c` hub resume checks `HCD_HW_ACCESSIBLE` (line 1894)
  - `xhci_suspend()` early-returns if already inaccessible (line 980)
  - EHCI/OHCI/UHCI drivers check `HCD_HW_ACCESSIBLE` in hot paths
  - xhci command path was the outlier

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 – Buggy code present?**
- Record: **Yes.** Local tree is **v6.18.44** (`VERSION=6`,
  `PATCHLEVEL=18`, `SUBLEVEL=44`). `queue_command()` at lines 4383–4422
  lacks the `HCD_HW_ACCESSIBLE` check. `xhci_suspend()` clears the flag
  at lines 999–1001. Bug has existed since 2010-era suspend code.

**Step 6.2 – Backport complications**
- Record: Clean apply verified with `git apply --check`. No conflicting
  local changes expected.

**Step 6.3 – Related fixes already present?**
- Record: No equivalent fix found in local tree. `git log
  --grep="Prevent queuing new commands"` returns nothing. Fix is not yet
  in this 6.18.y tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 – Subsystem criticality**
- Record: `drivers/usb/host/xhci` — **IMPORTANT/CORE-adjacent**. xHCI is
  the standard USB3 host controller on virtually all modern PCs,
  laptops, and servers.

**Step 7.2 – Subsystem activity**
- Record: Actively maintained; recent local history shows multiple xhci
  suspend/resume and command-ring fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 – Who is affected**
- Record: All systems using xHCI (Intel, AMD, and most ARM platforms
  with xHCI). Config: `CONFIG_USB_XHCI_HCD`.

**Step 8.2 – Trigger conditions**
- Record:
  - System suspend / bus suspend while commands are in flight
  - Race between `xhci_setup_device()` / configure-endpoint paths and
    `xhci_suspend()`
  - Not easily triggered by unprivileged users directly, but common on
    every laptop suspend
  - Likelihood: moderate during suspend with active or completing USB
    operations

**Step 8.3 – Failure mode severity**
- Record:
  - Commands queued then lost when `xhci_clear_command_ring()` runs →
    `wait_for_completion()` timeouts
  - Doorbell `writel()` to inaccessible hardware → possible hang, failed
    suspend, or “host not responding” behavior
  - Severity: **HIGH** (suspend failure / hang), not merely cosmetic

**Step 8.4 – Risk vs benefit**
- Record:
  - Benefit: **HIGH** — prevents command submission to inaccessible
    hardware during suspend
  - Risk: **LOW** — 10-line, pattern-consistent guard returning existing
    error code
  - Ratio: strongly favorable

---

## Phase 9: Final Synthesis

**Evidence FOR backport**
- Real inconsistency: URB path guarded, command path was not
- Suspend/resume is a critical stable use case
- Fix is tiny, obviously correct, and applies cleanly to v6.18.44
- Failure mode can cause suspend hangs/timeouts
- Author is xhci maintainer; USB maintainer acked
- Standalone; no series dependencies
- Same HW_ACCESSIBLE infrastructure present since 2010

**Evidence AGAINST backport**
- No explicit user report, CVE, or syzbot hit in commit message
- Part of a larger feature series (though this hunk is independent)
- Diagnostic warning does not itself fix pending-command cleanup

**Unresolved questions**
- No quantitative data on how often the suspend warning fires in the
  field
- No independent Tested-by in the patch

**Stable rules checklist**
1. Obviously correct and tested? **PASS** — mirrors existing xhci
   checks; maintainer-reviewed
2. Fixes a real bug affecting users? **PASS** — suspend/command race is
   real and code-verified
3. Important issue? **PASS** — suspend hang/timeout, HIGH severity
4. Small and contained? **PASS** — 10 lines, 2 files
5. No new features or APIs? **PASS** — guard + warning only
6. Can apply to local tree? **PASS** — verified clean apply on v6.18.44

**Exception category:** N/A (not a device ID, quirk, DT, build, or docs-
only change)

---

## What Problem This Solves for Stable Users

During suspend, xhci marks hardware inaccessible via
`HCD_FLAG_HW_ACCESSIBLE` before stopping the controller and clearing the
command ring. Until this fix, the command-ring entry point did not honor
that flag, while URB submission already did. That gap allows commands to
be queued—and doorbells to be rung—against hardware being torn down,
which can leave callers waiting on completions that will never arrive
and can contribute to suspend failures. The fix aligns command
submission with the rest of the driver’s accessibility checks.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  lore mbox
- [Phase 2] Read `queue_command()` at lines 4383–4422 in
  `drivers/usb/host/xhci-ring.c`
- [Phase 2] Read `xhci_suspend()` at lines 961–1051 in
  `drivers/usb/host/xhci.c`
- [Phase 2] Read `xhci_ring_cmd_db()` at lines 420–433 — confirmed
  doorbell register access
- [Phase 2] Read `prepare_ring()` — software ring management; doorbell
  is separate
- [Phase 3] `git describe HEAD` → `v6.18.44`
- [Phase 3] `git blame` on `xhci_suspend()` HW_ACCESSIBLE clear → 2010
  commit `5535b1d5f88856`
- [Phase 3] `git blame` on `queue_command()` → core logic from
  2009–2016, no HW_ACCESSIBLE check
- [Phase 3] `git log --grep="Prevent queuing new commands"` → not in
  tree
- [Phase 4] `b4 mbox` fetched lore thread (21 messages) to
  `/tmp/xhci_b4/`
- [Phase 4] Extracted patch 12/15 body and cover letter from mbox
- [Phase 4] No stable nomination or NAK found for patch 12/15
- [Phase 5] `grep HCD_HW_ACCESSIBLE drivers/usb/host/xhci*` → present in
  `xhci.c` (lines 980, 1658) and `xhci-hub.c` (line 1894), absent from
  `xhci-ring.c`
- [Phase 5] Traced `xhci_setup_device()` — uses `mutex_lock`, not
  `spin_lock`; no HW_ACCESSIBLE check before
  `xhci_queue_address_device()`
- [Phase 5] Traced `xhci_urb_enqueue()` — checks `HCD_HW_ACCESSIBLE`
  under `xhci->lock`
- [Phase 6] Confirmed buggy code present in v6.18.44 checkout
- [Phase 6] `git apply --check` on reconstructed patch → **clean apply**
- [Phase 6] `git merge-base --is-ancestor b320937972d45 HEAD` →
  HW_ACCESSIBLE suspend infrastructure present
- [Phase 8] Assessed failure mode from suspend path calling
  `xhci_clear_command_ring()` with possible live `cmd_list` entries

**YES**

 drivers/usb/host/xhci-ring.c | 6 ++++++
 drivers/usb/host/xhci.c      | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 859680bc74a2c..c48bcc6cc958a 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4386,6 +4386,7 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 			 u32 field3, u32 field4, bool command_must_succeed)
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	int ret;
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
@@ -4395,6 +4396,11 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 		return -ESHUTDOWN;
 	}
 
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		xhci_warn(xhci, "Can't queue command, xHC not accessible\n");
+		return -ESHUTDOWN;
+	}
+
 	if (!command_must_succeed)
 		reserved_trbs++;
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 23b104c2956c7..9dc3ef8fcc67e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1002,6 +1002,10 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 	/* step 1: stop endpoint */
 	/* skipped assuming that port suspend has done */
 
+	/* Check if command ring is empty */
+	if (!list_empty(&xhci->cmd_list))
+		xhci_warn(xhci, "Suspending and stopping xHC with pending command!\n");
+
 	/* step 2: clear Run/Stop bit */
 	command = readl(&xhci->op_regs->command);
 	command &= ~CMD_RUN;
-- 
2.53.0

