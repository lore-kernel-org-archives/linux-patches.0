Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6040861DA9A;
	Mon, 19 Oct 2026 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418669; cv=none; b=bUtGYomxb7KpYKkdwAhjn02KdFKGblB6N7jtq/S10S7lhvzHDasLfCC3jGYBenTK0RaUTNJCkkaDRBJPxcJ90Y45eJ2cuTL8dtlMs+n1bZ6GlKkfX1qNpvn97ObT6UJt0nLZZdwdzzXVJXzGT/Pm+u9g8dqE+SW9XP7lrk7m8gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418669; c=relaxed/simple;
	bh=4KAYUoOjix1DR/FJ57j7j+nuWbJyyBYf1hpwM4JbsIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=an01y1acNg+ewI7zvoZTfPVZ8ZV8Pda+3W5m+OqOVqHr6uhq7G7DJZ7e55oIrIycI+o205RP9zLjy0s6EGvD9NH8T5xXghGUnDMbqONLGtS/sy+wqqLeH/OxnSIwoL3ZdMSCtXujWFjaVjwJIDWjgkjLUM7udGO5QuZ15XrDCTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6+VHHa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6+VHHa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B86A1F000C5;
	Mon, 19 Oct 2026 14:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418666;
	bh=jLLDh1puObx2wo+uvUVY78w4616Mp3OdJM02tYhJN7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6+VHHa9uugtqhVeKuGruwQDoZXzQztoY517PNQH7XjBzPe/nj3o0wCwdR30UpNTt
	 Q+S8hRvQWfSNNhq3Trj7Hv9DGAHZtTK64r104dUxugRmEyRfUaAoVg+oZSJ3TjUYBN
	 OVZKoZXEyPXeUa7kKN95qGzxpOPTZ9bHch03u8fc2wsuLhYMhOvaDjuzSmHtUjiAPy
	 tnPpNDMy/8lHKfjEgfX8WllMvVrkDATuIgGWBsbpMIpYXNln8A9DzAVBQh4eIJEG1q
	 hXe4cyESKpGA7ZRbaZkLL477al1I2t9Hb9Uil2Tn1f0HI/kAdj6jo+EAKJzMiNfTLF
	 oi6gUWDncaghQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] exfat: free new directory cluster if zeroing fails
Date: Mon, 19 Oct 2026 09:51:42 -0400
Message-ID: <20261019135441.1420968-411-sashal@kernel.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit ce12a39bed483008683438962b3a605374e6f803 ]

exfat_alloc_new_dir() allocates a cluster for a new directory before
zeroing it.  If exfat_zeroed_cluster() fails, the function returns the
error but leaves the allocated cluster in use.

