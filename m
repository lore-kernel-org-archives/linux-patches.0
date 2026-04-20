Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B780D42883F;
	Mon, 20 Apr 2026 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691770; cv=none; b=Otz/1UuA6mxlHwJ6DiuudfbGVS6CMn/uwigN5sbkGiPgmbua58rAQsDxoGWWd97n6/uqPhzjz+pkfc5ACRCZEoiP2WaVjKq77RoZOmGcrA92pFogcanz4uzRaYN10UJ0/g5lVsUkTNCsAQ0cEMsQagwLvtCsBd7TMrYBLZCj59Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691770; c=relaxed/simple;
	bh=Z9CLPjPQmW71WT9UUYJtgYvMhTbrEDzc4hwt1KPPJN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UT8lNjSXtNHjeE45tL4MpuEspXSBW2cHs3EBnAvqJTzNNBJGnTIWFlsFyCubpsNStOrnnxHv5zkCN9ZP8Fw0P6NLfvSQHz8rYuyL+K4tFi48abzwH5JpJNojeX2EHFnV2TFKljvgcB3gwdgxb8sJMxsr3k97vuFEJYOzLuWQw8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mV6FZlWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mV6FZlWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C2C2BCB4;
	Mon, 20 Apr 2026 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691770;
	bh=Z9CLPjPQmW71WT9UUYJtgYvMhTbrEDzc4hwt1KPPJN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mV6FZlWBfyby0uJfZgUXY/Cq+G7KqCttVLBhshuHYuywarcOv6aNyl7/8ZWrVflMd
	 d/EEJpvr9BLnTosUR+WCnEono7/IJ5qtDKL0qMhlcqA3NJyZxX2jqkjvBeoBtkd7Lh
	 hQRy/iWmUjc3HiQsOHz3sDgWtYmxz4TzWzJeqBKTNaTd8Ogvjs6Eksb4O0ejfpMOBV
	 Y4pER8O0pYvoKGJW8hJfcB5RQo+e6vepIXQRYtbQNW2+e0UNhur3lf/ErZOFroBsLb
	 xn8bfGwvH1e3EzDMJ08JaSaSy+Wm9NZIb7h/sKEgmricr6neyxpuxFcEvweXGwBtSS
	 Qdtelu+K5JFPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Richter <Simon.Richter@hogyros.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] PCI/VGA: Pass vga_get_uninterruptible() errors to userspace
Date: Mon, 20 Apr 2026 09:19:37 -0400
Message-ID: <20260420132314.1023554-183-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Richter <Simon.Richter@hogyros.de>

[ Upstream commit 2a93c9851b2bb38614fadd84aa674b7a5c8181c6 ]

If VGA routing cannot be established, vga_get_uninterruptible() returns an
error and does not increment the lock count. Return the error to the
caller.

Return before incrementing uc->io_cnt/mem_cnt so vga_arb_release() won't
call vga_put() when userspace closes the handle.

Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260307173538.763188-2-Simon.Richter@hogyros.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: PCI/VGA
- **Action verb**: "Pass" (implies a fix for missing error propagation)
- **Summary**: Pass error return from `vga_get_uninterruptible()` back
  to userspace instead of silently ignoring it.
- Record: [PCI/VGA] [pass/fix] [Propagate vga_get_uninterruptible()
  error to userspace callers]

### Step 1.2: Tags
- `Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>` — patch
  author
- `[bhelgaas: commit log]` — Bjorn Helgaas (PCI subsystem maintainer)
  edited the log
- `Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>` — committed by
  the PCI subsystem maintainer
- `Link: https://patch.msgid.link/20260307173538.763188-2-
  Simon.Richter@hogyros.de`
- No Fixes: tag, no Cc: stable, no Reported-by. This is expected.
- Record: Maintainer-committed. Message-id `-2-` suggests this may be
  part of a series.

### Step 1.3: Body Text
The message clearly states two bugs:
1. When `vga_get_uninterruptible()` fails, the error is silently dropped
   — userspace isn't told the lock failed.
2. Even on failure, `uc->io_cnt/mem_cnt` are incremented, causing
   spurious `vga_put()` calls in `vga_arb_release()`.

Record: Bug = ignored error return leads to false success report to
userspace AND unbalanced lock counters. Failure mode = userspace
believes it holds VGA locks it doesn't actually hold.

### Step 1.4: Hidden Bug Fix?
This is an explicit bug fix — the commit describes two concrete problems
and the fix for each.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`drivers/pci/vgaarb.c`)
- **Lines added**: ~5 (new `int err;` variable, error check, and early
  return)
