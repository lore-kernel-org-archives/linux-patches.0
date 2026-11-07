Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065163;
	b=euQwXHHDKxkT033yErjDF5eCjhyfRcfA+r7uqEaCE3F+gbds7XxVV3rIDMkFWvjrtyQS
	 gZkq7TKWLHkT9FfXT+Drrrky3VzTUg06Wq61vdwg1n77IpN7m11A+8e/P0XZIm+FOEcE1
	 ch72ZmBeeetAMnaJmunpmYSC00qnJbDI2eoIGIMhMmf0QUPPguBw40ykyM1/Ks4qFZCIq
	 GG8NQjIZZKysNR87eF6yudGGLh198Eb4WpTChVrQr4sitLdltGkQwmX+MrB6NxBcyzN8v
	 5lQZzDpfCVVFAHvQCCe6ZYDg1/qEY0BVMe5guzVFA2fkqcHKFN8rXxe6vDeH5SJh70A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZjnfnCMqvLFjbLjTwTI10DP/8g5YhtQkeGPn6VBlBL4=;
	b=XmOlxklGqMihfogyjPrIPAPLy6D5RcWFk9iyvsHVtjsJCmvRY2RevIxjjmN6shnnRXh9
	 XGcMljK5OmHpsXQ3t6MTC8MO1XoI2OAJdqeAu1gxpp5FHcqkUicXrDST8yAPIHQ4GEXKp
	 G5ZbkmlM2zUcGPiP17d0zK/pUoaOfQ0W4MYFKsl/zygbYQSB74RMxBklTQ+w0PcYWbg0m
	 hxr6/zh/L76iOPeMG5YeZ8BV6j3/JD3MNwOoJjXsXZp2SQ9UU0I4GBsbyLV+lgfUc0mpz
	 2d1vCnNADLiI6qCvNzxc8Eqgsi3boHB+XMEisQB+SAgI4+3jaKqzxSzubAbiQAEpYYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZFDY0hg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7C606A32E;
	Sat,  7 Nov 2026 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZFDY0hg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9661F0089F;
	Sat,  7 Nov 2026 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065163;
	bh=ZjnfnCMqvLFjbLjTwTI10DP/8g5YhtQkeGPn6VBlBL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZFDY0hgQk8IfWFt1+vz5almG34TkKSQsJysQ0DJ5Yt4FQcSmAFkc/lc/fsFyG0lo
	 hvQGGB2Hbz2+8oD4l+73jZmznbL8asNKslfc7vCALx+k+pGgu/g5xdhmyzf6R/H81H
	 s5ikppLqIlxhUCSpRz2OCAErYOIFKUL0zxvwJ4eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Zhen Han <Zhen.Han@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0969/1257] drm/amdkfd: correct vram_available calculation
Date: Sat,  7 Nov 2026 08:54:25 -0500
Message-ID: <20261107135006.120006736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Han <Zhen.Han@amd.com>

[ Upstream commit 9131cc85d0dedd8ba4cae60dbe5985d081551f30 ]

reserve_mem_limit() computes available VRAM as
	vram_size - reserved - vram_pin_size - kfd.vram_used
However, kfd.vram_used already includes BOs that are later pinned.
Pinning does not consume extra VRAM. Subtracting
vram_pin_size counts those bytes twice and causes fake-OOM
while VRAM is still free.

Reuse get_available_memory() in reserve_mem_limit(). Move
ALIGN_DOWN to the ioctl so the userspace ABI is unchanged. The
VRAM counter is a parameter: the ioctl passes vram_used_aligned[],
the gate passes vram_used[] so a 4K BO is not charged 2MB.

kfd.vram_pinned is only updated in gpuvm_pin_bo(). dma-buf pin
calls amdgpu_bo_pin() only, so the counter stays zero. Update it
from amdgpu_bo_pin() through a KFD helper, on first pin and last
unpin, matching vram_pin_size.

Track per-XCP pins in vram_pin_size_xcp[] and kfd.vram_pinned[].
Pins that are not owned by a single partition go to
vram_pin_size_common, which every partition subtracts.

A KFD VRAM BO always carries a partition, so the KFD credit is only
correct for xcp >= 0. Call the helper for both branches and let it
warn once and skip if that ever stops holding: without the credit the
BO would be subtracted through vram_pin_size_common and never added
back, which is the double counting this patch removes, and
kfd.vram_pinned[] would be indexed out of bounds.

