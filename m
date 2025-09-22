Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0CE25F780;
	Mon, 22 Sep 2025 19:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569797; cv=none; b=FmhKzsIzfE5vWl5gM33SCr9vHorut9ioIPvzPOj0dsMA5cI26f79cUXkQqzfffwGnCmJ+TTVEa+j8rcuQtal3hcbhOwhIDZ/xKLHGjTza0GUVVy3J4k2v3RbR92gWrsQlYrsD1Licrhd5OXozVblYbc8735YG822vYty9Ic0vBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569797; c=relaxed/simple;
	bh=lFQ8iMpYyMHpfwOadxOBANJDIPjxk6TKs/EYZ4WmxRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elNd/ciEyvqKvuxNVSxVp+lIHNGx5YJ96qO/gUSRmlUYKk01viXi0tZQDDIm1pI2SJQCB+mGO2S7exWXQmMWpPwJoC2BapQUEsQjJ0xAwycQkY3opTPQ5Y+41LnuE7vqEgD5FigDvhwh2KZvIm8L85th2Jv+sdYejR81xY/GfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3GIyB0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3GIyB0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C804C4CEF0;
	Mon, 22 Sep 2025 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569797;
	bh=lFQ8iMpYyMHpfwOadxOBANJDIPjxk6TKs/EYZ4WmxRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3GIyB0lxQc5iWp3fkROH7iiDTTrz0o7TXlFwwtwOOmhaCaSf3cASyvAR8bgKyovb
	 2C69goQwb8HJR69+XVrC/oC4ZdzLg5hz4b3mWDB1bzutUNhswkIACbLj+bFkRROxvV
	 +EvmcqFt8rDBVMfImQBa5n+n5hl/Imp1Aa6nIs/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/70] phy: Use device_get_match_data()
Date: Mon, 22 Sep 2025 21:30:00 +0200
Message-ID: <20250922192406.211589414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 21bf6fc47a1e45031ba8a7084343b7cfd09ed1d3 ]

