Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0EB15B984;
	Mon, 29 Jan 2024 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548291; cv=none; b=P8L0psYcPTt1yuJR7vdeg6uo+EuTwrqpD4aNt8RABPw6lTlDfMgeSqH8jZn8MBXZFB+oW3jMToE0Pf6kM9jKbZ7aZ4Wb69J/B13/AVckE1Juh2MuFTpN+LBw/kpOz9usNbQY/mTVwnRDir3NVlWLGiYnBEqw2DQ7yHCJAqdS3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548291; c=relaxed/simple;
	bh=WzDKNl4EXX0ltNAQdQBTaF7TCkrJh7GeWswM6Jg8YCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwpjwX0ZARRy36rCC4B9tXuvTOIzGaagPaiD3X8BYRZyl9uJcxN03PiWtip60EdBrnr/UH5EZ6xNZyXukUZMoejYvrdPak0ZfyT61wsrW4gRLUQ2t4JBbEOX9+g+r09Q3WwgUBOsyzlwfrB3ecMLhFkSwu1UVh2JjnwMug9lriw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlLEqEyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlLEqEyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F602C433F1;
	Mon, 29 Jan 2024 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548291;
	bh=WzDKNl4EXX0ltNAQdQBTaF7TCkrJh7GeWswM6Jg8YCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlLEqEyLhs3S+YB/YWOQJWT2hMGaV3HYKEhOhRma8hBsmxeRfyW1/1cCVVSH87hQH
	 YAmV658aNTm2EmBv0ILjA8gU34eUUZqN1BMkWTSfOPcXIXvUWzYZjKbDwkjhWF3DFz
	 F/U5IKKZitQU47fWdelgnvlQcBfq0OqgmXgOfm7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 301/346] drm/amd/display: update pixel clock params after stream slice count change in context
Date: Mon, 29 Jan 2024 09:05:32 -0800
Message-ID: <20240129170025.279030733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit cfab803884f426b36b58dbe1f86f99742767c208 ]

[why]
When ODM slice count is changed, otg master pipe's pixel clock params is
no longer valid as the value is dependent on ODM slice count.

Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: aa36d8971fcc ("drm/amd/display: Init link enc resources in dc_state only if res_pool presents")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_resource.c    |  9 ++++++---
 .../drm/amd/display/dc/dcn20/dcn20_resource.c    | 16 ++++++++++------
 .../drm/amd/display/dc/dcn20/dcn20_resource.h    |  1 +
 .../drm/amd/display/dc/dcn32/dcn32_resource.c    |  1 +
 .../drm/amd/display/dc/dcn321/dcn321_resource.c  |  1 +
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c |  6 +-----
 drivers/gpu/drm/amd/display/dc/inc/core_types.h  |  1 +
 7 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index ae275f1780d5..c16190a10883 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2237,7 +2237,7 @@ static struct pipe_ctx *get_last_dpp_pipe_in_mpcc_combine(
 }
 
 static bool update_pipe_params_after_odm_slice_count_change(
-		const struct dc_stream_state *stream,
+		struct pipe_ctx *otg_master,
 		struct dc_state *context,
 		const struct resource_pool *pool)
 {
@@ -2247,9 +2247,12 @@ static bool update_pipe_params_after_odm_slice_count_change(
 
 	for (i = 0; i < pool->pipe_count && result; i++) {
 		pipe = &context->res_ctx.pipe_ctx[i];
-		if (pipe->stream == stream && pipe->plane_state)
+		if (pipe->stream == otg_master->stream && pipe->plane_state)
 			result = resource_build_scaling_params(pipe);
 	}
+
+	if (pool->funcs->build_pipe_pix_clk_params)
+		pool->funcs->build_pipe_pix_clk_params(otg_master);
 	return result;
 }
 
@@ -2932,7 +2935,7 @@ bool resource_update_pipes_for_stream_with_slice_count(
 					otg_master, new_ctx, pool);
 	if (result)
 		result = update_pipe_params_after_odm_slice_count_change(
-				otg_master->stream, new_ctx, pool);
+				otg_master, new_ctx, pool);
 	return result;
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 0a422fbb14bc..e73e59754837 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1273,15 +1273,19 @@ static void build_clamping_params(struct dc_stream_state *stream)
 	stream->clamping.pixel_encoding = stream->timing.pixel_encoding;
 }
 
