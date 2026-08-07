Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831AA42C4E9;
	Fri,  7 Aug 2026 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114657; cv=none; b=qQLW/xbYpExSVTUS/4DAKqO/7vNtIA7Ya1fyygMfDSkGUNBjvIqsJFMPs7iRGVc9h2IYn27LYSissPX14zNX6nVtqNO3il+L0vMAGrOH7cexqdMORxhOKFmTkirig7M6Hr3hX7E71oBEf8U/xbzU4DPhgjns2ETqwBG+g7RxD24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114657; c=relaxed/simple;
	bh=v1jDSiEEBoC11Kh/TC0cc8hRQKrMmpmD7FLMiy/4v5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiGO8iqZsMTiioJTnJxAjfIrIkbVy83e/vcqjapxFFqP2ik54HR0PLJMjucyof1MRN0mk34/SSU5WpitCxTwXkx0NqGDHuVM8MJDRv2T/fQI4/pVHb8vvrPO0uQshzNnxrVzm01AsR7DN50c7GsGvMiNCeOc2cKg8DwOvUpBACg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6olRZBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6olRZBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE4D1F000E9;
	Fri,  7 Aug 2026 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114656;
	bh=GluO16Xn36NrLhLjg48RgB7CGWuSVmsWLlaveoTtijI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6olRZBwkjaKa03O3K+aeRfH6cfh8cT5IsMrHqpYGOnrnnSX7eB6S1w2kpuiMpgyT
	 YfZKoRwphhHNbVw736z+Ux+ixZwwrHwOKlYWC4qnwFlnoT8+5ycVwyd0RNV9+Jb8zl
	 jnXRwO50icg49yKwNILuwSlBfher6OWLJhvvryCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/337] drm/exec: Remove the index parameter from drm_exec_for_each_locked_obj[_reverse]
Date: Fri,  7 Aug 2026 16:38:39 +0200
Message-ID: <20260807143425.379571307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit ce44b78512e9102aea54ff6b6e521d6c8de9f31c ]

Nobody makes any use of it. Possible internal future users can
instead use the _index variable. External users shouldn't use
it since the array it's pointing into is internal drm_exec state.

