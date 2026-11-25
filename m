Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625250;
	b=25f4r4n+cU/umJI2RME2q2bdKN07daqpX5kfsxWlaPJwuR2LegeSIapaf/DkuaB+v9Xg
	 RccCg4/0wpP4OCAsaTjd58SgrUjjoMBUaREL4qWagoYutMQrCs/dCIhdTUGxVv8+Y7CGF
	 Pb/QNMM7jSCRh4ic/REG0I5nHbBGCt6hkuVxNVIT/2onk42fAFyyINbOvU55hS3ZgiMUN
	 pwSbGDn1PFt9RY/ppJR8jeDAQAdSPPtRSSlCVFxuWzhnOnRhxD17DvCS9QkrbgQvfRtx2
	 TpZYBTG1aXLXDgIMtIyQsaO5IITdr24nJMu4Uj2w3C2i5VN/2SbWyIpvMKby8N9zFdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qHRLHKviUa8HJRw+gWWPxKxN35RTlTqjyEu7TEZAmiE=;
	b=nRpWRMScXG2EWvr1gVuGhP5/OEUaAHr1yNtLK8aDBBK5BchjeJaN2pJAGiyQcFEKBOMn
	 Lnk/LOodeRMahg7NxZr4951ROt2rtRApy88jV3Xe4iQdHj74/MIQc4dlGzK+vy9znJSJg
	 I1u5EDpNur50akbzfPWuogLo/RA7drfJmCQlKRreodf0z2Gtf0X+RLnDFqRMB2x8MXI1n
	 Xh2IJkpwPirvcmNvQvAJbL2N1S1G++1LgPVs1YTtOjyJTc7HvTjOQ9qboYhPjGHB9vUcQ
	 KWTUBcGE3ZZn0fLhfwRhAzMJUJCrPeNxrrXnpov62NLUO+untU/Ynvzlj9eZI8qZQpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJTGjSBy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984D7606A323;
	Wed, 25 Nov 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJTGjSBy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7791F000C4;
	Wed, 25 Nov 2026 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625249;
	bh=qHRLHKviUa8HJRw+gWWPxKxN35RTlTqjyEu7TEZAmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJTGjSByvoVQVkqSpf/nqdb+UwrZ/tPpuwYYhXFrvBXZ0tVR5KaKiaoraOoo13l/r
	 wZ/DWre+XTp+1wAkt2ZVXiWoyzvR+kGsKTQYifZqmSfHaOgx+tfizMHDJFB3bj5n/Y
	 KolNMtlBUUETqq+QZ8ECfBfjIGXuCEe+bqIiqxRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/816] phy: rockchip: naneng-combphy: Add SoC prefix to register definitions
Date: Wed, 25 Nov 2026 15:33:22 +0100
Message-ID: <20261125143859.698630113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit b3bbc6afcff50e2fd4d51dd64929e62d66fdc814 ]

All supported variants of naneng-combphy follow a register layout
similar to the RK3568 variant with some exceptions of SoC-specific
registers.

Add RK3568 prefix for the common set of registers and the corresponding
SoC prefix for SoC-specific registers, making usage of definitions clear
and preparing for future COMBPHY variants with a different register
layout.

Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250728102947.38984-6-ziyao@disroot.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: d68e47a06c5c ("phy: rockchip: naneng-combphy: Fix TX detect RX termination errata")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../rockchip/phy-rockchip-naneng-combphy.c    | 301 +++++++++---------
 1 file changed, 151 insertions(+), 150 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index fbaeb7ca600d1..11b5e43993fea 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -21,64 +21,65 @@
 #define REF_CLOCK_100MHz		(100 * HZ_PER_MHZ)
 
 /* COMBO PHY REG */
