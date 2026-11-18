Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060044;
	b=0nhAORHPM2NXK9PuKVZMkHJDcZnY33vohwBibNej1sKZ+jEspnk2qzb6+jOXQ4jFS5Px
	 KMDs8UZz+RflpIsD6UGoApVL+4pCx/a+LAdO1Q5Y4K7dVDhPchjQ4f2+Qmuy3BIp+6psn
	 2nnRyRvFCflMM1sm3d7iXW/S9NBAa9SRVyVup8GMIn9l9sZbq20fXDbyM07uK1Vn6ymku
	 KInNh6CbSt3h9SIdMZ63EXjCK7tyQHPMLdiU0Ed50SqKq/tWpOIxMzR2PuzZq3Lbjz9A/
	 L+BWeHRDftJOTN+KkkgUY59Y5G9E91xBY9op5ku5t0rFf2nRoIFql8WMasAWMlYGWew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mIdIbU+EbhzeA/FJ6u7Naz4xPUx3inKWfDGadwyPWNo=;
	b=zyT0Ipv/OAGvXY/Rt6+I2z0xuVsjACdg0t6m7qFnOiEVMr+CraEDm8bhUDsr7pXoJrfh
	 Ozpuks90kQNCNW70A5KLIMRb3IuSItVGbWvpdgRPiydXtmoyCVPtlF1/BE512fT99Fxbc
	 IMSxRoIrAIG7dpdtVljgVw59KVQi5CQh84ElnYW+uDjy24BMRgQWmsq7l+ieyYyfQrd4S
	 D/l/0vp6D/Yd6MOOKOzMz8AKgg2Lovb9HXxx0CTU6LOXVF57mEufwFcelGLOILizRCA7s
	 k11jYQwR7b775E1aTJVMKXWKMUI1mH38C9xM9C9z1hXaCI6rY4x3+gF+qL1TU+IwTqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9PzbLq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07F8606A320;
	Thu, 19 Nov 2026 03:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9PzbLq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54AF1F000C9;
	Thu, 19 Nov 2026 03:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060044;
	bh=mIdIbU+EbhzeA/FJ6u7Naz4xPUx3inKWfDGadwyPWNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9PzbLq2zcDDAfeeaJCEApFC4bh1lPEfXbkUWH4AaKrB0+FQmtpasH0F+PgEosiSL
	 0Ig1QGxLX+DHTU4UTqVMSXtSNAMqPNAkkay4OqK3uohGEDWpqADphh/xD9/zbVriNe
	 KEvvbYV5U5VkC6+T1+1YzS6Dnka1umQZAHg2L6Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Wang Zhan <wang.zhan@smartx.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1021/1848] inet: frags: limit the truesize of a reassembly queue
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118145959.916068619@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 3ae20e4697eb969104fe4b1e98a675f0100382b6 ]

The truesize of fragments in a reassembly queue is only bounded by
the per netns ipfrag_high_thresh sysctl, which has no upper limit.

inet_frag_reasm_finish() sums the truesize of all fragments in an int.
If this sum reaches 2^32, it wraps, and the final sk_wmem_alloc
adjustment of the socket owning the reassembled skb can cancel its own
reference, leading to a use-after-free of this socket.

This can be triggered from an unprivileged user/network namespace,
raising ipfrag_high_thresh and using padded TUN packets, which keep
a large truesize after being trimmed by ip_rcv_core().

Track the sum of the truesize of fragments in each queue, and refuse
a fragment that would make it bigger than INT_MAX / 2. Callers kill
the queue on this error. This bound is far above the needs of
legitimate traffic.

Fixes: 18685451fc4e ("inet: inet_defrag: prevent sk release while still in use")
Cc: stable@vger.kernel.org
Reported-by: Kyle Zeng <kylebot@openai.com>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Tested-by: Wang Zhan <wang.zhan@smartx.com>
Link: https://patch.msgid.link/20261030081225.2575462-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: moved the truesize reset from inet_frag_queue_flush() to ip_frag_reinit() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_frag.h  | 9 +++++++++
 net/ipv4/inet_fragment.c | 4 ++++
 net/ipv4/ip_fragment.c   | 1 +
 3 files changed, 14 insertions(+)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 4cbd413e71a3f..400375468536c 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -71,6 +71,7 @@ struct frag_v6_compare_key {
  * @meat: length of received fragments so far
  * @flags: fragment queue flags
  * @max_size: maximum received fragment size
+ * @truesize: sum of the truesize of queued fragments
  * @fqdir: pointer to struct fqdir
  * @rcu: rcu head for freeing deferall
  */
@@ -91,6 +92,7 @@ struct inet_frag_queue {
 	int			meat;
 	__u8			flags;
 	u16			max_size;
+	unsigned int		truesize;
 	struct fqdir		*fqdir;
 	struct rcu_head		rcu;
 };
@@ -173,6 +175,13 @@ extern const u8 ip_frag_ecn_table[16];
 #define IPFRAG_OK	0
 #define IPFRAG_DUP	1
 #define IPFRAG_OVERLAP	2
+#define IPFRAG_TOOBIG	4
+
+/* Max sum of the truesize of fragments in a queue. This keeps the sums
+ * done in inet_frag_reasm_prepare() and inet_frag_reasm_finish() well
+ * below INT_MAX. Legitimate traffic stays far below this limit.
+ */
+#define INET_FRAG_MAX_TRUESIZE	(INT_MAX / 2)
 int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 			   int offset, int end);
 void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 18217537cb298..6d6d90123be02 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -353,6 +353,9 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 {
 	struct sk_buff *last = q->fragments_tail;
 
+	if (skb->truesize > INET_FRAG_MAX_TRUESIZE - q->truesize)
+		return IPFRAG_TOOBIG;
+
 	/* An IP fragment is never a GSO packet, but an untrusted source
 	 * (virtio_net_hdr) may have attached GSO metadata to it. Do not let
 	 * that reach the reassembled skb, whose head keeps the first
@@ -415,6 +418,7 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 
 	FRAG_CB(skb)->ip_defrag_offset = offset;
 
+	q->truesize += skb->truesize;
 	return IPFRAG_OK;
 }
 EXPORT_SYMBOL(inet_frag_queue_insert);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 5cdc65a5c010b..00dff2c866154 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -263,6 +263,7 @@ static int ip_frag_reinit(struct ipq *qp)
 	qp->q.rb_fragments = RB_ROOT;
 	qp->q.fragments_tail = NULL;
 	qp->q.last_run_head = NULL;
+	qp->q.truesize = 0;
 	qp->iif = 0;
 	qp->ecn = 0;
 
-- 
2.53.0



