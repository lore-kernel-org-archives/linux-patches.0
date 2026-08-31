Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E742850AC27;
	Mon, 31 Aug 2026 13:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183763; cv=none; b=Uiw0yO+DveHKWGXD8WY8iRy7HHQp4AuptNTLpKrO1JL3MYkzp950azFfiGcCtfbaudXra54JXDoZJfRtRQYjchrICeAN0k2tGwd93E7qBBk7JXaxrjHo+AIqDDHISCZ9VkjzNQPXcP3MqubPcTy/zprpxA88HcYQm/r3vj1Qau0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183763; c=relaxed/simple;
	bh=vzeNr51d31NGUYRp+WNAmgyOiDvaDwMpl+YzU6OB0zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VBQYAOGDoZ2EetPkIgY4UmP29fBDNFpjNVzoEV3TL/ntd+G40JYT3ShfhweNoPbb79mZI0yXffgMybnulqQQ7EfpdKYbHz+x1iFMCFk20KOXN+yysyjvHxsHT8pYXzfROCUFWYwExjlakmBGmWVIQJqMqCwKYxmDXlP5HdBFEy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQAdzTjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQAdzTjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AD41F00A3E;
	Mon, 31 Aug 2026 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183760;
	bh=0OIU93BJMp8r0dcMIgJaZttBr6h0amJH1O2NySn/5CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQAdzTjMLvMo70e1IrwTTJE/oiijklF/5x5BTnAU08g9m36zsxJol3VJRXKSMtxfY
	 4qRI9ujQC5JkNlbTGTg8h5VXDYyklZTYhLBW65V1JYrJY905KdvAMZoECHMcFcrSlZ
	 39LxCb6FKjC0umfm8ZkcB6sQ1g6iP2tZdO+uzhrj49mbaWLw8HfIa3Y6KVwrsHTAkc
	 55wUJ7wJsS1VxrqknhllDzgeGRqBOp0MYMojwIbLuIUrvTCDOIJk79HjpvmALMrem/
	 yuxQO04mefs1bxpQSZu0wwdlrgpj5t9AjaIyX5YZd+Xxwkj+x6aHOTnI51AWhnEMFZ
	 NZPBwMltNCJ6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] jfs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:25:16 -0400
Message-ID: <20260831133314.4125787-288-sashal@kernel.org>
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

[ Upstream commit 05107f5602751fcfd3d108c1f579eb45aabead52 ]

jfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-5-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[jfs]` `[handle]` — Handle `sb_set_blocksize()` failures during
JFS mount.

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** Christoph Hellwig `<hch@lst.de>` (author)
- **Signed-off-by:** Christian Brauner (Amutable) `<brauner@kernel.org>`
  (merger)
- **Link:** https://patch.msgid.link/20260511071701.2456211-5-hch@lst.de
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable
- Part of series **"[PATCH 04/10] jfs: handle set_blocksize failures"**
  in *"fix crashes when mounting legacy file system with sector size >
  PAGE_SIZE"*

**Step 1.3 — Body analysis**

Record:
- **Bug:** JFS ignores `sb_set_blocksize(sb, PSIZE)` failure and
  continues mounting.
- **Symptom:** Kernel `BUG_ON(offset >= folio_size(folio))` in
  `folio_set_bh()` on the first `__bread_gfp()` call during mount.
- **Root cause:** JFS uses buffer_heads, which do not handle block sizes
  > `PAGE_SIZE`. When `sb_set_blocksize()` fails (e.g. device logical
  block size is 64K and JFS tries to set 4K), `sb->s_blocksize` stays at
  the device size from `setup_bdev_super()`. Mount proceeds and buffer
  allocation crashes.
- **Trigger context (cover letter):** Mount/probe on a 64K-sector loop
  device with JFS built-in.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite the neutral "handle" wording, this is a real
crash fix, not cleanup. Same pattern as ext4, UFS, minix, etc.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `fs/jfs/super.c` (+2 / −1)
- **Function:** `jfs_fill_super()`
- **Scope:** Single-file, surgical (3-line hunk)

**Step 2.2 — Code flow change**

Record:
- **Before:** `sb_set_blocksize(sb, PSIZE);` — return value ignored;
  mount continues on failure.
- **After:** `if (!sb_set_blocksize(sb, PSIZE)) goto out_unload;` —
  failed blocksize setup aborts mount via existing cleanup path.
- **Path affected:** Mount initialization, before `jfs_mount()` →
  `readSuper()` → `sb_bread()`.

**Step 2.3 — Bug mechanism**

Record: **Logic / error-path fix.** Category: missing error handling
leading to **kernel BUG**.
- `sb_set_blocksize()` returns 0 on failure (`block/bdev.c:220-229`).
- On failure, `sb->s_blocksize` is not updated to `PSIZE` (4096).
- `sb_bread()` uses `sb->s_blocksize`
  (`include/linux/buffer_head.h:346`).
- Buffer allocation reaches `folio_set_bh()` with invalid offset vs
  folio size → `BUG_ON` (`fs/buffer.c:1582`).

**Step 2.4 — Fix quality**

Record: **Obviously correct.** Matches ext4/ufs/minix pattern. Minimal
risk; `out_unload` already exists and returns `ret = -EINVAL`. No new
locks or APIs.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Unchecked `sb_set_blocksize(sb, PSIZE)` dates to initial JFS
import (`1da177e4c3f4`, 2005). Bug has been present for the lifetime of
JFS in-tree.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**

Record: Recent `fs/jfs/super.c` changes are mount-API and cleanup only;
none address this. Mainline merge `d90e60ced4c3c` ("fix crashes when
mounting legacy file system with sector size > PAGE_SIZE") contains this
fix but is **not** an ancestor of this tree's HEAD.

**Step 3.4 — Author context**

Record: Christoph Hellwig — senior VFS/filesystem developer. Series
merged by VFS maintainer Christian Brauner. Jan Kara reviewed sibling
patches in the series.

**Step 3.5 — Dependencies**

Record: **Standalone.** Patch 4/10 is independent per filesystem. No
prerequisite commits required for the JFS hunk. Applies cleanly to
current `fs/jfs/super.c` at line 494.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: Series cover at https://ratatoskr.run/linux-
fsdevel/2026/05/8994157. JFS patch at https://ratatoskr.run/linux-
fsdevel/2026/05/8994161 / spinics msg338004. `b4 dig -c` could not be
used (commit not in this tree). lore.kernel.org blocked by bot
protection.

**Step 4.2 — Reviewers**

Record: Christian Brauner merged the series. Jan Kara reviewed
minix/isofs/bfs patches. David Sterba reviewed affs. No NAKs found.

**Step 4.3 — Bug report**

Record: Author-reproduced crash during FS probe on 64K loop device. No
syzbot report. Real, reproducible trigger described in cover letter.

**Step 4.4 — Series context**

Record: 10-patch series, one filesystem each. JFS patch is self-
contained; other patches not required for this fix.

**Step 4.5 — Stable list**

Record: No stable-list discussion found. Not a negative signal per
instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `jfs_fill_super()`, `sb_set_blocksize()`, `jfs_mount()` →
`readSuper()` → `sb_bread()` → `__bread_gfp()` → `bdev_getblk()` →
`grow_buffers()` → `folio_alloc_buffers()` → `folio_set_bh()`.

**Step 5.2 — Callers**

Record: `jfs_fill_super()` called from `get_tree_bdev()`
(`fs/jfs/super.c:635`) during `mount(2)` or filesystem probe. Reachable
from userspace.

**Step 5.3 — Callees**

Record: `sb_set_blocksize()` → `set_blocksize()` →
`bdev_validate_blocksize()`. Fails when requested size < device logical
block size.

**Step 5.4 — Call chain / reachability**

Record: `mount`/`fsopen` → `jfs_get_tree` → `get_tree_bdev` →
`setup_bdev_super` (sets device blocksize) → `jfs_fill_super` →
`jfs_mount` → `sb_bread`. **Userspace-reachable** when `CONFIG_JFS_FS`
is enabled (built-in or module).

**Step 5.5 — Similar patterns**

Record: ext4 (`fs/ext4/super.c:5128`), ufs (`fs/ufs/super.c:927`),
minix, romfs, ocfs2, f2fs all check `sb_set_blocksize()` return value.
JFS was an outlier.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Current tree at `fs/jfs/super.c:494` has unchecked
`sb_set_blocksize(sb, PSIZE);`. `folio_set_bh()` BUG_ON present since
`465e5e6a1698f` (in this tree). `sb_set_blocksize()` failure semantics
unchanged in `block/bdev.c:220-229`.

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** Only the 3-line hunk at line 494; no
conflicts with recent stable changes in this file.

**Step 6.3 — Related fixes already present?**

Record: **No.** `git merge-base --is-ancestor d90e60ced4c3c HEAD` → not
ancestor. Sibling fixes in hpfs/bfs also absent. Fix not yet in 6.18.y.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **fs/jfs** — legacy filesystem driver. Criticality:
**IMPORTANT** (not core VFS, but mount path can kernel-BUG the system).

**Step 7.2 — Activity**

Record: Low churn; mature driver. Bug is long-standing, exposed when
large-sector devices are probed.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users with `CONFIG_JFS_FS` enabled (built-in or module) mounting
or probing JFS on block devices whose logical sector size prevents
setting 4K (e.g. 64K sectors).

**Step 8.2 — Trigger conditions**

Record: Mount or auto-probe of JFS on device with sector size >
`PAGE_SIZE` or where `sb_set_blocksize(4096)` fails. Unprivileged users
can trigger via `mount` if permitted, or during blkid/probe workflows.
Not extremely common hardware, but loop devices and some storage make it
realistic.

**Step 8.3 — Failure mode severity**

Record: **Kernel BUG()** — system crash/oops. Severity: **CRITICAL**.

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH — prevents kernel crash; graceful mount failure with
  `-EINVAL`.
- **Risk:** VERY LOW — 2 lines, established pattern, existing cleanup
  path.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Real, author-verified kernel BUG on mount/probe
- Long-standing bug in widely shipped legacy FS
- Surgical 2-line fix, obviously correct
- Matches pattern already used by ext4, ufs, etc. in this tree
- Merged to mainline by VFS maintainer
- Buggy code confirmed present in v6.18.44
- Clean apply, no dependencies

**Evidence AGAINST:**
- JFS is a legacy/rare filesystem → lower population
- Trigger requires specific block-device geometry
- None of these outweigh a kernel BUG fix

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (mainline merged; author
   tested crash scenario)
2. Fixes real user-affecting bug? **PASS**
3. Important issue? **PASS** (kernel BUG / crash)
4. Small and contained? **PASS** (3 lines, 1 file)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS**

**Exception category:** N/A (standard bug fix, not device-
ID/quirk/build/doc).

---

## Problem Summary for Stable Users

When JFS mount calls `sb_set_blocksize(sb, 4096)` on a device whose
logical sector size is larger (e.g. 64K loop device), the call fails
silently. Mount continues with the device's block size. The first
`sb_bread()` during `jfs_mount()` hits `BUG_ON(offset >=
folio_size(folio))` in `folio_set_bh()`, crashing the kernel. The fix
checks the return value and aborts mount through the existing
`out_unload` path, returning `-EINVAL` instead of crashing.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; identified series context
  via ratatoskr/spinics
- **[Phase 2]** Diff: 3-line error-check in `jfs_fill_super()`;
  classified as missing error handling → BUG
- **[Phase 3]** `git blame`: unchecked call since 2005 (`1da177e4c3f4`)
- **[Phase 3]** `git merge-base --is-ancestor d90e60ced4c3c HEAD` → not
  ancestor (fix absent from 6.18.y)
- **[Phase 3]** `git show d90e60ced4c3c:fs/jfs/super.c` → confirms
  mainline has the fix
- **[Phase 3]** `git diff d90e60ced4c3c -- fs/jfs/super.c` → only
  relevant hunk is the sb_set_blocksize check
- **[Phase 4]** Series cover and patch content from ratatoskr.run;
  Christian Brauner merge confirmed
- **[Phase 4]** lore.kernel.org / patch.msgid.link blocked; b4 dig
  unusable without commit in tree
- **[Phase 5]** Traced call chain: `jfs_fill_super` → `jfs_mount` →
  `readSuper` → `sb_bread` → `__bread_gfp`
- **[Phase 5]** Read `sb_set_blocksize()` at `block/bdev.c:220-229`
  (returns 0 on failure)
- **[Phase 5]** Read `folio_set_bh()` BUG_ON at `fs/buffer.c:1582`
- **[Phase 5]** Read `sb_bread` macro at
  `include/linux/buffer_head.h:344-346`
- **[Phase 5]** Compared ext4 pattern at `fs/ext4/super.c:5128`
- **[Phase 6]** `git describe HEAD` → v6.18.44; buggy code at
  `fs/jfs/super.c:494`
- **[Phase 6]** `folio_set_bh` ancestor check: `465e5e6a1698f` is in
  tree
- **[Phase 6]** hpfs/bfs sibling fixes also absent (confirming series
  not backported)
- **[Phase 8]** Failure mode: kernel BUG; severity CRITICAL

**YES**The background checks confirmed what the analysis relied on:

- **Grep for related commits** in this tree’s history returned nothing —
  the “handle set_blocksize failures” fix isn’t already in 6.18.y.
- **Merge commit `d90e60c`** (the mainline series that includes this JFS
  patch) exists in the repo but is **not an ancestor of HEAD**
  (v6.18.44). Mainline has the fix; this stable tree still has the
  unchecked `sb_set_blocksize(sb, PSIZE)` at `fs/jfs/super.c:494`.

That supports the **YES** backport recommendation: the bug is present
here, the fix is small and self-contained, and it should apply cleanly.

 fs/jfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 3cfb86c5a36e8..20b66fb022244 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -491,7 +491,8 @@ static int jfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	/*
 	 * Initialize blocksize to 4K.
 	 */
-	sb_set_blocksize(sb, PSIZE);
+	if (!sb_set_blocksize(sb, PSIZE))
+		goto out_unload;
 
 	/*
 	 * Set method vectors.
-- 
2.53.0

