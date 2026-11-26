Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705119;
	b=IunuB936BnV81fywH7x4kSE1xYNHWOqrpM9PlCyxpsXN8henF7M6KSgqu+wZlS3epMIf
	 LbNyiqOpMWp2kB66ItnUsLzPZO5/jhokdqaayp3+Vpl8GjH5vg1nWZ2T0blxgvf3yd01g
	 nhRHE1Hf6UBulBwWQIey5wF2W29k9fslrhSofSg5QhIHM8uui5VuS92Dz6yZ5J/8KuJsk
	 hcFPuAhBLFYxh6Kk65pDAhcxpUfdbhSkAi3/hqiGHzHH0+ON+yfo9UmysMicWwyIbCXX2
	 zuBwb8bJDPQZ2EmfKj5BwkkGs0gbpy7eIRZzYtZd/P/tvAlJb9dhEapArubUB9pKwOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+l6vMw9FdOg8eN4pU1pQ3LYn5kueWcUrU07J5zi3Lz4=;
	b=eoRFs7ITGG5e0RvWOdI6ppEK+JlP9u4RCWF4UAd+D/raHtSHe7PVh91RYgqrMbrCsdCW
	 uvqGskfpuZNYSHgyTGlTp23GJy7jrxwuJgAqJYeJ/PdBKAheCURa0lXF9MB4UQ5sf1UNo
	 SCgGuDmktitG/QHZqxc0yJfLZd2htnpVDVjOQipMRb/R5Y+yCal2jb36JDQN2rKOoI+TJ
	 6K7kQmO5TuGq2VSBeYV6Sh4Jo1UEpIVMoUfl2jG/nogrSS7CkfF9GZDVuMdYKQfCfTRp/
	 3T1//GzAgU3S3lT6M10utL+mUUdL7S0wQv0Js2ZTd3ksujAPkDIHxpzI6ykydVl3/1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2c1anAaP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85594606A31C;
	Thu, 26 Nov 2026 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2c1anAaP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63841F000CA;
	Thu, 26 Nov 2026 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705119;
	bh=+l6vMw9FdOg8eN4pU1pQ3LYn5kueWcUrU07J5zi3Lz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2c1anAaPsa5iML6iOJx19jfaR17oSbpHT5Pke5flQay4CsaYKndYpf24pflnrYVcT
	 dy9Mxfn0W5LqJglILohuxWtWz6EPQ3Xb4I3wlEpjC5miDpdA4ksoGhDVWH1RfE82iZ
	 eqN5cQefxPHt07iXn9a4PVRz1vtbd6OWM42tXB2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/319] ipv6: Flush exception route while replacing nexthop.
Date: Thu, 26 Nov 2026 15:37:38 +0100
Message-ID: <20261126144008.775972795@linuxfoundation.org>
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
index 63f74b1f6d4ad..ef00ace1fed6f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3655,9 +3655,10 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 {
 	struct rt6_exception_bucket *bucket;
 
+	fib6_nh_release_dsts(fib6_nh);
+
 	rcu_read_lock();
 
-	fib6_nh_flush_exceptions(fib6_nh, NULL);
 	bucket = fib6_nh_get_excptn_bucket(fib6_nh, NULL);
 	if (bucket) {
 		rcu_assign_pointer(fib6_nh->rt6i_exception_bucket, NULL);
@@ -3666,7 +3667,6 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
 	rcu_read_unlock();
 
-	fib6_nh_release_dsts(fib6_nh);
 	free_percpu(fib6_nh->rt6i_pcpu);
 
 	fib_nh_common_release(&fib6_nh->nh_common);
@@ -3676,6 +3676,8 @@ void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
 {
 	int cpu;
 
+	fib6_nh_flush_exceptions(fib6_nh, NULL);
+
 	if (!fib6_nh->rt6i_pcpu)
 		return;
 
-- 
2.53.0



