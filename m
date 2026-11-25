Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617589;
	b=leEdgLJ2ERYfR2HxTfOtsdj56eyVlXK3jAS1ZCFJj2JmlwByaQRsr09OKWF7cC1GEng4
	 sL+rMLA/YyjYIQuWkaI1tK+qPzFZAHgmCzviyWpCUzG8PD7Bc2/x50nRO5xOjF5Ke1laB
	 2SSs7tSo+KPtWPG4TP8zcXRNTf1+37AUz6b0u5w6TH6WdCkM4ZuQshhIrLxOM+jBsGee/
	 zDc1b+HgF+E545GYMdYFQNhkuBSA1tB1HUZJUWiqWzKyzNTyqRjN8B5wahnNvUGqG8oQw
	 CBQuwj93yKUJLScTTKpDxCtbBfQQE8Z/h3LkIflagsVuBP1ceB8buCw3onaEg4tcZMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/XbNFm1uiKafjCdEZMhXuIXMKU2R8Ls1EICplWiEew=;
	b=jzJWjPcxiI91c9E1cxNKgXb7lGwxLVkB4kVc9KEkwIn93/nTaTa5EOaks9ETRzUe4/DZ
	 jeS+JQGIUOSJgvekFhvNPcdFlIaAIXcI0+a0LhfKeO+LFlhCf0mIVYvUPGBcwm/5Dhado
	 /d/QqgSSEz27NfREeVyhPq5ewTainB5UtYMDeAUdM3SJAJYp62O1zAVgmSlxjQUXcMQg0
	 7dORfQW4KB7UttaJGdZ6xtUQ/GIEOa9bv4WGre9h9t8sd7oR/I/2+bajK1/jKR1+ONGle
	 pZSLUgrWJiLWFWKD1JJP+yYdAp+cRd7kR3UYNYrWpaiy/PheN72mgKwuPl6LcFMRYAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tj9k3rR7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A2606A31E;
	Wed, 25 Nov 2026 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tj9k3rR7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E9F1F000C0;
	Wed, 25 Nov 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617589;
	bh=P/XbNFm1uiKafjCdEZMhXuIXMKU2R8Ls1EICplWiEew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tj9k3rR7up6WnsxAUPqqeV8A1weR5ahN4yktZvIazCuMsce5TxNWoJLNjkF20Bwx+
	 muuOIWZU+dxgKVVFg+kHDvhoPpKwZPxaAgZD7ya74O6gwonY5m8ROZty0+6B7KwjD3
	 xOvjrUKSkeS0P/TcODD0lo9f6r8fcwvFBRUQU6Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cinq Prairie <notprairie@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0014/1005] io_uring/napi: dont end the single NAPI busy poll early on need_resched()
Date: Wed, 25 Nov 2026 15:22:32 +0100
Message-ID: <20261125143822.069703834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Cinq Prairie <notprairie@gmail.com>

Commit 39c7210e970200f8b17de3767c73efe64173a95f upstream.

With a single registered NAPI, io_napi_blocking_busy_loop() hands
io_napi_busy_loop_should_end() to napi_busy_loop_rcu() as loop_end and
runs its own loop once, relying on __napi_busy_loop() to spin until
that predicate fires. napi_busy_loop_rcu() sets NAPI_F_END_ON_RESCHED,
so __napi_busy_loop() also returns on the first need_resched(). io_uring
treats the return as the end of the busy poll period and sleeps in
schedule_hrtimeout() for the rest of the wait timeout.

With two or more NAPIs the inner loop is single-shot and io_uring's own
loop runs until its predicate is met, so busy_poll_to is honoured. The
same registration therefore behaves differently for one NAPI than for
several.

Make the busy poll deadline absolute, stored in io_wait_queue, so that
io_napi_busy_loop_should_end() no longer depends on the start_time the
napi loop snapshots on every entry. The single NAPI loop can then be
re-entered after an early need_resched() exit if there is budget left,
and the loop condition drops the "run once" special case. The fast path
that holds the NAPI across polls is kept.

