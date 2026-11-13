Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585741;
	b=38n7RJ4btSG9iApY1S9MOWsaRug85CGyO5I8nGS5AKU2TUmPcPR7KeAxmrOCbLuZIcqE
	 heWXGAIzuOwyjVTSPddVhnl8dnwzk5r+D1tDWMudurB+R4crlEoeCBNlXc5nSxnWxAzhJ
	 EGEV9SbbwUjjk1imnenxWy3fJcApD+uz4LZnf8dhhi23QUMhzm/gWuep6gKmBgqWmC5CT
	 hSf0seXYTyzPw52+LYvKY6bs1paPOLX+K8vGzGGmH9VMXwNj5TC5tRHeTkzSNXre0NP9+
	 A5ModFmI32vns3yAEdfMuVuH7bqDDwLB90V+8/09i5yI9DeN7pX0xxlOfYyg3IE9HbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8lrZVvOv1DZCLKBq1jVEFOL6Wl60IDbYCrnEKTdWCY=;
	b=xKY9xU/RRLRNJI3nteJaQxOV+tQhtAX4u1yMA3ZFGGpg83DPwnPgY2WbtggdTrlzgl2f
	 LrriaePB5SUltS4WXx/wVUxmRav+e9dEw4HjRSsDSiwF9BO+rMgDqfZHw5S3A9m+esjAa
	 Dq34Q7oN5Z8NpwvvijakP5wCox01maURR3qFv2XkAlIimsgS7Ng4nl/P16+cga0g8POTC
	 vdeFYw0d95chl9CCkLbvO1Alul4phNs9pUQW7PmHd1T87VpW6aRoNvuibpz6KnO8vVQb0
	 jkYvBXeMLfQtbVbaWAw+flf89VUYNRcTVg13J2ZTtSa5C/IGZa+sGiEfD9g2Y18a80Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGd6W4Hx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66617606AE01;
	Fri, 13 Nov 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGd6W4Hx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A591F000C9;
	Fri, 13 Nov 2026 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585741;
	bh=p8lrZVvOv1DZCLKBq1jVEFOL6Wl60IDbYCrnEKTdWCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGd6W4HxpjI5DSzy5LPMnwJ3z4zAmoAFVfvttpIqio8F9OvfsLPhrSq7g4p4CuN1i
	 3DquirN/IgNNYFN1TsBmz5xTsc94WQk5e/GTTezkapC3lqQ47D5Uo+uUcUthuPb5zQ
	 7iVY1wqoSsHR2JB3RmBAo6ylqkqL1aaOsJ0ehdcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 340/507] net/sched: clamp skb->queue_mapping before indexing the tx queue
Date: Fri, 13 Nov 2026 10:50:44 -0500
Message-ID: <20261113153806.920518754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 3e8ee4a691c34..d2e0d20f3ba1c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -96,9 +96,34 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
 
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
 
@@ -110,7 +135,8 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 	skb = skb_peek(&q->skb_bad_txq);
 	if (skb) {
 		/* check the reason of requeuing without tx lock first */
-		txq = skb_get_tx_queue(txq->dev, skb);
+		/* re-cap: real_num_tx_queues may have shrunk */
+		txq = skb_cap_tx_queue(q, skb);
 		if (!netif_xmit_frozen_or_stopped(txq)) {
 			skb = __skb_dequeue(&q->skb_bad_txq);
 			if (qdisc_is_percpu_stats(q)) {
@@ -224,6 +250,8 @@ static void try_bulk_dequeue_skb(struct Qdisc *q,
 		if (!nskb)
 			break;
 
+		/* Every element of an ONETXQUEUE qdisc is pinned to q->dev_queue. */
+		qdisc_cap_skb_tx_queue(q, nskb);
 		bytelimit -= nskb->len; /* covers GSO len */
 		skb->next = nskb;
 		skb = nskb;
@@ -241,7 +269,6 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
 				      struct sk_buff *skb,
 				      int *packets)
 {
-	int mapping = skb_get_queue_mapping(skb);
 	struct sk_buff *nskb;
 	int cnt = 0;
 
@@ -249,7 +276,9 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
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
@@ -294,7 +323,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 		if (xfrm_offload(skb))
 			*validate = true;
 		/* check the reason of requeuing without tx lock first */
-		txq = skb_get_tx_queue(txq->dev, skb);
+		txq = skb_cap_tx_queue(q, skb);
 		if (!netif_xmit_frozen_or_stopped(txq)) {
 			skb = __skb_dequeue(&q->gso_skb);
 			if (qdisc_is_percpu_stats(q)) {
@@ -330,6 +359,8 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	skb = q->dequeue(q);
 	if (skb) {
 bulk:
+		/* cap the head; the bulk helpers cap every appended element */
+		qdisc_cap_skb_tx_queue(q, skb);
 		if (qdisc_may_bulk(q))
 			try_bulk_dequeue_skb(q, skb, txq, packets, budget);
 		else
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 39ac5b97aa3af..0eb0803047a1e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -632,6 +632,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



