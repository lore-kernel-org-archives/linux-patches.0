Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826794;
	b=zE62Bj3aNliydvTaKMZ+I7dQvF0jCofPCyRWs3nT36mO54n0NUhfAIUjpkdZ8g0MAzVg
	 sfOp9EdOthAZbOPzO1c5SttSlNRIkCTFUzYp+qfwFgdcvo87z3gSX7ecPyc4mwkMqZU3M
	 KIzBDbBt5Ynd70sS5Kc91W/cpk8qDO3WS8nVNlzy9TY4fQzJzi5j3hBu1MAd6tCmJAwQt
	 PGm25QVb7uTHnFHbu+uqzm2/jTzQQfWoY70sDdFUp7w4rNHhgbmdcsi2qmhIK63JmgcC2
	 zUb4N7CPPw5vv9gOWXzJeUDRq5Jri3Lp7/tXtTjkeCIXl2FkP4yNqqKSJSR95GzbvDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lO0hBKd2MOEAikY5wOkkiaGdriEKotm4r/r3DaDJo0o=;
	b=aMIrPmq/kbvIHi2RqnNGj15DSu2F30R5gj/HNjhVJ7Zz4XB7+iaJZtxOx9x68cK5qvmD
	 z3XA0SWBpTjGbQAPh76IdTxBPgy1w9JKcgHDqtR/7k5e9rSRRu7n4pmcOoGf4Upmt/bdo
	 eN0bB4sTZCs8TT9EhLwygPGrArzMVYwEdhttD8Ui1lvnNKZqZk8NIWn27aI6681xaSv9R
	 oCHtDkCpWAoYwwSIU6SOjL0tqehTDINNU6cPGRdHOA8crNf7LcXZhoQssJXj4IgewoG/5
	 XwpYLcJ84MeihdaB/Si7l5gnMiP2saXRhch5ksXHae/NSUGeb8LYT9QEvs5FnwOUbwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueBAQ79N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF666071A00;
	Wed,  4 Nov 2026 21:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueBAQ79N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D921F00919;
	Wed,  4 Nov 2026 21:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826793;
	bh=lO0hBKd2MOEAikY5wOkkiaGdriEKotm4r/r3DaDJo0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueBAQ79NKCI1XrjNw0BlOb9C8P3i1GPl1k1lmOuK2GlSISlhk5gC0L7T4JXE0RQTo
	 +9Wz2FJp2WIfjh3D9iGQeF4EfSzj+nCyxwDFYONPlu54sdbpjKpNZA+jlTXxRLuFL/
	 iAmGtlpWUQ5VrPocPs0WXT11/AVGfHI8NJVaCYo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 012/547] wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
Date: Wed,  4 Nov 2026 16:03:16 -0500
Message-ID: <20261104211038.731242047@linuxfoundation.org>
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

[ Upstream commit fafb9b0450fd6fd3618daf347717a6d6320bea38 ]

Replace ATH12K_RX_DESC_COUNT with ath12k_dp_rx_desc_count() static inline
helper, also replace ATH12K_NUM_RX_SPT_PAGES which is calculated from
ATH12K_RX_DESC_COUNT into static inline helper functions and pass the DP
profile parameters explicitly to improve type safety and make the interface
explicit.

Also remove the unused ATH12K_NUM_TX_SPT_PAGE_START macro.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-7-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 18 +++++++++++-------
 drivers/net/wireless/ath/ath12k/dp.h | 24 ++++++++++++------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 93a41b2440daa..417d960bbd07d 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -968,7 +968,7 @@ void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif)
 static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
-	u32 pool_id, tx_spt_page, tx_spt_pages_per_pool;
+	u32 pool_id, tx_spt_page, tx_spt_pages_per_pool, num_rx_spt_pages;
 	struct ath12k_tx_desc_info *tx_desc_info, *tmp1;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct ath12k_rx_desc_info *desc_info;
@@ -983,8 +983,10 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 	/* RX Descriptor cleanup */
 	spin_lock_bh(&dp->rx_desc_lock);
 