-static enum dc_status build_pipe_hw_param(struct pipe_ctx *pipe_ctx)
+void dcn20_build_pipe_pix_clk_params(struct pipe_ctx *pipe_ctx)
 {
-
 	get_pixel_clock_parameters(pipe_ctx, &pipe_ctx->stream_res.pix_clk_params);
-
 	pipe_ctx->clock_source->funcs->get_pix_clk_dividers(
-		pipe_ctx->clock_source,
-		&pipe_ctx->stream_res.pix_clk_params,
-		&pipe_ctx->pll_settings);
+			pipe_ctx->clock_source,
+			&pipe_ctx->stream_res.pix_clk_params,
+			&pipe_ctx->pll_settings);
+}
+
+static enum dc_status build_pipe_hw_param(struct pipe_ctx *pipe_ctx)
+{
+
+	dcn20_build_pipe_pix_clk_params(pipe_ctx);
 
 	pipe_ctx->stream->clamping.pixel_encoding = pipe_ctx->stream->timing.pixel_encoding;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.h b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.h
index 37ecaccc5d12..4cee3fa11a7f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.h
@@ -165,6 +165,7 @@ enum dc_status dcn20_add_stream_to_ctx(struct dc *dc, struct dc_state *new_ctx,
 enum dc_status dcn20_add_dsc_to_stream_resource(struct dc *dc, struct dc_state *dc_ctx, struct dc_stream_state *dc_stream);
 enum dc_status dcn20_remove_stream_from_ctx(struct dc *dc, struct dc_state *new_ctx, struct dc_stream_state *dc_stream);
 enum dc_status dcn20_patch_unknown_plane_state(struct dc_plane_state *plane_state);
+void dcn20_build_pipe_pix_clk_params(struct pipe_ctx *pipe_ctx);
 
 #endif /* __DC_RESOURCE_DCN20_H__ */
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 89b072447dba..e940dd0f92b7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2041,6 +2041,7 @@ static struct resource_funcs dcn32_res_pool_funcs = {
 	.retain_phantom_pipes = dcn32_retain_phantom_pipes,
 	.save_mall_state = dcn32_save_mall_state,
 	.restore_mall_state = dcn32_restore_mall_state,
+	.build_pipe_pix_clk_params = dcn20_build_pipe_pix_clk_params,
 };
 
 static uint32_t read_pipe_fuses(struct dc_context *ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index f7de3eca1225..4156a8cc2bc7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1609,6 +1609,7 @@ static struct resource_funcs dcn321_res_pool_funcs = {
 	.retain_phantom_pipes = dcn32_retain_phantom_pipes,
 	.save_mall_state = dcn32_save_mall_state,
 	.restore_mall_state = dcn32_restore_mall_state,
+	.build_pipe_pix_clk_params = dcn20_build_pipe_pix_clk_params,
 };
 
 static uint32_t read_pipe_fuses(struct dc_context *ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index b46cde525066..92e2ddc9ab7e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1237,15 +1237,11 @@ static void update_pipes_with_slice_table(struct dc *dc, struct dc_state *contex
 {
 	int i;
 
-	for (i = 0; i < table->odm_combine_count; i++) {
+	for (i = 0; i < table->odm_combine_count; i++)
 		resource_update_pipes_for_stream_with_slice_count(context,
 				dc->current_state, dc->res_pool,
 				table->odm_combines[i].stream,
 				table->odm_combines[i].slice_count);
-		/* TODO: move this into the function above */
-		dcn20_build_mapped_resource(dc, context,
-				table->odm_combines[i].stream);
-	}
 
 	for (i = 0; i < table->mpc_combine_count; i++)
 		resource_update_pipes_for_plane_with_slice_count(context,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index bac1420b1de8..10397d4dfb07 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -205,6 +205,7 @@ struct resource_funcs {
 	void (*get_panel_config_defaults)(struct dc_panel_config *panel_config);
 	void (*save_mall_state)(struct dc *dc, struct dc_state *context, struct mall_temp_config *temp_config);
 	void (*restore_mall_state)(struct dc *dc, struct dc_state *context, struct mall_temp_config *temp_config);
+	void (*build_pipe_pix_clk_params)(struct pipe_ctx *pipe_ctx);
 };
 
 struct audio_support{
-- 
2.43.0



