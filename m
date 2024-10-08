Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B369D1C2420;
	Tue,  8 Oct 2024 12:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391761; cv=none; b=hiy9k4jSOXYNeFrzDj4qyIEoKcHttA8CBH6aYG3MVe4yIwQWpjZdtMlKc1Uc3ddyZjsL5zyNQjpeDXKrvOr+WuvRqhK9Y6xeCWpwG50cm+KFb7mW+MSHf1z+6SdnwXiwaotDZqmyVL7duTBWPn4rEEGc8OMAnjfjLkHC1wnu0dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391761; c=relaxed/simple;
	bh=Vr4WuF/7WujVZJH2IqKk4rUXiLPOoIkRMvxjfzv1vls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl1/ktI409Lvl0QijWX54qrOIr1a5CltbK/Y3YgV4N0LjeImCH9SPkhs5uPqY1QPOrf0MpUAb0NQCsJb2m+gwuzIyYftfZ2y2aE4UTkIRUhRcDcKdkR2ZnsBnbqAXin41l2+hikf7ojiVV/t8R+G95bX99iakZTl639NTyA3+GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsoH0dPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsoH0dPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97A4C4CEC7;
	Tue,  8 Oct 2024 12:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391761;
	bh=Vr4WuF/7WujVZJH2IqKk4rUXiLPOoIkRMvxjfzv1vls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsoH0dPxJfKXpKMCO1JFoOe9iaT+YbSem+fyrq/lgO/kdIn1hkZf1kqbZBvLmKVNW
	 OH4i4GJqXwE9wAOfmmobg3rlMIdc9bkDRScn+YXZwEstv7hWLu1xHtZ4ye9+2K7BN/
	 z+wqeZ9MLXqp3BWYtfEEwrSDGBrb2ukPnrlWukko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 215/558] drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Tue,  8 Oct 2024 14:04:05 +0200
Message-ID: <20241008115710.804568245@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 8e4ed3cf1642df0c4456443d865cff61a9598aa8 ]

This commit addresses a null pointer dereference issue in the
`dcn20_program_pipe` function. The issue could occur when
`pipe_ctx->plane_state` is null.

The fix adds a check to ensure `pipe_ctx->plane_state` is not null
before accessing. This prevents a null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn20/dcn20_hwseq.c:1925 dcn20_program_pipe() error: we previously assumed 'pipe_ctx->plane_state' could be null (see line 1877)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 30 ++++++++++++-------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 456e19e0d415c..17d1c195663a0 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1921,22 +1921,29 @@ static void dcn20_program_pipe(
 				dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->hubp_regs.det_size);
 	}
 
-	if (pipe_ctx->update_flags.raw || pipe_ctx->plane_state->update_flags.raw || pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->update_flags.raw ||
+	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
+	    pipe_ctx->stream->update_flags.raw)
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
-	if (pipe_ctx->update_flags.bits.enable
-			|| pipe_ctx->plane_state->update_flags.bits.hdr_mult)
+	if (pipe_ctx->update_flags.bits.enable ||
+	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult))
 		hws->funcs.set_hdr_multiplier(pipe_ctx);
 
 	if (hws->funcs.populate_mcm_luts) {
-		hws->funcs.populate_mcm_luts(dc, pipe_ctx, pipe_ctx->plane_state->mcm_luts,
-				pipe_ctx->plane_state->lut_bank_a);
-		pipe_ctx->plane_state->lut_bank_a = !pipe_ctx->plane_state->lut_bank_a;
+		if (pipe_ctx->plane_state) {
+			hws->funcs.populate_mcm_luts(dc, pipe_ctx, pipe_ctx->plane_state->mcm_luts,
+						     pipe_ctx->plane_state->lut_bank_a);
+			pipe_ctx->plane_state->lut_bank_a = !pipe_ctx->plane_state->lut_bank_a;
+		}
 	}
 	if (pipe_ctx->update_flags.bits.enable ||
-	    pipe_ctx->plane_state->update_flags.bits.in_transfer_func_change ||
-	    pipe_ctx->plane_state->update_flags.bits.gamma_change ||
-	    pipe_ctx->plane_state->update_flags.bits.lut_3d)
+	    (pipe_ctx->plane_state &&
+	     pipe_ctx->plane_state->update_flags.bits.in_transfer_func_change) ||
+	    (pipe_ctx->plane_state &&
+	     pipe_ctx->plane_state->update_flags.bits.gamma_change) ||
+	    (pipe_ctx->plane_state &&
+	     pipe_ctx->plane_state->update_flags.bits.lut_3d))
 		hws->funcs.set_input_transfer_func(dc, pipe_ctx, pipe_ctx->plane_state);
 
 	/* dcn10_translate_regamma_to_hw_format takes 750us to finish
@@ -1946,7 +1953,8 @@ static void dcn20_program_pipe(
 	if (pipe_ctx->update_flags.bits.enable ||
 			pipe_ctx->update_flags.bits.plane_changed ||
 			pipe_ctx->stream->update_flags.bits.out_tf ||
-			pipe_ctx->plane_state->update_flags.bits.output_tf_change)
+			(pipe_ctx->plane_state &&
+			 pipe_ctx->plane_state->update_flags.bits.output_tf_change))
 		hws->funcs.set_output_transfer_func(dc, pipe_ctx, pipe_ctx->stream);
 
 	/* If the pipe has been enabled or has a different opp, we
@@ -1970,7 +1978,7 @@ static void dcn20_program_pipe(
 	}
 
 	/* Set ABM pipe after other pipe configurations done */
-	if (pipe_ctx->plane_state->visible) {
+	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->visible)) {
 		if (pipe_ctx->stream_res.abm) {
 			dc->hwss.set_pipe(pipe_ctx);
 			pipe_ctx->stream_res.abm->funcs->set_abm_level(pipe_ctx->stream_res.abm,
-- 
2.43.0



