Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050786;
	b=qzqGSIwaNLiz6QrR3QE5HZQRx43N7X6rdVAhyr5MWOT3/5WT6ujvm+1XRXNdjbU9nF9a
	 5n33JhIV/UPaN/YT8T6ihu4WpbOxJMaIjAqLYMIFud4VpdXfIUMUaUzf9rITksr4/xCPY
	 r2Ir6fOiqgGVFhpynR70dz8Y6BB6oECdyr+FUHzw4b0xi+b4Agd2ZZsNNqNjXUfFFTFvx
	 eHJme8GXiFObdQfWCscalezECvzu2OOoAT6o9E0PIAFmsEosaft6nGqtbA6Re+9hRpL75
	 knRHR6yII3OIe/F/8J7V15S+GqEoul6LOlkiB0OxJyHhBTbOyGniQ7hzcSIOOqhLBuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1LN3P07zN+2mRiQkfVMGgUzaauu5wJmhb5jBy0otXSo=;
	b=fvivQWJ59qe2LVL6mbCYJPnJcNK7tM4Hl1YSv2avdgfL1n7CdIxWZYayyKyfHHEKTwx1
	 SQOobxz1sJRSIczckMdiwtbAim1d3IxjjLUTCOFP20e5Xa3cxbY+QDxOnTaXCDPIDtlf7
	 hi1Ot5hX1u2xmudMMXvw9hts2rVbkl64Z4TqjRLFC+Cownzh8DT2JWQa/CCbbwxRPgs6L
	 52JldNSb7wbOXcSW9xKxjyv5furPPeBq64ANakCmD/OTenfw9PkGRi5wJBSKh5d5M1Wkx
	 Xk/V21LZGySXk9GUUkgR0mAczH2aCR3I8BHOoC6W0mONR9BnVAV1U534yT2B4duLTIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otgdFpTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B20A606A32C;
	Thu, 19 Nov 2026 01:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otgdFpTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B711F000C4;
	Thu, 19 Nov 2026 01:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050786;
	bh=1LN3P07zN+2mRiQkfVMGgUzaauu5wJmhb5jBy0otXSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otgdFpTxDHyJL4VWkAVvwnmuto1mJwai835IY25ZNbhbx43FOf2xr2+XXfu6lRTdh
	 PlBhAzgtB7fJ6pw+b+potjkYsfoHgidNWoRAQS0AXnek7PdBHZsWWAaTAFvVQCKFR8
	 jZYjFX9SH15pxZln4rwPQWQdp3B/DWwWHa5q4k6w=
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
Subject: [PATCH 6.1 2831/2857] block: introduce init_wait_func()
Date: Wed, 18 Nov 2026 16:04:25 +0100
Message-ID: <20261118150343.513787767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e00e5961b0022..16477d10ed7a2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2700,8 +2700,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
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
index f68edf5550943..e78e7c94f7ab5 100644
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
index bc06a315653a7..40390717b3eee 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1208,14 +1208,16 @@ int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, i
 
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