Suggested-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Zhen Han <Zhen.Han@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 894cbb31c50e3cf49657130396bbf6c0475304e4)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h           | 11 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    | 20 +++-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 94 +++++++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c    | 33 +++++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 12 ++-
 5 files changed, 127 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index a9c6f5d4a6397..a63404adc2d84 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -834,8 +834,17 @@ struct amdgpu_device {
 	struct mutex	mn_lock;
 	DECLARE_HASHTABLE(mn_hash, 7);
 
-	/* tracking pinned memory */
+	/* tracking pinned memory
+	 *
+	 *	vram_pin_size = sum(vram_pin_size_xcp[]) + vram_pin_size_common
+	 *
+	 * vram_pin_size         total pin size in device
+	 * vram_pin_size_xcp[i]  pins owned by partition i (bo->xcp_id = i, i >= 0)
+	 * vram_pin_size_common  pins not owned by any partition, bo->xcp_id = -1
+	 */
 	atomic64_t vram_pin_size;
+	atomic64_t vram_pin_size_xcp[MAX_XCP];
+	atomic64_t vram_pin_size_common;
 	atomic64_t visible_pin_size;
 	atomic64_t gart_pin_size;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 056dd7375d24f..f462b40220eb2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -42,6 +42,12 @@
 
 extern uint64_t amdgpu_amdkfd_total_mem_size;
 
+/*
+ * Align VRAM availability to 2MB to avoid fragmentation caused by 4K
+ * allocations in the tail 2MB BO chunk.
+ */
+#define VRAM_AVAILABLITY_ALIGN (1 << 21)
+
 enum TLB_FLUSH_TYPE {
 	TLB_FLUSH_LEGACY = 0,
 	TLB_FLUSH_LIGHTWEIGHT,
@@ -106,7 +112,7 @@ struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
 	int64_t vram_used[MAX_XCP];
 	uint64_t vram_used_aligned[MAX_XCP];
-	atomic64_t vram_pinned;
+	atomic64_t vram_pinned[MAX_XCP];
 	bool init_complete;
 	struct work_struct reset_work;
 
@@ -391,6 +397,8 @@ void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
  * Allows KFD to release its resources associated with the GEM object.
  */
 void amdgpu_amdkfd_release_notify(struct amdgpu_bo *bo);
+void amdgpu_amdkfd_account_vram_pin(struct amdgpu_bo *bo, int xcp_id);
+void amdgpu_amdkfd_account_vram_unpin(struct amdgpu_bo *bo, int xcp_id);
 void amdgpu_amdkfd_reserve_system_mem(uint64_t size);
 #else
 static inline
@@ -408,6 +416,16 @@ static inline
 void amdgpu_amdkfd_release_notify(struct amdgpu_bo *bo)
 {
 }
+
+static inline
+void amdgpu_amdkfd_account_vram_pin(struct amdgpu_bo *bo, int xcp_id)
+{
+}
+
+static inline
+void amdgpu_amdkfd_account_vram_unpin(struct amdgpu_bo *bo, int xcp_id)
+{
+}
 #endif
 
 #if IS_ENABLED(CONFIG_HSA_AMD_SVM)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 0ac243467422f..46632a021ce85 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -46,12 +46,6 @@
 #define AMDGPU_USERPTR_RESTORE_DELAY_MS 1
 #define AMDGPU_RESERVE_MEM_LIMIT			(3UL << 29)
 
-/*
- * Align VRAM availability to 2MB to avoid fragmentation caused by 4K allocations in the tail 2MB
- * BO chunk
- */
-#define VRAM_AVAILABLITY_ALIGN (1 << 21)
-
 /* Impose limit on how much memory KFD can use */
 static struct {
 	uint64_t max_system_mem_limit;
@@ -73,6 +67,8 @@ static const char * const domain_bit_to_string[] = {
 #define domain_string(domain) domain_bit_to_string[ffs(domain)-1]
 
 static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work);
+static size_t __get_available_memory(struct amdgpu_device *adev,
+				     uint8_t xcp_id, int64_t vram_used);
 
 static bool kfd_mem_is_attached(struct amdgpu_vm *avm,
 		struct kgd_mem *mem)
@@ -169,13 +165,8 @@ void amdgpu_amdkfd_reserve_system_mem(uint64_t size)
 int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 		uint64_t size, u32 alloc_flag, int8_t xcp_id)
 {
-	uint64_t reserved_for_pt =
-		ESTIMATE_PT_SIZE(amdgpu_amdkfd_total_mem_size);
-	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
-	uint64_t reserved_for_ras = (con ? con->reserved_pages_in_bytes : 0);
 	size_t system_mem_needed, ttm_mem_needed, vram_needed;
 	int ret = 0;
-	uint64_t vram_size = 0;
 
 	system_mem_needed = 0;
 	ttm_mem_needed = 0;
@@ -196,7 +187,6 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 		if (WARN_ONCE(xcp_id < 0, "invalid XCP ID %d", xcp_id))
 			return -EINVAL;
 
-		vram_size = KFD_XCP_MEMORY_SIZE(adev, xcp_id);
 		if (adev->apu_prefer_gtt) {
 			system_mem_needed = size;
 			ttm_mem_needed = size;
@@ -232,14 +222,11 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 	 * VRAM check since ttm_mem_limit check already cover this allocation
 	 */
 
-	if (adev && xcp_id >= 0 && (!adev->apu_prefer_gtt || adev->gmc.is_app_apu)) {
-		uint64_t vram_available =
-			vram_size - reserved_for_pt - reserved_for_ras -
-			atomic64_read(&adev->vram_pin_size);
-		if (adev->kfd.vram_used[xcp_id] + vram_needed > vram_available) {
-			ret = -ENOMEM;
-			goto release;
-		}
+	if (adev && xcp_id >= 0 && (!adev->apu_prefer_gtt || adev->gmc.is_app_apu) &&
+	    vram_needed > __get_available_memory(adev, xcp_id,
+						 adev->kfd.vram_used[xcp_id])) {
+		ret = -ENOMEM;
+		goto release;
 	}
 
 	/* Update memory accounting by decreasing available system
@@ -318,6 +305,30 @@ void amdgpu_amdkfd_release_notify(struct amdgpu_bo *bo)
 	kfree(bo->kfd_bo);
 }
 
+void amdgpu_amdkfd_account_vram_pin(struct amdgpu_bo *bo, int xcp_id)
+{
+	if (!bo->kfd_bo)
+		return;
+
+	if (WARN_ONCE(xcp_id < 0, "KFD BO pinned in VRAM with no partition"))
+		return;
+
+	atomic64_add(amdgpu_bo_size(bo),
+		     &amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned[xcp_id]);
+}
+
+void amdgpu_amdkfd_account_vram_unpin(struct amdgpu_bo *bo, int xcp_id)
+{
+	if (!bo->kfd_bo)
+		return;
+
+	if (WARN_ONCE(xcp_id < 0, "KFD BO unpinned in VRAM with no partition"))
+		return;
+
+	atomic64_sub(amdgpu_bo_size(bo),
+		     &amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned[xcp_id]);
+}
+
 /**
  * create_dmamap_sg_bo() - Creates a amdgpu_bo object to reflect information
  * about USERPTR or DOOREBELL or MMIO BO.
@@ -1537,10 +1548,6 @@ static int amdgpu_amdkfd_gpuvm_pin_bo(struct amdgpu_bo *bo, u32 domain)
 
 	amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
 
-	if (!ret && bo->tbo.resource->mem_type == TTM_PL_VRAM)
-		atomic64_add(amdgpu_bo_size(bo),
-			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
-
 out:
 	amdgpu_bo_unreserve(bo);
 	return ret;
@@ -1564,10 +1571,6 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 
 	amdgpu_bo_unpin(bo);
 
-	if (bo->tbo.resource->mem_type == TTM_PL_VRAM)
-		atomic64_sub(amdgpu_bo_size(bo),
-			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
-
 	amdgpu_bo_unreserve(bo);
 }
 
@@ -1671,8 +1674,9 @@ int amdgpu_amdkfd_criu_resume(void *p)
 	return ret;
 }
 
-size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
-					  uint8_t xcp_id)
+/* Caller must hold kfd_mem_limit.mem_limit_lock. */
+static size_t __get_available_memory(struct amdgpu_device *adev,
+				     uint8_t xcp_id, int64_t vram_used)
 {
 	uint64_t reserved_for_pt =
 		ESTIMATE_PT_SIZE(amdgpu_amdkfd_total_mem_size);
@@ -1681,15 +1685,17 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 	ssize_t available;
 	uint64_t vram_available, system_mem_available, ttm_mem_available;
 
-	spin_lock(&kfd_mem_limit.mem_limit_lock);
+	lockdep_assert_held(&kfd_mem_limit.mem_limit_lock);
+
 	if (adev->apu_prefer_gtt && !adev->gmc.is_app_apu)
 		vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
-			- adev->kfd.vram_used_aligned[xcp_id];
+			- vram_used;
 	else
 		vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
-			- adev->kfd.vram_used_aligned[xcp_id]
-			- atomic64_read(&adev->vram_pin_size)
-			+ atomic64_read(&adev->kfd.vram_pinned)
+			- vram_used
+			- atomic64_read(&adev->vram_pin_size_xcp[xcp_id])
+			- atomic64_read(&adev->vram_pin_size_common)
+			+ atomic64_read(&adev->kfd.vram_pinned[xcp_id])
 			- reserved_for_pt
 			- reserved_for_ras;
 
@@ -1704,19 +1710,29 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 
 		available = min3(system_mem_available, ttm_mem_available,
 				 vram_available);
-		available = ALIGN_DOWN(available, PAGE_SIZE);
 	} else {
-		available = ALIGN_DOWN(vram_available, VRAM_AVAILABLITY_ALIGN);
+		available = vram_available;
 	}
 
-	spin_unlock(&kfd_mem_limit.mem_limit_lock);
-
 	if (available < 0)
 		available = 0;
 
 	return available;
 }
 
+size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
+					  uint8_t xcp_id)
+{
+	size_t available;
+
+	spin_lock(&kfd_mem_limit.mem_limit_lock);
+	available = __get_available_memory(adev, xcp_id,
+					   adev->kfd.vram_used_aligned[xcp_id]);
+	spin_unlock(&kfd_mem_limit.mem_limit_lock);
+
+	return available;
+}
+
 int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 		struct amdgpu_device *adev, uint64_t va, uint64_t size,
 		void *drm_priv, struct kgd_mem **mem,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 1b6c32a177fb6..ee366d729abfb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -915,6 +915,19 @@ void amdgpu_bo_unref(struct amdgpu_bo **bo)
 	*bo = NULL;
 }
 
+/* Map a BO onto vram_pin_size_xcp[]. bo->xcp_id < 0 means "any partition":
+ * such pins are not owned by a single partition and go to
+ * vram_pin_size_common, which every partition subtracts.
+ */
+static int amdgpu_bo_get_xcp(struct amdgpu_bo *bo)
+{
+	s8 xcp = bo->xcp_id;
+
+	if (xcp >= 0 && xcp < MAX_XCP)
+		return xcp;
+	return -1;
+}
+
 /**
  * amdgpu_bo_pin - pin an &amdgpu_bo buffer object
  * @bo: &amdgpu_bo buffer object to be pinned
@@ -995,7 +1008,17 @@ int amdgpu_bo_pin(struct amdgpu_bo *bo, u32 domain)
 	ttm_bo_pin(&bo->tbo);
 
 	if (bo->tbo.resource->mem_type == TTM_PL_VRAM) {
+		int xcp = amdgpu_bo_get_xcp(bo);
+
 		atomic64_add(amdgpu_bo_size(bo), &adev->vram_pin_size);
+		if (xcp >= 0) {
+			atomic64_add(amdgpu_bo_size(bo),
+				     &adev->vram_pin_size_xcp[xcp]);
+		} else {
+			atomic64_add(amdgpu_bo_size(bo),
+				     &adev->vram_pin_size_common);
+		}
+		amdgpu_amdkfd_account_vram_pin(bo, xcp);
 		atomic64_add(amdgpu_vram_mgr_bo_visible_size(bo),
 			     &adev->visible_pin_size);
 	} else if (bo->tbo.resource->mem_type == TTM_PL_TT) {
@@ -1028,7 +1051,17 @@ void amdgpu_bo_unpin(struct amdgpu_bo *bo)
 		dma_buf_unpin(bo->tbo.base.import_attach);
 
 	if (bo->tbo.resource->mem_type == TTM_PL_VRAM) {
+		int xcp = amdgpu_bo_get_xcp(bo);
+
 		atomic64_sub(amdgpu_bo_size(bo), &adev->vram_pin_size);
+		if (xcp >= 0) {
+			atomic64_sub(amdgpu_bo_size(bo),
+				     &adev->vram_pin_size_xcp[xcp]);
+		} else {
+			atomic64_sub(amdgpu_bo_size(bo),
+				     &adev->vram_pin_size_common);
+		}
+		amdgpu_amdkfd_account_vram_unpin(bo, xcp);
 		atomic64_sub(amdgpu_vram_mgr_bo_visible_size(bo),
 			     &adev->visible_pin_size);
 	} else if (bo->tbo.resource->mem_type == TTM_PL_TT) {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 3831451240e97..cad60ccdb2166 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1110,11 +1110,19 @@ static int kfd_ioctl_get_available_memory(struct file *filep,
 {
 	struct kfd_ioctl_get_available_memory_args *args = data;
 	struct kfd_process_device *pdd = kfd_lock_pdd_by_id(p, args->gpu_id);
+	struct amdgpu_device *adev;
+	size_t available;
 
 	if (!pdd)
 		return -EINVAL;
-	args->available = amdgpu_amdkfd_get_available_memory(pdd->dev->adev,
-							pdd->dev->node_id);
+
+	adev = pdd->dev->adev;
+	available = amdgpu_amdkfd_get_available_memory(adev, pdd->dev->node_id);
+	if (adev->apu_prefer_gtt)
+		args->available = ALIGN_DOWN(available, PAGE_SIZE);
+	else
+		args->available = ALIGN_DOWN(available, VRAM_AVAILABLITY_ALIGN);
+
 	kfd_unlock_pdd(pdd);
 	return 0;
 }
-- 
2.53.0



