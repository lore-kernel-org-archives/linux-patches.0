Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026838;
	b=oxv6r1qEqkzzDR2e4txtQTTiCFxndvJwVUqpeAyBSg9CVEB23+SLwnuRHYf1+RuUP1MN
	 yKGyZYz4wd44pqUCLa8JT8gfrNbYcTkt2BkBf98DFFiGa2yeP1lviauuNwjsD6TV5NYxc
	 wXDNDXlOVQUhw8Z+cQuThrpP0KQdy+4a2ZgQUmjtI1C3UJ0pqDVrvvx6xo7yyIsgYfo/s
	 ho0+jmhQfeUsjYvJ0hKckuMwsXBR5L+Ufr0QQ1hlMU5gR0CHw3Uq8LcMTOQkolAuxOyXc
	 BSv5fZelxGRpEwTuIqKLDpYHHlS69Y77UbuVRBK0/tt2HR7nkT3bvNZKWo/vwVb1Slw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RnsvGGtqYmnZRt3MJ0FCKYv09hNXOiiyM/T0CN4cjKw=;
	b=DItxUqBsY5QP+EzcOD9UyA3z6l6T8oQkHU5NA7U3OVAtZT7E1wo3cGy86+SyxiuNdXPn
	 jx6iknKAEuw0FSPjCpN0pbdzcNRHTHAbX9NGqcgvxuHLsVuRP5WwihEYUwL7kCfWTwkIa
	 8UH3OS6Mb6NKZRR++ZvyqTniSryPwAG8lJKR4fJm/gBVye6USl1J2MLDgJ8/Jhw7cFTjh
	 FIcapIOdCQF031JqWPwmBBV0yQMGQiPmUzJo4xJ/664gthW7RHgqNCPfhx8g1M8hew/qn
	 RJdd6dmSh7jkL3vLKh8ubfnPQHRRO1QldMmsd23cHGa5ipQS+kybJdH9Sq9sYvIoWgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onY7z0XD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262E606A320;
	Wed, 18 Nov 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onY7z0XD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E361A1F000C5;
	Wed, 18 Nov 2026 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026838;
	bh=RnsvGGtqYmnZRt3MJ0FCKYv09hNXOiiyM/T0CN4cjKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onY7z0XDZ9uxpCipwruvzVD/eu5sr7rQG3QoNGCGRHrAsec/aOjat+k/2+vlYvQ1t
	 wRNGvtKh+yWhSS1N0UxFPa0+JmfTmqjH9cZPw9v2vCERX/HDnHlgC9ihlEyTib5Mgp
	 ViCg4KkXeXfygVRu27VMK74J5l0noRlIJCc+ArK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Toshiaki Makita <toshiaki.makita1@gmail.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1577/2151] veth: clear rx queue hint in veth_xmit
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150219.328839479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 1b1c0e87cfe78d731bbab99c9c018655980b6790 ]

With more tx queues on one end of a veth pair than rx queues on the
other, and RPS or generic XDP enabled on the receiving end, we get:

    veth1 received packet on queue 2, but number of RX queues is 2
    WARNING: net/core/dev.c:5212 at get_rps_cpu+0x560/0x1360
    Call Trace:
     <TASK>
     netif_rx_internal+0x1af/0x4c0
     __netif_rx+0x99/0x350
     veth_xmit+0x713/0xca0
     dev_hard_start_xmit+0x166/0x5f0
     __dev_queue_xmit+0x1797/0x42d0
     ip_finish_output2+0xa34/0x1f40
     __ip_finish_output+0x510/0x7e0
     ip_finish_output+0x2f/0x320
     ip_output+0x17a/0x3f0
     ip_send_skb+0x1bc/0x220
     ......

Easy to hit with "ethtool -L veth0 tx 4", "ethtool -L veth1 rx 2",
rps_cpus set on veth1 and a few flows sent over the pair [1].

veth_xmit() uses skb->queue_mapping to pick the peer rq, but never
clears it before veth_forward_skb(), so the rx side still sees the tx
queue index. Everything on the rx side that goes through
skb_get_rx_queue(), like get_rps_cpu() and netif_get_rxqueue() for
generic XDP, takes it as a recorded rx queue and warns once it is out
of range.

Clear it before handing the skb to the peer:

- It is the tx queue index of this device, it says nothing about the
  rx queue of the peer.

- The two sides don't even agree on the encoding. The tx side stores
  the index as is, the rx side stores index + 1 so that 0 can mean
  "not recorded". So tx queue k is read back as rx queue k - 1, and
  tx queue 0 as "not recorded".

- Commit 710ad98c363a ("veth: Do not record rx queue hint in
  veth_xmit") already decided that veth should not pass any queue
  hint to the peer. There is no tx->rx queue mapping to preserve, so
  nothing is lost by clearing it.

On NETDEV_TX_BUSY the skb goes back to the qdisc, which looks up the
txq from skb->queue_mapping to decide when to retry, so restore it
there, next to the existing __skb_push().

[1]: https://lore.kernel.org/netdev/156834bb-8e40-496e-9443-9d515fa18eab@linux.dev/

Fixes: 76ff5cc91935 ("rtnl: allow to specify number of rx and tx queues on device creation")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261009040412.14571-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index c2b8b9d02e357..971b7999082e2 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -376,6 +376,9 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 
+	/* tx queue index of this device, meaningless as rx queue of the peer */
+	skb_set_queue_mapping(skb, 0);
+
 	ret = veth_forward_skb(rcv, skb, rq, use_napi);
 	switch (ret) {
 	case NET_RX_SUCCESS: /* same as NETDEV_TX_OK */
@@ -396,6 +399,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		/* Restore Eth hdr pulled by dev_forward_skb/eth_type_trans */
 		__skb_push(skb, ETH_HLEN);
+		/* qdisc requeues the skb on the txq it points to */
+		skb_set_queue_mapping(skb, rxq);
 		netif_tx_stop_queue(txq);
 		/* Makes sure NAPI peer consumer runs. Consumer is responsible
 		 * for starting txq again, until then ndo_start_xmit (this
-- 
2.53.0



