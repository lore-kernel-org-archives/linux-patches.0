Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3F42F5A;
	Tue,  2 Jul 2024 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941414; cv=none; b=hrfCNhsrwCBdKOx1XZsgnoJoVbcdxHWaNELzaQWn3MpwpQeEwOpDG3zvUC9fOIhsuggcUeAwUBXeTnG/AtOazKIPRTRHKMv8jUDxjNWBsctEWMAc3CJV6zlumb5eBVInQJMIGJWX+614sw/X8pLHE2JPZq6g64JBh4UyAE9tiG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941414; c=relaxed/simple;
	bh=lC12KkxMa0Dqc4WBP3j5ceDvhmUOnn0XbhIRxWmh/Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DyC0YXgebBOmcnH8s5cOXlNfVWgzmX6Kxx7gl6Aaybe346Cbc9UJ+FEk1j7yLxUQelhubb+WyH9Np1kSprIEguEDawxyuvz1vboWmMnJJKcQPhSUB6l1jYwF1DGUgQ0WP2DiHRfGvC8/aGtI0FqqtS01ybHIswvpeR3FlQkrTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNusMAKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNusMAKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702BEC116B1;
	Tue,  2 Jul 2024 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941413;
	bh=lC12KkxMa0Dqc4WBP3j5ceDvhmUOnn0XbhIRxWmh/Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNusMAKVPrX2igR3TskfkiJvGBSuw4Z+2rl7tEIyVovOSorkjDRQvPTEBqO5pEjwe
	 A921oz0h+aPvJe2WViaWAzSaQijWlAaIXzhAKzXbZCKa74cBBcJR6YbE4vvYWIQ84Q
	 ECb60I/OyNZsYeGeDo2zlv+KFvGkUNGpDHVLw/6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/128] drm/amd/amdgpu: Fix style errors in amdgpu_drv.c & amdgpu_device.c
Date: Tue,  2 Jul 2024 19:04:17 +0200
Message-ID: <20240702170228.352167909@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 47fc644f801e4414753a9b7e87ed41f991cd68c3 ]

Fix following checkpatch style errors in amdgpu_drv.c &
amdgpu_device.c

