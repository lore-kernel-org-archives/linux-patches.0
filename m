Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034774;
	b=XjENyZACsvfzkw+tn82UrRWYLdu1l5KkZUPCldvNgsmt1gSdWY8bBwsJGUGMBRemzac+
	 SylyDfZKUu+azT/m2svBGu2AO3dMAVbC6stv7Eck2PNvQlBHLvvJK7GyxOE/EzXxJOsDO
	 hI7B8cTGCfQ/LM4VrvHoRpqJ6SMRl8aB9CCo+JxkMI4Ncw5qTo07Y2X1gztHNXPhIUEBB
	 jbbcjmSfOUDxi6d40u5+he5oO0wzZXpVjO09nD9uEzp7/QueNByPaOEy6YImWTxbLV0Pk
	 oFl0HBItVRMRmksbMRaQfLirEytZ88vEzIWMND+VGMpPDw/IYjZfdq5x1/uiqPP9q/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xihTJQyidNXVPkme9yj9zONLGrbA/vRXaoHUPJlf0Dc=;
	b=S6JtRYxYcg2i1P1+vuRgnWOj7GVu1jZq8GTZ2D/eHmOGHRoBGSt4BYQugb6rxZkDFZS4
	 MJT0Cck713jVfcPbNeVfIhYHKPNqZ0L2FEIABizi+T26OSxVuV4HLkMKlvUgJZ/7GfB04
	 ciULbjLy6ox7ZvzVSQOB/GexWGay8mzMi09GRANtwe3g3qENNTLg0bTbmgN/16o4hvnJD
	 b0UjFyeYpzP53TYt0aM7juQC5r97V5BQvf8/CIkBj8ZWf8wG7NvFQqsYnJ/ZYExkeznU7
	 y0t49AwI6f8iQ+h77cxj27mKAPpPsVBCdP2sUMWkKNUnVTF705+N6VTA/XTRgmkcTOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i16NVpYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96382606A31C;
	Wed, 18 Nov 2026 20:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i16NVpYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2F41F000C4;
	Wed, 18 Nov 2026 20:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034774;
	bh=xihTJQyidNXVPkme9yj9zONLGrbA/vRXaoHUPJlf0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i16NVpYMHwr93e4qMy0LEsXnMeui5AJVJFa5w4+6t9BiI1Ce0+Rj7xLgan2srwu6d
	 E9NAukElJXqtVFtSFPLqhiAdof9HVHor38man2a3so9eeUE/EmlIgqe8rnatgnqekY
	 U6z5478tEyEoYDCZdcblv7uBqHUXi8Ky04oETtNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0439/3318] ipv6: Fix redirect exception creation for UDP/RAW sockets
Date: Wed, 18 Nov 2026 15:17:41 +0100
Message-ID: <20261118150329.860454381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Context adjusted because sk_uid(sk) doesn't exist here, so the changed line is applied with the direct sk->sk_uid field access this tree uses. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index baa43c7f03005..aa8092413e944 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3231,7 +3231,7 @@ void ip6_redirect_no_header(struct sk_buff *skb, struct net *net, int oif)
 
 void ip6_sk_redirect(struct sk_buff *skb, struct sock *sk)
 {
-	ip6_redirect(skb, sock_net(sk), sk->sk_bound_dev_if,
+	ip6_redirect(skb, sock_net(sk), skb->dev->ifindex,
 		     READ_ONCE(sk->sk_mark), sk->sk_uid);
 }
 EXPORT_SYMBOL_GPL(ip6_sk_redirect);
-- 
2.53.0



