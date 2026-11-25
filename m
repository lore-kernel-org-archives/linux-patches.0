Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620672;
	b=Oe0XwGg6X7tp5Wz72Qdn3zGOrxx5JFbzLU1g1a0D801eDoGRuTn7upE3Fqd96XsW4Wj9
	 OGLfAKZUyFDM+cgWOiqUnnahRx9CXM4L3/dY4qJffP5m1xG6nwp3ISF9zGXwiSAJcf4c8
	 lcUZl/KjEgkK/39C+Yt2kboGAg4nKTuTk4TizrSVTTOJgbry4V3xA0YteH1VE0mMPOKzs
	 nefa1qtJs7zFKRM+hrk+hdSApMuvyW8lO2SE61/BvBrZQzKmi8h6nc/vI065PbrK7AKS5
	 1s8pQbVkjYAv9+1U0f0uVjXEYBt2lCkQ7aBnU6JGVVnyuxd9+mdhaOE7YGpJUHf4dnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2WMLKuSttjjcQh9j7LErLKp7HgZNhzEv1cjP9hcRzWk=;
	b=NhMD/zGnwm5n0FO0Pqq6g1/qTkXE1IU2oxWIaLOqedwSCKJIgB+GUjSruZywXSiGKUkl
	 m6tFvNRVCfSyPzEbF/v5D2pHlKF5W34/nZiQ1L/xyPiVHKp1DazreRWHPwM3ZDMPfC4g9
	 +Yo/m04NjWC2pODDsgbmsmCDDgFjGmbR7tAvf6dObmHiEO+kYDQM5nSV1z1W+EF9Ar7Z/
	 eyqkXWEjDRyLt/IPoKhWBMWInic/0moVN7gDF+0ESzjNXAZu6eMHmSeDcK6rs1P+VSM5y
	 Jq8Tgs6I3WalFw/d4tT7+5AU5aP0mJQZSK1l3vPK5ycmjXbk3ObimRNI30sK9AvAodw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBQOWys4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CC2606A33A;
	Wed, 25 Nov 2026 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBQOWys4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A631F000C4;
	Wed, 25 Nov 2026 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620671;
	bh=2WMLKuSttjjcQh9j7LErLKp7HgZNhzEv1cjP9hcRzWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBQOWys4Ju6gs4M1aX2mhdI08RbQ0eux6Fy5VsCqxeP0Eg5fV/5Vx1T1UlBumSl1l
	 i2BcupGK6ktyXfURChEnNilePQPLffH7gmvJoMS2vbbiz0HqDo7NMtCIZw0dejs2Ug
	 lp7IOU73tyyfIYlHU6GmB0Wn05MgcyF0FwDuwCS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0996/1005] fou: reserve headroom before pushing the encap header
Date: Wed, 25 Nov 2026 15:38:54 +0100
Message-ID: <20261125143844.983722858@linuxfoundation.org>
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
@@ -1071,6 +1071,9 @@ static int fou_build_header(struct sk_bu
 	__be16 sport;
 	int err;
 
+	if (skb_cow_head(skb, fou_encap_hlen(e)))
+		return -ENOMEM;
+
 	err = __fou_build_header(skb, e, protocol, &sport, type);
 	if (err)
 		return err;
@@ -1083,16 +1086,24 @@ static int fou_build_header(struct sk_bu
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
@@ -604,6 +604,7 @@ void ip_md_tunnel_xmit(struct sk_buff *s
 
 	if (ip_tunnel_encap(skb, &tun_info->encap, &proto, &fl4) < 0)
 		goto tx_error;
+	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
 	if (use_cache)
@@ -747,6 +748,8 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	tos = tnl_params->tos;
+	df = tnl_params->frag_off;
+	ttl = tnl_params->ttl;
 	if (tos & 0x1) {
 		tos &= ~0x1;
 		if (payload_protocol == htons(ETH_P_IP)) {
@@ -765,6 +768,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 
 	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
 		goto tx_error;
+	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 
 	if (connected && md) {
 		use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
@@ -797,7 +801,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 		goto tx_error;
 	}
 
-	df = tnl_params->frag_off;
 	if (payload_protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
 		df |= (inner_iph->frag_off & htons(IP_DF));
 
@@ -819,7 +822,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	tos = ip_tunnel_ecn_encap(tos, inner_iph, skb);
-	ttl = tnl_params->ttl;
 	if (ttl == 0) {
 		if (payload_protocol == htons(ETH_P_IP))
 			ttl = inner_iph->ttl;


