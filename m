Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931AA4C9543;
	Mon, 31 Aug 2026 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183547; cv=none; b=HbsA6jTdgnW6RqJcKdP00+jOwBnHERRkNzAEjCrfQ+EgMnIyn8JnQZYxQbx0bnXUiacDk6oSZnt51eg+HF4dgXrHuhfF53xMtVtHGqeG4pGEn+T91fJHsa1Ve/lSngZlb71OO0zZBlOXuNiO4lDSxz7iF+Ru5V7MLFUhnA9PbsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183547; c=relaxed/simple;
	bh=owGxpU0hCiT3x2+IUuGj29JPbSbmXwzCe3w96sMTM3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdip5Jok0qFA30EXOE2WkamCrnutheU0JoxH3hHaJuUsDRTzgPRwYSuXzrc3+XTQTkKmsRJwlshlpz50Da/vdqElbYyD/0KnV+IgPvyc/Tisd9JzSe+9yFTAybI/9/c1r9BSiYaxlUUYMCYXg+MDU/k75ZEhbgW9MShoHpYJh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bIdpfIsq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIdpfIsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AF51F000E9;
	Mon, 31 Aug 2026 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183544;
	bh=O+LD+QuK3T7Ac59fOlWMN70I9q5qrjJVz2ZM6tt8RHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIdpfIsqVsgiE7RY8w3OrxGZpBhhuCdbw7pfV1AObQwS/ysRiQUqIYhzQO56n+SkQ
	 UDhnYjsYrwgVXrkPSG4hCpj+2LoE04brt/YtoDzEppLSYM8FkcOhXJTNLjG2fG0x6i
	 d2BLvUUkYmGKh3jpUqsPzY2gYt5ZfqHjO3vArxO+6clz0+8yWDyys12pAjDD0eh9QI
	 Kui4q1fjUYFRUYTSlcxgjT9gJBvivZgMH6PcaxaVmF0yqHKFQbo7+FELR+22ItO85O
	 SLWOiSBLRtsCGAxYLX+O3lE3nk2UUAkresJsmBXqTP5pM2HLcWAOG5E0Eay+1RKlRG
	 LjlOv1NxOdCtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aivazian.tigran@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] bfs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:23:08 -0400
Message-ID: <20260831133314.4125787-160-sashal@kernel.org>
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

[ Upstream commit 2430e3380936df0b648af720cae624eef035a2d1 ]

bfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

	BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-2-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `bfs: handle set_blocksize failures`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`;
Makefile `VERSION.PATCHLEVEL.SUBLEVEL` = 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[bfs]` `[handle]` — Add error handling when
`sb_set_blocksize()` fails during BFS superblock fill.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260511071701.2456211-2-hch@lst.de`
- **Cc: stable@vger.kernel.org:** — not present (expected)
- **Signed-off-by:** Christoph Hellwig `<hch@lst.de>`; Christian Brauner
  `<brauner@kernel.org>`; (ignore pipeline Sasha Levin SOB per
  instructions)

Notable: no syzbot/fuzzer report; author is a senior VFS developer;
patch is part of a 10-patch series on the same theme.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** BFS ignores `sb_set_blocksize()` failure; mount continues
  with a block size incompatible with buffer-head/folio handling.
- **Symptom:** Kernel `BUG_ON(offset >= folio_size(folio))` in
  `folio_set_bh()` on the first `__bread_gfp` / `sb_bread()` call.
- **Root cause (author):** BFS uses buffer heads, which do not handle
  block size > `PAGE_SIZE` well; when `sb_set_blocksize(s, BFS_BSIZE)`
  fails, the superblock keeps a larger block size set earlier by
  `setup_bdev_super()`.
- **Version info:** none explicit in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit bug fix. The “handle
failures” wording maps directly to preventing a mount-time kernel BUG.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory changes
**Record:**
- **Files:** `fs/bfs/inode.c` (+2 / −1)
- **Function:** `bfs_fill_super()`
- **Scope:** Single-file, surgical fix (2-line logic change)

### Step 2.2: Code flow change
**Record:**
- **Before:** `sb_set_blocksize(s, BFS_BSIZE);` — return value ignored;
  execution continues to `sb_bread(s, 0)`.
- **After:** `if (!sb_set_blocksize(s, BFS_BSIZE)) goto out;` — on
  failure, jump to existing cleanup (`mutex_destroy`, `kfree(info)`,
  return `-EINVAL`).
- **Path affected:** Mount initialization error path in
  `bfs_fill_super()`, called via `get_tree_bdev()` → `bfs_get_tree()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness + memory-safety crash (kernel BUG).
- **Mechanism:**
  1. `setup_bdev_super()` sets `sb->s_blocksize = block_size(bdev)` (can
     be 8K, 16K, 64K on some devices).
  2. BFS then calls `sb_set_blocksize(s, 512)` (`BFS_BSIZE`).
  3. `sb_set_blocksize()` returns `0` on failure (e.g. `512 <
     bdev_logical_block_size(bdev)`, or `size > PAGE_SIZE` without
     `FS_LBS`).
  4. Without the check, `sb->s_blocksize` remains at the large device
     size.
  5. `create_buffers()` in `fs/buffer.c` computes buffer offsets using
     that block size; with `size > folio_size(folio)`, `folio_set_bh()`
     hits `BUG_ON(offset >= folio_size(folio))`.

