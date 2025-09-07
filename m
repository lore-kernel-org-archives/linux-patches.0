Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C0120D4FC;
	Sun,  7 Sep 2025 20:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276391; cv=none; b=MieOC1aDlt3sW6AFtymRfrndEOtscmkx8oTVWlOANLaRJJXT7Z+yWnGh+rDKeyrsk57H5IrZ4/twSHrrWNdbRlbggHtTc6NYhzI+IF9OoTnsH3IG6WKfZgGzmfWGF/TSdVCzCV7DcntQlDcmyE7VLp+ogEz6b2eXDeiKYygSBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276391; c=relaxed/simple;
	bh=4Eb5cyLUOhQ7aQFZBOzQcPUs/0lS5cuGDU0LuQ/F4Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hoO5vkg4IGBwaWyJ+mTntzzNW0oDhsWRJ2lMLY+ZyoJjrJ218nkYbSveT7F5xLxGvHufVfhiA4B9UREpeQPsKVP8Bb121kj3LEAhfX153xxTcjh6LiKfZat4SR1K8k8fNsOH4sT8yyP2W5kdJkuHdPy5hIo55tWY+LNhTc7xurM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qypPDTPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qypPDTPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5B9C4CEF0;
	Sun,  7 Sep 2025 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276391;
	bh=4Eb5cyLUOhQ7aQFZBOzQcPUs/0lS5cuGDU0LuQ/F4Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qypPDTPHe8U+XKfyFkl6r/ZTOJdfhmJCUtzIbshZb/NwAqRRS3Jj+6Rxm4mT7Qqwf
	 UQCmuCAgX/EL6wkJ1fiUdrkjolXJTTLfOSvhygjP6jFKVpmAQOFxgsaWSjtS33dRXF
	 W5wh9qs9aoF9McgJzDwCkf7Lp8Gp760nF+oaKrGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/104] drm/amd/amdgpu: Fix style problems in amdgpu_psp.c
Date: Sun,  7 Sep 2025 21:58:47 +0200
Message-ID: <20250907195610.004226610@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit f14c8c3e1fc9e10c6d54999a96acb2b5087374df ]

Fix the following checkpatch warnings & error in amdgpu_psp.c

