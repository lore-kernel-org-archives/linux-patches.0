Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1E918E02A;
	Fri,  7 Aug 2026 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115765; cv=none; b=paNTxc8KP43cpTwE7R4LPfciS/SUCeZfMhHwxUivmgEu8AgIRArR3dJhXKlZ6pA7oX12lqmxqjDcrqPoVvMt6yW7fz3Im29S1fdngALBUTc085jM2ieixDT1w/1v4KcL2zoTRVQTmtfV9tuHXsl5tJWx36zEWXIa/6z/VBWqdVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115765; c=relaxed/simple;
	bh=JfQRqN57pwbpNgC7cjua3RJ5lhiEWFn/izCJVxnIpGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OryMRRTXQvGb9tnkws2oZv3fbaG9J9L/eAI0m1M3GwWw0muK0budb/BC/3l1LLCk8IIO6v4SMGZ2mGUpYErHONFuhHNJLslQEOWmSuR9CcjJU0Xbod/x0P6IgL1K2TXaYnkW1Y3EAj7nExCKuhKq8jMpaCycU9ITINZKhCdbVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOE8rJQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOE8rJQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659D31F000E9;
	Fri,  7 Aug 2026 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115763;
	bh=dYWLxHyc52Q5Ah28kMbKqi1Bzr6BtEL3byW6bzMx7XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOE8rJQZwa5+KTNgtPbTOMOzmXyUoUz/NObkjw9w5L2BFuKr2xrSzcIOXAE8BddKk
	 1zBrMN5o/g7ztaJDWd+5RQkDn+N5OYAebQGS5YXAIJI0SNAC/5NDOYNRXcCC4KK5kh
	 0tuSYleFdsM1yOb/ALi/pV4Qhv94ixWqs5BADP2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/396] drm/exec: Remove the index parameter from drm_exec_for_each_locked_obj[_reverse]
Date: Fri,  7 Aug 2026 16:39:04 +0200
Message-ID: <20260807143432.561298855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    9 +++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c |    3 +--
 drivers/gpu/drm/drm_exec.c                         |    6 ++----
 drivers/gpu/drm/drm_gpuvm.c                        |    3 +--
 drivers/gpu/drm/xe/xe_vm.c                         |    3 +--
 include/drm/drm_exec.h                             |   20 ++++++++++++--------
 6 files changed, 20 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -864,7 +864,6 @@ static int amdgpu_cs_parser_bos(struct a
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
@@ -1196,7 +1195,6 @@ static int amdgpu_cs_sync_rings(struct a
 	struct drm_gpu_scheduler *sched;
 	struct drm_gem_object *obj;
 	struct dma_fence *fence;
-	unsigned long index;
 	unsigned int i;
 	int r;
 
@@ -1207,7 +1205,7 @@ static int amdgpu_cs_sync_rings(struct a
 		return r;
 	}
 
-	drm_exec_for_each_locked_object(&p->exec, index, obj) {
+	drm_exec_for_each_locked_object(&p->exec, obj) {
 		struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 
 		struct dma_resv *resv = bo->tbo.base.resv;
@@ -1276,7 +1274,6 @@ static int amdgpu_cs_submit(struct amdgp
 	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	struct drm_gem_object *gobj;
-	unsigned long index;
 	unsigned int i;
 	uint64_t seq;
 	int r;
@@ -1327,7 +1324,7 @@ static int amdgpu_cs_submit(struct amdgp
 	}
 
 	p->fence = dma_fence_get(&leader->base.s_fence->finished);
-	drm_exec_for_each_locked_object(&p->exec, index, gobj) {
+	drm_exec_for_each_locked_object(&p->exec, gobj) {
 
 		ttm_bo_move_to_lru_tail_unlocked(&gem_to_amdgpu_bo(gobj)->tbo);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
@@ -49,7 +49,6 @@ amdgpu_eviction_fence_replace_fence(stru
 {
 	struct amdgpu_eviction_fence *old_ef, *new_ef;
 	struct drm_gem_object *obj;
-	unsigned long index;
 	int ret;
 
 	if (evf_mgr->ev_fence &&
@@ -77,7 +76,7 @@ amdgpu_eviction_fence_replace_fence(stru
 	spin_unlock(&evf_mgr->ev_fence_lock);
 
 	/* Attach the new fence */
-	drm_exec_for_each_locked_object(exec, index, obj) {
+	drm_exec_for_each_locked_object(exec, obj) {
 		struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 
 		if (!bo)
--- a/drivers/gpu/drm/drm_exec.c
+++ b/drivers/gpu/drm/drm_exec.c
@@ -24,7 +24,6 @@
  *
  *	struct drm_gem_object *obj;
  *	struct drm_exec exec;
- *	unsigned long index;
  *	int ret;
  *
  *	drm_exec_init(&exec, DRM_EXEC_INTERRUPTIBLE_WAIT);
@@ -40,7 +39,7 @@
  *			goto error;
  *	}
  *
- *	drm_exec_for_each_locked_object(&exec, index, obj) {
+ *	drm_exec_for_each_locked_object(&exec, obj) {
  *		dma_resv_add_fence(obj->resv, fence, DMA_RESV_USAGE_READ);
  *		...
  *	}
@@ -56,9 +55,8 @@
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
@@ -1521,9 +1521,8 @@ drm_gpuvm_resv_add_fence(struct drm_gpuv
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
@@ -355,7 +355,6 @@ int xe_vm_validate_rebind(struct xe_vm *
 			  unsigned int num_fences)
 {
 	struct drm_gem_object *obj;
-	unsigned long index;
 	int ret;
 
 	do {
@@ -368,7 +367,7 @@ int xe_vm_validate_rebind(struct xe_vm *
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


