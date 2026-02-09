Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B026E3019CB;
	Mon,  9 Feb 2026 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640037; cv=none; b=MLFWvjpTdah/jXetY2AF0ERkjCOIiHiyYgeDS5/b0Rm6T+JEbzIQd72bwh2ORuncFlJN0wQjdme/0sUzdtPQMwHbFUa1R5Lf5JSrkyrw+03pF/N/iAjMqxaCP4LV95fu4xfU++eGTxH+uRjeJ6JH0O1nkwRi1DaceYUCQVJ/Qiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640037; c=relaxed/simple;
	bh=hXP+E++WhJkVkqc8+HbBC2wTLj4aIgOppBb9nsxXmns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mYjhmCasYWA8/XT7MyjmBikpQwuoc9dEXxXe7dBBen8D7TUSSMK7aY8LeJkZVLtEC5JNM4vECNGBJtMoJy4gFDSoA8EhF+A2YwdYTBrA6mNqRSj//Ynr5CiOygwDbzydnaEVbuS4r7piD1hiwj9Br+Mxmqj5wQDiDqMzKpiuRu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6qmsC3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6qmsC3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D4CC116C6;
	Mon,  9 Feb 2026 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640037;
	bh=hXP+E++WhJkVkqc8+HbBC2wTLj4aIgOppBb9nsxXmns=;
	h=From:To:Cc:Subject:Date:From;
	b=G6qmsC3RhnsZVmwx1RLN0u83dz+fixxDGATD6vXKZ1bzS1ta9qejEWA79Mg5+ceL6
	 Lh+pvMYCotkykNVi3Kw9YUSETPUVnfz8uiAcJX2q/qQ3YFdWtZ8qM/wkZRQo6bA8d8
	 l53PUtQsH2R9QxNQU+vXFAdrbl0NipJak2Gv0uIMYPqPhEMA8YXIa7zJaSlVWqTYEl
	 RbSkGi7ew59VDO0EsJWA5zBu3lIn92vvaq/nKi12DQvXI04PRTGJgP3LaIFU5UEcAa
	 QsVGPwrkGxw5GUPrp6yXKl8nSMHIf5WakVCblAKo9bWzGEoP1FN3fc8A8s5b9JYfZt
	 XgmwTsYu8Bdwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alex.hung@amd.com,
	nicholas.kazlauskas@amd.com,
	ray.wu@amd.com,
	Karen.Chen@amd.com,
	Muhammad.Ahmed@amd.com,
	Wesley.Chalmers@amd.com,
	charlene.liu@amd.com,
	zaeem.mohamed@amd.com,
	rvojvodi@amd.com,
	dmytro.laktyushkin@amd.com,
	aurabindo.pillai@amd.com,
	Ilya.Bakoulin@amd.com,
	meenakshikumar.somasundaram@amd.com,
	alvin.lee2@amd.com,
	Dillon.Varone@amd.com,
	Yihan.Zhu@amd.com,
	peterson.guo@amd.com
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: extend delta clamping logic to CM3 LUT helper
Date: Mon,  9 Feb 2026 07:26:40 -0500
Message-ID: <20260209122714.1037915-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit d25b32aa829a3ed5570138e541a71fb7805faec3 ]

