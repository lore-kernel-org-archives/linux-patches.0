Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051610;
	b=ZDimE0Jr5F9VQvCwUjfTUJYGqr108CUNDZ/Z7jFNsOfUO4+ftoK+NUb+JIZd7K/RiVaj
	 lw5oGpgycl/T1P3eVTWFgQNfV6GWzd3Jrll1WhIMHJZX72eFhSranNQvHow5THkD77zW6
	 P4dW1WVp0d/kgi9jR4KBfqc3zR3wH/wgyX9fGbIcFGJRhLHC4InEX7oPNaTzayDNRY9oh
	 /z/VNlczOfEvEZZriv7g79qKNywj5dyBC0NA1Gx2E5aH3JitQ+1VWkgY46yOzqEhYgILk
	 nXqNXBAKY8PLMDuOgwsYpmmBeYKRpe6R/uVadkT2ow9xtGKBOt311NxOBasCytsPDjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9KTcaB90lB3orlTDz7EXtiw/IeO90Jdt2gHNFsu75eU=;
	b=AR4kcUyTERdOT5OUCyinZtT5lJgj0+/jb5tEKCU0T21/5bIv08h7QYPkBUzCmJlgqLq7
	 wZRHafZFRzvHdHl677WNTJ9jDC9hecLQhAwJNAkjpa4Hb+McPa5hpDAmn14u4v4xQ5mgu
	 q2uWyOy2hZ0TEZDzL/sOcNieBj7qau/J62AtLQ9OoaN8hl2hiDvOte18XQ//qtSNuSEbT
	 UjUNKoXYqTynSFdVKzOtuETIBaXMqE8eph5EGil0tL6z2RKqcq5NVROCYvkCFEThvZ5Ga
	 jg3v0AVm6bQQfCAMSwArC4o87cR2EVP22Aml0W8UYwFJYKXI/P+JG/ULl+SZ/zvat2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9kqS4xg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E18606A31C;
	Thu, 19 Nov 2026 01:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9kqS4xg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D45A1F000C4;
	Thu, 19 Nov 2026 01:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051609;
	bh=9KTcaB90lB3orlTDz7EXtiw/IeO90Jdt2gHNFsu75eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9kqS4xg2q1qV/C5tDX97vnbU5U1EaCy3E4v+ZcLuq7Sxh1b2PGIlfTEfBe90ULVf
	 9m0LA8mwDkGdWyHI1WWcQXHhDVgmwx13QSArHZ6JqISEhJOT+5FA7C5DCHnLh6B5qH
	 wipDm5nFvf8YAC9aUccQ5l0kScbPGh/FnnMEoIf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Praveen Kumar Kannoju <praveen.kannoju@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0270/2214] ipv4: start using dst_dev_rcu()
Date: Wed, 18 Nov 2026 15:32:26 +0100
Message-ID: <20261118150020.884289053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]

Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.

Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org

Conflicts:
	net/ipv4/icmp.c
	net/ipv4/ip_fragment.c
	net/ipv4/ipmr.c
	net/ipv4/route.c

 - Preserve the four-argument inet_getpeer_v4() and inet_putpeer() calls.
   Return before taking RCU for ICMP types exempt from rate limiting;
   release RCU on both the loopback and rate-limited paths.
 - Keep ip_frag_queue(qp, skb) and ipq_put(qp). Add RCU protection before
   selecting the device and release it on both queue lookup outcomes.
 - Use dst_dev_rcu() in the older ipmr_queue_xmit() implementation. Add
   the IPv4 cache-replay RCU wrapper from b07a9b26e2b1 ("ipmr: Always call
   ip{,6}_mr_forward() from RCU read-side critical section"), which this
   baseline lacks. RTNL alone does not satisfy the checked accessor.
 - Nest ordinary RCU inside the existing RCU-BH section in neighbour
   lookup. dst_dev_rcu() checks ordinary RCU, while the older neighbour
   hash walkers still require BH protection via rcu_dereference_bh().

Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c        | 8 +++++---
 net/ipv4/ip_fragment.c | 9 +++++++--
 net/ipv4/ipmr.c        | 4 +++-
 net/ipv4/route.c       | 5 ++++-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 49c94aebac32d..5f44609671b64 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -323,20 +323,22 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 	int vif;
 
 	if (icmpv4_mask_allow(net, type, code))
-		goto out;
+		return true;
 
 	/* No rate limit on loopback */
-	dev = dst_dev(dst);
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
 	if (dev && (dev->flags & IFF_LOOPBACK))
 		goto out;
 
-	vif = l3mdev_master_ifindex(dev);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
 		inet_putpeer(peer);
 out:
+	rcu_read_unlock();
 	return rc;
 }
 
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 23312d028af28..5cdc65a5c010b 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -475,13 +475,16 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 /* Process an incoming IP datagram fragment. */
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
-	int vif = l3mdev_master_ifindex_rcu(dev);
+	struct net_device *dev;
 	struct ipq *qp;
+	int vif;
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
 
 	/* Lookup (or create) queue header */
+	rcu_read_lock();
+	dev = skb->dev ? : skb_dst_dev_rcu(skb);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
 		int ret;
@@ -491,9 +494,11 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 		ret = ip_frag_queue(qp, skb);
 
 		spin_unlock(&qp->q.lock);
+		rcu_read_unlock();
 		ipq_put(qp);
 		return ret;
 	}
+	rcu_read_unlock();
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	kfree_skb(skb);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index d5ae2df481a48..855da7c3a906a 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1000,7 +1000,9 @@ static void ipmr_cache_resolve(struct net *net, struct mr_table *mrt,
 
 			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
 		} else {
+			rcu_read_lock();
 			ip_mr_forward(net, mrt, skb->dev, skb, c, 0);
+			rcu_read_unlock();
 		}
 	}
 }
@@ -1858,7 +1860,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 			goto out_free;
 	}
 
-	dev = rt->dst.dev;
+	dev = dst_dev_rcu(&rt->dst);
 
 	if (skb->len+encap > dst_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
 		/* Do not fragment multicasts. Alas, IPv4 does not
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d504d8cdd0300..b444a57498c2c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -424,10 +424,12 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 					   const void *daddr)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst_dev(dst);
+	struct net_device *dev;
 	struct neighbour *n;
 
 	rcu_read_lock_bh();
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
 
 	if (likely(rt->rt_gw_family == AF_INET)) {
 		n = ip_neigh_gw4(dev, rt->rt_gw4);
@@ -443,6 +445,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 
+	rcu_read_unlock();
 	rcu_read_unlock_bh();
 
 	return n;
-- 
2.53.0