Free the newly allocated cluster before returning the zeroing error.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[exfat] [free] Free a newly allocated directory cluster if
zeroing it fails.`

**Step 1.2: Tags**
Record:
- `Signed-off-by: Yichong Chen <chenyichong@uniontech.com>` (author)
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` (exFAT
  maintainer; applied the patch)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`
Absence of `Fixes:` / `Cc: stable` is expected for this review pipeline
and is not a negative signal.

**Step 1.3: Body**
Record:
- **Bug:** `exfat_alloc_new_dir()` allocates a cluster, then zeros it.
  On `exfat_zeroed_cluster()` failure it returns the error and leaves
  the cluster marked allocated.
- **Symptom:** leaked cluster (allocation bitmap / `used_clusters`), not
  a crash.
- **Version info:** none in the message.
- **Root cause:** missing rollback of `exfat_alloc_cluster()` on the
  zeroing error path.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. This is an explicit error-path resource-leak fix.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `fs/exfat/dir.c` (`+7 / -1`)
- Function: `exfat_alloc_new_dir()`
- Scope: single-file surgical error-path change

**Step 2.2: Code-flow change**
Record: **Before:** allocate one cluster; `return
exfat_zeroed_cluster(...)`. Zeroing failure returns `-ENOMEM`/`-EIO`
with the cluster still in the bitmap. **After:** on zeroing failure,
`exfat_free_cluster(inode, clu)` then return the original error. Success
still returns 0.

**Step 2.3: Bug mechanism**
Record: **Error-path resource leak.** Cluster stays marked used with no
directory entry pointing at it. `exfat_alloc_cluster()` does
`p_chain->size++` and `sbi->used_clusters += p_chain->size`, and can
dirty/sync the allocation bitmap via `exfat_set_bitmap()`. The leak can
persist on disk until fsck.

**Step 2.4: Fix quality**
Record: Obviously correct and minimal. Same rollback already exists in
`exfat_add_entry()` when `exfat_put_dentry_set()` fails
(`fs/exfat/namei.c`). `exfat_alloc_cluster()` drops `bitmap_lock` before
returning, so calling `exfat_free_cluster()` here does not deadlock.
Caller (`exfat_add_entry`) discards `clu` on error. Regression risk is
low.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: The leak (`return exfat_zeroed_cluster(inode, clu->dir)`) was
introduced in `ca06197382bde0` (“exfat: add directory operations”,
Namjae Jeon, 2020-03-02), described as `v5.6-rc1-4-gca06197382bde`
(exFAT landed around v5.7). The `exfat_alloc_cluster(..., false)`
argument is from `286ae368871d2` (2026 multi-cluster alloc); that is
unrelated to the leak.

**Step 3.2: Fixes: tag**
Record: None. The introducing commit is `ca06197382bde0`. `git merge-
base --is-ancestor ca06197382bde0 HEAD` is implied by the blame on this
tree; the buggy pattern existed here from the start of in-tree exFAT.

**Step 3.3: File history**
Record: Recent `fs/exfat/dir.c` work is unrelated (overflow, uniname
bounds, rename). Same-day follow-up `0901a71e8cff5` (“clean up new entry
on add entry failure”) handles a *later* failure
(`exfat_put_dentry_set()` after a successful `exfat_alloc_new_dir()`).
Complementary, not a prerequisite.

**Step 3.4: Author**
Record: Yichong Chen has three recent exFAT error-path commits. Namjae
Jeon is listed maintainer (`MAINTAINERS`: EXFAT FILE SYSTEM) and applied
this patch.

**Step 3.5: Dependencies**
Record: Standalone. Uses existing `exfat_free_cluster()`. No new helpers
or APIs. The leak-fix hunk does not depend on multi-cluster allocation.

---

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- Lore/msgid: `https://patch.msgid.link/20260728042923.408237-1-
  chenyichong@uniontech.com`
- `b4 dig -a`: v1 only, committed as submitted
- Maintainer reply: “Applied it to #dev. Thanks!” No NAK, no requested
  changes, no `Cc: stable` in the thread.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Namjae Jeon, Sungjong Seo, Yuezhang Mo, `exfat@lists.linux.dev`,
`linux-kernel@vger.kernel.org` — the MAINTAINERS set.

**Step 4.3: Bug report**
Record: No `Reported-by` / bugzilla / syzbot. Author-found by code
inspection. Trigger is still real: `exfat_zeroed_cluster()` returns
`-ENOMEM` on `sb_getblk()` failure, `-EIO` on out-of-range cluster, or a
DIRSYNC `sync_blockdev_range()` error.

**Step 4.4: Series**
Record: Standalone one-patch series. Next-day `0901a71e8cff5` is a
related but independent leak/cleanup.

**Step 4.5: Stable list**
Record: No stable-list discussion found. lore.kernel.org HTML fetch
returned 403; thread was recovered via `b4 dig -m`. No evidence this was
rejected for stable.

---

## Phase 5: Code semantic analysis

**Step 5.1: Functions**
Record: Modified: `exfat_alloc_new_dir()`. Callees:
`exfat_alloc_cluster`, `exfat_zeroed_cluster`, `exfat_free_cluster`.

**Step 5.2: Callers**
Record: Only `exfat_add_entry()` in `fs/exfat/namei.c` (mkdir path,
`type == TYPE_DIR && !sbi->options.zero_size_dir`). `zero_size_dir`
defaults to false (`/* Support creating zero-size directory, default:
false */`).

Call chain: `exfat_mkdir` → `exfat_add_entry` → `exfat_alloc_new_dir`.
`exfat_mkdir` is `.mkdir` in the inode operations. Userspace `mkdir(2)`
on a writable exFAT mount reaches this. `exfat_mkdir` takes `s_lock` and
sets the volume dirty *before* `exfat_add_entry`.

**Step 5.3: Callees**
Record: `exfat_alloc_cluster` marks bitmap + increments `used_clusters`.
`exfat_zeroed_cluster` zeros every sector in the cluster.
`exfat_free_cluster` takes `bitmap_lock` and clears the bitmap /
decrements `used_clusters`.

**Step 5.4: Reachability**
Record: Yes, from `mkdir(2)` on exFAT (SD cards / USB sticks;
`CONFIG_EXFAT_FS`). Unprivileged users can trigger it if they can mkdir
on the mount. Failure of zeroing is an error path (memory pressure or
I/O error), not every mkdir.

**Step 5.5: Similar pattern**
Record: `fs/exfat/namei.c` around the `exfat_find_empty_entry()` grow
path still does `exfat_alloc_cluster()` then `if
(exfat_zeroed_cluster(...)) return -EIO;` without freeing. That is a
sibling leak, not a reason to drop this fix.

---

## Phase 6: Local tree (this checkout)

**Step 6.1: Does the buggy code exist here?**
Record: Local tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`).
`git merge-base --is-ancestor ce12a39bed483 HEAD` succeeded — this
commit is already in HEAD. Pre-fix `dir.c` had the leak since
`ca06197382bde0` (v5.7-era). Current `exfat_alloc_new_dir()` already
contains the free-on-zeroing-failure path.