ERROR: exactly one space required after that #ifdef
ERROR: spaces required around that '+=' (ctx:WxV)
ERROR: space required before the open brace '{'
ERROR: spaces required around that '||' (ctx:VxE)
ERROR: space prohibited before that close parenthesis ')'
ERROR: space required before the open parenthesis '('
ERROR: space required before the open brace '{'
ERROR: code indent should use tabs where possible

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 74fa02c4a5ea ("drm/amdgpu: Fix pci state save during mode-1 reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 65 +++++++++++-----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |  2 +-
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b11690a816e73..985688696202a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -980,7 +980,7 @@ void amdgpu_device_program_register_sequence(struct amdgpu_device *adev,
 	if (array_size % 3)
 		return;
 
-	for (i = 0; i < array_size; i +=3) {
+	for (i = 0; i < array_size; i += 3) {
 		reg = registers[i + 0];
 		and_mask = registers[i + 1];
 		or_mask = registers[i + 2];
@@ -1552,7 +1552,7 @@ static int amdgpu_device_check_arguments(struct amdgpu_device *adev)
 		dev_warn(adev->dev, "sched jobs (%d) must be at least 4\n",
 			 amdgpu_sched_jobs);
 		amdgpu_sched_jobs = 4;
-	} else if (!is_power_of_2(amdgpu_sched_jobs)){
+	} else if (!is_power_of_2(amdgpu_sched_jobs)) {
 		dev_warn(adev->dev, "sched jobs (%d) must be a power of 2\n",
 			 amdgpu_sched_jobs);
 		amdgpu_sched_jobs = roundup_pow_of_two(amdgpu_sched_jobs);
@@ -2747,8 +2747,9 @@ static int amdgpu_device_ip_late_init(struct amdgpu_device *adev)
 		DRM_ERROR("enable mgpu fan boost failed (%d).\n", r);
 
 	/* For passthrough configuration on arcturus and aldebaran, enable special handling SBR */
-	if (amdgpu_passthrough(adev) && ((adev->asic_type == CHIP_ARCTURUS && adev->gmc.xgmi.num_physical_nodes > 1)||
-			       adev->asic_type == CHIP_ALDEBARAN ))
+	if (amdgpu_passthrough(adev) &&
+	    ((adev->asic_type == CHIP_ARCTURUS && adev->gmc.xgmi.num_physical_nodes > 1) ||
+	     adev->asic_type == CHIP_ALDEBARAN))
 		amdgpu_dpm_handle_passthrough_sbr(adev, true);
 
 	if (adev->gmc.xgmi.num_physical_nodes > 1) {
@@ -3077,7 +3078,7 @@ static int amdgpu_device_ip_suspend_phase2(struct amdgpu_device *adev)
 		}
 		adev->ip_blocks[i].status.hw = false;
 		/* handle putting the SMC in the appropriate state */
-		if(!amdgpu_sriov_vf(adev)){
+		if (!amdgpu_sriov_vf(adev)) {
 			if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SMC) {
 				r = amdgpu_dpm_set_mp1_state(adev, adev->mp1_state);
 				if (r) {
@@ -4048,7 +4049,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 
 	/* disable all interrupts */
 	amdgpu_irq_disable_all(adev);
-	if (adev->mode_info.mode_config_initialized){
+	if (adev->mode_info.mode_config_initialized) {
 		if (!drm_drv_uses_atomic_modeset(adev_to_drm(adev)))
 			drm_helper_force_disable_all(adev_to_drm(adev));
 		else
@@ -4755,42 +4756,42 @@ bool amdgpu_device_should_recover_gpu(struct amdgpu_device *adev)
 
 int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 {
-        u32 i;
-        int ret = 0;
+	u32 i;
+	int ret = 0;
 
-        amdgpu_atombios_scratch_regs_engine_hung(adev, true);
+	amdgpu_atombios_scratch_regs_engine_hung(adev, true);
 
-        dev_info(adev->dev, "GPU mode1 reset\n");
+	dev_info(adev->dev, "GPU mode1 reset\n");
 
-        /* disable BM */
-        pci_clear_master(adev->pdev);
+	/* disable BM */
+	pci_clear_master(adev->pdev);
 
-        amdgpu_device_cache_pci_state(adev->pdev);
+	amdgpu_device_cache_pci_state(adev->pdev);
 
-        if (amdgpu_dpm_is_mode1_reset_supported(adev)) {
-                dev_info(adev->dev, "GPU smu mode1 reset\n");
-                ret = amdgpu_dpm_mode1_reset(adev);
-        } else {
-                dev_info(adev->dev, "GPU psp mode1 reset\n");
-                ret = psp_gpu_reset(adev);
-        }
+	if (amdgpu_dpm_is_mode1_reset_supported(adev)) {
+		dev_info(adev->dev, "GPU smu mode1 reset\n");
+		ret = amdgpu_dpm_mode1_reset(adev);
+	} else {
+		dev_info(adev->dev, "GPU psp mode1 reset\n");
+		ret = psp_gpu_reset(adev);
+	}
 
-        if (ret)
-                dev_err(adev->dev, "GPU mode1 reset failed\n");
+	if (ret)
+		dev_err(adev->dev, "GPU mode1 reset failed\n");
 
-        amdgpu_device_load_pci_state(adev->pdev);
+	amdgpu_device_load_pci_state(adev->pdev);
 
-        /* wait for asic to come out of reset */
-        for (i = 0; i < adev->usec_timeout; i++) {
-                u32 memsize = adev->nbio.funcs->get_memsize(adev);
+	/* wait for asic to come out of reset */
+	for (i = 0; i < adev->usec_timeout; i++) {
+		u32 memsize = adev->nbio.funcs->get_memsize(adev);
 
-                if (memsize != 0xffffffff)
-                        break;
-                udelay(1);
-        }
+		if (memsize != 0xffffffff)
+			break;
+		udelay(1);
+	}
 
-        amdgpu_atombios_scratch_regs_engine_hung(adev, false);
-        return ret;
+	amdgpu_atombios_scratch_regs_engine_hung(adev, false);
+	return ret;
 }
 
 int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 9a5416331f02e..238c15c0c7e1e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1662,7 +1662,7 @@ static const u16 amdgpu_unsupported_pciidlist[] = {
 };
 
 static const struct pci_device_id pciidlist[] = {
-#ifdef  CONFIG_DRM_AMDGPU_SI
+#ifdef CONFIG_DRM_AMDGPU_SI
 	{0x1002, 0x6780, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6784, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6788, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
-- 
2.43.0



