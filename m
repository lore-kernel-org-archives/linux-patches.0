Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4801313A244;
	Tue, 27 May 2025 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364273; cv=none; b=XpMaDA5b8r0bBiSMhP+kJShsIXfUieIpWFCW2pojTsbTwkR4mPCWseVlqIqjsVKtbz+caCuwI7K228UNZhj5ZCWuJSX4NzS3PHe4O3spD6TT6HmHrL6A4UREB7NrUVvDPgZQVweSEffqlGQp0uHQLN6JCQR5TvaCsg6xe35cYaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364273; c=relaxed/simple;
	bh=gzyWRFIzIAtCRrq1xmKesblpRit84UrlKGjGe/d2vig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iieAaKYejMona4nqDLnLr6T7l0E/f30KScIwk/Er3PfCBbYJHuhYOAPYLTKFwdhlfE9HQC3acZ/dCfB2EFkb612H0jEYoXZ8HkJyAiPtVEO29azDpc33Qn/s6C6M4mp82/kayM0p6ecp7sA50MJMNHXjc/hD17SvLb5PkP7CqGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6YfCkp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6YfCkp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8FEC4CEEB;
	Tue, 27 May 2025 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364270;
	bh=gzyWRFIzIAtCRrq1xmKesblpRit84UrlKGjGe/d2vig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6YfCkp/ya9sDUCgWwOLHQBY4zhkwvdx7u37v8kGerT9vOgQP3TG4Z9WK8fxtUqD1
	 XkmLxU/hWMTEZBTQm0nakzBj1IYTAnJPzE5Mo0WVwCje4pk+oOYHb2t9DzkzqkheF9
	 0NBAJ3P5u3WZO9Z/ZgeAXHW6MNAh3YibJPxowBKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Koo <anthony.koo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Danny Wang <danny.wang@amd.com>,
	Zhongwei Zhang <Zhongwei.Zhang@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/626] drm/amd/display: Do not enable replay when vtotal update is pending.
Date: Tue, 27 May 2025 18:18:15 +0200
Message-ID: <20250527162445.145617135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Wang <danny.wang@amd.com>

[ Upstream commit bd00b29b5f236dce677089319176dee5872b5a7a ]

[Why&How]
Vtotal is not applied to HW when handling vsync interrupt.
Make sure vtotal is aligned before enable replay.

Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Reviewed-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Danny Wang <danny.wang@amd.com>
Signed-off-by: Zhongwei Zhang <Zhongwei.Zhang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 874697e12793 ("drm/amd/display: Defer BW-optimization-blocked DRR adjustments")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          |  9 +++++++--
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c | 15 +++++++++++++++
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h      |  1 +
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |  7 ++-----
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c   |  7 ++-----
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |  8 ++------
 .../drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c   |  4 +---
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c   |  3 +--
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 10 +++-------
 .../gpu/drm/amd/display/dc/hwss/hw_sequencer.h    |  6 ++++++
 10 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 216b525bd75e7..3392746f1d420 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -452,6 +452,7 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 
 	if (dc->caps.max_v_total != 0 &&
 		(adjust->v_total_max > dc->caps.max_v_total || adjust->v_total_min > dc->caps.max_v_total)) {
+		stream->adjust.timing_adjust_pending = false;
 		if (adjust->allow_otg_v_count_halt)
 			return set_long_vtotal(dc, stream, adjust);
 		else
@@ -465,7 +466,7 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 			dc->hwss.set_drr(&pipe,
 					1,
 					*adjust);
-
+			stream->adjust.timing_adjust_pending = false;
 			return true;
 		}
 	}
@@ -2975,8 +2976,12 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->vrr_active_fixed)
 		stream->vrr_active_fixed = *update->vrr_active_fixed;
 
-	if (update->crtc_timing_adjust)
+	if (update->crtc_timing_adjust) {
+		if (stream->adjust.v_total_min != update->crtc_timing_adjust->v_total_min ||
+			stream->adjust.v_total_max != update->crtc_timing_adjust->v_total_max)
+			stream->adjust.timing_adjust_pending = true;
 		stream->adjust = *update->crtc_timing_adjust;
+	}
 
 	if (update->dpms_off)
 		stream->dpms_off = *update->dpms_off;
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index bb766c2a74176..fdcba960e1e6f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -554,6 +554,21 @@ void set_p_state_switch_method(
 	}
 }
 
