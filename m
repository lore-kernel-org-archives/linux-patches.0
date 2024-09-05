Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521A81990D0;
	Thu,  5 Sep 2024 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529508; cv=none; b=JJcyqqFSV0b+4nMkugJuLcPwej/YhiNSYP7E+jwH9ZuBrjS3OwWooXRaepC7QG9NB8JvXLW/2RPOEYsRzIUYKtU5R7py70wk4iDQEuYN7Rjus+q0SPlEnRVeHNSZuHrIxJs3HsQYsOP7aSU5Ao4q8TCCv9EMJGNKO4oUH7RWG2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529508; c=relaxed/simple;
	bh=4X868TpYNhmTj+JMbeAXoz5LPIe42E0JKgYGkRBcm3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyhI9/8cWHJtkZGj0DAlqRbcFx6vtWEV6CFbYSEq10iGivEDA7IUl9FtWmbJVzB5iVx2gP90CkeztaZPLTKhnntI8Z1QDU5eqMcJOhC6nQx196z5mgPlyekC+HTETfPModo83D9NkW2z3PPmUupiW02c4QxTlA4TLqxABGCWdBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC94EDeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC94EDeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3319C4CEC3;
	Thu,  5 Sep 2024 09:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529508;
	bh=4X868TpYNhmTj+JMbeAXoz5LPIe42E0JKgYGkRBcm3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lC94EDeWWMxAEEjiETCEE2789YLD7Wll4YdRsRraCbJVO4ElQZbNH8makBd23Cbep
	 +9exOYFNqZOjnC0SZ43QvGAAM9vYcFRj/Qebqn9Pak1oL8sl4LXiskoLzdDbbf7rUV
	 fo8HNl1NKPgo/NtKEl1uTb58jQ0q5idKRazgrJkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 054/184] drm/amd/pm: fix uninitialized variable warnings for vega10_hwmgr
Date: Thu,  5 Sep 2024 11:39:27 +0200
Message-ID: <20240905093734.352477291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 5fa7d540d95d97ddc021a74583f6b3da4df9c93a ]

Clear warnings that using uninitialized variable when fails
to get the valid value from SMU.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 46 ++++++++++++++-----
 .../amd/pm/powerplay/smumgr/vega10_smumgr.c   |  6 ++-
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 574ead01430f..246b6568eb0d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -354,13 +354,13 @@ static int vega10_odn_initial_default_setting(struct pp_hwmgr *hwmgr)
 	return 0;
 }
 
-static void vega10_init_dpm_defaults(struct pp_hwmgr *hwmgr)
+static int vega10_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
-	int i;
 	uint32_t sub_vendor_id, hw_revision;
 	uint32_t top32, bottom32;
 	struct amdgpu_device *adev = hwmgr->adev;
+	int ret, i;
 
 	vega10_initialize_power_tune_defaults(hwmgr);
 
@@ -485,9 +485,12 @@ static void vega10_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 	if (data->registry_data.vr0hot_enabled)
 		data->smu_features[GNLD_VR0HOT].supported = true;
 
-	smum_send_msg_to_smc(hwmgr,
+	ret = smum_send_msg_to_smc(hwmgr,
 			PPSMC_MSG_GetSmuVersion,
 			&hwmgr->smu_version);
+	if (ret)
+		return ret;
+
 		/* ACG firmware has major version 5 */
 	if ((hwmgr->smu_version & 0xff000000) == 0x5000000)
 		data->smu_features[GNLD_ACG].supported = true;
@@ -505,10 +508,16 @@ static void vega10_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 		data->smu_features[GNLD_PCC_LIMIT].supported = true;
 
 	/* Get the SN to turn into a Unique ID */
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumTop32, &top32);
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumBottom32, &bottom32);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumTop32, &top32);
+	if (ret)
+		return ret;
+
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_ReadSerialNumBottom32, &bottom32);
+	if (ret)
+		return ret;
 
 	adev->unique_id = ((uint64_t)bottom32 << 32) | top32;
