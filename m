Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBE81D1504;
	Wed,  2 Oct 2024 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878670; cv=none; b=AxjcGCFNud3WLQ2ptlCbp6Wj1awlVUtiZZj0rk6/FstcHwSMgUUcDO5G4Y0dakvPlLEBiE9oRIvi/nxxHImzetK9QVj6OahCXSSs8Q6hnY+5hSIBzOcCX8WLt4/t4rXvg8pQ+2opGqAu0Dz3e/tSNXEr/XLORq0L9DY4y3iELRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878670; c=relaxed/simple;
	bh=7ThO5c/c+qRVzEAvAGvxZOTiLCRCN6+3hyGlpc1NmwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhUCxk0L1xNxI5ImfYb6dz01C1MaiItM0W5PUukfvzKlcR+GtoRnHtr4PDO6QJ1idYgBscIU8bTOPGlxf4qd7jMjEU84XK9Rw2QICBR+Vb8WIpow/yt0plGeqy0eTETWhi2sCisfZ8uhzhcK4m7TWgnYF7NmIZVdtANgAbNpunY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZVk/nob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZVk/nob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9695CC4CEC2;
	Wed,  2 Oct 2024 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878670;
	bh=7ThO5c/c+qRVzEAvAGvxZOTiLCRCN6+3hyGlpc1NmwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZVk/nob8xkNzV6xa0lyoDiKIKHbQnuYUsBDpi31OB82dLkMOgHl7aA4An1vRWpeI
	 KYkGUPJoqQZ0T8uQ3uu7pc955nLsamzXmMf1iJyuMOtGAGzAgsUjfhWqqCD5m22Sru
	 IMwQE8E1PUlxlSLBaPzL1rAjnBD7qc0bQ62yLwak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Chris Park <chris.park@amd.com>,
	Leo Ma <hanghong.ma@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 492/634] drm/amd/display: Add HDMI DSC native YCbCr422 support
Date: Wed,  2 Oct 2024 14:59:52 +0200
Message-ID: <20241002125830.520858054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Ma <hanghong.ma@amd.com>

commit 07bfa9cdbf3cd2daadfaaba0601f126f45951ffa upstream.

[WHY && HOW]
For some HDMI OVT timing, YCbCr422 encoding fails at the DSC
bandwidth check. The root cause is our DSC policy for timing
doesn't account for HDMI YCbCr422 native support.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Chris Park <chris.park@amd.com>
Signed-off-by: Leo Ma <hanghong.ma@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    4 ++--
 drivers/gpu/drm/amd/display/dc/dc_dsc.h                     |    3 ++-
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c                 |    5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1111,7 +1111,7 @@ static int compute_mst_dsc_configs_for_l
 		params[count].num_slices_v = aconnector->dsc_settings.dsc_num_slices_v;
 		params[count].bpp_overwrite = aconnector->dsc_settings.dsc_bits_per_pixel;
 		params[count].compression_possible = stream->sink->dsc_caps.dsc_dec_caps.is_dsc_supported;
-		dc_dsc_get_policy_for_timing(params[count].timing, 0, &dsc_policy);
+		dc_dsc_get_policy_for_timing(params[count].timing, 0, &dsc_policy, dc_link_get_highest_encoding_format(stream->link));
 		if (!dc_dsc_compute_bandwidth_range(
 				stream->sink->ctx->dc->res_pool->dscs[0],
 				stream->sink->ctx->dc->debug.dsc_min_slice_height_override,
@@ -1586,7 +1586,7 @@ static bool is_dsc_common_config_possibl
 {
 	struct dc_dsc_policy dsc_policy = {0};
 
-	dc_dsc_get_policy_for_timing(&stream->timing, 0, &dsc_policy);
+	dc_dsc_get_policy_for_timing(&stream->timing, 0, &dsc_policy, dc_link_get_highest_encoding_format(stream->link));
 	dc_dsc_compute_bandwidth_range(stream->sink->ctx->dc->res_pool->dscs[0],
 				       stream->sink->ctx->dc->debug.dsc_min_slice_height_override,
 				       dsc_policy.min_target_bpp * 16,
--- a/drivers/gpu/drm/amd/display/dc/dc_dsc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dsc.h
@@ -100,7 +100,8 @@ uint32_t dc_dsc_stream_bandwidth_overhea
  */
 void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing,
 		uint32_t max_target_bpp_limit_override_x16,
-		struct dc_dsc_policy *policy);
+		struct dc_dsc_policy *policy,
+		const enum dc_link_encoding_format link_encoding);
 
 void dc_dsc_policy_set_max_target_bpp_limit(uint32_t limit);
 
--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -883,7 +883,7 @@ static bool setup_dsc_config(
 
 	memset(dsc_cfg, 0, sizeof(struct dc_dsc_config));
 
-	dc_dsc_get_policy_for_timing(timing, options->max_target_bpp_limit_override_x16, &policy);
+	dc_dsc_get_policy_for_timing(timing, options->max_target_bpp_limit_override_x16, &policy, link_encoding);
 	pic_width = timing->h_addressable + timing->h_border_left + timing->h_border_right;
 	pic_height = timing->v_addressable + timing->v_border_top + timing->v_border_bottom;
 
@@ -1156,7 +1156,8 @@ uint32_t dc_dsc_stream_bandwidth_overhea
 
 void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing,
 		uint32_t max_target_bpp_limit_override_x16,
-		struct dc_dsc_policy *policy)
+		struct dc_dsc_policy *policy,
+		const enum dc_link_encoding_format link_encoding)
 {
 	uint32_t bpc = 0;
 


