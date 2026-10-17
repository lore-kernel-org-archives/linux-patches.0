Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345A21AAE28;
	Sat, 17 Oct 2026 17:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258044; cv=none; b=edrFCjVsLt4CGW/xZXSVach0sIimUKgCjDdwnmeJIjP1lEecJZDuQd/aWjfKt9fnB3w2e+xy/+WLFDzZ0wYjxhXNTtuSgh/NKkevPFbi1TaQygAeynWS8xT5ELSSMxhy5RowoYHsSQ0NgKCSvrBmRlfuJxtPrzK35yooF5bnjCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258044; c=relaxed/simple;
	bh=/9TDzSKYLEBHjFJLIebHEma2N5L95A6AfKlfLUWL91s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMl0lFzQUpJDvokE79Ue9vC7jUsOsIvoWvQDQBCDp5j3B4vNX5Mbciu+3V1t2zGuYAT3S1DREwhUSQWMDD2/xS+mqX+DFVHhj8OHV5nS0r7xmO15rifuwXwTAM1x3jyzJy4MdJZsNRMt42L8k+yI39GsGdb13AOtBOC8qGCH79M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGgyzHhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGgyzHhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427631F000C4;
	Sat, 17 Oct 2026 17:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258042;
	bh=iTZn5Xb4LStHHCCnSm4Q+ltYWgmghRoXKQ+PNjIDWKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGgyzHhPNC0Q3K6geU5T6+I27EVL8cwk+eSi5UEtf9FHZfF7nwxjeAaYmld45rAb6
	 2TyezO4D3Of2H9UkzGpxLHFRxG6xIJVLRLtSXlmDCmmWDBgv5PTSavOaVA1+ECwVEL
	 /JAqCoQHIdICS3smOWpyaFyxltf8rMTA0V/Jm7fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0708/1674] wifi: ath12k: avoid explicit mac id argument in Rxdma replenish
Date: Sat, 17 Oct 2026 17:49:40 +0200
Message-ID: <20261017160449.277862178@linuxfoundation.org>
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

[ Upstream commit d281a574f1332ad185faebe433f790abf4eb3b58 ]

Currently all Rxdma replenish callers pass zero for the mac id
argument, so make it as zero implicitly. To optimize the rx
data path per packet, avoid the explicit unnecessary argument
in Rxdma replenish function.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00125-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231111043934.20485-2-quic_periyasa@quicinc.com
Stable-dep-of: ecfc13138992 ("wifi: ath12k: Avoid memory leak while enabling statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c    |  4 ++--
 drivers/net/wireless/ath/ath12k/dp_rx.c | 16 +++++++---------
 drivers/net/wireless/ath/ath12k/dp_rx.h |  4 ++--
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index c918f5d12975c..e9097f5c96855 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <crypto/hash.h>
@@ -970,7 +970,7 @@ int ath12k_dp_service_srng(struct ath12k_base *ab,
 		struct ath12k_dp *dp = &ab->dp;
 		struct dp_rxdma_ring *rx_ring = &dp->rx_refill_buf_ring;
 
-		ath12k_dp_rx_bufs_replenish(ab, 0, rx_ring, 0,
+		ath12k_dp_rx_bufs_replenish(ab, rx_ring, 0,
 					    ab->hw_params->hal_params->rx_buf_rbm,
 					    true);
 	}
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 7fef0e8f9d924..525a18ca557de 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/ieee80211.h>
@@ -256,7 +256,7 @@ static int ath12k_dp_purge_mon_ring(struct ath12k_base *ab)
 }
 
 /* Returns number of Rx buffers replenished */
-int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab, int mac_id,
+int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 				struct dp_rxdma_ring *rx_ring,
 				int req_entries,
 				enum hal_rx_buf_return_buf_manager mgr,
@@ -337,9 +337,7 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab, int mac_id,
 			spin_unlock_bh(&rx_ring->idr_lock);
 			if (buf_id < 0)
 				goto fail_dma_unmap;
-			cookie = u32_encode_bits(mac_id,
-						 DP_RXDMA_BUF_COOKIE_PDEV_ID) |
-				 u32_encode_bits(buf_id,
+			cookie = u32_encode_bits(buf_id,
 						 DP_RXDMA_BUF_COOKIE_BUF_ID);
 		}
 
@@ -437,7 +435,7 @@ static int ath12k_dp_rxdma_ring_buf_setup(struct ath12k_base *ab,
 	if ((ringtype == HAL_RXDMA_MONITOR_BUF) || (ringtype == HAL_TX_MONITOR_BUF))
 		ath12k_dp_mon_buf_replenish(ab, rx_ring, num_entries);
 	else
-		ath12k_dp_rx_bufs_replenish(ab, 0, rx_ring, num_entries,
+		ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_entries,
 					    ab->hw_params->hal_params->rx_buf_rbm,
 					    ringtype == HAL_RXDMA_BUF);
 	return 0;
@@ -2746,7 +2744,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int ring_id,
 		goto exit;
 
 	/* TODO: Move to implicit BM? */
-	ath12k_dp_rx_bufs_replenish(ab, 0, rx_ring, num_buffs_reaped,
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped,
 				    ab->hw_params->hal_params->rx_buf_rbm, true);
 
 	ath12k_dp_rx_process_received_packets(ab, napi, &msdu_list,
@@ -3527,7 +3525,7 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 
 	rx_ring = &dp->rx_refill_buf_ring;
 
-	ath12k_dp_rx_bufs_replenish(ab, 0, rx_ring, tot_n_bufs_reaped,
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, tot_n_bufs_reaped,
 				    ab->hw_params->hal_params->rx_buf_rbm, true);
 
 	return tot_n_bufs_reaped;
@@ -3867,7 +3865,7 @@ int ath12k_dp_rx_process_wbm_err(struct ath12k_base *ab,
 	if (!num_buffs_reaped)
 		goto done;
 
-	ath12k_dp_rx_bufs_replenish(ab, 0, rx_ring, num_buffs_reaped,
+	ath12k_dp_rx_bufs_replenish(ab, rx_ring, num_buffs_reaped,
 				    ab->hw_params->hal_params->rx_buf_rbm, true);
 
 	rcu_read_lock();
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index c955b5c859d14..ef1b172e685c9 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #ifndef ATH12K_DP_RX_H
 #define ATH12K_DP_RX_H
@@ -116,7 +116,7 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 int ath12k_dp_rx_process(struct ath12k_base *ab, int mac_id,
 			 struct napi_struct *napi,
 			 int budget);
-int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab, int mac_id,
+int ath12k_dp_rx_bufs_replenish(struct ath12k_base *ab,
 				struct dp_rxdma_ring *rx_ring,
 				int req_entries,
 				enum hal_rx_buf_return_buf_manager mgr,
-- 
2.53.0



