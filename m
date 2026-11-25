Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618432;
	b=L8Vb2Q9+s+1VucVgMxqCNDfI0iKOrTznWFjAfsqslHp+IVt5lVdtOFvcxOZUfUZ58eVK
	 qneNr9G+OFHWd6w5GmG16jRrx26QZ82d8tr8ku08XfNI1QrNH8kY1zFPMmvhpMTyPpVHo
	 eygF9+a+4wS7EaYckf7YBXI6ioflPEXPBDWJD5rGZAYQvrl1zf0LQUs/47cZtUwdwB0ZL
	 m7tdpEA+DLAoHp8ez4rxCHMnTUVUnEEF1SCh7FxNtl/gHj2tLSf1aGrbRl2gq8Gkot1tk
	 b+Zd5XxNjsTtdjZtoxCHiLJIt6yC1wgCiM+HP6BUgLKZbYb4MnNVCdzg+BO1lGw9VPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QeAfNFyQrqh3efyNi9mEpRfo+xVZyHFCszqE/QBUFj0=;
	b=lWzndIw91Lqta/S9X1YQVa9URdjyICnetuAeAgBJpGXce0Q4WQIGieF0gs3yFxyqvccU
	 sIUZSFH5It4E+flAybWyGT9s9aZtGTAqQO25aK3/cKfupkPyUPTkRzMUu1K2qNpK3ovxJ
	 9bQ8mCnBMSqvr+P0txfofnRsYT5XnIHEMagYBJ8BfmnxEAvVNk4sHRsH7vwvMcPpELnmF
	 bK7JlsM0BZCXqxPdWOGQETdC1KBC9JmiyZH3I4WZkw+0KeJQFtK/aA8WNo/GzAgWREd1T
	 YRug1JMGcAVoH/1YZSfMDqeywgUO9swj+KMSLG7GCfXPOvh9iDE+gpbhffyMKDwtQLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/VdY4jX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5E1606A32E;
	Wed, 25 Nov 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/VdY4jX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33071F000C0;
	Wed, 25 Nov 2026 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618432;
	bh=QeAfNFyQrqh3efyNi9mEpRfo+xVZyHFCszqE/QBUFj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/VdY4jXvSk0etQGwCOOkkuLRI9PAotyZs+CKXxRAkgKLFU6CKsZhltL7f1/t/v4E
	 nZF0KE/LkKTA2wDznJleBr2khTtlhvGLOO77hlfafsiV/2niJbz63MHYmRw2WY2XL2
	 P1l5klPck7T/Zj4ijXmg8TSdRKbO7jvQhwKIFS2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0279/1005] ipv6: Flush rt->from in rt6_uncached_list_flush_dev().
Date: Wed, 25 Nov 2026 15:26:57 +0100
Message-ID: <20261125143828.276005118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit a0fe1a3f390a75152c7395fdf63fc39da77d7838 ]

When a device is unregistered, rt6_uncached_list_flush_dev()
iterates over uncached routes and switches the dying dev
with blackhole_netdev.

However, rt->from could be cached via sk->sk_rx_dst and
hold the device reference.

Then, unregister_netdevice() gets stuck with the splat
below. [0]

Let's release rt->from in rt6_uncached_list_flush_dev().

Note that ip6_rt_copy_init() could set rt->from even if
in6_dev_get() returns NULL (e.g. mtu < IPV6_MIN_MTU is
set concurrently).

Also, rt->from->nh could be replaced with another device
than rt_dev and rt_idev->dev, and in such a case,
nexthop_flush_dev() sets fib6_destroying before
rt6_uncached_list_flush_dev().

[0]:
unregister_netdevice: waiting for dummy2 to become free. Usage count = 2
ref_tracker: netdev@000000006fb9da8c has 1/1 users at
     netdev_get_by_index+0x14c/0x170
     fib6_nh_init+0x1ae/0x1950
     ip6_route_info_create_nh+0x15d/0x780
     ip6_route_add+0x55/0x150
     inet6_rtm_newroute+0x15d/0x1360
     rtnetlink_rcv_msg+0x606/0x710
     netlink_rcv_skb+0x14f/0x2f0
     netlink_unicast+0x71b/0x940
     netlink_sendmsg+0x595/0x840
     __sock_sendmsg+0x119/0x150
     ____sys_sendmsg+0x3e9/0x5c0
     ___sys_sendmsg+0x157/0x1a0
     __x64_sys_sendmsg+0x119/0x170
     do_syscall_64+0x109/0x330
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Reported-by: Jason Zhang <jdz@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261101064418.2055158-3-kuniyu@google.com
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 94273e6476885..1ec9fd20b07d8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -179,12 +179,20 @@ void rt6_uncached_list_flush_dev(struct net_device *dev)
 		list_for_each_entry_safe(rt, safe, &ul->head, dst.rt_uncached) {
 			struct inet6_dev *rt_idev = rt->rt6i_idev;
 			struct net_device *rt_dev = rt->dst.dev;
+			struct fib6_info *from;
+			bool release_fib;
+
+			rcu_read_lock();
+			from = rcu_dereference(rt->from);
+			release_fib = from && from->fib6_destroying;
+			rcu_read_unlock();
 
 			if (rt_idev &&
 			    (dev ? rt_idev->dev == dev :
 			     READ_ONCE(rt_idev->dev->reg_state) == NETREG_UNREGISTERED)) {
 				rt->rt6i_idev = in6_dev_get(blackhole_netdev);
 				in6_dev_put(rt_idev);
+				release_fib = true;
 			}
 
 			if (dev ? rt_dev == dev :
@@ -193,6 +201,12 @@ void rt6_uncached_list_flush_dev(struct net_device *dev)
 				netdev_ref_replace(rt_dev, blackhole_netdev,
 						   &rt->dst.dev_tracker,
 						   GFP_ATOMIC);
+				release_fib = true;
+			}
+
+			if (release_fib) {
+				from = unrcu_pointer(xchg(&rt->from, NULL));
+				fib6_info_release(from);
 			}
 
 			if (rt->dst.dev == blackhole_netdev &&
-- 
2.53.0



