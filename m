Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213141;
	b=2jYoNmUpDf5kcmkWqSmCGb9scFGzUMhc+5OwIXvJwoXNHsxr8X5F50hfaqiB4ekRKR5s
	 v5seULM7YMF+gbgQ2CnUZovJZOW/kOn7qS8PLnlnjXBjFB8//hXea6UiJOROOvT8W3rCa
	 tTX1aH8tpe8nFKCDxvWPl7vxMp3KJVW/eFYlO1vuRUqiTXxCHZFOwChdhvo06VAHqczcA
	 JM4M1nh6oZuWabWlg+p+y0S5qC135AlTuKnm3xEeRFBY5S8j+FR7r65F+XsHF8hE5fQc4
	 S8OOPxnvaKHTzHqfWBWaW3V372YlLVnz+Wt61ftFGB3VMNBK5f3TbgFcPnhGq5Pr0QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ul7/uy29ksMy6NNtZL5h4CEGak/Tn7aFdajuF7yYtCE=;
	b=160qTDmFzA//T3vfm+r0uwDJXG5Q9AqLtHYjHuOxeGm3pTGx5IlWIPeKwo9djblLg6Hh
	 rCjjH0wDXcJX9/hSZ8gw3jSCCgizeMM6mrlc9eInfMktKQtTIa5KmyqTJUqwQmS2oOkIJ
	 cWFt8hobcuP2Cs0A42kJqtVXEXJT6H7GW85IyPaTg/BYqQMiau4Aqjl7bf6AePsb0SI7P
	 H7zUljpPgIk7dK2V3EowoE/A45tEPWQpnNJ3eMuPngsgXe3gG+1oNveVvpNryJ9zgv9K6
	 meTtOtlUo41cWZTlneDTq2sJfhXRID3wXZAFm5Bxndr/q7Cf/nm+XuO8YukGXkzNkXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkuCFnI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2B9606A31A;
	Wed, 28 Oct 2026 18:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkuCFnI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708F31F01825;
	Wed, 28 Oct 2026 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213141;
	bh=ul7/uy29ksMy6NNtZL5h4CEGak/Tn7aFdajuF7yYtCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkuCFnI3OoYx8iJIH/NxlbMTp29Lu5dypp2yVEbrIDUR35tt7ZEBAKkC3VTjFLFKF
	 BbJ2J4ZabSVlO6guVau1xsmdBLqa2MRUhjHSAaVSd1WBefKal0OiDabhuZo/Ku51Ku
	 dXj+htqFrqWpFN2eAyMMDi/tX4uxT4G2hJed8GDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Fleischmann <sfle@kth.se>,
	Eric Dumazet <edumazet@google.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0402/1887] bnxt_en: fix DMA mapping length for padded small packets
Date: Wed, 28 Oct 2026 17:41:38 +0100
Message-ID: <20261028170508.379327013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit a51d233ccd4889aadb71dace863525cc2b00271e ]

Stefan Fleischmann reported Intel IOMMU DMA Read faults on BCM57412
NetXtreme-E NICs when transmitting packets on VLAN/macvlan interfaces:

  DMAR: [DMA Read NO_PASID] Request device [18:00.0] fault addr 0xfc499000
        [fault reason 0x06] PTE Read access is not set
  bnxt_en 0000:18:00.0 eno1np0: Abandoning msg {0xb4 0x41a} len: 0 due to firmware status: 0x2000001
  ...
  NETDEV WATCHDOG: eno1np0 (bnxt_en): transmit queue 0 timed out

The fault address (0xfc499000) is on an exact 4KB page boundary,
pointing to a DMA read buffer overrun.

In bnxt_start_xmit(), packets smaller than BNXT_MIN_PKT_SIZE (52 bytes),
such as 42-byte untagged ARP frames, are padded:

    if (length < BNXT_MIN_PKT_SIZE) {
        pad = BNXT_MIN_PKT_SIZE - length;
        if (skb_pad(skb, pad))
            goto tx_kick_pending;
        length = BNXT_MIN_PKT_SIZE;
    }

    mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
    ...
    dma_unmap_len_set(tx_buf, len, len);

