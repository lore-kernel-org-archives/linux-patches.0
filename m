Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB2832C8B;
	Fri,  6 Dec 2024 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496661; cv=none; b=fYXvc0WwQ1rG7Tj4EKu2LZQcThWglp6WdFcpzKEDiXtCzW80qP26JpIGldRALWqJMESMrxK1VLseEKaJdZDxlC5JD3ncc1HJkkW4hqEdPXY6xPCv7ULLV3tVtujRhmCtA4vxtixjUUCq0omalVxIso1oSJkN92K4wgcydtXP7qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496661; c=relaxed/simple;
	bh=3GRJEfY2xYruKs/0JYwIFEpHwFUwRzamgjxhTPqQaAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh6qK5BNydr1VG9xDhUu8N11TsSev1TTtBl/b9aJLVz9dbLlVXqefQKJAEe+eQTBsm/o1JKP2fQfYbb/Kldb26eYRuvoGJ+FJbGX/x9jYPr9ilOgvvpmZXNzelHa+buqIfqF6ZPme+f5/YXZAx172jw/IQ0Y8kUqKqBtbQytVIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yISlC8pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yISlC8pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7AAC4CED1;
	Fri,  6 Dec 2024 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496660;
	bh=3GRJEfY2xYruKs/0JYwIFEpHwFUwRzamgjxhTPqQaAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yISlC8pv4o3xjx54FLCJaguepJfjGxuTXjHoDRvqlREqFG2frtQqsrYumk2uXPTKN
	 5mTe5mAV+fPc50/mZCMsEpNxQLnst92Xn0bzgXUWl3yUyJm3Pq1wzrEiXfQAmpo0lb
	 M4CGiHPc/en/9vT/pTKRi/L2zRqI59uJ0aqnpE14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/676] drm/amd/display: Check null-initialized variables
Date: Fri,  6 Dec 2024 15:27:40 +0100
Message-ID: <20241206143654.958411588@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 367cd9ceba1933b63bc1d87d967baf6d9fd241d2 ]

[WHAT & HOW]
drr_timing and subvp_pipe are initialized to null and they are not
always assigned new values. It is necessary to check for null before
dereferencing.

This fixes 2 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 3d82cbef12740..ac6357c089e70 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -932,8 +932,9 @@ static bool subvp_drr_schedulable(struct dc *dc, struct dc_state *context)
 	 * for VBLANK: (VACTIVE region of the SubVP pipe can fit the MALL prefetch, VBLANK frame time,
 	 * and the max of (VBLANK blanking time, MALL region)).
 	 */
-	if (stretched_drr_us < (1 / (double)drr_timing->min_refresh_in_uhz) * 1000000 * 1000000 &&
-			subvp_active_us - prefetch_us - stretched_drr_us - max_vblank_mallregion > 0)
+	if (drr_timing &&
+	    stretched_drr_us < (1 / (double)drr_timing->min_refresh_in_uhz) * 1000000 * 1000000 &&
+	    subvp_active_us - prefetch_us - stretched_drr_us - max_vblank_mallregion > 0)
 		schedulable = true;
 
 	return schedulable;
@@ -995,7 +996,7 @@ static bool subvp_vblank_schedulable(struct dc *dc, struct dc_state *context)
 		if (!subvp_pipe && pipe->stream->mall_stream_config.type == SUBVP_MAIN)
 			subvp_pipe = pipe;
 	}
-	if (found) {
+	if (found && subvp_pipe) {
 		main_timing = &subvp_pipe->stream->timing;
 		phantom_timing = &subvp_pipe->stream->mall_stream_config.paired_stream->timing;
 		vblank_timing = &context->res_ctx.pipe_ctx[vblank_index].stream->timing;
-- 
2.43.0



