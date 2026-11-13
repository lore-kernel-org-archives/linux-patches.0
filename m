Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590433;
	b=2iFN76m4GJ+L27rUK5DPoIgNjiII5ZcoDFgrY+BQhzuJW050QplF+urwfMbqwXNdBcY/
	 cWqiI0N0Z9JWXVWWjDge31q9EdM1p0U88YHSVFnxwpMpeLCKIQReo200Hpz9LlrIzvv8W
	 j1/c/Ynx3A594QEvXCoAc2S1m9qs3GK21g7LkGIK6Mobraiy9KS8c/xMG4sVmua3Qw39A
	 KYXIahGuyIcQOXCAhfOLbaPNx7Uhqxyo0jnHAXTtgKqhVghiUb/UfQtKg8MH+kLCY7Md8
	 XS7hvTh78RbOI2VLhtvrgCje++npvPZEqapC/UoOP3nHGgfIafwUG2tPqVeoMhZ9DzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lETGAdFcMQfagAZq5OWApxYFophWyEYwFoo4xrU14fs=;
	b=Bqcjf01JixNbFb/nGb8xnwYHTS4lM3IoUv2iKIbq4kJrFc3mgm6M+NJuCTLO0XEwXy2i
	 6hNTrnJvcSknb97+WCnbAR8fWYV60huDWJlGTdxw+I2vZCL7a48ROVT+0zVO2278aCuGq
	 RCcoE2UUOlqdD+yTs1Pv8hdeee3DzaJSyXRB5lF73MYLi49wt+z5qFv08wH0ZVHDOpGQj
	 b0Ci7rql+atsGDg+Cc1VY79eaU1eBrg8IpeQxiPBhDzWpT7YbI1aFBpg0rLoYpAqVI5SL
	 CG/slJWSnxmhu2nDMAZJY0N0hHXdL2HU46pL8vJ8T4+cx6RY8J7ZvdYDZ07ZAqALeOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvlPI+Oy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E312C606E65E;
	Fri, 13 Nov 2026 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvlPI+Oy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4C51F000C4;
	Fri, 13 Nov 2026 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590432;
	bh=lETGAdFcMQfagAZq5OWApxYFophWyEYwFoo4xrU14fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvlPI+OyJxP9J30uUvQ5rkrL+eQlx7MO0Midtsi+yepVWKMBmkMuGHlCgTH3icOLK
	 lMB6fURpngkq5iAmGMlbq2cH6pfv3ObpRZEBnrRPa5s8CnyB2M6i5PHp1iFamfeALd
	 FOigowX/LE4UoSRwgU693e8cxwX8i3zl9KP2Iux0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 393/686] net/sched: clamp skb->queue_mapping before indexing the tx queue
Date: Fri, 13 Nov 2026 10:48:46 -0500
Message-ID: <20261113153834.319864761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f19f2b308beb158d0e6f6eb806ced636e4ebf6ce ]

This issue was caught by Sashiko (nipa). A producer-side path cap is
already merged (ea4d4b5dddb5); this patch adds the matching consumer-side
caps.

The issue:
The tx queue is picked and capped in netdev_core_pick_tx() before the
__dev_xmit_skb() qdisc enqueue path. A tc BPF program running inside an
egress qdisc (not clsact) can then change __sk_buff->queue_mapping; that
store is never re-checked. bpf_convert_ctx_access() bounds it only by
NO_QUEUE_MAPPING, not by the device's queue count.

Two consumers read the stale value:

  - On dequeue, qdisc_restart() calls netdev_get_tx_queue(), which
    indexes dev->_tx[]. netdev_get_tx_queue() guards it with just a
    DEBUG_NET_WARN_ON_ONCE, so sch_direct_xmit() takes the out-of-bounds
    txq->_xmit_lock and writes txq->xmit_lock_owner past the end of the
    allocation on non-lltx devices such as ifb. Drivers that index their
    rings from skb_get_queue_mapping() (ex: ifb) go out of range the same
    way.

  - On enqueue, taprio_enqueue() indexes q->qdiscs[] with the same value;
    the array is sized dev->num_tx_queues. A duplicating netem on a child
    qdisc clones the skb and re-enqueues the clone at the taprio root
    (qdisc_root_bh()) through a direct rootq->enqueue() call, so the value
    reaches taprio_enqueue() before any dequeue cap runs.

