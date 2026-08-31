Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67717459AFC;
	Mon, 31 Aug 2026 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183282; cv=none; b=XSqSvuz7XLGMbz7/xIlCUMRkNh3mtja4g8KOgOA14/0tcPHQR+BNWLbnuGHrPW4iu+Q8/PFUAZEINZerKLlGUXB63jn1w6bn4jrgBWSFxfQxFDey1m0c8dRhY6eGHHnxSpfG4rU5a5hwdZfWfUFqoVSAD6vO9dNt8JfdHovMCLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183282; c=relaxed/simple;
	bh=27oT7w6t2dSYoITnOB5E4HZ0ceriHpXM6Thk4gqkeOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fix1Ms4ymvN0zz3+673Q2jpY9acSk/+MRWeSBpJ8CgeF4PnoG592Nf1sUTZPfyGFrGWf+ui7v0NEo13vX8me6ghwoaWtwRqZAITafA0af5JuodYXxaPG3M/XGmUaygQvxhm1F1Doa5qbONxxVJJPVDE/gFzcB1u+8+yxAY/dwfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esSugd6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esSugd6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E071F00A3E;
	Mon, 31 Aug 2026 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183278;
	bh=hIDmP07IiHCoCW6q2VONui3+T4zKv9c35+YdyipWHtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esSugd6TJONRShZd19t0s+N+b2xHl8Fj40HCNZWQyeOHLlq6iUJoLygRrh4nEBiBi
	 bS/DnCmc6Yn7YwVAHB10JO2N7S4fPiaT+IVfm3eFs5IJ8bfM7OUluSCMWON3ttDOsf
	 IiG8RqEtNax04/eZV86yNLm5lyzINRHGjqydhbnumxIl4k+gTDj4OvxxwQNe8K+ocT
	 W5BciP4QTlDWNFyaabfZwoKMe86aFoLAlpTGQeyoqorLWJcQxj0AZ+hOJZANrMSPMv
	 mP0F9OOdQG/wZYFp3poFxEuoVMJcQdRAxtYqHPfvR9LE2a7I9jLzO450ZTlYag+ZWK
	 x4E/5q9dHIFWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dsterba@suse.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] affs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:21:20 -0400
Message-ID: <20260831133314.4125787-52-sashal@kernel.org>
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

[ Upstream commit 0861182af5983a39bd2a891966436c5679b74a45 ]

affs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-7-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject:** `[affs]` `[handle]` — handle `set_blocksize`
failures in AFFS mount path.

**Step 1.2 — Tags:**
- Signed-off-by: Christoph Hellwig \<hch@lst.de\>
- Link: https://patch.msgid.link/20260511071701.2456211-7-hch@lst.de
- Signed-off-by: Christian Brauner \<brauner@kernel.org\>
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Mailing list: Acked-by: David Sterba \<dsterba@suse.com\> (from
  thread)

**Step 1.3 — Body:** AFFS uses buffer_heads, which cannot safely use
block sizes larger than `PAGE_SIZE`. If `sb_set_blocksize()` fails and
the code continues, the first `__bread_gfp()` call hits `BUG_ON(offset
>= folio_size(folio))` in `folio_set_bh()`. Symptom: kernel BUG/panic
during mount (including filesystem auto-probe).

**Step 1.4 — Hidden bug fix?** No — this is an explicit mount-path bug
fix, not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory:**
- `fs/affs/affs.h`: −5 lines (removes `affs_set_blocksize()` wrapper)
- `fs/affs/super.c`: +4/−2 lines
- Functions: `affs_fill_super()` only
- Scope: single-subsystem, surgical (~11 lines net)

**Step 2.2 — Code flow:**
- **Before:** `affs_set_blocksize()` called `sb_set_blocksize()` and
  ignored its return value.
- **After:** Direct `sb_set_blocksize()` calls with failure checks;
  mount returns `-EINVAL` on failure at both the initial `PAGE_SIZE`
  setup and each blocksize-probe iteration.

**Step 2.3 — Bug mechanism:** Missing error-path handling. When
`sb_set_blocksize()` returns 0 (failure — e.g. requested size >
`PAGE_SIZE` on a non-`FS_LBS` filesystem, or `set_blocksize()` failure
on an incompatible block device), mount continued and issued buffer-head
I/O that triggers `folio_set_bh()`'s `BUG_ON`.

**Step 2.4 — Fix quality:** Obviously correct; mirrors patterns already
used in this tree by ext4, ufs, udf, minix (initial call), etc. Minimal
regression risk.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame:** Buggy ignore-return-value pattern dates to Linux
2.6.12 (`1da177e4c3f41`). Present throughout AFFS history in this tree.

