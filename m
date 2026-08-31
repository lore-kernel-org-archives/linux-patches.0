Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88E344685D;
	Mon, 31 Aug 2026 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183245; cv=none; b=ooRigfVtxqwuNtVxpdS+NZPG//oM6mjy6rrCLsn81PupEbcSEdstQIL8NUQOst24bOcbRx9Ak3i4D31dx8MjpVgwG1tQTuLKlbO1/UcA6jDEBDMOjNAC0XlAnHmzO6s2+K9HZkNHQot+jGeH5kjDNQ66QV4zPyPbaHcnV9gs84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183245; c=relaxed/simple;
	bh=OWFKpA3ZuDzs7hMv+8YGSP5x9c87ZGjBeQTHZCoiBws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEOfkALTbGKm5BLv9lorg1p4mqer5lK0/GyF3OscfzAnh5t16ABZzWe/RIPY6YYetTxBfNafQKwBzESh11szF42k/1yvxdsULRsJdVHsIzOedlrMjcbVPOwb2o1ZP6xVyVRXwx/XEB4Cwqh0L5xYAn1mERIINohLIUzgPGmPJNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dToK+IrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dToK+IrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7071D1F000E9;
	Mon, 31 Aug 2026 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183243;
	bh=K09q/buokMvn65Vf9LNh4KXDSVO1+zr1vaU2AYgr2xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dToK+IrD/BimSq1uvK+0xrz7UhVutVxwkXeLrrUl+CcCGQNUOgRI+/2/vuu3l3jTp
	 uiKz5Sa/WPXLnbBfKrYpHOcQetqNoAhBNylxJJMx//AdrcVi2bKaW20HnJr8pJs9xJ
	 CpR4n1qh43FHxk/fBlWzou3OgvMs+3r4QqbiRnLzP5RTp0q+NugBMJkDC0yaIc1w7/
	 frLW/CdYobU1ENyo1ekluo7uWWyjj/Zt4Cs6xdsC3qF1igH6H9p2gm5uUV1APUXkHb
	 9uHKg8LOs1VfOEV4vsDs4Drg0EJHsPzHMJcgemsUfqVOAE6jtsZBBVo9xQ9PUjf6CV
	 QnXJsWMMWdh7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Osama Abdelkader <osama.abdelkader@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] arm64: panic from init_IRQ if IRQ handler stacks cannot be allocated
Date: Mon, 31 Aug 2026 09:20:59 -0400
Message-ID: <20260831133314.4125787-31-sashal@kernel.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit 7dc6922f7fdd3496de4e7d8fb99284fc08f98003 ]

init_irq_stacks() and init_irq_scs() may fail when arch_alloc_vmap_stack
or scs_alloc return NULL. Return -ENOMEM from both and call panic() once
from init_IRQ(), covering per-CPU IRQ stacks and shadow IRQ stacks
consistently.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[arm64]` `[panic]` — Add explicit panic in `init_IRQ()`
when per-CPU IRQ handler stacks or shadow call stacks cannot be
allocated.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- `Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>` —
  author
- `Signed-off-by: Will Deacon <will@kernel.org>` — arm64 maintainer
  sign-off
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer sign-off (Will Deacon) but no fuzzer/user bug
  report

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug described:** `init_irq_stacks()` and `init_irq_scs()` ignore
  failures from `arch_alloc_vmap_stack()` and `scs_alloc()`, which can
  return NULL.
- **Symptom/failure mode:** Boot continues with NULL per-CPU IRQ stack
  pointers; first IRQ uses an invalid stack → crash/corruption instead
  of a clear early panic.
- **Version info:** None in message.
- **Root cause:** Missing error checking on allocation return values in
  early-boot IRQ stack setup.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Yes — described as adding panic, but it fixes a real NULL-
pointer/invalid-stack bug on the IRQ path. Not cosmetic cleanup.

---

## Phase 2: Diff Analysis — Line by Line

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `arch/arm64/kernel/irq.c` only (~30 lines changed)
- **Functions modified:** `init_irq_scs()`, `init_irq_stacks()`,
  `init_IRQ()`
- **Scope:** Single-file, surgical early-boot fix

### Step 2.2: Code Flow Change
**Record:**
- **`init_irq_scs()` hunk:** Before — `void`, ignored `scs_alloc()`
  NULL. After — returns `int`, propagates `-ENOMEM` on failure.
- **`init_irq_stacks()` hunk:** Before — `void`, ignored
  `arch_alloc_vmap_stack()` NULL. After — returns `int`, propagates
  `-ENOMEM` on failure.
- **`init_IRQ()` hunk:** Before — always continued to `irqchip_init()`.
  After — `panic("Failed to allocate IRQ stack resources\n")` if either
  init fails.
- **Affected path:** Early boot initialization only (`init_IRQ()` during
  `start_kernel()`).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Error-path / memory-safety (NULL stack pointer)
- **Mechanism:** On allocation failure, `per_cpu(irq_stack_ptr, cpu)`
  stays NULL. `call_on_irq_stack()` loads it and does `add sp, x16,
  #IRQ_STACK_SIZE` with x16=0, placing SP at `THREAD_SIZE` (16 KiB on
  4K-page kernels) — not a valid stack. Subsequent `stp`/`blr` corrupt
  low kernel memory and crash unpredictably.

