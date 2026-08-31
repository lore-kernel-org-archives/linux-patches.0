Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4307492531;
	Mon, 31 Aug 2026 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183514; cv=none; b=M4g4+3/19S5915myxDbE5WfsOTifAtwRoIy4J8zg1xf00oNu3Al30WPZvWtDS6lOlr8q5D0kbBUyO/3NaqxCDMEx2oXc5R7QFQZRuwsmKSRd9MyiI2570C698M3JxT+o5HRiVC9I2x17XURyD6FBRt8uprZx6qBRFvm8qUVA6VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183514; c=relaxed/simple;
	bh=fLJLMeraz/9+eiqxQRHsQvXXQQCTTjaCm+C0Blki5zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BM4ebZWcL3mq27As1x+2qZkJJGSQwE4KdHFh9Q0U+qYMZYHGu5EJ/XWahaoG7zkzLfXYsEwwCo0PBZpXkyYwnsRvkBNA/3gvrzQdjInuxncB/SxQW7lFWq96xYW821bHagdIK39nX2Eg5SKXdI3lFcMjpXzCnZV+8PX8YAMho2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EE5Slf9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EE5Slf9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127F91F00A3D;
	Mon, 31 Aug 2026 13:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183512;
	bh=VW0zXeoVMDpVklc0AYJUhm2FnO1Cs46mUoMbZ5PioLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EE5Slf9nZVEqfvAOJQVeoM4X6tDJ9Vdt5sgySDmh5BJwF3WOkgP1KoZh+jsCjvxqF
	 MudMXGnDL3BBehPDorM7/BxcplgZqM3GAHacR+G1/Bpy14IyR5dL/HBFT3ZhEj4FmU
	 p62f1bYN3fmUrlW58MOzdEm0DPKD8toBdx+IyzNL38bk8dqfs6X2LIX1ONnQqqs1wV
	 yaUCl5J5fAoKlrEq8DEJ3tHwmgrkcPDwXnm+R/6qgnHOEK1p5UF463mdvpx90bb/MW
	 vVqfTZw41xra/ZKOkf3XuRUfkL1ztS6hSpR5tpunaw3BLEIWl9ToWDc39Mle4EzqLm
	 Ow4XwC84ph96A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] tools/nolibc: avoid call to wcslen() in _start_c() inserted by clang
Date: Mon, 31 Aug 2026 09:22:49 -0400
Message-ID: <20260831133314.4125787-141-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 4c6826ee7d04f489ad6fcf46ae6dd595fe9c6295 ]

Clang may convert the loop to find _auxv into a call to wcslen() which
is missing on nolibc. -fsanitize needs to be disabled for this to
happen.

