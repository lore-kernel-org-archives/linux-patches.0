Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC1533372B;
	Fri,  9 Jan 2026 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962688; cv=none; b=LDwivOWQJpw9O7N5SRak/Ez8UlnGGXK0avV3AKGrfWkpbI1XNBazTmDgHxO75SgfssjIEede/j6iWZ/PTgFASyAEzJN6NONEftJ+s8JLzPRVSGljLy8+PXfmiZq7GuWMDtbAfOybr/FFoWspvMcI07m7nYKCrH1IAS1xZ+bvyJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962688; c=relaxed/simple;
	bh=Jgn533NONFvEk/w3UB+uVR/YI6QrOn9vqmhYPUPDEuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRGeDJDONaAAoiC0uazdU+1E6HKOLkP9+Ea+8opLkvGzDgqsd8nXNPtF7yBsI72y8f1tdKAPXuY8wDUImbeXxf0fNUyFWj76+zqOp5aV5r18GOw+i8sroNzBuwWV2ddyzJuL/qXRE0L04n8T9nqYwLgGey6g8q0tsr8Fv+35qAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzuWbT+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzuWbT+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CE7C4CEF1;
	Fri,  9 Jan 2026 12:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962688;
	bh=Jgn533NONFvEk/w3UB+uVR/YI6QrOn9vqmhYPUPDEuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzuWbT+F6T+fPRGrlJ6mhaSiFLG9YhLBalwu7eqbPYlvaGhVSnJ0deFiPNBIonsOW
	 DHY7MMbAagOhJwQLtRQ1H4sbVmxsSQa+DBu5SPVVzmzgKooTcpH5w2wDzja7iqpuct
	 WHhO327kBpVs0Fpgmn3Q/9hBvyzHDvC0RpHS+W94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Brian Masney <bmasney@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 421/634] net: stmmac: Remove some unnecessary void pointers
Date: Fri,  9 Jan 2026 12:41:39 +0100
Message-ID: <20260109112133.379722835@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 0c3f3c4f4b15a2c105e1ca882d100048074a2865 ]

There's a few spots in the hardware interface where a void pointer is
used, but what's passed in and later cast out is always the same type.

Just use the proper type directly.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: a48e23221000 ("net: stmmac: fix the crash issue for zero copy XDP_TX action")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/chain_mode.c  | 10 +++----
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |  4 +--
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  8 ++---
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |  6 ++--
 .../net/ethernet/stmicro/stmmac/enh_desc.c    | 11 +++----
 drivers/net/ethernet/stmicro/stmmac/hwif.h    | 30 ++++++++++++-------
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  8 ++---
 .../net/ethernet/stmicro/stmmac/ring_mode.c   | 10 +++----
 8 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
index 2e8744ac6b91..fb55efd52240 100644
--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -14,9 +14,9 @@
 
 #include "stmmac.h"
 
-static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
+static int jumbo_frm(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
+		     int csum)
 {
-	struct stmmac_tx_queue *tx_q = (struct stmmac_tx_queue *)p;
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
@@ -125,9 +125,8 @@ static void init_dma_chain(void *des, dma_addr_t phy_addr,
 	}
 }
 
-static void refill_desc3(void *priv_ptr, struct dma_desc *p)
+static void refill_desc3(struct stmmac_rx_queue *rx_q, struct dma_desc *p)
 {
-	struct stmmac_rx_queue *rx_q = (struct stmmac_rx_queue *)priv_ptr;
 	struct stmmac_priv *priv = rx_q->priv_data;
 
 	if (priv->hwts_rx_en && !priv->extend_desc)
@@ -141,9 +140,8 @@ static void refill_desc3(void *priv_ptr, struct dma_desc *p)
 				      sizeof(struct dma_desc)));
 }
 
-static void clean_desc3(void *priv_ptr, struct dma_desc *p)
+static void clean_desc3(struct stmmac_tx_queue *tx_q, struct dma_desc *p)
 {
-	struct stmmac_tx_queue *tx_q = (struct stmmac_tx_queue *)priv_ptr;
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->dirty_tx;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
index 8f0d9bc7cab5..f6abc7bfd29d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
@@ -80,10 +80,10 @@ static void dwmac100_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 }
 
 /* DMA controller has two counters to track the number of the missed frames. */
