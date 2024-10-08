Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319711DE2CF;
	Tue,  8 Oct 2024 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391865; cv=none; b=dpGTcy4kqQ40UOrxEdVLBW+fujn3Rva8IeROlU12LCnTje4az2eV5CHdlpTdIDgiq72WZaZrVftgDI/HVGfGxzQkBg6qoiGd2RxCvJ7cdKIuaI+1xtI/K6pWN6CBp+ipHE3mVeZXz4MlDjPl4lSlD/DPI/fs9uNkRV9gK3iv5KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391865; c=relaxed/simple;
	bh=6ul1ueODuLorEpPNRKvPOlBbU+HzG4KQUsHsHj3SMN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezhtXG44mLg/jUfmP/1O3bOFZAmWpIyIqUg2g/BSuy1zv3D5+lOEq3elvJP59pZL/+GI3vLHJqcTvhgVVlssGlVrqxSgHYIyOM7LozEq+xbpYXhd0OKbARLrecsQ9rKLEFtzUNyexkfp9qVx4K6SrpbsCyywoidLJazwfrxlogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAeetx75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAeetx75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B39C4CECC;
	Tue,  8 Oct 2024 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391864;
	bh=6ul1ueODuLorEpPNRKvPOlBbU+HzG4KQUsHsHj3SMN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAeetx75q4ZwEcmxbwFeqzFCFV7UoACIsxAcHm79i7qNijRTg2cM8uD/5nEwgUGr4
	 F+sCNjURPpkz3LbwOpmqVCpgpi/YlNpYwIkLxu9GhToaCpVT6AEz4DwCY9Aeckr7ys
	 mt8Gzu68ZA8vNO6W/+dpnx72gQ0XnmJUsKgBmIGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 205/558] drm/amd/display: Check null pointers before used
Date: Tue,  8 Oct 2024 14:03:55 +0200
Message-ID: <20241008115710.412050604@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit be1fb44389ca3038ad2430dac4234669bc177ee3 ]

[WHAT & HOW]
Poniters, such as dc->clk_mgr, are null checked previously in the same
function, so Coverity warns "implies that "dc->clk_mgr" might be null".
As a result, these pointers need to be checked when used again.

This fixes 10 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c    | 2 +-
 drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c    | 3 ++-
 drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c    | 3 ++-
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 5 +++--
 drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c   | 4 ++--
 drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c   | 4 ++--
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c   | 8 ++++----
 .../amd/display/dc/link/protocols/link_dp_capability.c    | 2 +-
 8 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
