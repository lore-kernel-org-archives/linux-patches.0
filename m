Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0C60C138;
	Mon, 19 Oct 2026 14:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418615; cv=none; b=j7co9hAhO4OyNuIT0wf0eNhQnO3SYBG/RhyUd7N45QSgumcVs55vI3rZPY1s3xn+j+ZyMvldryb5bDyZftyeqz/VuTh7W65S1hamPeDXKm74bX9n+2lz9JhAG/KuMg5kpmpT+/47Ef44vS8zvE+40DUzU5L67Uo9NC84Ku8tA/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418615; c=relaxed/simple;
	bh=+f7AxBQ/GFqMQOqpSVOnMUjhTseUYo1rSUcfmMZiITw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p6HCz6Lp26M4tuYrtOfplkgMMJPO9TWAnDyrGw1UlGCPHqc/Hj3NVdCuCCSATc2kdvZ1Tl7ACyk62lwTbmnusyY4N1RBAmVyWh0RfqK5BRSFxdm646nMLBuWVp63/J3Gs/ot2d0Inu8xg8Q2TFDFBN+rxfm6pHbbbbyoqwLaQnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDa1qS3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDa1qS3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70181F000C9;
	Mon, 19 Oct 2026 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418611;
	bh=O/7nKuZZTTXKrqGgjsu53ErwkFI4GPu3p0+a9Gj7TDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDa1qS3AnqKoCwvSpaP+OPTgda4UVC5CZEWUKKSlKjnF+YNQC40UwQVSU8lOISzlL
	 lWl4kyqj8h0/HlIpmSheUR+fDuXQhqVCNJVOpyQx0qxP5m0IGdq89f1D5WAFejubBA
	 sMAwcLCqY2/lmXF4MkjtvURmlYicnm34Io7nS8TN5f8AXwrJk3/1voGbxuL+/7amLT
	 fKS0+Fqjldzi4vtgYOuh/o0RWB/8HnGcUUARARwVGvPEZQMf7gWb17IC1d+UZb/1et
	 wBf6gHzlzBFMdoi3zh32NALmBhtwqut43ulBGlbtDa+rFvTzpV7+Lk9N+RAITQ0GAl
	 8qX6IKE8FG1BQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	awalls@md.metrocast.net,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: cx18: stop VBI start-code scan before short tail
Date: Mon, 19 Oct 2026 09:51:03 -0400
Message-ID: <20261019135441.1420968-372-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit bf533acaaa7dee21d49bcaabf8e813ea36bddcd8 ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline `7.3.0-rc4`). The candidate is
`bf533acaaa7de` (“media: cx18: stop VBI start-code scan before short
tail”). It is a one-line bounds fix for a four-byte VBI start-code scan
that can read past `bytesused`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[media/cx18] [stop] [stop VBI start-code scan before a short
4-byte tail]**
- Subsystem: `media: cx18`
- Verb: **stop** (prevent incorrect continuation) — a bug-fix verb even
  without “fix”
- Intent: do not scan a 4-byte EAV/start code when fewer than 4 bytes
  remain

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by:** Pengpeng Hou &lt;pengpeng@iscas.ac.cn&gt; (author)
- **Signed-off-by:** Hans Verkuil &lt;hverkuil+cisco@kernel.org&gt;
  (media maintainer; applied the patch)
- **No Fixes:**
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link / Cc:
  stable**
- Absence of Fixes/Cc:stable is expected for this pipeline and is not a
  negative signal
- Ignored: any Sasha Levin SOB / “[Upstream commit …]” (none in the real
  commit)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `compress_sliced_buf()` walks one byte at a time and tests
  `buf[0]..buf[3]`. The last iterations can read past the remaining
  tail.
- **Symptom:** out-of-bounds **read** of 1–3 bytes past `size` (the
  caller’s `buf->bytesused`).
- **Failure mode:** memory-safety defect (possible slab/page over-read
  if `bytesused` equals the allocation; otherwise a logical over-read of
  DMA payload).
- **Version info:** none in the message. History shows the loop since
  2008/2009.
- **Root cause (author):** loop condition `i < size` does not leave four
  readable bytes.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not disguised.** It is an explicit bounds fix. Not
