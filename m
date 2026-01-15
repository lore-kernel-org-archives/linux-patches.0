Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC923B9619;
	Thu, 15 Jan 2026 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496231; cv=none; b=M8iCObwcMSZV5r0Rc1UmEkIAglO0hTef39OMyoYIN/3YBcG2wDhC82P31+LkVxXQ7GbV9oJciE/vgH19Zz7YjOCEieyVs3AM1o/TRMa1FEW+Qoi3Evv5TMrOevTAaPO8uB1nKJMd6QlGSpeDmWGsuCxumKyMQQ0BZRQeA6gqPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496231; c=relaxed/simple;
	bh=1cg6X4vpWBTYdLbPSANOv68BHZxaDH9nPwXKHXJNhpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjWO5rzZ3HOvPLsI0DH7mfNUP0ZhoSj9aW464ba+olOUCXs5A6Q/BQcVaAicxrE/WQ3Ec18Al1J4rmcg6OcJu/JN6QAEoWIXXv3/SQdpZO4mFI5tZqsg2bzTu785aXdViuNkwdVGj6oVtxamCPn/+5eBqCuruk/347NcLslzx20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4Jo/XvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4Jo/XvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6C3C116D0;
	Thu, 15 Jan 2026 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496231;
	bh=1cg6X4vpWBTYdLbPSANOv68BHZxaDH9nPwXKHXJNhpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4Jo/XvR/cwu8YlLS3y0aYPHBTBlxp/ky4WYl4kkjoD0AfAxVc0+9lWu52WOhMEwr
	 agl+nvHrDLDsQ4PNefylzPCKZgEnHTHAv+1I0ycuZIotNgEgw7Lz0YHqxV8Xe+uxe8
	 Gwui5wjEner54zfQPQhhcDRcX3aRD6UdbDs8DCYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Chittim Madhu <madhu.chittim@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/181] idpf: convert vport state to bitmap
Date: Thu, 15 Jan 2026 17:47:41 +0100
Message-ID: <20260115164206.790264849@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 8dd72ebc73f37b216410db17340f15e6fb2cdb7b ]

