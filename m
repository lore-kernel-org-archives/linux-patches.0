Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751413E122A;
	Mon, 20 Apr 2026 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691472; cv=none; b=HPg0392ch5Dn0D9etaA6oAnXFA488yjAy+wL7FH1tbZ9jF7E8nMf5Z1lrzMGVvjT83/eR0V5HT8ehN7viUwxTadUap2hbk1Q2cKsk5lBZRqAsy+w6HWQpbSR604VtgWArjASynrv51Ic7sG0pDY10AfExYrKtAgiDxg46YWqM30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691472; c=relaxed/simple;
	bh=DPtaWdyhUp8H1tWTXq5W9Jp5ki8Hc4CFyVzacyf3Vjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rnGHgxoMEnpNQxlR2J4dhFiKZu7om9Bh74HqGgHMUUFn5feufNkSIOdqz2se4rIosLncihCd+xjBYYA5VSdTrvS24OBH2CLtqOYkRu8x6Q58QExtHOxL2/hBxY5TiMq57BLN91htX/5E6DVKfR5e8WxFXb2qSmcD8/U+4/IkeF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyXqcnNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyXqcnNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D7DC19425;
	Mon, 20 Apr 2026 13:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691472;
	bh=DPtaWdyhUp8H1tWTXq5W9Jp5ki8Hc4CFyVzacyf3Vjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyXqcnNCBCo86IRtIH72mspN4kaeOXGQdi8n0fV5Zl6BS9diZ9wx3YSXy6pKwiGNo
	 5ava8KqjyTyVEXY1fpy92Ft/3SOC4GnqDxnLl/0H3pqUs5AVsOy+irasYt7TnV7OMw
	 c8lC4L2Ckb2q0eWPDVFHTSzfgsyKlUlHeZpke9FDdtycEGW+PKQbHjlRsj3/APAnmO
	 ZV4c+F8tl6uwJbXoaYvjpvA1nX/W+uBoF4N7ZQ0D0wJpLxH6YV4QD/w46dUeqw9haZ
	 1iGnMOt1u/vw/RG/xfN7ufI7JNBwMh+1Xh7CbkZ9EC34mzSiWQjbgcUEFTGmYO4tdC
	 up0LCX6joFvxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Harry Wentland <harry.wentland@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Chuanyu Tseng <chuanyu.tseng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] drm/amd/display: Merge pipes for validate
Date: Mon, 20 Apr 2026 09:17:23 -0400
Message-ID: <20260420132314.1023554-49-sashal@kernel.org>
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

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 606f6b171326152ef08d0ef0ad49f52034edca07 ]

Validation expects to operate on non-split pipes. This is
seen in dcn20_fast_validate_bw, which merges pipes for
validation. We weren't doing that in the non-fast path
which lead to validation failures when operating with
4-to-1 MPC and a writeback connector.

Co-developed by Claude Sonnet 4.5

