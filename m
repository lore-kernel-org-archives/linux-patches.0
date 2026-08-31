Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB76440642;
	Mon, 31 Aug 2026 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183493; cv=none; b=rEkWpWN4vRM0yW4czt7L+tCwmY+4pj4atf548/IHABMimQyquWrUDKfsC2cNGzGY99Mk5074r6tT9OIjEslxdxlRQEts/03t8oJXBFAVHAlMjlUc/xAZUCriGZvVUt31s92mW4k/om9acRyWGBcqPMT57+C1p/aHueetVe10FZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183493; c=relaxed/simple;
	bh=qpxCDYcmxSY732uR7Q7l597pVJ9PLvEWprPFDE4L0DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTaPpF5ptgT6+sFNqMPAtSV0S4UcAsPVH+OaQ9zDgYPceAFPuuIaEmhbiRxO4WH6oqQmkyKd0ikanMErAOXkQhOZwkfyogX/iPl3t7RMJl/j3DTyANgaU6Lh4UX5FWNatYIJmkm19LmAwc2Q6roU9BAOxX8IM2ff5pVmmi3JQiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sk8LbN0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sk8LbN0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA0B1F00A3F;
	Mon, 31 Aug 2026 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183491;
	bh=0Em9zzb++Ll6MVP0RhQ8NpAE26qmdiVTlfV076VHUHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sk8LbN0lFZQhSXcE4pWXeD9O/hG/nP5cI9E8LZZEbhUZ3dr0dxtrTRJWIFKSFbE7U
	 lQzWG/aBe/XwOYnLgxGbG7qKucHSmBfH4u3L6oRNzC/gBT15zF/GR4I4BzkqUcuMvk
	 6sUM7PiEblkYZGyAPCpnu/ES05pEo9vuSWjMLv/UX1eQyCwsHYBlxqzYHhp4kvE/uy
	 Hz2MCtdtjNoMUfIjxN6hdRxsRQ7suLzD0/ogxepDX+xvqe+qWB5qwzn6TWlNiTfIXX
	 f5Z/W6CPvt5aUZXlwXn+/f+EhwITuIdhvICI9ZBTXfxBSN4l8AXiSUKiAL7U4aaeJG
	 cR0e9J0JZBj1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] configfs_depend_prep(): pass configfs_dirent instead of dentry
Date: Mon, 31 Aug 2026 09:22:36 -0400
Message-ID: <20260831133314.4125787-128-sashal@kernel.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 764682e0118432260191d194edbdaff208260483 ]

