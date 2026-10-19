Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F86526AA7;
	Mon, 19 Oct 2026 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418116; cv=none; b=Os1SARQcMAoJr71zYCRRXNl+r3qVSskI1gvtuAU706VYAm/SuhdcC9sfHMk9Ck8v9+HlKDjYF2LLv+Q98HL+dtvFrTGDgOtXzh7mBZchaI/LAesqL7mKsA7Rf7R5Qug0Jd02PYy6pg4mxIExv4f9LXniLI2P0wA49RMIoXRPZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418116; c=relaxed/simple;
	bh=HgEzeT6Mr78ZEamzC2MqHYhO15gU07acDgEjWshBVpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVRsEAHnN+AIzcOcFK5rlUfY/2IySRETXFufiEC9XbzysJ5TTFxGsPRoSdY6sKxe9B3OSJw5OV/CVcbRoRyrm9C8kZJXW0dzTrP0oKAuNld9/0UZ7sFrkLMimNaohNKMs9bp+eGmtjxD3ZYe1axY1u2YO07fTj3qpj8zQx71PJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ouvdB+UK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouvdB+UK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C52D1F000C4;
	Mon, 19 Oct 2026 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418114;
	bh=EyIl4QBNRI9HhEDt82gCnr1Cn7DA2ICqP3yMVbYsJbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouvdB+UKjzfrUg4qQkDEHAaV28m++NYbJDgCRFpU1GcZS715N8jVEC9mqAj2wlgN9
	 euKTK9edrCxyr8/4hOqYDbjcuTwTkGVlkJUGp7rJiHgW9Qpry+aP1HxX6uA2w9GiK4
	 J8m24NggKmTCIrWkr3nuEOBX4sR5nZU5b+0p4HNXCJ50Colp3E+1tqkNFhD2gM8PCt
	 aAbaiEYGaBUIb3JZWIFBBSRHr4W91a8pvHnF5g2WOlP7wUJY92poDFg+RVCv0QlOGS
	 hPWRu5LjxWfvOSSRi0WI9BpQarKO2Amg3zBTdfQoxdUGAgEXrPQF+5tkOv1jaOl84M
	 Lj9h2VYaFA5Rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: validate XCP topology counts before division
Date: Mon, 19 Oct 2026 09:45:12 -0400
Message-ID: <20261019135441.1420968-21-sashal@kernel.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 0eda57ee303b4392057b7d4c32e8fda9d14cffad ]

In aqua_vanjaram_get_xcp_res_info(), max_res[i] can be zero.
When res_lt_xcp is true the code divides num_xcp by max_res[i],
causing a divide fault.

Skip the loop body for absent resources.

v2: Remove redundant checks (Lijo)

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a divide-by-zero oops in MI300 XCP sysfs init. The buggy loop is
in this 6.18.y tree; the fix is a 3-line skip for a zero resource count.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `drm/amdgpu`
- Action verb: `validate` (defensive correctness; body is an explicit
  divide-fault fix)
- Claimed intent: do not divide XCP topology counts when a resource
  count is zero

Record: `[drm/amdgpu] [validate] [skip XCP resource loop when
max_res[i]==0 to avoid divide-by-zero]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- No `Fixes:` tag (expected for this review pipeline)
- No `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable@`
- `Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>` — original author of
  this function
- `Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>`
- `Signed-off-by: Asad Kamal <asad.kamal@amd.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- Ignored pipeline tags: `[Upstream commit 0eda57ee…]`, `Signed-off-by:
  Sasha Levin`

Record: Author + two AMD reviewers + maintainer SOB. No syzbot/user
report tag.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: in `aqua_vanjaram_get_xcp_res_info()`, `max_res[i]` can be 0.
  When `res_lt_xcp` is true the code does `num_xcp / max_res[i]`.
- Symptom: kernel divide fault (oops/exception).
- Fix: skip the loop body for absent resources.
- `v2: Remove redundant checks (Lijo)` — review-driven simplification.

Record: `[Bug: division by zero on zero resource counts] [Failure:
divide fault] [No version range stated] [Root cause: max_res[i]==0 with
res_lt_xcp true]`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not hidden. The message names the divide fault and the skip.

