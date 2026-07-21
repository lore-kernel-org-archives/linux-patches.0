Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9B946E005;
	Tue, 21 Jul 2026 19:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662952; cv=none; b=KwSJ3Y7HWENY813+N3MSRIsty/8lYmidhKsOvwoC+d7rOmsYmOyPa8r2JCO3Xwfsv2yauB6NP5o/SelMtYt1ZZ4E3dC80nVgF497y6vP8Pls2l53IOHEKRPi70v8ijQ3fxEs0gEjFb8nE+zgxCyxZpaO7lC+n7LNdtyk5+8BYrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662952; c=relaxed/simple;
	bh=/qNuTP/YwCJrPMGIFvq7HW9pP4leZgK/tp1nETkFiTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVCvIgTiPRX9S5PYmqXXg9UnW4qL6ayIcoPPCl4TW6Tpf5I6sA/kDAdQppY9XdWqBLbYBuwWaVF+vCC6IZNUsUJvGa6WMTsNnU5W2GxfIUAAsMI2RVIEzBi9kPZ16zJG3Os1F8IM7CBa4LAPQTU5CHp2u7msy/JXCZs6W1galdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLPCTJ0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLPCTJ0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A421F000E9;
	Tue, 21 Jul 2026 19:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662951;
	bh=Oem466lbb90gVX9Bt9PC4xHzCQ4JXNIZW6WeaDocSQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLPCTJ0chbS6XKeQPSDiKdYDStQqhnQJG4/A121/QDENcgorvRSwy/6GMr6yjSBN4
	 jEN5bp9pE1ZVSgczcyMzchEpJkp7/esb5x7zH+qGNdbs/70bs0pwwUCPZxT8X+vafJ
	 xwwulT2rlYvf92UFjlt0CJ0iezyjR5n/E1lglrsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0637/1276] eth: bnxt: rename ring_err_stats -> ring_drv_stats
Date: Tue, 21 Jul 2026 17:18:00 +0200
Message-ID: <20260721152500.365877306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6c32b07650676ab4c112ff8e9d345b6770ae2be5 ]

We recently added GRO stats to bnxt, which are maintained
by the driver. Having "err" in the name of the struct for
ring stats no longer makes sense (as pointed out by Michael,
see Link).

Rename them to "drv" stats, as these are all maintained
by the driver (even if partially based on info from descriptors).
Michael suggested calling these misc, happy to go back to
that. IMHO "drv" is a bit more meaningful that "misc".

Pure rename using sed, no functional changes.

Link: https://lore.kernel.org/CACKFLimgibJ0qkM1AacZVh8MKKy-pE_AAc4KPKZ7GUqebmXW9A@mail.gmail.com
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260223203702.4137801-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 40529e58629b ("eth: bnxt: improve the timing of stats")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 18 ++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  8 ++++----
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 20 +++++++++----------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b0a89a5df73777..68f338815ff9ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12557,7 +12557,7 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	/* Save ring stats before shutdown */
 	if (bp->bnapi && irq_re_init) {
 		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
-		bnxt_get_ring_err_stats(bp, &bp->ring_err_stats_prev);
+		bnxt_get_ring_drv_stats(bp, &bp->ring_drv_stats_prev);
 	}
 	if (irq_re_init) {
 		bnxt_free_irq(bp);
@@ -12807,8 +12807,8 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 }
 
