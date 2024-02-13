Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24A35F56B;
	Tue, 13 Feb 2024 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845808; cv=none; b=Yg5dqhK/gYMt4NUF2mbDCkqvvZ+vKQ4QJ9wlmJa3EghFXdH2qGLqYlaNbaXPEVCL6FXTcBQOhnsoPDyD2C8UJ5qxO9Ib7ZI9S32/YOOXxv8NuQzHc6UEI3IcVhZ81P96gAnUVi1ElQRbfxvKF898MyAmmICF632/vhnIFR6/M+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845808; c=relaxed/simple;
	bh=m/b/5mzAHkAT8uQxxTDm3VVj7smfkmmktujzT8GCQVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBkjN7V4p/z416q7FPtHPEVTdz7jp3aktM5tDFGMnnCSq5P0n1QHqGSZUBIedonNpIvzX2FALJKpmlYRPWxxkQUXt4jJk6eQFFFg1B+rF8tewdrQK23WgwIFEHnHSZm1meemq7TFlpSUxIk6kRtA7pYkCGrOnKw/QVaIIFuHDx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVEAVRtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVEAVRtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2D0C433F1;
	Tue, 13 Feb 2024 17:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845807;
	bh=m/b/5mzAHkAT8uQxxTDm3VVj7smfkmmktujzT8GCQVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVEAVRtj37lg5OWtnd/fAtGreWOzKGP+ZSBjYNPlh0izf/AaxqCwZS1RtMq3C5ZQ2
	 7ncIdAVsq8XFG9OeeS4iKhNUINy/W2zDaE59IA23OR9WAysvd97YMd0Ez/G5EFhSry
	 NEegTKcenisj7QQq3lKnCq5DGpnthP05jsTXTPA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <yongqiang.sun@amd.com>,
	Anthony Koo <Anthony.Koo@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 062/124] drm/amd/display: Fix panel_cntl could be null in dcn21_set_backlight_level()
Date: Tue, 13 Feb 2024 18:21:24 +0100
Message-ID: <20240213171855.548369095@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e96fddb32931d007db12b1fce9b5e8e4c080401b ]

'panel_cntl' structure used to control the display panel could be null,
dereferencing it could lead to a null pointer access.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn21/dcn21_hwseq.c:269 dcn21_set_backlight_level() error: we previously assumed 'panel_cntl' could be null (see line 250)

Fixes: 474ac4a875ca ("drm/amd/display: Implement some asic specific abm call backs.")
Cc: Yongqiang Sun <yongqiang.sun@amd.com>
Cc: Anthony Koo <Anthony.Koo@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn21/dcn21_hwseq.c   | 39 ++++++++++---------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c
index 8e88dcaf88f5..a9cd39f77360 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c
@@ -237,34 +237,35 @@ bool dcn21_set_backlight_level(struct pipe_ctx *pipe_ctx,
 {
 	struct dc_context *dc = pipe_ctx->stream->ctx;
 	struct abm *abm = pipe_ctx->stream_res.abm;
+	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 	struct panel_cntl *panel_cntl = pipe_ctx->stream->link->panel_cntl;
+	uint32_t otg_inst;
+
+	if (!abm && !tg && !panel_cntl)
+		return false;
+
+	otg_inst = tg->inst;
 
 	if (dc->dc->res_pool->dmcu) {
 		dce110_set_backlight_level(pipe_ctx, backlight_pwm_u16_16, frame_ramp);
 		return true;
 	}
 
-	if (abm != NULL) {
-		uint32_t otg_inst = pipe_ctx->stream_res.tg->inst;
-
-		if (abm && panel_cntl) {
-			if (abm->funcs && abm->funcs->set_pipe_ex) {
-				abm->funcs->set_pipe_ex(abm,
-						otg_inst,
-						SET_ABM_PIPE_NORMAL,
-						panel_cntl->inst,
-						panel_cntl->pwrseq_inst);
-			} else {
-					dmub_abm_set_pipe(abm,
-							otg_inst,
-							SET_ABM_PIPE_NORMAL,
-							panel_cntl->inst,
-							panel_cntl->pwrseq_inst);
-			}
-		}
+	if (abm->funcs && abm->funcs->set_pipe_ex) {
+		abm->funcs->set_pipe_ex(abm,
+					otg_inst,
+					SET_ABM_PIPE_NORMAL,
+					panel_cntl->inst,
+					panel_cntl->pwrseq_inst);
+	} else {
+		dmub_abm_set_pipe(abm,
+				  otg_inst,
+				  SET_ABM_PIPE_NORMAL,
+				  panel_cntl->inst,
+				  panel_cntl->pwrseq_inst);
 	}
 
-	if (abm && abm->funcs && abm->funcs->set_backlight_level_pwm)
+	if (abm->funcs && abm->funcs->set_backlight_level_pwm)
 		abm->funcs->set_backlight_level_pwm(abm, backlight_pwm_u16_16,
 			frame_ramp, 0, panel_cntl->inst);
 	else
-- 
2.43.0