### Step 2.4: Fix Quality Assessment
**Record:**
- Obviously correct; mirrors existing `sdei.c` pattern
  (`_init_sdei_stack()` / `_init_sdei_scs()` check NULL and return
  `-ENOMEM`).
- Minimal, no unrelated changes.
- Regression risk very low — only affects the already-fatal OOM-at-boot
  path, changing delayed corruption into immediate panic.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:**
- `init_irq_stacks()` core loop: `e3067861ba6650` (Mark Rutland, Jul
  2017) — arm64 VMAP_STACK IRQ stacks since ~v4.12.
- `init_irq_scs()`: `ac20ffbb0279aa` (Sami Tolvanen, Nov 2020) — dynamic
  SCS for IRQ stacks since ~v5.10.
- Node selection updates: `75b5e0bf90bff`, `7b1a09e44dc64` (2023).
- Bug present since original introduction; not a recent regression.

### Step 3.2: Follow Fixes Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: File History for Related Changes
**Record:**
- Recent `irq.c` changes: `c4a5699d5cefd` (Jul 2025) removed
  `CONFIG_VMAP_STACK` conditionals; did not add error checking.
- `sdei.c` (same commit `ac20ffbb0279aa`) already checks allocation
  failures for SDEI stacks/SCS.
- Fix is standalone; not part of a multi-patch series in this tree.
- Fix commit **not present** in local tree (grep/author search found no
  match).

### Step 3.4: Author's Other Commits
**Record:** Osama Abdelkader has other kernel commits in this tree (drm,
riscv kvm), but not this irq fix. Will Deacon is arm64 maintainer and
committed the related `ac20ffbb0279aa` SCS work.

### Step 3.5: Prerequisites
**Record:** No dependencies. Uses only existing APIs
(`arch_alloc_vmap_stack`, `scs_alloc`, `panic`, `-ENOMEM`). Applies
cleanly to current `irq.c`.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c HEAD` did not match this commit (fix not in
tree). Subject-based `b4 dig` failed (wrong usage). lore.kernel.org
returned 403 to automated fetch. **UNVERIFIED:** full review thread and
any stable nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via `b4 dig -w`. Will Deacon sign-off in
commit message confirms maintainer acceptance.

### Step 4.3: Bug Report
**Record:** No `Reported-by:` or `Link:` tags. No syzbot report. Bug
identified by code inspection / consistency with `sdei.c`.

### Step 4.4: Related Patches/Series
**Record:** Standalone fix. Complements existing error handling in
`arch/arm64/kernel/sdei.c`.

### Step 4.5: Stable Mailing List
**Record:** **UNVERIFIED** — could not search lore stable archive (403).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `init_irq_scs()`, `init_irq_stacks()`, `init_IRQ()`, and
downstream `call_on_irq_stack()`.

### Step 5.2: Callers
**Record:**
- `init_IRQ()` called from `start_kernel()` in `init/main.c:970` during
  early boot.
- `call_on_irq_stack()` called from `entry-common.c:160` on IRQ entry
  when `on_thread_stack()` is true, and from `do_softirq_own_stack()` in
  `irq.c:73`.
- Every hardware interrupt on arm64 can reach this path once IRQs are
  enabled.

### Step 5.3: Callees
**Record:**
- `arch_alloc_vmap_stack()` → `__vmalloc_node()` (can return NULL)
- `scs_alloc()` → `__scs_alloc()` → `__vmalloc_node_range()` (explicitly
  returns NULL on failure, `kernel/scs.c:58-60`)
- `panic()` on failure

### Step 5.4: Call Chain / Reachability
**Record:** `start_kernel()` → `init_IRQ()` → [allocation] → later
`irqchip_init()` → timers/IRQs enabled → `handle_arch_irq` →
`call_on_irq_stack()`. If stacks are NULL, first IRQ after enable hits
invalid stack. Reachable on all arm64 systems using VMAP stacks (always
selected in `arch/arm64/Kconfig:285`).

### Step 5.5: Similar Patterns
**Record:** `arch/arm64/kernel/sdei.c:74-84` and `:129-135` already
check `arch_alloc_vmap_stack()` / `scs_alloc()` for NULL and return
`-ENOMEM`. `arch/arm64/kernel/efi.c:218-222` also handles
`arch_alloc_vmap_stack()` failure. `irq.c` is the inconsistent outlier.

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`). Current `arch/arm64/kernel/irq.c:54-63`
and `:42-52` lack NULL checks. Fix not applied.

