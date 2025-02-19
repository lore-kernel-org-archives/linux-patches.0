Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7837A1CAA6F;
	Wed, 19 Feb 2025 09:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956089; cv=none; b=Xc89JiWyxrnnTdBCj3zCO+mFoS7s5UQODuIavCtboyn3gn/2EFZP5JT6X9+8/IT86q2O19SUaQY/bfEIDX+hyTBcS+anr/ipoopQC3T+YDkfAlV+43RUJ/WrJAf4BM6fwBqx07GBiv/jmDyUeOzOjYOBwPBkG904AdiKEpn8jUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956089; c=relaxed/simple;
	bh=l0j2ELJyUJ4C7EHuQ7xJMGGRnAH4b1ipM/GILXcfwNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFM4T6MWbBiGG9bXVwImlk8fg6OsbEl5ktjU3vA/iKMWMDaSSsLXPLo4N9fgstHwtM9N5RA6FSoV/kK1OxctYujV0eRJ0vqBSCLxUGnbGelVifBySQAv4+wu4A0UC66VeadgFAnrPT8z6YpA3kpgNHN1KoFjejNf1Ke08CX6Hwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WejUG56H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WejUG56H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F384BC4CED1;
	Wed, 19 Feb 2025 09:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956089;
	bh=l0j2ELJyUJ4C7EHuQ7xJMGGRnAH4b1ipM/GILXcfwNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WejUG56HavOIynzevX73QccQ3scZ0wcHhWlGa2zojtEqtOQ+ChPdGiE1YWKeHWbCK
	 aSz8E8wdJmbKjYdt0pfgSui/+W1Wahq2orRiQC8a/yugK18Ykc1/dtXp9DCBkymAu0
	 rvb5vdVL4UFbNI3JgDxQ5VV9JPBCmhsl5YDZIB14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/578] inetpeer: remove create argument of inet_getpeer_v[46]()
Date: Wed, 19 Feb 2025 09:21:04 +0100
Message-ID: <20250219082655.249304823@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 661cd8fc8e9039819ca0c22e0add52b632240a9e ]

All callers of inet_getpeer_v4() and inet_getpeer_v6()
want to create an inetpeer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241215175629.1248773-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a853c609504e ("inetpeer: do not get a refcount in inet_getpeer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inetpeer.h | 9 ++++-----
 net/ipv4/icmp.c        | 2 +-
 net/ipv4/ip_fragment.c | 2 +-
 net/ipv4/route.c       | 4 ++--
 net/ipv6/icmp.c        | 2 +-
 net/ipv6/ip6_output.c  | 2 +-
 net/ipv6/ndisc.c       | 2 +-
 7 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 74ff688568a0c..6f51f81d6cb19 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -101,25 +101,24 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 
 static inline struct inet_peer *inet_getpeer_v4(struct inet_peer_base *base,
 						__be32 v4daddr,
-						int vif, int create)
+						int vif)
 {
 	struct inetpeer_addr daddr;
 
 	daddr.a4.addr = v4daddr;
 	daddr.a4.vif = vif;
 	daddr.family = AF_INET;
-	return inet_getpeer(base, &daddr, create);
+	return inet_getpeer(base, &daddr, 1);
 }
 
 static inline struct inet_peer *inet_getpeer_v6(struct inet_peer_base *base,
-						const struct in6_addr *v6daddr,
-						int create)
+						const struct in6_addr *v6daddr)
 {
 	struct inetpeer_addr daddr;
 
 	daddr.a6 = *v6daddr;
 	daddr.family = AF_INET6;
-	return inet_getpeer(base, &daddr, create);
+	return inet_getpeer(base, &daddr, 1);
 }
 
 static inline int inetpeer_addr_cmp(const struct inetpeer_addr *a,
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 9dffdd876fef5..203734e29d462 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -326,7 +326,7 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 		goto out;
 
 	vif = l3mdev_master_ifindex(dst->dev);
-	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
+	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif);
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 6c309c1ec3b0f..1427a94fc77a0 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -89,7 +89,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 	q->key.v4 = *key;
 	qp->ecn = 0;
 	qp->peer = q->fqdir->max_dist ?
-		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif, 1) :
+		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif) :
 		NULL;
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index fda88894d0205..ae83b86fb209d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -885,7 +885,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	net = dev_net(rt->dst.dev);
-	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif, 1);
+	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif);
 	if (!peer) {
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
 			  rt_nexthop(rt, ip_hdr(skb)->daddr));
@@ -988,7 +988,7 @@ static int ip_error(struct sk_buff *skb)
 	}
 
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr,
-			       l3mdev_master_ifindex(skb->dev), 1);
+			       l3mdev_master_ifindex(skb->dev));
 
 	send = true;
 	if (peer) {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ed8cdf7b8b11e..ad34482186a9c 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -222,7 +222,7 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 		if (rt->rt6i_dst.plen < 128)
 			tmo >>= ((128 - rt->rt6i_dst.plen)>>5);
 
-		peer = inet_getpeer_v6(net->ipv6.peers, &fl6->daddr, 1);
+		peer = inet_getpeer_v6(net->ipv6.peers, &fl6->daddr);
 		res = inet_peer_xrlim_allow(peer, tmo);
 		if (peer)
 			inet_putpeer(peer);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4082470803615..5332aeddf9277 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -610,7 +610,7 @@ int ip6_forward(struct sk_buff *skb)
 		else
 			target = &hdr->daddr;
 
-		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr, 1);
+		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr);
 
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index cfb4cf6e66549..d1eb0e324b7c0 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1721,7 +1721,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 			  "Redirect: destination is not a neighbour\n");
 		goto release;
 	}
-	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr, 1);
+	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 	if (peer)
 		inet_putpeer(peer);
-- 
2.39.5



