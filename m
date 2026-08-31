Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396274B04AB;
	Mon, 31 Aug 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183535; cv=none; b=VMVVh7f6H5AjbCNtQxcgf1DVqUlTt+8O9u/YNEdeJ9j1oYWWLb21slFY6W/Q3ejLXYkDImb1hAo0JWgl0OLQoCk8aJY9+XT0cCbYV7k3iGjS1+3x+XyVaipMhhkWrmo6/rbejMz4TigS0y824W1nAJrEpugpf/0duf5suLfCmO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183535; c=relaxed/simple;
	bh=Tr2Yy92nlA2wxr8k/UFxRwIeWqOP4ep+qzjYn09kY3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oi57fVETFCIzacpvXl9euulzAcl9rC5QGBCuB+SYXkJkP1oXQEEuDlOOXStwEBwr6KrtW942PbQk//K99pDqdRSHkqjGwXYuGtUzUG5ywhJu1QTEljxtlo+55PsvdNQegoT9JP/26KKEvHmJI2MHPoxqy3j5whZciAVhCKtVgRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQLoiGtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQLoiGtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AD11F000E9;
	Mon, 31 Aug 2026 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183532;
	bh=d8po/ARa+kkOznZKLCjAeRDuQfdhOqMTAxgwyaRGCCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQLoiGtHhbJKsbJdD69hvqwV1NVhcjyG8VcWDLO79ycGh/HsAHEnzxoiqBQTFoXez
	 8msCELigvVQYjk6v3HDRfgUSR/IUUMXnPXuG8osjHoBPIdxW764WrzAvGCRtLgpnAz
	 UqogO7GXqQlr6A1O+3oDzyT9EreZG4pZqqfaSZJdIlU42UWGWeK8x3l10P7/qYu9QN
	 yQ4YznaGbqPqQZJkDDNUqe9fEjXfsLyY1xSIzJenD3vo7K7r5UVUMMj989kodSHwwo
	 xOY5D+pRQqDGxoEUAHQRCQiVcoiNOkai8OQsJxN9U/bhYd7GPFtMZVV//slyRslzau
	 gNfghzIonv8Zg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] gfs2: page poisoning fix
Date: Mon, 31 Aug 2026 09:23:01 -0400
Message-ID: <20260831133314.4125787-153-sashal@kernel.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 4982e58669b11c43644efb5fb7435975848b716e ]

Processes can write to the last page of a file using mmap, and when the file
size is not a multiple of the page size, this can be used to write beyond the
end of the file.  This is sometimes referred to as page poisoning, and it is
not a problem in itself because the data beyond eof will be ignored.  However,
we currently fail to clear out any space beyond the end of the file that we
skip over when the file size is increased, so that "poison" can end up getting
exposed.  Fix that.

Fixes xfstest generic/363.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[gfs2] [fix] page poisoning fix — clear stale bytes beyond EOF
when growing a file after mmap “page poisoning”`

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>` (author)
- No `Fixes:` tag
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, `Link:`,
  or `Cc: stable@vger.kernel.org`
- Commit message references `Fixes xfstest generic/363`

**Step 1.3 — Body analysis**

Record:
- **Bug:** mmap can write into the tail of the last page beyond current
  `i_size` (“page poisoning”). That is normally harmless, but when the
  file is later grown (write/fallocate/truncate), bytes between the old
  EOF and the new size in that page are not zeroed, so poisoned data
  becomes visible.
- **Symptom:** Readers see stale/non-zero data in the hole between old
  EOF and new EOF; xfstests `generic/363` fails.
- **Root cause:** GFS2 grow/write paths skip zeroing the post-EOF
  portion of the partial tail page before extending size.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Despite the terse subject, this is a real correctness/data-
integrity fix, not cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- `fs/gfs2/bmap.c`: +19 lines (`gfs2_clear_beyond_eof()`, call in
  `do_grow()`)
- `fs/gfs2/bmap.h`: +1 line (declaration)
- `fs/gfs2/file.c`: +10 lines (calls in `gfs2_file_buffered_write()`,
  `__gfs2_fallocate()`)
- **Functions modified:** `gfs2_clear_beyond_eof()` (new), `do_grow()`,
  `gfs2_file_buffered_write()`, `__gfs2_fallocate()`
