Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044698;
	b=XOajIv30wzwKyqaKdvb1d1z34QVlMwYxqENn+jTnrdssPRxQS5E0mED6fbrJjO9szp7b
	 yqt1JSj33cJjGl/Sl0x4+c0/us1ECRt3hidozBbTSbUgponSdXAqH3GhtgAWinMoaBaAm
	 yi+Z7a9l0lT5wUlXkEgO3WlbQr03DyU/DAnR+VeBXXRpEqixoN5edDl/u56l5cXuU4Wzr
	 KG9FsPeyeCyfJ0KT1YzFKUsY6G1n0vsCNUBxaUTqLHJXuERNJ2a/7VE4IVdL0TtkFuZXV
	 id5FUWzfLgpQSxBCX/yYQBcUv++oH0fy7dq3RYJLVJhgJIuYLgcIbyP/3TURh60bLRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Janzvq4elz70ZJKKx9qTeN8xpLtWYF+/oIxmL+EVoB8=;
	b=CHKsWJGkstlstKiG99yBeNLW8d8drZdwLCQi0750y2m24KvZvV//as+vB32rB9p0A0aJ
	 PhJKc8bj0pq13Lg/f+0toFcem2gk5Ij6F8f1u+rS2LNCNIrzSCckDmC01FZfXfY9MnPbL
	 yPo/uHSZwz+pbnXlgS49QrWzE9VKS4XyBQLSIK4e/XzkV7hX88vdVs7BvB4Hgk20X3Se8
	 4ZjMKKVAcyI4yc6mz0d/3RbsNs835vz+2FuBGkgocNrGnLbW8TjZ/gREkBofelbymKEVv
	 oFrfZWT4DVrXjfpqBjmwJzFB29p14xXGRJiWeNk/+28keddFDxNh+lN8B5qzy7Ucm+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+27nfrJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54B606A320;
	Wed, 18 Nov 2026 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+27nfrJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9BE1F000C4;
	Wed, 18 Nov 2026 23:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044698;
	bh=Janzvq4elz70ZJKKx9qTeN8xpLtWYF+/oIxmL+EVoB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+27nfrJu3UcUBdl6rQ+jk797WR9M6VQcizjqazjBbjYwOsn95VmKWvMxtfwUG7oa
	 WOfikvceOVIkwB5ANklmFXQ1xsADPS7WkC3R8W9IHM9jM4opTI9nD4p3h7BibeJxUv
	 LXxbFDrC2rPQdgZFCNj9JxqGgiiffmlxwCcQqPCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0659/2857] io_uring/sqpoll: dont wait for the thread to exit
Date: Wed, 18 Nov 2026 15:28:13 +0100
Message-ID: <20261118150225.280755814@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit 360395e8dbf9d23579f74b84a1af11190813b0f8 upstream.

io_sq_thread_stop() wakes the SQPOLL thread and waits for it to exit.
The thread belongs to the thread group that created the ring, so a
SIGSTOP or the cgroup freezer holds it in get_signal(), and the wake up
doesn't change that. io_ring_exit_work() then sleeps in that wait until
someone continues or kills the process. iou_exit has 64 slots, so 64
closed SQPOLL rings of a stopped process keep every other ring from
being freed, for everyone.

Don't wait. Set the stop bit, wake the thread, and let it exit when it
gets to run again. The sqd can now outlive its last ring, so give it a
second refcount with one reference for the rings and one for the thread,
and free it with the last one. The thread can't reach a freed ring,
rings leave ctx_list before dropping their reference, and the io-wq hash
is refcounted.

Fixes: 16efa4fce3b7 ("io_uring: allow IO worker threads to be frozen")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.1 has a single exit path in io_sq_thread(), drop the thread's
free_refs share there]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |   28 +++++++++++++++++++++++-----
 io_uring/sqpoll.h |    3 ++-
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -52,6 +52,24 @@ void io_sq_thread_park(struct io_sq_data
 		wake_up_process(sqd->thread);
 }
 
+/*
+ * The sqd has two holders: its rings, as one, and its thread. Neither waits
+ * for the other to let go. The one that lets go last frees the sqd.
+ */
+static void io_sq_data_release(struct io_sq_data *sqd)
+{
+	if (refcount_dec_and_test(&sqd->free_refs))
+		kfree(sqd);
+}
+
+/*
+ * Ask the thread to exit, and don't wait for it. A thread that is stopped or
+ * frozen exits only when a user lets it run again, and the exit work of the
+ * ring would keep its place in the workqueue until then. All rings have left
+ * ctx_list by now and have no request left, so the thread can reach none of
+ * them. What it still uses is its own or counted: the sqd by free_refs, the
+ * hash of its io-wq by hash->refs.
+ */
 void io_sq_thread_stop(struct io_sq_data *sqd)
 {
 	WARN_ON_ONCE(sqd->thread == current);
@@ -62,7 +80,6 @@ void io_sq_thread_stop(struct io_sq_data
 	if (sqd->thread)
 		wake_up_process(sqd->thread);
 	mutex_unlock(&sqd->lock);
-	wait_for_completion(&sqd->exited);
 }
 
 void io_put_sq_data(struct io_sq_data *sqd)
@@ -71,7 +88,7 @@ void io_put_sq_data(struct io_sq_data *s
 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
 
 		io_sq_thread_stop(sqd);
-		kfree(sqd);
+		io_sq_data_release(sqd);
 	}
 }
 
@@ -153,10 +170,10 @@ static struct io_sq_data *io_get_sq_data
 
 	atomic_set(&sqd->park_pending, 0);
 	refcount_set(&sqd->refs, 1);
+	refcount_set(&sqd->free_refs, 2);
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->exited);
 	return sqd;
 }
 
@@ -327,7 +344,7 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
-	complete(&sqd->exited);
+	io_sq_data_release(sqd);
 	do_exit(0);
 }
 
@@ -448,7 +465,8 @@ __cold int io_sq_offload_create(struct i
 		put_task_struct(task_to_put);
 	return 0;
 err_sqpoll:
-	complete(&ctx->sq_data->exited);
+	/* no thread was made: let go of its share */
+	io_sq_data_release(ctx->sq_data);
 err:
 	io_sq_thread_finish(ctx);
 	if (task_to_put)
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -2,6 +2,8 @@
 
 struct io_sq_data {
 	refcount_t		refs;
+	/* one for all the rings, one for the thread: the last put frees */
+	refcount_t		free_refs;
 	atomic_t		park_pending;
 	struct mutex		lock;
 
@@ -17,7 +19,6 @@ struct io_sq_data {
 	pid_t			task_tgid;
 
 	unsigned long		state;
-	struct completion	exited;
 };
 
 int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);


