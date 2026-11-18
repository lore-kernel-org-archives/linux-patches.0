Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028213;
	b=IZP2l2oJZWd3QGJmfgicoNlcJE/28hyepUDaxKoIR6JL+9yIL1EUK98v/14xOTlgYi5G
	 cfzxVRWk9J3AFbwAw7++I+ZyqZoyWAxxzmIuicL9UKA7Hb53JFgaG1RDanzjwWRcCzwnt
	 Mdslt5dmKjli/FVN0mZt5jmNY+EsBgl9hLzKatzKUaCG/o7IXwI/eFE51uubaERL9LP6o
	 GED5h9wKQusYIwFHCgjjnkQD9N1T7zqmd4IN+hdkocGfL06z7DZtmTcM7K0wzPYMdrzXn
	 Tj3uHZq023DOjBHH57k5G/jegyTkqbKbY/VIKLjgkg1MPB/cKiregALbQeyw5HXQrMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+FxGKVUcK6/0jwjhZI90s1dRmbLWVzreIMBJ21V6M4=;
	b=yTcLOv1ZakMmCR7qxCwLtJg2VQulb8d94bKy3iuo77BvnCeMbF5F5E2AgBq7L4P8ldg4
	 rMWTEp6yJYB+s5lXsc4nfHbe/LvhCDQmaQdeeeGj+8l9qpB11iiOxHkLD8kWwgPELB3je
	 psJU3B8w61E27Nla+Vud989KEnBOczAmsletrubrUwow93bGNPKqMDeE1M0dIXgtVMR+s
	 NOxk89I7Uct2nldg97tVQDdcaiTibANeGUDx3LFwTMZUaKxucDNOUNgHNjEmyk84+fTKB
	 5N1Airh55tGGNNT9W10+utKCUisFJti5QlRW82Y2xJrFRgpwk/1cdDgqGLhNQxuUoLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W63C/iLy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06842606A31C;
	Wed, 18 Nov 2026 18:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W63C/iLy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5801E1F000C4;
	Wed, 18 Nov 2026 18:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028212;
	bh=g+FxGKVUcK6/0jwjhZI90s1dRmbLWVzreIMBJ21V6M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W63C/iLyZSkWCi5UNWniWOu7hiwd8OX5FQQ3zctohJjf1xNm/28uK78x3VyGHEBCp
	 OehFM/aDL5rRwIawKDaPc1DJL8ZAFrZLMhqKzI7L6hqEv0P9ujMHA8X6e6fH09Ei3g
	 qtf2CMLv2c+wiIsEIfyds05tRfHFCXHfATNsW734=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2065/2151] octeontx2-pf: pass the skb to otx2_dma_unmap_skb_frags()
Date: Wed, 18 Nov 2026 16:03:20 +0100
Message-ID: <20261118150236.943236680@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 92cb8653970e4efaa7d2c2e2819c6d050b25e462 ]

After a DMA mapping error, the unmap reads an skb pointer that is not
set yet. It can be NULL or left over from an earlier packet.

Fixes: 195c3d463181 ("octeontx2-pf: map skb data as device writeable")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Acked-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20261027-nb-otx2-ipsec-tx-fixes-net-v1-2-2114c4f10c36@tipi-net.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c   |  5 ++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h   |  3 ++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 10 +++++-----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 3920cd0985831..4434356087814 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -1037,7 +1037,7 @@ bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
 	return true;
 drop:
-	otx2_dma_unmap_skb_frags(pf, &sq->sg[sq->head]);
+	otx2_dma_unmap_skb_frags(pf, &sq->sg[sq->head], skb);
 	sq->sg[sq->head].skb = (u64)NULL;
 	atomic_long_inc(&pf->hw.dev_stats.tx_discards);
 	dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f27ec6d82e51a..9cf2e162dfcd3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -2130,13 +2130,12 @@ dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic *pfvf,
 	return otx2_dma_map_page(pfvf, page, offset, *len, dir);
 }
 
-void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg)
+void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg,
+			      struct sk_buff *skb)
 {
 	enum dma_data_direction dir = DMA_TO_DEVICE;
-	struct sk_buff *skb = NULL;
 	int seg;
 
-	skb = (struct sk_buff *)sg->skb;
 	if (unlikely(xfrm_offload(skb)))
 		dir = DMA_BIDIRECTIONAL;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 844ad55dd34b8..7c90948b918d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -1199,7 +1199,8 @@ static inline int mcam_entry_cmp(const void *a, const void *b)
 
 dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic *pfvf,
 				 struct sk_buff *skb, int seg, int *len);
-void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg);
+void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg,
+			      struct sk_buff *skb);
 int otx2_read_free_sqe(struct otx2_nic *pfvf, u16 qidx);
 void otx2_queue_vf_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
 			int first, int mdevs, u64 intr);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 625bb5a05344c..1e1bf7ef37d7e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -160,7 +160,7 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 
 	*tx_bytes += skb->len;
 	(*tx_pkts)++;
-	otx2_dma_unmap_skb_frags(pfvf, sg);
+	otx2_dma_unmap_skb_frags(pfvf, sg, skb);
 	napi_consume_skb(skb, budget);
 	sg->skb = (u64)NULL;
 }
@@ -872,7 +872,7 @@ static int otx2_dma_map_tso_skb(struct otx2_nic *pfvf,
 	}
 	return 0;
 unmap:
-	otx2_dma_unmap_skb_frags(pfvf, sg);
+	otx2_dma_unmap_skb_frags(pfvf, sg, skb);
 	return -EINVAL;
 }
 
@@ -1252,7 +1252,7 @@ bool otx2_sq_append_skb(void *dev, struct netdev_queue *txq,
 		ret = otx2_sqe_add_sg(pfvf, sq, skb, num_segs, &offset);
 
 	if (!ret) {
-		otx2_dma_unmap_skb_frags(pfvf, &sq->sg[sq->head]);
+		otx2_dma_unmap_skb_frags(pfvf, &sq->sg[sq->head], skb);
 		return false;
 	}
 
@@ -1344,7 +1344,7 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 		if (skb) {
 			tx_bytes += skb->len;
 			tx_pkts++;
-			otx2_dma_unmap_skb_frags(pfvf, sg);
+			otx2_dma_unmap_skb_frags(pfvf, sg, skb);
 			dev_kfree_skb_any(skb);
 			sg->skb = (u64)NULL;
 		}
@@ -1399,7 +1399,7 @@ void otx2_free_pending_sqe(struct otx2_nic *pfvf)
 			if (skb) {
 				tx_bytes += skb->len;
 				tx_pkts++;
-				otx2_dma_unmap_skb_frags(pfvf, sg);
+				otx2_dma_unmap_skb_frags(pfvf, sg, skb);
 				dev_kfree_skb_any(skb);
 				sg->skb = (u64)NULL;
 			}
-- 
2.53.0