+void set_drr_and_clear_adjust_pending(
+		struct pipe_ctx *pipe_ctx,
+		struct dc_stream_state *stream,
+		struct drr_params *params)
+{
+	/* params can be null.*/
+	if (pipe_ctx && pipe_ctx->stream_res.tg &&
+			pipe_ctx->stream_res.tg->funcs->set_drr)
+		pipe_ctx->stream_res.tg->funcs->set_drr(
+				pipe_ctx->stream_res.tg, params);
+
+	if (stream)
+		stream->adjust.timing_adjust_pending = false;
+}
+
 void get_fams2_visual_confirm_color(
 		struct dc *dc,
 		struct dc_state *context,
diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index c10567ec1c819..0ded4bc7825b0 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -1000,6 +1000,7 @@ struct dc_crtc_timing_adjust {
 	uint32_t v_total_mid;
 	uint32_t v_total_mid_frame_num;
 	uint32_t allow_otg_v_count_halt;
+	uint8_t timing_adjust_pending;
 };
 
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 4fbed0298adfa..1e76524d116dc 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1653,9 +1653,7 @@ enum dc_status dce110_apply_single_controller_ctx_to_hw(
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-	if (pipe_ctx->stream_res.tg->funcs->set_drr)
-		pipe_ctx->stream_res.tg->funcs->set_drr(
-			pipe_ctx->stream_res.tg, &params);
+	set_drr_and_clear_adjust_pending(pipe_ctx, stream, &params);
 
 	// DRR should set trigger event to monitor surface update event
 	if (stream->adjust.v_total_min != 0 && stream->adjust.v_total_max != 0)
@@ -2103,8 +2101,7 @@ static void set_drr(struct pipe_ctx **pipe_ctx,
 		struct timing_generator *tg = pipe_ctx[i]->stream_res.tg;
 
 		if ((tg != NULL) && tg->funcs) {
-			if (tg->funcs->set_drr)
-				tg->funcs->set_drr(tg, &params);
+			set_drr_and_clear_adjust_pending(pipe_ctx[i], pipe_ctx[i]->stream, &params);
 			if (adjust.v_total_max != 0 && adjust.v_total_min != 0)
 				if (tg->funcs->set_static_screen_control)
 					tg->funcs->set_static_screen_control(
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
index d725af14af371..00be0b26689d3 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -1112,9 +1112,7 @@ static void dcn10_reset_back_end_for_pipe(
 		pipe_ctx->stream_res.tg->funcs->disable_crtc(pipe_ctx->stream_res.tg);
 
 		pipe_ctx->stream_res.tg->funcs->enable_optc_clock(pipe_ctx->stream_res.tg, false);
-		if (pipe_ctx->stream_res.tg->funcs->set_drr)
-			pipe_ctx->stream_res.tg->funcs->set_drr(
-					pipe_ctx->stream_res.tg, NULL);
+		set_drr_and_clear_adjust_pending(pipe_ctx, pipe_ctx->stream, NULL);
 		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
 			pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 	}
@@ -3217,8 +3215,7 @@ void dcn10_set_drr(struct pipe_ctx **pipe_ctx,
 		struct timing_generator *tg = pipe_ctx[i]->stream_res.tg;
 
 		if ((tg != NULL) && tg->funcs) {
-			if (tg->funcs->set_drr)
-				tg->funcs->set_drr(tg, &params);
+			set_drr_and_clear_adjust_pending(pipe_ctx[i], pipe_ctx[i]->stream, &params);
 			if (adjust.v_total_max != 0 && adjust.v_total_min != 0)
 				if (tg->funcs->set_static_screen_control)
 					tg->funcs->set_static_screen_control(
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index f5f1ccd8303cf..9c5cdb3b80b5d 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -952,9 +952,7 @@ enum dc_status dcn20_enable_stream_timing(
 	params.vertical_total_max = stream->adjust.v_total_max;
 	params.vertical_total_mid = stream->adjust.v_total_mid;
 	params.vertical_total_mid_frame_num = stream->adjust.v_total_mid_frame_num;
-	if (pipe_ctx->stream_res.tg->funcs->set_drr)
-		pipe_ctx->stream_res.tg->funcs->set_drr(
-			pipe_ctx->stream_res.tg, &params);
+	set_drr_and_clear_adjust_pending(pipe_ctx, stream, &params);
 
 	// DRR should set trigger event to monitor surface update event
 	if (stream->adjust.v_total_min != 0 && stream->adjust.v_total_max != 0)
@@ -2822,9 +2820,7 @@ void dcn20_reset_back_end_for_pipe(
 			pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 					pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
 
-		if (pipe_ctx->stream_res.tg->funcs->set_drr)
-			pipe_ctx->stream_res.tg->funcs->set_drr(
-					pipe_ctx->stream_res.tg, NULL);
+		set_drr_and_clear_adjust_pending(pipe_ctx, pipe_ctx->stream, NULL);
 		/* TODO - convert symclk_ref_cnts for otg to a bit map to solve
 		 * the case where the same symclk is shared across multiple otg
 		 * instances
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
index 3d4b31bd99469..9aa925a0b3b43 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
@@ -528,9 +528,7 @@ static void dcn31_reset_back_end_for_pipe(
 	if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
 		pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 
-	if (pipe_ctx->stream_res.tg->funcs->set_drr)
-		pipe_ctx->stream_res.tg->funcs->set_drr(
-				pipe_ctx->stream_res.tg, NULL);
+	set_drr_and_clear_adjust_pending(pipe_ctx, pipe_ctx->stream, NULL);
 
 	link = pipe_ctx->stream->link;
 	/* DPMS may already disable or */
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index 38755ca771401..ca446e08f6a27 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1452,8 +1452,7 @@ void dcn35_set_drr(struct pipe_ctx **pipe_ctx,
 					num_frames = 2 * (frame_rate % 60);
 				}
 			}
-			if (tg->funcs->set_drr)
-				tg->funcs->set_drr(tg, &params);
+			set_drr_and_clear_adjust_pending(pipe_ctx[i], pipe_ctx[i]->stream, &params);
 			if (adjust.v_total_max != 0 && adjust.v_total_min != 0)
 				if (tg->funcs->set_static_screen_control)
 					tg->funcs->set_static_screen_control(
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index b6b333a2461f8..3279f347660cb 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -902,10 +902,7 @@ enum dc_status dcn401_enable_stream_timing(
 	}
 
 	hws->funcs.wait_for_blank_complete(pipe_ctx->stream_res.opp);
-
-	if (pipe_ctx->stream_res.tg->funcs->set_drr)
-		pipe_ctx->stream_res.tg->funcs->set_drr(
-			pipe_ctx->stream_res.tg, &params);
+	set_drr_and_clear_adjust_pending(pipe_ctx, stream, &params);
 
 	/* Event triggers and num frames initialized for DRR, but can be
 	 * later updated for PSR use. Note DRR trigger events are generated
@@ -1835,9 +1832,8 @@ void dcn401_reset_back_end_for_pipe(
 			pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 					pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
 
-		if (pipe_ctx->stream_res.tg->funcs->set_drr)
-			pipe_ctx->stream_res.tg->funcs->set_drr(
-					pipe_ctx->stream_res.tg, NULL);
+		set_drr_and_clear_adjust_pending(pipe_ctx, pipe_ctx->stream, NULL);
+
 		/* TODO - convert symclk_ref_cnts for otg to a bit map to solve
 		 * the case where the same symclk is shared across multiple otg
 		 * instances
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
index ac92056256233..9ae6259f2db17 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
@@ -46,6 +46,7 @@ struct dce_hwseq;
 struct link_resource;
 struct dc_dmub_cmd;
 struct pg_block_update;
+struct drr_params;
 
 struct subvp_pipe_control_lock_fast_params {
 	struct dc *dc;
@@ -509,6 +510,11 @@ void set_p_state_switch_method(
 		struct dc_state *context,
 		struct pipe_ctx *pipe_ctx);
 
+void set_drr_and_clear_adjust_pending(
+		struct pipe_ctx *pipe_ctx,
+		struct dc_stream_state *stream,
+		struct drr_params *params);
+
 void hwss_execute_sequence(struct dc *dc,
 		struct block_sequence block_sequence[],
 		int num_steps);
-- 
2.39.5



