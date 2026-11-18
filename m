Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042866;
	b=LEOs5zYN12MnH/SNHcnb0GcTsjrFPlaOaJaNN+bo2yLrvoObTFrd/sgqO6JiF7Q55hbk
	 ln0nxIMTkM5rReAEqwnOR8TMJWk3L3mafYLWB87Cda1g8gN0elTZk3i5aArM7JiQXliDf
	 vTeUS/ikOys1aniH/TGwXrticnXZBopQaavCLU9He4yzSNfikZfNpmL1E2NNDMk+Pv6vx
	 Sj14Bt4xC42/vWOUQ6hEzNo4hpmr98i5Vm5DQgccaxxC8/khpa2jyTJBcIKahkULy5RR7
	 EVhFwcQ2eZQvVzWEOgChYqO+RSSbBA5BswtVmJUiC3KHDdXeweVxCcfxfH0sIlku9mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AyHPtvkZ0LzP1cfVCHCmDhgdvwA6w8i7T3nJMGHvPz0=;
	b=K+iruyhH2XDajKmN2aZ/5YhIQ7YMs45LjxYrFWtR9mqqfhdBxBlMhAEijjw0vQuUGw2J
	 T7Omcr2Dpb+uzpcBZ2AsX39pcZA4XX4+z89+0MJEm8/22cpu4mch9exSrdx5Ex6gZ2Lq/
	 aSj2EVOZEBVpBVoeiudFeP9RY2jShN2wHiIYTugRnKhmgvNnVbuOTch3QIXDjGtvqJe9e
	 TiIAkH3g74SJYiChUWM4jDeQmO4KjcPJZvgsvX3dIDlHSRzPDNQlaHa5OqlRPIz5UNh4C
	 UJHuGIScsWLyZBsxEhnx3FFhrbeH5SsMXkcQcyOSp9+ysuEiDYRCla1UbSUu743iuWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wht+pvF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D4B606A320;
	Wed, 18 Nov 2026 23:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wht+pvF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D5D1F000C5;
	Wed, 18 Nov 2026 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042866;
	bh=AyHPtvkZ0LzP1cfVCHCmDhgdvwA6w8i7T3nJMGHvPz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wht+pvFGRXW2ef/LSmgRGScy4jr/eV9i9SZNXslvs4vistV3bpo7KGxw+4vdmJ6e
	 2vjYNaHDTKSwtOiz89kLnSAbLWgIJi9Jt/5hkKQmkBQ1TK26h1fPB8nhxZYGx/Sssi
	 Ajq0CFXOU1fU8+T1qE5kmI2RkA3WQUHMSvBm1ntk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3292/3318] block: introduce init_wait_func()
Date: Wed, 18 Nov 2026 16:05:14 +0100
Message-ID: <20261118150458.356208983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 36d03cb3277e29beedb87b8efb1e4da02b26e0c0 ]

There is already a macro DEFINE_WAIT_FUNC() to declare a wait_queue_entry
with a specified waking function. But there is not a counterpart for
initializing one wait_queue_entry with a specified waking function. So
introducing init_wait_func() for this, which also could be used in iocost
and rq-qos. Using default_wake_function() in rq_qos_wait() to wake up
waiters, which could remove ->task field from rq_qos_wait_data.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250208090416.38642-1-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f3a6dae67c9c ("fs_pin: do not trust the pin after a spurious wakeup in pin_kill()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c   |  3 +--
 block/blk-rq-qos.c   | 14 +++++++-------
 include/linux/wait.h |  6 ++++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 185f2b82dab99..bea08873a080c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2722,8 +2722,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	 * All waiters are on iocg->waitq and the wait states are
 	 * synchronized using waitq.lock.
 	 */
-	init_waitqueue_func_entry(&wait.wait, iocg_wake_fn);
-	wait.wait.private = current;
+	init_wait_func(&wait.wait, iocg_wake_fn);
 	wait.bio = bio;
 	wait.abs_cost = abs_cost;
 	wait.committed = false;	/* will be set true by waker */
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 9b0aa7dd6779f..858ce69c04ece 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -196,7 +196,6 @@ bool rq_depth_scale_down(struct rq_depth *rqd, bool hard_throttle)
 
 struct rq_qos_wait_data {
 	struct wait_queue_entry wq;
-	struct task_struct *task;
 	struct rq_wait *rqw;
 	acquire_inflight_cb_t *cb;
 	void *private_data;
@@ -218,7 +217,12 @@ static int rq_qos_wake_function(struct wait_queue_entry *curr,
 		return -1;
 
 	data->got_token = true;
-	wake_up_process(data->task);
+	/*
+	 * autoremove_wake_function() removes the wait entry only when it
+	 * actually changed the task state. We want the wait always removed.
+	 * Remove explicitly and use default_wake_function().
+	 */
+	default_wake_function(curr, mode, wake_flags, key);
 	list_del_init_careful(&curr->entry);
 	return 1;
 }
@@ -244,11 +248,6 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 		 cleanup_cb_t *cleanup_cb)
 {
 	struct rq_qos_wait_data data = {
-		.wq = {
-			.func	= rq_qos_wake_function,
-			.entry	= LIST_HEAD_INIT(data.wq.entry),
-		},
-		.task = current,
 		.rqw = rqw,
 		.cb = acquire_inflight_cb,
 		.private_data = private_data,
@@ -259,6 +258,7 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 	if (!has_sleeper && acquire_inflight_cb(rqw, private_data))
 		return;
 
+	init_wait_func(&data.wq, rq_qos_wake_function);
 	has_sleeper = !prepare_to_wait_exclusive(&rqw->wait, &data.wq,
 						 TASK_UNINTERRUPTIBLE);
 	do {
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1ad63e595c8ef..9e158e13ed9ec 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1211,14 +1211,16 @@ int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, i
 
 #define DEFINE_WAIT(name) DEFINE_WAIT_FUNC(name, autoremove_wake_function)
 
-#define init_wait(wait)								\
+#define init_wait_func(wait, function)						\
 	do {									\
 		(wait)->private = current;					\
-		(wait)->func = autoremove_wake_function;			\
+		(wait)->func = function;					\
 		INIT_LIST_HEAD(&(wait)->entry);					\
 		(wait)->flags = 0;						\
 	} while (0)
 
+#define init_wait(wait)	init_wait_func(wait, autoremove_wake_function)
+
 typedef int (*task_call_f)(struct task_struct *p, void *arg);
 extern int task_call_func(struct task_struct *p, task_call_f func, void *arg);
 
-- 
2.53.0