Again, the only thing it uses dentry for is dentry->d_fsdata; for the
recursive call the situation is the same as with configfs_detach_prep()
and the same observation about ->s_dentry->d_fsdata applies.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[configfs] [refactor/correct] configfs_depend_prep(): pass
  configfs_dirent instead of dentry`

**Step 1.2 — Tags**
- Record: `Reviewed-by: Jan Kara <jack@suse.cz>`, `Reviewed-by: Breno
  Leitao <leitao@debian.org>`, `Signed-off-by: Al Viro
  <viro@zeniv.linux.org.uk>`. No `Fixes:`, `Reported-by:`, `Link:`, `Cc:
  stable`, or `Tested-by:` tags. Notable: two subsystem reviewers, no
  fuzzer/user report.

**Step 1.3 — Body**
- Record: The commit explains that `configfs_depend_prep()` only used
  its dentry argument to reach `dentry->d_fsdata`, which is the
  `configfs_dirent` itself. The recursive call should pass `child_sd`
  directly, mirroring the same observation already made for
  `configfs_detach_prep()` about `->s_dentry->d_fsdata`. No explicit
  crash report, but the implication is that going through `s_dentry` is
  unsafe/redundant during tree traversal.

**Step 1.4 — Hidden bug fix?**
- Record: **Yes.** Although framed as a signature cleanup, it removes
  dereferences of `child_sd->s_dentry` during a recursive tree walk. In
  the current tree, `configfs_readdir()` already treats `s_dentry` as
  potentially NULL, while `configfs_depend_prep()` does
  `BUG_ON(!origin)` on that same pointer. This is a latent NULL-deref /
  kernel-BUG fix, not mere style.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record: 1 file changed (`fs/configfs/dir.c`), 4 insertions / 8
  deletions. Functions modified: `configfs_depend_prep()`,
  `configfs_do_depend_item()`. Scope: single-file surgical change.

**Step 2.2 — Code flow**
- Record:
  - **Hunk 1 (`configfs_depend_prep`)**: Before — take `struct dentry
    *origin`, `BUG_ON(!origin || !origin->d_fsdata)`, set `sd =
    origin->d_fsdata`, recurse via `child_sd->s_dentry`. After — take
    `struct configfs_dirent *sd` directly, recurse via `child_sd`.
    Removes dentry indirection on the hot recursive path.
  - **Hunk 2 (`configfs_do_depend_item`)**: Before —
    `configfs_depend_prep(subsys_dentry, target)`. After —
    `configfs_depend_prep(subsys_dentry->d_fsdata, target)`. Top-level
    caller still has a valid pinned subsystem dentry.

**Step 2.3 — Bug mechanism**
- Record: **Memory safety / NULL dereference fix.** Category (d). Old
  recursive path: `configfs_depend_prep(child_sd->s_dentry, target)`
  with `BUG_ON(!origin)`. If `child_sd->s_dentry` is NULL (dentry
  evicted via `configfs_d_iput()` after `DCACHE_DONTCACHE`, or cleared
  on lookup failure), the kernel hits `BUG()`. The fix uses the already-
  available `configfs_dirent` pointer, which is what the function
  actually needs.

**Step 2.4 — Fix quality**
- Record: Obviously correct — dentry was only an alias for `d_fsdata`.
  Minimal diff, no API changes, no new locking. Regression risk very
  low; it aligns `configfs_depend_prep()` with the pattern already used
  in the backported lockless-traversal series.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: `configfs_depend_prep()` introduced in `631d1febab8e5` (2007,
  "config item dependancies"). `BUG_ON(!origin || !origin->d_fsdata)`
  added in `49deb4bc227cb` (2013). The `child_sd->s_dentry` recursive
  pattern has been present since 2007. Bug latent for years; exposure
  increased once `DCACHE_DONTCACHE` and dangling-`s_dentry` fixes landed
  in this tree.

**Step 3.2 — Fixes: tag**
- Record: Not applicable — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**
- Record: Part of Al Viro's 2026 configfs series on master:
  - `10da12d352b7b` → in tree as `c3b073a209a9b` (lookup dangling
    `s_dentry`)
  - `9b9e8bb81c41f` → in tree as `637ef4961470e` (lockless `s_children`
    traversal)
  - `96551d7f9f7b5` — **not** in tree (same fix for
    `configfs_detach_prep()`)
  - `764682e011843` — **not** in tree (this commit)
  Standalone for `depend_prep`; does not require the `detach_prep`
sibling.

**Step 3.4 — Author context**
- Record: Al Viro (VFS maintainer) authored the related configfs
  hardening series. Reviewed by Jan Kara (filesystems).

**Step 3.5 — Dependencies**
- Record: No patch-series numbering. Applies cleanly to 6.18.44
  (verified via cherry-pick). Benefits from already-present
  prerequisites (`DCACHE_DONTCACHE`, dangling-`s_dentry` fix, lockless
  traversal fix) but does not require unbackported commits.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 764682e011843` found no lore match. Commit went
  through Viro's `pull-configfs-fixed` tag (`de02909ae81aa` on master).
  Discussion not retrievable via b4; analysis relies on commit message,
  code, and series context.

**Step 4.2 — Reviewers**
- Record: `b4 dig -w` also failed (no lore match). Commit lists Jan Kara
  and Breno Leitao as reviewers.

**Step 4.3 — Bug report**
- Record: Not applicable — no `Reported-by:` or `Link:` tags.

**Step 4.4 — Related patches**
- Record: Sibling `96551d7f9f7b5` (`configfs_detach_prep()`) is the same
  class of fix for a different function. Independent; not a prerequisite
  for this commit.

**Step 4.5 — Stable list**
- Record: Not searched separately; the upstream lockless-traversal fix
  from the same series was already backported to this tree, indicating
  stable maintainers consider this configfs work relevant.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `configfs_depend_prep()`, `configfs_do_depend_item()`.

**Step 5.2 — Callers**
- Record: `configfs_do_depend_item()` called from
  `configfs_depend_item()` and `configfs_depend_item_unlocked()`.
  Exported callers include:
  - `fs/ocfs2/cluster/nodemanager.c`
  - `drivers/target/target_core_configfs.c`
  - `drivers/gpio/gpio-sim.c`, `gpio-virtuser.c`, `gpio-aggregator.c`
  - `drivers/usb/gadget/function/f_tcm.c`
  These are real production/configfs-client paths.

