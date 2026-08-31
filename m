Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F64E80A3;
	Mon, 31 Aug 2026 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183615; cv=none; b=UtSERok3L5mpMKavVt75QtPTttWMIJS21/RPY7UWj7KIXZNDqIO4Xj+evm+OKOnfHe3vccWahWWTiOQwFNcwZLhjopGJFONCnPROPMwp0YDg2Au6oiaqfkKU8vqQ0k6kW50A3504ippX9KLm88mbh2sTRjZ3p9SEJqTkGcWiU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183615; c=relaxed/simple;
	bh=Yw5ceG1qbYk5Luskp/Rhx/HOxgA94ogBfuwbf/z7bfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tNET94GgnaCZjn6QF9SL6eOQBOmlSryERRTKTnaigMMTMnv5BH35jbq1al1+caaWo3QAIDLyNeSGODBeE10Pgg/6ad1UVdQ9TrJ05QoRUfnr4AgMN/MZ3WAMfJb6gao4DcAopAnSGGfwUYNTK1aaavZvvrvTq5QK/7AJwCWSnNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqQZFPLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqQZFPLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A451F000E9;
	Mon, 31 Aug 2026 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183612;
	bh=hL0/Zi2uIBkiGBWy4pcN0QFvBlPleLsK/is6hJRFeqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqQZFPLj5hA4gvmCMMTN/0fR6pibzOJAK0OHSzeECW01wSsV1KN4q6+VrmvJ0SroU
	 h5ZjJtYgL17DRUueb2TNlaGy3Y3svyYXuX6ITrxf8k7bwMT9EFMfRQ15G2KYQl/KD/
	 F1hcE6NXwYK6J/683I9trP22vTKZZKOpol6QjPnDo1FhMenK8sCDVYy/tMtEwJF3Sg
	 tyChE41bCW5JjieF9+ZbZMNAz5XwIr9gqguWUzJoY4GgKJGWTiPEW1TP/rZReB82pg
	 oCyNtFcJIfDH6zz3M261k5xMhatD9LYFKcvvLTaynUcJ+yzsCcZfDt//gXizEf1xsW
	 QcNGkwh7HvD9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ast@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	memxor@gmail.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] libbpf: Add __NR_bpf definition for LoongArch
Date: Mon, 31 Aug 2026 09:23:46 -0400
Message-ID: <20260831133314.4125787-198-sashal@kernel.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit a4a5d4ee061240a1d39053db0a87f841d43277c0 ]

LoongArch uses the generic syscall table, where __NR_bpf is defined
as 280 in include/uapi/asm-generic/unistd.h.

To align with other architectures, add the __NR_bpf definition for
LoongArch to avoid a potential compilation failure: "error __NR_bpf
not defined. libbpf does not support your arch."

This is a follow up patch of:

  commit b0c47807d31d ("bpf: Add sparc support to tools and samples.")
  commit bad1926dd2f6 ("bpf, s390: fix build for libbpf and selftest suite")
  commit ca31ca8247e2 ("tools/bpf: fix perf build error with uClibc (seen on ARC)")
  commit e32cb12ff52a ("bpf, mips: Fix build errors about __NR_bpf undeclared")

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260526063936.16769-1-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `libbpf: Add __NR_bpf definition for
LoongArch`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[libbpf] [add] [__NR_bpf definition for LoongArch]`

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Tiezhu Yang `<yangtiezhu@loongson.cn>` (author)
- **Signed-off-by:** Andrii Nakryiko `<andrii@kernel.org>` (libbpf
  maintainer)
- **Link:** https://lore.kernel.org/bpf/20260526063936.16769-1-
  yangtiezhu@loongson.cn
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer Signed-off-by is a quality signal; no syzbot/user
  bug report

### Step 1.3: Body analysis
**Record:**
- **Bug:** When building libbpf/bpf tools on LoongArch with overridden
  `unistd.h` (perf build path), `__NR_bpf` is undefined and compilation
  fails with `#error __NR_bpf not defined. libbpf does not support your
  arch.`
- **Symptom:** Build failure (compile-time `#error`), not a runtime
  kernel crash
- **Root cause:** LoongArch uses the generic syscall table (`__NR_bpf` =
  280 in `asm-generic/unistd.h`), but the explicit arch fallback list in
  `tools/lib/bpf/bpf.c` and `tools/build/feature/test-bpf.c` was never
  updated for `__loongarch__`
