Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C412A2210FB;
	Thu, 12 Dec 2024 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018798; cv=none; b=G26Nb0B4NXMyqgG7vi+A+D2/siT0T1F8a2tFPLaQToDdlxnhrYqxAztL0Sua0Wp1PsrDjbn/z3xZ4GAvInPlZFJ6Vq2qJdkk56mD4UoGG5AI8EO8/kereDm7P7QMbMjLZ+oT2AhVgBtaEOP4LBVhXCajrsWW1Bl9l5M0GAFG8CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018798; c=relaxed/simple;
	bh=SPeOurpFIM7XU929DPYIrdc3hLP5J3CUvi9xKgtV7Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0ocQXHYO+z4bEM5/0pZ6Srw6HKXBi8H6WDzSBmU5q9A9nVIRBvKmfpWUIdq/mFYreHMPc2Ae2g/Un0T6PFPFTCcIZ9aTkdu8+CgR7Knu8umLjwGFy0eATvBOLGkwZ4b3k0T1HlnpSjgEM7C7yqIl44pgbydvwYP2zK8bzuU1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGKj61Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGKj61Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F35C4CECE;
	Thu, 12 Dec 2024 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018798;
	bh=SPeOurpFIM7XU929DPYIrdc3hLP5J3CUvi9xKgtV7Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGKj61Pn3l9ZvJRdMbGpGCpH17J4KQXsbTMGuRYjr/GTQlsfIHFlaAbcj6FvtiC4M
	 2mL9cP+Q0UYneFPxdHvTWOkDZCuQ+6qIKxpzdK4FDoV8ULPbD7ZI0qYuUeUjpzyghb
	 VfvR3VMFsA3MUVaWXrVXxHubJpi3Uy3KQpUdMKFk=
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
Subject: [PATCH 6.1 037/772] drm/amd/display: Check null-initialized variables
Date: Thu, 12 Dec 2024 15:49:42 +0100
Message-ID: <20241212144351.475902680@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[Xiangyu: BP to fix CVE: CVE-2024-49898, Minor conflict resolution]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 85e0d1c2a9085..9d8917f72d184 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -900,8 +900,9 @@ static bool subvp_drr_schedulable(struct dc *dc, struct dc_state *context, struc
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
@@ -966,7 +967,7 @@ static bool subvp_vblank_schedulable(struct dc *dc, struct dc_state *context)
 	if (found && context->res_ctx.pipe_ctx[vblank_index].stream->ignore_msa_timing_param) {
 		// SUBVP + DRR case
 		schedulable = subvp_drr_schedulable(dc, context, &context->res_ctx.pipe_ctx[vblank_index]);
-	} else if (found) {
+	} else if (found && subvp_pipe) {
 		main_timing = &subvp_pipe->stream->timing;
 		phantom_timing = &subvp_pipe->stream->mall_stream_config.paired_stream->timing;
 		vblank_timing = &context->res_ctx.pipe_ctx[vblank_index].stream->timing;
-- 
2.43.0



