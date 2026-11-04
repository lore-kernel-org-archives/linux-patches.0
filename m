Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826780;
	b=FDcTnVFluBUXCErc96Myo0Kjx12ivgTmWGRClA3RYJc2L70MIIbr0CCicEFS0tLTC5A/
	 chqW7uTE9trnuXurJwx63s0VNwTZz1ScwkGF6CYV5o3WF1mFtzhbTBu4mRhG1XBDC+I/5
	 vLLR6HrGokl630AZxePPyO5wqCoGiBwhNNTpKLwamPYeOiy0ysy8YD4ncB96GpVKxm80S
	 zuGSAIptq8gWLkcsm7DgXDlMbB9Hg+UYzD6NhS70Q7qf6Yp+SuC8QuWUhdX4+wf+vyaSB
	 5W+e82NQdnb27R0XyOEEvD58zmJgtngX+49ICQcTSMzyf3yhJZVNZS+8tU6Ofgjb4VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MYC/GIFsiro7iQgnZORj+BJLNNeJkqaqhMXR2RZkphQ=;
	b=bBjhBg9KGaYXtQrm2H3gtikPP9xugXH/z0c5P1EnLY5cCoIGGMQDF74I114BngWi2qbI
	 X2H5xdpRZDudCdgt8Rps94vIjtAaHnG+gYic46rU0aQOC9IPUlnobVkdyCubtnOot0B+8
	 EBN79OAfzYlKVEOuJGuiAGqkv0k00Bn6m/Dzd3/V+4eRq3ZWSaBzDnTGDr+8+vVBVJpUS
	 ZJZBhikKYjlgO7EVSH77yhMN0Lx+9xcMIPXrLVcrKQgCVQCCcu79TNQqH4YBEdC/HWnZb
	 TkpqUR58UncDhWbZWEMfD4ym/aWJh4ip0+EtN/zNxMdcRe8LLk/9v0u6tbVWzj9MnhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gg5EU9MH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154026071A04;
	Wed,  4 Nov 2026 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gg5EU9MH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC271F00A16;
	Wed,  4 Nov 2026 21:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826779;
	bh=MYC/GIFsiro7iQgnZORj+BJLNNeJkqaqhMXR2RZkphQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gg5EU9MHRd27XvkHgstOqE3iD0YMKkIh278HTxXUqB/3Pja3el82AsNUOzGBnYaDQ
	 g0n37w2bGKwtW0SoBTYXzQJc/OOAY4RgYg0jrwNo9I75AEHQ/1g/prMFV4fGDOlRr2
	 nV//HFJzflaFWUas+Hnw8PErdEnAxtRLPI0K2a6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 008/547] wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
Date: Wed,  4 Nov 2026 16:03:12 -0500
Message-ID: <20261104211038.625164952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit eaff19e86c2dbde320ccc8812cafb0a366dc65f4 ]

Replace DP_TX_COMP_RING_SIZE macro with ath12k_dp_tx_comp_ring_size()
static inline helper. Pass the DP profile parameters explicitly to
improve type safety and make the interface explicit.