- **Version info:** None in message; follow-up to arch-specific
  `__NR_bpf` additions dating from 2017–2021

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as alignment/cleanup, but it is a **build
fix** preventing compilation failure on LoongArch, same class as prior
mips/ARC/s390/sparc fixes by the same pattern.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `tools/lib/bpf/bpf.c`: +2 lines
- `tools/build/feature/test-bpf.c`: +2 lines
- **Total:** 4 insertions, 0 deletions
- **Functions affected:** None directly; modifies preprocessor fallback
  block before `sys_bpf()` / `main()`
- **Scope:** Single-purpose, two-file surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`bpf.c`):** Before → `#elif mips` then `#else #error`. After
  → adds `#elif defined(__loongarch__) #define __NR_bpf 280` before the
  error branch. Affects the `#ifndef __NR_bpf` fallback used when perf
  overrides `unistd.h`.
- **Hunk 2 (`test-bpf.c`):** Same preprocessor addition for bpf feature-
  detection compile test.

### Step 2.3: Bug mechanism
**Record:** **Build fix / missing arch definition (category
h-adjacent).** When `__NR_bpf` is not provided by headers (overridden
`unistd.h` path documented in `bpf.c`), LoongArch hits the `#else
#error` branch. Fix supplies the correct syscall number (280).

### Step 2.4: Fix quality
**Record:** Obviously correct — value 280 matches `include/uapi/asm-
generic/unistd.h` and `tools/arch/loongarch/include/uapi/asm/unistd.h`
(which includes `asm-generic/unistd.h`). Minimal, mirrors existing arch
entries (aarch64, arc also use 280). **Regression risk:** very low; only
affects preprocessor path when `__NR_bpf` is absent.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `__NR_bpf` fallback block in `bpf.c` introduced in
e3ed2fef22b6 (2015). Arch entries added incrementally: sparc (b0c47807,
2017), s390 (bad1926dd, 2017), arc (ca31ca82, 2019), mips (e32cb12ff,
2021, same author). LoongArch omission is a long-standing gap, not a
recently introduced regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Referenced prerequisite commits all
exist in this tree (`b0c47807`, `bad1926dd`, `ca31ca82`, `e32cb12ff`
confirmed via `git merge-base --is-ancestor`).

### Step 3.3: File history
**Record:** Related LoongArch libbpf work already in tree:
`00883922ab404` (bpf_tracing.h), `29c66ad1c3ad1` (PT_REGS_CAST for
LoongArch). `seccomp_bpf.c` already defines `__NR_seccomp` for
`__loongarch__` (line 147). Standalone patch; not part of a multi-patch
series.

### Step 3.4: Author context
**Record:** Tiezhu Yang (Loongson) — prior `e32cb12ff52a2` mips
`__NR_bpf` fix in same files. Andrii Nakryiko (libbpf maintainer)
Signed-off-by.

