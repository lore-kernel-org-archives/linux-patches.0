Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87C6369211;
	Wed, 20 May 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295126; cv=none; b=OYbT/yS4Ky2wfVxMc9ghn1YC8yBvD5spT0XSrobxKfZ70AnOofivgdDsCoSyOG4F4w+PkN3NjU7zGUFIkzj2VZ6wlCB1tHeX4hcplzw1XElBDbd42F+Zyg7JMIWNqF33NBWdC7fG7/HF7cK4cKWoXkP45jzpG+pdyn+tkCevEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295126; c=relaxed/simple;
	bh=uoEciZNhKAFB+x0cbEAhFs/oPBd3JhYkKdvJS8ns2Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ0ygDp5QCnnPXk2DvAxO4auADHoeUuCJUyMKbNah4TqMKO0w39ieXeOWyrlr3QJEpbftIJeLWCNdIFtGushUHHhy7f1hMZA8DcRFhgG6XwbdmkHwDkasrFsCC+8VOrHUzGvVmP2RerDCWeXREfdnmbCf6XZ2mitgsXYLBOomnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F93B/Zw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F93B/Zw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D591F000E9;
	Wed, 20 May 2026 16:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295124;
	bh=/BhNq9pljqbIGr7VGAcKd6pJLjMxGizHy2wAWSHIgvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F93B/Zw1RZiyzWs9cRJM+P087bMxdPDTwrGbrfksbIh7IK3y4uhBS6Beq31jqih62
	 5ppglHWHzKenSyiHkOYQFS+Z0HplCbdqJOkLVgduljtDBNvP/PqlxF4hPhZL8GaCfB
	 Ba7dx9IqBD2cEkjCDqkdqMwEedh/+TnVonu0OqWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Lang Yu <lang.yu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0259/1146] drm/amdgpu: GFX12.1 scratch memory limit up to 57-bit
Date: Wed, 20 May 2026 18:08:29 +0200
Message-ID: <20260520162154.091665457@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit b2d13a41da94008fdd3786b396a6375c12454522 ]

The scratch aperture or gmc private aperture in flat memory contains
57 bits of data on gfx v12.1.0 compared to the 32 bits from previous.

Add new helper kfd_init_apertures_v12 for gfx version >= v12.1.0 which
supports 57-bit VA space.

v2:
  - update pdd->scratch_limit (Yu, Lang)
  - update fixes tag (Felix Kuehling)
  - add helper kfd_init_apertures_v12

