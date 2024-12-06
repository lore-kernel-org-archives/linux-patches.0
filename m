Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC411474AF;
	Fri,  6 Dec 2024 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496695; cv=none; b=LWwICY24+VUXtHG1oV2GtUNk3hemHYWh1Ofak+8K+b0Dtu6J9Wi8zkrqpewTDO2uWr9p66xqDcIyaqCHlR0055W+KvNQ7LMjcgGdo9Yko1BN2VZIOpm+7bKRijal3wCmbj3PIIVxOnX6iU03OXsqlO5OJAbCxvLEv00McVgjWq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496695; c=relaxed/simple;
	bh=xq3lnvbvqjqcpSeh61GbIOh7lAlv43eqVuG57a81nyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptLxbixKMHLl15Fhp2hB5Y8sTt8nwEbTKhbYMrrcW4sICpMS8WQ0Qy5bhw1OsDQGco8pIcd56wAAye36/okNe4kVMkrY+iluMsGmZqfQeLt/tJ46tBR3H7LS+6fh6wxqbkqw5KqLaHtnbXcvYfAgxhDBNfXYkmSeGpXnNBbEzuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD03UCmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD03UCmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B40CC4CED1;
	Fri,  6 Dec 2024 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496695;
	bh=xq3lnvbvqjqcpSeh61GbIOh7lAlv43eqVuG57a81nyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD03UCmUtEK43h9xvpVLebj24ivQ7FbuBeVNrMDFGbBOM4CLaDZNRSo1X+SZs/n4S
	 G7XxhW9WPOUM69MQZW7Y3iMvWzajaosnv77ZKR+X5GDVdpIpXcD30j8FdnN7ad0eiA
	 Lmz/DbIuEtBonrECFl2CkIJyAjra4KF1Z/73z9TM=
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
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 046/676] drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Fri,  6 Dec 2024 15:27:45 +0100
Message-ID: <20241206143655.153428167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[Xiangyu: BP to fix CVE: CVE-2024-49914, modified the file path from
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn20/dcn20_hwseq.c to
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_hwseq.c
and minor conflict resolution]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 12af2859002f7..cd1d1b7283ab9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1732,17 +1732,22 @@ static void dcn20_program_pipe(
 		dc->res_pool->hubbub->funcs->program_det_size(
 			dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->det_buffer_size_kb);
 
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
@@ -1752,7 +1757,8 @@ static void dcn20_program_pipe(
 	if (pipe_ctx->update_flags.bits.enable ||
 			pipe_ctx->update_flags.bits.plane_changed ||
 			pipe_ctx->stream->update_flags.bits.out_tf ||
-			pipe_ctx->plane_state->update_flags.bits.output_tf_change)
+			(pipe_ctx->plane_state &&
+			 pipe_ctx->plane_state->update_flags.bits.output_tf_change))
 		hws->funcs.set_output_transfer_func(dc, pipe_ctx, pipe_ctx->stream);
 
 	/* If the pipe has been enabled or has a different opp, we
@@ -1776,7 +1782,7 @@ static void dcn20_program_pipe(
 	}
 
 	/* Set ABM pipe after other pipe configurations done */
-	if (pipe_ctx->plane_state->visible) {
+	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->visible)) {
 		if (pipe_ctx->stream_res.abm) {
 			dc->hwss.set_pipe(pipe_ctx);
 			pipe_ctx->stream_res.abm->funcs->set_abm_level(pipe_ctx->stream_res.abm,
-- 
2.43.0



