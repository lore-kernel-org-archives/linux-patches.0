Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AACB543C58;
	Mon, 19 Oct 2026 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418773; cv=none; b=Bu4Ar2BLyk7CVLjxJuRI6hMVCm4/BbchiUiLpNEHVrIRSWJxiMj4iqIMbru1QU1f72n1IKDAbXOqMOdBAao7QQHUbFTXh8JkQHyW0Dc8Du0ysA0etm3l8DkNGdK8Nkw3Dry/hRyISDByhzBr5W2RntsMPN2kxLVpOwNIn3IkP/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418773; c=relaxed/simple;
	bh=bBxz/Uhgb+d5MEu9EO0tuGIkk7pTuyaYOmPNtDxxKKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ssenggmk10naoV6BbnItp9/I+BHjiJk21afQuYJr3kUYjirACIBo76wnVATAi6VfoMOCGjmEaW6IXcRf9dLD5Zjlnu0Id336PpAsfqM1rpW++L7PKAl740+1P8P+Y2NVeLlidFuJd97h9JO1+6qAcAXQRO4F8vO2+pE8Kf5cBzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFKUGR3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFKUGR3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9041F000C7;
	Mon, 19 Oct 2026 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418770;
	bh=a1Kbn9w0EaGrLWbYU+vny+iLYXmyc0hfhWII48DP8E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFKUGR3kYIEf2jKYbGOZHx/SdGHpdpstVhp/izKkwUn2ywap0/nKHDASA82K7VXAH
	 7a4u9cEvq5aT6xwT5C2k/rQHFhzHLgQDZuDrncRjNLkuB1qZjzkrfr+YiROan2USq+
	 85gM1FopuSLJrhRfRUgW0S1o2GH24n/AZWAExSWqSlcYyu7exWDINrlIaBf3mt7nus
	 91gWc+fBpGyzbHaHWD2M2dfFm8+59nsgR0s6ypFf9revU+gqmssFebl6sL1gGPUrel
	 WtvotObL3nzfGIvV1ALwslnoai2yViWC8fzZsEUvjg1qMC201/estG/kyfX1PzZEpL
	 8/KXB48/pZnbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] udf: Fix bh leak for unallocated space entries
Date: Mon, 19 Oct 2026 09:52:54 -0400
Message-ID: <20261019135441.1420968-483-sashal@kernel.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit d95094d4c0a62ea17b8a7c6399b42381b8a55bc0 ]

