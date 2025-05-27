Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E561DC998;
	Tue, 27 May 2025 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367754; cv=none; b=ESwqE7XFbjz25mAnYSJkfwVv7qfeVWVILW6UJ+2Bp45Jq0Mx5ExU/RuWI7sNlwNwULZ/Bca8bO9m7/PuST9HQu+wVQI9MmtTqah/iKMf1GxiHcRu8UFlI1fZUbDiK9L7cTjVsHJr92ZmTxO1FQ48CXcXwY79G3dta4oX3M33GRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367754; c=relaxed/simple;
	bh=9UFhGC7FyamqBpY2m2msXmERQne4DwSNsdr7rVb3UXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX+DRROuwrZax1Pug9iuiap0Y/oYf7gEfIEhqxIQjFUpIzIrOJRkOwYuiGLlR12iPQJQcYL5POwaCN2zppJlGmC4apCAiYmM8tl53n99qXskXEmA1llBRmWZplVGP4NsDchsZYhh+9TO9hXxo+6HEaZwqZol5VCFcw/JM4nUtEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N60UsE0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N60UsE0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52063C4CEE9;
	Tue, 27 May 2025 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367753;
	bh=9UFhGC7FyamqBpY2m2msXmERQne4DwSNsdr7rVb3UXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N60UsE0MGxUx3A+fQHj1XCk8NR2ykew7dFbLYP7KYVJa6DijxzXK6ughEUhKHwYWl
	 8aABezozfA/mh/LjL7IfSMifFS2ueW/iLhq6esuiA3DMR6IAMGBG/hl96ksnml8YuV
	 ZXC5kNwN9m2uWmxdSKmZVNlCpNJ5GgfqPcFP5WlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 489/783] drm/amd/display: Ammend DCPG IP control sequences to align with HW guidance
Date: Tue, 27 May 2025 18:24:46 +0200
Message-ID: <20250527162533.045545382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit cbd97d621ece1d92c3542e52f8af7c04cd2c6afb ]

[WHY&HOW]
IP_REQUEST_CNTL should only be toggled off when it was originally, never
unconditionally.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 14 +++++---
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 34 +++++++++++++++++++
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.h |  3 ++
 .../amd/display/dc/hwss/dcn401/dcn401_init.c  |  2 +-
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index f7e31aec32058..1a07973ead4f5 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1264,14 +1264,18 @@ static void dcn20_power_on_plane_resources(
 	struct dce_hwseq *hws,
 	struct pipe_ctx *pipe_ctx)
 {
+	uint32_t org_ip_request_cntl = 0;
+
 	DC_LOGGER_INIT(hws->ctx->logger);
 
 	if (hws->funcs.dpp_root_clock_control)
 		hws->funcs.dpp_root_clock_control(hws, pipe_ctx->plane_res.dpp->inst, true);
 
 	if (REG(DC_IP_REQUEST_CNTL)) {
-		REG_SET(DC_IP_REQUEST_CNTL, 0,
-				IP_REQUEST_EN, 1);
+		REG_GET(DC_IP_REQUEST_CNTL, IP_REQUEST_EN, &org_ip_request_cntl);
+		if (org_ip_request_cntl == 0)
+			REG_SET(DC_IP_REQUEST_CNTL, 0,
+					IP_REQUEST_EN, 1);
 
 		if (hws->funcs.dpp_pg_control)
 			hws->funcs.dpp_pg_control(hws, pipe_ctx->plane_res.dpp->inst, true);
@@ -1279,8 +1283,10 @@ static void dcn20_power_on_plane_resources(
 		if (hws->funcs.hubp_pg_control)
 			hws->funcs.hubp_pg_control(hws, pipe_ctx->plane_res.hubp->inst, true);
 
-		REG_SET(DC_IP_REQUEST_CNTL, 0,
-				IP_REQUEST_EN, 0);
+		if (org_ip_request_cntl == 0)
+			REG_SET(DC_IP_REQUEST_CNTL, 0,
+					IP_REQUEST_EN, 0);
+
 		DC_LOG_DEBUG(
 				"Un-gated front end for pipe %d\n", pipe_ctx->plane_res.hubp->inst);
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 284f011f5643d..a6f2aff84267d 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -2655,3 +2655,37 @@ void dcn401_detect_pipe_changes(struct dc_state *old_state,
 		new_pipe->update_flags.bits.test_pattern_changed = 1;
 	}
 }
+
+void dcn401_plane_atomic_power_down(struct dc *dc,
+		struct dpp *dpp,
+		struct hubp *hubp)
+{
+	struct dce_hwseq *hws = dc->hwseq;
+	uint32_t org_ip_request_cntl = 0;
+
+	DC_LOGGER_INIT(dc->ctx->logger);
+
+	REG_GET(DC_IP_REQUEST_CNTL, IP_REQUEST_EN, &org_ip_request_cntl);
+	if (org_ip_request_cntl == 0)
+		REG_SET(DC_IP_REQUEST_CNTL, 0,
+			IP_REQUEST_EN, 1);
+
+	if (hws->funcs.dpp_pg_control)
+		hws->funcs.dpp_pg_control(hws, dpp->inst, false);
+
+	if (hws->funcs.hubp_pg_control)
+		hws->funcs.hubp_pg_control(hws, hubp->inst, false);
+
+	hubp->funcs->hubp_reset(hubp);
+	dpp->funcs->dpp_reset(dpp);
+
+	if (org_ip_request_cntl == 0)
+		REG_SET(DC_IP_REQUEST_CNTL, 0,
+			IP_REQUEST_EN, 0);
+
+	DC_LOG_DEBUG(
+			"Power gated front end %d\n", hubp->inst);
+
+	if (hws->funcs.dpp_root_clock_control)
+		hws->funcs.dpp_root_clock_control(hws, dpp->inst, false);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
index 17cea748789e1..dbd69d215b8bc 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
@@ -102,4 +102,7 @@ void dcn401_detect_pipe_changes(
 	struct dc_state *new_state,
 	struct pipe_ctx *old_pipe,
 	struct pipe_ctx *new_pipe);
+void dcn401_plane_atomic_power_down(struct dc *dc,
+		struct dpp *dpp,
+		struct hubp *hubp);
 #endif /* __DC_HWSS_DCN401_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
index 44cb376f97c17..a4e3501fadbbe 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
@@ -123,7 +123,7 @@ static const struct hwseq_private_funcs dcn401_private_funcs = {
 	.disable_vga = dcn20_disable_vga,
 	.bios_golden_init = dcn10_bios_golden_init,
 	.plane_atomic_disable = dcn20_plane_atomic_disable,
-	.plane_atomic_power_down = dcn10_plane_atomic_power_down,
+	.plane_atomic_power_down = dcn401_plane_atomic_power_down,
 	.enable_power_gating_plane = dcn32_enable_power_gating_plane,
 	.hubp_pg_control = dcn32_hubp_pg_control,
 	.program_all_writeback_pipes_in_tree = dcn30_program_all_writeback_pipes_in_tree,
-- 
2.39.5



