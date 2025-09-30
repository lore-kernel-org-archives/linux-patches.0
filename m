Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750161F03C5;
	Tue, 30 Sep 2025 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244259; cv=none; b=QA3qRfd8IjD3DqYp8xcctIISsk+F59NhVpjQzhM0sV5UXnPcDNUz6Rk5j7MdzR3X05A3zh1Y29Yns6pguGnMYEiawmjK4e1nlzWtKtLCZJg3OSknZMccbr5nAcVtUd7FOXmVrks3ovlRJif6p+jCgGCgThKoD5UtOyhuzQqk5xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244259; c=relaxed/simple;
	bh=6Ijj9A79MIr98g2hWyJZwgoe9vXdU0qPEEYGV4A96IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDtuWNuV6jD7SLGZIE4z5V7tI8uL4kpXdLGI9+04m4SpHAtYilnUeE2iq2buhNobMczA5JQ1QAXdHvmmCDq1/c2EUStYGMQU8rpAcRBQEq+l5Yi1V8hXA6DWDrOlkEpO4sbSogj3zUYfvR1puPujElHYmYMr0SXss16anvyKo0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IL+DWRkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IL+DWRkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B500C4CEF0;
	Tue, 30 Sep 2025 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244257;
	bh=6Ijj9A79MIr98g2hWyJZwgoe9vXdU0qPEEYGV4A96IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IL+DWRkTnT+p47xzFyc08yye0fMkV41GgP62KCdR0LQmwUxC4dd7HuXLZHhDezIFD
	 A35qNXZBauwxKhv0iaN2bTvAidvYPmRryz2QNMkiDa7v94D1rFO8qY8dSMk0sqrNBv
	 PrksCS7dJyPcfltEIGVkqEpuNvwPEW+x89qcfstY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Al Cooper <alcooperx@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/122] phy: broadcom: convert to devm_platform_ioremap_resource(_byname)
Date: Tue, 30 Sep 2025 16:46:45 +0200
Message-ID: <20250930143826.028869993@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit f669bc8b9f7beb6b1936882a2c3670dc1bd985ba ]

Use devm_platform_ioremap_resource(_byname) to simplify code

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Al Cooper <alcooperx@gmail.com>
Link: https://lore.kernel.org/r/1604642930-29019-3-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 64961557efa1 ("phy: ti: omap-usb2: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm-cygnus-pcie.c |    4 +---
 drivers/phy/broadcom/phy-bcm-kona-usb2.c   |    4 +---
 drivers/phy/broadcom/phy-bcm-ns-usb2.c     |    4 +---
 drivers/phy/broadcom/phy-bcm-ns-usb3.c     |    7 ++-----
 drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c  |   13 ++++---------
 drivers/phy/broadcom/phy-bcm-sr-pcie.c     |    5 +----
 drivers/phy/broadcom/phy-bcm-sr-usb.c      |    4 +---
 drivers/phy/broadcom/phy-brcm-sata.c       |    8 ++------
 8 files changed, 13 insertions(+), 36 deletions(-)

