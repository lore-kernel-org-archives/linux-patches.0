Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5309491B3D;
	Mon, 19 Oct 2026 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418142; cv=none; b=IdjpfCQQPwYS7yokQQg/23N6205ehsLAEWXQy9uGl7JIIgYBRz6bLdAuPNOH1qyljULphWR4pnScDXVaowKuX6bMg70X0TBE1QDdVmqrynv6oyMPVWMbC9ShDIymOUcs14OSCbv6/jibvuJb7ouIHhGB63QdYRKbyeLeKKa/VX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418142; c=relaxed/simple;
	bh=ySlhVHs5EIvaSq+cdETOQHdQwsOEDbFvT/Gg499Rl0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEv8HMfy7hCIJQhSi5I7BbNAsc74MLZZLipTpaq5tgPyR/b/3pSclHunlDTRsxGGUcY4REFonVmfdHXggb6fq1UMyqcdLvm9Br3q2VmY8ZfMzXCNJuBYIwEl7fUUMJK02eLbdCOsCRLzx1GF3ZF3uOicm4SENi/MsAf55NwxcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9IonbLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9IonbLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA811F000C6;
	Mon, 19 Oct 2026 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418139;
	bh=q6Y5kyHWSxLwi9giqi72Tq/HTjncMBIStO0G17YuWw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9IonbLKKfFHjhquDMRFtdehQRLkhutM5ewown8MizBDZCyRTCruaERbQaDD5wJvV
	 8RNl9wmoTAHrwmawuJ+0uZSKiV/qR8ioUcmtB6zyD24dvSqyjm4W5eTYLr9DCK06Qz
	 AQ3RnwnvydK6p1aHbCtFEknkF5+uEuT1GNCEsL7BXyvIy2jffdNwO7pGvmJJb1mq8t
	 Pbbs9/7F/pozVdyAKbt/DrHLyv/nUgMIn1zVETivEAd8mb9tX8q+XMs1+tTKoj2O6s
	 e4vzbZnz7PNBroeQYj7M7CYyT4GFipg9q33SxqnA1kN5epTMx8sq03xBDHVV5gKaSE
	 dV/I5jitxnUWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rostedt@goodmis.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] selftests/ftrace: Force C locale in ftracetest
Date: Mon, 19 Oct 2026 09:45:31 -0400
Message-ID: <20261019135441.1420968-40-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit c13fcd3951dcc19524ce0b3e852844b16cd32b22 ]

Some ftracetest test cases parse command output by matching English
field names. Tools such as readelf may localize their output via
gettext, while ftracetest currently inherits the user locale from
the environment.

If a translated field name is printed, parsing can fail even though
the tested kernel behavior is unchanged. For example, add_remove_uprobe
can fail to find the ELF entry point and then write a uprobe event with
a missing offset.

Export LC_ALL=C in the top-level ftracetest runner so every test case
gets stable command output by default.

