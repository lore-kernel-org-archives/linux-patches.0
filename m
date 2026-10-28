Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214898;
	b=kImNr1GK4qSEN/rgtDrfUy/iuBMcsqzVNmASb5GYhV40YephWTT3flI6wdRX8hNM/P/W
	 NRASo5nmHoFaAbvP8rn4XFr3b5CX5/rttXtbVWyA7uSpvz0WNjMddGHyOz0nWrAFNZCob
	 /PTPLJ3zEFr+S9mJ+vVmQZZ0mVdZGXm2J5Pz82oK3oXKjMwIlL09AnYvKIPe0Q1MIXdih
	 Q4Sp61WnedGXXhgVJu6UCZm7XLdg/1z22p8Hf5vSndJE119bfVuN/DAy4oAKbOMeIvnkr
	 +j1X0O6DwyvZJwNMKtek0NBYlnaHuSr6VVgLMTohvwtiQkT4SHCuAwEsJc71YWSDxJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1VjD1TTXjjDQaBbo+q68Q0D3lqhqWxuCcVRxJT1q+/I=;
	b=qPLFxC43np66XtdoE7MyW26uiosigR7A4kuNF+vZASA2eNcuApw3nglBKV3U3dXe3KXr
	 uHzKXU2QbZyvVC673rHBDShUzjqzWiqgF7mBwknrpPG0c6v1yfchX7TSplgbS4V9uxGlC
	 VFf2EpSMxoOpavBNhx2ucH/pmzMyF6JGL6Vs6C+qKqaJlddp25sHO5ByrwRgbyvWKDrQx
	 1rg1dDWwDhSeS9/8Rd4yPB2v8OUdPDVgNUwKUlXZ8fsrRPz6desdw5oVJ1hYTW6a6yL4E
	 ZLPIomdssNNNd/XptG2KYS5+gtgvcxNqL0MNhWvfM1btZsRcPhkb8kn7iC9jGeSOVBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsMXUA1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073D0606A31C;
	Wed, 28 Oct 2026 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsMXUA1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A851F01825;
	Wed, 28 Oct 2026 19:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214897;
	bh=1VjD1TTXjjDQaBbo+q68Q0D3lqhqWxuCcVRxJT1q+/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsMXUA1Df4wWM35WtIGKZ2eu/Sbv2CBfy9BVq3Eu23hDbat/TTKQlrTvr3KyQhTFu
	 iVAAKuVdNZVBikMxzKTswsTQz9Yb6gki/Iwd0+VqaJh2jbl60tX8wSqUFyBYKtZsLi
	 fHqmuV6dlMTQ7K2MNJpz2hr/dFPtAYyWtw5YVbJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	Eric Dumazet <edumazet@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1021/1887] bonding: fix type confusion in bond_setup_by_slave()
Date: Wed, 28 Oct 2026 17:51:57 +0100
Message-ID: <20261028170522.651120661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 950803f7254721c1c15858fbbfae3deaaeeecb11 ]

kernel BUG at net/core/skbuff.c:2306!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:pskb_expand_head+0xa08/0xfe0 net/core/skbuff.c:2306
RSP: 0018:ffffc90004aff760 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88807e3c8780 RCX: ffffffff89593e0e
RDX: ffff88807b7c4900 RSI: ffffffff89594747 RDI: ffff88807b7c4900
RBP: 0000000000000820 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000961a63e0 R11: 0000000000000000 R12: ffff88807e3c8780
R13: 00000000961a6560 R14: dffffc0000000000 R15: 00000000961a63e0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe1a0ed8df0 CR3: 000000002d816000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ipgre_header+0xdd/0x540 net/ipv4/ip_gre.c:900
 dev_hard_header include/linux/netdevice.h:3439 [inline]
 packet_snd net/packet/af_packet.c:3028 [inline]
 packet_sendmsg+0x3ae5/0x53c0 net/packet/af_packet.c:3108
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa54/0xc30 net/socket.c:2592
 ___sys_sendmsg+0x190/0x1e0 net/socket.c:2646
 __sys_sendmsg+0x170/0x220 net/socket.c:2678
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe1a0e6c1a9

