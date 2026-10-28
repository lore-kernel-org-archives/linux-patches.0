Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214176;
	b=3RmgmeHLS4Dm1Ie4pYAAyLYBYzotJ4J6wRQMa0NZmm4tLmjmtMhYFA7J6rHaVWAI7duB
	 9JWkDM8dSkhO0H1O0AtP2HDZe0r7L+uLUGP9GGds2dhVcXqWaMp3fKkir+YvoInx4Irt3
	 w3gqwXtiSO0o4X2Puu2ZXqCKrV4GuvEGUHWfL0Epzd1stjiHdrL/Zhg8CmIOefsy956P9
	 24nH4MLiIjUSsp2JTbldYZQB+hFxR3JWZZHY5lDrcsusNiBfQSWsmwp+BT44BW6Lk5hdP
	 429koa46HUYgnBft3SZWTl+iPT5bpUoC5jQqSt7Ff6tMvhTglMn7EYI99GJ7t38UrEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BKKsmL21+knYv/5Vff3eDj9F+Nvk5ydOxSgT70MAHiE=;
	b=0pjlO5gBqyZGOK+4N4p57CKYWfzrbDwmS7IFxHlWcfmofKmTzyWxGkixBPQ6d6ChuLIi
	 qS4Fx4btQbugdwUZmqyU69prX7wrmnibfGLECZcbL26Lc/3d8ic2D6Vqp0Rd5SlIRp6i8
	 SKzJNlOiMwNuLMX8oZ6G+eJpJcX3+ng2ZTMNNM/lfSvlXB3FG3vffY6yFeYOQvqRcXNDR
	 yrRGXvVPgMttLExvvqZxb8T2NcknAkSH6S+2IjVukoD+fpUMOELO7u7ne9SdOX3MEr4M8
	 2KMpWYe2xRaXg8wIoEt5IhArMtPxMsMuZF8kQLq5BPPV+KbDFUq7pLl+VNeHECpi5/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bb+iaa9M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83FE606A31A;
	Wed, 28 Oct 2026 19:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bb+iaa9M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA4A1F01825;
	Wed, 28 Oct 2026 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214175;
	bh=BKKsmL21+knYv/5Vff3eDj9F+Nvk5ydOxSgT70MAHiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb+iaa9MsNI3FGhLbWQYGf9YEFsbM2yB0a720Cr34tRoruTWBmfJmit6mVQnNoZ9a
	 dXWP6+O4OHOYuEX6GKHbrVGpI4S2jTzq1s55aBXbdaTME24rep7OLY3g1ZXGBb96Sp
	 YNRG3o+oUDr9ooxpJj4qW7TQmxUd4hMwPTFePElU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0723/1887] workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_MEM_RECLAIM worker
Date: Wed, 28 Oct 2026 17:46:59 +0100
Message-ID: <20261028170515.895270849@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit de35994ecd2dd6148ab5a6c5050a1670a04dec77 ]

After commit
746ae46c1113 ("drm/sched: Mark scheduler work queues with WQ_MEM_RECLAIM")
amdgpu started seeing the following warning:

 [ ] workqueue: WQ_MEM_RECLAIM sdma0:drm_sched_run_job_work [gpu_sched] is flushing !WQ_MEM_RECLAIM events:amdgpu_device_delay_enable_gfx_off [amdgpu]
...
 [ ] Workqueue: sdma0 drm_sched_run_job_work [gpu_sched]
...
 [ ] Call Trace:
 [ ]  <TASK>
...
 [ ]  ? check_flush_dependency+0xf5/0x110
...
 [ ]  cancel_delayed_work_sync+0x6e/0x80
 [ ]  amdgpu_gfx_off_ctrl+0xab/0x140 [amdgpu]
 [ ]  amdgpu_ring_alloc+0x40/0x50 [amdgpu]
 [ ]  amdgpu_ib_schedule+0xf4/0x810 [amdgpu]
 [ ]  ? drm_sched_run_job_work+0x22c/0x430 [gpu_sched]
 [ ]  amdgpu_job_run+0xaa/0x1f0 [amdgpu]
 [ ]  drm_sched_run_job_work+0x257/0x430 [gpu_sched]
 [ ]  process_one_work+0x217/0x720
...
 [ ]  </TASK>

The intent of the verifcation done in check_flush_depedency is to ensure
forward progress during memory reclaim, by flagging cases when either a
memory reclaim process, or a memory reclaim work item is flushed from a
context not marked as memory reclaim safe.

This is correct when flushing, but when called from the
cancel(_delayed)_work_sync() paths it is a false positive because work is
either already running, or will not be running at all. Therefore
cancelling it is safe and we can relax the warning criteria by letting the
helper know of the calling context.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: fca839c00a12 ("workqueue: warn if memory reclaim tries to flush !WQ_MEM_RECLAIM workqueue")
References: 746ae46c1113 ("drm/sched: Mark scheduler work queues with WQ_MEM_RECLAIM")
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0e6aa523ef557..70d6e7779c2e6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2607,23 +2607,27 @@ static int rescuer_thread(void *__rescuer)
  * check_flush_dependency - check for flush dependency sanity
  * @target_wq: workqueue being flushed
  * @target_work: work item being flushed (NULL for workqueue flushes)
+ * @from_cancel: are we called from the work cancel path
  *
  * %current is trying to flush the whole @target_wq or @target_work on it.
- * If @target_wq doesn't have %WQ_MEM_RECLAIM, verify that %current is not
- * reclaiming memory or running on a workqueue which doesn't have
- * %WQ_MEM_RECLAIM as that can break forward-progress guarantee leading to
- * a deadlock.
+ * If this is not the cancel path (which implies work being flushed is either
+ * already running, or will not be at all), check if @target_wq doesn't have
+ * %WQ_MEM_RECLAIM and verify that %current is not reclaiming memory or running
+ * on a workqueue which doesn't have %WQ_MEM_RECLAIM as that can break forward-
+ * progress guarantee leading to a deadlock.
  */
 static void check_flush_dependency(struct workqueue_struct *target_wq,
-				   struct work_struct *target_work)
+				   struct work_struct *target_work,
+				   bool from_cancel)
 {
-	work_func_t target_func = target_work ? target_work->func : NULL;
+	work_func_t target_func;
 	struct worker *worker;
 
-	if (target_wq->flags & WQ_MEM_RECLAIM)
+	if (from_cancel || target_wq->flags & WQ_MEM_RECLAIM)
 		return;
 
 	worker = current_wq_worker();
+	target_func = target_work ? target_work->func : NULL;
 
 	WARN_ONCE(current->flags & PF_MEMALLOC,
 		  "workqueue: PF_MEMALLOC task %d(%s) is flushing !WQ_MEM_RECLAIM %s:%ps",
@@ -2857,7 +2861,7 @@ void __flush_workqueue(struct workqueue_struct *wq)
 		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
 	}
 
-	check_flush_dependency(wq, NULL);
+	check_flush_dependency(wq, NULL, false);
 
 	mutex_unlock(&wq->mutex);
 
@@ -3032,7 +3036,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		pwq = worker->current_pwq;
 	}
 
-	check_flush_dependency(pwq->wq, work);
+	check_flush_dependency(pwq->wq, work, from_cancel);
 
 	insert_wq_barrier(pwq, barr, work, worker);
 	raw_spin_unlock_irq(&pool->lock);
-- 
2.53.0



