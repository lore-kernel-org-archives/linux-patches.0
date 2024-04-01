Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC58487BC;
	Mon,  1 Apr 2024 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991337; cv=none; b=OXErAw5hNDxbRPX7Pgr4hovqzJx4YZN+3SqaGMB8QA+tIGaz5FPd2j2CizV1prUG4h52In2oEz38kS9TEsNH4Qlkal8YPwsROPvb1+ITqL0LKo7Ht3gREbq055d5k5Om6C1bysds/suIgxq7H03AE/0TcjzW4Qt+aC6Q63QNaVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991337; c=relaxed/simple;
	bh=D3P+E4m9ozDs+7py3UYUK9n9TJnJETRgQnSKyI6qTjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnsLuZJutqXOMhhUe/etAVDzsiJRmXQdZvZVK7g4v9nklE8XhB0TpQhEg6kj9HNmK/meSH75/k7MIkYOoQPZycZgImW5J0t2YxPJtrh5tXP5CZH9hYw9H1JzIFyLxcz+MQhSkzCT4eRML8BmVO2dJeYqTgJZIcpyqIBef6b1a/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=md7tVgOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="md7tVgOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2563C433C7;
	Mon,  1 Apr 2024 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991337;
	bh=D3P+E4m9ozDs+7py3UYUK9n9TJnJETRgQnSKyI6qTjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=md7tVgOj7TcJQ1GzHPlGWsi6+rNYi9/PRzckX+zm+coFKkDipMdK7NUHYuBWgfpsa
	 Ko4khvzW4rNvOJkYrj+gwo/WJnFh8mZ+DOoYV5V9fVPY/HweWJt4/5oPBDajy+L5Bv
	 N3qIp8oaWaySeDJHZz4hW6bta0PA6t23R7qr9MYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ladislav Michl <ladis@linux-mips.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/272] usb: dwc3-am62: Rename private data
Date: Mon,  1 Apr 2024 17:47:04 +0200
Message-ID: <20240401152538.282052563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Ladislav Michl <ladis@linux-mips.org>

[ Upstream commit 3609699c32aa4f2710a6fe2b21afc6a9a3c66bc5 ]

Rename dwc3_data to dwc3_am62 to make it consistent with other
glue drivers, it's clearer that this is am62's specific.
While there, do the same for data variable.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Link: https://lore.kernel.org/r/ZLKoHhJvT+Y6aM+C@lenoch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6661befe4100 ("usb: dwc3-am62: fix module unload/reload behavior")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-am62.c | 80 ++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-am62.c b/drivers/usb/dwc3/dwc3-am62.c
index 173cf3579c55d..726f96d257c8d 100644
--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -89,7 +89,7 @@
 
 #define DWC3_AM62_AUTOSUSPEND_DELAY	100
 
