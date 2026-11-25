Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619081;
	b=peJC53wUJc+vmE48lU9gS5GKihcIcPVYZkJbrCuMNVu7T3SCPqtb4w3MHKLEcB/OZgrg
	 wIR4IYpuIDmPL+fvVkaVXZFbcDCYaDH2NBuUdH/iuyDbNt4HINEBCtYqzoN0abG0stTQu
	 i7CVxF5MAEzd/Azqy4I4Ds3NMLFmCzQMKedBi7aDEqJyRI0WZkfPF0QuM+qBUM100Gt2G
	 ympEWBzK2+0DEj4O2+lFtFsyr5ynpZwuz3sDePSlDtPvspkNwUxpLqO9hQlq4dhWyK0w5
	 TlwjgyTjy1FikqNNsPNT+UImgQSzYvUMZug15Ya/BLninztEy01zYu93Gw7xo8GN3Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0yi0DxxCw/RGzmOYMUhRSYPKdvh/8IJRWlHqMibaaw=;
	b=D4szlBS5pJqC0A3M4O6aWrOUXUBxKsPmFMoNRFFrg6Hjx4L3KDTW3zkuSIwYG7jsa1Pz
	 9Xl1urpCvOTh5OcsZuoz/mboUFyNkzzHaciMxNxqKPcduWTi9DBk86Ucj+H6mFO3AbKEn
	 Of3eznK/vPpbPG42pJDmRJu+wG7wzeNQz9d6u/HURFVI7iktjXpEv48sDgYZ42YpC/78K
	 SfZoNaClbmw1qw34ZrJwLc/Lww79nP5eTrnBa99WnZYjOg8IiZy4rSeMe1GfCFghZt6Cc
	 hOsKW/thT9ju4osalRsYX4AAV51C2/O8pnIyzUn2St0Ys8SG7yxrAde0E+GJ6OgXueQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P9aQ1r/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7DF606A31E;
	Wed, 25 Nov 2026 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P9aQ1r/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4DD1F000D1;
	Wed, 25 Nov 2026 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619081;
	bh=L0yi0DxxCw/RGzmOYMUhRSYPKdvh/8IJRWlHqMibaaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9aQ1r/y5q2oGXmtGCk8MIDzGR1wcgz/5rmQmu8eVMV8vWuZvIe8GOyaTta35aGqs
	 S4v/Z1gb1sDdxAIZKG89LHtz18Qgk9b1R2QqO4Ooqr8SEjgasIQCKMb+DcD78bOeVc
	 DEeacJxxrwYntBqDPIBvmG6W5e0PJvUl1j54EKPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0456/1005] ipv6: ignore link state in gateway check
Date: Wed, 25 Nov 2026 15:29:54 +0100
Message-ID: <20261125143832.429866544@linuxfoundation.org>
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

From: Yaroslav Dudkov <aroslavdudkov622@gmail.com>

[ Upstream commit b76bcf3fff9332076d92de47a80d12fd3d5268e2 ]

IPv6 route cannot be added in table when all
following conditions are true:
- gateway is not link-local address
- ignore_routes_with_linkdown=1 on device
- nexthop has no carrier
- gateway is not present or covered by any route in table already
Also multipath routes addition is invalidated by kernel even
if only one of added nexthops satisfies all above conditions.

Reproducer:

  ip netns add t
  ip -n t link add va type veth peer name vb
  ip -n t link set va up
  ip -n t addr add fd00::1/64 dev va nodad
  ip netns exec t sysctl -w \
    net.ipv6.conf.va.ignore_routes_with_linkdown=1
  ip -n t -6 route add 2001:db8::/64 via fd00::2 dev va
  # added
  ip -n t -6 route add 2001:db8::/64 table 100 via fd00::2 dev va
  # RTNETLINK answers: No route to host
  ip -n t -6 route show table all
  ip netns del t

Route should be added because:
- RT6_LOOKUP_F_IGNORE_LINKSTATE in commit d5d32e4b7668
("net: ipv6: Do not consider link state for nexthop validation")
was added for this
- the same route is valid in main table (when no specifying table id
while adding route)
- fib6_nh_init() initializes nexthops with no carrier
- IPv4 already does this (fib_check_nh_v4_gw() ignores link state
using the FIB_LOOKUP_IGNORE_LINKSTATE flag)

Before commit b2c709cce682 ("ipv6: Convert gateway validation to
use fib6_info") rt6_lookup() was used for checking if nexthop is
valid, rt6_lookup called rt6_device_match() which does not check the
link state. After change rt6_lookup() to fib6_lookup()
find_match() under fib6_lookup() started to invalidate linkdown
devices, because RT6_LOOKUP_F_IGNORE_LINKSTATE is not passed to it.

Adding RT6_LOOKUP_F_IGNORE_LINKSTATE to flags for ip6_route_check_nh()
solves the problem. RT6_LOOKUP_F_IGNORE_LINKSTATE is already used
inside the first search ip6_nh_lookup_table() and fixes the
bug in second search fib6_lookup(). Also RT6_LOOKUP_F_IGNORE_LINKSTATE
isn't read inside fib6_select_path().

Fixes: b2c709cce682 ("ipv6: Convert gateway validation to use fib6_info")
Signed-off-by: Yaroslav Dudkov <aroslavdudkov622@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261104195655.1406837-2-aroslavdudkov622@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1ec9fd20b07d8..cf6f09a42c9b7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3483,9 +3483,9 @@ static int ip6_route_check_nh(struct net *net,
 			      netdevice_tracker *dev_tracker,
 			      struct inet6_dev **idev)
 {
+	int flags = RT6_LOOKUP_F_IFACE | RT6_LOOKUP_F_IGNORE_LINKSTATE;
 	const struct in6_addr *gw_addr = &cfg->fc_gateway;
 	struct net_device *dev = _dev ? *_dev : NULL;
-	int flags = RT6_LOOKUP_F_IFACE;
 	struct fib6_result res = {};
 	int err = -EHOSTUNREACH;
 
-- 
2.53.0