Record: `[Not a disguised cleanup; explicit divide-by-zero fix]`

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c` (+3/−1)
- Function: `aqua_vanjaram_get_xcp_res_info()`
- Scope: single-file, surgical

Record: `[1 file, +3/-1, one function, surgical]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before (v6.18.53):
```
for each resource:
    res_lt_xcp = max_res[i] < num_xcp;
    set id;
    num_inst = res_lt_xcp ? 1 : max_res[i] / num_xcp;
    num_shared = res_lt_xcp ? num_xcp / max_res[i] : 1;
```
After:
```
for each resource:
    set id;
    if (!max_res[i]) continue;   // leave num_inst/num_shared at 0
    ... same arithmetic ...
```
The `continue` is on the per-resource fill path used at sysfs init and
on partition-mode store.

Record: `[zero count: divide -> skip and keep zeros]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: logic / memory-safety adjacent (integer divide-by-zero).

`max_res[]` is `= {}` then filled from:
- XCC: `NUM_XCC(adev->gfx.xcc_mask)`
- DMA: `adev->sdma.num_instances`
- DEC: `adev->vcn.num_vcn_inst`
- JPEG: `adev->jpeg.num_jpeg_inst`

`aqua_vanjaram_init_soc_config()` sets VCN/JPEG counts from
`hweight32(inst_mask)`. Discovery starts `vcn.inst_mask` /
`jpeg.inst_mask` at 0 and only sets bits when VCN IPs exist; harvest can
clear those bits. If a count is 0 and `num_xcp > 0` (SPX=1, DPX=2,
TPX=3, QPX=4, CPX=XCC count), then `res_lt_xcp` is true and `num_xcp /
max_res[i]` is a divide fault.

Record: `[divide-by-zero] [absent VCN/JPEG/SDMA/XCC count vs non-zero
partition count]`

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: skip the division when the divisor is 0. `xcp_cfg` is
`kzalloc`’d in `amdgpu_xcp_cfg_sysfs_init()`, so skipped entries keep
`num_inst`/`num_shared` = 0, which matches “absent”. Sysfs still creates
the `dec`/`jpeg` kobjects (id is still set); they report 0 instead of
oopsing.

Regression risk is very low. No API/locking/refcount change. v2 dropped
extra checks at Lijo’s request.

Record: `[minimal, correct] [very low regression risk]`

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
On v6.18.53, the loop is from `f501057aff3357` (`drm/amdgpu: Add
callback get xcp resource info`, Lijo Lazar, 2024-09-09). Present in
v6.13; not in v6.12. Wrapper/NPS split later in `3aa37922c66a63` /
`e5ad71779df6f4`; the divide itself is original.

Record: `[f501057aff3357, first in v6.13; in this 6.18.y tree]`

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag.

Record: `[N/A — no Fixes tag; buggy commit identified by blame]`

**Step 3.3: CHECK FILE HISTORY**
Recent v6.18.53 history on this file is XCP/NPS/partition work. No prior
zero-divisor guard in this loop. Later autosel commit `9bd596d9e90da`
(`Guard reads in pcie state readout`) is unrelated.

Record: `[standalone; no prerequisite series for this skip]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Asad Kamal is an AMD amdgpu contributor. Lijo Lazar has 20 commits on
this file in 6.18.y and wrote the function; his Reviewed-by is strong.

Record: `[AMD author; reviewed by function author and amdgpu
maintainer]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Uses existing `max_res[]` loop only. Sibling mainline patch `guard zero
divisors in soc_v1_0 partition code` is a different ASIC file;
`soc_v1_0` is **not** in this tree. This patch is self-contained.

Record: `[no local dependencies; applies standalone]`

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c 0eda57ee…` failed: lore.kernel.org returned an error.
Fallback: amd-gfx archives.

- v2 submission: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/146963.html
- Hawking Reviewed-by: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/146976.html
- May–July 2026 archives: only v2, no public v1 (v1 likely internal;
  message says Lijo asked to drop redundant checks)
- No NAK

Record: `[amd-gfx v2 + Hawking RB; no NAK; v1 not on the public list]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
v2 To/Cc: amd-gfx, Lijo Lazar, Hawking Zhang, Le Ma, Morris Zhang, Alex
Deucher, Yang Wang. Right maintainers.

Record: `[Lijo + Hawking reviewed; Deucher merged]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
No bugzilla/syzbot/Link. Hardware-path analysis by AMD, not a fuzzer ID.

Record: `[no public crash dump; AMD-described divide fault]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Standalone `[PATCH v2]`, not `n/N`. Related only as the same round of
divisor guards (`soc_v1_0` not in 6.18.y).

Record: `[standalone; soc_v1_0 sibling N/A here]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable/?q=… returned 403. No evidence this was rejected
for stable.