-struct dwc3_data {
+struct dwc3_am62 {
 	struct device *dev;
 	void __iomem *usbss;
 	struct clk *usb2_refclk;
@@ -115,19 +115,19 @@ static const int dwc3_ti_rate_table[] = {	/* in KHZ */
 	52000,
 };
 
-static inline u32 dwc3_ti_readl(struct dwc3_data *data, u32 offset)
+static inline u32 dwc3_ti_readl(struct dwc3_am62 *am62, u32 offset)
 {
-	return readl((data->usbss) + offset);
+	return readl((am62->usbss) + offset);
 }
 
-static inline void dwc3_ti_writel(struct dwc3_data *data, u32 offset, u32 value)
+static inline void dwc3_ti_writel(struct dwc3_am62 *am62, u32 offset, u32 value)
 {
-	writel(value, (data->usbss) + offset);
+	writel(value, (am62->usbss) + offset);
 }
 
-static int phy_syscon_pll_refclk(struct dwc3_data *data)
+static int phy_syscon_pll_refclk(struct dwc3_am62 *am62)
 {
-	struct device *dev = data->dev;
+	struct device *dev = am62->dev;
 	struct device_node *node = dev->of_node;
 	struct of_phandle_args args;
 	struct regmap *syscon;
@@ -139,16 +139,16 @@ static int phy_syscon_pll_refclk(struct dwc3_data *data)
 		return PTR_ERR(syscon);
 	}
 
-	data->syscon = syscon;
+	am62->syscon = syscon;
 
 	ret = of_parse_phandle_with_fixed_args(node, "ti,syscon-phy-pll-refclk", 1,
 					       0, &args);
 	if (ret)
 		return ret;
 
-	data->offset = args.args[0];
+	am62->offset = args.args[0];
 
-	ret = regmap_update_bits(data->syscon, data->offset, PHY_PLL_REFCLK_MASK, data->rate_code);
+	ret = regmap_update_bits(am62->syscon, am62->offset, PHY_PLL_REFCLK_MASK, am62->rate_code);
 	if (ret) {
 		dev_err(dev, "failed to set phy pll reference clock rate\n");
 		return ret;
@@ -161,32 +161,32 @@ static int dwc3_ti_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = pdev->dev.of_node;
-	struct dwc3_data *data;
+	struct dwc3_am62 *am62;
 	int i, ret;
 	unsigned long rate;
 	u32 reg;
 
-	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
+	am62 = devm_kzalloc(dev, sizeof(*am62), GFP_KERNEL);
+	if (!am62)
 		return -ENOMEM;
 
-	data->dev = dev;
-	platform_set_drvdata(pdev, data);
+	am62->dev = dev;
+	platform_set_drvdata(pdev, am62);
 
-	data->usbss = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(data->usbss)) {
+	am62->usbss = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(am62->usbss)) {
 		dev_err(dev, "can't map IOMEM resource\n");
-		return PTR_ERR(data->usbss);
+		return PTR_ERR(am62->usbss);
 	}
 
-	data->usb2_refclk = devm_clk_get(dev, "ref");
-	if (IS_ERR(data->usb2_refclk)) {
+	am62->usb2_refclk = devm_clk_get(dev, "ref");
+	if (IS_ERR(am62->usb2_refclk)) {
 		dev_err(dev, "can't get usb2_refclk\n");
-		return PTR_ERR(data->usb2_refclk);
+		return PTR_ERR(am62->usb2_refclk);
 	}
 
 	/* Calculate the rate code */
-	rate = clk_get_rate(data->usb2_refclk);
+	rate = clk_get_rate(am62->usb2_refclk);
 	rate /= 1000;	// To KHz
 	for (i = 0; i < ARRAY_SIZE(dwc3_ti_rate_table); i++) {
 		if (dwc3_ti_rate_table[i] == rate)
@@ -198,20 +198,20 @@ static int dwc3_ti_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	data->rate_code = i;
+	am62->rate_code = i;
 
 	/* Read the syscon property and set the rate code */
-	ret = phy_syscon_pll_refclk(data);
+	ret = phy_syscon_pll_refclk(am62);
 	if (ret)
 		return ret;
 
 	/* VBUS divider select */
-	data->vbus_divider = device_property_read_bool(dev, "ti,vbus-divider");
-	reg = dwc3_ti_readl(data, USBSS_PHY_CONFIG);
-	if (data->vbus_divider)
+	am62->vbus_divider = device_property_read_bool(dev, "ti,vbus-divider");
+	reg = dwc3_ti_readl(am62, USBSS_PHY_CONFIG);
+	if (am62->vbus_divider)
 		reg |= 1 << USBSS_PHY_VBUS_SEL_SHIFT;
 
-	dwc3_ti_writel(data, USBSS_PHY_CONFIG, reg);
+	dwc3_ti_writel(am62, USBSS_PHY_CONFIG, reg);
 
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
@@ -219,7 +219,7 @@ static int dwc3_ti_probe(struct platform_device *pdev)
 	 * Don't ignore its dependencies with its children
 	 */
 	pm_suspend_ignore_children(dev, false);
-	clk_prepare_enable(data->usb2_refclk);
+	clk_prepare_enable(am62->usb2_refclk);
 	pm_runtime_get_noresume(dev);
 
 	ret = of_platform_populate(node, NULL, NULL, dev);
@@ -229,9 +229,9 @@ static int dwc3_ti_probe(struct platform_device *pdev)
 	}
 
 	/* Set mode valid bit to indicate role is valid */
-	reg = dwc3_ti_readl(data, USBSS_MODE_CONTROL);
+	reg = dwc3_ti_readl(am62, USBSS_MODE_CONTROL);
 	reg |= USBSS_MODE_VALID;
-	dwc3_ti_writel(data, USBSS_MODE_CONTROL, reg);
+	dwc3_ti_writel(am62, USBSS_MODE_CONTROL, reg);
 
 	/* Setting up autosuspend */
 	pm_runtime_set_autosuspend_delay(dev, DWC3_AM62_AUTOSUSPEND_DELAY);
@@ -241,7 +241,7 @@ static int dwc3_ti_probe(struct platform_device *pdev)
 	return 0;
 
 err_pm_disable:
-	clk_disable_unprepare(data->usb2_refclk);
+	clk_disable_unprepare(am62->usb2_refclk);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	return ret;
@@ -258,18 +258,18 @@ static int dwc3_ti_remove_core(struct device *dev, void *c)
 static int dwc3_ti_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct dwc3_data *data = platform_get_drvdata(pdev);
+	struct dwc3_am62 *am62 = platform_get_drvdata(pdev);
 	u32 reg;
 
 	device_for_each_child(dev, NULL, dwc3_ti_remove_core);
 
 	/* Clear mode valid bit */
-	reg = dwc3_ti_readl(data, USBSS_MODE_CONTROL);
+	reg = dwc3_ti_readl(am62, USBSS_MODE_CONTROL);
 	reg &= ~USBSS_MODE_VALID;
-	dwc3_ti_writel(data, USBSS_MODE_CONTROL, reg);
+	dwc3_ti_writel(am62, USBSS_MODE_CONTROL, reg);
 
 	pm_runtime_put_sync(dev);
-	clk_disable_unprepare(data->usb2_refclk);
+	clk_disable_unprepare(am62->usb2_refclk);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 
@@ -280,18 +280,18 @@ static int dwc3_ti_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int dwc3_ti_suspend_common(struct device *dev)
 {
-	struct dwc3_data *data = dev_get_drvdata(dev);
+	struct dwc3_am62 *am62 = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(data->usb2_refclk);
+	clk_disable_unprepare(am62->usb2_refclk);
 
 	return 0;
 }
 
 static int dwc3_ti_resume_common(struct device *dev)
 {
-	struct dwc3_data *data = dev_get_drvdata(dev);
+	struct dwc3_am62 *am62 = dev_get_drvdata(dev);
 
-	clk_prepare_enable(data->usb2_refclk);
+	clk_prepare_enable(am62->usb2_refclk);
 
 	return 0;
 }
-- 
2.43.0