- **Scope:** Single-subsystem, surgical (~30 lines)

**Step 2.2 — Code flow per hunk**

Record:
1. **`gfs2_clear_beyond_eof()`:** If `i_size` is not page-aligned and
   `end > i_size`, compute bytes from `i_size` to end of page (capped at
   `end`), then zero via `gfs2_block_zero_range()`.
2. **`do_grow()`:** Before starting a transaction, if not unstuffing,
   clear poisoned tail bytes up to new `size`.
3. **`gfs2_file_buffered_write()`:** Before
   `iomap_file_buffered_write()`, clear if write position extends past
   partial tail page.
4. **`__gfs2_fallocate()`:** When not `FALLOC_FL_KEEP_SIZE`, clear
   before allocating/extending.

**Step 2.3 — Bug mechanism**

Record: **Logic/correctness — stale data exposure.** Category: post-EOF
page-cache pollution on file extension. Same class as NFS “eof page
pollution”, f2fs “zero post-eof page”, btrfs hole expansion fixes.

**Step 2.4 — Fix quality**

Record: Fix is minimal and obviously correct. Uses existing
`gfs2_block_zero_range()` which already clamps to `i_size`.
`gfs2_quota_unlock()` is safe if `goto do_grow_qunlock` is taken with
`unstuff == 0` because it returns early when `GIF_QD_LOCKED` is unset.
Low regression risk.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `gfs2_block_zero_range()` eof clamp: `87faee382d294` (May 2025,
  Andreas Gruenbacher) — present in this tree
- `do_grow()`: present since 2010 (`ff8f33c8b30d7`)
- Bug is long-standing; not introduced after 6.18.y branched

**Step 3.2 — Fixes: tag**

Record: Not applicable (no `Fixes:` tag).

**Step 3.3 — Related file history**

Record:
- Similar fixes already in this tree: `b1817b18ff20e` (NFS eof page
  pollution), `ba8dac350faf1` (f2fs zero post-eof page)
- Commit `4982e58669b11` on `master`, merged via `gfs2-for-7.2`; **not**
  in current HEAD (`v6.18.44`)
- Part of 2-patch series; patch 1 (`70008e22ab3fd`, remove unused
  `fallocate_chunk` arg) is independent — patch 2 applies cleanly
  without it

**Step 3.4 — Author context**

Record: Andreas Gruenbacher is the GFS2 maintainer; frequent GFS2 stable
fixes in this tree.

**Step 3.5 — Dependencies**

Record: Requires `gfs2_block_zero_range()` with eof clamp
(`87faee382d294`) — **present**. Standalone; no other commits required.
`git apply --check` on `4982e58669b11` succeeds on this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 4982e58669b11` found no lore match. Ratatoskr shows
`[PATCH 2/2] gfs2: page poisoning fix` (2026-05-29), thread status
DORMANT/no replies. No stable nomination found in available sources.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` unavailable (no lore match). Author is subsystem
maintainer.

**Step 4.3 — Bug report**

Record: Failure mode documented by xfstests `generic/363` (expanded to
all filesystems Dec 2024 by Christoph Hellwig). No syzbot/user crash
reports.

**Step 4.4 — Series context**

Record: 2-patch series; only patch 2 is needed here and applies cleanly.

**Step 4.5 — Stable list**

Record: No stable-specific discussion found (lore blocked by bot
protection for manual search).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `gfs2_clear_beyond_eof()`, `do_grow()`,
`gfs2_file_buffered_write()`, `__gfs2_fallocate()`

**Step 5.2 — Callers**

Record:
- `do_grow()` ← `gfs2_setattr_size()` ← `gfs2_setattr()` / truncate
- `gfs2_file_buffered_write()` ← `gfs2_file_write_iter()` ←
  `write()`/`pwrite()` syscall path
- `__gfs2_fallocate()` ← `gfs2_fallocate()` ← `fallocate()` syscall

**Step 5.3 — Callees**

Record: `i_size_read()`, `gfs2_block_zero_range()` →
`iomap_zero_range()`

**Step 5.4 — Reachability**

