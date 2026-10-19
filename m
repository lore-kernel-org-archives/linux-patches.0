Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72779513BB9;
	Mon, 19 Oct 2026 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418222; cv=none; b=Xze10jUgCKwCAgRgW10pgs7XXDwe6gX3cToLi3fuzG2kN7ty/Nuc+f4wn0urYo7MiS8fLGltKghgGaC9HsHXGrkg2qtXusu6gHNfboW8jDSqZwld7GqTvFS4oO7zv2eJCZOx41gsM9SVLH+eutpy2Tcg+xHjdBkGzujrP4FLIvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418222; c=relaxed/simple;
	bh=cxkFP+7Zr8mgYtM6Y7zky3J6+jbW/OsGrn2CamG3hyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O0rtPQ7uyP22fmgXrIR+Sdy3ONu08dJOdZaVZzrfBEmIGJm5WJjAFL3ePoRh/mX8T4gj2rWJaXTjV4x56WBqlmjhTkZp5qjU8eY6HCFSUBLz7lZWoyo4UxE3YNeo9YeCV9lyJj4WatSHAkz8eeo4mK4CB33KiWpH9EoIYeIqnWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQaKM/T3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQaKM/T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF0C1F000C7;
	Mon, 19 Oct 2026 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418219;
	bh=nL4fSE6q4hzExWtxquVD6K/lhTni8lNaviwhzv76uJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQaKM/T3k4ylXivoHvHpB6UgRRRkoukoLJCYM/m0wPma7nJE0kpCr+WFh4ppncDoM
	 P7UChUrKlcWauPgQnFLD1xTFnOQQbOEA0Jq4VnWXUq4Eb8wCqat2krgi1ruR6n+0gC
	 bj+EKj3wh6w6G9ZrkriXSL6o1wgXDK+PTc04rs3Fu9CBbuX6rmz+0kUrtaIwKeDF/z
	 3V0ug9bLatT3nOeKxyN+lE9tv3OyvijsBv0G5euMPkn5s4N+sM740ybCJuct4j7nZo
	 r0yf5Y+sFHFae9uk5M1ppNFrQVenw3BAsbk0CWpcN1vXIOpLzxka3SxF+rFd6pcv/g
	 4xSb2gX4mxinw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] Revert "namei: don't reveal overmounted entries in refwalk"
Date: Mon, 19 Oct 2026 09:46:28 -0400
Message-ID: <20261019135441.1420968-97-sashal@kernel.org>
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

[ Upstream commit 214897acc8c2e5d6b63189d23ccaed6fa2af45a9 ]

This reverts commit 8189ab688f5a2c745dc90b63374da02f213d6994.

This bug class is bigger than can be fixed with this simple patch.
Back out of it and give us some time to fix this properly.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This revert should go into this 6.18.57 tree. The incomplete
`unlink_may_reveal()` check is already in v6.18.57, the VFS maintainer
pulled it back as an rc8 fix, and leaving it here regresses common
unlink/open races.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[vfs/namei] [Revert] undo "don't reveal overmounted entries in
refwalk"`

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- No `Fixes:` tag on the revert itself (it names the reverted SHA in the
  body)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, `Link:`,
  or `Cc: stable`
- `Signed-off-by: Christian Brauner <brauner@kernel.org>` (VFS
  maintainer; ignore Sasha Levin SOB)
- Body: `This reverts commit 8189ab688f5a2c745dc90b63374da02f213d6994`

The original commit that is being reverted **did** have `Fixes:
8ed936b5671b`, `Cc: stable@vger.kernel.org`, and `Link:
https://patch.msgid.link/20261002-work-mount-
fixes-4-v1-2-dd44b89d44ce@kernel.org`. That is why 8189ab68 already
landed in this stable series; the revert is the follow-up.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug description: the earlier “simple patch” does not cover this bug
  class
- Symptom/failure mode: not a crash; an incomplete pathwalk/mount-cover
  check that must be withdrawn
- Version information: none in the revert message
- Root cause (author): “This bug class is bigger than can be fixed with
  this simple patch. Back out of it and give us some time to fix this
  properly.”

