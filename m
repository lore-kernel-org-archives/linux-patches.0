Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2954A8FCD;
	Mon, 31 Aug 2026 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183955; cv=none; b=ei6Pp/HbvDhPBVdDv6yvTC4kUCgqsea/la/ffUpAlfltAQ1SZnMMGZIJm9yL/lo2iKGgodSUbjUv2AeC8n3Gg257Qx6ny0RyPngbv8dHPIiTMUtBiDzg2e/VxX4z2PCTq1XCgrvLk9N3jCmve4TcMulT45iqljftDWPJAAQZ49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183955; c=relaxed/simple;
	bh=ZXzjaZE46lFi/jNrqCMZePIsIT/j8TA4E4nD29S2KS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UqieR6hpabLsQfGjjnZb9y5nDfCPb5gSz8RPXbQMIIrw6VPsXlfExQneMcAz5lYe/komRXdLmsCbW/JtiqyrDvxyMHcSsVGp2tzkQPJT2D8Z3TRqYdWAp/old8k8WmqH/UohQX324rqnsi4+e41gaxMFGa9s/OtcusUazd7tr+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/akwbGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/akwbGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA491F00A3F;
	Mon, 31 Aug 2026 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183953;
	bh=wC9cdW9mQNJEVes6ak1jpSMwduyDH0bcPNJB2MnXJQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/akwbGka0/YELRWHunI7sdYO52I19mww0r+K6XFGC6J7dOljl/kdkq9H/icG9ujI
	 GH/gWYOOVy4UhhTz1HX1ZSpWz0ozBkRuMWoNnsWtA60yXJr1c/HBo5FQVO+R3UuwhA
	 sKZ5m+AgnmG/GgkUHMhYgjc3fdwBsN0w97lLrMwFs5OmSxntX9hJjJuFblHfe4oG4E
	 XSGI3pWyCoLcl6Y2qTJOfayO0QcycaXXYg531UYOXwPF9mgAe5TBi/31NLfEzbZr/d
	 YDl1ZtmVbaHEw1VFn8No8+oxqdN6XtrdkvYj8KG5G7fd+vtC790PoCMyHI6++1So4X
	 Gog0/6rZniBLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] cachefiles: Fix double fput
Date: Mon, 31 Aug 2026 09:27:09 -0400
Message-ID: <20260831133314.4125787-401-sashal@kernel.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit af6830cc12dfe86c832dccc9c9878a93aaa22f83 ]

Fix a double fput() in error handling in cachefiles_create_tmpfile().

Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-4-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[cachefiles] [fix] Fix double fput` — explicit bug fix in
the cachefiles filesystem caching backend.

### Step 1.2: Tags
**Record:**
- **Link:** https://sashiko.dev/#/patchset/20260608145432.681865-1-
  dhowells%40redhat.com (patchset reference)
- **Signed-off-by:** David Howells `<dhowells@redhat.com>` (author)
- **Link:**
  https://patch.msgid.link/20260625140640.3116900-4-dhowells@redhat.com
  (mailing list submission)
- **cc:** Paulo Alcantara, netfs@lists.linux.dev, linux-
  fsdevel@vger.kernel.org
- **Signed-off-by:** Christian Brauner (Amutable) `<brauner@kernel.org>`
  (merge sign-off)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, or Cc: stable tags
  (expected for manual review)
- Part of **[PATCH v3 03/15]** series (standalone one-line fix within a
  larger series)

### Step 1.3: Body analysis
**Record:**
- **Bug:** Double `fput()` on the error path in
  `cachefiles_create_tmpfile()` when the backing cache filesystem lacks
  `read_iter`/`write_iter`.
- **Symptom:** Reference count dropped twice on the same `struct file
  *`; second `fput()` can trigger refcount underflow warnings,
  `WARN_ON`, or use-after-free.
- **Root cause:** Extra `fput(file)` before `goto err_unuse`, but
  `err_unuse` already calls `fput(file)`.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit, straightforward double-
free/refcount bug fix, not disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `fs/cachefiles/namei.c` — 1 line removed, 0 added
- **Function:** `cachefiles_create_tmpfile()`
- **Scope:** Single-file, surgical one-line fix

### Step 2.2: Code flow change
**Record:**
- **Before:** On `read_iter`/`write_iter` check failure → `fput(file)` →
  `goto err_unuse` → `cachefiles_do_unmark_inode_in_use()` →
  `fput(file)` again.
- **After:** On failure → `goto err_unuse` → single `fput(file)` via the
  shared cleanup label.
- **Path affected:** Error path only, after successful tmpfile creation
  but before capability validation.

### Step 2.3: Bug mechanism
**Record:** **Reference counting / double-free bug.** Category: extra
`fput()` on an error path that already releases the file reference.
Matches the correct pattern in sibling function `cachefiles_open_file()`
(lines 576–611), which uses `goto error_fput` with only one `fput()`.

### Step 2.4: Fix quality
**Record:** Obviously correct — removes redundant `fput()` and aligns
with existing convention in the same file. Minimal regression risk; no
locking or API changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `git blame` attributes all lines to merge commit
`5d324e5159d9e` (history in this tree is flattened). Tag comparison
shows the buggy pattern present since `cachefiles_create_tmpfile()` was
introduced:
- Present with bug in **v6.12.50** through **v6.12.99**
- Absent in **v6.18.0**; present with bug from **v6.18.1** through
  **v6.18.44** (current HEAD)

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -- fs/cachefiles/namei.c` shows only
merge commit in this tree’s shallow history. Tag comparison confirms the
bug has been present since the function’s introduction in this stable
series.

