Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B03F3264D6;
	Tue, 24 Mar 2026 11:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351174; cv=none; b=OGm+PjCgXib6rkixww3+YC9nYux+QkLvW9n4vuB97ccB6O9dGN5HeQvJ2Kfr4TQSmLNjtSHC3/TQouK5h0f2kRbmBq7fmbxkNYPl5NAEMmuidS3xTUkBBGWMoTew5PukeetH8I+w3ehJPAok6LOedutJbjDkjNMm9TlKOfOp/Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351174; c=relaxed/simple;
	bh=lelFSv8KIxfumUBSgNRBDGBB2PjvcsMNY6yIMv4a0UE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mjtTEK2ryudwsXi6ZvRnBCTYaFxmjfWT6RbKZv8tIxXZvDGvGyeo/HLIjF0sv52CBIwmJ2iMyK4WtQqmBA+scH3kHf5+KlYDbNcXHnEMHA1eYonKNWz/WKDS5fR3RB01H9PxDoyuOwQ3inRSYHJPDg0N5MKoszW7lXIhCCUwYis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUgDf5cC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUgDf5cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7A5C19424;
	Tue, 24 Mar 2026 11:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351173;
	bh=lelFSv8KIxfumUBSgNRBDGBB2PjvcsMNY6yIMv4a0UE=;
	h=From:To:Cc:Subject:Date:From;
	b=EUgDf5cCCgUbxl4OVUdC7/KhkysJV5oBwJQGqF/iXKd9ZmF1ggFP+YG3ADnO9zFkv
	 onGmcfP1WZytGeKHE9aSty7GA44uqy2LbPP78yKhm8IbUw/ikE1AjLUUNj47+INml8
	 6l5oi/fAHxO1MLtS6KsuzxQfgHRbp12b23d44zILlQY5e48aHs3Q0J4+m1V/dLOqYA
	 KvpROFnxbcsTf8/0V/KtPrwb/BrE7Rz+Uce6QYfYc6U6S6+08dqqbHvWUVzlraDSJo
	 3kmkCMHjV5KvyaemEwWyaqPgOrjUkaqPJ7YC46D1usvG7P8NMU8Ry9YoQ9+YYFFPn2
	 C0MUGQZ7sBAzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Hung <alex.hung@amd.com>,
	Xaver Hugl <xaver.hugl@kde.org>,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] drm/amd/display: Fix gamma 2.2 colorop TFs
Date: Tue, 24 Mar 2026 07:19:10 -0400
Message-ID: <20260324111931.3257972-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit b49814033cb5224c818cfb04dccb3260da10cc4f ]

Use GAMMA22 for degamma/blend and GAMMA22_INV for shaper so
curves match the color pipeline.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5016
Tested-by: Xaver Hugl <xaver.hugl@kde.org>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d8f9f42effd767ffa7bbcd7e05fbd6b20737e468)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile the full analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1:** [drm/amd/display] [Fix] [Gamma 2.2 colorop transfer
functions were swapped between degamma/blend and shaper]

**Step 1.2:** Tags: Closes (gitlab issue #5016), Tested-by (Xaver Hugl,
KDE), Reviewed-by (Melissa Wen, Igalia; Harry Wentland, AMD), Signed-
off-by (Alex Hung, AMD + Alex Deucher, AMD maintainer). No Cc: stable,
no Fixes: tag. Strong review chain.

**Step 1.3:** Bug: GAMMA22 and GAMMA22_INV were swapped in the
degamma/blend and shaper TF tables, causing incorrect color pipeline
behavior. Symptom: incorrect gamma 2.2 color rendering. The gitlab issue
title confirms: "Drm color pipeline has gamma 2.2 and inverse flipped."

**Step 1.4:** Not hidden - explicitly labeled as a fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1:** 1 file changed, 3 lines modified (value swaps only).
Functions affected: none - these are static constant array initializers.
Scope: minimal/surgical.