When a non-Ethernet device (e.g. GRE tunnel) is enslaved to a bond,
bond_setup_by_slave() directly copies the slave's header_ops to the
bond device:

    bond_dev->header_ops = slave_dev->header_ops;

This causes a type confusion when dev_hard_header() is later called
on the bond device. Functions like ipgre_header(), ip6gre_header(),all use
netdev_priv(dev) to access their device-specific private data. When
called with the bond device, netdev_priv() returns the bond's private
data (struct bonding) instead of the expected type (e.g. struct
ip_tunnel), leading to garbage values being read and kernel crashes.

Fix this by introducing bond_header_ops with wrapper functions that
delegate to the active slave's header_ops using the slave's own
device. This ensures netdev_priv() in the slave's header functions
always receives the correct device.

The fix is placed in the bonding driver rather than individual device
drivers, as the root cause is bond blindly inheriting header_ops from
the slave without considering that these callbacks expect a specific
netdev_priv() layout.

The type confusion can be observed by adding a printk in
ipgre_header() and running the following commands:

    ip link add dummy0 type dummy
    ip addr add 10.0.0.1/24 dev dummy0
    ip link set dummy0 up
    ip link add gre1 type gre local 10.0.0.1
    ip link add bond1 type bond mode active-backup
    ip link set gre1 master bond1
    ip link set gre1 up
    ip link set bond1 up
    ip addr add fe80::1/64 dev bond1

Fixes: 1284cd3a2b74 ("bonding: two small fixes for IPoIB support")
Suggested-by: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260306021508.222062-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 47 ++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c94be63284841..0764bff68d97c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1543,6 +1543,50 @@ static void bond_compute_features(struct bonding *bond)
 	netdev_change_features(bond_dev);
 }
 
+static int bond_header_create(struct sk_buff *skb, struct net_device *bond_dev,
+			      unsigned short type, const void *daddr,
+			      const void *saddr, unsigned int len)
+{
+	struct bonding *bond = netdev_priv(bond_dev);
+	const struct header_ops *slave_ops;
+	struct slave *slave;
+	int ret = 0;
+
+	rcu_read_lock();
+	slave = rcu_dereference(bond->curr_active_slave);
+	if (slave) {
+		slave_ops = READ_ONCE(slave->dev->header_ops);
+		if (slave_ops && slave_ops->create)
+			ret = slave_ops->create(skb, slave->dev,
+						type, daddr, saddr, len);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static int bond_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+{
+	struct bonding *bond = netdev_priv(skb->dev);
+	const struct header_ops *slave_ops;
+	struct slave *slave;
+	int ret = 0;
+
+	rcu_read_lock();
+	slave = rcu_dereference(bond->curr_active_slave);
+	if (slave) {
+		slave_ops = READ_ONCE(slave->dev->header_ops);
+		if (slave_ops && slave_ops->parse)
+			ret = slave_ops->parse(skb, haddr);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static const struct header_ops bond_header_ops = {
+	.create	= bond_header_create,
+	.parse	= bond_header_parse,
+};
+
 static void bond_setup_by_slave(struct net_device *bond_dev,
 				struct net_device *slave_dev)
 {
@@ -1550,7 +1594,8 @@ static void bond_setup_by_slave(struct net_device *bond_dev,
 
 	dev_close(bond_dev);
 
-	bond_dev->header_ops	    = slave_dev->header_ops;
+	bond_dev->header_ops	    = slave_dev->header_ops ?
+				      &bond_header_ops : NULL;
 
 	bond_dev->type		    = slave_dev->type;
 	bond_dev->hard_header_len   = slave_dev->hard_header_len;
-- 
2.53.0



