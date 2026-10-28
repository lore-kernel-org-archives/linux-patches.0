Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207784;
	b=Rg4IHlgHDKM4PO2Znvph2o8MtozR1756egWa22fuDL/waLD2njdgTwq1SIUa7bQFJnv0
	 vzaoGLbFXUO9VaHC+gRc40yy763Ulp95j7rpRBuKvy9nzYMJJ9Jxl/J6hzu0DRFN/NTPg
	 kjkeu1jIwQDzZt8lC38v0gzuESpl/bMFgNyXOB5P7xtu7aowRXaaQg8wgCvdrb6jDL2cZ
	 QCsqJ462zhV0yYH30jHvOiTbE4ei07kfP5Bhy/71kB/Yenooi1Ptp4mXeE16+8Lc4Na5f
	 0E8QEEkHjeHdPnVRlQ9skpGel64ITkGFmtWMt+7e4VhfQOp6RjrJfnNFakj0i9A/m9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3CaoHUj/sUYYGotAInuBmRc+XZyBzxtHWVDenI5vMaQ=;
	b=la2Ar1z7TkdvuG3X22+DjGBpBTmjS5Gz+/LK7kWtvE+pT4Y78G2qQyXC7KyNOZisTzCR
	 JWSGH3bdK7bLaSRhMQHGIaOvkff+/bqxW66C034o2UhNn2NAdQ0i0Je9NXUlfjMJuIvo8
	 FP8K87QRUAmMgOVxeHl5qfpPLgWokasXaC7kuZyRZY/pCYvjpyhM3gzqYrGNYbpgf0rQr
	 Rk0MANV/ETR++iQ5+8I6eZ3EY5dxniYquHOcoA7PxP4ya43XBG+fruZsSTZu3iQC1oHmO
	 akoo6SEnRTZNAH6P2YRoAip0d7Dlv9ynZ7XjLzBVqjbJPwI7Bq+YEEhGmXhjXPkqopg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hue0sjAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C707606A330;
	Wed, 28 Oct 2026 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hue0sjAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB2D1F031E3;
	Wed, 28 Oct 2026 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207784;
	bh=3CaoHUj/sUYYGotAInuBmRc+XZyBzxtHWVDenI5vMaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hue0sjARgX70omGX0IzVXt4EOhZV27dF/TWQmEzpEnpa8aLtghmX9Gktt3kM4v2cT
	 gGGq5x70+Xha9AEk7fE9o8sWzyT0zG/HbgSp5OPYVzoV5/snKOLE1pYxKevjD/7jlc
	 jOvxo7nhNgBrLfvwAU7qGCrNIk+giHQMk2LwMoiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/247] drm/xe: Bump LRU for external objects on exec and rebind
Date: Wed, 28 Oct 2026 17:59:02 +0100
Message-ID: <20261028165950.699461845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit d2ce8fcd778ee6d92748c92d23a56d4416c29d86 ]

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
[ sashal: Adjusted header context to accommodate missing xe_vm_bind_kernel_bo() and xe_vm_resume_rebind_worker() declarations. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec.c |  7 ++-----
 drivers/gpu/drm/xe/xe_vm.c   | 31 ++++++++++++++++++++++++++++---
 drivers/gpu/drm/xe/xe_vm.h   |  2 ++
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec.c b/drivers/gpu/drm/xe/xe_exec.c
index 04a88c16d8358..03af3704ee68d 100644
--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -330,11 +330,8 @@ int xe_exec_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
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
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index da148df421057..d53cb4e625172 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -439,6 +439,33 @@ int xe_vm_validate_rebind(struct xe_vm *vm, struct drm_exec *exec,
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
@@ -552,9 +579,7 @@ static void preempt_rebind_work_func(struct work_struct *w)
 
 #undef retry_required
 
-	spin_lock(&vm->xe->ttm.lru_lock);
-	ttm_lru_bulk_move_tail(&vm->lru_bulk_move);
-	spin_unlock(&vm->xe->ttm.lru_lock);
+	xe_vm_bump_lru(vm, &exec);
 
 	/* Point of no return. */
 	arm_preempt_fences(vm, &preempt_fences);
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index d2406532fcc50..b0a864618eccc 100644
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -248,6 +248,8 @@ int xe_vm_lock_vma(struct drm_exec *exec, struct xe_vma *vma);
 int xe_vm_validate_rebind(struct xe_vm *vm, struct drm_exec *exec,
 			  unsigned int num_fences);
 
+void xe_vm_bump_lru(struct xe_vm *vm, struct drm_exec *exec);
+
 /**
  * xe_vm_resv() - Return's the vm's reservation object
  * @vm: The vm
-- 
2.53.0



