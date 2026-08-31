Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3B64611CF;
	Mon, 31 Aug 2026 13:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183287; cv=none; b=N53WFixdC2fuPEI/viNQAyRQvV9BksoOTob1+YASe9/SkldIYgNyiPtaH9h5QIYTGD3E5FmxCSoEuoKEIsWiWJLB30B9bkzGThuXoTKFaw1doE56kIgJy4Gmz1XvzaYyzLo4Ct/70nZe4fdDYXxn/OmaSyplAjyZy4gwiQQCJMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183287; c=relaxed/simple;
	bh=eFvisUckkNSmvFFq1pdTJLcfIoD8pK81JeS80VTcSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELyLcyd4tCyYl+b3deXTPSeeajrpkTd2JN6LZdYWhHpe2K1yq3tXlIx+xOH+FbMvzlpIy94hPaiIAoO+Eo7YMA9AQQ09p/Ev2jZTeMtaPMotymkXFGY/r2pZF9N8D+7TOcPqisBOzJjaFSGnnMsp9kUPZ2h1rr6ccJaJEU1yUPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pd00OX5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pd00OX5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA291F00ACA;
	Mon, 31 Aug 2026 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183284;
	bh=Xh5u8FuzUDj4ag9ogwHjp3d6RgJocWRprHO9U/lme/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pd00OX5qbs+K3jN/XZ8KfGqqDTSR9yile4RZN65oK0RCmvVhen2cJEETgfG4qOrXK
	 LuZNuAYBF0pQiMWz69FNy0ihA+KKX1CSs52kepPApo3JeBpts3WV6nOFpNAq8dbZJ7
	 cRCXcvluPUsMtu0NM1cyEccAWi5wFucvIP/st9ni/pyOcKsA9meaMnYzQeNGaqrmTJ
	 RpJKiEKNvVM/WzFHkZjgcm0mV5gt0q7A+qPYjBPuoTQyDBEwucilSK4D/azfcI9vYv
	 5kPgbJcgqwetGMLP+QltAMzqmbo+qxPpgvSPIZ58TrGsHYWNrEEasau97PBfQehHhU
	 +eJe97WDBSdHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] minix: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:21:24 -0400
Message-ID: <20260831133314.4125787-56-sashal@kernel.org>
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

[ Upstream commit 38a03dc2bc71e7e0746cdb9ef5e9947f72470c67 ]

minix uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-9-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[minix] [handle] [check and propagate sb_set_blocksize()
failure for MINIX V3 mount path]`

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Christoph Hellwig `<hch@lst.de>` (author)
- **Signed-off-by:** Christian Brauner (Amutable) `<brauner@kernel.org>`
  (maintainer merge)
- **Link:**
  `https://patch.msgid.link/20260511071701.2456211-9-hch@lst.de` (patch
  9 of an 11-patch series)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: Part of series titled "fix crashes when mounting legacy file
  system with sector size > PAGE_SIZE"

### Step 1.3: Body Analysis
**Record:**
- **Bug:** MINIX V3 calls `sb_set_blocksize(s, m3s->s_blocksize)`
  without checking the return value. When block size exceeds
  `PAGE_SIZE`, `sb_set_blocksize()` fails (returns 0) but mount
  continues.
- **Symptom:** Kernel hits `BUG_ON(offset >= folio_size(folio))` in
  `folio_set_bh()` on the first `__bread_gfp` call during mount.
- **Root cause:** buffer_heads do not handle block size > `PAGE_SIZE`;
  ignoring `sb_set_blocksize()` failure leaves the superblock in an
  inconsistent state and mount proceeds into code that cannot work.
- **Version info:** None explicit; MINIX V3 `s_blocksize` field has
  existed since 2007.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit bug fix for a mount-time