WARNING: Comparisons should place the constant on the right side of the test
WARNING: braces {} are not necessary for single statement blocks
WARNING: please, no space before tabs
WARNING: braces {} are not necessary for single statement blocks
ERROR: that open brace { should be on the previous line

Suggested-by: Christian König <christian.koenig@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 467e00b30dfe ("drm/amd/amdgpu: Fix missing error return on kzalloc failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 51 ++++++++++---------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index ff3678a1c0296..459a5af3a99ac 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -392,7 +392,7 @@ static int psp_sw_init(void *handle)
 	if ((psp_get_runtime_db_entry(adev,
 				PSP_RUNTIME_ENTRY_TYPE_PPTABLE_ERR_STATUS,
 				&scpm_entry)) &&
-	    (SCPM_DISABLE != scpm_entry.scpm_status)) {
+	    (scpm_entry.scpm_status != SCPM_DISABLE)) {
 		adev->scpm_enabled = true;
 		adev->scpm_status = scpm_entry.scpm_status;
 	} else {
@@ -439,10 +439,9 @@ static int psp_sw_init(void *handle)
 
 	if (adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 0) ||
 	    adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 7)) {
-		ret= psp_sysfs_init(adev);
-		if (ret) {
+		ret = psp_sysfs_init(adev);
+		if (ret)
 			return ret;
-		}
 	}
 
 	ret = amdgpu_bo_create_kernel(adev, PSP_1_MEG, PSP_1_MEG,
@@ -641,7 +640,7 @@ psp_cmd_submit_buf(struct psp_context *psp,
 	skip_unsupport = (psp->cmd_buf_mem->resp.status == TEE_ERROR_NOT_SUPPORTED ||
 		psp->cmd_buf_mem->resp.status == PSP_ERR_UNKNOWN_COMMAND) && amdgpu_sriov_vf(psp->adev);
 
-	memcpy((void*)&cmd->resp, (void*)&psp->cmd_buf_mem->resp, sizeof(struct psp_gfx_resp));
+	memcpy(&cmd->resp, &psp->cmd_buf_mem->resp, sizeof(struct psp_gfx_resp));
 
 	/* In some cases, psp response status is not 0 even there is no
 	 * problem while the command is submitted. Some version of PSP FW
@@ -823,7 +822,7 @@ static int psp_tmr_load(struct psp_context *psp)
 }
 
 static void psp_prep_tmr_unload_cmd_buf(struct psp_context *psp,
-				        struct psp_gfx_cmd_resp *cmd)
+					struct psp_gfx_cmd_resp *cmd)
 {
 	if (amdgpu_sriov_vf(psp->adev))
 		cmd->cmd_id = GFX_CMD_ID_DESTROY_VMR;
@@ -1052,7 +1051,7 @@ static void psp_prep_ta_load_cmd_buf(struct psp_gfx_cmd_resp *cmd,
 				     struct ta_context *context)
 {
 	cmd->cmd_id				= context->ta_load_type;
-	cmd->cmd.cmd_load_ta.app_phy_addr_lo 	= lower_32_bits(ta_bin_mc);
+	cmd->cmd.cmd_load_ta.app_phy_addr_lo	= lower_32_bits(ta_bin_mc);
 	cmd->cmd.cmd_load_ta.app_phy_addr_hi	= upper_32_bits(ta_bin_mc);
 	cmd->cmd.cmd_load_ta.app_len		= context->bin_desc.size_bytes;
 
@@ -1158,9 +1157,8 @@ int psp_ta_load(struct psp_context *psp, struct ta_context *context)
 
 	context->resp_status = cmd->resp.status;
 
-	if (!ret) {
+	if (!ret)
 		context->session_id = cmd->resp.session_id;
-	}
 
 	release_psp_cmd_buf(psp);
 
@@ -1490,8 +1488,7 @@ int psp_ras_invoke(struct psp_context *psp, uint32_t ta_cmd_id)
 	if (amdgpu_ras_intr_triggered())
 		return ret;
 
-	if (ras_cmd->if_version > RAS_TA_HOST_IF_VER)
-	{
+	if (ras_cmd->if_version > RAS_TA_HOST_IF_VER) {
 		DRM_WARN("RAS: Unsupported Interface");
 		return -EINVAL;
 	}
@@ -1501,8 +1498,7 @@ int psp_ras_invoke(struct psp_context *psp, uint32_t ta_cmd_id)
 			dev_warn(psp->adev->dev, "ECC switch disabled\n");
 
 			ras_cmd->ras_status = TA_RAS_STATUS__ERROR_RAS_NOT_AVAILABLE;
-		}
-		else if (ras_cmd->ras_out_message.flags.reg_access_failure_flag)
+		} else if (ras_cmd->ras_out_message.flags.reg_access_failure_flag)
 			dev_warn(psp->adev->dev,
 				 "RAS internal register access blocked\n");
 
@@ -1598,11 +1594,10 @@ static int psp_ras_initialize(struct psp_context *psp)
 				if (ret)
 					dev_warn(adev->dev, "PSP set boot config failed\n");
 				else
-					dev_warn(adev->dev, "GECC will be disabled in next boot cycle "
-						 "if set amdgpu_ras_enable and/or amdgpu_ras_mask to 0x0\n");
+					dev_warn(adev->dev, "GECC will be disabled in next boot cycle if set amdgpu_ras_enable and/or amdgpu_ras_mask to 0x0\n");
 			}
 		} else {
-			if (1 == boot_cfg) {
+			if (boot_cfg == 1) {
 				dev_info(adev->dev, "GECC is enabled\n");
 			} else {
 				/* enable GECC in next boot cycle if it is disabled
@@ -2389,7 +2384,7 @@ static int psp_prep_load_ip_fw_cmd_buf(struct amdgpu_firmware_info *ucode,
 }
 
 static int psp_execute_non_psp_fw_load(struct psp_context *psp,
-			          struct amdgpu_firmware_info *ucode)
+				  struct amdgpu_firmware_info *ucode)
 {
 	int ret = 0;
 	struct psp_gfx_cmd_resp *cmd = acquire_psp_cmd_buf(psp);
@@ -2428,9 +2423,8 @@ static int psp_load_smu_fw(struct psp_context *psp)
 	     (adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 4) ||
 	      adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 2)))) {
 		ret = amdgpu_dpm_set_mp1_state(adev, PP_MP1_STATE_UNLOAD);
-		if (ret) {
+		if (ret)
 			DRM_WARN("Failed to set MP1 state prepare for reload\n");
-		}
 	}
 
 	ret = psp_execute_non_psp_fw_load(psp, ucode);
@@ -2740,9 +2734,8 @@ static int psp_suspend(void *handle)
 	}
 
 	ret = psp_ring_stop(psp, PSP_RING_TYPE__KM);
-	if (ret) {
+	if (ret)
 		DRM_ERROR("PSP ring stop failed\n");
-	}
 
 out:
 	return ret;
@@ -3015,7 +3008,7 @@ static int parse_sos_bin_descriptor(struct psp_context *psp,
 		psp->sos.fw_version        = le32_to_cpu(desc->fw_version);
 		psp->sos.feature_version   = le32_to_cpu(desc->fw_version);
 		psp->sos.size_bytes        = le32_to_cpu(desc->size_bytes);
-		psp->sos.start_addr 	   = ucode_start_addr;
+		psp->sos.start_addr	   = ucode_start_addr;
 		break;
 	case PSP_FW_TYPE_PSP_SYS_DRV:
 		psp->sys.fw_version        = le32_to_cpu(desc->fw_version);
@@ -3501,7 +3494,7 @@ void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size
 	drm_dev_exit(idx);
 }
 
-static DEVICE_ATTR(usbc_pd_fw, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(usbc_pd_fw, 0644,
 		   psp_usbc_pd_fw_sysfs_read,
 		   psp_usbc_pd_fw_sysfs_write);
 
@@ -3686,8 +3679,7 @@ static void psp_sysfs_fini(struct amdgpu_device *adev)
 	device_remove_file(adev->dev, &dev_attr_usbc_pd_fw);
 }
 
-const struct amdgpu_ip_block_version psp_v3_1_ip_block =
-{
+const struct amdgpu_ip_block_version psp_v3_1_ip_block = {
 	.type = AMD_IP_BLOCK_TYPE_PSP,
 	.major = 3,
 	.minor = 1,
@@ -3695,8 +3687,7 @@ const struct amdgpu_ip_block_version psp_v3_1_ip_block =
 	.funcs = &psp_ip_funcs,
 };
 
-const struct amdgpu_ip_block_version psp_v10_0_ip_block =
-{
+const struct amdgpu_ip_block_version psp_v10_0_ip_block = {
 	.type = AMD_IP_BLOCK_TYPE_PSP,
 	.major = 10,
 	.minor = 0,
@@ -3704,8 +3695,7 @@ const struct amdgpu_ip_block_version psp_v10_0_ip_block =
 	.funcs = &psp_ip_funcs,
 };
 
-const struct amdgpu_ip_block_version psp_v11_0_ip_block =
-{
+const struct amdgpu_ip_block_version psp_v11_0_ip_block = {
 	.type = AMD_IP_BLOCK_TYPE_PSP,
 	.major = 11,
 	.minor = 0,
@@ -3721,8 +3711,7 @@ const struct amdgpu_ip_block_version psp_v11_0_8_ip_block = {
 	.funcs = &psp_ip_funcs,
 };
 
-const struct amdgpu_ip_block_version psp_v12_0_ip_block =
-{
+const struct amdgpu_ip_block_version psp_v12_0_ip_block = {
 	.type = AMD_IP_BLOCK_TYPE_PSP,
 	.major = 12,
 	.minor = 0,
-- 
2.51.0



