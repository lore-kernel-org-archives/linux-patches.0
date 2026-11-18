Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015440;
	b=245z9RCuHjEhRULcDkSXmJ6rTPO5fQZXNEiEBFGLchk4ThK3GfRIhU+BJIz9I5TlklTK
	 9OM5mOEJkjvw8w/VvlW/PzKJIDijcFWX3EN8W2nlHTwIk4Eq87OUwm6JbsOqFE8/QZgYP
	 TltTm78bch/NuHpAyxmmq/RNM6JgSCjCzJgiYxLKIzLxF2YZHTTva/oScCZvvFLzRUfRu
	 xy1Q9vlmMsc72oNXd5tKpp5qx7QgoLJDbQbNsX9BPREWBUTfGInU360G+Rsvnrdl40lKR
	 XmAJ1walCRhbc3pe0iTJegMO23yEyUktbGyPadcICzxFJyiaFwJCSY6LVKiA8bZ43cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5tB3jC/d8Ijo6jwgwu8cJ9lYxW4EQ1AP97u/6rG/Yo=;
	b=ofSNQCW/xqXZsDTv84LP0mZW0xbYl9SvtHVzSeAO8nMEIaFALA/LWVCb+ilnyJnb7TiH
	 hGzh8uSRqLR6mYvQwYKbOoyMZHC23mihco6YY4pgHpoKmDNz14J8B+07NLtsSV36YAI+R
	 tPaeOHOINQZ+SyKsJYBdfnyB0XMjyIdFZ2aCmEeupIg2dLdVWr89mieycBhR9x8Hy0Hnb
	 IuDLzO6giX4Gt2CCV/sHdMnPIwG4NBzmG3SHIpe45XJd3tLpT0rom0w7URmc50CK1HI6m
	 Aplp6+JUiA7zG7Uv0+RQUzr7Gt9IgETWE4No5SLItO1zC6BzjPwHJP3HUIKJhO8JvpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ItBrXK2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763B4606A333;
	Wed, 18 Nov 2026 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ItBrXK2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8861F000C8;
	Wed, 18 Nov 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015439;
	bh=s5tB3jC/d8Ijo6jwgwu8cJ9lYxW4EQ1AP97u/6rG/Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItBrXK2DzCEeWca8uriM9Xx7kljwF95t8wIM4mT4JgBLR5z6oeKNaMH0Ir8aT7zl8
	 yEW3JYPPyFVMV7xSPtOUX9bGt3VOkqB40lxNJglRDqkhuQMiWpUWpZxjClpIqEwu+J
	 blj7/F58OcNpFoI0F+hxBi8uFMVlCKPHiU2SZ1uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Tomasz Siemek <tomasz.siemek@amd.com>,
	James Lin <pinglei.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0175/2651] drm/amd/display: Refactor HUBP_WAIT_FOR_DCC_META_PROP to drop pipe_ctx
Date: Wed, 18 Nov 2026 15:23:35 +0100
Message-ID: <20261118150254.150603246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Siemek <tomasz.siemek@amd.com>

[ Upstream commit 36a749820850e002e73c030cc59d88c43ec6735d ]

[why]
Pipe_ctx shouldn't be passed as block sequence block parameter.

[how]
Precalculate delay during building stage instead during execution.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Tomasz Siemek <tomasz.siemek@amd.com>
Signed-off-by: James Lin <pinglei.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e377716b9863 ("drm/amd/display: use translate_curve_to_degamma_hw_format on DCN30")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      |  4 +-
 .../drm/amd/display/dc/core/dc_hw_sequencer.c | 47 +++++++++++--------
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 24 ++--------
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.h |  3 +-
 .../drm/amd/display/dc/hwss/hw_sequencer.h    | 11 ++---
 5 files changed, 36 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 60b903edff2f8..2b6ed83021f1a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4973,9 +4973,7 @@ static void commit_planes_for_stream(struct dc *dc,
 						top_pipe_to_program->stream_res.tg);
 		}
 
-	if (dc->hwss.wait_for_dcc_meta_propagation) {
-		dc->hwss.wait_for_dcc_meta_propagation(dc, top_pipe_to_program);
-	}
+	hwss_hubp_wait_for_dcc_meta_prop(dc, top_pipe_to_program);
 
 	if (dc->hwseq->funcs.wait_for_pipe_update_if_needed)
 		dc->hwseq->funcs.wait_for_pipe_update_if_needed(dc, top_pipe_to_program, update_type < UPDATE_TYPE_FULL);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index d4dbdf7d05065..5b460c4d2c015 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -1119,6 +1119,22 @@ void hwss_build_post_unlock_full_sequence(struct dc *dc,
 	}
 }
 
