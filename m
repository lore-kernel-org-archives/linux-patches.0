Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705407;
	b=Mrfn38H9hF9Mhc9AayShWyTw50SMjEfhCuhHo4ZlONKRjn3o+KPjn/rgJMKgxheCutFq
	 HA90Wpoq3PyxCS1A99Z+jXEnUieEnYhGaeQgP3fjHCi6p1KCgucONYRc8huzgsVo1vFDw
	 AvkO0y6GiQukVwIOs2l2qKzXJLCqG9UcxSNFfCIS+y5Rpi3WlZJUYXOKU1s+APXXvCvBt
	 95cfO2Zyu/sTNXnzM8R2touKO2e7mVGhOAA62dkejnVEJdLJmP0HFJ1BL+bDHKar76eKW
	 dyhc19KZdE/BozzVS/PD1miZmyWztmVx2vOwZuxSDuulja1TNr8WbxtFdLFfb/RsoSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mv0bzshtzoegX8jkTUH6lDcWz3ozr7dAkMvWZKwzxdo=;
	b=iBgBOqLackjlzYWBu4FV4pZ8mnmIlp0cI4LOSwbQ1Bv1mXaB0KLx6oucscNBy6smQzkJ
	 ZAEqYciigTtwDe5C4LWLYT/hR+WhvuGNB+DXYnzhsF0ZfSqsn4FohnIEfsUNAPpwdzslq
	 VsARfHmC8IRgjpma400JsGAWKDXgWfbDdD91Qnz/Fwhxy3QONU0Aga81JBiG++CyJXvC9
	 P7xcsDV9iG6piggYM+LPK3dV+f42vs6itbnqlSLClILJmzFYTBuHpHlHgETai9PHwaWy2
	 /OEtWaF8MQd3WibVN43ryteWqPVFh3rg+HFLhWvggMGCO43CR4w53HRCx8yjDISl8Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyGRvD7z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FCE606A31C;
	Thu, 26 Nov 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyGRvD7z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E301A1F000C6;
	Thu, 26 Nov 2026 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705407;
	bh=mv0bzshtzoegX8jkTUH6lDcWz3ozr7dAkMvWZKwzxdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyGRvD7zVa/gBTMgeq+J4e8NR/ZWYSRd647UWNLQqpsBLFAqoGIaMmAJWJLErJB9e
	 TWYiUJ8g9TQKAonP1JMJol6vZf9I7GFBP0gfLYeDrrHAZgJd11zV4vwOhRWqeGskg4
	 blLvkOP/8NIN0pQpWVqI6cquUZ1TsblXp8tW6IEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 189/319] net: mana: report RX checksum offload for IPv6
Date: Thu, 26 Nov 2026 15:39:17 +0100
Message-ID: <20261126144011.012507059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -946,10 +946,9 @@ static void mana_rx_skb(void *buf_va, st
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