When processing unallocated space entries we didn't properly release the
inode bh. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line `brelse()` on the UDF unallocated-space inode success
path. The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`).
The UDF `TAG_IDENT_USE` path exists here, the leak is real, and the fix
is surgical, so it belongs in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[udf] [Fix] [release the inode buffer_head after successfully
reading an unallocated space entry]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Jan Kara <jack@suse.cz>` (author; UDF maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable`
- Absence of `Fixes:` / `Cc: stable` is expected for this review
  pipeline and is **not** a negative signal
- Ignored for decision: any candidate-prep markers (`[Upstream commit
  ...]`, `Signed-off-by: Sasha Levin`) — none were on the real commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** “When processing unallocated space entries we didn't properly
  release the inode bh.”
- **Symptom/failure mode:** leaked `buffer_head` (and the block-device
  page it pins) on the success path for `TAG_IDENT_USE` inodes
- **Version information:** none in the message
- **Root cause (from message + code):** early `return 0` skips the
  function-wide `out: brelse(bh)`

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden fix.** Subject and body state a leak. The diff is
a single `brelse(bh)` before `return 0`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `fs/udf/inode.c` — **+1 / -0**
- Function: `udf_read_inode()`
- Scope: **single-file, one-line surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

`udf_read_inode()` obtains `bh` from `udf_read_ptagged()` (referenced
buffer). FE/EFE paths copy inode data and fall through to:

```1665:1668:fs/udf/inode.c
        ret = 0;
out:
        brelse(bh);
        return ret;
```

The USE (`TAG_IDENT_USE`) branch copies the unallocated-space payload,
then **returns 0 immediately**. Error paths in that branch (`goto out`)
already drop `bh`. The success path did not.

**Before:** success on a USE inode → `return 0` with `bh` still held.
**After:** `brelse(bh); return 0;` — same as the normal `out:` path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[resource leak / missing `brelse`]**
`udf_read_ptagged()` returns a held `buffer_head`. The USE success path
never released it. Error paths were already correct.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct:** the only missing release on that early return;
  `bh` is not used after the `memcpy`
- **Minimal:** one statement, no unrelated edits
- **Regression risk:** very low. No lock, API, or control-flow change
  beyond dropping a ref that was already dropped on every other path
- No double-`brelse`: this branch does not fall through to `out:`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- USE branch present since **Linux 2.6.12-rc2** (`1da177e4c3f41`)
- Early `return 0` for USE came from **`6d3d5e860a114a`** (“udf: Make
  udf_read_inode() and udf_iget() return error”, **v3.17-rc5**). That
  commit turned a pre-existing `return;` (also without `brelse`) into
  `return 0`, still without `brelse`
- The leak on this success path is **old**, not a recent regression

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No `Fixes:` tag.** Not applicable. The missing `brelse` has
been on this early return since the error-return conversion (and the
void-function `return;` before that).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Immediate parent: **`b8228f59dc58a`** “udf: bound lengthAllocDescs
  from unallocated space entry” (Jay Vadayath; committed by Jan Kara two
  minutes earlier). That adds a `goto out` bounds check on the **error**
  path of the same branch; it does **not** fix the success-path leak
- Same 7.3-rc1 fs pull also has other hardening (`udf: validate extent
  partition references…`, isofs bh-leak fixes)
- This leak fix is **standalone**. It does not need the bounds-check
  commit

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: **Jan Kara is the UDF maintainer** (`MAINTAINERS`: `M: Jan Kara
<jack@suse.com>`). Recent `fs/udf/` work is mostly his. That is a strong
quality signal for a one-line leak fix.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None required.** The hunk only needs the existing
`TAG_IDENT_USE` early `return 0` and a live `bh`. Both are in this tree.
Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c d95094d4c0a62…` — lore returned server errors; **no thread
  match**
- lore.kernel.org fetches returned **403**; search for this exact
  subject did not find a posted patch
- Unlike `b8228f59dc58a`, this commit has **no `Link:`** and only Jan
  Kara’s SOB
- **Conclusion (verified by commit metadata, not lore):** maintainer-
  applied follow-up after taking Jay Vadayath’s bounds-check patch, not
  a reviewed mailing-list series

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: `b4 dig -w` could not run (no match / lore errors). No external
reviewers on the commit. Author **is** the subsystem maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No dedicated bug report for this leak.** The adjacent USE-path
work *was* reported:
- Jay Vadayath’s KASAN OOB on crafted USE `lengthAllocDescs` (statfs →
  `udf_count_free_table`)
- Baul Lee’s similar patch, Cc: stable; Jan replied that `b8228f59dc58`
  already covered it
That discussion is about **OOB**, not this leak. It does show the USE
mount path is reachable and under active scrutiny.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Not a numbered series. Sequential maintainer commits on the same
branch:
1. bounds-check (OOB)
2. this `brelse` (leak)

Independent; either can stand alone.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search **failed (403)**. **UNVERIFIED**
whether this SHA was already discussed on stable@. Historical precedent:
a similar UDF `brelse` leak (`udf: fix memory leak while allocating
blocks during write`) **did** go to stable in 2013.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `udf_read_inode()` (modified). Helpers involved:
`udf_read_ptagged()`, `udf_alloc_i_data()`, `__udf_iget()`.

**Step 5.2: TRACE CALLERS**

Record:
- `udf_read_inode()` — only caller: `__udf_iget()` in `fs/udf/inode.c`
- `__udf_iget()` — `udf_iget()` (normal lookup) and `udf_iget_special()`
  (hidden/metadata inodes)
- USE inodes are loaded at mount from the partition header:
  `fs/udf/super.c` `phd->unallocSpaceTable.extLength` →
  `udf_iget_special()` → sets `UDF_PART_FLAG_UNALLOC_TABLE`
- That table inode is then used for block alloc/free (`fs/udf/balloc.c`)
  and `udf_count_free_table()` / `statfs`

**Step 5.3: TRACE CALLEES**

Record: `udf_read_ptagged()` → `udf_read_tagged()` returns a held `bh`.
`udf_alloc_i_data()` kmallocs `iinfo->i_data`. After copy, the on-disk
`bh` is no longer needed.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Userspace-reachable.** Mount a UDF volume that uses an
Unallocated Space Table (not only a bitmap). That is a documented UDF
allocation method, used on some writable UDF media. Not a syscall fuzzer
path by itself, but a normal mount of such media.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: FE/EFE already rely on `out: brelse(bh)`. Same-pull isofs bh-
leak fixes. Older UDF `brelse` leak in `inode_getblk` was stable
material. Pattern is systematic: early returns forgetting `brelse`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `fs/udf/inode.c` `udf_read_inode()` still has the USE
branch (`TAG_IDENT_USE`, `iinfo->i_use = 1`, early `return 0`). This
checkout is **7.3.0-rc4**; the leak existed on that path since v3.17
(and the same missing release existed before that). `git merge-base
--is-ancestor d95094d4c0a62 HEAD` succeeds — the fix is in this lineage
(merged via `fs_for_v7.3-rc1`). That does **not** change technical
merit; it confirms the code this commit targets is this tree’s UDF inode
reader.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree. Context is the existing USE
`memcpy` + `return 0`. No refactor of `udf_read_inode()` between the
commit and HEAD that would conflict.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `b8228f59dc58a` (bounds check) is in this tree; it does **not**
replace this leak fix. No other `brelse` on the USE success path besides
this commit.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **[fs/udf] [IMPORTANT]** — in-tree filesystem for DVD/CDRW and
some USB/removable UDF volumes (`CONFIG_UDF_FS`). Not core VFS/mm, but a
supported production FS, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature driver, actively maintained by Jan Kara. Recent 7.3 work
is hardening (OOB, deadlock, leaks), not a rewrite.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Filesystem-specific, config-specific:** `CONFIG_UDF_FS`
volumes that use an **Unallocated Space Table**. Bitmap-only UDF is
unaffected. Population is smaller than ext4, but real (optical and some
removable UDF).

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Trigger: successful `udf_read_inode()` of a USE inode — typically
  **once per such inode at mount**
- Not a hot path; not unprivileged-syscall without an already-mounted
  (or mountable) UDF image
- Remount / repeated mount of such media repeats the leak

**Step 8.3: FAILURE MODE SEVERITY**

Record: **[buffer_head leak] [MEDIUM–HIGH]**
Not a panic or corruption by itself. A held `bh` pins a **block-device**
page; the extra ref is not tied to the inode’s later `iput`, so it can
persist after unmount. That is a real leak, not a log-only issue.
Severity is below UAF/OOB on this same path, but it is a genuine
resource bug.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** stops a long-standing bh leak on a real UDF metadata
  inode type; same class as prior stable UDF `brelse` fixes
- **Risk:** very low (1 line, matches existing cleanup)
- **Ratio:** favorable — tiny, obviously correct leak fix

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting**
- Real missing `brelse` on a success path; error paths already released
  `bh`
- One line, obviously correct, maintainer-authored
- Buggy code is in this tree and has been for many releases
- No new API/feature; no prerequisites
- Users of UDF unallocated-space tables hit it at mount
- Same class of fix has gone to stable before

**AGAINST**
- Not a crash, UAF, or data-corruption fix
- Trigger is mount of a less common UDF allocation layout, once per
  inode
- No `Reported-by` / syzbot for *this* leak (the adjacent OOB *was*
  reported)
- No mailing-list review of this specific commit (maintainer direct
  commit)
- Could not query lore.kernel.org/stable (403)

**UNRESOLVED**
- Whether this SHA was already mailed or discussed on stable@ (lore 403
  / `b4 dig` failed)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — matches the existing `out:`
   release; author is the UDF maintainer
2. Fixes a real bug that affects users? **PASS** — leaked `buffer_head`
   on USE inode read at mount
3. Important issue? **PASS** — resource leak that pins bdev pages; not a
   panic, but a real leak with historical stable precedent
4. Small and contained? **PASS** — +1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `fs/udf/inode.c` USE path is
   present; hunk is trivial

**Step 9.3: EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
small leak fix.

**Step 9.4: DECISION**

This is a real, long-standing buffer leak on a path this tree actually
has. The patch is one `brelse(bh)` on an early return that skipped the
function’s only cleanup. Risk is negligible; benefit is stopping a leak
that can pin block-device pages across mount/unmount of UDF volumes that
use an unallocated space table. That meets stable rules for this
checkout.

---

### What the commit solves for this tree

`udf_read_inode()` holds a `buffer_head` from `udf_read_ptagged()`.
File/extended-file inodes drop it at `out:`. Unallocated space entries
(`TAG_IDENT_USE`) copy the payload and `return 0` without releasing
`bh`. That happens when this kernel mounts a UDF filesystem that uses an
unallocated space table (loaded via `udf_iget_special()` in
`fs/udf/super.c`). The extra reference is a real leak, not a style
issue.

### Stable rules / risk

Obviously correct, one line, no new API, applies to this 7.3-rc4 UDF
code with no extra commits. Benefit outweighs risk.

### Concerns

No mailing-list review of *this* one-liner (likely spotted while
applying the adjacent bounds-check). That does not make the leak
incorrect. The bounds-check commit is **not** a prerequisite.

---

### Verification

- **[Phase 1]** Parsed tags on `d95094d4c0a62`: only `Signed-off-by: Jan
  Kara`; no Fixes/Reported-by/Cc stable
- **[Phase 2]** Diff: +1 `brelse(bh)` in `udf_read_inode()` USE branch
  before `return 0`; `out:` at 1666–1668 already does `brelse(bh)`
- **[Phase 2]** Confirmed FE/EFE do not early-return; only USE does
- **[Phase 3]** `git blame fs/udf/inode.c` 1475–1493: USE branch old;
  `return 0` from `6d3d5e860a114a` (v3.17-rc5); `brelse` from this
  commit
- **[Phase 3]** `git show 6d3d5e860a114a`: old code was `return;`
  without `brelse`; leak predates that refactor
- **[Phase 3]** Parent `b8228f59dc58a` is a bounds check with `goto
  out`, not a success-path release
- **[Phase 3]** `git log --author='Jan Kara' -- fs/udf/`: maintainer;
  `MAINTAINERS` UDF FILESYSTEM entry confirmed
- **[Phase 3]** `git merge-base --is-ancestor d95094d4c0a62 HEAD` — 0
  (commit is in this lineage)
- **[Phase 4]** `b4 dig -c d95094d4c0a62…`: lore errors, no match
- **[Phase 4]** WebFetch lore.kernel.org: 403; openwall: Jay Vadayath
  OOB patch and Jan’s reply about `b8228f59dc58`; **no** thread for this
  leak commit
- **[Phase 4]** Historical stable UDF bh leak: `2fb7d99` / 3.7-stable
  review mail (verified via search snippets)
- **[Phase 5]** Callers: `__udf_iget` → `udf_iget` / `udf_iget_special`;
  mount path `super.c:1155–1172` for unalloc space table
- **[Phase 5]** `udf_read_ptagged` in `misc.c` returns
  `udf_read_tagged()`’s `bh`
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`; Makefile 7.3.0-rc4
- **[Phase 6]** Local `fs/udf/inode.c` contains the USE branch and the
  `brelse` from this fix
- **[Phase 7]** `CONFIG_UDF_FS` in `fs/udf/Kconfig`: CD/DVD/USB UDF
- **[Phase 8]** Failure mode: leaked bh / pinned bdev page on USE inode
  read, not oops
- **UNVERIFIED:** stable@ discussion of this exact SHA (lore 403)

**YES**

 fs/udf/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6a0c66d706295..84b1a0b7b28d2 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1495,6 +1495,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0

