Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DEC1F7060;
	Tue, 21 Jan 2025 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482245; cv=none; b=m4/mCY82C2qeoEefK/zUTlrkuOpPSpTBnR9LziZ6xzBQGKOdW17acVCA6opgGgklLfcWe+ftOaroLTA0md32bnDjSBVUVdeRFLB0UKmsDnd8VNPXUXpFdcRMbyAtxfIJOmg33bjH25307RB9SrvIx9lki+ZOCjRZ8bq8GgBQ8/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482245; c=relaxed/simple;
	bh=5uE52hav9p5dXr6vPSYxV8GqKeqQIPqjulVT3nlMG3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS1jTQ6hYFArIknVQ/Y91ryUigtyLfXLeGTojKZ4WxLRntI1Vsf1PEudpurzUC6/JJqIallOKqqyeZ3b4Nt/zdGp19mHrGOzWAlHTWjACSMdVFyLfBxKA7hRuedjhjmyojAZ8IssUcl1UHQIHBJLx5w4v3vCKIboYcZnsgrUopc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbfxlM3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbfxlM3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4861C4CEDF;
	Tue, 21 Jan 2025 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482245;
	bh=5uE52hav9p5dXr6vPSYxV8GqKeqQIPqjulVT3nlMG3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbfxlM3QNRahQwZzRSEnP6s83YKX0iPB+TDTUnYaqdvLeyvM1R8s+fGltjymo6W70
	 yl7qhClk2jjlvhXtdOfNEq8trdUnUQXRZpXDE+w5ftd8cII0uF+h2+4OucBa4arjur
	 e1zKiK4g6uC3TJoReTlPY8OIuBgNJhzpmuag7eYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 011/122] ice: Introduce ice_get_phy_model() wrapper
Date: Tue, 21 Jan 2025 18:50:59 +0100
Message-ID: <20250121174533.432859655@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

[ Upstream commit 5e0776451d89eefe66b19e010e48ece1cca07e58 ]

Introduce ice_get_phy_model() to improve code readability

Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 258f5f905815 ("ice: Add correct PHY lane assignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h        |  5 +++++
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 19 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 22 ++++++++++-----------
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index d6f80da30decf..558cda577191d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -1047,5 +1047,10 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 }
 
+static inline enum ice_phy_model ice_get_phy_model(const struct ice_hw *hw)
+{
+	return hw->ptp.phy_model;
+}
+
 extern const struct xdp_metadata_ops ice_xdp_md_ops;
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ef2e858f49bb0..d534c8e571cee 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1363,7 +1363,7 @@ ice_ptp_port_phy_stop(struct ice_ptp_port *ptp_port)
 
 	mutex_lock(&ptp_port->ps_lock);
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		err = ice_stop_phy_timer_eth56g(hw, port, true);
 		break;
@@ -1409,7 +1409,7 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 
 	mutex_lock(&ptp_port->ps_lock);
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		err = ice_start_phy_timer_eth56g(hw, port);
 		break;
@@ -1480,8 +1480,7 @@ void ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
 	/* Skip HW writes if reset is in progress */
 	if (pf->hw.reset_ongoing)
 		return;
-
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_E810:
 		/* Do not reconfigure E810 PHY */
 		return;
@@ -1514,7 +1513,7 @@ static int ice_ptp_cfg_phy_interrupt(struct ice_pf *pf, bool ena, u32 threshold)
 
 	ice_ptp_reset_ts_memory(hw);
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G: {
 		int port;
 
@@ -1553,7 +1552,7 @@ static int ice_ptp_cfg_phy_interrupt(struct ice_pf *pf, bool ena, u32 threshold)
 	case ICE_PHY_UNSUP:
 	default:
 		dev_warn(dev, "%s: Unexpected PHY model %d\n", __func__,
-			 hw->ptp.phy_model);
+			 ice_get_phy_model(hw));
 		return -EOPNOTSUPP;
 	}
 }
@@ -2059,7 +2058,7 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 	/* For Vernier mode on E82X, we need to recalibrate after new settime.
 	 * Start with marking timestamps as invalid.
 	 */
