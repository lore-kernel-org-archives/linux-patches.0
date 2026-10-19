Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F01621516;
	Mon, 19 Oct 2026 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418684; cv=none; b=fVp3XriJFX1UdjutMz/c64/ND4C34VYDLRKD2I//2NoXI+sbYYk9FMNjg+4R3w6X/nGmcBj/HVv9ocOlKkwrtXUX4qf+A4Gp8zMN+5axmsLSOyDDHv5K+h25cn/m720tHYFO9LvWor5LCMEirIiOPlNpG4qUWtd9wADvLTKsLYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418684; c=relaxed/simple;
	bh=m+RSTR09BlGt5wD4eoZ4CFruZ0+2Oa8TtInUWskHhE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RHn0M2UKKq21hqBqaFj+TuFuWfqETzQ7g1yedEpmL+rmucowm+fNZm2DUX7V6ssFTn1t57c70Z5hMo0y5mIZ1U7GHnYHWHkPfD0a4+Qimf14OM8S5/XKYSV0MzpXjUIXGOtYaJFtIZH5QEtRgrP4yGtasgEOzBuYjkvHplkxMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z781MwwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z781MwwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7AF1F000C6;
	Mon, 19 Oct 2026 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418681;
	bh=qs6PIHfEwxs6hrxo+YZEdqNmskDll6A50DsVfWY1k6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z781MwwYHKfIUu4CpzI1qY39t6SleU/WomiUQdvw6rst1RxZZVXftMdGzHg71qUch
	 gc5BloDOBJlSaXacfOn5Cyc3H57vkfvyG8Efv6xDcL8HMUAqdmyzV1ua0yONc2Vl9s
	 X88Z75y53dKEcxt3vEDEXPX2NU1Obvd/3qM0/EsHluWf+qbvlWPsZCoGylDPKzXMBI
	 QJs65l5GCsgGGf9FJSfno99zcITZ8AlCw5NB9KAJvWs+sgiiBeqhNAiGEeNFa2t3hH
	 qOW4U50NE97SIZPLejrd6HJa43BgPmYLfhNlb0tkFaGOc7hk1Xj/LCw2vWChfPCmeK
	 UJbA3KTUzdF9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruoyu Wang <ruoyuw560@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ntfs3: initialize err in attr_wof_frame_info
Date: Mon, 19 Oct 2026 09:51:52 -0400
Message-ID: <20261019135441.1420968-421-sashal@kernel.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit dd64afb32c4d8d3c934ae84df59a2e463d6fa43c ]

attr_wof_frame_info() may reuse a cached offsets folio. In that case the
loop can fill the output offsets without calling attr_load_runs_range()
or ntfs_read_run(), leaving err uninitialized before the common return
path. Initialize err to 0 for the successful cached path.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
change is a one-line init of `err` in `attr_wof_frame_info()` so a
cached WOF offsets folio does not return stack garbage; that path is in
this tree and is a real user-visible bug.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[ntfs3] [initialize] initialize `err` in
`attr_wof_frame_info`**
- Subsystem: `ntfs3` (NTFS3 filesystem)
- Action verb: **initialize** (classic uninitialized-variable fix
  language)
- Claimed intent: set `err` so the cached-folio success path does not
  return an uninitialized value

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by: Ruoyu Wang** (author)
- **Signed-off-by: Konstantin Komarov** (ntfs3 maintainer; applied the
  patch)
- **No Fixes:** tag (expected for this review pipeline)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by**
- **No Link:** / **no syzbot**
- **No Cc: stable** (expected; not a negative)
- Ignore pipeline-added Sasha Levin SOB / Upstream markers (none present
  on the real commit)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `attr_wof_frame_info()` can reuse a cached offsets folio
  (`ni->file.offs_folio`). On that path the loop fills `off[]` from the
  cached page and never calls `attr_load_runs_range()` /
  `ntfs_read_run()`, so `err` is never written.
- **Symptom:** common `return err` then returns uninitialized stack
  memory. Callers treat any non-zero as failure → spurious I/O errors on
  WOF LZX/Xpress compressed files after the first cache hit.
