Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826797;
	b=WIxYtZEGKZUKGNDFFiDvUt+PZBOsIJQb9q5X2kG39nXYW12ZvmJTB0CFrVj/gJS49VNY
	 1WoqRyK13JBuR/RMz7fBF3QQqs98PV+wiXAXFH6kWnt9cvP9/m3G2tg76++YnUUdZ9xRp
	 whx3+9nUSoMn2ZXXOoDKg0ewGdHzApmjVlQaXXTr5S3W58YU5AxdzzCqZ+86iHMQUV1ly
	 lPboUJoULaXbau6ayLWOSK4Y3bQcH9Lf/8QlJ6H2R6vROmUACBF8VPhC1ryYt9HeGh5Ny
	 gm5ClL7s9/0WthDNgMWBoD9Yx0mSmpVC9O8CkRY7t583cKbiGvQVcH1BJIKS2JpTcbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ovG8OBWT5IzmayRkPH84YUULyZ94QKxq+u7aMsDHBFQ=;
	b=PnwiNqS/j/slECxP15W/fnNbhHaql29SLxHyqMJRGlgeIytsIQReWBFQtf2acL8gqPjj
	 4H82hSNGB36HpOUNcHh3Jj1cwI7YPD/V63KprLLes2ZFdm2HEQ7VWWjrhqorcrCji1ZDK
	 dQN2I9jbbxTpZe8tQWRrHbLD4eDdxc1mMUyzhc/pfZ9ZRwyBG0mG0nnxMA2Gqj6DApdV9
	 N7f3zFnA8akoxY9KQ62b2PILk2kpewwzs4O50UIV5Pz1IwIH9HiXQGn5MLV4H5gP1wKzY
	 q4+3wHZzAinwmtvn9WCA9AJI7sBvFizma26owrXg7R7xX+SYDbe7+qQxWtfheOVs3qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDJ6GOCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596FD606D810;
	Wed,  4 Nov 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDJ6GOCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8FC1F00A02;
	Wed,  4 Nov 2026 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826797;
	bh=ovG8OBWT5IzmayRkPH84YUULyZ94QKxq+u7aMsDHBFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDJ6GOCTETDBHPxpBnJ80j5RQojAKyqHvXWFlppNRiWBh1FLcXHweRxDet+0B3VnS
	 TNYjvU0LoSiD1yAL8hTYvI9CLuHfPyAlWkEnHSVdMVL/05iF8IJOWid2oNa729yBzq
	 7eHT4NwEDfjsDAXQ4Rw99fX7yLxwiGNnFwW3t/NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 011/547] wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
Date: Wed,  4 Nov 2026 16:03:15 -0500
Message-ID: <20261104211038.705510804@linuxfoundation.org>
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

[ Upstream commit 99b85a24189a518938eb0f1c4f8e15fbab4373ec ]

Replace ATH12K_NUM_POOL_TX_DESC with the ath12k_dp_num_pool_tx_desc()
static inline helper. Also replace ATH12K_TX_SPT_PAGES_PER_POOL,
ATH12K_NUM_TX_SPT_PAGES, and ATH12K_RX_SPT_PAGE_OFFSET, which are derived
from ATH12K_NUM_POOL_TX_DESC, with static inline helper functions.

