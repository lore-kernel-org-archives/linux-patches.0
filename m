Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043929;
	b=QYzdIVj9etMPt+/eKcfkg2QBsZjLIBDgN1JjXP7aO9ZsJtJ9NyM3skdJPQJLHtYaM+ni
	 Erdp6xGVgueTpZp0pDwWZOQuw57Vw+Ovfb9EF18trk968buzOdrV4O8eU1MDRKZ6iS1nb
	 3SKxe2XzSp0yXw7LwpS6IeljOZGj0KZp0bHoGMC+18VR7zRx37YipKkawz4xGDsB1vHt9
	 JJ35vZ8wrtRnI91800f6Nvx8AOleqPd8ZJaG73I8ZQT4gfo+zTQAN0KNkYygw3DYQLSRK
	 +MKytN30mBFNyoNE5a7U35REnCmybKUM3/DsZMIn+f7gmFztMUTZ7vYWIpblvb7zynQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gJEeHqIXIqPfGXmjUMJU6ULRwZcPHz8h/o7FVd/YWBE=;
	b=reG58+07y8bjrlIwZGwm+ELTGakW10h23qzUy2O+E4Zo6hFXqjzkPjtwcJt8K6xYQoq8
	 ga7pxjQHX0LuWZcCq8SbjNencsr3xMUoh0iyty/hslYAkO4FPdXD14y9xFEoj3vuQMMSq
	 iu91R0bP+Q8LEqnVc3bay7D8ux3IsjxXbaVKLpcc8ENBcrLk2xKmCnjWlxlHyObolF58v
	 x1gSjWnI5HK8ehInaWBCkwVX45yG/iN5KxzavUbpbw2HmLhiS7iroCxgZ6Edy0cG6u7ft
	 zfDj1YZ+p90hL40ExjL0HqaqKOZN0XR2qlEYFn4w6EqsvGdJXVuNlUapyVIaGEkNSAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MC3BvmXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A677606A330;
	Wed, 18 Nov 2026 23:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MC3BvmXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F71F000C7;
	Wed, 18 Nov 2026 23:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043929;
	bh=gJEeHqIXIqPfGXmjUMJU6ULRwZcPHz8h/o7FVd/YWBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MC3BvmXrUKVfeOHrPsYZdbwH095IfTjRWBo1MGCuYrCX1pgfgiiFW/HVkJ/NlNPdN
	 dyL6C6EDNPV64zC+PCq/0DuCP2Tf0cI8qoyhSeVlfZeUt/vPHg+2a3touwjZwkCfY4
	 hEzMgI525EGxUVo/8M4zMVBaBDcPS5ubIpasRfHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0386/2857] ipv6: Fix redirect exception creation for UDP/RAW sockets
Date: Wed, 18 Nov 2026 15:23:40 +0100
Message-ID: <20261118150215.302080041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cd51b74bdd0b75aedf255dc67306a16dd057f7ee ]

When an ICMP Redirect Message is matched to a socket, both IPv4 and IPv6
verify that the source IP of the ICMP packet is the current gateway for
the quoted packet. Both also pass the socket's bound device as the
expected nexthop device.

The difference is that IPv4 treats "oif=0" as "any", whereas IPv6 always
requires an exact match (see ip6_redirect_nh_match()), since the gateway
address is usually a link-local address.

Therefore, when an IPv6 UDP/RAW socket is not bound to a device, the
above verification fails and an exception is not created. This also
happens when the socket is bound to a VRF, as l3mdev_update_flow()
resets the oif to 0.

Fix this by passing the ifindex of the ingress device as the expected
nexthop device. This is consistent with the existing callers of
ip6_redirect(). Note that for ICMPv6 Redirect Message packets the VRF
driver does not reset skb->dev to the VRF device, so skb->dev is
correct, even when it is a VRF port.

Fixes: b55b76b22144 ("ipv6:introduce function to find route for redirect")
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828192344.2596928-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Replaced sk_uid(sk) with the direct field access sk->sk_uid in the context line, since this tree has no sk_uid() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1c61081a857ce..1b5ab10d498dc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3223,7 +3223,7 @@ void ip6_redirect_no_header(struct sk_buff *skb, struct net *net, int oif)
 
 void ip6_sk_redirect(struct sk_buff *skb, struct sock *sk)
 {
-	ip6_redirect(skb, sock_net(sk), sk->sk_bound_dev_if,
+	ip6_redirect(skb, sock_net(sk), skb->dev->ifindex,
 		     READ_ONCE(sk->sk_mark), sk->sk_uid);
 }
 EXPORT_SYMBOL_GPL(ip6_sk_redirect);
-- 
2.53.0



