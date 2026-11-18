Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038204;
	b=1DbMcagBH/zezqCkbZZcIZ33UWMOxXWy8a/QvALkxYwD8fSrkWuRJwYEGv7X/IoDOWFz
	 oSyecTGVPrvu4GdSY6U/0avNAKceOmnacjBf0CLsG4QefOD+xWnhwBECR1MtAgygjidwc
	 sD/LDK2tZPCcRnAhXC6iYrdIVp6rY1ijlwV7o6zpVtZtgyPrDiTQhgFx+ly75t9y0P45E
	 VV55DYxaDxVj297E4WlQzebpjqR+YKyaEiViKZL2PGqqYaUK9Gx+IsFmT2E8EwenHlrO0
	 4X6xzCWVzuP+d75PCsQKs98hZok1biCuKG0bfxlM+wfqvFi3awi/idHd4VNQeHBqW7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eF7x8q4iEqZm3cGp2zBQpA+HHLZMv8HaYCNnF3LipqA=;
	b=i3pX92U4ezMVJV6+dkFj881Av5RL3wJ+hNiTcZ4kSmigOFaBjyYSaiwEka9F6aOvcsrB
	 T2fRb6fksH2t/tcwRage22T6HxVrSlTZqpEr6pmdltMvvLsv0+SP1ZLdYihR/V4jpY9CH
	 zzBPfu4XDS6WKpy09DL7Yz73WwwzPoO8BfdwHkGhjF4lJili2T5klmUIUkDoz3Gm+kUTP
	 6IAsEu7lP8gxR14lhlo2eZBBNSiA0uGexsLW2yS3UcF4TZKNb4k6CSXa/M5c8TRY4xHbF
	 5L8XwpAmWViQAE6LUGtAZq6goxaPo+kuKo5Pfs7ezzQBJ9MBEnWVqjMWtx85x44lXtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cjUxT/gL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC97E606A320;
	Wed, 18 Nov 2026 21:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjUxT/gL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D9E1F000C5;
	Wed, 18 Nov 2026 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038204;
	bh=eF7x8q4iEqZm3cGp2zBQpA+HHLZMv8HaYCNnF3LipqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjUxT/gLfvGTQno6OxSLl9SQVn5Oi6AR/qPzlgP0PhBDTOCwFr0DOTB700L4zyAQZ
	 u05QQIMJ2NyVDlwTKmk5I//8evB9CpMEP2CkyO1wP4b4aJ34xEH+tL8kH3fK7FHD9Z
	 qhEwBkw1zHmNef3wtBdOuae3OVIHYaXp8CTG2KNA=
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
Subject: [PATCH 6.6 1663/3318] ipmr, ip6mr: validate packets injected into the register vif on xmit
Date: Wed, 18 Nov 2026 15:38:05 +0100
Message-ID: <20261118150411.669817956@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 6 ++++++
 net/ipv6/ip6mr.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index d831d89a9b0aa..dd4c570a0e04f 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -512,6 +512,12 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 	};
 	int err;
 
+	if (skb->protocol != htons(ETH_P_IP) || !pskb_inet_may_pull(skb)) {
+		DEV_STATS_INC(dev, tx_errors);
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	rcu_read_lock();
 	err = ipmr_fib_lookup(net, &fl4, &mrt);
 	if (err < 0) {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 38446928f1c45..f24ebb942c64e 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -616,7 +616,7 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 		.flowi6_mark	= skb->mark,
 	};
 
-	if (!pskb_inet_may_pull(skb))
+	if (skb->protocol != htons(ETH_P_IPV6) || !pskb_inet_may_pull(skb))
 		goto tx_err;
 
 	if (ip6mr_fib_lookup(net, &fl6, &mrt) < 0)
-- 
2.53.0