Link: https://lore.kernel.org/all/20260807081512.2974757-2-qirui.001@bytedance.com/

Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a three-line selftest locale fix, the
companion uprobe offset patch is already in this 6.18 tree, and the
runner still inherits the user locale.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[selftests/ftrace] [Force] Force C locale in ftracetest so
  test parsing is locale-stable`

**Step 1.2: Tags**
- Record:
  - `Link: https://lore.kernel.org/all/20260807081512.2974757-2-
    qirui.001@bytedance.com/`
  - `Signed-off-by: Rui Qi <qirui.001@bytedance.com>` (author)
  - `Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>`
    (ftrace/probes maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, or `Cc: stable` (absence is expected for this review)
  - Upstream SHA: `c13fcd3951dcc19524ce0b3e852844b16cd32b22`

**Step 1.3: Body**
- Record: `[Bug] ftracetest inherits the user locale; tools such as
  readelf can print translated field names. Tests that grep English
  strings then fail even though kernel behavior is unchanged.`
  `[Symptom] add_remove_uprobe fails to parse the ELF entry point and
  writes a uprobe event with a missing offset.` `[Versions] none
  stated.` `[Root cause] command-output parsing depends on English
  gettext strings while LC_ALL is not forced.`

**Step 1.4: Hidden bug fix?**
- Record: `[Not disguised.] This is an explicit robustness fix for
  locale-dependent test parsing, not a style cleanup.`

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `[Files] tools/testing/selftests/ftrace/ftracetest +3 / -0`
  `[Functions] none; top-level shell runner` `[Scope] single-file,
  surgical]`

**Step 2.2: Code flow**
- Record: `[Before] ftracetest and every sourced `.tc` inherit LANG/LC_*
  from the environment.` `[After] `export LC_ALL=C` at runner start,
  inherited by all test cases including `readelf` in add_remove_uprobe.`
  `[Path] initialization of the test harness, not kernel runtime.`

**Step 2.3: Bug mechanism**
- Record: `[Category] logic/correctness in the test harness (locale-
  dependent parsing).` `[Mechanism] `add_remove_uprobe.tc` does `grep
  "Entry point"` and `grep LOAD` on `readelf` output. If those strings
  are translated, `ENTRY` is empty, `OFFSET` is empty, and the script
  writes `p:myevent ${REALBIN}:` with no offset.`

**Step 2.4: Fix quality**
- Record: `[Quality] obviously correct; `LC_ALL=C` is the standard way
  to freeze tool output. Three comment+export lines, no API change.`
  `[Regression risk] very low. C locale can change collation/number
  formatting, but ftrace tests parse English tracefs and ELF field
  names. Maintainer asked for runner-wide export rather than
  per-`readelf` wrappers.`

## Phase 3: Git history

**Step 3.1: Blame**
- Record: `[Introduced] ftracetest header is from `6e68e6c5e4b67`
  (2014). The locale-sensitive parsing was added by `dc4b165855f23`
  ("Use readelf to find entry point in uprobe test", 2025-02-26) and
  tightened by `bd4e5a97edf8c` (already in this tree), which greps
  `"Entry point"` with no `LC_ALL=C`.` `[Age] parsing bug present since
  v6.15-era code; still present here.`

**Step 3.2: Fixes: tag**
- Record: `[N/A] no Fixes: tag. Companion series patch 2/2
  (`bd4e5a97edf8c` / upstream `24aa630f6259`) fixes `dc4b165855f23` and
  is already an ancestor of HEAD.`

**Step 3.3: File history**
- Record: `[Related] `bd4e5a97edf8c` already backported here with `Cc:
  stable`. That is v2 2/2 of the same series. In v2, per-command
  `LC_ALL=C` was removed from the uprobe test because patch 1/2 was
  supposed to set it in the runner. This tree has 2/2 without 1/2.`
  `[Standalone?] yes as a diff; semantically it completes that series.`

**Step 3.4: Author**
- Record: `[Author] Rui Qi (ByteDance); not the subsystem maintainer.
  Only other ftrace selftest commit in this tree is the companion offset
  conversion. Maintainer Masami Hiramatsu applied both.`

**Step 3.5: Prerequisites**
- Record: `[Dependencies] none for apply. Insertion is after the
  copyright block, which matches this tree. Local `ftracetest` lacks
  mainline `--rv`; that is later context only and is not required.`
  `[Standalone apply] yes.`

## Phase 4: Mailing list

**Step 4.1: Original discussion**
- Record: `[Lore] https://patch.msgid.link/20260807081512.2974757-2-
  qirui.001@bytedance.com` (WebFetch on lore.kernel.org returned 403;
  thread recovered via `b4 dig -m`).`
- `[Revisions] v1 (2026-08-06): `LC_ALL=C` only on one `readelf` in
  add_remove_uprobe. v2 (2026-08-07): moved to top-level `ftracetest`
  per Masami. Applied version is v2, latest.`
- `[Feedback] Masami on v1: force C locale in the top-level runner, not
  per test. Author agreed and sent v2. Masami applied v2 2/2 with "Good
  catch! OK, let me take it." No NAKs. No reviewer `Cc: stable` on this
  patch (2/2 had `Fixes:` and later got `Cc: stable` in the backport).`

**Step 4.2: Recipients**
- Record: `[To/Cc] Steven Rostedt, Masami Hiramatsu, Mathieu Desnoyers,
  Shuah Khan, Heiko Carstens, linux-trace-kernel, linux-kselftest,
  linux-kernel.`

**Step 4.3: Bug report**
- Record: `[No syzbot/bugzilla.] Cover letter: series fixes two ways
  add_remove_uprobe can build an invalid uprobe offset. v1 body: if
  readelf is translated, ENTRYPOINT is empty and the `uprobe_events`
  write is rejected because the offset after `PATH:` is missing. Author
  is a real user of a non-C locale (ByteDance).`

**Step 4.4: Series**
- Record: `[v2 0/2] "Fix add_remove_uprobe robustness". Patch 1 = this
  commit. Patch 2 = ELF VA→file offset (`bd4e5a97edf8c`), already in
  this tree. v2 2/2 dropped inline `LC_ALL=C` and relies on the runner.`

