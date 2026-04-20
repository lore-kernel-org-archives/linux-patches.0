Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948B63DC4B2;
	Mon, 20 Apr 2026 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691451; cv=none; b=gxAl3X4iD+MGDglT0ONmLQj2LGzrDRoAUtNthOQu+s1zVrJ8QMmZnDLKLKmp0BgDuc/Ng6ZKivtbCStvOcsW582faI6Jy8iDW572wLKxXepBtEUlqXQvl93ftR0imaIezkykrA28nIH/rQw1hSTGD1GQVHJ9h+mlFXWDkvSE+MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691451; c=relaxed/simple;
	bh=FEnyd1UQ/zZHWMGwmgtUtyWm7G0MehOng4821bhIHuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5ttJe5V3a5zIoWWzzIocpwnUWCgK/A4eosQqL+Rwtd+8P49dwfasmZ38tes9/lTDO1no/hj+4Y4cEVs9qVer8oXgoawupgKNhCj5JKHciUGg4ZC00mctcg9UbvLXM7Z40IbOyT4omizHNnrVQzXM9QvMSvR5/jYnT0QgnlGydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nW/xqpEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nW/xqpEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C56DC2BCB9;
	Mon, 20 Apr 2026 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691451;
	bh=FEnyd1UQ/zZHWMGwmgtUtyWm7G0MehOng4821bhIHuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW/xqpEuDFfmInz0VFvrKHs4eKR3Gq3EKEzgZycqd9RqhM1nywHv9r3rVCw+5YyuC
	 gJrFcC+LHWlHEHCEIu3Cwm9hLSCaLHI68WYECg00KhCiimtzdFPaKsu5I66dERxE3w
	 AQmnAGbS1gRAYlbgIlgMjhhnUOtzJbWbzOaWmhSGpB3F9vYV/+IgNwN2JsNdZOtheK
	 IejJQEWmUxiDVFbQbZd0G/5IIfeDf7jOZaeJ2ezbkT1JFrM/OU7DqHw1ixwpUOMeq4
	 nJfozi6O5ZxQg0P1YbShQlXuE9IzbU+yYfECyQUyjs1+9vbIr6oBDEij+fqdw7SUvT
	 yU6GTym85DlZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>,
	devel@lists.orangefs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] orangefs_readahead: don't overflow the bufmap slot.
Date: Mon, 20 Apr 2026 09:17:10 -0400
Message-ID: <20260420132314.1023554-36-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 415e507cdefc510c01de8ab6644163327ee9a5d0 ]

generic/340 showed that this caller of wait_for_direct_io was
sometimes asking for more than a bufmap slot could hold. This splits
the calls up if needed.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have enough information to provide a comprehensive analysis.

## Analysis

### Phase 1: Commit Message Forensics

**Step 1.1 — Subject parsing:**
Record: subsystem = `fs/orangefs`, function = `orangefs_readahead`;
action = "don't overflow" (prevention/fix verb); claim = bufmap slot
overflow is avoided by splitting up large wait_for_direct_io calls.

**Step 1.2 — Tags:**
Record: Only `Signed-off-by: Mike Marshall <hubcap@omnibond.com>`
(author is the OrangeFS subsystem maintainer per MAINTAINERS). No
Fixes:, Cc: stable:, Reviewed-by:, Tested-by:, Reported-by:, or Link:
tags. The absence of these tags is expected for autoselection review.

**Step 1.3 — Body analysis:**
Record: The bug manifests via xfstests `generic/340` (a known mmap
writing race test using the `holetest` helper — verified by fetching the
test source). The author states the caller was "sometimes asking for
more than a bufmap slot could hold," i.e. the `total_size` passed to
`wait_for_direct_io` could exceed the bufmap descriptor's slot size.

**Step 1.4 — Hidden bug fix detection:**
Record: The verb "don't overflow" and the claim of "sometimes asking for
more than a bufmap slot could hold" is explicit: this is an out-of-
bounds / overflow fix, not a cleanup.

### Phase 2: Diff Analysis

