Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE05076413;
	Mon,  8 Apr 2024 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582904; cv=none; b=XAvG7RDNCy0u3OO2S2DdUptndlU+TjBM3yo79fhf6crg27Y0Wjulq+bjAHPOJ3LimvEdvpI/XceBr6rtWDG0qWiHeYjA60kueQr1zF85BcYK4ACuajUq9jTpjobkUeBOCFrgcqBgaKuhzSJ/zd+4fbEJgvGH2nCle5sIra1lK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582904; c=relaxed/simple;
	bh=g68e4f0gTDvrUCTPfLJrcSzedP3a9lJTAi41QmDfFR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkMAD4nmDymQYJXhLTXC/ViJjOKpABxFmqlE7nE14GTwQ1bNVSOGU5YCwiIKSR6d5SBms7wY1yz2RcQNIX8lto/uDVCTzYeva6hIdx9YImRaYUuvfbVI8n9ZLXlQMC/51AXm5DZsuKHgUh55MmLeJ4nsKNmJA1uCmssUHK2SFJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ijqLBID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ijqLBID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B49DC433C7;
	Mon,  8 Apr 2024 13:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582903;
	bh=g68e4f0gTDvrUCTPfLJrcSzedP3a9lJTAi41QmDfFR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ijqLBID1EFAjqOVX8AHRP+VUc31O0/8k3hyGv5hi+DEsw7xsuXf3CpuZzfK8hxc0
	 YgW0KWAdZ0Kjm8EpkqwUWRP/no8sUrH/KCqAY7oqyckNWbhCWIPHphv9X0RczF8gnF
	 if1MmzdOZwM0Upo8mxld6qmitNSrgXadBeHkF1x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/252] drm/amd/display: Fix DPSTREAM CLK on and off sequence
Date: Mon,  8 Apr 2024 14:57:13 +0200
Message-ID: <20240408125310.797267043@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit e8d131285c98927554cd007f47cedc4694bfedde ]

[Why]
Secondary DP2 display fails to light up in some instances

[How]
Clock needs to be on when DPSTREAMCLK*_EN =1. This change
moves dtbclk_p enable/disable point to make sure this is
the case

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 72d72e8fddbc ("drm/amd/display: Prevent crash when disable stream")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dce110/dce110_hw_sequencer.c   |  2 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 251dd800a2a66..2ac41c2a7238c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1179,9 +1179,9 @@ void dce110_disable_stream(struct pipe_ctx *pipe_ctx)
 		dto_params.timing = &pipe_ctx->stream->timing;
 		dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;
 		if (dccg) {
-			dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
 			dccg->funcs->set_dpstreamclk(dccg, REFCLK, tg->inst, dp_hpo_inst);
+			dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 		}
 	} else if (dccg && dccg->funcs->disable_symclk_se) {
 		dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 1e3803739ae61..12af2859002f7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2728,18 +2728,17 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
 	}
 
 	if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx)) {
-		dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;
-		dccg->funcs->set_dpstreamclk(dccg, DTBCLK0, tg->inst, dp_hpo_inst);
-
-		phyd32clk = get_phyd32clk_src(link);
-		dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
-
 		dto_params.otg_inst = tg->inst;
 		dto_params.pixclk_khz = pipe_ctx->stream->timing.pix_clk_100hz / 10;
 		dto_params.num_odm_segments = get_odm_segment_count(pipe_ctx);
 		dto_params.timing = &pipe_ctx->stream->timing;
 		dto_params.ref_dtbclk_khz = dc->clk_mgr->funcs->get_dtb_ref_clk_frequency(dc->clk_mgr);
 		dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
+		dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;
+		dccg->funcs->set_dpstreamclk(dccg, DTBCLK0, tg->inst, dp_hpo_inst);
+
+		phyd32clk = get_phyd32clk_src(link);
+		dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
 	} else {
 		}
 	if (hws->funcs.calculate_dccg_k1_k2_values && dc->res_pool->dccg->funcs->set_pixel_rate_div) {
-- 
2.43.0