**Step 4.5: Stable list**
- Record: `[No stable-list discussion found] for this subject. Companion
  2/2 was taken into this tree with `Cc: stable@vger.kernel.org`.`

## Phase 5: Code semantics

**Step 5.1: Functions**
- Record: `[No C functions.] Change is `export LC_ALL=C` in
  `ftracetest`. Affected consumer: `add_remove_uprobe.tc` `readelf`
  parsing.`

**Step 5.2: Callers**
- Record: `[ftracetest-ktap] runs `./ftracetest -K -v`. kselftest
  Makefile lists `ftracetest` / `ftracetest-ktap`. `__run_test` sources
  each `.tc` in a subshell, so `LC_ALL=C` is inherited. Reachable
  whenever someone runs ftrace selftests.`

**Step 5.3: Callees**
- Record: `[readelf -hW / -lW, grep, awk, writes to uprobe_events.]
  Kernel ABI involved is `uprobe_events`, already exercised by the
  test.`

**Step 5.4: Call chain**
- Record: `[kselftest runner → ftracetest-ktap → ftracetest →
  add_remove_uprobe.tc → readelf → uprobe_events.] Userspace-only. Not a
  syscall bug; it does cause a false test failure and a malformed probe
  write.`

**Step 5.5: Similar patterns**
- Record: `[Only this ftrace test greps readelf "Entry point".] Other
  selftests (e.g. mptcp) already pin `LC_ALL=C` on individual commands.
  No `export LC_ALL=C` in this tree's ftrace runner yet.`

## Phase 6: This tree (pending-6.18 / 6.18.53)

**Step 6.1: Buggy code present?**
- Record: `[Yes.] `tools/testing/selftests/ftrace/ftracetest` has no
  `LC_ALL=C`. `add_remove_uprobe.tc` lines 17 and 37 grep English
  `readelf` strings. `git describe HEAD` = `p-6.18-1-g03b85e06ca9bf`;
  `make kernelversion` = `6.18.53`. Introduced by `dc4b165855f23`
  (ancestor of HEAD).`

**Step 6.2: Backport difficulty**
- Record: `[Clean apply.] Copyright-block context matches. `--rv` in the
  candidate hunk is later mainline noise, not needed here.`

