Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469D21CAA6F;
	Wed, 19 Feb 2025 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956092; cv=none; b=sh0tA9ZCO5VLCOL+Ml5txySUVjt/bPBVC8LNPse4JDbCU07+w5MnznYVy1M72KjzKc6Cg3u2yvfPkRS+m3IZTL1k7tQxGyyh4jv04pEYg2bFDPVEHcjs3vwBAFKTk+cpq7JdPVHjEm/3/cMdzrdzeRdG7Zy7geWMwg9vM2UzyqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956092; c=relaxed/simple;
	bh=k6ozHqPYbDK21TL6ryuKiwDuul1h1NOs0X9iV39/UAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK+qhpQSzL54Q+qqTlBY5XPOcaJx0ywEgVt317WQeKZYHWYmro8RGQaczveIOOXiUeS2aUm0bzh958iTyDdpHErcaByf9xHqvR7nZcQ0C8kXGLjwmr/RNde4S5dDrIODomIGovWjIwypPX8QZDsvNjT1W0nb8KjbuUnO4sj30lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eSQcYfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eSQcYfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A46C4CED1;
	Wed, 19 Feb 2025 09:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956092;
	bh=k6ozHqPYbDK21TL6ryuKiwDuul1h1NOs0X9iV39/UAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eSQcYfJhVFlX1Ts9FrB+9kJP2V3y69CTeJNXPH15T8hebCgyHX8uj5CKZHQUeIHI
	 MkYOOcy8RTI34mjL5SwLRxmlaAJRHiO5n27+DQhLHIcGfKzYJ1Arm4yfpYuSGUq7y3
	 Wu03F0oMnkKoRJettOI18r4ZPSlXvtBrVzu31P7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/578] inetpeer: remove create argument of inet_getpeer()
Date: Wed, 19 Feb 2025 09:21:05 +0100
Message-ID: <20250219082655.289166523@linuxfoundation.org>
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

[ Upstream commit 7a596a50c4a4eab946aec149171c72321b4934aa ]

All callers of inet_getpeer() want to create an inetpeer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241215175629.1248773-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a853c609504e ("inetpeer: do not get a refcount in inet_getpeer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inetpeer.h |  7 +++----
 net/ipv4/inetpeer.c    | 11 ++---------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 6f51f81d6cb19..f475757daafba 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -96,8 +96,7 @@ static inline struct in6_addr *inetpeer_get_addr_v6(struct inetpeer_addr *iaddr)
 
 /* can be called with or without local BH being disabled */
 struct inet_peer *inet_getpeer(struct inet_peer_base *base,
-			       const struct inetpeer_addr *daddr,
-			       int create);
+			       const struct inetpeer_addr *daddr);
 
 static inline struct inet_peer *inet_getpeer_v4(struct inet_peer_base *base,
 						__be32 v4daddr,
@@ -108,7 +107,7 @@ static inline struct inet_peer *inet_getpeer_v4(struct inet_peer_base *base,
 	daddr.a4.addr = v4daddr;
 	daddr.a4.vif = vif;
 	daddr.family = AF_INET;
-	return inet_getpeer(base, &daddr, 1);
+	return inet_getpeer(base, &daddr);
 }
 
 static inline struct inet_peer *inet_getpeer_v6(struct inet_peer_base *base,
@@ -118,7 +117,7 @@ static inline struct inet_peer *inet_getpeer_v6(struct inet_peer_base *base,
 
 	daddr.a6 = *v6daddr;
 	daddr.family = AF_INET6;
-	return inet_getpeer(base, &daddr, 1);
+	return inet_getpeer(base, &daddr);
 }
 
 static inline int inetpeer_addr_cmp(const struct inetpeer_addr *a,
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index e9fed83e9b3cc..5670571ee5fbe 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -177,13 +177,11 @@ static void inet_peer_gc(struct inet_peer_base *base,
 }
 
 struct inet_peer *inet_getpeer(struct inet_peer_base *base,
-			       const struct inetpeer_addr *daddr,
-			       int create)
+			       const struct inetpeer_addr *daddr)
 {
 	struct inet_peer *p, *gc_stack[PEER_MAX_GC];
 	struct rb_node **pp, *parent;
 	unsigned int gc_cnt, seq;
-	int invalidated;
 
 	/* Attempt a lockless lookup first.
 	 * Because of a concurrent writer, we might not find an existing entry.
@@ -191,16 +189,11 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 	rcu_read_lock();
 	seq = read_seqbegin(&base->lock);
 	p = lookup(daddr, base, seq, NULL, &gc_cnt, &parent, &pp);
-	invalidated = read_seqretry(&base->lock, seq);
 	rcu_read_unlock();
 
 	if (p)
 		return p;
 
-	/* If no writer did a change during our lookup, we can return early. */
-	if (!create && !invalidated)
-		return NULL;
-
 	/* retry an exact lookup, taking the lock before.
 	 * At least, nodes should be hot in our cache.
 	 */
@@ -209,7 +202,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 
 	gc_cnt = 0;
 	p = lookup(daddr, base, seq, gc_stack, &gc_cnt, &parent, &pp);
-	if (!p && create) {
+	if (!p) {
 		p = kmem_cache_alloc(peer_cachep, GFP_ATOMIC);
 		if (p) {
 			p->daddr = *daddr;
-- 
2.39.5



