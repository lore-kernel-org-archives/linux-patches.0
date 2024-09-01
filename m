Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E7C5381A;
	Sun,  1 Sep 2024 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208323; cv=none; b=PtjDcVnPrK3GaZkM6XD7wxuKziSgwWPqSl1tyxAncH57gEX2LXlrrNrw4+3iFvoLsJb9/7DcuHEytcVsh23n9lFsODjKnk4UElf+5Z3gLGMhpsD3oeIzf5cf7o88uZ02J6p3+6vCTcHANz6Pbu2jaGPqEUJVe85j8QJghXEEX8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208323; c=relaxed/simple;
	bh=lClPpfn5OtS/i9JLNH6SyB4RQSJk87824Oc8jqAPcO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htz5WiyKep0t3FyVwhWXuTs/Jc5OjdCcK0EvkS0J5BgRj4IIBgLKmwiselxeRyGtbOdCD5SFkEulNMYEbiOxhp1ED958TzS3Q1EcnRTHgJa+ibNMh2Mci4Tlnpm74KEL/lXr3UitrpWE6bbbdeB9DgyPt+KbUD2YJWUheTeQr3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXyaLv8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXyaLv8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A92C4CEC3;
	Sun,  1 Sep 2024 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208323;
	bh=lClPpfn5OtS/i9JLNH6SyB4RQSJk87824Oc8jqAPcO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXyaLv8/qA05b6CfbQ/fwcQ7Ll0hUfp4fowib3/3c7XJ8G5NjD7ofK1nzaexNEZL5
	 3KTaREXyKxxzyCI59+pRHjuKA0OHLlmwIabcmuk6v3SOkzJOxaw6/BBfy+rvhSm0nr
	 pqly2+j+X5wCL8wkSMuy9KTRV3b8XH4t8YhW+LGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 047/149] drm/xe/exec_queue: Rename xe_exec_queue::compute to xe_exec_queue::lr
Date: Sun,  1 Sep 2024 18:15:58 +0200
Message-ID: <20240901160819.236359939@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Dugast <francois.dugast@intel.com>

[ Upstream commit 731e46c032281601756f08cfa7d8505fe41166a9 ]

The properties of this struct are used in long running context so
make that clear by renaming it to lr, in alignment with the rest
of the code.

Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240613170348.723245-1-francois.dugast@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 730b72480e29 ("drm/xe: prevent UAF around preempt fence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c       |  6 +--
 drivers/gpu/drm/xe/xe_exec_queue_types.h | 14 +++---
 drivers/gpu/drm/xe/xe_preempt_fence.c    |  2 +-
 drivers/gpu/drm/xe/xe_vm.c               | 58 ++++++++++++------------
 4 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 2ae4420e29353..316731c5cce6d 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -67,7 +67,7 @@ static struct xe_exec_queue *__xe_exec_queue_alloc(struct xe_device *xe,
 	q->fence_irq = &gt->fence_irq[hwe->class];
 	q->ring_ops = gt->ring_ops[hwe->class];
 	q->ops = gt->exec_queue_ops;
-	INIT_LIST_HEAD(&q->compute.link);
+	INIT_LIST_HEAD(&q->lr.link);
 	INIT_LIST_HEAD(&q->multi_gt_link);
 
 	q->sched_props.timeslice_us = hwe->eclass->sched_props.timeslice_us;
@@ -631,8 +631,8 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 			return PTR_ERR(q);
 
 		if (xe_vm_in_preempt_fence_mode(vm)) {
-			q->compute.context = dma_fence_context_alloc(1);
-			spin_lock_init(&q->compute.lock);
+			q->lr.context = dma_fence_context_alloc(1);
+			spin_lock_init(&q->lr.lock);
 
 			err = xe_vm_add_compute_exec_queue(vm, q);
 			if (XE_IOCTL_DBG(xe, err))
diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index f0c40e8ad80a1..52a1965d91375 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -115,19 +115,19 @@ struct xe_exec_queue {
 		enum xe_exec_queue_priority priority;
 	} sched_props;
 
-	/** @compute: compute exec queue state */
+	/** @lr: long-running exec queue state */
 	struct {
-		/** @compute.pfence: preemption fence */
+		/** @lr.pfence: preemption fence */
 		struct dma_fence *pfence;
-		/** @compute.context: preemption fence context */
+		/** @lr.context: preemption fence context */
 		u64 context;
-		/** @compute.seqno: preemption fence seqno */
+		/** @lr.seqno: preemption fence seqno */
 		u32 seqno;
-		/** @compute.link: link into VM's list of exec queues */
+		/** @lr.link: link into VM's list of exec queues */
 		struct list_head link;
-		/** @compute.lock: preemption fences lock */
+		/** @lr.lock: preemption fences lock */
 		spinlock_t lock;
-	} compute;
+	} lr;
 
 	/** @ops: submission backend exec queue operations */
 	const struct xe_exec_queue_ops *ops;
diff --git a/drivers/gpu/drm/xe/xe_preempt_fence.c b/drivers/gpu/drm/xe/xe_preempt_fence.c
index 5b243b7feb59d..e8b8ae5c6485e 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence.c
+++ b/drivers/gpu/drm/xe/xe_preempt_fence.c
@@ -129,7 +129,7 @@ xe_preempt_fence_arm(struct xe_preempt_fence *pfence, struct xe_exec_queue *q,
 	list_del_init(&pfence->link);
 	pfence->q = xe_exec_queue_get(q);
 	dma_fence_init(&pfence->base, &preempt_fence_ops,
-		      &q->compute.lock, context, seqno);
+		      &q->lr.lock, context, seqno);
 
 	return &pfence->base;
 }
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 3137cbbaabde0..fd5612cc6f19b 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -83,10 +83,10 @@ static bool preempt_fences_waiting(struct xe_vm *vm)
 	lockdep_assert_held(&vm->lock);
 	xe_vm_assert_held(vm);
 
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link) {
-		if (!q->compute.pfence ||
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
+		if (!q->lr.pfence ||
 		    test_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-			     &q->compute.pfence->flags)) {
+			     &q->lr.pfence->flags)) {
 			return true;
 		}
 	}