Verified `sb_set_blocksize()` in `block/bdev.c`:

```220:230:block/bdev.c
int sb_set_blocksize(struct super_block *sb, int size)
{
        if (!(sb->s_type->fs_flags & FS_LBS) && size > PAGE_SIZE)
                return 0;
        if (set_blocksize(sb->s_bdev_file, size))
                return 0;
        /* If we get here, we know size is validated */
        sb->s_blocksize = size;
        sb->s_blocksize_bits = blksize_bits(size);
        return sb->s_blocksize;
}
```

Verified `BFS_BSIZE = 512` in `include/uapi/linux/bfs_fs.h`.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; matches established pattern in ext2,
  ext4, udf, efs, f2fs, etc.
- **Regression risk:** Very low — only aborts mount earlier on a path
  that already crashes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- Unchecked `sb_set_blocksize(s, BFS_BSIZE)` dates to initial import
  (`1da177e4c3f4`, 2005).
- Bug has existed since BFS was added; exposure increased once
  `folio_set_bh()` added `BUG_ON(offset >= folio_size(folio))` (commit
  `465e5e6a1698f`, present in this tree).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Recent BFS changes in this tree: mount API conversion
  (`9d5c8dc811153`), file-type reconstruction (`34ab4c75588c0`).
- Fix commit upstream: `2430e3380936df0b648af720cae624eef035a2d1`
  (2026-05-21).
- **Not an ancestor of HEAD** in this 6.18.44 checkout; buggy code still
  present at line 345.

### Step 3.4: Author context
**Record:** Christoph Hellwig is a core VFS/block developer. This patch
is patch 1/10 in a series fixing the same missing-check pattern across
legacy filesystems (affs, befs, bfs, hpfs, isofs, jfs, minix, qnx4,
ntfs3, omfs).

### Step 3.5: Dependencies
**Record:** **Standalone.** Only modifies `bfs_fill_super()` error
handling. No prerequisite commits required. Other series patches are
independent per-filesystem fixes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260511071701.2456211-2-hch@lst.de
- **Series cover:** “fix crashes when mounting legacy file system with
  sector size > PAGE_SIZE”
- **Author explanation:** Test on 64K block-size loop device triggered
  mount probing of built-in filesystems; first half of series actually
  crashed.
- **Maintainer action:** Christian Brauner applied series to
  `vfs-7.2.misc`.
- **Stable nomination in thread:** None found.
- **NAKs/concerns:** None found in retrieved thread.

### Step 4.2: Reviewers
**Record:** CC list included Alexander Viro, Christian Brauner, Jan
Kara, David Sterba, linux-fsdevel; applied by Brauner.

### Step 4.3: Bug report
**Record:** No external bugzilla/syzbot link. Repro described in series
cover letter (64K loop device, built-in FS probe).

### Step 4.4: Related patches
**Record:** 10-patch series; siblings (qnx4, minix, isofs, etc.) have
the same unchecked pattern in this tree (e.g. `fs/qnx4/inode.c:205`
still unchecked). Each is independently backportable.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list; no stable nomination found
in patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `bfs_fill_super()`, `sb_set_blocksize()`, `sb_bread()` →
`__bread_gfp()` → `create_buffers()` → `folio_set_bh()`.

### Step 5.2: Callers
**Record:**
- `bfs_fill_super()` ← `bfs_get_tree()` ← `get_tree_bdev()` (mount
  path).
- Reachable whenever BFS mount is attempted (`mount -t bfs`) or during
  filesystem probing if BFS is registered/built-in.

### Step 5.3: Callees
**Record:** On failure, existing `out:` path runs `mutex_destroy()`,
`kfree(info)`, returns `ret` (initialized to `-EINVAL`).

### Step 5.4: Reachability
**Record:**
- **Userspace trigger:** Yes — `mount(2)` with `CAP_SYS_ADMIN` on a
  block device whose logical block size prevents setting 512-byte blocks
  (common on 4K/64K-sector media).
- Author confirmed crash during mount probing on 64K loop device with
  built-in filesystems.

### Step 5.5: Similar patterns
**Record:** Many filesystems already check `sb_set_blocksize()`; BFS was
an outlier. Same bug class fixed across the 10-patch series.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** Current tree at `fs/bfs/inode.c:345`:

```345:347:fs/bfs/inode.c
        sb_set_blocksize(s, BFS_BSIZE);

        sbh = sb_bread(s, 0);
```

`folio_set_bh()` BUG_ON is also present (`fs/buffer.c:1582`).

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — 2-line change, no context
conflicts with recent BFS churn.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git merge-base --is-ancestor e7fcf391a498b HEAD` →
fix NOT in tree. No equivalent grep hit under `fs/bfs/`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **Filesystem (BFS)** — IMPORTANT but niche (`CONFIG_BFS_FS`,
tristate, depends on `BLOCK`). Not core VFS, but mount path can panic
the kernel.

### Step 7.2: Subsystem activity
**Record:** Low activity; occasional maintenance (mount API conversion
in 2025). Mature, rarely used filesystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_BFS_FS` built-in or `bfs` module loaded
who mount (or probe) BFS on block devices with sector/logical block size
incompatible with 512-byte `sb_set_blocksize()` — especially >
`PAGE_SIZE`.