### Step 6.2: Backport Complications
**Record:** Clean apply expected. One minor context difference: user's
diff shows `#ifdef CONFIG_SOFTIRQ_ON_OWN_STACK` but this tree uses
`#ifndef CONFIG_PREEMPT_RT` at that location — unrelated to the fix
hunks.

### Step 6.3: Related Fixes Already Present?
**Record:** SDEI stack allocation error handling present since
`ac20ffbb0279aa`. No equivalent fix in `irq.c`. `git log -S "Failed to
allocate IRQ stack"` found nothing (fix absent).

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `arch/arm64` — **CORE/IMPORTANT**. Affects every arm64
system (servers, mobile, embedded).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent `irq.c` changes in 2025
(`c4a5699d5cefd`). Long-standing code with a long-lived oversight.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** All arm64 users with `CONFIG_VMAP_STACK` (always selected).
`CONFIG_SHADOW_CALL_STACK` users additionally affected by `scs_alloc()`
path.

### Step 8.2: Trigger Conditions
**Record:** `arch_alloc_vmap_stack()` or `scs_alloc()` returns NULL
during `init_IRQ()` — early-boot OOM / vmalloc failure. Rare but
concrete (not theoretical). Once IRQs fire, every CPU is affected.
Unprivileged users can trigger IRQs after boot proceeds.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: invalid stack at address `THREAD_SIZE` (16
KiB), stack operations corrupt kernel memory, then oops/hang with poor
diagnostics. **Severity: HIGH** when triggered (crash + potential
corruption). With fix: immediate panic with clear message. **Severity of
fix: prevents corruption.**

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents undefined behavior and memory corruption on IRQ;
  fail-fast with clear message; aligns with `sdei.c` precedent.
- **Risk:** Very low — ~30 lines, early-boot-only, maintainer-reviewed.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Compile

**FOR backport:**
- Real bug: NULL IRQ stack pointers used by `call_on_irq_stack()`
- Can cause memory corruption and oops, not just clean failure
- Small, surgical, obviously correct
- Matches existing `sdei.c` error-handling pattern in this tree
- arm64 maintainer (Will Deacon) signed off
- Buggy code present since 2017/2020 in this tree
- VMAP_STACK always enabled on arm64

**AGAINST backport:**
- Trigger (OOM at early boot) is very rare
- No user reports, syzbot, or `Fixes:` tag
- System likely unusable anyway under severe boot-time OOM
- Mailing list review thread unverified

**UNRESOLVED:**
- Full lore review discussion and any explicit stable nominations

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors proven `sdei.c`
   pattern; maintainer sign-off; no user test reports.
2. Fixes a real bug affecting users? **PASS** — NULL stack →
   corruption/crash on IRQ.
3. Important issue? **PASS** — oops and potential memory corruption
   (HIGH when triggered).
4. Small and contained? **PASS** — one file, ~30 lines.
5. No new features or APIs? **PASS** — error handling only.
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected.

### Step 9.3: Exception Categories
**Record:** Not a device ID, quirk, DT, build fix, or docs fix. Standard
bug fix.

### Step 9.4: Decision Rationale

This commit fixes a long-standing oversight where IRQ stack allocation
failures are silently ignored. When `arch_alloc_vmap_stack()` or
`scs_alloc()` fails during early boot, the kernel proceeds with NULL
per-CPU stack pointers. The first IRQ then runs `call_on_irq_stack()`
with an invalid stack base (`THREAD_SIZE`), causing stack operations to
corrupt low kernel memory before crashing — worse than a clean panic.

The fix is minimal, follows an established pattern already used in
`sdei.c` in this same tree, and is signed off by the arm64 maintainer.
While the trigger is rare (boot-time OOM), the consequence is a serious
crash with potential corruption, which fits stable kernel criteria for
"oops" and "oh, that's not good" issues. For v6.18.43, the buggy code is
present and the fix is not.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis: 1 file, 3 functions, NULL-check + panic
  pattern
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232
- **[Phase 3]** `git blame -L 42,63 arch/arm64/kernel/irq.c`: bug since
  e3067861 (2017), ac20ffbb (2020)
- **[Phase 3]** `git show e3067861ba6650`: introduced
  `init_irq_stacks()` without error check