kernel crash, though the verb "handle" rather than "fix" is used.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/minix/inode.c` (+2 lines, -1 line)
- **Function:** `minix_fill_super()`
- **Scope:** Single-file, surgical fix (3-line hunk)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `sb_set_blocksize(s, m3s->s_blocksize);` — return value
  ignored; mount continues to `minix_check_superblock()` and
  `sb_bread()` calls.
- **After:** `if (!sb_set_blocksize(s, m3s->s_blocksize)) goto out;` —
  mount aborts with `-EINVAL` on failure.
- **Path affected:** MINIX V3 superblock detection branch only
  (error/validation path during mount).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness fix preventing kernel panic (missing
  error-path handling).
- **Mechanism:** `sb_set_blocksize()` in `block/bdev.c` returns 0 when
  `size > PAGE_SIZE` for non-`FS_LBS` filesystems (minix has
  `FS_REQUIRES_DEV` only). Mount continued with stale `s_blocksize`
  (1024 from line 221), then `sb_bread()` → `bdev_getblk()` →
  `folio_alloc_buffers()` → `folio_set_bh()` triggered `BUG_ON` when
  buffer size exceeded folio size.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — mirrors the existing pattern at line
  221 (`if (!sb_set_blocksize(s, BLOCK_SIZE)) goto out_bad_hblock;`).
- **Regression risk:** Very low. Only affects failed-mount path for
  invalid/unsupported block sizes.
- **Minor note:** `goto out` skips `brelse(bh)` (one buffer_head leak on
  failed mount); pre-existing style in this function for early errors
  after `bh` is read. Not a stability concern.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Unchecked `sb_set_blocksize(s, m3s->s_blocksize)` introduced in commit
  `939b00df0306` (Andries Brouwer, 2007-02-12) — MINIX V3 support.
- `PAGE_SIZE` validation in `sb_set_blocksize()` re-added in
  `a64e5a596067b` (Luis Chamberlain, 2025-03-06), present in this tree.

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag present. N/A.

### Step 3.3: File History
**Record:**
- Recent minix changes: superblock sanity checking (`31fefc18096cd`),
  inode mode verification (`73861970938ad`).
- This fix is standalone within the 11-patch series; each filesystem
  patch is independent.
- Fix is **not** yet merged in this tree (grep confirms unchecked call
  still at line 275).

### Step 3.4: Author Context
**Record:** Christoph Hellwig is a prolific VFS/block-layer contributor.
Recent minix work from others (Biggers, Viro). Hellwig authored the
broader series fixing the same pattern across legacy filesystems.

### Step 3.5: Dependencies
**Record:** No dependencies. Self-contained 2-line change. Does not
require other patches in the series.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- Fetched cover letter from `https://lore.kernel.org/linux-
  fsdevel/20260511071701.2456211-1-hch@lst.de/t.mbox.gz`
- **Series:** "fix crashes when mounting legacy file system with sector
  size > PAGE_SIZE" (11 patches)
- **Author's scenario:** Test case on 64k block-size loop device
  triggered filesystem probing of built-in filesystems, causing actual
  crashes in roughly half the affected filesystems.
- **b4 dig -c:** Failed — commit not yet in local tree (not merged).
- No explicit stable nomination found in cover letter.

### Step 4.2: Reviewers
**Record:** CC'd to Alexander Viro, Christian Brauner, Jan Kara, David
Sterba, and multiple filesystem maintainers on linux-fsdevel. Brauner
merged (Signed-off-by in commit message).

### Step 4.3: Bug Report
**Record:** No external bug report. Author discovered via own testing
(64k block device + filesystem probe). Reproducible, concrete trigger.

### Step 4.4: Related Patches
**Record:** Same pattern fixed in affs, befs, bfs, hpfs, isofs, jfs,
ntfs3, omfs, qnx4 (series diffstat). Each is independently backportable.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found (series is May 2026,
recent).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `minix_fill_super()`, `sb_set_blocksize()`, `sb_bread()`,
`folio_alloc_buffers()`, `folio_set_bh()`

### Step 5.2: Callers
**Record:**
- `minix_fill_super()` ← `minix_get_tree()` ← `get_tree_bdev()` ← mount
  syscall path
- Triggered during `mount -t minix` or automatic filesystem probing on
  block devices

### Step 5.3: Callees
**Record:** On V3 path after superblock read: `sb_set_blocksize()` → (on
failure, should abort) → `minix_check_superblock()` → `sb_bread()` for
bitmap blocks

### Step 5.4: Reachability
**Record:**
- Reachable from mount syscall (requires `CAP_SYS_ADMIN` typically)
- Also reachable via built-in filesystem probing when kernel tries to
  identify filesystem on a block device (author's actual trigger)
- MINIX V3 with `s_blocksize > PAGE_SIZE` (e.g., 8K/16K/32K/64K on
  4K-page systems) triggers the bug

### Step 5.5: Similar Patterns
**Record:** Same unchecked-call pattern exists in other legacy FS (hpfs,
isofs, jfs, qnx4, omfs) — fixed in the same series. Within minix, line
221 already checks `sb_set_blocksize()` for initial `BLOCK_SIZE`; only
the V3 re-set at line 275 is missing the check.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is `v6.18.44` (Makefile: 6.18.44).
Unchecked call at line 275:

```275:275:fs/minix/inode.c
                sb_set_blocksize(s, m3s->s_blocksize);
