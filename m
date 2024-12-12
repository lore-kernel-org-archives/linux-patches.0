Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1F5205ACF;
	Thu, 12 Dec 2024 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017292; cv=none; b=rCwvuHkEo36bt0VW+espw/cxFGeiyCVpdjvJ0IQKcaBdHcE+gs+cSJ50uav+T3G16iFVkq69DzCPZJdKuRr/b8hAxF56dGv6pOcrF3AFXT8oOXz5Ro9A1Xx96mQP7LTsM9Xr27uL95uePqI/SHnRx3BRSHG2Jtvdt16R3TXCOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017292; c=relaxed/simple;
	bh=ITFNZX5uvruFZnyXUocPZ8nKPGKwyYnbOphKnSN3660=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX1dt9v4r8rskibpYO3iDZ/ESeak/uUQDh+lWyYu1sgXMqrsI4Cc/LYmxxSq4Lno2ab0G1Pjk15641A7cvNsAipVrpwS5IhoIlJ41NcPIblSXSoKyIGV9oWW54nPOW7pI9ErC6bSUweF4zVqZuyu+YKopFO/YSjoqPF2Hs2rI2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0wzFWk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0wzFWk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8818CC4CECE;
	Thu, 12 Dec 2024 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017291;
	bh=ITFNZX5uvruFZnyXUocPZ8nKPGKwyYnbOphKnSN3660=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0wzFWk1c6kxNZ4TAbtOZYV8M2M6JcHXEdb5kJWqF5VlyyWM2MTWB7WvTdGjjg/9p
	 pWdekV949284bQxKO55Cke/gqQHiTECu41bUijoGHptplPILnAxQjNShbvEfECe2yV
	 YjNljrGSeFVDZAwLA5nnnP5N6yj/F7CV4ir4cYBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Sung Lee <Sung.Lee@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/466] drm/amd/display: Add option to retrieve detile buffer size
Date: Thu, 12 Dec 2024 16:00:07 +0100
Message-ID: <20241212144324.166621609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Lee <Sung.Lee@amd.com>

[ Upstream commit 6a7fd76b949efe40fb6d6677f480e624e0cb6e40 ]

[WHY]
For better power profiling knowing the detile
buffer size at a given point in time
would be useful.

[HOW]
Add interface to retrieve detile buffer from
dc state.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Sung Lee <Sung.Lee@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c       | 18 ++++++++++++++++++
 drivers/gpu/drm/amd/display/dc/dc.h            |  2 ++
 .../gpu/drm/amd/display/dc/inc/core_types.h    |  1 +
 .../display/dc/resource/dcn31/dcn31_resource.c |  7 +++++++
 .../display/dc/resource/dcn31/dcn31_resource.h |  3 +++
 .../dc/resource/dcn314/dcn314_resource.c       |  1 +
 .../dc/resource/dcn315/dcn315_resource.c       |  1 +
 .../dc/resource/dcn316/dcn316_resource.c       |  1 +
 .../display/dc/resource/dcn35/dcn35_resource.c |  1 +
 .../dc/resource/dcn351/dcn351_resource.c       |  1 +
 10 files changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1d99ab233765f..dbf6724c34777 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -6013,3 +6013,21 @@ struct dc_power_profile dc_get_power_profile_for_dc_state(const struct dc_state
 
 	return profile;
 }
