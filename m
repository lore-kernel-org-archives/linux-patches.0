Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831207;
	b=ThxI5aAtimhxeXDcku9J1tN/RYNd/aCzH+vMXC6uVDY3CgLoJJLYXbk8KN3gfXF8Ykf5
	 HYI3upT7OhL2IWJGhjNcN4vWIJSJ8Zz1PqDZgsS7AGmAOYN02ydoB0UpRkxoTZt7dfk/P
	 5bK5Hgv5ICGM36kAZd01AKd8bZQ6KdJi/FFpqNci4KYAU++EgNuXNvOfOsgToF2+IqbYB
	 VoZ4sF1sOBeI8Y2Ma8F6LhzjHLhWb5+2JyhctXQ9QJoGiBljMzjtk2RDftKgB0xlGoDpn
	 HyAmPQ5YoRcR2mabi15kXNZhBe1YOsV9FOkQpiO3IX/C1zsbFgeWqWnSYt69LV/lgTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBU5MdRxxBbSX+HKB5F0+Fn2f+4p7OMVWxaW7VAptQw=;
	b=ScTYLUJxY5wdR4KFYG6jZJIlmTcIRmhKgtabVpySUt6qk5id/aMkdUO9OXLtZkItbPsR
	 P8/eXM12HP4FbaB7gk9Y3Ot3+kw+7pUYMoQo18BDfeOmMz63Tt8upZ7nJlZK5TKCBz194
	 w3LxZpmwtAHp6p2/wS7PtLoSXW3WRyEjt+OuN3y6pDRrVPrQKMbidevXGzHDRqXoEu12a
	 kj7Q6O736oZMthTPkBnlBC3w3ulkTpqvdt8vS4s8NtgLUsPK12cvG3Al/HR1cgu/lMc1O
	 UPFA2MXyjHhqCHUHFBHlGqtgEY/fkOk7vHjSORuGFKM1BgqWfi+PHmsDeJazdRS/CCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zG2/zS9j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D2606A873;
	Wed,  4 Nov 2026 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zG2/zS9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E736F1F00919;
	Wed,  4 Nov 2026 22:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831207;
	bh=iBU5MdRxxBbSX+HKB5F0+Fn2f+4p7OMVWxaW7VAptQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zG2/zS9jNvGqbeTMTAezK5/8vfceg32WUIAC8DCltnfg0lgL2cxg7Cy1XYGk1c+u3
	 2Jo09u9ecdJQXEs5vd+IXrKZFpOA+3N2waPqs407n/dsgR/G85TbOt3NkDxdpf/JgR
	 8u7S2oSMT6QvGGOPLIlwnbtRTfGD/1EYCrSBKB7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0565/1005] drm/amd/display: Update P-state naming for clarity.
Date: Wed,  4 Nov 2026 16:04:58 -0500
Message-ID: <20261104211059.708453037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit e44ee152a5ea8ee1b5f5440a754a9fd17639f230 ]

