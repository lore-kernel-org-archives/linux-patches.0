Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C218E35B;
	Mon, 28 Oct 2024 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098473; cv=none; b=sc4RcZeyP1utaWgjfKSQiJJoid3A6mFB2dgDVa2DcNfoy8M3Og0NNMh3Yt5JI4PgAV5w8bskBNfK8Wl8wL0yqw/f+Y8wCylkSRH1RdYMhpV4HWA9NGAUb4eraykbiWffOjxyAHNKQE4Uv3r4tnK2/JS27eHy3Mm6UohV519Tbag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098473; c=relaxed/simple;
	bh=gmZgAM/+NLnfo0vKmoSyZrUOsi1xqy4uC8R7ZY8RMGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulKDPdY9z3kMRiP4UPm1FDsw5UtqatFNHZHcFRsYeedZNvRPxEzF9F2W+ONF+gX1P0nWmWO7cpmhTrCQHHhwSssFgmkXRDtUnxPgkzmH/ea37q61sHZ1ApN9vKJXzdqBAlSWQx///Sug9ssEQA9OBEb/WW06zVA+ypEYLOtGUFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3ekb/+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3ekb/+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD67C4CEC3;
	Mon, 28 Oct 2024 06:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098473;
	bh=gmZgAM/+NLnfo0vKmoSyZrUOsi1xqy4uC8R7ZY8RMGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3ekb/+jLt/o48Um1LHQfcE68itDVod++5G6zbeJUoiJZQ0c5bN/93V1DBW7ydAHG
	 /6SupNV6cgdcRZtgdSkML92bVj4KpuHiVhibrvE8jiNHy+tb95nGunPhsO4flLXFya
	 G3Hjecyh++vZ4IqERBscsff/nSFGXjJAbPjqtG9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 241/261] drm/amd/display: temp w/a for DP Link Layer compliance
Date: Mon, 28 Oct 2024 07:26:23 +0100
Message-ID: <20241028062318.153333834@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 63feb35cd26557572ad95fc062ede344bb61d9ad upstream.

[Why&How]
Disabling P-State support on full updates for DCN401 results in
introducing additional communication with SMU. A UCLK hard min message
to SMU takes 4 seconds to go through, which was due to DCN not allowing
pstate switch, which was caused by incorrect value for TTU watermark
before blanking the HUBP prior to DPG on for servicing the test request.

Fix the issue temporarily by disallowing pstate changes for compliance
test while test request handler is reworked for a proper fix.

Fixes: 67ea53a4bd9d ("drm/amd/display: Disable DCN401 UCLK P-State support on full updates")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8a79f7cdbb41bb0ddfd4d7662b4428d4a9d5306d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -44,6 +44,7 @@
 
 #include "dm_helpers.h"
 #include "ddc_service_types.h"
+#include "clk_mgr.h"
 
 static u32 edid_extract_panel_id(struct edid *edid)
 {
@@ -1121,6 +1122,8 @@ bool dm_helpers_dp_handle_test_pattern_r
 	struct pipe_ctx *pipe_ctx = NULL;
 	struct amdgpu_dm_connector *aconnector = link->priv;
 	struct drm_device *dev = aconnector->base.dev;
+	struct dc_state *dc_state = ctx->dc->current_state;
+	struct clk_mgr *clk_mgr = ctx->dc->clk_mgr;
 	int i;
 
 	for (i = 0; i < MAX_PIPES; i++) {
@@ -1221,6 +1224,16 @@ bool dm_helpers_dp_handle_test_pattern_r
 	pipe_ctx->stream->test_pattern.type = test_pattern;
 	pipe_ctx->stream->test_pattern.color_space = test_pattern_color_space;
 
+	/* Temp W/A for compliance test failure */
+	dc_state->bw_ctx.bw.dcn.clk.p_state_change_support = false;
+	dc_state->bw_ctx.bw.dcn.clk.dramclk_khz = clk_mgr->dc_mode_softmax_enabled ?
+		clk_mgr->bw_params->dc_mode_softmax_memclk : clk_mgr->bw_params->max_memclk_mhz;
+	dc_state->bw_ctx.bw.dcn.clk.idle_dramclk_khz = dc_state->bw_ctx.bw.dcn.clk.dramclk_khz;
+	ctx->dc->clk_mgr->funcs->update_clocks(
+			ctx->dc->clk_mgr,
+			dc_state,
+			false);
+
 	dc_link_dp_set_test_pattern(
 		(struct dc_link *) link,
 		test_pattern,