- **Functions modified**: `vga_arb_write()` (the "lock" command handler)
- **Scope**: Single-file, single-function surgical fix.

### Step 2.2: Code Flow Change
**Before**: `vga_get_uninterruptible()` is called, return value
discarded, code unconditionally increments user counters and returns
`count` (success).

**After**: Return value is captured in `err`. If non-zero, the function
returns the error code to userspace via `goto done`, skipping the
counter increments.

### Step 2.3: Bug Mechanism
This is a **logic/correctness fix** combined with a **reference counting
fix**:
- `vga_get()` returns `-ENODEV` when the VGA device is removed from the
  list (e.g., hot-unplug between target check and lock attempt)
- Ignoring this error means userspace thinks it holds a VGA lock when it
  doesn't
- The unbalanced counters cause `vga_arb_release()` (lines 1424-1427) to
  call `vga_put()` for locks never acquired (though `__vga_put()`'s `>0`
  guards prevent underflow)

### Step 2.4: Fix Quality
- Obviously correct: standard error-checking pattern
- Minimal/surgical: 5 lines, single hunk in the "lock" handler
- No regression risk: the only change is to return error early rather
  than continuing
- No API or behavior change: callers of `vga_arb_write()` already handle
  error returns

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy line (`vga_get_uninterruptible(pdev, io_state);` at line 1168)
was introduced in commit `deb2d2ecd43dfc` by Benjamin Herrenschmidt on
2009-08-11, the original VGA arbitration implementation. This is kernel
v2.6.32-rc1 era code, present in **all** active stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected for a manually reviewed candidate).

### Step 3.3: File History
Recent changes to `vgaarb.c` are mostly refactoring/cleanup (VGA device
selection, typo fixes, simplifications). None touch the "lock" command
handler in `vga_arb_write()`.

### Step 3.4: Author
Simon Richter has other PCI-related commits (BAR resize fixes). Bjorn
Helgaas (PCI maintainer) committed this, which indicates it was reviewed
and accepted through the proper PCI maintainer tree.

### Step 3.5: Dependencies
The message-id `-2-` suggests this is patch 2 in a series, but the fix
is entirely self-contained. It only adds error checking to an existing
call. No structural dependencies on other patches.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.2: Original Patch
b4 dig could not find a match by the message-id directly. Lore was
inaccessible. However, the commit was signed off by Bjorn Helgaas (PCI
maintainer), indicating proper review.

### Step 4.3-4.5: Bug Report / Stable Discussion
No bug report links. No syzbot reference. This appears to be a code-
review-discovered issue.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
`vga_arb_write()` — the write handler for `/dev/vga_arbiter`.

### Step 5.2: Callers
`vga_arb_write()` is registered as the `.write` callback in
`vga_arb_device_fops` (line 1498). It's called when userspace writes to
`/dev/vga_arbiter`. This is the main userspace interface for the VGA
arbiter, used by X servers and display managers on multi-GPU systems.

### Step 5.3-5.4: Call Chain
Userspace → `write(fd, "lock io+mem", ...)` → `vga_arb_write()` →
`vga_get_uninterruptible()` → `vga_get()`. The error path is directly
reachable from userspace.

### Step 5.5: Similar Patterns
The i915 driver also ignores `vga_get_uninterruptible()` return values
(lines 68, 93 in `intel_vga.c`), but those are kernel-internal callers
where the consequences differ.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code Existence
The buggy code has been present since v2.6.32 (2009). It exists in
**all** active stable trees (5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y,
6.12.y).

### Step 6.2: Backport Complications
The surrounding code in the "lock" handler has not changed significantly
since the original commit. The patch should apply cleanly. The only
nearby changes are comment fixes (`cc64ca4b62f50` in 2023).

### Step 6.3: Related Fixes
No other fix for this issue exists in any stable tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
PCI/VGA arbiter — **IMPORTANT** level. Used by all systems with VGA
devices and userspace display servers (X11, Wayland compositors). Multi-
GPU systems (common in desktop/workstation use) depend on correct VGA
arbitration.

### Step 7.2: Subsystem Activity
Moderately active — periodic cleanups and improvements, but core logic
is mature.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users with multi-GPU systems or systems where VGA device hot-unplug can
occur. Includes desktop/workstation users running X servers or other VGA
arbitration clients.

### Step 8.2: Trigger Conditions
- VGA device hot-unplug while userspace holds a reference via
  `/dev/vga_arbiter`
- The window is a race between target check and `vga_get()`, so it's
  timing-dependent
- Unprivileged user with access to `/dev/vga_arbiter` can trigger this

