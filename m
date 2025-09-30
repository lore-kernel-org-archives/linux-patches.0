Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED49201017;
	Tue, 30 Sep 2025 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244263; cv=none; b=BOsBe87F+5WvFZJoYK5syYr1KVAOlhStEEGZNbZKgT40vPXuTbLvvRMY9h/q+i0bfebcNr9CfgYu25KaoBithpH1ou3RQ1H/R7Ff80QCDcExfpIrPCjlh0Qvex/4j1MB7ZE6pTalxspwrOTIrQ/bv0NFprmrrIzgHje6aKY4p6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244263; c=relaxed/simple;
	bh=zYq6DK6WfDOSeF7NQIWmYFK32A2N7wKO625nBBCkaOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jh6sahyu+waXDBeNWT8MjfPYNYR4lPzrL/L9ZwzydplfQQ//8RDJqIBa1wrEGvgntZ0Ec4qxYKcKzzU4sHXU0kP2kBxNYFKihsgUi0mEj28q+jCZFSbDhFpGPekCIvECqNZ6CKk6BEsyzTMLQqH6k7Nn/MuRnp3cPqcMR7HjVsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN9nqQTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN9nqQTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379D6C4CEF0;
	Tue, 30 Sep 2025 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244263;
	bh=zYq6DK6WfDOSeF7NQIWmYFK32A2N7wKO625nBBCkaOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN9nqQTSJTeO0/iNotrPhhGSTo8wdXgKvWMaCUuqyabDUfHd5BOocWs/8/drPz8vv
	 2rKPw7XlU1/E2W23JL6vNWXKRhPMcGCFzdeAg/PbdtnERBbJqTtkxnkUKiKZ56crOm
	 UOubErhgBuzorj66TAyaBYPMEl2CpGl22ul1Er4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/122] phy: phy-bcm-ns-usb3: drop support for deprecated DT binding
Date: Tue, 30 Sep 2025 16:46:47 +0200
Message-ID: <20250930143826.111104292@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 36a94760c98954e50ea621f7a9603fee3621deb7 ]

Initially this PHY driver was implementing MDIO access on its own. It
was caused by lack of proper hardware design understanding.

It has been changed back in 2017. DT bindings were changed and driver
was updated to use MDIO layer.

