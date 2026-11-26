Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705279;
	b=ynMoB2aEcI9yFcLBUbjmgGF7EXZupv9h+re+ZydXfCMsIe3MVsxwney/aEAgiSEY7XnH
	 kS7TLVzYeBq6Zn73RzYeP1+DbSwMhUSqMAVnNH0es5Op+wM+BJUxMFmhcW9VHBmu8WsFY
	 JrNt7U6jQheQWOQVsV2kKi6pDbiG7/792BzNYB9T1Bggqv1mBIZGhcxk6BO3fEhihi5Nj
	 ceyIdwGMDJ+TmBE8ITkD1TIM6SaMgCtppaUf4oyrDM6f6Yrb/x14JZHAbGHVPSqJbxFL8
	 mAjyq/oC/0b1glcsOD8l0PB/+L7qdH6G3wuSBLoGOKckNpyspPUmMZnKjrVMYGQ8vQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JkBmM4qPJVnv3Pp1+uRAROOR5Skn1BFudCYSO5JN5w8=;
	b=UmPROVkI0vWqfdBxJcUhHqOplauIOhPSsMZCqbLB57QVOn4MkL1u7ionpBqKz7Qe56C2
	 lPbgWnbUYAnu/7pfZgirAEd151A8zOe86AuMk0Bldb1sNT/WjPyjGC0/I40kpOjv2Ooiw
	 ZvqM1Q7VjbNE56UuWJVR+MIe8WMLyN4R2o4xGAi/UeYeBPU7eiDhKrik5ZXF/t4DRqe2V
	 I8iZV1H4qn+808OwV+rE72/BOeTCv2i5KC4uXN1y7XAZwA9fznj2wnxF60UhfabjDBzhy
	 7jDItj8WZq+xHVuLdUkyLISI3qmOcU+8glMpr2boyyHfhxDGEVL7dFBqQZEoy1nsPhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMR7qOA9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE4D606A31E;
	Thu, 26 Nov 2026 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMR7qOA9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBDE1F000C0;
	Thu, 26 Nov 2026 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705279;
	bh=JkBmM4qPJVnv3Pp1+uRAROOR5Skn1BFudCYSO5JN5w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMR7qOA9w1hDhlK0A1dFef5iHWKdhsRMtOiPfPIIp17KDL9hWqMCs6N1QyU63hA+y
	 Td1LaiMyWwa3JsJluX+kzwfgI7aHjk8ML1RAr/yYYhNo5wU08kEQMMLXSFx8RWFkit
	 m3cFbGeF5B2q9IpSiMYHOxBT3CmU1pT8AWkIsl4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/319] neigh: introduce neigh_confirm() helper function
Date: Thu, 26 Nov 2026 15:38:33 +0100
Message-ID: <20261126144010.021449708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 1e84dc6b7bbfc4d1dd846decece4611b7e035772 ]

Add neigh_confirm() for the confirmed member in struct neighbour,
it can be called as an independent unit by other functions.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c78b47704934 ("net: require a full socket in sock_confirm_neigh()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/arp.h       |  8 +-------
 include/net/ndisc.h     | 16 ++--------------
 include/net/neighbour.h | 11 +++++++++++
 include/net/sock.h      |  5 +----
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 4a23a97195f33..d7ef4ec71dfeb 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -53,13 +53,7 @@ static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 
 	rcu_read_lock_bh();
 	n = __ipv4_neigh_lookup_noref(dev, key);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index e97ef508664f4..8f137404714ba 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -411,13 +411,7 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
@@ -428,13 +422,7 @@ static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref_stub(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 0e9d33e4439ec..1dbd543d8378f 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -305,6 +305,17 @@ static inline struct neighbour *__neigh_lookup_noref(struct neigh_table *tbl,
 	return ___neigh_lookup_noref(tbl, tbl->key_eq, tbl->hash, pkey, dev);
 }
 
+static inline void neigh_confirm(struct neighbour *n)
+{
+	if (n) {
+		unsigned long now = jiffies;
+
+		/* avoid dirtying neighbour */
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
+	}
+}
+
 void neigh_table_init(int index, struct neigh_table *tbl);
 int neigh_table_clear(int index, struct neigh_table *tbl);
 struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
diff --git a/include/net/sock.h b/include/net/sock.h
index 77cef68c56335..b178e4b05540a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2224,13 +2224,10 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 {
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
-		unsigned long now = jiffies;
 
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
 		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
+		neigh_confirm(n);
 	}
 }
 
-- 
2.53.0



