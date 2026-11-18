Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034965;
	b=t7U0BXCo2/nsGVkdv65t6sXOOelpnQMt8rUSrFqiarLNfnBrTdfP9xZdkWfZMT4myS+y
	 MUnQLzZnxOkaTvEr8lhicvdGQSHuVPuSQSlrAPbztOXlrx4FhkTX0YLdaZ0Sv8CDa9uh4
	 hELmCmOaPGxQmUSTnRjduS+77PADVMBCv/uhHoJQkhaFecVb06jNDZUqKk1hPpKX7WNZn
	 U4JscAO1pqc5YNOIO+jWqlhOaBTQIEw84IXBg5ccSGbwM2TDAdqd+TKoMGJ3w5qa1v/Uu
	 OGvN8LDAj/tHRSQyFTI+GobF51QyAIYuNdwRiyhsqLhKjud6Ev0WpL5uXw5+2b5fNdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gl74FRkaFUWwmi7EQJF5ameufdo6dy33esLJ+gkskgk=;
	b=RtCCunmGwLIrcTU+bKmlV4tLUeIbUK2Whgxc8ojO78w2ZZkuHHzQxXo+iA+ibp4e12+n
	 oLwkYqwpFuw2rzo5wNEMAEFOHHba0BcvE4QBuKdO0gzVDCaWEX0BiXTb8uV5M9YRs81sb
	 URXMRSlpjmfd0cO0aZhYZf7fmI57Fu1lK+pth/tuY83LOychJ6j/ww0x6rS/XJyxVn/DA
	 uhSM/ys4xDtixfIN1rTgNFepkvH3f//JVLg9rL6Ho9H2tm+OdFU75fbMoKc+C+01xpIrQ
	 Jx8Btc74+opsqF1XCHc9dO6Hk3Xln8Wktgi/eExvhsCypelMBuCGOytJWb6BOBPmZ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MY+IE0Ym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104A606A325;
	Wed, 18 Nov 2026 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MY+IE0Ym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7871F000C4;
	Wed, 18 Nov 2026 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034965;
	bh=Gl74FRkaFUWwmi7EQJF5ameufdo6dy33esLJ+gkskgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MY+IE0YmsneJPaPQFLyARxZKA4As2xCbXpGc8mRp2dT5qDLXDFKTEDy3P1e2+PRBy
	 LQGCnHgHs8ywcoOAE6XkA1oH+MV0/hly2lqhmbpReMqPVjBCA+/ugmR4/heoDtlnyp
	 qza5du80fRYcTT5FWbOJKU+LL/iGnVN9hIP1Fa78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0557/3318] net/sched: fix packet reordering on requeue
Date: Wed, 18 Nov 2026 15:19:39 +0100
Message-ID: <20261118150334.049860132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@mandelbit.com>

commit 14368b9aa1017fee35d2589be7b17e0485c0f93e upstream.

dev_requeue_skb() appends requeued skbs to the tail of q->gso_skb, while
dequeue_skb() takes them back one at a time from the head. If the driver
returns NETDEV_TX_BUSY again for the first of them, it moves behind the
skbs still parked there and is sent after them.

This showed up as heavy TCP reordering while benchmarking over veth,
which returns NETDEV_TX_BUSY whenever its ring is full since
commit dc82a33297fc ("veth: apply qdisc backpressure on full ptr_ring to reduce TX drops").

Requeue the skbs at the head of gso_skb, keeping their order. With 4 TCP
streams over a veth pair with a pfifo qdisc, this removes about 1.3M
out-of-order segments and 15-37k retransmits per 15 seconds, and raises
throughput from about 40 to 76 Gbit/s.

Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
Fixes: 9540d977618c ("net: sched: fix skb leak in dev_requeue_skb()")
Cc: stable@vger.kernel.org
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20261026153113.3275494-1-antonio@mandelbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -141,8 +141,11 @@ static inline void qdisc_enqueue_skb_bad
 
 static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 {
+	struct sk_buff_head requeue;
 	spinlock_t *lock = NULL;
 
+	__skb_queue_head_init(&requeue);
+
 	if (q->flags & TCQ_F_NOLOCK) {
 		lock = qdisc_lock(q);
 		spin_lock(lock);
@@ -151,7 +154,7 @@ static inline void dev_requeue_skb(struc
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
-		__skb_queue_tail(&q->gso_skb, skb);
+		__skb_queue_tail(&requeue, skb);
 
 		/* it's still part of the queue */
 		if (qdisc_is_percpu_stats(q)) {
@@ -167,6 +170,11 @@ static inline void dev_requeue_skb(struc
 		skb = next;
 	}
 
+	/* the skbs may come from the head of gso_skb, so put them back there:
+	 * appending them would let the ones still parked overtake them
+	 */
+	skb_queue_splice(&requeue, &q->gso_skb);
+
 	if (lock) {
 		spin_unlock(lock);
 		set_bit(__QDISC_STATE_MISSED, &q->state);


