Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213982;
	b=PP9UIXAjOLz7iroSMw2hDIVmg5bOoqTASNddBKg4kir9IkYcjEdPBz7UhAYCdnHrHwXM
	 1uc05jbP6ErJM7/P/JEEEkcF9tP1yQIurTiW96+QbhfmmQgiDHZtvL3wsPaBnaEz9QT1p
	 KQy8q0Iax++8SHWEK1DPp9YGqsyR37DD6LopZBIg0w0Bjf0DXxYZlUXg8aycTfAaDzbnE
	 ZOnGGb/t0cHk8wbWFak2/swO8NiuvVww9PZJqIazLPENEyrq09lUGjCYUymUrsJHthVR3
	 RMfcDSIKasEzmihYpXr4HN8WZKOcPwwtHZSP+SIMtGz8WwHIKTOoH7IsgfE9QZtSFrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BurFSJZ0zUV86V9zzm1/8ea3xDM21kWwxK+UCQuFP9Y=;
	b=1oDkVOCEDC6Czrb2IkxMDmvuTD7CHPe7LZjpN9r7/OEPKAMsuS5hKibi5fEVyri6/Ksd
	 fEEbZeE8SZX4hE55sM+FEB+s+xGQOpmBwCZX6LRT1VIn/dj2rZ0eU/eRYxiDH+i5muJgr
	 6K/xEpkTOvgekXj5EOyPyuB55ksZ+556WzZKAGZVBs41KSeknVIBMa0ojNdAjrLfAN06d
	 vBUyAPGgmz6FUb7opo1Nr+XXb0uCkFmh+KUzbBidmC+7Q6Y90KFeyHsH3cEUUydK2cIxI
	 +8oLCUfrgcCBonPlMRu9bOyHkW3s8YrhdBbNW6hs6SOpuRK+PIKSxdx14zIC3QWqRuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tj+D89VG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C140606A31C;
	Wed, 28 Oct 2026 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tj+D89VG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FCD1F01825;
	Wed, 28 Oct 2026 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213982;
	bh=BurFSJZ0zUV86V9zzm1/8ea3xDM21kWwxK+UCQuFP9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tj+D89VGEkiVETg+6HpOqJb/QQerN+oxpUlJsMsPfd2EjSswN9OkRW77Uauk1cE2r
	 7CEampimmzY2KlzGMfdGa0UVJJfGDuvOpLS5C0my6kFIlYNrd1YGTSZhTWa8HfDjRF
	 WMfiJL6g1WvnTbwQlXC5BUWVX4G3fIfhORnLbQzk=
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
Subject: [PATCH 6.1 0671/1887] drm/amd/display: Check null pointers before used
Date: Wed, 28 Oct 2026 17:46:07 +0100
Message-ID: <20261028170514.682130981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c             | 2 +-
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c  | 5 +++--
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c            | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c    | 4 ++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c            | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c           | 4 ++--
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
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index f87c6174b7040..fa0ae49fa22b0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3330,7 +3330,7 @@ bool dp_verify_link_cap_with_retries(
 
 		memset(&link->verified_link_cap, 0,
 				sizeof(struct dc_link_settings));
-		if (!dc_link_detect_sink(link, &type) || type == dc_connection_none) {
+		if (link->link_enc && (!dc_link_detect_sink(link, &type) || type == dc_connection_none)) {
 			link->verified_link_cap = fail_safe_link_settings;
 			break;
 		} else if (dp_verify_link_cap(link, known_limit_link_setting,
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index c542d2ab9160e..d2e71bf6b8f52 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -963,7 +963,7 @@ void dce110_edp_backlight_control(
 {
 	struct dc_context *ctx = link->ctx;
 	struct bp_transmitter_control cntl = { 0 };
-	uint8_t panel_instance;
+	uint8_t panel_instance = 0;
 	unsigned int pre_T11_delay = OLED_PRE_T11_DELAY;
 	unsigned int post_T7_delay = OLED_POST_T7_DELAY;
 
@@ -1016,7 +1016,8 @@ void dce110_edp_backlight_control(
 	 */
 	/* dc_service_sleep_in_milliseconds(50); */
 		/*edp 1.2*/
-	panel_instance = link->panel_cntl->inst;
+	if (link->panel_cntl)
+		panel_instance = link->panel_cntl->inst;
 
 	if (cntl.action == TRANSMITTER_CONTROL_BACKLIGHT_ON) {
 		if (!link->dc->config.edp_no_power_sequencing)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
index a142a00bc4326..3bedc96714ceb 100644
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
index b120aa67d26c1..e2e8823f1371f 100644
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
@@ -1630,7 +1630,7 @@ void dcn10_init_hw(struct dc *dc)
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
index d4ee533deff32..2ef1c227f1051 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -281,10 +281,10 @@ void dcn31_init_hw(struct dc *dc)
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 
-	if (dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
+	if (dc->clk_mgr && dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
 		dc->clk_mgr->funcs->set_hard_max_memclk(dc->clk_mgr);
 
 	if (dc->res_pool->hubbub->funcs->force_pstate_change_control)
-- 
2.53.0



