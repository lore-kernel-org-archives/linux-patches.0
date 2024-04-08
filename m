Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610092DF73;
	Mon,  8 Apr 2024 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582445; cv=none; b=dQbxSuZi6MjRmbd2kDu4LWaQEZ68zQM/KvsmrCuIu1GZKGml8OENJZBWPUOlqjWfE6LDVQzzMeJ84UosLGJXe+yOCDjQjhU+bnpeLTue1fM1lYJatAJ70CaJ7oUgUYxGDOL6439wtCwJkMTUU7X7xAgKY0nGrmeaRyAOb0XXjeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582445; c=relaxed/simple;
	bh=my7TQDZ9AxwfyHa/ju6Z40LEbDFIR0JWFanu8CdUFhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxpYoJWHXhMXWV+cdrDmbTithdLD0e6jpTg613CdhIo0BIjowORF8w2lB+1RWuhGNMvMKiZE5WhDWyEAsCnnTP/Qsk8ZypZpBjAl1XTwID5kdBy+TAgwKPxzxEQS25pTqzdq58wS0qTDcpBQRYLhwFDEjKjRF3ERJHpImWd1psc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWqdIo8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWqdIo8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3532C433F1;
	Mon,  8 Apr 2024 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582445;
	bh=my7TQDZ9AxwfyHa/ju6Z40LEbDFIR0JWFanu8CdUFhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWqdIo8EE7j1sLcagU2PW2GBFriYPhhsLyZoGPWQFdKi15QbGrPeMYWe8ab0k9gwG
	 Vr2x4RRuemCDLKC+I5kIaxQLLZcm6ll8Y4iMgIqb2cK1bC8+iY3moqjyycCfKu2dv0
	 kPaLK2Z/bqanv5jZ0kULfsW5q3kHwCTBOMrTIZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Harish Chegondi <harish.chegondi@intel.com>,
	Haridhar Kalvala <haridhar.kalvala@intel.com>,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 055/273] drm/i915/xelpg: Extend some workarounds/tuning to gfx version 12.74
Date: Mon,  8 Apr 2024 14:55:30 +0200
Message-ID: <20240408125311.012121449@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit c44d4ef47fdad0a33966de89f9064e19736bb52f ]

Some of our existing Xe_LPG workarounds and tuning are also applicable
to the version 12.74 variant.  Extend the condition bounds accordingly.
Also fix the comment on Wa_14018575942 while we're at it.

v2: Extend some more workarounds (Harish)

Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Signed-off-by: Haridhar Kalvala <haridhar.kalvala@intel.com>
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240108122738.14399-4-haridhar.kalvala@intel.com
Stable-dep-of: 186bce682772 ("drm/i915/mtl: Update workaround 14018575942")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_engine_cs.c    |  4 ++--
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 24 +++++++++++++--------
 drivers/gpu/drm/i915/i915_perf.c            |  2 +-
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
index 86a04afff64b3..e1bf13e3d3070 100644
--- a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
@@ -226,7 +226,7 @@ u32 *gen12_emit_aux_table_inv(struct intel_engine_cs *engine, u32 *cs)
 static int mtl_dummy_pipe_control(struct i915_request *rq)
 {
 	/* Wa_14016712196 */
-	if (IS_GFX_GT_IP_RANGE(rq->engine->gt, IP_VER(12, 70), IP_VER(12, 71)) ||
+	if (IS_GFX_GT_IP_RANGE(rq->engine->gt, IP_VER(12, 70), IP_VER(12, 74)) ||
 	    IS_DG2(rq->i915)) {
 		u32 *cs;
 
@@ -822,7 +822,7 @@ u32 *gen12_emit_fini_breadcrumb_rcs(struct i915_request *rq, u32 *cs)
 		flags |= PIPE_CONTROL_FLUSH_L3;
 
 	/* Wa_14016712196 */
-	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)) || IS_DG2(i915))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74)) || IS_DG2(i915))
 		/* dummy PIPE_CONTROL + depth flush */
 		cs = gen12_emit_pipe_control(cs, 0,
 					     PIPE_CONTROL_DEPTH_CACHE_FLUSH, 0);
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 3eacbc50caf8d..72dac27d9332f 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -789,8 +789,13 @@ static void xelpg_ctx_gt_tuning_init(struct intel_engine_cs *engine,
 
 	dg2_ctx_gt_tuning_init(engine, wal);
 
-	if (IS_GFX_GT_IP_STEP(gt, IP_VER(12, 70), STEP_B0, STEP_FOREVER) ||
-	    IS_GFX_GT_IP_STEP(gt, IP_VER(12, 71), STEP_B0, STEP_FOREVER))
+	/*
+	 * Due to Wa_16014892111, the DRAW_WATERMARK tuning must be done in
+	 * gen12_emit_indirect_ctx_rcs() rather than here on some early
+	 * steppings.
+	 */
+	if (!(IS_GFX_GT_IP_STEP(gt, IP_VER(12, 70), STEP_A0, STEP_B0) ||
+	      IS_GFX_GT_IP_STEP(gt, IP_VER(12, 71), STEP_A0, STEP_B0)))
 		wa_add(wal, DRAW_WATERMARK, VERT_WM_VAL, 0x3FF, 0, false);
 }
 