- **Version info:** none in the message. Code is present since ntfs3
  introduction.
- **Root cause:** `int i, err;` with `err` only assigned on I/O / alloc
  / corruption paths, not on cache-hit success.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not disguised.** This is an explicit uninitialized-variable
fix (`Initialize X`). Matches the KMSAN / uninit-use class even without
a sanitizer tag.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `fs/ntfs3/attrib.c` — **1 insertion, 1 deletion**
- Function: `attr_wof_frame_info()`
- Change: `int i, err;` → `int i, err = 0;`
- Scope: **single-file surgical fix** (one local initializer)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record (verified in current `fs/ntfs3/attrib.c`):
- Resident attribute path returns `0` directly; unaffected.
- Non-resident path:
  - Alloc fail: `err = -ENOMEM; goto out;`
  - I/O / metadata fail: `err = ...; goto out1;`
  - **Cache hit** (`index == folio->index`): loop reads offsets from the
    cached folio, never assigns `err`, then falls through to `*vbo_data
    += off[0]; *ondisk_size = off[1] - off[0];` and `return err;`
- **Before:** cache-hit success returned uninitialized `err`
- **After:** that path returns `0`

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** (e) Initialization / uninitialized data use
- **Mechanism:** stack `err` used as the function return value without
  assignment on the cached-folio success path
- **Not** a leak, race, refcount, or API change

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Obviously correct:** initializing `err = 0` is the right default;
  every error path still overwrites `err` before return
- **Minimal:** one token
- **Regression risk: very low** — does not change locking, structures,
  or successful I/O that already assigned `err`
- **Red flags:** none

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Current line is the fix: `dd64afb32c4d8` (Ruoyu Wang, 2026-06-18)
- Uninitialized `int i, err;` dates to **`be71b5cba2e648`** (“fs/ntfs3:
  Add attrib operations”, 2021-08-13)
- Contained in **`v5.15-rc1`** (`git describe --contains be71b5cba2e648`
  → `v5.15-rc1~...`)
- Folio conversion `c091354d6bf60e` (2024) kept the same uninit `err`;
  it did not introduce the bug
- The cached offsets page/`offs_folio` reuse path existed from day one

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Bug was in the original function, not a later
regression commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Nearby: `859d777646b56` (OOB write in same function), other ntfs3
  bounds/init fixes
- This commit is **standalone**, not “patch X/Y”
- No prerequisite refactor required for the one-line init

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Ruoyu Wang: this is their only commit under `fs/ntfs3/` in this tree
- Applied by **Konstantin Komarov** (ntfs3 maintainer) — maintainer-
  accepted

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Diff assumes only `int err` in `attr_wof_frame_info()` — present since
  v5.15
- **Applies standalone.** No new helpers or struct changes.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c dd64afb32c4d8` →
  https://patch.msgid.link/20260617182227.965603-1-ruoyuw560@gmail.com
- `b4 dig -a`: **v1 only** (no later revisions)
- Thread (mbox via `b4 dig -m`):
  - Patch submitted 2026-06-17 by Ruoyu Wang
  - Maintainer reply 2026-07-23: “The patch was applied, thank you.”
- **No NAK, no stable nomination, no reviewer risk flags**
- lore.kernel.org HTTP fetch returned **403**; thread recovered via b4
  mbox (verified)

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`):
- To/Cc: Konstantin Komarov, ntfs3@lists.linux.dev, linux-
  kernel@vger.kernel.org
- Subsystem maintainer was the recipient and applied it
- No extra Reviewed-by tags

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No Reported-by, no syzbot, no bugzilla.** Bug is from code
inspection / static reasoning, confirmed by reading the cache-hit path.
No user crash report found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: **Standalone v1 patch**, not part of a series.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable HTTP search returned **403**.
**UNVERIFIED** whether stable@ discussed this. b4 thread has no Cc:
stable. Absence of stable discussion is not a negative here.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`attr_wof_frame_info()`** only. Guarded by
`CONFIG_NTFS3_LZX_XPRESS`.

