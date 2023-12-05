Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1628BF7;
	Tue,  5 Dec 2023 03:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCWm2JcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710BBC433C8;
	Tue,  5 Dec 2023 03:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747206;
	bh=qYmYJqcBdSX7+P1AQfPv4p3pODf+7DYJQi/whJJJb0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCWm2JcBCT5zn2TKT+S+DZ/+GOuSsmzyTXNQGkIsJ4+AupWlCkXx7we6CQWyVcnjr
	 d+SR7cm0imuAaWLrztA2P/scQz/C6PMRoKBewBLsvwPjU1Dou2aQsxYiU+UDaRjZne
	 pyGybJjFj3verrQssgMR5ssp4pjhJy3l7GXkZzzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/107] drm/amd/display: clean code-style issues in dcn30_set_mpc_shaper_3dlut
Date: Tue,  5 Dec 2023 12:17:14 +0900
Message-ID: <20231205031537.931438784@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 94369589e4ec13c762fe10a1fdc4463bdfee5d5f ]

This function has many conditions and all code style issues (identation,
missing braces, etc.) make reading it really annoying.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6f395cebdd89 ("drm/amd/display: Fix MPCC 1DLUT programming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn30/dcn30_hwseq.c    | 37 ++++++++++---------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index a1b312483d7f1..07691b487e28c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -91,8 +91,8 @@ bool dcn30_set_blend_lut(
 	return result;
 }
 
-static bool dcn30_set_mpc_shaper_3dlut(
-	struct pipe_ctx *pipe_ctx, const struct dc_stream_state *stream)
+static bool dcn30_set_mpc_shaper_3dlut(struct pipe_ctx *pipe_ctx,
+				       const struct dc_stream_state *stream)
 {
 	struct dpp *dpp_base = pipe_ctx->plane_res.dpp;
 	int mpcc_id = pipe_ctx->plane_res.hubp->inst;
@@ -104,19 +104,18 @@ static bool dcn30_set_mpc_shaper_3dlut(
 	const struct pwl_params *shaper_lut = NULL;
 	//get the shaper lut params
 	if (stream->func_shaper) {
-		if (stream->func_shaper->type == TF_TYPE_HWPWL)
+		if (stream->func_shaper->type == TF_TYPE_HWPWL) {
 			shaper_lut = &stream->func_shaper->pwl;
-		else if (stream->func_shaper->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			cm_helper_translate_curve_to_hw_format(
-					stream->func_shaper,
-					&dpp_base->shaper_params, true);
+		} else if (stream->func_shaper->type == TF_TYPE_DISTRIBUTED_POINTS) {
+			cm_helper_translate_curve_to_hw_format(stream->func_shaper,
+							       &dpp_base->shaper_params, true);
 			shaper_lut = &dpp_base->shaper_params;
 		}
 	}
 
 	if (stream->lut3d_func &&
-		stream->lut3d_func->state.bits.initialized == 1 &&
-		stream->lut3d_func->state.bits.rmu_idx_valid == 1) {
+	    stream->lut3d_func->state.bits.initialized == 1 &&
+	    stream->lut3d_func->state.bits.rmu_idx_valid == 1) {
 		if (stream->lut3d_func->state.bits.rmu_mux_num == 0)
 			mpcc_id_projected = stream->lut3d_func->state.bits.mpc_rmu0_mux;
 		else if (stream->lut3d_func->state.bits.rmu_mux_num == 1)
@@ -125,20 +124,22 @@ static bool dcn30_set_mpc_shaper_3dlut(
 			mpcc_id_projected = stream->lut3d_func->state.bits.mpc_rmu2_mux;
 		if (mpcc_id_projected != mpcc_id)
 			BREAK_TO_DEBUGGER();
-		/*find the reason why logical layer assigned a differant mpcc_id into acquire_post_bldn_3dlut*/
+		/* find the reason why logical layer assigned a different
+		 * mpcc_id into acquire_post_bldn_3dlut
+		 */
 		acquired_rmu = mpc->funcs->acquire_rmu(mpc, mpcc_id,
-				stream->lut3d_func->state.bits.rmu_mux_num);
+						       stream->lut3d_func->state.bits.rmu_mux_num);
 		if (acquired_rmu != stream->lut3d_func->state.bits.rmu_mux_num)
 			BREAK_TO_DEBUGGER();
-		result = mpc->funcs->program_3dlut(mpc,
-								&stream->lut3d_func->lut_3d,
-								stream->lut3d_func->state.bits.rmu_mux_num);
+
+		result = mpc->funcs->program_3dlut(mpc, &stream->lut3d_func->lut_3d,
+						   stream->lut3d_func->state.bits.rmu_mux_num);
 		result = mpc->funcs->program_shaper(mpc, shaper_lut,
-				stream->lut3d_func->state.bits.rmu_mux_num);
-	} else
-		/*loop through the available mux and release the requested mpcc_id*/
+						    stream->lut3d_func->state.bits.rmu_mux_num);
+	} else {
+		// loop through the available mux and release the requested mpcc_id
 		mpc->funcs->release_rmu(mpc, mpcc_id);
-
+	}
 
 	return result;
 }
-- 
2.42.0



