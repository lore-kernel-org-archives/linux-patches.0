Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CF6514775;
	Mon, 31 Aug 2026 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183798; cv=none; b=MFDzsROdiP1X7IO+r/cyUSJHqU1Ob48YUwDBHnClCbK38hZ2mhj3WBYvNPLhComHbSbKBzI4dZoCvYaomk1gEEB1KamZb9a6Pczt5BhHknParRZqTOpPyX73Lj96YbJRI/DgirHBhNDjFRw4JwywDuYJ2jGF31d8+Jq43A+ypCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183798; c=relaxed/simple;
	bh=vZV2PZfP+sH7Cg8KI+eKwwh5L9yz0BX5dUFUyM2ud00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DHIrdgLDbN6RTHTfhUOyYbiQDNBnMIP3Bbtfsr5J9JZHSJEwtyH183+pu6/tb0E+nX6oZYp4pQ3obD+sCfyzEqp1WLfG83lmoR75p7l/BVr+RZMkAnE+Qq06HyolCqDACGMafep2kyAHFhe74kbC0xM9ojBDwQOOzidiLEkPURU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LF1vg+pQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LF1vg+pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCBB1F00A3F;
	Mon, 31 Aug 2026 13:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183794;
	bh=d5bf8PXaDFdlauIKesDSa3n1lxDD+c7++rS+6dr/hQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LF1vg+pQZcFfUpEswHpVwV1+H0vmQqzXn0cYxxkye11AwfsRSCuU5OeCrOvHiwIl8
	 YKoOghcE75bJMB96M+k/vQxjSptaxOiyfMjE7A1wpeJl08DUPtunlyrGQ05vptObXl
	 rimb50SnNOy1mFQ8THItpjuV6qcGRFTood7S8lkfHFrA4TQZEK7UuBByHLabTZ0mQl
	 jLC3L8N4ntqiFiyFnMUNHvf1rsVvVJuxXDQ479thnak6QSg1CWNm5Q2aUYSV2X4b4h
	 HihIuHXRPKXjT1din71OKe3ErVyPgjC/q4Wuh6DbDGoRBZDvmmy4G+82dUTCqkjT+2
	 pjeJFuEY7MuVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] isofs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:25:36 -0400
Message-ID: <20260831133314.4125787-308-sashal@kernel.org>
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

[ Upstream commit 25ef4c4d9f0e96fb89c0ae0d7127c3f12a31bc32 ]

isofs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-8-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `isofs: handle set_blocksize failures`