Use the same pattern as in the nolibc strlen() implementation to avoid
the function call generation.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260418-nolibc-wcslen-v1-1-671271b8ea63@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[tools/nolibc]` `[avoid]` — Prevent clang from inserting a
`wcslen()` call into the `_auxv` search loop in `_start_c()`.

### Step 1.2: Commit Tags
**Record:**
- **Signed-off-by:** Thomas Weißschuh `<linux@weissschuh.net>` (author)
- **Acked-by:** Willy Tarreau `<w@1wt.eu>` (nolibc co-maintainer)
- **Link:** https://patch.msgid.link/20260418-nolibc-
  wcslen-v1-1-671271b8ea63@weissschuh.net
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer Ack; no syzbot/user crash reports

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Clang may turn the `_auxv` scan loop into a call to
  `wcslen()`, which nolibc does not provide → link failure (`undefined
  symbol: wcslen`).
- **Symptom:** Link-time failure building nolibc programs with clang.
- **Trigger:** The commit states this happens when function sanitizer
  instrumentation is disabled on `_start_c()` (via
  `no_sanitize("function")` when UBSan is enabled globally). The nolibc
  test build enables `-fsanitize=undefined` by default in
  `Makefile.include`.
- **Root cause:** LLVM loop-idiom optimization (same class as the
  kernel-wide `wcslen` issue addressed by `-fno-builtin-wcslen` in the
  top-level `Makefile`).
- **Fix approach:** Add `__asm__("")` in the loop body, matching the
  existing `strlen()` pattern in `string.h`.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — described as an optimization workaround, but it fixes
a real link failure. Same category as the existing `strlen()`
`__asm__("")` guard.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `tools/include/nolibc/crt.h` (+1/−1)
- **Function:** `_start_c()`
- **Scope:** Single-file, one-line surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (auxv loop):** Before: empty loop body `;` — clang may optimize
  to `wcslen()`. After: `__asm__("")` blocks that optimization while
  preserving loop semantics.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Build/compiler optimization bug.
**Mechanism:** LLVM recognizes the null-terminated scan pattern and
emits a `wcslen()` builtin call; nolibc has no `wcslen` implementation →
undefined symbol at link time.

### Step 2.4: Fix Quality
**Record:** Obviously correct — identical to the established `strlen()`
pattern at line 140 of `string.h`. Minimal scope, no API changes,
negligible regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** In this shallow checkout (`v6.18.43`), blame points to a
single commit for `crt.h`; full introduction history is not reliably
available here. The buggy loop is present at lines 73–74.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** `string.h` already uses `__asm__("")` in `strlen()` for the
same compiler-optimization issue (lines 127–141). The top-level
`Makefile` already has `KBUILD_CFLAGS += -fno-builtin-wcslen` (line
1085), but nolibc standalone builds do not inherit `KBUILD_CFLAGS`.

### Step 3.4: Author Context
**Record:** Thomas Weißschuh is a primary nolibc contributor/maintainer.
Willy Tarreau Acked the patch.

### Step 3.5: Dependencies
**Record:** Standalone — no series dependency, no prerequisite commits
required. Applies cleanly to this tree’s `crt.h`.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Patch Discussion
**Record:** Patch posted 2026-04-18 to linux-kernel; spinics mirror at
https://www.spinics.net/lists/kernel/msg6159937.html. Follow-up from
Willy Tarreau listed. `b4 dig -c` failed (commit not in this shallow
tree). Lore direct fetch blocked (403).

### Step 4.2: Reviewers
**Record:** Acked-by Willy Tarreau (nolibc co-maintainer). CC’d linux-
kernel.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Issue is a
reproducible build/link failure class, related to LLVM commit
9694844d7e36 (kernel addressed via `-fno-builtin-wcslen`, backported to
stable for kbuild).

### Step 4.4: Related Patches
**Record:** Same author posted related nolibc sanitizer/stack-protector
patches in April 2026. This patch is independent.

### Step 4.5: Stable List History
**Record:** Could not search lore stable list (blocked). The kernel-wide
`-fno-builtin-wcslen` fix was queued for stable (spinics stable-commits
reference).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `_start_c()` — nolibc C runtime entry called from arch
`_start` assembly.

### Step 5.2: Callers
**Record:** Called from every nolibc arch entry stub (e.g. `arch-x86.h`,
`arch-arm64.h`, etc.) at program startup. Every nolibc binary executes
this path once at boot.

### Step 5.3: Callees
**Record:** After auxv scan: constructor arrays, `_nolibc_main()`
(main), destructor arrays, `exit()`.

### Step 5.4: Reachability
**Record:** Every nolibc program hits this path at startup. Failure is
at link time (before execution), triggered when building with clang
under conditions described above.

### Step 5.5: Similar Patterns
**Record:** `strlen()` in `string.h` uses the same `__asm__("")`
pattern. Kernel `Makefile` uses `-fno-builtin-wcslen` for the same LLVM
optimization.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `tools/include/nolibc/crt.h` lines 73–74 have the
empty loop body without `__asm__("")`. Tree is `v6.18.43` on
`stable/linux-6.18.y`.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — one-line change, no conflicts with
surrounding code in this tree.

### Step 6.3: Related Fixes Already Present?
**Record:** `Makefile` has `-fno-builtin-wcslen` for kernel builds (line
1085). `string.h` has the `strlen()` asm barrier. The `_start_c()` auxv
loop fix is **not** present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** `tools/nolibc` — **PERIPHERAL** for runtime (not in kernel
boot path), but **IMPORTANT** for kernel development/selftest
infrastructure.

### Step 7.2: Activity
**Record:** nolibc is actively maintained; used by multiple selftests
(nolibc suite, vDSO, riscv vector, arm64 GCS/FP).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Kernel developers and CI building nolibc programs with
**clang** and **UBSan** (default in
`tools/testing/selftests/nolibc/Makefile.include`). Not production
kernel runtime.

### Step 8.2: Trigger Conditions
**Record:** Build nolibc test binaries with clang +
`-fsanitize=undefined`. Fairly specific, but nolibc’s own test Makefile
enables sanitizers by default. Not userspace-exploitable.

### Step 8.3: Failure Severity
**Record:** **Link failure** (build error) — severity **MEDIUM** for
affected developers/CI; **LOW** for end users running kernels.

### Step 8.4: Risk-Benefit
**Record:** **Benefit:** MEDIUM — unblocks nolibc+clang+UBSan builds,
complements existing `-fno-builtin-wcslen` kbuild fix. **Risk:** VERY
LOW — one-line asm barrier, proven pattern. **Ratio:** Favorable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real build/link failure with clang on nolibc programs
- Explicit build-fix category per stable rules
- One-line, obviously correct, maintainer-Acked
- Same LLVM `wcslen` optimization class already addressed in this tree’s
  `Makefile`
- Established precedent in `string.h` `strlen()` implementation
- Buggy code confirmed present in v6.18.43

**AGAINST backport:**
- Affects developer tooling/selftests, not kernel runtime
- Narrow trigger (clang + UBSan on nolibc builds)
- Workaround possible (use gcc, add `-fno-builtin-wcslen` to nolibc
  CFLAGS)
- Could not reproduce `wcslen` call locally on clang 21.1.8 (may need
  newer clang or specific flags)

**Unresolved:**
- Exact clang version/flags that trigger the optimization
  (author/maintainer report accepted; local reproduction failed)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — proven pattern, maintainer
   Ack
2. Fixes real bug affecting users? **PASS** — link failure for
   nolibc+clang builds (developer/CI users)
3. Important issue? **PASS** — build error (stable-rules explicit
   category), severity MEDIUM
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, clean apply

### Step 9.3: Exception Category
**Record:** **Build fix** — compilation/link error in kernel tree
tooling.

### Step 9.4: Decision Rationale

This is the nolibc counterpart to the kernel-wide `-fno-builtin-wcslen`
fix already present in this 6.18.y tree. Nolibc standalone builds do not
use `KBUILD_CFLAGS`, so the header-level asm barrier is the correct
targeted fix. It is trivial, follows an in-tree precedent, is Acked by
the nolibc maintainer, and fixes a real link failure in the kernel’s own
nolibc test infrastructure when built with clang and UBSan (the default
nolibc test configuration). Impact is limited to developers/CI, but
stable rules explicitly include build errors, and the risk is
essentially zero.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Acked-by Willy Tarreau, Link to
  patch msgid)
- **[Phase 1]** Read commit body: clang `wcslen` insertion,
  `__asm__("")` fix
- **[Phase 2]** Diff: 1 line in `_start_c()` auxv loop in `crt.h`
- **[Phase 2]** Read `string.h` lines 127–141: `strlen()` uses same
  `__asm__("")` pattern
- **[Phase 3]** `git blame` on crt.h lines 72–75: buggy loop present
- **[Phase 3]** `git log -- tools/include/nolibc/crt.h`: limited history
  (shallow clone)
- **[Phase 4]** spinics.net patch mirror fetched; Willy Tarreau follow-
  up listed
- **[Phase 4]** `b4 dig -c`: failed — commit not in shallow tree
- **[Phase 4]** lore.kernel.org / patch.msgid.link: blocked (403/Anubis)
- **[Phase 5]** `grep _start_c`: called from all nolibc arch entry stubs
- **[Phase 5]** Read `Makefile.include`: `_CFLAGS_SANITIZER` defaults to
  `-fsanitize=undefined`
- **[Phase 6]** `git describe HEAD`: `v6.18.43` on `stable/linux-6.18.y`
- **[Phase 6]** Read `crt.h` lines 72–75: empty loop body (bug present,
  fix absent)
- **[Phase 6]** `grep fno-builtin-wcslen Makefile`: present at line 1085
- **[Phase 8]** Attempted clang reproduction of `wcslen` call:
  **UNVERIFIED** — not reproduced on clang 21.1.8 with test programs;
  maintainer report and LLVM context accepted
- **[Phase 8]** `make -f Makefile.nolibc nolibc-test` with clang: failed
  on unrelated `__stack_chk_init` unused-function error, not this bug

**YES**

 tools/include/nolibc/crt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/crt.h b/tools/include/nolibc/crt.h
index 961cfe777c356..d4e726ed80765 100644
--- a/tools/include/nolibc/crt.h
+++ b/tools/include/nolibc/crt.h
@@ -71,7 +71,7 @@ void _start_c(long *sp)
 
 	/* find _auxv */
 	for (auxv = (void *)envp; *auxv++;)
-		;
+		__asm__("");
 	_auxv = auxv;
 
 	for (ctor_func = __preinit_array_start; ctor_func < __preinit_array_end; ctor_func++)
-- 
2.53.0