-#define PHYREG6				0x14
-#define PHYREG6_PLL_DIV_MASK		GENMASK(7, 6)
-#define PHYREG6_PLL_DIV_SHIFT		6
-#define PHYREG6_PLL_DIV_2		1
-
-#define PHYREG7				0x18
-#define PHYREG7_TX_RTERM_MASK		GENMASK(7, 4)
-#define PHYREG7_TX_RTERM_SHIFT		4
-#define PHYREG7_TX_RTERM_50OHM		8
-#define PHYREG7_RX_RTERM_MASK		GENMASK(3, 0)
-#define PHYREG7_RX_RTERM_SHIFT		0
-#define PHYREG7_RX_RTERM_44OHM		15
-
-#define PHYREG8				0x1C
-#define PHYREG8_SSC_EN			BIT(4)
-
-#define PHYREG11			0x28
-#define PHYREG11_SU_TRIM_0_7		0xF0
-
-#define PHYREG12			0x2C
-#define PHYREG12_PLL_LPF_ADJ_VALUE	4
-
-#define PHYREG13			0x30
-#define PHYREG13_RESISTER_MASK		GENMASK(5, 4)
-#define PHYREG13_RESISTER_SHIFT		0x4
-#define PHYREG13_RESISTER_HIGH_Z	3
-#define PHYREG13_CKRCV_AMP0		BIT(7)
-
-#define PHYREG14			0x34
-#define PHYREG14_CKRCV_AMP1		BIT(0)
-
-#define PHYREG15			0x38
-#define PHYREG15_CTLE_EN		BIT(0)
-#define PHYREG15_SSC_CNT_MASK		GENMASK(7, 6)
-#define PHYREG15_SSC_CNT_SHIFT		6
-#define PHYREG15_SSC_CNT_VALUE		1
-
-#define PHYREG16			0x3C
-#define PHYREG16_SSC_CNT_VALUE		0x5f
-
-#define PHYREG18			0x44
-#define PHYREG18_PLL_LOOP		0x32
-
-#define PHYREG27			0x6C
-#define PHYREG27_RX_TRIM_RK3588		0x4C
-
-#define PHYREG32			0x7C
-#define PHYREG32_SSC_MASK		GENMASK(7, 4)
-#define PHYREG32_SSC_DIR_SHIFT		4
-#define PHYREG32_SSC_UPWARD		0
-#define PHYREG32_SSC_DOWNWARD		1
-#define PHYREG32_SSC_OFFSET_SHIFT	6
-#define PHYREG32_SSC_OFFSET_500PPM	1
-
-#define PHYREG33			0x80
-#define PHYREG33_PLL_KVCO_MASK		GENMASK(4, 2)
-#define PHYREG33_PLL_KVCO_SHIFT		2
-#define PHYREG33_PLL_KVCO_VALUE		2
+#define RK3568_PHYREG6			0x14
+#define RK3568_PHYREG6_PLL_DIV_MASK	GENMASK(7, 6)
+#define RK3568_PHYREG6_PLL_DIV_SHIFT	6
+#define RK3568_PHYREG6_PLL_DIV_2	1
+
+#define RK3568_PHYREG7			0x18
+#define RK3568_PHYREG7_TX_RTERM_MASK	GENMASK(7, 4)
+#define RK3568_PHYREG7_TX_RTERM_SHIFT	4
+#define RK3568_PHYREG7_TX_RTERM_50OHM	8
+#define RK3568_PHYREG7_RX_RTERM_MASK	GENMASK(3, 0)
+#define RK3568_PHYREG7_RX_RTERM_SHIFT	0
+#define RK3568_PHYREG7_RX_RTERM_44OHM	15
+
+#define RK3568_PHYREG8			0x1C
+#define RK3568_PHYREG8_SSC_EN		BIT(4)
+
+#define RK3568_PHYREG11			0x28
+#define RK3568_PHYREG11_SU_TRIM_0_7	0xF0
+
+#define RK3568_PHYREG12			0x2C
+#define RK3568_PHYREG12_PLL_LPF_ADJ_VALUE	4
+
+#define RK3568_PHYREG13			0x30
+#define RK3568_PHYREG13_RESISTER_MASK	GENMASK(5, 4)
+#define RK3568_PHYREG13_RESISTER_SHIFT	0x4
+#define RK3568_PHYREG13_RESISTER_HIGH_Z	3
+#define RK3568_PHYREG13_CKRCV_AMP0	BIT(7)
+
+#define RK3568_PHYREG14			0x34
+#define RK3568_PHYREG14_CKRCV_AMP1	BIT(0)
+
+#define RK3568_PHYREG15			0x38
+#define RK3568_PHYREG15_CTLE_EN		BIT(0)
+#define RK3568_PHYREG15_SSC_CNT_MASK	GENMASK(7, 6)
+#define RK3568_PHYREG15_SSC_CNT_SHIFT	6
+#define RK3568_PHYREG15_SSC_CNT_VALUE	1
+
+#define RK3568_PHYREG16			0x3C
+#define RK3568_PHYREG16_SSC_CNT_VALUE	0x5f
+
+#define RK3568_PHYREG18			0x44
+#define RK3568_PHYREG18_PLL_LOOP	0x32
+
+#define RK3568_PHYREG32			0x7C
+#define RK3568_PHYREG32_SSC_MASK	GENMASK(7, 4)
+#define RK3568_PHYREG32_SSC_DIR_SHIFT	4
+#define RK3568_PHYREG32_SSC_UPWARD	0
+#define RK3568_PHYREG32_SSC_DOWNWARD	1
+#define RK3568_PHYREG32_SSC_OFFSET_SHIFT	6
+#define RK3568_PHYREG32_SSC_OFFSET_500PPM	1
+
+#define RK3568_PHYREG33			0x80
+#define RK3568_PHYREG33_PLL_KVCO_MASK	GENMASK(4, 2)
+#define RK3568_PHYREG33_PLL_KVCO_SHIFT	2
+#define RK3568_PHYREG33_PLL_KVCO_VALUE	2
+
+/* RK3588 COMBO PHY registers */
+#define RK3588_PHYREG27			0x6C
+#define RK3588_PHYREG27_RX_TRIM		0x4C
 
 struct rockchip_combphy_priv;
 