Use preferred device_get_match_data() instead of of_match_device() to
get the driver match data. With this, adjust the includes to explicitly
include the correct headers.

Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20231009172923.2457844-15-robh@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 64961557efa1 ("phy: ti: omap-usb2: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm-ns-usb3.c   |    9 +++------
 drivers/phy/marvell/phy-berlin-usb.c     |    7 +++----
 drivers/phy/ralink/phy-ralink-usb.c      |   10 +++-------
 drivers/phy/rockchip/phy-rockchip-pcie.c |   11 ++++-------
 drivers/phy/rockchip/phy-rockchip-usb.c  |   10 +++-------
 drivers/phy/ti/phy-omap-control.c        |    9 ++-------
 drivers/phy/ti/phy-omap-usb2.c           |   11 ++++-------
 drivers/phy/ti/phy-ti-pipe3.c            |   14 ++++----------
 8 files changed, 26 insertions(+), 55 deletions(-)

--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -16,10 +16,11 @@
 #include <linux/iopoll.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #define BCM_NS_USB3_PHY_BASE_ADDR_REG	0x1f
@@ -189,7 +190,6 @@ static int bcm_ns_usb3_mdio_phy_write(st
 static int bcm_ns_usb3_mdio_probe(struct mdio_device *mdiodev)
 {
 	struct device *dev = &mdiodev->dev;
-	const struct of_device_id *of_id;
 	struct phy_provider *phy_provider;
 	struct device_node *syscon_np;
 	struct bcm_ns_usb3 *usb3;
@@ -203,10 +203,7 @@ static int bcm_ns_usb3_mdio_probe(struct
 	usb3->dev = dev;
 	usb3->mdiodev = mdiodev;
 
-	of_id = of_match_device(bcm_ns_usb3_id_table, dev);
-	if (!of_id)
-		return -EINVAL;
-	usb3->family = (uintptr_t)of_id->data;
+	usb3->family = (enum bcm_ns_family)device_get_match_data(dev);
 
 	syscon_np = of_parse_phandle(dev->of_node, "usb3-dmp-syscon", 0);
 	err = of_address_to_resource(syscon_np, 0, &res);
--- a/drivers/phy/marvell/phy-berlin-usb.c
+++ b/drivers/phy/marvell/phy-berlin-usb.c
@@ -8,9 +8,10 @@
 
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/reset.h>
 
 #define USB_PHY_PLL		0x04
@@ -162,8 +163,6 @@ MODULE_DEVICE_TABLE(of, phy_berlin_usb_o
 
 static int phy_berlin_usb_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match =
-		of_match_device(phy_berlin_usb_of_match, &pdev->dev);
 	struct phy_berlin_usb_priv *priv;
 	struct phy *phy;
 	struct phy_provider *phy_provider;
@@ -180,7 +179,7 @@ static int phy_berlin_usb_probe(struct p
 	if (IS_ERR(priv->rst_ctrl))
 		return PTR_ERR(priv->rst_ctrl);
 
-	priv->pll_divider = *((u32 *)match->data);
+	priv->pll_divider = *((u32 *)device_get_match_data(&pdev->dev));
 
 	phy = devm_phy_create(&pdev->dev, NULL, &phy_berlin_usb_ops);
 	if (IS_ERR(phy)) {
--- a/drivers/phy/ralink/phy-ralink-usb.c
+++ b/drivers/phy/ralink/phy-ralink-usb.c
@@ -13,9 +13,10 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/of_platform.h>
+#include <linux/of.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
 
@@ -171,18 +172,13 @@ static int ralink_usb_phy_probe(struct p
 {
 	struct device *dev = &pdev->dev;
 	struct phy_provider *phy_provider;
-	const struct of_device_id *match;
 	struct ralink_usb_phy *phy;
 
-	match = of_match_device(ralink_usb_phy_of_match, &pdev->dev);
-	if (!match)
-		return -ENODEV;
-
 	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy)
 		return -ENOMEM;
 
-	phy->clk = (uintptr_t)match->data;
+	phy->clk = (uintptr_t)device_get_match_data(&pdev->dev);
 	phy->base = NULL;
 
 	phy->sysctl = syscon_regmap_lookup_by_phandle(dev->of_node, "ralink,sysctl");
--- a/drivers/phy/rockchip/phy-rockchip-pcie.c
+++ b/drivers/phy/rockchip/phy-rockchip-pcie.c
@@ -12,10 +12,9 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
 
@@ -62,7 +61,7 @@ struct rockchip_pcie_data {
 };
 
 struct rockchip_pcie_phy {
-	struct rockchip_pcie_data *phy_data;
+	const struct rockchip_pcie_data *phy_data;
 	struct regmap *reg_base;
 	struct phy_pcie_instance {
 		struct phy *phy;
@@ -349,7 +348,6 @@ static int rockchip_pcie_phy_probe(struc
 	struct rockchip_pcie_phy *rk_phy;
 	struct phy_provider *phy_provider;
 	struct regmap *grf;
-	const struct of_device_id *of_id;
 	int i;
 	u32 phy_num;
 
@@ -363,11 +361,10 @@ static int rockchip_pcie_phy_probe(struc
 	if (!rk_phy)
 		return -ENOMEM;
 
-	of_id = of_match_device(rockchip_pcie_phy_dt_ids, &pdev->dev);
-	if (!of_id)
+	rk_phy->phy_data = device_get_match_data(&pdev->dev);
+	if (!rk_phy->phy_data)
 		return -EINVAL;
 
-	rk_phy->phy_data = (struct rockchip_pcie_data *)of_id->data;
 	rk_phy->reg_base = grf;
 
 	mutex_init(&rk_phy->pcie_mutex);
--- a/drivers/phy/rockchip/phy-rockchip-usb.c
+++ b/drivers/phy/rockchip/phy-rockchip-usb.c
@@ -13,10 +13,9 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/regmap.h>
@@ -458,7 +457,6 @@ static int rockchip_usb_phy_probe(struct
 	struct device *dev = &pdev->dev;
 	struct rockchip_usb_phy_base *phy_base;
 	struct phy_provider *phy_provider;
-	const struct of_device_id *match;
 	struct device_node *child;
 	int err;
 
@@ -466,14 +464,12 @@ static int rockchip_usb_phy_probe(struct
 	if (!phy_base)
 		return -ENOMEM;
 
-	match = of_match_device(dev->driver->of_match_table, dev);
-	if (!match || !match->data) {
+	phy_base->pdata = device_get_match_data(dev);
+	if (!phy_base->pdata) {
 		dev_err(dev, "missing phy data\n");
 		return -EINVAL;
 	}
 
-	phy_base->pdata = match->data;
-
 	phy_base->dev = dev;
 	phy_base->reg_base = ERR_PTR(-ENODEV);
 	if (dev->parent && dev->parent->of_node)
--- a/drivers/phy/ti/phy-omap-control.c
+++ b/drivers/phy/ti/phy-omap-control.c
@@ -8,9 +8,9 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/of.h>
-#include <linux/of_device.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/clk.h>
@@ -268,20 +268,15 @@ MODULE_DEVICE_TABLE(of, omap_control_phy
 
 static int omap_control_phy_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *of_id;
 	struct omap_control_phy *control_phy;
 
-	of_id = of_match_device(omap_control_phy_id_table, &pdev->dev);
-	if (!of_id)
-		return -EINVAL;
-
 	control_phy = devm_kzalloc(&pdev->dev, sizeof(*control_phy),
 		GFP_KERNEL);
 	if (!control_phy)
 		return -ENOMEM;
 
 	control_phy->dev = &pdev->dev;
-	control_phy->type = *(enum omap_control_phy_type *)of_id->data;
+	control_phy->type = *(enum omap_control_phy_type *)device_get_match_data(&pdev->dev);
 
 	if (control_phy->type == OMAP_CTRL_TYPE_OTGHS) {
 		control_phy->otghs_control =
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -19,6 +19,7 @@
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
@@ -371,16 +372,12 @@ static int omap_usb2_probe(struct platfo
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *control_node;
 	struct platform_device *control_pdev;
-	const struct of_device_id *of_id;
-	struct usb_phy_data *phy_data;
+	const struct usb_phy_data *phy_data;
 
-	of_id = of_match_device(omap_usb2_id_table, &pdev->dev);
-
-	if (!of_id)
+	phy_data = device_get_match_data(&pdev->dev);
+	if (!phy_data)
 		return -EINVAL;
 
-	phy_data = (struct usb_phy_data *)of_id->data;
-
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy)
 		return -ENOMEM;
--- a/drivers/phy/ti/phy-ti-pipe3.c
+++ b/drivers/phy/ti/phy-ti-pipe3.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/phy/phy.h>
 #include <linux/of.h>
@@ -791,23 +792,16 @@ static int ti_pipe3_probe(struct platfor
 	struct phy_provider *phy_provider;
 	struct device *dev = &pdev->dev;
 	int ret;
-	const struct of_device_id *match;
-	struct pipe3_data *data;
+	const struct pipe3_data *data;
 
 	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy)
 		return -ENOMEM;
 
-	match = of_match_device(ti_pipe3_id_table, dev);
-	if (!match)
+	data = device_get_match_data(dev);
+	if (!data)
 		return -EINVAL;
 
-	data = (struct pipe3_data *)match->data;
-	if (!data) {
-		dev_err(dev, "no driver data\n");
-		return -EINVAL;
-	}
-
 	phy->dev = dev;
 	phy->mode = data->mode;
 	phy->dpll_map = data->dpll_map;


