Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619250;
	b=UA7EG9agyBGw0H5S/EePBG8P+X8zr0jWUakN9AZwwu3/e6S3oHaWmmv07Dd5eihocfZp
	 F4dLd7EvDheQqfaCp9ZqCIPWN2zErJ31pFoe74X1uUPAI1GeO7qO/k31ipeiRadg+3Qtn
	 SXJp03HYRfPhMYD0Kxq1Vj4ZJZT8MgzA6/vEcrWdXfxDQILnE9mDMA6rnMb33HiEYWgWl
	 no5t5/z8IiDsEXGhRJC12yL2DWpHeqj74BBUoiFO4L/uri2uBnIGEOlutH6Y+wboyWLJl
	 tNV9Uz5QdmUELDVJFqRUAvyfZ8Ecw6fnrzG60YpZFR+KtbxkhlGwY8JxRSHkFqdi6lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nAO9e1Ig/ttEifGnqTn+qZiFhPuPyYtGb01Og5lbhog=;
	b=VAygLTyTsYF8fy7Vo5ByTbVNI8rgSpW3UYKEiSwRmxl27H+Fgf8BNYTt37DfR2ytWNNO
	 l+JMXczCibJtTRBdrmehJQK4z5kYuYR46Rc1tJpYBuDvCrW07qRIXM+zwzlKKkvqYgZSV
	 ws2OcMa+yjM1N0cG4DjHyE8wCJM31aE7Am+GFLUwXgQFmXOnemI+4UWh+FjfGLBqxEBtM
	 61raNPfY7jVdG+JHR1WeSqIQQOaTZ8yBnnuMS8fukvyk61lympfOFLjPlBQh/Nr1H8DYv
	 iRFgA3g+Ndub9mtMstmj5FBm+nvICvNAvjQlZgD6FhK6iZj+Le6VmTyRX5vl8ahasGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nK/DDavw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E129606A31E;
	Wed, 25 Nov 2026 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nK/DDavw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D641F000CA;
	Wed, 25 Nov 2026 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619249;
	bh=nAO9e1Ig/ttEifGnqTn+qZiFhPuPyYtGb01Og5lbhog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK/DDavwaix/jGlnK9IQPlKxRYflTX9ukcaTDotJPoBKsDQCgB761Zj5eQjZPNuxA
	 H6EBIY6IAwLJifvyBZV8qLLkvjb6hRF7pkpafy36vUxHh6IFoOIF2KElniWN19QLfm
	 WgcqTIqdY/Dy4MdLrX3hcPcQbom+/R5w+jrzspFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Petr Oros <poros@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0536/1005] ice: dpll: serialize changes of the SyncE CGU registers
Date: Wed, 25 Nov 2026 15:31:14 +0100
Message-ID: <20261125143834.302437442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 0afbc079d87eb2ba86b396bb1be145ad679ec300 ]

All E825C PFs share the CGU registers R10 and R11. On dual complex E825
the second complex reaches the CGU of complex 0 through cgu_peer. RCLK pin
callbacks read, modify and write these registers under dpll_lock and the
pf->dplls.lock of their PF. ice_ptp_link_change() rewrites R10 under the
pf->dplls.lock of its PF only, so a link change on one PF can write back
a stale R10 and undo an RCLK pin change made by another PF.

Add a mutex to struct ice_adapter, which all E825C PFs share, and hold it
around these sequences.

Tested on GNR-D with dual complex E825, with a 2 to 4 ms delay after the
read of R10 in the link change path to widen the window. Toggling the
RCLK pin of one port while another port of the same complex went down
and up 143 times lost 120 of 86814 updates of the mux in R10 without
this patch, and none of 76992 with it.

Fixes: ad1df4f2d591 ("ice: dpll: Support E825-C SyncE and dynamic pin discovery")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Link: https://patch.msgid.link/20261110094350.184185-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adapter.c |  2 ++
 drivers/net/ethernet/intel/ice/ice_adapter.h |  4 ++++
 drivers/net/ethernet/intel/ice/ice_dpll.c    | 11 ++++++-----
 drivers/net/ethernet/intel/ice/ice_dpll.h    |  4 ++++
 drivers/net/ethernet/intel/ice/ice_ptp.c     |  2 ++
 drivers/net/ethernet/intel/ice/ice_tspll.c   |  4 ++--
 6 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.c b/drivers/net/ethernet/intel/ice/ice_adapter.c
index 536923b6ae979..aa2d8addae5be 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.c
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.c
@@ -72,6 +72,7 @@ static struct ice_adapter *ice_adapter_new(struct pci_dev *pdev)
 	spin_lock_init(&adapter->txq_ctx_lock);
 	for (int i = 0; i < ARRAY_SIZE(adapter->cpi_phy_lock); i++)
 		mutex_init(&adapter->cpi_phy_lock[i]);
+	mutex_init(&adapter->cgu_synce_lock);
 	refcount_set(&adapter->refcount, 1);
 
 	spin_lock_init(&adapter->ports.lock);
@@ -85,6 +86,7 @@ static void ice_adapter_free(struct ice_adapter *adapter)
 	WARN_ON(!list_empty(&adapter->ports.list));
 	for (int i = 0; i < ARRAY_SIZE(adapter->cpi_phy_lock); i++)
 		mutex_destroy(&adapter->cpi_phy_lock[i]);
