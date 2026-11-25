Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622942;
	b=fFPgUVkTkdMj4PnvQ2UWK9zhxwGtOVpsfO2VvvkqFdqO3WQ/jfHr3rJx/Z5QUQXttLF2
	 /wlbZDUy0T/5bXieRsvfCcBwtSZarh4fsvJY9giFJ11+dj13Jz9saHpktnAhYAJsaxq9f
	 qLEzmNrXcBhQr4ebyztIx4CCG/OuHtX4btsftAGyCwbESWJGawkAAAf4ri/F0RkJBXff3
	 u5e+y4v5nkG5n81Rmk0I4a+v2AJTbu3xji67M2VMF8g5a3oz4spmjinN63NhdrZNcpmVu
	 PIleNVIyfNGIQl87qCHB0p6qzudXOv9qDvAgjC+vREOvdncymHSmXb0F9yOkaNY9AMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vg9KimYobsr3PgH60R6LUdSOZ0a3LrU/+pgOQrzqNxk=;
	b=UOFKIvoqYJBgUrgccmoVRm+rTz5DXtcWiOF49S0PtSfXErlAJVutTConbBLECcSvBnI6
	 Xu67eXhDi6DkLLw4ohB2pOMblz0eSeYVeCyKK7wfVtBmOQvwYbzcDx/C9yBh1AzJLmPy1
	 NM9JnZzSGPw4bEuCy3rW9M0f5VwrFQ6ctVaTJPKZFeupQFS7PuVJySLGLrenYebBKIKBO
	 /idJYuVlNljZ/GDMmRdJRnYC9BgszOBx7AODP0ih6RIUJ5B0v34dKz7oTO2oKeijfmitl
	 iOS0/PerTf3J9C/ysLZQmY42AxaWv3oUPqcF7xiy+04dmhCluD/A3dLn6+nA5zKpLog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/MDD+9Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F62606A327;
	Wed, 25 Nov 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/MDD+9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE251F000CA;
	Wed, 25 Nov 2026 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622942;
	bh=Vg9KimYobsr3PgH60R6LUdSOZ0a3LrU/+pgOQrzqNxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/MDD+9Ze7a0m63dg6zQfrOymq9et44FifmnaJ5NvjzfRKJBH5xUErY566B0sbBHk
	 KM1qtduKLg8aTisxz0qSNmzpNUKBxoCwMkmH6fP78emTytwAbVCbpIpq1RCh6b+a6g
	 HXELzMYJBVN/bF6d/SV1iCMQdXl301/HqH7ZeDoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 700/990] net: mana: report RX checksum offload for IPv6
Date: Wed, 25 Nov 2026 15:34:27 +0100
Message-ID: <20261125143838.481235263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1978,10 +1978,9 @@ static void mana_rx_skb(void *buf_va, bo
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


