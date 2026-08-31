Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3604963B3;
	Mon, 31 Aug 2026 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183527; cv=none; b=LZD88y+SkUuW+RsDJYjolpSg3rgHqvLocYmdOTXUeGynCfHexqe5xnbAGbIh0cm8dVMFPZ5O8tt5Ys/VhjXj8f8kyboIeZMcQIusmPgyilvgUro1j29NBA4R/LN+WlLfwhy9Qe9FKpYfr8yRU/2Z6hkLP/sRPoH4ZHCrbaHSf6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183527; c=relaxed/simple;
	bh=bUa6al6uRm203EFTsNAKwT13GfkkHCAQDFFOAfrtvNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Quy+Yad6opSwCMDencSeFEbRWFKYZOXYkOBj2fV32h/85plY5b7Iv90UG4k+PG4zMmpwYommpXtouZncfHi8/BRKwo+SOrw+DCqwCdvA5gUVG4gU7MdMS9+NEQo6O52ZtmLyA4op1acctilamW6GKXr/cnsFvHeOXs/DFLlo02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NP/MsIQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NP/MsIQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9851F00A3E;
	Mon, 31 Aug 2026 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183524;
	bh=htwSknvtK7tk1ZfWIIQ4eVdrEqrOrzlUVWlK2rmiduw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NP/MsIQGXKMSp2EvNHsK275jfdEQzhs9NRC58VKw5qW/us30ThnH9aS/ic/EdEpT2
	 DWCR36BJjbtLV2MeLvQacPv+Svxaamor6oImoHuOSsspg4XOMIUChACtsMgCDzDOya
	 LnoAIoSm0xqt6PskGTvOcFds/sJXR4M4o0y1DeuOYRiCFPeEkir758+ce2E67tTAW6
	 6QyFwdPwMB9yDUrnir1UgIcRi4eXyMTBr7HoWHgMYFKX4PwTnO863aKTdjmbqrPQBo
	 Azpu6dnGTEZGSr2dez+OZCxCaXlGbqwUnFJUHua44ch/obqd25L1zIRIh9WQs/1Ijz
	 BQ8iD6yXJjZNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] genirq/proc: Size interrupt directory names for 10-digit interrupt numbers
Date: Mon, 31 Aug 2026 09:22:56 -0400
Message-ID: <20260831133314.4125787-148-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit c2c7983c93f5d86962318be7e7298f1bc3feb1a6 ]

/proc/irq/<n>/ directory names are built in `char name[10]` buffers
with `sprintf(name, "%u", irq)`.

Ten-digit IRQ numbers already need 11 bytes including the trailing NUL, and
current sparse-IRQ configurations allow interrupt numbers in that range.

Size the temporary name buffer for the current decimal form and switch
to bounded formatting when creating or removing the proc entry.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260404101001.1-genirq-proc-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: genirq/proc IRQ directory name buffer
overflow

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[genirq/proc]` `[size]` — Size interrupt directory names
for 10-digit interrupt numbers

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Signed-off-by:** Thomas Gleixner `<tglx@kernel.org>` (irq
  maintainer/committer)
- **Link:** https://patch.msgid.link/20260404101001.1-genirq-proc-
  pengpeng@iscas.ac.cn
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: committed by irq subsystem maintainer (Thomas Gleixner); no
  fuzzer/user crash report cited

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `/proc/irq/<n>/` directory names are built in `char name[10]`
  with unbounded `sprintf(name, "%u", irq)`
- **Symptom:** Stack buffer overflow when `irq` has 10 decimal digits
  (needs 11 bytes including NUL)
- **Root cause:** Buffer sized for 9-digit IRQ numbers; sparse-IRQ
  allows IRQ numbers up to `INT_MAX`
- **Fix approach:** Increase buffer to 11 bytes; use `snprintf()` for
  bounded formatting
- **Version info:** None specified in message

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit buffer-overflow /
correctness fix, not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `kernel/irq/proc.c` only (+4 / -3 lines, plus 1 include)
- **Functions modified:** `register_irq_proc()`, `unregister_irq_proc()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change per hunk
**Record:**
1. **Include:** Adds `#include <linux/kernel.h>` (for `snprintf`)
2. **`register_irq_proc()`:** `MAX_NAMELEN` 10→11; `sprintf()` →
   `snprintf(name, MAX_NAMELEN, "%u", irq)`
3. **`unregister_irq_proc()`:** Same `sprintf()` → `snprintf()` change

**Before:** 10-byte stack buffer; unbounded write for any `%u` value ≥
1,000,000,000
**After:** 11-byte buffer (exact fit for max `unsigned int` decimal +
NUL); bounded formatting

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds stack write (memory
  safety)
- **Mechanism:** `char name[10]` cannot hold 10-digit decimal string +
  NUL; `sprintf()` writes 11 bytes → stack corruption
- **Affected paths:** IRQ proc entry creation (`register_irq_proc`) and
  removal (`unregister_irq_proc`)

### Step 2.4: Fix quality
**Record:**
- Fix is obviously correct: max `unsigned int` is 4,294,967,295 (10
  digits); 11 bytes is sufficient
