Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F54547F2EA;
	Mon, 20 Apr 2026 13:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691891; cv=none; b=BOWDEeT/KEoG+kMMJH89uDf5GAFg6yF0EEyh6TuwcGTAK+i9EuRwIjzHdpPcmyzNaXZgF3/zhDLLE60rzynWiK8wUynK/kxqjKOTiJCVGE4E4VfYiC+3mvx/yFfytWVzQhPZIZMSw80bMWj9sxi78I4PWf0bLjcKDmkE35C0lr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691891; c=relaxed/simple;
	bh=zlcHTpa2ZsJ6GNWjqV8E7J6S2piuEFdQXj/3/loQ2Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKn36vFCN0YvYReFviJCvyQ9SRGBhgpuuVBGIKYL4rAhyCJSywYkAlRmp3XI+3d4ZFrxCeUJywYmMBkGascjyuyQAxPooxjKLr14mNdO4bKS7HPhUZT1bsjBtFLcqi9lkcAzoyuLePJjjbFmFE/9KtgitX8G2AT6fQpyUSiY91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmSPj07E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmSPj07E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E0AC2BCF4;
	Mon, 20 Apr 2026 13:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691891;
	bh=zlcHTpa2ZsJ6GNWjqV8E7J6S2piuEFdQXj/3/loQ2Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmSPj07ETBnlUQxi/nFRGNdG13hwT5+EEqf0OxDdYJ2tMd0+ZnN/heFUY9AxNpnmB
	 6wy0LrYOxFF2qwL6xqUpUJpADHlRU2EhSWnf6x5MlpMd5fZO47OAqsmcjcjR6ksdYc
	 BprpeSDVEllIJDnzQL5w/rals6r1/I4gphemdJsKqY38N/D8bD3p5znEZqT3TXM1Gq
	 1L334BvRh2htJ3WIfnyRXzyTisjRf+a3uk80qaMhtfpiJ6v72+gVOIIkg3B/mFkENM
	 Poi9Em4y8gd9xnwtdFRMT2Mx7ORj0gs/soU30WfPKNF934uy2HbGMtq95Doz2BycQ6
	 cAsAV/OU8LQpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Austin Zheng <Austin.Zheng@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Chuanyu Tseng <chuanyu.tseng@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	austin.zheng@amd.com,
	jun.lei@amd.com,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] drm/amd/display: Fix number of opp
Date: Mon, 20 Apr 2026 09:20:48 -0400
Message-ID: <20260420132314.1023554-254-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit 2c5f15ee2c760514c5be0f02cf9c9f1ff68b9ac8 ]

[Why/How]
Patch number of opp based on IP caps

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Chuanyu Tseng <chuanyu.tseng@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the full report.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amd/display`
- Action verb: "Fix"
- Summary: Fix the number of OPP (Output Pixel Processors) patching from
  IP caps.

Record: [drm/amd/display] [fix] [Ensures max_num_opp is patched from IP
capabilities]

**Step 1.2: Tags**
- Reviewed-by: Dillon Varone (AMD display team member)
- Signed-off-by: Austin Zheng (author), Chuanyu Tseng (series submitter)
- Tested-by: Dan Wheeler (AMD's display QA)
- Signed-off-by: Alex Deucher (AMD display maintainer)
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable (expected)

Record: Reviewed, tested, and signed off by the AMD display team. No
syzbot or external reports.

**Step 1.3: Body Text**
- "[Why/How] Patch number of opp based on IP caps"
- Terse message typical of AMD display DML patches. Indicates the OPP
  count should come from IP capabilities (hardware-specific) rather than
  remaining at the compile-time default.

Record: Bug is that `max_num_opp` was not being patched from hardware IP
caps, leaving it at a static default regardless of actual hardware.

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly labeled "Fix" and adds a missing field assignment
that was omitted when OPP validation was introduced.

Record: This is a direct bug fix for a missing field patching, not a
hidden fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `dml2_core_dcn4.c`
- +1 line added
- Function modified: `patch_ip_params_with_ip_caps()`
- Scope: Single-file, surgical 1-line fix

**Step 2.2: Code Flow Change**
The single line added:

```c
ip_params->max_num_opp = ip_caps->otg_count;
```

BEFORE: `patch_ip_params_with_ip_caps()` copies all IP capability fields
to IP params EXCEPT `max_num_opp`. The `max_num_opp` remains at the
compile-time default from `core_dcn4_ip_caps_base` (hardcoded to 4).

AFTER: `max_num_opp` is correctly patched from `ip_caps->otg_count`,
matching the actual hardware's OTG count.

**Step 2.3: Bug Mechanism**
This is a **logic/correctness fix** - an omission bug. Commit
`610cf76e9453b` ("Add opp count validation to dml2.1") added OPP count
validation checks in `dml2_core_dcn4_calcs.c` that read
`mode_lib->ip.max_num_opp`, but the function that patches IP params from
IP caps (`patch_ip_params_with_ip_caps`) was not updated to copy
`max_num_opp`. The validation uses a stale default value instead of the
actual hardware capability.

The validation code at lines 8588 checks:
```c
if (mode_lib->ms.TotalNumberOfActiveOPP > (unsigned
int)mode_lib->ip.max_num_opp)
    mode_lib->ms.support.TotalAvailablePipesSupport = false;