**Step 3.2 — Fixes: tag:** Not present (expected for manual review).

**Step 3.3 — Related commits:**
- `a64e5a596067b` (2025-03-07): re-added `PAGE_SIZE` validation to
  `sb_set_blocksize()` — **in this tree**
- `465e5e6a1698f` (2023): added `folio_set_bh()` with `BUG_ON` — **in
  this tree**
- Mainline commit: `0861182af5983` — **NOT in this tree**
- Part of 10-patch series merged as `d90e60ced4c3c` ("fix crashes when
  mounting legacy file system with sector size > PAGE_SIZE")

**Step 3.4 — Author:** Christoph Hellwig; series merged by VFS
maintainer Christian Brauner.

**Step 3.5 — Dependencies:** Standalone; patch 6/10 in series but self-
contained for AFFS. No prerequisite commits required beyond code already
in 6.18.y.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Thread:**
https://patch.msgid.link/20260511071701.2456211-7-hch@lst.de (b4 dig
confirmed). Series v1, 10 patches.

**Step 4.2 — Reviewers:** CC'd to linux-fsdevel, Alexander Viro,
Christian Brauner, filesystem maintainers. David Sterba Acked-by on affs
patch.

**Step 4.3 — Bug report:** Cover letter (`2456211-1-hch@lst.de`): author
reproduced crashes probing built-in filesystems on a 64K-sector loop
device; affs was among filesystems that actually crashed.

**Step 4.4 — Series context:** 10 filesystems fixed with same pattern;
affs patch is independent of the others.

**Step 4.5 — Stable list:** No stable-specific discussion found; not a
negative signal.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Functions:** `affs_fill_super()`, inline `affs_bread()`
(unchanged).

**Step 5.2 — Callers:** `affs_fill_super()` called from
`get_tree_bdev()` during `mount(2)` / filesystem probe.

**Step 5.3 — Callees:** `sb_set_blocksize()` → `set_blocksize()`; on
success, `affs_bread()` → `sb_bread()` → `__bread_gfp()` →
`folio_alloc_buffers()` → `folio_set_bh()`.

**Step 5.4 — Reachability:** Reachable from userspace mount and blkid-
style filesystem probing on block devices with large logical sector
sizes or on systems where `PAGE_SIZE` > AFFS's supported 4K blocks.

**Step 5.5 — Similar patterns:** 15+ filesystems in this tree already
check `sb_set_blocksize()` return value; AFFS is an outlier.

---

## Phase 6: Cross-Reference Against Local Tree

**Tree:** `v6.18.44` (6.18.y stable)

**Step 6.1 — Buggy code exists:** Yes — `fs/affs/super.c` lines 360 and
376 still call `affs_set_blocksize()` without checking return value.

**Step 6.2 — Backport difficulty:** Clean apply expected; no conflicting
changes in this file.

**Step 6.3 — Related fixes already present:** No equivalent AFFS fix.
Prerequisites (`folio_set_bh` BUG_ON, `sb_set_blocksize` PAGE_SIZE
check) are both present, making the bug reachable.

---

## Phase 7: Subsystem Context

**Step 7.1:** AFFS filesystem (`fs/affs/`). Criticality: PERIPHERAL
(Amiga/legacy FS), but mount path is security-relevant (unprivileged
mount with privileges).

**Step 7.2:** Low recent churn; mature legacy driver.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Affected users:** Users with `CONFIG_AFFS_FS` who mount or
auto-probe AFFS on block devices where `sb_set_blocksize()` fails.

**Step 8.2 — Trigger:** Mount/probe on devices with sector size >
`PAGE_SIZE`, or blocksize/LBA mismatches; more likely on large-page
architectures or during multi-FS probe on unusual block devices.

**Step 8.3 — Failure mode:** Kernel `BUG()` in `folio_set_bh()` —
**CRITICAL** severity when triggered.

**Step 8.4 — Risk/benefit:**
- Benefit: Prevents kernel panic; converts crash to clean `-EINVAL`
  mount failure
