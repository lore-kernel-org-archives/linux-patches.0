Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832D426D02;
	Tue, 28 Apr 2026 10:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372988; cv=none; b=IofZyokVW2mob2P+y/0xnB7lRFhQ0/TfmLkygLZ6ZPkvFgFHR1uMmpLxD7PiLdtXDn+OJo+a9+w5SbsjDLQpJMWLzM13NCuxmQmIPgCJ05P/faRY14WvwryfCa6Y/cyZzWYGZtONy4LCUEEsSeQCAcRb9W7f8Wf3hLtH/mQz0B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372988; c=relaxed/simple;
	bh=z+ubNEiGkyTvzeK84mlK5De1vxwPNmN3CCbIYOlyWaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRnJ4QB0oPelyIYzYPz8cMrYEFCmbeBnuBmzhE1E0f5tHcABY7QFXgC+3Kj79n1eJQacLYk0A/DutN1yVW7OaxjT4LRc7RLD5Z5OOYoN83koW9DjZgqOccIngVaWnmfJOI3WeaGrnm9FVK6+e/FNYyFPtSQMtNfrdEH057QoJCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4jthecS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4jthecS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C8EC2BCB5;
	Tue, 28 Apr 2026 10:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372988;
	bh=z+ubNEiGkyTvzeK84mlK5De1vxwPNmN3CCbIYOlyWaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4jthecS94mhXjzorhQRDoB6Lc3gquagydnFHUhJv8mcNsYFHrPWQ7V3E9D9OlRdk
	 kyq87+nN/Xzvi1GYv+rE+muLjgUblU4nY4paGXNt2rnV/YI71ocmyk4ff04VyjqhDe
	 GZs/I7rKbvC9ZlssFivPZiCEAoUUyk3umpTgaYgnJFRBHtlg24DjG5AeNsE4QpAz+1
	 egX3ZioUOXL+rh3lXrNJhXvROouWtNh9ffJzNW9l+4tFvjPPseMGPY10ALe3s3WiEt
	 bRRQ7y6ET3BX1V+wW/iBJvywhqp/tGK4eNb/4YoCRQY4oQyiveDAnGV+FiDG9iXMkn
	 BU4u0Mwy3wG1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Hung <alex.hung@amd.com>,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	Rodrigo.Siqueira@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amd/display: Use overlay cursor when color pipeline is active
Date: Tue, 28 Apr 2026 06:41:16 -0400
Message-ID: <20260428104133.2858589-65-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit d3a549f4df7864bca8612c8bcfce1ec72b2874fb ]

Force overlay cursor mode when an underlying plane has a non-bypassed
color pipeline to avoid incorrect cursor transformation.

Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a comprehensive analysis.