However, 'len' was initialized earlier to skb_headlen(skb) (e.g. 42 bytes)
and is left unadjusted after padding. Consequently, dma_map_single() and
dma_unmap_len_set() map and track only 42 bytes.

Later, the hardware TX buffer descriptor is programmed with the padded length:

    txbd->tx_bd_len_flags_type =
        cpu_to_le32(((len + pad) << TX_BD_LEN_SHIFT) | flags |
                    TX_BD_FLAGS_PACKET_END);

The NIC DMA engine is thus instructed to read 52 bytes from a region where
only 42 bytes were DMA-mapped. If skb->data ends near the boundary of a 4KB
page (within 'pad' bytes of the next page), the hardware DMA read overruns
into the unmapped adjacent page, triggering an IOMMU fault.

This issue was exposed after commit 447cbe95ebb9 ("vlan: fix skb_under_panic
and races when toggling HW VLAN offload") because reserving extra VLAN
headroom rounded LL_RESERVED_SPACE from 48 up to 64 bytes, shifting skb->data
offsets and potentially causing small frames to land right against page
boundaries.

Fix this by using skb_put_padto(skb, BNXT_MIN_PKT_SIZE) in
bnxt_start_xmit(), before skb_shinfo(skb)->nr_frags is sampled,
because padding might linearize the skb.
This ensures skb->len and skb_headlen(skb) reflect the padded size so
that dma_map_single() maps the full buffer and the descriptor length is
consistent. This also removes the temporary 'pad' variable and masking logic.

The padding is done after the SW USO branch, otherwise
bnxt_sw_udp_gso_xmit() would account the padding as UDP payload
and send it in extra segments.

Note that SW USO segments are still not padded: with IPv4, a segment
carrying less than 10 bytes of UDP payload (small gso_size, or a short
last segment) is sent as a frame shorter than BNXT_MIN_PKT_SIZE.
This is a separate issue, left for a followup patch.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Cc: stable@vger.kernel.org
Reported-by: Stefan Fleischmann <sfle@kth.se>
Closes: https://lore.kernel.org/netdev/20261004122616.56714cbd@nargothrond/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261007051747.455273-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8d7eda5cafe2d..3179412d7b33b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -392,7 +392,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *txq;
 	int i;
 	dma_addr_t mapping;
-	unsigned int length, pad = 0;
+	unsigned int length;
 	u32 len, free_size, vlan_tag_flags, cfa_action, flags;
 	u16 prod, last_frag;
 	struct pci_dev *pdev = bp->pdev;
@@ -411,6 +411,14 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	txr = &bp->tx_ring[bp->tx_ring_map[i]];
 	prod = txr->tx_prod;
 
+	/* Must be done before skb_shinfo(skb)->nr_frags is sampled,
+	 * because skb_put_padto() might linearize the skb.
+	 */
+	if (skb_put_padto(skb, BNXT_MIN_PKT_SIZE)) {
+		/* SKB already freed. */
+		goto tx_kick_pending;
+	}
+
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
 		/* We must have raced with NAPI cleanup */
@@ -539,14 +547,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 normal_tx:
-	if (length < BNXT_MIN_PKT_SIZE) {
-		pad = BNXT_MIN_PKT_SIZE - length;
-		if (skb_pad(skb, pad))
-			/* SKB already freed. */
-			goto tx_kick_pending;
-		length = BNXT_MIN_PKT_SIZE;
-	}
-
 	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
 	if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
@@ -618,10 +618,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
 	}
 
-	flags &= ~TX_BD_LEN;
-	txbd->tx_bd_len_flags_type =
-		cpu_to_le32(((len + pad) << TX_BD_LEN_SHIFT) | flags |
-			    TX_BD_FLAGS_PACKET_END);
+	txbd->tx_bd_len_flags_type |= cpu_to_le32(TX_BD_FLAGS_PACKET_END);
 
 	netdev_tx_sent_queue(txq, skb->len);
 
-- 
2.53.0



