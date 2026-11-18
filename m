Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046777;
	b=dsVP/Jz6z9znF7NEiOwxvVv/W0a7HtkW7DkaNulLfzt1KDteB4prbIZeHXeauvR5z+h2
	 G4DVo8KIYgVHxwxuuI70xIYNTD+b7ZxsI0qtj6IcYD01wwqYcM12THHUhsDL3R4kfhkZx
	 RAES/CrgcRSv4rp3AESUde42hkek3c19AN2nLil3qNhw83Jl9kQvqHolF957q2ab/0g1N
	 1Ht1IviIC/PEjioAlRu5GASB/yRoKPZjWUW8uA7nLgLAqEj7sQNAsfyMQrx57+d3X3Li2
	 Mt1tPnq5z/ZCiOSo+S1/tkX4/l2WEXEtcdKwFIExl3uXek/BZqB4RC40SYPDYyJNcsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O4P2EaOMxvrw799DPzj3nk6Lmx1W1h1xoJ8rvaWwobM=;
	b=WeAWQ2F8Ws5kPmSYWbWOe59Ueajz40DpI9rzwnnOCNv6rWZ076d8GEepl9sdNh3tT/JE
	 oPDH9KztnR8b3ilq+elTLe8yDUiBxMNgWwoWDYk9Cbju2QX0nDjD8U6sTsv0vijpvAl06
	 OTaw/11nExaF1oIX6pOPO/gGgbPSDREw9ZAScNROwLJkLOt+G9nKVCjlVO/LhX4qxMRce
	 1LnpA5D4JcJ6QRjzu69gLocupOYDfuuUAryUsHYP/lRMY2KbaZzUwOc2ckv813hAZa45m
	 ce7K00++yGNpMNO2EVZ0ArH/wDNhrZ08tq4x2n21Jl3MmlFLbZZ8iGU5IRe/LQl+Qww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nN2/5ceQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1AC606A31C;
	Thu, 19 Nov 2026 00:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nN2/5ceQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3B41F000C4;
	Thu, 19 Nov 2026 00:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046777;
	bh=O4P2EaOMxvrw799DPzj3nk6Lmx1W1h1xoJ8rvaWwobM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nN2/5ceQ2d1ha5EHVwAZ4QkeoX2vxvEK8cpTMVeNIMDAIS8W7qHh+imgaCOmZ0X8Q
	 OqGH/DrJzCt4llf63ZzeqsokqmYB6ih0ZeaiAWMMaxL6w9CRH5VumgQLJUQvf/klKT
	 l7kVHMxkB9KKywGqvAu2LFlIs7gQJnQQuNOZciX8=
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
Subject: [PATCH 6.1 1402/2857] ipmr, ip6mr: validate packets injected into the register vif on xmit
Date: Wed, 18 Nov 2026 15:40:36 +0100
Message-ID: <20261118150251.826672669@linuxfoundation.org>
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
index d93e57c31b6aa..2f9c39b3cb5aa 100644
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
index b677f48179c87..362e670fe7f7e 100644
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



