Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826835;
	b=aDDEfgHv7PMMTnZG2QQ0z2n5OuqsYWlNIquJ9ZXmrSyQv0IHyXr9rqJ8ug8ZxraicQaB
	 3pr3a6BHRVvmQMKiQBeF2tFI0ZePvVpMwlyHJnmCybHI4Ky7gKuR62uFXjaoQEsh0Vjl0
	 VmrfHHom19N2pNKpLrXl7wkZs/m4YOs0gnf1lf5OWu33C8+7ucRRz6rvja3ABOoJTz7BU
	 fJ3Y7lLLD2La0obDOSJC0lskIvvCbmbz0fBEkCQSWiYku9pmSipc6ST8vfHjvsjzdCJoR
	 h+TxHMi0m+VfKwGZQtFZWD85/L8xorUMXx0IEiHloP5g98O8unXBe6R1UQKh7FGW+Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kMjOCzTHCwsf7ZspRuDVRTAUiVvOaNs/zEtrpytJLKA=;
	b=S4qhLpIfNn76Ut+HyRd7JW/rB+ffXjg/WB4SMkE6qXLwavNuphcfH97x3u55wqPeF7wE
	 3Wc4e60AGxmlPk0MHIrDx/wAmgkwUJC/ZmM5pDJ7VrKMiceGkiDz79zsFgYuwm3WmSST5
	 nyGZ9V2Kv1VXZYXFiyz69Tssh14FLlIcCMg2EaxwYtLJnPRezz3HO/8UTPZEQwZVoUgEr
	 eC0wT8Xrnahv/QNf/GOeBhxEq8fk6Qq8qw0UtXCxYWg74PSIDIJfoRl4LzjyE88Ti5DT0
	 1PRz6z5jGv+faXsylvO84t7zOF+jML5ywFpqaL3Rfb5nj4FeidZzM8blSISmaFWzJqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zM+tSc5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B3B6072F7B;
	Wed,  4 Nov 2026 21:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zM+tSc5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2368E1F00A1C;
	Wed,  4 Nov 2026 21:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826834;
	bh=kMjOCzTHCwsf7ZspRuDVRTAUiVvOaNs/zEtrpytJLKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zM+tSc5CUbIXeD1P1Y67iLM/Ytu9jXXJ6W4W1xtH2yMFYuyc5A2EqGG90ZnQImk4m
	 ktZ0GpR8NiG8YtqK0u9FparHIbmRK4UmZ0MkmmX++ZBYtaqLVDsUBrpNYjemr/T6Wq
	 CyOzrlf2Mq4Chp1FfJRoMqpFLNDY6D5z5Ymd55eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 035/547] io_uring: wake ring pollers for local task_work
Date: Wed,  4 Nov 2026 16:03:39 -0500
Message-ID: <20261104211039.337055031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b88902d8745a701d24275d012f0830e3628e2a22 ]

With IORING_SETUP_DEFER_TASKRUN completions are queued as local work, and
only become CQEs when the submitter enters the kernel to wait for events.
For an application that finds out via poll() or epoll on the ring fd when
it is time to do that, io_uring_poll() reports EPOLLIN if local work is
pending.

That only helps if the work is there at the time of the call. When
DEFER_TASKRUN was added, io_req_local_work_add() did io_cqring_wake(),
which took care of tasks sleeping in poll() as well. Then polling got a
wait queue of its own, ->poll_wq, and the wake up in
io_req_local_work_add() was replaced by waking the submitter directly.
Since then ->poll_wq is only woken when CQEs are committed, which for
such a ring is done by the very task that is waiting to be told to:

  submitter                           completion
  poll(ring_fd)
    io_uring_poll()  // nothing yet
    schedule()
                                      io_req_local_work_add()
                                        // ->cq_wait_nr: nobody waits
  // sleeps on

Wake ->poll_wq when the first entry is put on the work list. Like for the
eventfd, that must not be done right away if the work is queued from a
wake up handler, as the chain of wake ups could get back to the wait
queue whose lock is held. Use an RCU callback in that case, with a
reference to the ring.

Fixes: 130bd686d9be ("io_uring: waitqueue-less cq waiting")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-19-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/tw.c                  | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e90e5b5dd70ab..c5edf6246a4b4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -519,6 +519,9 @@ struct io_ring_ctx {
 	u32				iowq_limits[2];
 
 	struct callback_head		poll_wq_task_work;
+	/* deferred ->poll_wq wake up for local task_work */
+	struct rcu_head			poll_wq_rcu;
+	atomic_t			poll_wq_rcu_pending;
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 	/* drain request dispatched from ->defer_list, until it completes */
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 98e3b1bc61b4b..0b5066f972245 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -148,6 +148,37 @@ static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
 	}
 }
 
+static void io_poll_wq_wake_rcu(struct rcu_head *rcu)
+{
+	struct io_ring_ctx *ctx = container_of(rcu, struct io_ring_ctx,
+					       poll_wq_rcu);
+
+	atomic_set(&ctx->poll_wq_rcu_pending, 0);
+	io_poll_wq_wake(ctx);
+	percpu_ref_put(&ctx->refs);
+}
+
+/*
+ * io_uring_poll() reports pending local work as EPOLLIN, as it takes a trip to
+ * the kernel to turn it into CQEs. Let those know who are asleep already.
+ */
+static void io_local_work_wake_poll(struct io_ring_ctx *ctx, unsigned int flags)
+{
+	if (!(flags & IOU_F_TWQ_IN_WAKE)) {
+		io_poll_wq_wake(ctx);
+		return;
+	}
+	/*
+	 * Called from a wake up handler with some wait queue lock held, this
+	 * one could lead back to it. Do it from a clean context.
+	 */
+	if (!wq_has_sleeper(&ctx->poll_wq) ||
+	    atomic_xchg(&ctx->poll_wq_rcu_pending, 1))
+		return;
+	percpu_ref_get(&ctx->refs);
+	call_rcu_hurry(&ctx->poll_wq_rcu, io_poll_wq_wake_rcu);
+}
+
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -174,6 +205,9 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 		io_ctx_mark_taskrun(ctx);
 		if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
 			io_eventfd_signal(ctx, false, flags & IOU_F_TWQ_IN_WAKE);
+		/* whoever sets the flag wakes ->poll_wq afterwards */
+		if (data_race(ctx->int_flags) & IO_RING_F_POLL_ACTIVATED)
+			io_local_work_wake_poll(ctx, flags);
 	}
 
 	/*
-- 
2.53.0



