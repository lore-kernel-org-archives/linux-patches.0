Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704547;
	b=xMLiZsZvTo96tcoGA59hG7W4/RkZBLXCKfLGSp82W+9Jp06OIh6fd/AqpBGN9SMe7Q8C
	 g8NVgCHdP4VdfAL3yaTFeYtqH2uvMrxO/WoQMMeFZ1/K6woqU0cftQ8SO7gkcq4rCPwgJ
	 9EeC7h9YatslmZpQF8NdHua+KgoHYRd7qZ742r7VwycHNnHEAU5ZsQULhm7HZWXUylTkC
	 1NYWZTn3raLIiSeEiUZDTJybDZiElSaztzvOrZ9n4a/XEErHRuyMtbbVqlpRc7j5SCc/9
	 wSCC5HFBrs75Wp6j6eNMWOETi9D6m2iCc4mKKaNC9r4ktmRpVno+pjnx9f4Dk262SzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0VDEND6TTKxz8BozEnTsHZ8fB4BHiDo3bJdfqy2c+0=;
	b=PlXM4nEdP1CP5EgClWuBxJEJ4dYPM9iG+XJFe06D2jJjuIEs/IYtGwLuH36KqqS1KBoA
	 omN2PaZK4QriubBQ1QvqNe1PIvhSXDGHXxOc1mMejRD5xJW7YfMc7u4HIKwQtf5UnI6OO
	 F+YAOXJSGPCSP84QY9uC+AzGTbMpdWVAHEP/gYLWsiQlbTYvk5e79vRF4Ma2g6Ml/X8Ml
	 kgpefOcqaM1wMFKGj2KO443hxKCizZVdlDf4426+udp58oDEWF/j5TKONv2pBotN1mQA/
	 Trrv3zWl3xaGy33ns51NQFg4lZGd2KFvF4f3qCCcbUZBYWpr2HjI0O2Qi3ZRq9IqJ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nV8i/qum";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86538606A31C;
	Thu, 26 Nov 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nV8i/qum
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71971F000CF;
	Thu, 26 Nov 2026 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704547;
	bh=N0VDEND6TTKxz8BozEnTsHZ8fB4BHiDo3bJdfqy2c+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nV8i/qumOW3/y9PwA72Fbyt0u9ZUEaq/XgZH4MOpURnRkBh3/Dj+UJgytpw28Ixwf
	 /dw5ouldezzC0c6wIySS6iKXqaPlWTUj75zhPs94xatLi/MZyq8BuMNHhWIffhSx7I
	 7F8/ASfkpIw6v2oQtQQMQIe8OjUgumuBgMuF7k90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Yingjie Wang <1075151112@qq.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 162/265] ipv6: reject routes without an inet6_dev
Date: Thu, 26 Nov 2026 15:38:12 +0100
Message-ID: <20261126143616.466803700@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

commit 08a1eb7a634f665718ebe74e0960e242f597135e upstream.

ip6_route_output() and ip6_route_lookup() can return an error-free route
whose rt6i_idev is NULL.  Lowering an external nexthop device's MTU below
IPV6_MIN_MTU tears down its inet6_dev, while fib6_ifdown() leaves routes
using nexthop objects in the FIB.

An unprivileged user with CAP_NET_ADMIN in a private user and network
namespace can construct this state.  Consumers which treat a route without
an error as usable can then dereference the NULL rt6i_idev.  This was
reproduced as a KASAN NULL pointer dereference in ip6_tnl_xmit().

An audit of IPv6 route and tunnel users found this unchecked
ip6_dst_idev() dereference.

A similar missing inet6_dev check was fixed in commit 1b9b5323725e
("netfilter: ip6t_rpfilter: reject routes without inet6_dev").  However,
the route construction path still marks routes without an inet6_dev as
successful, leaving every consumer responsible for the same check.

Acquire the inet6_dev reference before initializing the destination.  If a
non-reject route has no inet6_dev, initialize it as RTN_UNREACHABLE instead
of a successful route.  Explicit reject routes keep their original type and
error.  This establishes that ordinary error-free IPv6 routes have an
inet6_dev while retaining the existing defensive checks at callers.

The modified route object builds cleanly with W=1.  A full x86_64 KASAN
bzImage build completes; it reports two pre-existing kernel-doc warnings
outside this change.

Tests:
  - `make W=1 net/ipv6/route.o`
  - full x86_64 KASAN `bzImage` build with `W=1`
  - KASAN QEMU with an unprivileged user and network namespace: after
    lowering the MTU, the stale route returned `No route to host`, a normal
    route still resolved, and the collect_md trigger completed without
    KASAN, oops, or panic
  - `tools/testing/selftests/net/ip6_tunnel.sh` in the same KASAN QEMU

Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
Closes: https://lore.kernel.org/netdev/DMP4WRIOGMBX.3VW2KNLBGDZ0K@gmail.com/
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/tencent_91DA7FD8277B509C55906702D1E425FBC906@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1089,6 +1089,12 @@ static void ip6_rt_init_dst(struct rt6_i
 		return;
 	}
 
+	/* addrconf_ifdown() removed inet6_dev. The device can't do IPv6. */
+	if (!rt->rt6i_idev) {
+		ip6_rt_init_dst_reject(rt, RTN_UNREACHABLE);
+		return;
+	}
+
 	rt->dst.error = 0;
 	rt->dst.output = ip6_output;
 
@@ -1123,10 +1129,10 @@ static void ip6_rt_copy_init(struct rt6_
 	const struct net_device *dev = nh->fib_nh_dev;
 	struct fib6_info *f6i = res->f6i;
 
+	rt->rt6i_idev = dev ? in6_dev_get(dev) : NULL;
 	ip6_rt_init_dst(rt, res);
 
 	rt->rt6i_dst = f6i->fib6_dst;
-	rt->rt6i_idev = dev ? in6_dev_get(dev) : NULL;
 	rt->rt6i_flags = res->fib6_flags;
 	if (nh->fib_nh_gw_family) {
 		rt->rt6i_gateway = nh->fib_nh_gw6;


