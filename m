Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050755;
	b=pfu+7yINy1Z3TZwPJVtVWxPArqAh05oVA1ZDZQBGYwAhmWC//wR+zddC7hOSBKOJo7bs
	 RYxQM4o1ceFng2IsG4dR7CfLMakoXmSq+52VPlwu/DWQta9I3KWD4asrVXSGmfIvwaBax
	 itf7SjRKguqmqJtwG8c/SaUo3eeUxuzz+KerR6rbody3hTvUAR2JJ+4rofSNy4id0IBZf
	 6T7Wp0B/aQlNVpa0Q3WYBAVS3V7DawMaRfcGW6FklVwqYnNrJAnZQl8HqMuH/Lblarokl
	 YtD5CCB0U9zQRbZ5+If9g1RjLZYWvtQ9LEzWlN+v3Rj8jt/Acl+P/JpI7D/326Pu0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gAQS1zVT2rugTME8RKxEeYyYYqWQmqhG3yhk4NN0cYE=;
	b=mzdvdUeBrMML4x3pkST4icuHnNaZHSbHRDvFW4eEgLCoLdyNKza9xTybkA3JS5Aa10j+
	 rZJC6AmVmsNsb79cuDk6AiYBd4UoppRJru4wWx/2KEXP2wkZmExRDul/h9OVubBxj6ZEq
	 l+DBslxEhO8hFIwgu75B6xsI1VYe8LG2Y23JJdMbJCeKqZkYWPYzFmHIV61UiodbpLnkm
	 7wjacNR6mpxbTnh3FuR4mMo8n3oWGbMrO9ujRN1H+ZAUpzxnlZg3HIfO8HMcASNdTzjup
	 R1lXgnX6TTKAtUfdfZSX+hDUS5qi5K0fkdX5PckKYqP/sZxy5D4MPchAaFigMP7337Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5Jx0EtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A8A606A31C;
	Thu, 19 Nov 2026 01:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5Jx0EtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B66A1F000C4;
	Thu, 19 Nov 2026 01:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050755;
	bh=gAQS1zVT2rugTME8RKxEeYyYYqWQmqhG3yhk4NN0cYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5Jx0EtAetOWY5r/IigCnRfbBgmnjhRv07b03LpuzLuqhOYthC6trt/iSQr5f1UWZ
	 CCgJowB2kkRG8/UE8He+JNEzlsphl+zSpjSIpiBScdqHiKf/MXnA7iu2h9k6LO0OOk
	 jZPqMfaB1ZPbPqegKWrQJ8nqVXW4j+CLtyDjr1z0=
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
Subject: [PATCH 6.1 2821/2857] loopback: use eth_type_trans_careful()
Date: Wed, 18 Nov 2026 16:04:15 +0100
Message-ID: <20261118150343.171132718@linuxfoundation.org>
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
index 8dc6a4df93c7f..8f871976f1da7 100644
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