Fixes: db1882b3ff0c ("drm/amdkfd: Update LDS, Scratch base for 57bit address")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Lang Yu <lang.yu@amd.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c       |  2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c       | 10 ++++--
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c | 35 ++++++++++++++------
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
index eb9725ae1607a..557d15b90ad27 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
@@ -1405,7 +1405,7 @@ static void gfx_v12_1_xcc_init_compute_vmid(struct amdgpu_device *adev,
 	/*
 	 * Configure apertures:
 	 * LDS:         0x20000000'00000000 - 0x20000001'00000000 (4GB)
-	 * Scratch:     0x10000000'00000000 - 0x10000001'00000000 (4GB)
+	 * Scratch:     0x10000000'00000000 - 0x11ffffff'ffffffff (128PB 57-bit)
 	 */
 	sh_mem_bases = REG_SET_FIELD(0, SH_MEM_BASES, PRIVATE_BASE,
 				     (adev->gmc.private_aperture_start >> 58));
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
index b9671fc39e2a8..da4a0cf4aad0c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -654,9 +654,15 @@ static int gmc_v12_0_early_init(struct amdgpu_ip_block *ip_block)
 	adev->gmc.shared_aperture_start = 0x2000000000000000ULL;
 	adev->gmc.shared_aperture_end =
 		adev->gmc.shared_aperture_start + (4ULL << 30) - 1;
+
 	adev->gmc.private_aperture_start = 0x1000000000000000ULL;
-	adev->gmc.private_aperture_end =
-		adev->gmc.private_aperture_start + (4ULL << 30) - 1;
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(12, 1, 0))
+		adev->gmc.private_aperture_end =
+			adev->gmc.private_aperture_start + (1ULL << 57) - 1;
+	else
+		adev->gmc.private_aperture_end =
+			adev->gmc.private_aperture_start + (4ULL << 30) - 1;
+
 	adev->gmc.noretry_flags = AMDGPU_VM_NORETRY_FLAGS_TF;
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c b/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
index e8da0b4527dc5..04c5e26f01ed9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
@@ -342,20 +342,14 @@ static void kfd_init_apertures_vi(struct kfd_process_device *pdd, uint8_t id)
 
 static void kfd_init_apertures_v9(struct kfd_process_device *pdd, uint8_t id)
 {
-	if (KFD_GC_VERSION(pdd->dev) >= IP_VERSION(12, 1, 0))
-		pdd->lds_base = pdd->dev->adev->gmc.shared_aperture_start;
-	else
-		pdd->lds_base = MAKE_LDS_APP_BASE_V9();
+	pdd->lds_base = MAKE_LDS_APP_BASE_V9();
 	pdd->lds_limit = MAKE_LDS_APP_LIMIT(pdd->lds_base);
 
 	pdd->gpuvm_base = AMDGPU_VA_RESERVED_BOTTOM;
 	pdd->gpuvm_limit =
 		pdd->dev->kfd->shared_resources.gpuvm_size - 1;
 
-	if (KFD_GC_VERSION(pdd->dev) >= IP_VERSION(12, 1, 0))
-		pdd->scratch_base = pdd->dev->adev->gmc.private_aperture_start;
-	else
-		pdd->scratch_base = MAKE_SCRATCH_APP_BASE_V9();
+	pdd->scratch_base = MAKE_SCRATCH_APP_BASE_V9();
 	pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
 
 	/*
@@ -365,6 +359,25 @@ static void kfd_init_apertures_v9(struct kfd_process_device *pdd, uint8_t id)
 	pdd->qpd.cwsr_base = AMDGPU_VA_RESERVED_TRAP_START(pdd->dev->adev);
 }
 
+static void kfd_init_apertures_v12(struct kfd_process_device *pdd, uint8_t id)
+{
+	pdd->lds_base = pdd->dev->adev->gmc.shared_aperture_start;
+	pdd->lds_limit = pdd->dev->adev->gmc.shared_aperture_end;
+
+	pdd->gpuvm_base = AMDGPU_VA_RESERVED_BOTTOM;
+	pdd->gpuvm_limit =
+		pdd->dev->kfd->shared_resources.gpuvm_size - 1;
+
+	pdd->scratch_base = pdd->dev->adev->gmc.private_aperture_start;
+	pdd->scratch_limit = pdd->dev->adev->gmc.private_aperture_end;
+
+	/*
+	 * Place TBA/TMA on opposite side of VM hole to prevent
+	 * stray faults from triggering SVM on these pages.
+	 */
+	pdd->qpd.cwsr_base = AMDGPU_VA_RESERVED_TRAP_START(pdd->dev->adev);
+}
+
 int kfd_init_apertures(struct kfd_process *process)
 {
 	uint8_t id  = 0;
@@ -412,9 +425,11 @@ int kfd_init_apertures(struct kfd_process *process)
 				kfd_init_apertures_vi(pdd, id);
 				break;
 			default:
-				if (KFD_GC_VERSION(dev) >= IP_VERSION(9, 0, 1))
+				if (KFD_GC_VERSION(dev) >= IP_VERSION(12, 1, 0)) {
+					kfd_init_apertures_v12(pdd, id);
+				} else if (KFD_GC_VERSION(dev) >= IP_VERSION(9, 0, 1)) {
 					kfd_init_apertures_v9(pdd, id);
-				else {
+				} else {
 					WARN(1, "Unexpected ASIC family %u",
 					     dev->adev->asic_type);
 					return -EINVAL;
-- 
2.53.0



