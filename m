Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7411554707A;
	Mon, 19 Oct 2026 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418124; cv=none; b=DN59ESt2+fVQzq1NNStHVLdYUThQQUXObcO8l96cA4XneFg38CiC6a00654CXGlWM42R6KBD+GYIIhrLe4wxVlldql0UHz1dERtD6Pzm1+xg7sR8Ys27vH02EkwM3+JTIPANMG858iwvy+uu2DONIakpAcahPwJN4V0hjupzVMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418124; c=relaxed/simple;
	bh=ag1r3dO+hTmf5iGAASIFWIPuBw6QvX/U5lxznXVSzdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SzzuM3WOnKQxb84RSLps+abQWYdwfV/a8JFqKA9XAc4nt/ulRFEPBM6I0yRKqOk+nhgH+cU+zk4J62K/d7Sxa+z2y0dADxs8mEshYJOhMwXWCJCBjv2QrCjf3SmcVPz88g3SSubUyZHIt6Lj91XpSJffDjqTyjpA376pduYtDlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdwaVseF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdwaVseF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958F21F000C5;
	Mon, 19 Oct 2026 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418122;
	bh=Ch4WjkUqaDLEjPrlB74vPqJSfYLdXmGZs6MkatSbaW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdwaVseF4GJYMOj1mXNnoi5ucdJ/fwlsYE8t5XJtUcTvpPrVodLqkBg6rfa0+HfJh
	 iwHqIay7e+4kOI+bjUEwEXc9vc0/U7G+O9z0nGXiOQGWxxofIBj++0vVTy45Htb3Yj
	 Tkj74imQHOYKPiUm6vC0K+3/AajvNWE6VtJds5lXPftx639CLF6Gz1Q65x6SamFh+s
	 CawB/FmXlFK5hRaGHHsQDFByVabQw4P9j4KC9ckBPvk7aWra55tj0czbmwNBVu4akf
	 5Sl2dSotuQ5wrdkVEkJoF725QdDWOaYkHYlLI81UWlMfhaot2GQ8GRGCuLKIbu6SZS
	 ByiS65MUr2FjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	haver@linux.ibm.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] misc: genwqe: handle a first DMA address of zero
Date: Mon, 19 Oct 2026 09:45:18 -0400
Message-ID: <20261019135441.1420968-27-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit d401772a9e18e837631450844f835229354528a4 ]

genwqe_setup_sgl() uses zero as the initial previous DMA address. DMA
address zero is valid, so a first entry at that address enters the
merge path before last_s has been assigned and dereferences NULL.

Only merge adjacent mappings after an SGL data entry has been created.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Confirmed `GENWQE_EXECUTE_DDCB` is unprivileged on a 0666 device node.
Compiling the nine-phase analysis from the code, history, and review
trail.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [misc: genwqe] [handle] [avoid NULL deref when the first SGL DMA
address is zero]
Subsystem prefix `misc: genwqe:`. Verb “handle” is a fix-style verb.
Claimed intent: stop treating DMA address 0 as “no previous mapping.”

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com> (author)
- Link: https://patch.msgid.link/20260630104923.53827-1-
  alhouseenyousef@gmail.com
- Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> (char-
  misc maintainer; applied)
- No Fixes: tag (expected for this review pipeline)
- No Reported-by, Tested-by, Reviewed-by, Acked-by
- No Cc: stable@vger.kernel.org (expected; not a negative)
- Ignoring any Sasha Levin SOB (none on this commit)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `genwqe_setup_sgl()` initializes `prev_daddr = 0`. DMA address 0
  is valid. If the first mapping is at 0, `prev_daddr == daddr` is true
  while `last_s` is still NULL.
- Symptom/failure mode: NULL pointer dereference of `last_s->len`
  (kernel oops).
- Version information: none in the message. History shows the pattern
  dates to the original GenWQE driver (v3.14).
- Root cause: 0 used as a sentinel for “no previous DMA address,” which
  collides with a valid IOVA/physical DMA address.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit NULL-deref fix. The