```

MINIX V3 support and `struct minix3_super_block.s_blocksize` are
present. `sb_set_blocksize()` PAGE_SIZE check (`a64e5a596067b`) is an
ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 2-line change in a stable code region
unchanged since 2007. No conflicts anticipated.

### Step 6.3: Related Fixes Already Present?
**Record:** No. `git log --grep='handle set_blocksize'` and
`--grep='sector size > PAGE_SIZE'` return empty. Fix not yet in tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `fs/minix` — filesystem driver. **IMPORTANT** (not core VFS,
but mount path can panic kernel). Legacy/niche but built-in on many
configs.

### Step 7.2: Activity Level
**Record:** Moderately active — recent superblock validation and
timestamp accessor updates, but core mount path is mature.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users mounting or auto-probing MINIX V3 filesystems with
`s_blocksize > PAGE_SIZE`, or with any block size rejected by
`sb_set_blocksize()`. Config-dependent (`CONFIG_MINIX_FS`).

### Step 8.2: Trigger Conditions
**Record:**
- MINIX V3 image with blocksize > `PAGE_SIZE` (author used 64k on
  4k-page system)
- Filesystem probe on unsuitable block device (author's actual scenario)
- Malicious/corrupt superblock with oversized blocksize
- **Likelihood:** Low for typical users, but concrete and reproducible
- **Unprivileged trigger:** Unlikely directly; probing requires block
  device access

### Step 8.3: Failure Mode Severity
**Record:** `BUG_ON()` in `folio_set_bh()` → **kernel panic**.
**Severity: CRITICAL** (system crash during mount/probe).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents kernel panic on mount/probe failure path;
  converts crash to clean `-EINVAL` mount failure
- **Risk:** Very low — 2 lines, matches existing in-file pattern, only
  affects error path
- **Ratio:** High benefit, minimal risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible kernel panic (`BUG_ON`) on mount
- Small, obviously correct fix matching existing code pattern
- Author verified crashes across multiple legacy filesystems
- Filesystem probing can trigger without explicit minix mount
- `sb_set_blocksize()` PAGE_SIZE validation is already in 6.18.y, making
  the silent-failure path live today

**AGAINST backport:**
- MINIX is niche/rarely used
- Requires specific blocksize condition
- Minor buffer_head leak on new error path (`goto out` vs `goto
  out_release`) — negligible

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors line 221; author
   tested via 64k block device scenario
2. Fixes a real bug affecting users? **PASS** — mount-time kernel panic
3. Important issue? **PASS** — CRITICAL (BUG_ON/panic)
4. Small and contained? **PASS** — 2 lines, one file
5. No new features or APIs? **PASS** — error handling only
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not a device-ID/quirk/build/doc
exception.

### Step 9.4: Problem Summary

This commit fixes a mount-time kernel panic in the MINIX V3 code path.
When a V3 superblock specifies a block size that `sb_set_blocksize()`
rejects (notably > `PAGE_SIZE` on systems where minix lacks `FS_LBS`),
the failure was silently ignored. Mount continued and the first
`sb_bread()` call hit `BUG_ON(offset >= folio_size(folio))` in
`folio_set_bh()`. The fix adds the same return-value check already used
for the initial `BLOCK_SIZE` setup at the top of `minix_fill_super()`,
causing mount to fail cleanly instead of panicking.

For v6.18.44, the buggy code is present, the prerequisite
`sb_set_blocksize()` PAGE_SIZE validation exists, and the fix applies
cleanly as a standalone 2-line change.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Identified patch 9/11 from Link message-ID
- [Phase 2] Diff: 2 lines added in `minix_fill_super()` V3 branch
- [Phase 2] Read `sb_set_blocksize()` at `block/bdev.c:220-230` —
  returns 0 when `size > PAGE_SIZE` for non-FS_LBS
- [Phase 2] Read `folio_set_bh()` at `fs/buffer.c:1578-1582` — confirmed
  `BUG_ON(offset >= folio_size(folio))`
- [Phase 2] Traced `sb_bread` → `bdev_getblk` → `folio_alloc_buffers` →
  `folio_set_bh` at `fs/buffer.c:1075,946`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame -L 270,280 fs/minix/inode.c`: unchecked call from
  2007 (939b00df0306)