### Step 3.5: Dependencies
**Record:** No hard dependencies beyond the existing `__NR_bpf` fallback
mechanism (present since 2015+). Applies standalone. Commit itself is
**not** in current branch (`git log --grep` returned empty).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 am 20260526063936.16769-1-yangtiezhu@loongson.cn` found
thread at
https://patch.msgid.link/20260526063936.16769-1-yangtiezhu@loongson.cn.
Mbox contains only the patch (1 message, no replies). No stable
nominations or NAKs found. `b4 dig -c HEAD` failed (commit not in tree);
used message-id lookup instead.

### Step 4.2: Reviewers
**Record:** Andrii Nakryiko Signed-off-by on patch. No separate
Reviewed-by in mbox.

### Step 4.3: Bug report
**Record:** N/A — no external bug report or syzbot link. Author
documents expected compile error text.

### Step 4.4: Related patches
**Record:** Part of ongoing arch-by-arch `__NR_bpf` fallback additions.
Same author fixed mips identically in 2021. LoongArch bpf_tracing
support already merged separately.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list (WebFetch blocked by bot
protection). No stable discussion found in mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Preprocessor block only. Downstream: `sys_bpf()` in `bpf.c`
calls `syscall(__NR_bpf, ...)`. `test-bpf.c` `main()` calls
`syscall(__NR_bpf, BPF_PROG_LOAD, ...)`.

### Step 5.2: Callers
**Record:** `sys_bpf()` is the central libbpf syscall wrapper — used
throughout libbpf for all BPF operations. Only reached at runtime if
compilation succeeds; this patch affects **compile-time** availability
of `__NR_bpf`.

### Step 5.3: Callees
**Record:** `syscall(__NR_bpf, ...)` — requires correct arch syscall
number.

### Step 5.4: Reachability
**Record:** Triggered when building bpf tools (libbpf, perf, bpftool,
bpf selftests feature detection) on LoongArch hosts where `__NR_bpf` is
not defined by included headers. Userspace build path, not kernel
runtime.

### Step 5.5: Similar patterns
**Record:** `seccomp_bpf.c` already has `__loongarch__` syscall
fallbacks (`__NR_seccomp 277`). `bpf.c` and `test-bpf.c` are
inconsistent — LoongArch was missed. Same pattern fixed for mips, arc,
s390, sparc.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current `tools/lib/bpf/bpf.c` lines 43–64 and
`tools/build/feature/test-bpf.c` lines 6–25 lack `__loongarch__` case
and fall through to `#error`. LoongArch arch support present since
`fa96b57c14906` (LoongArch build infrastructure). Bug has existed since
LoongArch tooling support without this define.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Two identical 2-line hunks in
files that match the patch context. No conflicting recent churn in this
specific block.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. `git log --grep="Add __NR_bpf
definition for LoongArch"` returns empty on this branch.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** **tools/lib/bpf** (userspace libbpf shipped with kernel
sources). **Criticality:** IMPORTANT for bpf tooling; PERIPHERAL for
general kernel runtime (does not affect running kernel on non-LoongArch
or pre-built distros).

### Step 7.2: Activity
**Record:** LoongArch and libbpf actively maintained in 6.18.y (recent
LoongArch BPF/kprobes fixes; ongoing libbpf API work).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** LoongArch users building kernel bpf tools from source
(libbpf, perf, bpftool, bpf feature tests). Not universal; platform-
specific build issue.

### Step 8.2: Trigger conditions
**Record:** Compile libbpf/bpf tools on LoongArch when `__NR_bpf` is not
provided by headers (documented perf override path). Common for
developers/maintainers building from kernel tree on LoongArch hardware.
Unprivileged users can trigger only insofar as they can invoke a build.

### Step 8.3: Failure mode severity
**Record:** **Compile-time failure** (`#error` / undeclared `__NR_bpf`).
**Severity: MEDIUM** for affected users (cannot build tools); **LOW**
for general kernel stability (no runtime crash, corruption, or security
issue).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables bpf tool builds on LoongArch; closes obvious gap
  vs. other arches and vs. `seccomp_bpf.c` on same platform
- **Risk:** Very low — 4 lines, correct constant, no logic change
- **Ratio:** Favorable; classic stable build-fix backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real build failure on LoongArch (documented error path)
- Build fix — explicit stable exception category
- Tiny (4 lines), obviously correct (`__NR_bpf` = 280 verified in tree
  headers)
- Same pattern as mips/ARC/s390 fixes already in 6.18.44
- libbpf maintainer Signed-off-by
- Buggy code confirmed present in 6.18.44
- Prerequisites all in tree; standalone apply

**AGAINST backport:**
- No runtime kernel bug (tools-only build issue)
- Affects niche platform (LoongArch)
- No user bug reports or syzbot evidence
- No explicit stable nomination in review thread (thread had no replies)

**Unresolved:** Whether distro packagers always hit the
overridden-`unistd.h` path; author says "potential" failure, but
mechanism is well-established from `bpf.c` comment and prior arch fixes.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — syscall number matches `asm-
   generic/unistd.h`; maintainer SOB; mirrors proven prior arch fixes
2. Fixes real bug affecting users? **PASS** — compile failure for
   LoongArch bpf tool builds
3. Important issue? **PASS (moderate)** — build fix for platform
   developers; not crash/security, but stable explicitly accepts build
   fixes
4. Small and contained? **PASS** — 4 lines, 2 files
5. No new features/APIs? **PASS** — preprocessor define only
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception category
**Record:** **BUILD FIX** — prevents compilation failure when building
libbpf/bpf tools on LoongArch.