wording “handle” / “only merge after an SGL data entry has been created”
matches the one-line guard.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/misc/genwqe/card_utils.c` (+1 / -1)
- Function: `genwqe_setup_sgl()`
- Scope: single-file, single-line surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
Before: on every mapping, `if (prev_daddr == daddr)` merges into
`last_s`. `prev_daddr` starts at 0, `last_s` starts NULL. First mapping
at DMA 0 takes the merge path and dereferences NULL.
After: `if (last_s && prev_daddr == daddr)` — merge only after a data
entry exists (`last_s` assigned at “start new entry”). First mapping
always creates an entry.

Verified in the current function:

```379:439:drivers/misc/genwqe/card_utils.c
        dma_addr_t prev_daddr = 0;
        struct sg_entry *s, *last_s = NULL;
        ...
                        if (last_s && prev_daddr == daddr) {
                                u32 prev_len = be32_to_cpu(last_s->len);
                                ...
                        }
                        /* start new entry */
                        s[j].target_addr = cpu_to_be64(daddr);
                        ...
                        last_s = &s[j];
```

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [NULL pointer dereference] [sentinel 0 vs valid DMA address 0].
`last_s` is only assigned when a new SG_DATA entry is created. Guarding
the merge with `last_s` skips merge until there is a real previous
entry.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct. `last_s == NULL` means there is nothing to
merge; skipping merge is the right first-entry behavior. One-line, no
API/locking/structure changes. Regression risk is very low: the only new
path is “first daddr==0 creates an entry instead of oopsing.” Later
adjacent merges still work once `last_s` is set.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Buggy `prev_daddr = 0`, `last_s = NULL`, and `if (prev_daddr ==
daddr)` come from 67f4addbb8fe68 (“GenWQE Utility functions”, Frank
Haverkamp, 2013-12-09). `git describe --contains` →
`v3.14-rc1~152^2~29`. Present for ~12 years. The fix line is
d401772a9e18e8 (this commit).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Original buggy commit is 67f4addbb8fe68,
confirmed ancestor of HEAD. No intermediate fix of this sentinel bug in
`drivers/misc/genwqe/`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `card_utils.c` history is mostly treewide
MAX_ORDER/docs/DMA API churn. This commit is the only functional SGL-
merge change. Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Yousef Alhouseen has this single genwqe commit. Not the listed
maintainer (Frank Haverkamp). Greg KH applied it through char-misc. No
related follow-up series from the same author in this tree.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. The change uses existing locals `last_s` and `prev_daddr`.
Applies standalone on any tree that still has the 2013
`genwqe_setup_sgl()` merge loop.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c d401772a9e18e837631450844f835229354528a4` → https://patch.m
  sgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
- `b4 dig -a`: v1 only, 2026-06-30; no v2/v3
- lore.kernel.org fetches returned 403; discussion recovered from
  https://lkml.iu.edu/hypermail/linux/kernel/2606.3/11318.html and
  https://lists.openwall.net/linux-kernel/2026/06/30/1334
- Message matches the committed diff. No NAK found in those archives.
  Greg applied it 2026-07-17 (char-misc), merged to Linus via `char-
  misc-7.3-rc1` (93e4b3076b5f, 2026-08-25).
- No reviewer “Cc: stable” in the archives that were reachable.
- UNVERIFIED: full lore reply chain (403). No public replies found on
  IU/openwall for this Message-ID.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc Frank Haverkamp (GENWQE maintainer), Arnd
Bergmann, Greg Kroah-Hartman, linux-kernel@. Applied by Greg (SOB). No
Reviewed-by/Acked-by on the commit.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, syzbot, or bugzilla. Bug is from code inspection
of the sentinel/NULL pattern, not a published crash report.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1 patch, not a series. `git log --grep` on
`drivers/misc/genwqe/` found no companion “DMA address zero” follow-up.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. UNVERIFIED whether
stable@ already discussed this specific commit. No local evidence it was
rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `genwqe_setup_sgl()` only. semcode MCP not available; identified
from the hunk header.

Step 5.2: TRACE CALLERS
Record: Single caller, `ddcb_cmd_fixups()` in
`drivers/misc/genwqe/card_dev.c` (ATS_TYPE_SGL_RD / ATS_TYPE_SGL_RDWR),
which is called from `genwqe_execute_ddcb()` → `do_execute_ddcb()` →
ioctl `GENWQE_EXECUTE_DDCB`.

Verified: `GENWQE_EXECUTE_DDCB` does **not** check
`capable(CAP_SYS_ADMIN)` (only `GENWQE_EXECUTE_RAW_DDCB` does).
`genwqe_devnode()` sets the char device mode to 0666. With CONFIG_GENWQE
and hardware present, an unprivileged process that can open
`/dev/genwqe*` can reach this path.

