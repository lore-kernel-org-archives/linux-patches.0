Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7374358B6D9;
	Mon, 31 Aug 2026 13:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184237; cv=none; b=G2kemrzQPTn8olKY0efzKRPlhmFszB3hjUDsoQf/OLCb2Xic/eHOCctm3QS3bd6OFaEchhRyu+dVVvOJQry44WmUk456S158PFy4eiJdkZkhha7lVqxp+dLNSQn9R50Yi6jQ684AcHAtbRD9HiAslcQY6kaKcSwOSA3z02GPNAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184237; c=relaxed/simple;
	bh=USxSTS8492OWJwk9M0MT5PjW7R0tZplA+Svm0i++wow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ab7oeqOlY5Bid2fS2RM5xdfm+txxK76X21C9Xnbj8ij4IoFCe7hMAGzcqHB8l1uHOPGFYJdcPeUSzRJw2oNMr1skXkhe5wZAvFfl2dD7EddpqvK3KkJfxTF8eZrq5wqAv3ejTwMxqpXDOaaA+uBuMwMyMGURDIfT4m6bFQU8q5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDSUU2A0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDSUU2A0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003231F000E9;
	Mon, 31 Aug 2026 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184235;
	bh=a054+4uI6BXJFIWW7/FnetJTET2ZtU0mCB7YxbyJzWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDSUU2A0LJ2K4eJJaIDXyXbU4iG1kegeCeO27eUUXwkHRpA/vDFgZARdnT+3Nnyzk
	 pjjOMGMqMvuOOvwcibOH1ilzGljRqj7LZteT5MSKq8tnZYRiU0uyrnApYfaEa6yDG8
	 P0crMIhPcJJ9AbUmiS4VSRMmvd0MfhiUyJ32YrY7vnfOkyu99uMyGecMd35A5adDao
	 OobVamSN5hYly5jSVtO9Y+/9/vZcccKPzpUV34MgD+0JaAhAsyJTt6hLv2lXa1yAHA
	 d3pbnWa7CIXwdC4DgbGcEXTJvJKKgGKZzpaWMfwPSGIXD58Cwpo4srZFOpVJ3gW8po
	 W4m5mhpgLs35w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leo Yan <leo.yan@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrii@kernel.org,
	eddyz87@gmail.com,
	daniel@iogearbox.net,
	memxor@gmail.com,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] selftests/bpf: Avoid static LLVM linking for cross builds
Date: Mon, 31 Aug 2026 09:30:00 -0400
Message-ID: <20260831133314.4125787-572-sashal@kernel.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 62617d28d9ae123c0d6ba51035caa3ca52b94f7a ]

The BPF selftests prefer static LLVM linking, which works for native
builds but can break cross builds. Its --link-static output may include
host-only libraries that are unavailable for the cross compilation,
causing link failures.

