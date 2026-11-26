Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704308;
	b=XyxWLx7WcAc4Wr6au4sqUY+d1RJXoD8PgIKH9KzKWgqOrz+nj2FEuB6ORvHB/StWkVNu
	 Wqonhq9s9NB/GgnxAWME7F1kFzfQUx1UDSU22xplbOX3+dQSalF5yGufsEtL0YaQF2K45
	 cZ3yhY/UDFpJ4a43NC/pTzb8iQEjVSJJN7svcwNgtgML/iN9DBiO5RMrvoQf1gQCoz4vS
	 6CgZrDMmQwVzkkIg3u+DyZSlxUltpqrZg5/ISJbfuZciYUSWH2lzj7AwHHwGRGGdYLRMA
	 b/xz7kTCVPSkRBoEiW8eevQ415VFT2iHXjYTLpb2Mct6r4+0qLP1zLDMoengwJ0sk0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KlapgHuu5mU1wK6OsPGHKcpqAOwknFnIaVKVS3EiSt4=;
	b=rr7L3MNM1OTmm6k4DvBXAvBdULI45q22U4q4yGwQOZEBirTI7M3Fs1TfClHOSDcIpyKU
	 Fwcj+we02KEH36CHUdQq7L5DO5KkbsSZDntAxL5gnlDIEvVs9w0KD/GLHjoMPUyj3PfT/
	 uQ47A+GMj9VHfMk2p3iSfBH1n+GmMjGKYefbHipXrW2FXj8q9IeblYy00Rh3T9Y1byqF0
	 s+mf4u3ileQHAeNgeQiRNqADiDF3eqC4pn5fKwaAZfTlJLRODXBivNi3aBTSrothhSil1
	 uLvhX2aaQsM7jDz4UdGkSnISeUxhC1194QX6yQowB9Urrv+YnQGqezAZALWh3TOc5Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB9o4Gsc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F6F606A329;
	Thu, 26 Nov 2026 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB9o4Gsc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A431F000C0;
	Thu, 26 Nov 2026 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704308;
	bh=KlapgHuu5mU1wK6OsPGHKcpqAOwknFnIaVKVS3EiSt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nB9o4GscCbg5pLQYTYBvKY7KlLKOxliocs3/FccU2zVkC14gRKRNOab0t+BOob0bh
	 aaEGUpyZaZg2HcDDYtrYqaCWXLk8psUbAZXjRODl8rYj/jDqhhxLftkB/kzfRU1OID
	 Fyd1v6mEswqQj5KV9f8kbbnTR989Ut0gTKcU9dl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/265] ipv6: Flush exception route while replacing nexthop.
Date: Thu, 26 Nov 2026 15:36:47 +0100
Message-ID: <20261126143610.427905657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 9401b428b5d4dfe1fd5752973fd02b4e9cd05536 ]

The following creates a cyclic reference between IPv6 route
and nexthop:

  1. create a nexthop A
  2. create a nexthop group w/ A
  3. create an IPv6 route with the nexthop group
  4. create an exception route w/ A
  5. replace A with a new nexthop B in the nexthop group
  6. remove the IPv6 route
  7. replace B with A in the nexthop group
  8. remove the nexthop group

Then, removing a device tied to the route gets stuck and
triggers the splat below. [0]

At 5., fib6_nh_release_dsts() is called, but it does not
flush exception routes, so the nexthop A continues to grab
the IPv6 route reference.

  nh_A->rt6i_exception_bucket[] -> rt6_ex->rt6i->from

At 6., fib6_purge_rt() calls rt6_flush_exceptions(), but it
only purges exceptions tied to nexthop B.  Also, the route is
unlinked from the nexthop group by list_del_init(&rt->nh_list).

  -> f6i->nh -> nhg->nh_entries[]

At 8., __remove_nexthop_fib() cannot find the IPv6 route, and
remove_nexthop_group() calls list_del_init(&nhge->nh_list) to
unlink the group from the nexthop A's nhe->grp_list.

  nhg->nh_entries[] -> nh_A -> ... -> f6i

Here, the nexthop A is reachable from net->nexthop.devhash[],
but remove_nexthop_from_groups() cannot find the nexthop group,
leaking the whole chain.

Let's call fib6_nh_flush_exceptions() in fib6_nh_release_dsts().

[0]:
unregister_netdevice: waiting for gre6 to become free. Usage count = 4
ref_tracker: netdev@000000009652f190 has 1/3 users at
     dst_alloc+0x14b/0x490
     ip6_rt_cache_alloc+0x27b/0x670
     __ip6_rt_update_pmtu+0x572/0x850
     ip6_tnl_xmit+0x8c5/0x1b70
     __gre6_xmit+0x7af/0xaa0
     ip6gre_tunnel_xmit+0x685/0xdc0
     dev_hard_start_xmit+0x204/0x5a0
     __dev_queue_xmit+0xe8a/0x2550
     ip6_finish_output+0x232/0x570
     ip6_output+0x226/0x3b0
     ip6_send_skb+0x133/0x250
     rawv6_push_pending_frames+0x503/0x6f0
     rawv6_sendmsg+0xdf0/0x1310
     sock_sendmsg_nosec+0xde/0x130
     __sys_sendto+0x27f/0x320
     __x64_sys_sendto+0xd9/0xf0

Fixes: 7bf4796dd099 ("nexthops: add support for replace")
Reported-by: Jason Zhang <jdz@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261101064418.2055158-2-kuniyu@google.com
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a81f8fb43f852..44500bcc99a29 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3544,9 +3544,10 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 {
 	struct rt6_exception_bucket *bucket;
 
+	fib6_nh_release_dsts(fib6_nh);
+
 	rcu_read_lock();
 
-	fib6_nh_flush_exceptions(fib6_nh, NULL);
 	bucket = fib6_nh_get_excptn_bucket(fib6_nh, NULL);
 	if (bucket) {
 		rcu_assign_pointer(fib6_nh->rt6i_exception_bucket, NULL);
@@ -3555,7 +3556,6 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
 	rcu_read_unlock();
 
-	fib6_nh_release_dsts(fib6_nh);
 	free_percpu(fib6_nh->rt6i_pcpu);
 
 	fib_nh_common_release(&fib6_nh->nh_common);
@@ -3565,6 +3565,8 @@ void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
 {
 	int cpu;
 
+	fib6_nh_flush_exceptions(fib6_nh, NULL);
+
 	if (!fib6_nh->rt6i_pcpu)
 		return;
 
-- 
2.53.0