Step 5.3: TRACE CALLEES
Record: Builds hardware SG entries from `dma_list[]` (from
`dma_map_page()` in `genwqe_map_pages()`) or from `sgl->fpage_dma_addr`
/ `sgl->lpage_dma_addr` (`dma_alloc_coherent()`). first-page buffer:
`daddr = sgl->fpage_dma_addr + map_offs`. `dma_mapping_error()` treats
`~0` as error, not 0, so DMA address 0 is accepted as valid.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace ioctl → `ddcb_cmd_fixups` → `genwqe_setup_sgl`.
Reachable from userspace when the IBM GenWQE card is present. Trigger
is: first SGL data mapping has DMA address 0 (IOMMU IOVA 0, or coherent
alloc at 0). Not every I/O; depends on the DMA API returning 0. Failure
is an oops, not a WARN.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same file’s `genwqe_unmap_pages()` also treats `dma_list[i] ==
0` as end-of-list. That is a separate sentinel bug and is **not** fixed
here. It does not make this `last_s` guard wrong: `fpage_dma_addr` does
not go through `dma_list`, so a coherent mapping at 0 still hits the
NULL deref. No sibling functions needed the same one-line change.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion` → `7.3.0-rc4` (Linus mainline, not a -stable
  series)
- Driver and `genwqe_setup_sgl()` exist. Bug introduced in v3.14
  (67f4addbb8fe68), ancestor of HEAD.
- Candidate d401772a9e18 **is already an ancestor of HEAD** (expected:
  candidates are taken from this mainline history). The pre-fix
  condition is the historical `if (prev_daddr == daddr)` in this
  lineage.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Surrounding function is essentially unchanged since 2014
(`718f762efc4547` adjusted mapping sources). Expected apply: clean (1
line). No conflicting refactor in this file’s recent history.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This commit is the fix. No earlier alternative for the same NULL
deref. No later revert.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drivers/misc/genwqe — IBM GenWQE PCIe accelerator]
[PERIPHERAL]. CONFIG_GENWQE, depends on PCI && 64BIT. MAINTAINERS:
“Supported,” Frank Haverkamp.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Low churn; mostly treewide and small misc fixes. Mature driver,
bug long-standing rather than a new-feature regression.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: driver-specific / config-specific: users with IBM GenWQE
hardware and CONFIG_GENWQE. Not universal. Device node default 0666
widens who can issue the ioctl on those systems.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger: SGL DDCB ioctl whose first mapped DMA address is 0.
Uncommon without an IOMMU that issues IOVA 0; possible with
`dma_alloc_coherent`/`dma_map_page`. Not every boot. Unprivileged users
can issue `GENWQE_EXECUTE_DDCB` if they can open the device.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [NULL deref → kernel oops] [CRITICAL for affected systems]. No
data-corruption path identified beyond the crash itself.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: prevents oops on a valid DMA address; long-lived bug; ioctl-
  reachable. Benefit is high for GenWQE users, limited population.
- Risk: one-line pointer NULL check; very low.
- Ratio: favorable. Stable rules accept important crashes in drivers,
  not only core kernel.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR backporting:
- Real NULL deref, not style.
- DMA 0 is valid per the DMA API; using 0 as “no previous address” is
  wrong.
- One-line, obviously correct, no new API.
- Bug in code since v3.14; driver present in this tree.
- Userspace-reachable via `GENWQE_EXECUTE_DDCB` on a 0666 node without
  CAP_SYS_ADMIN.
- Applied by Greg KH; no NAK found.
- Applies cleanly; no prerequisites.

AGAINST:
- Peripheral IBM accelerator; few machines.
- No Reported-by/syzbot/crash log; trigger needs DMA address 0.
- Author is not the listed maintainer; no Reviewed-by.
- Separate `dma_list[i]==0` unmap sentinel remains (not a reason to skip
  this fix).

UNRESOLVED:
- Full lore thread (403).
- Whether stable@ already queued/rejected it (403).
- How often GenWQE + IOVA 0 occurs in production (unverified frequency;
  mechanism is verified).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — logic is local and correct;
   landed in char-misc/mainline. No extra Tested-by.
2. Fixes a real bug that affects users? PASS — NULL deref on a valid
   first DMA address 0.
3. Important issue? PASS — kernel oops (CRITICAL on that path).
4. Small and contained? PASS — 1 line, one function.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — same `genwqe_setup_sgl()`; no
   missing helpers. (This checkout already contains the commit because
   it is 7.3-rc4 mainline; that does not change merit for stable.)

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary memory-
safety bug fix.

Step 9.4: MAKE YOUR DECISION
This is a one-line NULL-deref fix in a driver that exists in this
lineage since v3.14. The bug is real: `prev_daddr` is initialized to 0
while `last_s` is NULL, so a first mapping at DMA address 0 takes the
merge path and crashes. That path is ioctl-reachable. The patch is
minimal and does not need prerequisites. Peripheral hardware limits the
user set, but stable regularly takes crash fixes in supported drivers.
Benefit (oops avoided) outweighs risk (trivial guard).

What the commit solves for stable users: a kernel oops in
`genwqe_setup_sgl()` when the first SGL fragment is at DMA address 0.

Meets stable rules: obviously correct, real crash, small, no new API,
applies to this driver’s long-standing code.

Risk vs benefit: very low risk, meaningful crash fix for GenWQE systems.

Concerns: uncommon trigger; no user report. Those do not override a
verified oops with a one-line fix. This 7.3-rc4 tree already contains
the commit as mainline history; the evaluation is technical fitness for
stable trees that still have the unguarded `prev_daddr == daddr` test.
The surrounding function matches that old code, so a backport does not
need extra commits.

Verification:
- [Phase 1] Parsed tags: author SOB, Greg KH SOB, msgid Link; no
  Fixes/Reported-by/Cc: stable
- [Phase 1] Body: first DMA 0 enters merge before `last_s` assigned →
  NULL deref
- [Phase 2] Diff: 1 line in `genwqe_setup_sgl()`: `if (prev_daddr ==
  daddr)` → `if (last_s && prev_daddr == daddr)`
- [Phase 2] Read `card_utils.c`: `prev_daddr = 0`, `last_s = NULL`,
  `last_s` set only on new SG_DATA entry
- [Phase 3] `git blame`: buggy code from 67f4addbb8fe68 (v3.14-rc1); fix
  is d401772a9e18
- [Phase 3] `git merge-base --is-ancestor 67f4addbb8fe68 HEAD`: yes;
  `d401772a9e18` also ancestor of HEAD
- [Phase 3] `git log --oneline -20 -- drivers/misc/genwqe/card_utils.c`:
  no prerequisite series
- [Phase 3] Author log: only this genwqe commit
- [Phase 4] `b4 dig -c d401772a9e18`: lore msgid 20260630104923.53827-1;
  v1 only
- [Phase 4] `b4 dig -w`: Haverkamp, Arnd, Greg KH, linux-kernel@
- [Phase 4] IU/openwall: patch text matches commit; no NAK found
- [Phase 4] lore/stable WebFetch: 403 — UNVERIFIED full review thread
  and stable@ discussion
- [Phase 5] grep: only caller `ddcb_cmd_fixups` → `GENWQE_EXECUTE_DDCB`
- [Phase 5] `GENWQE_EXECUTE_DDCB` has no CAP_SYS_ADMIN; `genwqe_devnode`
  sets 0666
- [Phase 5] `dma_map_page`/`dma_alloc_coherent` + `dma_mapping_error` do
  not reject address 0
- [Phase 6] `git describe HEAD`: v7.3-rc4-27; kernelversion 7.3.0-rc4;
  driver present
- [Phase 6] Apply difficulty: clean 1-line change vs 2013/2014 function
- [Phase 7] MAINTAINERS: GENWQE Supported, Frank Haverkamp
- [Phase 8] Failure mode: NULL deref oops, severity CRITICAL on that
  path
- UNVERIFIED: production frequency of DMA address 0 on GenWQE; full lore
  replies

**YES**

 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index a2c4a9b4f871c..e3b5fb337182e 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -413,7 +413,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			size -= size_to_map;
 			map_offs = 0;
 
-			if (prev_daddr == daddr) {
+			if (last_s && prev_daddr == daddr) {
 				u32 prev_len = be32_to_cpu(last_s->len);
 
 				/* pr_info("daddr combining: "
-- 
2.53.0