**Step 6.2: Backport difficulty onto this tree**
Record: Already applied; context matches. On this 7.3 tree there is
nothing left to apply.

**Step 6.3: Related fixes already here?**
Record: `0901a71e8cff5` is also in HEAD and covers a different failure
(writeback of the new dentry set). No alternate fix of this zeroing-path
leak.

The question for *this* tree is whether the fix is stable-worthy given
that the bug and the code path exist here. It is not a “code missing
from the tree” NO.

---

## Phase 7: Subsystem context

**Step 7.1:**
Record: `fs/exfat/` — filesystem. **IMPORTANT** (not core VFS/mm, but a
widely used removable-media FS).

**Step 7.2:**
Record: Actively maintained (Namjae Jeon, Sungjong Seo). The leak itself
is old (2020), not a new-subsystem-only bug.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Users of `CONFIG_EXFAT_FS` who create directories (default
`zero_size_dir=false`). Typical: SD cards, USB sticks.

**Step 8.2: Trigger**
Record: `mkdir` after a cluster was allocated, then
`exfat_zeroed_cluster()` fails. Not every mkdir; needs
ENOMEM/EIO/DIRSYNC write failure. Unprivileged if the mount is writable.

**Step 8.3: Failure mode**
Record: Persistent cluster leak (bitmap + `used_clusters`), lost free
space until fsck. Volume is already marked dirty. Not a
panic/UAF/corruption of existing files. **Severity: HIGH** for on-disk
space leak; not CRITICAL crash/corruption.

**Step 8.4: Risk-benefit**
Record:
- **Benefit:** High for remount-surviving leaked clusters on a common
  removable FS; tiny, obviously correct rollback.
- **Risk:** Very low (7 lines, error path only, existing free helper,
  lock order already used elsewhere).
- **Ratio:** Favorable.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real leak: allocated cluster not freed when zeroing fails
- On-disk allocation bitmap can retain the leak
- Reachable from `mkdir(2)` on default exFAT mounts
- Present since exFAT was merged (~v5.7)
- 7-line surgical rollback; `exfat_free_cluster()` already used on
  similar error paths
