Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A799B47208E;
	Mon, 31 Aug 2026 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183845; cv=none; b=qdbp9X3vwRi1C2Z1MeKkLOZedR5eAaIwSHzsOY9ozau/Wdg1yvMwYGP9QQ8+M+XPyFMTlrCQdrzygr7LqyN8UeTfxBz+V05Y8T3lOtV5khDQBxUT+byt7R/Jh4Z5/kha28gqmV8L1zGJvXnBUReSqcIYBswpV+wfMdIWKwRrIqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183845; c=relaxed/simple;
	bh=otr5NY2MFFscEVpnJK/T3TzYe+eAV3OQTgmN/nEWpIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G4ZR3qTVJDac/fabY+I6JNrZGg+9GsZ/8qUPUJa5yqytVqhtSWmt1WBArAcYW4iPvy7zQlId9VQJLZiMYTXls7/Z5FKVNkNpFJWKvz0557H2MpVcAnsP2tMa/Ora8rVIhm2zxiJmYUtIYMUUxr8RuZhRYYYXojEXx0thnkAd79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J03yHCGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J03yHCGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16AE1F000E9;
	Mon, 31 Aug 2026 13:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183843;
	bh=7qGwW3gxR5T/5PtitnhbUDkMhVbPHeo78jwB8bqHzrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J03yHCGS2KHuH8UsR/8hRl+vS1nx6SRtaQeVPVkeUiqbzRWROD+h2yqZtFr0FL0iP
	 Unjxvxvpi9yG2koCAeucm2U0yzR4H6EfVF3acOwi/9apZ/pL4C9jeb2Qx5JqB5rkCY
	 yH76iicKdCQ38KCcB0Y+yQ1uMIqcsVNpp53gLsLlaTIciH4NkOXsYdTV9AjnW6dL+h
	 ka1s8MN0hdaZheqfFoMNyPyKZsIFJLimWxqxlrN20eoQOZ0iHV6RLyBOBP1wW4sKfZ
	 dDbJToLZtT8BzKKr9pzuwY5d0CAgAojgTdAV1PjsAgcS4k4rpjwDigACC8QH3lTKVf
	 nMGJdH1563TgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mikulas@artax.karlin.mff.cuni.cz,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hpfs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:26:05 -0400
Message-ID: <20260831133314.4125787-337-sashal@kernel.org>
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

[ Upstream commit a405996f23e04942aad064ab8d50c55827482872 ]

hpfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-3-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[hpfs] [handle] — Check return value of sb_set_blocksize()
during HPFS mount and abort on failure.`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Christoph Hellwig <hch@lst.de>` (author)
- `Link: https://patch.msgid.link/20260511071701.2456211-3-hch@lst.de`
- `Signed-off-by: Christian Brauner <brauner@kernel.org>` (committer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or `Tested-
  by:` tags
- Part of series cover letter: `fix crashes when mounting legacy file
  system with sector size > PAGE_SIZE`

**Step 1.3 — Body analysis**
Record:
- **Bug:** HPFS ignores `sb_set_blocksize()` failure and continues
  mounting.
- **Symptom:** Kernel `BUG_ON(offset >= folio_size(folio))` in
  `folio_set_bh()` on the first `__bread_gfp()` during mount.
- **Root cause (author):** HPFS uses buffer heads, which do not cope
  with block sizes larger than `PAGE_SIZE`; when `sb_set_blocksize(s,
  512)` fails, mount proceeds with the device’s larger block size.
- **Trigger context (series cover letter):** Filesystem probing on a 64
  KiB-sector loop device caused built-in legacy filesystem drivers
  (including HPFS) to crash.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although phrased as “handle failures,” this is a real
mount-time crash fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **File:** `fs/hpfs/super.c` (+2 / −1 lines)
- **Function:** `hpfs_fill_super()`
- **Scope:** Single-file, surgical error-path fix

**Step 2.2 — Code flow change**
Record:
- **Before:** `sb_set_blocksize(s, 512);` — return value ignored; mount
  continues even if block size cannot be set.
- **After:** `if (!sb_set_blocksize(s, 512)) goto bail0;` — mount aborts
  through existing cleanup (`hpfs_unlock`, `free_sbi`, `-EINVAL`).
- **Path affected:** Early mount initialization, before first
  `hpfs_map_sector()` → `sb_bread()` call.

**Step 2.3 — Bug mechanism**
Record: **Logic / correctness + memory-safety crash**
- `setup_bdev_super()` first sets `s_blocksize` to the device logical
  block size via `sb_set_blocksize(sb, block_size(bdev))`.
- HPFS then tries `sb_set_blocksize(s, 512)`. On devices with logical
  block size > 512 (4 KiB, 64 KiB, etc.), `bdev_validate_blocksize()`
  rejects 512 and `sb_set_blocksize()` returns 0.
- Without the check, mount continues with the wrong block size; buffer-
  head allocation hits `folio_set_bh()` with invalid offsets → `BUG_ON`.

**Step 2.4 — Fix quality**
Record:
- **Quality:** Obviously correct; matches the established pattern in
  `minix`, `udf`, `ufs`, `ocfs2`, etc.
- **Regression risk:** Very low — only fails mount earlier instead of
  crashing.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `sb_set_blocksize(s, 512)` dates to the original HPFS import
(`1da177e4c3f4`, 2005). The missing error check is long-standing.

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record:
- Commit `a405996f23e04` on `master` is the fix; **not present** in this
  tree (`stable/linux-6.18.y` at v6.18.44).
- Part of 10-patch series merged as `d90e60ced4c3c` (“fix crashes when
  mounting legacy file system with sector size > PAGE_SIZE”).
- Each filesystem patch is standalone; HPFS does not depend on other
  series members.

**Step 3.4 — Author context**
Record: Christoph Hellwig (block/VFS expert) authored the series;
Christian Brauner merged it. Jan Kara reviewed related minix patches in
the same thread.

**Step 3.5 — Dependencies**
Record: **Standalone.** Requires only existing `bail0` label (present in
this tree) and `sb_set_blocksize()` API (present). Patch applies cleanly
(`git apply --check` passed).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c a405996f23e04`:
  https://patch.msgid.link/20260511071701.2456211-3-hch@lst.de
- Series cover:
  https://patch.msgid.link/20260511071701.2456211-1-hch@lst.de
- Author confirmed real crashes during fs probe on 64 KiB loop devices.
- No explicit `Cc: stable` nomination found in thread.
- No NAKs on HPFS patch.

**Step 4.2 — Reviewers**
Record (`b4 dig -w`): CC’d Alexander Viro, Christian Brauner, Jan Kara,
David Sterba, linux-fsdevel, and HPFS maintainer Mikulas Patocka. Thread
contains `Reviewed-by: Jan Kara`, `Acked-by: David Sterba`, `Acked-by:
Anders Larsen` on series patches.

**Step 4.3 — Bug report**
Record: No external bugzilla/syzbot report. Reproduction described in
cover letter (64 KiB loop device + built-in fs probe).

**Step 4.4 — Series context**
Record: Patch 02/10 in v1 series; same logical fix applied to 10 legacy
filesystems. HPFS patch is independent.

**Step 4.5 — Stable list**
Record: No stable-list discussion found for this specific HPFS patch.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `hpfs_fill_super()`, `hpfs_map_sector()`, `sb_set_blocksize()`,
`sb_bread()` → `__bread_gfp()` → `bdev_getblk()` → `grow_buffers()` →
`folio_alloc_buffers()` → `folio_set_bh()`.

**Step 5.2 — Callers**
Record:
- `hpfs_fill_super()` called from `hpfs_get_tree()` via
  `get_tree_bdev()`.
- Reachable from `mount(2)` / `fsopen`+`fsconfig`+`fsmount` syscalls.
- Also reachable during automatic filesystem probing when mounting a
  block device.

**Step 5.3 — Callees**
Record: On failure path, `goto bail0` runs `hpfs_unlock()`,
`free_sbi()`, returns `-EINVAL` — proper cleanup, no buffer heads
allocated yet.

**Step 5.4 — Reachability**
Record: **Userspace-reachable** whenever `CONFIG_HPFS_FS` is enabled
(built-in or module loaded) and a mount/probe is attempted on a block
device whose logical sector size prevents setting 512-byte blocks.

**Step 5.5 — Similar patterns**
Record: Same missing-check pattern fixed across `bfs`, `minix`, `jfs`,
`qnx4`, `isofs`, `affs`, `befs`, `omfs`, `ntfs3` in the same series —
systematic error-handling gap.

---

## Phase 6: Cross-Reference Against Local Tree (linux-6.18.y / v6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** `fs/hpfs/super.c:525` still has unchecked
`sb_set_blocksize(s, 512);`. `folio_set_bh()` BUG_ON exists
(`fs/buffer.c:1582`, since `465e5e6a1698f`). `bdev_validate_blocksize()`
exists (`block/bdev.c`, since `e03463d247dda`).

**Step 6.2 — Backport complications**
Record: **Clean apply** — verified with `git apply --check`. `bail0`
label already exists at lines 690–693.

**Step 6.3 — Fix already present?**
Record: **No.** `git log HEAD --grep="handle set_blocksize"` returns
empty; commit `a405996f23e04` is on `master` but not in this stable
branch.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: **Filesystem (HPFS)** — PERIPHERAL driver, but mount/probe path
can affect any user mounting block devices when HPFS is enabled.

**Step 7.2 — Subsystem activity**
Record: HPFS is mature/legacy; recent changes are minor (mount API
conversion, helpers). The bug is in longstanding mount code.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users with `CONFIG_HPFS_FS` enabled who mount or auto-probe
block devices with logical sector size > 512 bytes (4 KiB and 64 KiB
devices are common).

**Step 8.2 — Trigger conditions**
Record:
- Mount HPFS, or filesystem probe hits HPFS superblock check on large-
  sector device.
- Requires HPFS support compiled in or loaded.
- Unprivileged users can trigger via `mount` if permitted by policy.

**Step 8.3 — Failure mode severity**
Record: **CRITICAL** — `BUG_ON()` causes kernel panic during mount/probe
(confirmed by series author for this class of filesystems on 64 KiB
devices).

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Prevents kernel panic; returns clean mount error instead.
- **Risk:** Minimal (2-line change on error path only).
- **Ratio:** Strongly favorable.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real mount-time kernel BUG | HPFS is rarely used/enabled |
| Reproduced by author (64 KiB probe) | Only affects HPFS users |
| Trivial, obviously-correct fix | |
| Reviewed/acked in series | |
| Applies cleanly to 6.18.y | |
| Standard pattern across many fs drivers | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — pattern is standard; author
   tested during series development.
2. Fixes a real user-affecting bug? **PASS** — mount/probe panic.
3. Important issue? **PASS** — kernel crash (CRITICAL).
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features/APIs? **PASS** — error handling only.
6. Can apply to local tree? **PASS** — verified clean apply;
   prerequisites present.

**Step 9.3 — Exception category**
Record: Not a device-ID/quirk/DT/docs exception — standard bug fix.

**Step 9.4 — Decision rationale**
For **linux-6.18.y (v6.18.44)**, the unchecked `sb_set_blocksize()` call
is present, the failure mode is real and severe, and the fix is minimal
with negligible regression risk. Even though HPFS is niche, a mount-time
`BUG_ON` is exactly the kind of issue stable trees should fix.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show a405996f23e04`
- **[Phase 2]** Read diff; confirmed `bail0` cleanup path in
  `fs/hpfs/super.c:686-693`
- **[Phase 2]** Read `sb_set_blocksize()` at `block/bdev.c:220-230` and
  `bdev_validate_blocksize()` at `block/bdev.c:165-175`
- **[Phase 2]** Read `folio_set_bh()` BUG_ON at `fs/buffer.c:1578-1582`
- **[Phase 3]** `git blame -L 525,525 fs/hpfs/super.c` → original 2005
  code
- **[Phase 3]** `git log master --grep="handle set_blocksize"` → found
  `a405996f23e04`; absent from HEAD
- **[Phase 3]** `git show d90e60ced4c3c` → merge commit with crash
  description
- **[Phase 3]** `git apply --check` on patch → applies cleanly
- **[Phase 4]** `b4 dig -c a405996f23e04` → lore URL found
- **[Phase 4]** `b4 dig -w` → maintainers CC'd
- **[Phase 4]** `/tmp/hpfs_blocksize.mbx` → cover letter, reviews, no
  stable nomination
- **[Phase 5]** Traced `hpfs_map_sector()` → `sb_bread()` in
  `fs/hpfs/buffer.c:82`
- **[Phase 5]** Traced `setup_bdev_super()` initial blocksize at
  `fs/super.c:1662`
- **[Phase 6]** `git describe HEAD` → v6.18.44; `Makefile` → 6.18.44
- **[Phase 6]** Confirmed buggy line at `fs/hpfs/super.c:525`
- **[Phase 6]** `git merge-base --is-ancestor 465e5e6a1698f HEAD` →
  folio_set_bh present
- **[Phase 6]** `git merge-base --is-ancestor e03463d247dda HEAD` →
  bdev_validate present

**YES**The background searches finished and match the earlier analysis:

- The fix is **`a405996f23e04`** (`hpfs: handle set_blocksize failures`)
  on `master`, part of Christoph Hellwig’s “legacy filesystem sector
  size > PAGE_SIZE” series.
- It is **not** in the checked-out **linux-6.18.y** tree (v6.18.44).
- `b4 dig` succeeded on retry and pointed to the lore thread; the
  initial timed-out runs did not change the conclusion.

Verdict for this tree remains **YES** — a small mount-time crash fix
that applies cleanly.

 fs/hpfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 8ab85e7ac91eb..553e6b6b4600b 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -522,7 +522,8 @@ static int hpfs_fill_super(struct super_block *s, struct fs_context *fc)
 	hpfs_lock(s);
 
 	/*sbi->sb_mounting = 1;*/
-	sb_set_blocksize(s, 512);
+	if (!sb_set_blocksize(s, 512))
+		goto bail0;
 	sbi->sb_fs_size = -1;
 	if (!(bootblock = hpfs_map_sector(s, 0, &bh0, 0))) goto bail1;
 	if (!(superblock = hpfs_map_sector(s, 16, &bh1, 1))) goto bail2;
-- 
2.53.0

