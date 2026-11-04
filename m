Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831897;
	b=aQ/GOrQCfC17KYTGNJALjStJLwF7jlm6Z5PXDp4nGhLEm+YnmyGE+vAGaFR0BYS0RgiQ
	 QeZ50aXGdrajPg6dJHU+lohi6biXefy+uJ/tnXBeLHp4fubBpQnG8H7IcqSbFBcDscDxO
	 kUKleBN21o1/QwmQJK9s8BT09q1GdBv/3T0ww+vU5imtYvICW+8PISbPfJqTlhqyMQ1rc
	 KhtClOOpV6NekxsMkX8njZf6V6h3YCyF3dUL6spLJ8Infwl6ohbexS5Ii+F7uDAcT8WG2
	 8hlRnCRE7mLPcp1sklan/Pv81ogleerEmjRY7LpPL+HBdxrQi+/KHFoeFltIf/14NIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LX3S/yVbrHA4qvLlk+I/idvLNtvrf9Zv+2FWO1Jaauw=;
	b=1rd8ih+fmvf0kTb5s1iJbdiaSe4CGgdI+5Xj7agb21aY2ZqRRM3ErVfkfdOEjyU4O+wh
	 psVaOctqXsEKUJQoGOp/LHJOywcakZV58zW6dPmfT6rqXKkCQtSZZ3QZlDSn3lJ9RoEvU
	 bb6Z2bdHAP3r0xtkOtgOVsxh7GxTUFTLOf/4rAQS/IM5PYabcjPmswFCPD46pNFKhiabG
	 kQX5rAWUqqGi/sSB3BzdQFeUkbZW9lXe6yNGNn5kCQdPX9X/N7vjhhxsriJgjNLJFLU37
	 r4+Cc3kmopKPDjxEbQF2Cx/m2trGJkfJWa/oK7baO9R7jNpQ4d91iA8Q3IAC4GNaCjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNtaoM9L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0769B606A33D;
	Wed,  4 Nov 2026 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNtaoM9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DFB1F000C1;
	Wed,  4 Nov 2026 22:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831896;
	bh=LX3S/yVbrHA4qvLlk+I/idvLNtvrf9Zv+2FWO1Jaauw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNtaoM9LI6Ig/duqb4NVwMxoidPn6P077Qbzv9Q5BNZcze8s6ljOIvcFr+GWVYIcl
	 5ayBBQ0sNWe1ylmapfRIRLnxiriaAR2YY96Xlqz8S+zw3dbt2h+vOy133NNcFBZXIU
	 s6Chyf38/5ysWRAQlBXBJtt8KHra9ErhduPKjBhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0978/1005] io_uring/sqpoll: dont wait for the thread to exit
Date: Wed,  4 Nov 2026 16:11:51 -0500
Message-ID: <20261104211110.446057609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |   28 +++++++++++++++++++++++-----
 io_uring/sqpoll.h |    3 ++-
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -62,6 +62,24 @@ void io_sq_thread_park(struct io_sq_data
 	}
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
 	struct task_struct *tsk;
@@ -76,7 +94,6 @@ void io_sq_thread_stop(struct io_sq_data
 		wake_up_process(tsk);
 	}
 	mutex_unlock(&sqd->lock);
-	wait_for_completion(&sqd->exited);
 }
 
 void io_put_sq_data(struct io_sq_data *sqd)
@@ -85,7 +102,7 @@ void io_put_sq_data(struct io_sq_data *s
 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
 
 		io_sq_thread_stop(sqd);
-		kfree(sqd);
+		io_sq_data_release(sqd);
 	}
 }
 
@@ -159,10 +176,10 @@ static struct io_sq_data *io_get_sq_data
 
 	atomic_set(&sqd->park_pending, 0);
 	refcount_set(&sqd->refs, 1);
+	refcount_set(&sqd->free_refs, 2);
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->exited);
 	return sqd;
 }
 
@@ -429,7 +446,7 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 err_out:
-	complete(&sqd->exited);
+	io_sq_data_release(sqd);
 	do_exit(0);
 }
 
@@ -543,7 +560,8 @@ __cold int io_sq_offload_create(struct i
 	}
 	return 0;
 err_sqpoll:
-	complete(&ctx->sq_data->exited);
+	/* no thread was made: let go of its share */
+	io_sq_data_release(ctx->sq_data);
 err:
 	io_sq_thread_finish(ctx);
 	return ret;
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -2,6 +2,8 @@
 
 struct io_sq_data {
 	refcount_t		refs;
+	/* one for all the rings, one for the thread: the last put frees */
+	refcount_t		free_refs;
 	atomic_t		park_pending;
 	struct mutex		lock;
 
@@ -18,7 +20,6 @@ struct io_sq_data {
 
 	u64			work_time;
 	unsigned long		state;
-	struct completion	exited;
 };
 
 int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);


