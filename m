Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70694244670;
	Tue, 29 Apr 2025 17:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948295; cv=none; b=NN/p7AKXueOa0eTFkk14SCFxU9W8+dUDx61i8FU938aN/NDR3GKjSaZZuM3ncmKe1XEGsw6AxqKBgfSihHl2Bgy0nTnRH6WILhVgjsqwxqNI63oqn5hRS/DyAOsMLjc1Cb1UHlCQ8cYFJSTlPobJTpWJK87XATXYMIOn9zkzFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948295; c=relaxed/simple;
	bh=PXLn36Ir8Zb0ZuKe+E1JEsGRbB93r8ls53Q7jdKncyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE8g3H7Uad+vNGQxXeyl7pqJx74xsDSxw4mtzgZDPxkYEL8/AyIjH3ogawwNuhM1b20JSKPLzhf4g8zltmhUaZVVzYcMcRue/dU9X4L2/K6bBnjFT6Tix/BBSaMQA1a2ARNBup/lL2vr149K/2gXCF/VwwVyRzHHQP9XnJ6M8mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRbUhYvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRbUhYvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E698C4CEE3;
	Tue, 29 Apr 2025 17:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948294;
	bh=PXLn36Ir8Zb0ZuKe+E1JEsGRbB93r8ls53Q7jdKncyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRbUhYvZaCy8fifF/aYjljbQkXXOjdfA1HkUYmyqbAv5KbjURxA1gmGVRWpfF04+a
	 8yDCOh1AAdPYt8eOPWsqDSVUDHcemrMw7lrZD1QYLzuai8pGeprxTRiBXoEmBOYU7A
	 0RFxraBU/zC+Iul0Gu9++4WznDuxG8h0bE85YDV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/280] drm/amdgpu: Use the right function for hdp flush
Date: Tue, 29 Apr 2025 18:43:07 +0200
Message-ID: <20250429161125.189219682@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit c235a7132258ac30bd43d228222986022d21f5de ]

There are a few prechecks made before HDP flush like a flush is not
required on APU bare metal. Using hdp callback directly bypasses those
checks. Use amdgpu_device_flush_hdp which takes care of prechecks.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1d9bff4cf8c53d33ee2ff1b11574e5da739ce61c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |  8 ++++----
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 12 ++++++------
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |  6 +++---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  |  2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c |  2 +-
 10 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 45ed97038df0c..24d711b0e6346 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -5998,7 +5998,7 @@ static int gfx_v10_0_cp_gfx_load_pfp_microcode(struct amdgpu_device *adev)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_PFP_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_PFP_IC_BASE_CNTL, VMID, 0);
@@ -6076,7 +6076,7 @@ static int gfx_v10_0_cp_gfx_load_ce_microcode(struct amdgpu_device *adev)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_CE_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_CE_IC_BASE_CNTL, VMID, 0);
@@ -6153,7 +6153,7 @@ static int gfx_v10_0_cp_gfx_load_me_microcode(struct amdgpu_device *adev)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_ME_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_ME_IC_BASE_CNTL, VMID, 0);
@@ -6528,7 +6528,7 @@ static int gfx_v10_0_cp_compute_load_microcode(struct amdgpu_device *adev)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_CPC_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_CPC_IC_BASE_CNTL, CACHE_POLICY, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 84cf5fd297b7f..0357fea8ae1df 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -2327,7 +2327,7 @@ static int gfx_v11_0_config_me_cache(struct amdgpu_device *adev, uint64_t addr)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, regCP_ME_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_ME_IC_BASE_CNTL, VMID, 0);
@@ -2371,7 +2371,7 @@ static int gfx_v11_0_config_pfp_cache(struct amdgpu_device *adev, uint64_t addr)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, regCP_PFP_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_PFP_IC_BASE_CNTL, VMID, 0);
@@ -2416,7 +2416,7 @@ static int gfx_v11_0_config_mec_cache(struct amdgpu_device *adev, uint64_t addr)
 	}
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	tmp = RREG32_SOC15(GC, 0, regCP_CPC_IC_BASE_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_CPC_IC_BASE_CNTL, CACHE_POLICY, 0);
@@ -3051,7 +3051,7 @@ static int gfx_v11_0_cp_gfx_load_pfp_microcode_rs64(struct amdgpu_device *adev)
 	amdgpu_bo_unreserve(adev->gfx.pfp.pfp_fw_data_obj);
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	WREG32_SOC15(GC, 0, regCP_PFP_IC_BASE_LO,
 		lower_32_bits(adev->gfx.pfp.pfp_fw_gpu_addr));
@@ -3269,7 +3269,7 @@ static int gfx_v11_0_cp_gfx_load_me_microcode_rs64(struct amdgpu_device *adev)
 	amdgpu_bo_unreserve(adev->gfx.me.me_fw_data_obj);
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	WREG32_SOC15(GC, 0, regCP_ME_IC_BASE_LO,
 		lower_32_bits(adev->gfx.me.me_fw_gpu_addr));
