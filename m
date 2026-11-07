Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061471;
	b=MXytGZw1RUHP74zbGbdJcqpFDpJR8kjic5xX/4ebxD9T6NqDB81yJdPnFUCAVVGQqCCX
	 iBYVjE3uNDc+4kBVhsit7g20OoAdg2ZXdFOJ1U9/0L7ofBOtufmYp/o3WZWnugWMJ5C09
	 eT9a/jFUwwbDSAmYiqe2FGQ1dTS7/lab9O6tFxlvDSdELYS91XDrn0RAydFbXjcoAzB7z
	 oKgsBhk+BTTms4lLO3ReFlH7SYSSkL075xTUixDLmD/pPmYVGJVjOmBsuHwUQFqEoPtSU
	 poLcwLrYUWnv7JOQV4wtvvT2zkxkacyhEdjcgm7EdEF6LEZB3yedBsQRFbYjxG3dhqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sxyhmdfr7JDiBsoLRjaADvjK0/w85Fsk5BmxgKEeZ0Y=;
	b=M3XeHZ4aysM159V5TXjpSJ1YO6xlX+RfoaSIgmtAZKkplwoop7PB458C8F/sUCWy4q7M
	 jHnChFkCkBjNcicGNeFh/EemAeNj5wuX+NoaM9RbXI3iKpzwYu+Dp9s3YSw/qSVCq2A43
	 W8N1Sj9Ic65GkoKoPzdqY0Q3xKff9GM/1VLJGud8A2bgFDt5JAWMw/2vlR60vbtUS5+85
	 dll8+mQHN8JKEdvvlmMWohIQLLU/2rO3c/3/BGFkVlB3iK0+ZlwmkrQI21kkulzzwC6mz
	 nzL2Lte1Hwmw+jiBdsR1WmJaOsCSlT3u2J/IIyBUhRFD88TtJDJh19BoOjw0RY4AQ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZbzLSGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474EA606A326;
	Sat,  7 Nov 2026 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZbzLSGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EB11F0089F;
	Sat,  7 Nov 2026 14:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061471;
	bh=Sxyhmdfr7JDiBsoLRjaADvjK0/w85Fsk5BmxgKEeZ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZbzLSGgQM+49Kp0nBNjS9n9jpBh8UkcwWWsa+KpRE5writTHLYE1lOE6VOCUUKWw
	 6OtD9i0XURkxMdbjnEcVOwbb7OxXu0Sg6Th1Tn8Q7f4LTOtxZbH6xv2ZjstXYFwwqi
	 nUnDKXVvXbs3heHZIpBxGTb3CrVp4bMXPgJEOqno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	owen kwan <owen@verialabs.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 0571/1536] net/sched: sch_teql: fix use-after-free on lower qdisc drop
Date: Sat,  7 Nov 2026 08:43:07 -0500
Message-ID: <20261107135013.609690212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: owen kwan <owen@verialabs.com>

commit 782d6bb8f9b8e9d8591181662222bf74cd3ecf79 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_teql.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -347,12 +347,18 @@ restart:
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
+						rcu_read_unlock();
+						return NETDEV_TX_OK;
+					}
 					raw_spin_lock_irqsave(&master->slaves_lock, flags);
 					if (rcu_dereference_protected(master->slaves,
 								      lockdep_is_held(&master->slaves_lock)) == q)
@@ -366,7 +372,6 @@ restart:
 					rcu_read_unlock();
 					return NETDEV_TX_OK;
 				}
-				__netif_tx_unlock(slave_txq);
 			}
 			if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)))
 				busy = 1;


