Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76AA4B3398;
	Mon, 31 Aug 2026 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184322; cv=none; b=OUjzYbaaL8TCCslghSHN2pKLkoVnbJ7Sh6eXEJtY6Bmhinp6lHh9JTUW4chjWJhy8Ir1kp07CrH6MiuDdqzuNh3YUYUaWn2UJ89TKtMNP5COvZLvcGMFHxXJTHDPkjXtRnMtwnR/CkRgBTT+I88Xo2DRHBgG1gSlkslP777ISSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184322; c=relaxed/simple;
	bh=EgYoyrvMPsoSGWk1v4IkgChDLry2uP5z0WQwDIBV5S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjdQF6FMzxnvSeFm6FZ1r7JdSqZnLA9r/dGzTmdEwTY8X8fA2WnH3ofqPLwiOD1dMlTT3qZvEy3ww5dFIciBDMmG1rBoQ/ufGC91cUPMPiBEtaGRsT9wnOfOCwl7fpzJcaO4sDpaw4af+8FiDZeiYjqH7QVKt4IIDzgxFuPiyVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RE9GnsnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RE9GnsnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41F21F00A3E;
	Mon, 31 Aug 2026 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184319;
	bh=tbfMNc2pHRJNTVbk8gfPJ8lcFEetRD6t1be6xpPKzpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RE9GnsnIxs/DNU39mFGVHUpRPvjs1c04B/JzRJ4N9OEOwqjndAaSPjXvJ5xngGkxF
	 4mKu9nU3d3HwNlyLRNRiJ1HpbQUrxziXLp1SfLTXpF3j0cGgyCwgArC69Tgem/SFaS
	 3RkbBDZIv2o4eNMqugkH63BYvoTvaDM4VlTOlOeVqkATC6LwaywhyKUP+tJ52Xg1dq
	 SUxUjAK96xfVwxDmhDR6AcWPJah5DWd9GTMpnJYmaohTplA7LojyZlXV+D7UQHIIRc
	 knOLXW6boQUPZ+8rT1lA3IUCjlQHaLg17v/M/zTew1EeoXgEcLgsY9Ij3FxVA+S2Xr
	 NoThGDcdVSZww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] qnx4: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:30:50 -0400
Message-ID: <20260831133314.4125787-622-sashal@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c7d911ea1cc9a63b07e52f5e75b263be0615b289 ]

