Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A165476FC;
	Mon, 31 Aug 2026 13:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183981; cv=none; b=VUUxte0hK3Xrf7P/q2cb4xMrlpqSVQ2Un0ieTmsmaW+iSQf7Xnu6lc9caoFJCYxKQS8kr7dNAAMptTm5fmSrl/sPxZdz259kSlqe4zktQnsb09zWvEqLzIsnGlsPt9t9SyokYXOd/ZCB8/p82MV3BSq4K3j4WyatFR5re+qBFCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183981; c=relaxed/simple;
	bh=YAfnDOC5zY1e+UV28FtmJyCelrSWxoNwOdIP5MkjSQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RW9s+ncsxvshSz6l7A08QNYW9Js7e61zTq4yod3EQStPODgswX6Unrb0PwRpLyTIoqTRbBtvgIVj+G0TcYfON5JZ09vVLYN312z79wpt2WARhWITbCJr39K3jh6/9UUl3LQh7ConsKd9ItlhYXxkb7pYDo/ZLFUJZu5chntRI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7hwDB89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7hwDB89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B071F01558;
	Mon, 31 Aug 2026 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183978;
	bh=f95LOdgaP6V6KgOb6K1Z2STN85DVH3UJaoxWcXsZFME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7hwDB89gcKTMDkCyeBNMAcdmqrF9YsUcfUEED41t44fj+Tajvt+hBlDSXvzFvggA
	 bAwqQY0fqcQk+fqwHfya6ag05niWbPBac50t+O7OXV66Zmi9NXdAMmjva+y5K12YAZ
	 bPvdUYZtTsHb5syPh5mdE0nzSwkY/S500a/rWsrGvPM3huG+SLOcCL10wv7mghlpdG
	 hRZi1q7eniA2Mo5Ctf6HB0FCYu+FXnPj7YLait//4wKbavwUCkP9ocqbEhISo+PJsG
	 L4k78Jjvlc66/vs76wbHAPTcT3LCrhZ59zK88DbfUIiA1zHXPBrIMNV9oDxEy2eK7t
	 5t8CimAvpY2vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	oleg@redhat.com,
	peterz@infradead.org,
	davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] sparc64: uprobes: add missing break
Date: Mon, 31 Aug 2026 09:27:25 -0400
Message-ID: <20260831133314.4125787-417-sashal@kernel.org>
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

[ Upstream commit 5b0eee4cd812bd6547eea393cb9b5c0322f26c88 ]

Missing fallthrough causes failure with newer compilers:

arch/sparc/kernel/uprobes.c:284:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
  284 |         default:
      |         ^
arch/sparc/kernel/uprobes.c:284:2: note: insert 'break;' to avoid fall-through
  284 |         default:
      |         ^
      |         break;

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[sparc64/uprobes]` `[add]` — Add a missing `break`
statement in the sparc64 uprobes die-notifier switch.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Signed-off-by:** Rosen Penev `<rosenp@gmail.com>` (author)
- **Reviewed-by:** Masami Hiramatsu (Google) `<mhiramat@kernel.org>`
  (uprobes maintainer)
- **Reviewed-by:** Andreas Larsson `<andreas@gaisler.com>` (sparc
  maintainer)
- **Signed-off-by:** Andreas Larsson `<andreas@gaisler.com>` (subsystem
  maintainer ack)
- No Fixes:, Reported-by:, Link:, Cc: stable@vger.kernel.org, or Tested-
  by: tags
- Notable: dual Reviewed-by from uprobes and sparc maintainers; no
  syzbot or user bug reports

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug description:** Missing `break` after `case DIE_SSTEP:` causes an
  unannotated fall-through warning that becomes a build error under
  `-Werror,-Wimplicit-fallthrough`.
- **Symptom:** sparc64 kernel compilation fails on
  `arch/sparc/kernel/uprobes.c:284`.
- **Root cause:** `case DIE_SSTEP:` lacks `break;` before `default:`.
- **Version info:** None stated; failure is tied to newer compilers
  enforcing `-Wimplicit-fallthrough`.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not a hidden runtime bug fix. The fall-through lands on
`default: break;`, which is a no-op. This is a **build-fix / compiler-
warning fix**, not a functional correctness fix. No hidden UAF, race, or
logic error.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `arch/sparc/kernel/uprobes.c` (+1 line)
- **Function modified:** `arch_uprobe_exception_notify()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `case DIE_SSTEP:` could fall through to `default:`
  (compiler warning/error).