+	num_rx_spt_pages = ath12k_dp_num_rx_spt_pages(dp_params);
+
 	if (dp->rxbaddr) {
-		for (i = 0; i < ATH12K_NUM_RX_SPT_PAGES(ab); i++) {
+		for (i = 0; i < num_rx_spt_pages; i++) {
 			if (!dp->rxbaddr[i])
 				continue;
 
@@ -1166,7 +1168,7 @@ struct ath12k_rx_desc_info *ath12k_dp_get_rx_desc(struct ath12k_dp *dp,
 	dp_params = &dp->ab->profile_param->dp_params;
 
 	start_ppt_idx = dp->rx_ppt_base + ath12k_dp_rx_spt_page_offset(dp_params);
-	end_ppt_idx = start_ppt_idx + ATH12K_NUM_RX_SPT_PAGES(dp->ab);
+	end_ppt_idx = start_ppt_idx + ath12k_dp_num_rx_spt_pages(dp_params);
 
 	if (ppt_idx < start_ppt_idx ||
 	    ppt_idx >= end_ppt_idx ||
@@ -1208,10 +1210,10 @@ EXPORT_SYMBOL(ath12k_dp_get_tx_desc);
 static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+	u32 num_rx_spt_pages = ath12k_dp_num_rx_spt_pages(dp_params);
 	struct ath12k_rx_desc_info *rx_descs, **rx_desc_addr;
 	struct ath12k_tx_desc_info *tx_descs, **tx_desc_addr;
 	u32 i, j, pool_id, tx_spt_page, tx_spt_pages_per_pool;
-	u32 num_rx_spt_pages = ATH12K_NUM_RX_SPT_PAGES(ab);
 	u32 ppt_idx, cookie_ppt_idx, rx_spt_page_offset;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 
@@ -1317,7 +1319,7 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 	case ATH12K_DP_RX_DESC:
 		cmem_base += ATH12K_PPT_ADDR_OFFSET(dp->rx_ppt_base);
 		start = ath12k_dp_rx_spt_page_offset(dp_params);
-		end = start + ATH12K_NUM_RX_SPT_PAGES(ab);
+		end = start + ath12k_dp_num_rx_spt_pages(dp_params);
 		break;
 	default:
 		ath12k_err(ab, "invalid descriptor type %d in cmem init\n", type);
@@ -1349,7 +1351,8 @@ static u32 ath12k_dp_get_num_spt_pages(struct ath12k_base *ab)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 
-	return ATH12K_NUM_RX_SPT_PAGES(ab) + ath12k_dp_num_tx_spt_pages(dp_params);
+	return ath12k_dp_num_rx_spt_pages(dp_params) +
+	       ath12k_dp_num_tx_spt_pages(dp_params);
 }
 
 static int ath12k_dp_cc_init(struct ath12k_base *ab)
@@ -1377,7 +1380,8 @@ static int ath12k_dp_cc_init(struct ath12k_base *ab)
 		return -ENOMEM;
 	}
 
-	dp->rx_ppt_base = ab->device_id * ATH12K_NUM_RX_SPT_PAGES(ab);
+	dp->rx_ppt_base = ab->device_id *
+			  ath12k_dp_num_rx_spt_pages(&ab->profile_param->dp_params);
 
 	for (i = 0; i < dp->num_spt_pages; i++) {
 		dp->spt_info[i].vaddr = dma_alloc_coherent(ab->dev,
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 7e48379d18a0f..c8ca3ab4d5e1a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -249,10 +249,6 @@ struct ath12k_pdev_dp {
 #define ATH12K_SHADOW_DP_TIMER_INTERVAL 20
 #define ATH12K_SHADOW_CTRL_TIMER_INTERVAL 10
 
-/* TODO: revisit this count during testing */
-#define ATH12K_RX_DESC_COUNT(ab) \
-	((ab)->profile_param->dp_params.rx_desc_count)
-
 #define ATH12K_PAGE_SIZE	PAGE_SIZE
 
 /* Total 1024 entries in PPT, i.e 4K/4 considering 4K aligned
@@ -263,16 +259,8 @@ struct ath12k_pdev_dp {
 /* Total 512 entries in a SPT, i.e 4K Page/8 */
 #define ATH12K_MAX_SPT_ENTRIES	512
 
-#define ATH12K_NUM_RX_SPT_PAGES(ab)	((ATH12K_RX_DESC_COUNT(ab)) / \
-					  ATH12K_MAX_SPT_ENTRIES)
-
 #define ATH12K_TX_SPT_PAGE_OFFSET 0
 
-/* The SPT pages are divided for RX and TX, first block for RX
- * and remaining for TX
- */
-#define ATH12K_NUM_TX_SPT_PAGE_START(ab) ATH12K_NUM_RX_SPT_PAGES(ab)
-
 #define ATH12K_DP_RX_DESC_MAGIC	0xBABABABA
 
 /* 4K aligned address have last 12 bits set to 0, this check is done
@@ -716,6 +704,18 @@ ath12k_dp_rx_spt_page_offset(const struct ath12k_dp_profile_params *p)
 	return ath12k_dp_num_tx_spt_pages(p);
 }
 
+static inline u32
+ath12k_dp_rx_desc_count(const struct ath12k_dp_profile_params *p)
+{
+	return p->rx_desc_count;
+}
+
+static inline u32
+ath12k_dp_num_rx_spt_pages(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_rx_desc_count(p) / ATH12K_MAX_SPT_ENTRIES;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
-- 
2.53.0



