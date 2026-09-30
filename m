Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5360B4FD27B;
	Wed, 30 Sep 2026 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797149; cv=none; b=QfgCEHNi/nmYS81dOwwkUgYMez5FuvUTNi/umilZejtCaxV9ir1gYBUGtn3h/H7S6fBGuNkUXPAqurdFF9QV7POwjUsKeQvgAxGQP9ZpnVIR0XdA73OjbIhoRs7uQ+CE25xuX46CVJQA5KMuofETQy2x+LrUWQoZU2K+AZVj7jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797149; c=relaxed/simple;
	bh=mrA1NMhuESAILtGWCqngaW2HMH8TrCUsULXaLCTNkeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n50NVeKDgnyWhru7t74YwQ5xrbfIOJKIMxU/d+YLy7if989/F0lUA2ziClME5JdN6P6RUCGEPY212h3voalHBDzK87+Z3PL1OTccC8dmUbXG/L9oLkUZG7wXvlEqk0ihBq7gFabI1NP3q4afLsi7vhpvxMEerSqEnW7FIy7BpbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOACCFrb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOACCFrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E151F000FF;
	Wed, 30 Sep 2026 19:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797148;
	bh=D6pQYcHfVZWqZ+JTvFqqUpWgJSnuODFLFrjoGD4KPEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOACCFrbRwCGxt46mZTqVgqUyYNOonabZfxN51aVqYBGasH2EIgJKcxav7GCPKCnQ
	 UbXjlK+6bywgChPirk1VGExWMlkwUNXbCEjAi+gPf6i7BtNHyG3LBBMUKLnYbRzvJW
	 bb/Ex2t0WqzZ3M4kTMC74XGqi5xBgBSRyZc7rwlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1164/1193] drm/amd/display: Validate function returns
Date: Wed, 30 Sep 2026 17:30:48 +0200
Message-ID: <20260930152500.106829370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 673f816b9e1e92d1f70e1bf5f21b531e0ff9ad6c ]

[WHAT & HOW]
Function return values must be checked before data can be used
in subsequent functions.

This fixes 4 CHECKED_RETURN issues reported by Coverity.

[ Backport to 6.6.y: used the older dcn20 path and checked the applicable
  non-OK wait result; the surrounding D3-state case is absent. ]

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c               | 7 +++++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c        | 3 ++-
 .../drm/amd/display/dc/link/protocols/link_dp_training.c   | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 30a79dffbd37a..b3f02f451535a 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -144,7 +144,9 @@ bool dc_dmub_srv_cmd_run_list(struct dc_dmub_srv *dc_dmub_srv, unsigned int coun
 		if (status == DMUB_STATUS_QUEUE_FULL) {
 			/* Execute and wait for queue to become empty again. */
 			dmub_srv_cmd_execute(dmub);
-			dmub_srv_wait_for_idle(dmub, 100000);
+			status = dmub_srv_wait_for_idle(dmub, 100000);
+			if (status != DMUB_STATUS_OK)
+				return false;
 
 			/* Requeue the command. */
 			status = dmub_srv_cmd_queue(dmub, &cmd_list[i]);
@@ -405,7 +407,8 @@ void dc_dmub_srv_get_visual_confirm_color_cmd(struct dc *dc, struct pipe_ctx *pi
 	union dmub_rb_cmd cmd = { 0 };
 	unsigned int panel_inst = 0;
 
-	dc_get_edp_link_panel_inst(dc, pipe_ctx->stream->link, &panel_inst);
+	if (!dc_get_edp_link_panel_inst(dc, pipe_ctx->stream->link, &panel_inst))
+		return;
 
 	memset(&cmd, 0, sizeof(cmd));
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c
index 6eebcb22e3173..2d87e85fdbac5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c
@@ -595,7 +595,8 @@ static bool hubbub2_program_watermarks(
 		hubbub1->base.ctx->dc->clk_mgr->clks.p_state_change_support == false)
 		safe_to_lower = true;
 
-	hubbub1_program_pstate_watermarks(hubbub, watermarks, refclk_mhz, safe_to_lower);
+	if (hubbub1_program_pstate_watermarks(hubbub, watermarks, refclk_mhz, safe_to_lower))
+		wm_pending = true;
 
 	REG_SET(DCHUBBUB_ARB_SAT_LEVEL, 0,
 			DCHUBBUB_ARB_SAT_LEVEL, 60 * refclk_mhz);
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 08c2f11724140..539f57858dfec 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -1683,8 +1683,8 @@ bool perform_link_training_with_retries(
 		if (status == LINK_TRAINING_ABORT) {
 			enum dc_connection_type type = dc_connection_none;
 
-			link_detect_connection_type(link, &type);
-			if (type == dc_connection_none) {
+			if (link_detect_connection_type(link, &type) &&
+			    type == dc_connection_none) {
 				DC_LOG_HW_LINK_TRAINING("%s: Aborting training because sink unplugged\n", __func__);
 				break;
 			}
-- 
2.53.0