**Step 6.3: Related fixes already here?**
- Record: `[Partial.] Offset conversion `bd4e5a97edf8c` is here; locale
  export is not. No earlier equivalent `LC_ALL=C` in this file.`

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[Subsystem] tools/testing/selftests/ftrace` `[Criticality]
  PERIPHERAL for production kernel runtime; IMPORTANT for anyone running
  ftrace kselftests on this stable tree (distro CI, KernelCI, vendor
  QA).`

**Step 7.2**
- Record: `[Activity] active; recent ftrace selftest fixes already
  landed in this 6.18.y tree, including the companion uprobe test fix.`

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: `[config/test-specific] users/CI running ftracetest with a
  non-C locale (zh_CN, de_DE, ja_JP, etc.). No effect on kernel boot or
  production tracing if tests are not run.`

**Step 8.2: Trigger**
- Record: `[Trigger] run ftracetest (or kselftest ftrace) with
  translated binutils/gettext. Common on non-English developer and QA
  machines. Unprivileged users can run the tests if they have tracefs
  access; this is not a privilege-escalation bug.`

**Step 8.3: Failure mode**
- Record: `[Failure] false-negative kselftest; possible write of
  `p:myevent <path>:` with empty offset, which the kernel rejects. Not a
  panic, UAF, or data corruption.` `[Severity] MEDIUM for QA/CI
  correctness; LOW for production kernel runtime.`

**Step 8.4: Risk-benefit**
- Record: `[Benefit] medium for this tree: completes a 2-patch series
  whose second half is already here, so add_remove_uprobe stays locale-
  broken without it.` `[Risk] very low (3 lines, userspace test runner
  only).` `[Ratio] favorable.`

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real, reproducible test failure when `readelf` is localized.
- Companion v2 2/2 is already in this 6.18 tree and depends on runner
  `LC_ALL=C` (inline `LC_ALL=C` was removed in v2).
- Tiny, obviously correct, maintainer-directed.
- Applies cleanly; no kernel ABI/feature change.
- kselftest false failures on stable are used by distros and CI.

Against:
- Not a kernel crash, security hole, deadlock, or data corruption.
- Only hits people who run ftrace selftests under a non-C locale.
- This patch itself was not `Cc: stable` (not used as a NO vote per the
  review rules).

Unresolved:
- Could not fetch lore.kernel.org over HTTP (403); discussion was
  recovered from `b4 dig` mbox. No stable-list thread found.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — 3-line export; maintainer
   requested and applied; author ran `checkpatch` and `sh -n`.
2. Real bug affecting users? **PASS** — false ftracetest failure and
   malformed uprobe write on localized systems.
3. Important issue? **PASS** — not a kernel oops, but it is a real
   kselftest break, and this tree already took the paired functional
   fix. Leaving this out keeps that test locale-fragile.
4. Small and contained? **PASS** — +3 lines, one file.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS**.

**Step 9.3: Exception category**
- Record: `[Not a device-ID/quirk/DT/build/docs exception.] Closest
  analogue is a kselftest robustness/false-failure fix, which stable
  trees routinely take when the test exists in-tree.`

**Step 9.4: Decision**
This should be backported to **this** 6.18.y tree. The bug exists here,
the patch is surgical, and it finishes a series that is already half-
applied.

### What the commit solves for stable users
On a non-C locale, `readelf` can translate `"Entry point"`, so
`add_remove_uprobe` computes an empty offset and fails even though
uprobes work. Distros and CI that run ftrace kselftests against 6.18.y
get a false failure. The offset-conversion fix already in this tree
still greps English `readelf` text and assumed this runner change.

### Risk vs benefit
Benefit is restoring a test that this tree already ships. Risk is
negligible: `LC_ALL=C` only affects the ftracetest process tree.

### Concerns
None material. `--rv` in the original hunk context is not in this tree
and is not required. No further commits are needed for the export to
work.

## Verification
- [Phase 1] Parsed tags: Link to lore msgid `20260807081512.2974757-2`;
  SOBs Rui Qi and Masami Hiramatsu; no Fixes/Reported-by/Cc: stable.
- [Phase 2] Diff: +3 lines in `ftracetest` (`export LC_ALL=C`);
  confirmed local file lacks it.
- [Phase 3] `git describe HEAD` → `p-6.18-1-g03b85e06ca9bf`; `make
  kernelversion` → `6.18.53`.
- [Phase 3] `git merge-base --is-ancestor c13fcd3951dcc1 HEAD` → not an
  ancestor (fix not in tree).
- [Phase 3] `git merge-base --is-ancestor bd4e5a97edf8c HEAD` → yes
  (companion 2/2 is in tree).
- [Phase 3] `git merge-base --is-ancestor dc4b165855f23 HEAD` → yes
  (readelf parsing introduced here).
- [Phase 3] `git blame` on ftracetest header: `6e68e6c5e4b67` (2014); no
  LC_ALL.
- [Phase 3] Read `add_remove_uprobe.tc`: greps `"Entry point"` and
  `LOAD` with no LC_ALL.
- [Phase 4] `b4 dig -c c13fcd3951dcc1` → v2 1/2 msgid link above.
- [Phase 4] `b4 dig -a` → v1 per-readelf LC_ALL, v2 runner-wide
  (applied).
- [Phase 4] `b4 dig -w` → Rostedt, Masami, Desnoyers, Shuah, kselftest
  and trace lists.
- [Phase 4] mbox: Masami asked to set LC_ALL in the runner; no NAKs;
  cover letter describes two invalid-offset paths.
- [Phase 4] lore WebFetch 403; stable-list search found no discussion of
  this subject.
- [Phase 5] `ftracetest-ktap` invokes `./ftracetest -K -v`; `__run_test`
  sources `.tc` files so export is inherited.
- [Phase 6] Insertion context after copyright block is present; `export
  LC_ALL=C` is not.
- [Phase 8] Failure mode verified from v1 message and current test
  script: empty ENTRY → `p:myevent path:` write → test fail, not kernel
  oops.
- UNVERIFIED: live `readelf` translation under a specific locale was not
  executed on this machine; the gettext localization claim is from the
  author and is consistent with binutils behavior, but was not
  reproduced here.

**YES**

 tools/testing/selftests/ftrace/ftracetest | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index cce72f8b03dce..ee3b950e872f6 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -7,6 +7,9 @@
 #  Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
 #
 
+# Keep command output parsing stable regardless of the user's locale.
+export LC_ALL=C
+
 usage() { # errno [message]
 [ ! -z "$2" ] && echo $2
 echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
-- 
2.53.0