- Minimal, no unrelated changes
- Regression risk: very low (one extra byte on stack; `snprintf` is
  strictly safer)
- `show_interrupts()` in the same file already sizes display width for
  up to 10-digit IRQ numbers (`prec < 10`), confirming the subsystem
  expects such values

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Current `MAX_NAMELEN 10` and `sprintf(name, "%u", irq)` are
present at lines 326–348 and 401 in this tree. `git blame` resolves to
merge commit `5d324e5159d9e` (shallow per-file history in this
checkout). The buggy pattern predates the fix commit.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: File history for related changes
**Record:** Fix commit `c2c7983c93f5d86962318be7e7298f1bc3feb1a6` is
**not** an ancestor of HEAD (`git merge-base --is-ancestor` returned
exit 1). Buggy code is still present in 6.18.43. Single-patch series (v1
only per `b4 dig -a`).

### Step 3.4: Author's other commits
**Record:** Pengpeng Hou has other validation/bounds-checking patches in
this tree (e.g., media, iommu, hwmon). Not irq maintainer, but author of
similar safety fixes.

### Step 3.5: Dependencies
**Record:** No prerequisites. Self-contained; no series dependencies.
Applies to existing `register_irq_proc`/`unregister_irq_proc` in this
tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **URL:** https://patch.msgid.link/20260404101001.1-genirq-proc-
  pengpeng@iscas.ac.cn
- **Series:** v1 only (no v2/v3)
- **Review feedback:** No replies, NAKs, or stable nominations visible
  on spinics/lore thread — only tip-bot merge notification
- Merged to `tip: irq/core` by Thomas Gleixner (May 11, 2026)

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — To: Thomas Gleixner; Cc: linux-kernel, author.
Appropriate maintainer routing; no explicit review thread.

### Step 4.3: Bug report
**Record:** No syzbot, KASAN, or user crash report. Proactive
correctness fix from code analysis.

### Step 4.4: Related patches
**Record:** Standalone single patch; no related series members needed.

### Step 4.5: Stable mailing list
**Record:** No stable-list discussion found for this fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `register_irq_proc()`, `unregister_irq_proc()`

### Step 5.2: Callers
**Record:**
- `register_irq_proc()` called from `kernel/irq/manage.c`
  (`request_threaded_irq` path, line 1772) and `init_irq_proc()` (boot,
  iterates all IRQs)
- `unregister_irq_proc()` called from `kernel/irq/irqdesc.c`
  `free_desc()` during IRQ teardown

### Step 5.3: Callees
**Record:** `proc_mkdir()`, `remove_proc_entry()`,
`snprintf()`/`sprintf()`, mutex guards

### Step 5.4: Call chain / reachability
**Record:**
- **Normal path:** Device driver `request_irq()` →
  `request_threaded_irq()` → `register_irq_proc()`
- **Boot path:** `init_irq_proc()` registers proc entries for all
  existing IRQs
- **Teardown:** IRQ free → `unregister_irq_proc()`
- Reachable whenever an IRQ ≥ 1,000,000,000 is registered; requires
  `CONFIG_SPARSE_IRQ` (proc functions are stubs without it)

### Step 5.5: Similar patterns
**Record:** Same file's `show_interrupts()` already handles 10-digit IRQ
display width (`prec < 10 && j <= nr_irqs`). `register_handler_proc()`
already uses `snprintf` with a 128-byte buffer. Only the IRQ-number proc
directory path retained the undersized buffer.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Verified at `kernel/irq/proc.c`:
- Line 326: `#define MAX_NAMELEN 10`
- Lines 348, 401: `sprintf(name, "%u", irq)`
- `CONFIG_SPARSE_IRQ` is selected on x86, arm64, arm, powerpc, riscv,
  s390, etc.
- `MAX_SPARSE_IRQS` is `INT_MAX` when `CONFIG_SPARSE_IRQ` is set
  (`kernel/irq/internals.h` lines 14–17)
- `irq_find_free_area()` searches up to `MAX_SPARSE_IRQS`
  (`kernel/irq/irqdesc.c` line 178)

### Step 6.2: Backport complications
**Record:** Clean apply expected — identical context in this tree. No
conflicting changes observed.

### Step 6.3: Related fixes already present?
**Record:** None. `git log --grep="10-digit"` and `--grep="interrupt
directory"` returned no matches. Fix commit not in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **kernel/irq** — CORE subsystem. Affects interrupt
registration and `/proc/irq/` on all `CONFIG_SPARSE_IRQ` systems.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; irq maintainer (Thomas Gleixner)
committed the fix.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Systems with `CONFIG_SPARSE_IRQ` (default on major
architectures) that register or unregister an IRQ with number ≥
1,000,000,000. Universal subsystem code, but trigger requires high IRQ
numbers.

### Step 8.2: Trigger conditions
**Record:**
- IRQ number ≥ 1,000,000,000 during `register_irq_proc()` or
  `unregister_irq_proc()`
