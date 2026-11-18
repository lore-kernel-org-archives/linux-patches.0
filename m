Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050814;
	b=yDks9g0wSYImSsCABiuKIHjPVQ02Czro4KnwxfJTouyuGgqgqkyMp7UU88/WiIgvqhY9
	 DDufhWY+qKnwphRyk5x6EthoBoo5Lsr7ivazCGN0Bvw8pBT9ofm5EOU0i6rokKJkfUtNf
	 XWbfadcOpitSt/iWdhwbshRo9mI89XHQ49PMYUM27s5H/O4AllqFV+RJGFMTSA+oDnEwv
	 94Wazi3UxWMP81RlbjtgtvYsXdonZSLKl3adwZ6kMhoGrM2xwkFkzkxbMbdF9yBiQBwQN
	 ufd+ZgEkj0vmeq5WUuhFK+46hKwKhecgIIH9qAqRccEQN//oD67PzfgAD3VWwj9uSYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rMKzaSbzatGzyH9bWJkNUjgwCUXx3c6yYhZueYiPlmA=;
	b=osL+wIa81CPPmKJEO7ggG9Fr32zxOEHKxUYg9CEUJP14jGlM8Lzn8f1AANsI+RB9lyNc
	 uOLfSHS7ubb5UlLACZpibp7+4P1A5CS8ARqpTod2vj8L+phrH3gaQrrWTm4O5B9kx8ewM
	 cKTGQO8CaZs8bzwIDRAxsYmsfAUQe91ViJubh2DMokgOZv4AURu005RXrci2O7Xvo5V2X
	 cGqXwQ9IPP81pi0+iJ8Ja8kxOPeArUxY2Ks1fmvp5eLl8HlJYl/wXvkpSKlqsC6bYWaew
	 CkrCdEZmqltd6mzEV6TPYyCIu5gUNucrRWfGE3x7I23e7YrkABBGwTb6LqKmyid9K/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDQKXOqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB7606A32A;
	Thu, 19 Nov 2026 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDQKXOqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4151F000C5;
	Thu, 19 Nov 2026 01:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050814;
	bh=rMKzaSbzatGzyH9bWJkNUjgwCUXx3c6yYhZueYiPlmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDQKXOqQDcVCmTvd9V2hHGeRYhDn9X0eQvDLcKqL+U/dLGiYuIZAOx3JKDKOgwnrz
	 zXdJjLt/plIBZXzveM/awLfJ0x446p0vvsi4BDWH9sVw1Fj/3nA3tTmIFgQ2LHvMEb
	 DhXA9to4NzSwBVVfdaEiiT+suMUoaz8isi8W2BRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2802/2857] blk-mq: dont bring back flags of a completed request
Date: Wed, 18 Nov 2026 16:03:56 +0100
Message-ID: <20261118150342.483140105@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 9531230ee1fcb8eca2c9cbb9bf02651cbf798842 ]

The timeout handler sets and clears RQF_TIMED_OUT in a request it only
holds a reference to, with a plain read-modify-write, while the
completion clears flags in rq_flags the same way. If the two interleave,
blk_mq_finish_request() runs twice with the flags back: the zone write
plug reference is dropped twice and the scheduler's ->finish_request()
is called again.

Change RQF_TIMED_OUT with cmpxchg, so the handler never writes back a
flag that changed under it.

Fixes: e5c0ca13659e ("blk-mq: release scheduler resource when request completes")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-31-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c      |  2 +-
 block/blk-timeout.c |  3 ++-
 block/blk.h         | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 155d602bb2afb..4229ec5899268 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1559,7 +1559,7 @@ EXPORT_SYMBOL_GPL(blk_mq_queue_inflight);
 
 static void blk_mq_rq_timed_out(struct request *req)
 {
-	req->rq_flags |= RQF_TIMED_OUT;
+	blk_rq_change_timed_out(req, true);
 	if (req->q->mq_ops->timeout) {
 		enum blk_eh_timer_return ret;
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1b8de0417fc1a..0590720e38c7f 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -137,7 +137,8 @@ void blk_add_timer(struct request *req)
 	if (!req->timeout)
 		req->timeout = q->rq_timeout;
 
-	req->rq_flags &= ~RQF_TIMED_OUT;
+	if (req->rq_flags & RQF_TIMED_OUT)
+		blk_rq_change_timed_out(req, false);
 
 	expiry = jiffies + req->timeout;
 	WRITE_ONCE(req->deadline, expiry);
diff --git a/block/blk.h b/block/blk.h
index db6232c5be60f..bd5ad5515510e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -251,6 +251,20 @@ unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 const char *blk_status_to_str(blk_status_t status);
 
+/*
+ * The timeout handler changes RQF_TIMED_OUT in a request which it does not
+ * own: whoever completes it changes rq_flags at the same time, with plain
+ * loads and stores. Never write back a flag that has changed under us.
+ */
+static inline void blk_rq_change_timed_out(struct request *rq, bool set)
+{
+	req_flags_t old = READ_ONCE(rq->rq_flags), new;
+
+	do {
+		new = set ? old | RQF_TIMED_OUT : old & ~RQF_TIMED_OUT;
+	} while (!try_cmpxchg(&rq->rq_flags, &old, new));
+}
+
 enum bio_merge_status {
 	BIO_MERGE_OK,
 	BIO_MERGE_NONE,
-- 
2.53.0



