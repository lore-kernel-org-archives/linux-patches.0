Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059675;
	b=e3wQyiZPpirjhS/kEuU9UQIZko1Kz3jY1L2BBIl33k12mkz/UrSVHfAgrXKxpFPUF3qS
	 sZM8VFop5uCPfhuvkEDAC5GuCnPthujOig1IQPZRhgQSGiJbIia8/eR9EYLnji28/IRgQ
	 9ZwZtLFfgtWJuy7l9Lk293IFZlCnavx9XkplKjA9DeklC517f9rvbmszVBnrp8iTbnlCb
	 qDC0WD4b6DRgV7Xt7F7AyX72ljKObFFU/qUUE+Yq0UvhYgr4r8wwfNDE50Z0vXgVUJFM3
	 jhHVmMstGahjB02S3HC6Ao1ehUYzG0RFxfivdW61izySGVHTKn3IzSFl6daxWN5iKEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1D5pH5soA94knySW8QRsrY0wPzy3YkUp7/twh4125Tw=;
	b=XzUWLMLqD7Vm17slDvKQmWVDdsZE8miCNQACM9xJJy5Ned/KoyK97gwlhZMEVjQF47Xs
	 bnz1y+desxyPkFf+JBd+sLRz2R7D/ZX4AqrfiEgR6ddJtEDrpU8Lllq4r7xzH9I++d9s2
	 JQDGkLn5kCT99nQ3NC0+RF8I3gXb+WTjVgFu6ntPBPWVvoTQEfS4dP8g2vTwlphS3C+l5
	 TFNLfrUJz6ZAW6CAqtDQEg2vm1pGYL5aYPwgfXYWRgwhdixPGj7eOV3pPO7Yk7ny7tZ1c
	 KSApe2wcjlljEvV2kvUNAKrkxR04vtfGdTajRx+qwEVuOgjIkp6GjE1Vyx1s6XoqzEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Amv85z9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844B4606A32A;
	Thu, 19 Nov 2026 03:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Amv85z9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965C51F000C4;
	Thu, 19 Nov 2026 03:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059675;
	bh=1D5pH5soA94knySW8QRsrY0wPzy3YkUp7/twh4125Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Amv85z9UW7gfkrLHuzyvqjGWDfIWGZrIHJ2RYE6J6LKWqgKL8qaxKbtTSJp83Boku
	 kHxPlGgS/nhTPYQD+Xl6vpLYXuw/PYk/yzd/MPdUnma+lNOdWT5erVX2ohMf9oQkKo
	 6WJeo1HVw/68UH2yu+yTtKMOATrkKzRC9oi4W4zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0889/1848] xprtrdma: Remove the RPC/RDMA QP event handler
Date: Wed, 18 Nov 2026 15:48:47 +0100
Message-ID: <20261118145953.731618498@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e1648eb23d839bd4b9f2999296d5e81dcd93311f ]

Clean up: The handler only recorded a trace event. If indeed no
action is needed by the RPC/RDMA consumer, then the event can be
ignored.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 0b5bb4e586f7 ("xprtrdma: prevent disconnect feedback during endpoint teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rpcrdma.h | 32 --------------------------------
 net/sunrpc/xprtrdma/verbs.c    | 18 ------------------
 2 files changed, 50 deletions(-)

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index bf1065772228f..3bdea1600e8b1 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -485,38 +485,6 @@ TRACE_EVENT(xprtrdma_op_set_cto,
 	)
 );
 
-TRACE_EVENT(xprtrdma_qp_event,
-	TP_PROTO(
-		const struct rpcrdma_ep *ep,
-		const struct ib_event *event
-	),
-
-	TP_ARGS(ep, event),
-
-	TP_STRUCT__entry(
-		__field(unsigned long, event)
-		__string(name, event->device->name)
-		__array(unsigned char, srcaddr, sizeof(struct sockaddr_in6))
-		__array(unsigned char, dstaddr, sizeof(struct sockaddr_in6))
-	),
-
-	TP_fast_assign(
-		const struct rdma_cm_id *id = ep->re_id;
-
-		__entry->event = event->event;
-		__assign_str(name, event->device->name);
-		memcpy(__entry->srcaddr, &id->route.addr.src_addr,
-		       sizeof(struct sockaddr_in6));
-		memcpy(__entry->dstaddr, &id->route.addr.dst_addr,
-		       sizeof(struct sockaddr_in6));
-	),
-
-	TP_printk("%pISpc -> %pISpc device=%s %s (%lu)",
-		__entry->srcaddr, __entry->dstaddr, __get_str(name),
-		rdma_show_ib_event(__entry->event), __entry->event
-	)
-);
-
 /**
  ** Call events
  **/
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 257acdb5bf56e..8c05fc11d79e5 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -114,22 +114,6 @@ static void rpcrdma_xprt_drain(struct rpcrdma_xprt *r_xprt)
 	rpcrdma_ep_put(ep);
 }
 
-/**
- * rpcrdma_qp_event_handler - Handle one QP event (error notification)
- * @event: details of the event
- * @context: ep that owns QP where event occurred
- *
- * Called from the RDMA provider (device driver) possibly in an interrupt
- * context. The QP is always destroyed before the ID, so the ID will be
- * reliably available when this handler is invoked.
- */
-static void rpcrdma_qp_event_handler(struct ib_event *event, void *context)
-{
-	struct rpcrdma_ep *ep = context;
-
-	trace_xprtrdma_qp_event(ep, event);
-}
-
 /* Ensure xprt_force_disconnect() is invoked exactly once when a
  * connection is closed or lost. (The important thing is it needs
  * to be invoked "at least" once).
@@ -428,8 +412,6 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 
 	r_xprt->rx_buf.rb_max_requests = cpu_to_be32(ep->re_max_requests);
 
-	ep->re_attr.event_handler = rpcrdma_qp_event_handler;
-	ep->re_attr.qp_context = ep;
 	ep->re_attr.srq = NULL;
 	ep->re_attr.cap.max_inline_data = 0;
 	ep->re_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
-- 
2.53.0