**Step 2.1 — Inventory:**
Record: Single file (`fs/orangefs/inode.c`), single function
(`orangefs_readahead`). +27/−9, ~18 net added lines. Single-file
surgical fix.

**Step 2.2 — Code flow change:**
Record:
- BEFORE: One call `wait_for_direct_io(..., readahead_length(rac), ...)`
  using the full readahead length which can exceed 4 MB.
- AFTER: A loop that chunks the request into pieces of at most 4194304
  bytes (4 MB), advancing `offset` and draining `remaining`.

**Step 2.3 — Bug mechanism:**
Record: Category (f/h) bounds/size fix. I inspected
`fs/orangefs/orangefs-bufmap.c` and `orangefs_bufmap_copy_to_iovec`:

```497:521:fs/orangefs/orangefs-bufmap.c
int orangefs_bufmap_copy_to_iovec(struct iov_iter *iter,
                                    int buffer_index,
                                    size_t size)
{
        struct orangefs_bufmap_desc *from;
        int i;

        from = &__orangefs_bufmap->desc_array[buffer_index];
        ...
        for (i = 0; size; i++) {
                struct page *page = from->page_array[i];
                size_t n = size;
                if (n > PAGE_SIZE)
                        n = PAGE_SIZE;
                n = copy_page_to_iter(page, 0, n, iter);
```

Each `desc.page_array` is a pointer into a shared larger
`bufmap->page_array` sliced by `pages_per_desc` (`desc_size /
PAGE_SIZE`, i.e. 1024 pages for a 4 MB slot). If `size` exceeds one
slot, the loop index `i` walks off the end of the slot into the next
slot's pages — or, for the last slot, off the end of
`bufmap->page_array` entirely. This produces either data corruption
(mixing data destined for a different concurrent I/O) or a wild out-of-
bounds dereference of an uninitialized page pointer.

**Step 2.4 — Fix quality:**
Record: The fix is obviously correct in shape: it bounds each call to ≤
4 MB and correctly advances both `offset` and the loop counter. `iter`
is naturally advanced inside `wait_for_direct_io` via
`orangefs_bufmap_copy_to_iovec`. There is an existing precedent for the
same pattern in the same file in `orangefs_direct_IO` (lines 519–565),
which uses `orangefs_bufmap_size_query()` to cap the per-call size —
this is literally the same idea. Minor concern: the fix hardcodes
`4194304` rather than using `orangefs_bufmap_size_query()`, but the same
function already hardcodes `4194304` for `readahead_expand` above, so
the fix is internally consistent with surrounding code. Regression risk
is very low; worst-case is a marginal performance change (two 4 MB
round-trips instead of one >4 MB round-trip).

### Phase 3: Git History Investigation

**Step 3.1 — Blame:**
Record: `git blame` shows the buggy `readahead_length(rac)` call site
has been unchanged since commit `0c4b7cadd1ade1` "Orangef: implement
orangefs_readahead." authored by Mike Marshall on 2021-03-28 (kernel
v5.13 merge window). The only cosmetic change was `iov_iter_xarray`
signature churn in v6.1 by Al Viro (`de4eda9de2d957`).

**Step 3.2 — Fixes tag:**
Record: No Fixes: tag in the commit, but blame reveals the introducing
commit is `0c4b7cadd1ade1` (present in v5.13+).

**Step 3.3 — File history:**
Record: Recent touches to the readahead code are `cd01049d9ca37` (folio
conversion, 2023) and `121a83ce6fe69` ("orangefs: Bufmap deadcoding").
None of them alter the bounds behavior; all stable trees retain the
unsafe pattern.

**Step 3.4 — Author:**
Record: Mike Marshall (`hubcap@omnibond.com`) is the OrangeFS
maintainer. The commit arrived through the `for-linus-7.1-ofs1` pull
request (verified by fetching the PR from lore.kernel.org archive search
results). Author credibility is high.

**Step 3.5 — Dependencies:**
Record: Fix is standalone. It does not touch any function signatures,
nor depend on the companion series commit `e61bc5e4d8743` (bufmap-as-
folios) that was pulled alongside.

