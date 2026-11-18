Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057984;
	b=PxLvpyQVTBMF560Mikd+2xon38jgHttpDmlsc31rYYIXijBsUj/Xn7+BgsAfcUL5xdlK
	 pzz9vyO9E2dhRjzOrnI+cl0M9iWpI4/EKS5Jzko7RSF3bv7Ltjr9QAxHHVTTLjj5zSjIE
	 dNjevxJSD3XNLODc+nrhd70TQOdzFIGsQ+eDxhvt0aEqutvPRyO2/ZE94HrLTLLrSbcn+
	 iqG0EKRqjVXjvMbU87uJUZGUiYeT6c9Hxrai0in458DfnZ5W3nMy8QXMTh/wQXsg2uEn2
	 vLKUkvdk/yOS+BfBhBc1B65ezI4ILXUEHWf6fwn0caIulQZME9gX8xr1efYzzwD5gxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4b9KTIVlncYXIPJ1Guk4j5aRwyYqO/F4Ld6cCBzizpI=;
	b=ya5v58sCOglXFTl8ttLqyniUQxTuT2U7L1x8NqGr8MK64zpnYbejEljVoBlZKQXkJJSn
	 gBXX5vEbpos4ecJc+NbAiYYD1Yz/J87MublG8IsTFM/xb3xrIMYiHUCgVMpKS8VUp/hHb
	 TNTr0YXeWFVvgtV4R43gbGvNBAEjMBrcOG3morZ7SB4n6YewJGbVIfKPZe/QqbiRd3BHL
	 n4kGCX4QxmafZDOwysJZAhY3HbuVXP5QnvtKwJnTNHn9xIsmcE+Nnx4BCjMPCZpMH1d3g
	 GCI24NWVx0X/CCibVlPpgU99go5xc321eda48KcY6USoHqIYPllQdOd+4UHqCsKpP4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KO/UA9+e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6814C606A325;
	Thu, 19 Nov 2026 03:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KO/UA9+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA971F000C4;
	Thu, 19 Nov 2026 03:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057983;
	bh=4b9KTIVlncYXIPJ1Guk4j5aRwyYqO/F4Ld6cCBzizpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KO/UA9+etyFZkCuYSt1S6xo3iSgX+jS8auRicy7NAse+wScTZqhu+ghhKEhYTsbnl
	 30Iqv16DrrpIH+rVCO1v/a3dXq5V9hTEZ4H3wh81nmGe9w+leUMcfILH+IfHVV4RGH
	 BJHBddoO1lzyAjSrMQkI9XsEqKp6n0k5tleayEuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	owen kwan <owen@verialabs.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0325/1848] net/sched: sch_teql: fix use-after-free on lower qdisc drop
Date: Wed, 18 Nov 2026 15:39:23 +0100
Message-ID: <20261118145925.732426020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: owen kwan <owen@verialabs.com>

[ Upstream commit 782d6bb8f9b8e9d8591181662222bf74cd3ecf79 ]

The issue: teql_master_xmit() tests the slave's ndo_start_xmit() return
value against NETDEV_TX_OK alone. A slave that consumes the skb but
returns an error code (rc < NET_XMIT_MASK, e.g. NET_XMIT_DROP) is treated
as if the skb were still owned, so the loop restores skb->dev and calls
__skb_pull() on it. A VLAN slave returns the result of dev_queue_xmit()
from its ndo_start_xmit() (propagated since cbbef5e18307), and when the
lower qdisc drops the packet that value is NET_XMIT_DROP after the skb
has been freed, giving a use-after-free in teql_master_xmit().

The Fix: test for consumption with dev_xmit_complete(), which accepts
NETDEV_TX_OK and every rc < NET_XMIT_MASK, matching other callers that
need to distinguish consumed results from busy. Only NETDEV_TX_OK keeps
the packet counted in tx_packets/tx_bytes and advances the slave; a
consumed result that is neither a success nor NET_XMIT_CN ends the
attempt and is charged to tx_dropped, so lower-qdisc drops are no longer
reported as good transmits. NET_XMIT_CN is counted like success because
it can accompany acceptance of the current packet: pfifo_head_drop drops
the old head, enqueues the current skb and returns NET_XMIT_CN.

Conditions to recreate the bug:
With CONFIG_NET_SCH_TEQL,
CONFIG_VLAN_8021Q and CONFIG_DUMMY enabled, add lkrdummy0 (dummy) and
lkrvlan0 (VLAN id 37 on lkrdummy0); set a pfifo limit 0 root on lkrdummy0
and a teql0 root on lkrvlan0; bring teql0 up with an address and send one
UDP packet to it. The VLAN xmit returns NET_XMIT_DROP from the lower
qdisc while holding a freed skb.

Fixes: 572a9d7b6fc7 ("net: allow to propagate errors through ->ndo_hard_start_xmit()")
Link: https://lore.kernel.org/netdev/179248763469.3135.1739559328868319628@kernel.org/
Link: https://lore.kernel.org/netdev/20261023162821.GN708417@horms.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: owen kwan <owen@verialabs.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-Y0BY.v2.r0.20261024060625-2@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: omitted rcu_read_unlock() to match the existing non-RCU transmit path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_teql.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 00ac4386627c7..9057d4f2ee5c6 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -311,19 +311,23 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 		case 0:
 			if (__netif_tx_trylock(slave_txq)) {
 				unsigned int length = qdisc_pkt_len(skb);
+				int rc = NETDEV_TX_BUSY;
 
 				skb->dev = slave;
-				if (!netif_xmit_frozen_or_stopped(slave_txq) &&
-				    netdev_start_xmit(skb, slave, slave_txq, false) ==
-				    NETDEV_TX_OK) {
-					__netif_tx_unlock(slave_txq);
+				if (!netif_xmit_frozen_or_stopped(slave_txq))
+					rc = netdev_start_xmit(skb, slave, slave_txq, false);
+				__netif_tx_unlock(slave_txq);
+				if (dev_xmit_complete(rc)) {
+					if (rc != NETDEV_TX_OK && rc != NET_XMIT_CN) {
+						master->tx_dropped++;
+						return NETDEV_TX_OK;
+					}
 					master->slaves = NEXT_SLAVE(q);
 					netif_wake_queue(dev);
 					master->tx_packets++;
 					master->tx_bytes += length;
 					return NETDEV_TX_OK;
 				}
-				__netif_tx_unlock(slave_txq);
 			}
 			if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)))
 				busy = 1;
-- 
2.53.0



