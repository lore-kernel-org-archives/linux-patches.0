Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051960;
	b=Gouww5W2tVHcRmtKAHpqPc1zTjpJNc8muJ5mXn46ENrzG4MX/7pjcPl5Zqgnz+Ygi9Ix
	 v4zrd/ZskxVMf4dZwG1uuevdbi524ruJ6rJHK+0XIRxSEEa6c3bz1u04ml4fL11s2k/Qd
	 t0W9nBIpwU5c++WiiwUO/krM6OICWaEjGTjM/8KOBlLrO83Q4yzYGo8FhmFbton9T3ER8
	 MftlonWpsWZRMMwN0vHSBnlYdrVdJ5JZHikeR6PiWFA2MO0Gm0ycNPl24g1bzXZf6i4/o
	 C5NzsYRY5hCbA0yiHrufSSmWFxQT+Rarba3Dz4ALp1/3jmT/gKUaHNtSO7zgVmt/fdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+83/+/kULK5u8N7zS0GnRbwBCV/WKfY1q6aS8Sd8mE=;
	b=nVmRLnMVUSlDNuPRsN1v549Gb+OKKHT4xGuNTQCCG4g6zoVsx6ZJHL5FwvRJwHnGHsgs
	 GULkF6dI9DENK4SFHMNrJH/nG7NjZr9sntN+QUnXmKmLxLNKSFEvfek9mDMtACEOGlrM0
	 asQ62bHf6crioGhNlB1f2ddedioyv4s3BqHmY+l8qY6ty5hRgQa2rOjKEyTeIslcSKPtE
	 11u30Q4xKIwkDYvqHJ7RJPQAkxeCsVL7JbnRUUNG9Lt60EIkm332E4mT6XO5Zhji7Q1TU
	 C91zwHQ3+o9B6AbtBXp+KLGUDR8Ask95vdGCq/IHkUL8LI+JuCUUKh7HtRabv186Lkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Du8lT83X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC65606A330;
	Thu, 19 Nov 2026 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Du8lT83X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51B41F000C4;
	Thu, 19 Nov 2026 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051960;
	bh=L+83/+/kULK5u8N7zS0GnRbwBCV/WKfY1q6aS8Sd8mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Du8lT83Xa38oj1Ljr88w54LZwAWAZExmM8B5Qav13zwaW/DextXEo0Rmqb6Ge7IPO
	 ocbSwcRtYomfcXiQdw+BLErNSmUBNYBKFs6VGYCY0WRKb3LywQZEvy6JgQpl9fa5Rs
	 tMHdWM3RZTwntjLf7NJaWRSEnCjfubiZOvvq+cjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	owen kwan <owen@verialabs.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0393/2214] net/sched: sch_teql: fix use-after-free on lower qdisc drop
Date: Wed, 18 Nov 2026 15:34:29 +0100
Message-ID: <20261118150026.386609755@linuxfoundation.org>
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
[ sashal: Omitted rcu_read_unlock() because teql_master_xmit() has no corresponding RCU read lock. ]
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