Record: Reachable from userspace via mmap + grow
(write/fallocate/truncate/setattr). Common file I/O paths for GFS2
cluster users.

**Step 5.5 — Similar patterns**

Record: NFS, f2fs, btrfs, exfat all received analogous post-EOF zeroing
fixes; NFS and f2fs fixes are already in this 6.18.y tree.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code exists?**

Record: **Yes.** Local tree is `v6.18.44` (`stable/linux-6.18.y`).
`gfs2_clear_beyond_eof()` absent; `do_grow()`,
`gfs2_file_buffered_write()`, `__gfs2_fallocate()` lack the clearing
calls. Commit `4982e58669b11` is on `master` but not an ancestor of
HEAD.

**Step 6.2 — Backport complications**

Record: **Clean apply** — `git apply --check` on upstream patch succeeds
with no conflicts.

**Step 6.3 — Related fixes already present?**

Record: No equivalent GFS2 fix in this tree. Related infrastructure
(`gfs2_block_zero_range` eof clamp) is present.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: `fs/gfs2/` — IMPORTANT (cluster filesystem used in
enterprise/RHEL deployments; not universal like VFS core, but
production-critical where enabled).

**Step 7.2 — Activity**

Record: GFS2 actively maintained; multiple recent stable fixes in 6.18.y
(UAF, NULL deref, quota, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: GFS2 users (`CONFIG_GFS2_FS`) performing mmap writes on non-
page-aligned files followed by file growth.

**Step 8.2 — Trigger conditions**

Record: mmap write beyond EOF on partial tail page, then extend file
past old EOF without rewriting that region. Realistic; exercised by
`generic/363`. Unprivileged users with write access can trigger.

**Step 8.3 — Failure mode severity**

Record: **Stale/wrong data exposed in file reads** — data integrity
issue, potential information leak of page-cache contents. Not a kernel
crash, but serious for filesystem correctness. Severity: **HIGH** (data
corruption/exposure).

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH — prevents exposing poisoned page-cache data; aligns
  GFS2 with xfstest expectations and peer filesystem fixes
- **Risk:** LOW — 30-line additive fix, uses existing zeroing helper,
  applies cleanly
- **Ratio:** Strong benefit, minimal risk

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

FOR:
- Real, reproducible bug (`generic/363`)
- Data exposure on file growth
- Small, maintainer-authored, obviously correct fix
- Applies cleanly to v6.18.44
- Prerequisites present
- Peer filesystems already fixed similarly in this tree
- Long-standing bug in production GFS2 code paths

AGAINST:
- No syzbot/crash report (correctness, not oops)
- No lore review thread found
- GFS2-specific (not all kernel users)
- Skips clearing when `unstuff == 1` (stuffed→normal transition; likely
  correct for inline files)

UNRESOLVED:
- No mailing-list review discussion retrieved
- No explicit stable nomination from reviewers

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic is clear; fixes
   `generic/363`
2. Fixes a real bug affecting users? **PASS** — stale data exposure on
   grow
3. Important issue? **PASS** — data integrity / information exposure
   (HIGH)
4. Small and contained? **PASS** — 30 lines, 3 files
5. No new features/APIs? **PASS** — internal helper only
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 — Exception categories**

Record: Not a device-ID/quirk/DT/build/docs exception; standard
filesystem correctness bug fix.

**Step 9.4 — Decision rationale**

This commit fixes a real GFS2 data-integrity bug where mmap “page
poisoning” on a partial tail page can leak stale bytes when the file is
later grown. The buggy code is present in v6.18.44, the fix is small and
self-contained, prerequisites are satisfied, and analogous fixes for
NFS/f2fs are already in this stable tree. The fix should be backported.

---

## Verification

- [Phase 1] Parsed commit `4982e58669b11`: subject, body, tags; only SOB
  and xfstest reference
- [Phase 2] Diff analysis: 30 lines across `bmap.c`, `bmap.h`, `file.c`;
  new `gfs2_clear_beyond_eof()` helper
- [Phase 3] `git blame`: `do_grow()` since 2010; `gfs2_block_zero_range`
  eof clamp in `87faee382d294` (present)
- [Phase 3] `git merge-base --is-ancestor 4982e58669b11 HEAD`: fix NOT
  in current HEAD
- [Phase 3] `git apply --check` on `4982e58669b11`: applies cleanly
- [Phase 3] Related commits in tree: `b1817b18ff20e` (NFS),
  `ba8dac350faf1` (f2fs)
- [Phase 4] `b4 dig -c 4982e58669b11`: no lore match
- [Phase 4] Ratatoskr fetch: patch 2/2, 2026-05-29, DORMANT/no replies
- [Phase 5] Callers traced: `gfs2_setattr_size` → `do_grow`;
  `gfs2_file_write_iter` → `gfs2_file_buffered_write`; `gfs2_fallocate`
  → `__gfs2_fallocate`
- [Phase 5] `gfs2_quota_unlock()` at `fs/gfs2/quota.c:1152`: safe no-op
  when lock not held
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] `grep gfs2_clear_beyond_eof`: not present in tree
- [Phase 8] Failure mode: stale data exposure on file grow; severity
  HIGH

