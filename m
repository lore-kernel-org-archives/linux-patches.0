Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4978D183CD9;
	Mon, 12 Aug 2024 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478777; cv=none; b=Ea9DDiRbv/X7j8UCgC75jI6vcmixRuiroUlk4vHQwps4TcPaknEEk3k0uKy34VkF3TEfFSCk71ZSXwFmd5jxf2GfuiQqpyXRbQqSCCuRyGyKtjWpTGyA5qLZqbNJvbF+T5LKGr4iu4SE11bzz1k1UXNrobopWV1K88MwqpGJCvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478777; c=relaxed/simple;
	bh=ewoYbgf06iJMGKEia7fyvdk4F4aVoCosCL+Zgq0Xpu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeTckNTW8urnVafL5kdtrDaNHJT8mqpxCZdoIBCcao09oX3QiB1w8VTQVwycQqzPdTPa9RfD9TTcgRvaAkt17fymPzYhk7o6XO7H0yXFAaQKG62MWJxyxgdTuIgc7mz/mV+gzilu20ItNpHdCqulopmgHL/f5lwcqq5wc9gKdqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW6AgQh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW6AgQh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739C5C4AF0D;
	Mon, 12 Aug 2024 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478776;
	bh=ewoYbgf06iJMGKEia7fyvdk4F4aVoCosCL+Zgq0Xpu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW6AgQh+5c8tX3XQwqbwcAwvXxW1g2U2zs+DvmXJ+EwS1GcVVuRB/X9yD2dp0ybZy
	 k928OZtZ3GeXrswkXWuJ+3mwOxbsd1U78xRafcENeNHyToRsqaFUJTlN0f+hkR5OMr
	 gQgrJcrh/6lP2LeRrIpczYdtCrt869oLo7Uw7YE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/150] drm/amdgpu/pm: Fix the param type of set_power_profile_mode
Date: Mon, 12 Aug 2024 18:01:55 +0200
Message-ID: <20240812160126.482075923@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit f683f24093dd94a831085fe0ea8e9dc4c6c1a2d1 ]

Function .set_power_profile_mode need an array as input
parameter. So define variable workload as an array to fix
the below coverity warning.

"Passing &workload to function hwmgr->hwmgr_func->set_power_profile_mode
which uses it as an array. This might corrupt or misinterpret adjacent
memory locations"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c |  8 ++++----
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c  |  8 ++++----
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c        | 16 ++++++++--------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 179e1c593a53f..f3668911a88fd 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -928,7 +928,7 @@ static int pp_dpm_switch_power_profile(void *handle,
 		enum PP_SMC_POWER_PROFILE type, bool en)
 {
 	struct pp_hwmgr *hwmgr = handle;
-	long workload;
+	long workload[1];
 	uint32_t index;
 
 	if (!hwmgr || !hwmgr->pm_en)
@@ -946,12 +946,12 @@ static int pp_dpm_switch_power_profile(void *handle,
 		hwmgr->workload_mask &= ~(1 << hwmgr->workload_prority[type]);
 		index = fls(hwmgr->workload_mask);
 		index = index > 0 && index <= Workload_Policy_Max ? index - 1 : 0;
-		workload = hwmgr->workload_setting[index];
+		workload[0] = hwmgr->workload_setting[index];
 	} else {
 		hwmgr->workload_mask |= (1 << hwmgr->workload_prority[type]);
 		index = fls(hwmgr->workload_mask);
 		index = index <= Workload_Policy_Max ? index - 1 : 0;
-		workload = hwmgr->workload_setting[index];
+		workload[0] = hwmgr->workload_setting[index];
 	}
 
 	if (type == PP_SMC_POWER_PROFILE_COMPUTE &&
@@ -961,7 +961,7 @@ static int pp_dpm_switch_power_profile(void *handle,
 	}
 
 	if (hwmgr->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL)
-		hwmgr->hwmgr_func->set_power_profile_mode(hwmgr, &workload, 0);
+		hwmgr->hwmgr_func->set_power_profile_mode(hwmgr, workload, 0);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
index 1d829402cd2e2..f4bd8e9357e22 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
@@ -269,7 +269,7 @@ int psm_adjust_power_state_dynamic(struct pp_hwmgr *hwmgr, bool skip_display_set
 						struct pp_power_state *new_ps)
 {
 	uint32_t index;
-	long workload;
+	long workload[1];
 
 	if (hwmgr->not_vf) {
 		if (!skip_display_settings)
@@ -294,10 +294,10 @@ int psm_adjust_power_state_dynamic(struct pp_hwmgr *hwmgr, bool skip_display_set
 	if (hwmgr->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL) {
 		index = fls(hwmgr->workload_mask);
 		index = index > 0 && index <= Workload_Policy_Max ? index - 1 : 0;
-		workload = hwmgr->workload_setting[index];
+		workload[0] = hwmgr->workload_setting[index];
 
-		if (hwmgr->power_profile_mode != workload && hwmgr->hwmgr_func->set_power_profile_mode)
-			hwmgr->hwmgr_func->set_power_profile_mode(hwmgr, &workload, 0);
+		if (hwmgr->power_profile_mode != workload[0] && hwmgr->hwmgr_func->set_power_profile_mode)
+			hwmgr->hwmgr_func->set_power_profile_mode(hwmgr, workload, 0);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 1d0693dad8185..91f0646eb3ee0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1834,7 +1834,7 @@ static int smu_adjust_power_state_dynamic(struct smu_context *smu,
 {
 	int ret = 0;
 	int index = 0;
-	long workload;
+	long workload[1];
 	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
 
 	if (!skip_display_settings) {
@@ -1874,10 +1874,10 @@ static int smu_adjust_power_state_dynamic(struct smu_context *smu,
 		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
-		workload = smu->workload_setting[index];
+		workload[0] = smu->workload_setting[index];
 
-		if (smu->power_profile_mode != workload)
-			smu_bump_power_profile_mode(smu, &workload, 0);
+		if (smu->power_profile_mode != workload[0])
+			smu_bump_power_profile_mode(smu, workload, 0);
 	}
 
 	return ret;
@@ -1927,7 +1927,7 @@ static int smu_switch_power_profile(void *handle,
 {
 	struct smu_context *smu = handle;
 	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
-	long workload;
+	long workload[1];
 	uint32_t index;
 
 	if (!smu->pm_enabled || !smu->adev->pm.dpm_enabled)
@@ -1940,17 +1940,17 @@ static int smu_switch_power_profile(void *handle,
 		smu->workload_mask &= ~(1 << smu->workload_prority[type]);
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
-		workload = smu->workload_setting[index];
+		workload[0] = smu->workload_setting[index];
 	} else {
 		smu->workload_mask |= (1 << smu->workload_prority[type]);
 		index = fls(smu->workload_mask);
 		index = index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
-		workload = smu->workload_setting[index];
+		workload[0] = smu->workload_setting[index];
 	}
 
 	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
 		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
-		smu_bump_power_profile_mode(smu, &workload, 0);
+		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;
 }
-- 
2.43.0