Linus’s `vfs-7.3-rc8.fixes` pull restates the same thing: *Revert
"namei: don't reveal overmounted entries in refwalk" from the rc7 fixes.
The bug class is bigger than that patch.*

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised cleanup. This is an explicit revert of a recently
merged, incomplete VFS change. A later (unmerged) follow-up documented a
real regression: any unlink/rename racing a refwalk returned `-ESTALE`
and forced a full `LOOKUP_REVAL` walk, which on NFS/FUSE revalidates
every path component.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/namei.c` only
- Mainline revert: remove `unlink_may_reveal()` (~27 lines) and its one
  call site (2 lines). Net −29
- Local 6.18.y equivalent of the original add is `5f97df8ca7fad`; the
  revert is its inverse
- Functions: delete `unlink_may_reveal`; one call removed from
  `step_into()` (this tree) / `step_into_slowpath()` (mainline after a
  later split)
- Scope: single-file surgical revert

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before (v6.18.57): in the non-RCU / refwalk arm of `step_into()`,
  after `handle_mounts()`, `unlink_may_reveal()` returns true if the
  dentry is `cant_mount()` **and** `d_unlinked()`, the walk has not
  crossed a mount, and flags are not `WALK_NOFOLLOW`/`LOOKUP_REVAL`. It
  `dput()`s `path->dentry` and the caller returns `-ESTALE`.
- After: that check is gone; refwalk accepts the dentry as it did before
  5f97.
- Path: common pathname lookup (`open`/`stat`/`lookup`), refwalk only
  (RCU walk already retries via `d_seq`/`mount_lock`).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: revert of an incomplete logic/correctness change that also
  caused a lookup-retry regression
- Mechanism: `dont_mount()` runs on **every** successful `vfs_unlink()`
  / `vfs_rmdir()` / rename-over, not only mountpoints. Combined with
  `d_unlinked()`, the helper treated ordinary unlinks as “may reveal a
  covered file” and forced `-ESTALE` → `LOOKUP_REVAL`. That is far
  broader than the mount-cover race it meant to close, and it still did
  not cover the rest of the bug class.

Verified `dont_mount()` call sites in this tree: `vfs_rmdir()` ~4558,
`vfs_unlink()` ~4679, `vfs_rename()` ~5230.

Verified ESTALE retry in this tree:
```2708:2709:fs/namei.c
        if (unlikely(retval == -ESTALE))
                retval = path_lookupat(&nd, flags | LOOKUP_REVAL, path);
```
Same pattern in `do_filp_open()` / `do_file_open_root()`. The helper
itself skipped the check when `LOOKUP_REVAL` was already set, which
matches the “fail once, then full revalidate” behavior.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Quality: obviously correct as a revert — it is the exact inverse of
  5f97 in this tree
- Regression risk of the revert: re-opens the remaining refwalk window
  where a walker that already held the dentry can see a file after its
  covering mounts were detached. That race is old (Fixes target
  8ed936b5671b, 2014). 6.18.y lived with it until 6.18.57. A sibling
  backport, `d29cd99db3db7` (“unhash a dentry before detaching the
  mounts”), remains and still shrinks the *new lookup* side of the race.
- Risk of keeping 5f97: extra `LOOKUP_REVAL` on common unlink/create
  storms; incomplete security fix in core pathwalk

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: At v6.18.57, every `unlink_may_reveal` line and the
`step_into()` call are `5f97df8ca7fad` (Christian Brauner, 2026-10-02;
committed to 6.18.y by Greg Kroah-Hartman on 2026-10-15). Surrounding
`step_into()` logic is old Al Viro/Linus code (2011–2022).

Step 3.2: FOLLOW THE FIXES: TAG
Record: The revert has no Fixes tag. It reverts mainline `8189ab688f5a`
= local `5f97df8ca7fad`.
- `git merge-base --is-ancestor 5f97df8ca7fad v6.18.57` → yes
  (v6.18.57~479)
- `git merge-base --is-ancestor 5f97df8ca7fad v6.18.56` → no
- Original 8189ab68 `Fixes: 8ed936b5671b` **is** an ancestor of this
  tree (2014-10-09)

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `d29cd99db3db7 namespace: unhash a dentry before detaching the mounts
  on it` is also in v6.18.57 (same Greg KH batch, same original series).
  It stays; this revert does not undo it.
- No other `unlink_may_reveal` / `DCACHE_UNCOVERED` commits in this tree
- Standalone revert, not patch 2/N of something this tree still needs

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Christian Brauner is the VFS maintainer. Recent `fs/namei.c`
work in this history includes the original add, this revert, and other
VFS fixes. Weight: high.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: The only prerequisite is that 5f97 exists, which it does. The
revert applies as the exact inverse of 5f97 (`step_into`, not mainline’s
later `step_into_slowpath`). No new helpers. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 214897acc8c2` failed: lore.kernel.org returned errors
  (UNVERIFIED: no dedicated mailed revert thread found; Brauner likely
  committed this directly)
