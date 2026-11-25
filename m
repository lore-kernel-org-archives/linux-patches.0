Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625640;
	b=DaueyFpgtb1kKchg1ucouRmToSy+EFqi10PhZGUneoUSOqkDJBm59+CT5EDaqA7oWukf
	 2tSmUxrjRSKU8SKbTImIxiDCU3W0FxzT7lJVXYxPozOcSlsRufPQFfuPRaN9+P5Vd8mky
	 z7T3/ny5gPhFIBwXaMj8nCV75JeE4ZcKdg9TVFLYRic7JlgktKL0xvhrswWJLrRu2cUQI
	 caLbWzyisyzeSyFysmyWPQdgY1V8KtjLimWCTpv4FGSLc5X5rorXmdRa6JXyAIjLTVp4k
	 v59la2ejTlZn3cjzM4tnYxq41OVfI40gJyB9Gxpki4tZpouCCCfmJ3kKUK7jUY8Ojcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GplOH9ZRusUC/wxCzBqgb+ze1wwCo2DVEOe58msz/SQ=;
	b=RYQqJR9wkqLnhr2N3ECVCBGYSHyP4ibewLZDusXCQcUZ6rtfPiR1TJcBa0lSHYIa1d33
	 i2oCaBNri8lgi0VIKYbw6CIWmjp0MctafOFE30vhvmiGl9yrZycaOIMZ1TUEb6X+xfMi8
	 aupagDya82qOPGcfZHQ5M7uCu671gjaNa57lcqprkMMJOk4N3XtSHATP1JiV1aYTXzjlx
	 SUgeIjHJ0Blc5JjOipO6/rKJg0RpXpsF5M8bIeLbvdX3FHS/nIVmf9KrQG86rNzmjotEz
	 x3Y01KUhabvTIAnUDM6jXUD2CvVMh6MFwU9eVv7Lhk4PTYJCT36vzy7ONV0IE8ZGOyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhm0+8D8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AD1606A31E;
	Wed, 25 Nov 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhm0+8D8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A651F000C4;
	Wed, 25 Nov 2026 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625640;
	bh=GplOH9ZRusUC/wxCzBqgb+ze1wwCo2DVEOe58msz/SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhm0+8D8qSU1h7N/q54mBnpRTfE9yJzwCjoVUdKdmblzobisgOjT5yJ4UH9HFJGzU
	 mfWVJJG1GLp2BIgxOZ0V9rEcUdEpUISKuwTnSJoV38AOMWtW8boxOyDVN+d6ayZkDC
	 3d/tdE983cbZnDyLX90hxEMEk7mO8RUCAXlTcC5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 583/816] net: mana: report RX checksum offload for IPv6
Date: Wed, 25 Nov 2026 15:35:31 +0100
Message-ID: <20261125143902.673697358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

commit bbcd02741c4cfbf9e1c59b1906f21ef772bd15eb upstream.

The hardware validates TCP and UDP checksums for both IPv4 and IPv6 and
reports the result in rx_tcp_csum_succeed and rx_udp_csum_succeed.
However, mana_rx_skb() also requires rx_iphdr_csum_succeed before it
sets CHECKSUM_UNNECESSARY. That bit is only set for IPv4 (since IPv6
has no header checksum), so IPv6 TCP and UDP traffic is always
checksummed again in software.

So, only look at the L4 result. For IPv4 this makes no material
difference since CHECKSUM_UNNECESSARY only covers the L4 checksum, and
ip_rcv_core() always verifies the IPv4 header checksum in software.

Between two Azure Standard_E16s_v6 VMs (VF enabled), IPv6 TCP and UDP
packets (including VXLAN over IPv6), now arrive with
CHECKSUM_UNNECESSARY instead of CHECKSUM_NONE, so GRO no longer
checksums them in software. Calls to __skb_gro_checksum_complete() on
the receiver during an 8 second iperf3 run:

                               before    after
  TCP/IPv4, 12.2 Gbps              23       28
  TCP/IPv6, 12.1 Gbps         8728419       25
  UDP/IPv6, 1.5 Gbps          1071380       20
  TCP/VXLAN/IPv6, 10.9 Gbps   7934373       18

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Link: https://patch.msgid.link/20261109142856.779955-1-hamzamahfooz@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1560,10 +1560,9 @@ static void mana_rx_skb(void *buf_va, bo
 	skb_checksum_none_assert(skb);
 	skb_record_rx_queue(skb, rxq_idx);
 
-	if ((ndev->features & NETIF_F_RXCSUM) && cqe->rx_iphdr_csum_succeed) {
-		if (cqe->rx_tcp_csum_succeed || cqe->rx_udp_csum_succeed)
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-	}
+	if ((ndev->features & NETIF_F_RXCSUM) &&
+	    (cqe->rx_tcp_csum_succeed || cqe->rx_udp_csum_succeed))
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	if (cqe->rx_hashtype != 0 && (ndev->features & NETIF_F_RXHASH)) {
 		hash_value = cqe->ppi[0].pkt_hash;