index 78df96882d6ec..f8409453434c1 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -195,7 +195,7 @@ void dce11_pplib_apply_display_requirements(
 	 * , then change minimum memory clock based on real-time bandwidth
 	 * limitation.
 	 */
-	if ((dc->ctx->asic_id.chip_family == FAMILY_AI) &&
+	if (dc->bw_vbios && (dc->ctx->asic_id.chip_family == FAMILY_AI) &&
 	     ASICREV_IS_VEGA20_P(dc->ctx->asic_id.hw_internal_rev) && (context->stream_count >= 2)) {
 		pp_display_cfg->min_memory_clock_khz = max(pp_display_cfg->min_memory_clock_khz,
 							   (uint32_t) div64_s64(
diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
index bf399819ca800..22ac2b7e49aea 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
@@ -749,7 +749,8 @@ bool hubp1_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (hubp &&
+	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
index 6bba020ad6fbf..0637e4c552d8a 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
@@ -927,7 +927,8 @@ bool hubp2_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (hubp &&
+	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index fc0d2077aaec4..96371dac72fc1 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -950,7 +950,7 @@ void dce110_edp_backlight_control(
 {
 	struct dc_context *ctx = link->ctx;
 	struct bp_transmitter_control cntl = { 0 };
-	uint8_t pwrseq_instance;
+	uint8_t pwrseq_instance = 0;
 	unsigned int pre_T11_delay = OLED_PRE_T11_DELAY;
 	unsigned int post_T7_delay = OLED_POST_T7_DELAY;
 
@@ -1003,7 +1003,8 @@ void dce110_edp_backlight_control(
 	 */
 	/* dc_service_sleep_in_milliseconds(50); */
 		/*edp 1.2*/
-	pwrseq_instance = link->panel_cntl->pwrseq_inst;
+	if (link->panel_cntl)
+		pwrseq_instance = link->panel_cntl->pwrseq_inst;
 
 	if (cntl.action == TRANSMITTER_CONTROL_BACKLIGHT_ON) {
 		if (!link->dc->config.edp_no_power_sequencing)
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
index 1d2be574f6680..83942abd08e84 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -1554,7 +1554,7 @@ void dcn10_init_hw(struct dc *dc)
 		dc->clk_mgr->funcs->init_clocks(dc->clk_mgr);
 
 	/* Align bw context with hw config when system resume. */
-	if (dc->clk_mgr->clks.dispclk_khz != 0 && dc->clk_mgr->clks.dppclk_khz != 0) {
+	if (dc->clk_mgr && dc->clk_mgr->clks.dispclk_khz != 0 && dc->clk_mgr->clks.dppclk_khz != 0) {
 		dc->current_state->bw_ctx.bw.dcn.clk.dispclk_khz = dc->clk_mgr->clks.dispclk_khz;
 		dc->current_state->bw_ctx.bw.dcn.clk.dppclk_khz = dc->clk_mgr->clks.dppclk_khz;
 	}
@@ -1674,7 +1674,7 @@ void dcn10_init_hw(struct dc *dc)
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
index 746c522adf84c..3d4b31bd99469 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
@@ -256,10 +256,10 @@ void dcn31_init_hw(struct dc *dc)
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 
-	if (dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
 		dc->clk_mgr->funcs->set_hard_max_memclk(dc->clk_mgr);
 
 	if (dc->res_pool->hubbub->funcs->force_pstate_change_control)
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index 80db40787e019..12a39dbc35419 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -235,7 +235,7 @@ void dcn35_init_hw(struct dc *dc)
 	if (hws->funcs.enable_power_gating_plane)
 		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 */
-	if (res_pool->hubbub->funcs->dchubbub_init)
+	if (res_pool->hubbub && res_pool->hubbub->funcs->dchubbub_init)
 		res_pool->hubbub->funcs->dchubbub_init(dc->res_pool->hubbub);
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
@@ -328,10 +328,10 @@ void dcn35_init_hw(struct dc *dc)
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 
-	if (dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
 		dc->clk_mgr->funcs->set_hard_max_memclk(dc->clk_mgr);
 
 
@@ -1054,7 +1054,7 @@ void dcn35_calc_blocks_to_gate(struct dc *dc, struct dc_state *context,
 		if (pipe_ctx->plane_res.hubp)
 			update_state->pg_pipe_res_update[PG_HUBP][pipe_ctx->plane_res.hubp->inst] = false;
 
-		if (pipe_ctx->plane_res.dpp)
+		if (pipe_ctx->plane_res.dpp && pipe_ctx->plane_res.hubp)
 			update_state->pg_pipe_res_update[PG_DPP][pipe_ctx->plane_res.hubp->inst] = false;
 
 		if (pipe_ctx->plane_res.dpp || pipe_ctx->stream_res.opp)
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 46bb7a855bc21..60015e94c4aa8 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -2254,7 +2254,7 @@ bool dp_verify_link_cap_with_retries(
 
 		memset(&link->verified_link_cap, 0,
 				sizeof(struct dc_link_settings));
-		if (!link_detect_connection_type(link, &type) || type == dc_connection_none) {
+		if (link->link_enc && (!link_detect_connection_type(link, &type) || type == dc_connection_none)) {
 			link->verified_link_cap = fail_safe_link_settings;
 			break;
 		} else if (dp_verify_link_cap(link, known_limit_link_setting, &fail_count)) {
-- 
2.43.0



