Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0C65F56B;
	Tue, 13 Feb 2024 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845532; cv=none; b=u6NPNIVkCSlAyPCPg8bISnLoGAKqImgnb6KBozo7il/kfcRJlcl8hdtcCJFvZy/zD2qQUARkzHdpPwJ85p6sbhGrfB8W+aS9PnpezRmJhnSvg2efK6LsM5K0XLEqIr2nLI/90vd2WwXewoBfUKrXXjDzI2+z0+LBb8k3us734yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845532; c=relaxed/simple;
	bh=3LrP2aTGyvtsW4hq8w1i+Elpy0VQ/ayWkZmmJA9FCxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy6Z0brbjZRlxU3VQNJUn61zRJvqVRR/FHrU4EqvtTt29YNP57pXdw1vUPHGJPj43UHB1Gfo4EkrJbCdkRiUGRttFKo89ouKPmFm+iXGl34qQWSP+b+Hat0ZYRjM6aElXC+IHYX8vcYfHGtKmPaslkhS4Nu89wqGfw2sUMjvX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hU4Ue8cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hU4Ue8cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A03C433C7;
	Tue, 13 Feb 2024 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845531;
	bh=3LrP2aTGyvtsW4hq8w1i+Elpy0VQ/ayWkZmmJA9FCxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU4Ue8cTZRMHZ2UyXoW4exiYgLxXAsWhX2b2ZMo5BUFXYqpvbLYVV3MYpUJEIV9WC
	 szy0HNQkLg3X3IMyWrU5Auf5sE/h37nXMjz5smzke8qWg7rp+Y66jiHVcmgUv1OtNd
	 pWVVSacmklVhw5rF7jJRuSAx+CCb13SvBlxQdXnA=
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
Subject: [PATCH 6.6 077/121] drm/amd/display: Fix panel_cntl could be null in dcn21_set_backlight_level()
Date: Tue, 13 Feb 2024 18:21:26 +0100
Message-ID: <20240213171855.239942870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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
 .../drm/amd/display/dc/dcn21/dcn21_hwseq.c    | 39 ++++++++++---------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
index f99b1bc49694..7238930e6383 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
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



