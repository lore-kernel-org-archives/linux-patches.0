Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CFE3B3BF2;
	Wed, 30 Sep 2026 19:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795593; cv=none; b=bk+f/G4GCDtLfuDVvkfaCGGxbt8WhayKmgYXesnp0UFUna5Api1bn4SAPVAnYDBJFXeFYYEVStDOkMzbYttnsNPnRFDGv31JZECXR2WGloV/681v3gf3rHkbL74X+xS/hOryybpe2uIj5f14n8fm5jSIkyGkKsiEQoYxCficVJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795593; c=relaxed/simple;
	bh=N0i0F8AkpE94tKv1SyrUkQlmv04CG2j0y1+8dWy25a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+EG87U+N9R0YfDUP3TRvPJhZLkuYJBNKdzJMmz34cTaguIjTLV73DTzbqSMT824IptKEAfLe84IHmhJT0x4JQkOMHFBvVuX3o3WsRcpoqRCVJe1vyxCn7YEtrrbijGun9GumG5BOQScsAU0bR6rUBWm/+OELYXwWJe+46s99sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STo7PCQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STo7PCQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5861F000FF;
	Wed, 30 Sep 2026 19:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795592;
	bh=LpgfoaWGKM1vD0GpdlSnJlAwaEU2aCPq08SF0zqClP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STo7PCQziMi97ZYKa5zUPuJQORfxW3wfMwDNDlriwygrCFVwrqIZzYxbi8O8VT6FM
	 Iw/XkKzokUxNjBFkVv6UnAccBXORxZCRI7wyX2OfihAZlixzJOCyHtj7XTqzMJZ29a
	 Xa1UZCYQMhTYuCPOWMfcuML0zS9D1+4yG8A1upKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0570/1193] ipv6: remove "proto" argument from udp_tunnel6_dst_lookup()
Date: Wed, 30 Sep 2026 17:20:54 +0200
Message-ID: <20260930152446.904503857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beniamino Galvani <b.galvani@gmail.com>

[ Upstream commit 7e937dcf96d0489b3cdd1cff9dfd049617d28492 ]

The function is now UDP-specific, the protocol is always IPPROTO_UDP.

This is similar to what already done for IPv4 in commit 78f3655adcb5
("ipv4: remove "proto" argument from udp_tunnel_dst_lookup()").

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: be83178bfc44 ("vxlan: initialize _md in vxlan_xmit_one()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c     | 5 ++---
 include/net/udp_tunnel.h  | 2 +-
 net/ipv6/ip6_udp_tunnel.c | 4 +---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index b181c03368153..eaaa7bf89accf 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -394,7 +394,7 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return -ESHUTDOWN;
 
 	dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock, &saddr, info,
-				     IPPROTO_UDP, use_cache);
+				     use_cache);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
@@ -524,8 +524,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 			return -ESHUTDOWN;
 
 		dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock,
-					     &saddr, info, IPPROTO_UDP,
-					     use_cache);
+					     &saddr, info, use_cache);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 6818a59a1ebcb..ae35dcae1eeee 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -174,7 +174,7 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 					 struct socket *sock,
 					 struct in6_addr *saddr,
 					 const struct ip_tunnel_info *info,
-					 u8 protocol, bool use_cache);
+					 bool use_cache);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
 				    __be16 flags, __be64 tunnel_id,
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 7aef559e60ec5..812fc284cf36e 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -120,7 +120,6 @@ EXPORT_SYMBOL_GPL(udp_tunnel6_xmit_skb);
  *      @sock: Socket which provides route info
  *      @saddr: Memory to store the src ip address
  *      @info: Tunnel information
- *      @protocol: IP protocol
  *      @use_cache: Flag to enable cache usage
  *      This function performs a route lookup on a UDP tunnel
  *
@@ -134,7 +133,6 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 					 struct socket *sock,
 					 struct in6_addr *saddr,
 					 const struct ip_tunnel_info *info,
-					 u8 protocol,
 					 bool use_cache)
 {
 	struct dst_entry *dst = NULL;
@@ -154,7 +152,7 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 #endif
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_mark = skb->mark;
-	fl6.flowi6_proto = protocol;
+	fl6.flowi6_proto = IPPROTO_UDP;
 	fl6.daddr = info->key.u.ipv6.dst;
 	fl6.saddr = info->key.u.ipv6.src;
 	prio = info->key.tos;
-- 
2.53.0