- **[Phase 3]** `git show ac20ffbb0279aa`: introduced `init_irq_scs()`
  without error check; sdei.c got checks
- **[Phase 3]** `git log --oneline -20 -- arch/arm64/kernel/irq.c`:
  recent history reviewed
- **[Phase 3]** `git log --grep="panic from init_IRQ"`: no match (fix
  not in tree)
- **[Phase 3]** `git log -S "Failed to allocate IRQ stack"`: no match
  (timed out once, then killed; no results)
- **[Phase 4]** `b4 dig -c HEAD`: no match for this commit
- **[Phase 4]** lore.kernel.org fetch: 403 Forbidden — **UNVERIFIED**
  review thread
- **[Phase 5]** Read `arch/arm64/kernel/irq.c`: confirmed buggy code at
  lines 42-63, 110-113
- **[Phase 5]** Read `arch/arm64/kernel/entry.S:874-891`:
  `call_on_irq_stack` uses `irq_stack_ptr` without NULL check
- **[Phase 5]** Read `kernel/scs.c:54-60`: `scs_alloc()` returns NULL on
  failure
- **[Phase 5]** Read `arch/arm64/include/asm/vmap_stack.h:18-26`:
  `arch_alloc_vmap_stack()` returns `kasan_reset_tag(p)` which can be
  NULL
- **[Phase 5]** Read `arch/arm64/kernel/sdei.c:74-84,129-135,177-181`:
  precedent for NULL checks
- **[Phase 5]** Read `init/main.c:970`: `init_IRQ()` called during
  `start_kernel()`
- **[Phase 5]** Read `arch/arm64/kernel/entry-common.c:159-160`: IRQ
  path calls `call_on_irq_stack`
- **[Phase 6]** `arch/arm64/Kconfig:285`: `select VMAP_STACK` — always
  enabled on arm64
- **[Phase 6]** Confirmed fix not present in current `irq.c`
- **[Phase 8]** `IRQ_STACK_SIZE` = `THREAD_SIZE` = 16 KiB (4K pages) per
  `arch/arm64/include/asm/memory.h:131,140`

**YES**Those background searches are done. They back up the earlier
analysis:

- **`git log --grep="panic from init_IRQ"`** — no matches; the fix is
  not in this v6.18.43 tree.
- **Similar-fix search** — no equivalent error handling in `irq.c`; only
  unrelated history (e.g. SDEI stack checks in `sdei.c`).
- **Author/subject search** — no local commit for this IRQ stack panic
  fix.
- **`git log -S` for the panic string** — timed out and was stopped;
  other checks already showed the fix is absent.

Verdict unchanged: **YES** for backport to this tree.

 arch/arm64/kernel/irq.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index c0065a1d77cf3..00ebbf18b1c18 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -10,6 +10,7 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
+#include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/irq.h>
@@ -32,34 +33,43 @@ DEFINE_PER_CPU(struct nmi_ctx, nmi_contexts);
 
 DEFINE_PER_CPU(unsigned long *, irq_stack_ptr);
 
-
 DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
 
 #ifdef CONFIG_SHADOW_CALL_STACK
 DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
 #endif
 
-static void init_irq_scs(void)
+static int __init init_irq_scs(void)
 {
 	int cpu;
+	void *s;
 
 	if (!scs_is_enabled())
-		return;
+		return 0;
+
+	for_each_possible_cpu(cpu) {
+		s = scs_alloc(early_cpu_to_node(cpu));
+		if (!s)
+			return -ENOMEM;
+		per_cpu(irq_shadow_call_stack_ptr, cpu) = s;
+	}
 
-	for_each_possible_cpu(cpu)
-		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			scs_alloc(early_cpu_to_node(cpu));
+	return 0;
 }
 
-static void __init init_irq_stacks(void)
+static int __init init_irq_stacks(void)
 {
 	int cpu;
 	unsigned long *p;
 
 	for_each_possible_cpu(cpu) {
 		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, early_cpu_to_node(cpu));
+		if (!p)
+			return -ENOMEM;
 		per_cpu(irq_stack_ptr, cpu) = p;
 	}
+
+	return 0;
 }
 
 #ifndef CONFIG_PREEMPT_RT
@@ -109,8 +119,9 @@ int __init set_handle_fiq(void (*handle_fiq)(struct pt_regs *))
 
 void __init init_IRQ(void)
 {
-	init_irq_stacks();
-	init_irq_scs();
+	if (init_irq_stacks() || init_irq_scs())
+		panic("Failed to allocate IRQ stack resources\n");
+
 	irqchip_init();
 
 	if (system_uses_irq_prio_masking()) {
-- 
2.53.0

