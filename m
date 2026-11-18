Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028420;
	b=ih408/vi13HCU+1y6FdEo/tGKd8rcbxjzVY0Awsd3btc3HGirI+ufm9wD3O04HT/xvIc
	 rxRnIIH3HFby1lxZvPHD5GDdpCcrv472EykKisXKq//4WBrG3Z7fi8UKSlx8XZm9WxEpX
	 hdAB+MKPw+o/WyZ/KcZ+zlSlACDrj1ay8yHJOMWe7Gam56goDjBGD/SsCJ0vpqcISU8GQ
	 DZJ4I0uHMpLL6h2QCO4fNmr6eSE68/A2pUytgHj4Dt5WYdueaSokQMbHpAP3BTiEQY9fq
	 0RujLUMqOH/l7d90LIdXeEgdrMsNz7mBF5MvdEC+1kG21KwUUj06DgvQRuyZ9OS4Gnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xI4PI9SGxIMBoTQsaOILlIsL6WF75oRnG7Pqn7x6xVY=;
	b=QPfsGdtpnubMOMQw/cl8bUTOe/i1k28ux8yHwJlUaRxXsgR2y3eKqtzM3e/v+zz1WeV/
	 lHYh+297ruLzQjDocCn6dJrXytVPRzXMl3Kgr1K6hfSTxR7ugXHQhqnSmYb5LPrGu+Fgq
	 dgrV46oob3omMdWKGijZnhrFXeuQvTxljOIAhmbDRynqdzHeAcdcWB9YeGIrK0u6IQ2hW
	 xChFhQEYnj/eodVWVCaWlDt+Xq9yXxHTQQJJ2PFKZvWd50qerk4RMznRayKawOIOps8sL
	 b830q/q039Q1YWN8P8sNGdXbtX9Lj517OqwC9MwVoviGZ2/j3WoIDTW70miHcxLhEWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTXX1jiy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967E5606A337;
	Wed, 18 Nov 2026 19:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTXX1jiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB32F1F000C9;
	Wed, 18 Nov 2026 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028420;
	bh=xI4PI9SGxIMBoTQsaOILlIsL6WF75oRnG7Pqn7x6xVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTXX1jiyMr0xwolsfigCMd/o9AAYS/8KV2x6tjnYaJAXdOPHLjHIV6e1B9XFLXF7T
	 SgWRS3OnbkfJ7Ik0Gdqp6dfiD6EuAsrxW2VRRUB7ue5nOPpAN7biqXMShGO5nevlx3
	 I8LoFPMufgeWjr/LIVqnHcXCq04XVoRx1elVLvac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2087/2151] block/blk-iocost: Split ioc_rqos_throttle()
Date: Wed, 18 Nov 2026 16:03:42 +0100
Message-ID: <20261118150237.729227352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1ff85a387947890938c05cfe22041dfeef3098dd ]

Prepare for inlining iocg_lock() and iocg_unlock() by moving the code
between these two calls into a new function. No functionality has been
changed.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://patch.msgid.link/a6d3ed953cef6669d23a80923bf46600733cbdae.1780682325.git.bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0150554a3f38 ("blk-iocost: publish hweights as one atomic value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 163 ++++++++++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 69 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6df4d84bff842..6f9611c9314e4 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2609,6 +2609,88 @@ static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 	return cost;
 }
 