### Step 8.3: Failure Mode Severity
- **Userspace is told lock succeeded when it didn't**: MEDIUM — could
  lead to concurrent VGA resource access, potentially causing display
  corruption or GPU conflicts
- **Unbalanced counters**: LOW — `__vga_put()` has `>0` guards
  preventing counter underflow, though spurious wake-ups may occur
- Overall severity: **MEDIUM**

### Step 8.4: Risk-Benefit
- **Benefit**: Correct error propagation to userspace; prevents VGA
  resource conflicts on multi-GPU systems
- **Risk**: Very low — 5-line change adding standard error checking
- **Ratio**: Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a real correctness bug: userspace is lied to about VGA lock
  acquisition
- Fixes unbalanced reference counting on the cleanup path
- Small, surgical fix (5 lines, single function)
- Obviously correct: standard error-checking pattern
- Committed by PCI subsystem maintainer (Bjorn Helgaas)
- Bug present since v2.6.32 — affects all stable trees
- Self-contained, no dependencies on other patches
- Should apply cleanly to all stable trees

**AGAINST backporting:**
- The trigger window is a race condition (timing-dependent)
- No reported real-world incidents (code-review-found issue)
- The consequences are somewhat mitigated by `__vga_put()`'s `>0` guards

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — trivial error-checking
   pattern, committed by maintainer
2. Fixes a real bug? **YES** — incorrect error reporting to userspace +
   unbalanced counters
3. Important issue? **MEDIUM** — resource conflict possible but
   mitigated in practice
4. Small and contained? **YES** — 5 lines in one function
5. No new features/APIs? **YES** — no new features
6. Can apply to stable? **YES** — code unchanged since 2009

### Step 9.3: Exception Categories
Not an exception category; evaluated on its own merit as a bug fix.

### Step 9.4: Decision
This is a clear correctness fix: error values from
`vga_get_uninterruptible()` must be propagated to userspace rather than
silently swallowed. The fix is minimal, obviously correct, committed by
the subsystem maintainer, and applies to all stable trees. Despite the
trigger being race-dependent, the fix prevents both misleading userspace
and unbalanced lock accounting.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author and PCI maintainer,
  Link to lore, no Fixes/Reported-by/Cc:stable (expected)
- [Phase 2] Diff analysis: 5 lines added in the "lock" handler of
  `vga_arb_write()` — captures return value of
  `vga_get_uninterruptible()`, returns error before incrementing
  counters
- [Phase 3] git blame: buggy code introduced in commit deb2d2ecd43dfc
  (v2.6.32-rc1, 2009), present in all stable trees
- [Phase 3] git describe: `v2.6.32-rc1~670^2~52` confirms the original
  commit is in all active stable trees
- [Phase 3] git log: no recent changes to the "lock" handler code path,
  ensuring clean backport
- [Phase 4] b4 dig -c deb2d2ecd43dfc: found original VGA arbitration
  patch from 2009
- [Phase 4] lore inaccessible due to anti-scraping protection
- [Phase 5] `vga_get_uninterruptible` returns `int` (verified in
  include/linux/vgaarb.h lines 92-96), wrapping `vga_get()` which
  returns -ENODEV on failure
- [Phase 5] `vga_arb_release()` (lines 1418-1428): confirms `vga_put()`
  is called for each `io_cnt`/`mem_cnt`, creating unbalanced puts if
  counters were wrongly incremented
- [Phase 5] `__vga_put()` (lines 378-381): confirmed `>0` guards exist,
  preventing counter underflow
- [Phase 5] `vga_get()` (lines 434-483): confirmed `-ENODEV` is the only
  error possible for uninterruptible calls
- [Phase 6] Code unchanged in the "lock" handler since v2.6.32; should
  apply cleanly to all stable trees
- [Phase 7] PCI/VGA arbiter is used by display servers on multi-GPU
  systems
- UNVERIFIED: Could not access lore to check full patch series context
  or reviewer feedback

**YES**

 drivers/pci/vgaarb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index d9383bf541e7c..22b2b6ebdefdb 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -1134,6 +1134,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user *buf,
 	char kbuf[64], *curr_pos;
 	size_t remaining = count;
 
+	int err;
 	int ret_val;
 	int i;
 
@@ -1165,7 +1166,11 @@ static ssize_t vga_arb_write(struct file *file, const char __user *buf,
 			goto done;
 		}
 
-		vga_get_uninterruptible(pdev, io_state);
+		err = vga_get_uninterruptible(pdev, io_state);
+		if (err) {
+			ret_val = err;
+			goto done;
+		}
 
 		/* Update the client's locks lists */
 		for (i = 0; i < MAX_USER_CARDS; i++) {
-- 
2.53.0

