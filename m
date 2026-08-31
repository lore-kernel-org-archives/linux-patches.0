Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A699459AE1;
	Mon, 31 Aug 2026 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183284; cv=none; b=ZqDIGO3xJozC4ve3VvTeFX1aK3m+gHRIF2ppiWPK6GJGuFVaIGtwOSVa3feznuKnmU009y+s5BQjwMjrHFSdGj44+PmvJSz484w7P/YGbKQiD18B/i4cyWP3BpDHNtQzlE07SIJHqUDMo1jZ+OySKs0Lka/nr7lul+w2PMEMsMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183284; c=relaxed/simple;
	bh=PH2X3SFn9NSEbVrnM93NioM31uEVwUeY3PxrAvoIU5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OiYyGLRTwAm94SohFS3j5+ujcAtI2HWYNw2yTZJdYIdmBogOZ9DZoBIN0J3m6ixi2vTofAFPYJNWMJ2b3Wyy+HJIYvFOTNcHajQjr0a7qKH6msWImSfFY/zBYDx0QqPS13JMXFL2M9LWH0EQoc22nL/4ze+aIzi7kgKBv3Z2UY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvoIgE+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvoIgE+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE191F000E9;
	Mon, 31 Aug 2026 13:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183282;
	bh=mZkxmumgWxt+25lmmE7hMDBxeMFAURVsSHQbXMIjoFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvoIgE+OrctmpA+8ZXMVBVnMNE7Zg47gm2VAMVsdfB+XajESy4oXH9yBKaPkJZYvV
	 a9ci1TYvvchG0Ipxjevn1POoKruEju3mr/gz7Iwi2TuXJH5RCrCfbOKMw5sli+vl9x
	 9wvEHLQJx8ow5YI+e3Nnz5/JXbPjeeWOBB9jA2cpq4phJ7+fA/cpwoMqli9BGbX2sT
	 TnUH1XuHb2FzODRgcfhVW3Cha2Ve2Quh4sYfD0/h9ioOJDGQNdj4Mql55lbJ86zZBW
	 It9tUG7u7+bfW4vV4B+VooweC/FKQINPb3PfRvKHyv83XIAGxg5gefKZwl1fFPAXj7
	 BFWNGzBJ8mHxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] sparc: Disable compat support with LLD
Date: Mon, 31 Aug 2026 09:21:22 -0400
Message-ID: <20260831133314.4125787-54-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 852fed2e8bfe195351fb0078ba7245d41154e7a5 ]

An LLVM=1 sparc64 allmodconfig enables COMPAT and then tries to
build the 32-bit vDSO. That path cannot be linked with ld.lld:

  ld.lld: error: unknown emulation: elf32_sparc

ld.lld does not support the 32-bit SPARC ELF emulation used for
the compat vDSO, so keep COMPAT disabled when LLD is the linker.
This avoids selecting an unsupported build path while leaving the
existing GNU ld configuration unchanged.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `sparc: Disable compat support with LLD`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[sparc] [disable] Disable compat support with LLD` —
Kconfig change to prevent an unsupported LLVM/LLD build path on sparc64.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Acked-by:** Nathan Chancellor `<nathan@kernel.org>` (LLVM/toolchain
  maintainer)
- **Reviewed-by:** Andreas Larsson `<andreas@gaisler.com>` (sparc
  maintainer)
- **Link:**
  https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
- **Signed-off-by:** Rosen Penev `<rosenp@gmail.com>` (author)
- **Signed-off-by:** Andreas Larsson (committer/maintainer)
- **Assisted-by:** Codex:GPT-5.5
- No Fixes:, Reported-by:, Tested-by:, or Cc: stable tags
- Notable: dual maintainer endorsement (toolchain + sparc)

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `LLVM=1 sparc64 allmodconfig` enables `CONFIG_COMPAT`
  (default y), which builds the 32-bit compat vDSO using `elf32_sparc`
  linker emulation.
- **Symptom:** Build failure: `ld.lld: error: unknown emulation:
  elf32_sparc`
- **Root cause:** LLD does not support 32-bit SPARC ELF emulation; GNU
  ld path is unaffected.
- **Fix approach:** Add `depends on !LD_IS_LLD` to `CONFIG_COMPAT` so
  LLD builds skip the unsupported vDSO32 path.
- No kernel version range specified in the message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — this is an explicit **build fix**. No hidden
runtime bug; the failure is at link time during kernel build when LLD is
the linker.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `arch/sparc/Kconfig` only (+1 line)
- **Scope:** Single-file, surgical Kconfig fix
- **Function modified:** N/A (Kconfig symbol `COMPAT`)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `CONFIG_COMPAT` depends only on `SPARC64`, defaults to
  `y`. With `LLVM=1` + LLD, COMPAT stays enabled →
  `arch/sparc/vdso/Makefile` builds `vdso-image-32.o` using `-m
  elf32_sparc` → LLD fails.
- **After:** `CONFIG_COMPAT` additionally requires `!LD_IS_LLD`. LLD
  builds disable COMPAT and skip vdso32; GNU ld builds unchanged.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Build fix / toolchain incompatibility (Kconfig guard)
- **Mechanism:** Kconfig enables a build target (`vdso32.so` with
  `elf32_sparc`) that the selected linker cannot handle. The fix gates
  COMPAT on linker capability.

Relevant existing code in this tree:

```64:64:arch/sparc/vdso/Makefile
VDSO_LDFLAGS_vdso32.lds = -m elf32_sparc -soname linux-gate.so.1
```

```470:476:arch/sparc/Kconfig
config COMPAT
        bool
        depends on SPARC64
        default y
        select HAVE_UID16
        select ARCH_WANT_OLD_COMPAT_IPC
        select COMPAT_OLD_SIGACTION
