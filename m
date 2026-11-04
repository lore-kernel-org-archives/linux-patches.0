Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830912;
	b=HW+MYmU0/7OqVJBD3zZSzs5vp8R95Kxjet914W2f3o9nBYC7IrRPBqXRsU69hVIac+UJ
	 taeke4Yd+AxkWDDXbyHhRMeGKUBu3yRlnQzTbideUQsk4Yh7X7wCbvlZSnuVEqoXHmQu6
	 KwswNoAdg6X+hy5mIRIzkkaAYJBjR0DoIBP4PAAt6GNEUVq9yAzZ9cPijjh3rbar8DuAE
	 ywM4Z1IjME0RjGQfvy3f5sF2jGm4Nu3mXrFJDZG1LObZmqQeNUSsFK0TvUWsDxQR7zd47
	 N9rAr+Kdmd0GCLjar7vbYoBFnhgZRwVf3GcjglDbcUCVo0qqHnTFjbrQCgR/rdra/mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cx85N+TYERrMInKK5PENOz2LaQJsyZayLhQxvIuZY+M=;
	b=AJjsVWoMygLVM8/2kmZOVNGiA8EBGpEMXSRbu3O98E8fPy5rSkiJ2AT0Iinr5DAYwjtB
	 zMQt5vh4UOG1r8sDUNPSEf1Hyydsxy0OzXBzdvo59zfU8apgqC15Sf4RCyNhQNdcQDJSz
	 O2ntchTZP8cEr6qyqMJWTDaIDnqdNQTWpFO++RmWu6c0F0GiNW/DwzjTY2phTgHWEkqp2
	 MAofR03VoCsOyUDC6YmQyIGAGeE9AU46HnNA+oEEpt8FA4stGHRAxb54ULQDWC8cbbQLe
	 PjuIeZbY/6Y9WHnRpueC8zTu6odrlTMbcD9M2qC4P0Fk4idAqPcFlT9BVZxRmayzsGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cc0ZJ7uY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4A7606A841;
	Wed,  4 Nov 2026 22:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cc0ZJ7uY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C43B1F000C1;
	Wed,  4 Nov 2026 22:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830911;
	bh=cx85N+TYERrMInKK5PENOz2LaQJsyZayLhQxvIuZY+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc0ZJ7uYtjIMisA/2ILNpdzzJU1rsFK/055YBgRmPSGWYvNGnvr4wAP5QnUFPwHrF
	 Z1tg1PhYqRpKEIBD7QhKofU6KQMCIAEa5gDw+qj3aCKWGpqC8CYd2/iQ2LGWyAcBlD
	 W1qwx1o5PnPobt1YMgwl+gZG8ETlTyh8xMCYo/ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0398/1005] gre: fix ERSPAN o_flags race/corruption in xmit and fill_info
Date: Wed,  4 Nov 2026 16:02:11 -0500
Message-ID: <20261104211055.218455552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9958e69b98930834a576e156f6458166d1db1c02 ]

For IPv4 ERSPAN:
In erspan_xmit(), the driver clears IP_TUNNEL_SEQ_BIT (for version 0)
and IP_TUNNEL_KEY_BIT directly in the shared tunnel->parms.o_flags
structure. Since transmit paths can run locklessly and concurrently,
this leads to a data race.

Furthermore, modifying tunnel->parms.o_flags permanently alters the
tunnel configuration. To work around this, erspan_fill_info() (which
reports config to userspace) was setting IP_TUNNEL_KEY_BIT back. If
erspan_fill_info (running under RTNL) and erspan_xmit (running locklessly)
race, erspan_xmit might see IP_TUNNEL_KEY_BIT set when it shouldn't,
leading to GRE header corruption (injecting a key field into the ERSPAN
GRE header).

Fix this by:
1) Passing flags as an argument to __gre_xmit().
2) Using local stack flags in ipgre_xmit(), gre_tap_xmit(), and erspan_xmit()
   to prevent TOCTOU data races with concurrent configuration updates,
   and passing them to __gre_xmit().
3) Removing the racy modification of t->parms.o_flags in erspan_fill_info().
4) Forcing IP_TUNNEL_KEY_BIT in the reported flags for ERSPAN locally
   in ipgre_fill_info().

For IPv6 ERSPAN:
ip6erspan_tunnel_xmit() was locklessly clearing IP_TUNNEL_KEY_BIT in
t->parms.o_flags even though it does not use these flags for building
the GRE header (it uses local flags). This permanently corrupts the
configuration and races with ip6gre_fill_info() which reads it.

Remove the redundant and racy modification.
This should remove false sharing in a fast path.