- **After:** `case DIE_SSTEP:` ends with `break;`, matching `case
  DIE_BPT:` and other architectures.
- **Path affected:** Die-notifier callback for uprobes on sparc64;
  normal and error paths unchanged at runtime.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Build fix (compiler `-Wimplicit-fallthrough` /
  `-Werror`)
- **Mechanism:** Unannotated switch fall-through triggers a warning;
  with `-Werror` it fails the build. No runtime behavior change because
  `default:` only contains `break;`.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct; matches powerpc/mips pattern.
- Minimal, zero regression risk.
- No API, locking, or logic changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** Buggy code introduced in `e8f4aa6087fa8` ("sparc64:Support
User Probes for sparc", Oct 2016, Allen Pais). Present in this tree
since uprobes support landed on sparc64.

### Step 3.2: Follow Fixes: Tag
**Record:** No Fixes: tag. N/A.

### Step 3.3: File History
**Record:** Recent `arch/sparc/kernel/uprobes.c` history in 6.18.y:
- `a51b8c83bf274` sparc64: Fix prototype warning for uprobe_trap
- SPDX/treewide cleanups
- Original `e8f4aa6087fa8` uprobes introduction

Commit `5b0eee4cd812b` is on `master` but **not** in
`stable/linux-6.18.y`. Standalone one-patch fix.

### Step 3.4: Author's Other Commits
**Record:** Rosen Penev has no other sparc commits in this tree. Fix
came through sparc maintainer tree (Andreas Larsson).

### Step 3.5: Dependencies
**Record:** No prerequisites. Applies cleanly to current 6.18.y
`uprobes.c`. Self-contained.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260506031815.779909-1-rosenp@gmail.com
- Single-patch submission, no series revisions (`b4 dig -a` not needed).
- No stable nomination or NAKs found in thread.
- Maintainer reviews present (Hiramatsu, Larsson).

### Step 4.2: Reviewers
**Record:** CC'd to `sparclinux@vger.kernel.org`, `linux-trace-
kernel@vger.kernel.org`, David S. Miller, Oleg Nesterov, Peter Zijlstra
— appropriate uprobes/sparc audience.

### Step 4.3: Bug Report
**Record:** No external bug report. Author demonstrated compiler error
in commit message and patch.

### Step 4.4: Related Patches
**Record:** Standalone. No series dependencies.

### Step 4.5: Stable Mailing List
**Record:** No stable-list discussion found. Not searched exhaustively;
no stable nomination in patch thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `arch_uprobe_exception_notify()` — only function modified.

### Step 5.2: Callers
**Record:** Registered as die notifier in `kernel/events/uprobes.c`:

```2901:2913:kernel/events/uprobes.c
static struct notifier_block uprobe_exception_nb = {
        .notifier_call          = arch_uprobe_exception_notify,
        .priority               = INT_MAX-1,    /* notified after
kprobes, kgdb */
};

void __init uprobes_init(void)
{
        ...
        BUG_ON(register_die_notifier(&uprobe_exception_nb));
}
```

Called from kernel die-notification path on `DIE_BPT` / `DIE_SSTEP` when
uprobes are active.

### Step 5.3: Callees
**Record:** `user_mode()`, `uprobe_pre_sstep_notifier()`,
`uprobe_post_sstep_notifier()`.

### Step 5.4: Call Chain / Reachability
**Record:** Reachable when `CONFIG_UPROBES` is enabled and a userspace
breakpoint/single-step trap occurs. Not a syscall path;
debugging/tracing infrastructure. Build impact is unconditional when
`uprobes.c` is compiled.

### Step 5.5: Similar Patterns
**Record:** powerpc has the correct `break` after `DIE_SSTEP`:

```148:159:arch/powerpc/kernel/uprobes.c
        switch (val) {
        case DIE_BPT:
                if (uprobe_pre_sstep_notifier(regs))
                        return NOTIFY_STOP;
                break;
        case DIE_SSTEP:
                if (uprobe_post_sstep_notifier(regs))
                        return NOTIFY_STOP;
                break;
        default:
                break;
        }
```

sparc64 was missing the equivalent `break`. Prior sparc precedent:
`f6f8c1c09c224` ("sparc builds with -Werror") addressed similar fall-
through warnings.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.44** (`stable/linux-6.18.y`).
Buggy code at lines 280–285:

```280:286:arch/sparc/kernel/uprobes.c
        case DIE_SSTEP:
                if (uprobe_post_sstep_notifier(args->regs))
                        ret = NOTIFY_STOP;

        default:
                break;
```

Bug present since 2016 uprobes introduction.

### Step 6.2: Backport Complications
**Record:** Clean one-line apply expected. No conflicting changes in
this file on 6.18.y since the uprobes introduction.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix in 6.18.y. `git merge-base --is-ancestor
5b0eee4cd812b HEAD` → NOT IN TREE.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **arch/sparc** uprobes — **PERIPHERAL** (sparc64 only,
tracing/debugging). Build impact matters for sparc64 builders.

### Step 7.2: Subsystem Activity
**Record:** Low churn on this file; last functional change was prototype
fix `a51b8c83bf274`.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** sparc64 kernel **builders** with `CONFIG_UPROBES` enabled.
`sparc64_defconfig` has `CONFIG_UPROBE_EVENTS=y`, which selects
`UPROBES` via Kconfig. Not universal; sparc64-specific and config-
dependent.

### Step 8.2: Trigger Conditions
**Record:**
- `-Wimplicit-fallthrough` is enabled globally
  (`scripts/Makefile.extrawarn:94` via
  `CONFIG_CC_IMPLICIT_FALLTHROUGH`).
- Becomes a **build failure** with `-Werror` (`CONFIG_WERROR=y` or `make
  W=e`).
- Default `sparc64_defconfig` does not set `CONFIG_WERROR`; typical
  distro builds may see a warning only.
- Developers/CI using `-Werror` or `W=e` hit a hard failure.
- **No unprivileged runtime trigger**; no security impact.

### Step 8.3: Failure Mode Severity
**Record:**
- **Build failure** with `-Werror`: **MEDIUM** for
  developers/maintainers.
- **Runtime:** **NONE** — fall-through to `default: break;` is
  semantically identical.
- **Warning-only** builds: **LOW**.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Unblocks sparc64 builds with WERROR/W=e and UPROBES;
  aligns with other arch implementations; matches stable precedent for
  `-Wimplicit-fallthrough` fixes (e.g. `3ab659eb696f0`, `98845e7753902`
  in this tree).
- **Risk:** Very low — one `break;` with no behavioral change.
- **Ratio:** Favorable for a build-fix backport, though end-user runtime
  benefit is zero.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Valid **build fix** (stable exception category)
- Demonstrated `-Werror` compilation failure
- `uprobes.c` compiled in default sparc64 defconfig (`UPROBE_EVENTS=y` →
  `UPROBES`)
- One-line, maintainer-reviewed, obviously correct
- Bug present since 2016; applies cleanly to 6.18.y
- Precedent for similar implicit-fallthrough fixes in stable

**AGAINST backport:**
- **No runtime bug** — purely compiler hygiene
- sparc64 is niche; limited user base
- Default production builds may only warn, not fail
- Low severity for running systems

**Unresolved:** Whether any sparc64 distro enables `CONFIG_WERROR` by
default (not verified; not needed for decision).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — trivial fix; reviewed by
   uprobes and sparc maintainers.
2. Fixes a real bug? **PASS** — real build failure with `-Werror`.
3. Important issue? **PASS (build-fix category)** — not
   crash/corruption, but prevents compilation for sparc64+UPROBES+WERROR
   builds.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code confirmed in v6.18.44;
   patch applies cleanly.

### Step 9.3: Exception Category
**Record:** **Build fix** — prevents compilation failure under
`-Wimplicit-fallthrough` + `-Werror`.

### Step 9.4: Decision Rationale

This commit fixes a sparc64 build break, not a runtime defect. The
missing `break` is harmless at runtime because execution falls through
to `default: break;`, but it violates `-Wimplicit-fallthrough` and fails
builds that use `-Werror` — a configuration kernel developers and CI
commonly use. With `UPROBE_EVENTS=y` in `sparc64_defconfig`, `uprobes.c`
is compiled by default on sparc64. The fix is one line, matches powerpc
and other architectures, is maintainer-reviewed, and fits the stable
exception for build fixes. Risk is negligible.

---

## Verification

- **[Phase 1]** `git show 5b0eee4cd812b`: parsed subject, body, tags
- **[Phase 2]** `git show 5b0eee4cd812b -p`: confirmed +1 `break;` in
  `arch_uprobe_exception_notify()`
- **[Phase 2]** Read `arch/sparc/kernel/uprobes.c:274-286`: confirmed
  missing `break` in 6.18.y
- **[Phase 2]** Read `arch/powerpc/kernel/uprobes.c:148-159`: confirmed
  correct pattern on other arch
- **[Phase 3]** `git blame -L 274,286 arch/sparc/kernel/uprobes.c`: bug
  since `e8f4aa6087fa8` (2016)
- **[Phase 3]** `git merge-base --is-ancestor 5b0eee4cd812b HEAD`: NOT
  IN TREE
- **[Phase 3]** `git log --oneline -20 -- arch/sparc/kernel/uprobes.c`:
  file history verified
- **[Phase 4]** `b4 dig -c 5b0eee4cd812b`: lore URL found
- **[Phase 4]** `b4 dig -c 5b0eee4cd812b -w`: recipients and reviewers
  verified
- **[Phase 4]** `b4 dig -m /tmp/uprobes_break.mbox`: thread saved; no
  stable nomination found
- **[Phase 5]** `grep arch_uprobe_exception_notify`: callers in
  `kernel/events/uprobes.c` verified
- **[Phase 6]** `git describe HEAD`: v6.18.44 on `stable/linux-6.18.y`
- **[Phase 6]** Read `arch/sparc/configs/sparc64_defconfig`:
  `CONFIG_UPROBE_EVENTS=y` at line 204
- **[Phase 6]** `kernel/trace/Kconfig:778-783`: `UPROBE_EVENTS` selects
  `UPROBES`
- **[Phase 6]** `arch/sparc/Kconfig:150-151`: `ARCH_SUPPORTS_UPROBES`
  for SPARC64
- **[Phase 6]** `init/Kconfig:939-942`: `CC_IMPLICIT_FALLTHROUGH`
  enabled by default
- **[Phase 6]** `scripts/Makefile.extrawarn:94,217-219`: global
  `-Wimplicit-fallthrough`; `-Werror` with `CONFIG_WERROR` or `W=e`
- **[Phase 6]** `init/Kconfig:227-229`: `CONFIG_WERROR` defaults to
  `COMPILE_TEST` (typically off in defconfig)
- **[Phase 7]** `git show f6f8c1c09c224`: prior sparc
  `-Werror`/fallthrough precedent
- **[Phase 8]** Runtime analysis: fall-through to `default:break` is a
  no-op — **no runtime bug**
- **[Phase 8]** `git log --oneline --grep='missing break'`: similar
  implicit-fallthrough fixes exist in tree history

**YES**

 arch/sparc/kernel/uprobes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/kernel/uprobes.c b/arch/sparc/kernel/uprobes.c
index 305017bec164f..c8cac64e9988a 100644
--- a/arch/sparc/kernel/uprobes.c
+++ b/arch/sparc/kernel/uprobes.c
@@ -280,6 +280,7 @@ int arch_uprobe_exception_notify(struct notifier_block *self,
 	case DIE_SSTEP:
 		if (uprobe_post_sstep_notifier(args->regs))
 			ret = NOTIFY_STOP;
+		break;
 
 	default:
 		break;
-- 
2.53.0

