Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694B5938D9;
	Mon, 19 Oct 2026 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418339; cv=none; b=ak3brZTXH11fjST4tU/qVO5Gr8g4thzM/J3h/NWi04IErqRY3sK0ox6aT08X3R0eHCGpAigDgWOa17QYRIeSAJArsQJGZFqlaPI1W9l5m4UyvTFFWziQNXa3uTkplZ8Yil17ltu42ADsm9c3XnAVpjaS2O737q6mOYzynt8FMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418339; c=relaxed/simple;
	bh=p+4oUslT8JyTnI5db81Mz0p1bCz3UbZGm6komxtnaDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vER+7CshB9hImWo3vndfC1q8ICjHBs/hq02gjQhsDqlL5vpTVvGqznGM4qi1bs4giwHodKGw615N+U57QVI5cilKro5sPeCIbxtMeMuXfDe3Fy7ZjthaEjWMjWTCCALVDwqbB7GlqR18kIi1cUWmxVvPxWWr+K6EEEcy6iKRajM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCumNmWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCumNmWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D5D1F000C9;
	Mon, 19 Oct 2026 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418336;
	bh=MS8pmardBEX2l3RcjTmGxnUsx1lLEKzZ591tCruACIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCumNmWBlaGuj7DfutqjSE+YoOA57c6YFPT9Yqpfd0/zHFKas1Uvayn2FXO0K3iO9
	 3EaPbmM0LdB5X9uoeeVevi3Nr33PNkb5rsB5RWKSFqCEBs0Hrs2TY8bonU5bTx5ggS
	 WrzcMstwg6qwBY/Vj81zXwX1FihSDbKTzF3WnqF0Q+AkOrHjSLRAofIoFvtTQg2mOe
	 ic6XsgkO07XEb+B2svnnrdK3v1+XqngBaDKPsbeae31f/ON7xHzi3cH55UNqNJcggS
	 DzRmrHbAxBztaTmvvFlYFcER6hVBb5/v46mu8T3pp2iPfvxJ6bcZasOVTCon86U0cq
	 EyHpGrNNKtrNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: Fix kobject cleanup in xcp sysfs
Date: Mon, 19 Oct 2026 09:47:46 -0400
Message-ID: <20261019135441.1420968-175-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 62d8b452615fd7a61976a1372bb81937807968c3 ]

Fix the indexing issue. Release the kobject whose init/add failed, and
unwind the successfully added ones.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The buggy XCP sysfs cleanup is present
here; the patch is a small, obviously-correct error-path kobject
leak/WARN fix, so it should be backported.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/amdgpu] [Fix] kobject cleanup in xcp sysfs** — intended
to correct failed/partial kobject teardown for compute-partition sysfs.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reviewed-by:** Alex Deucher `<alexander.deucher@amd.com>` (amdgpu
  maintainer)
- **Signed-off-by:** Lijo Lazar `<lijo.lazar@amd.com>` (author)
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>`
- Ignore pipeline tags: `[Upstream commit
  62d8b452615fd7a61976a1372bb81937807968c3]`, `Signed-off-by: Sasha
  Levin`
- **No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable** (absence
  is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** “indexing issue” in XCP sysfs kobject unwind; failed
  `kobject_init_and_add()` is not released; successfully added kobjects
  are not unwound.
- **Symptom:** leaked kobjects / leftover sysfs on the init error path;
  extra `kobject_put()` on the failed object when the loop runs with `i
  >= 2`.
- **Version info in message:** none.
- **Root cause (author):** wrong index in the cleanup loop, plus missing
  `kobject_put()` for the kobject whose init/add failed.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Subject and body state a real cleanup bug. The
original loop `for (j = 0; j < i; j++) { xcp_res = &xcp_cfg->xcp_res[i];
... }` using **`i` instead of `j`** is a copy-paste error, not style
cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c` — **+5 / −3** (net
  +2)
- **Function:** `amdgpu_xcp_cfg_sysfs_init()`
- **Scope:** single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (verified against parent `6a08c18ac122` / `v6.18.53`):
1. Drop unused `j` after the loop rewrite.
2. On `kobject_init_and_add()` failure: **before** `goto err` with no
   put; **after** `kobject_put(&xcp_res->kobj)` then `goto err` (matches
   `kobject_init_and_add()` docs: put is required even on failure
   because `kobject_init()` already ran).
