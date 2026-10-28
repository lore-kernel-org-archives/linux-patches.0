Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214470;
	b=5O5okqqEi4F/W0VioG9kLo0tYiXig7JyZmccJdIQNEjsKlokaahSpKl+sFV/hk9YS4IK
	 p3zZq6niX71EKyPQwduXSRtGiyX8+AxPew3SqR8WI6NTym7aQEJyfBboqOP1FLnGIr7Lo
	 qfzS1yHFubFdTb1p7X3eBVil+imTPXknFd03uLZg2IqpRUv5BDYmfz5/kF4RnEbkPi3yw
	 1huABIFX4iYJB7kRFFIzOQQHHcjNzp6lObdm+yovpLVYSWm2J/JI8pIHGpRnp1N3Z9XPJ
	 /Z8MqdGmzTAoGsgd/g6+VH5Nw0Ui3xdieUVE0/02SKykhvq0nNoCJLhABHzVBmXbnPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cb2p8rIEccGRqTHx2p0oB7NDBOG/rhAhzGvYFonoELY=;
	b=NnVXgq54zbc3Df1x6uCVoXBMw0m2MXcGK50/+SXjJFWcUVwnp1MQuoQlKCeZDeCNhruZ
	 RQ8WXuc/pc0ei5gR1zQbuEg/Oj8zlg/MoKmOeFrEUw4PkNfu6eCu0rEJPBEhqgGBnmhoY
	 I5Nxi2JZbRlXo4qHikRWcaRtY6xyQvDzg5qtU7nHFZC54iNavkQqzvs8DmarcDKqyCATc
	 4x4VDPxoWe37/nlvAdQ1GfMImYV9C/OYWFAvs8ieLCna4fW/dzNHJajctSVtieLRWfyoB
	 EH00BETVgg9nxIf6O/RdNbiNmUI3BXVDmotlUUp3Dvqxfy7ohjDK5HNqkW4jXked5hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKbuysZX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8704E606AB26;
	Wed, 28 Oct 2026 19:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKbuysZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D733B1F031E6;
	Wed, 28 Oct 2026 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214470;
	bh=Cb2p8rIEccGRqTHx2p0oB7NDBOG/rhAhzGvYFonoELY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKbuysZXWTkpQO9ZEK+vaOZZTNkEOe3KwFkbAAzIONm6Zm2wG9Bfgv62Nr5luMO4x
	 Br2p4C4aHC3de10pv9JmXGvLtAxXIhvAY/QFKWH9stNIQkMlNDUMzk3kLGoRGaUmeQ
	 MU99BRZvcYR5/E97WBNYvmp8XFWwUJzwtSSI7cHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0871/1887] net: use dst_dev_rcu() in sk_setup_caps()
Date: Wed, 28 Oct 2026 17:49:27 +0100
Message-ID: <20261028170519.238100917@linuxfoundation.org>
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

[ Upstream commit 99a2ace61b211b0be861b07fbaa062fca4b58879 ]

Use RCU to protect accesses to dst->dev from sk_setup_caps()
and sk_dst_gso_max_size().

Also use dst_dev_rcu() in ip6_dst_mtu_maybe_forward(),
and ip_dst_mtu_maybe_forward().

ip4_dst_hoplimit() can use dst_dev_net_rcu().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h        | 17 +++++++++++++----
 include/net/ip6_route.h |  2 +-
 include/net/route.h     |  2 +-
 net/core/sock.c         | 10 +++++++---
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 49e86b8bf9c9a..855998087701e 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -459,9 +459,14 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net *net = dev_net(dst_dev(dst));
-	unsigned int mtu;
+	const struct net_device *dev;
+	unsigned int mtu, res;
+	struct net *net;
+
+	rcu_read_lock();
 
+	dev = dst_dev_rcu(dst);
+	net = dev_net_rcu(dev);
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
@@ -475,7 +480,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	if (mtu)
 		goto out;
 
-	mtu = READ_ONCE(dst_dev(dst)->mtu);
+	mtu = READ_ONCE(dev->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
 		if (rt->rt_uses_gateway && mtu > 576)
@@ -485,7 +490,11 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 out:
 	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
 
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+	res = mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+
+	rcu_read_unlock();
+
+	return res;
 }
 
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 9df55c2ee058c..6b7dae7d47dbe 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -337,7 +337,7 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 
 	mtu = IPV6_MIN_MTU;
 	rcu_read_lock();
-	idev = __in6_dev_get(dst->dev);
+	idev = __in6_dev_get(dst_dev_rcu(dst));
 	if (idev)
 		mtu = idev->cnf.mtu6;
 	rcu_read_unlock();
diff --git a/include/net/route.h b/include/net/route.h
index ce608f8830401..4e2f8c3e1f98e 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -362,7 +362,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 		const struct net *net;
 
 		rcu_read_lock();
-		net = dev_net_rcu(dst_dev(dst));
+		net = dst_dev_net_rcu(dst);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		rcu_read_unlock();
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 8593dc1b33eb3..6f8a15aa4a126 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2395,9 +2395,12 @@ static void sk_trim_gso_size(struct sock *sk)
 
 void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
+	const struct net_device *dev;
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst_dev(dst)->features;
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
+	sk->sk_route_caps = dev->features;
 	if (sk_is_tcp(sk))
 		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
@@ -2410,15 +2413,16 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
-			sk->sk_gso_max_size = READ_ONCE(dst_dev(dst)->gso_max_size);
+			sk->sk_gso_max_size = READ_ONCE(dev->gso_max_size);
 			sk_trim_gso_size(sk);
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dev->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
 	sk_dst_set(sk, dst);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(sk_setup_caps);
 
-- 
2.53.0