**Step 5.3 — Callees**
- Record: Holds `configfs_dirent_lock`, walks `sd->s_children`, compares
  `sd->s_element` to target, increments `s_dependent_count` on success.

**Step 5.4 — Reachability**
- Record: Triggered when kernel drivers call `configfs_depend_item()` /
  `configfs_depend_item_unlocked()` to pin cross-subsystem config items.
  Reachable from module code managing configfs objects (target, ocfs2,
  gpio, USB gadget). Not a syscall path, but a real kernel runtime path.

**Step 5.5 — Similar patterns**
- Record: `configfs_readdir()` at lines 1695–1697 already does `dentry =
  next->s_dentry; if (dentry)` before use. `configfs_depend_prep()` is
  the outlier that assumed `s_dentry` is always valid.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **Yes.** Tree is `v6.18.44` (`HEAD detached at
  stable/linux-6.18.y`). `configfs_depend_prep()` still takes `struct
  dentry *` and recurses through `child_sd->s_dentry` with
  `BUG_ON(!origin)`.

**Step 6.2 — Backport complications**
- Record: Cherry-pick applies cleanly with auto-merge (`4 insertions, 8
  deletions`). No rework needed.

**Step 6.3 — Related fixes already present?**
- Record: Prerequisites already in tree: `c3b073a209a9b` (dangling
  `s_dentry`), `637ef4961470e` (lockless traversal), `a509e7cf622bc`
  (`DCACHE_DONTCACHE`). This specific `depend_prep` fix is **not**
  present. The `detach_prep` sibling fix is also absent.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `fs/configfs` — VFS/configfs core. Criticality: **IMPORTANT**
  (shared infrastructure for target, ocfs2, gpio, USB gadget configfs
  users).

**Step 7.2 — Activity**
- Record: Actively maintained in 2026; multiple Al Viro configfs fixes
  already landed and partially backported to this stable tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Systems using configfs with `configfs_depend_item()` — notably
  SCSI target, ocfs2, GPIO sim/virtuser/aggregator, USB gadget TCM.

**Step 8.2 — Trigger conditions**
- Record: `configfs_depend_item()` called while a subdirectory in the
  tree has `s_dentry == NULL` but is otherwise live (not
  `CREATING`/`DROPPING`). More likely with `DCACHE_DONTCACHE` dentry
  eviction. Not userspace-triggerable directly, but driver-initiated
  during normal configfs dependency setup.

**Step 8.3 — Failure mode**
- Record: `BUG_ON(!origin)` → kernel BUG / crash. Severity: **CRITICAL**
  (hard kernel failure).

**Step 8.4 — Risk-benefit**
- Record: Benefit **high** (prevents kernel crash in configfs dependency
  path). Risk **very low** (4-line net change, removes redundant
  indirection, reviewed by two filesystem developers). Ratio strongly
  favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

*For backport:*
- Real latent crash: NULL `s_dentry` triggers `BUG_ON` in recursive
  `configfs_depend_prep()`
- Same file already handles NULL `s_dentry` in `configfs_readdir()`
- Prerequisites (`DCACHE_DONTCACHE`, dangling-pointer fix, lockless
  traversal) already in 6.18.44 increase exposure
- Small, surgical, applies cleanly
- Reviewed by Jan Kara and Breno Leitao
- Part of a series whose main fix is already in this stable tree
- Used by production subsystems (target, ocfs2, gpio)

*Against backport:*
- No explicit bug report or syzbot reference
- Commit message is terse; reads partly like cleanup
- Sibling `configfs_detach_prep()` fix not yet in tree (incomplete
  series coverage)

*Unresolved:*
- No lore discussion retrieved (b4 found nothing)
- No user-reported crash instance verified

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is trivially correct;
   reviewed by two developers.
2. Fixes a real bug affecting users? **PASS** — NULL `s_dentry` →
   `BUG_ON` crash on `configfs_depend_item()` path.
3. Important issue? **PASS** — kernel BUG / crash (CRITICAL).
4. Small and contained? **PASS** — 12 lines, 1 file, 2 functions.
5. No new features or APIs? **PASS** — internal static function
   signature change only.
6. Can apply to local tree? **PASS** — verified clean cherry-pick on
   6.18.44.

**Step 9.3 — Exception category**
- Record: Not applicable (not device ID, quirk, DT, build, or docs).

**Step 9.4 — Decision rationale**