Record: `[UNVERIFIED: stable list discussion (HTTP 403)]`

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `[aqua_vanjaram_get_xcp_res_info]`

**Step 5.2: TRACE CALLERS**
Callback `.get_xcp_res_info` in `aqua_vanjaram_xcp_funcs`. Only call
sites of `amdgpu_xcp_get_res_info()`:
1. `amdgpu_xcp_cfg_sysfs_init()` — `amdgpu_xcp_sysfs_init()` ←
   `amdgpu_device.c` during device init
2. `xcp_config_store()` — sysfs `xcp_config` (`__ATTR_RW_MODE(...,
   0644)`), typically CAP_SYS_ADMIN/root

Record: `[GPU probe sysfs init + privileged sysfs store]`

**Step 5.3: TRACE CALLEES**
`__aqua_vanjaram_get_px_mode_info()` sets `num_xcp` to 1/2/3/4 or
`NUM_XCC`. No alloc/lock in the changed loop.

Record: `[fills xcp_cfg for sysfs; no new side effects]`

**Step 5.4: FOLLOW THE CALL CHAIN**
Probe: discovery → `aqua_vanjaram_init_soc_config()` (GC 9.4.3 / 9.4.4 /
9.5.0) → later `amdgpu_xcp_sysfs_init()` → this function. Userspace can
also write `compute_partition_config/xcp_config`.

Record: `[reachable on MI300-class probe and partition sysfs; not a dead
path]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Only implementation of `get_xcp_res_info` in this tree. Mainline
`soc_v1_0` guard is a sibling, not present here.

Record: `[no other local copy of this loop]`

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Local tree: **v6.18.53** (`VERSION=6 PATCHLEVEL=18 SUBLEVEL=53`, `git
describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`, branch `autosel`).

v6.18.53 `aqua_vanjaram_get_xcp_res_info()` still does `num_xcp /
max_res[i]` with no zero check. Upstream `0eda57ee` is **not** an
ancestor of HEAD. Introducing commit `f501057aff3357` **is** an ancestor
of v6.18.53.

Record: `[YES, buggy loop is in v6.18.53] [bug from v6.13 /
f501057aff3357]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
v6.18.53 loop matches the patch preimage exactly. Clean apply; no
refactor in the way.

Record: `[clean apply]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No other zero-divisor fix for this loop in v6.18.53.

Record: `[no substitute fix in this tree]`

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
`drivers/gpu/drm/amd/amdgpu` — AMD GPU driver, Aqua Vanjaram XCP
(MI300/MI325/MI350-class, GC 9.4.3/9.4.4/9.5.0).

Record: `[amdgpu XCP] [IMPORTANT — datacenter Instinct GPUs, not core
mm/fs]`

**Step 7.2: SUBSYSTEM ACTIVITY**
File is actively maintained (partition/NPS/XCP changes). The divide is
old (6.13), not a last-week feature.

Record: `[active driver; bug has been in-tree since v6.13]`

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Users of amdgpu on Aqua Vanjaram ASICs (MI300A/X, MI325, GC 9.5.0) with
XCP sysfs. Not universal.

Record: `[driver-specific / platform-specific (MI300-class)]`

**Step 8.2: TRIGGER CONDITIONS**
Always runs at XCP sysfs init if `xcp_mgr` exists. Faults when any
`max_res[i]` is 0 — verified possible for VCN/JPEG via `inst_mask==0`
after discovery/harvest. Also on writing partition mode. Unprivileged
users do not normally write that sysfs node (0400 resource attrs; store
is 0644 on a root-owned kobject). Probe path does not need a user
trigger.

Record: `[probe + partition sysfs] [likely on harvested/no-VCN configs]
[unprivileged write not required]`

**Step 8.3: FAILURE MODE SEVERITY**
x86 `#DE` in kernel → oops. During device init this can fail GPU bring-
up or panic if `panic_on_oops`. Not silent corruption.

Record: `[kernel oops / GPU init crash] [CRITICAL/HIGH]`

**Step 8.4: RISK-BENEFIT RATIO**
Benefit: stop a real divide oops on MI300-class XCP sysfs. Risk: 3
lines, skip-only, zeros already from kzalloc.

