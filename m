Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24896FB1;
	Tue,  5 Dec 2023 03:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1gHuVCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A91C433C7;
	Tue,  5 Dec 2023 03:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747204;
	bh=kaubL3Dk1MLbvM811/eE6u9Yrev94IpB6XGr5LYGAuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1gHuVCdOSSp6q1mQDg37NiSeZhsnu+fYLj2m+uFvR3UmPCHMBQlf3Iy/2Nd6sz0g
	 05OKNrE7a1cebh43PRNtl7AU0bBOysWiKnMdPsnAhF/5xwbTW5QTFG9LDvrNbBpfRa
	 sk2Q7q1wMXOg/379YEeyR/YOs7nm7YNa1Tmm7jkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/107] drm/amd/display: Expand kernel doc for DC
Date: Tue,  5 Dec 2023 12:17:13 +0900
Message-ID: <20231205031537.867389597@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 1682bd1a6b5fb094e914d9b73b711821fd84dcbd ]

This commit adds extra documentation for elements related to FAMs.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 67e38874b85b ("drm/amd/display: Increase num voltage states to 40")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h           | 19 +++++++++++---
 drivers/gpu/drm/amd/display/dc/dc_stream.h    | 11 ++++++++
 .../gpu/drm/amd/display/dc/dml/dc_features.h  |  7 ++++++
 .../amd/display/dc/dml/display_mode_enums.h   | 25 +++++++++++++++++++
 .../drm/amd/display/dc/dml/display_mode_vba.h |  9 +++++++
 .../gpu/drm/amd/display/dc/inc/core_types.h   |  7 ++++++
 .../gpu/drm/amd/display/dc/inc/hw/hw_shared.h |  7 ++++++
 7 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index f773a467fef54..7e775cec06927 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -499,9 +499,12 @@ enum dcn_zstate_support_state {
 	DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY,
 	DCN_ZSTATE_SUPPORT_DISALLOW,
 };
-/*
- * For any clocks that may differ per pipe
- * only the max is stored in this structure
+
+/**
+ * dc_clocks - DC pipe clocks
+ *
+ * For any clocks that may differ per pipe only the max is stored in this
+ * structure
  */
 struct dc_clocks {
 	int dispclk_khz;
@@ -528,6 +531,16 @@ struct dc_clocks {
 	bool prev_p_state_change_support;
 	bool fclk_prev_p_state_change_support;
 	int num_ways;
+
+	/**
+	 * @fw_based_mclk_switching
+	 *
+	 * DC has a mechanism that leverage the variable refresh rate to switch
+	 * memory clock in cases that we have a large latency to achieve the
+	 * memory clock change and a short vblank window. DC has some
+	 * requirements to enable this feature, and this field describes if the
+	 * system support or not such a feature.
+	 */
 	bool fw_based_mclk_switching;
 	bool fw_based_mclk_switching_shut_down;
 	int prev_num_ways;
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 364ff913527d8..31c6a80c216ff 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -202,7 +202,18 @@ struct dc_stream_state {
 	bool use_vsc_sdp_for_colorimetry;
 	bool ignore_msa_timing_param;
 
+	/**
+	 * @allow_freesync:
+	 *
+	 * It say if Freesync is enabled or not.
+	 */
 	bool allow_freesync;
+
+	/**
+	 * @vrr_active_variable:
+	 *
+	 * It describes if VRR is in use.
+	 */
 	bool vrr_active_variable;
 	bool freesync_on_desktop;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dc_features.h b/drivers/gpu/drm/amd/display/dc/dml/dc_features.h
index 74e86732e3010..2cbdd75429ffd 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dc_features.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dc_features.h
@@ -29,6 +29,13 @@
 #define DC__PRESENT 1
 #define DC__PRESENT__1 1
 #define DC__NUM_DPP 4
+
+/**
+ * @DC__VOLTAGE_STATES:
+ *
+ * Define the maximum amount of states supported by the ASIC. Every ASIC has a
+ * specific number of states; this macro defines the maximum number of states.
+ */
 #define DC__VOLTAGE_STATES 20
 #define DC__NUM_DPP__4 1
 #define DC__NUM_DPP__0_PRESENT 1
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h b/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
index f394b3f3922a8..0bffae95f3a29 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
@@ -105,14 +105,39 @@ enum source_macro_tile_size {
 enum cursor_bpp {
 	dm_cur_2bit = 0, dm_cur_32bit = 1, dm_cur_64bit = 2
 };
+
+/**
+ * @enum clock_change_support - It represents possible reasons to change the DRAM clock.
+ *
+ * DC may change the DRAM clock during its execution, and this enum tracks all
+ * the available methods. Note that every ASIC has their specific way to deal
+ * with these clock switch.
+ */
 enum clock_change_support {
+	/**
+	 * @dm_dram_clock_change_uninitialized: If you see this, we might have
+	 * a code initialization issue
+	 */
 	dm_dram_clock_change_uninitialized = 0,
+
+	/**
+	 * @dm_dram_clock_change_vactive: Support DRAM switch in VActive
+	 */
 	dm_dram_clock_change_vactive,
+
+	/**
+	 * @dm_dram_clock_change_vblank: Support DRAM switch in VBlank
+	 */
 	dm_dram_clock_change_vblank,
+
 	dm_dram_clock_change_vactive_w_mall_full_frame,
 	dm_dram_clock_change_vactive_w_mall_sub_vp,
 	dm_dram_clock_change_vblank_w_mall_full_frame,
 	dm_dram_clock_change_vblank_w_mall_sub_vp,
+
+	/**
+	 * @dm_dram_clock_change_unsupported: Do not support DRAM switch
+	 */
 	dm_dram_clock_change_unsupported
 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
index 2b34b02dbd459..81e53e67cd0b0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
@@ -419,6 +419,15 @@ struct vba_vars_st {
 	double MinPixelChunkSizeBytes;
 	unsigned int DCCMetaBufferSizeBytes;
 	// Pipe/Plane Parameters
+
+	/** @VoltageLevel:
+	 * Every ASIC has a fixed number of DPM states, and some devices might
+	 * have some particular voltage configuration that does not map
+	 * directly to the DPM states. This field tells how many states the
+	 * target device supports; even though this field combines the DPM and
+	 * special SOC voltages, it mostly matches the total number of DPM
+	 * states.
+	 */
 	int VoltageLevel;
 	double FabricClock;
 	double DRAMSpeed;
diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index 5fa7c4772af4f..d2b9e3f83fc3b 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -115,6 +115,13 @@ struct resource_funcs {
 				int vlevel);
 	void (*update_soc_for_wm_a)(
 				struct dc *dc, struct dc_state *context);
+
+	/**
+	 * @populate_dml_pipes - Populate pipe data struct
+	 *
+	 * Returns:
+	 * Total of pipes available in the specific ASIC.
+	 */
 	int (*populate_dml_pipes)(
 		struct dc *dc,
 		struct dc_state *context,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
index cd2be729846b4..a819f0f97c5f3 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
@@ -35,6 +35,13 @@
  ******************************************************************************/
 
 #define MAX_AUDIOS 7
+
+/**
+ * @MAX_PIPES:
+ *
+ * Every ASIC support a fixed number of pipes; MAX_PIPES defines a large number
+ * to be used inside loops and for determining array sizes.
+ */
 #define MAX_PIPES 6
 #define MAX_DIG_LINK_ENCODERS 7
 #define MAX_DWB_PIPES	1
-- 
2.42.0



