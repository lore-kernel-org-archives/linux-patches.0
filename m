Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B3253FD23;
	Mon, 31 Aug 2026 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183953; cv=none; b=dQEkGkHcIuSZtAAnGZWyRAOMlsUSIwhV1kQUiaFgvCzjqUNv7ymbx+5X7t4NQ3RZ/F7/sgebJ4BKmQEeFGTLqhAsPilD+C5N+djqHcv1+kJ+pcyDv/kJ9A6EAjcphHMPrHclexRq828iT/ngV4s8ksEHuet3F8Hly2TpY025BbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183953; c=relaxed/simple;
	bh=9LQ3iqtyQgQ6YSeJ7PjYzHzpcWURz9cYe4Nb079KxI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jeb8/I5DcxAg887jy/mExZ65itwBa8+ftpIuyZGwDl037O0Z8kwcUsiv6oa5FlQcvHEDL7byDqPvQTGK/dH3I+E9f9M8lOtX3q80KBw9TIkdqNsICXlqb2Wz9XF/4VhfcVArdbNlkm3sq1gdWQ4/3aRtda0mjazWhcIjdXyeCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDVltKKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDVltKKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA531F00ACF;
	Mon, 31 Aug 2026 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183949;
	bh=6RK013iRq29/IgXuqW7jB7bdykYBv+AyjOhCZOP2yrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDVltKKFv9FeJN9DGzH9Sh4P5K700O4KIf24AyuHnbzq5SHOViQld7Ov8MnBEVSsm
	 AznH7AdAEuAT6pKRdwj7hVjmc3ma5CeEXK41VFP8y7rnz+4iIEWmvOVu9YEcLzmjEM
	 kO5FVmTXqgdG6uSitfetgxKasUqZdQJr950rG8Aur3OjkVnHXxDZN3oK9SS3+xZmZD
	 dy8YFFiFdlOmuefmLMgyqZu4Oqy+NRF5fYcfN/pdBuQj5LwUn6VswWHblTIZvalPEP
	 tElma18gV11zhAIFLH/Uk3sr/LRJB0OG2qkGukIqpiElrPUokB3qO5LcO4ZZWMfgGQ
	 dO33w/IPnuXtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] genirq/manage: Make NMI cleanup RT safe
Date: Mon, 31 Aug 2026 09:27:07 -0400
Message-ID: <20260831133314.4125787-399-sashal@kernel.org>
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

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 3ba92f6a28203e30d0b2c7d75b59f48d5ff9fbcc ]