@@ -908,7 +913,7 @@ __intel_engine_init_ctx_wa(struct intel_engine_cs *engine,
 	if (engine->class != RENDER_CLASS)
 		goto done;
 
-	if (IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 70), IP_VER(12, 71)))
+	if (IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 70), IP_VER(12, 74)))
 		xelpg_ctx_workarounds_init(engine, wal);
 	else if (IS_PONTEVECCHIO(i915))
 		; /* noop; none at this time */
@@ -1643,7 +1648,7 @@ pvc_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 static void
 xelpg_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 {
-	/* Wa_14018778641 / Wa_18018781329 */
+	/* Wa_14018575942 / Wa_18018781329 */
 	wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
 
 	/* Wa_22016670082 */
@@ -1710,7 +1715,7 @@ xelpmp_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
  */
 static void gt_tuning_settings(struct intel_gt *gt, struct i915_wa_list *wal)
 {
-	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71))) {
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74))) {
 		wa_mcr_write_or(wal, XEHP_L3SCQREG7, BLEND_FILL_CACHING_OPT_DIS);
 		wa_mcr_write_or(wal, XEHP_SQCM, EN_32B_ACCESS);
 	}
@@ -1743,7 +1748,7 @@ gt_init_workarounds(struct intel_gt *gt, struct i915_wa_list *wal)
 		return;
 	}
 
-	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74)))
 		xelpg_gt_workarounds_init(gt, wal);
 	else if (IS_PONTEVECCHIO(i915))
 		pvc_gt_workarounds_init(gt, wal);
@@ -2216,7 +2221,7 @@ void intel_engine_init_whitelist(struct intel_engine_cs *engine)
 
 	if (engine->gt->type == GT_MEDIA)
 		; /* none yet */
-	else if (IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 70), IP_VER(12, 71)))
+	else if (IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 70), IP_VER(12, 74)))
 		xelpg_whitelist_build(engine);
 	else if (IS_PONTEVECCHIO(i915))
 		pvc_whitelist_build(engine);
@@ -2828,7 +2833,7 @@ add_render_compute_tuning_settings(struct intel_gt *gt,
 {
 	struct drm_i915_private *i915 = gt->i915;
 
-	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)) || IS_DG2(i915))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74)) || IS_DG2(i915))
 		wa_mcr_write_clr_set(wal, RT_CTRL, STACKID_CTRL, STACKID_CTRL_512);
 
 	/*
@@ -2881,7 +2886,8 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 	}
 
 	if (IS_GFX_GT_IP_STEP(gt, IP_VER(12, 70), STEP_B0, STEP_FOREVER) ||
-	    IS_GFX_GT_IP_STEP(gt, IP_VER(12, 71), STEP_B0, STEP_FOREVER))
+	    IS_GFX_GT_IP_STEP(gt, IP_VER(12, 71), STEP_B0, STEP_FOREVER) ||
+	    IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 74), IP_VER(12, 74)))
 		/* Wa_14017856879 */
 		wa_mcr_masked_en(wal, GEN9_ROW_CHICKEN3, MTL_DISABLE_FIX_FOR_EOT_FLUSH);
 
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 2d695818f0062..bd9d812b1afa7 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -3225,7 +3225,7 @@ u32 i915_perf_oa_timestamp_frequency(struct drm_i915_private *i915)
 	struct intel_gt *gt = to_gt(i915);
 
 	/* Wa_18013179988 */
-	if (IS_DG2(i915) || IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71))) {
+	if (IS_DG2(i915) || IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74))) {
 		intel_wakeref_t wakeref;
 		u32 reg, shift;
 
-- 
2.43.0