Measured on io_uring-7.4 at 9c207aa58e54, x86-64, HZ=1000,
PREEMPT_DYNAMIC (lazy), no CPU isolation, low RX traffic, r8169 with one
RX queue, prefer_busy_poll, busy_poll_to = wait timeout = 10 ms.
"waker" is a SCHED_FIFO task pinned to the polling CPU waking every 1 ms:

  1 NAPI, waker, before:  busy 0.5-1.5 ms per 10 ms wait, ~0.8M polls/s
  1 NAPI, waker, after:   busy 10 ms per 10 ms wait,      ~16.2M polls/s
  1 NAPI, idle, before:   busy 10 ms per 10 ms wait,      ~15.3M polls/s
  1 NAPI, idle, after:    busy 10 ms per 10 ms wait,      ~16.2M polls/s
  2 NAPIs, waker, before: busy 10 ms per 10 ms wait,      ~7.2M polls/s
  2 NAPIs, waker, after:  busy 10 ms per 10 ms wait,      ~7.1M polls/s

The held-NAPI fast path polls about twice as often as the single-shot
path used for several NAPIs, which is why it is kept.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Cc: stable@vger.kernel.org
Signed-off-by: Cinq Prairie <notprairie@gmail.com>
Link: https://patch.msgid.link/20261027204840.7823-1-notprairie@gmail.com
[axboe: trim comments, drop __always_unused]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h |  1 +
 io_uring/napi.c     | 31 ++++++++++++++-----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2d6b2158605ad..0cb053aabe4b0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -139,6 +139,7 @@ struct io_wait_queue {
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	ktime_t napi_busy_poll_dt;
+	ktime_t napi_busy_poll_end;
 	bool napi_prefer_busy_poll;
 #endif
 };
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 7e698720cd51a..54c1b328a89d3 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -134,19 +134,15 @@ static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
 		__io_napi_remove_stale(ctx);
 }
 
-static inline bool io_napi_busy_loop_timeout(ktime_t start_time,
-					     ktime_t bp)
+static inline bool io_napi_busy_loop_timeout(struct io_wait_queue *iowq)
 {
-	if (bp) {
-		ktime_t end_time = ktime_add(start_time, bp);
-		ktime_t now = net_to_ktime(busy_loop_current_time());
-
-		return ktime_after(now, end_time);
-	}
-
-	return true;
+	if (!iowq->napi_busy_poll_dt)
+		return true;
+	return ktime_after(net_to_ktime(busy_loop_current_time()),
+			   iowq->napi_busy_poll_end);
 }
 
+/* Uses an absolute deadline, so the napi loop can be re-entered */
 static bool io_napi_busy_loop_should_end(void *data,
 					 unsigned long start_time)
 {
@@ -156,8 +152,7 @@ static bool io_napi_busy_loop_should_end(void *data,
 		return true;
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return true;
-	if (io_napi_busy_loop_timeout(net_to_ktime(start_time),
-				      iowq->napi_busy_poll_dt))
+	if (io_napi_busy_loop_timeout(iowq))
 		return true;
 
 	return false;
@@ -215,13 +210,16 @@ __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
-	unsigned long start_time = busy_loop_current_time();
+	ktime_t now = net_to_ktime(busy_loop_current_time());
 	bool (*loop_end)(void *, unsigned long) = NULL;
 	void *loop_end_arg = NULL;
 	bool is_stale = false;
 
-	/* Singular lists use a different napi loop end check function and are
-	 * only executed once.
+	iowq->napi_busy_poll_end = ktime_add(now, iowq->napi_busy_poll_dt);
+
+	/*
+	 * A single NAPI is held by __napi_busy_loop() for the whole spin. It
+	 * may return early on need_resched(), loop until our own deadline.
 	 */
 	if (list_is_singular(&ctx->napi_list)) {
 		loop_end = io_napi_busy_loop_should_end;
@@ -232,8 +230,7 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 		do {
 			is_stale = __io_napi_do_busy_loop(ctx, loop_end,
 							  loop_end_arg);
-		} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
-			 !loop_end_arg);
+		} while (!io_napi_busy_loop_should_end(iowq, 0));
 	}
 
 	io_napi_remove_stale(ctx, is_stale);
-- 
2.53.0