-	if (hw->ptp.phy_model == ICE_PHY_E82X) {
+	if (ice_get_phy_model(hw) == ICE_PHY_E82X) {
 		err = ice_ptp_clear_phy_offset_ready_e82x(hw);
 		if (err)
 			dev_warn(ice_pf_to_dev(pf), "Failed to mark timestamps as invalid before settime\n");
@@ -2083,7 +2082,7 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 	ice_ptp_enable_all_clkout(pf);
 
 	/* Recalibrate and re-enable timestamp blocks for E822/E823 */
-	if (hw->ptp.phy_model == ICE_PHY_E82X)
+	if (ice_get_phy_model(hw) == ICE_PHY_E82X)
 		ice_ptp_restart_all_phy(pf);
 exit:
 	if (err) {
@@ -3209,7 +3208,7 @@ static int ice_ptp_init_port(struct ice_pf *pf, struct ice_ptp_port *ptp_port)
 
 	mutex_init(&ptp_port->ps_lock);
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		return ice_ptp_init_tx_eth56g(pf, &ptp_port->tx,
 					      ptp_port->port_num);
@@ -3307,7 +3306,7 @@ static void ice_ptp_remove_auxbus_device(struct ice_pf *pf)
  */
 static void ice_ptp_init_tx_interrupt_mode(struct ice_pf *pf)
 {
-	switch (pf->hw.ptp.phy_model) {
+	switch (ice_get_phy_model(&pf->hw)) {
 	case ICE_PHY_E82X:
 		/* E822 based PHY has the clock owner process the interrupt
 		 * for all ports.
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 64c36620a02f3..28bd4815ebcf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -804,7 +804,7 @@ static u32 ice_ptp_tmr_cmd_to_port_reg(struct ice_hw *hw,
 	/* Certain hardware families share the same register values for the
 	 * port register and source timer register.
 	 */
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_E810:
 		return ice_ptp_tmr_cmd_to_src_reg(hw, cmd) & TS_CMD_MASK_E810;
 	default:
@@ -5461,7 +5461,7 @@ void ice_ptp_init_hw(struct ice_hw *hw)
 static int ice_ptp_write_port_cmd(struct ice_hw *hw, u8 port,
 				  enum ice_ptp_tmr_cmd cmd)
 {
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		return ice_ptp_write_port_cmd_eth56g(hw, port, cmd);
 	case ICE_PHY_E82X:
@@ -5526,7 +5526,7 @@ static int ice_ptp_port_cmd(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
 	u32 port;
 
 	/* PHY models which can program all ports simultaneously */
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_E810:
 		return ice_ptp_port_cmd_e810(hw, cmd);
 	default:
@@ -5605,7 +5605,7 @@ int ice_ptp_init_time(struct ice_hw *hw, u64 time)
 
 	/* PHY timers */
 	/* Fill Rx and Tx ports and send msg to PHY */
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		err = ice_ptp_prep_phy_time_eth56g(hw,
 						   (u32)(time & 0xFFFFFFFF));
@@ -5651,7 +5651,7 @@ int ice_ptp_write_incval(struct ice_hw *hw, u64 incval)
 	wr32(hw, GLTSYN_SHADJ_L(tmr_idx), lower_32_bits(incval));
 	wr32(hw, GLTSYN_SHADJ_H(tmr_idx), upper_32_bits(incval));
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		err = ice_ptp_prep_phy_incval_eth56g(hw, incval);
 		break;
@@ -5720,7 +5720,7 @@ int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj)
 	wr32(hw, GLTSYN_SHADJ_L(tmr_idx), 0);
 	wr32(hw, GLTSYN_SHADJ_H(tmr_idx), adj);
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		err = ice_ptp_prep_phy_adj_eth56g(hw, adj);
 		break;
@@ -5753,7 +5753,7 @@ int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj)
  */
 int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp)
 {
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		return ice_read_ptp_tstamp_eth56g(hw, block, idx, tstamp);
 	case ICE_PHY_E810:
@@ -5783,7 +5783,7 @@ int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp)
  */
 int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx)
 {
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		return ice_clear_ptp_tstamp_eth56g(hw, block, idx);
 	case ICE_PHY_E810:
@@ -5846,7 +5846,7 @@ static int ice_get_pf_c827_idx(struct ice_hw *hw, u8 *idx)
  */
 void ice_ptp_reset_ts_memory(struct ice_hw *hw)
 {
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		ice_ptp_reset_ts_memory_eth56g(hw);
 		break;
@@ -5875,7 +5875,7 @@ int ice_ptp_init_phc(struct ice_hw *hw)
 	/* Clear event err indications for auxiliary pins */
 	(void)rd32(hw, GLTSYN_STAT(src_idx));
 
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		return ice_ptp_init_phc_eth56g(hw);
 	case ICE_PHY_E810:
@@ -5900,7 +5900,7 @@ int ice_ptp_init_phc(struct ice_hw *hw)
  */
 int ice_get_phy_tx_tstamp_ready(struct ice_hw *hw, u8 block, u64 *tstamp_ready)
 {
-	switch (hw->ptp.phy_model) {
+	switch (ice_get_phy_model(hw)) {
 	case ICE_PHY_ETH56G:
 		return ice_get_phy_tx_tstamp_ready_eth56g(hw, block,
 							  tstamp_ready);
-- 
2.39.5



