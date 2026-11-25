Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624800;
	b=113bzJ7opapLqw6b93rK7T3IBlUuwGZ1hsheKY6LyfEQsRnflqiyznYbexSEoug3urk/
	 WjlJ4h4LlWX+7umxr34fFcI38yXThYQFUho19M0MpKbQhT7fklQRa5B3LqoNdRrG36AEK
	 ib+PMww53lJ4S7QZfY46k+ZOceJYwZE0DgszFnjIudIvYvsKkXwRS9i38fyi+MLNIqhWy
	 W/d5PgCbl6ZWKdH1xtBZF4bkk+bka3xx1hdYnsrFHBqJ+OMnqi67WC6kO6Xj2Z2J/0LuT
	 7VeSr95Qjqf7EfP+tkRLDUbpY6OH3Zrdik3rnDDR/uM/y5Ro8m6VCbcZYnNXLcG2D/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xq0Sg8WbyguTK2uyjuedOet6u4HEXKdWUegCg14EhQg=;
	b=5nwT5oPzk3BtuW/bVnKY8Xw68pTIAiVpiJE/AgpKK30w/LRZKnYxNVn9t+BqEFYMEr7L
	 Mez2G2nL9plKzDtIugGffISs0SQqoGt4r1iIi/2bp/mdFSEfHZlBNkQOv4sKWqlifywD1
	 +UAWt9jTD2NZcEq4KlehkoKkxTSm0zUpCIwa+krb+16euu2avKvXIK7nAVvcM2gsdsSE8
	 OsnZDZnmwuFusWU1xNyONeTu1O17Ga/KGWjU7KAiIzK+ioDHO+JvKDlVKWBOrwsm2twpr
	 vhvj70dzNAdJZ1E03l2NH09yM13i5+Yc1s2ezSMl4iuJXzLOW4ypbXVzF/koPD6/MEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yw8c4U97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517E3606A32D;
	Wed, 25 Nov 2026 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yw8c4U97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB271F0093E;
	Wed, 25 Nov 2026 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624800;
	bh=xq0Sg8WbyguTK2uyjuedOet6u4HEXKdWUegCg14EhQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yw8c4U97a7N9gc0WTGppecmvoWubEukG/6pKW6UuVgem7HPsHPo0E0c9O8CEL18G7
	 AAHwn24GlcQZ/wxaMzqmqUOIJFhbSju2fR/qtgpnX2vQmJRXzsiAo0WWDUEZ6hA/gM
	 vqAwH/q1HC7vv0Xa87q3vnYfRv2UrWDCRgqfOICI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/816] ipv6: ignore link state in gateway check
Date: Wed, 25 Nov 2026 15:30:58 +0100
Message-ID: <20261125143856.376271711@linuxfoundation.org>
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
index ced56c191dd73..281975e0887fd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3449,9 +3449,9 @@ static int ip6_route_check_nh(struct net *net,
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



