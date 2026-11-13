Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591553;
	b=Byj+Z3Bfzidx1busZS6R1MU/fjspGwPvj6MBA8WrR/eq5HHtT19t3gG2yd0MLqRycx/1
	 UtLbwEBsO1diCYUVK/wEGUxgzJjt97yCnl9bVmeswa1JPjXPcDiD7wX7y1uEx/FeTWxL9
	 v4qsFB+sD3QtY2so5gKVJzHa3YKFmhvgbI4sIOVswid7qaJXxeSNmFTw2u6UMnbVYtXYl
	 yBA8jBHkUy7Atp7+kdFmL471t0BVZsxB13cJFPBQ9jXkAtUHUSPW3qMYIWhcrjmrGUeiI
	 MfqQUo9YF+qbTy+qIPaD1i+kRiJnBOGwWjlz2Kqmht4Rdkun01iPMp1IyyMcqEuTTTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jkkJ9va3ewbdAsHa0mcosDll42gzO0GWctIvogH/8o=;
	b=1YN2A/DgMg7vIAcX5W8XC/nC3w8bqtnTevoGlZuzORulVdHxQlvnjLpQeH76gyFwIh8D
	 Ht5+1k2W5QiAArKl/9jmrd3z3ig4ub0BQwkORyYp32K3Dw2rkD5VgOeHGHXkZrtHHVNB9
	 RmQz8L2ggZzwPPaC5CTIaTfAM1J05MLQ+tD4fObQS5ffBvzwkXlnYznM7o5ql8quIbveu
	 DWwoNblwYdWK1Gb1MYlMJqbiYCqz6vayjeZ6QowK5W0EOoN1I0nQ3XuVwKuMsOYsuwiq7
	 3AkDymjGn3H2UOuyIdQjpNPEMC67pJrk0jqYR6FLbXnm+c69djpsMDSVyrzaxJ+BVnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0htUKyLF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081C6607EE66;
	Fri, 13 Nov 2026 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0htUKyLF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B431F000C4;
	Fri, 13 Nov 2026 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591552;
	bh=+jkkJ9va3ewbdAsHa0mcosDll42gzO0GWctIvogH/8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0htUKyLFIH+HHPj5CslE3nkUD4N+lv9yjVCR/HpSrdT5eDiMDXhQQmgQA45dJk2a/
	 o9MuAP23UEyRc7+2Z97afgDoQ9y19QPNVNRKFeZd79ugkiYYLZgnzR91GoSslXcEX2
	 U5sVfsq1k6dRg7f+Pd5LQEu1xB0zisr55Ehwcwd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 603/670] drm/amd/pm: reapply umd profile state after recovery
Date: Fri, 13 Nov 2026 10:52:47 -0500
Message-ID: <20261113153832.267078938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Wang <kevin.wang@amd.com>

[ Upstream commit ad6eb088a508d927641c8a76d1ca7911dfb7c80b ]

Resume and full GPU reset retain the selected UMD profile level in
driver state.
The GFX and PMFW state behind it is reinitialized.

Add a generic DPM reapply path after CG and PG restoration.
It restores the UMD GFX state and asks the PM backend to replay the
retained level.

v2:
- Reapply only GFX CG to preserve the profile-owned GFX PG reference.
- Fall back to AUTO when reapply fails without failing device recovery.
- Propagate PowerPlay DPM errors before accepting AUTO fallback.
- Limit workload-profile error reporting to the swSMU reapply path.

This covers:
- PCI runtime resume
- Full GPU reset recovery
- System resume, including S3 and s2idle

Signed-off-by: Kevin Wang <kevin.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fd0699fc9f4266fc07d6ce6dbb484fac04601106)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |  6 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       | 14 ---
 .../gpu/drm/amd/include/kgd_pp_interface.h    |  2 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c           | 85 ++++++++++++++++++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h       |  1 +
 .../gpu/drm/amd/pm/powerplay/amd_powerplay.c  | 33 +++++--
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c     | 87 +++++++++++++++++--
 7 files changed, 201 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 8602c31f25880..037cb9ce69e42 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3307,6 +3307,12 @@ static int amdgpu_device_ip_late_init(struct amdgpu_device *adev)
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_GATE);
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_GATE);
 