Eventually blocking functions cannot be invoked with interrupts disabled
and a raw spin lock held. Restructure the code so this happens outside of
the descriptor lock held region.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/20260517194931.601972758@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[genirq/manage]` `[Make]` — Make NMI cleanup RT safe;
restructure `__cleanup_nmi()` so blocking work is not done under
`desc->lock`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Thomas Gleixner `<tglx@kernel.org>` (irq
  maintainer)
- **Tested-by:** Michael Kelley `<mhklinux@outlook.com>`
- **Link:** https://patch.msgid.link/20260517194931.601972758@kernel.org
- No Fixes:, Reported-by:, Reviewed-by:, Acked-by:, or Cc: stable
- Mainline commit: `3ba92f6a28203e30d0b2c7d75b59f48d5ff9fbcc` (not in
  this tree)

### Step 1.3: Body analysis
**Record:**
- **Bug:** Blocking functions must not run with interrupts disabled and
  a raw spinlock held (PREEMPT_RT rule).
- **Symptom:** RT lockdep splats / “sleeping function called from
  invalid context” on NMI teardown.
- **Root cause:** `__cleanup_nmi()` called `unregister_handler_proc()`
  (→ `proc_remove()` → `proc_entry_rundown()` → `wait_for_completion()`)
  while `desc->lock` was held via `free_nmi()`’s guard or
  `request_nmi()`’s `scoped_guard`.
- **Version info:** Patch V6 09/16 of Thomas Gleixner’s irq/RT
  validation series; “Found when adding the validation update.”

### Step 1.4: Hidden bug fix?
**Record:** Yes — not cosmetic. It fixes an RT correctness violation and
a potential deadlock when `/proc/irq/...` handlers are open during NMI
teardown.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `kernel/irq/manage.c` only (+21 / −16 lines)
- **Functions:** `__cleanup_nmi()`, `free_nmi()`, `request_nmi()`
- **Scope:** Single-file, surgical

### Step 2.2: Code flow per hunk

**`__cleanup_nmi()`:**
- **Before:** Assumed caller held `desc->lock`; ran
  `unregister_handler_proc()` and `kfree()` under that lock.
- **After:** Takes its own `scoped_guard(raw_spinlock_irqsave,
  &desc->lock)` for irq state teardown; moves
  `unregister_handler_proc()` and `kfree()` outside the lock.

**`free_nmi()`:**
- **Before:** `guard(raw_spinlock_irqsave)` + `irq_nmi_teardown()` then
  `__cleanup_nmi()` — lock held for entire cleanup including blocking
  paths.
- **After:** Only calls `__cleanup_nmi()`, which manages locking
  internally (also moves `irq_nmi_teardown()` inside `__cleanup_nmi()`’s
  guard).

**`request_nmi()` error path:**
- **Before:** On `irq_nmi_setup()` failure, called `__cleanup_nmi()`
  inside `scoped_guard` (lock still held).
- **After:** Exits `scoped_guard` first, then calls `__cleanup_nmi()` on
  failure.

### Step 2.3: Bug mechanism
**Record:** **Category:** RT atomic-context / lock-ordering violation;
potential deadlock.
- `unregister_handler_proc()` → `proc_remove()` →
  `remove_proc_subtree()` unlocks `proc_subdir_lock` before
  `proc_entry_rundown()`, which can call `wait_for_completion()` — a
  blocking primitive.
- That runs while `desc->lock` (raw, IRQs off) is still held from
  `free_nmi()` / `request_nmi()`.
- Mirrors the established `__free_irq()` pattern (unlock before
  `unregister_handler_proc()` at lines 1869–1886).

### Step 2.4: Fix quality
**Record:** Obviously correct; minimal; low regression risk. Aligns NMI
cleanup with normal IRQ cleanup. `action` pointer saved under lock, proc
unregister and `kfree` deferred until after unlock — safe because
`desc->action` is already NULL.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `__cleanup_nmi()` with `unregister_handler_proc()` under
lock is present in this tree. Function exists in `v6.6`, `v6.10`,
`v6.18`, and current `HEAD` (verified via `git show
<tag>:kernel/irq/manage.c`). Stable-tree `git blame` is unreliable
(shallow history attributes lines to unrelated commits).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Fix commit `3ba92f6a2820` exists in object DB but `git
merge-base --is-ancestor` returns exit 1 — **not merged into this
6.18.44 tree**. Part of irq/RT validation series (patch 09/16) but this
hunk is self-contained in `manage.c`.

### Step 3.4: Author context
**Record:** Thomas Gleixner is irq/RT maintainer. `Tested-by: Michael
Kelley` indicates RT testing.

### Step 3.5: Dependencies
**Record:** No prerequisites in this tree. `scoped_guard` exists
(`include/linux/cleanup.h`). `git apply --check` of mainline commit
succeeds cleanly on current tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lkml.iu.edu/hypermail/linux/kernel/2605.2/01539.html
  (V6 09/16)
- **Series:** irq/RT validation, patch 09/16
- **Note:** “V4: New patch. Found when adding the validation update” —
  proactive RT validation finding, not a user crash report
- No NAKs found in fetched content; no explicit stable nomination seen

### Step 4.2: Reviewers
**Record:** `b4 dig -c 3ba92f6a2820` matched lore thread
`20260517194931.601972758@kernel.org`. V4 CC list included x86
maintainers, Marc Zyngier, Jan Kiszka (RT), and others. Full `-w` output
truncated by b4 thread-parsing warnings.

### Step 4.3: Bug reports
**Record:** No syzbot, bugzilla, or user crash reports. Found during RT
lock validation.

### Step 4.4: Series context
**Record:** One patch in a 16-patch irq/RT series; this change is
standalone for `manage.c` and does not depend on other series patches.

### Step 4.5: Stable list
**Record:** Not searched separately; no stable-list nomination found in
patch thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `__cleanup_nmi()`, `free_nmi()`, `request_nmi()`,
`unregister_handler_proc()`

### Step 5.2: Callers
**Record:**
- `free_nmi()` / `request_nmi()` are exported; in-tree callers:
  - `drivers/perf/arm_pmu.c` — ARM PMU NMI perf events (common on ARM
    servers/embedded)
  - `drivers/soc/fujitsu/a64fx-diag.c` — Fujitsu A64FX diagnostics
- Callable from module unload / driver probe error paths (process
  context, but historically under irq lock)

### Step 5.3: Callees
**Record:** Under lock: `irq_nmi_teardown()`, `irq_pm_remove_action()`,
`irq_shutdown_and_deactivate()`. Outside lock:
`unregister_handler_proc()` → `proc_remove()` → `proc_entry_rundown()`
(`wait_for_completion()`), `kfree()`, `irq_release_resources()`,
`irq_chip_pm_put()`, `module_put()`.

### Step 5.4: Reachability
**Record:** Triggered on `free_nmi()` (module remove, PMU teardown) or
`request_nmi()` setup failure. Requires `CONFIG_PREEMPT_RT` for
guaranteed RT splat; deadlock risk also exists if
`/proc/irq/N/smp_affinity` or similar is open during teardown
(`proc_entry_rundown()` waits for openers).

### Step 5.5: Similar patterns
**Record:** `__free_irq()` already unlocks before
`unregister_handler_proc()` and `__synchronize_irq()`. NMI path was
inconsistent.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `kernel/irq/manage.c` lines 1990–2033 show
the buggy pattern (`unregister_handler_proc()` under lock). Present
since at least v6.6 in this repository.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` of `3ba92f6a2820`
passes with no conflicts. `scoped_guard` already used elsewhere in this
file.

