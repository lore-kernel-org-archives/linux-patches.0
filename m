Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888042EE99C;
	Thu,  3 Jul 2025 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555305; cv=none; b=FNG71hEydOfHPCIPLBYyRbTN77gOKHSk88Xtmrose3cutuEfAERpNT8mySJorTNdxLoUZgEmArcQ8JwGMRe/KihH44+hbM1Op/Pi1PslReV7lUGfOd0Xj1S5qCAVLgzn7oZq17NDBIhyeG7If9HkfTH10h6Lyg7PIFt1bpujarg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555305; c=relaxed/simple;
	bh=+KfMDHUlOiJyFFc3Xa1Eb4UKlz5xucRAJVyMquro7I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjbyWyRE2uNIuFAcoqLCrwy3qOjMEv24b0+6+rl8YMUtHeYWMCgyNDswCLv8iB8n5S5iMigjz8DQ5B2ImBtrcIA8I3cnTLWqsWnqKc+oHwuDr0Pnq9WnDjU25QC0SMUQZvEdN8/9sw4KNFOLbzVg516wE2mJFbcl+4RrKygyYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO7he9l4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO7he9l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB18BC4CEF2;
	Thu,  3 Jul 2025 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555305;
	bh=+KfMDHUlOiJyFFc3Xa1Eb4UKlz5xucRAJVyMquro7I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO7he9l4S4m7Ymg1jXp0WSgZF/jC52eCkZN5SSM0F0Pt4N3TZBRIC8Wz1OR0dI2/i
	 34aSbPpsKapc5trVVYLS/PByK0GsN0Lbs22aAINc6dpYhQQij6/JKoIV58w6dBa69M
	 fD5at/OwmqQX353OeszFI0R3Na/d7ngsXOy092zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Cruise Hung <cruise.hung@amd.com>,
	Peichen Huang <PeiChen.Huang@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.15 238/263] drm/amd/display: Add dc cap for dp tunneling
Date: Thu,  3 Jul 2025 16:42:38 +0200
Message-ID: <20250703144013.950995750@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peichen Huang <PeiChen.Huang@amd.com>

commit 3251b69b7efb82eba24c9e168a6142a3078de72f upstream.

