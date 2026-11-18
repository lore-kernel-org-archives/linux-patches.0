Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042183;
	b=HubZmF97k+A4GgdEFfwB9r9KSAcq7o+7u0Dv42hmlPxJSU3Z+C7N+N6NXrisZ8Nt75lL
	 OXFnG6qPJPbH6Z1K7DiFBFyYncKsqTAefPQjCdAL5ElUMUCOdUvgUgLmFaPFjFYNOSXxj
	 VEPo1XvFqWMKtq2XkJQ1P0ZF2NGGo09q5MQs2HkNBTArugY4zlnTAGqcIIBCWmsxVIjo6
	 ahAdX2m+bJIl5a0yiWYvBeyaWfX6eI8eEWfclfjaXbhzEmx3dmP99vnsG13pOvb9+iAOZ
	 R0dP3d71YkORAu9zfnl+5NnPDOq+cX6DK4IYxYv6/yrPf51nFVYhysZIO72kozSrpYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1PKJfDeqpR+7sSO0HKMjVolWbZ2EyLbbGNAf/HfL18=;
	b=vR1Fr8lI3d+fdQJc5choV1YLdXzOHP4BpdbUhiUHGGaHoEE/eta6pdR97xm5tpjD7UTF
	 9Ps23sZ2rSBwdc88AEKoFazYzk1YuruITkJzBfDkuKSJw7mRTl9ouQqsM34UOmDvJ1oWp
	 7Hcz4C5Ki3myKiUmRun6quPdG4TzIl94oE8uDosfqRdR/z7PxdapzPCSmTwnM9cAwz6lt
	 lR4mqmHY4wDcTD8gFqX8E6hkuDxLo4rWnQeWQ3pYnXH/hbUajkY4ivml9yQ1Ju8jC8rnB
	 +1pNZq0OB67sfXyXMTRAjUwT3fStbGLlgdsxXbLV1naiivnDHghCVJaOL+ZO7kZR26A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KBIwz639;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13888606A320;
	Wed, 18 Nov 2026 22:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KBIwz639
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170341F000C4;
	Wed, 18 Nov 2026 22:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042182;
	bh=q1PKJfDeqpR+7sSO0HKMjVolWbZ2EyLbbGNAf/HfL18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBIwz6397zwVza+3MjLiNOp1lKkLENjtaOgk76F6oV5Zq7YmCo53aV7VJJaJhxT2W
	 apQ0Hx0iNwTFreB1X5MWXXYVXw5v6PDlf7AuEuYmkNy9qDaslGTqLlt+vHHbjGpfe5
	 DqVdQQPpDa1ZK+/rgC13uvsJglRkTjq+KIGiIBok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3080/3318] ipv6: account route exceptions to the netns of their dst
Date: Wed, 18 Nov 2026 16:01:42 +0100
Message-ID: <20261118150452.473161957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 8ff017b891e89276c15f06dfd7155981d572af77 ]

rt6_insert_exception() and rt6_remove_exception() update
rt6_stats->fib_rt_cache of dev_net(rt6i->dst.dev), but the device of an
exception dst can move to another netns while the exception is still in
its bucket.

This happens when the bucket is flushed from an RCU callback, for
instance from nexthop_free_rcu() for the nh_info of a replaced nexthop,
whose exceptions still point to live routes. If the device moves to
another netns before that callback runs, the decrement hits the other
netns, whose u32 counter underflows in /proc/net/rt6_stats, while the
counter of the original netns never goes back down.

Account exceptions to the netns their dst was allocated in, derived from
dst->ops as ip6_dst_gc() already does, which does not depend on the
device. The dst already relies on that netns' ip6_dst_ops being alive
when it is destroyed, which happens after the exception is removed.

Fixes: 81eb8447daae ("ipv6: take care of rt6_stats")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261016091556.2750902-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index aa8092413e944..bbc5b400a27e7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1492,6 +1492,15 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
  */
 static DEFINE_SPINLOCK(rt6_exception_lock);
 
+/* Exceptions are accounted to the netns their dst was allocated in.
+ * Unlike dev_net(dst->dev), it does not change when the device moves to
+ * another netns or when dst_dev_put() points the dst to blackhole_netdev.
+ */
+static struct net *rt6_exception_net(const struct rt6_info *rt)
+{
+	return container_of(rt->dst.ops, struct net, ipv6.ip6_dst_ops);
+}
+
 /* Remove rt6_ex from hash table and free the memory
  * Caller must hold rt6_exception_lock
  */
@@ -1503,7 +1512,7 @@ static void rt6_remove_exception(struct rt6_exception_bucket *bucket,
 	if (!bucket || !rt6_ex)
 		return;
 
-	net = dev_net(rt6_ex->rt6i->dst.dev);
+	net = rt6_exception_net(rt6_ex->rt6i);
 	net->ipv6.rt6_stats->fib_rt_cache--;
 
 	/* purge completely the exception to allow releasing the held resources:
@@ -1763,7 +1772,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	rt6_ex->stamp = jiffies;
 	hlist_add_head_rcu(&rt6_ex->hlist, &bucket->chain);
 	bucket->depth++;
-	net->ipv6.rt6_stats->fib_rt_cache++;
+	rt6_exception_net(nrt)->ipv6.rt6_stats->fib_rt_cache++;
 
 	/* Randomize max depth to avoid some side channels attacks. */
 	max_depth = FIB6_MAX_DEPTH + get_random_u32_below(FIB6_MAX_DEPTH);
-- 
2.53.0