--- a/drivers/phy/broadcom/phy-bcm-cygnus-pcie.c
+++ b/drivers/phy/broadcom/phy-bcm-cygnus-pcie.c
@@ -126,7 +126,6 @@ static int cygnus_pcie_phy_probe(struct
 	struct device_node *node = dev->of_node, *child;
 	struct cygnus_pcie_phy_core *core;
 	struct phy_provider *provider;
-	struct resource *res;
 	unsigned cnt = 0;
 	int ret;
 
@@ -141,8 +140,7 @@ static int cygnus_pcie_phy_probe(struct
 
 	core->dev = dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	core->base = devm_ioremap_resource(dev, res);
+	core->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(core->base))
 		return PTR_ERR(core->base);
 
--- a/drivers/phy/broadcom/phy-bcm-kona-usb2.c
+++ b/drivers/phy/broadcom/phy-bcm-kona-usb2.c
@@ -94,7 +94,6 @@ static int bcm_kona_usb2_probe(struct pl
 {
 	struct device *dev = &pdev->dev;
 	struct bcm_kona_usb *phy;
-	struct resource *res;
 	struct phy *gphy;
 	struct phy_provider *phy_provider;
 
@@ -102,8 +101,7 @@ static int bcm_kona_usb2_probe(struct pl
 	if (!phy)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	phy->regs = devm_ioremap_resource(&pdev->dev, res);
+	phy->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(phy->regs))
 		return PTR_ERR(phy->regs);
 
--- a/drivers/phy/broadcom/phy-bcm-ns-usb2.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb2.c
@@ -83,7 +83,6 @@ static int bcm_ns_usb2_probe(struct plat
 {
 	struct device *dev = &pdev->dev;
 	struct bcm_ns_usb2 *usb2;
-	struct resource *res;
 	struct phy_provider *phy_provider;
 
 	usb2 = devm_kzalloc(&pdev->dev, sizeof(*usb2), GFP_KERNEL);
@@ -91,8 +90,7 @@ static int bcm_ns_usb2_probe(struct plat
 		return -ENOMEM;
 	usb2->dev = dev;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dmu");
-	usb2->dmu = devm_ioremap_resource(dev, res);
+	usb2->dmu = devm_platform_ioremap_resource_byname(pdev, "dmu");
 	if (IS_ERR(usb2->dmu)) {
 		dev_err(dev, "Failed to map DMU regs\n");
 		return PTR_ERR(usb2->dmu);
--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -305,7 +305,6 @@ static int bcm_ns_usb3_probe(struct plat
 	struct device *dev = &pdev->dev;
 	const struct of_device_id *of_id;
 	struct bcm_ns_usb3 *usb3;
-	struct resource *res;
 	struct phy_provider *phy_provider;
 
 	usb3 = devm_kzalloc(dev, sizeof(*usb3), GFP_KERNEL);
@@ -319,15 +318,13 @@ static int bcm_ns_usb3_probe(struct plat
 		return -EINVAL;
 	usb3->family = (enum bcm_ns_family)of_id->data;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dmp");
-	usb3->dmp = devm_ioremap_resource(dev, res);
+	usb3->dmp = devm_platform_ioremap_resource_byname(pdev, "dmp");
 	if (IS_ERR(usb3->dmp)) {
 		dev_err(dev, "Failed to map DMP regs\n");
 		return PTR_ERR(usb3->dmp);
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ccb-mii");
-	usb3->ccb_mii = devm_ioremap_resource(dev, res);
+	usb3->ccb_mii = devm_platform_ioremap_resource_byname(pdev, "ccb-mii");
 	if (IS_ERR(usb3->ccb_mii)) {
 		dev_err(dev, "Failed to map ChipCommon B MII regs\n");
 		return PTR_ERR(usb3->ccb_mii);
--- a/drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c
+++ b/drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c
@@ -293,7 +293,6 @@ static int ns2_drd_phy_probe(struct plat
 	struct device *dev = &pdev->dev;
 	struct ns2_phy_driver *driver;
 	struct ns2_phy_data *data;
-	struct resource *res;
 	int ret;
 	u32 val;
 
@@ -307,23 +306,19 @@ static int ns2_drd_phy_probe(struct plat
 	if (!driver->data)
 		return -ENOMEM;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "icfg");
-	driver->icfgdrd_regs = devm_ioremap_resource(dev, res);
+	driver->icfgdrd_regs = devm_platform_ioremap_resource_byname(pdev, "icfg");
 	if (IS_ERR(driver->icfgdrd_regs))
 		return PTR_ERR(driver->icfgdrd_regs);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rst-ctrl");
-	driver->idmdrd_rst_ctrl = devm_ioremap_resource(dev, res);
+	driver->idmdrd_rst_ctrl = devm_platform_ioremap_resource_byname(pdev, "rst-ctrl");
 	if (IS_ERR(driver->idmdrd_rst_ctrl))
 		return PTR_ERR(driver->idmdrd_rst_ctrl);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "crmu-ctrl");
-	driver->crmu_usb2_ctrl = devm_ioremap_resource(dev, res);
+	driver->crmu_usb2_ctrl = devm_platform_ioremap_resource_byname(pdev, "crmu-ctrl");
 	if (IS_ERR(driver->crmu_usb2_ctrl))
 		return PTR_ERR(driver->crmu_usb2_ctrl);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "usb2-strap");
-	driver->usb2h_strap_reg = devm_ioremap_resource(dev, res);
+	driver->usb2h_strap_reg = devm_platform_ioremap_resource_byname(pdev, "usb2-strap");
 	if (IS_ERR(driver->usb2h_strap_reg))
 		return PTR_ERR(driver->usb2h_strap_reg);
 
--- a/drivers/phy/broadcom/phy-bcm-sr-pcie.c
+++ b/drivers/phy/broadcom/phy-bcm-sr-pcie.c
@@ -217,7 +217,6 @@ static int sr_pcie_phy_probe(struct plat
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
 	struct sr_pcie_phy_core *core;
-	struct resource *res;
 	struct phy_provider *provider;
 	unsigned int phy_idx = 0;
 
@@ -226,9 +225,7 @@ static int sr_pcie_phy_probe(struct plat
 		return -ENOMEM;
 
 	core->dev = dev;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	core->base = devm_ioremap_resource(core->dev, res);
+	core->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(core->base))
 		return PTR_ERR(core->base);
 
--- a/drivers/phy/broadcom/phy-bcm-sr-usb.c
+++ b/drivers/phy/broadcom/phy-bcm-sr-usb.c
@@ -300,14 +300,12 @@ static int bcm_usb_phy_probe(struct plat
 	struct device *dev = &pdev->dev;
 	struct device_node *dn = dev->of_node;
 	const struct of_device_id *of_id;
-	struct resource *res;
 	void __iomem *regs;
 	int ret;
 	enum bcm_usb_phy_version version;
 	struct phy_provider *phy_provider;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	regs = devm_ioremap_resource(dev, res);
+	regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
--- a/drivers/phy/broadcom/phy-brcm-sata.c
+++ b/drivers/phy/broadcom/phy-brcm-sata.c
@@ -726,7 +726,6 @@ static int brcm_sata_phy_probe(struct pl
 	struct device_node *dn = dev->of_node, *child;
 	const struct of_device_id *of_id;
 	struct brcm_sata_phy *priv;
-	struct resource *res;
 	struct phy_provider *provider;
 	int ret, count = 0;
 
@@ -739,8 +738,7 @@ static int brcm_sata_phy_probe(struct pl
 	dev_set_drvdata(dev, priv);
 	priv->dev = dev;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy");
-	priv->phy_base = devm_ioremap_resource(dev, res);
+	priv->phy_base = devm_platform_ioremap_resource_byname(pdev, "phy");
 	if (IS_ERR(priv->phy_base))
 		return PTR_ERR(priv->phy_base);
 
@@ -751,9 +749,7 @@ static int brcm_sata_phy_probe(struct pl
 		priv->version = BRCM_SATA_PHY_STB_28NM;
 
 	if (priv->version == BRCM_SATA_PHY_IPROC_NS2) {
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						   "phy-ctrl");
-		priv->ctrl_base = devm_ioremap_resource(dev, res);
+		priv->ctrl_base = devm_platform_ioremap_resource_byname(pdev, "phy-ctrl");
 		if (IS_ERR(priv->ctrl_base))
 			return PTR_ERR(priv->ctrl_base);
 	}


