Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626327;
	b=kfiHzBGUOltIphrbDXyAL0HfGppAEQBcD9R7ndQsCRJPniqdy6kY58S3upVrxtAsoNt2
	 le0jQDqg4SEX0FJGHNAZytbOlZktk6qcOX71n0bz9mYL02eNck515K3/StNToyfEyrx+8
	 S7PaG0QXCCFFAXXRSyvLaLsViSBWBZHgXk3jCn0BPZlm/cZlQH+9+4AzL5ZyFKLUVYoS/
	 T1ww2OtoPo9FGMd7yJqWT+jMCZ8Sy7jGW18lfloYIEZ9OdcaZEAKj0REsicoiDJnQ+WGo
	 B5YEzEIA4ZAe04vZ/2LjAIvILDQfvdbC5IA24ti1XIBHHK+HBxmHSwlqw5uAL24YIKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v2eNqEcjXzw58yx2x1gyXfz8y/DDYK2WZpppQXxWlTY=;
	b=K94+PmiArxgJw9110mkGCE3G0/SMvRUBVfSb2ys0qy57D4XCsTVw8E7Nhx1GndXAQZWw
	 KcdbF5+BzW9a4uAkHGme+djiTZCmGQmCo07wdhrRYt0LmEDNL5fRNGpkBEoWKoq1kxOW0
	 m+tA8JlPfcL/ILHynYtDlmn4L9jwynSbQWcOL6p0O7N1e4tjZalQA/uEfVgpW6PMTwc6C
	 Y+DwQqskL8taqcxCDogxlDEbHTBERAt+4miGTZZ+wU8IQVOFoymIGIv16HJUu+Ox5YoIB
	 p8TOVrWuVvVcEv6uoBd5/dm2tqe32kLI9ZlJmGhfUzvitJ3HRfvgGG9BqUJ4rt1POxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYuLdQsS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80248606A323;
	Wed, 25 Nov 2026 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYuLdQsS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2481F000C6;
	Wed, 25 Nov 2026 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626327;
	bh=v2eNqEcjXzw58yx2x1gyXfz8y/DDYK2WZpppQXxWlTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYuLdQsS0N1ZIUcYLI5wtyAcFg+SgmEI2nCahZDKsB4c0dO3+lYBV/LvdoVwuxU28
	 XtZ1H7ZglCwIv1TRjUftENSD6FTMLxL+UxheQdnemG8hD9be3romVDwqXOTJ+VrNEb
	 YqzJC5LNPxntv1y1bds9yTzIQjQLSyCicVqHRNU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 800/816] fou: reserve headroom before pushing the encap header
Date: Wed, 25 Nov 2026 15:39:08 +0100
Message-ID: <20261125143907.690337310@linuxfoundation.org>
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

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

commit bcb42672751a8786dce871a35bde363b041cb2f7 upstream.

ip_tunnel_xmit() and ip_md_tunnel_xmit() push the encap header before
reserving headroom. A packet redirected into the tunnel (tc mirred, nft
fwd/dup) keeps the headroom of its original device, so fou_build_udp()
panics:

  kernel BUG at net/core/skbuff.c:214!
  Call Trace:
   skb_push+0xcc/0xf0
   fou_build_udp+0x2f/0x380
   gue_build_header+0xfa/0x150
   ip_tunnel_xmit+0x87f/0x21c0

With a mirred mirror, the push overwrites the original packet instead.
Reachable with CAP_NET_ADMIN in a user namespace.

Reserve the headroom in fou_build_header() and gue_build_header(); GUE
sizes and builds the header from one copy of the encap fields. The skb
head may move, so reload inner_iph after ip_tunnel_encap() and read
tnl_params, which points into the head for GRE with header_ops, before
the call. sit's ipip6_tunnel_xmit() holds no head pointer across it.

Fixes: 56328486539d ("net: Changes to ip_tunnel to support foo-over-udp encapsulation")
Fixes: ac931d4cdec3 ("ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices")
Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Closes: https://lore.kernel.org/netdev/20260801060115.3538849-1-nicoyip.dev@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261116113845.166280-1-theodorlarionov@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou_core.c  |   19 +++++++++++++++----
 net/ipv4/ip_tunnel.c |    6 ++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -1078,6 +1078,9 @@ static int fou_build_header(struct sk_bu
 	__be16 sport;
 	int err;
 
+	if (skb_cow_head(skb, fou_encap_hlen(e)))
+		return -ENOMEM;
+
 	err = __fou_build_header(skb, e, protocol, &sport, type);
 	if (err)
 		return err;
@@ -1090,16 +1093,24 @@ static int fou_build_header(struct sk_bu
 static int gue_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
 			    u8 *protocol, struct flowi4 *fl4)
 {
-	int type = e->flags & TUNNEL_ENCAP_FLAG_CSUM ? SKB_GSO_UDP_TUNNEL_CSUM :
-						       SKB_GSO_UDP_TUNNEL;
+	struct ip_tunnel_encap encap = {
+		.flags = READ_ONCE(e->flags),
+		.sport = READ_ONCE(e->sport),
+		.dport = READ_ONCE(e->dport),
+	};
+	int type = encap.flags & TUNNEL_ENCAP_FLAG_CSUM ?
+		   SKB_GSO_UDP_TUNNEL_CSUM : SKB_GSO_UDP_TUNNEL;
 	__be16 sport;
 	int err;
 
-	err = __gue_build_header(skb, e, protocol, &sport, type);
+	if (skb_cow_head(skb, gue_encap_hlen(&encap)))
+		return -ENOMEM;
+
+	err = __gue_build_header(skb, &encap, protocol, &sport, type);
 	if (err)
 		return err;
 
-	fou_build_udp(skb, e, fl4, protocol, sport);
+	fou_build_udp(skb, &encap, fl4, protocol, sport);
 
 	return 0;
 }
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -603,6 +603,7 @@ void ip_md_tunnel_xmit(struct sk_buff *s
 
 	if (ip_tunnel_encap(skb, &tun_info->encap, &proto, &fl4) < 0)
 		goto tx_error;
+	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
 	if (use_cache)
@@ -745,6 +746,8 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	tos = tnl_params->tos;
+	df = tnl_params->frag_off;
+	ttl = tnl_params->ttl;
 	if (tos & 0x1) {
 		tos &= ~0x1;
 		if (payload_protocol == htons(ETH_P_IP)) {
@@ -763,6 +766,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 
 	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
 		goto tx_error;
+	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 
 	if (connected && md) {
 		use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
@@ -795,7 +799,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 		goto tx_error;
 	}
 
-	df = tnl_params->frag_off;
 	if (payload_protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
 		df |= (inner_iph->frag_off & htons(IP_DF));
 
@@ -815,7 +818,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	tos = ip_tunnel_ecn_encap(tos, inner_iph, skb);
-	ttl = tnl_params->ttl;
 	if (ttl == 0) {
 		if (payload_protocol == htons(ETH_P_IP))
 			ttl = inner_iph->ttl;