cleanup/refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/media/pci/cx18/cx18-vbi.c` — **1 insertion, 1
  deletion** (`2 +-`)
- **Function:** `compress_sliced_buf()`
- **Scope:** single-file, single-line surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `for (i = hdr_size, buf += hdr_size; i < size; i++,
  buf++)` then `buf[0]..buf[3]`. When `i` is `size-3`, `size-2`, or
  `size-1`, `buf[3]` is at `size`, `size+1`, or `size+2` — past the
  valid tail.
- **After:** `i + 3 < size` so the last readable index is `i+3 <=
  size-1`.
- **Path:** sliced-VBI start-code search (not probe init). Only the “no
  start code until EOF” path actually hits the tail; a successful match
  `break`s earlier.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** **(d) memory safety** — buffer over-read / out-of-bounds
- **Mechanism:** 4-byte peek with a 1-byte stride and an exclusive
  `size` bound.
- **Fix:** require four remaining bytes (`i + 3 < size`), the same
  pattern as the sibling ivtv change.

If no start code is found:
- Old: `i == size`, then `size -= (i - hdr_size)` → remaining `hdr_size`
  (12)
- New: `i == size - 3` (when `size` is large enough), remaining
  `hdr_size + 3` (15)
Both are still `< line_size` (272/284), so the function still returns 0.
A 4-byte code cannot sit in the last 3 bytes, so no false negative.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Obviously correct.** Classic `need N bytes remaining` bound.
- **Minimal.** One condition, no API/locking/structure change.
- **Regression risk: very low.** False match in the old over-read tail
  still left remaining size ≪ `line_size`. `i` starts at `hdr_size` (12)
  and only increments; `i + 3 < size` with `u32 size` is safe for
  realistic DMA sizes.
- **Red flags:** none.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Loop introduced in **`1c1e45d17b663d`** (Hans Verkuil, 2008-04-28) —
  original cx18 driver, `for (i = 0; i < size; i++, buf++)`.
- Current form (`i = hdr_size, buf += hdr_size; i < size`) from
  **`4ab9b256b5908a`** (Andy Walls, 2009-03-14) — “Optimize processing
  of VBI buffers”.
- Bug present ~17 years. Bound fixed in **`bf533acaaa7de`** (Pengpeng
  Hou, 2026-06-30; Hans Verkuil commit).

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** N/A. Introducer is `4ab9b256b5908a` /
original `1c1e45d17b663d`, both ancestors of this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent cx18-vbi.c: this fix, email/SPDX/typo/whitespace. No refactor
  of the scan.
- **Sibling (same author, same day, same maintainer):** `f373cf17fb8e7`
  `media: ivtv: stop VBI start-code scan before short tail` — same one-
  line change in `drivers/media/pci/ivtv/ivtv-vbi.c`.
- **Standalone.** Not “patch X/Y”. ivtv is a parallel clone, not a
  prerequisite.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Pengpeng Hou: several small media correctness patches (ivtv twin, cec,
  v4l2-ctrls, stm32 resume errors). Not the cx18 maintainer.
- **Andy Walls** is listed maintainer for CX18; **Hans Verkuil** applied
  this (media co-maintainer). That is a strong apply-path signal.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** Touches only the for-condition. Parent still has
`compress_sliced_buf()`, `sliced_vbi_eav_rp[]`, and `i < size`. Applies
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig -c bf533acaaa7de:** match
  https://patch.msgid.link/2026063007035519.3-ccfa108-0014-media-
  cx18-stop-VBI-start-c-pengpeng@iscas.ac.cn
- **b4 dig -a:** **v1 only** (2026-06-30). Applied version is that v1.
- **b4 dig -m:** mbox is the original submission only — commit body +
  1-line diff. **No replies, NAK, or on-list review.**
- lore.kernel.org HTTP: Anubis 403. Discussion beyond the mbox is
  **UNVERIFIED** via WebFetch.
- Hans Verkuil’s SOB is the review/apply signal.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (**b4 dig -w**):
- To: Andy Walls (CX18 maintainer), Mauro Carvalho Chehab
- Cc: linux-media, linux-kernel
- Applied by Hans Verkuil. Right lists/maintainers were CCd.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No Reported-by, no syzbot, no bugzilla Link.** Looks like
static/code inspection, not a user crash. Twin ivtv patch supports that.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Independent `[PATCH]` plus independent ivtv twin (`…-0015-media-
ivtv-…`). No hidden series dependency. This commit is self-contained.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** (lore/stable search blocked). Local history has
no stable-discussion commit for this subject. No evidence it was
rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`compress_sliced_buf()`** only.

Step 5.2: TRACE CALLERS
Record (grep, not semcode — semcode MCP not available):
- `compress_sliced_buf()` ← `_cx18_process_vbi_data()` when **not** raw
  VBI
- `_cx18_process_vbi_data()` ← `cx18_process_vbi_data()` per buffer on a
  VBI MDL
- `cx18_process_vbi_data()` ← `cx18_fileops.c` on userspace read of VBI,
  or internal VBI while reading MPEG (`CX18_F_S_INTERNAL_USE`)
- **Context:** process context, V4L2 read/DQBUF — not IRQ. User-
  reachable with sliced VBI capture on cx18.

Step 5.3: TRACE CALLEES
Record: start-code compare; later `v4l2_subdev_call(...,
decode_vbi_line)` and `memcpy` of 42 bytes. The changed loop only
searches; it does not decode until a full line is found.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
`VIDIOC_QBUF/read` → `cx18_dequeue` → `cx18_process_vbi_data` →
`_cx18_process_vbi_data` → `compress_sliced_buf`
- **Userspace-reachable:** yes, with this card and sliced VBI.
- Unprivileged: only with access to the V4L device node (typical video
  group / capture app).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same bug in **ivtv** `compress_sliced_buf()`; already fixed with
`i + 3 < size`. No other `i + 3 < size` hits under `drivers/media`.
Systematic cloned-driver bug, both fixed.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- **Tree:** `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` = **7.3.0-rc4**
- Driver and function exist: `drivers/media/pci/cx18/cx18-vbi.c`
- **This commit is already an ancestor of HEAD** (`git merge-base --is-
  ancestor bf533acaaa7de HEAD` succeeded)
- First mainline tag containing it: **`v7.3-rc1`** (`git describe
  --contains --match 'v*'`)
- **Buggy bound `i < size` is in the parent** `bf533acaaa7de^`; it is
  not a post-7.3 invention
- Introduced **2008/2009**, so every current stable series that still
  has cx18 has the bug unless this commit was backported
- Already-in-HEAD on **mainline 7.3-rc4** is expected; it is not
  “already selected for stable”

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Surrounding function is stable since 2009 aside
from macros/email/SPDX. Stable trees with `i < size` get a 1-line
conflict-free change.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This is the fix. No earlier alternate bound check. ivtv twin is
a different driver.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- **Subsystem:** media / PCI V4L2 — Conexant CX23418 (Hauppauge HVR-1600
  and similar)
- **Criticality: PERIPHERAL** — old PCI capture card, not mm/net/VFS
- `CONFIG_VIDEO_CX18`; maintainer Andy Walls; list linux-media

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: **Mature/quiet.** Recent cx18 commits are treewide/API; this is
one of the few real local bugfixes. Long-lived bug, not churn from a
rewrite.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific:** `CONFIG_VIDEO_CX18`,
sliced VBI (not raw). Population is small (HVR-1600-class cards) but
real.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: sliced VBI processing when the 4-byte EAV (`0xff 00 00
  {0xb0,0xf0}`) is not found before the tail — then the loop runs to EOF
  and over-reads
- How common: every sliced-VBI buffer that lacks a match in-range; with
  valid hardware the match is usually early
- Unprivileged: only via the V4L node, not a generic syscall primitive
- Not a race

Default buffer sizing (verified):
- `stream_buf_size[VBI] = VBI_ACTIVE_SAMPLES * 36` = **1444 × 36 =
  51984**
- Sliced MDL: NTSC **9792**, PAL **12496**; `bufs_per_mdl = 1`
- `buf->buf = kmalloc(s->buf_size)` (51984); DMA/`bytesused` ≈ mdl_size
  (~10–12K)
- Default: 1–3 bytes past `bytesused` are **still inside the kmalloc
  object** (not a KASAN slab redzone hit)
- If `bytesused == buf_size` (full buffer), it **would** be a true
  allocation over-read

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** 1–3 byte read past valid DMA `bytesused` while
  matching start codes (result not copied to userspace)
- Default config: no crash, no leak to userspace, no functional change
  (tail false-match still leaves size ≪ line_size)
- Edge: true slab/page OOB / oops if used size equals allocation
- **Severity: MEDIUM** as memory-safety/correctness; **not CRITICAL**
  (no demonstrated panic/corruption). Still a real OOB class bug.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** closes a long-standing OOB read on a live capture path;
  low user count
- **Risk: very low** (1 line, loop bound only)
- **Ratio:** favorable — tiny risk, real bounds bug, same pattern
  already used on ivtv

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR backporting:**
- Real 4-byte peek past `size`; classic OOB-read class used in stable
- One line, obviously correct, no API/feature
- Code has been in-tree since 2008/2009; no missing prereqs
- Userspace-reachable sliced VBI on cx18
- Applied by Hans Verkuil; CX18 maintainer CCd
- Twin ivtv fix confirms the pattern
- Regression risk essentially zero

**AGAINST:**
- No syzbot/user/crash report
- Peripheral 2008 PCI encoder, small population
- Default kmalloc (52K) ≫ typical `bytesused` (~10K), so default may not
  oops
- No Fixes/Cc:stable (not a veto here)
- Not core mm/fs/net

**UNRESOLVED:**
- lore/stable threads beyond b4 mbox (Anubis)
- No sanitizer report found

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — bound is locally checkable;
   accepted by media maintainer (no extra Tested-by)
2. Fixes a real bug that affects users? **PASS** — over-read of the VBI
   payload bound on a real capture path
3. Important issue? **PASS** (medium) — memory-safety OOB; crash only if
   used size equals allocation; still the OOB class stable takes as
   small driver fixes
4. Small and contained? **PASS** — 1 line, 1 function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — already in this 7.3-rc4 tree;
   parent form applies cleanly wherever `i < size` remains

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **None** (not ID/quirk/DT/build/doc). Qualifies as a normal
small bugfix.

Step 9.4: MAKE YOUR DECISION
This tree is mainline **7.3-rc4**, which already contains the fix
(landed in **v7.3-rc1**). The evaluation is technical merit for stable,
not “re-apply on 7.3”.

The bug is a one-byte-stride scan of a four-byte start code with `i <
size`, present since 2008/2009. The patch is the standard remaining-
bytes fix. It does not add features, does not need other commits, and
will not regress the later line parser.

Default cx18 VBI buffers make a crash unlikely, but it is still a real
bounds bug on a user-triggerable path, with ~zero backport risk. That is
enough for YES on this tree’s stable-candidate criteria.

------------------------------------------------
What the commit solves for stable users
`compress_sliced_buf()` must see `buf[0]..buf[3]`. With `i < size`, the
last three iterations read past `bytesused`. Stopping at `i + 3 < size`
prevents that. Users with Hauppauge HVR-1600-class cx18 cards doing
sliced VBI (or MPEG with inserted VBI) no longer walk off the valid DMA
tail.

Stable rules / risk
Meets the rules: obvious, small, no new API, real OOB. Benefit is modest
(niche driver, default alloc has slack); risk is negligible. Prefer
taking a 1-line memory-safety fix over leaving a 17-year over-read.

Concerns
None for apply/prereqs. Not a sanitizer/CVE-backed crash. ivtv twin is
separate. This 7.3-rc4 checkout already has the commit; older stables
still on `i < size` are the backport targets.

Verification:
- [Phase 1] Subject/tags: media/cx18 “stop”; SOBs Hou + Verkuil; no
  Fixes/Reported-by/Link/Cc:stable
- [Phase 2] Diff: `drivers/media/pci/cx18/cx18-vbi.c`
  `compress_sliced_buf()` `i < size` → `i + 3 < size` (1/1)
- [Phase 2] Confirmed `buf[0]..buf[3]` vs exclusive `size`; post-loop
  `size < line_size` still holds if no match
- [Phase 3] `git blame`: loop from `1c1e45d17b663d` (2008) /
  `4ab9b256b5908a` (2009); fix `bf533acaaa7de`
- [Phase 3] `git show bf533acaaa7de^`: parent still has `i < size`
- [Phase 3] Sibling `f373cf17fb8e7` ivtv same change; author log shows
  both
- [Phase 4] `b4 dig -c`: lore msgid `2026063007035519.3-ccfa108-0014-…`;
  v1 only; mbox = patch, no replies
- [Phase 4] `b4 dig -w`: Walls, Chehab, linux-media, linux-kernel
- [Phase 4] WebFetch/WebSearch lore: **UNVERIFIED** (Anubis 403)
- [Phase 5] Callers: `_cx18_process_vbi_data` ← `cx18_process_vbi_data`
  ← `cx18-fileops.c` VBI/MPEG read
- [Phase 5] `i + 3 < size` only in cx18-vbi.c and ivtv-vbi.c
- [Phase 6] `git describe HEAD` v7.3-rc4-27; kernel 7.3.0-rc4; `merge-
  base --is-ancestor bf533acaaa7de HEAD` true; `--contains` v7.3-rc1
- [Phase 6] File present; apply would be clean on `i < size`
- [Phase 7] CONFIG_VIDEO_CX18; MAINTAINERS Andy Walls; mature driver
- [Phase 8] buf_size 1444*36=51984; sliced mdl_size 9792/12496;
  kmalloc(buf_size) so default over-read stays in-object
- [Phase 8] Failure: OOB read, severity MEDIUM; risk very low
- UNVERIFIED: on-list review beyond Hans’s SOB; stable@ discussion;
  KASAN/syzbot report

**YES**

 drivers/media/pci/cx18/cx18-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index 8dc4ce3259353..3a8430f3259eb 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -135,7 +135,7 @@ static u32 compress_sliced_buf(struct cx18 *cx, u8 *buf, u32 size,
 				    : VBI_HBLANK_SAMPLES_50HZ;
 
 	/* find the first valid line */
-	for (i = hdr_size, buf += hdr_size; i < size; i++, buf++) {
+	for (i = hdr_size, buf += hdr_size; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] &&
 		    (buf[3] == sliced_vbi_eav_rp[0] ||
 		     buf[3] == sliced_vbi_eav_rp[1]))
-- 
2.53.0

