Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EB018D62A;
	Sat, 17 Oct 2026 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258051; cv=none; b=suTGlm5yA0WznVvip/mneDrIKy5I7ILk/caYCMbqPgEYkR58yia4hk5tj/kY8vlMCkzdXzcD7B7euRyicOGI2psto92gdxkRv0h8jZHox2tZQxRP3V+gRc4ANUV4xQPHDWpZJ5Te9e5syb64bEF2H4E+/IlO9OGqFcgV0a/CIpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258051; c=relaxed/simple;
	bh=XKukx1YJjEd27Yqs6dRKwWfj5rA125YZAFMe9tx6zvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm9BniQ1GeojyHnQ2BXaGdvCttIgeCrL5Qj7AsEagVzjWLSlnI7mzE9wdj9YgA5IeZcsceGr6KuCoM+rvl8BDiZIfnqP9WNQftGp292Y0POdnobnMqPhG0nK1U8Bj7pod2DelPTz1NBHmN7qylgGS6UI7BjT0MmdWvhlTPeUCSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRocs/ce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRocs/ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2437E1F000C4;
	Sat, 17 Oct 2026 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258048;
	bh=5iL+slNH0rZUBXEm7+nTSoGxDV14hwh5ZsDa7iIgwPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRocs/cemwJeOG61nUhRn3QCprV3ZtLIGCfZWG+Ziboq0lNzd1Ay6LneDWOV5SRSh
	 9qGprreaXmgB6ai8Js2hzt2Y0PAD5/OOvqsVyCxKSmWnH/J4cB7d1oI+sxdVQ7or8A
	 pop01z1Mds2LN0GAAgVO6IGet4c0hCvmZ1/Q6MoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0710/1674] wifi: ath12k: avoid explicit HW conversion argument in Rxdma replenish
Date: Sat, 17 Oct 2026 17:49:42 +0200
Message-ID: <20261017160449.330314721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit 4d922ce983cbb9d8f57335acb62d67697ac45202 ]