+	r = amdgpu_dpm_reapply_umd_profile(adev);
+	if (r) {
+		dev_err(adev->dev, "Failed to restore UMD profile state: %d\n", r);
+		return r;
+	}
+
 	amdgpu_device_fill_reset_magic(adev);
 
 	r = amdgpu_device_enable_mgpu_fan_boost();
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 1a112a3617576..7c9fee6a2edb5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2838,19 +2838,6 @@ static int amdgpu_pmops_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static void amdgpu_restore_umd_profile_pstate_after_runpm(struct amdgpu_device *adev)
-{
-	enum amd_dpm_forced_level level;
-	uint32_t profile_mode_mask = AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD |
-		AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK |
-		AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK |
-		AMD_DPM_FORCED_LEVEL_PROFILE_PEAK;
-
-	level = amdgpu_dpm_get_performance_level(adev);
-	if (level & profile_mode_mask)
-		amdgpu_asic_update_umd_stable_pstate(adev, true);
-}
-
 static int amdgpu_pmops_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -2896,7 +2883,6 @@ static int amdgpu_pmops_runtime_resume(struct device *dev)
 	if (adev->pm.rpm_mode == AMDGPU_RUNPM_PX)
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
 
-	amdgpu_restore_umd_profile_pstate_after_runpm(adev);
 	adev->in_runpm = false;
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/include/kgd_pp_interface.h b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
index a97b03232c0b9..a42e6c8710a2e 100644
--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -372,6 +372,8 @@ struct amd_pm_funcs {
 	int (*print_clock_levels)(void *handle, enum pp_clock_type type, char *buf);
 	int (*emit_clock_levels)(void *handle, enum pp_clock_type type, char *buf, int *offset);
 	int (*force_performance_level)(void *handle, enum amd_dpm_forced_level level);
+	int (*reapply_performance_level)(void *handle,
+					 enum amd_dpm_forced_level level);
 	int (*get_sclk_od)(void *handle);
 	int (*set_sclk_od)(void *handle, uint32_t value);
 	int (*get_mclk_od)(void *handle);
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index f57d09b025153..e096efd77e732 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -992,6 +992,91 @@ static void amdgpu_dpm_exit_umd_state(struct amdgpu_device *adev)
 					       AMD_PG_STATE_GATE);
 }
 