@@ -129,14 +129,14 @@ static int wait_for_existing_preempt_fences(struct xe_vm *vm)
 
 	xe_vm_assert_held(vm);
 
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link) {
-		if (q->compute.pfence) {
-			long timeout = dma_fence_wait(q->compute.pfence, false);
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
+		if (q->lr.pfence) {
+			long timeout = dma_fence_wait(q->lr.pfence, false);
 
 			if (timeout < 0)
 				return -ETIME;
-			dma_fence_put(q->compute.pfence);
-			q->compute.pfence = NULL;
+			dma_fence_put(q->lr.pfence);
+			q->lr.pfence = NULL;
 		}
 	}
 
@@ -148,7 +148,7 @@ static bool xe_vm_is_idle(struct xe_vm *vm)
 	struct xe_exec_queue *q;
 
 	xe_vm_assert_held(vm);
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link) {
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
 		if (!xe_exec_queue_is_idle(q))
 			return false;
 	}
@@ -161,17 +161,17 @@ static void arm_preempt_fences(struct xe_vm *vm, struct list_head *list)
 	struct list_head *link;
 	struct xe_exec_queue *q;
 
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link) {
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
 		struct dma_fence *fence;
 
 		link = list->next;
 		xe_assert(vm->xe, link != list);
 
 		fence = xe_preempt_fence_arm(to_preempt_fence_from_link(link),
-					     q, q->compute.context,
-					     ++q->compute.seqno);
-		dma_fence_put(q->compute.pfence);
-		q->compute.pfence = fence;
+					     q, q->lr.context,
+					     ++q->lr.seqno);
+		dma_fence_put(q->lr.pfence);
+		q->lr.pfence = fence;
 	}
 }
 
@@ -191,10 +191,10 @@ static int add_preempt_fences(struct xe_vm *vm, struct xe_bo *bo)
 	if (err)
 		goto out_unlock;
 
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link)
-		if (q->compute.pfence) {
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link)
+		if (q->lr.pfence) {
 			dma_resv_add_fence(bo->ttm.base.resv,
-					   q->compute.pfence,
+					   q->lr.pfence,
 					   DMA_RESV_USAGE_BOOKKEEP);
 		}
 
@@ -211,10 +211,10 @@ static void resume_and_reinstall_preempt_fences(struct xe_vm *vm,
 	lockdep_assert_held(&vm->lock);
 	xe_vm_assert_held(vm);
 
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link) {
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
 		q->ops->resume(q);
 
-		drm_gpuvm_resv_add_fence(&vm->gpuvm, exec, q->compute.pfence,
+		drm_gpuvm_resv_add_fence(&vm->gpuvm, exec, q->lr.pfence,
 					 DMA_RESV_USAGE_BOOKKEEP, DMA_RESV_USAGE_BOOKKEEP);
 	}
 }
@@ -238,16 +238,16 @@ int xe_vm_add_compute_exec_queue(struct xe_vm *vm, struct xe_exec_queue *q)
 	if (err)
 		goto out_up_write;
 
-	pfence = xe_preempt_fence_create(q, q->compute.context,
-					 ++q->compute.seqno);
+	pfence = xe_preempt_fence_create(q, q->lr.context,
+					 ++q->lr.seqno);
 	if (!pfence) {
 		err = -ENOMEM;
 		goto out_fini;
 	}
 
-	list_add(&q->compute.link, &vm->preempt.exec_queues);
+	list_add(&q->lr.link, &vm->preempt.exec_queues);
 	++vm->preempt.num_exec_queues;
-	q->compute.pfence = pfence;
+	q->lr.pfence = pfence;
 
 	down_read(&vm->userptr.notifier_lock);
 
@@ -284,12 +284,12 @@ void xe_vm_remove_compute_exec_queue(struct xe_vm *vm, struct xe_exec_queue *q)
 		return;
 
 	down_write(&vm->lock);
-	list_del(&q->compute.link);
+	list_del(&q->lr.link);
 	--vm->preempt.num_exec_queues;
-	if (q->compute.pfence) {
-		dma_fence_enable_sw_signaling(q->compute.pfence);
-		dma_fence_put(q->compute.pfence);
-		q->compute.pfence = NULL;
+	if (q->lr.pfence) {
+		dma_fence_enable_sw_signaling(q->lr.pfence);
+		dma_fence_put(q->lr.pfence);
+		q->lr.pfence = NULL;
 	}
 	up_write(&vm->lock);
 }
@@ -325,7 +325,7 @@ static void xe_vm_kill(struct xe_vm *vm)
 	vm->flags |= XE_VM_FLAG_BANNED;
 	trace_xe_vm_kill(vm);
 
-	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link)
+	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link)
 		q->ops->kill(q);
 	xe_vm_unlock(vm);
 
-- 
2.43.0