Assisted-by: Claude:claude-sonnet-4.5
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Chuanyu Tseng <chuanyu.tseng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/amd/display` (AMD display driver, DCN30
  specifically)
- **Action verb**: "Merge" (in the sense of merging split pipes before
  validation)
- **Summary**: Adds pipe merge step before validation in dcn30 non-fast
  path, matching the fast path behavior.

Record: [drm/amd/display] [merge/fix] [Add missing pipe merge call
before validation to match fast-validate path]

### Step 1.2: Tags
- **Fixes:** NONE (expected for autosel candidate)
- **Cc: stable:** NONE (expected for autosel candidate)
- **Co-developed by Claude Sonnet 4.5** - AI-assisted development
- **Assisted-by:** Claude:claude-sonnet-4.5
- **Reviewed-by:** Nicholas Kazlauskas (AMD display engineer)
- **Signed-off-by:** Harry Wentland (AMD display developer), Chuanyu
  Tseng, Alex Deucher (AMD DRM maintainer)
- **Reported-by:** NONE

Record: No Fixes tag, no Cc stable, no Reported-by. Reviewed by AMD
display expert. Signed by AMD DRM maintainer. No user bug reports.

### Step 1.3: Commit Body Text
The commit says: "Validation expects to operate on non-split pipes. This
is seen in dcn20_fast_validate_bw, which merges pipes for validation. We
weren't doing that in the non-fast path which lead to validation
failures when operating with 4-to-1 MPC and a writeback connector."

Bug: `dcn30_internal_validate_bw` passes split pipe configurations to
DML validation, but DML expects merged (non-split) pipes.
Symptom: Validation failures with 4-to-1 MPC split + writeback
connector.
Root cause: Missing `dcn20_merge_pipes_for_validate()` call that
dcn20_fast_validate_bw already has.

Record: [Validation expects non-split pipes; DCN30 non-fast path missed
merge call] [Validation failures with 4-to-1 MPC + writeback] [No
version info] [Same pattern as dcn20/dcn21 fast-validate]

### Step 1.4: Hidden Bug Fix Detection
This is NOT hidden - it clearly describes a validation failure bug and
the fix.

Record: [Explicit bug fix - validation failures on specific
configuration]

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: 1 file (`dcn30_resource.c`), +2 lines added (function call
  + blank line)
- **Functions modified**: `dcn30_internal_validate_bw`
- **Scope**: Single-file, single-line surgical fix

Record: [1 file, +2 lines] [dcn30_internal_validate_bw] [Single-line
surgical fix]

### Step 2.2: Code Flow Change
- **Before**: `dcn30_internal_validate_bw` immediately proceeds to set
  DML parameters and populate DML pipes without merging previously-split
  pipes.
- **After**: Before setting DML parameters, it calls
  `dcn20_merge_pipes_for_validate(dc, context)` to merge ODM-split and
  MPC-split pipes back into their head pipes, matching what
  `dcn20_fast_validate_bw` does.

The merge function (already existing in dcn20_resource.c, lines
1792-1849):
1. Merges ODM-split pipes by unlinking the chain
2. Merges MPC-split pipes by removing bottom_pipe entries
3. Both needed "since mode support needs to make the decision"

Record: [Before: validate with split pipes (wrong)] [After: merge pipes
first, then validate (correct, matching dcn20/dcn21)]

### Step 2.3: Bug Mechanism
This is a **logic/correctness fix**. The DML validation expects a single
non-split pipe view and makes its own split decisions. When pipes are
already split from a previous configuration, the validation gets
confused about pipe counts and resources, leading to false validation
failures.

Record: [Logic correctness bug] [DML fed split pipes when it expects
non-split pipes; fixes false validation failures]

### Step 2.4: Fix Quality
- **Obviously correct**: YES - directly matches the established pattern
  in `dcn20_fast_validate_bw` (line 2057) and dcn21's validate function
  (line 812)
- **Minimal/surgical**: YES - 1 line of actual code
- **Regression risk**: Extremely low - calling existing, well-tested
  function at the correct location
- **Red flags**: None

Record: [Obviously correct, matches established pattern] [No regression
risk from the fix itself]

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- `dcn30_internal_validate_bw` was introduced by `5dba4991fd338d`
  (2020-05-21, "drm/amd/display: Add DCN3 Resource")
- The merge logic was available via `dcn20_merge_pipes_for_validate`
  since `ea817dd5ad7950` (2020-09-18, "drm/amd/display: add dcn21 bw
  validation")
- The bug has existed since DCN3 was first added (v5.9)
- `dcn20_resource.h` is already included by dcn30_resource.c (line 34)

Record: [Buggy code from 5dba4991fd338d, introduced in v5.9] [Bug
present in all stable trees with DCN3 support]

### Step 3.2: Fixes Tag
No Fixes: tag present. The bug was introduced when DCN3 resource was
added without the merge call.

### Step 3.3: Related Changes
- Commit `269c1d1443d668` (2025-05-14) changed `fast_validate` to `enum
  dc_validate_mode` - affects function signature but NOT the insertion
  point
- Commit `71c4ca2d3b079d` (2023-02-01) added `allow_self_refresh_only`
  parameter

Record: [Standalone fix, no prerequisites] [May need minor context
adjustment for older stable trees]

### Step 3.4: Author
Harry Wentland is a well-known AMD display developer and regular
contributor. Alex Deucher is the AMD DRM maintainer.

Record: [Authored by established AMD display developer, signed off by
subsystem maintainer]

### Step 3.5: Dependencies
The commit calls `dcn20_merge_pipes_for_validate()` which has existed
since v5.10+. The function is declared in `dcn20_resource.h` which is
already included. No new dependencies.

Record: [No dependencies, function already exists and is accessible]

## PHASE 4: MAILING LIST RESEARCH

I was unable to find the original patch submission on lore.kernel.org
due to anti-bot protections. Web searches found related AMD display work
by the same authors but not this specific patch.

Record: [UNVERIFIED - could not find original lore discussion] [No
stable-specific discussion found]

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `dcn30_internal_validate_bw` is modified.

### Step 5.2: Callers
`dcn30_internal_validate_bw` is called from:
1. `dcn30_validate_bandwidth` (dcn30_resource.c:2091) - main validation
   entry point for DCN3.0
2. `dcn31_validate_bandwidth` (dcn31_resource.c:1812) - DCN3.1
3. `dcn314_validate_bandwidth` (dcn314_resource.c:1751) - DCN3.14
4. `dcn30_fpu.c` (lines 342, 634) - called in loops for dummy pstate and
   watermark calculations

This means the fix affects ALL DCN 3.x generations.

### Step 5.3-5.4: Call Chain
Display mode validation → `dcn30_validate_bandwidth` →
`dcn30_internal_validate_bw` → DML validation
This is triggered during every mode set/display configuration change.

Record: [Called during every mode set on DCN 3.0/3.1/3.14 hardware]
[Affects RDNA 2 GPUs (RX 6000), Rembrandt APUs, Phoenix APUs]

### Step 5.5: Similar Patterns
Confirmed: `dcn20_fast_validate_bw` at line 2057 and dcn21's validate
function at line 812 both already call `dcn20_merge_pipes_for_validate`
in the exact same position.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
DCN3 support (and `dcn30_internal_validate_bw`) has been present since
v5.9. All active stable trees (6.1.y, 6.6.y, 6.12.y) contain this code.

### Step 6.2: Backport Complications
The function signature changed over time:
- v6.1/v6.6: has `bool fast_validate` parameter
- v6.12+: has `enum dc_validate_mode validate_mode`
- The insertion point (after `if (!pipes) return false;`, before
  `maxMpcComb = 0`) is stable across versions
- Minor context adjustment may be needed for older trees

Record: [Likely clean apply or trivial conflict on most stable trees]

### Step 6.3: Related Fixes Already in Stable
No related fixes found for the same issue.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: drm/amd/display - display driver for AMD GPUs
- **Criticality**: IMPORTANT - AMD RDNA 2/3 GPUs are among the most
  widely deployed discrete GPUs
- DCN3.0 covers RX 6000 series, DCN3.1 covers Ryzen 6000 mobile APUs

### Step 7.2: Subsystem Activity
Very active subsystem with frequent changes.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users with AMD RDNA 2+ hardware (RX 6000 series, Ryzen 6000+ APUs) who
use display configurations triggering 4-to-1 MPC split with writeback.
This is driver-specific but on very popular hardware.

### Step 8.2: Trigger Conditions
- Requires 4-to-1 MPC pipe split (high resolution/bandwidth scenarios)
- Plus writeback connector active (screen capture, virtual display)
- Not a common everyday trigger, but can occur with specific display
  configurations

### Step 8.3: Failure Mode
Validation failure → mode set fails → display configuration rejected
Severity: MEDIUM-HIGH (can cause display output failure)

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Prevents display validation failures on widely deployed
  hardware
- **Risk**: Extremely low (1-line change, calling existing well-tested
  function)
- **Ratio**: Strongly favorable for backporting

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real validation failure bug (display config rejection)
- Extremely surgical: 1 line of actual code
- Matches established pattern in dcn20/dcn21 (proven correct)
- Zero regression risk
- Affects widely deployed hardware (AMD RDNA 2+)
- Affects multiple DCN generations (3.0, 3.1, 3.14 all call this
  function)
- Bug has existed since v5.9 (long-standing)
- Reviewed by AMD display expert (Nicholas Kazlauskas)
- Signed off by AMD DRM maintainer (Alex Deucher)
- Function already exists and is included via header

**AGAINST backporting:**
- Specific trigger condition (4-to-1 MPC + writeback)
- No Fixes: tag, no Cc: stable (expected)
- No user bug reports (Reported-by)
- Writeback connector usage is relatively niche
- Co-developed with AI (unusual, though reviewed by expert)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - matches exact pattern in
   dcn20/dcn21
2. Fixes a real bug? **YES** - validation failures with specific
   configuration
3. Important issue? **MEDIUM** - display config rejection, not
   crash/security
4. Small and contained? **YES** - 1 line in 1 file
5. No new features or APIs? **YES** - just calls existing function
6. Can apply to stable? **YES** - insertion point is stable across
   versions

### Step 9.3: Exception Categories
Not an exception category - this is a standard bug fix.

### Step 9.4: Decision
The fix is extremely low risk (single function call, well-established
pattern) and prevents real validation failures on popular AMD hardware.
While the specific trigger (4-to-1 MPC + writeback) is not common in
everyday use, the fix has virtually zero regression potential and
corrects a clear inconsistency between the DCN20/21 and DCN30 validation
paths.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Nicholas Kazlauskas, SOBs from
  Wentland/Tseng/Deucher, Co-developed by AI
- [Phase 2] Diff analysis: +2 lines (1 function call + blank line) in
  dcn30_internal_validate_bw
- [Phase 2] Verified dcn20_fast_validate_bw at line 2057 already has
  identical call
- [Phase 2] Verified dcn21 validate function at line 812 already has
  identical call
- [Phase 3] git blame: dcn30_internal_validate_bw introduced in
  5dba4991fd338d (2020-05-21, v5.9)
- [Phase 3] git blame: dcn20_merge_pipes_for_validate introduced in
  ea817dd5ad7950 (2020-09-18)
- [Phase 3] Verified dcn30_resource.c includes dcn20/dcn20_resource.h at
  line 34
- [Phase 3] Verified function signature changes: validate_mode in
  269c1d1443d66 (2025), allow_self_refresh_only in 71c4ca2d3b079d (2023)
- [Phase 5] Confirmed callers: dcn30_validate_bandwidth, dcn31, dcn314,
  dcn30_fpu.c (multiple call sites)
- [Phase 5] Verified dcn20_merge_pipes_for_validate function body (lines
  1792-1849): merges ODM and MPC splits
- [Phase 6] Confirmed DCN3 present in stable trees since v5.9 (tag
  contains check)
- [Phase 6] maxMpcComb=0 line (context) confirmed present since v6.1
  (4931ce22eca6ed)
- UNVERIFIED: Could not access lore.kernel.org for mailing list
  discussion due to anti-bot protections
- UNVERIFIED: Could not find original patch submission via b4 dig or web
  search

**YES**

 drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
index 87b7b4ee04c64..b00054ea18178 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
@@ -1675,6 +1675,8 @@ noinline bool dcn30_internal_validate_bw(
 	if (!pipes)
 		return false;
 
+	dcn20_merge_pipes_for_validate(dc, context);
+
 	context->bw_ctx.dml.vba.maxMpcComb = 0;
 	context->bw_ctx.dml.vba.VoltageLevel = 0;
 	context->bw_ctx.dml.vba.DRAMClockChangeSupport[0][0] = dm_dram_clock_change_vactive;
-- 
2.53.0