Convert vport state to a bitmap and remove the DOWN state which is
redundant in the existing logic. There are no functional changes aside
from the use of bitwise operations when setting and checking the states.
Removed the double underscore to be consistent with the naming of other
bitmaps in the header and renamed current_state to vport_is_up to match
the meaning of the new variable.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Chittim Madhu <madhu.chittim@intel.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20251125223632.1857532-6-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2e281e1155fc ("idpf: detach and close netdevs while handling a reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h        | 12 ++++------
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 12 +++++-----
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 24 +++++++++----------
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   |  2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   |  2 +-
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   |  4 ++--
 drivers/net/ethernet/intel/idpf/xdp.c         |  2 +-
 7 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index ca4da0c899794..64142f8163fed 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -131,14 +131,12 @@ enum idpf_cap_field {
 
 /**
  * enum idpf_vport_state - Current vport state
- * @__IDPF_VPORT_DOWN: Vport is down
- * @__IDPF_VPORT_UP: Vport is up
- * @__IDPF_VPORT_STATE_LAST: Must be last, number of states
+ * @IDPF_VPORT_UP: Vport is up
+ * @IDPF_VPORT_STATE_NBITS: Must be last, number of states
  */
 enum idpf_vport_state {
-	__IDPF_VPORT_DOWN,
-	__IDPF_VPORT_UP,
-	__IDPF_VPORT_STATE_LAST,
+	IDPF_VPORT_UP,
+	IDPF_VPORT_STATE_NBITS
 };
 
 /**
@@ -162,7 +160,7 @@ struct idpf_netdev_priv {
 	u16 vport_idx;
 	u16 max_tx_hdr_size;
 	u16 tx_max_bufs;
-	enum idpf_vport_state state;
+	DECLARE_BITMAP(state, IDPF_VPORT_STATE_NBITS);
 	struct rtnl_link_stats64 netstats;
 	spinlock_t stats_lock;
 };
diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index a5a1eec9ade8b..eed166bc46f38 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -386,7 +386,7 @@ static int idpf_get_rxfh(struct net_device *netdev,
 	}
 
 	rss_data = &adapter->vport_config[np->vport_idx]->user_config.rss_data;
-	if (np->state != __IDPF_VPORT_UP)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		goto unlock_mutex;
 
 	rxfh->hfunc = ETH_RSS_HASH_TOP;
@@ -436,7 +436,7 @@ static int idpf_set_rxfh(struct net_device *netdev,
 	}
 
 	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
-	if (np->state != __IDPF_VPORT_UP)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		goto unlock_mutex;
 
 	if (rxfh->hfunc != ETH_RSS_HASH_NO_CHANGE &&
@@ -1167,7 +1167,7 @@ static void idpf_get_ethtool_stats(struct net_device *netdev,
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
-	if (np->state != __IDPF_VPORT_UP) {
+	if (!test_bit(IDPF_VPORT_UP, np->state)) {
 		idpf_vport_ctrl_unlock(netdev);
 
 		return;
@@ -1319,7 +1319,7 @@ static int idpf_get_q_coalesce(struct net_device *netdev,
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
-	if (np->state != __IDPF_VPORT_UP)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		goto unlock_mutex;
 
 	if (q_num >= vport->num_rxq && q_num >= vport->num_txq) {
@@ -1507,7 +1507,7 @@ static int idpf_set_coalesce(struct net_device *netdev,
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
-	if (np->state != __IDPF_VPORT_UP)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		goto unlock_mutex;
 
 	for (i = 0; i < vport->num_txq; i++) {
@@ -1710,7 +1710,7 @@ static void idpf_get_ts_stats(struct net_device *netdev,
 		ts_stats->err = u64_stats_read(&vport->tstamp_stats.discarded);
 	} while (u64_stats_fetch_retry(&vport->tstamp_stats.stats_sync, start));
 
-	if (np->state != __IDPF_VPORT_UP)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		goto exit;
 
 	for (u16 i = 0; i < vport->num_txq_grp; i++) {
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 452f3107378cb..313803c088478 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -519,7 +519,7 @@ static int idpf_del_mac_filter(struct idpf_vport *vport,
 	}
 	spin_unlock_bh(&vport_config->mac_filter_list_lock);
 
-	if (np->state == __IDPF_VPORT_UP) {
+	if (test_bit(IDPF_VPORT_UP, np->state)) {
 		int err;
 
 		err = idpf_add_del_mac_filters(vport, np, false, async);
@@ -590,7 +590,7 @@ static int idpf_add_mac_filter(struct idpf_vport *vport,
 	if (err)
 		return err;
 
-	if (np->state == __IDPF_VPORT_UP)
+	if (test_bit(IDPF_VPORT_UP, np->state))
 		err = idpf_add_del_mac_filters(vport, np, true, async);
 
 	return err;
@@ -894,7 +894,7 @@ static void idpf_vport_stop(struct idpf_vport *vport, bool rtnl)
 {
 	struct idpf_netdev_priv *np = netdev_priv(vport->netdev);
 
-	if (np->state <= __IDPF_VPORT_DOWN)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		return;
 
 	if (rtnl)
@@ -921,7 +921,7 @@ static void idpf_vport_stop(struct idpf_vport *vport, bool rtnl)
 	idpf_xdp_rxq_info_deinit_all(vport);
 	idpf_vport_queues_rel(vport);
 	idpf_vport_intr_rel(vport);
-	np->state = __IDPF_VPORT_DOWN;
+	clear_bit(IDPF_VPORT_UP, np->state);
 
 	if (rtnl)
 		rtnl_unlock();
@@ -1345,7 +1345,7 @@ static int idpf_up_complete(struct idpf_vport *vport)
 		netif_tx_start_all_queues(vport->netdev);
 	}
 
-	np->state = __IDPF_VPORT_UP;
+	set_bit(IDPF_VPORT_UP, np->state);
 
 	return 0;
 }
@@ -1391,7 +1391,7 @@ static int idpf_vport_open(struct idpf_vport *vport, bool rtnl)
 	struct idpf_vport_config *vport_config;
 	int err;
 
-	if (np->state != __IDPF_VPORT_DOWN)
+	if (test_bit(IDPF_VPORT_UP, np->state))
 		return -EBUSY;
 
 	if (rtnl)
@@ -1602,7 +1602,7 @@ void idpf_init_task(struct work_struct *work)
 
 	/* Once state is put into DOWN, driver is ready for dev_open */
 	np = netdev_priv(vport->netdev);
-	np->state = __IDPF_VPORT_DOWN;
+	clear_bit(IDPF_VPORT_UP, np->state);
 	if (test_and_clear_bit(IDPF_VPORT_UP_REQUESTED, vport_config->flags))
 		idpf_vport_open(vport, true);
 
@@ -1796,7 +1796,7 @@ static void idpf_set_vport_state(struct idpf_adapter *adapter)
 			continue;
 
 		np = netdev_priv(adapter->netdevs[i]);
-		if (np->state == __IDPF_VPORT_UP)
+		if (test_bit(IDPF_VPORT_UP, np->state))
 			set_bit(IDPF_VPORT_UP_REQUESTED,
 				adapter->vport_config[i]->flags);
 	}
@@ -1934,7 +1934,7 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 			     enum idpf_vport_reset_cause reset_cause)
 {
 	struct idpf_netdev_priv *np = netdev_priv(vport->netdev);
-	enum idpf_vport_state current_state = np->state;
+	bool vport_is_up = test_bit(IDPF_VPORT_UP, np->state);
 	struct idpf_adapter *adapter = vport->adapter;
 	struct idpf_vport *new_vport;
 	int err;
@@ -1985,7 +1985,7 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 		goto free_vport;
 	}
 
