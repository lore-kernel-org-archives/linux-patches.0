Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060757;
	b=0PyqreQQQieifpxtvnmsyFEuloEU6jymyyt9Qhoous61EZvwPWu4z1PrtXPI+mUkffak
	 y4rFzH+8Vn350y6vAxvOUkJiTFaJOWLRzt8XcOl7gV6CZ1fwSt9K9vxkWwxdtiVJkdmCt
	 swG9sJUR4lzLPMWRP58kNvrhkX0AVGXxjUWTzCLNoBcjtr0xSN51wHkF8Fpr7YzF38fJ3
	 ujqjfdKuuHic/VyTjMk8EMR6/sXxNpza7ADWV6o4r2+KjCd+Ge52PSBTxWycqAlrOysqt
	 VrFZUduFVLLliQrf6a2KLjkYBShE+gCWRkrNftd8YNFelhlF4HSiT7+LgIgUIdwvlug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1TuttsYtS9QYUXsPmiAeSsUD1BdHIvyOH7KXHRVXf0U=;
	b=GUvAyFtNMcg+/VqrjKOc4zNL3fovOO0bk8Xk6sRXavHms/VAtXn8czQGOVF5htqmmD27
	 5c0noFdmMXV6LBl6+ujuDXrfGF5jYx4Ne3dWN6/caUEavwHm+m3ljMXNkTNBwUiDFvnJS
	 TOU55CWerHOViqaiBs39mwYTWjcLEuehBZQdwHFIKWta52yPRM/tfZvEHxL6f8MyJwi8v
	 cF9eG54P9j5a/lIpZIgnHj5BOPBuM2Nw2Y8f4KdfNLEzpqv+mKmkX62g6EfGOYKJq1AIy
	 thgvu6FmlPrtl3SwnOJTj9lQsVB2sT7QNoJBSwG9eDweZtIxb9srfWU5dbcgI8/YahQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHIK9HtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABD2606A331;
	Sat,  7 Nov 2026 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHIK9HtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DD51F008A1;
	Sat,  7 Nov 2026 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060757;
	bh=1TuttsYtS9QYUXsPmiAeSsUD1BdHIvyOH7KXHRVXf0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHIK9HtW+O7gThkU3IWZauGbH5NmvsrjunABm7gI5MN7lu6GkfveaY4QhWOf1xA2d
	 ZI2mPVEwu9pHpuTWDmh2nT/JHAmher6f3yliGsAWdVVhMWQ7YZkUrk89X10jZeC6NV
	 tvcnuBx2nguXi7IowjFR5ig7fb1ZoM49T0fDcUMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0121/1536] drm/xe: only resume exec queues that were actually suspended
Date: Sat,  7 Nov 2026 08:35:37 -0500
Message-ID: <20261107135001.085509413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

[ Upstream commit 65f40fa5022bcdb90d3a39e4948adf2aa16732a3 ]

A consumer-issued suspend() can fail (e.g. the queue is killed, banned
or wedged), leaving the queue un-suspended. The consumer must then not
issue the matching resume(): resuming a queue that was never suspended
is incorrect.

Add an lr.suspended flag to struct xe_exec_queue that records whether a
consumer suspend() succeeded and a matching resume() is still owed. Set
it on a successful suspend() in the preempt-fence path, clear it on
resume(), and only resume queues that have it set.

In resume_and_reinstall_preempt_fences() also skip queues that have
since been reset/killed/banned/wedged: such a queue's suspend may not
have completed (suspend_pending can still be set, e.g. a preempt fence
signalled with -ENOENT without waiting), so resuming it would trip the
!suspend_pending assert in the backend. Leave it marked suspended and
let teardown resolve its state.

A queue is only ever suspended by a single consumer at a time
(preempt-fence mode and hw engine group fault mode are mutually
exclusive), so a single flag is sufficient.

Assisted-by: Github-Copilot:Claude-opus-4.8
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260713202317.2187787-9-niranjana.vishwanathapura@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue_types.h | 12 ++++++++++++
 drivers/gpu/drm/xe/xe_preempt_fence.c    |  7 +++++++
 drivers/gpu/drm/xe/xe_vm.c               | 18 +++++++++++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index 7deb480e26af0..2ab4dca85a7e4 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -126,6 +126,18 @@ struct xe_exec_queue {
 		u32 seqno;
 		/** @lr.link: link into VM's list of exec queues */
 		struct list_head link;
+		/**
+		 * @lr.suspended: Tracks whether the consumer-issued suspend()
+		 * succeeded and a matching resume() is still owed. suspend() can
+		 * fail (e.g. killed/banned/wedged), leaving the queue
+		 * un-suspended, so consumers must only resume() queues that were
+		 * actually suspended. Set by the suspend caller on success and
+		 * cleared by the resume caller. A queue is only ever suspended by
+		 * a single consumer at a time (preempt-fence mode and hw engine
+		 * group fault mode are mutually exclusive), so a single flag is
+		 * sufficient.
+		 */
+		bool suspended;
 	} lr;
 
 	/** @ops: submission backend exec queue operations */
diff --git a/drivers/gpu/drm/xe/xe_preempt_fence.c b/drivers/gpu/drm/xe/xe_preempt_fence.c
index 83fbeea5aa201..014a5980febd0 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence.c
+++ b/drivers/gpu/drm/xe/xe_preempt_fence.c
@@ -63,6 +63,13 @@ static bool preempt_fence_enable_signaling(struct dma_fence *fence)
 	struct xe_exec_queue *q = pfence->q;
 
 	pfence->error = q->ops->suspend(q);
+	/*
+	 * Record a successful suspend so the rebind worker only resumes queues
+	 * that were actually suspended; a failed suspend() leaves the queue
+	 * un-suspended and must not be paired with a resume().
+	 */
+	if (!pfence->error)
+		WRITE_ONCE(q->lr.suspended, true);
 	queue_work(q->vm->xe->preempt_fence_wq, &pfence->preempt_work);
 	return true;
 }
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index d53cb4e625172..310178a5652a3 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -211,7 +211,23 @@ static void resume_and_reinstall_preempt_fences(struct xe_vm *vm,
 	xe_vm_assert_held(vm);
 
 	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
-		q->ops->resume(q);
+		/*
+		 * Only resume queues whose suspend() actually succeeded. A
+		 * failed suspend() (e.g. killed/banned/wedged) leaves the queue
+		 * un-suspended, so it must not be resumed.
+		 *
+		 * Also skip queues that have since been reset/killed/banned/
+		 * wedged: their suspend may not have completed (suspend_pending
+		 * can still be set, e.g. a preempt fence signalled with -ENOENT
+		 * without waiting), so resuming would trip the !suspend_pending
+		 * assert in the backend. Such queues are being torn down anyway,
+		 * so leave them marked suspended and let teardown resolve their
+		 * state.
+		 */
+		if (READ_ONCE(q->lr.suspended) && !q->ops->reset_status(q)) {
+			WRITE_ONCE(q->lr.suspended, false);
+			q->ops->resume(q);
+		}
 
 		drm_gpuvm_resv_add_fence(&vm->gpuvm, exec, q->lr.pfence,
 					 DMA_RESV_USAGE_BOOKKEEP, DMA_RESV_USAGE_BOOKKEEP);
-- 
2.53.0



