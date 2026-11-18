Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022190;
	b=QmE6E+aElwKrisTe25JER59ATI34eCaI5eD7fGWnE98aG6QRWeIY1DefJUw5k1+g5Kn6
	 bN9++0INVZkzBNy471QoDHflaGhv49DTKttkNVMXWMul1qj9CQBZRP9JAg3vYuoGjOnMh
	 b4QP/k37QC+EzHmsWuGugiv8nEsKFPeK2N7VSEbypArZ0xuo9xzRf3I6NsjIYeATm4Cz6
	 y8u0LqRYyZrYRltMAy4JKk5GpxJ8ukb+n1PidKAyJhaJiVoJgaVvUX5zrxducVoOulJ1X
	 3S0MHWvStm5XXt0SbE6WId7HVt1rNCk7xS8XmIi36TQzuLeeoJAvH6VZ7niIejqKXrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9OYcfmkqL85X11W3LtmMsvZyAMBGFTYVWIQNRVHfec=;
	b=rWUsb7RIjsM2j/8o7PftE5ozc4aGn5Wm34oiM2aCkJFsguEiSSbE2xE/ua3pRJAyKqcX
	 eTNc6B9esxVDGJRoCVHipk+gqK+3JG8IoUF3TfePbYmAMYHart50eRVUAOeT+JjZajc5W
	 ixijSkKHdPd0qdyrCRG3v6j8Z/ZZfDoMJttV7XCiza+s0xF0WfIkOayKMnZBVCYde9fAG
	 qBIR/utBW7q4TEDzYL+QlsCEEn5YCw7+/fqYUr9rWBOgX6IwdMtZszpWPZ8va2JMZttrw
	 vMJ1eusA/3qwvcOFKF3ArS//hFxF1CEYFrJwIpNGIQzLnac08WcTBj1j0qwQZz3VVmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWaVx4H7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC790606A31C;
	Wed, 18 Nov 2026 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWaVx4H7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A1C1F000C5;
	Wed, 18 Nov 2026 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022190;
	bh=g9OYcfmkqL85X11W3LtmMsvZyAMBGFTYVWIQNRVHfec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWaVx4H7tK3tT+BUdxh83uwi+jl3ccTubmPCFkqf8BMXldF7/8Od3xlPMunQPh/rq
	 8L4JfwGZK4+bE1woz91DvDU6DulUUxxkwwpO0qr2Nys+aPihXMpASBz/30IGjNBNLq
	 IlTXiqlD7b7Wp9c3MS2gQeseX3usJcskRyZi6S2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2573/2651] octeontx2-pf: pass the skb to otx2_dma_unmap_skb_frags()
Date: Wed, 18 Nov 2026 16:03:33 +0100
Message-ID: <20261118150417.000164416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index b11389a841d15..07c43a4fcb4ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -2140,13 +2140,12 @@ dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic *pfvf,
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
index 44cd56a0c2c4c..9a80450857f89 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -1253,7 +1253,8 @@ static inline int mcam_entry_cmp(const void *a, const void *b)
 
 dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic *pfvf,
 				 struct sk_buff *skb, int seg, int *len);
-void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg);
+void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg,
+			      struct sk_buff *skb);
 int otx2_read_free_sqe(struct otx2_nic *pfvf, u16 qidx);
 void otx2_queue_vf_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
 			int first, int mdevs, u64 intr);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 8d2d607bc92f9..66dc8cc154861 100644
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



