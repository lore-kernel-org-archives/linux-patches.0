Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056678;
	b=SZo7rwHEoa1uvfFLLmvQAnooGHiN15D76twcCpV+oIacC2NVTz77l1kQo2uFv18K/iFo
	 WZSqUFhbKhabQBtrqWoGImvq5T+MAkHxXjURcgjg/IWMHMMrBgtStuejEM9nM6ula482k
	 1eSi+5xzu4RZTpmJG6KkParu72G/iGiqB4UAz3G0FDuMHAAMROPp0GIfqy03HmUSdwezQ
	 l5cURuQMffdXzkmcjG9FTj42+EAb9SOsxIMdXW+X5Ycg0pQBpJ3lrGdX2gMRUZ5oFdvkG
	 8+sqkw4JpPerrIUhFNURBInC12T2/bEejXaHy1oGLhA3KBCAf9GBkd+Jbl+L1eNwSFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=18SUyDXzf73cgHECf/9DxhmYDXU1zD6NlfQjhF5ESQU=;
	b=0M48ix9cZXqWerVOyoq1vOWpcoNr4SG+L5rV5XLqnQl6529hiEiZ0cU/C+26KrvOrTa+
	 qvvZjICb5CX9+B3UE0O+ceffxg1cIcoJs98L1gtR3Fa/UrUZYeDxnOEJZByJk+IqV3WAH
	 l3uYazBJf+9SYIF7SAr13lnOzooGRL4pkDrgHt4yaVzpL2yqiHKAi+RjaiwWwoq/4i3+2
	 wObA/STBnqt43l6R8r+ha09ubMgi9jTu3AGKxMd8trd7DtQ3aKjsEMvulYP2bTtpuIcae
	 LscKZFheuvQum/KlKq+DAF/NaIVeFdZ0UXHUyvp+sGE2/qdciRCvZjIu3i5U2x4V0rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8GWs9AH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6707606A31C;
	Thu, 19 Nov 2026 02:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8GWs9AH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D83A1F000C4;
	Thu, 19 Nov 2026 02:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056677;
	bh=18SUyDXzf73cgHECf/9DxhmYDXU1zD6NlfQjhF5ESQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8GWs9AHe/xaAbPgAMuLNOV7TWr+AFfzFHYEV7Wf8qsX9YP37cPddwNXDINIqidPf
	 6bQWqs/g3wq/qQDD9/SzX9siDz7YBBEGBCLwe2TfLe9VHBM1R1k1NNFwxKvSqYEy5k
	 KBnuV0oTrrsaA207cO8VRzXkFr3llVEx/VJStZQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2072/2214] ipv6: account route exceptions to the netns of their dst
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150133.514481032@linuxfoundation.org>
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
index c9dc099c90234..8286e723d56bc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1442,6 +1442,15 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
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
@@ -1453,7 +1462,7 @@ static void rt6_remove_exception(struct rt6_exception_bucket *bucket,
 	if (!bucket || !rt6_ex)
 		return;
 
-	net = dev_net(rt6_ex->rt6i->dst.dev);
+	net = rt6_exception_net(rt6_ex->rt6i);
 	net->ipv6.rt6_stats->fib_rt_cache--;
 
 	/* purge completely the exception to allow releasing the held resources:
@@ -1713,7 +1722,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	rt6_ex->stamp = jiffies;
 	hlist_add_head_rcu(&rt6_ex->hlist, &bucket->chain);
 	bucket->depth++;
-	net->ipv6.rt6_stats->fib_rt_cache++;
+	rt6_exception_net(nrt)->ipv6.rt6_stats->fib_rt_cache++;
 
 	/* Randomize max depth to avoid some side channels attacks. */
 	max_depth = FIB6_MAX_DEPTH + prandom_u32_max(FIB6_MAX_DEPTH);
-- 
2.53.0



