Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BA212DD8C;
	Tue, 30 Apr 2024 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476701; cv=none; b=sb6EL2g6mrruDaGuUaHhGW3Hq7LP3lvWZvVoxAtVpC5vM3+lVKKUMfXbmnzOp1EDZ891+mZKASsReBXdxzwEQNJWpnSrcOx7K5nKCOWBefsqfgrPvatlf/E0KSITT6dHfGMYe/IMoDRBBV0NYQIsAkb4mrZzAmHNh9ypjbbBkFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476701; c=relaxed/simple;
	bh=Anqpf553B2prm9MNoZ4wmoXPklv/Lbmla3lraxcP6Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgizFYN7brAZopr9GNvyUuDcFpe5ySOs96qWokXCmxO9LhOAd+pzkihrcHY0FoFFQsz2+qpMEm32vjU5gBe6j/233kDbE7C45NspII/asIu1Yv1MOsZw858sKVZTRJBsVI8rdpTMR7tLq26pfmJjmpxRUHGbSwOKCg+h54RHUcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP/Pxtnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP/Pxtnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A1AC4AF1A;
	Tue, 30 Apr 2024 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476701;
	bh=Anqpf553B2prm9MNoZ4wmoXPklv/Lbmla3lraxcP6Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SP/PxtnhzvnChHeLXyq1dW00kr8CWY1RRPr4fwEDlejiHTY3yGr4BPpqIbIOCNWB+
	 7oLMLZcLEuar2QxW9pi9Op6qmgeP+GRf1V2KoMuosBpY+Ug7ND3y69eXmv4wVZ3HEH
	 lWsMoqJPwPP7f7mS98XEd7Z6FDDSvcP06u09rmGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Marek Vasut <marex@denx.de>,
	Richard Leitner <richard.leitner@skidata.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/110] phy: freescale: imx8m-pcie: Refine i.MX8MM PCIe PHY driver
Date: Tue, 30 Apr 2024 12:41:06 +0200
Message-ID: <20240430103050.436562732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit ca679c49c4463595499a053ba94328acb574fffa ]

To make it more flexible and easy to expand. Refine i.MX8MM PCIe PHY
driver.
- Use gpr compatible string to avoid the codes duplications when add
  another platform PCIe PHY support.
- Re-arrange the codes to let it more flexible and easy to expand.
No functional change. Re-arrange the TX tuning, since internal registers
can be wrote through APB interface before assertion of CMN_RST.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Marek Vasut <marex@denx.de>
Tested-by: Richard Leitner <richard.leitner@skidata.com>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/1665625622-20551-4-git-send-email-hongxing.zhu@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 3a161017f1de ("phy: freescale: imx8m-pcie: fix pcie link-up instability")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c | 106 +++++++++++++--------
 1 file changed, 66 insertions(+), 40 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
index c93286483b425..f1476936b8d9a 100644
--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -11,6 +11,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx7-iomuxc-gpr.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
@@ -47,6 +48,15 @@
 #define IMX8MM_GPR_PCIE_SSC_EN		BIT(16)
 #define IMX8MM_GPR_PCIE_AUX_EN_OVERRIDE	BIT(9)
 
+enum imx8_pcie_phy_type {
+	IMX8MM,
+};
+
+struct imx8_pcie_phy_drvdata {
+	const	char			*gpr;
+	enum	imx8_pcie_phy_type	variant;
+};
+
 struct imx8_pcie_phy {
 	void __iomem		*base;
 	struct clk		*clk;
@@ -57,6 +67,7 @@ struct imx8_pcie_phy {
 	u32			tx_deemph_gen1;
 	u32			tx_deemph_gen2;
 	bool			clkreq_unused;
+	const struct imx8_pcie_phy_drvdata	*drvdata;
 };
 
 static int imx8_pcie_phy_power_on(struct phy *phy)
@@ -68,31 +79,17 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 	reset_control_assert(imx8_phy->reset);
 
 	pad_mode = imx8_phy->refclk_pad_mode;
-	/* Set AUX_EN_OVERRIDE 1'b0, when the CLKREQ# isn't hooked */
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_AUX_EN_OVERRIDE,
-			   imx8_phy->clkreq_unused ?
-			   0 : IMX8MM_GPR_PCIE_AUX_EN_OVERRIDE);
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_AUX_EN,
-			   IMX8MM_GPR_PCIE_AUX_EN);
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_POWER_OFF, 0);
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_SSC_EN, 0);
-
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_REF_CLK_SEL,
-			   pad_mode == IMX8_PCIE_REFCLK_PAD_INPUT ?
-			   IMX8MM_GPR_PCIE_REF_CLK_EXT :
-			   IMX8MM_GPR_PCIE_REF_CLK_PLL);
-	usleep_range(100, 200);
-
-	/* Do the PHY common block reset */
-	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
-			   IMX8MM_GPR_PCIE_CMN_RST,
-			   IMX8MM_GPR_PCIE_CMN_RST);
-	usleep_range(200, 500);
+	switch (imx8_phy->drvdata->variant) {
+	case IMX8MM:
+		/* Tune PHY de-emphasis setting to pass PCIe compliance. */
+		if (imx8_phy->tx_deemph_gen1)
+			writel(imx8_phy->tx_deemph_gen1,
+			       imx8_phy->base + PCIE_PHY_TRSV_REG5);
+		if (imx8_phy->tx_deemph_gen2)
+			writel(imx8_phy->tx_deemph_gen2,
+			       imx8_phy->base + PCIE_PHY_TRSV_REG6);
+		break;
+	}
 
 	if (pad_mode == IMX8_PCIE_REFCLK_PAD_INPUT ||
 	    pad_mode == IMX8_PCIE_REFCLK_PAD_UNUSED) {
@@ -120,15 +117,37 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 		       imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG065);
 	}
 
