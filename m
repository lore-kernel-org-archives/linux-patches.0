Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060161;
	b=iWisnl3JDD1TxcyNiIjFq4OgjtP04mEQrsqHvTGcqN4cQUGSOqUnkEXAG5qXU8AO2vXb
	 ZwVXO4jFKt8bw8RsJ0RzjHmmn7zPGiZ34AmSf2amkudkGwLsHKFqR93nOJuaLLuSegP5a
	 eqqnoz5H709+FZII1lC6MBTjqrxvi0v9YZOm59xa6CdPDR6KyJMR1sqb3CiigClBAKKzE
	 w3MhuA0HjyMnRlGsCNA9mtz9yX4ZE9IEieYR05pgl0YvAcmpd62XiLvYodroKy9a3BTQ7
	 4qDhfhUA9NAvZ51YmwKAP8I12CmF4mH8ZCOIatpYtmpZqHKgJJ3bk/uLGAysnbYrs8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aHrZ2Cy8AtzYkiLthLGmnMY8lh4xFIFGi0pYadlZCb8=;
	b=xARQh+O04KDiikfu5MS/jVKZeFdu/jli8rl0aK9GB9RY1HE0NRApPrBmw5qbLGLj5reo
	 lVhSpBUZuYqhzOV3NxJlxPtw7Q+7rjuaXgj5joBNj32WoYuX66TxZ7IrRUxq3iNcjLj7a
	 jYi0TTiCANiLbFxr2a8Qlo5QvNlU4Npr8oNJf+K314JXbxtp5rCBmfkPYTgorqGAvF0Y4
	 pg2/AOtGwpkW+BCiAwEk6a3bc5N+22VK2dAMU7ttJV1ehJ+arbjuhx4RrOLozDdPwLfb4
	 ItWZxdR6jqO+LMWwEqnjGaIE7dUJIqJ5iCyqrDoDC41j1m8d6pqm3wU+J6B2dZkFo0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Iey1p1h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6F4606A325;
	Thu, 19 Nov 2026 03:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Iey1p1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3CA1F000C4;
	Thu, 19 Nov 2026 03:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060161;
	bh=aHrZ2Cy8AtzYkiLthLGmnMY8lh4xFIFGi0pYadlZCb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Iey1p1hdrOgV6zmzywBxrwXrrjXshi0qQBD+uFazwUQM7t7PTzYLbfgrfwMxepXs
	 aQeSSfbYZfyKjqzL1D9QJc/yeNOxwt0h3AuenZjHJVCkNw0TglkLgy8qbWA1XA+yOv
	 kg9vPiG9ODyaH4Y8kEmbdthDUqH4JAY6H6lgHDNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1099/1848] blk-iocost: Simplify ioc_rqos_done()
Date: Wed, 18 Nov 2026 15:52:17 +0100
Message-ID: <20261118150005.087087585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 62c159a03da92121b1b909fd8039028de97885fc ]

Leave out the superfluous "& REQ_OP_MASK" code. The definition of req_op()
shows that that code is superfluous:

 #define req_op(req) ((req)->cmd_flags & REQ_OP_MASK)

Compile-tested only.

Cc: Tejun Heo <tj@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20220615225549.1054905-2-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e9804489e27d ("blk-iocost: account flush sequence latency only once")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 46f2b01c782a3..f7e6590d66d9b 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2786,7 +2786,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
 		return;
 
-	switch (req_op(rq) & REQ_OP_MASK) {
+	switch (req_op(rq)) {
 	case REQ_OP_READ:
 		pidx = QOS_RLAT;
 		rw = READ;
-- 
2.53.0



