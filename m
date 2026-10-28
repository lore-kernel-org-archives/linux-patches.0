Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215315;
	b=K2LlNVDw5qSGsUar49KTiu1jkkKmfW8xPtBdfASyIjTywrasmodyyjpdA3f09WO1k7BT
	 v7NIaU8az9fkSiP5vONzpDGZhnCwI8kZSZGUQb9fBisISHX3KPGdD/craNNmYeywoXZvB
	 8lgH3y9q+A2HE5nL0tds8HCDb4PHu1MvauHT4YxLm8gWN4CXzWJ4nR8AtAuh4s6bOM+6R
	 ZO3diQr+ZJNxZqULi/135iss/545Wzo9nmSzWltJw4DlqVycrlIMqTCp/71UXrgQbhxu1
	 ZODPM2guHjtB1/vXbmGkEjRSbPygqRQmdKjI8ZPTp30WQvZ2FJkVz2BXDUZHtvHjb+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QZIucYxTbo+3q0Tdbn8GLA6lAelNJPJDdZ+CRjncM1U=;
	b=4GFXqkOhEF+ayGQfsUIV0i8QddYwtiuzxBTMQxQkcGPmxxQbXykofXl7CP9a2zGK0UU/
	 Oz9JhOxNO5vkQOnAQPF0ZkSYI02AMk8wcP7YpGXNhxPjAjYC6n0FuFsm0KvcSwbJmowa6
	 ZvM0sKPnsHzZayrNjC07byfqiMXwkJp7QhIP+AgWPZxTAtp7WeJ1ylodxmL3I2/uxsiIb
	 wK1xufTNQ6JyRYwZQfAy/EfD+LCqOFZL9gqfWEkJ7AxJ+2Cw4n/sN0P3J1QbKK1atvPfu
	 up0yR/FT/B/xOKVAVs28HaOhwoBMu4g+SwIwbUrDmHboSXZDAbyXMu/bpk6X6CxxfKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QL5DqW36;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FDF606A31D;
	Wed, 28 Oct 2026 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QL5DqW36
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55501F01828;
	Wed, 28 Oct 2026 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215315;
	bh=QZIucYxTbo+3q0Tdbn8GLA6lAelNJPJDdZ+CRjncM1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QL5DqW36PWOxdKWEuOJhMC8/gl/KQ+7QrqS0mKijuAE47qFiBqrRka/36TD+WLF02
	 VLUm6p33S+SXm2D1+e2IYHhGchrHw9F9U/taqGJv3Plnc5Jz3qg91CkXkxGZm1NXUK
	 y3QLJ1jv1vLC3drv0LDv7sPgIicT+R9ECuqdB7sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1167/1887] drm/amd/amdgpu: Fix errors & warnings in amdgpu _bios, _cs, _dma_buf, _fence.c
Date: Wed, 28 Oct 2026 17:54:23 +0100
Message-ID: <20261028170525.959816162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 9e690184586bfb88efa176cdf912414f6c53519c ]

The following checkpatch errors & warning is removed.

