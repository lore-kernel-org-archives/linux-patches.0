Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33CA5BC5AF;
	Mon, 19 Oct 2026 14:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418460; cv=none; b=f+LNPwUnt1HW9ZzA2FCslAPt8CyoG7QKW9yl54hPHhftKAB76qnO4v/z1HRMuwhcGtwS2wgnoxVEXqVD5ahXyOZQYNo5aeP3zemg9R74KgcdxVreJ9iJHWu8d1WDkM8ktJdnRsQ2gauCTK6aXLbJfIC78tSHdCnNtqU8610rnOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418460; c=relaxed/simple;
	bh=p6xL5iEyRC23PFPYnv1H0K/arg+o6dBqNWFGLi/PVuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sexGR0UJD3GJeNBwv23Mq91We1kpbv6ndVUK+Z/YzNymsyA2Kf8FPkI67KG+BLacR07LvDVvTOD9+NHdaKT14EcTDYxBXGZlNbKtKpbmfkyFuNEu7mmi0x7w+xvx1TKjhZf7FS6z9MYn6YDnh/HmP613sjNfamet31g6l53QvJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uj7/+35V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uj7/+35V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B9D1F000C9;
	Mon, 19 Oct 2026 14:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418458;
	bh=vmih4YEtyPerUsmZiKCYZilMhr6BxnBlF4yNVIMWQmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uj7/+35VfNzAS38g7cNUnf2rixe5xVDaUp3Pd0WJr9Gwz1jtZ62ckQJ6eGqmDXYAA
	 Wv/een0uz/B2ROt8qDfT1BLokOGHhaiTAus/JFtEx/jGsXfCswSNcxbJy8iqoV9dyX
	 7JbdDbp9kthtpGj99GKNiPCRyoeGKejT3d6Rsict/SdA6+g29REyWylVoc1S7/X37V
	 mLRz3FGsTzsyTUzNJfBmIPr82Vu0adDwIUiBL6V5T3lnDHTTsYkiln1DZWfo/RdGR6
	 pvSKfZll2LKqgabUv0mp/NfDVptUlrObTe5JSY74emgwLQB1GWYcYssKJio2Gj+X2P
	 SCmXjYxT67IGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gangliang Xie <ganglxie@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: add check for xcp id
Date: Mon, 19 Oct 2026 09:49:14 -0400
Message-ID: <20261019135441.1420968-263-sashal@kernel.org>
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

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit fa1531170d2c96060478d697fe93f1cafc0e7ddd ]

check sel_xcp_id before its use

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Confirmed: `ring->xcp_id` is `u32`, `AMDGPU_XCP_NO_PARTITION` is `~0`,
and the same OOB pattern is what the XCP maintainer later called out in
`release_sched`. The 6.18.53 function has no bounds check. Compiling the
full analysis.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[drm/amdgpu]** **[add/check]** Add a bounds check on
`sel_xcp_id` before using it as an index into `adev->xcp_mgr->xcp[]`.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Lijo Lazar \<lijo.lazar@amd.com\> (AMD
  XCP/partitioning reviewer; also reviewed the helper that introduced
  this function)
- **Acked-by:** none
- **Link:** none in the commit message
- **Cc: stable:** none (expected; not a negative signal)
- **Signed-off-by:** Gangliang Xie \<ganglxie@amd.com\> (author); Alex
  Deucher \<alexander.deucher@amd.com\> (amdgpu maintainer)
- Ignored pipeline tags: `[Upstream commit fa1531170d2c…]`, `Signed-off-
  by: Sasha Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug description:** `sel_xcp_id` is used as an array index without
  validation.
- **Symptom/failure mode:** not spelled out in the message (one-line
  body: “check sel_xcp_id before its use”). From the code, the failure
  is an out-of-bounds read/write of `xcp[sel_xcp_id]`.
- **Version information:** none in the message.
- **Root cause:** `amdgpu_xcp_gpu_sched_update()` indexes
  `adev->xcp_mgr->xcp[sel_xcp_id]` even when the ID is
  `AMDGPU_XCP_NO_PARTITION` (`~0`) or `>= MAX_XCP`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Yes — this is a memory-safety fix described as “add check”. Same
pattern as the author’s nearby “add buf length check” / “add first
record offset check” patches, and as Lijo Lazar’s explicit “bounds check
xcp_id in release_sched” (“Avoid out-of-bounds xcp[] access, e.g. when
xcp_id is AMDGPU_XCP_NO_PARTITION”).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c` (+3 / −0)
- **Function:** `amdgpu_xcp_gpu_sched_update()`
- **Scope:** single-file surgical fix (3 lines)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: **Before:** the function immediately does
`num_gpu_sched = &adev->xcp_mgr->xcp[sel_xcp_id].gpu_sched[...]` and
writes `&ring->sched` into that slot, incrementing `num_scheds`.
**After:** if `sel_xcp_id >= MAX_XCP` or `sel_xcp_id ==
AMDGPU_XCP_NO_PARTITION`, it returns without touching the array. Normal
path unchanged for IDs in `0 .. MAX_XCP-1`.

