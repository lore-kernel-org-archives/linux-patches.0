Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617605;
	b=KNhd8Bhs/ounROPdnCPZido1SHVA9fhHyirhjrpK6hG82KU2bZ/e3ehLgJn6keCKa/PQ
	 0RZp/PyF4HMaKzEv6S48wkQpgrwKe1kfCmQMy0urnPuZb8/GgWIzVLJsRYcfGIEKwTlRh
	 G/5waPCotXa2RrfFhNT4xxWN/4F82RdeWDgLNe7qGfsaPSOlx1og+wNApFhKbJctuHkCm
	 c3b+bcL12J/KI5i1qb0R2p9CnME+mbkPTpMmaY+nxVUW0/jZ7Jh15q4uvDBGFBVxkREoO
	 f0fqDCPS3IcdFiOh7GRoCXxpYff85wgHtPiuO24/rQTVP+wlcdMt3McwpB9eIMd7NlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bL4mHLSeM/G6/n0X5K/IW2eQDts75FcC/o4HYwiLJC4=;
	b=ZWaBNcGORZO3A0pNzcvemVmvwcuEgJxMBBQFXPwsKoyfj1kUH4ziFkkcoNDyUVvZiIWd
	 7jfqvt4pMgSH7CO5TVFwgA/O8t/nSGEHK9JLcuhTJpxwTFL1nxecQHg7vYPtUAYSrvezs
	 p9Dtc1SbDBJLuYd11KZzbbkea9tkZCTZ3vLruDvyVz8hxb6GlfklNMjT/S7aOHWD4Brv8
	 EQj6oM87sedm0NUH+q7j67QGJVH2Om7PhuJrYs7NvaaL2Sz/nIF/P+SElXDTjqDihJkUG
	 FuiPxf3RI73CMCNObHgNuoNf0J9VwWK4LOOVeq6e1+4KWl2XkIW25PN12yEf3iHoZfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yG/ugAZh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E7606A31E;
	Wed, 25 Nov 2026 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yG/ugAZh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C838F1F000C0;
	Wed, 25 Nov 2026 14:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617605;
	bh=bL4mHLSeM/G6/n0X5K/IW2eQDts75FcC/o4HYwiLJC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yG/ugAZh7U9uiQ5q/TccTaHnfTcK7fNqriAZSk3sNvDAL+YCvs2fONbCwzLhniI/g
	 ktQdVVJELJOyveBq+zCRQztZVHyOJ04ULaqBkr8JpJNU/T6F7at3JXH9CszUZxpLrw
	 1rZyDLH6acwS2erCzQfN8hSDK4joXfOLkNZv7wJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0019/1005] io_uring/timeout: dont rearm a multishot timeout on cancel
Date: Wed, 25 Nov 2026 15:22:37 +0100
Message-ID: <20261125143822.187105814@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

Commit 97d4a585db2b91d855f957be0a9f126068c5be93 upstream.

io_timeout_complete() does not check tw.cancel. When it runs from
io_cancel_local_task_work(), a multishot timeout that has not reached
its count still posts an IORING_CQE_F_MORE completion and rearms its
timer. With a zero interval the timer expires again right away and
queues new task work, so the drain keeps running it until posting a
CQE fails.

Normally the CQ fills up quickly and the request then completes. But
if userspace moves the CQ head far ahead of the tail, for example to
cq.tail + 0x7fffffff, posting keeps succeeding and ring teardown is
delayed for a long time.

Don't post another CQE or rearm the timer when tw.cancel is set, so
the request completes through io_req_task_complete(), like the poll and
linked timeout task work does when cancelled.

Fixes: ea97f6c8558e ("io_uring: add support for multishot timeouts")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/20261116044519.281756-1-teel4res@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 8e7a4bd7e5141..b46a50b395177 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -115,7 +115,8 @@ static void io_timeout_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!io_timeout_finish(timeout, data)) {
-		if (io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
+		if (!tw.cancel &&
+		    io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
 			/* re-arm timer */
 			raw_spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
-- 
2.53.0



