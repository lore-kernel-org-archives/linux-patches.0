Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774805;
	b=SHtU1tx0AvyzXP5d5oOB9f2Nh5bLHUXfGuSujXQ7wInQOt3XMvM+ZQwn9l6bChO/n71R
	 X4hLUszaJRb26wpvE02auLWOGVcx9zv6jpP4kmChXhFObzmBLcNDeC4kzAsvwanAI3YXL
	 9CcLU90CsDM8j00+1NZKdUej4wBOr41e9j+QEQT/LQZQ0al69k6VQFhvxvbGCVgl8vJjR
	 NZJR0A1cc0Rvlqx3f1MmddMoKj74UlvTr7zbRAkCbGnpYBEy2ZhSgww9K2FBeAKUoaVoS
	 HRBaqBieGZHjCmvvn83ibIrPSmOb/h1QaKnpP3Lv6OzCGqG8X6SzupxKj9XF+oSnGWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/lmxHTE21W5zmoyp3jZTt8DzJx0jl19rLdXeNkXrEiE=;
	b=oyBkDMDRaGx5KKgiBhQ7m4o7kbF11LJ/zC5tRuo9mbtFJr+6uIpKSK6bV+ntuweyBBEJ
	 USByRfydYckmFs7G9ZTlxFun5wvLosVfNwKjQC64o47lOPRSRMEMvPHNLpiVbQhHGc/3i
	 i6oPCKzwX1bgp4ABCl4M17pnu3H5tEWVGF3fBaWZSWrnQZti6QR3NDVkZdIryYZICSd/y
	 +QwGWxUunGTk9dSgztZf84ans/Jo6JpNUFZgWDf7RWsw3g+01n46dbBODntxaVlpkroDL
	 riqUeJn3zPZ5IdCW4Pl7gcrlXQQYh0HHydCwlHArlmipV/5VFyMesTk1JgJeTpd2qdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iicajFDP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E9A606A31D;
	Fri, 23 Oct 2026 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iicajFDP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056EF1F01825;
	Fri, 23 Oct 2026 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774804;
	bh=/lmxHTE21W5zmoyp3jZTt8DzJx0jl19rLdXeNkXrEiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iicajFDP1GM2Xa1PJgCF7R+8myHs3D0lUnyeIPBitGYpjDKYbv5+RCr/0VkvutC+I
	 J7aHYVdpnXWVXukwvT80Vo8prOfBg82jJpI1xJqm2bRPhKw/mk+4tVjO+7CqEDR2WI
	 7B3xeYWroymmexEgTu7A6F3XtDE516eBmneOMcho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.2 163/242] drm/xe: Bump LRU for external objects on exec and rebind
Date: Fri, 23 Oct 2026 18:40:05 +0200
Message-ID: <20261023163717.639786580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit d2ce8fcd778ee6d92748c92d23a56d4416c29d86 upstream.

The VM's private BOs get their LRU position refreshed in bulk via
ttm_lru_bulk_move_tail() on vm->lru_bulk_move, both after a successful
non-LR exec and after the LR preempt-fence rebind worker runs. External
objects (BOs potentially shared across VMs) are never added to that
per-VM bulk move list, so their LRU position is never refreshed by
either path. This makes external objects in active use look more
evictable than they are.

Add xe_vm_bump_lru(), which, under a single lru_lock critical section,
performs the bulk move of the VM's private BOs and bumps each external
object locked by the drm_exec transaction. Use it from both the non-LR
exec path and the LR rebind worker, replacing the open-coded bulk move.

Fixes: d490ecf57790 ("drm/xe: Rework xe_exec and the VM rebind worker to use the drm_exec helper")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Assisted-by: LLM
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20261012132607.21387-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 324ba30cca180c2e1d02090743dd78ccb15b9e4a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_exec.c |    7 ++-----
 drivers/gpu/drm/xe/xe_vm.c   |   31 ++++++++++++++++++++++++++++---
 drivers/gpu/drm/xe/xe_vm.h   |    2 ++
 3 files changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -346,11 +346,8 @@ retry:
 	xe_sched_job_push(job);
 	xe_vm_reactivate_rebind(vm);
 
-	if (!err && !xe_vm_in_lr_mode(vm)) {
-		spin_lock(&xe->ttm.lru_lock);
-		ttm_lru_bulk_move_tail(&vm->lru_bulk_move);
-		spin_unlock(&xe->ttm.lru_lock);
-	}
+	if (!err && !xe_vm_in_lr_mode(vm))
+		xe_vm_bump_lru(vm, exec);
 
 	if (mode == EXEC_MODE_LR)
 		xe_hw_engine_group_resume_faulting_lr_jobs(group);
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -394,6 +394,33 @@ int xe_vm_validate_rebind(struct xe_vm *
 	return 0;
 }
 
+/**
+ * xe_vm_bump_lru() - Bump the LRU position of BOs used by a submission
+ * @vm: The vm for which we are bumping LRUs.
+ * @exec: The struct drm_exec with the locked GEM objects.
+ *
+ * Move the VM's private BOs, and all external objects locked by @exec,
+ * to the LRU tail. Private BOs are moved in bulk using @vm's
+ * &xe_vm.lru_bulk_move. External objects, which may be shared with other
+ * VMs, are not part of that bulk move and are bumped individually.
+ */
+void xe_vm_bump_lru(struct xe_vm *vm, struct drm_exec *exec)
+{
+	spinlock_t *lru_lock = &vm->xe->ttm.lru_lock;
+	struct drm_gem_object *obj;
+
+	spin_lock(lru_lock);
+	ttm_lru_bulk_move_tail(&vm->lru_bulk_move);
+	drm_exec_for_each_locked_object(exec, obj) {
+		if (!drm_gpuvm_is_extobj(&vm->gpuvm, obj))
+			continue;
+
+		ttm_bo_move_to_lru_tail(&gem_to_xe_bo(obj)->ttm);
+		cond_resched_lock(lru_lock);
+	}
+	spin_unlock(lru_lock);
+}
+
 static int xe_preempt_work_begin(struct drm_exec *exec, struct xe_vm *vm,
 				 bool *done)
 {
@@ -544,9 +571,7 @@ retry:
 
 #undef retry_required
 
-	spin_lock(&vm->xe->ttm.lru_lock);
-	ttm_lru_bulk_move_tail(&vm->lru_bulk_move);
-	spin_unlock(&vm->xe->ttm.lru_lock);
+	xe_vm_bump_lru(vm, &exec);
 
 	/* Point of no return. */
 	arm_preempt_fences(vm, &preempt_fences);
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -284,6 +284,8 @@ int xe_vm_lock_vma(struct drm_exec *exec
 int xe_vm_validate_rebind(struct xe_vm *vm, struct drm_exec *exec,
 			  unsigned int num_fences);
 
+void xe_vm_bump_lru(struct xe_vm *vm, struct drm_exec *exec);
+
 struct dma_fence *xe_vm_bind_kernel_bo(struct xe_vm *vm, struct xe_bo *bo,
 				       struct xe_exec_queue *q, u64 addr,
 				       enum xe_cache_level cache_lvl);


