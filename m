Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF2A17BED0;
	Sat, 17 Oct 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257728; cv=none; b=s48x6MNBfK16gWdiq3l7EfE2/yCv6Q8be0OSNt8nOiM3v0nS+7wOp0Zmxofk57uV0R+rSvzzaYZP/Q0V5iYsHEKtR6824N3mvAkDtAWutweu/W1lzel6SRr4YOkFuIFYc8eVGt0zHS9q4fLvrsMZEud/zGADTOjXHDhffxMN0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257728; c=relaxed/simple;
	bh=c30oHDLJ8L30VypYC7oZLxtSXslV/cSbExT2Gk6ynX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh8r/0fktkP4qczQfPPJZPKwY37E+T4QmsAIONSudeW0e77yukU7XjfIWzcEB7IpnKakzBXCw8fq8lnlqhwGqBbSsCySh3EcQODfwgc8Hi8pjmqDA7r3CJ78Vuyu6rwdjOADtvCR4COeh0LgzFKRdmLW2DaoInNx3E9ez6sri/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8QDbzDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8QDbzDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864ED1F000C4;
	Sat, 17 Oct 2026 17:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257727;
	bh=9xF4hjA/T552Lj2JA90YHSg0PDJO+rj9nfkndwhdhro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8QDbzDfolXPF8wEPheUIQ3HJioOomqZFXIxhhJcFejc6O1jXZGzs9mTDeKriaqh7
	 BinD12IYll8D7m5IYM0gFnHSUrf50ecJWkqlISrqhEmVUf5+4c8oDbZAFJ1HKEuQG4
	 kLAc0+vvTrIKcDUnhdjUNB8P0+KK9qNF84f0wKXo=
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
Subject: [PATCH 6.6 0650/1674] drm/amd/display: Check null pointers before multiple uses
Date: Sat, 17 Oct 2026 17:48:42 +0200
Message-ID: <20261017160447.793125299@linuxfoundation.org>
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

[ Upstream commit fdd5ecbbff751c3b9061d8ebb08e5c96119915b4 ]

[WHAT & HOW]
Poniters, such as stream_enc and dc->bw_vbios, are null checked previously
in the same function, so Coverity warns "implies that stream_enc and
dc->bw_vbios might be null". They are used multiple times in the
subsequent code and need to be checked.

This fixes 10 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/core/dc_hw_sequencer.c | 82 ++++++++++---------
 .../amd/display/dc/dce112/dce112_resource.c   |  5 +-
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    |  8 +-
 .../drm/amd/display/dc/dcn32/dcn32_resource.c |  3 +
 .../display/dc/dcn32/dcn32_resource_helpers.c | 10 +--
 .../display/dc/link/accessories/link_dp_cts.c |  5 +-
 .../amd/display/dc/link/hwss/link_hwss_dio.c  |  5 +-
 7 files changed, 69 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 37b156d32dd91..58f28adf7b2ce 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -522,48 +522,50 @@ void hwss_build_fast_sequence(struct dc *dc,
 	while (current_pipe) {
 		current_mpc_pipe = current_pipe;
 		while (current_mpc_pipe) {
-			if (dc->hwss.set_flip_control_gsl && current_mpc_pipe->plane_state && current_mpc_pipe->plane_state->update_flags.raw) {
-				block_sequence[*num_steps].params.set_flip_control_gsl_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].params.set_flip_control_gsl_params.flip_immediate = current_mpc_pipe->plane_state->flip_immediate;
-				block_sequence[*num_steps].func = HUBP_SET_FLIP_CONTROL_GSL;
-				(*num_steps)++;
-			}
-			if (dc->hwss.program_triplebuffer && dc->debug.enable_tri_buf && current_mpc_pipe->plane_state->update_flags.raw) {
-				block_sequence[*num_steps].params.program_triplebuffer_params.dc = dc;
-				block_sequence[*num_steps].params.program_triplebuffer_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].params.program_triplebuffer_params.enableTripleBuffer = current_mpc_pipe->plane_state->triplebuffer_flips;
-				block_sequence[*num_steps].func = HUBP_PROGRAM_TRIPLEBUFFER;
-				(*num_steps)++;
-			}
-			if (dc->hwss.update_plane_addr && current_mpc_pipe->plane_state->update_flags.bits.addr_update) {
-				block_sequence[*num_steps].params.update_plane_addr_params.dc = dc;
-				block_sequence[*num_steps].params.update_plane_addr_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = HUBP_UPDATE_PLANE_ADDR;
-				(*num_steps)++;
-			}
+			if (current_mpc_pipe->plane_state) {
+				if (dc->hwss.set_flip_control_gsl && current_mpc_pipe->plane_state->update_flags.raw) {
+					block_sequence[*num_steps].params.set_flip_control_gsl_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].params.set_flip_control_gsl_params.flip_immediate = current_mpc_pipe->plane_state->flip_immediate;
+					block_sequence[*num_steps].func = HUBP_SET_FLIP_CONTROL_GSL;
+					(*num_steps)++;
+				}
+				if (dc->hwss.program_triplebuffer && dc->debug.enable_tri_buf && current_mpc_pipe->plane_state->update_flags.raw) {
+					block_sequence[*num_steps].params.program_triplebuffer_params.dc = dc;
+					block_sequence[*num_steps].params.program_triplebuffer_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].params.program_triplebuffer_params.enableTripleBuffer = current_mpc_pipe->plane_state->triplebuffer_flips;
+					block_sequence[*num_steps].func = HUBP_PROGRAM_TRIPLEBUFFER;
+					(*num_steps)++;
+				}
+				if (dc->hwss.update_plane_addr && current_mpc_pipe->plane_state->update_flags.bits.addr_update) {
+					block_sequence[*num_steps].params.update_plane_addr_params.dc = dc;
+					block_sequence[*num_steps].params.update_plane_addr_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = HUBP_UPDATE_PLANE_ADDR;
+					(*num_steps)++;
+				}
 
