Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209BA2080FC;
	Thu, 12 Dec 2024 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017014; cv=none; b=dhpo0eGK+n9lS14i4qBXNBpWklRtaedm+ylh5CQitefZ28l/gqjuNGWz2ybtj35pD2a6SErNWEH0hKYtW0sqiQIMrkuT/mZ36sQk83N0bDefuuYdf6iN7VuJ0c9mea6DYZK3jqnv0yX4bqRfFrLlAVfcAI2DE7Vk8dm003rnFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017014; c=relaxed/simple;
	bh=oNDPXtHL6rsRSHaUvERmKumV2qDblZD0uTAe6cYnIgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm7zIRTVlF4paQ7SjpsX5+dhSxENly7gCp/uKHH9Hnkd+NfZ5PPjVjQkjbtzv0V/4VJ/6J5fxt9Y6faU3oFFaQnzYmo87beX8MnK6hQWudxUVlqW8/a53K6bQljTETOfTncn6TVS193y/nky/3f4yF5A6wkJSwC9wY3SlIO/gw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wZPWgNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wZPWgNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8130FC4CECE;
	Thu, 12 Dec 2024 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017014;
	bh=oNDPXtHL6rsRSHaUvERmKumV2qDblZD0uTAe6cYnIgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wZPWgNeHvjxrapqK9jifkIZPOcX7mWxcF8ulRR/qADJL/WvF+cCoHDh4WcBxrW+R
	 0dQm66A7Kro1hXizCfBzpMGrp0QKpePb6cvDguNNny2GG9fcxb2J6LgqAVp718L9dM
	 xbtsTGWT8HvyaEnWYqYrOdWEu5DKH3BaPytFBLmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/466] drm/amd/display: Remove hw w/a toggle if on DP2/HPO
Date: Thu, 12 Dec 2024 15:58:15 +0100
Message-ID: <20241212144319.669836624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit b4c804628485af2b46f0d24a87190735cac37d61 ]

[why&how]
Applying a hw w/a only relevant to DIG FIFO causing corruption
using HPO, do not apply the w/a if on DP2/HPO

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 7d68006137a97..3bd0d46c17010 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -132,6 +132,8 @@ static void dcn35_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *
 	for (i = 0; i < dc->res_pool->pipe_count; ++i) {
 		struct pipe_ctx *old_pipe = &dc->current_state->res_ctx.pipe_ctx[i];
 		struct pipe_ctx *new_pipe = &context->res_ctx.pipe_ctx[i];
+		struct clk_mgr_internal *clk_mgr_internal = TO_CLK_MGR_INTERNAL(clk_mgr_base);
+		struct dccg *dccg = clk_mgr_internal->dccg;
 		struct pipe_ctx *pipe = safe_to_lower
 			? &context->res_ctx.pipe_ctx[i]
 			: &dc->current_state->res_ctx.pipe_ctx[i];
@@ -148,8 +150,13 @@ static void dcn35_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *
 		new_pipe->stream_res.stream_enc &&
 		new_pipe->stream_res.stream_enc->funcs->is_fifo_enabled &&
 		new_pipe->stream_res.stream_enc->funcs->is_fifo_enabled(new_pipe->stream_res.stream_enc);
-		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal) ||
-			!pipe->stream->link_enc) && !stream_changed_otg_dig_on) {
+		bool has_active_hpo = dccg->ctx->dc->link_srv->dp_is_128b_132b_signal(old_pipe) && dccg->ctx->dc->link_srv->dp_is_128b_132b_signal(new_pipe);
+
+		if (!has_active_hpo && !dccg->ctx->dc->link_srv->dp_is_128b_132b_signal(pipe) &&
+					(pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal) ||
+					!pipe->stream->link_enc) && !stream_changed_otg_dig_on)) {
+
+
 			/* This w/a should not trigger when we have a dig active */
 			if (disable) {
 				if (pipe->stream_res.tg && pipe->stream_res.tg->funcs->immediate_disable_crtc)
-- 
2.43.0



