Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209980;
	b=W6rn4By2dz8oED0oVVnGDwymZs5TixLbuIS/xVEjzpICsn8lPPY2PAshsTRG8XPeNgfo
	 mmLQEtBWTZXipl8AX1CdXYlFfbfPZb5u17YU/W4WMadL1pgtTDYzGcen8ViCe7SlZrYfP
	 r5BtAXoUlH/TTYKyv8w6o5LlO/6AZUg9qjVAgJiRHHaMHiNDQzxCXrWQEiiXxYFwSZE40
	 EhTha8kJZDKcmDB0uZtzg1P72ET6qAXgeqMk5PmCl172/gMOC1am2rsIi6Ck32Y1Z4v99
	 yZXe48V02QzNihpfU0ZsUje2brwRdZbdfmbuyaSqPEMpm0fgUJ+51vBsccAUk2dhi7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2MDjlIJEj0Dt0lmCE/ZmX34Mnh09vMvXQUdSIpxzwc=;
	b=ZTMYnM0rjm4YdtLPTLvVdC4W0KdpwDhT7Ti0zZKeHxAsDavYQGp/u/nd+1cERRdL1AkS
	 ixbF0+aWrPefj3O9gfZn9gA4ZKcjOLCJn0436HgN+YCNjBWH3WK5Cjk5qy2yplYNl9p3b
	 oW29OZNaxn/wwtoEeLGrlDQRebXEAhFwiQ7zaYzxExKtFLb4CIx5F1fm5vXPAUtOYQG5n
	 vmDutcHd73Dy+I54dstMWdNaUUgAKmO1No80H07t2zqiZWhRDxDN0qBMiMx5QEL5KBCvW
	 3kZqJTK5q+sdInlxBtUApuNbsmmRT5B3FBKgwYloaT04phNClVuoUr/dxpHf/2oRDSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgvH9UMu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D8C606A31A;
	Wed, 28 Oct 2026 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgvH9UMu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007CF1F01825;
	Wed, 28 Oct 2026 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209979;
	bh=W2MDjlIJEj0Dt0lmCE/ZmX34Mnh09vMvXQUdSIpxzwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgvH9UMu3om7pZXiKig5Mf1kpAg4KR73r+sdLcZhgMzxwNEHp3r1OmeFKJIMAuA14
	 TbVLCAPVqPpHV4c76cgpNewq18uAoSFNNJwphU9/VCBqIrLVYzDN4Bj1jQWytlVNXd
	 iKZ4KdtCsvKKVJMav5QqBe4/eqf/mBpb++MK+r0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/168] net: bcmgenet: unshare the skb before writing the control block
Date: Wed, 28 Oct 2026 17:59:29 +0100
Message-ID: <20261028165943.879502063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 89771ce4f8f67dcffae561b2ccac95c0f6e3aa01 ]

bcmgenet stores first_cb, last_cb and bytes_sent in the skb control
block and reads them back on completion to free the skb and credit BQL.
ether_setup() leaves IFF_TX_SKB_SHARING set, so the stack can resubmit
a shared skb that is still in the ring. The next transmit overwrites
last_cb, so the earlier slots complete without crediting their bytes
and BQL stalls the queue until the watchdog resets it.

Unshare the skb before writing the control block.

Reproduce with pktgen in clone_skb mode, which hands the driver the same
skb while earlier copies are still in the ring:

  modprobe pktgen
  pg=/proc/net/pktgen
  echo "add_device eth0" > $pg/kpktgend_0
  echo "dst_mac AA:BB:CC:DD:EE:FF" > $pg/eth0
  echo "dst 192.0.2.1" > $pg/eth0
  echo "clone_skb 8" > $pg/eth0
  echo "count 0" > $pg/eth0
  echo start > $pg/pgctrl &
  sleep 5
  echo stop > $pg/pgctrl
  wait
  cat /sys/class/net/eth0/queues/tx-0/byte_queue_limits/inflight

inflight stays nonzero on the now idle queue. clone_skb 0 leaves it at
zero.

Fixes: f48bed16a756 ("net: bcmgenet: Free skb after last Tx frag")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261009-nb-genet-shared-skb-net-v1-1-c6d0a841977d@tipi-net.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index affac9887f160..37f42e8787a0e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2104,6 +2104,16 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
+	/* We store Tx state in the control block, so the skb must not be
+	 * shared, but ether_setup() leaves IFF_TX_SKB_SHARING set.
+	 */
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb) {
+		BCMGENET_STATS64_INC((&ring->stats64), dropped);
+		ret = NETDEV_TX_OK;
+		goto out;
+	}
+
 	/* Retain how many bytes will be sent on the wire, without TSB inserted
 	 * by transmit checksum offload
 	 */
-- 
2.53.0



