Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619541;
	b=qQWYCTX2K+tOl5/ooxxwx3rDg39taCFSPYGBYdMuG90O4MRIrXcR3h1TIFZkrLju3COn
	 vctvGvdR1/+ekXAR6HeVHiUGPiH90oBkJuk2in84I+CeajtgvrW8Jutcwwm2hZg7ceI2y
	 WILLa6iFf1ucupyR04HvufSHtwObVgGuaOJwBevB89HyP0I7E5XGbcze/wa4p6sLulgV5
	 FeB/Y2ajbTlzM8Yo9HFzugCiicvJdZ0/8Pr977oF2vdmhneBLyx3MFpuT5QYpayzssRy9
	 9qSa0al0+/W5WIHj6ilKVIf8urDFSoJ1F7Kw5f/lusN0ZyTfOMqPlWFb/tcJH06TdFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vG2u4m5Sfgt2qNfQU99/p6j/q6KvjJLh8Wi9P1JQbqo=;
	b=1nH559PkjaAi6sjqD4FA/up9GoSqrMiehOEUZEQpQcWNdNQJVTCPkoZZHT3DGyWPEJQl
	 QBmsMN+SLdy/LsNuecuiY9Uip6IvSVo3a/8Bv0iwptP0goxZbq8Fmjdoj9drzvjLWGP2J
	 NjC1lZFq2gBhP7Q8swdulyOeiruOCgsAqUmWH5TqHg82uyppUW5lPjWmSOPxaLETvUxHg
	 34Vq09elY79HH/wjzVE+cv5ySjG3PrvxLxSgkkjyd1edasz7lfWBMoqT8k9unCDQRWqxa
	 0436o+YADQkfYrWwMbTlZc/CsnNAFCJG74cy4t6z2O1xKKP4p9FAr44ngzBLAbW1y+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnXsV69P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77096606A321;
	Wed, 25 Nov 2026 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnXsV69P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FAD1F000C4;
	Wed, 25 Nov 2026 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619541;
	bh=vG2u4m5Sfgt2qNfQU99/p6j/q6KvjJLh8Wi9P1JQbqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnXsV69P66EkggYNwLtBHMi3gKpP3okop3Tam8SGj+52GiOTVyobaoCdAtHHDaowP
	 37JqYOspT3CmUecXtWL0Wp4xcjtMU1ohzUdiGNyy/ocGliQdib8Q0PbKFSZGg6h4nF
	 mhE5A9rY64EGFlAQp5/E2jCMMwFQ8UottBaPHsjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0629/1005] net: mana: report RX checksum offload for IPv6
Date: Wed, 25 Nov 2026 15:32:47 +0100
Message-ID: <20261125143836.481303606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -2148,10 +2148,9 @@ static void mana_rx_skb(void *buf_va, bo
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
 		if (cqe->rx_hashtype & MANA_HASH_L4)