+	mutex_destroy(&adapter->cgu_synce_lock);
 
 	cleanup_srcu_struct(&adapter->ports.srcu);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.h b/drivers/net/ethernet/intel/ice/ice_adapter.h
index c61bd645e460d..fd5585005d91b 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.h
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.h
@@ -41,6 +41,8 @@ struct ice_port_list {
  * @txq_ctx_lock: Spinlock protecting access to the GLCOMM_QTX_CNTX_CTL register
  * @cpi_phy_lock: Per-PHY mutex serializing CPI REQ/ACK transactions.
  *               Index 0 = PHY0, index 1 = PHY1. Used on E825C devices.
+ * @cgu_synce_lock: Mutex serializing changes of the CGU registers R10 and R11,
+ *                  which all PFs reach. Used on E825C devices.
  * @ctrl_pf: Control PF of the adapter
  * @ports: Ports list
  * @index: 64-bit index cached for collision detection on 32bit systems
@@ -53,6 +55,8 @@ struct ice_adapter {
 	spinlock_t txq_ctx_lock;
 	/* Serialize CPI REQ/ACK transactions per PHY (E825C only) */
 	struct mutex cpi_phy_lock[ICE_E825_MAX_PHYS];
+	/* Serialize changes of the SyncE CGU registers (E825C only) */
+	struct mutex cgu_synce_lock;
 
 	struct ice_pf *ctrl_pf;
 	struct ice_port_list ports;
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 85a74cd6ea1f3..bd162a0e7c305 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -2024,7 +2024,7 @@ ice_dpll_phase_offset_get(const struct dpll_pin *pin, void *pin_priv,
  *
  * DPLL subsystem callback. Set proper signals to recover clock from port.
  *
- * Context: Called under pf->dplls.lock
+ * Context: Called under pf->dplls.lock, acquires adapter->cgu_synce_lock
  * Return:
  * * 0 - success
  * * negative - error
@@ -2032,14 +2032,15 @@ ice_dpll_phase_offset_get(const struct dpll_pin *pin, void *pin_priv,
 static int ice_dpll_synce_update_e825c(struct ice_hw *hw, bool ena,
 				       u32 port_num, enum ice_synce_clk output)
 {
+	struct ice_pf *pf = hw->back;
 	int err;
 
+	mutex_lock(&pf->adapter->cgu_synce_lock);
 	/* configure the mux to deliver proper signal to DPLL from the MUX */
 	err = ice_tspll_cfg_bypass_mux_e825c(hw, ena, port_num, output);
-	if (err)
-		return err;
-
-	err = ice_tspll_cfg_synce_ethdiv_e825c(hw, output);
+	if (!err)
+		err = ice_tspll_cfg_synce_ethdiv_e825c(hw, output);
+	mutex_unlock(&pf->adapter->cgu_synce_lock);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.h b/drivers/net/ethernet/intel/ice/ice_dpll.h
index 103ba3e490682..d882846f995d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.h
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.h
@@ -156,6 +156,7 @@ struct ice_dpll {
  *     txclk_notify_rwsem (read)
  *       -> pf->dplls.lock
  *         -> ctrl_pf->dplls.lock
+ *         -> adapter->cgu_synce_lock
  *
  *   - @lock serializes all DPLL state mutations on this PF. When the
  *     controlling PF's lock must also be taken (e.g. updating the shared
@@ -167,6 +168,9 @@ struct ice_dpll {
  *     dpll_*_change_ntf() calls. ice_dpll_deinit() takes the write side
  *     standalone (not nested under any other lock) to drain in-flight
  *     readers before pins and the TXC DPLL device are freed.
+ *   - adapter->cgu_synce_lock serializes changes of the CGU registers R10 and
+ *     R11. All E825C PFs reach one CGU, so @lock, which is per PF, does not
+ *     cover them.
  */
 struct ice_dplls {
 	struct kthread_worker *kworker;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 2f8563eb6fb19..b15b02c03b933 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1365,7 +1365,9 @@ void ice_ptp_link_change(struct ice_pf *pf, bool linkup)
 				break;
 			}
 
+			mutex_lock(&pf->adapter->cgu_synce_lock);
 			err = ice_tspll_cfg_synce_ethdiv_e825c(hw, clk_pin);
+			mutex_unlock(&pf->adapter->cgu_synce_lock);
 			if (active && err) {
 				dev_err_once(ice_pf_to_dev(pf),
 					     "Failed to configure SyncE ETH divider for pin %d, err %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_tspll.c b/drivers/net/ethernet/intel/ice/ice_tspll.c
index fd4b58eb9bc00..25227690418eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_tspll.c
+++ b/drivers/net/ethernet/intel/ice/ice_tspll.c
@@ -680,7 +680,7 @@ int ice_tspll_bypass_mux_active_e825c(struct ice_hw *hw, u8 port, bool *active,
  *
  * Set reference clock source and output clock selection.
  *
- * Context: Called under pf->dplls.lock
+ * Context: Called under pf->dplls.lock and adapter->cgu_synce_lock
  * Return:
  * * 0 - success
  * * negative - error
@@ -786,7 +786,7 @@ static int ice_tspll_get_div_e825c(u16 link_speed, unsigned int *divider)
  *
  * Set the correct CGU divider for RCLKA or RCLKB.
  *
- * Context: Called under pf->dplls.lock
+ * Context: Called under pf->dplls.lock and adapter->cgu_synce_lock
  * Return:
  * * 0 - success
  * * negative - error
-- 
2.53.0