3. Unwind loop: **before** `for (j = 0; j < i; j++)` always uses
   `xcp_res[i]` (the failed slot), never `xcp_res[j]`; **after** `while
   (i--)` puts indices `i-1 … 0` (the successfully added ones).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Error-path resource leak + incorrect kobject put** (refcount
WARN / leak).
- `kobject_init_and_add()` always inits; a failed add still needs one
  `kobject_put()`.
- The old loop used `i` instead of `j`, so it never released successful
  children and, when `i >= 2`, put the **same** failed kobject `i`
  times.
- `num_res` is `ARRAY_SIZE(max_res)` = `AMDGPU_XCP_RES_MAX` = **4**
  (`aqua_vanjaram_get_xcp_res_info()`), so `i` can be 2 or 3.
- First extra put: `kref` hits 0 → `kobject_cleanup()` (name freed).
  Further puts: `refcount_dec_and_test()` on 0 → **refcount underflow
  WARN**. Successful children and the parent `xcp_cfg` leak because
  those child refs are never dropped.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. Success path unchanged. `while
(i--)` after putting the failed index is the usual pattern (`i=0` does
not unwind further). Regression risk is **low** (error path only; no
API/lock/hot-path change). `xcp_cfg_res_sysfs_ktype` has no `.release`
(embedded kobject); putting it only cleans kobject state, it does not
`kfree` the parent — that is correct.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy loop introduced in **`4ae86dc878504`** (“drm/amdgpu: Add
sysfs nodes to get xcp details”, Lijo Lazar, 2024-09-09). `git describe`
→ `v6.11-rc7-1469-g4ae86dc878504`; contained in **v6.12**. Present in
this 6.18 tree (`git merge-base --is-ancestor 4ae86dc878504 HEAD`
succeeded).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is in this tree. No
later same-file fix for this indexing bug besides this candidate.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Nearby history is XCP sysfs feature work (`10072642541bd`,
`04e9101766dfe`, `cbbab29246c8b`) plus unrelated RAS/bounds fixes. This
is **standalone**, not `patch X/Y`. No extra prerequisite refactor is
required for the hunk.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Lijo Lazar is a regular amdgpu/XCP contributor and authored the
original sysfs nodes. Alex Deucher (maintainer) reviewed and signed off.
Related author work on this file is XCP feature/fix traffic, not a
hidden series dependency for this hunk.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Diff only uses existing `kobject_init_and_add` / `kobject_put`
and the existing `err` label. **Applies standalone.** Upstream SHA
`62d8b452615fd7a61976a1372bb81937807968c3` is **not** an ancestor of
this 6.18 HEAD (expected; it is a later mainline commit).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 62d8b452…` →
  https://patch.msgid.link/20260617085435.723531-1-lijo.lazar@amd.com
- `b4 dig -a`: **v1 only** (2026-06-17), no v2/v3.
- Thread (mbox): body matches the committed message; **Alex Deucher
  Reviewed-by**; **no NAK**.
- WebFetch of lore.kernel.org returned **403**; discussion recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To `amd-gfx@lists.freedesktop.org`; Cc Hawking
Zhang, Alexander Deucher, Asad Kamal, Candice Li. Maintainer reviewed.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by / syzbot / bugzilla. Found by code inspection of
the unwind path. No user crash log.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone single patch, not a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org/stable WebFetch returned 403.
No `Cc: stable` in the amd-gfx mbox.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `amdgpu_xcp_cfg_sysfs_init()` only.

**Step 5.2: TRACE CALLERS**
Record:
- `amdgpu_xcp_cfg_sysfs_init()` ← `amdgpu_xcp_sysfs_init()`
  (`amdgpu_xcp.c`)
- ← `amdgpu_device.c` (~line 4948) during device init, with other amdgpu
  sysfs setup
- Early-out if `!adev->xcp_mgr`

**Step 5.3: TRACE CALLEES**
Record: `kobject_init_and_add`,
`sysfs_create_files`/`sysfs_create_file`, `amdgpu_xcp_get_res_info`,
`kobject_put`, `sysfs_remove_*`. No new locks or allocations besides
existing ones.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: GPU probe/init for devices that create `xcp_mgr`. That is
**`aqua_vanjaram_init_soc_config()`**, only for **GC IP 9.4.3, 9.4.4,
9.5.0** (MI300/MI325/MI350-class Instinct). Userspace cannot directly
call this; trigger is `kobject_init_and_add()` failure (ENOMEM / name
collision) during driver load. Function is `void`; probe **continues**
even on failure, so leaked objects live until unload/reboot.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: No remaining `for (j = 0; j < i; j++)` in this file.
`amdgpu_xcp_cfg_sysfs_fini()` iterates `0 .. num_res-1` correctly. Bug
is local to this init unwind.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Tree is `v6.18.53-5049-g0f0bdc2b0dffb` (`Makefile`
6.18.53, branch `autosel`). `v6.18.53:amdgpu_xcp.c` still has `int i, r,
j, rid, mode;`, `if (r) goto err;` without put, and `for (j = 0; j < i;
j++)` using `xcp_res[i]`. Introduced in v6.12-era commit
`4ae86dc878504`, ancestor of 6.18.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Same function, same loop, same identifiers.
Context in 6.18 uses `kzalloc(sizeof(*xcp_cfg), GFP_KERNEL)` rather than
a later `kzalloc_obj` helper; that is outside the hunk. No conflicting
refactor in this file for these lines.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other commit on this file fixes this indexing/put bug.
`v6.18.53` does not contain the fix (`git merge-base --is-ancestor
4fbcdfa45e537 v6.18.53` failed).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drm/amdgpu XCP (compute partition) sysfs.** Criticality:
**IMPORTANT** for MI300-class GPU servers; **PERIPHERAL** for typical
desktop/laptop amdgpu. Not mm/VFS/net core.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: amdgpu/XCP is actively developed in this tree, but this
particular unwind has been wrong since the 6.12-era feature landed — a
long-standing bug, not last-month code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver/platform-specific** — AMD Instinct GC 9.4.3/9.4.4/9.5.0
with `xcp_mgr`. Consumer GPUs without XCP are unaffected (`if
(!adev->xcp_mgr) return`).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: `kobject_init_and_add()` failure while creating
`compute_partition_config/{xcc,dma,dec,jpeg}` during probe. **Uncommon**
(ENOMEM or sysfs name clash). Not a hot path; not directly triggerable
by an unprivileged syscall except via memory pressure during driver
load. Timing race: no.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Leak of child kobjects + parent `xcp_cfg` (sysfs leftovers; `xcp_cfg`
  never stored so `fini` cannot recover it).
- If failure is at `i >= 2`: **refcount underflow WARN** on repeated put
  of the failed kobject.
- Not a happy-path oops, deadlock, or filesystem corruption.
- Severity: **MEDIUM–HIGH** on that error path (WARN + leak), **LOW**
  frequency.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium for affected GPUs — correct teardown, no leftover
  sysfs, no refcount WARN; zero effect on the success path.
- **Risk:** very low — 5-line error-path-only change, maintainer-
  reviewed.
- **Ratio:** favorable for stable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, obvious bug: cleanup loop uses `i` not `j`.
- Missing `kobject_put()` after failed `kobject_init_and_add()`
  (documented API contract in `lib/kobject.c`).
- Can leak kobjects/sysfs and, for `i >= 2` of 4 resources, trigger
  refcount underflow WARN.
- Tiny (+5/−3), success path untouched.
- Buggy code has been in tree since ~v6.12 and **is in 6.18.53**.
- Reviewed-by amdgpu maintainer; standalone; applies cleanly.

AGAINST:
- Error path only; `kobject_init_and_add()` rarely fails.
- Init function is `void`; probe does not fail, so users may not notice.
- Limited to XCP-capable Instinct GPUs.
- No syzbot/user report, no Fixes:/Cc: stable (not a negative by
  itself).
- One-time probe leak, not a hot-path leak.

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403).
- Could not use semcode (namespace not present).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic matches kobject rules;
   maintainer Reviewed-by.
2. Fixes a real bug that affects users? **PASS** — wrong unwind is in
   6.18; MI300-class systems hit this init.
3. Important issue? **PASS** — leak plus possible kernel refcount WARN;
   not a universal panic, but a real stability/correctness bug on a
   production GPU path.
4. Small and contained? **PASS** — 8-line hunk, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy code is in `v6.18.53`;
   context matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to **this** 6.18.y tree. The indexing bug is
unambiguous, the missing put is required by the kobject API, the change
is surgical, and the code has been wrong for the entire lifetime of this
sysfs feature in 6.18.

**What it solves for stable users:** On MI300-class amdgpu probe, if
creating a partition-config resource kobject fails, 6.18 currently leaks
the kobjects that did get added (and can WARN on extra puts of the
failed one). The fix releases the failed kobject and actually unwinds
`0..i-1`.

**Risk vs benefit:** Benefit is correct error-path teardown with no
success-path behavior change; risk is negligible.

**Concerns:** Trigger is uncommon; impact is limited to XCP GPUs. That
does not make the patch unsuitable — it applies cleanly and does not
need other commits.

Verification:
- [Phase 1] Tags: Reviewed-by Alex Deucher; SOB Lijo Lazar + Deucher; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: `amdgpu_xcp_cfg_sysfs_init()` +5/−3; add `kobject_put`
  on failed init/add; `for (j=0;j<i;j++)` + `xcp_res[i]` → `while (i--)`
- [Phase 2] Parent dump of `amdgpu_xcp.c` confirmed the `i`-instead-
  of-`j` bug
- [Phase 2] `lib/kobject.c`: `kobject_init_and_add()` inits then adds;
  comments require `kobject_put()` on error
- [Phase 2] Extra puts hit `refcount_dec_and_test()` underflow WARN
  (`include/linux/refcount.h`)
- [Phase 3] `git blame` on parent: lines from `4ae86dc878504` (v6.12
  era)
- [Phase 3] `git merge-base --is-ancestor 4ae86dc878504 HEAD` → yes;
  `62d8b452` not ancestor of this 6.18 HEAD
- [Phase 3] `git log --oneline -20 -- amdgpu_xcp.c`: standalone, not a
  series
- [Phase 4] `b4 dig -c 62d8b452`: lore msgid
  20260617085435.723531-1-lijo.lazar@amd.com
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: amd-gfx + Deucher et al.
- [Phase 4] mbox: Deucher Reviewed-by; no NAK; no stable nomination
- [Phase 4] lore.kernel.org WebFetch 403 — UNVERIFIED for stable@
  archive
- [Phase 5] callers: `amdgpu_xcp_sysfs_init` ← `amdgpu_device.c` probe;
  `xcp_mgr` only from `aqua_vanjaram_init_soc_config` for GC
  9.4.3/9.4.4/9.5.0
- [Phase 5] `num_res = ARRAY_SIZE(max_res)` = `AMDGPU_XCP_RES_MAX` = 4
- [Phase 5] no semcode — used grep/read
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` 6.18.53
- [Phase 6] `git show v6.18.53:amdgpu_xcp.c` still has the buggy loop
- [Phase 8] Failure: leak + possible refcount WARN on probe error path;
  not a common-path oops
- UNVERIFIED: whether stable@ ever discussed this commit (lore 403)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index 1083db8cea2eb..6059227c53150 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -901,7 +901,7 @@ static void amdgpu_xcp_cfg_sysfs_init(struct amdgpu_device *adev)
 {
 	struct amdgpu_xcp_res_details *xcp_res;
 	struct amdgpu_xcp_cfg *xcp_cfg;
-	int i, r, j, rid, mode;
+	int i, r, rid, mode;
 
 	if (!adev->xcp_mgr)
 		return;
@@ -947,14 +947,16 @@ static void amdgpu_xcp_cfg_sysfs_init(struct amdgpu_device *adev)
 					 &xcp_cfg_res_sysfs_ktype,
 					 &xcp_cfg->kobj, "%s",
 					 xcp_res_names[rid]);
-		if (r)
+		if (r) {
+			kobject_put(&xcp_res->kobj);
 			goto err;
+		}
 	}
 
 	adev->xcp_mgr->xcp_cfg = xcp_cfg;
 	return;
 err:
-	for (j = 0; j < i; j++) {
+	while (i--) {
 		xcp_res = &xcp_cfg->xcp_res[i];
 		kobject_put(&xcp_res->kobj);
 	}
-- 
2.53.0