### Phase 4: Mailing List Research

**Step 4.1 — b4 dig:**
Record: `b4 dig -c 415e507cdefc5...` searched lore by patch-id, subject,
and author — all three attempts returned no match. This is consistent
with OrangeFS patches that are often applied directly from the
maintainer tree without appearing on a public list as a standalone patch
thread. The PR containing the fix (`for-linus-7.1-ofs1`, 2026-04-17) is
visible in the lore archive but does not contain a per-patch discussion
thread.

**Step 4.2/4.3 — Discussion/bug report:**
Record: No separate review thread was found; the change flowed through
Mike Marshall's maintainer tree to Linus in the 7.1-rc window.
`generic/340` is the reproducer cited by the author and is a documented
mmap write race test in xfstests (verified by fetching its source).

**Step 4.4/4.5 — Related patches/stable discussion:**
Record: No related stable mailing list discussion found. The sibling
commit `e61bc5e4d8743` ("bufmap: manage as folios, V2") confirms a slot
size of 4 MB in ten-slot configurations — establishing the `4194304`
constant matches the real slot size.

### Phase 5: Code Semantic Analysis

**Step 5.1/5.2 — Functions/callers:**
Record: Only `orangefs_readahead` is modified. It is registered as
`.readahead` in `orangefs_address_operations` (verified via grep in each
stable branch). It is invoked by the VFS readahead machinery
(`page_cache_ra_*`), reachable from any buffered read of an OrangeFS
file, including `read(2)` and `mmap(2)` page faults — i.e. the normal
user-facing path.

**Step 5.3 — Callees:**
Record: Calls `wait_for_direct_io` (fs/orangefs/file.c), which allocates
a bufmap slot via `orangefs_bufmap_get()`, then uses
`orangefs_bufmap_copy_to_iovec` to fetch up to `total_size` bytes — the
OOB occurs here.

**Step 5.4 — Reachability:**
Record: Path is reachable from userspace with a normal read/mmap of any
file on OrangeFS. `generic/340` triggers it via `holetest`. Reproducer
exists.

**Step 5.5 — Similar patterns:**
Record: `orangefs_direct_IO` already chunks I/O using
`orangefs_bufmap_size_query()` (lines 519–565). The readahead path was
simply missing this safety loop; the fix adds the analogous defense.

### Phase 6: Stable Tree Analysis

**Step 6.1 — Buggy code in stable:**
Record: Checked `stable-push/linux-5.15.y`, `6.1.y`, `6.6.y`, `6.12.y`,
`6.17.y`, `6.18.y`, `6.19.y`. All have the identical unbounded single-
call pattern. The bug exists in every active LTS and rolling-stable
branch.

**Step 6.2 — Backport difficulty:**
Record: The modified hunk itself is identical across all stable trees —
only the surrounding "clean up" block differs
(`readahead_page`/`page_endio` in 5.15/6.1 vs.
`readahead_folio`/`folio_*` from 6.6 onward). The fix inserts its loop
before that block and does not touch it, so application should be clean
or essentially clean on every LTS.

**Step 6.3 — Prior fixes:**
Record: No earlier or alternative fix has been applied to stable for
this issue.

### Phase 7: Subsystem Context

**Step 7.1/7.2:**
Record: Subsystem is `fs/orangefs` — a distributed filesystem.
Criticality: PERIPHERAL (limited user base compared to ext4/xfs) but
still a real filesystem with real data-integrity expectations. Activity
is low-to-moderate; mostly maintenance.

### Phase 8: Impact and Risk

**Step 8.1 — Affected population:**
Record: Filesystem-specific — only OrangeFS users. But for those users,
the bug fires on ordinary reads, not a rare configuration.

**Step 8.2 — Trigger:**
Record: Fires any time the readahead window exceeds 4 MB, which the
existing `readahead_expand(... 4194304)` plus kernel heuristics make
fairly likely for sequential reads of large files. An unprivileged user
reading a >4 MB file can trigger it.