@@ -392,9 +393,9 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 	switch (priv->type) {
 	case PHY_TYPE_PCIE:
 		/* Set SSC downward spread spectrum. */
-		rockchip_combphy_updatel(priv, PHYREG32_SSC_MASK,
-					 PHYREG32_SSC_DOWNWARD << PHYREG32_SSC_DIR_SHIFT,
-					 PHYREG32);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG32_SSC_MASK,
+					 RK3568_PHYREG32_SSC_DOWNWARD << RK3568_PHYREG32_SSC_DIR_SHIFT,
+					 RK3568_PHYREG32);
 
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_pcie, true);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
@@ -404,30 +405,30 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 
 	case PHY_TYPE_USB3:
 		/* Set SSC downward spread spectrum. */
-		rockchip_combphy_updatel(priv, PHYREG32_SSC_MASK,
-					 PHYREG32_SSC_DOWNWARD << PHYREG32_SSC_DIR_SHIFT,
-					 PHYREG32);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG32_SSC_MASK,
+					 RK3568_PHYREG32_SSC_DOWNWARD << RK3568_PHYREG32_SSC_DIR_SHIFT,
+					 RK3568_PHYREG32);
 
 		/* Enable adaptive CTLE for USB3.0 Rx. */
-		val = readl(priv->mmio + PHYREG15);
-		val |= PHYREG15_CTLE_EN;
-		writel(val, priv->mmio + PHYREG15);
+		val = readl(priv->mmio + RK3568_PHYREG15);
+		val |= RK3568_PHYREG15_CTLE_EN;
+		writel(val, priv->mmio + RK3568_PHYREG15);
 
 		/* Set PLL KVCO fine tuning signals. */
-		rockchip_combphy_updatel(priv, PHYREG33_PLL_KVCO_MASK,
-					 PHYREG33_PLL_KVCO_VALUE << PHYREG33_PLL_KVCO_SHIFT,
-					 PHYREG33);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG33_PLL_KVCO_MASK,
+					 RK3568_PHYREG33_PLL_KVCO_VALUE << RK3568_PHYREG33_PLL_KVCO_SHIFT,
+					 RK3568_PHYREG33);
 
 		/* Enable controlling random jitter. */