Step 5.2: TRACE CALLERS
Record:
- Sole caller: `ni_read_frame()` in `fs/ntfs3/frecord.c` (~2379), WOF
  (Xpress/LZX) branch
- `ni_read_frame()` callers:
  - `ni_read_folio_cmpr()` (`frecord.c` ~1987) — compressed `read_folio`
  - `ni_decompress_file()` (`frecord.c` ~2087) — decompress on
    write/size change
  - `ntfs_file_write_iter` path in `file.c` (~1056, ~1121) — extending
    valid size / writing compressed files
- `ntfs_read_folio()` (`inode.c` ~850) calls `ni_read_folio_cmpr()` when
  `is_compressed(ni)`

Step 5.3: TRACE CALLEES
Record (success cache path does not call these):
`attr_load_runs_range()`, `ntfs_read_run()`, `folio_alloc()`, folio
lock/unlock, `down_write`/`up_write` on `ni->file.run_lock`. Bug is
return-value init, not those callees.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Userspace `read()` → VFS `read_folio` → `ntfs_read_folio()` →
  `ni_read_folio_cmpr()` → `ni_read_frame()` → `attr_wof_frame_info()`
- **Reachable from userspace** on NTFS volumes with Windows 10+
  `compact.exe` WOF files (`CONFIG_NTFS3_LZX_XPRESS`, Kconfig
  “recommended Y”)