### Step 6.3: Related fixes already present?
**Record:** **No** — `git log --grep="NMI cleanup"` on HEAD returns
nothing.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** **kernel/irq (genirq)** — CORE subsystem. Affects interrupt
management for all platforms using generic IRQ core.

### Step 7.2: Activity
**Record:** Active; PREEMPT_RT is a first-class option in 6.18
(`kernel/Kconfig.preempt`, `config PREEMPT_RT`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of `request_nmi()` / `free_nmi()` — primarily ARM PMU
(`arm_pmu`) and Fujitsu A64FX. Impact is config-specific
(`CONFIG_PREEMPT_RT` for RT splat) but irq core code is widely shared.

### Step 8.2: Trigger conditions
**Record:**
- Unload/teardown of NMI-based perf monitoring or A64FX diag driver
- Or `request_nmi()` failure during probe
- Worse if `/proc/irq/...` entries have active openers
- Not syscall-triggerable by unprivileged users directly; driver/module
  lifecycle paths

### Step 8.3: Failure mode severity
**Record:**
- PREEMPT_RT: **HIGH** — lockdep/RT splat, “sleeping function called
  from invalid context”
- With proc openers: **HIGH** — potential deadlock
  (`wait_for_completion()` while holding `desc->lock`)
- Non-RT without openers: often latent (may not trigger in practice)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for RT and PMU users; prevents hang/crash on
  legitimate teardown paths
- **Risk:** VERY LOW — 37-line change, mirrors proven `__free_irq()`
  pattern, tested, applies cleanly
- **Ratio:** Strong benefit for RT; minimal risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real RT correctness bug in core irq code
- Potential deadlock via `proc_entry_rundown()` under irq lock
- Small, surgical, obviously correct fix from irq maintainer
- Applies cleanly to 6.18.44
- Buggy code confirmed present in this tree since v6.6+
- PREEMPT_RT supported in 6.18
- Tested-by present
- Matches existing `__free_irq()` design

**AGAINST backport:**
- Narrow trigger surface (NMI irq users only)
- No production crash reports — found during RT validation
- Only fully enforced on `CONFIG_PREEMPT_RT` builds
- Part of larger irq/RT series (but this patch is standalone)

**Unresolved:** Exact commit that introduced `__cleanup_nmi()` not
identified (pickaxe search inconclusive in shallow stable history).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors `__free_irq()`;
   Tested-by Michael Kelley
2. Fixes a real bug? **PASS** — RT atomic-context violation; verified
   blocking in `proc_entry_rundown()`
3. Important issue? **PASS** — deadlock / RT splat (HIGH severity on
   affected paths)
4. Small and contained? **PASS** — 1 file, ~37 lines
5. No new features/APIs? **PASS** — restructuring only
6. Can apply to local tree? **PASS** — clean `git apply --check`

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

For **Linux 6.18.44** (this checkout): the buggy NMI cleanup path is
present, PREEMPT_RT is supported, and the fix prevents a verified RT
lock violation and possible deadlock during `free_nmi()` /
`request_nmi()` error cleanup. The change is minimal, applies cleanly,
and follows the established pattern already used in `__free_irq()`.
While the trigger is narrower than a core syscall path, irq teardown
deadlocks and RT splats are exactly the class of fixes stable trees
carry.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit and
  `git show 3ba92f6a2820`
- [Phase 2] Read current `kernel/irq/manage.c` lines 1990–2295; read
  `fs/proc/generic.c` `proc_remove()` / `remove_proc_subtree()`; read
  `fs/proc/inode.c` `proc_entry_rundown()` (`wait_for_completion`)
- [Phase 3] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 3] `git cat-file -t 3ba92f6a2820` → commit exists; `git merge-
  base --is-ancestor 3ba92f6a2820 HEAD` → exit 1 (not in tree)
