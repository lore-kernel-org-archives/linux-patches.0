Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13455F54E;
	Tue, 13 Feb 2024 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845535; cv=none; b=r5mV/l4Nx1yGLoQs6K1BbdNm57wd83jUEW4CwHK5czJu1ECk81L2finBPQQwASyL+IyQCYyXR8+PHnLGCsWE2zvr546NwVazpDosZcKdSUVvKzCzqBfCliRx/PdVzOuyMEzXoof4lFgayY8mM5EokSQBFhroknMN5BsoamqTyyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845535; c=relaxed/simple;
	bh=EbWAPEy4ekzfZ9MuNLLJCnRfzWs1dREZF4n7E0btWyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NITNHYmWLzcSAFCJE1Z7RgLP9FsNnP1PwpvQju+kvtspZKCLeqw2QNZ5OXmhuP8pstgWoK63Cwcm2IfpMXUS5sCmhZ1F9TAhnZ9tPjeYeZYDcMOhBd95G/NBWUoyDvpbW2EQG1bDHi2IRUWmp0oK7sDqJEdrFYzgR914yB2XB0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SGwWDgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SGwWDgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B815EC433F1;
	Tue, 13 Feb 2024 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845535;
	bh=EbWAPEy4ekzfZ9MuNLLJCnRfzWs1dREZF4n7E0btWyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SGwWDgEstj2x0J6kzx9ZPKm2Q9EJb1UHamsc0Wrvc/bIJ4891nZcYXo9idacI1BE
	 9X7fqS2KeFGO8dXMGrHJsbm8Q7Q9IXXmsIahaonEPLlZliTcMiY0XG2Oo9SNBM8t5Y
	 lAenGFQeFR6dN8qlVvOKc8kEibkRLbOPQAXJIuOQ=
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
Subject: [PATCH 6.6 078/121] drm/amd/display: Add NULL test for timing generator in dcn21_set_pipe()
Date: Tue, 13 Feb 2024 18:21:27 +0100
Message-ID: <20240213171855.268962975@linuxfoundation.org>
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

[ Upstream commit 66951d98d9bf45ba25acf37fe0747253fafdf298 ]

In "u32 otg_inst = pipe_ctx->stream_res.tg->inst;"
pipe_ctx->stream_res.tg could be NULL, it is relying on the caller to
ensure the tg is not NULL.

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
 .../drm/amd/display/dc/dcn21/dcn21_hwseq.c    | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
index 7238930e6383..1b08749b084b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
@@ -206,28 +206,32 @@ void dcn21_set_abm_immediate_disable(struct pipe_ctx *pipe_ctx)
 void dcn21_set_pipe(struct pipe_ctx *pipe_ctx)
 {
 	struct abm *abm = pipe_ctx->stream_res.abm;
-	uint32_t otg_inst = pipe_ctx->stream_res.tg->inst;
+	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 	struct panel_cntl *panel_cntl = pipe_ctx->stream->link->panel_cntl;
 	struct dmcu *dmcu = pipe_ctx->stream->ctx->dc->res_pool->dmcu;
+	uint32_t otg_inst;
+
+	if (!abm && !tg && !panel_cntl)
+		return;
+
+	otg_inst = tg->inst;
 
 	if (dmcu) {
 		dce110_set_pipe(pipe_ctx);
 		return;
 	}
 
-	if (abm && panel_cntl) {
-		if (abm->funcs && abm->funcs->set_pipe_ex) {
-			abm->funcs->set_pipe_ex(abm,
+	if (abm->funcs && abm->funcs->set_pipe_ex) {
+		abm->funcs->set_pipe_ex(abm,
 					otg_inst,
 					SET_ABM_PIPE_NORMAL,
 					panel_cntl->inst,
 					panel_cntl->pwrseq_inst);
-		} else {
-				dmub_abm_set_pipe(abm, otg_inst,
-						SET_ABM_PIPE_NORMAL,
-						panel_cntl->inst,
-						panel_cntl->pwrseq_inst);
-		}
+	} else {
+		dmub_abm_set_pipe(abm, otg_inst,
+				  SET_ABM_PIPE_NORMAL,
+				  panel_cntl->inst,
+				  panel_cntl->pwrseq_inst);
 	}
 }
 
-- 
2.43.0



