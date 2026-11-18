Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042757;
	b=snN4QQttJXOGDqMLZ+RwrvrXYhex/Ok4aRDJrvHSwOj/2vbAl2HjdF4Zsy6Ai0qRjdPQ
	 wIehlV+Sys3mbavUvHKVW4RCXTjXoWesfNyjp5UkxvUBnPS0AOxuR71sH5DWjBV4uVTyX
	 U9mwWfKp74ySrynx5BFIDVdWs09TdhKJiHMfXvOOIBLvoGMYOjekgast2YNuyG+n/1RBZ
	 UoCAtt/u0hQIorw89oZuanrvOSz4YYldy53Efk1ewB4vVqjmZ4CzpAEK5KurFQc2ncCDy
	 qdWkpPPOzyVStZvS6MDOavRPgSf0pRfwpcuPpWVZizki/UnoJISYxGSQ4eFkf46UfAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oS4q0OcuiJHNm0/Avj8VHGVXuMQpr7iFOWyCUHFXspU=;
	b=kcjoj79eiU1tFlzg/XjalnCJ+GzvCizTUf3DiZ9rXqB4OLZwap0Zygll+7cihbQiZz3a
	 Sl2tnouzBzM0A4EdpZc0lFimkvs9oXjEcnHdKni3xxkUAbgun70WlKPZSmtfuTYsZRix7
	 WfO1gp+av5G4dnJnUf7d2gjQ3w1St69n5VqIASwsaKxtAX3nwPX/7B8+Y7w2FcjcZ4Bf4
	 hbTRcQeVSWjDh/71G7CS45WP3VXKOLTgAjKQx/tUCjgnRYMOxO3zyLaLRLIMuWTlHnaMG
	 oVb5N5GRLhEPHqXLkwLVNdgvVEcZheLfbpYgRsQiq0BytaqWPsllFaY3zuHAB2fEWEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COLSsa6U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47900606A320;
	Wed, 18 Nov 2026 22:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COLSsa6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20691F000C4;
	Wed, 18 Nov 2026 22:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042757;
	bh=oS4q0OcuiJHNm0/Avj8VHGVXuMQpr7iFOWyCUHFXspU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COLSsa6U7+HuWTXjTinaAUa6KbB0A3pa8XFDlc+gtKa2fiiPzBqVLtP7010NVLSrS
	 CgElW7+YPaTEkwGnXaO+VJr+TSu+ZdKGtKLT2w4i8SiR4PFd9Ez3YLKJNJBjTR4+UX
	 RlxoilHTs1KxfTJAUY2G4ZXzxOjKAYoi7RXr3Vdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3282/3318] loopback: use eth_type_trans_careful()
Date: Wed, 18 Nov 2026 16:05:04 +0100
Message-ID: <20261118150458.070246364@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 093a28998374f4007ffe67cc661f8192c1b062a9 ]

tc egress actions can leave an skb with fewer than ETH_HLEN bytes in
its linear part. loopback_xmit() then crashes in eth_type_trans():

  tc qdisc add dev lo clsact
  tc filter add dev lo egress matchall action vlan pop_eth
  # AF_PACKET SOCK_RAW: eth / eth / 8192 bytes of payload

  kernel BUG at include/linux/skbuff.h:2839!
  RIP: 0010:eth_type_trans (include/linux/etherdevice.h:635 net/ethernet/eth.c:163)
  Call Trace:
   loopback_xmit (drivers/net/loopback.c:87)
   dev_hard_start_xmit (include/linux/netdevice.h:5455 include/linux/netdevice.h:5464 net/core/dev.c:4057 net/core/dev.c:4073)
   __dev_queue_xmit (net/core/dev.c:5066)
   packet_sendmsg (net/packet/af_packet.c:3157 net/packet/af_packet.c:3189)

The same happens with "action ife decode" on lo egress.

Use eth_type_trans_careful(), and drop the packet if the Ethernet
header can not be pulled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Vega <vega@nebusec.ai>
Link: https://lore.kernel.org/netdev/20261005052249.1914367-2-weir@nebusec.ai/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028122703.2093730-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/loopback.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 6aa00f62b1f90..b11529a26619f 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -69,6 +69,7 @@ EXPORT_SYMBOL(blackhole_netdev);
 static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 				 struct net_device *dev)
 {
+	enum skb_drop_reason reason;
 	int len;
 
 	skb_tx_timestamp(skb);
@@ -83,7 +84,12 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 	 */
 	skb_dst_force(skb);
 
-	skb->protocol = eth_type_trans(skb, dev);
+	reason = eth_type_trans_careful(skb, dev);
+	if (unlikely(reason)) {
+		dev_core_stats_tx_dropped_inc(dev);
+		kfree_skb_reason(skb, reason);
+		return NETDEV_TX_OK;
+	}
 
 	len = skb->len;
 	if (likely(__netif_rx(skb) == NET_RX_SUCCESS))
-- 
2.53.0