[WHAT]
1. add dc cap for dp tunneling
2. add function to get index of host router

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Cruise Hung <cruise.hung@amd.com>
Signed-off-by: Peichen Huang <PeiChen.Huang@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 29e178d13979cf6fdb42c5fe2dfec2da2306c4ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c                         |   33 ++++++++++
 drivers/gpu/drm/amd/display/dc/dc.h                              |    8 ++
 drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c   |    3 
 drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c |    3 
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c   |    3 
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c |    3 
 drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c   |    3 
 7 files changed, 55 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -239,6 +239,7 @@ static bool create_links(
 	DC_LOG_DC("BIOS object table - end");
 
 	/* Create a link for each usb4 dpia port */
+	dc->lowest_dpia_link_index = MAX_LINKS;
 	for (i = 0; i < dc->res_pool->usb4_dpia_count; i++) {
 		struct link_init_data link_init_params = {0};
 		struct dc_link *link;
@@ -251,6 +252,9 @@ static bool create_links(
 
 		link = dc->link_srv->create_link(&link_init_params);
 		if (link) {
+			if (dc->lowest_dpia_link_index > dc->link_count)
+				dc->lowest_dpia_link_index = dc->link_count;
+
 			dc->links[dc->link_count] = link;
 			link->dc = dc;
 			++dc->link_count;
@@ -6247,6 +6251,35 @@ struct dc_power_profile dc_get_power_pro
 		profile.power_level = dc->res_pool->funcs->get_power_profile(context);
 	return profile;
 }
+/**
+ ***********************************************************************************************
+ * dc_get_host_router_index: Get index of host router from a dpia link
+ *
+ * This function return a host router index of the target link. If the target link is dpia link.
+ *
+ * @param [in] link: target link
+ * @param [out] host_router_index: host router index of the target link
+ *
+ * @return: true if the host router index is found and valid.
+ *
+ ***********************************************************************************************
+ */
+bool dc_get_host_router_index(const struct dc_link *link, unsigned int *host_router_index)
+{
+	struct dc *dc = link->ctx->dc;
+
+	if (link->ep_type != DISPLAY_ENDPOINT_USB4_DPIA)
+		return false;
+
+	if (link->link_index < dc->lowest_dpia_link_index)
+		return false;
+
+	*host_router_index = (link->link_index - dc->lowest_dpia_link_index) / dc->caps.num_of_dpias_per_host_router;
+	if (*host_router_index < dc->caps.num_of_host_routers)
+		return true;
+	else
+		return false;
+}
 
 /*
  **********************************************************************************
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -66,7 +66,8 @@ struct dmub_notification;
 #define MAX_STREAMS 6
 #define MIN_VIEWPORT_SIZE 12
 #define MAX_NUM_EDP 2
-#define MAX_HOST_ROUTERS_NUM 2
+#define MAX_HOST_ROUTERS_NUM 3
+#define MAX_DPIA_PER_HOST_ROUTER 2
 
 /* Display Core Interfaces */
 struct dc_versions {
@@ -303,6 +304,8 @@ struct dc_caps {
 	/* Conservative limit for DCC cases which require ODM4:1 to support*/
 	uint32_t dcc_plane_width_limit;
 	struct dc_scl_caps scl_caps;
+	uint8_t num_of_host_routers;
+	uint8_t num_of_dpias_per_host_router;
 };
 
 struct dc_bug_wa {
@@ -1431,6 +1434,7 @@ struct dc {
 
 	uint8_t link_count;
 	struct dc_link *links[MAX_LINKS];
+	uint8_t lowest_dpia_link_index;
 	struct link_service *link_srv;
 
 	struct dc_state *current_state;
@@ -2586,6 +2590,8 @@ struct dc_power_profile dc_get_power_pro
 
 unsigned int dc_get_det_buffer_size_from_state(const struct dc_state *context);
 
+bool dc_get_host_router_index(const struct dc_link *link, unsigned int *host_router_index);
+
 /* DSC Interfaces */
 #include "dc_dsc.h"
 
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -1954,6 +1954,9 @@ static bool dcn31_resource_construct(
 	dc->caps.color.mpc.ogam_rom_caps.hlg = 0;
 	dc->caps.color.mpc.ocsc = 1;
 
+	dc->caps.num_of_host_routers = 2;
+	dc->caps.num_of_dpias_per_host_router = 2;
+
 	/* Use pipe context based otg sync logic */
 	dc->config.use_pipe_ctx_sync_logic = true;
 	dc->config.disable_hbr_audio_dp2 = true;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -1885,6 +1885,9 @@ static bool dcn314_resource_construct(
 
 	dc->caps.max_disp_clock_khz_at_vmin = 650000;
 
+	dc->caps.num_of_host_routers = 2;
+	dc->caps.num_of_dpias_per_host_router = 2;
+
 	/* Use pipe context based otg sync logic */
 	dc->config.use_pipe_ctx_sync_logic = true;
 
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1894,6 +1894,9 @@ static bool dcn35_resource_construct(
 	dc->caps.color.mpc.ogam_rom_caps.hlg = 0;
 	dc->caps.color.mpc.ocsc = 1;
 
+	dc->caps.num_of_host_routers = 2;
+	dc->caps.num_of_dpias_per_host_router = 2;
+
 	/* max_disp_clock_khz_at_vmin is slightly lower than the STA value in order
 	 * to provide some margin.
 	 * It's expected for furture ASIC to have equal or higher value, in order to
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1866,6 +1866,9 @@ static bool dcn351_resource_construct(
 	dc->caps.color.mpc.ogam_rom_caps.hlg = 0;
 	dc->caps.color.mpc.ocsc = 1;
 
+	dc->caps.num_of_host_routers = 2;
+	dc->caps.num_of_dpias_per_host_router = 2;
+
 	/* max_disp_clock_khz_at_vmin is slightly lower than the STA value in order
 	 * to provide some margin.
 	 * It's expected for furture ASIC to have equal or higher value, in order to
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c
@@ -1867,6 +1867,9 @@ static bool dcn36_resource_construct(
 	dc->caps.color.mpc.ogam_rom_caps.hlg = 0;
 	dc->caps.color.mpc.ocsc = 1;
 
+	dc->caps.num_of_host_routers = 2;
+	dc->caps.num_of_dpias_per_host_router = 2;
+
 	/* max_disp_clock_khz_at_vmin is slightly lower than the STA value in order
 	 * to provide some margin.
 	 * It's expected for furture ASIC to have equal or higher value, in order to