Avoid static LLVM linking for cross builds and use shared LLVM libraries
instead. Native builds keep the existing behavior.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20260602-tools_build_fix_zero_init_bpf_only-v2-8-c76e5250ea1c@arm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[selftests/bpf]` `[avoid]` — Avoid static LLVM linking for
cross builds. Subsystem is BPF selftest build infrastructure; action is
a preventive build fix.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Leo Yan `<leo.yan@arm.com>` (author)
- **Link:** https://lore.kernel.org/r/20260602-
  tools_build_fix_zero_init_bpf_only-v2-8-c76e5250ea1c@arm.com
- **Signed-off-by:** Alexei Starovoitov `<ast@kernel.org>` (BPF
  maintainer merge)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable in commit message
- Notable: part of bpf-next v2 series patch 8/8; no syzbot or user bug
  reports

### Step 1.3: Body Analysis
**Record:**
- **Bug:** BPF selftests prefer static LLVM linking via `llvm-config
  --link-static`; on cross builds this can pull in host-only libraries
  unavailable to the target linker, causing link failures.
- **Symptom:** Cross-compiled BPF selftest binaries fail to link.
- **Fix:** Use shared LLVM libraries when `ARCH != HOSTARCH`; native
  builds keep static-first behavior.
- **Root cause:** Static linking logic added without distinguishing
  native vs cross builds.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit build/link fix, not disguised
cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `tools/testing/selftests/bpf/Makefile` (+7 / -2 lines)
- **Scope:** Single-file, surgical Makefile change
- **Area:** LLVM library selection block (lines ~185–192)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Always probe `llvm-config --link-static`; if available,
  use static libs for all builds.
- **After:** If `ARCH != HOSTARCH`, skip static probe
  (`LLVM_LINK_STATIC` empty) and fall through to `--link-shared`. On
  native builds (`ARCH == HOSTARCH`), probe static linking as before.
- **Path affected:** Cross-compilation of LLVM-enabled BPF selftests
  only.

### Step 2.3: Bug Mechanism
**Record:** **Build fix / logic correctness.** Static LLVM link flags
reference host libraries unsuitable for cross-linking. Forcing shared
libs on cross builds avoids unresolved host dependencies.

### Step 2.4: Fix Quality
**Record:** Fix is small and follows the existing `ARCH`/`HOSTARCH`
pattern used in `tools/perf/Makefile.config`. Low regression risk on
cross builds. Minor edge case: unnormalized `ARCH=x86_64` vs normalized
`HOSTARCH=x86` on native builds could force shared instead of static
linking (degraded preference, not a breakage). Sashiko AI review flagged
this; committed version unchanged.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Static-linking preference introduced by `67ab80a01886` (Sep 2024,
  Eduard Zingerman)
- Dynamic fallback added by `2a9d30fac818f` (Jan 2025, Daniel Xu)
- Shell redirection fix by `caa4237a790a9` (Mar 2025, Anton Protopopov)
- All three commits are present in this tree; buggy cross-build behavior
  dates to static-linking introduction

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag. N/A.

### Step 3.3: Related History
**Record:** Related stable-tree commits in same Makefile:
- `caa4237a790a9` — Fix selection of static vs dynamic LLVM (already in
  6.18.y)
- `cb3ade567816a` — Fix runqslower cross-endian build
- `fd526e121c4d6` — Fix cross-compiling urandom_read
- `3b796d3f16c10` — Allow selftests to build with older xxd
- Candidate commit `62617d28d9ae1` is **not** in this tree

### Step 3.4: Author Context
**Record:** Leo Yan is an active ARM/tools contributor (perf, kselftest,
bpf selftests). This patch is standalone within the broader tools-build
series.

### Step 3.5: Dependencies
**Record:** Patch 8/8 of v2 series, but this hunk is self-contained — no
dependency on earlier series patches for the LLVM linking logic. `git
apply --check` succeeds on current tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260602-
  tools_build_fix_zero_init_bpf_only-v2-8-c76e5250ea1c@arm.com
- **Series:** v1 (6 patches, Mar 2026) → v2 bpf-next (8 patches, Jun
  2026); committed version is v2/8
- **Review feedback:** Sashiko AI flagged medium-severity concern about
  `ARCH` vs `HOSTARCH` normalization; suggested `SRCARCH` or
  `CROSS_COMPILE` check instead
- No stable nominations found in thread
- No NAKs; bpf maintainers CC'd

### Step 4.2: Reviewers
**Record:** CC'd bpf maintainers (Starovoitov, Borkmann, Nakryiko,
etc.), Shuah Khan (kselftest), llvm@lists.linux.dev. Series patches
received Acked-by from Quentin Monnet and Ihor Solodrai (other patches
in series, not specifically this one in commit message).

### Step 4.3: Bug Reports
**Record:** No external bug report, syzbot, or user Reported-by. Issue
inferred from cross-build failure mechanism.

### Step 4.4: Series Context
**Record:** v2/0 covers EXTRA_CFLAGS/HOST_EXTRACFLAGS append fixes;
patch 8/8 is independent for LLVM linking purposes.

### Step 4.5: Stable List
**Record:** No stable-specific discussion found for this patch.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions/Variables
**Record:** `LLVM_LINK_STATIC`, `LLVM_LDLIBS`, `LLVM_LDFLAGS` in
Makefile LLVM feature block.

### Step 5.2: Callers/Usage
**Record:** `LLVM_LDLIBS` used at line 707 in the link rule for selftest
binaries (e.g. `test_progs`). Only affects builds with `feature-llvm=1`
and `SKIP_LLVM!=1`.

### Step 5.3: Callees
**Record:** Invokes `llvm-config --link-static/--link-shared
--libs/--system-libs`.

### Step 5.4: Reachability
**Record:** Triggered when a developer/CI cross-compiles BPF selftests
with LLVM support (`make -C tools/testing/selftests/bpf` with
`ARCH!=host`). Not reachable from normal kernel runtime or typical
distro kernel packages. Userspace-triggerable: no.

### Step 5.5: Similar Patterns
**Record:** `tools/perf/Makefile.config` uses identical `ifeq ($(ARCH),
$(HOSTARCH))` for native vs cross detection. Makefile already uses
`ifneq ($(CROSS_COMPILE),)` elsewhere for cross-build handling.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.44** (`linux-6.18.y`). Lines
185–192 still unconditionally prefer static LLVM linking. Introducing
commit `67ab80a01886` is an ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git apply --check` on commit
`62617d28d9ae1` succeeds with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** `caa4237a790a9` (shell redirection for static/dynamic probe)
is present. The cross-build guard from `62617d28d9ae1` is **not**
present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `tools/testing/selftests/bpf` — developer test
infrastructure. **Criticality: PERIPHERAL** (not core kernel runtime).