```

### Step 2.4: Fix Quality Assessment
**Record:** Obviously correct, minimal (1 line), matches established
pattern on s390. **Regression risk:** Low — only affects LLVM+LLD
sparc64 builds; those already fail to build. Trade-off: LLD builds lose
32-bit compat support, which is unavoidable until LLD gains
`elf32_sparc` support.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Changed Lines
**Record:** `CONFIG COMPAT` on sparc dates to Sam Ravnborg, 2008
(`26b4c912185a8`). The missing `!LD_IS_LLD` guard has been absent since
COMPAT was introduced. `CONFIG_LD_IS_LLD` was added in `b744b43f79cc7`
(kbuild, May 2020) and is present in this tree.

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: File History for Related Changes
**Record:** Recent sparc toolchain work in this tree includes
`05457d96175d2` ("sparc/module: Add R_SPARC_UA64 relocation handling" —
needed for LLVM's IAS, committed Sep 2025). This shows active LLVM sparc
build enablement. The candidate fix is **standalone** (not part of a
multi-patch series).

### Step 3.4: Author's Other Commits
**Record:** Rosen Penev is an active contributor (ata, gpio, net
drivers) but not the sparc maintainer. Andreas Larsson (sparc
maintainer, also committed the LLVM relocation fix) reviewed and signed
off.

### Step 3.5: Prerequisite Commits
**Record:** Requires only `CONFIG_LD_IS_LLD` from `init/Kconfig`, which
exists in 6.18.44. No other dependencies. Applies cleanly as a one-line
addition.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig` with message-id failed (wrong invocation syntax).
Lore.kernel.org fetch blocked by anti-bot protection. Could not read
thread discussion directly.

### Step 4.2: Reviewers
**Record:** Acked-by Nathan Chancellor (LLVM/kbuild) and Reviewed-by
Andreas Larsson (sparc maintainer) — appropriate reviewers for this
change.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Failure is
reproducible from the commit message's described build command (`LLVM=1
sparc64 allmodconfig`).

### Step 4.4: Related Patches/Series
**Record:** Standalone 1-patch fix. Direct precedent: s390 uses the same
pattern:

```507:514:arch/s390/Kconfig
config COMPAT
        def_bool n
        prompt "Kernel support for 31 bit emulation"
        ...
        depends on MULTIUSER
        depends on !CC_IS_CLANG && !LD_IS_LLD