**Step 8.3 — Failure severity:**
Record: Out-of-bounds `page_array[i]` dereference → at best reads pages
belonging to another concurrent OrangeFS I/O (silent data corruption /
info leak between slots); at worst walks off the end of
`bufmap->page_array` (NULL/garbage page pointer, crash in
`copy_page_to_iter`). Classification: HIGH.

**Step 8.4 — Risk/benefit:**
Record:
- Benefit: Prevents data corruption and possible OOB read on a user-
  triggerable path in OrangeFS.
- Risk: Very low. ~18 net lines in a single function. Identical chunking
  pattern exists elsewhere in the file. No API or locking changes. The
  only downside is slightly more round-trips for >4 MB readaheads.
- Ratio: Favorable.

### Phase 9: Synthesis

**Step 9.1 — Evidence:**
FOR: Real OOB/corruption fix reachable from userspace (reads, mmap);
reproduced by xfstests generic/340; surgical scope; author is subsystem
maintainer; identical pattern already used elsewhere in the same file;
bug present in every stable tree since v5.13.
AGAINST: No explicit Cc: stable or Fixes: tag (expected for
autoselection); fix uses a hardcoded constant instead of
`orangefs_bufmap_size_query()` (cosmetic concern, consistent with
neighbouring code).

**Step 9.2 — Stable rules:**
1. Obviously correct? Yes — clean chunking, matches existing precedent.
2. Real bug? Yes — OOB in bufmap page array.
3. Important? Yes — data corruption / OOB read, HIGH severity.
4. Small and contained? Yes — ~18 net lines, single function, single
   file.
5. No new features/APIs? Correct.
6. Applies to stable? Yes — identical hunk context in all LTS branches.

**Step 9.3 — Exception categories:** Not applicable; this is a
straightforward bug fix.

**Step 9.4 — Decision:** YES.

## Verification

- [Phase 1] Parsed tags: only `Signed-off-by: Mike Marshall` present; no
  Fixes:/Cc:stable/Link:/Reported-by: (confirmed via `git log -1
  --format='%B'`).
- [Phase 1] Verified `generic/340` is xfstests mmap-write race via
  `holetest` by fetching
  `github.com/kdave/xfstests/raw/master/tests/generic/340`.
- [Phase 2] Inspected `orangefs_bufmap_copy_to_iovec` in
  `fs/orangefs/orangefs-bufmap.c`: confirmed unchecked
  `from->page_array[i]` indexing driven by `size`.
- [Phase 2] Inspected `orangefs_bufmap_map`: confirmed
  `desc_array[i].page_array` are slices of the shared
  `bufmap->page_array` (line 279–285), so an over-sized `size` walks
  into the next slot or off the end.
- [Phase 2] Inspected `orangefs_direct_IO` (lines 519–565): confirmed
  existing per-call size cap using `orangefs_bufmap_size_query()` — the
  readahead fix mirrors this pattern.
- [Phase 3] `git blame` on lines 242–247 in `fs/orangefs/inode.c`: buggy
  pattern originates in `0c4b7cadd1ade1` (2021-03-28, v5.13 merge
  window).
- [Phase 3] `git log --oneline -- fs/orangefs/inode.c`: confirmed only
  cosmetic changes (`de4eda9de2d957`, `cd01049d9ca37`) since
  introduction.
- [Phase 3] `git log --author="Mike Marshall" --oneline`: confirmed
  author is the long-time OrangeFS maintainer.
- [Phase 4] `b4 dig -c 415e507cdefc5...`: no lore match (by patch-id, by
  author/subject, or by in-body From). Falls back to pull-request
  channel.
- [Phase 4] `WebFetch https://yhbt.net/lore/linux-fsdevel/?q=for-
  linus-7.1-ofs1`: located the pull request for 7.1-ofs1 by Mike
  Marshall (2026-04-17) and pr-tracker-bot confirmation.
- [Phase 4] Searched lore for "orangefs_readahead bufmap slot" and
  related phrases: no standalone review thread found — patch flowed
  through the maintainer tree.
