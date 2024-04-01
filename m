Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C2E1C0DE7;
	Mon,  1 Apr 2024 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989054; cv=none; b=IA2UIfyfafeixPfoT4LtIKt+pDmePaSalO17ZytUrryi7lEAw5VIwcM/oOJVcYPC4SAfx9gxIQimLR3Km6g2DwGu6pPz14YCgiAO2rBoQZmPJ57DoufRMsNBqyuy8CAAICqL0idw+3jghpXXzYEUjhLZsNuDIakq2m2bMvZKflk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989054; c=relaxed/simple;
	bh=Oo44f3g+c0MqYWpcWXaLxItD+jfvIzeumIU/e8ohXhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dy1qQHCtCY+xr75mWH2JovGkacS+QTEbjPXvpjxNp+XMjmAUc0JrAFNUIcLMpKlcxxUaxwqya5d5rwMc4cCe4qbPQuNK8/f95aGQ0oA39LjVBMUgmhdLuPNrfKkpWAiRf9bvPV51hb8zfRdozgv0flnLaoXzfP6skCkw9kK5pDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjK5hHzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjK5hHzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4794C43390;
	Mon,  1 Apr 2024 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989054;
	bh=Oo44f3g+c0MqYWpcWXaLxItD+jfvIzeumIU/e8ohXhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjK5hHzD1dmCweB+HHGgX5jwgXnubbK/ywxZOhNoZND1yPEGq2SCKqE8b6uw/Edat
	 Jdh9Ch7/IU2iDIP46E2EaUUmj1MB4MvDEFml8rW8bLNzAzEjQeP+0F41qYGkhZKjPQ
	 FTjbVbruUL4+Lh1b44SiHADPaRrYyGbyCbw0cE+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 368/432] drm/amd/display: Remove MPC rate control logic from DCN30 and above
Date: Mon,  1 Apr 2024 17:45:55 +0200
Message-ID: <20240401152604.250551731@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

commit edfa93d87fc46913868481fe8ed3fb62c891ffb5 upstream.

[Why]
MPC flow rate control is not needed for DCN30 and above. Current logic
that uses it can result in underflow for certain edge cases (such as
DSC N422 + ODM combine + 422 left edge pixel).

[How]
Remove MPC flow rate control logic and programming for DCN30 and above.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c          |   54 ++++++++------
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.h          |   14 +--
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_mpc.c          |    5 -
 drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c |   41 ----------
 drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c   |   41 ----------
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c   |   41 ----------
 6 files changed, 41 insertions(+), 155 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c
@@ -44,6 +44,36 @@
 #define NUM_ELEMENTS(a) (sizeof(a) / sizeof((a)[0]))
 
 
+void mpc3_mpc_init(struct mpc *mpc)
+{
+	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
+	int opp_id;
+
+	mpc1_mpc_init(mpc);
+
+	for (opp_id = 0; opp_id < MAX_OPP; opp_id++) {
+		if (REG(MUX[opp_id]))
+			/* disable mpc out rate and flow control */
+			REG_UPDATE_2(MUX[opp_id], MPC_OUT_RATE_CONTROL_DISABLE,
+					1, MPC_OUT_FLOW_CONTROL_COUNT, 0);
+	}
+}
+
+void mpc3_mpc_init_single_inst(struct mpc *mpc, unsigned int mpcc_id)
+{
+	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
+
+	mpc1_mpc_init_single_inst(mpc, mpcc_id);
+
+	/* assuming mpc out mux is connected to opp with the same index at this
+	 * point in time (e.g. transitioning from vbios to driver)
+	 */
+	if (mpcc_id < MAX_OPP && REG(MUX[mpcc_id]))
+		/* disable mpc out rate and flow control */
+		REG_UPDATE_2(MUX[mpcc_id], MPC_OUT_RATE_CONTROL_DISABLE,
+				1, MPC_OUT_FLOW_CONTROL_COUNT, 0);
+}
+
 bool mpc3_is_dwb_idle(
 	struct mpc *mpc,
 	int dwb_id)
@@ -80,25 +110,6 @@ void mpc3_disable_dwb_mux(
 		MPC_DWB0_MUX, 0xf);
 }
 