+
+/*
+ **********************************************************************************
+ * dc_get_det_buffer_size_from_state() - extracts detile buffer size from dc state
+ *
+ * Called when DM wants to log detile buffer size from dc_state
+ *
+ **********************************************************************************
+ */
+unsigned int dc_get_det_buffer_size_from_state(const struct dc_state *context)
+{
+	struct dc *dc = context->clk_mgr->ctx->dc;
+
+	if (dc->res_pool->funcs->get_det_buffer_size)
+		return dc->res_pool->funcs->get_det_buffer_size(context);
+	else
+		return 0;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 25385aa09ed5d..7c163aa7e8bd2 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -2544,6 +2544,8 @@ struct dc_power_profile {
 
 struct dc_power_profile dc_get_power_profile_for_dc_state(const struct dc_state *context);
 
+unsigned int dc_get_det_buffer_size_from_state(const struct dc_state *context);
+
 /* DSC Interfaces */
 #include "dc_dsc.h"
 
diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index 8597e866bfe6b..3061dca47dd2f 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -219,6 +219,7 @@ struct resource_funcs {
 	 * Get indicator of power from a context that went through full validation
 	 */
 	int (*get_power_profile)(const struct dc_state *context);
+	unsigned int (*get_det_buffer_size)(const struct dc_state *context);
 };
 
 struct audio_support{
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
index ac8cb20e2e3b6..80386f698ae4d 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -1721,6 +1721,12 @@ int dcn31_populate_dml_pipes_from_context(
 	return pipe_cnt;
 }
 
+unsigned int dcn31_get_det_buffer_size(
+	const struct dc_state *context)
+{
+	return context->bw_ctx.dml.ip.det_buffer_size_kbytes;
+}
+
 void dcn31_calculate_wm_and_dlg(
 		struct dc *dc, struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
@@ -1843,6 +1849,7 @@ static struct resource_funcs dcn31_res_pool_funcs = {
 	.update_bw_bounding_box = dcn31_update_bw_bounding_box,
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn31_get_panel_config_defaults,
+	.get_det_buffer_size = dcn31_get_det_buffer_size,
 };
 
 static struct clock_source *dcn30_clock_source_create(
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h
index 901436591ed45..551ad912f7bea 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h
@@ -63,6 +63,9 @@ struct resource_pool *dcn31_create_resource_pool(
 		const struct dc_init_data *init_data,
 		struct dc *dc);
 
+unsigned int dcn31_get_det_buffer_size(
+	const struct dc_state *context);
+
 /*temp: B0 specific before switch to dcn313 headers*/
 #ifndef regPHYPLLF_PIXCLK_RESYNC_CNTL
 #define regPHYPLLF_PIXCLK_RESYNC_CNTL 0x007e
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
index 169924d0a8393..01d95108ce662 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -1778,6 +1778,7 @@ static struct resource_funcs dcn314_res_pool_funcs = {
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn314_get_panel_config_defaults,
 	.get_preferred_eng_id_dpia = dcn314_get_preferred_eng_id_dpia,
+	.get_det_buffer_size = dcn31_get_det_buffer_size,
 };
 
 static struct clock_source *dcn30_clock_source_create(
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
index f6b840f046a5d..d85356b7fe419 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
@@ -1846,6 +1846,7 @@ static struct resource_funcs dcn315_res_pool_funcs = {
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn315_get_panel_config_defaults,
 	.get_power_profile = dcn315_get_power_profile,
+	.get_det_buffer_size = dcn31_get_det_buffer_size,
 };
 
 static bool dcn315_resource_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
index 5fd52c5fcee45..af82e13029c9e 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
@@ -1720,6 +1720,7 @@ static struct resource_funcs dcn316_res_pool_funcs = {
 	.update_bw_bounding_box = dcn316_update_bw_bounding_box,
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn316_get_panel_config_defaults,
+	.get_det_buffer_size = dcn31_get_det_buffer_size,
 };
 
 static bool dcn316_resource_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index ed3238edaf791..d0c4693c12241 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1779,6 +1779,7 @@ static struct resource_funcs dcn35_res_pool_funcs = {
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn35_get_panel_config_defaults,
 	.get_preferred_eng_id_dpia = dcn35_get_preferred_eng_id_dpia,
+	.get_det_buffer_size = dcn31_get_det_buffer_size,
 };
 
 static bool dcn35_resource_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
index c274861e83c73..575c0aa12229c 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1758,6 +1758,7 @@ static struct resource_funcs dcn351_res_pool_funcs = {
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn35_get_panel_config_defaults,
 	.get_preferred_eng_id_dpia = dcn351_get_preferred_eng_id_dpia,
+	.get_det_buffer_size = dcn31_get_det_buffer_size,
 };
 
 static bool dcn351_resource_construct(
-- 
2.43.0



