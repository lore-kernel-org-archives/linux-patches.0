Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053726;
	b=ejEl30VVxw1PdaGqQ08Iys0jzOeJkyARhssqBOOYgud447fXeh8XWx6bn2FJa6fRSysW
	 T8rX7mxFRd7E9qR7h8n29kx2xUfawIVWui/3ajyIaskRKgp0gTR3HoEzLltK5HfAdP86f
	 eE6qnpMkRZOOhFnE7Eb5joSlk8zi3AvCbNW3/R/RI641kZEGfrhmAgyrP9LviWQUIwGkA
	 rWDO+XqRV3CJqYG5V3DAq5nUtqUASz8n6hn5gr5fANUKMxOHi/gOd7d5/GwN4dVeNVJhu
	 LANspf8m/fbKSeG6idHZ1aYg/x/a0X9hT5zeV7pLrYPtb87qfUPuTUskgbNRf2NL1AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SVsTNQCdjNCR7qB+5EeAwd6pazBmUfuu45F7DRAS3YI=;
	b=eTo1PAX3LeYcBCfrfLeUp+a2HWfU1twDFqt5Ve79rA8EMCJjri+u1FOpQak7c2ZvIKjE
	 Er1Hhacjpayx2pZqJf96k1YNM43J8PHxt93mQwDAEcOe8ozz13AFAXFG0OJEDkbV4Jxxm
	 lSoEwESH+9VVxShkUNFGNPxJwEZBYwrBCC801fYP8VxjRVLoOjewcyAkBAQO8cG7cyXnh
	 SFhl6TT0hvQhl6eyHRa6v9kor2jYnfZgqY9id7lIqsecEsq4yDKK20rC4pJf7NRw5Pakt
	 njOnfuTAxIHdyQvis4lQNbUNwguYzT6cqQvNhMbadiO9nVkkLcDONkHhHsj8AyqiEog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u6kd/VAW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CD7606A31C;
	Thu, 19 Nov 2026 02:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6kd/VAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC96B1F000C4;
	Thu, 19 Nov 2026 02:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053726;
	bh=SVsTNQCdjNCR7qB+5EeAwd6pazBmUfuu45F7DRAS3YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6kd/VAWzrWMkGLRN6v07SsSO+tbqB9ei4qc5TpYM9inxW/8g9Y7VsrpzaiOuWnPA
	 93LL0mX4h9vZ9ihkKrGBqgVYUL5YwXH+UDvTLpZvux8fKzliQs9wNH9R6Dz4gZE9gW
	 hvOk9Cq8mBeNZJjxZ89Rmh1Squawtqg9MrGRfkIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1019/2214] ipmr, ip6mr: validate packets injected into the register vif on xmit
Date: Wed, 18 Nov 2026 15:44:55 +0100
Message-ID: <20261118150053.130921527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit aa1799e93f5ebb973252aec649d84d12d9c7fd1c ]

reg_vif_xmit() passes the packet to ipmr_cache_report() which copies its
IP header into the IGMPMSG_WHOLEPKT report that is queued to the mroute
socket. Nothing guarantees that the packet contains a full IP header, so
when a short packet is injected on the register device (e.g., using
AF_PACKET), the copy reads past the end of the packet and a recvmsg() on
the mroute socket leaks the uninitialized bytes to user space [1].

IPv6 has the same problem [2]. Its reg_vif_xmit() does call
pskb_inet_may_pull(), but the helper keys off skb->protocol and does not
pull anything when the protocol is neither IPv4 nor IPv6.

Fix by dropping packets whose protocol does not match the address family
of the register device or that do not contain a full network header.

[1]
BUG: KMSAN: kernel-infoleak in _copy_to_iter
 raw_recvmsg

Uninit was stored to memory at:
 ipmr_cache_report
 reg_vif_xmit
 packet_sendmsg

Uninit was created at:
 __alloc_skb
 sock_alloc_send_pskb
 packet_sendmsg

Bytes 1-3 of 21 are uninitialized

[2]
BUG: KMSAN: kernel-infoleak in _copy_to_iter
 rawv6_recvmsg

Uninit was stored to memory at:
 ip6mr_cache_report
 reg_vif_xmit
 packet_sendmsg

Uninit was created at:
 __alloc_skb
 sock_alloc_send_pskb
 packet_sendmsg

Bytes 8-23 of 41 are uninitialized

Fixes: 14fb64e1f449 ("[IPV6] MROUTE: Support PIM-SM (SSM).")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/0545f0c83f5ee2f6696210f87268e811ef655715.1792476357.git.zhilinz%40nebusec.ai
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261025071729.34967-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adjusted IPv4 patch context to preserve the existing locking layout around the route lookup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 6 ++++++
 net/ipv6/ip6mr.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index dc33f432e0f0c..10394192e2883 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -502,6 +502,12 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 	};
 	int err;
 
+	if (skb->protocol != htons(ETH_P_IP) || !pskb_inet_may_pull(skb)) {
+		DEV_STATS_INC(dev, tx_errors);
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	err = ipmr_fib_lookup(net, &fl4, &mrt);
 	if (err < 0) {
 		kfree_skb(skb);
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a793dcd24813e..1781287fb5aed 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -601,7 +601,7 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 		.flowi6_mark	= skb->mark,
 	};
 
-	if (!pskb_inet_may_pull(skb))
+	if (skb->protocol != htons(ETH_P_IPV6) || !pskb_inet_may_pull(skb))
 		goto tx_err;
 
 	if (ip6mr_fib_lookup(net, &fl6, &mrt) < 0)
-- 
2.53.0