-			if (hws->funcs.set_input_transfer_func && current_mpc_pipe->plane_state->update_flags.bits.gamma_change) {
-				block_sequence[*num_steps].params.set_input_transfer_func_params.dc = dc;
-				block_sequence[*num_steps].params.set_input_transfer_func_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].params.set_input_transfer_func_params.plane_state = current_mpc_pipe->plane_state;
-				block_sequence[*num_steps].func = DPP_SET_INPUT_TRANSFER_FUNC;
-				(*num_steps)++;
-			}
+				if (hws->funcs.set_input_transfer_func && current_mpc_pipe->plane_state->update_flags.bits.gamma_change) {
+					block_sequence[*num_steps].params.set_input_transfer_func_params.dc = dc;
+					block_sequence[*num_steps].params.set_input_transfer_func_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].params.set_input_transfer_func_params.plane_state = current_mpc_pipe->plane_state;
+					block_sequence[*num_steps].func = DPP_SET_INPUT_TRANSFER_FUNC;
+					(*num_steps)++;
+				}
 
-			if (dc->hwss.program_gamut_remap && current_mpc_pipe->plane_state->update_flags.bits.gamut_remap_change) {
-				block_sequence[*num_steps].params.program_gamut_remap_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = DPP_PROGRAM_GAMUT_REMAP;
-				(*num_steps)++;
-			}
-			if (current_mpc_pipe->plane_state->update_flags.bits.input_csc_change) {
-				block_sequence[*num_steps].params.setup_dpp_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = DPP_SETUP_DPP;
-				(*num_steps)++;
-			}
-			if (current_mpc_pipe->plane_state->update_flags.bits.coeff_reduction_change) {
-				block_sequence[*num_steps].params.program_bias_and_scale_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = DPP_PROGRAM_BIAS_AND_SCALE;
-				(*num_steps)++;
+				if (dc->hwss.program_gamut_remap && current_mpc_pipe->plane_state->update_flags.bits.gamut_remap_change) {
+					block_sequence[*num_steps].params.program_gamut_remap_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = DPP_PROGRAM_GAMUT_REMAP;
+					(*num_steps)++;
+				}
+				if (current_mpc_pipe->plane_state->update_flags.bits.input_csc_change) {
+					block_sequence[*num_steps].params.setup_dpp_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = DPP_SETUP_DPP;
+					(*num_steps)++;
+				}
+				if (current_mpc_pipe->plane_state->update_flags.bits.coeff_reduction_change) {
+					block_sequence[*num_steps].params.program_bias_and_scale_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = DPP_PROGRAM_BIAS_AND_SCALE;
+					(*num_steps)++;
+				}
 			}
 			if (hws->funcs.set_output_transfer_func && current_mpc_pipe->stream->update_flags.bits.out_tf) {
 				block_sequence[*num_steps].params.set_output_transfer_func_params.dc = dc;
diff --git a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
index 2b20180f1a324..18c942cfe5301 100644
--- a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
@@ -1069,7 +1069,10 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	struct dm_pp_clock_levels clks = {0};
 	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
 
-	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+	if (!dc->bw_vbios)
+		return;
+
+	if (dc->bw_vbios->memory_type == bw_def_hbm)
 		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	/*do system clock  TODO PPLIB: after PPLIB implement,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index e52c2bb1b6265..3fe91d6869fe1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2017,6 +2017,9 @@ void dcn20_post_unlock_program_front_end(
 		}
 	}
 
+	if (!hwseq)
+		return;
+
 	/* P-State support transitions:
 	 * Natural -> FPO: 		P-State disabled in prepare, force disallow anytime is safe
 	 * FPO -> Natural: 		Unforce anytime after FW disable is safe (P-State will assert naturally)
@@ -2024,7 +2027,7 @@ void dcn20_post_unlock_program_front_end(
 	 * FPO -> Unsupported:	P-State disabled in prepare, unforce disallow anytime is safe
 	 * FPO <-> SubVP:		Force disallow is maintained on the FPO / SubVP pipes
 	 */
-	if (hwseq && hwseq->funcs.update_force_pstate)
+	if (hwseq->funcs.update_force_pstate)
 		dc->hwseq->funcs.update_force_pstate(dc, context);
 
 	/* Only program the MALL registers after all the main and phantom pipes
@@ -2262,6 +2265,9 @@ bool dcn20_wait_for_blank_complete(
 {
 	int counter;
 
+	if (!opp)
+		return false;
+
 	for (counter = 0; counter < 1000; counter++) {
 		if (opp->funcs->dpg_is_blanked(opp))
 			break;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index c7f259e265f4d..ab6b4f44f537c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1645,6 +1645,9 @@ static void dcn32_enable_phantom_plane(struct dc *dc,
 		else
 			phantom_plane = dc_create_plane_state(dc);
 
+		if (!phantom_plane)
+			continue;
+
 		memcpy(&phantom_plane->address, &curr_pipe->plane_state->address, sizeof(phantom_plane->address));
 		memcpy(&phantom_plane->scaling_quality, &curr_pipe->plane_state->scaling_quality,
 				sizeof(phantom_plane->scaling_quality));
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index 3ad2b48954e02..57a662fc99ef8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -233,12 +233,12 @@ bool dcn32_is_center_timing(struct pipe_ctx *pipe)
 				pipe->stream->timing.v_addressable != pipe->stream->src.height) {
 			is_center_timing = true;
 		}
-	}
 
-	if (pipe->plane_state) {
-		if (pipe->stream->timing.v_addressable != pipe->plane_state->dst_rect.height &&
-				pipe->stream->timing.v_addressable != pipe->plane_state->src_rect.height) {
-			is_center_timing = true;
+		if (pipe->plane_state) {
+			if (pipe->stream->timing.v_addressable != pipe->plane_state->dst_rect.height &&
+					pipe->stream->timing.v_addressable != pipe->plane_state->src_rect.height) {
+				is_center_timing = true;
+			}
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index fe4282771cd07..b5775a12f6e5c 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -878,8 +878,11 @@ bool dp_set_test_pattern(
 			break;
 		}
 
+		if (!pipe_ctx->stream)
+			return false;
+
 		if (pipe_ctx->stream_res.tg->funcs->lock_doublebuffer_enable) {
-			if (pipe_ctx->stream && should_use_dmub_lock(pipe_ctx->stream->link)) {
+			if (should_use_dmub_lock(pipe_ctx->stream->link)) {
 				union dmub_hw_lock_flags hw_locks = { 0 };
 				struct dmub_hw_lock_inst_flags inst_flags = { 0 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c
index 1328a0ade3422..a52a0eef06b35 100644
--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c
@@ -58,7 +58,10 @@ void reset_dio_stream_encoder(struct pipe_ctx *pipe_ctx)
 	struct link_encoder *link_enc = link_enc_cfg_get_link_enc(pipe_ctx->stream->link);
 	struct stream_encoder *stream_enc = pipe_ctx->stream_res.stream_enc;
 
-	if (stream_enc && stream_enc->funcs->disable_fifo)
+	if (!stream_enc)
+		return;
+
+	if (stream_enc->funcs->disable_fifo)
 		stream_enc->funcs->disable_fifo(stream_enc);
 
 	link_enc->funcs->connect_dig_be_to_fe(
-- 
2.53.0