-static void dwmac100_dma_diagnostic_fr(void *data, struct stmmac_extra_stats *x,
+static void dwmac100_dma_diagnostic_fr(struct net_device_stats *stats,
+				       struct stmmac_extra_stats *x,
 				       void __iomem *ioaddr)
 {
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 	u32 csr8 = readl(ioaddr + DMA_MISSED_FRAME_CTR);
 
 	if (unlikely(csr8)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 8cc80b1db4cb..6a011d8633e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -13,11 +13,11 @@
 #include "dwmac4.h"
 #include "dwmac4_descs.h"
 
-static int dwmac4_wrback_get_tx_status(void *data, struct stmmac_extra_stats *x,
+static int dwmac4_wrback_get_tx_status(struct net_device_stats *stats,
+				       struct stmmac_extra_stats *x,
 				       struct dma_desc *p,
 				       void __iomem *ioaddr)
 {
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 	unsigned int tdes3;
 	int ret = tx_done;
 
@@ -73,10 +73,10 @@ static int dwmac4_wrback_get_tx_status(void *data, struct stmmac_extra_stats *x,
 	return ret;
 }
 
-static int dwmac4_wrback_get_rx_status(void *data, struct stmmac_extra_stats *x,
+static int dwmac4_wrback_get_rx_status(struct net_device_stats *stats,
+				       struct stmmac_extra_stats *x,
 				       struct dma_desc *p)
 {
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 	unsigned int rdes1 = le32_to_cpu(p->des1);
 	unsigned int rdes2 = le32_to_cpu(p->des2);
 	unsigned int rdes3 = le32_to_cpu(p->des3);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index b1f0c3984a09..13c347ee8be9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -8,7 +8,8 @@
 #include "common.h"
 #include "dwxgmac2.h"
 
-static int dwxgmac2_get_tx_status(void *data, struct stmmac_extra_stats *x,
+static int dwxgmac2_get_tx_status(struct net_device_stats *stats,
+				  struct stmmac_extra_stats *x,
 				  struct dma_desc *p, void __iomem *ioaddr)
 {
 	unsigned int tdes3 = le32_to_cpu(p->des3);
@@ -22,7 +23,8 @@ static int dwxgmac2_get_tx_status(void *data, struct stmmac_extra_stats *x,
 	return ret;
 }
 
-static int dwxgmac2_get_rx_status(void *data, struct stmmac_extra_stats *x,
+static int dwxgmac2_get_rx_status(struct net_device_stats *stats,
+				  struct stmmac_extra_stats *x,
 				  struct dma_desc *p)
 {
 	unsigned int rdes3 = le32_to_cpu(p->des3);
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index 1bcbbd724fb5..a91d8f13a931 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -12,10 +12,10 @@
 #include "common.h"
 #include "descs_com.h"
 
-static int enh_desc_get_tx_status(void *data, struct stmmac_extra_stats *x,
+static int enh_desc_get_tx_status(struct net_device_stats *stats,
+				  struct stmmac_extra_stats *x,
 				  struct dma_desc *p, void __iomem *ioaddr)
 {
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 	unsigned int tdes0 = le32_to_cpu(p->des0);
 	int ret = tx_done;
 
@@ -117,7 +117,8 @@ static int enh_desc_coe_rdes0(int ipc_err, int type, int payload_err)
 	return ret;
 }
 
-static void enh_desc_get_ext_status(void *data, struct stmmac_extra_stats *x,
+static void enh_desc_get_ext_status(struct net_device_stats *stats,
+				    struct stmmac_extra_stats *x,
 				    struct dma_extended_desc *p)
 {
 	unsigned int rdes0 = le32_to_cpu(p->basic.des0);
@@ -181,10 +182,10 @@ static void enh_desc_get_ext_status(void *data, struct stmmac_extra_stats *x,
 	}
 }
 
-static int enh_desc_get_rx_status(void *data, struct stmmac_extra_stats *x,
+static int enh_desc_get_rx_status(struct net_device_stats *stats,
+				  struct stmmac_extra_stats *x,
 				  struct dma_desc *p)
 {
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 	unsigned int rdes0 = le32_to_cpu(p->des0);
 	int ret = good_frame;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 820e2251b7c8..17ea6216a78f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -56,8 +56,9 @@ struct stmmac_desc_ops {
 	/* Last tx segment reports the transmit status */
 	int (*get_tx_ls)(struct dma_desc *p);
 	/* Return the transmit status looking at the TDES1 */
-	int (*tx_status)(void *data, struct stmmac_extra_stats *x,
-			struct dma_desc *p, void __iomem *ioaddr);
+	int (*tx_status)(struct net_device_stats *stats,
+			 struct stmmac_extra_stats *x,
+			 struct dma_desc *p, void __iomem *ioaddr);
 	/* Get the buffer size from the descriptor */
 	int (*get_tx_len)(struct dma_desc *p);
 	/* Handle extra events on specific interrupts hw dependent */
@@ -65,10 +66,12 @@ struct stmmac_desc_ops {
 	/* Get the receive frame size */
 	int (*get_rx_frame_len)(struct dma_desc *p, int rx_coe_type);
 	/* Return the reception status looking at the RDES1 */
-	int (*rx_status)(void *data, struct stmmac_extra_stats *x,
-			struct dma_desc *p);
-	void (*rx_extended_status)(void *data, struct stmmac_extra_stats *x,
-			struct dma_extended_desc *p);
+	int (*rx_status)(struct net_device_stats *stats,
+			 struct stmmac_extra_stats *x,
+			 struct dma_desc *p);
+	void (*rx_extended_status)(struct net_device_stats *stats,
+				   struct stmmac_extra_stats *x,
+				   struct dma_extended_desc *p);
 	/* Set tx timestamp enable bit */
 	void (*enable_tx_timestamp) (struct dma_desc *p);
 	/* get tx timestamp status */
@@ -185,8 +188,9 @@ struct stmmac_dma_ops {
 	void (*dma_tx_mode)(void __iomem *ioaddr, int mode, u32 channel,
 			    int fifosz, u8 qmode);
 	/* To track extra statistic (if supported) */
-	void (*dma_diagnostic_fr) (void *data, struct stmmac_extra_stats *x,
-				   void __iomem *ioaddr);
+	void (*dma_diagnostic_fr)(struct net_device_stats *stats,
+				  struct stmmac_extra_stats *x,
+				  void __iomem *ioaddr);
 	void (*enable_dma_transmission) (void __iomem *ioaddr);
 	void (*enable_dma_irq)(void __iomem *ioaddr, u32 chan,
 			       bool rx, bool tx);
@@ -537,16 +541,20 @@ struct stmmac_hwtimestamp {
 #define stmmac_timestamp_interrupt(__priv, __args...) \
 	stmmac_do_void_callback(__priv, ptp, timestamp_interrupt, __args)
 
+struct stmmac_tx_queue;
+struct stmmac_rx_queue;
+
 /* Helpers to manage the descriptors for chain and ring modes */
 struct stmmac_mode_ops {
 	void (*init) (void *des, dma_addr_t phy_addr, unsigned int size,
 		      unsigned int extend_desc);
 	unsigned int (*is_jumbo_frm) (int len, int ehn_desc);
-	int (*jumbo_frm)(void *priv, struct sk_buff *skb, int csum);
+	int (*jumbo_frm)(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
+			 int csum);
 	int (*set_16kib_bfsize)(int mtu);
 	void (*init_desc3)(struct dma_desc *p);
-	void (*refill_desc3) (void *priv, struct dma_desc *p);
-	void (*clean_desc3) (void *priv, struct dma_desc *p);
+	void (*refill_desc3)(struct stmmac_rx_queue *rx_q, struct dma_desc *p);
+	void (*clean_desc3)(struct stmmac_tx_queue *tx_q, struct dma_desc *p);
 };
 
 #define stmmac_mode_init(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index e3da4da242ee..350e6670a576 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -12,10 +12,10 @@
 #include "common.h"
 #include "descs_com.h"
 
-static int ndesc_get_tx_status(void *data, struct stmmac_extra_stats *x,
+static int ndesc_get_tx_status(struct net_device_stats *stats,
+			       struct stmmac_extra_stats *x,
 			       struct dma_desc *p, void __iomem *ioaddr)
 {
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 	unsigned int tdes0 = le32_to_cpu(p->des0);
 	unsigned int tdes1 = le32_to_cpu(p->des1);
 	int ret = tx_done;
@@ -70,12 +70,12 @@ static int ndesc_get_tx_len(struct dma_desc *p)
  * and, if required, updates the multicast statistics.
  * In case of success, it returns good_frame because the GMAC device
  * is supposed to be able to compute the csum in HW. */
-static int ndesc_get_rx_status(void *data, struct stmmac_extra_stats *x,
+static int ndesc_get_rx_status(struct net_device_stats *stats,
+			       struct stmmac_extra_stats *x,
 			       struct dma_desc *p)
 {
 	int ret = good_frame;
 	unsigned int rdes0 = le32_to_cpu(p->des0);
-	struct net_device_stats *stats = (struct net_device_stats *)data;
 
 	if (unlikely(rdes0 & RDES0_OWN))
 		return dma_own;
diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index 2b5b17d8b8a0..d218412ca832 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -14,9 +14,9 @@
 
 #include "stmmac.h"
 
-static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
+static int jumbo_frm(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
+		     int csum)
 {
-	struct stmmac_tx_queue *tx_q = (struct stmmac_tx_queue *)p;
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
@@ -101,9 +101,8 @@ static unsigned int is_jumbo_frm(int len, int enh_desc)
 	return ret;
 }
 
-static void refill_desc3(void *priv_ptr, struct dma_desc *p)
+static void refill_desc3(struct stmmac_rx_queue *rx_q, struct dma_desc *p)
 {
-	struct stmmac_rx_queue *rx_q = priv_ptr;
 	struct stmmac_priv *priv = rx_q->priv_data;
 
 	/* Fill DES3 in case of RING mode */
@@ -117,9 +116,8 @@ static void init_desc3(struct dma_desc *p)
 	p->des3 = cpu_to_le32(le32_to_cpu(p->des2) + BUF_SIZE_8KiB);
 }
 
-static void clean_desc3(void *priv_ptr, struct dma_desc *p)
+static void clean_desc3(struct stmmac_tx_queue *tx_q, struct dma_desc *p)
 {
-	struct stmmac_tx_queue *tx_q = (struct stmmac_tx_queue *)priv_ptr;
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->dirty_tx;
 
-- 
2.51.0