Add const qualifiers in ipgre_fill_info(), erspan_fill_info()
and ip6gre_fill_info() to clarify that these methods are not
supposed to write any live parameters.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260812142257.21283-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c  | 42 +++++++++++++++++++++++-------------------
 net/ipv6/ip6_gre.c |  5 ++---
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b15cc4ee0d920..b1ec4f92d3462 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -474,12 +474,9 @@ static int gre_rcv(struct sk_buff *skb)
 
 static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 		       const struct iphdr *tnl_params,
-		       __be16 proto)
+		       __be16 proto, const unsigned long *flags)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	IP_TUNNEL_DECLARE_FLAGS(flags);
-
-	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
 
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
@@ -652,6 +649,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 			      struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	const struct iphdr *tnl_params;
 
 	if (!pskb_inet_may_pull(skb))
@@ -687,11 +685,12 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 		tnl_params = &tunnel->parms.iph;
 	}
 
-	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
-					      tunnel->parms.o_flags)))
+	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
+
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT, flags)))
 		goto free_skb;
 
-	__gre_xmit(skb, dev, tnl_params, skb->protocol);
+	__gre_xmit(skb, dev, tnl_params, skb->protocol, flags);
 	return NETDEV_TX_OK;
 
 free_skb:
@@ -704,6 +703,7 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 			       struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	bool truncate = false;
 	__be16 proto;
 
@@ -727,10 +727,12 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
+	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
+
 	/* Push ERSPAN header */
 	if (tunnel->erspan_ver == 0) {
 		proto = htons(ETH_P_ERSPAN);
-		__clear_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.o_flags);
+		__clear_bit(IP_TUNNEL_SEQ_BIT, flags);
 	} else if (tunnel->erspan_ver == 1) {
 		erspan_build_header(skb, ntohl(tunnel->parms.o_key),
 				    tunnel->index,
@@ -745,8 +747,8 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 		goto free_skb;
 	}
 
-	__clear_bit(IP_TUNNEL_KEY_BIT, tunnel->parms.o_flags);
-	__gre_xmit(skb, dev, &tunnel->parms.iph, proto);
+	__clear_bit(IP_TUNNEL_KEY_BIT, flags);
+	__gre_xmit(skb, dev, &tunnel->parms.iph, proto, flags);
 	return NETDEV_TX_OK;
 
 free_skb:
@@ -759,6 +761,7 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 				struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 
 	if (!pskb_inet_may_pull(skb))
 		goto free_skb;
@@ -768,14 +771,15 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
-					      tunnel->parms.o_flags)))
+	ip_tunnel_flags_copy(flags, tunnel->parms.o_flags);
+
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT, flags)))
 		goto free_skb;
 
 	if (skb_cow_head(skb, dev->needed_headroom))
 		goto free_skb;
 
-	__gre_xmit(skb, dev, &tunnel->parms.iph, htons(ETH_P_TEB));
+	__gre_xmit(skb, dev, &tunnel->parms.iph, htons(ETH_P_TEB), flags);
 	return NETDEV_TX_OK;
 
 free_skb:
@@ -1571,12 +1575,15 @@ static size_t ipgre_get_size(const struct net_device *dev)
 
 static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_parm_kern *p = &t->parms;
+	const struct ip_tunnel *t = netdev_priv(dev);
+	const struct ip_tunnel_parm_kern *p = &t->parms;
 	IP_TUNNEL_DECLARE_FLAGS(o_flags);
 
 	ip_tunnel_flags_copy(o_flags, p->o_flags);
 
+	if (t->erspan_ver != 0 && !t->collect_md)
+		__set_bit(IP_TUNNEL_KEY_BIT, o_flags);
+
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1619,12 +1626,9 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ip_tunnel *t = netdev_priv(dev);
+	const struct ip_tunnel *t = netdev_priv(dev);
 
 	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			__set_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
-
 		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
 			goto nla_put_failure;
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index e3aedef13ceed..c14c76b78b984 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -966,7 +966,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	if (skb_cow_head(skb, dev->needed_headroom ?: t->hlen))
 		goto tx_err;
 
-	__clear_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
 	IPCB(skb)->flags = 0;
 
 	/* For collect_md mode, derive fl6 from the tunnel key,
@@ -2109,8 +2108,8 @@ static size_t ip6gre_get_size(const struct net_device *dev)
 
 static int ip6gre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ip6_tnl *t = netdev_priv(dev);
-	struct __ip6_tnl_parm *p = &t->parms;
+	const struct ip6_tnl *t = netdev_priv(dev);
+	const struct __ip6_tnl_parm *p = &t->parms;
 	IP_TUNNEL_DECLARE_FLAGS(o_flags);
 
 	ip_tunnel_flags_copy(o_flags, p->o_flags);
-- 
2.53.0