-void mpc3_set_out_rate_control(
-	struct mpc *mpc,
-	int opp_id,
-	bool enable,
-	bool rate_2x_mode,
-	struct mpc_dwb_flow_control *flow_control)
-{
-	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
-
-	REG_UPDATE_2(MUX[opp_id],
-			MPC_OUT_RATE_CONTROL_DISABLE, !enable,
-			MPC_OUT_RATE_CONTROL, rate_2x_mode);
-
-	if (flow_control)
-		REG_UPDATE_2(MUX[opp_id],
-			MPC_OUT_FLOW_CONTROL_MODE, flow_control->flow_ctrl_mode,
-			MPC_OUT_FLOW_CONTROL_COUNT, flow_control->flow_ctrl_cnt1);
-}
-
 enum dc_lut_mode mpc3_get_ogam_current(struct mpc *mpc, int mpcc_id)
 {
 	/*Contrary to DCN2 and DCN1 wherein a single status register field holds this info;
@@ -1386,8 +1397,8 @@ static const struct mpc_funcs dcn30_mpc_
 	.read_mpcc_state = mpc1_read_mpcc_state,
 	.insert_plane = mpc1_insert_plane,
 	.remove_mpcc = mpc1_remove_mpcc,
-	.mpc_init = mpc1_mpc_init,
-	.mpc_init_single_inst = mpc1_mpc_init_single_inst,
+	.mpc_init = mpc3_mpc_init,
+	.mpc_init_single_inst = mpc3_mpc_init_single_inst,
 	.update_blending = mpc2_update_blending,
 	.cursor_lock = mpc1_cursor_lock,
 	.get_mpcc_for_dpp = mpc1_get_mpcc_for_dpp,
@@ -1404,7 +1415,6 @@ static const struct mpc_funcs dcn30_mpc_
 	.set_dwb_mux = mpc3_set_dwb_mux,
 	.disable_dwb_mux = mpc3_disable_dwb_mux,
 	.is_dwb_idle = mpc3_is_dwb_idle,
-	.set_out_rate_control = mpc3_set_out_rate_control,
 	.set_gamut_remap = mpc3_set_gamut_remap,
 	.program_shaper = mpc3_program_shaper,
 	.acquire_rmu = mpcc3_acquire_rmu,
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.h
@@ -1007,6 +1007,13 @@ void dcn30_mpc_construct(struct dcn30_mp
 	int num_mpcc,
 	int num_rmu);
 
+void mpc3_mpc_init(
+	struct mpc *mpc);
+
+void mpc3_mpc_init_single_inst(
+	struct mpc *mpc,
+	unsigned int mpcc_id);
+
 bool mpc3_program_shaper(
 		struct mpc *mpc,
 		const struct pwl_params *params,
@@ -1074,13 +1081,6 @@ bool mpc3_is_dwb_idle(
 	struct mpc *mpc,
 	int dwb_id);
 
-void mpc3_set_out_rate_control(
-	struct mpc *mpc,
-	int opp_id,
-	bool enable,
-	bool rate_2x_mode,
-	struct mpc_dwb_flow_control *flow_control);
-
 void mpc3_power_on_ogam_lut(
 	struct mpc *mpc, int mpcc_id,
 	bool power_on);
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_mpc.c
@@ -47,7 +47,7 @@ void mpc32_mpc_init(struct mpc *mpc)
 	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
 	int mpcc_id;
 
-	mpc1_mpc_init(mpc);
+	mpc3_mpc_init(mpc);
 
 	if (mpc->ctx->dc->debug.enable_mem_low_power.bits.mpc) {
 		if (mpc30->mpc_mask->MPCC_MCM_SHAPER_MEM_LOW_PWR_MODE && mpc30->mpc_mask->MPCC_MCM_3DLUT_MEM_LOW_PWR_MODE) {
@@ -990,7 +990,7 @@ static const struct mpc_funcs dcn32_mpc_
 	.insert_plane = mpc1_insert_plane,
 	.remove_mpcc = mpc1_remove_mpcc,
 	.mpc_init = mpc32_mpc_init,
-	.mpc_init_single_inst = mpc1_mpc_init_single_inst,
+	.mpc_init_single_inst = mpc3_mpc_init_single_inst,
 	.update_blending = mpc2_update_blending,
 	.cursor_lock = mpc1_cursor_lock,
 	.get_mpcc_for_dpp = mpc1_get_mpcc_for_dpp,
@@ -1007,7 +1007,6 @@ static const struct mpc_funcs dcn32_mpc_
 	.set_dwb_mux = mpc3_set_dwb_mux,
 	.disable_dwb_mux = mpc3_disable_dwb_mux,
 	.is_dwb_idle = mpc3_is_dwb_idle,
-	.set_out_rate_control = mpc3_set_out_rate_control,
 	.set_gamut_remap = mpc3_set_gamut_remap,
 	.program_shaper = mpc32_program_shaper,
 	.program_3dlut = mpc32_program_3dlut,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
@@ -69,29 +69,6 @@
 #define FN(reg_name, field_name) \
 	hws->shifts->field_name, hws->masks->field_name
 
-static int calc_mpc_flow_ctrl_cnt(const struct dc_stream_state *stream,
-		int opp_cnt)
-{
-	bool hblank_halved = optc2_is_two_pixels_per_containter(&stream->timing);
-	int flow_ctrl_cnt;
-
-	if (opp_cnt >= 2)
-		hblank_halved = true;
-
-	flow_ctrl_cnt = stream->timing.h_total - stream->timing.h_addressable -
-			stream->timing.h_border_left -
-			stream->timing.h_border_right;
-
-	if (hblank_halved)
-		flow_ctrl_cnt /= 2;
-
-	/* ODM combine 4:1 case */
-	if (opp_cnt == 4)
-		flow_ctrl_cnt /= 2;
-
-	return flow_ctrl_cnt;
-}
-
 static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 {
 	struct display_stream_compressor *dsc = pipe_ctx->stream_res.dsc;
@@ -183,10 +160,6 @@ void dcn314_update_odm(struct dc *dc, st
 	struct pipe_ctx *odm_pipe;
 	int opp_cnt = 0;
 	int opp_inst[MAX_PIPES] = {0};
-	bool rate_control_2x_pclk = (pipe_ctx->stream->timing.flags.INTERLACE || optc2_is_two_pixels_per_containter(&pipe_ctx->stream->timing));
-	struct mpc_dwb_flow_control flow_control;
-	struct mpc *mpc = dc->res_pool->mpc;
-	int i;
 
 	opp_cnt = get_odm_config(pipe_ctx, opp_inst);
 
@@ -199,20 +172,6 @@ void dcn314_update_odm(struct dc *dc, st
 		pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 				pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
 
-	rate_control_2x_pclk = rate_control_2x_pclk || opp_cnt > 1;
-	flow_control.flow_ctrl_mode = 0;
-	flow_control.flow_ctrl_cnt0 = 0x80;
-	flow_control.flow_ctrl_cnt1 = calc_mpc_flow_ctrl_cnt(pipe_ctx->stream, opp_cnt);
-	if (mpc->funcs->set_out_rate_control) {
-		for (i = 0; i < opp_cnt; ++i) {
-			mpc->funcs->set_out_rate_control(
-					mpc, opp_inst[i],
-					true,
-					rate_control_2x_pclk,
-					&flow_control);
-		}
-	}
-
 	for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
 		odm_pipe->stream_res.opp->funcs->opp_pipe_clock_control(
 				odm_pipe->stream_res.opp,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -969,29 +969,6 @@ void dcn32_init_hw(struct dc *dc)
 	}
 }
 
-static int calc_mpc_flow_ctrl_cnt(const struct dc_stream_state *stream,
-		int opp_cnt)
-{
-	bool hblank_halved = optc2_is_two_pixels_per_containter(&stream->timing);
-	int flow_ctrl_cnt;
-
-	if (opp_cnt >= 2)
-		hblank_halved = true;
-
-	flow_ctrl_cnt = stream->timing.h_total - stream->timing.h_addressable -
-			stream->timing.h_border_left -
-			stream->timing.h_border_right;
-
-	if (hblank_halved)
-		flow_ctrl_cnt /= 2;
-
-	/* ODM combine 4:1 case */
-	if (opp_cnt == 4)
-		flow_ctrl_cnt /= 2;
-
-	return flow_ctrl_cnt;
-}
-
 static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 {
 	struct display_stream_compressor *dsc = pipe_ctx->stream_res.dsc;
@@ -1106,10 +1083,6 @@ void dcn32_update_odm(struct dc *dc, str
 	struct pipe_ctx *odm_pipe;
 	int opp_cnt = 0;
 	int opp_inst[MAX_PIPES] = {0};
-	bool rate_control_2x_pclk = (pipe_ctx->stream->timing.flags.INTERLACE || optc2_is_two_pixels_per_containter(&pipe_ctx->stream->timing));
-	struct mpc_dwb_flow_control flow_control;
-	struct mpc *mpc = dc->res_pool->mpc;
-	int i;
 
 	opp_cnt = get_odm_config(pipe_ctx, opp_inst);
 
@@ -1122,20 +1095,6 @@ void dcn32_update_odm(struct dc *dc, str
 		pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 				pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
 
-	rate_control_2x_pclk = rate_control_2x_pclk || opp_cnt > 1;
-	flow_control.flow_ctrl_mode = 0;
-	flow_control.flow_ctrl_cnt0 = 0x80;
-	flow_control.flow_ctrl_cnt1 = calc_mpc_flow_ctrl_cnt(pipe_ctx->stream, opp_cnt);
-	if (mpc->funcs->set_out_rate_control) {
-		for (i = 0; i < opp_cnt; ++i) {
-			mpc->funcs->set_out_rate_control(
-					mpc, opp_inst[i],
-					true,
-					rate_control_2x_pclk,
-					&flow_control);
-		}
-	}
-
 	for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
 		odm_pipe->stream_res.opp->funcs->opp_pipe_clock_control(
 				odm_pipe->stream_res.opp,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -338,29 +338,6 @@ void dcn35_init_hw(struct dc *dc)
 	}
 }
 
-static int calc_mpc_flow_ctrl_cnt(const struct dc_stream_state *stream,
-		int opp_cnt)
-{
-	bool hblank_halved = optc2_is_two_pixels_per_containter(&stream->timing);
-	int flow_ctrl_cnt;
-
-	if (opp_cnt >= 2)
-		hblank_halved = true;
-
-	flow_ctrl_cnt = stream->timing.h_total - stream->timing.h_addressable -
-			stream->timing.h_border_left -
-			stream->timing.h_border_right;
-
-	if (hblank_halved)
-		flow_ctrl_cnt /= 2;
-
-	/* ODM combine 4:1 case */
-	if (opp_cnt == 4)
-		flow_ctrl_cnt /= 2;
-
-	return flow_ctrl_cnt;
-}
-
 static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 {
 	struct display_stream_compressor *dsc = pipe_ctx->stream_res.dsc;
@@ -454,10 +431,6 @@ void dcn35_update_odm(struct dc *dc, str
 	struct pipe_ctx *odm_pipe;
 	int opp_cnt = 0;
 	int opp_inst[MAX_PIPES] = {0};
-	bool rate_control_2x_pclk = (pipe_ctx->stream->timing.flags.INTERLACE || optc2_is_two_pixels_per_containter(&pipe_ctx->stream->timing));
-	struct mpc_dwb_flow_control flow_control;
-	struct mpc *mpc = dc->res_pool->mpc;
-	int i;
 
 	opp_cnt = get_odm_config(pipe_ctx, opp_inst);
 
@@ -470,20 +443,6 @@ void dcn35_update_odm(struct dc *dc, str
 		pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 				pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
 
-	rate_control_2x_pclk = rate_control_2x_pclk || opp_cnt > 1;
-	flow_control.flow_ctrl_mode = 0;
-	flow_control.flow_ctrl_cnt0 = 0x80;
-	flow_control.flow_ctrl_cnt1 = calc_mpc_flow_ctrl_cnt(pipe_ctx->stream, opp_cnt);
-	if (mpc->funcs->set_out_rate_control) {
-		for (i = 0; i < opp_cnt; ++i) {
-			mpc->funcs->set_out_rate_control(
-					mpc, opp_inst[i],
-					true,
-					rate_control_2x_pclk,
-					&flow_control);
-		}
-	}
-
 	for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
 		odm_pipe->stream_res.opp->funcs->opp_pipe_clock_control(
 				odm_pipe->stream_res.opp,