## Phase 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parsing**
- Subsystem: `drm/amd/display`
- Action verb: "Use" (implicit "fix" through "to avoid incorrect cursor
  transformation")
- Record: drm/amd/display - changes cursor mode selection logic when
  underlying plane has active color pipeline

**Step 1.2: Tag parsing**
- Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com> (AMD display
  maintainer)
- Signed-off-by: Alex Hung <alex.hung@amd.com> (author)
- Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com> (AMD)
- Tested-by: Dan Wheeler <daniel.wheeler@amd.com> (AMD)
- Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (subsystem
  maintainer)
- NO Fixes: tag, NO Cc: stable, NO Reported-by, NO Link
- Record: Standard AMD development chain, reviewed and tested
  internally, no external bug report references

**Step 1.3: Commit body analysis**
- Bug described: Cursor in NATIVE mode is subjected to color pipeline
  transformation of underlying plane, causing "incorrect cursor
  transformation"
- Solution: Force OVERLAY cursor mode (which uses dedicated DCN pipe)
  when underlying plane has non-bypassed color pipeline
- No version info, no stack traces, no reproduction steps
- Record: Bug = visual incorrectness in cursor color rendering when
  color pipeline is active. Symptom is described conceptually, not
  concretely.

**Step 1.4: Hidden bug fix detection**
- "Use overlay cursor when..." -> "to avoid incorrect cursor
  transformation" reveals this IS a fix, but described as enhancement
- Record: Fixes a real correctness issue, but framed as adding new code
  path rather than emergency fix.

## Phase 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c`
- ~49 lines added, ~4 lines deleted
- Functions modified: `dm_crtc_get_cursor_mode()`,
  `amdgpu_dm_atomic_check()` (debug message)
- New helper: `dm_plane_color_pipeline_active()` (static)
- Adds `#include <drm/drm_colorop.h>`
- Record: Surgical, single-file fix, contained.

**Step 2.2: Code flow change**
- Before: `dm_crtc_get_cursor_mode()` only checked YUV format and scale
  differences for overlay cursor decision
- After: Also checks if any plane in z-order has an active (non-
  bypassed) color pipeline
- Two checks added: (1) trigger consider_mode_change if color pipeline
  activity changes between old/new, (2) force OVERLAY mode when
  underlying plane has active pipeline
- Record: Adds new condition for selecting OVERLAY cursor mode.

**Step 2.3: Bug mechanism**
- Category: Logic/correctness fix - missing condition check
- The native cursor (integrated in DCN hw plane) was being subjected to
  color pipeline transformations meant for the underlying plane; this
  corrupts cursor visual rendering
- Fix forces overlay (separate DCN pipe) which is not subject to
  underlying plane's color pipeline
- Record: Visual correctness bug; not a crash/UAF/race/leak

**Step 2.4: Fix quality**
- Obviously correct: Yes, mirrors existing YUV/scaling check pattern
- Minimal/surgical: Yes
- Regression risk: Low - only changes cursor mode selection on a
  specific narrow condition (active color pipeline)
- Record: High quality, well-contained.

## Phase 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame analysis**
- The `dm_crtc_get_cursor_mode()` function was introduced in commit
  `1b04dcca4fb1` (drm/amd/display: Introduce overlay cursor mode),
  pre-v6.18
- The drm_colorop infrastructure was introduced in commit
  `cfc27680ee208` (Nov 26, 2025), present from v6.19
- Record: The function exists since pre-6.18, but the bug only triggers
  when color pipeline (v6.19+) is active.

**Step 3.2: Fixes: tag - N/A, no Fixes: tag**

**Step 3.3: Recent file history**
- Active development on color pipeline in AMD display driver
- Several recent color pipeline fixes: `b49814033cb52` (Fix gamma 2.2
  colorop TFs), `a4fa2355e0add` (Enable DEGAMMA and reject
  COLOR_PIPELINE+DEGAMMA_LUT), `18a4127e93156` (Disable CRTC degamma
  when color pipeline is enabled)
- Standalone fix; not part of an explicit X/Y series
- Record: Standalone correctness fix in actively developed area

**Step 3.4: Author**
- Alex Hung is a regular AMD display contributor; numerous recent
  commits in this area
- Record: Trusted developer, area maintainer chain present

**Step 3.5: Dependencies**
- Requires: `<drm/drm_colorop.h>`, `for_each_oldnew_colorop_in_state`
  macro, `drm_colorop_state` struct with `colorop`/`bypass` fields,
  `drm_colorop` struct with `plane` field
- All present in v6.19.14 and v7.0.1 stable trees - verified by direct
  inspection
- Record: All dependencies present in v6.19.y and v7.0.y; will apply
  cleanly.

## Phase 4: MAILING LIST RESEARCH

**Step 4.1: b4 dig results**
- `b4 dig -c d3a549f4df786`: "Could not find anything matching commit"
- `b4 dig -c 5d09aac12d5be`: "Could not find anything matching commit"
- Manual lore search via search engine: did not find direct submission
  of this exact patch
- BUT found relevant prior discussion: lists.freedesktop.org dri-devel
  April 2025 thread - Harry Wentland confirmed: "Yes, AMD driver is
  using the overlay cursor (entire dedicated HW pipe) for the cursor
  when the cursor scaling doesn't match the underlying plane. **The same
  thing can be done for color operations but it's not implemented
  yet.**"
- Record: This commit IMPLEMENTS the missing functionality identified
  during the original color pipeline patch series review.

**Step 4.2: Reviewers**
- Reviewed-by: Leo Li (AMD display maintainer)
- Tested-by: Dan Wheeler (AMD QA)
- Record: Properly reviewed by relevant maintainer.

**Step 4.3: Bug report - N/A** (no Reported-by, no Link)

**Step 4.4: Series context**
- Standalone patch (not part of X/Y series)
- Builds upon entire color pipeline infrastructure already in v6.19+
- Record: Self-contained; depends only on v6.19+ infrastructure.

**Step 4.5: Stable list - no specific discussion found**

## Phase 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key functions**
- New: `dm_plane_color_pipeline_active(state, plane, use_old)` - checks
  for non-bypassed colorops on a plane
- Modified: `dm_crtc_get_cursor_mode()` - cursor mode selection
- Modified: debug message in `amdgpu_dm_atomic_check()`

**Step 5.2: Callers**
- `dm_crtc_get_cursor_mode()` is called from `amdgpu_dm_atomic_check()`
  for every atomic commit when cursor configuration may change on AMD
  DCN hardware
- Affects: Every modeset/cursor update path on supported AMD DCN
  hardware
- Record: Reachable from userspace via DRM atomic commit syscalls

**Step 5.3: Callees**
- `for_each_oldnew_colorop_in_state` (DRM core macro from v6.19+)
- `drm_atomic_get_plane_state`, `drm_atomic_plane_enabling/disabling`
- Record: Standard DRM atomic helpers

**Step 5.4: Reachability**
- User triggers: opt-in to `DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE` AND
  configure non-bypassed colorop on a primary plane
- Modern Wayland compositors are adopting color pipeline API
- Record: Reachable but requires opt-in to relatively new API

**Step 5.5: Similar patterns**
- Existing YUV format check and scaling check follow same pattern
- The fix is the third "underlying plane property" check, parallel to
  the existing two
- Record: Consistent with established pattern.

## Phase 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Code in stable trees**
- `drm_colorop` infrastructure: NOT in v6.18 or earlier; PRESENT in
  v6.19.14 and v7.0.1 (verified by `git cat-file -e`)
- `dm_crtc_get_cursor_mode()`: present in v6.18, v6.19.14, v7.0.1
  (verified by direct inspection)
- The bug only manifests in v6.19+ (where colorop is operational on AMD)
- Record: Stable trees affected: v6.19.y and v7.0.y only. Older stables
  (v6.18, v6.12, v6.6, v6.1, v5.15, v5.10) DO NOT have the buggy code
  path because color pipeline didn't exist.

**Step 6.2: Backport difficulty**
- `dm_crtc_get_cursor_mode()` structure identical between mainline and
  v6.19.14/v7.0.1
- All required infrastructure (`for_each_oldnew_colorop_in_state`,
  `drm_colorop_state.colorop`, `drm_colorop_state.bypass`,
  `drm_colorop.plane`) is present in v6.19.14 - verified
- Record: Expected clean apply to v6.19.y and v7.0.y stable trees.

**Step 6.3: Related fixes already in stable**
- `e180b2af2725c` (drm/amd/display: Fix gamma 2.2 colorop TFs)
  backported to 6.19.y
- `083f1f71a9291` (drm/amd/display: Enable DEGAMMA and reject
  COLOR_PIPELINE+DEGAMMA_LUT) backported to 6.19.y
- `0b26c7e819c40` (drm/atomic: convert drm_atomic_get_{old,
  new}_colorop_state() into proper functions) backported to 6.19.y
- Record: Strong precedent of color pipeline correctness fixes
  backported to 6.19.y stable.

## Phase 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- DRM/AMD display - graphics driver
- Criticality: PERIPHERAL/IMPORTANT - affects many AMD GPU users but
  only those using new color pipeline feature
- Record: AMD display driver - impacts user-visible rendering for users
  who opt-in to color pipeline

**Step 7.2: Activity**
- Heavy activity on color pipeline area; multiple recent fixes
- Record: Very active subsystem; AMD display team actively maintaining
  color pipeline

## Phase 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected users**
- AMD GPU users with DCN hardware (DCN1+, except DCN401/420 which are
  exempt)
- Who use compositors that opt-in to
  `DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE`
- Modern Wayland compositors increasingly use the new API
- Record: Driver-specific (AMD) AND opt-in feature dependent

**Step 8.2: Trigger conditions**
- Userspace must enable `DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE`
- A non-cursor plane must have an active (non-bypassed) colorop
- Cursor must be enabled on the same CRTC
- Triggerable by unprivileged users via DRM atomic commit
- Record: Relatively narrow but reachable from userspace

**Step 8.3: Failure mode severity**
- Cursor undergoes incorrect color transformation -> cursor renders with
  wrong colors/visual artifacts
- No crash, no data corruption, no security implications, no system hang
- Severity: MEDIUM (visual correctness only)
- Record: Visual bug only - severity MEDIUM

**Step 8.4: Risk-benefit**
- BENEFIT: Correct cursor rendering for users of color pipeline; small
  but real correctness improvement
- RISK: Very low - single file, ~50 lines, well-contained, reviewed by
  AMD maintainer, tested
- Ratio: Low-risk, moderate-benefit fix
- Record: Favorable risk/benefit for a correctness fix

## Phase 9: FINAL SYNTHESIS

**Step 9.1: Evidence compilation**

Evidence FOR backporting:
- Real bug fix (incorrect cursor color rendering when color pipeline
  active)
- Small (~49 lines), single file, surgical change
- Reviewed-by AMD display maintainer (Leo Li)
- Tested-by AMD QA (Dan Wheeler)
- Clean apply to v6.19.y and v7.0.y stable (all dependencies verified
  present)
- Strong precedent: similar color pipeline correctness fixes already
  backported to 6.19.y
- Reachable from userspace via standard DRM atomic API
- Implements functionality explicitly identified as missing during
  original color pipeline review

Evidence AGAINST backporting:
- No Fixes: tag, no Cc: stable
- No Reported-by from external users (only AMD internal Tested-by)
- Color pipeline is documented under Documentation/gpu/rfc/ (RFC status)
- Opt-in feature requiring `DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE`
- Bug is visual-only (no crash, corruption, security)
- Commit reads as feature enhancement rather than fix

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? YES (Reviewed/Tested by AMD)
2. Fixes a real bug affecting users? YES (visual correctness)
3. Important issue? BORDERLINE (visual only, but real)
4. Small and contained? YES (single file, ~50 lines)
5. No new features/APIs? YES (uses existing APIs)
6. Can apply to stable trees? YES (verified for v6.19.y and v7.0.y)

**Step 9.3: Exception categories - N/A**

**Step 9.4: Decision**
The patch represents a small, well-reviewed correctness fix for cursor
rendering on AMD hardware when the color pipeline feature is in use.
While the bug is visual-only (no crashes/corruption/security), the fix
is exactly the type that has been backported to v6.19.y stable for the
same color pipeline area (e180b2af2725c, 083f1f71a9291). The fix applies
cleanly, has appropriate review/test signoffs, and implements a behavior
that was explicitly identified as needed during the original color
pipeline review. Affected stable trees are limited to v6.19.y and v7.0.y
where the colorop infrastructure exists.

## Verification

- [Phase 1] Parsed tags: Reviewed-by (AMD maintainer), Tested-by (AMD),
  Signed-off-by chain through AMD maintainers; NO Fixes:, NO Cc: stable,
  NO Reported-by, NO Link
- [Phase 1] Commit body: describes "incorrect cursor transformation" -
  confirms this is a fix despite enhancement-style subject
- [Phase 2] Diff inventory verified: 1 file, ~49 insertions, ~4
  deletions, adds `dm_plane_color_pipeline_active()` helper and modifies
  `dm_crtc_get_cursor_mode()`
- [Phase 2] Bug mechanism: native cursor subject to underlying plane's
  color pipeline transformation -> wrong cursor colors; fix forces
  overlay mode (separate DCN pipe)
- [Phase 3] git log on file: confirmed `dm_crtc_get_cursor_mode()`
  exists in v6.18 and forward
- [Phase 3] git log search: identified colorop infra introduced by
  `cfc27680ee208` (Nov 26, 2025), tagged v6.19+
- [Phase 4] b4 dig -c d3a549f4df786: did not find lore submission
  directly
- [Phase 4] Web search: found prior discussion on dri-devel April 2025
  confirming this functionality was deferred during original color
  pipeline review
- [Phase 5] Modified function `dm_crtc_get_cursor_mode()` callable via
  amdgpu_dm_atomic_check from DRM atomic commit syscall
- [Phase 6] git cat-file -e v6.19.14:include/drm/drm_colorop.h: EXISTS
  (bug applicable)
- [Phase 6] git cat-file -e v7.0.1:include/drm/drm_colorop.h: EXISTS
  (bug applicable)
- [Phase 6] git cat-file -e v6.18.24:include/drm/drm_colorop.h: NOT
  EXISTS (bug N/A for older stables)
- [Phase 6] Verified `for_each_oldnew_colorop_in_state` macro and
  `drm_colorop_state.{colorop,bypass}`, `drm_colorop.plane` all present
  in v6.19.14
- [Phase 6] git log v6.19..v6.19.14: found e180b2af2725c, 083f1f71a9291,
  0b26c7e819c40 already backported (precedent for color pipeline fixes)
- [Phase 8] Failure mode: visual cursor color rendering incorrect; no
  crash/corruption/security
- UNVERIFIED: Could not find direct lore submission via b4 dig (commit
  has not yet appeared in lore search index, possibly because it is a
  recent merge)

The fix targets a real correctness issue limited to v6.19+ stable trees,
applies cleanly, follows the same pattern as previously backported color
pipeline fixes, and has appropriate review/test signoffs from AMD
maintainers.

**YES**

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 53 +++++++++++++++++--
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2328c1aa0ead1..853e62c67375e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -94,6 +94,7 @@
 #include <drm/drm_utils.h>
 #include <drm/drm_vblank.h>
 #include <drm/drm_audio_component.h>
+#include <drm/drm_colorop.h>
 #include <drm/drm_gem_atomic_helper.h>
 
 #include <media/cec-notifier.h>
@@ -12278,6 +12279,38 @@ static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm
  * available.
  */
 
+/**
+ * dm_plane_color_pipeline_active() - Check if a plane's color pipeline active.
+ * @state: DRM atomic state
+ * @plane: DRM plane to check
+ * @use_old: if true, inspect the old colorop states; otherwise the new ones
+ *
+ * A color pipeline may be selected (color_pipeline != NULL) but still is
+ * inactive if every colorop in the chain is bypassed.  Only return
+ * true when at least one colorop has bypass == false, meaning the cursor
+ * would be subjected to the transformation in native mode.
+ *
+ * Return: true if the pipeline modifies pixels, false otherwise.
+ */
+static bool dm_plane_color_pipeline_active(struct drm_atomic_state *state,
+					   struct drm_plane *plane,
+					   bool use_old)
+{
+	struct drm_colorop *colorop;
+	struct drm_colorop_state *old_colorop_state, *new_colorop_state;
+	int i;
+
+	for_each_oldnew_colorop_in_state(state, colorop, old_colorop_state, new_colorop_state, i) {
+		struct drm_colorop_state *cstate = use_old ? old_colorop_state : new_colorop_state;
+
+		if (cstate->colorop->plane != plane)
+			continue;
+		if (!cstate->bypass)
+			return true;
+	}
+	return false;
+}
+
 /**
  * dm_crtc_get_cursor_mode() - Determine the required cursor mode on crtc
  * @adev: amdgpu device
@@ -12289,8 +12322,8 @@ static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm
  * the dm_crtc_state.
  *
  * The cursor should be enabled in overlay mode if there exists an underlying
- * plane - on which the cursor may be blended - that is either YUV formatted, or
- * scaled differently from the cursor.
+ * plane - on which the cursor may be blended - that is either YUV formatted,
+ * scaled differently from the cursor, or has a color pipeline active.
  *
  * Since zpos info is required, drm_atomic_normalize_zpos must be called before
  * calling this function.
@@ -12327,7 +12360,7 @@ static int dm_crtc_get_cursor_mode(struct amdgpu_device *adev,
 
 	/*
 	 * Cursor mode can change if a plane's format changes, scale changes, is
-	 * enabled/disabled, or z-order changes.
+	 * enabled/disabled, z-order changes, or color management properties change.
 	 */
 	for_each_oldnew_plane_in_state(state, plane, old_plane_state, plane_state, i) {
 		int new_scale_w, new_scale_h, old_scale_w, old_scale_h;
@@ -12352,6 +12385,12 @@ static int dm_crtc_get_cursor_mode(struct amdgpu_device *adev,
 			consider_mode_change = true;
 			break;
 		}
+
+		if (dm_plane_color_pipeline_active(state, plane, true) !=
+		    dm_plane_color_pipeline_active(state, plane, false)) {
+			consider_mode_change = true;
+			break;
+		}
 	}
 
 	if (!consider_mode_change && !crtc_state->zpos_changed)
@@ -12392,6 +12431,12 @@ static int dm_crtc_get_cursor_mode(struct amdgpu_device *adev,
 			return 0;
 		}
 
+		/* Underlying plane has an active color pipeline - cursor would be transformed */
+		if (dm_plane_color_pipeline_active(state, plane, false)) {
+			*cursor_mode = DM_CURSOR_OVERLAY_MODE;
+			return 0;
+		}
+
 		dm_get_plane_scale(plane_state,
 				   &underlying_scale_w, &underlying_scale_h);
 		dm_get_plane_scale(cursor_state,
@@ -12770,7 +12815,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 		} else if (required_cursor_mode == DM_CURSOR_OVERLAY_MODE) {
 			drm_dbg_driver(crtc->dev,
-				       "[CRTC:%d:%s] Cannot enable native cursor due to scaling or YUV restrictions\n",
+				       "[CRTC:%d:%s] Cannot enable native cursor due to scaling, YUV, or color pipeline restrictions\n",
 				       crtc->base.id, crtc->name);
 			ret = -EINVAL;
 			goto fail;
-- 
2.53.0