- [Phase 3] `git apply --check` of mainline patch → clean apply
- [Phase 3] Verified `__cleanup_nmi` in v6.6, v6.10, v6.18, HEAD via
  `git show <tag>:kernel/irq/manage.c`
- [Phase 4] `b4 dig -c 3ba92f6a2820` → lore thread
  `20260517194931.601972758@kernel.org`
- [Phase 4] Fetched
  https://lkml.iu.edu/hypermail/linux/kernel/2605.2/01539.html — V6
  09/16, “Found when adding the validation update”
- [Phase 5] `grep request_nmi/free_nmi` in drivers → `arm_pmu.c`,
  `a64fx-diag.c`
- [Phase 5] Verified `__free_irq()` unlock-before-proc pattern at lines
  1869–1886
- [Phase 6] Confirmed buggy code at lines 1997–2000 in current tree
- [Phase 6] `grep scoped_guard` in `include/linux/cleanup.h` — present
- [Phase 7] `grep PREEMPT_RT` in `kernel/Kconfig.preempt` — present
- [Phase 8] Traced `unregister_handler_proc` → `proc_remove` →
  `proc_entry_rundown` → `wait_for_completion`
- **UNVERIFIED:** Exact introduction commit for `__cleanup_nmi` (stable-
  tree pickaxe/blame unreliable)
- **UNVERIFIED:** Reviewer stable nominations in full lore thread (b4
  `-w` output truncated)

**YES**The background `b4 dig` run failed at first (wrong invocation,
then a long hang), but a retry with `b4 dig -c
3ba92f6a28203e30d0b2c7d75b59f48d5ff9fbcc` succeeded and matched the lore
thread at `20260517194931.601972758@kernel.org`.

That confirmed the patch context: irq/RT validation series (V6 09/16),
authored by Thomas Gleixner, with `Tested-by: Michael Kelley`. The
analysis conclusion is unchanged — this should be backported to the
6.18.44 tree.

**YES**

 kernel/irq/manage.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c09751b7a0c49..881d95c5af64d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1987,24 +1987,30 @@ const void *free_irq(unsigned int irq, void *dev_id)
 }
 EXPORT_SYMBOL(free_irq);
 
-/* This function must be called with desc->lock held */
 static const void *__cleanup_nmi(unsigned int irq, struct irq_desc *desc)
 {
+	struct irqaction *action = NULL;
 	const char *devname = NULL;
 
-	desc->istate &= ~IRQS_NMI;
+	scoped_guard(raw_spinlock_irqsave, &desc->lock) {
+		irq_nmi_teardown(desc);
 
-	if (!WARN_ON(desc->action == NULL)) {
-		irq_pm_remove_action(desc, desc->action);
-		devname = desc->action->name;
-		unregister_handler_proc(irq, desc->action);
+		desc->istate &= ~IRQS_NMI;
 
-		kfree(desc->action);
+		if (!WARN_ON(desc->action == NULL)) {
+			action = desc->action;
+			irq_pm_remove_action(desc, action);
+			devname = action->name;
+		}
 		desc->action = NULL;
+
+		irq_settings_clr_disable_unlazy(desc);
+		irq_shutdown_and_deactivate(desc);
 	}
 
-	irq_settings_clr_disable_unlazy(desc);
-	irq_shutdown_and_deactivate(desc);
+	if (action)
+		unregister_handler_proc(irq, action);
+	kfree(action);
 
 	irq_release_resources(desc);
 
@@ -2028,8 +2034,6 @@ const void *free_nmi(unsigned int irq, void *dev_id)
 	if (WARN_ON(desc->depth == 0))
 		disable_nmi_nosync(irq);
 
-	guard(raw_spinlock_irqsave)(&desc->lock);
-	irq_nmi_teardown(desc);
 	return __cleanup_nmi(irq, desc);
 }
 
@@ -2279,13 +2283,14 @@ int request_nmi(unsigned int irq, irq_handler_t handler,
 		/* Setup NMI state */
 		desc->istate |= IRQS_NMI;
 		retval = irq_nmi_setup(desc);
-		if (retval) {
-			__cleanup_nmi(irq, desc);
-			return -EINVAL;
-		}
-		return 0;
 	}
 
+	if (retval) {
+		__cleanup_nmi(irq, desc);
+		return -EINVAL;
+	}
+	return 0;
+
 err_irq_setup:
 	irq_chip_pm_put(&desc->irq_data);
 err_out:
-- 
2.53.0

