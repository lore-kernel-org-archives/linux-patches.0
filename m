Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6862115218A;
	Tue,  2 Jul 2024 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940184; cv=none; b=PCh+XUcuwObbBKpXl5Z5YMpnG8g+COPeZR6o7lBOBYuRjm0Lz9nqdUgzfBU1AU4eQMO5Gg/ELYKfuBqkCjWlWSZLlydB6r8xNwborzcxGJKCV7drnmmrlFBhVY883kbFoLvyJGLMwco9gky0DMJqv2PaS/NVPwN+x0OOceWr3Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940184; c=relaxed/simple;
	bh=EfoWlHyf6Qy9JIlEUJQuarZhs2lGGutubptezkQ6ArM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW83U2T0L5b5EBzAoH+3E8Nj9dqvwLuyfTl9w8irxfjdFqwgbmZfe8ymguwAIPBQcLGLZ6CgB2FI4YC9t17AbNWkb/GUgdl6NsTS9dZpln1scOVqChKiFMP2hxKrFFcXRIUlX2wdv5sCUouCiUa8MfJjrJHevspODHi9/eleAww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCNZLjl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCNZLjl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85C0C4AF07;
	Tue,  2 Jul 2024 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940184;
	bh=EfoWlHyf6Qy9JIlEUJQuarZhs2lGGutubptezkQ6ArM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCNZLjl1eHyj2Nxj0W5+Xtb9tn5E4MHrQTdYZN8/CM8eac48RknXoAgHtna8IG8Xp
	 V15VfKC7lAljScUXNDFJQaclW3wZ1MnPoHvsDXw/Msa+8jZJb4p9w4Z5iRC+unvCCV
	 3y8aLMVjnFPRmoFqTyq4/eifUzLPXR3ej6DB7GrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Muhammad Ahmed <ahmed.ahmed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 076/222] drm/amd/display: Skip pipe if the pipe idx not set properly
Date: Tue,  2 Jul 2024 19:01:54 +0200
Message-ID: <20240702170246.885441812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Ahmed <ahmed.ahmed@amd.com>

[ Upstream commit af114efe8d24b5711cfbedf7180f2ac1a296c24b ]

[why]
Driver crashes when pipe idx not set properly

[how]
Add code to skip the pipe that idx not set properly

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Muhammad Ahmed <ahmed.ahmed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
index f15d1dbad6a96..b72ed3e78df05 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
@@ -327,6 +327,8 @@ void dml2_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_state *cont
 			dml_pipe_idx = dml2_helper_find_dml_pipe_idx_by_stream_id(in_ctx, context->res_ctx.pipe_ctx[dc_pipe_ctx_index].stream->stream_id);
 		}
 
+		if (dml_pipe_idx == 0xFFFFFFFF)
+			continue;
 		ASSERT(in_ctx->v20.scratch.dml_to_dc_pipe_mapping.dml_pipe_idx_to_stream_id_valid[dml_pipe_idx]);
 		ASSERT(in_ctx->v20.scratch.dml_to_dc_pipe_mapping.dml_pipe_idx_to_stream_id[dml_pipe_idx] == context->res_ctx.pipe_ctx[dc_pipe_ctx_index].stream->stream_id);
 
@@ -468,6 +470,9 @@ bool dml2_verify_det_buffer_configuration(struct dml2_context *in_ctx, struct dc
 			dml_pipe_idx = find_dml_pipe_idx_by_plane_id(in_ctx, plane_id);
 		else
 			dml_pipe_idx = dml2_helper_find_dml_pipe_idx_by_stream_id(in_ctx, display_state->res_ctx.pipe_ctx[i].stream->stream_id);
+
+		if (dml_pipe_idx == 0xFFFFFFFF)
+			continue;
 		total_det_allocated += dml_get_det_buffer_size_kbytes(&in_ctx->v20.dml_core_ctx, dml_pipe_idx);
 		if (total_det_allocated > max_det_size) {
 			need_recalculation = true;
-- 
2.43.0



