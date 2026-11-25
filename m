Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619747;
	b=ZV3wZx9NhTc8fSn9TiyvJM3qcyHBTVhDyavYW8SAW5Ux5QBeyhWjQM/FGM5eH1v2bdO6
	 +xxZra67e8yqIW6jBdZFxDO+5yJpUr1bRDFs3QJyDn9751gwgSED+WzP0mltchWX+AQV4
	 jsid5KnJp1DRH9jLrkr3+PfDpBaCI1PAfmDIslLtV6Z5udTrGpqooto9Jd5C8JVj2fRrp
	 4f4iCBE1z4ZiaxXgqmc891OWLQwDgnGy1/6ey0Kx9JFEvYt4oscnpXa/wnbnLT2thgutD
	 Ka933vzug9dgePSInozvRtT9YMnHqPnCsiIChOqj8v+Z6gd0EN6FpRHIyzSaMQAq+uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6D+wpoklqeQWjEO3FLZn8AJuaeGvQZzZeIHmudFqDRk=;
	b=g0vnqTlkQsw8bU8pMN3L2OVarCBv+mtMDGYO1EFm5hNoVmhRQgy/DCDlBqAhTNxWy7rO
	 pHOGo6LBY3vteOUhLoVSfzOeboeJidDH7fV1q1glKdgXBqBpHFNmhFA/8J2o7+t0vp/Fl
	 sLvw40hkJYS5/lhL8RQib5b4e4I+P4d8WS5Kk8SHgfBJrQU4LzS72yAWL6OcPBmK1wgoV
	 0aWE/2EGdaGv2Q35evK/PaTyQj5fPiJRMvaCnVprxD8qgdmX5Q7wCkRT70Pd1iHooo9O3
	 MUMa5R1ThP9UbBzRyeJrfr/FB879yjqQQbQXLYcjyzqKLvEDoFn5JW+p0H13dV37fzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+7TtwF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC5606A32D;
	Wed, 25 Nov 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+7TtwF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A3E1F000D2;
	Wed, 25 Nov 2026 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619746;
	bh=6D+wpoklqeQWjEO3FLZn8AJuaeGvQZzZeIHmudFqDRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+7TtwF3ROXTharo7cVHnxUTkPC4yEG3nq8hRjJ9L/RM0PMBufSUpZFtEE1rW60ED
	 Nhkwz83mf6NFM9Dycw0xNq+ESvVJ7BuCb6K7QpZ1sNaZhO+rKFNALiAylVDJx2BP4E
	 KloOLNPIngWNgiPzK6jajN++OlFwsT/78y6pfBg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Yingjie Wang <1075151112@qq.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0650/1005] ipv6: reject routes without an inet6_dev
Date: Wed, 25 Nov 2026 15:33:08 +0100
Message-ID: <20261125143836.976303223@linuxfoundation.org>
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
@@ -1165,6 +1165,12 @@ static void ip6_rt_init_dst(struct rt6_i
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
 
@@ -1200,10 +1206,10 @@ static void ip6_rt_copy_init(struct rt6_
 	const struct net_device *dev = nh->fib_nh_dev;
 	struct fib6_info *f6i = res->f6i;
 
+	rt->rt6i_idev = dev ? in6_dev_get(dev) : NULL;
 	ip6_rt_init_dst(rt, res);
 
 	rt->rt6i_dst = f6i->fib6_dst;
-	rt->rt6i_idev = dev ? in6_dev_get(dev) : NULL;
 	rt->rt6i_flags = res->fib6_flags;
 	if (nh->fib_nh_gw_family) {
 		rt->rt6i_gateway = nh->fib_nh_gw6;