-		writel(PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + PHYREG12);
+		writel(RK3568_PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + RK3568_PHYREG12);
 
 		/* Set PLL input clock divider 1/2. */
-		rockchip_combphy_updatel(priv, PHYREG6_PLL_DIV_MASK,
-					 PHYREG6_PLL_DIV_2 << PHYREG6_PLL_DIV_SHIFT,
-					 PHYREG6);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG6_PLL_DIV_MASK,
+					 RK3568_PHYREG6_PLL_DIV_2 << RK3568_PHYREG6_PLL_DIV_SHIFT,
+					 RK3568_PHYREG6);
 
-		writel(PHYREG18_PLL_LOOP, priv->mmio + PHYREG18);
-		writel(PHYREG11_SU_TRIM_0_7, priv->mmio + PHYREG11);
+		writel(RK3568_PHYREG18_PLL_LOOP, priv->mmio + RK3568_PHYREG18);
+		writel(RK3568_PHYREG11_SU_TRIM_0_7, priv->mmio + RK3568_PHYREG11);
 
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_sel_usb, true);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
@@ -445,16 +446,16 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 
 	case PHY_TYPE_SATA:
 		/* Enable adaptive CTLE for SATA Rx. */
-		val = readl(priv->mmio + PHYREG15);
-		val |= PHYREG15_CTLE_EN;
-		writel(val, priv->mmio + PHYREG15);
+		val = readl(priv->mmio + RK3568_PHYREG15);
+		val |= RK3568_PHYREG15_CTLE_EN;
+		writel(val, priv->mmio + RK3568_PHYREG15);
 		/*
 		 * Set tx_rterm=50ohm and rx_rterm=44ohm for SATA.
 		 * 0: 60ohm, 8: 50ohm 15: 44ohm (by step abort 1ohm)
 		 */
-		val = PHYREG7_TX_RTERM_50OHM << PHYREG7_TX_RTERM_SHIFT;
-		val |= PHYREG7_RX_RTERM_44OHM << PHYREG7_RX_RTERM_SHIFT;
-		writel(val, priv->mmio + PHYREG7);
+		val = RK3568_PHYREG7_TX_RTERM_50OHM << RK3568_PHYREG7_TX_RTERM_SHIFT;
+		val |= RK3568_PHYREG7_RX_RTERM_44OHM << RK3568_PHYREG7_RX_RTERM_SHIFT;
+		writel(val, priv->mmio + RK3568_PHYREG7);
 
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_sata, true);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_sata, true);
@@ -489,11 +490,11 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 	case REF_CLOCK_24MHz:
 		if (priv->type == PHY_TYPE_USB3 || priv->type == PHY_TYPE_SATA) {
 			/* Set ssc_cnt[9:0]=0101111101 & 31.5KHz. */
-			val = PHYREG15_SSC_CNT_VALUE << PHYREG15_SSC_CNT_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG15_SSC_CNT_MASK,
-						 val, PHYREG15);
+			val = RK3568_PHYREG15_SSC_CNT_VALUE << RK3568_PHYREG15_SSC_CNT_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG15_SSC_CNT_MASK,
+						 val, RK3568_PHYREG15);
 
-			writel(PHYREG16_SSC_CNT_VALUE, priv->mmio + PHYREG16);
+			writel(RK3568_PHYREG16_SSC_CNT_VALUE, priv->mmio + RK3568_PHYREG16);
 		}
 		break;
 
@@ -505,24 +506,24 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
 		if (priv->type == PHY_TYPE_PCIE) {
 			/* PLL KVCO  fine tuning. */
-			val = PHYREG33_PLL_KVCO_VALUE << PHYREG33_PLL_KVCO_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG33_PLL_KVCO_MASK,
-						 val, PHYREG33);
+			val = RK3568_PHYREG33_PLL_KVCO_VALUE << RK3568_PHYREG33_PLL_KVCO_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG33_PLL_KVCO_MASK,
+						 val, RK3568_PHYREG33);
 
 			/* Enable controlling random jitter. */