@@ -4487,7 +4487,7 @@ static int gfx_v11_0_gfxhub_enable(struct amdgpu_device *adev)
 	if (r)
 		return r;
 
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	value = (amdgpu_vm_fault_stop == AMDGPU_VM_FAULT_STOP_ALWAYS) ?
 		false : true;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index b259e217930c7..241619ee10e4b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -2264,7 +2264,7 @@ static int gfx_v12_0_cp_gfx_load_pfp_microcode_rs64(struct amdgpu_device *adev)
 	amdgpu_bo_unreserve(adev->gfx.pfp.pfp_fw_data_obj);
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	WREG32_SOC15(GC, 0, regCP_PFP_IC_BASE_LO,
 		lower_32_bits(adev->gfx.pfp.pfp_fw_gpu_addr));
@@ -2408,7 +2408,7 @@ static int gfx_v12_0_cp_gfx_load_me_microcode_rs64(struct amdgpu_device *adev)
 	amdgpu_bo_unreserve(adev->gfx.me.me_fw_data_obj);
 
 	if (amdgpu_emu_mode == 1)
-		adev->hdp.funcs->flush_hdp(adev, NULL);
+		amdgpu_device_flush_hdp(adev, NULL);
 
 	WREG32_SOC15(GC, 0, regCP_ME_IC_BASE_LO,
 		lower_32_bits(adev->gfx.me.me_fw_gpu_addr));
@@ -3429,7 +3429,7 @@ static int gfx_v12_0_gfxhub_enable(struct amdgpu_device *adev)
 	if (r)
 		return r;
 
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	value = (amdgpu_vm_fault_stop == AMDGPU_VM_FAULT_STOP_ALWAYS) ?
 		false : true;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 9784a28921853..c6e7429212827 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -265,7 +265,7 @@ static void gmc_v10_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 	ack = hub->vm_inv_eng0_ack + hub->eng_distance * eng;
 
 	/* flush hdp cache */
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	/* This is necessary for SRIOV as well as for GFXOFF to function
 	 * properly under bare metal
@@ -966,7 +966,7 @@ static int gmc_v10_0_gart_enable(struct amdgpu_device *adev)
 	adev->hdp.funcs->init_registers(adev);
 
 	/* Flush HDP after it is initialized */
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	value = (amdgpu_vm_fault_stop == AMDGPU_VM_FAULT_STOP_ALWAYS) ?
 		false : true;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
index 2797fd84432b2..4e9c23d65b02f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -226,7 +226,7 @@ static void gmc_v11_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 	ack = hub->vm_inv_eng0_ack + hub->eng_distance * eng;
 
 	/* flush hdp cache */
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	/* This is necessary for SRIOV as well as for GFXOFF to function
 	 * properly under bare metal
@@ -893,7 +893,7 @@ static int gmc_v11_0_gart_enable(struct amdgpu_device *adev)
 		return r;
 
 	/* Flush HDP after it is initialized */
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	value = (amdgpu_vm_fault_stop == AMDGPU_VM_FAULT_STOP_ALWAYS) ?
 		false : true;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
index 60acf676000b3..525e435ee22d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -294,7 +294,7 @@ static void gmc_v12_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 		return;
 
 	/* flush hdp cache */
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	/* This is necessary for SRIOV as well as for GFXOFF to function
 	 * properly under bare metal
@@ -862,7 +862,7 @@ static int gmc_v12_0_gart_enable(struct amdgpu_device *adev)
 		return r;
 
 	/* Flush HDP after it is initialized */
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	value = (amdgpu_vm_fault_stop == AMDGPU_VM_FAULT_STOP_ALWAYS) ?
 		false : true;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 7a45f3fdc7341..9a212413c6d3a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -2351,7 +2351,7 @@ static int gmc_v9_0_hw_init(void *handle)
 	adev->hdp.funcs->init_registers(adev);
 
 	/* After HDP is initialized, flush HDP.*/
-	adev->hdp.funcs->flush_hdp(adev, NULL);
+	amdgpu_device_flush_hdp(adev, NULL);
 
 	if (amdgpu_vm_fault_stop == AMDGPU_VM_FAULT_STOP_ALWAYS)
 		value = false;
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 2395f1856962a..e77a467af7ac3 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -532,7 +532,7 @@ static int psp_v11_0_memory_training(struct psp_context *psp, uint32_t ops)
 			}
 
 			memcpy_toio(adev->mman.aper_base_kaddr, buf, sz);
-			adev->hdp.funcs->flush_hdp(adev, NULL);
+			amdgpu_device_flush_hdp(adev, NULL);
 			vfree(buf);
 			drm_dev_exit(idx);
 		} else {
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index 51e470e8d67d9..bf00de763acb0 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -600,7 +600,7 @@ static int psp_v13_0_memory_training(struct psp_context *psp, uint32_t ops)
 			}
 
 			memcpy_toio(adev->mman.aper_base_kaddr, buf, sz);
-			adev->hdp.funcs->flush_hdp(adev, NULL);
+			amdgpu_device_flush_hdp(adev, NULL);
 			vfree(buf);
 			drm_dev_exit(idx);
 		} else {
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
index 4d33c95a51163..89f6c06946c51 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -488,7 +488,7 @@ static int psp_v14_0_memory_training(struct psp_context *psp, uint32_t ops)
 			}
 
 			memcpy_toio(adev->mman.aper_base_kaddr, buf, sz);
-			adev->hdp.funcs->flush_hdp(adev, NULL);
+			amdgpu_device_flush_hdp(adev, NULL);
 			vfree(buf);
 			drm_dev_exit(idx);
 		} else {
-- 
2.39.5