- Risk: Very low (2 error checks + wrapper removal)
- Ratio: Strongly favorable

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Real, reproduced crash (author's 64K loop-device probe testing)
- Kernel BUG/panic on mount
- Small, obviously correct fix
- Matches established patterns in this tree
- Prerequisites present in 6.18.y
- Reviewed (Acked-by David Sterba) and merged to mainline
- Bug present since 2.6 in code that exists in this tree

**Evidence AGAINST:**
- AFFS is rarely used (niche legacy FS)
- Trigger conditions are uncommon on typical 4K-page desktops
- Not a security CVE, but mount-triggered BUG is still serious

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — author tested; reviewer
   acked
2. Fixes real bug affecting users? **PASS** — confirmed crash on mount
   probe
3. Important issue? **PASS** — kernel BUG/panic (CRITICAL)
4. Small and contained? **PASS** — ~11 lines, 2 files
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply expected

**Exception category:** None (standard bug fix).

---

## Verification

- [Phase 1] Parsed commit message and tags from provided diff and `git
  show 0861182af5983`
- [Phase 2] Diff analysis: 2 files, `affs_fill_super()` only; adds
  `sb_set_blocksize()` failure checks
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame` lines 360–376: bug since `1da177e4c3f41`
  (2.6.12)
- [Phase 3] `git merge-base --is-ancestor 0861182af5983 HEAD`: NOT in
  tree
- [Phase 3] `git merge-base --is-ancestor a64e5a596067b HEAD`: PAGE_SIZE
  check present
- [Phase 3] `git merge-base --is-ancestor 465e5e6a1698f HEAD`:
  `folio_set_bh` BUG_ON present
- [Phase 3] Read `block/bdev.c:220-230`: `sb_set_blocksize()` returns 0
  on failure
- [Phase 3] Read `fs/buffer.c:1578-1582`: `folio_set_bh()` BUG_ON
  confirmed
- [Phase 4] `b4 dig -c 0861182af5983`: thread at
  patch.msgid.link/20260511071701.2456211-7-hch@lst.de
- [Phase 4] `b4 dig -a`: v1 series, patch 6/10
- [Phase 4] `b4 dig -w`: Viro, Brauner, fsdevel CC'd
- [Phase 4] Mbox: cover letter confirms 64K loop-device crash during FS
  probe; David Sterba Acked-by
- [Phase 5] `affs_fill_super` called from `get_tree_bdev()` at
  `fs/affs/super.c:583`
- [Phase 5] `sb_bread` → `__bread_gfp` uses `sb->s_blocksize` per
  `include/linux/buffer_head.h:344-346`
- [Phase 6] Buggy `affs_set_blocksize()` wrapper confirmed at
  `fs/affs/affs.h:228-232`
- [Phase 6] AFFS lacks `FS_LBS` flag (`fs/affs/super.c:651`)
- [Phase 8] Failure mode: BUG_ON in `folio_set_bh` — CRITICAL

This fix prevents a kernel BUG during AFFS mount when
`sb_set_blocksize()` fails — a scenario the author reproduced during
filesystem probing on a 64K-sector block device. The change is minimal,
matches patterns already used by other filesystems in 6.18.y, and all
prerequisites are present in this tree.

**YES**The background search finished while the AFFS backport analysis
was already done. It didn’t turn up the `affs: handle set_blocksize
failures` commit in this tree (expected — it’s only on mainline as
`0861182af5983`), and the mbox search didn’t find a local copy of the
patch thread.

**Verdict from the analysis: YES** — the fix should be backported to
this 6.18.y tree. It’s a small, low-risk change that prevents a kernel
BUG during AFFS mount when `sb_set_blocksize()` fails, and the buggy
code is still present here.

 fs/affs/affs.h  | 5 -----
 fs/affs/super.c | 6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index ac4e9a02910b7..99e54e3453ac1 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -225,11 +225,6 @@ static inline bool affs_validblock(struct super_block *sb, int block)
 	       block < AFFS_SB(sb)->s_partition_size);
 }
 
-static inline void
-affs_set_blocksize(struct super_block *sb, int size)
-{
-	sb_set_blocksize(sb, size);
-}
 static inline struct buffer_head *
 affs_bread(struct super_block *sb, int block)
 {
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 44f8aa883100e..994f1199beaf1 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -357,7 +357,8 @@ static int affs_fill_super(struct super_block *sb, struct fs_context *fc)
 	size = bdev_nr_sectors(sb->s_bdev);
 	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
-	affs_set_blocksize(sb, PAGE_SIZE);
+	if (!sb_set_blocksize(sb, PAGE_SIZE))
+		return -EINVAL;
 	/* Try to find root block. Its location depends on the block size. */
 
 	i = bdev_logical_block_size(sb->s_bdev);
@@ -373,7 +374,8 @@ static int affs_fill_super(struct super_block *sb, struct fs_context *fc)
 		if (ctx->root_block < 0)
 			sbi->s_root_block = (ctx->reserved + size - 1) / 2;
 		pr_debug("setting blocksize to %d\n", blocksize);
-		affs_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize))
+			return -EINVAL;
 		sbi->s_partition_size = size;
 
 		/* The root block location that was calculated above is not
-- 
2.53.0

