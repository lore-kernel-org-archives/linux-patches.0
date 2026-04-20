Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FEB425CDF;
	Mon, 20 Apr 2026 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691673; cv=none; b=ul3Q5enYXzGt2XW8OrH+jkrPWoIGA9iqsDrEKwWOGwinWp7877FgKnIdqgq9SZYolNxW6OPWOScu3I8IXCr/TZecdQ23dMRpOuVpDV7tJRvLFRIUvkN+a0XqnSzmS/aWZqFEC3dY/DlH2sCix6DWfSjvUpCNEOBsJJ2JsC5Ua+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691673; c=relaxed/simple;
	bh=NttIuWqxHGq9CKGWgmyzDa57N7vXJe/0ISLp7pi9UwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SzkjaxsZxRqBajPxyffNO+JqlYYGsae+203ullh4+CHhr/n+P5z0rlPDHoSRnIrRTTdkbZLorjRIAOgs4DabBboHi/ZbGfwo/JWYMfwOhpZx+bDwFUZM4DIQhXzFS8z/Ea3YElUYIyW6nvNz2klqnE0h6RmLF4yr/adO2ULZ2B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZpOGeVpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZpOGeVpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF7EC19425;
	Mon, 20 Apr 2026 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691672;
	bh=NttIuWqxHGq9CKGWgmyzDa57N7vXJe/0ISLp7pi9UwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpOGeVpaOVjwXC089UH29B2iC1syp/kHlZTsGflMIn0XezsIVErtwQHwve9r8nNcc
	 T4KpvWI4NReBzS1fGvpUmi6vXi12WLom18pGZUga77x0/FR8fq2QtUafG0SYsDc66B
	 f9fHvonMVpiPqBY/foZHzxiflHV1+CdkbN4tHoZ4rZWZ+knyavpxwGqyzd9rmPLaFa
	 Vx1q1pwHtP7naxbTTEr0WJ/lu87uutqB1b8LWz+N3xPvyPDiDTofB+/SREcH++TM3k
	 WwL1c+twyyijjkNGTMpHqt10fsGHS6fd6dc/ITJfl8MipsoP0HsOCg3091XgT62Bnp
	 JFjXO/xELsYtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joshua Aberback <joshua.aberback@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Chuanyu Tseng <chuanyu.tseng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] drm/amd/display: Restore full update for tiling change to linear
Date: Mon, 20 Apr 2026 09:19:19 -0400
Message-ID: <20260420132314.1023554-165-sashal@kernel.org>
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

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 3967ab83a5075c05be3c614f1dc8460f66ee77ad ]

[Why]
There was previously a dc debug flag to indicate that tiling
changes should only be a medium update instead of full. The
function get_plane_info_type was refactored to not rely on dc
state, but in the process the logic was unintentionally changed,
which leads to screen corruption in some cases.

