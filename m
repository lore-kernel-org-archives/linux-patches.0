Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065548;
	b=mLQuD0haPEWxrsiVABoCj6a73flLYTgESfyheS4Zg+f1wPNk+ESTo1tQSnYG6hHzRTfb
	 0oHec8tKYPD9sVkFHLyZknXuDkeeTeyl8h3/cd/6NsxF5Eojn1X33y12aA1Im+JFvMzMe
	 y429w3+3uLsdvIiVfYeeLRdXkK2vV08zaPKrgpk7XrtaljT+4MFoF+idkr1fgjnzgfqLB
	 gJYf0mDRGRqeleh3cH1QLz1bqXD52q8qOaJbY8u9G5qQ0jJ3im2yULh8KTyjefQ5z37wb
	 u9gbg9kWQDzZdPNSRAx7zFnD1ZaBTubs/IvwJxbD1E57lQt8L/wMO8FfpvZbY1nICzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UjniJT0GqJnKQfYePgmTjY3JKE+/9vq5DwRjc40hinc=;
	b=VkCcBvpO3QE02U6hphd3ZCHtfBZrSGykobpN5pHaSo09hpsDc+AdyUoB2hCFuuePDNAf
	 VXTT6tGIDzBYDUAtEwKdNseoo5j/mORwsgFf2SqG1KOSdaHVziu7c+OqplDv5xrVviqz7
	 VxlZTI7Ghk6KAUc18OUZsv9Vj7sEZZs3HRnPsyERzZ7XiD5Obb76lJHJLybv1wqC0Lm/S
	 cg7KeXL7hMd7PmLXrRQ4kbO3xtP3UxBumjgfSpmhTxO4VdLGKjcjU8Oj5d5rMAoXw6QcI
	 3cbwG9td+b6jK1KKAfCRlyFjmLOsRB0ldQ+XoFgJ5OC1YP38+P4j5/upXlgLcxABeCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGjbacwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C8B606A330;
	Sat,  7 Nov 2026 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGjbacwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C411F0089F;
	Sat,  7 Nov 2026 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065547;
	bh=UjniJT0GqJnKQfYePgmTjY3JKE+/9vq5DwRjc40hinc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGjbacwYK+yZHM4aod6x5DGtKVahIwKuM49xiDpMMiPlSYZTaUUjSynJNDT2c2gxc
	 K7eXvdQZMjjLDraWm6o+pX5HwbCqNAwebnrHz1nEhZhIHPYlYCRGYrKBl9/qkllOZD
	 yvk+0G3CwsTXJlVsUoR6/rGgmHH30pVeL+iNjcoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Wang <echoowall@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1222/1257] Revert "net: advertise TCP MSS from the configured MTU, not the learned PMTU"
Date: Sat,  7 Nov 2026 08:58:38 -0500
Message-ID: <20261107135013.104122798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yongjian Wang <echoowall@gmail.com>

[ Upstream commit 564313447e545eea13038f74ada9272ab129b3cb ]

This reverts commit 2640e6419594 ("net: advertise TCP MSS from the
configured MTU, not the learned PMTU").

That commit stopped the learned PMTU from lowering the MSS we advertise
in SYN and SYN-ACK. For symmetric paths it argued that "the peer runs
its own PMTU discovery and usually already knows the real path MTU".
That only holds if ICMP "fragmentation needed" can reach the peer. When
the peer sits behind a firewall that drops inbound ICMP, its PMTU
discovery is a black hole (RFC 2923, section 2.1), and the smaller MSS
we advertised was the only thing keeping its full-size segments off the
narrow hop.

Inbound ICMP filtering is very common in enterprise and carrier
networks, and it is pervasive in mainland China. We hit this in
production after the commit was backported to 6.12.111: TCP connections
that reach a server through a relay with a smaller-MTU hop complete the
handshake, then stall as soon as the client sends full-size segments.
Clients on networks that let ICMP through, and connections that bypass
the relay, are unaffected, which made it hard to trace back to the
kernel.

Reproducer, network namespaces on a single host:

  cli --(1500)-- r1 --(1456)-- r2 --(1500)-- srv

r1 drops ICMP frag-needed towards cli. srv has already learned PMTU
1456 towards cli, then cli uploads 1 MB to srv:

  kernel                     SYN-ACK MSS   1 MB upload
  6.12.107                   1416          OK
  6.12.111                   1460          stalls, times out
  7.3-rc7                    1460          stalls, times out
  7.3-rc7 + this revert      1416          OK

The asymmetric case the commit was written for does not need a new
default: the advertised MSS can already be set per route with the
advmss metric, which takes precedence over default_advmss(). With this
revert applied, on an asymmetric path where srv learned PMTU 1456
towards cli while cli->srv is 1500 end to end:

  srv route to cli           SYN-ACK MSS   largest cli->srv segment
  default                    1416          1404
  advmss 1460                1460          1448

So DSR-style setups can opt in with "ip route ... advmss <mss>", while
hosts whose peers cannot complete PMTU discovery keep working by
default.

Fixes: 2640e6419594 ("net: advertise TCP MSS from the configured MTU, not the learned PMTU")
Closes: https://lore.kernel.org/regressions/4F0FAEB6-A13B-47F3-BFF1-C706686C6F64@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Yongjian Wang <echoowall@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261026-advmss-revert-v1-2-272fa4b7ecb6@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h        | 25 -------------------------
 include/net/ip6_route.h | 37 -------------------------------------
 net/ipv4/route.c        |  4 ++--
 net/ipv6/route.c        |  2 +-
 4 files changed, 3 insertions(+), 65 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d07c2c5730240..f0aeab1b1a3b3 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -513,31 +513,6 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	return res;
 }
 