```

If `max_num_opp` is wrong, display modes may be incorrectly accepted or
rejected.

**Step 2.4: Fix Quality**
- Obviously correct: follows the exact same pattern as ALL other fields
  in the function
- Minimal/surgical: 1 line
- Regression risk: effectively zero - it only adds missing
  initialization
- No red flags

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The `patch_ip_params_with_ip_caps` function was introduced by commit
`70839da636050` (Aurabindo Pillai, 2024-04-19, "Add new DCN401
sources"). The function was created without a `max_num_opp` line because
at that time there was no `max_num_opp` field or OPP validation.

**Step 3.2: Fixes Target**
The commit that introduced the bug is `610cf76e9453b` ("Add opp count
validation to dml2.1", by Dmytro Laktyushkin, v6.19). That commit:
- Added `max_num_opp = 4` to `core_dcn4_ip_caps_base` static struct
- Added `max_num_opp` field to `dml2_core_ip_params`
- Added OPP validation in `dml2_core_dcn4_calcs.c`
- BUT did NOT add `max_num_opp` patching to
  `patch_ip_params_with_ip_caps()`

Record: The bug was introduced in v6.19. It exists in v6.19 and v7.0.

**Step 3.3: File History**
Only one commit in the 7.0 tree modified this specific file (the rename
from dml2/ to dml2_0/). The original code has had many "reintegration"
commits prior to v7.0.

**Step 3.4: Author**
Austin Zheng is a regular AMD display team contributor. Other commits
include DML-related fixes and data type corrections.

**Step 3.5: Dependencies**
The fix depends on commit `610cf76e9453b` ("Add opp count validation")
being present. Verified:
- v6.19: Has this prerequisite (confirmed via `git show`)
- v6.18 and older: Do NOT have this prerequisite
- v6.12 LTS: Does NOT have this prerequisite

## PHASE 4: MAILING LIST RESEARCH

Found the original submission: "[PATCH v2 0/9] DC Patches March 10,
2026" on amd-gfx mailing list. The fix was patch 7 of 9 in a v2 series
submitted by Chuanyu Tseng. The series was merged via the normal AMD
display patch flow. It was NOT part of drm-fixes-7.0 (the -fixes pull
only had different urgent fixes).

No NAKs or objections found. No explicit stable nomination.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Key function:** `patch_ip_params_with_ip_caps()` - called from
`core_dcn4_initialize()` during DML2 core initialization.

**Impact path:** `dml21_populate_dml_init_params()` ->
`core_dcn4_initialize()` -> `patch_ip_params_with_ip_caps()`. This runs
during display mode validation for every display configuration change on
DCN4+ hardware.

**Consumer of `max_num_opp`:** Used in `CalculateODMMode()` and the main
mode support validation loop in `dml2_core_dcn4_calcs.c` (lines 8421,
8442, 8588) to validate that active OPP count doesn't exceed hardware
capability.

## PHASE 6: STABLE TREE ANALYSIS

**Bug existence by tree:**
- v7.0: BUG EXISTS (verified - `max_num_opp` in struct at line 31,
  validation in calcs, but missing patching)
- v6.19: BUG EXISTS (verified - same state as 7.0, file at dml2_0 path)
- v6.18: Bug does NOT exist (no `max_num_opp` field or validation)
- v6.12 LTS: Bug does NOT exist
- v6.6 LTS, v6.1 LTS: Bug does NOT exist

**Backport complexity:** For 7.0.y: should apply cleanly. For 6.19.y:
path may need adjustment (file is at `dml2_0/` in v6.19 already, so it
may apply cleanly).

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: drm/amd/display - DML2 (Display Mode Library) for DCN4+
- Criticality: IMPORTANT - affects AMD GPU display output for newer
  hardware
- The DML2.1 code is actively developed with frequent "reintegration"
  commits

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Who is affected:** Users of AMD DCN4+ GPUs where the actual OPP/OTG
count differs from the compile-time default of 4 (e.g., harvested
silicon, different SKUs).

**Trigger conditions:** Any display mode validation on affected
hardware. This runs during every display configuration change (mode set,
multi-monitor setup, etc.).

**Failure mode:** Incorrect DML mode validation:
- If real OPP count < 4: modes could be accepted that the hardware can't
  support (display corruption or failure)
- If real OPP count > 4: modes could be incorrectly rejected (user can't
  use supported display configurations)
- Severity: MEDIUM-HIGH for affected hardware

**Risk-Benefit:**
- Benefit: Correct mode validation on all DCN4 hardware variants
- Risk: VERY LOW - 1 line, follows established pattern, no behavioral
  change for hardware where count == 4

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real bug (missing field initialization) with concrete
  consequences
- Trivially correct (1 line, follows exact pattern of all other fields)
- Reviewed and tested by AMD display team
- Affects display functionality on AMD DCN4 hardware
- Zero regression risk for hardware where OPP count == 4 (most current
  hardware)

**Evidence AGAINST backporting:**
- Only affects hardware with non-default OPP counts (subset of DCN4
  ASICs)
- Commit message is terse with minimal detail
- Not submitted via -fixes flow (went through normal DC patches)
- Only applicable to trees containing v6.19+ (610cf76e9453b)

**Stable rules checklist:**
1. Obviously correct? YES - exact pattern match with all other fields
2. Fixes real bug? YES - incorrect DML mode validation
3. Important issue? YES for affected hardware (display functionality)
4. Small and contained? YES - 1 line
5. No new features? YES
6. Applies to stable? YES for 7.0.y and 6.19.y

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Dillon Varone, Tested-by Dan
  Wheeler, author Austin Zheng, maintainer Alex Deucher
- [Phase 2] Diff analysis: 1 line added to
  `patch_ip_params_with_ip_caps()`, adds missing `max_num_opp` field
  patching
- [Phase 3] git blame: `patch_ip_params_with_ip_caps()` introduced in
  70839da636050 (v6.12 era) without `max_num_opp`
- [Phase 3] git show 610cf76e9453b: confirmed this commit added opp
  validation but missed updating `patch_ip_params_with_ip_caps()` - this
  is the root cause
- [Phase 3] git show v6.19 file: confirmed `max_num_opp = 4` in struct
  AND validation in calcs, BUT missing patching - bug exists in v6.19
- [Phase 3] git show v6.18 file: confirmed no `max_num_opp` at all - bug
  does NOT exist pre-6.19
- [Phase 3] git show v6.12 file: confirmed no `max_num_opp` at all
- [Phase 4] Found original submission: "[PATCH v2 0/9] DC Patches March
  10, 2026" on amd-gfx mailing list
- [Phase 4] No NAKs or concerns found in mailing list
- [Phase 5] `max_num_opp` is consumed at lines 8421, 8442, 8588 of
  dml2_core_dcn4_calcs.c for display mode validation
- [Phase 5] `patch_ip_params_with_ip_caps()` called from
  `core_dcn4_initialize()`, which runs during every DML initialization
- [Phase 6] Bug exists in v6.19 and v7.0 only - confirmed by checking
  file contents at each tagged version
- [Phase 8] Failure mode: incorrect mode validation leading to display
  issues, severity MEDIUM-HIGH for affected hardware
- UNVERIFIED: Exact set of AMD ASICs where OPP count differs from
  default 4 could not be determined (dcn42 bounding box header not found
  in tree)

The fix is a trivially correct 1-line addition that patches a missing
field from the hardware IP capabilities, fixing incorrect DML mode
validation on AMD DCN4 hardware where the OPP count may differ from the
compile-time default.

**YES**

 .../amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4.c   | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4.c b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4.c
index eba948e187c11..93d479083acde 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4.c
@@ -107,6 +107,7 @@ static void patch_ip_params_with_ip_caps(struct dml2_core_ip_params *ip_params,
 {
 	ip_params->max_num_dpp = ip_caps->pipe_count;
 	ip_params->max_num_otg = ip_caps->otg_count;
+	ip_params->max_num_opp = ip_caps->otg_count;
 	ip_params->num_dsc = ip_caps->num_dsc;
 	ip_params->max_num_dp2p0_streams = ip_caps->max_num_dp2p0_streams;
 	ip_params->max_num_dp2p0_outputs = ip_caps->max_num_dp2p0_outputs;
-- 
2.53.0