+/**
+ * amdgpu_dpm_reapply_umd_profile - Restore the active UMD profile
+ * @adev: amdgpu device
+ *
+ * Resume and reset retain the selected DPM level in software, but the
+ * underlying GFX and PMFW state is lost. Reapply a retained UMD profile
+ * after the common resume path has restored its default CG and PG state.
+ */
+int amdgpu_dpm_reapply_umd_profile(struct amdgpu_device *adev)
+{
+	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
+	enum amd_dpm_forced_level level;
+	int ret, fallback_ret;
+
+	if (!pp_funcs || !pp_funcs->reapply_performance_level ||
+	    !pp_funcs->force_performance_level)
+		return 0;
+
+	/* Serialize the retained level with the GFX and PMFW reprogramming. */
+	mutex_lock(&adev->pm.mutex);
+	if (adev->pm.dpm.thermal_active) {
+		dev_warn(adev->dev,
+			 "Cannot restore UMD profile while thermal control is active\n");
+		ret = 0;
+		goto unlock;
+	}
+
+	if (pp_funcs->get_performance_level)
+		level = pp_funcs->get_performance_level(adev->powerplay.pp_handle);
+	else
+		level = adev->pm.dpm.forced_level;
+
+	switch (level) {
+	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
+	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK:
+	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK:
+	case AMD_DPM_FORCED_LEVEL_PROFILE_PEAK:
+		break;
+	default:
+		ret = 0;
+		goto unlock;
+	}
+
+	/* The active profile already owns the GFX PG reference. */
+	ret = amdgpu_device_ip_set_clockgating_state(adev, AMD_IP_BLOCK_TYPE_GFX,
+					      AMD_CG_STATE_UNGATE);
+	if (ret)
+		goto fallback_auto;
+
+	ret = amdgpu_asic_update_umd_stable_pstate(adev, true);
+	if (ret)
+		goto fallback_auto;
+
+	ret = pp_funcs->reapply_performance_level(adev->powerplay.pp_handle,
+						     level);
+	if (ret)
+		goto fallback_auto;
+
+unlock:
+	mutex_unlock(&adev->pm.mutex);
+
+	return ret;
+
+fallback_auto:
+	dev_warn(adev->dev, "Failed to restore UMD profile state: %d\n", ret);
+
+	/* Restore normal CG before releasing the profile's PG reference. */
+	amdgpu_asic_update_umd_stable_pstate(adev, false);
+	amdgpu_device_ip_set_clockgating_state(adev, AMD_IP_BLOCK_TYPE_GFX,
+					       AMD_CG_STATE_GATE);
+	mutex_unlock(&adev->pm.mutex);
+
+	mutex_lock(&adev->pm.stable_pstate_ctx_lock);
+	fallback_ret = amdgpu_dpm_force_performance_level(adev,
+						   AMD_DPM_FORCED_LEVEL_AUTO);
+	if (fallback_ret)
+		dev_warn(adev->dev, "Failed to fall back to AUTO performance level: %d\n",
+			 fallback_ret);
+	else
+		adev->pm.stable_pstate_ctx = NULL;
+	mutex_unlock(&adev->pm.stable_pstate_ctx_lock);
+
+	return 0;
+}
+
 int amdgpu_dpm_force_performance_level(struct amdgpu_device *adev,
 				       enum amd_dpm_forced_level level)
 {
diff --git a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
index 3e27050ccd123..ff49e03626c6e 100644
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -480,6 +480,7 @@ void amdgpu_dpm_set_power_state(struct amdgpu_device *adev,
 enum amd_dpm_forced_level amdgpu_dpm_get_performance_level(struct amdgpu_device *adev);
 int amdgpu_dpm_force_performance_level(struct amdgpu_device *adev,
 				       enum amd_dpm_forced_level level);
+int amdgpu_dpm_reapply_umd_profile(struct amdgpu_device *adev);
 int amdgpu_dpm_get_pp_num_states(struct amdgpu_device *adev,
 				 struct pp_states_info *states);
 int amdgpu_dpm_dispatch_task(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index b1526f80c9720..58dc4a5920a55 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -383,24 +383,46 @@ static void pp_dpm_en_umd_pstate(struct pp_hwmgr  *hwmgr,
 	}
 }
 
-static int pp_dpm_force_performance_level(void *handle,
-					enum amd_dpm_forced_level level)
+static int pp_dpm_apply_performance_level(struct pp_hwmgr *hwmgr,
+					  enum amd_dpm_forced_level level,
+					  bool reapply)
 {
-	struct pp_hwmgr *hwmgr = handle;
+	int ret;
 
 	if (!hwmgr || !hwmgr->pm_en)
 		return -EINVAL;
 
-	if (level == hwmgr->dpm_level)
+	if (!reapply && level == hwmgr->dpm_level)
 		return 0;
 
 	pp_dpm_en_umd_pstate(hwmgr, &level);
 	hwmgr->request_dpm_level = level;
-	hwmgr_handle_task(hwmgr, AMD_PP_TASK_READJUST_POWER_STATE, NULL);
+	ret = hwmgr_handle_task(hwmgr, AMD_PP_TASK_READJUST_POWER_STATE, NULL);
+	if (ret)
+		return ret;
+
+	ret = phm_force_dpm_levels(hwmgr, level);
+	if (ret)
+		return ret;
+
+	hwmgr->dpm_level = level;
 
 	return 0;
 }
 
+static int pp_dpm_force_performance_level(void *handle,
+					enum amd_dpm_forced_level level)
+{
+	return pp_dpm_apply_performance_level(handle, level, false);
+}
+
+static int
+pp_dpm_reapply_performance_level(void *handle,
+					 enum amd_dpm_forced_level level)
+{
+	return pp_dpm_apply_performance_level(handle, level, true);
+}
+
 static enum amd_dpm_forced_level pp_dpm_get_performance_level(
 								void *handle)
 {
@@ -1583,6 +1605,7 @@ static const struct amd_pm_funcs pp_dpm_funcs = {
 	.load_firmware = pp_dpm_load_fw,
 	.wait_for_fw_loading_complete = pp_dpm_fw_loading_complete,
 	.force_performance_level = pp_dpm_force_performance_level,
+	.reapply_performance_level = pp_dpm_reapply_performance_level,
 	.get_performance_level = pp_dpm_get_performance_level,
 	.get_current_power_state = pp_dpm_get_current_power_state,
 	.dispatch_tasks = pp_dpm_dispatch_tasks,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 83f666dfe7bdf..1963653a5c605 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2214,6 +2214,13 @@ static int smu_set_powergating_state(void *handle,
 	return 0;
 }
 
+static void smu_enter_umd_pstate(struct smu_context *smu)
+{
+	smu_gpo_control(smu, false);
+	smu_gfx_ulv_control(smu, false);
+	smu_deep_sleep_control(smu, false);
+}
+
 static int smu_enable_umd_pstate(void *handle,
 		      enum amd_dpm_forced_level *level)
 {
@@ -2232,9 +2239,7 @@ static int smu_enable_umd_pstate(void *handle,
 		/* enter umd pstate, save current level, disable gfx cg*/
 		if (*level & profile_mode_mask) {
 			smu_dpm_ctx->saved_dpm_level = smu_dpm_ctx->dpm_level;
-			smu_gpo_control(smu, false);
-			smu_gfx_ulv_control(smu, false);
-			smu_deep_sleep_control(smu, false);
+			smu_enter_umd_pstate(smu);
 			amdgpu_asic_update_umd_stable_pstate(smu->adev, true);
 		}
 	} else {
@@ -2293,7 +2298,8 @@ static void smu_power_profile_mode_put(struct smu_context *smu,
 
 static int smu_adjust_power_state_dynamic(struct smu_context *smu,
 					  enum amd_dpm_forced_level level,
-					  bool skip_display_settings)
+					  bool skip_display_settings,
+					  bool force_performance_level)
 {
 	int ret = 0;
 	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
@@ -2320,7 +2326,7 @@ static int smu_adjust_power_state_dynamic(struct smu_context *smu,
 		}
 	}
 
-	if (smu_dpm_ctx->dpm_level != level) {
+	if (force_performance_level || smu_dpm_ctx->dpm_level != level) {
 		ret = smu_asic_set_performance_level(smu, level);
 		if (ret) {
 			dev_err(smu->adev->dev, "Failed to set performance level!");
@@ -2338,6 +2344,39 @@ static int smu_adjust_power_state_dynamic(struct smu_context *smu,
 	return ret;
 }
 
+static int
+smu_reapply_power_state_dynamic(struct smu_context *smu,
+				enum amd_dpm_forced_level level)
+{
+	struct smu_dpm_context *smu_dpm_ctx = &smu->smu_dpm;
+	int ret;
+
+	ret = smu_apply_clocks_adjust_rules(smu);
+	if (ret) {
+		dev_err(smu->adev->dev, "Failed to apply clocks adjust rules!");
+		return ret;
+	}
+
+	ret = smu_asic_set_performance_level(smu, level);
+	if (ret) {
+		if (ret == -EOPNOTSUPP)
+			dev_info(smu->adev->dev, "set performance level %d not supported",
+				 level);
+		else
+			dev_err(smu->adev->dev, "Failed to set performance level %d",
+				level);
+		return ret;
+	}
+
+	smu_dpm_ctx->dpm_level = level;
+
+	if (smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL ||
+	    smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+		return 0;
+
+	return smu_bump_power_profile_mode(smu, NULL, 0);
+}
+
 static int smu_handle_task(struct smu_context *smu,
 			   enum amd_dpm_forced_level level,
 			   enum amd_pp_task task_id)
@@ -2352,13 +2391,13 @@ static int smu_handle_task(struct smu_context *smu,
 		ret = smu_pre_display_config_changed(smu);
 		if (ret)
 			return ret;
-		ret = smu_adjust_power_state_dynamic(smu, level, false);
+		ret = smu_adjust_power_state_dynamic(smu, level, false, false);
 		break;
 	case AMD_PP_TASK_COMPLETE_INIT:
-		ret = smu_adjust_power_state_dynamic(smu, level, true);
+		ret = smu_adjust_power_state_dynamic(smu, level, true, false);
 		break;
 	case AMD_PP_TASK_READJUST_POWER_STATE:
-		ret = smu_adjust_power_state_dynamic(smu, level, true);
+		ret = smu_adjust_power_state_dynamic(smu, level, true, false);
 		break;
 	default:
 		break;
@@ -2454,6 +2493,37 @@ static int smu_force_performance_level(void *handle,
 	return ret;
 }
 
+static int
+smu_reapply_performance_level(void *handle,
+			      enum amd_dpm_forced_level level)
+{
+	struct smu_context *smu = handle;
+	struct smu_dpm_context *smu_dpm_ctx = &smu->smu_dpm;
+
+	if (!smu->pm_enabled || !smu->adev->pm.dpm_enabled)
+		return -EOPNOTSUPP;
+
+	if (!smu->is_apu && !smu_dpm_ctx->dpm_context)
+		return -EINVAL;
+
+	switch (level) {
+	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
+	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK:
+	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK:
+	case AMD_DPM_FORCED_LEVEL_PROFILE_PEAK:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (smu_dpm_ctx->dpm_level != level)
+		return -EINVAL;
+
+	smu_enter_umd_pstate(smu);
+
+	return smu_reapply_power_state_dynamic(smu, level);
+}
+
 static int smu_set_display_count(void *handle, uint32_t count)
 {
 	struct smu_context *smu = handle;
@@ -3711,6 +3781,7 @@ static const struct amd_pm_funcs swsmu_pm_funcs = {
 	.print_clock_levels      = smu_print_ppclk_levels,
 	.emit_clock_levels       = smu_emit_ppclk_levels,
 	.force_performance_level = smu_force_performance_level,
+	.reapply_performance_level = smu_reapply_performance_level,
 	.read_sensor             = smu_read_sensor,
 	.get_apu_thermal_limit       = smu_get_apu_thermal_limit,
 	.set_apu_thermal_limit       = smu_set_apu_thermal_limit,
-- 
2.53.0



