Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964051494DF;
	Wed,  5 Feb 2025 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764840; cv=none; b=Jzqb0AOwaHL7xrVzFdkt+hrExbsmTMGbLiGZWqN0bcjzEgSGZtSab3xMuz0iWiYM7b39bF6dRQ0bqYasLJyIUTSd28+tIyhz6eGCGAeHqle9tHh4OXaoR6kwChfLNmbA8bh9VHU9kyq23WczqS/7ozBYQhG3i9qRJqB9MCQJvxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764840; c=relaxed/simple;
	bh=nh3pyinrxprfYqmpWODL8IDTAh7UsNe0QvEACIyy/BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gW3Olb8eNPAsX6GC42Sljce2Zr8ylCcr1eujUaGrxypcyKQYQEidh7gx0p0l0gqYZT4OUbvu1sY3kz7TYh80sozcYlnDAuZ7+SD8lSnOVICZpkg7fctiPwitJ66/HyJC6YOjwA4/Hy88Cfbu1GqvD1PuDxUssOkCnIydn0zmdms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdraiS1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdraiS1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FD1C4CED1;
	Wed,  5 Feb 2025 14:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764840;
	bh=nh3pyinrxprfYqmpWODL8IDTAh7UsNe0QvEACIyy/BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdraiS1JoC3LhS5y3we0GRHwkLucfkG4iW7rXJBNA2Qwc88I3f52rtBvXGQs5j8ZB
	 FLWU5ZSHZ5t+0OY/RGXbHTnnGf+s5AHtAp9KgUx+3Y45gmgRoG/awpowhVQrM2GgfE
	 mhHCS/7TlUhK5mgNMriu+pZ4hT39fQisXGzS2UAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 118/623] inetpeer: remove create argument of inet_getpeer()
Date: Wed,  5 Feb 2025 14:37:40 +0100
Message-ID: <20250205134500.734916718@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5ab56f4cb5297..bc79cc9d13ebb 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -169,13 +169,11 @@ static void inet_peer_gc(struct inet_peer_base *base,
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
@@ -183,16 +181,11 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
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
@@ -201,7 +194,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 
 	gc_cnt = 0;
 	p = lookup(daddr, base, seq, gc_stack, &gc_cnt, &parent, &pp);
-	if (!p && create) {
+	if (!p) {
 		p = kmem_cache_alloc(peer_cachep, GFP_ATOMIC);
 		if (p) {
 			p->daddr = *daddr;
-- 
2.39.5



