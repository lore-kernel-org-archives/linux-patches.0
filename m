Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F05747D94B;
	Thu, 20 Aug 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247605; cv=none; b=A3GbwPOAQc6RQXX/NkS+qLgTSbSPnl6NgyNjhzZai+ujgF04N5/W4CYTK6syzzeONFIPbnZVoLjyDDMudfjEH6glcCbgYPDTpLzmVsVmVHDWV6oKaVDTKWc/Kd6ctgb/W5+nbHgmBQKsy3rr2SU+S51YlBtHt4/AmlWUy19Lm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247605; c=relaxed/simple;
	bh=+q1S3fIb/yKOJYBvvf4+XZdZnjxMQzjhvYLqOmChdJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRnpp1VY0qONHH0ebusLF6wMzSmRc045tWDo8nGf0KJdlht6pAYfMtvsowfI2EYJXcoRUIucvGZzfPGgEJ+D1RchAs9d+6ERC7Eb0kKZFhmqg/qtDMttBkdYrDPxNMpyWmnAwK0lg73Z7w+sZT7R7uXIgww2Ppg+49TxIeY4VZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwbuOPWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwbuOPWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902341F000E9;
	Thu, 20 Aug 2026 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247604;
	bh=6emtz+3SmpYM0VTzCpWxG0SAw+7FLU+2lrGoyzlBRHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwbuOPWgj58eGxzsh5ERw2sfbbdGpZ6HOFoCQ+c2JPkpATgsegiNxuvKwM0KdGFep
	 UAkoQ2fEGC4R4YmN2pY0InlSU7a73cafeWX5sef7NQQFAQ4GVy3U3HVocPTyxFwcKa
	 NhGCv+b0Bmgw4ZflDVm9xa9FMsdXhidFfAwPgMqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 103/166] ice: make ice_vsi_cfg_rxq() static
Date: Thu, 20 Aug 2026 16:56:02 +0200
Message-ID: <20260820145214.261163229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 3e5fb691faee1d43ee13d4ce2666b0a05e1555b3 ]

Currently, XSK control path in ice driver calls directly
ice_vsi_cfg_rxq() whereas we have ice_vsi_cfg_single_rxq() for that
purpose. Use the latter from XSK side and make ice_vsi_cfg_rxq() static.

ice_vsi_cfg_rxq() resides in ice_base.c and is rather big, so to reduce
the code churn let us move two callers of it from ice_lib.c to
ice_base.c.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c |   58 +++++++++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_base.h |    3 +
 drivers/net/ethernet/intel/ice/ice_lib.c  |   56 ----------------------------
 drivers/net/ethernet/intel/ice/ice_lib.h  |    4 --
 drivers/net/ethernet/intel/ice/ice_xsk.c  |    2 -
 5 files changed, 60 insertions(+), 63 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -544,7 +544,7 @@ static unsigned int ice_get_frame_sz(str
  *
  * Return 0 on success and a negative value on error.
  */
-int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
+static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 {
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	u32 num_bufs = ICE_RX_DESC_UNUSED(ring);
@@ -636,6 +636,62 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *
 
 	return 0;
 }
+
+int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx)
+{
+	if (q_idx >= vsi->num_rxq)
+		return -EINVAL;
+
+	return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
+}
+
+/**
+ * ice_vsi_cfg_frame_size - setup max frame size and Rx buffer length
+ * @vsi: VSI
+ */
+static void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
+{
+	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
+		vsi->max_frame = ICE_MAX_FRAME_LEGACY_RX;
+		vsi->rx_buf_len = ICE_RXBUF_1664;
+#if (PAGE_SIZE < 8192)
+	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
+		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
+		vsi->max_frame = ICE_RXBUF_1536 - NET_IP_ALIGN;
+		vsi->rx_buf_len = ICE_RXBUF_1536 - NET_IP_ALIGN;
+#endif
+	} else {
+		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
+		vsi->rx_buf_len = ICE_RXBUF_3072;
+	}
+}
+
+/**
+ * ice_vsi_cfg_rxqs - Configure the VSI for Rx
+ * @vsi: the VSI being configured
+ *
+ * Return 0 on success and a negative value on error
+ * Configure the Rx VSI for operation.
+ */
+int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
+{
+	u16 i;
+
+	if (vsi->type == ICE_VSI_VF)
+		goto setup_rings;
+
+	ice_vsi_cfg_frame_size(vsi);
+setup_rings:
+	/* set up individual rings */
+	ice_for_each_rxq(vsi, i) {
+		int err = ice_vsi_cfg_rxq(vsi->rx_rings[i]);
+
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
 
 /**
  * __ice_vsi_get_qs - helper function for assigning queues from PF to VSI
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -6,7 +6,8 @@
 
 #include "ice.h"
 
-int ice_vsi_cfg_rxq(struct ice_rx_ring *ring);
+int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
+int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
 int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg);
 int
 ice_vsi_ctrl_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx, bool wait);
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1697,27 +1697,6 @@ static void ice_vsi_set_rss_flow_fld(str
 }
 
 /**
- * ice_vsi_cfg_frame_size - setup max frame size and Rx buffer length
- * @vsi: VSI
- */
-static void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
-{
-	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
-		vsi->max_frame = ICE_MAX_FRAME_LEGACY_RX;
-		vsi->rx_buf_len = ICE_RXBUF_1664;
-#if (PAGE_SIZE < 8192)
-	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
-		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
-		vsi->max_frame = ICE_RXBUF_1536 - NET_IP_ALIGN;
-		vsi->rx_buf_len = ICE_RXBUF_1536 - NET_IP_ALIGN;
-#endif
-	} else {
-		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
-		vsi->rx_buf_len = ICE_RXBUF_3072;
-	}
-}
-
-/**
  * ice_pf_state_is_nominal - checks the PF for nominal state
  * @pf: pointer to PF to check
  *
@@ -1823,14 +1802,6 @@ ice_write_qrxflxp_cntxt(struct ice_hw *h
 	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
 }
 
-int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx)
-{
-	if (q_idx >= vsi->num_rxq)
-		return -EINVAL;
-
-	return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
-}
-
 int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
@@ -1851,33 +1822,6 @@ int ice_vsi_cfg_single_txq(struct ice_vs
 }
 
 /**
- * ice_vsi_cfg_rxqs - Configure the VSI for Rx
- * @vsi: the VSI being configured
- *
- * Return 0 on success and a negative value on error
- * Configure the Rx VSI for operation.
- */
-int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
-{
-	u16 i;
-
-	if (vsi->type == ICE_VSI_VF)
-		goto setup_rings;
-
-	ice_vsi_cfg_frame_size(vsi);
-setup_rings:
-	/* set up individual rings */
-	ice_for_each_rxq(vsi, i) {
-		int err = ice_vsi_cfg_rxq(vsi->rx_rings[i]);
-
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-/**
  * ice_vsi_cfg_txqs - Configure the VSI for Tx
  * @vsi: the VSI being configured
  * @rings: Tx ring array to be configured
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -54,12 +54,8 @@ bool ice_pf_state_is_nominal(struct ice_
 
 void ice_update_eth_stats(struct ice_vsi *vsi);
 
-int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
-
 int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx);
 
-int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
-
 int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
 
 void ice_vsi_cfg_msix(struct ice_vsi *vsi);
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -252,7 +252,7 @@ static int ice_qp_ena(struct ice_vsi *vs
 		ice_tx_xsk_pool(vsi, q_idx);
 	}
 
-	err = ice_vsi_cfg_rxq(rx_ring);
+	err = ice_vsi_cfg_single_rxq(vsi, q_idx);
 	if (err)
 		goto free_buf;
 