ERROR: else should follow close brace '}'
ERROR: trailing statements should be on next line
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Possible repeated word: 'Fences'
WARNING: Missing a blank line after declarations
WARNING: braces {} are not necessary for single statement blocks
WARNING: Comparisons should place the constant on the right side of the test
WARNING: printk() should include KERN_<LEVEL> facility level

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 65bff2661760 ("drm/amdgpu: Release VFCT ACPI table reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c    | 16 +++++++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c      | 16 ++++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c   | 14 ++++++++------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index d57fa0aee358b..2a313964f63df 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -105,9 +105,8 @@ static bool igp_read_bios_from_vram(struct amdgpu_device *adev)
 	adev->bios = NULL;
 	vram_base = pci_resource_start(adev->pdev, 0);
 	bios = ioremap_wc(vram_base, size);
-	if (!bios) {
+	if (!bios)
 		return false;
-	}
 
 	adev->bios = kmalloc(size, GFP_KERNEL);
 	if (!adev->bios) {
@@ -134,9 +133,8 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	adev->bios = NULL;
 	/* XXX: some cards may return 0 for rom size? ddx has a workaround */
 	bios = pci_map_rom(adev->pdev, &size);
-	if (!bios) {
+	if (!bios)
 		return false;
-	}
 
 	adev->bios = kzalloc(size, GFP_KERNEL);
 	if (adev->bios == NULL) {
@@ -169,9 +167,9 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	header[AMD_VBIOS_SIGNATURE_END] = 0;
 
 	if ((!AMD_IS_VALID_VBIOS(header)) ||
-	    0 != memcmp((char *)&header[AMD_VBIOS_SIGNATURE_OFFSET],
-			AMD_VBIOS_SIGNATURE,
-			strlen(AMD_VBIOS_SIGNATURE)))
+		memcmp((char *)&header[AMD_VBIOS_SIGNATURE_OFFSET],
+		       AMD_VBIOS_SIGNATURE,
+		       strlen(AMD_VBIOS_SIGNATURE)) != 0)
 		return false;
 
 	/* valid vbios, go on */
@@ -265,7 +263,7 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 
 	status = acpi_evaluate_object(atrm_handle, NULL, &atrm_arg, &buffer);
 	if (ACPI_FAILURE(status)) {
-		printk("failed to evaluate ATRM got %s\n", acpi_format_exception(status));
+		DRM_ERROR("failed to evaluate ATRM got %s\n", acpi_format_exception(status));
 		return -ENODEV;
 	}
 
@@ -407,7 +405,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 	struct acpi_table_header *hdr;
 	acpi_size tbl_size;
 	UEFI_ACPI_VFCT *vfct;
-	unsigned offset;
+	unsigned int offset;
 
 	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
 		return false;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index e9d51002001a4..e63a71506871d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -384,7 +384,7 @@ static int amdgpu_cs_p2_dependencies(struct amdgpu_cs_parser *p,
 {
 	struct drm_amdgpu_cs_chunk_dep *deps = chunk->kdata;
 	struct amdgpu_fpriv *fpriv = p->filp->driver_priv;
-	unsigned num_deps;
+	unsigned int num_deps;
 	int i, r;
 
 	num_deps = chunk->length_dw * 4 /
@@ -456,7 +456,7 @@ static int amdgpu_cs_p2_syncobj_in(struct amdgpu_cs_parser *p,
 				   struct amdgpu_cs_chunk *chunk)
 {
 	struct drm_amdgpu_cs_chunk_sem *deps = chunk->kdata;
-	unsigned num_deps;
+	unsigned int num_deps;
 	int i, r;
 
 	num_deps = chunk->length_dw * 4 /
@@ -474,7 +474,7 @@ static int amdgpu_cs_p2_syncobj_timeline_wait(struct amdgpu_cs_parser *p,
 					      struct amdgpu_cs_chunk *chunk)
 {
 	struct drm_amdgpu_cs_chunk_syncobj *syncobj_deps = chunk->kdata;
-	unsigned num_deps;
+	unsigned int num_deps;
 	int i, r;
 
 	num_deps = chunk->length_dw * 4 /
@@ -494,7 +494,7 @@ static int amdgpu_cs_p2_syncobj_out(struct amdgpu_cs_parser *p,
 				    struct amdgpu_cs_chunk *chunk)
 {
 	struct drm_amdgpu_cs_chunk_sem *deps = chunk->kdata;
-	unsigned num_deps;
+	unsigned int num_deps;
 	int i;
 
 	num_deps = chunk->length_dw * 4 /
@@ -528,7 +528,7 @@ static int amdgpu_cs_p2_syncobj_timeline_signal(struct amdgpu_cs_parser *p,
 						struct amdgpu_cs_chunk *chunk)
 {
 	struct drm_amdgpu_cs_chunk_syncobj *syncobj_deps = chunk->kdata;
-	unsigned num_deps;
+	unsigned int num_deps;
 	int i;
 
 	num_deps = chunk->length_dw * 4 /
@@ -721,6 +721,7 @@ static void amdgpu_cs_get_threshold_for_moves(struct amdgpu_device *adev,
 
 		if (used_vis_vram < total_vis_vram) {
 			u64 free_vis_vram = total_vis_vram - used_vis_vram;
+
 			adev->mm_stats.accum_us_vis = min(adev->mm_stats.accum_us_vis +
 							  increment_us, us_upper_bound);
 
@@ -1043,9 +1044,8 @@ static int amdgpu_cs_patch_ibs(struct amdgpu_cs_parser *p,
 
 		/* the IB should be reserved at this point */
 		r = amdgpu_bo_kmap(aobj, (void **)&kptr);
-		if (r) {
+		if (r)
 			return r;
-		}
 
 		kptr += va_start - (m->start * AMDGPU_GPU_PAGE_SIZE);
 
@@ -1318,7 +1318,7 @@ static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser)
 {
 	struct amdgpu_device *adev = parser->adev;
 	struct amdgpu_bo_list_entry *e;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < parser->num_post_deps; i++) {
 		drm_syncobj_put(parser->post_deps[i].syncobj);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 4dcc7de961d08..533a283c5e58f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -173,7 +173,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 	if (!bo->tbo.pin_count) {
 		/* move buffer into GTT or VRAM */
 		struct ttm_operation_ctx ctx = { false, false };
-		unsigned domains = AMDGPU_GEM_DOMAIN_GTT;
+		unsigned int domains = AMDGPU_GEM_DOMAIN_GTT;
 
 		if (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM &&
 		    attach->peer2peer) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 418e4c77ceb80..c16c7f6517e6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -42,7 +42,6 @@
 #include "amdgpu_reset.h"
 
 /*
- * Fences
  * Fences mark an event in the GPUs pipeline and are used
  * for GPU/CPU synchronization.  When the fence is written,
  * it is expected that all buffers associated with that fence
@@ -139,7 +138,7 @@ static u32 amdgpu_fence_read(struct amdgpu_ring *ring)
  * Returns 0 on success, -ENOMEM on failure.
  */
 int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **f, struct amdgpu_job *job,
-		      unsigned flags)
+		      unsigned int flags)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct dma_fence *fence;
@@ -173,11 +172,11 @@ int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **f, struct amd
 				       adev->fence_context + ring->idx, seq);
 			/* Against remove in amdgpu_job_{free, free_cb} */
 			dma_fence_get(fence);
-		}
-		else
+		} else {
 			dma_fence_init(fence, &amdgpu_fence_ops,
 				       &ring->fence_drv.lock,
 				       adev->fence_context + ring->idx, seq);
+		}
 	}
 
 	amdgpu_ring_emit_fence(ring, ring->fence_drv.gpu_addr,
@@ -393,7 +392,7 @@ signed long amdgpu_fence_wait_polling(struct amdgpu_ring *ring,
  * Returns the number of emitted fences on the ring.  Used by the
  * dynpm code to ring track activity.
  */
-unsigned amdgpu_fence_count_emitted(struct amdgpu_ring *ring)
+unsigned int amdgpu_fence_count_emitted(struct amdgpu_ring *ring)
 {
 	uint64_t emitted;
 
@@ -421,7 +420,7 @@ unsigned amdgpu_fence_count_emitted(struct amdgpu_ring *ring)
  */
 int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 				   struct amdgpu_irq_src *irq_src,
-				   unsigned irq_type)
+				   unsigned int irq_type)
 {
 	struct amdgpu_device *adev = ring->adev;
 	uint64_t index;
@@ -636,6 +635,7 @@ void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev)
 
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
 		struct amdgpu_ring *ring = adev->rings[i];
+
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
@@ -824,6 +824,7 @@ static int amdgpu_debugfs_fence_info_show(struct seq_file *m, void *unused)
 
 	for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
 		struct amdgpu_ring *ring = adev->rings[i];
+
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
@@ -897,6 +898,7 @@ static void amdgpu_debugfs_reset_work(struct work_struct *work)
 						  reset_work);
 
 	struct amdgpu_reset_context reset_context;
+
 	memset(&reset_context, 0, sizeof(reset_context));
 
 	reset_context.method = AMD_RESET_METHOD_NONE;
-- 
2.53.0