Update code using ATH12K_TX_COMPL_NEXT to pass ring size directly rather
than deriving it from the ath12k_base structure.
Also remove the unused DP_TX_IDR_SIZE macro.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-3-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c          | 10 +++++++---
 drivers/net/wireless/ath/ath12k/dp.h          | 11 +++++++----
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 12 +++++++-----
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index f9b37d75956d3..5980946d1e82f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -439,6 +439,7 @@ static void ath12k_dp_srng_common_cleanup(struct ath12k_base *ab)
 
 static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 {
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	const struct ath12k_hal_tcl_to_wbm_rbm_map *map;
 	struct hal_srng *srng;
@@ -469,7 +470,7 @@ static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 
 		ret = ath12k_dp_srng_setup(ab, &dp->tx_ring[i].tcl_comp_ring,
 					   HAL_WBM2SW_RELEASE, tx_comp_ring_num, 0,
-					   DP_TX_COMP_RING_SIZE(ab));
+					   ath12k_dp_tx_comp_ring_size(dp_params));
 		if (ret) {
 			ath12k_warn(ab, "failed to set up tcl_comp ring (%d) :%d\n",
 				    tx_comp_ring_num, ret);
@@ -1465,6 +1466,7 @@ static int ath12k_dp_reoq_lut_setup(struct ath12k_base *ab)
 
 static int ath12k_dp_setup(struct ath12k_base *ab)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_dp *dp;
 	struct hal_srng *srng = NULL;
 	size_t size = 0;
@@ -1474,6 +1476,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 
 	dp = ath12k_ab_to_dp(ab);
 	dp->ab = ab;
+	dp_params = &ab->profile_param->dp_params;
 
 	INIT_LIST_HEAD(&dp->reo_cmd_list);
 	INIT_LIST_HEAD(&dp->reo_cmd_cache_flush_list);
@@ -1528,7 +1531,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 		goto fail_dp_bank_profiles_cleanup;
 
 	size = ab->hal.hal_wbm_release_ring_tx_size *
-	       DP_TX_COMP_RING_SIZE(ab);
+	       ath12k_dp_tx_comp_ring_size(dp_params);
 
 	ret = ath12k_dp_reoq_lut_setup(ab);
 	if (ret) {
@@ -1540,7 +1543,8 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 		dp->tx_ring[i].tcl_data_ring_id = i;
 
 		dp->tx_ring[i].tx_status_head = 0;
-		dp->tx_ring[i].tx_status_tail = DP_TX_COMP_RING_SIZE(ab) - 1;
+		dp->tx_ring[i].tx_status_tail =
+			ath12k_dp_tx_comp_ring_size(dp_params) - 1;
 		dp->tx_ring[i].tx_status = kmalloc(size, GFP_KERNEL);
 		if (!dp->tx_ring[i].tx_status) {
 			ret = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 72d3de2db5d8e..6540b3453cc69 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -61,7 +61,7 @@ struct dp_rxdma_ring {
 	int bufs_max;
 };
 
-#define ATH12K_TX_COMPL_NEXT(ab, x)	(((x) + 1) % DP_TX_COMP_RING_SIZE(ab))
+#define ATH12K_TX_COMPL_NEXT(ring_size, x)	(((x) + 1) % (ring_size))
 
 struct dp_tx_ring {
 	u8 tcl_data_ring_id;
@@ -201,9 +201,6 @@ struct ath12k_pdev_dp {
 
 #define DP_WBM_RELEASE_RING_SIZE	64
 #define DP_TCL_DATA_RING_SIZE		512
-#define DP_TX_COMP_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.tx_comp_ring_size)
-#define DP_TX_IDR_SIZE(ab)		DP_TX_COMP_RING_SIZE(ab)
 #define DP_TCL_CMD_RING_SIZE		32
 #define DP_TCL_STATUS_RING_SIZE		32
 #define DP_REO_DST_RING_MAX		8
@@ -689,6 +686,12 @@ ath12k_dp_to_pdev_dp(struct ath12k_dp *dp, u8 pdev_idx)
 	return rcu_dereference(dp->dp_pdevs[pdev_idx]);
 }
 
+static inline u32
+ath12k_dp_tx_comp_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->tx_comp_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa5..e14f1d190ba8d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -922,12 +922,14 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 	u64 desc_va;
 	enum hal_wbm_rel_src_module buf_rel_source;
 	enum hal_wbm_tqm_rel_reason rel_status;
+	u32 ring_size;
 
 	spin_lock_bh(&status_ring->lock);
 
+	ring_size = ath12k_dp_tx_comp_ring_size(&ab->profile_param->dp_params);
 	ath12k_hal_srng_access_begin(ab, status_ring);
 
-	while (ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_head) !=
+	while (ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_head) !=
 	       tx_ring->tx_status_tail) {
 		desc = ath12k_hal_srng_dst_get_next_entry(ab, status_ring);
 		if (!desc)
@@ -936,11 +938,11 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		memcpy(&tx_ring->tx_status[tx_ring->tx_status_head],
 		       desc, sizeof(*desc));
 		tx_ring->tx_status_head =
-			ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_head);
+			ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_head);
 	}
 
 	if (ath12k_hal_srng_dst_peek(ab, status_ring) &&
-	    (ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_head) ==
+	    (ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_head) ==
 	     tx_ring->tx_status_tail)) {
 		/* TODO: Process pending tx_status messages when kfifo_is_full() */
 		ath12k_warn(ab, "Unable to process some of the tx_status ring desc because status_fifo is full\n");
@@ -950,13 +952,13 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 
 	spin_unlock_bh(&status_ring->lock);
 
-	while (ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_tail) !=
+	while (ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_tail) !=
 	       tx_ring->tx_status_head) {
 		struct hal_wbm_completion_ring_tx *tx_status;
 		u32 desc_id;
 
 		tx_ring->tx_status_tail =
-			ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_tail);
+			ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_tail);
 		tx_status = &tx_ring->tx_status[tx_ring->tx_status_tail];
 		ath12k_wifi7_dp_tx_status_parse(dp, tx_status, &ts);
 
-- 
2.53.0



