Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE7D3BAD9A;
	Sat, 17 Oct 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258047; cv=none; b=PzjR2/21p+AdlO1g+KLuxMN+yAVOw79FSj3CB8gV0S1FT8HYXVPZ4a0H0uWTilMUJBnemJWehxEf1ZxFYmQKXSVky0LB2jvDCRxS+F5RNkys68pw4seuB2pltf0Yb8crZQXsxnxkYtn1sqH8TsqJ75vZ6C9YT1PNjFePFu4CYuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258047; c=relaxed/simple;
	bh=iv4TC3YMSVq9nw2NDtML673BKsIafBCT0vV/0nAi5wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJMnzHCy+QEsfSN70wLeQl9V4HvyTo6OzHmRR0svXRK/t2mv0WK3GkJSQlaSXewPWSFNR1L2U39RINpVn6+gUpyG0sbD9fqbn/X6xLAcZWiybBihtjsrqTefL9R1CxTgN+QAnWLVza7bqh922ychr+60T3VXJfQraI7C6SaW1ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UVJv5e7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UVJv5e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4EA1F000C4;
	Sat, 17 Oct 2026 17:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258045;
	bh=1vR2hWtvBhJuMjRsbfzO6nXC2JmYs/WAePnD61Vc/Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UVJv5e7ENZuL2B6CQFiZc1S0g9TTc2026kpt7RQJrj8GZBH1NwMfW06XATfEogRX
	 261FRf6w5IgJE52ZPNyYlzHUaHvXbm5P5JlTS6uS1Kn7kXG0l7JpzP4AOuHP1IX0Qh
	 JsW5BOy8puqHYn7tvw7zdgokjO71rR8H8zg8OnVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0709/1674] wifi: ath12k: avoid explicit RBM id argument in Rxdma replenish
Date: Sat, 17 Oct 2026 17:49:41 +0200
Message-ID: <20261017160449.303689982@linuxfoundation.org>
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

[ Upstream commit d457f9fe863df2e15ea1815dfe836020d436ea29 ]

Currently all Rxdma replenish callers pass the same return
buffer manager id argument, so make it implicitly. To
optimize the rx data path per packet, avoid the explicit
unnecessary argument in Rxdma replenish function.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00125-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231111043934.20485-3-quic_periyasa@quicinc.com
Stable-dep-of: ecfc13138992 ("wifi: ath12k: Avoid memory leak while enabling statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c    |  1 -
 drivers/net/wireless/ath/ath12k/dp_rx.c | 13 ++++---------
 drivers/net/wireless/ath/ath12k/dp_rx.h |  1 -
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index e9097f5c96855..175e2a5da827f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -971,7 +971,6 @@ int ath12k_dp_service_srng(struct ath12k_base *ab,
 		struct dp_rxdma_ring *rx_ring = &dp->rx_refill_buf_ring;
 
 		ath12k_dp_rx_bufs_replenish(ab, rx_ring, 0,
-					    ab->hw_params->hal_params->rx_buf_rbm,
 					    true);
 	}
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 525a18ca557de..bb3df16deb796 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -259,7 +259,6 @@ static int ath12k_dp_purge_mon_ring(struct ath12k_base *ab)
 int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 				struct dp_rxdma_ring *rx_ring,
 				int req_entries,
-				enum hal_rx_buf_return_buf_manager mgr,
 				bool hw_cc)
 {
 	struct ath12k_buffer_addr *desc;
@@ -272,6 +271,7 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 	dma_addr_t paddr;
 	struct ath12k_dp *dp = &ab->dp;
 	struct ath12k_rx_desc_info *rx_desc;
+	enum hal_rx_buf_return_buf_manager mgr = ab->hw_params->hal_params->rx_buf_rbm;
 
 	req_entries = min(req_entries, rx_ring->bufs_max);
 
@@ -436,7 +436,6 @@ static int ath12k_dp_rxdma_ring_buf_setup(struct ath12k_base *ab,
 		ath12k_dp_mon_buf_replenish(ab, rx_ring, num_entries);
 	else
 		ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_entries,
-					    ab->hw_params->hal_params->rx_buf_rbm,
 					    ringtype == HAL_RXDMA_BUF);
 	return 0;
 }
@@ -2743,9 +2742,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int ring_id,
 	if (!total_msdu_reaped)
 		goto exit;
 
-	/* TODO: Move to implicit BM? */
-	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped,
-				    ab->hw_params->hal_params->rx_buf_rbm, true);
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped, true);
 
 	ath12k_dp_rx_process_received_packets(ab, napi, &msdu_list,
 					      ring_id);
@@ -3525,8 +3522,7 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 
 	rx_ring = &dp->rx_refill_buf_ring;
 
-	ath12k_dp_rx_bufs_replenish(ab, rx_ring, tot_n_bufs_reaped,
-				    ab->hw_params->hal_params->rx_buf_rbm, true);
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, tot_n_bufs_reaped, true);
 
 	return tot_n_bufs_reaped;
 }
@@ -3865,8 +3861,7 @@ int ath12k_dp_rx_process_wbm_err(struct ath12k_base *ab,
 	if (!num_buffs_reaped)
 		goto done;
 
-	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped,
-				    ab->hw_params->hal_params->rx_buf_rbm, true);
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped, true);
 
 	rcu_read_lock();
 	for (i = 0; i <  ab->num_radios; i++) {
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index ef1b172e685c9..b0fb806a3b147 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -119,7 +119,6 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int mac_id,
 int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 				struct dp_rxdma_ring *rx_ring,
 				int req_entries,
-				enum hal_rx_buf_return_buf_manager mgr,
 				bool hw_cc);
 int ath12k_dp_rx_pdev_mon_attach(struct ath12k *ar);
 int ath12k_dp_rx_peer_frag_setup(struct ath12k *ar, const u8 *peer_mac, int vdev_id);
-- 
2.53.0



