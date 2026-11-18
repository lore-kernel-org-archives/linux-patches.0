Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050739;
	b=duaR240znGTmnblrDFVxQ9daH7Tzv+v1q4t11bNeai0oCchSz/xn3Z7Cg++Cd5rEwLHd
	 yvll8g6afW4l3F3Ki5JEWDh5RyJXuSGhOFjXlqwKLZ1MQppa1wJCNLiFwGostGF6nnoyU
	 /nAfqc0wSa1btMqlvr2tLMg0glCGagSrrvVPLr0WqoEg1Bb8RsYqVbV/C++pxItiPDMWM
	 V+cuKh8mI9qjPOGC1PZdLAFDEAXQJUZM81uZd4gXYI+V6WWRp+M2GfuYr7jjONDlqypxR
	 Nutq5vLrV9OWfbXVV9YZ4bhhaBTqPvNPdC5n8VQFFfptUzCEDplODNDfyfVYxp/V4lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ra0Kq54csXoSj2B7cIauUrI7aSxgg/VtzFF6nZG7Rk=;
	b=O4SwoAjy22yD8PFzHh0l0fVwYKjDPzDN8cJaG12KMrpUEdjwA3XEQzHfuSmUO22RFtrj
	 UA2fkzL9G8RzinGZKGnS094utEqE5SBdErIYEzhuyORJ8Bnsit00/V4wZx3Hsn2eRyvsj
	 ZDL6+GLKiYOqdNsL378pmZMkdMvsqyOQyMz69ppqAbdVlHuyaO0dYfQhu/aB+C07bBrDP
	 bzKD0m6XwDaqr/KJ7cdk+tFqSmc/eMToBwgp6e5YL1OolWJh0DvJ78uSa8J2zJjAfWtCf
	 vTGunaNfXUcDj1Dmj6/qNBR28QfN2c9CqZUHKoG4gzrXi3SoDbBtm+GpzTOUYc113Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zY4KsUki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45164606A325;
	Thu, 19 Nov 2026 01:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zY4KsUki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAE31F000C4;
	Thu, 19 Nov 2026 01:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050738;
	bh=1ra0Kq54csXoSj2B7cIauUrI7aSxgg/VtzFF6nZG7Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zY4KsUkiAJARjF5VK5QzZDcAwcRWFmsQtVG9Ir4mgkQtlzBgXVZdrCwqt5o9d8s4U
	 rXFrA3X76UgCgj3mRVzl8mhvs43xim452Se00Z262mvkUbEUR31yyK6TmHf/CtaBH/
	 hcFlRSvWsfwhNdRHMiwikCYGiHa8jHa5+X+G+hvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2816/2857] bnxt_en: Add XDP Metadata support
Date: Wed, 18 Nov 2026 16:04:10 +0100
Message-ID: <20261118150342.993021802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 0ae1fafc8be6d4271a8ad66b4695e123a4e8cef1 ]

- Change the last arg to xdp_prepare_buff to true from false.
- Ensure that when XDP_PASS is returned the xdp->data_meta area
is copied to the skb->data area. Account for the meta data
size on skb allocation and do a pull after to move it to the
"reserved" zone.

Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240402093753.331120-6-pavan.chebbi@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 364b88b54fc2 ("eth: bnxt: hand XDP frags over to the copybreak skb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 44 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  2 +-
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2bb1e26034048..bbb7b77a6b753 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1249,9 +1249,9 @@ static int bnxt_agg_bufs_valid(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	return RX_AGG_CMP_VALID(agg, *raw_cons);
 }
 
-static inline struct sk_buff *bnxt_copy_skb(struct bnxt_napi *bnapi, u8 *data,
-					    unsigned int len,
-					    dma_addr_t mapping)
+static struct sk_buff *bnxt_copy_data(struct bnxt_napi *bnapi, u8 *data,
+				      unsigned int len,
+				      dma_addr_t mapping)
 {
 	struct bnxt *bp = bnapi->bp;
 	struct pci_dev *pdev = bp->pdev;
@@ -1271,6 +1271,39 @@ static inline struct sk_buff *bnxt_copy_skb(struct bnxt_napi *bnapi, u8 *data,
 				   bp->rx_dir);
 
 	skb_put(skb, len);
+
+	return skb;
+}
+
+static struct sk_buff *bnxt_copy_skb(struct bnxt_napi *bnapi, u8 *data,
+				     unsigned int len,
+				     dma_addr_t mapping)
+{
+	return bnxt_copy_data(bnapi, data, len, mapping);
+}
+
+static struct sk_buff *bnxt_copy_xdp(struct bnxt_napi *bnapi,
+				     struct xdp_buff *xdp,
+				     unsigned int len,
+				     dma_addr_t mapping)
+{
+	unsigned int metasize = 0;
+	u8 *data = xdp->data;
+	struct sk_buff *skb;
+
+	len = xdp->data_end - xdp->data_meta;
+	metasize = xdp->data - xdp->data_meta;
+	data = xdp->data_meta;
+
+	skb = bnxt_copy_data(bnapi, data, len, mapping);
+	if (!skb)
+		return skb;
+
+	if (metasize) {
+		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
+
 	return skb;
 }
 
@@ -1983,7 +2016,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (len <= bp->rx_copy_thresh) {
-		skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
+		if (!xdp_active)
+			skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
+		else
+			skb = bnxt_copy_xdp(bnapi, &xdp, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
 			if (agg_bufs) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 95f620991ec78..45d55aa3c730e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -194,7 +194,7 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, len, bp->rx_dir);
 
 	xdp_init_buff(xdp, buflen, &rxr->xdp_rxq);
-	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, false);
+	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, true);
 }
 
 void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
-- 
2.53.0