```

### Step 4.5: Stable Mailing List History
**Record:** Could not search lore (blocked). No evidence of prior stable
discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** Kconfig symbol `COMPAT` in `arch/sparc/Kconfig`; build
impact via `arch/sparc/vdso/Makefile` line 14: `obj-$(CONFIG_COMPAT) +=
vdso-image-32.o`

### Step 5.2: Callers / Impact Surface
**Record:** COMPAT enables 32-bit userspace syscall emulation on sparc64
(sys_sparc32.c, signal32.c, vdso32, etc.). Only disabled when
`LD_IS_LLD` is true — a build-time Kconfig decision, not a runtime code
path.

### Step 5.3: Callees
**Record:** When COMPAT=y, vdso build invokes `$(LD)` with `-m
elf32_sparc`. With LLD, this fails at link time.

### Step 5.4: Reachability
**Record:** Triggered by any developer/CI building `LLVM=1` sparc64
kernel with LLD (default with LLVM=1). Not userspace-triggerable at
runtime; build-time only.

### Step 5.5: Similar Patterns
**Record:** `arch/arm/mm/Kconfig` (`CPU_BIG_ENDIAN depends on
!LD_IS_LLD`), `arch/arm/Kconfig.platforms`, and `arch/s390/Kconfig`
(`COMPAT depends on !CC_IS_CLANG && !LD_IS_LLD`) — established pattern
for gating features LLD cannot support.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does the Buggy Code Exist?
**Record:** **YES.** `arch/sparc/Kconfig` lacks `depends on !LD_IS_LLD`
on COMPAT. vdso32 build with `elf32_sparc` is present.
`CONFIG_LD_IS_LLD` exists in `init/Kconfig`. The fix commit itself is
**not yet** in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — single line insertion after `depends on
SPARC64`. No conflicting changes in recent `arch/sparc/Kconfig` history.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found (`git log -S "depends on !LD_IS_LLD"
-- arch/sparc/Kconfig` returned nothing). s390's analogous guard exists
but sparc does not.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `arch/sparc` — **PERIPHERAL** architecture (niche hardware),
but kbuild/toolchain interaction affects kernel builders.

### Step 7.2: Subsystem Activity
**Record:** Active LLVM/toolchain work on sparc in this tree
(R_SPARC_UA64 relocation, Sep 2025), indicating LLVM sparc builds are a
real and growing concern.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Config-specific** — sparc64 kernel builders using `LLVM=1`
with LLD. Not general runtime users. Relevant to CI, distro builders,
and developers adopting LLVM toolchains on SPARC.

### Step 8.2: Trigger Conditions
**Record:** `LLVM=1` + sparc64 + LLD linker + config that enables COMPAT
(default y on sparc64). Reproducible on `allmodconfig`. Not timing-
dependent.

### Step 8.3: Failure Mode Severity
**Record:** **Build failure** (hard error at link stage) — severity
**MEDIUM** for affected builders (cannot complete kernel build), **LOW**
for runtime/production users (no oops, corruption, or security issue).

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Unblocks LLVM+LLD sparc64 kernel builds; aligns with
  active LLVM enablement work in tree; follows s390 precedent.
- **Risk:** Very low — 1-line Kconfig guard; only changes behavior for
  builds that already fail.
- **Ratio:** Favorable for backport as a build fix.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Explicit build fix — listed in `Documentation/process/stable-kernel-
  rules.rst` as valid stable material
- Reproducible, documented failure (`elf32_sparc` unsupported by LLD)
- 1-line, obviously correct, maintainer-reviewed
- Direct precedent on s390 (`COMPAT depends on !LD_IS_LLD`)
- Bug exists in 6.18.44; applies cleanly
- LLVM sparc support actively being developed in this tree

**AGAINST backport:**
- Very niche audience (sparc64 + LLVM + LLD)
- No runtime user impact — only affects kernel builders
- LLD builds lose 32-bit compat (acceptable workaround)

**Unresolved:**
- Full lore.kernel.org review thread (blocked by anti-bot)
- Whether any distro has filed a stable request

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — Kconfig guard;
   Acked/Reviewed by toolchain and sparc maintainers.
2. Fixes a real bug affecting users? **PASS** — real build failure for
   LLVM sparc64 builders.
3. Important issue? **PASS (MEDIUM)** — build error, not
   crash/corruption/security.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — Kconfig dependency only.
6. Can apply to local tree? **PASS** — clean one-line apply to 6.18.44.

### Step 9.3: Exception Categories
**Record:** **Build fix** — explicitly qualifies under stable kernel
rules.

### Step 9.4: Decision Rationale

This commit fixes a reproducible build failure when compiling a sparc64
kernel with `LLVM=1` and LLD. The failure occurs because `CONFIG_COMPAT`
(default y) triggers building the 32-bit vDSO with `elf32_sparc`
emulation, which LLD does not support. The fix is a one-line Kconfig
guard matching an established pattern on s390 and arm.

While the affected audience is small (sparc64 LLVM builders), stable
kernel rules explicitly include build errors as backport-worthy, and
LLVM toolchain adoption on sparc is actively progressing in this 6.18.y
tree. The fix is minimal, reviewed by both the sparc and LLVM
maintainers, and carries negligible regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified as build-fix with
  maintainer review
- [Phase 2] Confirmed 1-line diff in `arch/sparc/Kconfig`; verified
  `elf32_sparc` in `arch/sparc/vdso/Makefile:64` and COMPAT→vdso32
  linkage at `Makefile:14`
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame` COMPAT lines to
  2008; `CONFIG_LD_IS_LLD` present since b744b43f79cc7 (2020)
- [Phase 3] Related commit `05457d96175d2` (LLVM R_SPARC_UA64) present
  in tree, confirming active LLVM sparc work
- [Phase 3] `git log -S "depends on !LD_IS_LLD" -- arch/sparc/Kconfig`:
  no results — fix not present
- [Phase 4] `b4 dig` with message-id: failed (syntax error);
  lore.kernel.org: blocked by anti-bot
- [Phase 4] Verified s390 precedent at `arch/s390/Kconfig:514` (`depends
  on !CC_IS_CLANG && !LD_IS_LLD`)
- [Phase 5] Traced COMPAT → vdso32 build path via Makefile and Kconfig
- [Phase 6] Confirmed buggy Kconfig state in 6.18.44; fix not yet
  applied; clean apply expected
- [Phase 8] Assessed as build-time failure, MEDIUM severity for
  builders, LOW runtime risk
- UNVERIFIED: Full mailing list review thread content (lore blocked)
- UNVERIFIED: Whether commit has landed in mainline (evaluated as
  candidate for this 6.18.y tree)

**YES**

 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a630d373e6453..454782ac54b26 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -470,6 +470,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
-- 
2.53.0