-/* Configured/administrative MTU of a route, for advertising the TCP MSS.
- *
- * Unlike ip_dst_mtu_maybe_forward(), this deliberately ignores the
- * ICMP-learned path MTU (rt->rt_pmtu).  The advertised MSS bounds what the
- * peer may send to us and must reflect our receive capability (the device or
- * route-configured MTU), not a path MTU learned on the reverse (send)
- * direction, which may not apply to the peer->us path and outlives the fnhe
- * for the whole connection.  See RFC 2923 section 2.3 and the comment above
- * tcp_advertise_mss().
- */
-static inline unsigned int ip_dst_mtu_configured(const struct dst_entry *dst)
-{
-	unsigned int mtu, res;
-
-	rcu_read_lock();
-	mtu = dst_metric_raw(dst, RTAX_MTU);
-	if (!mtu)
-		mtu = READ_ONCE(dst_dev_rcu(dst)->mtu);
-	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
-	res = mtu - lwtunnel_headroom(dst->lwtstate, mtu);
-	rcu_read_unlock();
-
-	return res;
-}
-
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 					  const struct sk_buff *skb)
 {
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 0f9b7a260d253..5fd0c0e4beac0 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -389,43 +389,6 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-/* Configured/administrative MTU of a route, for advertising the TCP MSS.
- *
- * Unlike ip6_dst_mtu_maybe_forward(), this ignores any ICMPv6-learned path
- * MTU (which is kept on the RTF_CACHE exception route) and returns the MTU of
- * the underlying route (fib6_pmtu) or the egress device.  The advertised MSS
- * bounds what the peer may send to us and must reflect our receive
- * capability, not a path MTU learned on the reverse (send) direction.  See
- * RFC 2923 section 2.3 and the comment above tcp_advertise_mss().
- */
-static inline unsigned int ip6_dst_mtu_configured(const struct dst_entry *dst)
-{
-	const struct rt6_info *rt = dst_rt6_info(dst);
-	const struct fib6_info *from;
-	struct inet6_dev *idev;
-	unsigned int mtu = 0;
-
-	rcu_read_lock();
-	/* IPv6 keeps the learned PMTU and the configured MTU in the same
-	 * RTAX_MTU slot: the learned value sits on this (possibly RTF_CACHE)
-	 * dst, the configured one on the underlying route.  Reach the latter
-	 * via ->from (fib6_pmtu), populated by ip6_route_info_create().
-	 */
-	from = rcu_dereference(rt->from);
-	if (from)
-		mtu = from->fib6_pmtu;
-	if (!mtu) {
-		mtu = IPV6_MIN_MTU;
-		idev = __in6_dev_get(dst_dev_rcu(dst));
-		if (idev)
-			mtu = max_t(unsigned int, mtu, READ_ONCE(idev->cnf.mtu6));
-	}
-	rcu_read_unlock();
-
-	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
-}
-
 u32 ip6_mtu_from_fib6(const struct fib6_result *res,
 		      const struct in6_addr *daddr,
 		      const struct in6_addr *saddr);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 268d8821f7e09..1d8fcd19eaf65 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1365,8 +1365,8 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 
 	rcu_read_lock();
 	net = dst_dev_net_rcu(dst);
-	advmss = max_t(unsigned int, ip_dst_mtu_configured(dst) - header_size,
-		       net->ipv4.ip_rt_min_advmss);
+	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
+				   net->ipv4.ip_rt_min_advmss);
 	rcu_read_unlock();
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a5e955e56e794..bd6bc9ada5398 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3267,7 +3267,7 @@ void ip6_sk_redirect(struct sk_buff *skb, struct sock *sk)
 
 static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 {
-	unsigned int mtu = ip6_dst_mtu_configured(dst);
+	unsigned int mtu = dst6_mtu(dst);
 	struct net *net;
 
 	mtu -= sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
-- 
2.53.0