- WebFetch of lore.kernel.org returned 403 (UNVERIFIED: full lore
  thread)
- Original add was series `work-mount-fixes-4` patch 02/21 (msgid
  `20261002-work-mount-fixes-4-v1-2-dd44b89d44ce@kernel.org`); also on
  lkml.iu.edu / patchew
- Linus merged the revert in `1dbb7422053fa` *Merge tag
  'vfs-7.3-rc8.fixes'* and called it out in the pull text
- An unmerged follow-up (syzbot CI series) explained the LOOKUP_REVAL
  regression and tried `DCACHE_UNCOVERED`; that approach was **not**
  merged — they reverted instead

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` failed (lore error). Author is the VFS maintainer;
Linus merged it as an rc8 VFS fix. That is stronger than a typical
mailing-list Ack.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla on the revert. The **original** add included
a userspace reproducer (`unlink_covered`) showing the mount-cover race
(~27 hits/60s without widening). The unmerged follow-up’s `unlink_storm`
reproducer showed 463 LOOKUP_REVAL retries in 16.8 million opens from
the too-broad check.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Original add was 02/21 of a large mount-fixes series. Sibling
`unhash a dentry before detaching` is already in 6.18.57 and is **not**
reverted. No merged “proper” replacement for `unlink_may_reveal` exists
in this tree or in the nearby mainline objects inspected.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search could not be fetched (403).
UNVERIFIED whether anyone separately requested this revert on the stable
list. Not needed: the original went to 6.18.57 via `Cc: stable`, and the
author immediately backed it out in mainline.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `unlink_may_reveal` (removed), `step_into` (call removed). No
semcode tools available.

Step 5.2: TRACE CALLERS
Record: `step_into()` callers in this tree:
- `handle_dots()` (WALK_NOFOLLOW — helper returned false anyway)
- `walk_component()` — every normal path component
- one more WALK_NOFOLLOW site ~2660
- `open_last_lookups` path ~3922 (`WALK_TRAILING`)
Impact surface: **every pathname lookup** that drops out of RCU-walk
into refwalk.

Step 5.3: TRACE CALLEES
Record: Helper used `cant_mount()`, `d_unlinked()`,
`dput(no_free_ptr(path->dentry))`. Returning `-ESTALE` skipped the
normal `dput(nd->path.dentry)` / `mntput` in `step_into()`;
`terminate_walk()` still owns `nd->path`. The extra `dput` was only on
the ESTALE path.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace `open`/`openat`/`stat`/`fstatat`/etc. →
`filename_lookup` / `do_filp_open` → `link_path_walk` → `walk_component`
→ `step_into`. Unprivileged users trigger this constantly. The false
ESTALE path is a realistic unlink vs open race, not only the exotic
mount-cover case.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: No other `unlink_may_reveal` copies. `cant_mount()` remains in
`fs/namespace.c` and `fs/dcache.c` for mount setup, which is correct and
unrelated.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes, in **v6.18.57** (`fs/namei.c` `unlink_may_reveal` + call in
`step_into`). Tree identity: `git describe HEAD` =
`v6.18.57-155-gcdf239ca885b2`, `make kernelversion` = 6.18.57.
Introduced here by 5f97 (upstream 8189ab68), first in 6.18.57, not
6.18.56.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Local revert hunks match 5f97 exactly (`step_into`,
not `step_into_slowpath`). No conflicting namei refactor between 5f97
and v6.18.57.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No later replacement for this check. `d29cd99` (unhash before
detach) is present and complementary; it must stay. This revert does not
remove it.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `fs/namei.c` — VFS pathname lookup. **CORE**. Affects every user
of every filesystem.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature, still actively fixed (recent mount/namespace series).
This is not staging/experimental code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Universal for anyone running 6.18.57+. NFS/FUSE users feel the
LOOKUP_REVAL retry cost most. Container/user-ns users care about the
original mount-cover race; that race is only partially addressed by
d29cd99 and was not fully fixed by 5f97.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- False ESTALE: concurrent unlink/rename vs refwalk on any name
  (`dont_mount` is unconditional). Common.
- Original cover-reveal race: unlink of a mountpoint while another task
  walks the covering name. Narrow but real; original commit measured 27
  hits/60s.
- Unprivileged users can trigger both (open/unlink). The cover case
  typically needs mount privileges or a shared mount namespace.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Keeping 5f97: extra full-path revalidation (MEDIUM–HIGH on NFS/FUSE;
  LOW on local tmpfs except under unlink storms). Incomplete mount-cover
  fix (the author says the class is bigger).
- After revert: restore pre-6.18.57 `step_into` behavior; remaining
  cover-reveal race is the long-standing one (MEDIUM, security-adjacent,
  narrow), with d29cd99 still reducing new-lookup hits.
- Severity of **not** reverting a known-wrong core pathwalk change that
  already shipped in 6.18.57: HIGH (stable regression vs 6.18.56).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: remove a too-broad ESTALE/LOOKUP_REVAL regression from core
  lookup; align 6.18.y with the VFS maintainer’s rc8 correction; drop an
  incomplete security bandage rather than pretend it closed the class
- Risk: very low — exact inverse of a 29-line function added in 6.18.57
- Ratio: strongly favors backporting the revert

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- The commit being reverted **is in this tree** (5f97, v6.18.57~479)
- VFS maintainer authored the revert; Linus merged it as
  vfs-7.3-rc8.fixes
- Documented too-broad check: every unlink/rename vs refwalk, not only
  overmounts
- Small, exact inverse, applies cleanly
- Sibling unhash-before-detach fix remains
- Revert of a stable-to-stable mistake (5f97 was itself a 6.18.57
  backport)

AGAINST:
- Re-opens the remaining “walker already holds the dentry” cover-reveal
  window
- Original add had a reproducer and `Cc: stable`

UNRESOLVED:
- Full lore thread for the revert itself (b4/lore failed)
- Whether a later proper fix exists only on branches not in this object
  store (none found on 214897’s nearby history)

The “against” point is why 5f97 was written. The maintainer’s later
judgment, merged by Linus, is that keeping that patch is worse than
living with the old narrow race until a real fix exists. For stable,
shipping 5f97 for a few days and then following the revert is the
conservative choice.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — exact revert of a known SHA;
   merged as an rc8 VFS fix
2. Fixes a real bug that affects users? **PASS** — removes a too-broad
   ESTALE/LOOKUP_REVAL pathwalk regression introduced in 6.18.57
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   core VFS lookup regression; incomplete security check is worse than
   no check plus the remaining unhash fix
4. Small and contained? **PASS** — −29 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — inverse of 5f97 on
   `step_into()`

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs case. It is the documented revert
case: original commit **is** in this stable tree, so the revert is
needed.

Step 9.4: MAKE YOUR DECISION
This tree is 6.18.57. It already contains the incomplete refwalk check.
The revert is the maintainer’s correction of that 6.18.57 backport and
should be applied here.

What it does for stable users: it takes `unlink_may_reveal()` out of
`step_into()` so ordinary unlink/open races no longer force a full
`LOOKUP_REVAL` walk, and it stops treating a known-incomplete mount-
cover check as a finished fix. `d29cd99` still unhashes before detaching
mounts.

Risk vs benefit: benefit is high (undo a core-pathwalk regression that
is only days old in 6.18.57); risk is very low (surgical revert).

Concerns: the original cover-reveal race is not fully solved; that is
intentional per the author. No extra prerequisites.

Verification:
- [Phase 1] Parsed revert tags: Brauner SOB only; body reverts
  8189ab688f5a; original add had Fixes/Cc stable/Link
- [Phase 1] Linus vfs-7.3-rc8.fixes pull explicitly names this revert
- [Phase 2] Diff: −29 lines in fs/namei.c; removes unlink_may_reveal +
  ESTALE return in step_into
- [Phase 2] Verified dont_mount() on vfs_unlink/vfs_rmdir/vfs_rename;
  ESTALE→LOOKUP_REVAL in filename_lookup/do_filp_open
- [Phase 3] git describe HEAD: v6.18.57-155-gcdf239ca885b2;
  kernelversion 6.18.57
- [Phase 3] git merge-base --is-ancestor 5f97df8ca7fad v6.18.57: yes;
  v6.18.56: no
- [Phase 3] git blame v6.18.57: unlink_may_reveal entirely 5f97df8ca7fad
- [Phase 3] 8ed936b5671b is an ancestor; d29cd99 unhash-before-detach is
  in v6.18.57 and stays
- [Phase 3] Local revert is the exact inverse of 5f97 on step_into (not
  step_into_slowpath)
- [Phase 4] b4 dig -c 214897acc8c2: lore server error — UNVERIFIED
  mailed thread
- [Phase 4] lore WebFetch 403 — UNVERIFIED lore discussion
- [Phase 4] Unmerged DCACHE_UNCOVERED follow-up documents LOOKUP_REVAL
  regression (syzbot CI / series text)
- [Phase 5] step_into callers: walk_component, handle_dots,
  open_last_lookups — core pathwalk
- [Phase 6] Buggy helper present at v6.18.57:fs/namei.c:1983; clean
  apply
- [Phase 8] Failure mode: extra LOOKUP_REVAL on unlink vs open; NFS/FUSE
  revalidate whole path
- UNVERIFIED: stable@ mailing list discussion of this specific revert

**YES**

 fs/namei.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2e86733b4bacb..003c9a1b2f904 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1973,33 +1973,6 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 	return NULL;
 }
 
-/*
- * Be careful in case the dentry is unlinked or renamed. Any mounts
- * stacked on top of it are going away. We need to make sure that we
- * don't reveal the underyling dentry during refwalk. In rcuwalk we
- * catch this via d_seq and another lookup for the name. Give the same
- * guarantee in refwalk.
- */
-static bool unlink_may_reveal(struct nameidata *nd, int flags,
-			      struct path *path, struct dentry *dentry)
-{
-	/* ".." and LOOKUP_DOWN may land on an unhashed directory */
-	if (flags & WALK_NOFOLLOW)
-		return false;
-	if (nd->flags & LOOKUP_REVAL)
-		return false;
-	/* We crossed onto a mount and the name led us here while it still existed */
-	if (path->mnt != nd->path.mnt)
-		return false;
-	/* only a name on its way out is flagged */
-	if (likely(!cant_mount(dentry)))
-		return false;
-	if (!d_unlinked(dentry))
-		return false;
-	dput(no_free_ptr(path->dentry));
-	return true;
-}
-
 /*
  * Do we need to follow links? We _really_ want to be able
  * to do this check without having to look at inode->i_op,
@@ -2028,8 +2001,6 @@ static const char *step_into(struct nameidata *nd, int flags,
 			if (unlikely(!inode))
 				return ERR_PTR(-ENOENT);
 		} else {
-			if (unlikely(unlink_may_reveal(nd, flags, &path, dentry)))
-				return ERR_PTR(-ESTALE);
 			dput(nd->path.dentry);
 			if (nd->path.mnt != path.mnt)
 				mntput(nd->path.mnt);
-- 
2.53.0