The Fix:
Cap the mapping at the consumers and write the capped value back, so the
qdisc's _tx[] lookup, the taprio q->qdiscs[] lookup and any later driver
read stay in range.

On the dequeue side the cap folds into the dequeue path instead of a
separate walk over the returned list: dequeue_skb() caps the head, and
each bulk helper caps the element it appends. For a qdisc that is not
TCQ_F_ONETXQUEUE, netdev_cap_txqueue() logs a ratelimited notice and
selects queue 0.

A TCQ_F_ONETXQUEUE qdisc is bound to a single tx queue: dequeue_skb() uses
q->dev_queue for the frozen check, the BQL limit and the trace point, while
qdisc_restart() transmits on the skb's queue. Capping an out-of-range
mapping to queue 0 would therefore send a per-queue child's skb through a
different queue than the one it was dequeued for. On mq, mqprio, taprio and
htb offload children, a stopped queue 0 could then park the list in
q->gso_skb, and the later wake would schedule queue 0's own child instead
of this qdisc. Pin a TCQ_F_ONETXQUEUE mapping to the qdisc's own queue to
keep the documented invariant.

The pin covers every mapping, not only an out-of-range one: an in-range
mapping that a filter sets on one of those per-queue children is rewritten
to the child's own queue, and this path does not call netdev_cap_txqueue(),
so it logs no notice. On a single-queue device qdisc_create() sets
TCQ_F_ONETXQUEUE, so the one-queue trigger described below also takes this
branch and is corrected without a notice.

That also keeps a bulk list on one queue by construction: every element of
a TCQ_F_ONETXQUEUE qdisc, including a follower changed by a filter, is
pinned to q->dev_queue before it is appended. The fast bulk helper
therefore needs no head comparison and no skb_bad_txq requeue; the slow
helper, used only by non-ONETXQUEUE qdiscs, still compares and requeues a
mismatched follower, where a wake on any queue reschedules q.

On the enqueue side taprio_enqueue() caps the mapping against
real_num_tx_queues and writes it back before selecting q->qdiscs[queue], so
a duplicating child cannot steer the clone out of the array.

Conditions to recreate the bug:
The dequeue path: load a SCHED_CLS or SCHED_ACT program that stores
__sk_buff->queue_mapping (a tc BPF action is enough), attach it to a
transmit qdisc (for example a matchall filter on a prio root), and send a
packet. With a 1-queue device a store of 1 indexes one past dev->_tx[].
Under KASAN with panic_on_warn=1 the unfixed kernel faults with "BUG:
KASAN: slab-out-of-bounds in sch_direct_xmit". Loading the program needs
CAP_BPF/CAP_SYS_ADMIN, so the trigger is root.

The enqueue path: on a multi-queue device, install a software taprio root,
graft a prio child with a duplicating netem on every class, and store an
out-of-range queue_mapping from a matchall+bpf filter on the prio. The
duplicate is re-enqueued at the taprio root and indexes q->qdiscs[] past
dev->num_tx_queues; the unfixed kernel faults in taprio_enqueue_one().
Same CAP_BPF/CAP_SYS_ADMIN requirement.

Fixes: 74e31ca850c1 ("bpf: add skb->queue_mapping write access from tc clsact")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179033713973.2160803.4914570693994398206@kernel.org/
Link: https://lore.kernel.org/netdev/179329777513.3134.12135506558709584471@kernel.org/
Link: https://lore.kernel.org/netdev/179293123940.3134.1149128679923234677@kernel.org/
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-MD1X.v4.r0.20261021042722-1%40mojatatu.com
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-MD1X.v3.r0.20261015165943-1%40mojatatu.com
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-MD1X.v1.20261005193231%40mojatatu.com
Link: https://lore.kernel.org/netdev/20261015125822.GH83879@horms.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-MD1X.v6.r0.20261029162633-1@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 41 ++++++++++++++++++++++++++++++++++++-----
 net/sched/sch_taprio.c  |  5 +++++
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 26085d31be47c..e2dc86758888a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -71,9 +71,34 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
 
 #define SKB_XOFF_MAGIC ((struct sk_buff *)1UL)
 
