Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213702;
	b=K3wC/wPQ4r0g6LO7umlCUCwnZonxa95yC9Jh5u0UhWtCNgcKkCmhIzsmyQ4qw7yYK8bL
	 hxyZyHT62tGENFPxCGdn5TpDo15HQ5zotAz4sURUZ0nYi0/Vb0TwmnFn+wSOnmRhLUI5p
	 mGJXcLt56PoHQXs0tRwUmietG1xPEM9sltDDLrik+K9xrLpjVwLzdGXIh34quey9ksEDr
	 hCi6WgMacmWfLMoixo5Z0wduEKsNa+myecYuEkM84Ro67f5Nw7fFFNVV5FS75L1kEdLWq
	 ft/J5KQWgfqa2NJ3Go+slvxPPTC8S0m5xrKCvYM+G7Z0Q/7KPttI0DbcPT/zOGl9kkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GE6fhT2SiSY7kEuCElb+Beh2gthPN9G0rx105EU+R/I=;
	b=PClZ9xJ5NQzSrKAqkGct++V3Zn90Z1nnjb3BoDL+ZM2QIanhY7CjzmR5YBHBT1FL6Ld2
	 kCNHLU0fyYznInMQmQQsLeg+C90zTFSmJAumNmUPGgC277STvEbw7yKZUJ//59nZAlaOU
	 kZK6ZoBQlQntVexhR9EzqcKjQBpZIkRJwyioLolSDuYNWCMWfFeQs/p5eGvuo/J2SQ2RP
	 yh6dzMMSjPBvRsvuihnE9M9MOF27Q2J/y3xJMfrhVAaPIEgSmV6JZoAHfzpLwc+Pd9Xo3
	 PzpzOT9+PFFzc4q3PHchRJXVmTWHcF8F3ZSw5qNJYOa6xqPvlGbhBnlnpYt+9wQ0hxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smK+5Sj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0D2606A31A;
	Wed, 28 Oct 2026 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smK+5Sj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E27D1F01825;
	Wed, 28 Oct 2026 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213702;
	bh=GE6fhT2SiSY7kEuCElb+Beh2gthPN9G0rx105EU+R/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smK+5Sj2nlfR7XJcvTPW/l+hj2MX6ZY2O+b6rUupEqt+JfBbD1KXXrt6Im1pMNB6T
	 YvUEsT9fg2hDQca1pu1K0l5+RtgGYgjvmEt6stWyd0fw/A5ek0mL3lamoWtz4JglUh
	 e7CGKbGg9LoP90qd/0/V0ISnw/s3nsRwB9Gto7YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingshuai Ren <renmingshuai@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0599/1887] net/sched: Fix mirred deadlock on device recursion
Date: Wed, 28 Oct 2026 17:44:55 +0100
Message-ID: <20261028170513.047165436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0f022d32c3eca477fbf79a205243a6123ed0fe11 ]

When the mirred action is used on a classful egress qdisc and a packet is
mirrored or redirected to self we hit a qdisc lock deadlock.
See trace below.

[..... other info removed for brevity....]
[   82.890906]
[   82.890906] ============================================
[   82.890906] WARNING: possible recursive locking detected
[   82.890906] 6.8.0-05205-g77fadd89fe2d-dirty #213 Tainted: G        W
[   82.890906] --------------------------------------------
[   82.890906] ping/418 is trying to acquire lock:
[   82.890906] ffff888006994110 (&sch->q.lock){+.-.}-{3:3}, at:
__dev_queue_xmit+0x1778/0x3550
[   82.890906]
[   82.890906] but task is already holding lock:
[   82.890906] ffff888006994110 (&sch->q.lock){+.-.}-{3:3}, at:
__dev_queue_xmit+0x1778/0x3550
[   82.890906]
[   82.890906] other info that might help us debug this:
[   82.890906]  Possible unsafe locking scenario:
[   82.890906]
[   82.890906]        CPU0
[   82.890906]        ----
[   82.890906]   lock(&sch->q.lock);
[   82.890906]   lock(&sch->q.lock);
[   82.890906]
[   82.890906]  *** DEADLOCK ***
[   82.890906]
[..... other info removed for brevity....]

Example setup (eth0->eth0) to recreate
tc qdisc add dev eth0 root handle 1: htb default 30
tc filter add dev eth0 handle 1: protocol ip prio 2 matchall \
     action mirred egress redirect dev eth0

Another example(eth0->eth1->eth0) to recreate
tc qdisc add dev eth0 root handle 1: htb default 30
tc filter add dev eth0 handle 1: protocol ip prio 2 matchall \
     action mirred egress redirect dev eth1

tc qdisc add dev eth1 root handle 1: htb default 30
tc filter add dev eth1 handle 1: protocol ip prio 2 matchall \
     action mirred egress redirect dev eth0

We fix this by adding an owner field (CPU id) to struct Qdisc set after
root qdisc is entered. When the softirq enters it a second time, if the
qdisc owner is the same CPU, the packet is dropped to break the loop.

Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
Closes: https://lore.kernel.org/netdev/20240314111713.5979-1-renmingshuai@huawei.com/
Fixes: 3bcb846ca4cf ("net: get rid of spin_trylock() in net_tx_action()")
Fixes: e578d9c02587 ("net: sched: use counter to break reclassify loops")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240415210728.36949-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 +
 net/core/dev.c            | 6 ++++++
 net/sched/sch_generic.c   | 1 +
 3 files changed, 8 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index b694d27f41714..d932af97fa579 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -117,6 +117,7 @@ struct Qdisc {
 	struct qdisc_skb_head	q;
 	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue	qstats;
+	int                     owner;
 	unsigned long		state;
 	unsigned long		state2; /* must be written under qdisc spinlock */
 	struct Qdisc            *next_sched;
diff --git a/net/core/dev.c b/net/core/dev.c
index f9597dbfd4225..e467e81226396 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3948,6 +3948,10 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		return rc;
 	}
 
+	if (unlikely(READ_ONCE(q->owner) == smp_processor_id())) {
+		kfree_skb_reason(skb, SKB_DROP_REASON_TC_EGRESS);
+		return NET_XMIT_DROP;
+	}
 	/*
 	 * Heuristic to force contended enqueues to serialize on a
 	 * separate lock before trying to get qdisc main lock.
@@ -3987,7 +3991,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
+		WRITE_ONCE(q->owner, smp_processor_id());
 		rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
+		WRITE_ONCE(q->owner, -1);
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index f58ec57e31f46..b9cc8e90d6554 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -986,6 +986,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
+	sch->owner = -1;
 	netdev_hold(dev, &sch->dev_tracker, GFP_KERNEL);
 	refcount_set(&sch->refcnt, 1);
 
-- 
2.53.0



