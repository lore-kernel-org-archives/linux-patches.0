Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06E314534A;
	Tue, 27 Feb 2024 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040727; cv=none; b=O4obiE5R+z5I7Tv3dZqN5q8Ck7XJnCOPLdhk+SGJZYVhkOM10miysC9y4gdyXAnh4aCvWXTlZ/GIvxdccz2GzSYD5KCOrOPx3gxUXsaVXhXvEkXp3N10pYO+7ZRN8RBtVzAh9HoSwdnE3aMFS0t6TQT0/3TZcyLGjJ72Yr47iDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040727; c=relaxed/simple;
	bh=hwKUeUiVpqA04NtPI2fMgWLefB80qVuVBFmoCq4KDCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPlUpl69Sb4yhSGd3RE9qD5mjMyQX4rY0zA1eeN0e6l5T/IG5b2DSjL4+Kz6fKY+obzgZL0V08VkFKpALZE6s86QG22i6rt3sXvzEJVGcP+Q80dPG07JRVFRVbODL4qJg+QHxwlAAZk5hzEwdoI2pOnN62dXRl7rkubL1IhmBCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r39QblKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r39QblKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E1FC433F1;
	Tue, 27 Feb 2024 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040727;
	bh=hwKUeUiVpqA04NtPI2fMgWLefB80qVuVBFmoCq4KDCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r39QblKS16nN19ZH2CGg1J/W86JEvTNy3uwH4FdR7oE/zGmHC4GSfOHGxpjvu/ogv
	 xrut3N8xEIXwhgIkFAhhMt9Wazvbuab9VTA35eW6GC3BcD2ZHQfECPWp1y5cPoe0XN
	 sKUglFIdw6TC9v1hVAzD+vIyRUrOLSjgkpsy5at8=
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
Subject: [PATCH 6.7 059/334] drm/amd/display: Fix DPSTREAM CLK on and off sequence
Date: Tue, 27 Feb 2024 14:18:37 +0100
Message-ID: <20240227131632.478228618@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit 31c2bf25eaf51c2d45f092284a28e97f43b54c15 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |  2 +-
 .../gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 9fedf99475695..c1f1665e553d6 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1182,9 +1182,9 @@ void dce110_disable_stream(struct pipe_ctx *pipe_ctx)
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
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index da0181fef411f..c966f38583cb9 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -2776,18 +2776,17 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
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
 		if (dccg->funcs->enable_symclk_se)
 			dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
-- 
2.43.0



