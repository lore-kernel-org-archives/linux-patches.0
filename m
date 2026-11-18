Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014999;
	b=YCjAdnQHJvCPUlQCwBJVlL0nxY+M9LGXq2zt0XDwUFgAlaIlaYa3guNHvIYz4OeQ0DnC
	 wAffUwQ3Fsz7NprSVgp+bRWZHvWWSz/fYvvoiHUBP4qXY+tIoaLAHa4/20fQDku3FnMQZ
	 hRkMDF/aDBIqcDtG94mLBK0sNphTzlQBo9YvVyI45lmcYyaT5cbNYQb39J8zNlxpu+9qq
	 PNjt24UBjPPGvxL0DTtXjqTZJNJ22IYT5x1EwS1c54u37TUvJ0/EGhxcL5+Ls6gSV1PbT
	 84WeE9iLP6KyqWbIrnEOorusonyv7eeySUwiCrWGoiJImtVjqjGv0T5wcvVIMw76Wxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86jGWpSPFrRrM0+tm4QUc7fybEO6syf+r/JlIHXUv50=;
	b=s+xQLLyPSDEloRzv94h+XltQWxVCknJBQeD8z0JcTXA5x+tn+VF7rFge8TLN1zUv1DiG
	 2H5hPPdlip+Y72xqzu2K/PXxH82HsL5cycXnszg0pbe/UjD9qKf0OMg9qzZTLQSFL6YDA
	 p192dMHT/rLC+uPjZzufS8gcSTaTFOY9ZHU4BJHbVBjkZ7M549+kX7Xusn3fz6zB3BdK5
	 KLf4BDEoRKg1EgnR1md1wF1Bbf3cBMNGxPx1RgA9K9GRcQIeOEf2pSVYPfXcJXL3BJoD5
	 toh5WLtsCxZClKxcXgd4ObUcoVb+TmNbYZcyKyrax3ddolduhAXuQKd6j2r90ZEmqLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dj6q0G9F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDE0606A320;
	Wed, 18 Nov 2026 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dj6q0G9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0751F000C5;
	Wed, 18 Nov 2026 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014999;
	bh=86jGWpSPFrRrM0+tm4QUc7fybEO6syf+r/JlIHXUv50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dj6q0G9FCn2WvAPCRx/z/8KeACireF8S0BLxfMkQcX4m0/yVYLIPLFpzVbuUnAmjb
	 3oQ6Awh0zDV7LrHLUVofi7sl33GZbcf3XVsIcJizPi3FG6J4mtxSWHlyxcyTxzWZb8
	 QcxyiIbTuAvHtcG9yK25KHUsoAbds0LvvB4wIS4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0017/2651] inet: frags: bound the wmem charge of the socket completing a reassembly
Date: Wed, 18 Nov 2026 15:20:57 +0100
Message-ID: <20261118150248.611579633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit b71c101bbb9814d163c00234d43c41f0a17907d4 ]

When a socket owned fragment completes a reassembly queue,
inet_frag_reasm_prepare() and inet_frag_reasm_finish() charge the
truesize of all other fragments to its sk_wmem_alloc. These fragments
were orphaned when queued, and might have been sent by someone else,
for instance padded TUN packets.