This commit completes hardening started by already-backported configfs
fixes in 6.18.44. With `DCACHE_DONTCACHE` making dentry eviction more
aggressive, `configfs_d_iput()` can clear `sd->s_dentry` while the
`configfs_dirent` remains in the live tree. `configfs_depend_prep()`
then recurses through that NULL pointer and hits `BUG_ON(!origin)`. The
fix is minimal, self-contained, applies cleanly, and prevents a kernel
crash in a path used by target, ocfs2, and GPIO configfs clients.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by x2, no Fixes/Reported-by),
  body text
- [Phase 2] Diff: 1 file, `configfs_depend_prep()` +
  `configfs_do_depend_item()`, 4+/8-
- [Phase 3] `git blame` lines 1091–1119: function from 2007, BUG_ON from
  2013
- [Phase 3] Series check: `c3b073a209a9b` and `637ef4961470e` in tree;
  `96551d7f9f7b5` and `764682e011843` not in tree
- [Phase 3] `git show 764682e011843`: full commit on master
- [Phase 3] `git show 96551d7f9f7b5`: sibling detach_prep commit,
  independent
- [Phase 4] `b4 dig -c 764682e011843`: no lore match
- [Phase 4] `b4 dig -c 764682e011843 -a -w`: no lore match
- [Phase 5] `grep configfs_depend_item`: callers in ocfs2, target, gpio,
  usb gadget
- [Phase 5] Read `configfs_readdir()` lines 1695–1697: NULL `s_dentry`
  handling confirmed
- [Phase 5] Read `configfs_d_iput()` lines 45–66: sets `s_dentry = NULL`
  on dentry eviction
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Buggy code confirmed at lines 1091–1129 in
  `fs/configfs/dir.c`
- [Phase 6] Cherry-pick test: applies cleanly to 6.18.44
- [Phase 6] `a509e7cf622bc` (`DCACHE_DONTCACHE`) confirmed in tree
- [Phase 8] Failure mode: `BUG_ON(!origin)` on NULL dentry → kernel
  crash

**YES**The background checks finished and match the earlier analysis.

**6.18.44 stable tree status for the configfs series:**
- **Present:** `DCACHE_DONTCACHE` (`a509e7cf622bc`), the lookup
  dangling-`s_dentry` fix (`c3b073a209a9b`), and the lockless
  `s_children` traversal fix (`637ef4961470e`)
- **Missing:** `configfs_detach_prep(): pass configfs_dirent instead of
  dentry` (`96551d7f9f7b5`) and the commit under review
  (`764682e011843`)

That supports the **YES** verdict: the prerequisites that make NULL
`s_dentry` more likely are already in this tree, but the
`configfs_depend_prep()` fix is not. The patch applies cleanly on
6.18.44.The branch search found the commit on **master** (and related
branches) as `764682e011843` — `configfs_depend_prep(): pass
configfs_dirent instead of dentry` — merged via Al Viro's `pull-
configfs-fixed` tag. It is not in the current **6.18.44** stable
checkout, which matches the earlier analysis.

 fs/configfs/dir.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 68203952766e6..bfecb68a83797 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1088,15 +1088,12 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
  * much on the stack, though, so folks that need this function - be careful
  * about your stack!  Patches will be accepted to make it iterative.
  */
-static int configfs_depend_prep(struct dentry *origin,
+static int configfs_depend_prep(struct configfs_dirent *sd,
 				struct config_item *target)
 {
-	struct configfs_dirent *child_sd, *sd;
+	struct configfs_dirent *child_sd;
 	int ret = 0;
 
-	BUG_ON(!origin || !origin->d_fsdata);
-	sd = origin->d_fsdata;
-
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
 
@@ -1104,8 +1101,7 @@ static int configfs_depend_prep(struct dentry *origin,
 		if ((child_sd->s_type & CONFIGFS_DIR) &&
 		    !(child_sd->s_type & CONFIGFS_USET_DROPPING) &&
 		    !(child_sd->s_type & CONFIGFS_USET_CREATING)) {
-			ret = configfs_depend_prep(child_sd->s_dentry,
-						   target);
+			ret = configfs_depend_prep(child_sd, target);
 			if (!ret)
 				goto out;  /* Child path boo-yah */
 		}
@@ -1126,7 +1122,7 @@ static int configfs_do_depend_item(struct dentry *subsys_dentry,
 
 	spin_lock(&configfs_dirent_lock);
 	/* Scan the tree, return 0 if found */
-	ret = configfs_depend_prep(subsys_dentry, target);
+	ret = configfs_depend_prep(subsys_dentry->d_fsdata, target);
 	if (ret)
 		goto out_unlock_dirent_lock;
 
-- 
2.53.0