Callers in `amdgpu_xcp_sched_list_update()`:
1. `amdgpu_xcp_gpu_sched_update(adev, ring, ring->xcp_id)`
2. For shared VCN: `amdgpu_xcp_gpu_sched_update(adev, ring, ring->xcp_id
   + 1)`

`amdgpu_set_xcp_id()` sets `ring->xcp_id = AMDGPU_XCP_NO_PARTITION`
first and can leave it there (CPER/early return, unsupported ring type,
or no matching `inst_mask`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Memory safety / out-of-bounds]** `xcp[]` has `MAX_XCP` (8)
entries. `ring->xcp_id` is `u32`; `AMDGPU_XCP_NO_PARTITION` is `(~0)` →
`0xffffffff`. Indexing `xcp[0xffffffff]` is a wild OOB read/write (store
a scheduler pointer, increment `num_scheds`). The VCN `xcp_id + 1` path
can also produce `8` when `xcp_id == 7`. The `==
AMDGPU_XCP_NO_PARTITION` clause is redundant for unsigned `sel_xcp_id`
(already `>= MAX_XCP`) but harmless.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct 3-line guard. Skipping a ring with an invalid
XCP id is the right behavior (that ring should not be on a partition
sched list). Regression risk is very low: a previously valid `0..7` id
is unaffected; a previously invalid id was already corrupting memory.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: The unchecked index was introduced in **`4dbc17b455329`**
(“drm/amdgpu: Convert update_partition_sched_list into a common helper
v3”, Hawking Zhang, 2025-06-16). That commit is an ancestor of
**v6.18.53**. XCP itself dates to **`75d1692393cb7`** (2022-09-16).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The buggy helper **is** in this tree (`git
merge-base --is-ancestor 4dbc17b455329 v6.18.53` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Related nearby work on the same file: `085ef38814f01` “bounds
check xcp ip block index”; mailing-list sibling “bounds check xcp_id in
release_sched” (Lijo Lazar) which names the same
`AMDGPU_XCP_NO_PARTITION` OOB. This patch is standalone; it does not
depend on those siblings. No follow-ups after it on this function.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Gangliang Xie is an AMD contributor sending small validation
patches (`add buf length check`, `add first record offset check`, RAS
checksum). Not the subsystem maintainer. Weight comes from **Reviewed-
by: Lijo Lazar** and **Signed-off-by: Alex Deucher**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. It only uses `MAX_XCP` and `AMDGPU_XCP_NO_PARTITION`, both
present in this tree (`amdgpu_xcp.h`). Can apply standalone; the
v6.18.53 function body matches the patch parent exactly.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c fa1531170d2c96060478d697fe93f1cafc0e7ddd` →
  https://patch.msgid.link/20260623024809.121196-1-ganglxie@amd.com
- `b4 dig -a`: single **v1**, no later revisions
- Thread: author patch + **Reviewed-by: Lijo Lazar**. No NAK, no stable
  nomination, no crash log in the thread.
- lore.kernel.org HTTP fetch returned 403; discussion recovered via `b4
  dig -m` mbox (2 messages).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: `b4 dig -w`: To `amd-gfx@lists.freedesktop.org`, Cc
`tao.zhou1@amd.com`. Reviewed by Lijo Lazar (XCP reviewer). Merged by
Alex Deucher.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla/CVE. Web search did find the maintainer
stating the **same** `xcp[ring->xcp_id]` pattern is OOB when id is
`AMDGPU_XCP_NO_PARTITION` (`bounds check xcp_id in release_sched`). That
is independent confirmation of the bug class, not a user crash report
for this exact function.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone v1, not a numbered series. Related OOB guards in the
same file (`release_sched`, ip-block index) are separate and not
required for this hunk to be correct.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable@ discussion found for this subject. linux-next merge
mail listed this commit among several amdgpu_xcp.c bounds-check fixes
(conflict was in `release_sched`, not this function).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP is not available; callers/callees traced with grep and file
reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `amdgpu_xcp_gpu_sched_update` (modified); callers
`amdgpu_xcp_sched_list_update` →
`amdgpu_xcp_update_partition_sched_list`.

**Step 5.2: TRACE CALLERS**

Record:
- `amdgpu_xcp_init()` (partition setup / mode switch)
- `amdgpu_device.c` after `drm_sched_init` for all rings (`if
  (adev->xcp_mgr) amdgpu_xcp_update_partition_sched_list(adev)`)

Only **aqua_vanjaram** calls `amdgpu_xcp_mgr_init` (MI300-family
Instinct). Consumer GPUs have `xcp_mgr == NULL` and never enter this
path.

`amdgpu_xcp_sched_list_update` skips `!ring`, `!ring->sched.ready`, and
`ring->no_scheduler`. CPER/KIQ/MES/UMSCH set `no_scheduler` and are not
this OOB. Rings that **are** scheduled and still have `xcp_id == ~0`
(unsupported type in `amdgpu_set_xcp_id`’s `default:`, or no `inst_mask`
match) **are** the OOB path. Shared VCN uses `xcp_id + 1`.

**Step 5.3: TRACE CALLEES**

Record: Array access and `dev_dbg` only. No locks, no allocation.
Failure mode is pure memory corruption.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Device init / partition switch on Instinct GPUs with XCP enabled
(`mode != AMDGPU_XCP_MODE_NONE`; `AMDGPU_XCP_MODE_NONE` and
`AMDGPU_UNKNOWN_COMPUTE_PARTITION_MODE` are both `-1`, so the update is
skipped until a real SPX/DPX/TPX/QPX/CPX mode is set). Not a syscall-hot
path; it **is** a driver-init/mode-switch path on production HPC/AI
GPUs. Unprivileged users do not trigger it directly.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same unguarded `xcp[ring->xcp_id]` in
`amdgpu_xcp_release_sched()` in this tree. Maintainer-authored sibling
patch exists upstream. Pattern is systematic.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree is **6.18.53** (`git describe HEAD` →
`v6.18.53-5049-g0f0bdc2b0dffb`; Makefile `VERSION=6 PATCHLEVEL=18
SUBLEVEL=53`). `v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c` has
`amdgpu_xcp_gpu_sched_update` **without** the `sel_xcp_id` check
(verified via `git show v6.18.53:...`). Bug introduced 2025-06
(`4dbc17b455329`), present since this 6.18 branch.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** onto v6.18.53 — parent hunk is identical. No
refactor of this function between 6.18.53 and the patch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other fix of this specific index in
`amdgpu_xcp_gpu_sched_update` on v6.18.53. The `release_sched` OOB is
still unfixed here; that does not replace this patch.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **drm/amdgpu XCP (compute partitioning).** Criticality:
**IMPORTANT** — not core mm/fs, but MI300-class Instinct GPUs in HPC/AI.
Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively developed (partition sysfs, unique ids, kobject
cleanup, multiple 2025–2026 XCP commits). The helper this guards has
been in 6.18 for the whole stable cycle.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver/config-specific:** `CONFIG_DRM_AMDGPU` + aqua_vanjaram
XCP (Instinct MI300 family) with partitioning actually enabled. Not
universal; not consumer Radeon.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Partition sched-list rebuild during GPU init or partition-mode
switch, when a ready scheduled ring still has `xcp_id == ~0` or `xcp_id
+ 1 >= 8`. Not an unprivileged syscall. Likelihood: uncommon if every
ring matches a partition, but the sentinel `AMDGPU_XCP_NO_PARTITION` is
an intentional valid state in `amdgpu_set_xcp_id`, and the VCN `+ 1`
path is an explicit in-tree caller. Consequences if it hits are severe.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **OOB write of a pointer + increment through that pointer.**
Kernel oops / memory corruption. **Severity: HIGH** (crash/corruption;
potentially worse if the write lands on live data).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for Instinct XCP users — prevents a wild OOB write.
  Zero effect on other hardware (`xcp_mgr` is null).
- **Risk:** Very low (3 lines, early return, no locking/API change).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real OOB write: `xcp[sel_xcp_id]` with `sel_xcp_id` possibly
  `0xffffffff` or `>= 8`.
- `AMDGPU_XCP_NO_PARTITION` is a first-class sentinel in
  `amdgpu_set_xcp_id`, then passed straight into this indexer.
- Same class of bug independently described as OOB by Lijo Lazar for
  `release_sched`.
- Buggy helper present in **this** 6.18.53 tree since `4dbc17b455329`.
- 3-line, obviously correct, reviewed by XCP expert, signed off by
  amdgpu maintainer.
- Applies cleanly; no new API/feature; no prerequisites.

**AGAINST:**
- No user/syzbot report; commit message is one line.
- Affects only partitioned Instinct GPUs, not all amdgpu users.
- On current MI300 mappings, many rings get a valid id or
  `no_scheduler`, so the crash may be uncommon.

**UNRESOLVED:** Exact production frequency of a ready ring left at
`NO_PARTITION` on MI300 was not reproduced on hardware (analysis is from
code). That does not change the OOB if it happens.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — trivial bounds check;
   Reviewed-by Lijo Lazar; in mainline via Alex Deucher.
2. Fixes a real bug that affects users? **PASS** — OOB index on XCP
   sched-list update for Instinct partition setups.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   OOB write → crash/corruption, HIGH.
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — v6.18.53 has the unchecked
   function; hunk matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It qualifies as a
normal memory-safety bug fix.

**Step 9.4: MAKE YOUR DECISION**

This is a small, correct guard against a real out-of-bounds write in
amdgpu XCP scheduler-list updates. The buggy code is in this 6.18.53
tree, the patch applies cleanly, and the risk of regression is
negligible. It should be backported.

Verification:
- [Phase 1] Tags: Reviewed-by Lijo Lazar; SOB Alex Deucher; no
  Fixes/Reported-by/Cc:stable (expected).
- [Phase 1] Body is one line; bug inferred from code, not a crash log.
- [Phase 2] Diff: +3 lines in `amdgpu_xcp_gpu_sched_update()`; early
  return on `sel_xcp_id >= MAX_XCP || sel_xcp_id ==
  AMDGPU_XCP_NO_PARTITION`.
- [Phase 2] `MAX_XCP` is 8; `AMDGPU_XCP_NO_PARTITION` is `(~0)`;
  `ring->xcp_id` is `u32` (`amdgpu_ring.h:370`).
- [Phase 3] Blame: unchecked index from `4dbc17b455329` (2025-06-16);
  `git merge-base --is-ancestor 4dbc17b455329 v6.18.53` succeeded.
- [Phase 3] No Fixes tag; no follow-up on this function after the
  candidate.
- [Phase 4] `b4 dig -c fa1531170d2c…`: lore/msgid
  `20260623024809.121196-1-ganglxie@amd.com`; v1 only; Lijo Reviewed-by;
  no NAK.
- [Phase 4] lore.kernel.org WebFetch: 403; mbox via `b4 dig -m` used
  instead.
- [Phase 4] WebSearch: Lijo Lazar “bounds check xcp_id in release_sched”
  explicitly calls `AMDGPU_XCP_NO_PARTITION` an OOB `xcp[]` access.
- [Phase 5] Callers: `amdgpu_xcp_sched_list_update` ←
  `amdgpu_xcp_update_partition_sched_list` ← `amdgpu_xcp_init` and
  `amdgpu_device.c` post-`drm_sched_init`.
- [Phase 5] Only `aqua_vanjaram.c` calls `amdgpu_xcp_mgr_init`.
- [Phase 5] CPER/KIQ/MES/UMSCH use `no_scheduler` (verified); they are
  not this OOB. Default/unmatched rings and VCN `xcp_id+1` are.
- [Phase 6] `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` = 6.18.53.
- [Phase 6] `git show v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c`
  shows the function **without** the check.
- [Phase 6] Upstream `fa1531170d2c` is not an ancestor of HEAD (`merge-
  base --is-ancestor` exit 1); the 6.18.53 file contents still match the
  pre-fix hunk.
- [Phase 7] drm/amdgpu XCP; IMPORTANT for Instinct partition users.
- [Phase 8] Failure mode: OOB write → oops/corruption; severity HIGH;
  backport risk very low.
- UNVERIFIED: Hardware reproduction on MI300 of a ready ring left at
  `NO_PARTITION`; not used as the sole basis for the decision (the OOB
  is visible in code and the same pattern is acknowledged by the XCP
  reviewer).

The patch is a 3-line, obviously correct bounds check for a real out-of-
bounds write in amdgpu XCP scheduler-list updates. The unchecked
function exists in this 6.18.53 tree, the fix applies cleanly, and the
regression risk is negligible.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index 6059227c53150..88de3ecc7f230 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -572,6 +572,9 @@ static void amdgpu_xcp_gpu_sched_update(struct amdgpu_device *adev,
 {
 	unsigned int *num_gpu_sched;
 
+	if (sel_xcp_id >= MAX_XCP || sel_xcp_id == AMDGPU_XCP_NO_PARTITION)
+		return;
+
 	num_gpu_sched = &adev->xcp_mgr->xcp[sel_xcp_id]
 			.gpu_sched[ring->funcs->type][ring->hw_prio].num_scheds;
 	adev->xcp_mgr->xcp[sel_xcp_id].gpu_sched[ring->funcs->type][ring->hw_prio]
-- 
2.53.0