- [Phase 5] `Grep` for `.readahead = orangefs_readahead` in all stable
  branches: confirmed it is wired into `orangefs_address_operations` and
  thus reachable from ordinary VFS reads.
- [Phase 5] Inspected `wait_for_direct_io` (`fs/orangefs/file.c` lines
  49–280): confirmed `total_size` is passed unchecked as
  `new_op->upcall.req.io.count` and is used to drive
  `orangefs_bufmap_copy_to_iovec`'s loop.
- [Phase 6] `git show stable-
  push/linux-{5.15,6.1,6.6,6.12,6.17,6.18,6.19}.y:fs/orangefs/inode.c`:
  confirmed identical unbounded `wait_for_direct_io(...,
  readahead_length(rac), ...)` call in every branch.
- [Phase 6] Compared context lines: modified hunk is identical; only the
  post-loop cleanup differs (page vs folio) and is not touched by the
  fix — clean apply expected.
- [Phase 8] Verified bufmap slot size: sibling commit `e61bc5e4d8743`
  ("bufmap: manage as folios, V2.") explicitly documents ten 4 MB slots;
  matches the `4194304` constant.
- UNVERIFIED: Exact mainline release that will first contain this commit
  (it is in the 7.1-ofs1 PR, so 7.1-rc onward); not yet merged into the
  tree HEAD I have available — irrelevant to the YES decision.
- UNVERIFIED: Whether `generic/340` was observed to reproduce on every
  stable branch (not directly tested, but the code path is identical in
  every branch so the same failure applies).

The fix addresses a real, userspace-triggerable out-of-bounds memory
access in a filesystem read path, is minimal, self-contained, authored
by the subsystem maintainer, validated by an xfstests reproducer, and
applies cleanly to all active stable trees where the bug has been
present since v5.13.

**YES**

 fs/orangefs/inode.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 2d4710d0e05e1..af7c9432e141b 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -224,6 +224,8 @@ static void orangefs_readahead(struct readahead_control *rac)
 	loff_t new_start = readahead_pos(rac);
 	int ret;
 	size_t new_len = 0;
+	size_t this_size;
+	size_t remaining;
 
 	loff_t bytes_remaining = inode->i_size - readahead_pos(rac);
 	loff_t pages_remaining = bytes_remaining / PAGE_SIZE;
@@ -239,17 +241,33 @@ static void orangefs_readahead(struct readahead_control *rac)
 	offset = readahead_pos(rac);
 	i_pages = &rac->mapping->i_pages;
 
-	iov_iter_xarray(&iter, ITER_DEST, i_pages, offset, readahead_length(rac));
+	iov_iter_xarray(&iter, ITER_DEST, i_pages,
+				offset, readahead_length(rac));
 
-	/* read in the pages. */
-	if ((ret = wait_for_direct_io(ORANGEFS_IO_READ, inode,
-			&offset, &iter, readahead_length(rac),
-			inode->i_size, NULL, NULL, rac->file)) < 0)
-		gossip_debug(GOSSIP_FILE_DEBUG,
-			"%s: wait_for_direct_io failed. \n", __func__);
-	else
-		ret = 0;
+	remaining = readahead_length(rac);
+	while (remaining) {
+		if (remaining > 4194304)
+			this_size = 4194304;
+		else
+			this_size = remaining;
+
+		/* read in the pages. */
+		if ((ret = wait_for_direct_io(ORANGEFS_IO_READ, inode,
+				&offset, &iter, this_size,
+				inode->i_size, NULL, NULL, rac->file)) < 0) {
+			gossip_debug(GOSSIP_FILE_DEBUG,
+				"%s: wait_for_direct_io failed. :%d: \n",
+				__func__, ret);
+			goto cleanup;
+		} else {
+			ret = 0;
+		}
+
+		remaining -= this_size;
+		offset += this_size;
+	}
 
+cleanup:
 	/* clean up. */
 	while ((folio = readahead_folio(rac))) {
 		if (!ret)
-- 
2.53.0