**Step 2.2:**
- `amdgpu_dm_supported_degam_tfs`: GAMMA22_INV → GAMMA22
- `amdgpu_dm_supported_shaper_tfs`: GAMMA22 → GAMMA22_INV
- `amdgpu_dm_supported_blnd_tfs`: GAMMA22_INV → GAMMA22

**Step 2.3:** Logic/correctness bug. The pattern across all three tables
makes it clear:
- Degamma/blend: SRGB_**EOTF**, PQ_125_**EOTF**, BT2020_**INV_OETF** →
  all "forward" transforms → GAMMA22 (forward) is correct
- Shaper: SRGB_**INV_EOTF**, PQ_125_**INV_EOTF**, BT2020_**OETF** → all
  "inverse" transforms → GAMMA22_**INV** is correct

**Step 2.4:** Obviously correct by pattern consistency. Zero regression
risk - just swapping constants to match the established convention.

## PHASE 3: GIT HISTORY

**Step 3.1:** Git blame confirms all buggy lines were introduced by
commit `db2bad93fe206` ("Enable support for Gamma 2.2") from 2025-11-14,
which is v6.19-rc1 material.

**Step 3.2:** No Fixes: tag, but the bug was introduced by
`db2bad93fe206`.

**Step 3.3:** The file `amdgpu_dm_colorop.c` was created in v6.19-rc1
cycle. Only one other fix has been backported to 6.19.y stable for this
file (`c5d11ab0cad0b`). This fix is standalone.

**Step 3.4:** Alex Hung is an AMD display developer, author of the
original buggy commit and several other colorop-related changes. Fix
authored by the same person who introduced the bug.

**Step 3.5:** No dependencies. The fix only changes constant values in
arrays already present.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1:** Patch submitted 2026-03-11, reviewed by Melissa Wen and
Harry Wentland, accepted by Alex Deucher. No explicit Cc: stable
nomination found.

**Step 4.2:** Bug report at gitlab.freedesktop.org/drm/amd/-/issues/5016
confirms "gamma 2.2 and inverse flipped" in the color pipeline. Tested
by Xaver Hugl (KDE Plasma compositor developer), indicating real-world
impact on desktop compositors.

**Step 4.3:** Standalone fix, not part of a series.

**Step 4.4:** No stable-specific discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** No functions modified - only constant array definitions.

**Step 5.2:** These constants are used in:
- `amdgpu_dm_initialize_default_pipeline()` - pipeline initialization
- `amdgpu_dm_color.c` - multiple places validating colorop state against
  supported TFs

**Step 5.3-5.4:** The TF bitmasks control which transfer functions are
advertised as supported to userspace and validated during atomic check.
With the wrong values, userspace compositors (like KDE Plasma) would see
incorrect supported TFs and get wrong color output.

**Step 5.5:** The pattern is consistent with all other TFs in the same
tables (sRGB, PQ, BT.2020).

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The file `amdgpu_dm_colorop.c` does NOT exist in v6.18 or
earlier. It was introduced in v6.19-rc1. The bug only exists in 6.19.y
stable.

**Step 6.2:** The fix would apply cleanly to 6.19.y - the code in 6.19.9
still has the buggy values (verified).

**Step 6.3:** No related fixes for this specific issue found in stable.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** [drm/amd/display] [IMPORTANT - AMD GPU is the most widely
used GPU on Linux desktops]

**Step 7.2:** Active subsystem with frequent changes to the colorop
infrastructure.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of AMD GPUs using the new DRM colorop/color
pipeline API (e.g., KDE Plasma 6 compositor). Driver-specific but widely
used hardware.

**Step 8.2:** Triggered whenever a compositor uses gamma 2.2 transfer
functions through the DRM color pipeline. The KDE Plasma compositor is a
primary consumer.

**Step 8.3:** Incorrect color rendering - not a crash, but produces
visually wrong output for users. Severity: MEDIUM-HIGH (functional
incorrectness in display output).

**Step 8.4:**
- **Benefit:** Fixes incorrect color output for AMD GPU users with
  compositors using the color pipeline. Tested by KDE developer.
- **Risk:** Extremely low - 3 constant value swaps, pattern-consistent,
  no logic changes.
