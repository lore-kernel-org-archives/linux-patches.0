Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061808;
	b=Rb7MjYqho3QttKiZr7PbdV7aCLr4LbAaaAE3z/3JwV1n2sEUtvmlEMEoWCMdij9udfYT
	 xNpi7cEW0FgnbIOtk4LeqG96a3pi4AzqebeRYjrZKh+VZ1zCt1VImLaTsGh+yrS9X/7EP
	 yzu3NGlAKd3iHViWBq0fDk8RkXXs8GiK6rkVDjObfKXSJbrQMHrV0Ht/fISo4ldvfD0o0
	 vLMDP9gKAJhgSQtbQenyae/VM29ZzIg6JQPBIs7UrTktSsCY0RSaGBIY2kibOjLsr66Kd
	 O9MaAMTEHPLhSQpV81VY+7xT5hL6DTjp/PONhk0YUlc7cIY12PZkvnTEj+jfR5qLctg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bKY1jYjxjVBraDWdETh1BnsbZoRto+MgBGpdd9ahv4Q=;
	b=rgekxvxJrCB5KppWLgGpQeEeQaf0EcTQFbVUqnEBL+tF+PwOeUBj9x3J3Zt2sDuJPCwn
	 RB6Mlvzfgk3CZj6LFG00aiYAv7fcYAq3dR/C2lGBoBPne+dj3jJIXyZ/eDL5Kxta2fzWc
	 3UUc69/beI0GtHGaXrGqza08rs7KVXwuq9h0WxSpxD82/2ycqn0yoHmJR6qPW88gN7ISG
	 6rfDiFXi31pa9L6thx76V/fDOaH4c0V6deh77lL4PAWgQObLW0hhr3WWeTn4V1nL3n5ry
	 d8v730K0AXlLz4aOPNptq0w+0+aZpeMExMAmuNSY4hRdzhUUzty6ipDU+jAihU/R1KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIZAWAoX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B6B606A326;
	Sat,  7 Nov 2026 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIZAWAoX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC501F0089F;
	Sat,  7 Nov 2026 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061807;
	bh=bKY1jYjxjVBraDWdETh1BnsbZoRto+MgBGpdd9ahv4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIZAWAoX05dW5TFLXa1WG2+WRAWkDXyE8khqa2qzd1kjVUh9fPlPYIePeOKBnhEny
	 1Fr/v2Qt0FovyuNW3mSZUZ5KXS0SEJYMcxb6uSjqrVKJ1wyPGiNM8A6gB7i62qJGmK
	 sgCCacmnYx1StxwtpW+ubhz/2VM6UH/+V6sv8AKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0835/1536] io_uring/sqpoll: dont wait for the thread to exit
Date: Sat,  7 Nov 2026 08:47:31 -0500
Message-ID: <20261107135021.000447163@linuxfoundation.org>
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
@@ -59,6 +59,24 @@ void io_sq_thread_park(struct io_sq_data
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
@@ -73,7 +91,6 @@ void io_sq_thread_stop(struct io_sq_data
 		wake_up_process(tsk);
 	}
 	mutex_unlock(&sqd->lock);
-	wait_for_completion(&sqd->exited);
 }
 
 void io_put_sq_data(struct io_sq_data *sqd)
@@ -82,7 +99,7 @@ void io_put_sq_data(struct io_sq_data *s
 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
 
 		io_sq_thread_stop(sqd);
-		kfree(sqd);
+		io_sq_data_release(sqd);
 	}
 }
 
@@ -156,10 +173,10 @@ static struct io_sq_data *io_get_sq_data
 
 	atomic_set(&sqd->park_pending, 0);
 	refcount_set(&sqd->refs, 1);
+	refcount_set(&sqd->free_refs, 2);
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->exited);
 	return sqd;
 }
 
@@ -426,7 +443,7 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 err_out:
-	complete(&sqd->exited);
+	io_sq_data_release(sqd);
 	do_exit(0);
 }
 
@@ -540,7 +557,8 @@ __cold int io_sq_offload_create(struct i
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