[Why & How]
P-state can refer to different things like UCLK P-state, PPT, or temp read
Update naming for clarity

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 93a77d353cb2 ("drm/amd/display: Remove const Qualifier From Non-Pointer Fields")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c |  2 +-
 .../src/dml2_core/dml2_core_shared_types.h     | 18 ++++++++++++------
 .../dml2/dml21/src/dml2_core/dml2_core_utils.c |  2 ++
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index 7ff30870aa601..d2a237fcf5b08 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -13023,7 +13023,7 @@ void dml2_core_calcs_get_informative(const struct dml2_core_internal_display_mod
 	out->informative.mode_support_info.InvalidCombinationOfMALLUseForPState = mode_lib->ms.support.InvalidCombinationOfMALLUseForPState;
 	out->informative.mode_support_info.ExceededMALLSize = mode_lib->ms.support.ExceededMALLSize;
 	out->informative.mode_support_info.EnoughWritebackUnits = mode_lib->ms.support.EnoughWritebackUnits;
-	out->informative.mode_support_info.temp_read_or_ppt_support = mode_lib->ms.support.temp_read_or_ppt_support;
+	out->informative.mode_support_info.temp_read_or_ppt_support = mode_lib->ms.support.global_temp_read_or_ppt_supported;
 	out->informative.mode_support_info.g6_temp_read_support = mode_lib->ms.support.g6_temp_read_support;
 
 	out->informative.mode_support_info.ExceededMultistreamSlots = mode_lib->ms.support.ExceededMultistreamSlots;
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
index ff1c47347610a..c09be5652f46f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
@@ -263,8 +263,11 @@ struct dml2_core_internal_mode_support_info {
 	bool DCCMetaBufferSizeNotExceeded;
 	enum dml2_pstate_change_support DRAMClockChangeSupport[DML2_MAX_PLANES];
 	enum dml2_pstate_change_support FCLKChangeSupport[DML2_MAX_PLANES];
+	enum dml2_pstate_change_support temp_read_or_ppt_support[DML2_MAX_PLANES];
+	bool global_dram_clock_change_support_required;
 	bool global_dram_clock_change_supported;
 	bool global_fclk_change_supported;
+	bool global_temp_read_or_ppt_supported;
 	bool USRRetrainingSupport;
 	bool AvgBandwidthSupport;
 	bool UrgVactiveBandwidthSupport;
@@ -335,7 +338,6 @@ struct dml2_core_internal_mode_support_info {
 	bool incorrect_imall_usage;
 
 	bool g6_temp_read_support;
-	bool temp_read_or_ppt_support;
 
 	struct dml2_core_internal_watermarks watermarks;
 	bool dcfclk_support;
@@ -643,7 +645,7 @@ struct dml2_core_internal_mode_support {
 	unsigned int DSTYAfterScaler[DML2_MAX_PLANES];
 	unsigned int DSTXAfterScaler[DML2_MAX_PLANES];
 
-	enum dml2_pstate_method pstate_switch_modes[DML2_MAX_PLANES];
+	enum dml2_pstate_method uclk_pstate_switch_modes[DML2_MAX_PLANES];
 };
 
 /// @brief A mega structure that houses various info for model programming step.
@@ -834,6 +836,7 @@ struct dml2_core_internal_mode_program {
 	double max_urgent_latency_us;
 	double df_response_time_us;
 
+	enum dml2_pstate_method uclk_pstate_switch_modes[DML2_MAX_PLANES];
 	// -------------------
 	// Output
 	// -------------------
@@ -960,11 +963,12 @@ struct dml2_core_internal_mode_program {
 	double MaxActiveFCLKChangeLatencySupported;
 	bool USRRetrainingSupport;
 	bool g6_temp_read_support;
-	bool temp_read_or_ppt_support;
 	enum dml2_pstate_change_support FCLKChangeSupport[DML2_MAX_PLANES];
 	enum dml2_pstate_change_support DRAMClockChangeSupport[DML2_MAX_PLANES];
+	enum dml2_pstate_change_support temp_read_or_ppt_support[DML2_MAX_PLANES];
 	bool global_dram_clock_change_supported;
 	bool global_fclk_change_supported;
+	bool global_temp_read_or_ppt_supported;
 	double MaxActiveDRAMClockChangeLatencySupported[DML2_MAX_PLANES];
 	double WritebackAllowFCLKChangeEndPosition[DML2_MAX_PLANES];
 	double WritebackAllowDRAMClockChangeEndPosition[DML2_MAX_PLANES];
@@ -1310,7 +1314,7 @@ struct dml2_core_calcs_CalculateVMRowAndSwath_params {
 	unsigned int HostVMMinPageSize;
 	unsigned int DCCMetaBufferSizeBytes;
 	bool mrq_present;
-	enum dml2_pstate_method *pstate_switch_modes;
+	enum dml2_pstate_method *uclk_pstate_switch_modes;
 
 	// Output
 	bool *PTEBufferSizeNotExceeded;
@@ -1737,10 +1741,12 @@ struct dml2_core_calcs_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport_param
 	unsigned int max_request_size_bytes;
 	unsigned int *meta_row_height_l;
 	unsigned int *meta_row_height_c;
+	enum dml2_pstate_method *uclk_pstate_switch_modes;
 
 	// Output
 	struct dml2_core_internal_watermarks *Watermark;
 	enum dml2_pstate_change_support *DRAMClockChangeSupport;
+	bool *global_dram_clock_change_support_required;
 	bool *global_dram_clock_change_supported;
 	double *MaxActiveDRAMClockChangeLatencySupported;
 	unsigned int *SubViewportLinesNeededInMALL;
@@ -1751,10 +1757,10 @@ struct dml2_core_calcs_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport_param
 	double *VActiveLatencyHidingMargin;
 	double *VActiveLatencyHidingUs;
 	bool *g6_temp_read_support;
-	bool *temp_read_or_ppt_support;
+	enum dml2_pstate_change_support *temp_read_or_ppt_support;
+	bool *global_temp_read_or_ppt_supported;
 };
 
-
 struct dml2_core_calcs_CalculateSwathAndDETConfiguration_params {
 	const struct dml2_display_cfg *display_cfg;
 	unsigned int ConfigReturnBufferSizeInKByte;
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_utils.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_utils.c
index 5f301befed167..b57d0f6ea6a1c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_utils.c
@@ -306,6 +306,8 @@ void dml2_core_utils_print_mode_support_info(const struct dml2_core_internal_mod
 		DML_LOG_VERBOSE("DML: support: ExceededMALLSize = %d\n", support->ExceededMALLSize);
 	if (!fail_only || support->g6_temp_read_support == 0)
 		DML_LOG_VERBOSE("DML: support: g6_temp_read_support = %d\n", support->g6_temp_read_support);
+	if (!fail_only || (support->global_dram_clock_change_supported == 0 && support->global_dram_clock_change_support_required))
+		DML_LOG_VERBOSE("DML: support: dram_clock_change_support = %d\n", support->global_dram_clock_change_supported);
 	if (!fail_only || support->ImmediateFlipSupport == 0)
 		DML_LOG_VERBOSE("DML: support: ImmediateFlipSupport = %d\n", support->ImmediateFlipSupport);
 	if (!fail_only || support->LinkCapacitySupport == 0)
-- 
2.53.0



