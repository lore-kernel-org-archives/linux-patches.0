Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618306;
	b=gH21xZXCjzW1VpL/DUfaIXtTZD9rCTSUorV4x7c6olZrgeBA8Zauj848qcCUrIbj/yUJ
	 T2BRQ2bm+VK/xNAhQO46OFkwatgNidsyVkvfqSxY06mi3BDaLCa2O/3T8VAY+JEXxbK4l
	 YAK/mZcxKTMjHq6rQQAESIT6QENq5XnzQk+sz1yq3P8wwFBmsI+szd0fBP3vRWRp/xsNJ
	 Ts5tho6/LN/xyfp002Kh2iKJqyOHjrN+d8522UnMzrpCskpeYqkVOV6d3dj6D7POQdZjb
	 bgNlub6MWB1kIqViJqiHqnfJdgGmPFe/WG15lLcdgQDKgWoGI2aYaiKz5Zup4vsV5Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tNdd0oV99P9N5pPwPosLEPhn+MQkYmjNlsOlk4nYHJo=;
	b=PMNpD+Z4YsPQx6ZErSASajp2Z5T3G6z/oXnHqAxhWEyQEQ+xpaePv3dfJyh/+9KdqpVe
	 75f7wkjlWOJkyAd0acuUyqhqV4XIO039/YSOE3XKkEBgpozIEVMC70tHFP4XN7q98apim
	 B7BStGV+2yA/zpGlr1UDPdW2rpYVqTqm2rFyroVLjogdNkhXQyjqfjPvhMt10N3x+8YCi
	 EdgfIfIfj+iGnMQbkL4zr27ahx4J10FTKi15DUJHmPdFbar0e4syAVSzBjAxzVgrFVD8a
	 UHTignoQymEs2Q6gTBEUUtzXGduUX9LbJPm0V8Wrb2NPbxGAM1g9tiKL2aLS9vcwZiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xY1SvFHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9075C606A321;
	Wed, 25 Nov 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xY1SvFHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD561F000C0;
	Wed, 25 Nov 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618306;
	bh=tNdd0oV99P9N5pPwPosLEPhn+MQkYmjNlsOlk4nYHJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xY1SvFHWSA8E/XbbzwE0R8MSAiZJD15g2lplO/U5lax7zSUAy3oGw4/WyJX0YtCYK
	 4ZeoR90YFbLXMIImTRXlYlToGy7Nb8JSUkuWnn0BhJAXpZFSpiw766JvtbL2PdCMNy
	 Z7O7a9iMBlE84m3C0YvRUpxGrBwfwnIF7FDairuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0238/1005] blk-mq: reset queue state on scheduler teardown
Date: Wed, 25 Nov 2026 15:26:16 +0100
Message-ID: <20261125143827.314118893@linuxfoundation.org>
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

From: Jianan Huang <jnhuang95@gmail.com>

[ Upstream commit 3a9892bca4dd0182db61702e131cad569b1d71e6 ]

We observed I/O timeouts with requests stalled in per-CPU software
queues.

The affected queue had no elevator, but QUEUE_FLAG_SQ_SCHED remained
set. A failed elevator switch can leave this state when falling back to
none without clearing the flag. With empty hctx dispatch lists, a
queue-wide restart on CPU4 would skip requests pending in ctx5/ctx7:

CPU4: blk_mq_run_hw_queues(q)
  sq_hctx = hctx4
  hctx4: no pending requests   -> selected
  hctx5: 9 reads in ctx5       -> skipped
  hctx7: 3 writes in ctx7      -> skipped

The pending requests may remain undispatched until another event runs
their hardware queues.

Clear the flag and restore nr_requests and async_depth to the driver
queue depth in the common scheduler teardown path, covering both
scheduler exit and failed initialization.

Fixes: 4d337cebcb1c ("blk-mq: avoid to touch q->elevator without any protection")
Assisted-by: LLM
Signed-off-by: Jianan Huang <jnhuang95@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261023092611.116795-1-jnhuang95@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 0a00f5a76f5a8..d7b45778732b8 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -374,7 +374,7 @@ bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
 
-/* called in queue's release handler, tagset has gone away */
+/* Clear scheduler tags and reset queue state. */
 static void blk_mq_sched_tags_teardown(struct request_queue *q, unsigned int flags)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -385,6 +385,10 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q, unsigned int fla
 
 	if (blk_mq_is_shared_tags(flags))
 		q->sched_shared_tags = NULL;
+
+	blk_queue_flag_clear(QUEUE_FLAG_SQ_SCHED, q);
+	q->nr_requests = q->tag_set->queue_depth;
+	q->async_depth = q->tag_set->queue_depth;
 }
 
 void blk_mq_sched_reg_debugfs(struct request_queue *q)
-- 
2.53.0



