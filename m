Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6397C4FB9D5;
	Mon, 19 Oct 2026 13:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418090; cv=none; b=QKrmVFJwU75lC8mVIon+Ruvq6NGH36+eXPhUd+mJJfeIdUBMTaQT6kZkVqynykvEB58x3eUHTp7PFIxvLzSecvvVPTH4GR+o1hjcvC6hrCCJxAzxkmgdnFM/XgfadtT6GjK422WTfKwuGvWgz5cqYmj9RUbOZc8cT+KLT1FoYfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418090; c=relaxed/simple;
	bh=tmqPc6UZCJQUzYP/TCc+RhS4jDKHImkL64fnuWK2zYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UF1rqgwh1o4cp0LcrGvc1JtB8Hel0eFojK7i3IbrpINhU144bz7wyfbq5FU4Ryb0GrCg+ubJuFGUr35eQKGjt7kO7pg6iJhl4GSwq2aN9IkMJAhdzbqEqapzX8Eo10FQr+b3T5B7zBVmsj06nQCj3r1Xhsaozy5jH9i1bx3mFBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghIxZkxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghIxZkxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478D31F000C7;
	Mon, 19 Oct 2026 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418087;
	bh=UT703PQW66foZVKNkQrObg9w1QyCa8II10FWAWp7oss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghIxZkxD7vtIYYioc0con473xy6ahvb8RXFcjPVZv39zayXcwzNRDOmWy2eyUFKTx
	 ysNzwN6N0pUuI0zoSmwaU2HtyLRJioUe4zPWe9q82YrXqOfhrCO4PNJUUvX4hkmmlf
	 PvuyDG/8xekutukzkkdNnhcSvSHGYbWO5DUW0iPXxWdKUhXdbzN31HP8/8r8CHb9h+
	 qqK1QxT001nHwc7OJc4yHgVOmW+PprmGJM8F2UZCkqI/heFmQweEchQgklLreP0EWA
	 3YmlbKT8jnFPKRTNh3KAQQ22qC7rQ63XafpZGqDAemKBGv0lnxgFjupOnzhYS5OnfR
	 ed+DsLKBLjmog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] docs: update the unmount propagation rule
Date: Mon, 19 Oct 2026 09:44:54 -0400
Message-ID: <20261019135441.1420968-3-sashal@kernel.org>
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

[ Upstream commit 3f5dc09141a7bfe286620a6869d1d70ffe32d6b8 ]

Section 5f still describes the rule propagate_umount() used before
commit f0d0ba19985d ("Rewrite of propagate_umount()"). It states that a
mount that receives the unmount by propagation is left alone as soon as
it has any submount. That's not true anymore.

A propagated unmount unmounts a mount with sub-mounts as long as every
sub-mount gets unmounted together with it. This is the case when the
sub-mounts are unmounted by the same propagation. Only a sub-mount that
cannot be unmounted keeps its parent mounted.

The section also only describes a single mount without sub-mounts. But
lazy unmounts take a tree and every mount of the tree propagates its
unmount from its parent mount.

Link: https://patch.msgid.link/20260923-work-mount-fixes-v1-8-f424cf8d3242@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a documentation-only correction of stale unmount-propagation
text. The local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The
rewrite it documents is already in that tree, so the question is whether
this docs update belongs here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[docs]** **[update]** Update the unmount propagation rule in
shared-subtree documentation.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Link: `https://patch.msgid.link/20260923-work-mount-
  fixes-v1-8-f424cf8d3242@kernel.org`
- Signed-off-by: Christian Brauner (Amutable) \<brauner@kernel.org\>
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable on this patch itself
- Cover letter of the same series (`[PATCH 0/8] mount: a few gnarly
  fixes`) did Cc stable; this 8/8 docs patch did not
- Ignore pipeline tags: `[Upstream commit 3f5dc09141a7…]`, `Signed-off-
  by: Sasha Levin`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** Section 5f of `sharedsubtree.rst` still describes pre-rewrite
  `propagate_umount()`: a receiver with any sub-mount is left mounted.
- **Symptom:** Documentation disagrees with current kernel behavior. A
  propagated unmount may take a mount that has children if those
  children are also unmounted by the same propagation. Only a child that
  cannot be unmounted keeps its parent.
- **Also missing:** Lazy `MNT_DETACH` unmounts a tree; every mount in
  that tree propagates from its own parent.