-static void bnxt_get_one_ring_err_stats(struct bnxt *bp,
-					struct bnxt_total_ring_err_stats *stats,
+static void bnxt_get_one_ring_drv_stats(struct bnxt *bp,
+					struct bnxt_total_ring_drv_stats *stats,
 					struct bnxt_cp_ring_info *cpr)
 {
 	struct bnxt_sw_stats *sw_stats = cpr->sw_stats;
@@ -12829,13 +12829,13 @@ static void bnxt_get_one_ring_err_stats(struct bnxt *bp,
 	stats->total_missed_irqs += sw_stats->cmn.missed_irqs;
 }
 
-void bnxt_get_ring_err_stats(struct bnxt *bp,
-			     struct bnxt_total_ring_err_stats *stats)
+void bnxt_get_ring_drv_stats(struct bnxt *bp,
+			     struct bnxt_total_ring_drv_stats *stats)
 {
 	int i;
 
 	for (i = 0; i < bp->cp_nr_rings; i++)
-		bnxt_get_one_ring_err_stats(bp, stats, &bp->bnapi[i]->cp_ring);
+		bnxt_get_one_ring_drv_stats(bp, stats, &bp->bnapi[i]->cp_ring);
 }
 
 static bool bnxt_mc_list_updated(struct bnxt *bp, u32 *rx_mask)
@@ -15267,9 +15267,9 @@ static void bnxt_get_base_stats(struct net_device *dev,
 
 	rx->packets = bp->net_stats_prev.rx_packets;
 	rx->bytes = bp->net_stats_prev.rx_bytes;
-	rx->alloc_fail = bp->ring_err_stats_prev.rx_total_oom_discards;
-	rx->hw_gro_packets = bp->ring_err_stats_prev.rx_total_hw_gro_packets;
-	rx->hw_gro_wire_packets = bp->ring_err_stats_prev.rx_total_hw_gro_wire_packets;
+	rx->alloc_fail = bp->ring_drv_stats_prev.rx_total_oom_discards;
+	rx->hw_gro_packets = bp->ring_drv_stats_prev.rx_total_hw_gro_packets;
+	rx->hw_gro_wire_packets = bp->ring_drv_stats_prev.rx_total_hw_gro_wire_packets;
 
 	tx->packets = bp->net_stats_prev.tx_packets;
 	tx->bytes = bp->net_stats_prev.tx_bytes;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1e673df55c5edf..2cd96fe055a6e6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1134,7 +1134,7 @@ struct bnxt_sw_stats {
 	struct bnxt_cmn_sw_stats cmn;
 };
 
-struct bnxt_total_ring_err_stats {
+struct bnxt_total_ring_drv_stats {
 	u64			rx_total_l4_csum_errors;
 	u64			rx_total_resets;
 	u64			rx_total_buf_errors;
@@ -2479,7 +2479,7 @@ struct bnxt {
 	u8			pri2cos_idx[8];
 	u8			pri2cos_valid;
 
-	struct bnxt_total_ring_err_stats ring_err_stats_prev;
+	struct bnxt_total_ring_drv_stats ring_drv_stats_prev;
 
 	u16			hwrm_max_req_len;
 	u16			hwrm_max_ext_req_len;
@@ -2864,8 +2864,8 @@ int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 void bnxt_reenable_sriov(struct bnxt *bp);
 void bnxt_close_nic(struct bnxt *, bool, bool);
-void bnxt_get_ring_err_stats(struct bnxt *bp,
-			     struct bnxt_total_ring_err_stats *stats);
+void bnxt_get_ring_drv_stats(struct bnxt *bp,
+			     struct bnxt_total_ring_drv_stats *stats);
 bool bnxt_rfs_capable(struct bnxt *bp, bool new_rss_ctx);
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
 			 u32 *reg_buf);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9833d0a0b83861..4c18a310cf00c9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -339,7 +339,7 @@ enum {
 	RX_NETPOLL_DISCARDS,
 };
 
-static const char *const bnxt_ring_err_stats_arr[] = {
+static const char *const bnxt_ring_drv_stats_arr[] = {
 	"rx_total_l4_csum_errors",
 	"rx_total_resets",
 	"rx_total_buf_errors",
@@ -499,7 +499,7 @@ static const struct {
 	BNXT_TX_STATS_PRI_ENTRIES(tx_packets),
 };
 
-#define BNXT_NUM_RING_ERR_STATS	ARRAY_SIZE(bnxt_ring_err_stats_arr)
+#define BNXT_NUM_RING_DRV_STATS	ARRAY_SIZE(bnxt_ring_drv_stats_arr)
 #define BNXT_NUM_PORT_STATS ARRAY_SIZE(bnxt_port_stats_arr)
 #define BNXT_NUM_STATS_PRI			\
 	(ARRAY_SIZE(bnxt_rx_bytes_pri_arr) +	\
@@ -538,7 +538,7 @@ static int bnxt_get_num_stats(struct bnxt *bp)
 	int num_stats = bnxt_get_num_ring_stats(bp);
 	int len;
 
-	num_stats += BNXT_NUM_RING_ERR_STATS;
+	num_stats += BNXT_NUM_RING_DRV_STATS;
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS)
 		num_stats += BNXT_NUM_PORT_STATS;
@@ -593,7 +593,7 @@ static bool is_tx_ring(struct bnxt *bp, int ring_num)
 static void bnxt_get_ethtool_stats(struct net_device *dev,
 				   struct ethtool_stats *stats, u64 *buf)
 {
-	struct bnxt_total_ring_err_stats ring_err_stats = {0};
+	struct bnxt_total_ring_drv_stats ring_drv_stats = {0};
 	struct bnxt *bp = netdev_priv(dev);
 	u64 *curr, *prev;
 	u32 tpa_stats;
@@ -642,12 +642,12 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			buf[j] = sw[k];
 	}
 
-	bnxt_get_ring_err_stats(bp, &ring_err_stats);
+	bnxt_get_ring_drv_stats(bp, &ring_drv_stats);
 
 skip_ring_stats:
-	curr = &ring_err_stats.rx_total_l4_csum_errors;
-	prev = &bp->ring_err_stats_prev.rx_total_l4_csum_errors;
-	for (i = 0; i < BNXT_NUM_RING_ERR_STATS; i++, j++, curr++, prev++)
+	curr = &ring_drv_stats.rx_total_l4_csum_errors;
+	prev = &bp->ring_drv_stats_prev.rx_total_l4_csum_errors;
+	for (i = 0; i < BNXT_NUM_RING_DRV_STATS; i++, j++, curr++, prev++)
 		buf[j] = *curr + *prev;
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
@@ -751,8 +751,8 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				ethtool_sprintf(&buf, "[%d]: %s", i, str);
 			}
 		}
-		for (i = 0; i < BNXT_NUM_RING_ERR_STATS; i++)
-			ethtool_puts(&buf, bnxt_ring_err_stats_arr[i]);
+		for (i = 0; i < BNXT_NUM_RING_DRV_STATS; i++)
+			ethtool_puts(&buf, bnxt_ring_drv_stats_arr[i]);
 
 		if (bp->flags & BNXT_FLAG_PORT_STATS)
 			for (i = 0; i < BNXT_NUM_PORT_STATS; i++) {
-- 
2.53.0