**Local tree:** `v6.18.44` (Linux 6.18.44)
**Commit under review:** `25ef4c4d9f0e9` (on `master`, not yet in this
tree)
**Patch series:** [PATCH 07/10] of “fix crashes when mounting legacy
file system with sector size > PAGE_SIZE”

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[isofs] [handle] — check return value of sb_set_blocksize()
during mount and fail cleanly instead of continuing`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Christoph Hellwig <hch@lst.de>` (author)
- `Link: https://patch.msgid.link/20260511071701.2456211-8-hch@lst.de`
- `Signed-off-by: Christian Brauner <brauner@kernel.org>` (committer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Reviewed-
  by:` in the committed message (Jan Kara reviewed on-list; see Phase 4)
- No syzbot report

**Step 1.3 — Body analysis**
Record:
- **Bug:** `isofs` uses buffer heads, which cannot handle block sizes >
  `PAGE_SIZE`. If `sb_set_blocksize()` fails and mount continues, the
  first `__bread_gfp` path hits `BUG_ON(offset >= folio_size(folio))` in
  `folio_set_bh`.
- **Symptom:** Kernel `BUG()` during ISO9660 mount.
- **Root cause (author):** Ignored `sb_set_blocksize()` failure leaves
  inconsistent block geometry; buffer-head setup then triggers the folio
  assertion.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although the subject says “handle failures,” this is a
real crash fix on the mount path, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **Files:** `fs/isofs/inode.c` (+2 / -1 lines)
- **Function:** `isofs_fill_super()`
- **Scope:** Single-file, surgical mount-path fix

**Step 2.2 — Code flow change**
Record:
- **Before:** `sb_set_blocksize(s, orig_zonesize);` — return value
  ignored; mount continues.
- **After:** `if (!sb_set_blocksize(s, orig_zonesize)) goto
  out_freesbi;` — mount aborts and frees `sbi`.
- **Path affected:** Normal mount success path in `isofs_fill_super()`,
  after volume-descriptor parsing and before root inode read
  (`isofs_iget()` → `sb_bread()`).

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Logic / correctness fix preventing kernel `BUG()`.
- **Mechanism:** `sb_set_blocksize()` returns 0 on failure:

```220:229:block/bdev.c
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

  ISOFS does not set `FS_LBS`. `orig_zonesize` can be 2048 (standard
ISO9660 block size). On systems with `PAGE_SIZE` < 2048 (e.g. 1024-byte
pages), `sb_set_blocksize(s, 2048)` returns 0. Mount then proceeds with
wrong `sb->s_blocksize`, and buffer-head I/O triggers:

```1578:1582:fs/buffer.c
void folio_set_bh(struct buffer_head *bh, struct folio *folio,
                  unsigned long offset)
{
        bh->b_folio = folio;
        BUG_ON(offset >= folio_size(folio));
```

**Step 2.4 — Fix quality**
Record: Obviously correct; matches pattern used by ext4, minix, udf,
romfs, and nine other filesystems in the same series. Minimal regression
risk — only changes behavior when `sb_set_blocksize()` already fails.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: The unchecked `sb_set_blocksize()` call dates to the original
import (`1da177e4c3f4`, 2005). The latent bug was exposed when PAGE_SIZE
validation was restored to `sb_set_blocksize()` in `a64e5a596067b`
(merged in v6.15).

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**
Record:
- `e106e269c5cb3` — “isofs: check the return value of
  sb_min_blocksize()” — **already in this tree**; handles earlier
  failure in the same function.
- This commit is the complementary fix for the second
  `sb_set_blocksize()` call later in `isofs_fill_super()`.
- Part of a 10-patch series (`bfs`, `hpfs`, `qnx4`, `jfs`, `befs`,
  `affs`, `isofs`, `minix`, `ntfs3`, `omfs`).

**Step 3.4 — Author context**
Record: Christoph Hellwig is a core VFS/block developer. Christian
Brauner committed the series. Jan Kara (isofs maintainer) reviewed on-
list.

**Step 3.5 — Dependencies**
Record: **Standalone.** No prerequisite commits required beyond existing
`sb_set_blocksize()` API and `out_freesbi` label (both present in this
tree). Patch applies cleanly (`git apply --check` succeeded).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 25ef4c4d9f0e9`:
  https://patch.msgid.link/20260511071701.2456211-8-hch@lst.de
- Series: v1, patch 07/10 of 10
- Jan Kara reply: `Reviewed-by: Jan Kara <jack@suse.cz>`
- No NAKs found in retrieved thread

**Step 4.2 — Reviewers**
Record: CC'd to Alexander Viro, Christian Brauner, Jan Kara, David
Sterba, linux-fsdevel@vger.kernel.org, and filesystem-specific lists.

**Step 4.3 — Bug report**
Record: No external bug report or syzbot link. Failure mode described
analytically by author.

**Step 4.4 — Series context**
Record: Broader series addresses legacy filesystems using buffer heads
on systems where `sb_set_blocksize()` can now fail due to restored
PAGE_SIZE validation (`a64e5a596067b`, in v6.15+). Each filesystem patch
is independent.

**Step 4.5 — Stable list discussion**
Record: No stable-list nomination found for this specific isofs patch.
(Absence is not a negative signal per instructions.)

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `isofs_fill_super()`, `sb_set_blocksize()`, `isofs_iget()` →
`isofs_read_inode()` → `sb_bread()` → `__bread_gfp()` → `folio_set_bh()`

**Step 5.2 — Callers**
Record: `isofs_fill_super()` called from FS mount path (`mount`/`fsopen`
syscall chain with `CAP_SYS_ADMIN`). Affects all ISO9660 mount attempts
where `sb_set_blocksize()` fails.

**Step 5.3 — Callees**
Record: On failure path, `goto out_freesbi` → `kfree(sbi)` → `return
error` (`-EINVAL`).

**Step 5.4 — Reachability**
Record: Triggered by mounting an ISO9660 image with logical block size
2048 on a kernel where `PAGE_SIZE` < 2048, or other `set_blocksize()`
failure. Requires mount privileges; not unprivileged, but still a real
admin-triggered kernel crash.

**Step 5.5 — Similar patterns**
Record: Nine sibling filesystems in the same series received identical
fixes. `e106e269c5cb3` already fixed the earlier `sb_min_blocksize()`
call in this same function.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Current tree at line 821:

```821:821:fs/isofs/inode.c
        sb_set_blocksize(s, orig_zonesize);
```

  Return value is unchecked. PAGE_SIZE validation in
`sb_set_blocksize()` is present (`a64e5a596067b`, in v6.15+). This tree
is v6.18.44, so the failure path is live.

**Step 6.2 — Backport complications**
Record: **Clean apply** — verified with `git apply --check`. No
conflicts expected.

**Step 6.3 — Related fixes already present?**
Record: `e106e269c5cb3` (sb_min_blocksize check) is already in tree.
This specific `sb_set_blocksize(orig_zonesize)` check is **not**
present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `fs/isofs` — IMPORTANT (filesystem, CD/ISO mounting). Not core
VFS, but mount crashes are serious.

**Step 7.2 — Activity**
Record: isofs is mature/low-churn; recent related fix `e106e269c5cb3`
(Nov 2025) shows active maintenance of mount error handling.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Users mounting ISO9660 filesystems on architectures with
`PAGE_SIZE` < 2048, or any configuration where `sb_set_blocksize(s,
orig_zonesize)` fails. Config/arch-specific, not universal.

**Step 8.2 — Trigger conditions**
Record: Mount ISO9660 image where `orig_zonesize` (512/1024/2048 from
disc) causes `sb_set_blocksize()` to return 0. Most common case:
2048-byte ISO on 1 KiB page kernel. Requires mount capability.

**Step 8.3 — Failure severity**
Record: **CRITICAL** — kernel `BUG()` in `folio_set_bh`, not a graceful
`-EIO` return.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** Prevents kernel crash; converts to clean mount failure.
  Complements existing `sb_min_blocksize()` fix already in tree.
- **Risk:** Very low — 2-line change, only affects already-failing path.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real kernel BUG on mount path | Narrow trigger (small-page or specific
failure configs) |
| Small, surgical, obviously correct | Requires mount privileges |
| Matches established pattern in 9 sibling FS fixes | No syzbot/user bug
report |
| Complements fix already in 6.18 tree | |
| PAGE_SIZE validation (v6.15+) makes failure path reachable | |
| isofs maintainer reviewed | |
| Applies cleanly to 6.18.44 | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — pattern used across multiple
   FS; maintainer reviewed.
2. Fixes a real bug? **PASS** — ignored failure leads to `BUG_ON`.
3. Important issue? **PASS** — kernel crash (CRITICAL severity).
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features/APIs? **PASS** — error handling only.
6. Can apply to local tree? **PASS** — verified clean apply.

**Step 9.3 — Exception categories**
Record: Not applicable (not device ID, quirk, DT, build, or docs fix).

**Step 9.4 — Decision rationale**
This commit closes a gap left by the v6.15 restoration of PAGE_SIZE
validation in `sb_set_blocksize()`. The 6.18 tree already has that
validation and the related `sb_min_blocksize()` fix, but still ignores
the second `sb_set_blocksize(orig_zonesize)` call. When that call fails,
mount continues into buffer-head I/O and hits a kernel `BUG()`. The fix
is minimal, well-reviewed, and directly prevents a crash. The trigger is
narrower than a generic networking or memory bug, but kernel `BUG()` on
mount is exactly the kind of issue stable trees accept.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.44`; parsed commit message and
  tags from user query and `git show 25ef4c4d9f0e9`
- [Phase 2] Read diff; confirmed 2-line change in `isofs_fill_super()`
- [Phase 2] Read `sb_set_blocksize()` at `block/bdev.c:220-229` —
  returns 0 when `size > PAGE_SIZE` for non-LBS filesystems
- [Phase 2] Read `folio_set_bh()` at `fs/buffer.c:1578-1582` —
  `BUG_ON(offset >= folio_size(folio))`
- [Phase 3] `git blame -L 815,825 fs/isofs/inode.c` — unchecked call
  since 2005
- [Phase 3] `git log -1 -S 'size > PAGE_SIZE' -- block/bdev.c` →
  `a64e5a596067b` (v6.15)
- [Phase 3] `git merge-base --is-ancestor a64e5a596067b HEAD` →
  PAGE_SIZE check present in tree
- [Phase 3] `git show e106e269c5cb3` — related sb_min_blocksize fix
  already in tree
- [Phase 3] `git log master --oneline --grep='handle set_blocksize
  failures'` — 10-FS series confirmed
- [Phase 4] `b4 dig -c 25ef4c4d9f0e9 -a` → patch 07/10, lore URL found
- [Phase 4] `b4 dig -c 25ef4c4d9f0e9 -w` → Viro, Brauner, Jan Kara CC'd
- [Phase 4] Mbox review → Jan Kara `Reviewed-by`
- [Phase 5] Traced mount path: `isofs_fill_super` → `isofs_iget` →
  `sb_bread` in `fs/isofs/inode.c`
- [Phase 6] Confirmed buggy line at `fs/isofs/inode.c:821` in HEAD
- [Phase 6] `git apply --check` on patch from `25ef4c4d9f0e9` → applies
  cleanly
- [Phase 6] `git log HEAD..master --oneline -- fs/isofs/inode.c` → fix
  not yet in tree
- [Phase 6] Verified `orig_zonesize` values 512/1024/2048 at
  `fs/isofs/inode.c:734-753`
- [Phase 6] Verified hardware sector > 2048 rejected at
  `fs/isofs/inode.c:606-610`

**YES**The analysis is done: **backport this commit to the 6.18.44
tree.**

`isofs_fill_super()` still ignores the return value of
`sb_set_blocksize(s, orig_zonesize)`. When that call fails (for example,
mounting a 2048-byte ISO on a kernel with `PAGE_SIZE` < 2048), mount
continues and can hit `BUG_ON(offset >= folio_size(folio))` in
`folio_set_bh` on the first buffer read.

The fix is two lines, applies cleanly, and matches the pattern already
used for the earlier `sb_min_blocksize()` check in this tree
(`e106e269c5cb3`). The commit is on `master` (`25ef4c4d9f0e9`) but not
yet in v6.18.44.

**YES**

 fs/isofs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index ad3143d4066bf..3433fa14cd014 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -818,7 +818,8 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
 	 * entries.  By forcing the blocksize in this way, we ensure
 	 * that we will never be required to do this.
 	 */
-	sb_set_blocksize(s, orig_zonesize);
+	if (!sb_set_blocksize(s, orig_zonesize))
+		goto out_freesbi;
 
 	sbi->s_nls_iocharset = NULL;
 
-- 
2.53.0