Commit 27fc10d1095f ("drm/amd/display: Fix the delta clamping for shaper
LUT") fixed banding when using plane shaper LUT in DCN10 CM helper.  The
problem is also present in DCN30 CM helper, fix banding by extending the
same bug delta clamping fix to CM3.

Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0274a54897f356f9c78767c4a2a5863f7dde90c6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit explicitly states it's extending a bug fix from DCN10 CM
helper to DCN30 CM helper. The referenced commit `27fc10d1095f`
("drm/amd/display: Fix the delta clamping for shaper LUT") fixed visual
banding artifacts when using plane shaper LUT. This commit applies the
same fix to the DCN30 (and DCN32, DCN401) code paths, which suffer from
the same banding problem.

### Code Change Analysis

Let me examine the actual changes in detail:

**1. Function signature change
(`cm3_helper_translate_curve_to_hw_format`)**:
- Adds `struct dc_context *ctx` as the first parameter
- This is needed to access `ctx->logger` for the `DC_LOG_ERROR` macro

**2. Core bug fix in `dcn30_cm_common.c`** (the important part):

The old code:
```c
rgb->delta_red_reg   = dc_fixpt_clamp_u0d10(rgb->delta_red);
rgb->delta_green_reg = dc_fixpt_clamp_u0d10(rgb->delta_green);
rgb->delta_blue_reg  = dc_fixpt_clamp_u0d10(rgb->delta_blue);
```

The new code:
```c
rgb->delta_red   = dc_fixpt_sub(rgb_plus_1->red,   rgb->red);
rgb->delta_green = dc_fixpt_sub(rgb_plus_1->green, rgb->green);
rgb->delta_blue  = dc_fixpt_sub(rgb_plus_1->blue,  rgb->blue);

red_clamp = dc_fixpt_clamp_u0d14(rgb->delta_red);
green_clamp = dc_fixpt_clamp_u0d14(rgb->delta_green);
blue_clamp = dc_fixpt_clamp_u0d14(rgb->delta_blue);

if (red_clamp >> 10 || green_clamp >> 10 || blue_clamp >> 10)
    DC_LOG_ERROR("Losing delta precision while programming shaper
LUT.");

rgb->delta_red_reg   = red_clamp & 0x3ff;
rgb->delta_green_reg = green_clamp & 0x3ff;
rgb->delta_blue_reg  = blue_clamp & 0x3ff;
```

The fix:
1. **Recalculates deltas** from the (potentially corrected) RGB values,
   rather than using stale delta values that may not account for the
   monotonicity corrections applied just above
2. **Clamps to u0d14** first (14-bit precision), then truncates to 10
   bits for the register, with a warning if precision is lost
3. The old code used `dc_fixpt_clamp_u0d10` directly which could produce
   incorrect delta values because the deltas weren't recalculated after
   the monotonicity fix

**3. All caller updates**: Every call site across dcn30, dcn32, and
dcn401 hwseq files is updated to pass the `ctx` parameter - purely
mechanical changes.

### Bug Classification

This is a **visual display bug fix** - banding artifacts when using
shaper LUT on DCN30+ hardware. Banding is a user-visible rendering
defect where smooth color gradients appear as discrete steps/bands
instead.

### Scope and Risk Assessment

**Scope**: The change touches 5 files across the AMD display subsystem:
- 1 core fix file (dcn30_cm_common.c)
- 1 header update (dcn30_cm_common.h)
- 3 caller update files (dcn30, dcn32, dcn401 hwseq)

**Risk concerns**:
1. **Function signature change**: This is an ABI-breaking change within
   the driver. All callers must be updated simultaneously. If any caller
   is missed in a backport, compilation will fail.
2. **Size**: The patch touches multiple files across multiple DCN
   generations. While the changes are logically simple, the breadth
   increases backport complexity.
3. **Dependency**: This commit depends on `27fc10d1095f`
   ("drm/amd/display: Fix the delta clamping for shaper LUT") being
   present for context, though the CM3 fix is self-contained.
4. **DCN401 code**: The dcn401 hwseq changes may not exist in older
   stable trees, requiring manual backport adjustments.

### Stable Kernel Criteria Assessment

- **Fixes a real bug**: Yes - visual banding artifacts on DCN30+ AMD
  GPUs
- **Obviously correct**: Yes - mirrors an already-accepted fix
  (27fc10d1095f) for DCN10
- **Small and contained**: Borderline - the core fix is small, but the
  function signature change propagates across many call sites
- **No new features**: Correct - this is purely a bug fix
- **Tested**: Has Reviewed-by from Harry Wentland (AMD display
  maintainer) and was cherry-picked

### Dependency Concerns

The commit was cherry-picked from mainline, suggesting it was already
selected for a stable-like branch. The function signature change means
this requires careful backporting - if the DCN401 files don't exist in
the target stable tree, those hunks need to be dropped. The prerequisite
commit `27fc10d1095f` should ideally be in the stable tree first (for
the DCN10 path), though the CM3 fix is technically independent.

### User Impact

AMD DCN30+ GPUs (RDNA 2 and later) are widely used in consumer desktops
and laptops. Banding in color gradients is a visible display quality
issue that affects all users of these GPUs when shaper LUTs are in use
(e.g., HDR content, color management workflows).

### Verdict

This fixes a real, user-visible display bug (banding) on widely-used AMD
GPU hardware. The fix is well-understood (same approach already applied
to DCN10), reviewed by the AMD display maintainer, and the core logic
change is small and correct. The main concern is the function signature
change requiring updates across multiple files, which increases backport
complexity but doesn't increase runtime risk - any missed caller would
result in a compilation error, not a silent bug. The fix is important
enough for display quality on modern AMD hardware that backporting is
warranted despite the moderate complexity.

**YES**

 .../amd/display/dc/dcn30/dcn30_cm_common.c    | 30 +++++++++++++++----
 .../display/dc/dwb/dcn30/dcn30_cm_common.h    |  2 +-
 .../amd/display/dc/hwss/dcn30/dcn30_hwseq.c   |  9 +++---
 .../amd/display/dc/hwss/dcn32/dcn32_hwseq.c   | 17 ++++++-----
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 16 +++++-----
 5 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
index 0690c346f2c52..509626e6edcfd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -105,9 +105,12 @@ void cm_helper_program_gamcor_xfer_func(
 #define NUMBER_REGIONS     32
 #define NUMBER_SW_SEGMENTS 16
 
-bool cm3_helper_translate_curve_to_hw_format(
-				const struct dc_transfer_func *output_tf,
-				struct pwl_params *lut_params, bool fixpoint)
+#define DC_LOGGER \
+		ctx->logger
+
+bool cm3_helper_translate_curve_to_hw_format(struct dc_context *ctx,
+					     const struct dc_transfer_func *output_tf,
+					     struct pwl_params *lut_params, bool fixpoint)
 {
 	struct curve_points3 *corner_points;
 	struct pwl_result_data *rgb_resulted;
@@ -248,6 +251,10 @@ bool cm3_helper_translate_curve_to_hw_format(
 	if (fixpoint == true) {
 		i = 1;
 		while (i != hw_points + 2) {
+			uint32_t red_clamp;
+			uint32_t green_clamp;
+			uint32_t blue_clamp;
+
 			if (i >= hw_points) {
 				if (dc_fixpt_lt(rgb_plus_1->red, rgb->red))
 					rgb_plus_1->red = dc_fixpt_add(rgb->red,
@@ -260,9 +267,20 @@ bool cm3_helper_translate_curve_to_hw_format(
 							rgb_minus_1->delta_blue);
 			}
 
-			rgb->delta_red_reg   = dc_fixpt_clamp_u0d10(rgb->delta_red);
-			rgb->delta_green_reg = dc_fixpt_clamp_u0d10(rgb->delta_green);
-			rgb->delta_blue_reg  = dc_fixpt_clamp_u0d10(rgb->delta_blue);
+			rgb->delta_red   = dc_fixpt_sub(rgb_plus_1->red,   rgb->red);
+			rgb->delta_green = dc_fixpt_sub(rgb_plus_1->green, rgb->green);
+			rgb->delta_blue  = dc_fixpt_sub(rgb_plus_1->blue,  rgb->blue);
+
+			red_clamp = dc_fixpt_clamp_u0d14(rgb->delta_red);
+			green_clamp = dc_fixpt_clamp_u0d14(rgb->delta_green);
+			blue_clamp = dc_fixpt_clamp_u0d14(rgb->delta_blue);
+
+			if (red_clamp >> 10 || green_clamp >> 10 || blue_clamp >> 10)
+				DC_LOG_ERROR("Losing delta precision while programming shaper LUT.");
+
+			rgb->delta_red_reg   = red_clamp & 0x3ff;
+			rgb->delta_green_reg = green_clamp & 0x3ff;
+			rgb->delta_blue_reg  = blue_clamp & 0x3ff;
 			rgb->red_reg         = dc_fixpt_clamp_u0d14(rgb->red);
 			rgb->green_reg       = dc_fixpt_clamp_u0d14(rgb->green);
 			rgb->blue_reg        = dc_fixpt_clamp_u0d14(rgb->blue);
diff --git a/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h b/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h
index b86347c9b0389..95f9318a54efc 100644
--- a/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h
+++ b/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h
@@ -59,7 +59,7 @@ void cm_helper_program_gamcor_xfer_func(
 	const struct pwl_params *params,
 	const struct dcn3_xfer_func_reg *reg);
 
-bool cm3_helper_translate_curve_to_hw_format(
+bool cm3_helper_translate_curve_to_hw_format(struct dc_context *ctx,
 	const struct dc_transfer_func *output_tf,
 	struct pwl_params *lut_params, bool fixpoint);
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
index e47ed5571dfdd..731645a2ab9aa 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -238,7 +238,7 @@ bool dcn30_set_blend_lut(
 	if (plane_state->blend_tf.type == TF_TYPE_HWPWL)
 		blend_lut = &plane_state->blend_tf.pwl;
 	else if (plane_state->blend_tf.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		result = cm3_helper_translate_curve_to_hw_format(
+		result = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
 				&plane_state->blend_tf, &dpp_base->regamma_params, false);
 		if (!result)
 			return result;
@@ -333,8 +333,9 @@ bool dcn30_set_input_transfer_func(struct dc *dc,
 	if (plane_state->in_transfer_func.type == TF_TYPE_HWPWL)
 		params = &plane_state->in_transfer_func.pwl;
 	else if (plane_state->in_transfer_func.type == TF_TYPE_DISTRIBUTED_POINTS &&
-		cm3_helper_translate_curve_to_hw_format(&plane_state->in_transfer_func,
-				&dpp_base->degamma_params, false))
+		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							&plane_state->in_transfer_func,
+							&dpp_base->degamma_params, false))
 		params = &dpp_base->degamma_params;
 
 	result = dpp_base->funcs->dpp_program_gamcor_lut(dpp_base, params);
@@ -405,7 +406,7 @@ bool dcn30_set_output_transfer_func(struct dc *dc,
 				params = &stream->out_transfer_func.pwl;
 			else if (pipe_ctx->stream->out_transfer_func.type ==
 					TF_TYPE_DISTRIBUTED_POINTS &&
-					cm3_helper_translate_curve_to_hw_format(
+					cm3_helper_translate_curve_to_hw_format(stream->ctx,
 					&stream->out_transfer_func,
 					&mpc->blender_params, false))
 				params = &mpc->blender_params;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index f39292952702f..30bb5d8d85dc2 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -486,8 +486,9 @@ bool dcn32_set_mcm_luts(
 	if (plane_state->blend_tf.type == TF_TYPE_HWPWL)
 		lut_params = &plane_state->blend_tf.pwl;
 	else if (plane_state->blend_tf.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		result = cm3_helper_translate_curve_to_hw_format(&plane_state->blend_tf,
-				&dpp_base->regamma_params, false);
+		result = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+								 &plane_state->blend_tf,
+								 &dpp_base->regamma_params, false);
 		if (!result)
 			return result;
 
@@ -502,8 +503,9 @@ bool dcn32_set_mcm_luts(
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
 		ASSERT(false);
-		cm3_helper_translate_curve_to_hw_format(&plane_state->in_shaper_func,
-				&dpp_base->shaper_params, true);
+		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							&plane_state->in_shaper_func,
+							&dpp_base->shaper_params, true);
 		lut_params = &dpp_base->shaper_params;
 	}
 
@@ -543,8 +545,9 @@ bool dcn32_set_input_transfer_func(struct dc *dc,
 	if (plane_state->in_transfer_func.type == TF_TYPE_HWPWL)
 		params = &plane_state->in_transfer_func.pwl;
 	else if (plane_state->in_transfer_func.type == TF_TYPE_DISTRIBUTED_POINTS &&
-		cm3_helper_translate_curve_to_hw_format(&plane_state->in_transfer_func,
-				&dpp_base->degamma_params, false))
+		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							&plane_state->in_transfer_func,
+							&dpp_base->degamma_params, false))
 		params = &dpp_base->degamma_params;
 
 	dpp_base->funcs->dpp_program_gamcor_lut(dpp_base, params);
@@ -575,7 +578,7 @@ bool dcn32_set_output_transfer_func(struct dc *dc,
 				params = &stream->out_transfer_func.pwl;
 			else if (pipe_ctx->stream->out_transfer_func.type ==
 					TF_TYPE_DISTRIBUTED_POINTS &&
-					cm3_helper_translate_curve_to_hw_format(
+					cm3_helper_translate_curve_to_hw_format(stream->ctx,
 					&stream->out_transfer_func,
 					&mpc->blender_params, false))
 				params = &mpc->blender_params;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 68e48a2492c9e..77cdd02a41bdd 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -427,7 +427,7 @@ void dcn401_populate_mcm_luts(struct dc *dc,
 		if (mcm_luts.lut1d_func->type == TF_TYPE_HWPWL)
 			m_lut_params.pwl = &mcm_luts.lut1d_func->pwl;
 		else if (mcm_luts.lut1d_func->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			rval = cm3_helper_translate_curve_to_hw_format(
+			rval = cm3_helper_translate_curve_to_hw_format(mpc->ctx,
 					mcm_luts.lut1d_func,
 					&dpp_base->regamma_params, false);
 			m_lut_params.pwl = rval ? &dpp_base->regamma_params : NULL;
@@ -447,7 +447,7 @@ void dcn401_populate_mcm_luts(struct dc *dc,
 			m_lut_params.pwl = &mcm_luts.shaper->pwl;
 		else if (mcm_luts.shaper->type == TF_TYPE_DISTRIBUTED_POINTS) {
 			ASSERT(false);
-			rval = cm3_helper_translate_curve_to_hw_format(
+			rval = cm3_helper_translate_curve_to_hw_format(mpc->ctx,
 					mcm_luts.shaper,
 					&dpp_base->regamma_params, true);
 			m_lut_params.pwl = rval ? &dpp_base->regamma_params : NULL;
@@ -624,8 +624,9 @@ bool dcn401_set_mcm_luts(struct pipe_ctx *pipe_ctx,
 	if (plane_state->blend_tf.type == TF_TYPE_HWPWL)
 		lut_params = &plane_state->blend_tf.pwl;
 	else if (plane_state->blend_tf.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		rval = cm3_helper_translate_curve_to_hw_format(&plane_state->blend_tf,
-				&dpp_base->regamma_params, false);
+		rval = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							       &plane_state->blend_tf,
+							       &dpp_base->regamma_params, false);
 		lut_params = rval ? &dpp_base->regamma_params : NULL;
 	}
 	result = mpc->funcs->program_1dlut(mpc, lut_params, mpcc_id);
@@ -636,8 +637,9 @@ bool dcn401_set_mcm_luts(struct pipe_ctx *pipe_ctx,
 		lut_params = &plane_state->in_shaper_func.pwl;
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
-		rval = cm3_helper_translate_curve_to_hw_format(&plane_state->in_shaper_func,
-				&dpp_base->shaper_params, true);
+		rval = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							       &plane_state->in_shaper_func,
+							       &dpp_base->shaper_params, true);
 		lut_params = rval ? &dpp_base->shaper_params : NULL;
 	}
 	result &= mpc->funcs->program_shaper(mpc, lut_params, mpcc_id);
@@ -671,7 +673,7 @@ bool dcn401_set_output_transfer_func(struct dc *dc,
 				params = &stream->out_transfer_func.pwl;
 			else if (pipe_ctx->stream->out_transfer_func.type ==
 					TF_TYPE_DISTRIBUTED_POINTS &&
-					cm3_helper_translate_curve_to_hw_format(
+					cm3_helper_translate_curve_to_hw_format(stream->ctx,
 					&stream->out_transfer_func,
 					&mpc->blender_params, false))
 				params = &mpc->blender_params;
-- 
2.51.0