### Step 3.4: Author context
**Record:** David Howells is the primary fscache/cachefiles maintainer.
Patch was submitted to Christian Brauner and fsdevel/netfs lists.

### Step 3.5: Dependencies
**Record:** Standalone fix. Although labeled patch 03/15 of v3, this
one-line deletion has no structural dependency on other series patches.
Applies cleanly to the current tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` did not match (commit not in local
history). Found submission at https://lists.openwall.net/linux-
kernel/2026/06/25/1287 (Message-ID:
`<20260625140640.3116900-4-dhowells@redhat.com>`). Also appeared in v2
and v4 series. No NAKs or objections found in fetched content. No
explicit stable nomination in the patch email.

### Step 4.2: Reviewers
**Record:** CC’d: Christian Brauner, Christoph Hellwig, Paulo Alcantara,
netfs@lists.linux.dev, linux-fsdevel, plus netfs client lists (afs,
cifs, ceph). Appropriate maintainer coverage.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
code inspection during cachefiles development (sashiko patchset).

### Step 4.4: Series context
**Record:** Part of David Howells’ cachefiles patchset (v3 03/15). This
specific fix is self-contained and does not require other series
patches.

### Step 4.5: Stable list history
**Record:** Not searched exhaustively on lore stable@; no stable
discussion found in available sources.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `cachefiles_create_tmpfile()` modified.

### Step 5.2: Callers
**Record:**
- `cachefiles_create_file()` — `namei.c:531` (new cache object creation)
- `cachefiles_invalidate_cookie()` — `interface.c:407` (cookie
  invalidation / tmpfile replacement)

Both are kernel fscache/cachefiles paths triggered during networked
filesystem cache operations.

### Step 5.3: Callees
**Record:** `kernel_tmpfile_open()`, `cachefiles_mark_inode_in_use()`,
`cachefiles_ondemand_init_object()`, `vfs_truncate()`, `fput()`,
`cachefiles_do_unmark_inode_in_use()`, `cachefiles_end_secure()`.

### Step 5.4: Reachability
**Record:** Reachable when `CONFIG_CACHEFILES` is enabled and a
user/admin configures cachefiles as a local backing store for fscache
(NFS, CIFS, AFS, Ceph, etc.). Trigger requires a backing filesystem
whose file operations lack `read_iter` or `write_iter` — marked
`unlikely()`, but ext4/xfs/btrfs normally provide these; exotic or
misconfigured backing FS could hit it. Not a direct syscall path, but
reachable from normal filesystem I/O for cache-enabled mounts.

### Step 5.5: Similar patterns
**Record:** `cachefiles_open_file()` at lines 576–611 implements the
same `read_iter`/`write_iter` check correctly with a single `fput()` via
`error_fput`. The tmpfile path was inconsistent — classic copy-paste
error.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Local tree is **6.18.44** (`git describe`:
`v6.18.44-1-g2736c32da98b9`). Buggy code confirmed at
`fs/cachefiles/namei.c:502–504`:

```499:515:fs/cachefiles/namei.c
        ret = -EINVAL;
        if (unlikely(!file->f_op->read_iter) ||
            unlikely(!file->f_op->write_iter)) {
                fput(file);
                pr_notice("Cache does not support read_iter and
write_iter\n");
                goto err_unuse;
        }
// ...
err_unuse:
        cachefiles_do_unmark_inode_in_use(object, file_inode(file));
        fput(file);
```

Bug present since **v6.18.1** (function absent in v6.18.0).

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — exact one-line deletion, no
conflicts anticipated. File structure matches the patch diff.

### Step 6.3: Related fixes already present?
**Record:** `git log --grep="double fput"` returns nothing. Fix not yet
applied in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** **fs/cachefiles** — IMPORTANT (filesystem caching for
network filesystems). Not universal core code, but affects production
NFS/CIFS/AFS caching deployments.

### Step 7.2: Subsystem activity
**Record:** Actively maintained by David Howells; recent tmpfile
infrastructure added in 6.18.y stable series.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_CACHEFILES` enabled and cachefilesd (or
equivalent) configured. Subset of server/workstation deployments using
FS-Cache.

### Step 8.2: Trigger conditions
**Record:** Creating or invalidating a cache object tmpfile on a backing
filesystem missing `read_iter` or `write_iter`. Uncommon but plausible
with unusual FS choices. Triggered from kernel cache management, not
arbitrary userspace directly.

### Step 8.3: Failure mode severity
**Record:** **HIGH** — double `fput()` causes refcount underflow,
potential use-after-free, kernel `WARN`/`BUG`, or memory corruption. Not
merely cosmetic.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents refcount corruption and potential crash/UAF on a
  real error path.
- **Risk:** Very low — one-line removal, matches established pattern in
  same file.
- **Ratio:** Strong benefit, negligible risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real double `fput()` bug on error path
- HIGH severity when triggered (refcount corruption / UAF)
- One-line, obviously correct fix
- Bug present in this 6.18.44 tree since v6.18.1
- Matches correct pattern already used in `cachefiles_open_file()`
- From subsystem maintainer (David Howells)
- Applies cleanly

**AGAINST backport:**
- Rare trigger path (`unlikely()` + specific FS requirements)
- CONFIG_CACHEFILES is optional
- No syzbot/user crash report

**Unresolved:** No runtime crash report; severity inferred from refcount
semantics and code analysis.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; no Tested-by
   but fix is trivial
2. Fixes a real bug? **PASS** — confirmed double `fput()` in code
3. Important issue? **PASS** — refcount bug / potential UAF (HIGH)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, clean apply

### Step 9.3: Exception categories
**Record:** None (standard bug fix, not device ID/quirk/build fix).

### Step 9.4: Decision rationale
This is a textbook stable backport: a real reference-counting bug on an
error path, fixed by a single-line deletion that mirrors the correct
pattern already in the same file. The trigger is uncommon but the
consequence is serious. The bug exists in the locally checked-out
**6.18.44** tree and the patch applies without dependencies.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  openwall mirror
- [Phase 2] Read current `fs/cachefiles/namei.c:442–515` — confirmed
  double `fput()` path
- [Phase 2] Compared with `cachefiles_open_file()` at lines 576–611 —
  correct single-fput pattern verified
- [Phase 3] `git describe HEAD` → v6.18.44-1-g2736c32da98b9; `make
  kernelversion` → 6.18.44
- [Phase 3] `git blame -L 499,520 fs/cachefiles/namei.c` → lines
  attributed to 5d324e5159d9e
- [Phase 3] Tag comparison: v6.18.0 (no function), v6.18.1–v6.18.44 (bug
  present), v6.12.50–v6.12.99 (bug present)
- [Phase 3] `git show 1efe5d048a391:fs/cachefiles/namei.c` → buggy code
  at 6.18.44 tag
- [Phase 3] `git log --grep="double fput"` → no existing fix
- [Phase 4] `b4 dig -c HEAD` → no match (commit not in tree)
- [Phase 4] WebFetch openwall 2026/06/25/1287 → confirmed patch content
  and v3 03/15 series context
- [Phase 4] CC list verified: Brauner, Hellwig, fsdevel, netfs
  maintainers
- [Phase 5] `grep cachefiles_create_tmpfile` → callers in `namei.c:531`,
  `interface.c:407`
- [Phase 6] Current working tree has buggy code at line 502 (`fput`
  before `goto err_unuse`)
- [Phase 6] `git log --grep="double fput"` → fix not yet applied
- [Phase 7] Read `fs/cachefiles/Kconfig` → CONFIG_CACHEFILES tristate,
  depends on NETFS_SUPPORT && FSCACHE && BLOCK
- [Phase 8] Failure mode assessed from double-fput refcount semantics
  (no runtime reproducer available)

**YES**

 fs/cachefiles/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index d1edb2ac38376..eae5045d50081 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -499,7 +499,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}
-- 
2.53.0