**YES**The background searches finished and match what the analysis
already used:

- **Grep search:** No `gfs2: page poisoning fix` in this tree, but
  related post-EOF fixes are present (NFS, f2fs, btrfs, exfat).
- **Branch check:** Commit `4982e58669b11` (`gfs2: page poisoning fix`)
  is on `master` (via `gfs2-for-7.2`) and is **not** in the current
  `stable/linux-6.18.y` checkout at `v6.18.44`.

That confirms the fix is a valid backport candidate for this 6.18.y tree
and applies cleanly. Verdict remains **YES**.

 fs/gfs2/bmap.c | 19 +++++++++++++++++++
 fs/gfs2/bmap.h |  1 +
 fs/gfs2/file.c | 10 ++++++++++
 3 files changed, 30 insertions(+)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index fdcac8e3f2ba2..836e260099c39 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1321,6 +1321,19 @@ static int gfs2_block_zero_range(struct inode *inode, loff_t from, loff_t length
 			&gfs2_iomap_write_ops, NULL);
 }
 
+int gfs2_clear_beyond_eof(struct inode *inode, loff_t end)
+{
+	loff_t isize = i_size_read(inode);
+	unsigned int len = isize & ~PAGE_MASK;
+
+	if (!len || isize >= end)
+		return 0;
+	len = PAGE_SIZE - len;
+	if (end - isize < len)
+		len = end - isize;
+	return gfs2_block_zero_range(inode, isize, len);
+}
+
 #define GFS2_JTRUNC_REVOKES 8192
 
 /**
@@ -2096,6 +2109,12 @@ static int do_grow(struct inode *inode, u64 size)
 		unstuff = 1;
 	}
 
+	if (!unstuff) {
+		error = gfs2_clear_beyond_eof(inode, size);
+		if (error)
+			goto do_grow_qunlock;
+	}
+
 	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT +
 				 (unstuff &&
 				  gfs2_is_jdata(ip) ? RES_JDATA : 0) +
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index 6cdc72dd55a3f..e3d6efdfd8903 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -58,6 +58,7 @@ int gfs2_get_extent(struct inode *inode, u64 lblock, u64 *dblock,
 		    unsigned int *extlen);
 int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
 		      unsigned *extlen, bool *new);
+int gfs2_clear_beyond_eof(struct inode *inode, loff_t end);
 int gfs2_setattr_size(struct inode *inode, u64 size);
 int gfs2_truncatei_resume(struct gfs2_inode *ip);
 int gfs2_file_dealloc(struct gfs2_inode *ip);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index bc67fa058c845..ef57d6aa42ebb 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1057,6 +1057,10 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 			goto out_unlock;
 	}
 
+	ret = gfs2_clear_beyond_eof(inode, iocb->ki_pos);
+	if (ret)
+		goto out_unlock;
+
 	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops,
 			&gfs2_iomap_write_ops, NULL);
@@ -1266,6 +1270,12 @@ static long __gfs2_fallocate(struct file *file, int mode, loff_t offset, loff_t
 
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
+	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		error = gfs2_clear_beyond_eof(inode, offset + len);
+		if (error)
+			return error;
+	}
+
 	offset &= bsize_mask;
 
 	len = next - offset;
-- 
2.53.0

