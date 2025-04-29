Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CDF25332E;
	Tue, 29 Apr 2025 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949718; cv=none; b=N/QaKsu4i1DxinRHsYSTzrzTHL1jkEIgBiyjbr+tBa3FngBVw0X9T/GoAfhpzV2upqfRt5cJC8/kNZ+pmBIS/Hv74GwdEnSS3uplwznteUavn+0+SMCd12rljGZDwqZQTXLDpVObAMigBWFZmH5Ggw0l6FBGkA2qhB3k8Mzys8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949718; c=relaxed/simple;
	bh=Uvklg8GafiDFfYQbrQnY2wJafV4dfA/PFCtcKrppmSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxUeN0SjDiNEJFJ9e2iAH1Traph36ywRJW1gW7GyCywQB37hIo3zMeTEIgobDvKYcTdS90ARlNpCdrORrHC4wvW3dRlp4t5EHBxVP2HauZdgayYlQni+cmREWoRxagKY/LFr7OPkUbvUwmy6VIsK2FmIPTYc8YA1MwOiKbSWTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxDsJ7Bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxDsJ7Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3B5C4CEE3;
	Tue, 29 Apr 2025 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949717;
	bh=Uvklg8GafiDFfYQbrQnY2wJafV4dfA/PFCtcKrppmSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxDsJ7BnOKgjbDR01cwThr7x0hY6EG8Gm3tL6khZjPEsMHCk3Kh4GyHMzyilMvvg+
	 iGUplkPvkBMFeFH/9nDStBrHvfBJ2hO7p8vkvIgp/bbquegecYUpi7Af1igMg2UCzh
	 TCqC0MoDrcQ7uIhEntT2XdKj8qcj1YWJGXtdcjoU=
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
Subject: [PATCH 6.1 035/167] phy: freescale: imx8m-pcie: Add i.MX8MP PCIe PHY support
Date: Tue, 29 Apr 2025 18:42:23 +0200
Message-ID: <20250429161053.176069961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit dce9edff16ee8df20e791e82e0704c4667cc3908 ]

Add i.MX8MP PCIe PHY support.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Marek Vasut <marex@denx.de>
Tested-by: Richard Leitner <richard.leitner@skidata.com>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/1665625622-20551-5-git-send-email-hongxing.zhu@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: aecb63e88c5e ("phy: freescale: imx8m-pcie: assert phy reset and perst in power off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c | 25 ++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
index 211ce84d980f9..0082de17cf4de 100644
--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -50,6 +50,7 @@
 
 enum imx8_pcie_phy_type {
 	IMX8MM,
+	IMX8MP,
 };
 
 struct imx8_pcie_phy_drvdata {
@@ -62,6 +63,7 @@ struct imx8_pcie_phy {
 	struct clk		*clk;
 	struct phy		*phy;
 	struct regmap		*iomuxc_gpr;
+	struct reset_control	*perst;
 	struct reset_control	*reset;
 	u32			refclk_pad_mode;
 	u32			tx_deemph_gen1;
@@ -76,11 +78,11 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 	u32 val, pad_mode;
 	struct imx8_pcie_phy *imx8_phy = phy_get_drvdata(phy);
 
-	reset_control_assert(imx8_phy->reset);
-
 	pad_mode = imx8_phy->refclk_pad_mode;
 	switch (imx8_phy->drvdata->variant) {
 	case IMX8MM:
+		reset_control_assert(imx8_phy->reset);
+
 		/* Tune PHY de-emphasis setting to pass PCIe compliance. */
 		if (imx8_phy->tx_deemph_gen1)
 			writel(imx8_phy->tx_deemph_gen1,
@@ -89,6 +91,8 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 			writel(imx8_phy->tx_deemph_gen2,
 			       imx8_phy->base + PCIE_PHY_TRSV_REG6);
 		break;
+	case IMX8MP: /* Do nothing. */
+		break;
 	}
 
 	if (pad_mode == IMX8_PCIE_REFCLK_PAD_INPUT ||
@@ -145,6 +149,9 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 			   IMX8MM_GPR_PCIE_CMN_RST);
 
 	switch (imx8_phy->drvdata->variant) {
+	case IMX8MP:
+		reset_control_deassert(imx8_phy->perst);
+		fallthrough;
 	case IMX8MM:
 		reset_control_deassert(imx8_phy->reset);
 		usleep_range(200, 500);
@@ -186,8 +193,14 @@ static const struct imx8_pcie_phy_drvdata imx8mm_drvdata = {
 	.variant = IMX8MM,
 };
 
+static const struct imx8_pcie_phy_drvdata imx8mp_drvdata = {
+	.gpr = "fsl,imx8mp-iomuxc-gpr",
+	.variant = IMX8MP,
+};
+
 static const struct of_device_id imx8_pcie_phy_of_match[] = {
 	{.compatible = "fsl,imx8mm-pcie-phy", .data = &imx8mm_drvdata, },
+	{.compatible = "fsl,imx8mp-pcie-phy", .data = &imx8mp_drvdata, },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, imx8_pcie_phy_of_match);
@@ -243,6 +256,14 @@ static int imx8_pcie_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(imx8_phy->reset);
 	}
 
+	if (imx8_phy->drvdata->variant == IMX8MP) {
+		imx8_phy->perst =
+			devm_reset_control_get_exclusive(dev, "perst");
+		if (IS_ERR(imx8_phy->perst))
+			dev_err_probe(dev, PTR_ERR(imx8_phy->perst),
+				      "Failed to get PCIE PHY PERST control\n");
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	imx8_phy->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(imx8_phy->base))
-- 
2.39.5



