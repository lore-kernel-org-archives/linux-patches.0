Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283382FE56A;
	Tue, 21 Jul 2026 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657782; cv=none; b=N8qzss9Wi1RfSKWHkwDP2KpFIBzvtjSZQQCd7BGcMWRu3y2PzzKgnn/fNj209PnVADz9fY1r7gPy5nTDaTEe0KWpoYAybkU/QXJmVDCV1QOn/F1fwh+4Z+AEIq/u+0RCsBg8z1xF8v83/hQw5Ab9oBjfKSIhwmTY5ry1cep9vrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657782; c=relaxed/simple;
	bh=g9dpRrw0MPuD63GDsSoZwxLZ8QPSFpFl+HemNx/igUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKaHxvJ08sST1G6Ob5nlSnrCOtHbEpg+ZCKhPrpv/8eR/njtuqMp+1XjsjdXLO6uxBs6wqsi/i2X04fLy0bAmOouOwk/DJ0FuaiBHPl81Ww4z4xHiufbl35MR6+j/hyt6A6lwWwHMzUeCJqxLZ7vVvvrrWlgwieeEKwf4hxGW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKfQ6Oyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKfQ6Oyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EB51F000E9;
	Tue, 21 Jul 2026 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657781;
	bh=yiJraoXRXe1Hasgx7nDVumNYLRB9SyMEOT3C7M5QIwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKfQ6Oyd50bCV3/IK7AYX525anNAkiDer4v89nfPrCjRebrjhR3TumdfVJtkL0zgK
	 WMkw8/+K2DehGePQOei3SqVMKnhoERX9cNQo7d2dNKsAkpfA9yy6ZlPdmzdaZLObVK
	 7hJ3f69mGZ661dYdgiTd0ODEoY0JAER06RQ9C1Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0896/1611] eth: bnxt: rename ring_err_stats -> ring_drv_stats
Date: Tue, 21 Jul 2026 17:16:52 +0200
Message-ID: <20260721152535.543893513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2dece9aad5b95a..d0e37a09466499 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13159,7 +13159,7 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	/* Save ring stats before shutdown */
 	if (bp->bnapi && irq_re_init) {
 		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
-		bnxt_get_ring_err_stats(bp, &bp->ring_err_stats_prev);
+		bnxt_get_ring_drv_stats(bp, &bp->ring_drv_stats_prev);
 	}
 	if (irq_re_init) {
 		bnxt_free_irq(bp);
@@ -13404,8 +13404,8 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 }
 
-static void bnxt_get_one_ring_err_stats(struct bnxt *bp,
-					struct bnxt_total_ring_err_stats *stats,
+static void bnxt_get_one_ring_drv_stats(struct bnxt *bp,
+					struct bnxt_total_ring_drv_stats *stats,
 					struct bnxt_cp_ring_info *cpr)
 {
 	struct bnxt_sw_stats *sw_stats = cpr->sw_stats;
@@ -13426,13 +13426,13 @@ static void bnxt_get_one_ring_err_stats(struct bnxt *bp,
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
@@ -15887,9 +15887,9 @@ static void bnxt_get_base_stats(struct net_device *dev,
 
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
index b326a814b1f7a7..9c9212ecd8c744 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1144,7 +1144,7 @@ struct bnxt_sw_stats {
 	struct bnxt_cmn_sw_stats cmn;
 };
 
-struct bnxt_total_ring_err_stats {
+struct bnxt_total_ring_drv_stats {
 	u64			rx_total_l4_csum_errors;
 	u64			rx_total_resets;
 	u64			rx_total_buf_errors;
@@ -2562,7 +2562,7 @@ struct bnxt {
 	u8			pri2cos_idx[8];
 	u8			pri2cos_valid;
 
-	struct bnxt_total_ring_err_stats ring_err_stats_prev;
+	struct bnxt_total_ring_drv_stats ring_drv_stats_prev;
 
 	u16			hwrm_max_req_len;
 	u16			hwrm_max_ext_req_len;
@@ -2963,8 +2963,8 @@ int bnxt_half_open_nic(struct bnxt *bp);
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
index 3237515f0e7ec8..8d10bf22480f69 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -340,7 +340,7 @@ enum {
 	RX_NETPOLL_DISCARDS,
 };
 
-static const char *const bnxt_ring_err_stats_arr[] = {
+static const char *const bnxt_ring_drv_stats_arr[] = {
 	"rx_total_l4_csum_errors",
 	"rx_total_resets",
 	"rx_total_buf_errors",
@@ -500,7 +500,7 @@ static const struct {
 	BNXT_TX_STATS_PRI_ENTRIES(tx_packets),
 };
 
-#define BNXT_NUM_RING_ERR_STATS	ARRAY_SIZE(bnxt_ring_err_stats_arr)
+#define BNXT_NUM_RING_DRV_STATS	ARRAY_SIZE(bnxt_ring_drv_stats_arr)
 #define BNXT_NUM_PORT_STATS ARRAY_SIZE(bnxt_port_stats_arr)
 #define BNXT_NUM_STATS_PRI			\
 	(ARRAY_SIZE(bnxt_rx_bytes_pri_arr) +	\
@@ -539,7 +539,7 @@ static int bnxt_get_num_stats(struct bnxt *bp)
 	int num_stats = bnxt_get_num_ring_stats(bp);
 	int len;
 
-	num_stats += BNXT_NUM_RING_ERR_STATS;
+	num_stats += BNXT_NUM_RING_DRV_STATS;
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS)
 		num_stats += BNXT_NUM_PORT_STATS;
@@ -594,7 +594,7 @@ static bool is_tx_ring(struct bnxt *bp, int ring_num)
 static void bnxt_get_ethtool_stats(struct net_device *dev,
 				   struct ethtool_stats *stats, u64 *buf)
 {
-	struct bnxt_total_ring_err_stats ring_err_stats = {0};
+	struct bnxt_total_ring_drv_stats ring_drv_stats = {0};
 	struct bnxt *bp = netdev_priv(dev);
 	u64 *curr, *prev;
 	u32 tpa_stats;
@@ -643,12 +643,12 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
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
@@ -752,8 +752,8 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
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