Commit 3ae20e4697eb ("inet: frags: limit the truesize of a reassembly
queue") bounds this charge to INT_MAX / 2 per queue, but a socket can
complete several queues while the reassembled skbs are still alive,
for instance held in a qdisc. sk_wmem_alloc can then go past INT_MAX,
refcount_add() saturates it with a WARN, and the socket is leaked.

This is reachable from an unprivileged user/network namespace, by
raising ipfrag_high_thresh.

Refuse the reassembly if the charge would push sk_wmem_alloc above
2 * sk_sndbuf, the bound ip_append_data() uses, plus 4MB of slack for
fragments inflated by a refragmentation with a small MTU, and never
above INT_MAX / 2. The cap matters for tun sockets, which use
sk_sndbuf = INT_MAX, and whose skbs are still owned when act_ct or
openvswitch reassemble them at ingress.

Several queues can complete at the same time on different cpus for
the same socket, so the charge is reserved with a cmpxchg() loop in
inet_frag_reasm_prepare(), before it modifies the queue, and settled
in inet_frag_reasm_finish(). Move the size checks of ip_frag_reasm(),
ip6_frag_reasm() and nf_ct_frag6_reasm() before
inet_frag_reasm_prepare(), using the first fragment which becomes the
head, so that a successful inet_frag_reasm_prepare() is always followed
by inet_frag_reasm_finish(). All callers already kill the queue when
inet_frag_reasm_prepare() returns NULL.

Found by code inspection (AI review), not reproduced.

Fixes: 18685451fc4e ("inet: inet_defrag: prevent sk release while still in use")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Closes: https://lore.kernel.org/netdev/24feda7d-ae49-45af-9596-2cc5f149f28e@redhat.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261104122927.1033747-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_fragment.c                | 61 ++++++++++++++++++++++---
 net/ipv4/ip_fragment.c                  | 13 ++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 13 ++++--
 net/ipv6/reassembly.c                   | 13 ++++--
 4 files changed, 78 insertions(+), 22 deletions(-)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 0b8d22ffafca6..f330d0a398233 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -17,6 +17,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/rhashtable.h>
+#include <linux/sizes.h>
 
 #include <net/sock.h>
 #include <net/inet_frag.h>
@@ -519,6 +520,43 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_frag_queue_insert);
 
+/* When a socket owned fragment completes a queue, the truesize of all
+ * other fragments is charged to its sk_wmem_alloc, although they were
+ * orphaned when queued and possibly sent by someone else.
+ * Bound this like ip_append_data() bounds the memory a socket can
+ * allocate (2 * sk_sndbuf), plus slack for fragments inflated by a
+ * refragmentation using a small MTU. Otherwise, several reassembled skbs
+ * alive at the same time can saturate sk_wmem_alloc, and leak the socket.
+ *
+ * Several queues can complete at the same time for the same socket,
+ * and some sockets (tun) use sk_sndbuf = INT_MAX. The charge is reserved
+ * with a cmpxchg() loop, a refcount_t has no helper for this.
+ */
+#define INET_FRAG_WMEM_SLACK	SZ_4M
+
+static bool inet_frag_wmem_reserve(struct sock *sk, unsigned int charge)
+{
+	u64 limit = 2ULL * READ_ONCE(sk->sk_sndbuf) + INET_FRAG_WMEM_SLACK;
+	int old = refcount_read(&sk->sk_wmem_alloc);
+
+	limit = min_t(u64, limit, INET_FRAG_MAX_TRUESIZE);
+	do {
+		if (old <= 0 || (u64)old + charge > limit)
+			return false;
+	} while (!atomic_try_cmpxchg(&sk->sk_wmem_alloc.refs, &old,
+				     old + charge));
+
+	return true;
+}
+
+static void inet_frag_wmem_adjust(struct sock *sk, int delta)
+{
+	if (delta >= 0)
+		refcount_add(delta, &sk->sk_wmem_alloc);
+	else
+		WARN_ON_ONCE(refcount_sub_and_test(-delta, &sk->sk_wmem_alloc));
+}
+
 void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 			      struct sk_buff *parent)
 {
@@ -530,6 +568,11 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 	int delta;
 
 	if (sk && is_skb_wmem(skb)) {
+		/* skb->truesize is already charged to sk, and is part of
+		 * q->truesize. inet_frag_reasm_finish() settles the charge.
+		 */
+		if (!inet_frag_wmem_reserve(sk, q->truesize - skb->truesize))
+			return NULL;
 		/* TX: skb->sk might have been passed as argument to
 		 * dst->output and must remain valid until tx completes.
 		 *
@@ -605,17 +648,18 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 
 out_restore_sk:
 	if (orig_truesize) {
-		int ts_delta = head->truesize - orig_truesize;
-
 		/* if this reassembled skb is fragmented later,
 		 * fraglist skbs will get skb->sk assigned from head->sk,
 		 * and each frag skb will be released via sock_wfree.
-		 *
-		 * Update sk_wmem_alloc.
 		 */
 		head->sk = sk;
 		head->destructor = destructor;
-		refcount_add(ts_delta, &sk->sk_wmem_alloc);
+		/* On failure, head stays in the queue and will be freed
+		 * with the queue: only charge its truesize.
+		 */
+		if (!nextp)
+			inet_frag_wmem_adjust(sk, (int)head->truesize -
+						  (int)q->truesize);
 	}
 
 	return nextp;
@@ -626,7 +670,6 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 			    void *reasm_data, bool try_coalesce)
 {
 	struct sock *sk = is_skb_wmem(head) ? head->sk : NULL;
-	const unsigned int head_truesize = head->truesize;
 	struct sk_buff **nextp = reasm_data;
 	struct rb_node *rbn;
 	struct sk_buff *fp;
@@ -691,8 +734,12 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 	head->tstamp = q->stamp;
 	head->tstamp_type = q->tstamp_type;
 
+	/* After inet_frag_reasm_prepare(), q->truesize is charged to sk.
+	 * sum_truesize also includes what it added (skb_unclone() and
+	 * frag_list clone).
+	 */
 	if (sk)
-		refcount_add(sum_truesize - head_truesize, &sk->sk_wmem_alloc);
+		inet_frag_wmem_adjust(sk, sum_truesize - (int)q->truesize);
 }
 EXPORT_SYMBOL(inet_frag_reasm_finish);
 
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 36105dd192823..ef7fd61284a3f 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -413,16 +413,19 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 		goto out_fail;
 	}
 
