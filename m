Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042732;
	b=wz70R4rxU+qiOHQsmj0RNeDha54Qy9Bd2IHPADSsY5v9eBl6uNF2PTi/5xmhavxbam9B
	 RK7E2ipMeeuAzB/cK4mL3S1c4+ctbRuvR8ct6QBnEAYHvs75zwdfce1G5nGkf9yZKlpGA
	 Y6nJlsoyyfKyjMbt4V1hPxp93ddNe7QdfDCCXqf3byyyKRDpNLorHirc2TXoNIgf667EI
	 hQ+NugJ6rTo9IVo7Tj5vQWLHnPwHB6KV9H31yH8G+BVKV2x4G9WGDWZhEgev9j0mOSKF8
	 RfgBg571Ho0ebyJEtOPhLQaKThSbV72Z2blUhnRXwQKlxvQ08IGJoek2V+s8Rp1CGvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dvey1P+NYW1Mt3OOSfQnmCKu3pnMw22EM2vtwF6QwDk=;
	b=CWoVpq6fWSifAm2wQvZ7O8QhC2gn4SKhP9z77es/RNExyX/pjC7S2wdAqkmFEDcgL/gA
	 rQ10G2tW8gQpRpCbTaXTwOQ4ZMjN9uEoh52KDOMSflra5s82icICe320XFwKipcGBJwOy
	 qKxBo+akardCv8lTDxgDD7qw8UcBh37LPxkL7FNd65IIpWLQhXC1qYfr1VNvSRmWUMhOw
	 hEAC9mtH2zwzQZ1N8dwU/fVBVHvzqOvD93tq4uaIkRzl1fiC3YFysg1vMBwSObykmbqtp
	 EoBMzXuzh6zs6kbp4OPgvLhVsvc3K/lDL+FfreLKlKRJioDVx/lcPFj/9YGHj4ztm+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRzlU+QJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57071606A320;
	Wed, 18 Nov 2026 22:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRzlU+QJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE691F000C4;
	Wed, 18 Nov 2026 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042732;
	bh=dvey1P+NYW1Mt3OOSfQnmCKu3pnMw22EM2vtwF6QwDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRzlU+QJuM4OPK5ksFUbGSBnrsWdzRybXRx/x2QXmAhnkmfPNdBXDnGVqWwSBJ4Ll
	 J8LPJiq2yRltJ7ZUjcIv3qFyiHmxFwpUuDmLUvjT4GqnPSJb2jdH9GdeVgYFsZuUV1
	 Fm4FvtEfsQMdgU2LTI4sXkEzYZN+UawfXa3/Ag80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3274/3318] bnxt_en: Change bnxt_rx_xdp function prototype
Date: Wed, 18 Nov 2026 16:04:56 +0100
Message-ID: <20261118150457.836114295@linuxfoundation.org>
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 1614f06e09ad6b271c6ed8ffd87ccf89ec51526c ]

Change bnxt_rx_xdp() to take a pointer to xdp instead of stack
variable.
This is in prepartion for the XDP metadata patch change where
the BPF program can change the value of the xdp.meta_data.

Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240402093753.331120-5-pavan.chebbi@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c10f3420d598 ("eth: bnxt: free XDP frags when xdp_do_redirect() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 28 +++++++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9cfccedebc096..cf329bdfa1caf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1934,7 +1934,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (xdp_active) {
-		if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &data_ptr, &len, event)) {
+		if (bnxt_rx_xdp(bp, rxr, cons, &xdp, data, &data_ptr, &len, event)) {
 			rc = 1;
 			goto next_rx;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 85a9ffcc4fe06..8a098b5884b9b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -222,7 +222,7 @@ void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
  * false   - packet should be passed to the stack.
  */
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct xdp_buff xdp, struct page *page, u8 **data_ptr,
+		 struct xdp_buff *xdp, struct page *page, u8 **data_ptr,
 		 unsigned int *len, u8 *event)
 {
 	struct bpf_prog *xdp_prog = READ_ONCE(rxr->xdp_prog);
@@ -244,9 +244,9 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 	txr = rxr->bnapi->tx_ring;
 	/* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
-	orig_data = xdp.data;
+	orig_data = xdp->data;
 
-	act = bpf_prog_run_xdp(xdp_prog, &xdp);
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	tx_avail = bnxt_tx_avail(bp, txr);
 	/* If the tx ring is not full, we must not update the rx producer yet
@@ -255,10 +255,10 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	if (tx_avail != bp->tx_ring_size)
 		*event &= ~BNXT_RX_EVENT;
 
-	*len = xdp.data_end - xdp.data;
-	if (orig_data != xdp.data) {
-		offset = xdp.data - xdp.data_hard_start;
-		*data_ptr = xdp.data_hard_start + offset;
+	*len = xdp->data_end - xdp->data;
+	if (orig_data != xdp->data) {
+		offset = xdp->data - xdp->data_hard_start;
+		*data_ptr = xdp->data_hard_start + offset;
 	}
 
 	switch (act) {
@@ -270,8 +270,8 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		mapping = rx_buf->mapping - bp->rx_dma_offset;
 		*event = 0;
 
-		if (unlikely(xdp_buff_has_frags(&xdp))) {
-			struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(&xdp);
+		if (unlikely(xdp_buff_has_frags(xdp))) {
+			struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 
 			tx_needed += sinfo->nr_frags;
 			*event = BNXT_AGG_EVENT;
@@ -279,7 +279,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (tx_avail < tx_needed) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
-			bnxt_xdp_buff_frags_free(rxr, &xdp);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			bnxt_reuse_rx_data(rxr, cons, page);
 			return true;
 		}
@@ -289,7 +289,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		*event |= BNXT_TX_EVENT;
 		__bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
-				NEXT_RX(rxr->rx_prod), &xdp);
+				NEXT_RX(rxr->rx_prod), xdp);
 		bnxt_reuse_rx_data(rxr, cons, page);
 		return true;
 	case XDP_REDIRECT:
@@ -301,12 +301,12 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		/* if we are unable to allocate a new buffer, abort and reuse */
 		if (bnxt_alloc_rx_data(bp, rxr, rxr->rx_prod, GFP_ATOMIC)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
-			bnxt_xdp_buff_frags_free(rxr, &xdp);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			bnxt_reuse_rx_data(rxr, cons, page);
 			return true;
 		}
 
-		if (xdp_do_redirect(bp->dev, &xdp, xdp_prog)) {
+		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
 			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
@@ -321,7 +321,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		trace_xdp_exception(bp->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		bnxt_xdp_buff_frags_free(rxr, &xdp);
+		bnxt_xdp_buff_frags_free(rxr, xdp);
 		bnxt_reuse_rx_data(rxr, cons, page);
 		break;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 9f5829a0adeb1..220285e190fcd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -18,7 +18,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct xdp_buff *xdp);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int budget);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct xdp_buff xdp, struct page *page, u8 **data_ptr,
+		 struct xdp_buff *xdp, struct page *page, u8 **data_ptr,
 		 unsigned int *len, u8 *event);
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
-- 
2.53.0