### Step 8.2: Trigger conditions
**Record:**
- **Commonality:** Uncommon (BFS is legacy/obscure; large-sector devices
  are increasingly common).
- **Privilege:** Requires mount capability (`CAP_SYS_ADMIN`); not
  unprivileged, but still a local DoS.
- **Probe path:** Author hit it during filesystem probing, not only
  explicit `mount -t bfs`.

### Step 8.3: Failure mode severity
**Record:** **Kernel BUG / panic** during mount — **CRITICAL** severity
when triggered.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents deterministic kernel crash; converts to clean
  `-EINVAL` mount failure.
- **Risk:** Minimal (2 lines, established pattern, existing cleanup
  path).
- **Ratio:** High benefit, very low risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real mount-time kernel BUG (verified code path).
- Small, surgical, obviously correct fix.
- Matches patterns already used in mainstream filesystems.
- Buggy code confirmed present in Linux 6.18.44.
- Author reproduced on 64K loop device.
- Applied by VFS maintainer (Brauner).

**AGAINST backport:**
- BFS is obscure; `CONFIG_BFS_FS` often disabled.
- Trigger needs large-sector block device + BFS mount/probe.
- Part of a 10-patch series (though this patch is independent).

**Unresolved:** No independent Tested-by; stable list not explicitly
CC'd.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — pattern is standard; author
   tested in series context; no logical flaw in fix.
2. Fixes a real bug affecting users? **PASS** — mount-time BUG on real
   hardware configuration.
3. Important issue? **PASS** — kernel crash (CRITICAL when triggered).
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features or APIs? **PASS** — error handling only.
6. Can apply to local tree? **PASS** — buggy code present; fix not yet
   applied; clean apply expected.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Pure bug
fix.

### Step 9.4: Problem summary for stable users
Without this fix, mounting BFS on a block device whose sector size
cannot be reduced to 512 bytes leaves the superblock at a large block
size. The next buffer read triggers `BUG_ON()` in `folio_set_bh()`,
crashing the kernel instead of returning a mount error. The fix makes
BFS fail mount cleanly with `-EINVAL`, consistent with ext2, ext4, and
other filesystems.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no syzbot/Fixes tags; Link tag
  present.
- [Phase 2] Read diff: 2-line `sb_set_blocksize` check + `goto out` in
  `bfs_fill_super()`.
- [Phase 2] Read `sb_set_blocksize()` — returns 0 on failure
  (`block/bdev.c:220-230`).
- [Phase 2] Read `folio_set_bh()` BUG_ON (`fs/buffer.c:1578-1582`).
- [Phase 2] Read `create_buffers()` offset logic
  (`fs/buffer.c:933-946`).
- [Phase 2] Confirmed `BFS_BSIZE = 512`
  (`include/uapi/linux/bfs_fs.h:12-13`).
- [Phase 3] `git blame` line 345 → present since 2005 import.
- [Phase 3] `folio_set_bh` BUG_ON introduced `465e5e6a1698f`, ancestor
  of HEAD.
- [Phase 3] `git merge-base --is-ancestor e7fcf391a498b HEAD` → fix NOT
  in 6.18.44.
- [Phase 3] Upstream commit `2430e3380936df0b648af720cae624eef035a2d1`
  confirmed.
- [Phase 4] `b4 dig -c 2430e3380936`: lore URL found; patch 01/10 of
  series.
- [Phase 4] `b4 dig -a`: v1 only revision.
- [Phase 4] `b4 dig -w`: Viro, Brauner, fsdevel CC'd.
- [Phase 4] Mbox cover letter: 64K loop device crash during FS probe
  confirmed.
- [Phase 5] Call chain: `bfs_get_tree` → `get_tree_bdev` →
  `bfs_fill_super` verified in `fs/bfs/inode.c`.
- [Phase 5] `setup_bdev_super()` sets initial blocksize
  (`fs/super.c:1662`).
- [Phase 6] `git describe HEAD` → v6.18.44; Makefile 6.18.44.
- [Phase 6] Buggy unchecked call confirmed at `fs/bfs/inode.c:345`.
- [Phase 6] `out:` cleanup path returns `-EINVAL` (ret initialized line
  333).
- [Phase 7] `CONFIG_BFS_FS` tristate in `fs/bfs/Kconfig`.
- [Phase 8] Failure mode: kernel BUG — CRITICAL.

**YES**

 fs/bfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 984b365df0460..35b86dce3a788 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -342,7 +342,8 @@ static int bfs_fill_super(struct super_block *s, struct fs_context *fc)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	sb_set_blocksize(s, BFS_BSIZE);
+	if (!sb_set_blocksize(s, BFS_BSIZE))
+		goto out;
 
 	sbh = sb_bread(s, 0);
 	if (!sbh)
-- 
2.53.0