+enum over_budget_action {
+	action_retry,
+	action_commit,
+	action_wait,
+	action_return,
+};
+
+static enum over_budget_action
+iocg_handle_over_budget(struct rq_qos *rqos, struct ioc_gq *iocg,
+			struct bio *bio, struct ioc_now *now,
+			struct iocg_wait *wait, bool use_debt, bool ioc_locked,
+			u64 abs_cost, u64 cost)
+{
+	lockdep_assert_held(&iocg->waitq.lock);
+
+	/*
+	 * @iocg must stay activated for debt and waitq handling. Deactivation
+	 * is synchronized against both ioc->lock and waitq.lock and we won't
+	 * get deactivated as long as we're waiting or have debt, so we're good
+	 * if we're activated here. In the unlikely cases that we aren't, just
+	 * issue the IO.
+	 */
+	if (unlikely(list_empty(&iocg->active_list)))
+		return action_commit;
+
+	/*
+	 * We're over budget. If @bio has to be issued regardless, remember
+	 * the abs_cost instead of advancing vtime. iocg_kick_waitq() will pay
+	 * off the debt before waking more IOs.
+	 *
+	 * This way, the debt is continuously paid off each period with the
+	 * actual budget available to the cgroup. If we just wound vtime, we
+	 * would incorrectly use the current hw_inuse for the entire amount
+	 * which, for example, can lead to the cgroup staying blocked for a
+	 * long time even with substantially raised hw_inuse.
+	 *
+	 * An iocg with vdebt should stay online so that the timer can keep
+	 * deducting its vdebt and [de]activate use_delay mechanism
+	 * accordingly. We don't want to race against the timer trying to
+	 * clear them and leave @iocg inactive w/ dangling use_delay heavily
+	 * penalizing the cgroup and its descendants.
+	 */
+	if (use_debt) {
+		iocg_incur_debt(iocg, abs_cost, now);
+		if (iocg_kick_delay(iocg, now))
+			blkcg_schedule_throttle(rqos->disk,
+						(bio->bi_opf & REQ_SWAP) ==
+							REQ_SWAP);
+		return action_return;
+	}
+
+	/* guarantee that iocgs w/ waiters have maximum inuse */
+	if (!iocg->abs_vdebt && iocg->inuse != iocg->active) {
+		if (!ioc_locked)
+			return action_retry;
+		lockdep_assert_held(&iocg->ioc->lock);
+		propagate_weights(iocg, iocg->active, iocg->active, true, now);
+	}
+
+	/*
+	 * Append self to the waitq and schedule the wakeup timer if we're
+	 * the first waiter.  The timer duration is calculated based on the
+	 * current vrate.  vtime and hweight changes can make it too short
+	 * or too long.  Each wait entry records the absolute cost it's
+	 * waiting for to allow re-evaluation using a custom wait entry.
+	 *
+	 * If too short, the timer simply reschedules itself.  If too long,
+	 * the period timer will notice and trigger wakeups.
+	 *
+	 * All waiters are on iocg->waitq and the wait states are
+	 * synchronized using waitq.lock.
+	 */
+	init_wait_func(&wait->wait, iocg_wake_fn);
+	wait->bio = bio;
+	wait->abs_cost = abs_cost;
+	wait->committed = false; /* will be set true by waker */
+
+	__add_wait_queue_entry_tail(&iocg->waitq, &wait->wait);
+	iocg_kick_waitq(iocg, ioc_locked, now);
+	return action_wait;
+}
+
 static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 {
 	struct blkcg_gq *blkg = bio->bi_blkg;
@@ -2618,6 +2700,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	struct iocg_wait wait;
 	u64 abs_cost, cost, vtime;
 	bool use_debt, ioc_locked;
+	enum over_budget_action action;
 	unsigned long flags;
 
 	/* bypass IOs if disabled, still initializing, or for root cgroup */
@@ -2658,80 +2741,22 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	ioc_locked = use_debt || READ_ONCE(iocg->abs_vdebt);
 retry_lock:
 	iocg_lock(iocg, ioc_locked, &flags);
-
-	/*
-	 * @iocg must stay activated for debt and waitq handling. Deactivation
-	 * is synchronized against both ioc->lock and waitq.lock and we won't
-	 * get deactivated as long as we're waiting or has debt, so we're good
-	 * if we're activated here. In the unlikely cases that we aren't, just
-	 * issue the IO.
-	 */
-	if (unlikely(list_empty(&iocg->active_list))) {
-		iocg_unlock(iocg, ioc_locked, &flags);
+	action = iocg_handle_over_budget(rqos, iocg, bio, &now, &wait, use_debt,
+					 ioc_locked, abs_cost, cost);
+	iocg_unlock(iocg, ioc_locked, &flags);
+	switch (action) {
+	case action_retry:
+		ioc_locked = true;
+		goto retry_lock;
+	case action_commit:
 		iocg_commit_bio(iocg, bio, abs_cost, cost);
 		return;
-	}
-
-	/*
-	 * We're over budget. If @bio has to be issued regardless, remember
-	 * the abs_cost instead of advancing vtime. iocg_kick_waitq() will pay
-	 * off the debt before waking more IOs.
-	 *
-	 * This way, the debt is continuously paid off each period with the
-	 * actual budget available to the cgroup. If we just wound vtime, we
-	 * would incorrectly use the current hw_inuse for the entire amount
-	 * which, for example, can lead to the cgroup staying blocked for a
-	 * long time even with substantially raised hw_inuse.
-	 *
-	 * An iocg with vdebt should stay online so that the timer can keep
-	 * deducting its vdebt and [de]activate use_delay mechanism
-	 * accordingly. We don't want to race against the timer trying to
-	 * clear them and leave @iocg inactive w/ dangling use_delay heavily
-	 * penalizing the cgroup and its descendants.
-	 */
-	if (use_debt) {
-		iocg_incur_debt(iocg, abs_cost, &now);
-		if (iocg_kick_delay(iocg, &now))
-			blkcg_schedule_throttle(rqos->disk,
-					(bio->bi_opf & REQ_SWAP) == REQ_SWAP);
-		iocg_unlock(iocg, ioc_locked, &flags);
+	case action_return:
 		return;
+	case action_wait:
+		break;
 	}
 
-	/* guarantee that iocgs w/ waiters have maximum inuse */
-	if (!iocg->abs_vdebt && iocg->inuse != iocg->active) {
-		if (!ioc_locked) {
-			iocg_unlock(iocg, false, &flags);
-			ioc_locked = true;
-			goto retry_lock;
-		}
-		propagate_weights(iocg, iocg->active, iocg->active, true,
-				  &now);
-	}
-
-	/*
-	 * Append self to the waitq and schedule the wakeup timer if we're
-	 * the first waiter.  The timer duration is calculated based on the
-	 * current vrate.  vtime and hweight changes can make it too short
-	 * or too long.  Each wait entry records the absolute cost it's
-	 * waiting for to allow re-evaluation using a custom wait entry.
-	 *
-	 * If too short, the timer simply reschedules itself.  If too long,
-	 * the period timer will notice and trigger wakeups.
-	 *
-	 * All waiters are on iocg->waitq and the wait states are
-	 * synchronized using waitq.lock.
-	 */
-	init_wait_func(&wait.wait, iocg_wake_fn);
-	wait.bio = bio;
-	wait.abs_cost = abs_cost;
-	wait.committed = false;	/* will be set true by waker */
-
-	__add_wait_queue_entry_tail(&iocg->waitq, &wait.wait);
-	iocg_kick_waitq(iocg, ioc_locked, &now);
-
-	iocg_unlock(iocg, ioc_locked, &flags);
-
 	while (true) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (wait.committed)
-- 
2.53.0