Pass the DP profile parameters explicitly to improve type safety and
make the interface more explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-6-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c  | 55 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath12k/dp.h  | 32 ++++++++++++----
 drivers/net/wireless/ath/ath12k/mac.c |  5 ++-
 3 files changed, 61 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 5980946d1e82f..93a41b2440daa 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -967,14 +967,15 @@ void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif)
 
 static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 {
-	struct ath12k_rx_desc_info *desc_info;
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+	u32 pool_id, tx_spt_page, tx_spt_pages_per_pool;
 	struct ath12k_tx_desc_info *tx_desc_info, *tmp1;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_rx_desc_info *desc_info;
 	struct ath12k_skb_cb *skb_cb;
 	struct sk_buff *skb;
 	struct ath12k *ar;
 	int i, j;
-	u32 pool_id, tx_spt_page;
 
 	if (!dp->spt_info)
 		return;
@@ -1056,12 +1057,13 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 	}
 
 	if (dp->txbaddr) {
+		tx_spt_pages_per_pool = ath12k_dp_tx_spt_pages_per_pool(dp_params);
+
 		for (pool_id = 0; pool_id < ATH12K_HW_MAX_QUEUES; pool_id++) {
 			spin_lock_bh(&dp->tx_desc_lock[pool_id]);
 
-			for (i = 0; i < ATH12K_TX_SPT_PAGES_PER_POOL(ab); i++) {
-				tx_spt_page = i + pool_id *
-					      ATH12K_TX_SPT_PAGES_PER_POOL(ab);
+			for (i = 0; i < tx_spt_pages_per_pool; i++) {
+				tx_spt_page = i + pool_id * tx_spt_pages_per_pool;
 				if (!dp->txbaddr[tx_spt_page])
 					continue;
 
@@ -1155,13 +1157,15 @@ static void *ath12k_dp_cc_get_desc_addr_ptr(struct ath12k_dp *dp,
 struct ath12k_rx_desc_info *ath12k_dp_get_rx_desc(struct ath12k_dp *dp,
 						  u32 cookie)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_rx_desc_info **desc_addr_ptr;
 	u16 start_ppt_idx, end_ppt_idx, ppt_idx, spt_idx;
 
 	ppt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_PPT);
 	spt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_SPT);
+	dp_params = &dp->ab->profile_param->dp_params;
 
-	start_ppt_idx = dp->rx_ppt_base + ATH12K_RX_SPT_PAGE_OFFSET(dp->ab);
+	start_ppt_idx = dp->rx_ppt_base + ath12k_dp_rx_spt_page_offset(dp_params);
 	end_ppt_idx = start_ppt_idx + ATH12K_NUM_RX_SPT_PAGES(dp->ab);
 
 	if (ppt_idx < start_ppt_idx ||
@@ -1179,15 +1183,16 @@ EXPORT_SYMBOL(ath12k_dp_get_rx_desc);
 struct ath12k_tx_desc_info *ath12k_dp_get_tx_desc(struct ath12k_dp *dp,
 						  u32 cookie)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_tx_desc_info **desc_addr_ptr;
 	u16 start_ppt_idx, end_ppt_idx, ppt_idx, spt_idx;
 
 	ppt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_PPT);
 	spt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_SPT);
+	dp_params = &dp->ab->profile_param->dp_params;
 
 	start_ppt_idx = ATH12K_TX_SPT_PAGE_OFFSET;
-	end_ppt_idx = start_ppt_idx +
-		      (ATH12K_TX_SPT_PAGES_PER_POOL(dp->ab) * ATH12K_HW_MAX_QUEUES);
+	end_ppt_idx = start_ppt_idx + ath12k_dp_num_tx_spt_pages(dp_params);
 
 	if (ppt_idx < start_ppt_idx ||
 	    ppt_idx >= end_ppt_idx ||
@@ -1202,12 +1207,13 @@ EXPORT_SYMBOL(ath12k_dp_get_tx_desc);
 
 static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 {
-	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 	struct ath12k_rx_desc_info *rx_descs, **rx_desc_addr;
 	struct ath12k_tx_desc_info *tx_descs, **tx_desc_addr;
+	u32 i, j, pool_id, tx_spt_page, tx_spt_pages_per_pool;
 	u32 num_rx_spt_pages = ATH12K_NUM_RX_SPT_PAGES(ab);
-	u32 i, j, pool_id, tx_spt_page;
-	u32 ppt_idx, cookie_ppt_idx;
+	u32 ppt_idx, cookie_ppt_idx, rx_spt_page_offset;
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 
 	spin_lock_bh(&dp->rx_desc_lock);
 
@@ -1219,9 +1225,9 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 		return -ENOMEM;
 	}
 
-	/* First ATH12K_NUM_RX_SPT_PAGES(ab) of allocated SPT pages are used for
-	 * RX
-	 */
+	rx_spt_page_offset = ath12k_dp_rx_spt_page_offset(dp_params);
+
+	/* First num_rx_spt_pages of allocated SPT pages are used for RX */
 	for (i = 0; i < num_rx_spt_pages; i++) {
 		rx_descs = kzalloc_objs(*rx_descs, ATH12K_MAX_SPT_ENTRIES,
 					GFP_ATOMIC);
@@ -1231,7 +1237,7 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 			return -ENOMEM;
 		}
 
-		ppt_idx = ATH12K_RX_SPT_PAGE_OFFSET(ab) + i;
+		ppt_idx = rx_spt_page_offset + i;
 		cookie_ppt_idx = dp->rx_ppt_base + ppt_idx;
 		dp->rxbaddr[i] = &rx_descs[0];
 
@@ -1250,14 +1256,17 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 	spin_unlock_bh(&dp->rx_desc_lock);
 
 	dp->txbaddr = kzalloc_objs(struct ath12k_tx_desc_info *,
-				   ATH12K_NUM_TX_SPT_PAGES(ab), GFP_ATOMIC);
+				   ath12k_dp_num_tx_spt_pages(dp_params),
+				   GFP_ATOMIC);
 
 	if (!dp->txbaddr)
 		return -ENOMEM;
 
+	tx_spt_pages_per_pool = ath12k_dp_tx_spt_pages_per_pool(dp_params);
+
 	for (pool_id = 0; pool_id < ATH12K_HW_MAX_QUEUES; pool_id++) {
 		spin_lock_bh(&dp->tx_desc_lock[pool_id]);
-		for (i = 0; i < ATH12K_TX_SPT_PAGES_PER_POOL(ab); i++) {
+		for (i = 0; i < tx_spt_pages_per_pool; i++) {
 			tx_descs = kzalloc_objs(*tx_descs,
 						ATH12K_MAX_SPT_ENTRIES,
 						GFP_ATOMIC);
@@ -1268,8 +1277,7 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 				return -ENOMEM;
 			}
 
-			tx_spt_page = i + pool_id *
-				      ATH12K_TX_SPT_PAGES_PER_POOL(ab);
+			tx_spt_page = i + pool_id * tx_spt_pages_per_pool;
 			ppt_idx = ATH12K_TX_SPT_PAGE_OFFSET + tx_spt_page;
 
 			dp->txbaddr[tx_spt_page] = &tx_descs[0];
@@ -1295,6 +1303,7 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 			       struct ath12k_dp *dp,
 			       enum ath12k_dp_desc_type type)
 {
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 	u32 cmem_base;
 	int i, start, end;
 
@@ -1303,11 +1312,11 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 	switch (type) {
 	case ATH12K_DP_TX_DESC:
 		start = ATH12K_TX_SPT_PAGE_OFFSET;
-		end = start + ATH12K_NUM_TX_SPT_PAGES(ab);
+		end = start + ath12k_dp_num_tx_spt_pages(dp_params);
 		break;
 	case ATH12K_DP_RX_DESC:
 		cmem_base += ATH12K_PPT_ADDR_OFFSET(dp->rx_ppt_base);
-		start = ATH12K_RX_SPT_PAGE_OFFSET(ab);
+		start = ath12k_dp_rx_spt_page_offset(dp_params);
 		end = start + ATH12K_NUM_RX_SPT_PAGES(ab);
 		break;
 	default:
@@ -1338,7 +1347,9 @@ void ath12k_dp_partner_cc_init(struct ath12k_base *ab)
 
 static u32 ath12k_dp_get_num_spt_pages(struct ath12k_base *ab)
 {
-	return ATH12K_NUM_RX_SPT_PAGES(ab) + ATH12K_NUM_TX_SPT_PAGES(ab);
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+
+	return ATH12K_NUM_RX_SPT_PAGES(ab) + ath12k_dp_num_tx_spt_pages(dp_params);
 }
 
 static int ath12k_dp_cc_init(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index a7cd2535866bd..7e48379d18a0f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -249,8 +249,6 @@ struct ath12k_pdev_dp {
 #define ATH12K_SHADOW_DP_TIMER_INTERVAL 20
 #define ATH12K_SHADOW_CTRL_TIMER_INTERVAL 10
 
-#define ATH12K_NUM_POOL_TX_DESC(ab) \
-	((ab)->profile_param->dp_params.num_pool_tx_desc)
 /* TODO: revisit this count during testing */
 #define ATH12K_RX_DESC_COUNT(ab) \
 	((ab)->profile_param->dp_params.rx_desc_count)
@@ -268,13 +266,7 @@ struct ath12k_pdev_dp {
 #define ATH12K_NUM_RX_SPT_PAGES(ab)	((ATH12K_RX_DESC_COUNT(ab)) / \
 					  ATH12K_MAX_SPT_ENTRIES)
 
-#define ATH12K_TX_SPT_PAGES_PER_POOL(ab) (ATH12K_NUM_POOL_TX_DESC(ab) / \
-					  ATH12K_MAX_SPT_ENTRIES)
-#define ATH12K_NUM_TX_SPT_PAGES(ab)	(ATH12K_TX_SPT_PAGES_PER_POOL(ab) * \
-					 ATH12K_HW_MAX_QUEUES)
-
 #define ATH12K_TX_SPT_PAGE_OFFSET 0
-#define ATH12K_RX_SPT_PAGE_OFFSET(ab) ATH12K_NUM_TX_SPT_PAGES(ab)
 
 /* The SPT pages are divided for RX and TX, first block for RX
  * and remaining for TX
@@ -700,6 +692,30 @@ ath12k_dp_rxdma_monitor_dst_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rxdma_monitor_dst_ring_size;
 }
 
+static inline u32
+ath12k_dp_num_pool_tx_desc(const struct ath12k_dp_profile_params *p)
+{
+	return p->num_pool_tx_desc;
+}
+
+static inline u32
+ath12k_dp_tx_spt_pages_per_pool(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_num_pool_tx_desc(p) / ATH12K_MAX_SPT_ENTRIES;
+}
+
+static inline u32
+ath12k_dp_num_tx_spt_pages(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_tx_spt_pages_per_pool(p) * ATH12K_HW_MAX_QUEUES;
+}
+
+static inline u32
+ath12k_dp_rx_spt_page_offset(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_num_tx_spt_pages(p);
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf79d102..a997e888feb56 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9732,6 +9732,7 @@ static int ath12k_mac_config_mon_status_default(struct ath12k *ar, bool enable)
 
 static int ath12k_mac_start(struct ath12k *ar)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_hw *ah = ar->ah;
 	struct ath12k_base *ab = ar->ab;
 	struct ath12k_pdev *pdev = ar->pdev;
@@ -9740,6 +9741,8 @@ static int ath12k_mac_start(struct ath12k *ar)
 	lockdep_assert_held(&ah->hw_mutex);
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
+	dp_params = &ab->profile_param->dp_params;
+
 	ret = ath12k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS,
 					1, pdev->pdev_id);
 
@@ -9788,7 +9791,7 @@ static int ath12k_mac_start(struct ath12k *ar)
 	if (ab->hw_params->supports_cong_ctrl_max_msdus) {
 		ret = ath12k_wmi_pdev_set_param(ar,
 						WMI_PDEV_PARAM_SET_CONG_CTRL_MAX_MSDUS,
-						ATH12K_NUM_POOL_TX_DESC(ab),
+						ath12k_dp_num_pool_tx_desc(dp_params),
 						pdev->pdev_id);
 		if (ret) {
 			ath12k_err(ab,
-- 
2.53.0