Record: `[high benefit for affected GPUs] [very low risk] [favorable]`

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real divide-by-zero; oops on XCP sysfs init / partition store
- Buggy code is in this v6.18.53 tree
- Counts can be 0 (VCN/JPEG `inst_mask` from discovery/harvest)
- 3-line skip; obviously correct; v2 reviewed by the function author and
  Hawking; merged by Deucher
- Clean apply; no new API; no series dependency

AGAINST:
- Affects only MI300-class XCP, not all machines
- No public reproducer/syzbot
- v1 mailing-list text not found

UNRESOLVED:
- Stable-list discussion (lore 403)
- Exact public v1 diff
- How often production MI300 SKUs have `num_vcn_inst==0` (AMD still
  treated it as real)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — skip on zero divisor; two
   AMD R-b, maintainer SOB
2. Real bug that affects users? **PASS** — divide fault in driver
   init/sysfs
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   oops
4. Small and contained? **PASS** — +3/−1, one function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — v6.18.53 preimage matches

**Step 9.3: EXCEPTION CATEGORIES**
Not ID/quirk/DT/docs. Direct crash fix.

**Step 9.4: DECISION**
Backport. It is a small, obviously correct oops fix for code this tree
actually runs.

### Why this matters for this tree
v6.18.y ships Aqua Vanjaram XCP resource sysfs. If VCN/JPEG/SDMA/XCC
count is 0, `num_xcp / max_res[i]` oopses during
`amdgpu_xcp_cfg_sysfs_init()` or a partition-mode store. Skipping empty
resources stops the fault and reports 0 instances.

### Risk vs benefit
Benefit is avoiding a GPU-init oops on MI300-class systems. Risk is a
continue that leaves kzalloc zeros. No locking or ABI change.

### Concerns
None material. `soc_v1_0` sibling is not needed here. No follow-up on
this loop in this tree.

Verification:
- [Phase 1] Tags: Reviewed-by Lijo Lazar, Hawking Zhang; SOB Alex
  Deucher; no Fixes/syzbot
- [Phase 2] Diff: +3/−1 in `aqua_vanjaram_get_xcp_res_info()`; `if
  (!max_res[i]) continue` before `num_xcp / max_res[i]`
- [Phase 3] `git blame` v6.18.53: loop from `f501057aff3357` (in v6.13;
  not v6.12); `git merge-base --is-ancestor f501057aff3357 v6.18.53`
  succeeded
- [Phase 3] No Fixes tag; no later related fix on this loop in v6.18.53
- [Phase 4] `b4 dig -c 0eda57ee…`: lore error; found v2 at
  lists.freedesktop.org/amd-gfx/2026-June/146963.html; Hawking RB
  146976.html; no NAK
- [Phase 4] UNVERIFIED: stable@ thread (lore 403); public v1 body
- [Phase 5] Callers: `amdgpu_xcp_cfg_sysfs_init` (device init) and
  `xcp_config_store` (sysfs)
- [Phase 5] `adev->vcn.inst_mask` starts 0 in `amdgpu_discovery.c`;
  harvest can clear bits; `aqua_vanjaram_init_soc_config` sets
  `num_vcn_inst = hweight32(inst_mask)`
- [Phase 6] `git describe HEAD`: v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion`: 6.18.53
- [Phase 6] v6.18.53 file has the unfixed loop (`has skip? False`);
  `0eda57ee` is not an ancestor of HEAD
- [Phase 8] Failure mode: kernel divide fault / oops on XCP sysfs init,
  severity HIGH/CRITICAL
- UNVERIFIED: frequency of zero VCN/JPEG on shipping MI300 SKUs (does
  not override the verified divide path)

**YES**

 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index f9e2edf5260bc..15e70415c35b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -295,8 +295,10 @@ static int aqua_vanjaram_get_xcp_res_info(struct amdgpu_xcp_mgr *xcp_mgr,
 	xcp_cfg->num_res = ARRAY_SIZE(max_res);
 
 	for (i = 0; i < xcp_cfg->num_res; i++) {
-		res_lt_xcp = max_res[i] < num_xcp;
 		xcp_cfg->xcp_res[i].id = i;
+		if (!max_res[i])
+			continue;
+		res_lt_xcp = max_res[i] < num_xcp;
 		xcp_cfg->xcp_res[i].num_inst =
 			res_lt_xcp ? 1 : max_res[i] / num_xcp;
 		xcp_cfg->xcp_res[i].num_inst =
-- 
2.53.0