- **Version info:** Behavior changed in `f0d0ba19985d` (“Rewrite of
  propagate_umount()”).
- **Root cause:** Overview docs were not updated when
  `propagate_umount()` was rewritten.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden runtime fix. It is an explicit documentation
correction of obsolete unmount semantics. No code, locking, or error-
path change.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `Documentation/filesystems/sharedsubtree.rst` (+14 / −6)
- One section: “f) Unmount semantics”
- Scope: single-file documentation, surgical

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: receivers at dentry `b` are unmounted only if they have no
  sub-mounts. Any child on C2/C3 blocks that receiver; C1 with sub-
  mounts fails the whole umount.
- After: receivers are unmounted if every mount below them is also
  unmounted. A child unmounted by the same propagation does not pin its
  parent. Adds lazy-umount tree propagation and a pointer to
  `Documentation/filesystems/propagate_umount.txt`.
- Path affected: documentation of umount/propagation semantics only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: documentation correctness (obsolete comment/docs)
- Mechanism: overview text still described the old “any sub-mount blocks
  the receiver” rule. Code after `f0d0ba19985d` unmounts a receiver when
  remaining children are themselves candidates (`trim_one()` / non-
  shifting set).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct relative to this tree’s `propagate_umount()` and
  `propagate_umount.txt`
- Minimal; no unrelated edits
- Regression risk: none (no executable code)
- Red flags: none

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Original unmount-semantics prose: `9cfcceea8f7e8f` (Ram Pai,
  2005-11-07, `Documentation/sharedsubtree.txt`)
- ReST conversion/formatting: Bagas Sanjaya, 2025-08 (`a8886b42d57b8`,
  `b293fd55a1b89`)
- Behavior change that made the text wrong: `f0d0ba19985d` (Al Viro,
  2025-06-29, ~v6.17)
- That rewrite **is** an ancestor of this 6.18.y tree

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Expected. The related behavioral commit is
`f0d0ba19985d`, already in `v6.18.57`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent `sharedsubtree.rst` work is formatting/ReST, not semantics
- Precise rules already live in
  `Documentation/filesystems/propagate_umount.txt` (added by the
  rewrite)
- Standalone: patch 8/8 of Brauner’s “mount: a few gnarly fixes”; this
  hunk does not depend on patches 1–7

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Author is VFS maintainer (`FILESYSTEMS (VFS and infrastructure)` in
  MAINTAINERS)
- Same series includes real umount/mount bugfixes (busy propagated
  umount, unbindable copy, etc.)
- This patch is the docs companion, not one of those code fixes

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Depends only on the rewrite already present here, and on
  `propagate_umount.txt`, which exists at `v6.18.57`
- Can apply standalone. No new helpers or struct changes.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 3f5dc09141a7…` matched patch-id `0b2df883901084c2…`
- Lore URL: https://patch.msgid.link/20260923-work-mount-
  fixes-v1-8-f424cf8d3242@kernel.org
- Series: v1 only (`[PATCH 8/8] docs: update the unmount propagation
  rule`), 2026-09-23
- Cover letter: `[PATCH 0/8] mount: a few gnarly fixes`
- Direct replies in the saved thread are about patch 5/8 (`fs: don't
  silently unmount busy mounts`), not this docs patch
- No NAK, no reviewer concern, no stable nomination on 8/8 itself
- WebFetch of lore.kernel.org returned 403; thread recovered via `b4 dig
  -m`

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`):
- Recipients: Christian Brauner, linux-fsdevel, Linus Torvalds,
  Alexander Viro, Jan Kara
- Right maintainers/lists. No extra Reviewed-by on 8/8. Brauner is both
  author and VFS maintainer.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No user/syzbot report for the docs. The body is the author’s
observation that section 5f lagged the rewrite. Severity is
documentation inaccuracy, not a crash.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record:
- Series of 8: unbindable copy, MOVE_MOUNT_SET_GROUP, busy propagated
  umount, migrating-task ref, plus selftests, plus this docs update
- 8/8 does not implement those fixes; it only restates
  `propagate_umount()` after the 2025 rewrite
- Self-contained

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record:
- Cover letter Cc’d `stable@vger.kernel.org`
- Patches 1/8 and 5/8 had explicit `Cc: stable` in the body; 8/8 did not
- Direct lore.kernel.org/stable search was blocked (bot challenge). No
  additional stable-thread evidence beyond the series headers.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: None. Documentation only. Semcode tools are not available.

