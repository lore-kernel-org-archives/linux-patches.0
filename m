Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042874;
	b=mbe+epYxml1X1NhmNCc6pYYhEnEF0Ubw/tCP/6yHuLSWkUXQUEPUy+8+tlZHJ9nnY6bR
	 77Jb33S7d2H/SR2N8yhGvP87hHKbdQ8N+2gMX6HyW1xTQNpiiaJo7SMgDr5OoqFbEUIvx
	 OX38LBBGGJz9q6vcfEWthvzTbA2scUNG5Yx1RBdSBeqSzBzA2JmJQEI3cjNR5yJHHbx3y
	 Cwc0P/2iEjVDU39uajhPEtV1Hv48NUax1paLFe/UTQg4X27yEnf1IhJKkIv0VnXpYnnC6
	 fS+Iodo1Tw30SgXExBi3cbcgHn5Sww2lbET8JiVuJ7DVCxGPta/uGPurvx0K0DpsXow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C3X1MGB+FtbNOLPhxyo8k52OwvcqFhzP/yhGW1UVbuo=;
	b=QhQz3efUY65btwdTycWG7dtqFVMLXPE8NVI5QLG2B6Jc9BrJ1KfRbhz/CGiP1RrYq5c9
	 wWSN2hRr9Pw8e7foOyiRGfU7VdA/XiklDubs3/rY8Ma1nWP/OpW9nermrAp2pLjM2NmDp
	 rwOyvDXLoI9Klh0tk/pxTjTKiUmWw9pFrsYMltIWu/ZEBmbF03cMAgDL3DBkLpnPTxtd1
	 8B3lQ+z1UiUi+PGL/wHZRBgJXwzPChTjq3sDMMU8yzyR/VrgxnbrGMejH5x5KDm3afJeY
	 go/HZyCkfDdUCMPIBEaCaq6ocuKKJO6b7pmdlJLHZSkvg0rfDGtv7Hyb+EcJHAlDO/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyIHuPH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A90606A320;
	Wed, 18 Nov 2026 23:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyIHuPH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135881F000C4;
	Wed, 18 Nov 2026 23:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042874;
	bh=C3X1MGB+FtbNOLPhxyo8k52OwvcqFhzP/yhGW1UVbuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyIHuPH8j0b5IfGdAjAXVikJf0XS3TxNZ8Z8r+YZ9IvxXOA7dAK3TUkjg2aDwiEGF
	 GINhv8IQnzhVGws0BlnCTdmmkK1IyI3uMbIi0S3kNdQUyaqVq8GmrQYlr+GVWBJ0Ra
	 nOQGoUTUkkUmfQ6ZrdUhNEo71epb8sQ8ukXjyY2A=
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
Subject: [PATCH 6.6 3285/3318] openvswitch: use eth_type_trans_careful() in internal_dev_recv()
Date: Wed, 18 Nov 2026 16:05:07 +0100
Message-ID: <20261118150458.156861883@linuxfoundation.org>
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
index 74c88a6baa43a..e07c88b609126 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -193,6 +193,7 @@ static void internal_dev_destroy(struct vport *vport)
 static int internal_dev_recv(struct sk_buff *skb)
 {
 	struct net_device *netdev = skb->dev;
+	enum skb_drop_reason reason;
 
 	if (unlikely(!(netdev->flags & IFF_UP))) {
 		kfree_skb(skb);
@@ -205,7 +206,12 @@ static int internal_dev_recv(struct sk_buff *skb)
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



