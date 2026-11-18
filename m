Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033169;
	b=vLz3PI09sJz786iMF9fNODxozEZ4jJEudS6FkDS7nEcG2FnaIOMDTG8C8ztlZ3G683KO
	 EAFYlVAZwgWCnZu4Eh+gaoKZAVlYY2CQvUyPJUu7HlSG9ZKXd4GCeBepfEO/dIigVJH4a
	 T5NzJLCWEq1huaZy4AMD1iuKzw0cPm4lh1g766gDG0s3UktExY7/t0I7p7i8mchVzMCAQ
	 CRgWv2poiYzwTDeF4Xz9NQVzaDgVAw7sPgF5jfOqm6HYUzD2CKA5+7mSIVQSXaZ5qeyCF
	 WbxawXNekYCCisWev8eppM3IzyC6/KVd8p1WmqgamG0eeCHintnTsgES49+9Qzw4hDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1LO7TuPp28dgT6FAGAbyZJPBfSMVt5IbbKAQZb3OQ4=;
	b=oCcf5+DYDvMarJ4JkzES/sIas5PQNDBzEDQkuUuRSJSYCvbDA3DlZw/tm4K6etoP1G+s
	 af4KcOFrgNobZN+X++PvvqeRRMrkosW33AgGJcQxKJm8CCqDFdM87ZwzTBj1eFV1NUdSk
	 LNOs/ZUZukLWoSbpjV4pJ4HyIWcW8Yv4L+ZwAm0fwsM5fprdV5Zb2LeK365MkdulPIvI9
	 gZtvS0OhFVPWP5yn5v9H9PTyBl/sQLuxmoN7Ky0JW0y2lNwbYgY8RLM7sqaL3pzUxdqXQ
	 hQIPuaag9JnLARMK0LUfLWxxKP5TtZ7A7zqHTcl/70lc6Z2L309OMrtN/unkQWnThVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWFmwvIb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D11B606A32C;
	Wed, 18 Nov 2026 20:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWFmwvIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DD61F000C4;
	Wed, 18 Nov 2026 20:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033169;
	bh=u1LO7TuPp28dgT6FAGAbyZJPBfSMVt5IbbKAQZb3OQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWFmwvIbA1+yvpCGxS9Z1MF7miM5mcTDurG9mweq/AGDJ4IhYrYdjCJLVMGFE/EFk
	 /jiU/KAkR/RTYeO5KOBZv6nPsBICfQleh/nqwW7H+yDE7HVUp9LEwSh4U6mf2tFCuq
	 TFdSbgI8t9hOTGez3j38C4iyQAykXbGr9b874sng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1672/1756] blk-mq: dont bring back flags of a completed request
Date: Wed, 18 Nov 2026 16:03:19 +0100
Message-ID: <20261118150116.250605823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 2ef0a69b6dd42..c3c5a5c0772fd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1618,7 +1618,7 @@ EXPORT_SYMBOL_GPL(blk_mq_queue_inflight);
 
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
index 4500ba33dc7af..8458676fb1012 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -316,6 +316,20 @@ static inline void bio_integrity_free(struct bio *bio)
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 
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