-			writel(PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + PHYREG12);
+			writel(RK3568_PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + RK3568_PHYREG12);
 
-			val = PHYREG6_PLL_DIV_2 << PHYREG6_PLL_DIV_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG6_PLL_DIV_MASK,
-						 val, PHYREG6);
+			val = RK3568_PHYREG6_PLL_DIV_2 << RK3568_PHYREG6_PLL_DIV_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG6_PLL_DIV_MASK,
+						 val, RK3568_PHYREG6);
 
-			writel(PHYREG18_PLL_LOOP, priv->mmio + PHYREG18);
-			writel(PHYREG11_SU_TRIM_0_7, priv->mmio + PHYREG11);
+			writel(RK3568_PHYREG18_PLL_LOOP, priv->mmio + RK3568_PHYREG18);
+			writel(RK3568_PHYREG11_SU_TRIM_0_7, priv->mmio + RK3568_PHYREG11);
 		} else if (priv->type == PHY_TYPE_SATA) {
 			/* downward spread spectrum +500ppm */
-			val = PHYREG32_SSC_DOWNWARD << PHYREG32_SSC_DIR_SHIFT;
-			val |= PHYREG32_SSC_OFFSET_500PPM << PHYREG32_SSC_OFFSET_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG32_SSC_MASK, val, PHYREG32);
+			val = RK3568_PHYREG32_SSC_DOWNWARD << RK3568_PHYREG32_SSC_DIR_SHIFT;
+			val |= RK3568_PHYREG32_SSC_OFFSET_500PPM << RK3568_PHYREG32_SSC_OFFSET_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG32_SSC_MASK, val, RK3568_PHYREG32);
 		}
 		break;
 
@@ -534,20 +535,20 @@ static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
 	if (priv->ext_refclk) {
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
 		if (priv->type == PHY_TYPE_PCIE && rate == REF_CLOCK_100MHz) {
-			val = PHYREG13_RESISTER_HIGH_Z << PHYREG13_RESISTER_SHIFT;
-			val |= PHYREG13_CKRCV_AMP0;
-			rockchip_combphy_updatel(priv, PHYREG13_RESISTER_MASK, val, PHYREG13);
+			val = RK3568_PHYREG13_RESISTER_HIGH_Z << RK3568_PHYREG13_RESISTER_SHIFT;
+			val |= RK3568_PHYREG13_CKRCV_AMP0;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG13_RESISTER_MASK, val, RK3568_PHYREG13);
 
-			val = readl(priv->mmio + PHYREG14);
-			val |= PHYREG14_CKRCV_AMP1;
-			writel(val, priv->mmio + PHYREG14);
+			val = readl(priv->mmio + RK3568_PHYREG14);
+			val |= RK3568_PHYREG14_CKRCV_AMP1;
+			writel(val, priv->mmio + RK3568_PHYREG14);
 		}
 	}
 
 	if (priv->enable_ssc) {
-		val = readl(priv->mmio + PHYREG8);
-		val |= PHYREG8_SSC_EN;
-		writel(val, priv->mmio + PHYREG8);
+		val = readl(priv->mmio + RK3568_PHYREG8);
+		val |= RK3568_PHYREG8_SSC_EN;
+		writel(val, priv->mmio + RK3568_PHYREG8);
 	}
 
 	return 0;
@@ -622,30 +623,30 @@ static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
 		break;
 	case PHY_TYPE_USB3:
 		/* Set SSC downward spread spectrum */
-		rockchip_combphy_updatel(priv, PHYREG32_SSC_MASK,
-					 PHYREG32_SSC_DOWNWARD << PHYREG32_SSC_DIR_SHIFT,
-					 PHYREG32);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG32_SSC_MASK,
+					 RK3568_PHYREG32_SSC_DOWNWARD << RK3568_PHYREG32_SSC_DIR_SHIFT,
+					 RK3568_PHYREG32);
 
 		/* Enable adaptive CTLE for USB3.0 Rx. */
