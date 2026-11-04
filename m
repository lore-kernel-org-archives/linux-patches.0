Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831202;
	b=B/GD6GHsyoEyL75MyKE4n7G8pPygsnErT0hTV+bQYWCkNXa96gzfVdzyZHWUdWVHcxLf
	 pM6esQHHAUmIeAjDYmrIlqtW+O8SQNTDPEvB3cC+EJrjValRDKEDICaW9Ss5vXcUvgnno
	 SGOygDhbTiD8YZTaCh+Aiu5fdw5xpzMznte3rYZnlA/ntWjfJcHtoUrrh7gY/3iBqk42P
	 pstWk88jbJ2WPFpHvcidbvBGbOPvyOZvtG30fU2Ficc5eo6rbms1Edx35ONvJVWDwUauy
	 u7nVd9pXjGiRR9P5ba/Rxxv5dFZmEtvRNT2T8sBBzMrKuJBJGJGkKLMdMSIhtsdsxWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6UkrW0p+W0h/jF7HdVr9cPRSV3ik4Cl0MNOJeFcQ2M=;
	b=eeX/9KSMH+VHrITCGHTBt4SP3DKm0jubJb7e1w82wNp8vGRoDYfCQc5PXVmj1VNFlVAG
	 /oTd6hC7xZOqgzDO4FmZ8F9dH8DjEzB02EV+al144W+Dd40RWxFX289mgCwX7bcsmAOFD
	 v0mb7rDhEDccACg3ID48h054LYvRFaQ7XGAoManG7FPPDnhN0ojbtlDg6ByVwGInBzWlT
	 nUiesarc+xnSAa5C9aFxurb5DyoU94gn8f3ASdjXLkeOl+HmKluzYrTyNmHskAYYaDeOj
	 3tmA1oE6QK61v/xPxc4UbCpT+kqdmuAAhytiksBrM8wZ5aBFV4itOEH5r4cvIbQP/vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cN0LxwxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98969606A847;
	Wed,  4 Nov 2026 22:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cN0LxwxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A68B1F000C1;
	Wed,  4 Nov 2026 22:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831202;
	bh=H6UkrW0p+W0h/jF7HdVr9cPRSV3ik4Cl0MNOJeFcQ2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cN0LxwxN6xTunhfKf7vw9xGToIgeiczrqx5FFK4RohLkAQP/awR4NJYWGt6rb38Bx
	 N96UNWYyXC9Ot7l2hMxIvxRj3NEa53SebaF9VR97Q551+x06AMKLS86AJVpXbmOrlX
	 MbKElKELJLd1uLXFtBf6crL4ecEe+uYUuxWZ/CfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <aksecurity@gmail.com>,
	Noam Caspi <noam.caspi@mail.huji.ac.il>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0562/1005] ipv6: udp: Create exceptions before socket matching
Date: Wed,  4 Nov 2026 16:04:55 -0500
Message-ID: <20261104211059.630225349@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit ac76cab50e899a7346408b8d3c3a4192c2eefb9f ]

Currently, when ICMPv6 Packet Too Big and Redirect Message packets are
locally delivered and quote a UDP packet, an exception is only created
in the IPv6 exception cache if the kernel can match the UDP packet to an
existing socket.

This behavior allows off-path attackers to conduct a side-channel attack
on the exception cache in order to discover the ephemeral port used by a
connected UDP socket.

Commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()") and
commit a00df2caffed ("ipv6: make exception cache less predictible") tried
to mitigate such attacks by making it harder for attackers to discover
hash collisions in the exception cache and by randomizing the number of
exceptions a hash bucket can hold, respectively. Unfortunately, both of
the mitigations can be bypassed.

Instead, mitigate such attacks by always creating an exception, even
before trying to find a matching socket. Do that by calling
ip6_update_pmtu() and ip6_redirect(), the helpers used when the quoted
packet did not originate from a socket.

This means that guesses (right or wrong) from an off-path attacker will
always result in an exception being created or updated in the cache that
the attacker can observe.

Pass the ifindex of the ingress device and the default uid, in a similar
fashion to icmpv6_err(). Unlike IPv4, an oif of 0 would not match any
nexthop in ip6_redirect_nh_match() and no exception would be created in
response to a Redirect Message.

Note that this does not allow attackers to create exceptions that they
could not create before, as both helpers can already be reached with
little to no validation. For example, by sending an ICMPv6 error that
quotes an ICMPv6 Echo Reply or one that quotes a UDP source port that
matches a wildcard socket.

Also note that in the good case (matched socket) the above scheme comes
at the cost of an extra route lookup, as the no socket helpers perform
their own lookup before the one performed by ip6_sk_update_pmtu() /
ip6_sk_redirect(). When the two resolve to different nexthops, it also
results in two exceptions being created for the same destination IP. One
in the exception cache of the nexthop resolved by the no socket helpers
and another in the exception cache of the nexthop used by the socket.

Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
Cc: stable@vger.kernel.org
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Noam Caspi <noam.caspi@mail.huji.ac.il>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260828192344.2596928-4-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted the change to __udp6_lib_err() with its extra udptable argument, placing the new helper above it and adding its call before the socket lookup, since udpv6_err() is only a wrapper here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7ae825cb5413b..7468c1f0a4ff6 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -701,6 +701,17 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	return sk;
 }
 
+static void udpv6_err_update_exception(struct net *net, struct sk_buff *skb,
+				       u8 type, __be32 info)
+{
+	if (type == ICMPV6_PKT_TOOBIG)
+		ip6_update_pmtu(skb, net, info, skb->dev->ifindex, 0,
+				sock_net_uid(net, NULL));
+	else if (type == NDISC_REDIRECT)
+		ip6_redirect(skb, net, skb->dev->ifindex, 0,
+			     sock_net_uid(net, NULL));
+}
+
 int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		   u8 type, u8 code, int offset, __be32 info,
 		   struct udp_table *udptable)
@@ -716,6 +727,8 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	int err;
 	struct net *net = dev_net(skb->dev);
 
+	udpv6_err_update_exception(net, skb, type, info);
+
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
 
-- 
2.53.0