- Maintainer applied v1 with no objections
- No new API/feature; no prerequisites in this tree

AGAINST:
- Error path, not a crash/UAF/CVE
- No syzbot/user report
- Sibling leak in `namei.c` grow path remains (does not invalidate this
  fix)

UNRESOLVED:
- Could not HTML-fetch lore.kernel.org (403); thread recovered with `b4
  dig -m`
- No stable-list thread found

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — maintainer applied; logic
   matches existing cleanup in `exfat_add_entry()`
2. Real bug affecting users? **PASS** — leaked clusters on failed mkdir
3. Important? **PASS** — persistent FS space leak (not a crash, but more
   than cosmetic)
4. Small and contained? **PASS** — 7 insertions / 1 deletion, one
   function
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — already in this 7.3-rc4 tree; the
   same rollback is what stable wants

**Step 9.3: Exception category**
Record: None required. Ordinary small leak fix.

**Step 9.4: Decision**
This is a classic stable leak fix: small, obviously correct, user-
visible (lost clusters on exFAT mkdir error), and present for years. It
should be selected for stable.

---

## What the commit solves for stable users

`mkdir` on exFAT allocates a directory cluster, then zeros it. If
zeroing fails, the mkdir error is returned but the cluster stays
allocated in the bitmap with no dentry. That can permanently shrink free
space until fsck. The patch frees that cluster on the error path.

It meets the stable rules: real bug, small, no new API, already reviewed
by the maintainer. Risk is low; benefit is preventing a persistent
filesystem resource leak.

---

## Verification

- [Phase 1] Parsed commit `ce12a39bed483`; tags are author + maintainer
  SOB only
- [Phase 2] Diff is `fs/exfat/dir.c` `exfat_alloc_new_dir()`: add
  `exfat_free_cluster()` on `exfat_zeroed_cluster()` failure
- [Phase 2] Confirmed `exfat_alloc_cluster()` increments `p_chain->size`
  and `used_clusters`; `exfat_free_cluster()` no-ops if `size == 0`
- [Phase 2] Confirmed `exfat_zeroed_cluster()` can return `-ENOMEM`
  (`sb_getblk`), `-EIO` (range check), or DIRSYNC I/O error
- [Phase 3] `git blame` on parent: leak from `ca06197382bde0`
  (2020-03-02, `v5.6-rc1-4`)
- [Phase 3] `git merge-base --is-ancestor ce12a39bed483 HEAD` → commit
  is in this tree
- [Phase 3] Follow-up `0901a71e8cff5` is a different failure path; not a
  prerequisite
- [Phase 4] `b4 dig -c ce12a39bed483` → msgid
  `20260728042923.408237-1-chenyichong@uniontech.com`
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: exFAT maintainers + list
- [Phase 4] mbox: Namjae Jeon “Applied it to #dev”; no NAK
- [Phase 4] WebFetch lore HTML: 403; used `b4 dig -m` instead
- [Phase 5] `git grep exfat_alloc_new_dir`: only `exfat_add_entry()` →
  `exfat_mkdir`
- [Phase 5] Default `zero_size_dir` is false, so mkdir uses this path
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`
- [Phase 6] Current `fs/exfat/dir.c` already contains the fixed function
- [Phase 7] `MAINTAINERS`: Namjae Jeon, Sungjong Seo; `CONFIG_EXFAT_FS`
  for SD/USB
- [Phase 8] Failure mode verified as cluster leak, not oops
- UNVERIFIED: stable@ mailing-list archive HTML (403)

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 fs/exfat/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 1f6cb533a48d1..d82b48722ef76 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -310,7 +310,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
 	if (ret)
 		return ret;
 
-	return exfat_zeroed_cluster(inode, clu->dir);
+	ret = exfat_zeroed_cluster(inode, clu->dir);
+	if (ret) {
+		exfat_free_cluster(inode, clu);
+		return ret;
+	}
+
+	return 0;
 }
 
 int exfat_calc_num_entries(struct exfat_uni_name *p_uniname)
-- 
2.53.0