Step 5.2: TRACE CALLERS
Record: N/A for the diff. Documented behavior is implemented by
`propagate_umount()` in `fs/pnode.c`, called from `fs/namespace.c`
(`umount_tree` / `do_umount` path).

Step 5.3: TRACE CALLEES
Record: `propagate_umount()` gathers candidates, `trim_one()` /
`trim_ancestors()` enforce the non-shifting set, `handle_locked()`
enforces locked-mount (non-revealing) rules. That matches “unmount a
parent if every child is also unmounted; a child that cannot be
unmounted keeps the parent.”

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from `umount(2)` / `umount2(MNT_DETACH)` on
shared/slave mounts. Common container/namespace path. The **patch**
itself is not on that path; it only describes it.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Detailed rules already in
`Documentation/filesystems/propagate_umount.txt`. This change makes the
overview consistent with that file instead of contradicting it.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: VERSION 6.18.57 (`v6.18.57-155-gcdf239ca885b2`)
- Stale section 5f is present at
  `v6.18.57:Documentation/filesystems/sharedsubtree.rst` (identical to
  the candidate’s pre-image)
- Rewrite `f0d0ba19985d` **is** in `v6.18.57`
- So this tree’s kernel already uses the new rule, while the overview
  still documents the old one
- Bug introduced (as a docs mismatch) when the rewrite landed (~v6.17),
  i.e. before this 6.18 branch

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. `diff` of `v6.18.57` vs the candidate pre-image is
empty (both 994 lines). Context matches.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record:
- Precise notes (`propagate_umount.txt`) already here
- Related code fix `bf2c8dec26fb7` (“fs: don't silently unmount busy
  mounts”) is already in `v6.18.57`; that does not replace this overview
  correction
- No earlier equivalent rewrite of section 5f

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- Subsystem: VFS / mount namespace documentation
  (`Documentation/filesystems/`)
- Documents CORE mount/umount propagation used by containers
- The change itself is docs, not core code
- Criticality of the **text**: IMPORTANT for people who rely on shared-
  subtree docs; runtime criticality: none

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mount/namespace code is actively maintained (Brauner/Viro).
`sharedsubtree.rst` itself is old and mostly formatting churn; the
semantics gap dates to the 2025 rewrite.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Anyone reading shared-subtree unmount docs (container/namespace
users and developers). No runtime user population is changed.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Not a runtime trigger. The mismatch is visible whenever someone
reads section 5f and compares it to `umount` on shared mounts with
nested children.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure mode: incorrect documentation of `umount(2)` propagation
- Userspace that trusts the old “any child blocks the receiver” rule can
  mis-predict which mounts disappear
- Accurate rules already exist in `propagate_umount.txt`
- Severity: **LOW** for runtime; **MEDIUM** as a docs bug about user-
  visible mount semantics

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: overview matches this tree’s actual `propagate_umount()`;
  avoids a documented lie about umount
- Risk: none (14 insertions / 6 deletions, docs only)
- Ratio: favorable — small, zero-risk correction of obsolete docs for
  behavior that is already here

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Section 5f is factually wrong in this 6.18.y tree because
  `f0d0ba19985d` is present
- Stable exception for documentation/comment fixes applies
- Small, contained, maintainer-authored
- Applies cleanly to `v6.18.57`
- Points at `propagate_umount.txt`, which already exists here
- Zero runtime regression risk

AGAINST:
- No crash, UAF, deadlock, corruption, or security fix
- This patch was not itself Cc’d to stable (1/8 and 5/8 were)
- Precise behavior is already documented in `propagate_umount.txt`
- No user report of the docs bug

UNRESOLVED:
- lore.kernel.org HTTP fetch returned 403; thread was recovered with `b4
  dig`
- Could not search lore.kernel.org/stable beyond a bot wall
- No Reviewed-by on 8/8 (unverified whether silent acks existed off-
  thread)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — text matches
   `propagate_umount()` / `propagate_umount.txt` in this tree
2. Fixes a real bug that affects users? **PASS** — obsolete description
   of user-visible umount semantics (not a runtime bug)
3. Important issue (crash, security, corruption, deadlock)? **FAIL** as
   a runtime issue; **PASS** under the documentation exception
4. Small and contained? **PASS** — +14/−6, one rst file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context at `v6.18.57` is
   identical

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Documentation fix** — correcting obsolete comments/docs. Zero
runtime risk.

