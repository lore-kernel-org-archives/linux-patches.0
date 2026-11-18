Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033263;
	b=tuDa942MCtX3n52GgnQN+6R0fuoXy+9S54DvoRFR8J36s7GfoiR+BfuBbuVkr7Ony+/u
	 SYdN0k3gkVH8dPjNvo4GRWnR0i0hM1nVLLMNop6EABGb8aYrJGZtK0y9HbeZ2UDZ/y+Y4
	 kM3igA4EBc9ftMDXwJTm91K+Nr3nTVFaJ0h2syxf2uejJE3rTyIboOM4EbTixlbu+PP6f
	 s99ymgPaukdL8hLZzGkRCJys+iWeqfRpd/5HhWmd3VXFaoHsBmK22I88O5zHh8vntUCKy
	 awCn4BnsLLpBP267VZqekgkgL2ek6kJ/svYCTbN9YYijOaNWidMXNuW04bUe/jgn01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVEpV1ZNxIsEurisjYxOt64/+CL5nvGQAsDJe5tbMCw=;
	b=rrrbahMYml6vH4XwdegCP60HBzkDXPdlfpBuggyEUyLx4jbZ2aD9BnKF41bJ35RXyv1d
	 XKbtpoj6JpmgP0UvcvwsLHEy+RoFuUt5ATMLUJ7ZlMs/zPTgRSYouQBiAu8Svw66Nl1p7
	 qSMT9P47a+PJWiPtA26rRT9grPC8pWX8bmftEqYFlPKJ7opRSOOxlVQ1gQYvt2twplI2u
	 dlIbV6LKUsMacg+Sd5x8aLiUIe6eAQI/6aJo3QNUo+ocP8VlCHyOCa2y9tLZP9sTEA8Xw
	 rUtI63i9WM1+lk23N4nU+uwUOion8NyLfM7lzxyaNLjtqp0Pthgp6L5U8t7RJo3WUHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tiE6w566;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F63606A33B;
	Wed, 18 Nov 2026 20:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tiE6w566
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF7D1F000C5;
	Wed, 18 Nov 2026 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033262;
	bh=gVEpV1ZNxIsEurisjYxOt64/+CL5nvGQAsDJe5tbMCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiE6w566i5I3H7VSpNz2dUvKhHc3ysiaFW9cHjA90DOoEpGX3yo81/GN+G+c6Mhmz
	 QODJwiCVvUaeAc8Vx0zAcxNglFLrB09KGi4Gw2qcmMf9NlOOVbKWDvKxP9D+Isd9Ur
	 bAyS/CN3XhlAmBbWps4QkQjmRx5dz3DiRZ+1K/EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1707/1756] openvswitch: use eth_type_trans_careful() in internal_dev_recv()
Date: Wed, 18 Nov 2026 16:03:54 +0100
Message-ID: <20261118150117.588587955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit b55e5a0159c8f53edefcb7848d95eb93db37bce1 ]

OVS actions like pop_eth followed by pop_mpls(ETH_P_TEB) or pop_nsh
can expose an inner Ethernet header which is not in the linear part
of the skb. Output to an internal port then crashes in eth_type_trans():

  flow: in_port(0),eth(),eth_type(0x8847),mpls(lse=0x00010140)
  actions: pop_eth,pop_mpls(0x6558),0
  # AF_PACKET SOCK_RAW on dp0: eth / mpls / eth / 4096 bytes of payload

  kernel BUG at include/linux/skbuff.h:2839!
  RIP: 0010:eth_type_trans (include/linux/etherdevice.h:635 net/ethernet/eth.c:163)
  Call Trace:
   internal_dev_recv (net/openvswitch/vport-internal_dev.c:202) openvswitch
   do_execute_actions (net/openvswitch/actions.c:1296) openvswitch
   ovs_execute_actions (net/openvswitch/actions.c:1606) openvswitch
   ovs_dp_process_packet (net/openvswitch/datapath.c:310) openvswitch
   ovs_vport_receive (net/openvswitch/vport.c:448) openvswitch
   internal_dev_xmit (net/openvswitch/vport-internal_dev.c:42) openvswitch
   dev_hard_start_xmit (include/linux/netdevice.h:5455 include/linux/netdevice.h:5464 net/core/dev.c:4057 net/core/dev.c:4073)
   __dev_queue_xmit (net/core/dev.c:5066)
   packet_sendmsg (net/packet/af_packet.c:3157 net/packet/af_packet.c:3189)

Use eth_type_trans_careful(), and drop the packet if the Ethernet
header can not be pulled. This covers all OVS actions at the consumer,
instead of fixing each producer.

Fixes: b2d0f5d5dc53 ("openvswitch: enable NSH support")
Fixes: f66b53fdbb22 ("openvswitch: New MPLS actions for layer 2 tunnelling")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028122703.2093730-5-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-internal_dev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 7b05a423a9ab9..f01393351991e 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -186,6 +186,7 @@ static void internal_dev_destroy(struct vport *vport)
 static int internal_dev_recv(struct sk_buff *skb)
 {
 	struct net_device *netdev = skb->dev;
+	enum skb_drop_reason reason;
 
 	if (unlikely(!(netdev->flags & IFF_UP))) {
 		kfree_skb(skb);
@@ -198,7 +199,12 @@ static int internal_dev_recv(struct sk_buff *skb)
 	secpath_reset(skb);
 
 	skb->pkt_type = PACKET_HOST;
-	skb->protocol = eth_type_trans(skb, netdev);
+	reason = eth_type_trans_careful(skb, netdev);
+	if (unlikely(reason)) {
+		dev_core_stats_rx_dropped_inc(netdev);
+		kfree_skb_reason(skb, reason);
+		return NETDEV_TX_OK;
+	}
 	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
 	dev_sw_netstats_rx_add(netdev, skb->len);
 
-- 
2.53.0



