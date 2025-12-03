Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B6034DCD6;
	Wed,  3 Dec 2025 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780652; cv=none; b=KHd/edo76SR9ZIaVk9pj3s+spVwc6TIGB0YGou76J4aCm4SkiEYy9NGLn4Pbvka4hUMAralQMw/3T96lrD6S2fXf+rWIWO1T7oRturajhNmWDJMguXBY/b0EWy0ngA2bKl8DBrb//IYvCeFno9TN4P508frrRjqV6G39n8Zs0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780652; c=relaxed/simple;
	bh=ERhu7Z6UnSOgjGom+4pQeL9IcyRsQNG1xyqDOIHEorM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOWrSPA5wCZxPqvooweM4fwXcvZLVPmtLOiixq1Yx45gBMdHdwG6X3Bim8DmVO/42H/Zng24lyls1RK3gz56WzbQ7sIBm4OiX/gnkfAwexEL7QLinqL4FI69PSLQQSHZauuObgSlsNtQGLbsAJa6BBRx8jqbl1HLo5OdZbA74H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgoGg/lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgoGg/lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EF7C4CEF5;
	Wed,  3 Dec 2025 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780652;
	bh=ERhu7Z6UnSOgjGom+4pQeL9IcyRsQNG1xyqDOIHEorM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgoGg/lRYte44+s0ckGV/pC/RWEy0rZtBVY9GU/PxClhhftw0bkMmXzgWTjlQbA8x
	 9QNHVGO17cIvqnBHBFJbgNBO/Inm5EpDKTm/Xv5alSZh8oyeZHCYpR/rIJjwbu+wk7
	 LRj2A4dnuaJ6gf8AaDdIQPNJViF5kBRks0s6KEJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunpeng.Li@amd.com,
	ivan.lipski@amd.com,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 049/132] Revert "drm/amd/display: Move setup_stream_attribute"
Date: Wed,  3 Dec 2025 16:28:48 +0100
Message-ID: <20251203152345.111596485@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 3126c9ccb4373d8758733c6699ba5ab93dbe5c9d upstream.

This reverts commit 2681bf4ae8d24df950138b8c9ea9c271cd62e414.

This results in a blank screen on the HDMI port on some systems.
Revert for now so as not to regress 6.18, can be addressed
in 6.19 once the issue is root caused.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4652
Cc: Sunpeng.Li@amd.com
Cc: ivan.lipski@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d0e9de7a81503cdde37fb2d37f1d102f9e0f38fb)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c       |    1 -
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c         |    2 --
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c       |    2 --
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c                 |    3 +++
 drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c |    7 -------
 5 files changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -670,7 +670,6 @@ void dce110_enable_stream(struct pipe_ct
 	uint32_t early_control = 0;
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 
-	link_hwss->setup_stream_attribute(pipe_ctx);
 	link_hwss->setup_stream_encoder(pipe_ctx);
 
 	dc->hwss.update_info_frame(pipe_ctx);
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3017,8 +3017,6 @@ void dcn20_enable_stream(struct pipe_ctx
 						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
 	}
 
-	link_hwss->setup_stream_attribute(pipe_ctx);
-
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div)
 		dc->res_pool->dccg->funcs->set_pixel_rate_div(
 			dc->res_pool->dccg,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1019,8 +1019,6 @@ void dcn401_enable_stream(struct pipe_ct
 		}
 	}
 
-	link_hwss->setup_stream_attribute(pipe_ctx);
-
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div) {
 		dc->res_pool->dccg->funcs->set_pixel_rate_div(
 			dc->res_pool->dccg,
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -2447,6 +2447,7 @@ void link_set_dpms_on(
 	struct link_encoder *link_enc;
 	enum otg_out_mux_dest otg_out_dest = OUT_MUX_DIO;
 	struct vpg *vpg = pipe_ctx->stream_res.stream_enc->vpg;
+	const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
 	bool apply_edp_fast_boot_optimization =
 		pipe_ctx->stream->apply_edp_fast_boot_optimization;
 
@@ -2489,6 +2490,8 @@ void link_set_dpms_on(
 		pipe_ctx->stream_res.tg->funcs->set_out_mux(pipe_ctx->stream_res.tg, otg_out_dest);
 	}
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
+
 	pipe_ctx->stream->apply_edp_fast_boot_optimization = false;
 
 	// Enable VPG before building infoframe
--- a/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
@@ -44,11 +44,6 @@ static void virtual_stream_encoder_dvi_s
 	struct dc_crtc_timing *crtc_timing,
 	bool is_dual_link) {}
 
-static void virtual_stream_encoder_lvds_set_stream_attribute(
-	struct stream_encoder *enc,
-	struct dc_crtc_timing *crtc_timing)
-{}
-
 static void virtual_stream_encoder_set_throttled_vcp_size(
 	struct stream_encoder *enc,
 	struct fixed31_32 avg_time_slots_per_mtp)
@@ -120,8 +115,6 @@ static const struct stream_encoder_funcs
 		virtual_stream_encoder_hdmi_set_stream_attribute,
 	.dvi_set_stream_attribute =
 		virtual_stream_encoder_dvi_set_stream_attribute,
-	.lvds_set_stream_attribute =
-		virtual_stream_encoder_lvds_set_stream_attribute,
 	.set_throttled_vcp_size =
 		virtual_stream_encoder_set_throttled_vcp_size,
 	.update_hdmi_info_packets =


