Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2745D3C37;
	Mon, 19 Oct 2026 14:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418500; cv=none; b=YUL3RSHVqz3ou03jXPw4HN41J8ndrszK5ZtY69Z1Aggpll2P7fDMr2Fbba5zMQyILQ/0ah8oPo4OalQu+27T+69e8qZpRU8bquV8D7ZPwDsX3M48c9Ij+dbpAhRzVP+uZ4uBvJ1vhUgIXU3VaVsVNRnABRP/YCW+wlh79/QauNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418500; c=relaxed/simple;
	bh=22uhUZ/DLHs0CZkgnFH/MBSGlU2p1a3f72O9EochvAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+9vwn0LWcPMYcEO0Mr+IA0eYhYpC7K1iBHBPkaOWL0lM+TOlKDndT7oaKJSNx3MUOTkj/9R6iv5MtEb/qcA1cGqoa6h2/1LkQqLbZvNUALD52kyQduNBO8/wFib4ZgFWwXUI4Rlnm7ikW9XhxwQmYmBdVwq6vJ4D+mtwtQGato=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqhWI+bs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqhWI+bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4917B1F000C7;
	Mon, 19 Oct 2026 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418497;
	bh=ZlO61TrZDclDEP/J41cpKLqQXMCyv97Pd4adStebopw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqhWI+bsOdXCVk36eb4IVA8l8mNum44X8u3KKrudIoXWb5/TuSa7wsHAmWT/hteni
	 mPJPBquBXPxaDYCoskfsSO0H1nd7o0p7jJA3WanEWryr4XykHrs+RXnUec8DTNDPRe
	 232e5qRNLC5pE+6Jny1QNilEd3qx3R0ZLzjCl+13M7wzxLjKxjHEEB1kCw97Fodwry
	 0HSophNji2G2BlVQiILytmCviFI4HyZwnB5ghKSghCDj1y2YnAZ5Ucsx0TGsxR4A6A
	 R7pX85r1yINJpDmMSenzn3DF3Ik+F6nMl0UCuR9EWjibr0sQH1N4YTFN58wLR5l38e
	 5vThEZU7VqW6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] selftests/filesystems/overlayfs: fix set_layers_via_fds link error
Date: Mon, 19 Oct 2026 09:49:41 -0400
Message-ID: <20261019135441.1420968-290-sashal@kernel.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e5804b1024193c91ff2648403beda882cb4f8b6c ]

set_layers_via_fds.c calls open_tree() directly, but that wrapper is
not provided by all C libraries, so the test fails to link with
"undefined reference to open_tree" on toolchains without it.

Use sys_open_tree() from ../wrappers.h, the syscall wrapper already
used for move_mount(), fsmount() and friends here.  This is also a
prerequisite for building the new idmapped_mounts test added to this
directory.

