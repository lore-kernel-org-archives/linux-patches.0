Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022414;
	b=o11zhoKQyFwyRNjBtMJNtZKKqrHMU5fKw8L0MQW9BUpP46zF2sKUL36eKxsrsQ/46aJg
	 j3BYyKaAErRL3yiLLOiB0hBGMIr9P5X0cT9CPmMcL4RRnpen2Rt+7QpaSt1oOeCE5KWlo
	 sI5N4j0dd6iC0TsdqrlEVME3h0a1wsupdjHslFpDxsPFLFXP9iE92uKyJ9MYkQj7HCgX7
	 6r8Ux31mxYqYSXzhgKJw3EOKirfc9s7M+B/TjealC3LGCp6mRtWj01eAUfGzuNQWnI6Jq
	 /EMDd333R76q/q1xsqbxqIrcg+6zfw4ERiGF0xY7ztipm/W1qisBIjpWv7f1ysvFtHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gqzfwKFmGDEg/UwYdbrnk/gTg5mJsRDEqhsUgxgLZ3A=;
	b=Yty6vQVaNVfXXj2StSbjmvj+nFQn4vWrGIPZrGM9y2ZGLXu6AZH6iSihcr7k2LAThnMr
	 WcS719cuPBuxd6R0c/omcckWmCMn8QbQbMgaOvsTCRJFxiR09abXxJiKayTYEJnErTkY4
	 jub6chohlzjFOE9QROjX0f/XdNnmD6cum5VCGxbqI3D4bS85RDA35OXVX7jjtp0S9DeNL
	 9WV0kW0fsl9Y5oDy9pcrY4I1VQN3gelFsB7kFbv1NNED6uyUayADriNhvGFpreWTPd2ti
	 R1jaVC770eTvmr3C8N4Rw79DnraXvj1zQ9HvtUcmF7vUrliRwJhu0aExM0Kx2MAxlqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ej9O2xcG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2250F606A334;
	Wed, 18 Nov 2026 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ej9O2xcG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6E71F000C4;
	Wed, 18 Nov 2026 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022414;
	bh=gqzfwKFmGDEg/UwYdbrnk/gTg5mJsRDEqhsUgxgLZ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ej9O2xcGXZZlWQ+4R3nY4kMl2MQCHMFVTexToiqFTv3M4/nXQHHVmxYQ267/AJuWy
	 8YllFhg3QOB6OlnOkyDqranpYAmRk/4u2aQvehWVNdfWrmUVx/0Vk6Onte0E7F9yHz
	 tXCfDxb5BN8GFjAMKkk7X04XJPIOazs5DNxADdPQ=
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
Subject: [PATCH 7.3 2625/2651] loopback: use eth_type_trans_careful()
Date: Wed, 18 Nov 2026 16:04:25 +0100
Message-ID: <20261118150418.693185256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1fb6ce6843ade..6d16d6040401d 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(blackhole_netdev);
 static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 				 struct net_device *dev)
 {
+	enum skb_drop_reason reason;
 	int len;
 
 	skb_tx_timestamp(skb);
@@ -84,7 +85,12 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
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