Step 9.4: MAKE YOUR DECISION
The rewrite this documents is already in 6.18.y, the overview is still
wrong, and the patch is a tiny docs-only correction that applies
cleanly. That is exactly the documentation exception. It should be
backported to this tree.

Verification:
- [Phase 1] Parsed subject/tags: docs update; Link to patch 8/8 of work-
  mount-fixes; no Fixes/Reported-by/Cc:stable on this patch
- [Phase 1] Cover letter Cc’d stable; patches 1/8 and 5/8 had `Cc:
  stable` in the body; 8/8 did not
- [Phase 2] Diff: `Documentation/filesystems/sharedsubtree.rst` +14/−6;
  section 5f only
- [Phase 3] `git describe HEAD` / Makefile: 6.18.57
- [Phase 3] `git merge-base --is-ancestor f0d0ba19985d v6.18.57`:
  rewrite is in this tree
- [Phase 3] Blame: original text Ram Pai 2005; stale vs rewrite 2025-06
- [Phase 3] `git show
  v6.18.57:Documentation/filesystems/sharedsubtree.rst`: old “any sub-
  mounts” wording still present
- [Phase 4] `b4 dig -c 3f5dc09141a7`:
  https://patch.msgid.link/20260923-work-mount-
  fixes-v1-8-f424cf8d3242@kernel.org
- [Phase 4] `b4 dig -a`: v1 only, series of 8
- [Phase 4] `b4 dig -w`: vfs maintainers + linux-fsdevel
- [Phase 4] mbox: no NAK on 8/8; discussion was about 5/8
- [Phase 4] WebFetch lore: 403; UNVERIFIED beyond b4 mbox
- [Phase 5] Semcode unavailable; `propagate_umount()`/`trim_one()` in
  `fs/pnode.c` match the new wording
- [Phase 6] File at v6.18.57 identical to candidate pre-image (994
  lines, empty diff) — clean apply
- [Phase 6] `propagate_umount.txt` exists at v6.18.57
- [Phase 7] Author is VFS maintainer in MAINTAINERS
- [Phase 8] Failure mode: stale umount-propagation docs; severity LOW
  runtime / docs exception
- UNVERIFIED: stable-list discussion beyond series headers

This is a small, obviously correct documentation fix for mount-namespace
behavior that this tree already implements. Risk is zero.

**YES**

 Documentation/filesystems/sharedsubtree.rst | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/sharedsubtree.rst b/Documentation/filesystems/sharedsubtree.rst
index 8b7dc91590837..8bae6d9a7e047 100644
--- a/Documentation/filesystems/sharedsubtree.rst
+++ b/Documentation/filesystems/sharedsubtree.rst
@@ -564,8 +564,8 @@ f) Unmount semantics
    where 'A' is a mount mounted on mount 'B' at dentry 'b'.
 
    If mount 'B' is shared, then all most-recently-mounted mounts at dentry
-   'b' on mounts that receive propagation from mount 'B' and does not have
-   sub-mounts within them are unmounted.
+   'b' on mounts that receive propagation from mount 'B' are unmounted as
+   well, if every mount below them is also unmounted.
 
    Example: Let's say 'B1', 'B2', 'B3' are shared mounts that propagate to
    each other.
@@ -584,10 +584,18 @@ f) Unmount semantics
 
    So all 'C1', 'C2' and 'C3' should be unmounted.
 
-   If any of 'C2' or 'C3' has some child mounts, then that mount is not
-   unmounted, but all other mounts are unmounted. However if 'C1' is told
-   to be unmounted and 'C1' has some sub-mounts, the umount operation is
-   failed entirely.
+   If any of 'C2' or 'C3' has a child mount that cannot be unmounted
+   then that mount is not unmounted. But all other mounts are unmounted.
+   A child mount that is itself unmounted by the same unmount
+   propagation does not keep its parent mounted. However if 'C1' is
+   supposed to be unmounted and 'C1' has some sub-mounts, the unmount
+   fails.
+
+   A lazy umount (MNT_DETACH) takes a whole tree. Every mount of the
+   tree then propagates its unmount from its own parent as described
+   above, so the mounts that receive propagation lose the corresponding
+   trees as well. Documentation/filesystems/propagate_umount.txt has the
+   precise rules, including the ones for locked mounts.
 
 g) Clone Namespace
 
-- 
2.53.0