- Valid per `__irq_alloc_descs()` / `irq_find_free_area()` up to
  `INT_MAX`
- A driver can request a specific high IRQ via `irq_alloc_descs(at, at,
  1, node)` without allocating billions of prior IRQs
- Unprivileged users cannot directly trigger; module load or
  device/driver activity can
- **Likelihood:** Low on typical systems (IRQ numbers rarely reach 1
  billion), but architecturally permitted and API-supported

### Step 8.3: Failure mode severity
**Record:** Stack buffer overflow → stack corruption → kernel oops/panic
or potential exploit primitive. **Severity: HIGH** (memory safety in
core kernel code).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates real stack overflow in irq proc registration;
  aligns with existing 10-digit IRQ display logic in same file
- **Risk:** Minimal (7-line change, one extra stack byte, bounded
  formatting)
- **Ratio:** High benefit, very low risk — appropriate for stable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real stack buffer overflow bug in core irq code
- Buggy code confirmed present in 6.18.43
- Fix is minimal, obviously correct, maintainer-committed
- `CONFIG_SPARSE_IRQ` + `MAX_SPARSE_IRQS = INT_MAX` makes 10-digit IRQ
  numbers valid
- Stack corruption severity warrants stable inclusion

**AGAINST backport:**
- No syzbot/user crash reports
- Trigger (IRQ ≥ 1 billion) uncommon in practice
- No explicit stable nomination in review thread

**Unresolved:** Exact kernel version when `MAX_NAMELEN 10` was
introduced (git -S history in this checkout only shows merge commits).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — arithmetic is trivial;
   merged by irq maintainer
2. Fixes a real bug? **PASS** — stack buffer overflow for 10-digit IRQ
   numbers
3. Important issue? **PASS** — stack corruption in core kernel (HIGH
   severity)
4. Small and contained? **PASS** — 1 file, ~7 lines
5. No new features/APIs? **PASS** — bug fix only
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs — standard
memory-safety bug fix)

### Step 9.4: Decision rationale
This patch fixes a genuine stack buffer overflow in `/proc/irq/`
directory name construction when IRQ numbers have 10 decimal digits. The
local 6.18.43 tree still has the buggy `char name[10]` + `sprintf()`
pattern, while sparse IRQ permits IRQ numbers up to `INT_MAX`. The fix
is surgical, maintainer-approved, and prevents stack corruption on a
valid (if uncommon) code path. Stable trees routinely accept such core
memory-safety fixes.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes:/Reported-by:/syzbot
- [Phase 2] Read diff: `MAX_NAMELEN` 10→11, `sprintf`→`snprintf`,
  +`linux/kernel.h`
- [Phase 2] Confirmed `show_interrupts()` already handles 10-digit width
  (`prec < 10`)
- [Phase 3] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 3] Grep: buggy `MAX_NAMELEN 10` and `sprintf(name, "%u", irq)`
  at lines 326, 348, 401
- [Phase 3] `git merge-base --is-ancestor c2c7983c93f5... HEAD` → exit 1
  (fix NOT in tree)
- [Phase 3] `b4 dig -c c2c7983c93f5...` → lore URL found; v1 only series
- [Phase 3] `b4 dig -w` → Thomas Gleixner To, linux-kernel Cc
- [Phase 4] Fetched spinics thread — no review replies or stable
  nominations
- [Phase 5] Grep callers: `manage.c:1772`, `irqdesc.c:473`, `proc.c:436`
- [Phase 5] Read `irq_find_free_area()` — searches up to
  `MAX_SPARSE_IRQS`
- [Phase 5] Read `internals.h` — `MAX_SPARSE_IRQS = INT_MAX` with
  `CONFIG_SPARSE_IRQ`
- [Phase 5] Grep arch Kconfigs — `SPARSE_IRQ` selected on x86, arm64,
  arm, powerpc, riscv, s390, etc.
- [Phase 6] Buggy code confirmed present; fix not present
- [Phase 8] Failure mode: stack buffer overflow → HIGH severity
- [UNVERIFIED] Exact commit that introduced `MAX_NAMELEN 10` (git -S
  only shows merge commit in this checkout)

**YES**

 kernel/irq/proc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 29c2404e743be..0537d330abb82 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -10,6 +10,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/mutex.h>
 
@@ -323,7 +324,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 #undef MAX_NAMELEN
 
-#define MAX_NAMELEN 10
+#define MAX_NAMELEN 11
 
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
@@ -345,7 +346,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 		return;
 
 	/* create /proc/irq/1234 */
-	sprintf(name, "%u", irq);
+	snprintf(name, MAX_NAMELEN, "%u", irq);
 	desc->dir = proc_mkdir(name, root_irq_dir);
 	if (!desc->dir)
 		return;
@@ -398,7 +399,7 @@ void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
 #endif
 	remove_proc_entry("spurious", desc->dir);
 
-	sprintf(name, "%u", irq);
+	snprintf(name, MAX_NAMELEN, "%u", irq);
 	remove_proc_entry(name, root_irq_dir);
 }
 
-- 
2.53.0

