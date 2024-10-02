Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C687A1D048E;
	Wed,  2 Oct 2024 14:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880307; cv=none; b=DRGaGpzgsMj6p3RJsLZNbbuC5ovToQIMUuvLH1hsAL7/K95v8zqkvSVlwAMRaDDyLPrgNVIW9vOGjKpT0m6RTazDZzmeNIInD3V5xdY6JrO4v5pWfafMS0uz6SGsqdP+cbNTCR2LuYE50RIaXegr+DCrp8TF6L0gjgq+bHBA2fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880307; c=relaxed/simple;
	bh=1agiDmJHCqQ+X7qTu/c+IWf8H5LKs/xxqgLtNZkTipk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GY2VNDZgNQUGd257o9MvdnCODLiCUcPOXxIDzpeG50lb/HgNTQQ118fCrrps12r8WBeslytCUqM/Wv7/UEr3Nil5OjyKmUenJH6tBba24xVerckBEMWAy5b17Z+JTv63QM22KM5ez/zUnMR1xBluMnJeBrh53fzsIAvaaFsTcbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqP4vzvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqP4vzvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B6EC4CED2;
	Wed,  2 Oct 2024 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880307;
	bh=1agiDmJHCqQ+X7qTu/c+IWf8H5LKs/xxqgLtNZkTipk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqP4vzvA5+IY4MmUjHEm3VggLlc+Pmbnl65RdXI4TzPztny+u8Zaok4jTIzlDKYfh
	 KSdfYJqYQ310gr3n3IBOtk5bCymw/2gEGO+phX2VTTAR8TpnWb5fvdLqI/awInulQl
	 skacBDLqPmg6IJrvEtC/85aoxsuFWo2CLoU0Mr/E=
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
Subject: [PATCH 6.6 415/538] drm/amd/display: Add HDMI DSC native YCbCr422 support
Date: Wed,  2 Oct 2024 15:00:54 +0200
Message-ID: <20241002125808.813886950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -1115,7 +1115,7 @@ static int compute_mst_dsc_configs_for_l
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
@@ -861,7 +861,7 @@ static bool setup_dsc_config(
 
 	memset(dsc_cfg, 0, sizeof(struct dc_dsc_config));
 
-	dc_dsc_get_policy_for_timing(timing, options->max_target_bpp_limit_override_x16, &policy);
+	dc_dsc_get_policy_for_timing(timing, options->max_target_bpp_limit_override_x16, &policy, link_encoding);
 	pic_width = timing->h_addressable + timing->h_border_left + timing->h_border_right;
 	pic_height = timing->v_addressable + timing->v_border_top + timing->v_border_bottom;
 
@@ -1134,7 +1134,8 @@ uint32_t dc_dsc_stream_bandwidth_overhea
 
 void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing,
 		uint32_t max_target_bpp_limit_override_x16,
-		struct dc_dsc_policy *policy)
+		struct dc_dsc_policy *policy,
+		const enum dc_link_encoding_format link_encoding)
 {
 	uint32_t bpc = 0;
 


