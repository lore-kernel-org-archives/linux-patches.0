Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9443093B8;
	Tue,  2 Sep 2025 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820258; cv=none; b=qTrSfoZZLFnAC7imShPA/0WAsTdOtgRUTiUMs0oJCv2K8nDNG7VlNJyNeVXc7HNgXHwXEMvCDeyoyx3Jwfl3M9mBhpvzU9Pn9YShIve49R16LQj0fXvIhMQns0bCv16Fdg+O64ASLe8gFtE/CJkKCegOhjdf6D5P+zCOImFX3VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820258; c=relaxed/simple;
	bh=rskP4RvtYK6yG07GGPYOq1vvSNFx2nQmf4XUS5P10zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHeGibbk7Iy/rcngdjNAahXLovRgMdgWaRpe84uvvIKaFSdnb7SASlg8Te4ziTx5/TWr+H4yquo0410l+/DMijfw6BITCorQm8U69HWc+19un4tpwR2vSIrUI2PRc7eUNpj5qc+CPFwttLWIaa/p5xnnd4g2hBJF+TVQxZahH4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wotww4WZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wotww4WZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1215DC4CEED;
	Tue,  2 Sep 2025 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820258;
	bh=rskP4RvtYK6yG07GGPYOq1vvSNFx2nQmf4XUS5P10zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wotww4WZGdTVSvWwYSIQHqKtlzEdOhucmEKyLwaE1CCeUx2gpZgBNwRLbflNmtm/C
	 ALmtF5gRubTc34GP4btMsPz+oOuHiW+39Av5w39NOQl49k5PP6q9N+b5/8pZriJt9t
	 stve4Usnc4/0ooZztRa4f7yE+B9UkE42EMptitjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 49/75] net: stmmac: xgmac: Correct supported speed modes
Date: Tue,  2 Sep 2025 15:21:01 +0200
Message-ID: <20250902131937.045836851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit 42ef11b2bff5b6a2910c28d2ea47cc00e0fbcaec ]

Correct supported speed modes as per the XGMAC databook.
Commit 9cb54af214a7 ("net: stmmac: Fix IP-cores specific
MAC capabilities") removes support for 10M, 100M and
1000HD. 1000HD is not supported by XGMAC IP, but it does
support 10M and 100M FD mode for XGMAC version >= 2_20,
and it also supports 10M and 100M HD mode if the HDSEL bit
is set in the MAC_HW_FEATURE0 reg. This commit enables support
for 10M and 100M speed modes for XGMAC IP based on XGMAC
version and MAC capabilities.

Fixes: 9cb54af214a7 ("net: stmmac: Fix IP-cores specific MAC capabilities")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Link: https://patch.msgid.link/20250825-xgmac-minor-fixes-v3-2-c225fe4444c0@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 13 +++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |  5 +++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 052566f5b7f36..0bcb378fa0bc9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -47,6 +47,14 @@ static void dwxgmac2_core_init(struct mac_device_info *hw,
 	writel(XGMAC_INT_DEFAULT_EN, ioaddr + XGMAC_INT_EN);
 }
 
+static void dwxgmac2_update_caps(struct stmmac_priv *priv)
+{
+	if (!priv->dma_cap.mbps_10_100)
+		priv->hw->link.caps &= ~(MAC_10 | MAC_100);
+	else if (!priv->dma_cap.half_duplex)
+		priv->hw->link.caps &= ~(MAC_10HD | MAC_100HD);
+}
+
 static void dwxgmac2_set_mac(void __iomem *ioaddr, bool enable)
 {
 	u32 tx = readl(ioaddr + XGMAC_TX_CONFIG);
@@ -1583,6 +1591,7 @@ static void dwxgmac3_fpe_configure(void __iomem *ioaddr, struct stmmac_fpe_cfg *
 
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
+	.update_caps = dwxgmac2_update_caps,
 	.set_mac = dwxgmac2_set_mac,
 	.rx_ipc = dwxgmac2_rx_ipc,
 	.rx_queue_enable = dwxgmac2_rx_queue_enable,
@@ -1705,8 +1714,8 @@ int dwxgmac2_setup(struct stmmac_priv *priv)
 		mac->mcast_bits_log2 = ilog2(mac->multicast_filter_bins);
 
 	mac->link.caps = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
-			 MAC_1000FD | MAC_2500FD | MAC_5000FD |
-			 MAC_10000FD;
+			 MAC_10 | MAC_100 | MAC_1000FD |
+			 MAC_2500FD | MAC_5000FD | MAC_10000FD;
 	mac->link.duplex = 0;
 	mac->link.speed10 = XGMAC_CONFIG_SS_10_MII;
 	mac->link.speed100 = XGMAC_CONFIG_SS_100_MII;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 37c4258fef794..b2c03cb65c7cc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -382,8 +382,11 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 static int dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 				   struct dma_features *dma_cap)
 {
+	struct stmmac_priv *priv;
 	u32 hw_cap;
 
+	priv = container_of(dma_cap, struct stmmac_priv, dma_cap);
+
 	/* MAC HW feature 0 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE0);
 	dma_cap->edma = (hw_cap & XGMAC_HWFEAT_EDMA) >> 31;
@@ -406,6 +409,8 @@ static int dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->vlhash = (hw_cap & XGMAC_HWFEAT_VLHASH) >> 4;
 	dma_cap->half_duplex = (hw_cap & XGMAC_HWFEAT_HDSEL) >> 3;
 	dma_cap->mbps_1000 = (hw_cap & XGMAC_HWFEAT_GMIISEL) >> 1;
+	if (dma_cap->mbps_1000 && priv->synopsys_id >= DWXGMAC_CORE_2_20)
+		dma_cap->mbps_10_100 = 1;
 
 	/* MAC HW feature 1 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE1);
-- 
2.50.1