[How]
 - add flag to tiling struct to avoid full update when necessary

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Chuanyu Tseng <chuanyu.tseng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have a comprehensive understanding of this commit. Let me compile
the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amd/display`
- Action verb: "Restore" (indicating a regression fix — restoring
  previous correct behavior)
- Summary: Restoring full update for tiling change to linear to fix
  screen corruption
- Record: [drm/amd/display] [Restore] [Fix screen corruption by
  restoring full update for tiling changes to linear]

**Step 1.2: Tags**
- Reviewed-by: Nicholas Kazlauskas (AMD display core team) and Aric Cyr
  (AMD display team lead)
- Signed-off-by: Joshua Aberback (author), Chuanyu Tseng, Alex Deucher
  (AMD GPU maintainer)
- No Fixes: tag (expected for autosel candidates)
- No Reported-by: tag
- Record: Two reviews from AMD display engineers, signed off by GPU
  maintainer

**Step 1.3: Commit Body**
- Bug: Refactoring of `get_plane_info_type` unintentionally changed
  logic, leading to **screen corruption** in some cases
- Root cause: When tiling changes were refactored to not rely on dc
  state, the default behavior was changed from "always full update" to
  "conditional full update (only for non-linear)"
- Fix: Add a flag to the tiling struct to explicitly control when to
  avoid full update
- Record: Screen corruption caused by accidental logic change during
  refactoring. Failure mode is visual corruption.

**Step 1.4: Hidden Bug Fix Detection**
- This is explicitly described as fixing screen corruption. Not hidden
  at all — it's a clear regression fix.
- Record: Explicit bug fix for visual corruption regression.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `dc/core/dc.c`: ~20 lines removed (switch/case), ~6 lines added (flag-
  based logic). Net -16 lines.
- `dc/dc_hw_types.h`: 4 lines added (new `flags` sub-struct in
  `dc_tiling_info`)
- Functions modified: `get_plane_info_update_type()` in dc.c
- Record: 2 files, ~24 lines changed, single-function surgical fix plus
  struct addition

**Step 2.2: Code Flow Change**
- Before: Switch on `tiling->gfxversion`, only FULL update when swizzle
  is non-linear. Linear tiling changes get MED only.
- After: Check `tiling->flags.avoid_full_update_on_tiling_change`. If
  false (default), always FULL update. If true, MED update.
- Effect: Default is now always FULL update on tiling change (safe,
  conservative behavior), matching the pre-refactoring default.

**Step 2.3: Bug Mechanism**
- Category: Logic/correctness fix (restoring accidentally changed
  behavior)
- Original code (pre-03a593b1acbaf5): Always FULL unless
  `dc->debug.skip_full_updated_if_possible`
- Buggy code (03a593b1acbaf5): Only FULL for non-linear swizzle changes
- Fix: Restore always-FULL as default

**Step 2.4: Fix Quality**
- Obviously correct: yes, the default-to-FULL is the safe/conservative
  path
- Minimal/surgical: yes, tightly scoped to one function + one struct
- Regression risk: Potential for more FULL updates than necessary
  (performance cost, not correctness)
- Record: High quality fix, reviewed by two display engineers

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- Buggy switch/case logic introduced by `03a593b1acbaf5` (Dominik
  Kaszewski, 2025-07-15) "Remove dc state from check_update"
- This commit is present in 7.0 (confirmed via `git merge-base --is-
  ancestor`)
- First appeared in v6.19

**Step 3.2: Fixes Tag**
- No Fixes: tag present (expected for autosel candidate)
- Manually identified: `03a593b1acbaf5` is the commit that introduced
  the regression

**Step 3.3: File History**
- Related: `d637dd7288814` reverted `08a01ec306dbd` (another tiling fix
  that caused blank screens)
- Related: `bf95cf7f7a068` "Fix performance regression from full
  updates" by same refactoring author
- The display tiling update logic has been an active area of changes and
  fixes

**Step 3.4: Author**
- Joshua Aberback is a regular AMD display contributor (15+ commits to
  display subsystem)
- Previously authored `ce5057885ff70` "Clip rect size changes should be
  full updates" — a very similar type of fix
- Also reviewed the revert `d637dd7288814`

**Step 3.5: Dependencies**
- The commit requires `03a593b1acbaf5` to be present (it is — verified
  as ancestor of HEAD)
- The commit requires `45de10d2d9366` for the `LOCK_DESCRIPTOR_*` enum
  values (also present)
- No other dependencies found. The commit is standalone.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:**
- b4 dig could not find the patch on lore.kernel.org (AMD display
  patches often go through internal drm-misc/amd trees)
- lore.kernel.org blocked by Anubis anti-scraping
- Given the AMD display team's internal review process (two Reviewed-by
  tags from senior engineers + GPU maintainer sign-off), the patch went
  through proper review

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `get_plane_info_update_type()` — the only function modified in the
  logic

**Step 5.2: Callers**
- Called from `det_surface_update()` →
  `check_update_surfaces_for_stream()` →
  `dc_check_update_surfaces_for_stream()`
- This is the core display update path — called for every plane update
  on AMD GPUs

**Step 5.3-5.4: Call Chain**
- Reachable from: DRM atomic commit → amdgpu_dm →
  dc_check_update_surfaces_for_stream
- This is a HOT PATH — triggered on every display update for AMD GPU
  users

**Step 5.5: Similar Patterns**
- The `bundle` structs containing `dc_plane_info` are allocated with
  `kzalloc`, ensuring the new `flags` field is zero-initialized on the
  update path

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- Introduced in `03a593b1acbaf5` (v6.19)
- Present in 7.0 tree (verified)
- NOT present in 6.6.y or earlier stable trees (pre-dates the
  regression)

**Step 6.2: Backport Complications**
- The diff context lines match the current 7.0 code exactly — clean
  apply expected
- The `elevate_update_type` 3-argument signature matches (introduced by
  `45de10d2d9366`)
- The `dc_tiling_info` struct matches (revert `d637dd7288814` already
  applied)

**Step 6.3: Related Fixes in Stable**
- No related fix for this specific issue found in stable

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:**
- Subsystem: GPU/Display (drm/amd/display)
- Criticality: IMPORTANT — affects all AMD GPU users
- Record: AMD GPU display driver, widely used on desktops and laptops

**Step 7.2:**
- Very active subsystem with frequent changes
- The tiling update logic area has seen multiple fixes recently

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- All AMD GPU users (Radeon RX, integrated APUs) using this kernel
  version
- Particularly affects GFX9+ hardware where tiling transitions occur

**Step 8.2: Trigger Conditions**
- Tiling mode changes to linear (e.g., during mode switches, overlay
  plane changes)
- Can be triggered during normal desktop usage

**Step 8.3: Failure Mode**
- **Screen corruption** — CRITICAL visual artifact
- Severity: HIGH (screen corruption is visible and disruptive, though
  not data-corrupting)

**Step 8.4: Risk-Benefit**
- BENEFIT: Fixes screen corruption for AMD GPU users — HIGH
- RISK: ~24 lines changed, adds a struct field (low risk), default is
  conservative FULL update path. May cause minor performance overhead
  from extra FULL updates — LOW
- Ratio: HIGH benefit / LOW risk = FAVORABLE

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence**
FOR backporting:
- Fixes screen corruption (serious visual bug)
- Root cause clearly identified: logic change during refactoring
  (03a593b1acbaf5)
- Small, surgical fix (~24 lines across 2 files)
- Reviewed by two AMD display engineers (Kazlauskas, Cyr)
- Signed off by AMD GPU maintainer (Deucher)
- Standalone fix (no dependencies beyond what's in tree)
- Would apply cleanly to 7.0
- Default behavior is conservative (always FULL update)
- Author has track record of similar valid fixes (ce5057885ff70)

AGAINST backporting:
- Adds a new struct field (flags.avoid_full_update_on_tiling_change) —
  minor struct extension
- The flag is never set to true in this tree, making it effectively dead
  code
- A simpler fix (just always elevate to FULL without adding the flag)
  could have been used
- Potential (minor) performance regression from more FULL updates

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — two reviews, conservative default
2. Fixes a real bug? YES — screen corruption
3. Important issue? YES — screen corruption on AMD GPUs
4. Small and contained? YES — ~24 lines, 2 files, 1 function
5. No new features or APIs? The flag is new but internal-only and serves
   the fix
6. Can apply to stable? YES — context matches exactly

**Step 9.3: Exception Categories**
- Not an exception category; this is a standard bug fix

**Step 9.4: Decision**
This is a clear regression fix for screen corruption caused by
accidental logic change during refactoring. The fix is small, well-
reviewed, standalone, and defaults to the safe conservative behavior.
The struct field addition is internal-only and zero-initialized.

## Verification

- [Phase 1] Parsed tags: Reviewed-by: Nicholas Kazlauskas, Reviewed-by:
  Aric Cyr, three SOBs including Alex Deucher
- [Phase 2] Diff analysis: switch/case (20 lines) replaced with flag-
  check (6 lines) in `get_plane_info_update_type()`, plus 4-line struct
  addition
- [Phase 3] git blame: Buggy code introduced by `03a593b1acbaf5`
  (2025-07-15, v6.19), confirmed in 7.0 tree via `git merge-base --is-
  ancestor`
- [Phase 3] git show 03a593b1acbaf5: Confirmed refactoring replaced
  `dc->debug.skip_full_updated_if_possible` check with per-gfxversion
  switch, changing default from FULL to conditional
- [Phase 3] Related commits: `d637dd7288814` (revert of another tiling
  fix), `bf95cf7f7a068` (performance regression fix in same area)
- [Phase 3] Author check: Joshua Aberback has 15+ commits to AMD
  display, authored similar fix `ce5057885ff70`
- [Phase 4] b4 dig: Could not find original submission (AMD patches
  often go through internal trees)
- [Phase 4] lore.kernel.org: Blocked by Anubis protection
- [Phase 5] Callers traced: `get_plane_info_update_type()` →
  `det_surface_update()` → `dc_check_update_surfaces_for_stream()` — hot
  path for all AMD display updates
- [Phase 5] Bundle allocations at lines 3364 and 9949 both use kzalloc,
  ensuring flags field is zero-initialized
- [Phase 6] `git tag --contains 03a593b1acbaf5`: buggy code in v6.19 and
  7.0 only
- [Phase 6] Current tree code at lines 2748-2775 matches diff "before"
  context exactly — clean apply
- [Phase 6] `elevate_update_type` signature (3 args) matches at line 151
- [Phase 8] Failure mode: screen corruption on tiling change to linear,
  severity HIGH
- UNVERIFIED: Exact user reproduction scenario (commit message says
  "some cases" without specifics)
- UNVERIFIED: Whether any downstream code eventually sets the flag to
  true (but irrelevant — default false is the safe path)

**YES**

 drivers/gpu/drm/amd/display/dc/core/dc.c     | 26 ++++----------------
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h |  4 +++
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 47064e9bc08ad..7107529e90295 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2749,28 +2749,12 @@ static struct surface_update_descriptor get_plane_info_update_type(const struct
 
 	if (memcmp(tiling, &u->surface->tiling_info, sizeof(*tiling)) != 0) {
 		update_flags->bits.swizzle_change = 1;
-		elevate_update_type(&update_type, UPDATE_TYPE_MED, LOCK_DESCRIPTOR_STREAM);
 
-		switch (tiling->gfxversion) {
-		case DcGfxVersion9:
-		case DcGfxVersion10:
-		case DcGfxVersion11:
-			if (tiling->gfx9.swizzle != DC_SW_LINEAR) {
-				update_flags->bits.bandwidth_change = 1;
-				elevate_update_type(&update_type, UPDATE_TYPE_FULL, LOCK_DESCRIPTOR_GLOBAL);
-			}
-			break;
-		case DcGfxAddr3:
-			if (tiling->gfx_addr3.swizzle != DC_ADDR3_SW_LINEAR) {
-				update_flags->bits.bandwidth_change = 1;
-				elevate_update_type(&update_type, UPDATE_TYPE_FULL, LOCK_DESCRIPTOR_GLOBAL);
-			}
-			break;
-		case DcGfxVersion7:
-		case DcGfxVersion8:
-		case DcGfxVersionUnknown:
-		default:
-			break;
+		if (tiling->flags.avoid_full_update_on_tiling_change) {
+			elevate_update_type(&update_type, UPDATE_TYPE_MED, LOCK_DESCRIPTOR_STREAM);
+		} else {
+			update_flags->bits.bandwidth_change = 1;
+			elevate_update_type(&update_type, UPDATE_TYPE_FULL, LOCK_DESCRIPTOR_GLOBAL);
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index cfa569a7bff1b..face23e0559d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -436,6 +436,10 @@ enum dc_gfxversion {
 			enum swizzle_mode_addr3_values swizzle;
 		} gfx_addr3;/*gfx with addr3 and above*/
 	};
+
+	struct {
+		bool avoid_full_update_on_tiling_change;
+	} flags;
 };
 
 /* Rotation angle */
-- 
2.53.0