- **Ratio:** High benefit / Very low risk = Strong candidate.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 Evidence FOR:**
- Fixes a real, user-reported bug (gitlab issue #5016)
- Values were demonstrably swapped (pattern mismatch with other TFs in
  same tables)
- Fix is trivial: 3 constant swaps
- Tested by KDE compositor developer (real-world validation)
- Reviewed by two color pipeline experts
- Code exists in 6.19.y stable and still has the bug
- Obviously correct by pattern analysis

**Step 9.1 Evidence AGAINST:**
- Only applies to 6.19.y (very limited scope)
- DRM colorop is new infrastructure, not widely deployed yet
- Not a crash or security issue (just incorrect color output)
- No Cc: stable tag or Fixes: tag

**Step 9.2 Stable Rules Checklist:**
1. Obviously correct? **YES** - pattern analysis proves it
2. Fixes a real bug? **YES** - reported bug with wrong color output
3. Important issue? **YES** - incorrect display output for users
4. Small and contained? **YES** - 3 lines in 1 file
5. No new features? **YES** - pure bugfix
6. Can apply to stable? **YES** - verified code matches in 6.19.9

**Step 9.3:** No exception category - standard bugfix.

**Step 9.4:** The fix is trivially correct, minimal, well-reviewed,
tested, and fixes a real user-reported bug. Despite being limited to
6.19.y, it meets all stable criteria.

## Verification

- [Phase 1] Parsed tags: Closes gitlab issue, Tested-by KDE developer,
  two Reviewed-by from display experts
- [Phase 2] Diff: 3 constant value swaps in static arrays, no logic
  changes
- [Phase 2] Pattern analysis: degamma/blend use forward TFs (EOTF,
  INV_OETF, GAMMA22), shaper uses inverse TFs (INV_EOTF, OETF,
  GAMMA22_INV) - confirmed correct
- [Phase 3] git blame: buggy lines from `db2bad93fe206` (v6.19-rc1)
- [Phase 3] git show v6.18/v6.12: file does not exist in pre-6.19 trees
- [Phase 3] git show v6.19.9: confirmed buggy code still present in
  6.19.9 stable
- [Phase 4] lore.kernel.org: found patch at 20260311211837.2482799-1, no
  explicit Cc: stable
- [Phase 4] gitlab issue #5016: title confirms "gamma 2.2 and inverse
  flipped"
- [Phase 5] grep: variables used in pipeline init and color state
  validation (6 callsites in amdgpu_dm_color.c)
- [Phase 6] Only 6.19.y stable tree affected; patch applies cleanly
- [Phase 8] Impact: incorrect color rendering for AMD GPU + compositor
  users; Severity: MEDIUM-HIGH

**YES**

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
index cc124ab6aa7f7..212c13b745d0c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
@@ -37,19 +37,19 @@ const u64 amdgpu_dm_supported_degam_tfs =
 	BIT(DRM_COLOROP_1D_CURVE_SRGB_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_PQ_125_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_BT2020_INV_OETF) |
-	BIT(DRM_COLOROP_1D_CURVE_GAMMA22_INV);
+	BIT(DRM_COLOROP_1D_CURVE_GAMMA22);
 
 const u64 amdgpu_dm_supported_shaper_tfs =
 	BIT(DRM_COLOROP_1D_CURVE_SRGB_INV_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_PQ_125_INV_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_BT2020_OETF) |
-	BIT(DRM_COLOROP_1D_CURVE_GAMMA22);
+	BIT(DRM_COLOROP_1D_CURVE_GAMMA22_INV);
 
 const u64 amdgpu_dm_supported_blnd_tfs =
 	BIT(DRM_COLOROP_1D_CURVE_SRGB_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_PQ_125_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_BT2020_INV_OETF) |
-	BIT(DRM_COLOROP_1D_CURVE_GAMMA22_INV);
+	BIT(DRM_COLOROP_1D_CURVE_GAMMA22);
 
 #define MAX_COLOR_PIPELINE_OPS 10
 
-- 
2.51.0

