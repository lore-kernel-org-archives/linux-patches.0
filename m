Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0083B2FD9;
	Sat, 17 Oct 2026 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257732; cv=none; b=kihO2y5WvEL2FGKiY+2Aeh39KmquUsI7iIXPVoic27Pmuxv63CeUo1aE+1XBo7aKedmvSLrt5QvW87uxEwS9YtNxyl8E0Es6FTTaiaays/H50A8xmJNrhdAchR6XRenGuyBIRpteZBKspFGHlYRG/ZJnPvEOeQFgjA0EsZHPiDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257732; c=relaxed/simple;
	bh=MLwgnQHWbcktSsUlbPnVVKAx730V/wfSlOVJroxpuxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEeKwgwFwjHvuyLLAt3NCY3QsExCPRecAC8b4U8O/47uYn69tsX//08ImZMCKmffj2B3BW51MAXmquZtkad336sYD1Osw0GsqK64/U02MzbVBnOmBblNng8kPwmUKWfsHY3lyTSHxXuxTSOBo9asQk+H6j4sV3QJe+hUwY2AVb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rv3kbX1N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rv3kbX1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBA21F000C4;
	Sat, 17 Oct 2026 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257730;
	bh=oG/9qLTp2+tX8zvc+VjH8GPMbwZDIVVcOzs4QASYpbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rv3kbX1NtGEGVBc0GdDAogS1i2DJrT+QF9pcOpL72VdnljPkTKGIWj7+FUWMKYE2S
	 cTs26MAM2l57pzEEusn7raiFM2VaUM8w1XEBLoYvWILnBOWfraf77BwKNJApMhDemb
	 8qYFaoARway9xbMdBuylnSZea9RvcIn+V+6xqdIg=
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
Subject: [PATCH 6.6 0651/1674] drm/amd/display: Check null pointers before used
Date: Sat, 17 Oct 2026 17:48:43 +0200
Message-ID: <20261017160447.820458896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 .../gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c  | 5 +++--
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c            | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c    | 4 ++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c            | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c           | 4 ++--
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c   | 2 +-
 7 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
index bce53ab36f3e5..d50b9440210e4 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -218,7 +218,7 @@ void dce11_pplib_apply_display_requirements(
 	 * , then change minimum memory clock based on real-time bandwidth
 	 * limitation.
 	 */
-	if ((dc->ctx->asic_id.chip_family == FAMILY_AI) &&
+	if (dc->bw_vbios && (dc->ctx->asic_id.chip_family == FAMILY_AI) &&
 	     ASICREV_IS_VEGA20_P(dc->ctx->asic_id.hw_internal_rev) && (context->stream_count >= 2)) {
 		pp_display_cfg->min_memory_clock_khz = max(pp_display_cfg->min_memory_clock_khz,
 							   (uint32_t) div64_s64(
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 14f5b4f00f724..ef65f78fd3265 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -954,7 +954,7 @@ void dce110_edp_backlight_control(
 {
 	struct dc_context *ctx = link->ctx;
 	struct bp_transmitter_control cntl = { 0 };
-	uint8_t pwrseq_instance;
+	uint8_t pwrseq_instance = 0;
 	unsigned int pre_T11_delay = OLED_PRE_T11_DELAY;
 	unsigned int post_T7_delay = OLED_POST_T7_DELAY;
 
@@ -1007,7 +1007,8 @@ void dce110_edp_backlight_control(
 	 */
 	/* dc_service_sleep_in_milliseconds(50); */
 		/*edp 1.2*/
-	pwrseq_instance = link->panel_cntl->pwrseq_inst;
+	if (link->panel_cntl)
+		pwrseq_instance = link->panel_cntl->pwrseq_inst;
 
 	if (cntl.action == TRANSMITTER_CONTROL_BACKLIGHT_ON) {
 		if (!link->dc->config.edp_no_power_sequencing)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
index bf399819ca800..22ac2b7e49aea 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
@@ -749,7 +749,8 @@ bool hubp1_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (hubp &&
+	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index e71b79f5a66cd..17f2a39d91a72 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1490,7 +1490,7 @@ void dcn10_init_hw(struct dc *dc)
 		dc->clk_mgr->funcs->init_clocks(dc->clk_mgr);
 
 	/* Align bw context with hw config when system resume. */
-	if (dc->clk_mgr->clks.dispclk_khz != 0 && dc->clk_mgr->clks.dppclk_khz != 0) {
+	if (dc->clk_mgr && dc->clk_mgr->clks.dispclk_khz != 0 && dc->clk_mgr->clks.dppclk_khz != 0) {
 		dc->current_state->bw_ctx.bw.dcn.clk.dispclk_khz = dc->clk_mgr->clks.dispclk_khz;
 		dc->current_state->bw_ctx.bw.dcn.clk.dppclk_khz = dc->clk_mgr->clks.dppclk_khz;
 	}
@@ -1608,7 +1608,7 @@ void dcn10_init_hw(struct dc *dc)
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c
index aa252dc263267..4040ec51ac578 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c
@@ -925,7 +925,8 @@ bool hubp2_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (hubp &&
+	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 22da2007601ee..31065b4fa3d92 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -254,10 +254,10 @@ void dcn31_init_hw(struct dc *dc)
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 
-	if (dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
 		dc->clk_mgr->funcs->set_hard_max_memclk(dc->clk_mgr);
 
 	if (dc->res_pool->hubbub->funcs->force_pstate_change_control)
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 56999657f4d86..8ffa6739640e5 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -2217,7 +2217,7 @@ bool dp_verify_link_cap_with_retries(
 
 		memset(&link->verified_link_cap, 0,
 				sizeof(struct dc_link_settings));
-		if (!link_detect_connection_type(link, &type) || type == dc_connection_none) {
+		if (link->link_enc && (!link_detect_connection_type(link, &type) || type == dc_connection_none)) {
 			link->verified_link_cap = fail_safe_link_settings;
 			break;
 		} else if (dp_verify_link_cap(link, known_limit_link_setting, &fail_count)) {
-- 
2.53.0