It should be really safe now to drop the old deprecated code. All Linux
stored DT files don't use it for 3,5 year. There is close to 0 chance
there is any bootloader with its own DTB using old the binding.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201113113423.9466-1-zajec5@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 64961557efa1 ("phy: ti: omap-usb2: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm-ns-usb3.c |  156 +--------------------------------
 1 file changed, 5 insertions(+), 151 deletions(-)

--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -22,8 +22,6 @@
 #include <linux/phy/phy.h>
 #include <linux/slab.h>
 
-#define BCM_NS_USB3_MII_MNG_TIMEOUT_US	1000	/* usecs */
-
 #define BCM_NS_USB3_PHY_BASE_ADDR_REG	0x1f
 #define BCM_NS_USB3_PHY_PLL30_BLOCK	0x8000
 #define BCM_NS_USB3_PHY_TX_PMD_BLOCK	0x8040
@@ -51,11 +49,8 @@ struct bcm_ns_usb3 {
 	struct device *dev;
 	enum bcm_ns_family family;
 	void __iomem *dmp;
-	void __iomem *ccb_mii;
 	struct mdio_device *mdiodev;
 	struct phy *phy;
-
-	int (*phy_write)(struct bcm_ns_usb3 *usb3, u16 reg, u16 value);
 };
 
 static const struct of_device_id bcm_ns_usb3_id_table[] = {
@@ -69,13 +64,9 @@ static const struct of_device_id bcm_ns_
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, bcm_ns_usb3_id_table);
 
 static int bcm_ns_usb3_mdio_phy_write(struct bcm_ns_usb3 *usb3, u16 reg,
-				      u16 value)
-{
-	return usb3->phy_write(usb3, reg, value);
-}
+				      u16 value);
 
 static int bcm_ns_usb3_phy_init_ns_bx(struct bcm_ns_usb3 *usb3)
 {
@@ -187,8 +178,8 @@ static const struct phy_ops ops = {
  * MDIO driver code
  **************************************************/
 
-static int bcm_ns_usb3_mdiodev_phy_write(struct bcm_ns_usb3 *usb3, u16 reg,
-					 u16 value)
+static int bcm_ns_usb3_mdio_phy_write(struct bcm_ns_usb3 *usb3, u16 reg,
+				      u16 value)
 {
 	struct mdio_device *mdiodev = usb3->mdiodev;
 
@@ -229,8 +220,6 @@ static int bcm_ns_usb3_mdio_probe(struct
 		return PTR_ERR(usb3->dmp);
 	}
 
-	usb3->phy_write = bcm_ns_usb3_mdiodev_phy_write;
-
 	usb3->phy = devm_phy_create(dev, NULL, &ops);
 	if (IS_ERR(usb3->phy)) {
 		dev_err(dev, "Failed to create PHY\n");
@@ -254,142 +243,7 @@ static struct mdio_driver bcm_ns_usb3_md
 	.probe = bcm_ns_usb3_mdio_probe,
 };
 
-/**************************************************
- * Platform driver code
- **************************************************/
-
-static int bcm_ns_usb3_wait_reg(struct bcm_ns_usb3 *usb3, void __iomem *addr,
-				u32 mask, u32 value, int usec)
-{
-	u32 val;
-	int ret;
-
-	ret = readl_poll_timeout_atomic(addr, val, ((val & mask) == value),
-					10, usec);
-	if (ret)
-		dev_err(usb3->dev, "Timeout waiting for register %p\n", addr);
-
-	return ret;
-}
-
-static inline int bcm_ns_usb3_mii_mng_wait_idle(struct bcm_ns_usb3 *usb3)
-{
-	return bcm_ns_usb3_wait_reg(usb3, usb3->ccb_mii + BCMA_CCB_MII_MNG_CTL,
-				    0x0100, 0x0000,
-				    BCM_NS_USB3_MII_MNG_TIMEOUT_US);
-}
-
-static int bcm_ns_usb3_platform_phy_write(struct bcm_ns_usb3 *usb3, u16 reg,
-					  u16 value)
-{
-	u32 tmp = 0;
-	int err;
-
-	err = bcm_ns_usb3_mii_mng_wait_idle(usb3);
-	if (err < 0) {
-		dev_err(usb3->dev, "Couldn't write 0x%08x value\n", value);
-		return err;
-	}
-
-	/* TODO: Use a proper MDIO bus layer */
-	tmp |= 0x58020000; /* Magic value for MDIO PHY write */
-	tmp |= reg << 18;
-	tmp |= value;
-	writel(tmp, usb3->ccb_mii + BCMA_CCB_MII_MNG_CMD_DATA);
-
-	return bcm_ns_usb3_mii_mng_wait_idle(usb3);
-}
-
-static int bcm_ns_usb3_probe(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	const struct of_device_id *of_id;
-	struct bcm_ns_usb3 *usb3;
-	struct phy_provider *phy_provider;
-
-	usb3 = devm_kzalloc(dev, sizeof(*usb3), GFP_KERNEL);
-	if (!usb3)
-		return -ENOMEM;
-
-	usb3->dev = dev;
-
-	of_id = of_match_device(bcm_ns_usb3_id_table, dev);
-	if (!of_id)
-		return -EINVAL;
-	usb3->family = (enum bcm_ns_family)of_id->data;
-
-	usb3->dmp = devm_platform_ioremap_resource_byname(pdev, "dmp");
-	if (IS_ERR(usb3->dmp)) {
-		dev_err(dev, "Failed to map DMP regs\n");
-		return PTR_ERR(usb3->dmp);
-	}
-
-	usb3->ccb_mii = devm_platform_ioremap_resource_byname(pdev, "ccb-mii");
-	if (IS_ERR(usb3->ccb_mii)) {
-		dev_err(dev, "Failed to map ChipCommon B MII regs\n");
-		return PTR_ERR(usb3->ccb_mii);
-	}
-
-	/* Enable MDIO. Setting MDCDIV as 26  */
-	writel(0x0000009a, usb3->ccb_mii + BCMA_CCB_MII_MNG_CTL);
-
-	/* Wait for MDIO? */
-	udelay(2);
-
-	usb3->phy_write = bcm_ns_usb3_platform_phy_write;
-
-	usb3->phy = devm_phy_create(dev, NULL, &ops);
-	if (IS_ERR(usb3->phy)) {
-		dev_err(dev, "Failed to create PHY\n");
-		return PTR_ERR(usb3->phy);
-	}
-
-	phy_set_drvdata(usb3->phy, usb3);
-	platform_set_drvdata(pdev, usb3);
-
-	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (!IS_ERR(phy_provider))
-		dev_info(dev, "Registered Broadcom Northstar USB 3.0 PHY driver\n");
-
-	return PTR_ERR_OR_ZERO(phy_provider);
-}
-
-static struct platform_driver bcm_ns_usb3_driver = {
-	.probe		= bcm_ns_usb3_probe,
-	.driver = {
-		.name = "bcm_ns_usb3",
-		.of_match_table = bcm_ns_usb3_id_table,
-	},
-};
-
-static int __init bcm_ns_usb3_module_init(void)
-{
-	int err;
-
-	/*
-	 * For backward compatibility we register as MDIO and platform driver.
-	 * After getting MDIO binding commonly used (e.g. switching all DT files
-	 * to use it) we should deprecate the old binding and eventually drop
-	 * support for it.
-	 */
-
-	err = mdio_driver_register(&bcm_ns_usb3_mdio_driver);
-	if (err)
-		return err;
-
-	err = platform_driver_register(&bcm_ns_usb3_driver);
-	if (err)
-		mdio_driver_unregister(&bcm_ns_usb3_mdio_driver);
-
-	return err;
-}
-module_init(bcm_ns_usb3_module_init);
-
-static void __exit bcm_ns_usb3_module_exit(void)
-{
-	platform_driver_unregister(&bcm_ns_usb3_driver);
-	mdio_driver_unregister(&bcm_ns_usb3_mdio_driver);
-}
-module_exit(bcm_ns_usb3_module_exit)
+mdio_module_driver(bcm_ns_usb3_mdio_driver);
 
 MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, bcm_ns_usb3_id_table);


