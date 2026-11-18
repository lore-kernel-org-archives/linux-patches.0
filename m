Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046045;
	b=Jn6Wmh+MBtA+Ap5uCXtpKSfGm0agSXAg1TazPSpNHzsHJZD6hItc9/9a5Ri7wT5YWeFw
	 UCJv0croWoFNA+A5VBLxuzN7kyx+SIm6glQ4HufEz0KtKj3OaT9PfIVSDtXfekEpvjhI+
	 6fu5SmLK20WxkaCG5b6hGHTk9yeF29Sun2cJvwjQju89Il3/zZCAwwwGbqGxNWIum1Bd4
	 E07ylAuuEQiCq+GsuCDTvGCtdzvRqDNTE56gnKmprs8ZJimKsumgOXOA1jKfidiHYxlJ1
	 QoZ8BtGQsNO1s887MC5E34MIBjiPN3Ahd2Yv7pSL0kci2Txi9oMXYSpyjZ3Ti1JE98Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KL4eQ4diLhsUr8nXRX9ZlpRnoqao2dPlIR/fErpGQeY=;
	b=FyVqWNRIlviZ7USFRp31Np99g74pwaY8aIQM3B6JBqeKrqDC1ix7aHKviTXOXxK6Ad3/
	 Y9Ore8w2DGxscGVYLk5zJLFgwCqPvxjgWXenQ5boCzQE7VpvPCQyvl6XN03Dp/vEOqM6f
	 6b5k5XCgIFPSvHjc89Y+BkgP51InE/0KuuqtR1j5+LToDrOIxWEnritA1sMHgakQZykhb
	 CPyfoCGG12iqfKg4DH6fIBTaA2AXZcYzSNdg/Q/Mb7qDUqcJzVWTVruqMEAv7BATtKBi4
	 eo4/hk1tX6wzVbDqC6FVfW1HcKRjJ+mqKcQfEFmunmGJCBdFvyL+6UUvVUcQPo5ZMgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsULNf8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F871606A32F;
	Wed, 18 Nov 2026 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsULNf8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F481F000C4;
	Wed, 18 Nov 2026 23:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046045;
	bh=KL4eQ4diLhsUr8nXRX9ZlpRnoqao2dPlIR/fErpGQeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsULNf8nPBtVQ4gMvCl9yKxEXlBmN+cmk9t5hYjtDYB4zLpwhjLjFaUcqjvP2iyve
	 dFWvZChG57gB5DSyiKzg0pQjQRJaSe9pjcNtskl/aUOxm/M88TdtB3nK2ZRJiRVo2c
	 Q08Xqme/qzso0PmbHaUfF7Wi48OvV5FZx6m7FDSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+675af112519ca34f5502@syzkaller.appspotmail.com,
	Shuai Liu <847807867@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1141/2857] io_uring/sqpoll: dont set IO_SQ_THREAD_SHOULD_STOP on thread exit
Date: Wed, 18 Nov 2026 15:36:15 +0100
Message-ID: <20261118150242.670656011@linuxfoundation.org>
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

From: Shuai Liu <847807867@qq.com>

Commit fca3ff9e2eee7d285585daf51942e0b5e2be354a upstream.

io_sq_thread_stop() carries a WARN_ON_ONCE() asserting that
IO_SQ_THREAD_SHOULD_STOP isn't set yet, i.e. that stopping the SQPOLL
thread is never attempted twice. Since commit 22d9db9fd64a
("io_uring/sqpoll: don't attach to a thread that is canceling"), the
SQPOLL thread itself sets that bit on its way out, so that
io_sq_offload_create() won't attach a new ring to a thread that is
canceling.

When the thread exits on a fatal signal, the bit is thus set before the
ring teardown gets to io_sq_thread_stop(), which now triggers the
warning on every such exit:

  WARNING: io_uring/sqpoll.c:88 at io_sq_thread_stop
  Workqueue: iou_exit io_ring_exit_work
  Call Trace:
   io_put_sq_data
   io_sq_thread_finish
   io_ring_ctx_free
   io_ring_exit_work

Introduce a separate IO_SQ_THREAD_EXITING bit for the thread marking
itself as on its way out, and check it in io_sq_offload_create() along
with IO_SQ_THREAD_SHOULD_STOP. IO_SQ_THREAD_SHOULD_STOP regains its
original meaning, "a stop has been requested", and the WARN_ON_ONCE()
holds again.

Reproduced with an SQPOLL ring and an immediate fatal signal: the
warning fires on v7.3.0+ (22d9db9fd64a present) and is gone with this
change.

Reported-by: syzbot+675af112519ca34f5502@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=675af112519ca34f5502
Fixes: 22d9db9fd64a ("io_uring/sqpoll: don't attach to a thread that is canceling")
Signed-off-by: Shuai Liu <847807867@qq.com>
Link: https://patch.msgid.link/tencent_BB08960D79E0261B5C1EB1E589787734E907@qq.com
[axboe: trim excessive comment]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a9400233053d3..dd6f279ef17cb 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -23,6 +23,7 @@
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
 	IO_SQ_THREAD_SHOULD_PARK,
+	IO_SQ_THREAD_EXITING,
 };
 
 void io_sq_thread_unpark(struct io_sq_data *sqd)
@@ -340,9 +341,10 @@ static int io_sq_thread(void *data)
 	/*
 	 * Cancelation drops sqd->lock while it waits, and a ring could attach
 	 * to a thread that is on its way out. A fatal signal doesn't set the
-	 * bit, so set it here for io_sq_offload_create() to see.
+	 * stop bit, so mark the thread as exiting here for
+	 * io_sq_offload_create() to see.
 	 */
-	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	set_bit(IO_SQ_THREAD_EXITING, &sqd->state);
 	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
@@ -419,7 +421,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		/* don't attach to a dying SQPOLL thread, would be racy */
 		ret = 0;
 		if (attached && (!sqd->thread ||
-		    test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)))
+		    test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state) ||
+		    test_bit(IO_SQ_THREAD_EXITING, &sqd->state)))
 			ret = -ENXIO;
 		io_sq_thread_unpark(sqd);
 
-- 
2.53.0