+	return 0;
 }
 
 #ifdef PPLIB_VEGA10_EVV_SUPPORT
@@ -882,7 +891,9 @@ static int vega10_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 
 	vega10_set_features_platform_caps(hwmgr);
 
-	vega10_init_dpm_defaults(hwmgr);
+	result = vega10_init_dpm_defaults(hwmgr);
+	if (result)
+		return result;
 
 #ifdef PPLIB_VEGA10_EVV_SUPPORT
 	/* Get leakage voltage based on leakage ID. */
@@ -3913,11 +3924,14 @@ static int vega10_get_gpu_power(struct pp_hwmgr *hwmgr,
 		uint32_t *query)
 {
 	uint32_t value;
+	int ret;
 
 	if (!query)
 		return -EINVAL;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrPkgPwr, &value);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrPkgPwr, &value);
+	if (ret)
+		return ret;
 
 	/* SMC returning actual watts, keep consistent with legacy asics, low 8 bit as 8 fractional bits */
 	*query = value << 8;
@@ -4813,14 +4827,16 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 	uint32_t gen_speed, lane_width, current_gen_speed, current_lane_width;
 	PPTable_t *pptable = &(data->smc_state_table.pp_table);
 
-	int i, now, size = 0, count = 0;
+	int i, ret, now,  size = 0, count = 0;
 
 	switch (type) {
 	case PP_SCLK:
 		if (data->registry_data.sclk_dpm_key_disabled)
 			break;
 
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentGfxclkIndex, &now);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentGfxclkIndex, &now);
+		if (ret)
+			break;
 
 		if (hwmgr->pp_one_vf &&
 		    (hwmgr->dpm_level == AMD_DPM_FORCED_LEVEL_PROFILE_PEAK))
@@ -4836,7 +4852,9 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 		if (data->registry_data.mclk_dpm_key_disabled)
 			break;
 
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentUclkIndex, &now);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentUclkIndex, &now);
+		if (ret)
+			break;
 
 		for (i = 0; i < mclk_table->count; i++)
 			size += sprintf(buf + size, "%d: %uMhz %s\n",
@@ -4847,7 +4865,9 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 		if (data->registry_data.socclk_dpm_key_disabled)
 			break;
 
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentSocclkIndex, &now);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentSocclkIndex, &now);
+		if (ret)
+			break;
 
 		for (i = 0; i < soc_table->count; i++)
 			size += sprintf(buf + size, "%d: %uMhz %s\n",
@@ -4858,8 +4878,10 @@ static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 		if (data->registry_data.dcefclk_dpm_key_disabled)
 			break;
 
-		smum_send_msg_to_smc_with_parameter(hwmgr,
+		ret = smum_send_msg_to_smc_with_parameter(hwmgr,
 				PPSMC_MSG_GetClockFreqMHz, CLK_DCEFCLK, &now);
+		if (ret)
+			break;
 
 		for (i = 0; i < dcef_table->count; i++)
 			size += sprintf(buf + size, "%d: %uMhz %s\n",
diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/vega10_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/vega10_smumgr.c
index a70d73896649..f9c0f117725d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/vega10_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/vega10_smumgr.c
@@ -130,13 +130,17 @@ int vega10_get_enabled_smc_features(struct pp_hwmgr *hwmgr,
 			    uint64_t *features_enabled)
 {
 	uint32_t enabled_features;
+	int ret;
 
 	if (features_enabled == NULL)
 		return -EINVAL;
 
-	smum_send_msg_to_smc(hwmgr,
+	ret = smum_send_msg_to_smc(hwmgr,
 			PPSMC_MSG_GetEnabledSmuFeatures,
 			&enabled_features);
+	if (ret)
+		return ret;
+
 	*features_enabled = enabled_features;
 
 	return 0;
-- 
2.43.0