-	/* Tune PHY de-emphasis setting to pass PCIe compliance. */
-	if (imx8_phy->tx_deemph_gen1)
-		writel(imx8_phy->tx_deemph_gen1,
-		       imx8_phy->base + PCIE_PHY_TRSV_REG5);
-	if (imx8_phy->tx_deemph_gen2)
-		writel(imx8_phy->tx_deemph_gen2,
-		       imx8_phy->base + PCIE_PHY_TRSV_REG6);
+	/* Set AUX_EN_OVERRIDE 1'b0, when the CLKREQ# isn't hooked */
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_AUX_EN_OVERRIDE,
+			   imx8_phy->clkreq_unused ?
+			   0 : IMX8MM_GPR_PCIE_AUX_EN_OVERRIDE);
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_AUX_EN,
+			   IMX8MM_GPR_PCIE_AUX_EN);
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_POWER_OFF, 0);
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_SSC_EN, 0);
 
-	reset_control_deassert(imx8_phy->reset);
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_REF_CLK_SEL,
+			   pad_mode == IMX8_PCIE_REFCLK_PAD_INPUT ?
+			   IMX8MM_GPR_PCIE_REF_CLK_EXT :
+			   IMX8MM_GPR_PCIE_REF_CLK_PLL);
+	usleep_range(100, 200);
+
+	/* Do the PHY common block reset */
+	regmap_update_bits(imx8_phy->iomuxc_gpr, IOMUXC_GPR14,
+			   IMX8MM_GPR_PCIE_CMN_RST,
+			   IMX8MM_GPR_PCIE_CMN_RST);
+
+	switch (imx8_phy->drvdata->variant) {
+	case IMX8MM:
+		reset_control_deassert(imx8_phy->reset);
+		usleep_range(200, 500);
+		break;
+	}
 
 	/* Polling to check the phy is ready or not. */
 	ret = readl_poll_timeout(imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG75,
@@ -160,6 +179,17 @@ static const struct phy_ops imx8_pcie_phy_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static const struct imx8_pcie_phy_drvdata imx8mm_drvdata = {
+	.gpr = "fsl,imx8mm-iomuxc-gpr",
+	.variant = IMX8MM,
+};
+
+static const struct of_device_id imx8_pcie_phy_of_match[] = {
+	{.compatible = "fsl,imx8mm-pcie-phy", .data = &imx8mm_drvdata, },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, imx8_pcie_phy_of_match);
+
 static int imx8_pcie_phy_probe(struct platform_device *pdev)
 {
 	struct phy_provider *phy_provider;
@@ -172,6 +202,8 @@ static int imx8_pcie_phy_probe(struct platform_device *pdev)
 	if (!imx8_phy)
 		return -ENOMEM;
 
+	imx8_phy->drvdata = of_device_get_match_data(dev);
+
 	/* get PHY refclk pad mode */
 	of_property_read_u32(np, "fsl,refclk-pad-mode",
 			     &imx8_phy->refclk_pad_mode);
@@ -197,7 +229,7 @@ static int imx8_pcie_phy_probe(struct platform_device *pdev)
 
 	/* Grab GPR config register range */
 	imx8_phy->iomuxc_gpr =
-		 syscon_regmap_lookup_by_compatible("fsl,imx6q-iomuxc-gpr");
+		 syscon_regmap_lookup_by_compatible(imx8_phy->drvdata->gpr);
 	if (IS_ERR(imx8_phy->iomuxc_gpr)) {
 		dev_err(dev, "unable to find iomuxc registers\n");
 		return PTR_ERR(imx8_phy->iomuxc_gpr);
@@ -225,12 +257,6 @@ static int imx8_pcie_phy_probe(struct platform_device *pdev)
 	return PTR_ERR_OR_ZERO(phy_provider);
 }
 
-static const struct of_device_id imx8_pcie_phy_of_match[] = {
-	{.compatible = "fsl,imx8mm-pcie-phy",},
-	{ },
-};
-MODULE_DEVICE_TABLE(of, imx8_pcie_phy_of_match);
-
 static struct platform_driver imx8_pcie_phy_driver = {
 	.probe	= imx8_pcie_phy_probe,
 	.driver = {
-- 
2.43.0