-		val = readl(priv->mmio + PHYREG15);
-		val |= PHYREG15_CTLE_EN;
-		writel(val, priv->mmio + PHYREG15);
+		val = readl(priv->mmio + RK3568_PHYREG15);
+		val |= RK3568_PHYREG15_CTLE_EN;
+		writel(val, priv->mmio + RK3568_PHYREG15);
 
 		/* Set PLL KVCO fine tuning signals. */
-		rockchip_combphy_updatel(priv, PHYREG33_PLL_KVCO_MASK,
-					 PHYREG33_PLL_KVCO_VALUE << PHYREG33_PLL_KVCO_SHIFT,
-					 PHYREG33);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG33_PLL_KVCO_MASK,
+					 RK3568_PHYREG33_PLL_KVCO_VALUE << RK3568_PHYREG33_PLL_KVCO_SHIFT,
+					 RK3568_PHYREG33);
 
 		/* Enable controlling random jitter. */
-		writel(PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + PHYREG12);
+		writel(RK3568_PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + RK3568_PHYREG12);
 
 		/* Set PLL input clock divider 1/2. */
-		rockchip_combphy_updatel(priv, PHYREG6_PLL_DIV_MASK,
-					 PHYREG6_PLL_DIV_2 << PHYREG6_PLL_DIV_SHIFT,
-					 PHYREG6);
+		rockchip_combphy_updatel(priv, RK3568_PHYREG6_PLL_DIV_MASK,
+					 RK3568_PHYREG6_PLL_DIV_2 << RK3568_PHYREG6_PLL_DIV_SHIFT,
+					 RK3568_PHYREG6);
 
-		writel(PHYREG18_PLL_LOOP, priv->mmio + PHYREG18);
-		writel(PHYREG11_SU_TRIM_0_7, priv->mmio + PHYREG11);
+		writel(RK3568_PHYREG18_PLL_LOOP, priv->mmio + RK3568_PHYREG18);
+		writel(RK3568_PHYREG11_SU_TRIM_0_7, priv->mmio + RK3568_PHYREG11);
 
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
@@ -653,16 +654,16 @@ static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
 		break;
 	case PHY_TYPE_SATA:
 		/* Enable adaptive CTLE for SATA Rx. */
-		val = readl(priv->mmio + PHYREG15);
-		val |= PHYREG15_CTLE_EN;
-		writel(val, priv->mmio + PHYREG15);
+		val = readl(priv->mmio + RK3568_PHYREG15);
+		val |= RK3568_PHYREG15_CTLE_EN;
+		writel(val, priv->mmio + RK3568_PHYREG15);
 		/*
 		 * Set tx_rterm=50ohm and rx_rterm=44ohm for SATA.
 		 * 0: 60ohm, 8: 50ohm 15: 44ohm (by step abort 1ohm)
 		 */
-		val = PHYREG7_TX_RTERM_50OHM << PHYREG7_TX_RTERM_SHIFT;
-		val |= PHYREG7_RX_RTERM_44OHM << PHYREG7_RX_RTERM_SHIFT;
-		writel(val, priv->mmio + PHYREG7);
+		val = RK3568_PHYREG7_TX_RTERM_50OHM << RK3568_PHYREG7_TX_RTERM_SHIFT;
+		val |= RK3568_PHYREG7_RX_RTERM_44OHM << RK3568_PHYREG7_RX_RTERM_SHIFT;
+		writel(val, priv->mmio + RK3568_PHYREG7);
 
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_sata, true);
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_sata, true);
@@ -684,11 +685,11 @@ static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
 	case REF_CLOCK_24MHz:
 		if (priv->type == PHY_TYPE_USB3 || priv->type == PHY_TYPE_SATA) {
 			/* Set ssc_cnt[9:0]=0101111101 & 31.5KHz. */
-			val = PHYREG15_SSC_CNT_VALUE << PHYREG15_SSC_CNT_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG15_SSC_CNT_MASK,
-						 val, PHYREG15);
+			val = RK3568_PHYREG15_SSC_CNT_VALUE << RK3568_PHYREG15_SSC_CNT_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG15_SSC_CNT_MASK,
+						 val, RK3568_PHYREG15);
 
