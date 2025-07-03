Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5144122069F;
	Thu,  3 Jul 2025 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555302; cv=none; b=gQkvijceNqb2t9v/0z31q/IkdHzEGmpKnMfHzdoukhLciWRrT1Lu63uF87PVb491lJZc2jgTv1Y0Fhs91pGgvRcpg1M4pKUsnj9GxiJlt9cVSCf1D/zKHQ7+hdKDlfL3GIEWxkx5Z6vb8IfMTouVfcFQ/WwsFtrOguwvBUBSYas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555302; c=relaxed/simple;
	bh=ZtP3xpM9qGQ/Z7cTGYjLsIf9GHgvGCg4ZspywRwf+E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab9NJsTyspCwASAi6cuw0AI4P3XnFvq51hKJxHH/kmJGF+MrHdYEXRwpj8a968twBX4iqZVcw9O+Ql6tq2YhzBfMAE8MvjAJAOWPrH9FZ+bN0iid6rJo4Pt/SiQ7l/b4KXdmZ7meotUbLiaJWwLgzlkPKS4mBLUsCdWnvcL2JmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg1jotK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg1jotK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDA8C4CEED;
	Thu,  3 Jul 2025 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555302;
	bh=ZtP3xpM9qGQ/Z7cTGYjLsIf9GHgvGCg4ZspywRwf+E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg1jotK4LD0sG7innYb8RV6EVYA4PzWJHhVOjLZhbniQq1Uy1IG2pBaTtxCKTJcjm
	 czNqlIV5R6obpIRO7b6I3Iz9i+AephUTkjfUkZZYnsIt9VcHwm1zItndeCO8QuHcW7
	 INT166Z+b5/8GW/ATYZ+4NjC11wWarj+KqVIqOXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Duncan Ma <duncan.ma@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.15 237/263] drm/amd/display: Add more checks for DSC / HUBP ONO guarantees
Date: Thu,  3 Jul 2025 16:42:37 +0200
Message-ID: <20250703144013.901488136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 0d57dd1765d311111d9885346108c4deeae1deb4 upstream.

[WHY]
For non-zero DSC instances it's possible that the HUBP domain required
to drive it for sequential ONO ASICs isn't met, potentially causing
the logic to the tile to enter an undefined state leading to a system
hang.

[HOW]
Add more checks to ensure that the HUBP domain matching the DSC instance
is appropriately powered.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Duncan Ma <duncan.ma@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit da63df07112e5a9857a8d2aaa04255c4206754ec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c |   28 ++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1047,6 +1047,15 @@ void dcn35_calc_blocks_to_gate(struct dc
 			if (dc->caps.sequential_ono) {
 				update_state->pg_pipe_res_update[PG_HUBP][pipe_ctx->stream_res.dsc->inst] = false;
 				update_state->pg_pipe_res_update[PG_DPP][pipe_ctx->stream_res.dsc->inst] = false;
+
+				/* All HUBP/DPP instances must be powered if the DSC inst != HUBP inst */
+				if (!pipe_ctx->top_pipe && pipe_ctx->plane_res.hubp &&
+				    pipe_ctx->plane_res.hubp->inst != pipe_ctx->stream_res.dsc->inst) {
+					for (j = 0; j < dc->res_pool->pipe_count; ++j) {
+						update_state->pg_pipe_res_update[PG_HUBP][j] = false;
+						update_state->pg_pipe_res_update[PG_DPP][j] = false;
+					}
+				}
 			}
 		}
 
@@ -1193,6 +1202,25 @@ void dcn35_calc_blocks_to_ungate(struct
 		update_state->pg_pipe_res_update[PG_HDMISTREAM][0] = true;
 
 	if (dc->caps.sequential_ono) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *new_pipe = &context->res_ctx.pipe_ctx[i];
+
+			if (new_pipe->stream_res.dsc && !new_pipe->top_pipe &&
+			    update_state->pg_pipe_res_update[PG_DSC][new_pipe->stream_res.dsc->inst]) {
+				update_state->pg_pipe_res_update[PG_HUBP][new_pipe->stream_res.dsc->inst] = true;
+				update_state->pg_pipe_res_update[PG_DPP][new_pipe->stream_res.dsc->inst] = true;
+
+				/* All HUBP/DPP instances must be powered if the DSC inst != HUBP inst */
+				if (new_pipe->plane_res.hubp &&
+				    new_pipe->plane_res.hubp->inst != new_pipe->stream_res.dsc->inst) {
+					for (j = 0; j < dc->res_pool->pipe_count; ++j) {
+						update_state->pg_pipe_res_update[PG_HUBP][j] = true;
+						update_state->pg_pipe_res_update[PG_DPP][j] = true;
+					}
+				}
+			}
+		}
+
 		for (i = dc->res_pool->pipe_count - 1; i >= 0; i--) {
 			if (update_state->pg_pipe_res_update[PG_HUBP][i] &&
 			    update_state->pg_pipe_res_update[PG_DPP][i]) {