qnx4 uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-4-hch@lst.de
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `qnx4: handle set_blocksize failures`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[qnx4] [handle] handle set_blocksize failures` — error-path
handling for a block-size setup failure during mount.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Christoph Hellwig `<hch@lst.de>` (author)
- **Link:** https://patch.msgid.link/20260511071701.2456211-4-hch@lst.de
  (patch 4/N in a series)
- **Acked-by:** Anders Larsen `<al@alarsen.net>` (qnx4 maintainer)
- **Signed-off-by:** Christian Brauner `<brauner@kernel.org>` (merger)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- Notable: maintainer ack; part of an hch patch series

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** qnx4 ignores `sb_set_blocksize()` failure and continues
  mounting.
- **Symptom:** Kernel `BUG_ON(offset >= folio_size(folio))` in
  `folio_set_bh()` on the first `__bread_gfp` call during mount.
- **Root cause (author):** buffer_heads do not handle block size >
  PAGE_SIZE well; a failed `sb_set_blocksize()` leaves `s_blocksize` in
  a bad state.
- **No explicit kernel version range** in the message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite “handle” rather than “fix”, this prevents a
kernel panic on a mount error path. Same class of bug fix as
minix/qnx6/romfs.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `fs/qnx4/inode.c` (+2 / -1 lines)
- **Function:** `qnx4_fill_super()`
- **Scope:** Single-file, surgical mount-path fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `sb_set_blocksize(s, QNX4_BLOCK_SIZE);` — return value
  ignored; mount continues on failure.
- **After:** `if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE)) return
  -EINVAL;` — mount aborts cleanly.
- **Path affected:** Mount initialization error path in
  `qnx4_fill_super()`, before `sb_bread()`.

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix → kernel panic prevention**

Verified mechanism in this tree:

1. `sb_set_blocksize()` returns `0` on failure (`block/bdev.c:220-229`).
2. On failure, `sb->s_blocksize` is **not** updated.
3. `setup_bdev_super()` also calls `sb_set_blocksize(sb,
   block_size(bdev))` without checking the return value
   (`fs/super.c:1662`). If that fails (e.g. `block_size(bdev) >
   PAGE_SIZE` for non-`FS_LBS` filesystems), `s_blocksize` stays `0`
   (superblock is `kzalloc`'d in `alloc_super()`).
4. qnx4 then calls `sb_set_blocksize(s, 512)`. That can fail when `512 <
   bdev_logical_block_size(bdev)` (`block/bdev.c:171-172`), common on
   4K-native devices.
5. With `s_blocksize == 0`, `sb_bread()` passes `size=0` into
   `folio_alloc_buffers()`:

```932:946:fs/buffer.c
        offset = folio_size(folio);
        while ((offset -= size) >= 0) {
                // ...
                folio_set_bh(bh, folio, offset);
```

6. With `size=0`, `offset` never decreases; first call is
   `folio_set_bh(bh, folio, folio_size)` → triggers:

```1582:1582:fs/buffer.c
        BUG_ON(offset >= folio_size(folio));
```

Verified with a quick simulation: `size=0` → `offset=4096`, `BUG=True`.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Matches established pattern in minix, qnx6,
  romfs, ufs, udf, etc.
- **Minimal:** 2 lines.
- **Regression risk:** Very low. Early `-EINVAL` is handled by
  `get_tree_bdev()` → `deactivate_locked_super()` → `qnx4_kill_sb()`
  which frees `qs`.
- **No API changes.**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Unchecked `sb_set_blocksize(s, QNX4_BLOCK_SIZE)` dates to
`1da177e4c3f41` (Linux 2.6.12-rc2, 2005). Bug present since qnx4
inception. `folio_set_bh()` BUG added in `465e5e6a1698f` (April 2023);
confirmed ancestor of HEAD.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:**
- `git log --oneline -20 -- fs/qnx4/inode.c`: no prior set_blocksize
  fix.
- qnx6 has had this check since initial addition (`5d026c7242201`).
- minix has had it since `1da177e4c3f41` (line 221-222).
- Commit not yet in this tree (`git log --grep='handle set_blocksize
  failures'` empty).

### Step 3.4: Author Context
**Record:** Christoph Hellwig is a core block/VFS developer. Recent qnx4
work in tree is mostly from other authors (VFS conversions). This is a
targeted oversight fix, not a refactor.

### Step 3.5: Dependencies
**Record:** Standalone. No series prerequisites. Applies to existing
`qnx4_fill_super()` + `get_tree_bdev()` mount API already in 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig` could not be run — commit hash not in this tree.
Link fetch to lore.kernel.org blocked (Anubis bot protection).
patch.msgid.link timed out. Patch is 4/N per Link tag; content matches a
focused bug fix.

### Step 4.2: Reviewers
**Record:** Acked-by Anders Larsen (qnx4 maintainer). Merged by VFS
maintainer Christian Brauner. Strong subsystem review signal despite
incomplete lore access.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified by
code analysis in patch series (hch). Mechanism verified locally (see
Phase 2).

### Step 4.4: Related Patches
**Record:** Part of a multi-patch series (patch 4). This hunk is self-
contained; no evidence other series patches are required for this fix.

### Step 4.5: Stable List History
**Record:** Not searched (lore inaccessible). Absence of `Cc: stable` is
expected per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `qnx4_fill_super()`, `sb_set_blocksize()`, `sb_bread()` →
`__bread_gfp()` → `bdev_getblk()` → `folio_alloc_buffers()` →
`folio_set_bh()`.

### Step 5.2: Callers
**Record:**
- `qnx4_fill_super()` ← `qnx4_get_tree()` ← `get_tree_bdev()` ← mount
  syscall path.
- Triggered when a user mounts a qnx4 filesystem (`mount -t qnx4 ...`).

### Step 5.3: Callees
**Record:** `sb_set_blocksize()` → `set_blocksize()` →
`bdev_validate_blocksize()`. Failure when requested size < device
logical block size or other validation failure.

### Step 5.4: Reachability
**Record:** Reachable from userspace via `mount(2)` when
`CONFIG_QNX4FS_FS` is enabled. Unprivileged users can attempt mount
(will fail with permissions or succeed if allowed); kernel panic is not
an acceptable failure mode.

### Step 5.5: Similar Patterns
**Record:** minix (`fs/minix/inode.c:221`), qnx6
(`fs/qnx6/inode.c:312`), romfs, ufs, udf, hfs, gfs2, fuse all check
`sb_set_blocksize()` return value. qnx4 is the outlier.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `fs/qnx4/inode.c:205`:

```205:205:fs/qnx4/inode.c
        sb_set_blocksize(s, QNX4_BLOCK_SIZE);
```

`QNX4_BLOCK_SIZE` is 512 (`include/uapi/linux/qnx4_fs.h:30`).
`folio_set_bh()` BUG exists in this tree. Bug has been latent since
2005; panic path active since folio/buffer conversion (~2023).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Only contextual difference: tree
uses `kzalloc(sizeof(...), GFP_KERNEL)` vs. upstream `kzalloc_obj()`.
The two-line hunk applies directly.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix in this tree. qnx6 and minix already have
the check.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **Filesystem driver (qnx4)** — PERIPHERAL in reach (niche,
read-only FS), but mount path touches core buffer-head infrastructure
shared by many filesystems.

### Step 7.2: Subsystem Activity
**Record:** Low activity (`git log --oneline -20 -- fs/qnx4/` shows
mostly VFS API conversions). Mature, rarely touched code — classic
stable-backport profile.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users who enable `CONFIG_QNX4FS_FS` and mount qnx4 on block
devices where `sb_set_blocksize(512)` fails — notably 4K-logical-sector
devices where `512 < bdev_logical_block_size(bdev)`.

### Step 8.2: Trigger Conditions
**Record:**
- **Common on modern storage:** 4K logical block size is widespread.
- **Userspace trigger:** `mount -t qnx4` on incompatible block device.
- **Not a race:** Deterministic on mount when blocksize setup fails.

### Step 8.3: Failure Mode Severity
**Record:** **CRITICAL** — `BUG_ON()` kernel panic during mount. Mount
failure should return `-EINVAL` to userspace, not crash the kernel.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents kernel panic; converts crash to clean
  mount failure.
- **Risk:** VERY LOW — 2-line check, established pattern, no behavior
  change on success path.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real kernel panic (`BUG_ON`) on mount error path
- Bug verified in 6.18.44 tree
- Tiny, obviously correct fix matching minix/qnx6/romfs
- Acked by qnx4 maintainer; merged by VFS maintainer
- Error-path cleanup verified via `deactivate_locked_super()` →
  `qnx4_kill_sb()`
- Long-standing oversight (since 2005); panic path since folio
  conversion (~2023)

**AGAINST backport:**
- qnx4 is niche (CONFIG_QNX4FS_FS, read-only legacy FS)
- No syzbot/user crash report attached
- Lore discussion not accessible for stable nomination confirmation

**Unresolved:**
- Full lore thread content unavailable (bot protection / timeout)
- Exact mainline commit SHA not in this tree

Neither unresolved item affects the technical verdict.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — matches minix/qnx6;
maintainer ack |
| 2. Fixes a real user-affecting bug? | **PASS** — kernel panic on mount
|
| 3. Important issue? | **PASS** — CRITICAL (BUG_ON panic) |
| 4. Small and contained? | **PASS** — 2 lines, one function |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — clean apply to 6.18.44 |

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision Rationale
This commit closes a long-standing gap where qnx4 ignored
`sb_set_blocksize()` failure while sibling filesystems (minix, qnx6) did
not. On devices where setting 512-byte blocks fails, mount proceeds with
`s_blocksize == 0`, and the first `sb_bread()` triggers `BUG_ON()` in
`folio_set_bh()` — a kernel panic that should be a userspace-visible
`-EINVAL`. The fix is minimal, well-precedented, and low-risk. qnx4's
niche status reduces blast radius but does not reduce severity when
triggered.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided
  content
- **[Phase 1]** Identified hidden bug fix (panic prevention on mount
  failure)
- **[Phase 2]** Read diff: 2-line change in `qnx4_fill_super()`
- **[Phase 2]** Read `sb_set_blocksize()` at `block/bdev.c:220-229` —
  returns 0 on failure
- **[Phase 2]** Read `bdev_validate_blocksize()` at
  `block/bdev.c:171-172` — rejects size < logical block size
- **[Phase 2]** Read `folio_alloc_buffers()` + `folio_set_bh()` at
  `fs/buffer.c:932-946, 1582`
- **[Phase 2]** Simulated `size=0` path — confirms `BUG_ON` trigger
  (`offset=4096, triggers BUG=True`)
- **[Phase 3]** `git describe HEAD` → `v6.18.44`
- **[Phase 3]** `git blame -L 205,205 fs/qnx4/inode.c` → `1da177e4c3f41`
  (2005)
- **[Phase 3]** `git merge-base --is-ancestor 465e5e6a1698f HEAD` →
  folio_set_bh in tree
- **[Phase 3]** `git log --grep='handle set_blocksize failures'` → empty
  (not yet applied)
- **[Phase 3]** Verified minix check since 2005
  (`fs/minix/inode.c:221-222`)
- **[Phase 3]** Verified qnx6 check (`fs/qnx6/inode.c:312-314`)
- **[Phase 4]** `b4 dig` — failed (no commit hash in tree)
- **[Phase 4]** WebFetch lore.kernel.org — blocked (Anubis)
- **[Phase 4]** WebFetch patch.msgid.link — timed out
- **[Phase 5]** Traced mount call chain: `qnx4_get_tree` →
  `get_tree_bdev` → `qnx4_fill_super`
- **[Phase 5]** Confirmed peer filesystems check `sb_set_blocksize`
  return value
- **[Phase 6]** Confirmed buggy line at `fs/qnx4/inode.c:205` in 6.18.44
- **[Phase 6]** `QNX4_BLOCK_SIZE = 0x200` (512) in
  `include/uapi/linux/qnx4_fs.h:30`
- **[Phase 6]** Verified error cleanup: `get_tree_bdev` →
  `deactivate_locked_super` → `qnx4_kill_sb` (`fs/super.c:1705-1708`,
  `fs/qnx4/inode.c:257-264`)
- **[Phase 8]** Failure mode: BUG_ON kernel panic, severity CRITICAL

**YES**The background history checks finished and match the earlier
analysis:

- **`git log --grep='qnx4: handle set_blocksize failures'`** — no match
  in this tree; the fix isn’t applied yet in **6.18.44**.
- **`git log -S 'sb_set_blocksize(s, QNX4_BLOCK_SIZE)' --
  fs/qnx4/inode.c`** — the unchecked call goes back to
  **`1da177e4c3f41`** (Linux 2.6.12-rc2), so this is a long-standing
  gap, not a recent regression.

That supports the **YES** backport verdict: the bug is present here, the
fix is small and well-precedented (minix/qnx6 already do this), and it
prevents a mount-time `BUG_ON()` panic when `sb_set_blocksize(512)`
fails.

 fs/qnx4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index e399e2dd3a124..7a15ad20d98a2 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -202,7 +202,8 @@ static int qnx4_fill_super(struct super_block *s, struct fs_context *fc)
 		return -ENOMEM;
 	s->s_fs_info = qs;
 
-	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
+	if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE))
+		return -EINVAL;
 
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-- 
2.53.0

