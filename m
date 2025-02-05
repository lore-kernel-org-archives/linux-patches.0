Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EC0F510;
	Wed,  5 Feb 2025 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764453; cv=none; b=r8yVZr+Sd/uhv7/QFbhmYICqFYfBbuR0WtfRqbT4WmLh9SQAsVnQY5OfhBoi50N2t1WPA0gSnydz6IudIIEYxd91J03ej/zYmU7RrYullwK4ao7mUjRFKoScD042sHItjvmJtEZfmhWeWLbOZhc30ujZRTAkH2qPEZ0T9ur+LyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764453; c=relaxed/simple;
	bh=gTrjvkrCe1uB0SYHusWarnuH8UDHDpzNiFPMhRGhgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gt3UVEfi1dOZm31nTdzkAlyfRiKnp3nCSJeI06VtxJFo482cGSY5jJDn+S0gyVluqiHy1nRlSH7pt85PoRsAr8FShU7XuoyTYsoM9eBYoGdxq04B1SujT4XBnCID/IalBufAo43lt2S5d5/cSOMpvzbLd9LGWHfb2y5N1EgBDUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBstwhCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBstwhCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42643C4CED1;
	Wed,  5 Feb 2025 14:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764453;
	bh=gTrjvkrCe1uB0SYHusWarnuH8UDHDpzNiFPMhRGhgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBstwhCM+31g9V1uThRzdjz4AOvkJelhilEseHzV4O37KtGPrzys/HQpPDMW+Hget
	 KQaXKFl9xCgkuiY/6khbhhZ7kjqYCDstKQH4S5i07/Pc64pc6lXsSErZAERnE/3Ed3
	 CDEH7ucZIg8i/kvbhdLzf6T9tqO5b831MGebEpWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/590] inetpeer: remove create argument of inet_getpeer()
Date: Wed,  5 Feb 2025 14:37:42 +0100
Message-ID: <20250205134459.351586474@linuxfoundation.org>
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
index 5bd7599634517..411a194f9c999 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -174,13 +174,11 @@ static void inet_peer_gc(struct inet_peer_base *base,
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
@@ -188,16 +186,11 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
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
@@ -206,7 +199,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 
 	gc_cnt = 0;
 	p = lookup(daddr, base, seq, gc_stack, &gc_cnt, &parent, &pp);
-	if (!p && create) {
+	if (!p) {
 		p = kmem_cache_alloc(peer_cachep, GFP_ATOMIC);
 		if (p) {
 			p->daddr = *daddr;
-- 
2.39.5