-			writel(PHYREG16_SSC_CNT_VALUE, priv->mmio + PHYREG16);
+			writel(RK3568_PHYREG16_SSC_CNT_VALUE, priv->mmio + RK3568_PHYREG16);
 		}
 		break;
 
@@ -699,23 +700,23 @@ static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
 		if (priv->type == PHY_TYPE_PCIE) {
 			/* PLL KVCO fine tuning. */
-			val = 4 << PHYREG33_PLL_KVCO_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG33_PLL_KVCO_MASK,
-						 val, PHYREG33);
+			val = 4 << RK3568_PHYREG33_PLL_KVCO_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG33_PLL_KVCO_MASK,
+						 val, RK3568_PHYREG33);
 
 			/* Enable controlling random jitter. */
-			writel(PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + PHYREG12);
+			writel(RK3568_PHYREG12_PLL_LPF_ADJ_VALUE, priv->mmio + RK3568_PHYREG12);
 
 			/* Set up rx_trim: PLL LPF C1 85pf R1 1.25kohm */
-			writel(PHYREG27_RX_TRIM_RK3588, priv->mmio + PHYREG27);
+			writel(RK3588_PHYREG27_RX_TRIM, priv->mmio + RK3588_PHYREG27);
 
 			/* Set up su_trim:  */
-			writel(PHYREG11_SU_TRIM_0_7, priv->mmio + PHYREG11);
+			writel(RK3568_PHYREG11_SU_TRIM_0_7, priv->mmio + RK3568_PHYREG11);
 		} else if (priv->type == PHY_TYPE_SATA) {
 			/* downward spread spectrum +500ppm */
-			val = PHYREG32_SSC_DOWNWARD << PHYREG32_SSC_DIR_SHIFT;
-			val |= PHYREG32_SSC_OFFSET_500PPM << PHYREG32_SSC_OFFSET_SHIFT;
-			rockchip_combphy_updatel(priv, PHYREG32_SSC_MASK, val, PHYREG32);
+			val = RK3568_PHYREG32_SSC_DOWNWARD << RK3568_PHYREG32_SSC_DIR_SHIFT;
+			val |= RK3568_PHYREG32_SSC_OFFSET_500PPM << RK3568_PHYREG32_SSC_OFFSET_SHIFT;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG32_SSC_MASK, val, RK3568_PHYREG32);
 		}
 		break;
 	default:
@@ -726,20 +727,20 @@ static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
 	if (priv->ext_refclk) {
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
 		if (priv->type == PHY_TYPE_PCIE && rate == REF_CLOCK_100MHz) {
-			val = PHYREG13_RESISTER_HIGH_Z << PHYREG13_RESISTER_SHIFT;
-			val |= PHYREG13_CKRCV_AMP0;
-			rockchip_combphy_updatel(priv, PHYREG13_RESISTER_MASK, val, PHYREG13);
+			val = RK3568_PHYREG13_RESISTER_HIGH_Z << RK3568_PHYREG13_RESISTER_SHIFT;
+			val |= RK3568_PHYREG13_CKRCV_AMP0;
+			rockchip_combphy_updatel(priv, RK3568_PHYREG13_RESISTER_MASK, val, RK3568_PHYREG13);
 
-			val = readl(priv->mmio + PHYREG14);
-			val |= PHYREG14_CKRCV_AMP1;
-			writel(val, priv->mmio + PHYREG14);
+			val = readl(priv->mmio + RK3568_PHYREG14);
+			val |= RK3568_PHYREG14_CKRCV_AMP1;
+			writel(val, priv->mmio + RK3568_PHYREG14);
 		}
 	}
 
 	if (priv->enable_ssc) {
-		val = readl(priv->mmio + PHYREG8);
-		val |= PHYREG8_SSC_EN;
-		writel(val, priv->mmio + PHYREG8);
+		val = readl(priv->mmio + RK3568_PHYREG8);
+		val |= RK3568_PHYREG8_SSC_EN;
+		writel(val, priv->mmio + RK3568_PHYREG8);
 	}
 
 	return 0;
-- 
2.53.0



