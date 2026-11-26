Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704421;
	b=VPpuDQN3W4rmUUVjYo7pSc+NTxu96W+cF7r7dQJoEQHqpRZ3HPjPnNTXrP9FWVlYbM+S
	 /nAX+sgz9PY1WDcsavFmGKyCT0V7GFzSrwJNt7lb81f8SAVFTpfXzXlakCj0Tffro5aFV
	 hh+sw4VPpoAZkpB8hmL5jfDNRvUwuDVvr9QLV7CRTD4ES3JKjYyLyZCownvvJEWpaZBO0
	 fGbIIkTn2Ou37T94H0AElVorUlmg8rjWhuwWbZWu3aInCxFWzy8py4yn7DSfJJHxhzFIx
	 keKwcWethIgwhQ7l4NvMpDPLvv4kAUbx3/zG70FpUqfVpZTAjfPM8L1/WTR+RHZp1yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQxmGOONiCEZILqVuDD17iKy6xlKSBigc3PS6+nEVZs=;
	b=frxFip/HfG1JmfS+8ivuE7KxQKg8bLWia2cJsaDliU1V4l5CZj9e8KIyi74wK3PomUOo
	 3WlvHTybGPG2cMLxD1dtXwyayza/0ZCw5bPHapy216Q8c+yTa2pvD3RzCvq7l3c8KRenP
	 xZRLXp385yZNYhMyzzV4fiEewN2Oewws+OunKKSxFcHD/4vS45He5A9n7CVJeQJaQMQEN
	 G2xS8usnocn5w66wyk/ByxRP3oX5nJ5qil0n8DWcpGbBXKsFWeTVc5ZGzr4wSjk0d4xu0
	 UHs+r+nECEk0isTIlOCW+yqMqDUpI1E9nl3SK4ae5ibWHjWRjjbYZ6CvR7kg6WFtxbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n36XGp4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05446606A323;
	Thu, 26 Nov 2026 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n36XGp4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C231F000C0;
	Thu, 26 Nov 2026 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704420;
	bh=vQxmGOONiCEZILqVuDD17iKy6xlKSBigc3PS6+nEVZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n36XGp4uW9pJokQEXWHNjB2SjwNfKh+4C4j+v3dcujF3amN3CujHBQduF5nIiTbTM
	 8eDjC8u6/z8Dlz6nL69u395DwayBeMJce9VZl4GWzFwaca5dmKs5LDsTKBRQ6PYHv1
	 48mJqNJ+RAINDbE/wvC2BA9ADNV+DGerszExCFCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/265] ipv6: ignore link state in gateway check
Date: Thu, 26 Nov 2026 15:37:29 +0100
Message-ID: <20261126143613.345428346@linuxfoundation.org>
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
index 44500bcc99a29..e550a3960c453 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3278,9 +3278,9 @@ static int ip6_route_check_nh(struct net *net,
 			      struct net_device **_dev,
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



