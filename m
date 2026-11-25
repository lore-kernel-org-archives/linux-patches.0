Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624479;
	b=XM5lu05dbWJ1b3n+B/JRjGfxyz7jkI6Zf7KB2zVzijgRWT3o1WmVz35eplOIqKScPcoc
	 evvPuU86VNURsGbcOHhAu1C3JlBWZ+55dBtrzGrjCVHfcvl1w5K/CiJzxv6uTLdQ7eIxs
	 hhj8GBF97Wiezks8435xxuapX92eDrly+byrXHp395vtvJF3TMG9Xyrh9weizUq6Ntelr
	 gqMqip4rXMOzC38v5mn96G06/pAbmthFxiFG+jJ5+hLHF9RD4KsnGq+b6zYUjIqJmWnNg
	 p2wJHrJZKmBZ8j6o1GJyGpbaTJaMmCSFKWkbE1tQGXES5hdglfu5lyuDFhwUTYHxUlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5kXk2Il7DC6e4cWF6Qi46SsCGXtVmNsgb6rFq2NaOiM=;
	b=cIdGbFbzo7ohPqtvnph6YdsCIuOEF6AqgRT0uTHDaiO6NScqD5JmxrsPOtCRDSt9UnEH
	 i6wIOm8XKhPxV4gjl4mbIYV7GBelZpvWB5ns6d7r3WcA1RPjRNYHXYG8iz8lvk0TjZvpD
	 HPwfIvM8McJ2dXB6cnlCO0ycdDIJIstHHBRn5ZLax4eWwTr9vMvYG2E+QLWX1YAWfZ+lY
	 pitGV8B/jgph/eM9SQpfpuuJ/wSff27l0zlZD5fHjwVf8B9eRFuRlbCE+21F7XM7A3jlz
	 EILokUJy620xVHWZWONqYQnPv20gcQp57ND+ijOJqg5QEVpxNXw5aslzwb60nvTVV1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yrd0Fpup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF712606A33B;
	Wed, 25 Nov 2026 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yrd0Fpup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DA01F000C4;
	Wed, 25 Nov 2026 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624479;
	bh=5kXk2Il7DC6e4cWF6Qi46SsCGXtVmNsgb6rFq2NaOiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrd0Fpup4M7Pf38DXvdjQhf2y6UABh+a3U1GodmUFndsnfCDUv/njHC4m6rNH5Ziy
	 l5e4dcOWXU82V4Vi/Fr1XpnE2tu9ERQYag37t5YuQDmYYW5WCm9Xt3v6M608vPxIDY
	 7twCl2XOunNPrUjfswEoX8FoQGg9S0Tf/tOnj2J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/816] ipv6: Flush exception route while replacing nexthop.
Date: Wed, 25 Nov 2026 15:29:13 +0100
Message-ID: <20261125143853.940033836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3af35b9728459..ced56c191dd73 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3721,9 +3721,10 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 {
 	struct rt6_exception_bucket *bucket;
 
+	fib6_nh_release_dsts(fib6_nh);
+
 	rcu_read_lock();
 
-	fib6_nh_flush_exceptions(fib6_nh, NULL);
 	bucket = fib6_nh_get_excptn_bucket(fib6_nh, NULL);
 	if (bucket) {
 		rcu_assign_pointer(fib6_nh->rt6i_exception_bucket, NULL);
@@ -3732,7 +3733,6 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
 	rcu_read_unlock();
 
-	fib6_nh_release_dsts(fib6_nh);
 	free_percpu(fib6_nh->rt6i_pcpu);
 
 	fib_nh_common_release(&fib6_nh->nh_common);
@@ -3742,6 +3742,8 @@ void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
 {
 	int cpu;
 
+	fib6_nh_flush_exceptions(fib6_nh, NULL);
+
 	if (!fib6_nh->rt6i_pcpu)
 		return;
 
-- 
2.53.0