+static uint32_t get_dcc_meta_propagation_delay(struct dc *dc, struct pipe_ctx *pipe_ctx)
+{
+	/* check if any surfaces are updating address while using flip immediate and dcc */
+	while (pipe_ctx != NULL) {
+		if (pipe_ctx->plane_state &&
+				pipe_ctx->plane_state->dcc.enable &&
+				pipe_ctx->plane_state->flip_immediate &&
+				pipe_ctx->plane_state->update_bits.addr_update) {
+			return dc->debug.dcc_meta_propagation_delay_us;
+		}
+		/* check next pipe */
+		pipe_ctx = pipe_ctx->bottom_pipe;
+	}
+	return 0;
+}
+
 void hwss_build_fast_sequence(struct dc *dc,
 		struct dc_dmub_cmd *dc_dmub_cmd,
 		unsigned int dmub_cmd_count,
@@ -1142,8 +1158,7 @@ void hwss_build_fast_sequence(struct dc *dc,
 		return;
 
 	if (dc->hwss.wait_for_dcc_meta_propagation) {
-		block_sequence[*num_steps].params.wait_for_dcc_meta_propagation_params.dc = dc;
-		block_sequence[*num_steps].params.wait_for_dcc_meta_propagation_params.top_pipe_to_program = pipe_ctx;
+		block_sequence[*num_steps].params.wait_for_dcc_meta_propagation_params.delay = get_dcc_meta_propagation_delay(dc, pipe_ctx);
 		block_sequence[*num_steps].func = HUBP_WAIT_FOR_DCC_META_PROP;
 		(*num_steps)++;
 	}
@@ -1721,9 +1736,7 @@ void hwss_execute_sequence(struct dc *dc,
 			hwss_subvp_save_surf_addr(params);
 			break;
 		case HUBP_WAIT_FOR_DCC_META_PROP:
-			dc->hwss.wait_for_dcc_meta_propagation(
-					params->wait_for_dcc_meta_propagation_params.dc,
-					params->wait_for_dcc_meta_propagation_params.top_pipe_to_program);
+			dc->hwss.wait_for_dcc_meta_propagation(params->wait_for_dcc_meta_propagation_params.delay);
 			break;
 		case DMUB_HW_CONTROL_LOCK_FAST:
 			dc->hwss.dmub_hw_control_lock_fast(params);
@@ -2436,21 +2449,6 @@ void hwss_add_dmub_subvp_save_surf_addr(struct block_sequence_state *seq_state,
 	}
 }
 
-/*
- * Helper function to add HUBP wait for DCC meta propagation to block sequence
- */
-void hwss_add_hubp_wait_for_dcc_meta_prop(struct block_sequence_state *seq_state,
-		struct dc *dc,
-		struct pipe_ctx *top_pipe_to_program)
-{
-	if (*seq_state->num_steps < MAX_HWSS_BLOCK_SEQUENCE_SIZE) {
-		seq_state->steps[*seq_state->num_steps].params.wait_for_dcc_meta_propagation_params.dc = dc;
-		seq_state->steps[*seq_state->num_steps].params.wait_for_dcc_meta_propagation_params.top_pipe_to_program = top_pipe_to_program;
-		seq_state->steps[*seq_state->num_steps].func = HUBP_WAIT_FOR_DCC_META_PROP;
-		(*seq_state->num_steps)++;
-	}
-}
-
 /*
  * Helper function to add HUBP wait pipe read start to block sequence
  */
@@ -6171,3 +6169,12 @@ void get_refresh_rate_confirm_color(struct pipe_ctx *pipe_ctx, struct tg_color *
 		pipe_ctx->visual_confirm_color.color_b_cb = (uint16_t)color_value;
 	}
 }
+
+void hwss_hubp_wait_for_dcc_meta_prop(struct dc *dc, struct pipe_ctx *top_pipe_to_program)
+{
+	if (dc->hwss.wait_for_dcc_meta_propagation) {
+		uint32_t delay = get_dcc_meta_propagation_delay(dc, top_pipe_to_program);
+		dc->hwss.wait_for_dcc_meta_propagation(delay);
+	}
+}
+
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 51596f445a09f..9e3c1f5beed0c 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1332,28 +1332,10 @@ bool dcn401_apply_idle_power_optimizations(struct dc *dc, bool enable)
 	return true;
 }
 