### Step 9.4: Decision rationale
For Linux **6.18.44**, LoongArch is a supported architecture and bpf
tooling is actively used, but `tools/lib/bpf/bpf.c` and
`tools/build/feature/test-bpf.c` still lack the `__loongarch__` entry in
the `__NR_bpf` fallback table. This is the same class of fix as the mips
(`e32cb12ff52a2`) and ARC (`ca31ca8247e2`) commits already in this tree.
The fix is trivial, correct, and low-risk. While severity is build-time
rather than runtime, stable trees routinely accept such arch-specific
build fixes — especially when they unblock tool compilation on a
supported platform.

---

## Verification

- **[Phase 1]** `git describe HEAD` → v6.18.44; parsed subject, tags,
  body from user-provided commit and mbox
- **[Phase 2]** Read `tools/lib/bpf/bpf.c` lines 39–65; read
  `tools/build/feature/test-bpf.c` full file; confirmed 4-line diff,
  preprocessor-only change
- **[Phase 3]** `git blame -L 43,65 tools/lib/bpf/bpf.c` — fallback
  block history traced to 2015; mips fix e32cb12ff52a2 by same author
- **[Phase 3]** `git merge-base --is-ancestor b0c47807d31d HEAD` →
  prerequisite in tree
- **[Phase 3]** `git log --grep="Add __NR_bpf definition for LoongArch"`
  → not in branch
- **[Phase 3]** `git log --author="Tiezhu Yang" -- tools/lib/bpf/` →
  mips fix + bpf_tracing LoongArch work present
- **[Phase 4]** `b4 am 20260526063936.16769-1-yangtiezhu@loongson.cn` →
  patch retrieved; 1 message, no replies
- **[Phase 4]** WebFetch lore.kernel.org → blocked (bot protection);
  used b4 mbox instead
- **[Phase 5]** `grep __loongarch__ tools/` — found in seccomp_bpf.c,
  bpf_tracing.h, etc., but NOT in bpf.c `__NR_bpf` block
- **[Phase 5]** Read `seccomp_bpf.c` lines 134–164 — `__NR_seccomp` for
  `__loongarch__` already defined
- **[Phase 6]** `grep __NR_bpf tools/lib/bpf/bpf.c` — no `__loongarch__`
  branch in 6.18.44
- **[Phase 6]** `include/uapi/asm-generic/unistd.h` line 677 → `#define
  __NR_bpf 280`
- **[Phase 6]** `tools/arch/loongarch/include/uapi/asm/unistd.h` →
  includes `asm-generic/unistd.h`
- **[Phase 6]** `arch/loongarch/` exists; `git log --reverse --
  arch/loongarch/ | head -1` → fa96b57c14906
- **[Phase 7]** `git log -20 -- arch/loongarch/` — active LoongArch
  development including BPF fixes
- **[Phase 8]** Assessed as build-time failure, platform-specific, low
  runtime risk

**YES**The background search finished. It confirmed that **"libbpf: Add
__NR_bpf definition for LoongArch" is not in the current 6.18.44
branch** — related LoongArch libbpf work is already there
(`bpf_tracing.h`, `PT_REGS_CAST`), but the `__NR_bpf` fallback in
`bpf.c` and `test-bpf.c` is still missing.

That matches the earlier analysis: this is a small, low-risk build fix
for LoongArch bpf tool compilation and should be backported to this
tree.

**YES**

 tools/build/feature/test-bpf.c | 2 ++
 tools/lib/bpf/bpf.c            | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-bpf.c
index e7a405f83af6e..89d59674f39b9 100644
--- a/tools/build/feature/test-bpf.c
+++ b/tools/build/feature/test-bpf.c
@@ -20,6 +20,8 @@
 #  define __NR_bpf 6319
 # elif defined(__mips__) && defined(_ABI64)
 #  define __NR_bpf 5315
+# elif defined(__loongarch__)
+#  define __NR_bpf 280
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 339b197972374..1e8f01bfc1bfd 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -59,6 +59,8 @@
 #  define __NR_bpf 6319
 # elif defined(__mips__) && defined(_ABI64)
 #  define __NR_bpf 5315
+# elif defined(__loongarch__)
+#  define __NR_bpf 280
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
-- 
2.53.0