Link: https://patch.msgid.link/20260615-work-idmapped-overlayfs-v1-8-7381632aa402@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a selftest link fix for code that
already exists on 6.18.y, with a clean apply and no kernel runtime
change.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[selftests/filesystems/overlayfs] [fix] [replace libc
  open_tree() with sys_open_tree() so the test links]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Link: https://patch.msgid.link/20260615-work-idmapped-
  overlayfs-v1-8-7381632aa402@kernel.org` — lore/msgid for patch 8/10 of
  the idmapped overlayfs series
- `Reviewed-by: Amir Goldstein <amir73il@gmail.com>` — overlayfs
  maintainer
- `Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>` —
  VFS maintainer / author
- Pipeline-only (ignored for selection): `[Upstream commit
  e5804b1024193c91ff2648403beda882cb4f8b6c]`, `Signed-off-by: Sasha
  Levin`
- Absent (expected): `Fixes:`, `Cc: stable@vger.kernel.org`, `Reported-
  by:`, `Tested-by:`, syzbot

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: `[Bug] set_layers_via_fds.c calls libc open_tree(), which some
  C libraries do not provide. [Symptom] link failure: "undefined
  reference to open_tree". [Version info] none. [Root cause] the test
  already uses sys_fsopen/sys_fsmount/sys_move_mount from wrappers.h,
  but this one test used the libc name instead of sys_open_tree(). The
  message also says the change is a prerequisite for a new
  idmapped_mounts test.`

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: `[Not a hidden fix] The subject and body state a link error.
  That is a real userspace build failure of an existing kselftest, not a
  disguised kernel runtime bug. The "prerequisite for idmapped_mounts"
  line is extra context for a later new test, not the bug being fixed
  here.`

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: `[Files]
  tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
  (+8/-8). [Function] TEST_F(set_layers_via_fds,
  set_layers_via_detached_mount_fds) only. [Scope] single-file surgical
  rename, 8 call sites.]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record: `[Before] eight open_tree(dfd, path,
  OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC) calls (libc symbol). [After] the
  same arguments via sys_open_tree(), the local syscall wrapper. [Path]
  userspace selftest setup for detached overlay layer mounts. No kernel
  path, no error-path logic change, no flag change.]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: `[Category] build / link error (portability). [Mechanism]
  unresolved libc symbol on C libraries without open_tree();
  sys_open_tree() already exists in wrappers.h and issues
  syscall(__NR_open_tree, ...).]`

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: `[Quality] obviously correct: same arguments, wrapper already
  used for the other new-mount syscalls in this file, OPEN_TREE_*
  already defined in wrappers.h. [Regression risk] very low. syscall()
  and libc open_tree() both return fd or -1/errno; the test already uses
  ASSERT_GE(fd, 0). No kernel ABI, locking, or API change.]`

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: `[Introduced by] ccc829b15d48a ("selftests: add tests for
  using detached mount with overlayfs", 2025-02-12). [Present in this
  tree] yes (ancestor of v6.18.53). The test file itself dates to
  af9199145b197 (2024-10-14).]`

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: `[N/A] No Fixes: tag. The intro commit is ccc829b15d48a,
  confirmed via blame on v6.18.53.]`

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: `[Related] 0bd92b9fe538b moved wrappers.h to
  tools/testing/selftests/filesystems/wrappers.h (already in v6.18.53).
  Next commit 226c30d522a3b adds idmapped_mounts.c (new test, not in
  v6.18.53). [Standalone] this rename does not need the new test.]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: `[Author] Christian Brauner, VFS maintainer, overlayfs
  contributor. [Related] authored the original detached-mount test and
  the later idmapped overlayfs series. Not a drive-by change.]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: `[Dependencies] sys_open_tree() and #include "../wrappers.h"
  already exist at v6.18.53. Parent file vs v6.18.53 file: 0-line diff.
  [Standalone] yes for this tree. The new idmapped_mounts test is not
  required.]`

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `[Lore] https://patch.msgid.link/20260615-work-idmapped-
  overlayfs-v1-8-7381632aa402@kernel.org . [Series] v1 only (10 patches,
  "ovl: support idmapped overlay mounts"). This is 08/10. [Review] no
  NAK on this patch. Amir Goldstein Reviewed-by on the whole series
  ("the entire series looks good to me"). His risk comments were about
  FS_ALLOW_IDMAP on overlayfs itself, not this selftest rename. [Stable
  nomination] none in the thread.]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: `[Recipients] Miklos Szeredi, Amir Goldstein, linux-unionfs,
  linux-fsdevel. [Reviewer] Amir Goldstein (overlayfs maintainer) gave
  series-wide Reviewed-by.]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: `[No Reported-by / bugzilla / syzbot] The failure is described
  by the author as a link error. No independent user report found.]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: `[Series] 01–07/10 and 10/10 are overlayfs idmapped-mount
  kernel/docs features. 09/10 is the new idmapped_mounts selftest. Those
  are new functionality and are not in v6.18.53 (no FS_ALLOW_IDMAP on
  overlay in this tree; no idmapped_mounts.c). This 08/10 patch is
  independently a fix to an existing test.]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: `[UNVERIFIED for lore.kernel.org/stable] WebFetch returned
  403. b4 dig of the original thread found no stable@ discussion.]`

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `[Modified] TEST_F(set_layers_via_fds,
  set_layers_via_detached_mount_fds) in userspace kselftest. [Added]
  none. semcode MCP not available; identified from @@ hunks.]`

**Step 5.2: TRACE CALLERS**
- Record: `[Callers] kselftest harness TEST_HARNESS_MAIN / fixture
  runner when executing the set_layers_via_fds binary. Not in-kernel.
  Not interrupt or syscall-kernel context.]`

**Step 5.3: TRACE CALLEES**
- Record: `[sys_open_tree] syscall(__NR_open_tree, dfd, filename, flags)
  in wrappers.h. Same as other sys_* helpers already used in this file
  (sys_fsopen, sys_fsmount, sys_move_mount, sys_fsconfig).]`

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: `[Reachability] only when a developer/CI builds and runs
  overlayfs kselftests (typically root, CONFIG_OVERLAY_FS). Not a
  production kernel path. The link failure happens at test build time,
  before the test runs.]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: `[This tree at v6.18.53] the only remaining libc open_tree()
  uses in tools/testing/selftests besides this file are
  landlock/fs_test.c, which defines its own local open_tree() wrapper.
  Overlayfs tests were already supposed to use sys_open_tree(). Earlier
  overlayfs selftest build fixes already in this tree: e8b8c5264d4eb
  (ppc64 format), 0f05ee447949c (mount.h / sys_mount).]`

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: `[Tree] Makefile VERSION=6 PATCHLEVEL=18 SUBLEVEL=53; git
  describe HEAD = v6.18.53-5049-g0f0bdc2b0dffb; branch autosel.
  [v6.18.53] set_layers_via_fds.c exists and has all 8 open_tree()
  calls. wrappers.h already has sys_open_tree() and
  OPEN_TREE_CLONE/CLOEXEC. Include of ../wrappers.h is already present.
  [Bug introduced] ccc829b15d48a, in this series.]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: `[Difficulty] clean apply. `git diff v6.18.53 088318c9d7a6e^
  -- set_layers_via_fds.c` is empty. Applying the commit patch onto a
  copy of the v6.18.53 file: APPLY_CLEAN.]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: `[No equivalent fix in v6.18.53] still uses open_tree().
  Candidate 088318c9d7a6e is on autosel only, not in v6.18.53 (`git
  merge-base --is-ancestor 088318c9d7a6e v6.18.53` → not an ancestor).]`

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `[Subsystem] kselftests for overlayfs
  (tools/testing/selftests/filesystems/overlayfs/). [Criticality]
  PERIPHERAL for production runtime; IMPORTANT for overlayfs regression
  testing of this LTS tree. Overlayfs itself is a widely used fs
  (containers), but this commit does not touch fs/overlayfs/.]`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: `[Activity] overlayfs selftests were added/extended through
  6.15 (fd mounts, detached mounts, override_creds). Relatively new
  tests, still the ones this 6.18.y tree ships. Kernel overlayfs is
  mature.]`

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: `[Affected] people/CI building overlayfs kselftests on a C
  library without libc open_tree() (author: "not provided by all C
  libraries"). Not universal kernel users. UNVERIFIED which specific
  libc versions still lack it in 2026; glibc added open_tree in 2.36, so
  musl/older glibc are the plausible cases.]`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: `[Trigger] building TEST_GEN_PROGS set_layers_via_fds
  (Makefile already lists it). Common for anyone running these
  selftests. Unprivileged users are not a security concern; this is a
  link failure, not a runtime exploit.]`

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: `[Failure] userspace link error; the kernel still builds and
  boots. Test binary is not produced, so that overlayfs selftest cannot
  be run. [Severity] LOW for production runtime, MEDIUM for stable-
  kernel testability. Matches the documented "build error" class, not
  oops/corruption/deadlock.]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record: `[Benefit] medium for testers of this tree (existing test
  becomes buildable everywhere the rest of this directory already
  builds). [Risk] very low: 8 identifier substitutions, no kernel
  change, wrapper already in tree. [Ratio] favorable if build fixes for
  existing selftests are in scope; this one is.]`

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real link failure of an existing test in this 6.18.y tree
- Documentation/process/stable-kernel-rules.rst explicitly lists build
  errors as acceptable
- 8-line surgical change, obviously correct
- sys_open_tree() and wrappers.h already present; applies cleanly
- Overlayfs maintainer Reviewed-by
- Same class of fix as e8b8c5264d4eb / 0f05ee447949c already in this
  lineage
- No kernel runtime regression surface

AGAINST:
- Not a kernel crash, security hole, or data-corruption fix
- Lives in a 10-patch new-feature series; 09/10 and the kernel idmap
  work must not be pulled with it
- No independent user/syzbot report
- Only testers building kselftests benefit

UNRESOLVED:
- Exact C libraries that still lack open_tree() in 2026 (author claim,
  not independently enumerated)
- No stable@ thread found (lore stable search 403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — rename to an existing
   wrapper; reviewed by Amir Goldstein
2. Fixes a real bug that affects users? **PASS** — existing kselftest
   fails to link on some toolchains
3. Important issue (crash, security, corruption, deadlock)? **PASS**
   under the documented build-error clause, not under crash/security
4. Small and contained? **PASS** — 8 lines, one file, one test
5. No new features or APIs? **PASS** — no new test, no kernel API; the
   later idmapped_mounts test is a different commit
6. Can apply to the local tree? **PASS** — v6.18.53 file matches the
   parent; apply check clean

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: `[Exception] BUILD FIX for an existing in-tree selftest. Not a
  device ID, quirk, DT, or docs-only change.]`

**Step 9.4: MAKE YOUR DECISION**

This should be backported to this 6.18.y tree. The bug is in the tree,
the wrapper is in the tree, and the patch only makes an existing
overlayfs selftest match the sys_* calling convention the rest of the
file already uses. The idmapped-overlay feature series around it is
irrelevant here: that feature and its new test are not in v6.18.53 and
are not part of this diff.

### What the commit solves and why it matters here
`set_layers_via_fds` is already built on 6.18.y (`TEST_GEN_PROGS +=
set_layers_via_fds`). One fixture still calls libc `open_tree()`, so the
binary fails to link where that symbol is missing. Switching to
`sys_open_tree()` fixes that with no kernel change.

### Stable rules
It is small, obviously correct, and a build error. It does not add
features or APIs.

### Risk vs benefit
Risk is negligible (userspace identifier change). Benefit is that
overlayfs kselftests for this LTS tree can actually be built on the same
toolchains the wrappers were written for.

### Concerns
Do not pull 09/10 (`idmapped_mounts.c`) or the overlay FS_ALLOW_IDMAP
kernel patches with this; they implement a new feature this tree does
not have. This commit does not require them.

Verification:
- [Phase 1] Parsed tags: Link to patch 8/10, Reviewed-by Amir Goldstein,
  SOB Christian Brauner; no Fixes/Cc:stable/Reported-by
- [Phase 1] Body: link error "undefined reference to open_tree"; also
  mentions idmapped_mounts prerequisite
- [Phase 2] Diff: 8 open_tree → sys_open_tree in
  set_layers_via_detached_mount_fds; +8/-8 one file
- [Phase 2] wrappers.h: sys_open_tree() = syscall(__NR_open_tree, ...);
  OPEN_TREE_CLONE/CLOEXEC defined
- [Phase 3] git describe HEAD: v6.18.53-5049-g0f0bdc2b0dffb; make
  kernelversion 6.18.53
- [Phase 3] git merge-base --is-ancestor 088318c9d7a6e v6.18.53: NOT in
  v6.18.53
- [Phase 3] git blame v6.18.53: open_tree() lines from ccc829b15d48a
  (2025-02-12), present in this tree
- [Phase 3] git diff v6.18.53 vs commit parent for this file: 0 lines
  (identical)
- [Phase 3] idmapped_mounts.c: not in v6.18.53; FS_ALLOW_IDMAP not set
  on overlay in this tree
- [Phase 4] b4 dig -c e5804b1024193c91ff2648403beda882cb4f8b6c: matched
  08/10 of ovl idmapped series
- [Phase 4] b4 dig -a: v1 only
- [Phase 4] b4 dig -w: Miklos Szeredi, Amir Goldstein, linux-unionfs,
  linux-fsdevel
- [Phase 4] b4 dig -m: Amir series-wide Reviewed-by; risk comments were
  about kernel FS_ALLOW_IDMAP, not this patch; no NAK on 08/10
- [Phase 4] lore WebFetch 403; stable list search 403 — UNVERIFIED
  beyond the saved mbox
- [Phase 5] semcode unavailable; callers are kselftest harness only
- [Phase 5] git grep v6.18.53: only this file plus landlock (local
  wrapper) use open_tree() in selftests
- [Phase 6] v6.18.53 has the 8 open_tree() calls and ../wrappers.h
  include; patch apply onto that file: APPLY_CLEAN
- [Phase 7] tools/testing/selftests/filesystems/overlayfs; not
  fs/overlayfs
- [Phase 8] Failure mode: userspace link error; severity LOW runtime /
  build-error class
- UNVERIFIED: exact C libraries lacking open_tree() in 2026; no stable@
  thread (403)

**YES**

 .../filesystems/overlayfs/set_layers_via_fds.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index dc0449fa628f8..d4a645ec88636 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -624,7 +624,7 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 
 	ASSERT_EQ(sys_move_mount(fd_tmpfs, "", -EBADF, "/set_layers_via_fds_tmpfs", MOVE_MOUNT_F_EMPTY_PATH), 0);
 
-	fd_tmp = open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	fd_tmp = sys_open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(fd_tmp, 0);
 
 	layer_fds[0] = openat(fd_tmp, "upper", O_CLOEXEC | O_DIRECTORY | O_PATH);
@@ -633,25 +633,25 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 	layer_fds[1] = openat(fd_tmp, "work", O_CLOEXEC | O_DIRECTORY | O_PATH);
 	ASSERT_GE(layer_fds[1], 0);
 
-	layer_fds[2] = open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[2] = sys_open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[2], 0);
 
-	layer_fds[3] = open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[3] = sys_open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[3], 0);
 
-	layer_fds[4] = open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[4] = sys_open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[4], 0);
 
-	layer_fds[5] = open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[5] = sys_open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[5], 0);
 
-	layer_fds[6] = open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[6] = sys_open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[6], 0);
 
-	layer_fds[7] = open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[7] = sys_open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[7], 0);
 
-	layer_fds[8] = open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[8] = sys_open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[8], 0);
 
 	ASSERT_EQ(close(fd_tmpfs), 0);
-- 
2.53.0