+/* Re-cap a stale queue_mapping; an ONETXQUEUE qdisc pins q->dev_queue. */
+static u16 qdisc_cap_skb_tx_queue(struct Qdisc *q, struct sk_buff *skb)
+{
+	u16 queue = skb_get_queue_mapping(skb);
+	struct net_device *dev = qdisc_dev(q);
+	u16 capped;
+
+	if (q->flags & TCQ_F_ONETXQUEUE)
+		capped = q->dev_queue - netdev_get_tx_queue(dev, 0);
+	else
+		capped = netdev_cap_txqueue(dev, queue);
+
+	if (unlikely(capped != queue))
+		skb_set_queue_mapping(skb, capped);
+
+	return capped;
+}
+
+static struct netdev_queue *skb_cap_tx_queue(struct Qdisc *q,
+					     struct sk_buff *skb)
+{
+	return netdev_get_tx_queue(qdisc_dev(q),
+				   qdisc_cap_skb_tx_queue(q, skb));
+}
+
 static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 {
-	const struct netdev_queue *txq = q->dev_queue;
+	const struct netdev_queue *txq;
 	spinlock_t *lock = NULL;
 	struct sk_buff *skb;
 
@@ -85,7 +110,8 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 	skb = skb_peek(&q->skb_bad_txq);
 	if (skb) {
 		/* check the reason of requeuing without tx lock first */
-		txq = skb_get_tx_queue(txq->dev, skb);
+		/* re-cap: real_num_tx_queues may have shrunk */
+		txq = skb_cap_tx_queue(q, skb);
 		if (!netif_xmit_frozen_or_stopped(txq)) {
 			skb = __skb_dequeue(&q->skb_bad_txq);
 			if (qdisc_is_percpu_stats(q)) {
@@ -199,6 +225,8 @@ static void try_bulk_dequeue_skb(struct Qdisc *q,
 		if (!nskb)
 			break;
 
+		/* Every element of an ONETXQUEUE qdisc is pinned to q->dev_queue. */
+		qdisc_cap_skb_tx_queue(q, nskb);
 		bytelimit -= nskb->len; /* covers GSO len */
 		skb->next = nskb;
 		skb = nskb;
@@ -216,7 +244,6 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
 				      struct sk_buff *skb,
 				      int *packets)
 {
-	int mapping = skb_get_queue_mapping(skb);
 	struct sk_buff *nskb;
 	int cnt = 0;
 
@@ -224,7 +251,9 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
 		nskb = q->dequeue(q);
 		if (!nskb)
 			break;
-		if (unlikely(skb_get_queue_mapping(nskb) != mapping)) {
+		/* A tc BPF store may have changed the mapping; cap it. */
+		if (unlikely(qdisc_cap_skb_tx_queue(q, nskb) !=
+			     skb_get_queue_mapping(skb))) {
 			qdisc_enqueue_skb_bad_txq(q, nskb);
 			break;
 		}
@@ -269,7 +298,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 		if (xfrm_offload(skb))
 			*validate = true;
 		/* check the reason of requeuing without tx lock first */
-		txq = skb_get_tx_queue(txq->dev, skb);
+		txq = skb_cap_tx_queue(q, skb);
 		if (!netif_xmit_frozen_or_stopped(txq)) {
 			skb = __skb_dequeue(&q->gso_skb);
 			if (qdisc_is_percpu_stats(q)) {
@@ -305,6 +334,8 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	skb = q->dequeue(q);
 	if (skb) {
 bulk:
+		/* cap the head; the bulk helpers cap every appended element */
+		qdisc_cap_skb_tx_queue(q, skb);
 		if (qdisc_may_bulk(q))
 			try_bulk_dequeue_skb(q, skb, txq, packets, budget);
 		else
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 99a711d0479c2..f9eeb6296f1dc 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -631,6 +631,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	int queue;
 
 	queue = skb_get_queue_mapping(skb);
+	if (unlikely(queue >= qdisc_dev(sch)->real_num_tx_queues)) {
+		/* A tc BPF program may have stored an out-of-range mapping. */
+		queue = netdev_cap_txqueue(qdisc_dev(sch), queue);
+		skb_set_queue_mapping(skb, queue);
+	}
 
 	child = q->qdiscs[queue];
 	if (unlikely(child == &noop_qdisc))
-- 
2.53.0