-	if (current_state <= __IDPF_VPORT_DOWN) {
+	if (!vport_is_up) {
 		idpf_send_delete_queues_msg(vport);
 	} else {
 		set_bit(IDPF_VPORT_DEL_QUEUES, vport->flags);
@@ -2018,7 +2018,7 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 	if (err)
 		goto err_open;
 
-	if (current_state == __IDPF_VPORT_UP)
+	if (vport_is_up)
 		err = idpf_vport_open(vport, false);
 
 	goto free_vport;
@@ -2028,7 +2028,7 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 				 vport->num_rxq, vport->num_bufq);
 
 err_open:
-	if (current_state == __IDPF_VPORT_UP)
+	if (vport_is_up)
 		idpf_vport_open(vport, false);
 
 free_vport:
diff --git a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
index 61e6130661404..e3ddf18dcbf51 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -570,7 +570,7 @@ static bool idpf_tx_singleq_clean(struct idpf_tx_queue *tx_q, int napi_budget,
 	np = netdev_priv(tx_q->netdev);
 	nq = netdev_get_tx_queue(tx_q->netdev, tx_q->idx);
 
-	dont_wake = np->state != __IDPF_VPORT_UP ||
+	dont_wake = !test_bit(IDPF_VPORT_UP, np->state) ||
 		    !netif_carrier_ok(tx_q->netdev);
 	__netif_txq_completed_wake(nq, ss.packets, ss.bytes,
 				   IDPF_DESC_UNUSED(tx_q), IDPF_TX_WAKE_THRESH,
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 828f7c444d309..1993a3b0da59b 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2275,7 +2275,7 @@ static bool idpf_tx_clean_complq(struct idpf_compl_queue *complq, int budget,
 		/* Update BQL */
 		nq = netdev_get_tx_queue(tx_q->netdev, tx_q->idx);
 
-		dont_wake = !complq_ok || np->state != __IDPF_VPORT_UP ||
+		dont_wake = !complq_ok || !test_bit(IDPF_VPORT_UP, np->state) ||
 			    !netif_carrier_ok(tx_q->netdev);
 		/* Check if the TXQ needs to and can be restarted */
 		__netif_txq_completed_wake(nq, tx_q->cleaned_pkts, tx_q->cleaned_bytes,
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index fc03d55bc9b90..5bbe7d9294c14 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -68,7 +68,7 @@ static void idpf_handle_event_link(struct idpf_adapter *adapter,
 
 	vport->link_up = v2e->link_status;
 
-	if (np->state != __IDPF_VPORT_UP)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		return;
 
 	if (vport->link_up) {
@@ -2760,7 +2760,7 @@ int idpf_send_get_stats_msg(struct idpf_vport *vport)
 
 
 	/* Don't send get_stats message if the link is down */
-	if (np->state <= __IDPF_VPORT_DOWN)
+	if (!test_bit(IDPF_VPORT_UP, np->state))
 		return 0;
 
 	stats_msg.vport_id = cpu_to_le32(vport->vport_id);
diff --git a/drivers/net/ethernet/intel/idpf/xdp.c b/drivers/net/ethernet/intel/idpf/xdp.c
index 21ce25b0567f6..958d16f874248 100644
--- a/drivers/net/ethernet/intel/idpf/xdp.c
+++ b/drivers/net/ethernet/intel/idpf/xdp.c
@@ -418,7 +418,7 @@ static int idpf_xdp_setup_prog(struct idpf_vport *vport,
 	if (test_bit(IDPF_REMOVE_IN_PROG, vport->adapter->flags) ||
 	    !test_bit(IDPF_VPORT_REG_NETDEV, cfg->flags) ||
 	    !!vport->xdp_prog == !!prog) {
-		if (np->state == __IDPF_VPORT_UP)
+		if (test_bit(IDPF_VPORT_UP, np->state))
 			idpf_xdp_copy_prog_to_rqs(vport, prog);
 
 		old = xchg(&vport->xdp_prog, prog);
-- 
2.51.0



