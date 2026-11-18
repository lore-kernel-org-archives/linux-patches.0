Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032010;
	b=Hsat1IBqZuF7gjKxSzghe0H0yW8Be79zsh4NicyCnNtxOVnPHJeaYR9dFTDicz5TGIBm
	 R7s38t/y5lh/aEPEKPSvtruMjHBrZR5Suoqp0SDIwNvHJAbneGA/+9J5z5JMqio9msFKM
	 Goo1MNfS/YuPe+qEw5mjxZ5084SKs5lYHjj4pM0T2DS35S2c6O4DmcjzGxKocofbIJ9/S
	 hoJsdd/kGFNHEM9GXDQmekazDLM1pzB0i2KAsotlFzSGOFL2M3IJJDEJXaT8ksT8ulZot
	 8LOmcDfDegK/cEuPR8ZmRdhVMr4I9aj/dz6+F44pK8Ppm2FuYPyDJcJmjkFj9XRwmnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WKuvAweNmgMSYn8qJKQhGxnJmku2lXrb+MFD5zyqW38=;
	b=A3ggyQbU/hHHnm2ZJNruli44t2O0u9bMNc4TJs1c8o+QDA6tTEDorxXQrVZ6cWQjiO8u
	 GPywuxZrXit7pbHyTTYxhVDtsfEa/IL3ixstHuj9FKNmK3Y1Rlp4XqGHkZLr9Ln4Yx7LO
	 TYz9NQXFBMo+OhudQ8Epx5J2YGD1sQbVPee+1DpFdSwYAuBhJcz9GN5VeJPCCf44S8IjB
	 I7sXApyMXPn4qM6UCaEkIk6kqsYG/7n9Ap+M3nH1DJRuSbn6zxSpLzUn8RnA1YPb5gAEc
	 Zmh8j2ysCVNZunvwl8HkdHAgzgsA64aTQLPCbDU7HH9zSz+EJAFVABJq5A8VQg560QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkGk7jHP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F32606A320;
	Wed, 18 Nov 2026 20:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkGk7jHP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE741F000C4;
	Wed, 18 Nov 2026 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032010;
	bh=WKuvAweNmgMSYn8qJKQhGxnJmku2lXrb+MFD5zyqW38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkGk7jHPbnOBu/zi/HJA3HilkGa/nt8MWEr8DMX5bp5e49VlvCUMs/2dfMZTrv1ZS
	 uFBK0lNnwL7oL2rhYnSsifHvoWxkxR2EeZfUMuKqUjg2HO8W2QmESM9BTXjo1IRIk0
	 RpMrAII21eMdbded/yW9VDvbeBRLLwuvoWTrdGkU=
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
Subject: [PATCH 6.12 1260/1756] veth: clear rx queue hint in veth_xmit
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150059.834627937@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22387f66bf90d..0fc14b73d24a2 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -375,6 +375,9 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 
+	/* tx queue index of this device, meaningless as rx queue of the peer */
+	skb_set_queue_mapping(skb, 0);
+
 	ret = veth_forward_skb(rcv, skb, rq, use_napi);
 	switch (ret) {
 	case NET_RX_SUCCESS: /* same as NETDEV_TX_OK */
@@ -395,6 +398,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
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