Currently Rxdma replenish require HW conversion argument which is
unnecessary argument since ath12k driver configures the Rxdma only
in HW conversion. To optimize the rx data path per packet, avoid
the explicit unnecessary argument and condition check in the rx
replenish.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00125-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231111043934.20485-4-quic_periyasa@quicinc.com
Stable-dep-of: ecfc13138992 ("wifi: ath12k: Avoid memory leak while enabling statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c    |  3 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c | 78 +++++++++----------------
 drivers/net/wireless/ath/ath12k/dp_rx.h |  3 +-
 3 files changed, 31 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 175e2a5da827f..637d5ee6e7538 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -970,8 +970,7 @@ int ath12k_dp_service_srng(struct ath12k_base *ab,
 		struct ath12k_dp *dp = &ab->dp;
 		struct dp_rxdma_ring *rx_ring = &dp->rx_refill_buf_ring;
 
-		ath12k_dp_rx_bufs_replenish(ab, rx_ring, 0,
-					    true);
+		ath12k_dp_rx_bufs_replenish(ab, rx_ring, 0);
 	}
 
 	/* TODO: Implement handler for other interrupts */
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index bb3df16deb796..427641ffa968f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -258,15 +258,13 @@ static int ath12k_dp_purge_mon_ring(struct ath12k_base *ab)
 /* Returns number of Rx buffers replenished */
 int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 				struct dp_rxdma_ring *rx_ring,
-				int req_entries,
-				bool hw_cc)
+				int req_entries)
 {
 	struct ath12k_buffer_addr *desc;
 	struct hal_srng *srng;
 	struct sk_buff *skb;
 	int num_free;
 	int num_remain;
-	int buf_id;
 	u32 cookie;
 	dma_addr_t paddr;
 	struct ath12k_dp *dp = &ab->dp;
@@ -307,40 +305,29 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 		if (dma_mapping_error(ab->dev, paddr))
 			goto fail_free_skb;
 
-		if (hw_cc) {
-			spin_lock_bh(&dp->rx_desc_lock);
-
-			/* Get desc from free list and store in used list
-			 * for cleanup purposes
-			 *
-			 * TODO: pass the removed descs rather than
-			 * add/read to optimize
-			 */
-			rx_desc = list_first_entry_or_null(&dp->rx_desc_free_list,
-							   struct ath12k_rx_desc_info,
-							   list);
-			if (!rx_desc) {
-				spin_unlock_bh(&dp->rx_desc_lock);
-				goto fail_dma_unmap;
-			}
-
-			rx_desc->skb = skb;
-			cookie = rx_desc->cookie;
-			list_del(&rx_desc->list);
-			list_add_tail(&rx_desc->list, &dp->rx_desc_used_list);
+		spin_lock_bh(&dp->rx_desc_lock);
 
+		/* Get desc from free list and store in used list
+		 * for cleanup purposes
+		 *
+		 * TODO: pass the removed descs rather than
+		 * add/read to optimize
+		 */
+		rx_desc = list_first_entry_or_null(&dp->rx_desc_free_list,
+						   struct ath12k_rx_desc_info,
+						   list);
+		if (!rx_desc) {
 			spin_unlock_bh(&dp->rx_desc_lock);
-		} else {
-			spin_lock_bh(&rx_ring->idr_lock);
-			buf_id = idr_alloc(&rx_ring->bufs_idr, skb, 0,
-					   rx_ring->bufs_max * 3, GFP_ATOMIC);
-			spin_unlock_bh(&rx_ring->idr_lock);
-			if (buf_id < 0)
-				goto fail_dma_unmap;
-			cookie = u32_encode_bits(buf_id,
-						 DP_RXDMA_BUF_COOKIE_BUF_ID);
+			goto fail_dma_unmap;
 		}
 
+		rx_desc->skb = skb;
+		cookie = rx_desc->cookie;
+		list_del(&rx_desc->list);
+		list_add_tail(&rx_desc->list, &dp->rx_desc_used_list);
+
+		spin_unlock_bh(&dp->rx_desc_lock);
+
 		desc = ath12k_hal_srng_src_get_next_entry(ab, srng);
 		if (!desc)
 			goto fail_buf_unassign;
@@ -359,17 +346,11 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 	return req_entries - num_remain;
 
 fail_buf_unassign:
-	if (hw_cc) {
-		spin_lock_bh(&dp->rx_desc_lock);
-		list_del(&rx_desc->list);
-		list_add_tail(&rx_desc->list, &dp->rx_desc_free_list);
-		rx_desc->skb = NULL;
-		spin_unlock_bh(&dp->rx_desc_lock);
-	} else {
-		spin_lock_bh(&rx_ring->idr_lock);
-		idr_remove(&rx_ring->bufs_idr, buf_id);
-		spin_unlock_bh(&rx_ring->idr_lock);
-	}
+	spin_lock_bh(&dp->rx_desc_lock);
+	list_del(&rx_desc->list);
+	list_add_tail(&rx_desc->list, &dp->rx_desc_free_list);
+	rx_desc->skb = NULL;
+	spin_unlock_bh(&dp->rx_desc_lock);
 fail_dma_unmap:
 	dma_unmap_single(ab->dev, paddr, skb->len + skb_tailroom(skb),
 			 DMA_FROM_DEVICE);
@@ -435,8 +416,7 @@ static int ath12k_dp_rxdma_ring_buf_setup(struct ath12k_base *ab,
 	if ((ringtype == HAL_RXDMA_MONITOR_BUF) || (ringtype == HAL_TX_MONITOR_BUF))
 		ath12k_dp_mon_buf_replenish(ab, rx_ring, num_entries);
 	else
-		ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_entries,
-					    ringtype == HAL_RXDMA_BUF);
+		ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_entries);
 	return 0;
 }
 
@@ -2742,7 +2722,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int ring_id,
 	if (!total_msdu_reaped)
 		goto exit;
 
-	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped, true);
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped);
 
 	ath12k_dp_rx_process_received_packets(ab, napi, &msdu_list,
 					      ring_id);
@@ -3522,7 +3502,7 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 
 	rx_ring = &dp->rx_refill_buf_ring;
 
-	ath12k_dp_rx_bufs_replenish(ab, rx_ring, tot_n_bufs_reaped, true);
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, tot_n_bufs_reaped);
 
 	return tot_n_bufs_reaped;
 }
@@ -3861,7 +3841,7 @@ int ath12k_dp_rx_process_wbm_err(struct ath12k_base *ab,
 	if (!num_buffs_reaped)
 		goto done;
 
-	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped, true);
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped);
 
 	rcu_read_lock();
 	for (i = 0; i <  ab->num_radios; i++) {
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index b0fb806a3b147..05b3d5581dbe2 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -118,8 +118,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int mac_id,
 			 int budget);
 int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 				struct dp_rxdma_ring *rx_ring,
-				int req_entries,
-				bool hw_cc);
+				int req_entries);
 int ath12k_dp_rx_pdev_mon_attach(struct ath12k *ar);
 int ath12k_dp_rx_peer_frag_setup(struct ath12k *ar, const u8 *peer_mac, int vdev_id);
 
-- 
2.53.0