+	/* Check the size on the first fragment, which will become the head:
+	 * inet_frag_reasm_finish() must follow inet_frag_reasm_prepare().
+	 */
+	len = ip_hdrlen(skb_rb_first(&qp->q.rb_fragments)) + qp->q.len;
+	err = -E2BIG;
+	if (len > 65535)
+		goto out_oversize;
+
 	/* Make the one we just received the head. */
 	reasm_data = inet_frag_reasm_prepare(&qp->q, skb, prev_tail);
 	if (!reasm_data)
 		goto out_nomem;
 
-	len = ip_hdrlen(skb) + qp->q.len;
-	err = -E2BIG;
-	if (len > 65535)
-		goto out_oversize;
-
 	inet_frag_reasm_finish(&qp->q, skb, reasm_data,
 			       ip_frag_coalesce_ok(qp));
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 599c49bf0a0af..02341c64baaa6 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -330,11 +330,10 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	if (unlikely(ecn == 0xff))
 		goto err;
 
-	reasm_data = inet_frag_reasm_prepare(&fq->q, skb, prev_tail);
-	if (!reasm_data)
-		goto err;
-
-	payload_len = -skb_network_offset(skb) -
+	/* Check the size on the first fragment, which will become the head:
+	 * inet_frag_reasm_finish() must follow inet_frag_reasm_prepare().
+	 */
+	payload_len = -skb_network_offset(skb_rb_first(&fq->q.rb_fragments)) -
 		       sizeof(struct ipv6hdr) + fq->q.len -
 		       sizeof(struct frag_hdr);
 	if (payload_len > IPV6_MAXPLEN) {
@@ -343,6 +342,10 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 		goto err;
 	}
 
+	reasm_data = inet_frag_reasm_prepare(&fq->q, skb, prev_tail);
+	if (!reasm_data)
+		goto err;
+
 	/* We have to remove fragment header from datagram and to relocate
 	 * header in order to calculate ICV correctly. */
 	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 8418ed9423f4b..91a65fe673500 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -275,16 +275,19 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	if (unlikely(ecn == 0xff))
 		goto out_fail;
 
-	reasm_data = inet_frag_reasm_prepare(&fq->q, skb, prev_tail);
-	if (!reasm_data)
-		goto out_oom;
-
-	payload_len = -skb_network_offset(skb) -
+	/* Check the size on the first fragment, which will become the head:
+	 * inet_frag_reasm_finish() must follow inet_frag_reasm_prepare().
+	 */
+	payload_len = -skb_network_offset(skb_rb_first(&fq->q.rb_fragments)) -
 		       sizeof(struct ipv6hdr) + fq->q.len -
 		       sizeof(struct frag_hdr);
 	if (payload_len > IPV6_MAXPLEN)
 		goto out_oversize;
 
+	reasm_data = inet_frag_reasm_prepare(&fq->q, skb, prev_tail);
+	if (!reasm_data)
+		goto out_oom;
+
 	/* We have to remove fragment header from datagram and to relocate
 	 * header in order to calculate ICV correctly. */
 	nhoff = fq->nhoffset;
-- 
2.53.0