### Step 7.2: Activity
**Record:** Actively maintained; multiple bpf selftest build fixes
landed in 6.18.y (e.g. `3b796d3f16c10`, `4b65d5ae97143`,
`e860a98c8aebd`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Developers and CI systems cross-compiling BPF selftests with
LLVM on **6.18.y**. Not production kernel users.

### Step 8.2: Trigger Conditions
**Record:** Cross-compile (`ARCH != HOSTARCH`) + LLVM feature enabled +
static LLVM libs available on host. Uncommon but real for ARM/embedded
BPF development workflows.

### Step 8.3: Failure Mode
**Record:** **Link failure** during selftest build. **Severity: LOW** —
blocks optional test tooling, not kernel boot or data integrity.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** LOW-MEDIUM — restores cross-build of BPF selftests;
  aligns with prior stable backports of bpf cross-build fixes
- **Risk:** VERY LOW — 7-line Makefile change, cross-build path only
- **Ratio:** Modest benefit, very low risk; fits established 6.18.y
  precedent for bpf selftest build fixes

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible cross-build link failure
- Small, obviously correct build fix
- Applies cleanly to 6.18.44
- Bug introduced by commit already in this tree
- Precedent in 6.18.y: `cb3ade567816a`, `fd526e121c4d6`,
  `caa4237a790a9`, other bpf selftest build fixes
- Build-fix exception category per stable rules
- Standalone patch, no series dependencies

**AGAINST backport:**
- Affects only optional selftest tooling, not kernel runtime
- No user reports, syzbot, or security impact
- "Important issue" bar is borderline — link failure in tests, not
  crash/corruption
- Minor edge case in ARCH/HOSTARCH comparison on native x86_64 builds

**Unresolved:** Whether Leo Yan addressed the Sashiko AI ARCH-
normalization concern in a follow-up (not in this commit).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is sound; merged by
   BPF maintainer; no functional regression on cross path
2. Fixes a real bug? **PASS** — cross-build link failures are real
3. Important issue? **PASS (borderline)** — build-fix exception; low
   severity but blocks a legitimate developer workflow; consistent with
   prior bpf selftest cross-build backports in this tree
4. Small and contained? **PASS** — 7 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Category
**Record:** **Build fix** for test infrastructure.

### Step 9.4: Decision Rationale

This tree (6.18.44) contains the static LLVM linking preference without
a cross-build guard, so the bug is real and reachable for cross-
compiling developers. The fix is minimal, applies cleanly, and matches
established 6.18.y practice of backporting BPF selftest build
fixes—including prior cross-compile fixes in the same Makefile. Impact
is limited to test tooling rather than production kernels, but stable
trees routinely carry such fixes to keep selftest CI and developer
workflows functional on stable branches.

---

## Verification

- [Phase 1] Parsed commit `62617d28d9ae1` message and tags from `git
  show`
- [Phase 2] Diff analysis: 1 file, +7/-2, LLVM linking block only
- [Phase 3] `git blame` lines 185–192: static linking from
  `67ab80a01886`, probe fix from `caa4237a790a9`
- [Phase 3] `67ab80a01886` is ancestor of HEAD; `62617d28d9ae1` is not
- [Phase 3] `git apply --check` on patch: succeeds
- [Phase 3] Related stable history: `cb3ade567816a`, `fd526e121c4d6`,
  `caa4237a790a9` in `stable/linux-6.18.y`
- [Phase 4] `b4 dig -c 62617d28d9ae1`: found lore thread
- [Phase 4] `b4 dig -a`: v1→v2 series, patch 8/8
- [Phase 4] `b4 dig -w`: BPF maintainers CC'd
- [Phase 4] Mbox review: Sashiko AI medium concern on ARCH/HOSTARCH
  normalization
- [Phase 4] No stable@vger nomination found in thread
- [Phase 5] `LLVM_LDLIBS` used at Makefile line 707 for selftest linking
- [Phase 5] `ARCH`/`HOSTARCH` defined in `tools/scripts/Makefile.arch`
  (included line 3)
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9; `make
  kernelversion`: 6.18.44
- [Phase 6] Buggy code confirmed at Makefile lines 185–192
- [Phase 6] Patch applies cleanly to current tree
- [Phase 7] Subsystem: bpf selftests (peripheral)
- [Phase 8] Failure mode: link error on cross-build; severity LOW; no
  runtime/security impact

**YES**

 tools/testing/selftests/bpf/Makefile | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 591e7e77f89ba..372ae53ae63ae 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -182,8 +182,15 @@ ifeq ($(feature-llvm),1)
   LLVM_CONFIG_LIB_COMPONENTS := mcdisassembler all-targets
   # both llvm-config and lib.mk add -D_GNU_SOURCE, which ends up as conflict
   LLVM_CFLAGS  += $(filter-out -D_GNU_SOURCE,$(shell $(LLVM_CONFIG) --cflags))
-  # Prefer linking statically if it's available, otherwise fallback to shared
-  ifeq ($(shell $(LLVM_CONFIG) --link-static --libs >/dev/null 2>&1 && echo static),static)
+  # Cross compilation must use dynamic linking to avoid unresolved library
+  # dependencies. For native build, prefer linking statically if it's
+  # available, otherwise fallback to shared.
+  ifneq ($(ARCH), $(HOSTARCH))
+    LLVM_LINK_STATIC :=
+  else
+    LLVM_LINK_STATIC := $(shell $(LLVM_CONFIG) --link-static --libs >/dev/null 2>&1 && echo y)
+  endif
+  ifeq ($(LLVM_LINK_STATIC),y)
     LLVM_LDLIBS  += $(shell $(LLVM_CONFIG) --link-static --libs $(LLVM_CONFIG_LIB_COMPONENTS))
     LLVM_LDLIBS  += $(filter-out -lxml2,$(shell $(LLVM_CONFIG) --link-static --system-libs $(LLVM_CONFIG_LIB_COMPONENTS)))
     LLVM_LDLIBS  += -lstdc++
-- 
2.53.0