- [Phase 3] `git merge-base --is-ancestor a64e5a596067b HEAD`: PAGE_SIZE
  check is in tree
- [Phase 3] `git log --grep='handle set_blocksize'`: empty — fix not
  merged
- [Phase 3] `git log --oneline -20 -- fs/minix/inode.c`: recent
  activity, no duplicate fix
- [Phase 4] Fetched cover letter mbox from lore.kernel.org — confirmed
  crash scenario and 11-patch series
- [Phase 4] b4 dig -c: N/A — commit not in tree
- [Phase 4] No stable nomination found in cover letter
- [Phase 5] `minix_fill_super` called from `minix_get_tree` →
  `get_tree_bdev` (mount path)
- [Phase 5] minix `fs_flags = FS_REQUIRES_DEV` — no FS_LBS
- [Phase 6] `grep sb_set_blocksize fs/minix/inode.c`: line 275
  unchecked, line 221 checked
- [Phase 6] `struct minix3_super_block.s_blocksize` in
  `include/uapi/linux/minix_fs.h:94`
- [Phase 6] Read `minix_check_superblock()` — does not validate
  blocksize against PAGE_SIZE
- [Phase 8] Failure mode: BUG_ON → kernel panic, severity CRITICAL

**YES**The background checks finished and match what the analysis
already used:

- **Hellwig/minix history:** Recent related work in this tree is mostly
  older minix cleanups (error handling in `minix_set_link` /
  `minix_delete_entry`, DIRSYNC behavior), not this `sb_set_blocksize`
  fix.
- **Merge check:** `git log --grep='handle set_blocksize'` and
  `--grep='sector size > PAGE_SIZE'` both came back empty, so the fix is
  still not in v6.18.44.

That leaves the earlier conclusion unchanged: this is a small mount-time
panic fix worth backporting to this tree.

**YES**

 fs/minix/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 7bdd240ea1584..5bfe42599a585 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -272,7 +272,8 @@ static int minix_fill_super(struct super_block *s, struct fs_context *fc)
 		sbi->s_namelen = 60;
 		sbi->s_version = MINIX_V3;
 		sbi->s_mount_state = MINIX_VALID_FS;
-		sb_set_blocksize(s, m3s->s_blocksize);
+		if (!sb_set_blocksize(s, m3s->s_blocksize))
+			goto out;
 		s->s_max_links = MINIX2_LINK_MAX;
 	} else
 		goto out_no_fs;
-- 
2.53.0

