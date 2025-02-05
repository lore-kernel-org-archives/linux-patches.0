Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12441519AA;
	Wed,  5 Feb 2025 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764379; cv=none; b=JWro2jv0RUrHGiaRat0mfxObo0LArq3w4CnY4rgwIJt3mkzBD8k5zceVbhsagUfFqeu5WqH0rtmRCeZF3oWg33CqmdtgcBeZcI60be6Mk00Dh9drJElkut0RwznVNh50W9QaDWEh4Q+XVWATE/oE1LXWrCL2NPO6KWVCAFuER9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764379; c=relaxed/simple;
	bh=8eDq47HPxCf6jTybK5Kio0Esdiko9Of1OQuAIC2/iS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvBArmbC9JiXp8YK/+evCN1bjQYaB8B6A4fVjuHDJZRfeHSP3L2GLmqYvALbvApMi7dcL+GsPaswJ8kmejuGQeLe4vsDyB5rXxpHVwWNd6qbwJkgpxkBNJGS+7Vr0K1axQjdlgx2nFQ9jLOyA5FcXaDwhql84rqqQUlurthLJfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZQtQmj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZQtQmj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB47AC4CED1;
	Wed,  5 Feb 2025 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764379;
	bh=8eDq47HPxCf6jTybK5Kio0Esdiko9Of1OQuAIC2/iS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZQtQmj5o/hO9cDcPHcUxr/iwlfEPAuAxgpsMqo5FLirR9WzIdwa3Gow8/4gH3i5I
	 ZXbvtY3X+CiRvSQv8MCoFOwPLiHLv3mRx9V/xaGqDu0VGgaqXl34JLNGDZxW0lr6SH
	 uN5mflpkek14/XYsQ3VZcTjz807mkAyLyraVVgaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/590] inetpeer: remove create argument of inet_getpeer_v[46]()
Date: Wed,  5 Feb 2025 14:37:41 +0100
Message-ID: <20250205134459.313106302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3ad41573b33e..c9846159a4c3e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -322,7 +322,7 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 		goto out;
 
 	vif = l3mdev_master_ifindex(dst->dev);
-	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
+	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif);
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index a92664a5ef2ef..34f9dbc4ccb40 100644
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
index 723ac9181558c..7a4cf60cece7c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -873,7 +873,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	net = dev_net(rt->dst.dev);
-	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif, 1);
+	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif);
 	if (!peer) {
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
 			  rt_nexthop(rt, ip_hdr(skb)->daddr));
@@ -976,7 +976,7 @@ static int ip_error(struct sk_buff *skb)
 	}
 
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr,
-			       l3mdev_master_ifindex(skb->dev), 1);
+			       l3mdev_master_ifindex(skb->dev));
 
 	send = true;
 	if (peer) {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 071b0bc1179d8..4593e3992c67b 100644
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
index f26841f1490f5..a66180a3eefe9 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -613,7 +613,7 @@ int ip6_forward(struct sk_buff *skb)
 		else
 			target = &hdr->daddr;
 
-		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr, 1);
+		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr);
 
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index aba94a3486737..f113554d13325 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1731,7 +1731,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
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



