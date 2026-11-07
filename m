Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064978;
	b=YUpfIKt58FNhVUb6gBqKqVbRZ3TNyhRFSH6ybnqgm1hHibYlG849HittdNZ+/gc4J2Tl
	 nUTM2DMOpQYzVD4MeBy4es3NYAoZIPuzqosl5e27VXkXVTJS5mptI8Z98DwgcmZk8+hkl
	 ouPNpqhD/bukIbzh35Es7ZtbRl0SkPkv/1wEC9aj09H6l1kbUVy8PkpRLQ+IWWuPF1wG/
	 oMyaaqGtkaOeE0AyaOyu+k5IGbbDfX8Fy8tosSxADCEVWDdX50iS53hzUb8XMefP66IsA
	 G41W7Wz/vVofFwHJLGvNDMfhxDULF1pU05sqT6rZgfzTAmp4hBhABjDapiDuy0lvv6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5CdQbI3xWm2qf8jUnRnqbJK6n3/RAexIDV3tH1GeW5g=;
	b=xf+pdCnGX9udYzUY5X1u0UViW2Eq3qoVVHgGP/GxIeYk90v6JKzrMuHmStdVcSFK+H5l
	 KAMjIqEGUbZ5hRK0p7s+9yOnh/mzWUmugniwsVXuelamUBChHMZNXPxRl+j3T/IC5zda2
	 /4R9PISSB1UOWmCCJt3ap9B6romd66Lz80PAvrHeeDDTg5gv2ZIsPqNO4t42rudySCRWz
	 ZgytDzfsYlWkWvzXerdK1Jx8f48D8CAZ6UIMq19nDPyVF+1/zwznZ5sAqWM3OXbu4SA+3
	 HVwKD20Erl88SVWwVuDWIvFcPretl5t4HnNc1QtCLaGe3FeI8J6dyULz7Atb1kTRH4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgqJFqZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384D4606A336;
	Sat,  7 Nov 2026 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgqJFqZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71911F0089F;
	Sat,  7 Nov 2026 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064978;
	bh=5CdQbI3xWm2qf8jUnRnqbJK6n3/RAexIDV3tH1GeW5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgqJFqZCjpftoqsBKneqkupXx0hDT/m+afx7/UDtWXMXYAcJ7mIKac9oTlV9Nrg8w
	 KJzYSxXg12585x6RGilFg52BMohTREM2p1DZyYJAlMnjIYA/I50n8R+bef+0IyQvaH
	 4ZoQXWJPNAGXuyLctegUB3wmtsk0GX/UxXSpl1Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0856/1257] sched_ext: Dont queue balance callbacks from a core-sched pick
Date: Sat,  7 Nov 2026 08:52:32 -0500
Message-ID: <20261107135002.972471425@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 680edc7f23ad71e0ecce8a2364af3ae7f30dd11a ]

Commit ff0545e0c263 ("sched_ext: Don't leave balance callbacks queued
across a pick retry") queues the deferred work as a balance callback
only when do_pick_task_scx() returns a final pick. However, under core
scheduling, a pick that returns a task isn't final either:
pick_next_task() goes on to pick the SMT siblings, and their dispatch
can release the shared rq lock with the callback still queued,
triggering the rq_pin_lock() warning.

Moreover, dispatch_core_pick() returns early when another dispatch is
in flight on the rq, and do_pick_task_scx() then consumes
%SCX_RQ_BAL_CB_PENDING set by that dispatch while it's still running.

This can be reproduced running scx_qmap -I on SMT siblings with
coresched-tagged workloads that frequently sleep, mixed with untagged
CPU-bound tasks.

Fix this by always deferring the pending work to the irq_work path from
dispatch_core_pick() under core scheduling, for both the local and the
sibling picks, and by leaving %SCX_RQ_BAL_CB_PENDING alone in
do_pick_task_scx(), so that it's handled by the dispatch that set it.
Sample the core scheduling state once at the start of the pick, since
core scheduling can get enabled while a non-core dispatch has the rq lock
released, and the follow-up work must match the dispatch path that ran.

Fixes: 4c95380701f5 ("sched/ext: Fold balance_scx() into pick_task_scx()")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 8fc3f791c88f4..60e8bacc14bb9 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3372,15 +3372,20 @@ static enum scx_dsp_verdict dispatch_core_pick(struct rq *rq, struct rq_flags *r
 
 	verdict = dispatch_one(rq, prev);
 
-	if (cpu_of(rq) != smp_processor_id() &&
-	    unlikely(rq->scx.flags & SCX_RQ_BAL_CB_PENDING)) {
-		/*
-		 * Balance callbacks must run in the context that queued them,
-		 * so they can't be queued on another CPU's rq. Run the deferred
-		 * work directly instead.
-		 */
+	/*
+	 * A pick that returns a task isn't final under core scheduling: the
+	 * selection goes on to pick the siblings, and their dispatch can
+	 * release the rq lock, which can't happen with balance callbacks
+	 * queued. Don't queue the deferred work as a balance callback, for this
+	 * CPU or a sibling, and run it from irq_work instead.
+	 *
+	 * do_pick_task_scx() leaves %SCX_RQ_BAL_CB_PENDING alone under core
+	 * scheduling, so that the early return above leaves it to the dispatch
+	 * in flight, which handles it here.
+	 */
+	if (unlikely(rq->scx.flags & SCX_RQ_BAL_CB_PENDING)) {
 		rq->scx.flags &= ~SCX_RQ_BAL_CB_PENDING;
-		run_deferred(rq);
+		schedule_deferred(rq);
 	}
 
 	rq_repin_lock(rq, rf);
@@ -3403,6 +3408,7 @@ static struct task_struct *
 do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 {
 	struct task_struct *prev = rq->curr;
+	bool core_sched = sched_core_enabled(rq);
 	enum scx_dsp_verdict verdict;
 	struct task_struct *p;
 
@@ -3411,7 +3417,12 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 
 	rq_modified_begin(rq, &ext_sched_class);
 
-	if (sched_core_enabled(rq))
+	/*
+	 * Core scheduling can get enabled while dispatch_pick() has the rq lock
+	 * released. Stick to @core_sched, so that the follow-up work below
+	 * matches the dispatch that ran.
+	 */
+	if (core_sched)
 		verdict = dispatch_core_pick(rq, rf, prev);
 	else
 		verdict = dispatch_pick(rq, rf, prev);
@@ -3477,7 +3488,9 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 	 * for the next pick.
 	 */
 	if (p != RETRY_TASK && (p || !force_scx)) {
-		maybe_queue_balance_callback(rq);
+		/* under core scheduling, see dispatch_core_pick() */
+		if (!core_sched)
+			maybe_queue_balance_callback(rq);
 
 		/*
 		 * Defer to a balance callback which can drop rq lock and enable
@@ -3490,7 +3503,7 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 			queue_balance_callback(rq, &rq->scx.kick_sync_bal_cb,
 					       kick_sync_wait_bal_cb);
 		}
-	} else if (rq->scx.flags & SCX_RQ_BAL_CB_PENDING) {
+	} else if (!core_sched && (rq->scx.flags & SCX_RQ_BAL_CB_PENDING)) {
 		rq->scx.flags &= ~SCX_RQ_BAL_CB_PENDING;
 		schedule_deferred(rq);
 	}
-- 
2.53.0