-void dcn401_wait_for_dcc_meta_propagation(const struct dc *dc,
-		const struct pipe_ctx *top_pipe)
+void dcn401_wait_for_dcc_meta_propagation(uint32_t delay)
 {
-	bool is_wait_needed = false;
-	const struct pipe_ctx *pipe_ctx = top_pipe;
-
-	/* check if any surfaces are updating address while using flip immediate and dcc */
-	while (pipe_ctx != NULL) {
-		if (pipe_ctx->plane_state &&
-				pipe_ctx->plane_state->dcc.enable &&
-				pipe_ctx->plane_state->flip_immediate &&
-				pipe_ctx->plane_state->update_bits.addr_update) {
-			is_wait_needed = true;
-			break;
-		}
-
-		/* check next pipe */
-		pipe_ctx = pipe_ctx->bottom_pipe;
-	}
-
-	if (is_wait_needed && dc->debug.dcc_meta_propagation_delay_us > 0) {
-		udelay(dc->debug.dcc_meta_propagation_delay_us);
+	if (delay > 0) {
+		udelay(delay);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
index 69c7dc73a29a1..2e3392c963d03 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
@@ -57,8 +57,7 @@ void dcn401_set_cursor_position(struct pipe_ctx *pipe_ctx);
 
 bool dcn401_apply_idle_power_optimizations(struct dc *dc, bool enable);
 
-void dcn401_wait_for_dcc_meta_propagation(const struct dc *dc,
-		const struct pipe_ctx *top_pipe_to_program);
+void dcn401_wait_for_dcc_meta_propagation(uint32_t delay);
 
 void dcn401_prepare_bandwidth(struct dc *dc,
 		struct dc_state *context);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
index 0d64a0c1913d9..5ea6d8a1937e2 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
@@ -182,8 +182,7 @@ struct subvp_save_surf_addr {
 };
 
 struct wait_for_dcc_meta_propagation_params {
-	const struct dc *dc;
-	const struct pipe_ctx *top_pipe_to_program;
+	uint32_t delay;
 };
 
 struct dmub_hw_control_lock_fast_params {
@@ -1652,8 +1651,7 @@ struct hw_sequencer_funcs {
 	bool (*is_pipe_topology_transition_seamless)(struct dc *dc,
 			const struct dc_state *cur_ctx,
 			const struct dc_state *new_ctx);
-	void (*wait_for_dcc_meta_propagation)(const struct dc *dc,
-		const struct pipe_ctx *top_pipe_to_program);
+	void (*wait_for_dcc_meta_propagation)(uint32_t delay);
 	void (*dmub_hw_control_lock)(struct dc *dc,
 			struct dc_state *context,
 			bool lock);
@@ -2120,6 +2118,8 @@ void hwss_setup_periodic_interrupt(struct dc *dc, union block_sequence_params *p
 
 void hwss_disable_audio_stream(struct dc *dc, union block_sequence_params *params);
 
+void hwss_hubp_wait_for_dcc_meta_prop(struct dc *dc, struct pipe_ctx *top_pipe_to_program);
+
 void hwss_add_optc_pipe_control_lock(struct block_sequence_state *seq_state,
 		struct dc *dc, struct pipe_ctx *pipe_ctx, bool lock);
 
@@ -2167,9 +2167,6 @@ void hwss_add_dmub_send_dmcub_cmd(struct block_sequence_state *seq_state,
 void hwss_add_dmub_subvp_save_surf_addr(struct block_sequence_state *seq_state,
 		struct dc_dmub_srv *dc_dmub_srv, struct dc_plane_address *addr, uint8_t subvp_index);
 
-void hwss_add_hubp_wait_for_dcc_meta_prop(struct block_sequence_state *seq_state,
-		struct dc *dc, struct pipe_ctx *top_pipe_to_program);
-
 void hwss_add_hubp_wait_pipe_read_start(struct block_sequence_state *seq_state,
 		struct hubp *hubp);
 
-- 
2.53.0