v2:
- Use a unique id for the loop variable (Christian)

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patch.msgid.link/20260520101616.41284-2-thomas.hellstrom@linux.intel.com
Stable-dep-of: af80e2bfde93 ("drm/xe: Wait on external BO kernel fences in exec IOCTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    9 +++------
 drivers/gpu/drm/drm_exec.c             |    6 ++----
 drivers/gpu/drm/drm_gpuvm.c            |    3 +--
 drivers/gpu/drm/xe/xe_vm.c             |    3 +--
 include/drm/drm_exec.h                 |   20 ++++++++++++--------
 5 files changed, 19 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -848,7 +848,6 @@ static int amdgpu_cs_parser_bos(struct a
 	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	struct drm_gem_object *obj;
-	unsigned long index;
 	unsigned int i;
 	int r;
 
@@ -969,7 +968,7 @@ static int amdgpu_cs_parser_bos(struct a
 		goto out_free_user_pages;
 	}
 
-	drm_exec_for_each_locked_object(&p->exec, index, obj) {
+	drm_exec_for_each_locked_object(&p->exec, obj) {
 		r = amdgpu_cs_bo_validate(p, gem_to_amdgpu_bo(obj));
 		if (unlikely(r))
 			goto out_free_user_pages;
@@ -1207,7 +1206,6 @@ static int amdgpu_cs_sync_rings(struct a
 	struct drm_gpu_scheduler *sched;
 	struct drm_gem_object *obj;
 	struct dma_fence *fence;
-	unsigned long index;
 	unsigned int i;
 	int r;
 
@@ -1218,7 +1216,7 @@ static int amdgpu_cs_sync_rings(struct a
 		return r;
 	}
 
-	drm_exec_for_each_locked_object(&p->exec, index, obj) {
+	drm_exec_for_each_locked_object(&p->exec, obj) {
 		struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 
 		struct dma_resv *resv = bo->tbo.base.resv;
@@ -1286,7 +1284,6 @@ static int amdgpu_cs_submit(struct amdgp
 	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	struct drm_gem_object *gobj;
-	unsigned long index;
 	unsigned int i;
 	uint64_t seq;
 	int r;
@@ -1337,7 +1334,7 @@ static int amdgpu_cs_submit(struct amdgp
 	}
 
 	p->fence = dma_fence_get(&leader->base.s_fence->finished);
-	drm_exec_for_each_locked_object(&p->exec, index, gobj) {
+	drm_exec_for_each_locked_object(&p->exec, gobj) {
 
 		ttm_bo_move_to_lru_tail_unlocked(&gem_to_amdgpu_bo(gobj)->tbo);
 
--- a/drivers/gpu/drm/drm_exec.c
+++ b/drivers/gpu/drm/drm_exec.c
@@ -22,7 +22,6 @@
  *
  *	struct drm_gem_object *obj;
  *	struct drm_exec exec;
- *	unsigned long index;
  *	int ret;
  *
  *	drm_exec_init(&exec, DRM_EXEC_INTERRUPTIBLE_WAIT);
@@ -38,7 +37,7 @@
  *			goto error;
  *	}
  *
- *	drm_exec_for_each_locked_object(&exec, index, obj) {
+ *	drm_exec_for_each_locked_object(&exec, obj) {
  *		dma_resv_add_fence(obj->resv, fence, DMA_RESV_USAGE_READ);
  *		...
  *	}
@@ -54,9 +53,8 @@
 static void drm_exec_unlock_all(struct drm_exec *exec)
 {
 	struct drm_gem_object *obj;
-	unsigned long index;
 
-	drm_exec_for_each_locked_object_reverse(exec, index, obj) {
+	drm_exec_for_each_locked_object_reverse(exec, obj) {
 		dma_resv_unlock(obj->resv);
 		drm_gem_object_put(obj);
 	}
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -1451,9 +1451,8 @@ drm_gpuvm_resv_add_fence(struct drm_gpuv
 			 enum dma_resv_usage extobj_usage)
 {
 	struct drm_gem_object *obj;
-	unsigned long index;
 
-	drm_exec_for_each_locked_object(exec, index, obj) {
+	drm_exec_for_each_locked_object(exec, obj) {
 		dma_resv_assert_held(obj->resv);
 		dma_resv_add_fence(obj->resv, fence,
 				   drm_gpuvm_is_extobj(gpuvm, obj) ?
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -418,7 +418,6 @@ int xe_vm_validate_rebind(struct xe_vm *
 			  unsigned int num_fences)
 {
 	struct drm_gem_object *obj;
-	unsigned long index;
 	int ret;
 
 	do {
@@ -431,7 +430,7 @@ int xe_vm_validate_rebind(struct xe_vm *
 			return ret;
 	} while (!list_empty(&vm->gpuvm.evict.list));
 
-	drm_exec_for_each_locked_object(exec, index, obj) {
+	drm_exec_for_each_locked_object(exec, obj) {
 		ret = dma_resv_reserve_fences(obj->resv, num_fences);
 		if (ret)
 			return ret;
--- a/include/drm/drm_exec.h
+++ b/include/drm/drm_exec.h
@@ -65,31 +65,35 @@ drm_exec_obj(struct drm_exec *exec, unsi
 	return index < exec->num_objects ? exec->objects[index] : NULL;
 }
 
+/* Helper for drm_exec_for_each_locked_object(). Internal use only. */
+#define __drm_exec_for_each_locked_object(exec, obj, __index)		\
+	for (unsigned long __index = 0; ((obj) = drm_exec_obj(exec, __index)); ++__index)
 /**
  * drm_exec_for_each_locked_object - iterate over all the locked objects
  * @exec: drm_exec object
- * @index: unsigned long index for the iteration
  * @obj: the current GEM object
  *
  * Iterate over all the locked GEM objects inside the drm_exec object.
  */
-#define drm_exec_for_each_locked_object(exec, index, obj)		\
-	for ((index) = 0; ((obj) = drm_exec_obj(exec, index)); ++(index))
+#define drm_exec_for_each_locked_object(exec, obj)			\
+	__drm_exec_for_each_locked_object(exec, obj, __UNIQUE_ID(drm_exec))
 
+/* Helper for drm_exec_for_each_locked_object_reverse(). Internal use only. */
+#define __drm_exec_for_each_locked_object_reverse(exec, obj, __index)	\
+	for (unsigned long __index = (exec)->num_objects - 1;		\
+	     ((obj) = drm_exec_obj(exec, __index)); --__index)
 /**
  * drm_exec_for_each_locked_object_reverse - iterate over all the locked
  * objects in reverse locking order
  * @exec: drm_exec object
- * @index: unsigned long index for the iteration
  * @obj: the current GEM object
  *
  * Iterate over all the locked GEM objects inside the drm_exec object in
- * reverse locking order. Note that @index may go below zero and wrap,
+ * reverse locking order. Note that the internal index may wrap around,
  * but that will be caught by drm_exec_obj(), returning a NULL object.
  */
-#define drm_exec_for_each_locked_object_reverse(exec, index, obj)	\
-	for ((index) = (exec)->num_objects - 1;				\
-	     ((obj) = drm_exec_obj(exec, index)); --(index))
+#define drm_exec_for_each_locked_object_reverse(exec, obj)		\
+	__drm_exec_for_each_locked_object_reverse(exec, obj, __UNIQUE_ID(drm_exec))
 
 /**
  * drm_exec_until_all_locked - loop until all GEM objects are locked