- Cache is per-inode (`ni->file.offs_folio`); sequential reads of a
  compressed file hit the uninit path **after the first frame on that
  offsets page** (typical, not rare)

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: ntfs3 has many prior uninit fixes (`5f33da04e6cee` KMSAN,
`a8a3ca23bbd9d`, `57ac2831c8e0f`, etc.). Same class of bug; this
instance was missed until 2026.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion` = **7.3.0-rc4**
- `attr_wof_frame_info()` is present; current code already has `int i,
  err = 0;` (this commit is an ancestor of HEAD)
- **Buggy pattern existed here** from v5.15 through parent of
  `dd64afb32c4d8`
- Bug was **not** introduced after this tree; it is native to this
  lineage

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** One-line change to a declaration that has been
`int i, err;` since 2021. Folio vs page rename does not affect this
line.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This exact fix **is** commit `dd64afb32c4d8` in this checkout.
No different competing fix for the same uninit `err`. Per instructions,
that is not used as “already selected → skip”; it confirms the
maintainer accepted the same one-line change.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- **Subsystem:** `fs/ntfs3` (NTFS3 filesystem)
- **Criticality:** **IMPORTANT** — not core VFS/mm, but a production
  filesystem used for Windows volumes, dual-boot, and some distros.
  Failure is I/O error / failed reads, not a global panic.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active (regular `ntfs3_for_7.x` pulls, many 2026 fixes). This
particular bug is **old** (2021), not a new-subsystem-only issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Filesystem-specific + config-specific:** `CONFIG_NTFS3_FS` +
`CONFIG_NTFS3_LZX_XPRESS`, users reading WOF-compressed files (Windows
10 `compact` xpress4k/8k/16k/lzx).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: read (or decompress-on-write) of a **non-resident** WOF
  compressed stream after `offs_folio` already holds the needed offsets
  page
- **Common** for sequential reads of a compressed file (page holds many
  32/64-bit offsets)
- **Unprivileged users** can trigger it if they can read such files
- Not a race; deterministic once the folio is cached

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: return of uninitialized `err` to `ni_read_frame()` → `if
  (err) goto out1;`
- If stack garbage is non-zero: **read/decompress fails** (EIO-class
  userspace error) despite successful offset decode
- If garbage is zero: silent luck
- C2 unsafety / KMSAN-class uninit use
- **Severity: HIGH** (broken reads of compressed files; undefined
  behavior). Not a guaranteed oops, not data corruption of written data.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for ntfs3+WOF users — fixes real false I/O failures
  on a hot cached path
- **Risk:** very low (one initializer)
- **Ratio:** strongly favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real uninitialized return on a realistic, common cache-hit path
  (verified in source)
- Userspace-reachable via normal reads of WOF-compressed NTFS files
- One-line, obviously correct, maintainer-applied
- Code present in this tree since v5.15; no missing prerequisites
- Matches stable’s uninitialized-data / KMSAN class (even without a
  sanitizer report)

**AGAINST:**
- No crash/syzbot/CVE report; failure is typically spurious I/O error,
  not panic
- Limited to ntfs3 WOF (`CONFIG_NTFS3_LZX_XPRESS`), not all kernel users
- No explicit Cc: stable (not a valid NO reason in this pipeline)

**UNRESOLVED:**
- Could not HTTP-fetch lore.kernel.org (403); used b4 mbox instead
- No stable@ thread verified
- No KMSAN/syzbot report located for this exact function

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one initializer; maintainer
   applied it
2. Fixes a real bug that affects users? **PASS** — uninit `err` on
   cached WOF reads
3. Important issue? **PASS** — HIGH: failed reads / UB on compressed
   files (not a panic, but user-visible breakage)
4. Small and contained? **PASS** — 1 line, 1 function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — declaration exists; applies
   cleanly

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs exception. It is a normal uninit
bugfix.

Step 9.4: MAKE YOUR DECISION
This tree contains `attr_wof_frame_info()` and the cached-folio path.
The one-line init is a real, contained fix for returning uninitialized
error codes on WOF compressed reads. It meets stable-kernel rules for
this checkout.

**What the commit solves:** On cache reuse, `err` was never set, so the
function returned stack garbage. Callers abort the read. Initializing
`err = 0` makes the successful cached path return success.

**Risk vs benefit:** Benefit is fixing broken/undefined reads of WOF
files; risk is a single local initializer.

**Concerns:** None on dependencies or apply difficulty. Impact is
ntfs3+WOF only, which is acceptable for a filesystem correctness fix.

Verification:
- [Phase 1] Parsed tags: author + maintainer SOB only; no
  Fixes/syzbot/Cc stable
- [Phase 1] Subject/body: initialize `err` for cached offsets folio path
- [Phase 2] Diff: 1 line in `attr_wof_frame_info()`, `int i, err` → `int
  i, err = 0`
- [Phase 2] Confirmed cache-hit loop skips
  `attr_load_runs_range`/`ntfs_read_run` then `return err`
- [Phase 3] `git blame`: uninit `err` from `be71b5cba2e648` (v5.15-rc1)
- [Phase 3] Folio conversion `c091354d6bf60e` kept uninitialized `err`
- [Phase 3] Author: one ntfs3 commit; applied by Konstantin Komarov
- [Phase 3] Standalone; `git merge-base --is-ancestor dd64afb32c4d8
  HEAD` is true
- [Phase 4] `b4 dig -c`: lore msgid
  20260617182227.965603-1-ruoyuw560@gmail.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: maintainer + ntfs3 list + lkml
- [Phase 4] mbox: maintainer “patch was applied”; no NAK
- [Phase 4] lore HTTP 403 — discussion via b4 only
- [Phase 5] Only caller `ni_read_frame()`; chain from `ntfs_read_folio`
  / `ni_read_folio_cmpr`
- [Phase 5] semcode MCP not available; used grep/read
- [Phase 6] Local tree v7.3-rc4; function present; parent still had `int
  i, err;`
- [Phase 7] fs/ntfs3, IMPORTANT, actively maintained
- [Phase 8] Trigger: cached WOF offset folio on compressed file read;
  severity HIGH
- UNVERIFIED: stable@ mailing list discussion (HTTP 403)
- UNVERIFIED: no KMSAN/syzbot report found for this exact bug

**YES**

 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 501f2ec153ab8..e500f7be8cc38 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1410,7 +1410,7 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 	u8 bytes_per_off;
 	char *addr;
 	struct folio *folio;
-	int i, err;
+	int i, err = 0;
 	__le32 *off32;
 	__le64 *off64;
 
-- 
2.53.0

