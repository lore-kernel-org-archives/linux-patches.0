Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25642609F7;
	Tue, 27 May 2025 16:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364279; cv=none; b=KaNMR8gcoAYhZma495FkB17OTKrArST/fu5+3CdzKi4PJrxSSyXCmlJi2Fr3OmkoTSnfL6T2lm42Bc+yJl0HdPBPRCNB7QQYAVrKK4GXsAYoFNCsTRL1bhwqQkGhzzIAg1aE+keC2iksY+yzN0q5nfQdOoBaebuURMCqiYlFcvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364279; c=relaxed/simple;
	bh=13QLzEPWmNGQ5Hb/rl0aEfnmsGS0LxLaHHheTUwtmck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ima8gSZMC1ql0sJKobgLZEnxsNwZ9mUTx+2mVdeAPAu3cHerJppoUx+I3PMS0lJ/AZrfyLaEAP2QwxHg+lTUSuLMK16hQ0GE0eHe6IImplhvpcxypdTdXe1PWaZ4i18G/EyFjwuDyiKFLZPBSqZRibxPJgJeTN8GGYDvdqich50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsyJ6jAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsyJ6jAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD129C4CEE9;
	Tue, 27 May 2025 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364279;
	bh=13QLzEPWmNGQ5Hb/rl0aEfnmsGS0LxLaHHheTUwtmck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsyJ6jABgj/x7meFcReRkLVxK9oDhWhjLB7WvA2mQxSy9Y7xdqPACkZK0O4ifPBhS
	 sbwVEv57yCjKFHVZw+ju60o4K3xGKjycBskM0/4EnP09+8LSIMkMPNIv2J+wPg1GMR
	 bxT5jCe0NpcwTEnUBsd+aynWvanEGFinJrbHchA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/626] i2c: designware: Use temporary variable for struct device
Date: Tue, 27 May 2025 18:18:18 +0200
Message-ID: <20250527162445.270541090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d2f94dccab8319063dd1fbc1738b4a280c2e4009 ]

Use temporary variable for struct device to make code neater.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 1cfe51ef07ca ("i2c: designware: Fix an error handling path in i2c_dw_pci_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c  | 29 ++++++-------
 drivers/i2c/busses/i2c-designware-platdrv.c | 48 ++++++++++-----------
 2 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 7b2c5d71a7fce..433cb285d3b20 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -207,6 +207,7 @@ static const struct software_node dgpu_node = {
 static int i2c_dw_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
+	struct device *device = &pdev->dev;
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
 	int r;
@@ -214,25 +215,22 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	struct dw_scl_sda_cfg *cfg;
 
 	if (id->driver_data >= ARRAY_SIZE(dw_pci_controllers))
-		return dev_err_probe(&pdev->dev, -EINVAL,
-				     "Invalid driver data %ld\n",
+		return dev_err_probe(device, -EINVAL, "Invalid driver data %ld\n",
 				     id->driver_data);
 
 	controller = &dw_pci_controllers[id->driver_data];
 
 	r = pcim_enable_device(pdev);
 	if (r)
-		return dev_err_probe(&pdev->dev, r,
-				     "Failed to enable I2C PCI device\n");
+		return dev_err_probe(device, r, "Failed to enable I2C PCI device\n");
 
 	pci_set_master(pdev);
 
 	r = pcim_iomap_regions(pdev, 1 << 0, pci_name(pdev));
 	if (r)
-		return dev_err_probe(&pdev->dev, r,
-				     "I/O memory remapping failed\n");
+		return dev_err_probe(device, r, "I/O memory remapping failed\n");
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(device, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -242,7 +240,7 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 
 	dev->get_clk_rate_khz = controller->get_clk_rate_khz;
 	dev->base = pcim_iomap_table(pdev)[0];
-	dev->dev = &pdev->dev;
+	dev->dev = device;
 	dev->irq = pci_irq_vector(pdev, 0);
 	dev->flags |= controller->flags;
 
@@ -281,14 +279,14 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
 		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, &dgpu_node);
 		if (IS_ERR(dev->slave))
-			return dev_err_probe(dev->dev, PTR_ERR(dev->slave),
+			return dev_err_probe(device, PTR_ERR(dev->slave),
 					     "register UCSI failed\n");
 	}
 
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_put_autosuspend(&pdev->dev);
-	pm_runtime_allow(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(device, 1000);
+	pm_runtime_use_autosuspend(device);
+	pm_runtime_put_autosuspend(device);
+	pm_runtime_allow(device);
 
 	return 0;
 }
@@ -296,11 +294,12 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 static void i2c_dw_pci_remove(struct pci_dev *pdev)
 {
 	struct dw_i2c_dev *dev = pci_get_drvdata(pdev);
+	struct device *device = &pdev->dev;
 
 	i2c_dw_disable(dev);
 
-	pm_runtime_forbid(&pdev->dev);
-	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_forbid(device);
+	pm_runtime_get_noresume(device);
 
 	i2c_del_adapter(&dev->adapter);
 }
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 2d0c7348e4917..a3e86930bf418 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -205,6 +205,7 @@ static void i2c_dw_remove_lock_support(struct dw_i2c_dev *dev)
 
 static int dw_i2c_plat_probe(struct platform_device *pdev)
 {
+	struct device *device = &pdev->dev;
 	struct i2c_adapter *adap;
 	struct dw_i2c_dev *dev;
 	int irq, ret;
@@ -213,15 +214,15 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(struct dw_i2c_dev), GFP_KERNEL);
+	dev = devm_kzalloc(device, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
-	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
-	if (device_property_present(&pdev->dev, "wx,i2c-snps-model"))
+	dev->flags = (uintptr_t)device_get_match_data(device);
+	if (device_property_present(device, "wx,i2c-snps-model"))
 		dev->flags = MODEL_WANGXUN_SP | ACCESS_POLLING;
 
-	dev->dev = &pdev->dev;
+	dev->dev = device;
 	dev->irq = irq;
 	platform_set_drvdata(pdev, dev);
 
@@ -229,7 +230,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	dev->rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
+	dev->rst = devm_reset_control_get_optional_exclusive(device, NULL);
 	if (IS_ERR(dev->rst))
 		return PTR_ERR(dev->rst);
 
@@ -246,13 +247,13 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 	i2c_dw_configure(dev);
 
 	/* Optional interface clock */
-	dev->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
+	dev->pclk = devm_clk_get_optional(device, "pclk");
 	if (IS_ERR(dev->pclk)) {
 		ret = PTR_ERR(dev->pclk);
 		goto exit_reset;
 	}
 
-	dev->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	dev->clk = devm_clk_get_optional(device, NULL);
 	if (IS_ERR(dev->clk)) {
 		ret = PTR_ERR(dev->clk);
 		goto exit_reset;
@@ -280,28 +281,24 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 					I2C_CLASS_HWMON : I2C_CLASS_DEPRECATED;
 	adap->nr = -1;
 
-	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
-		dev_pm_set_driver_flags(&pdev->dev,
-					DPM_FLAG_SMART_PREPARE);
-	} else {
-		dev_pm_set_driver_flags(&pdev->dev,
-					DPM_FLAG_SMART_PREPARE |
-					DPM_FLAG_SMART_SUSPEND);
-	}
+	if (dev->flags & ACCESS_NO_IRQ_SUSPEND)
+		dev_pm_set_driver_flags(device, DPM_FLAG_SMART_PREPARE);
+	else
+		dev_pm_set_driver_flags(device, DPM_FLAG_SMART_PREPARE | DPM_FLAG_SMART_SUSPEND);
 
-	device_enable_async_suspend(&pdev->dev);
+	device_enable_async_suspend(device);
 
 	/* The code below assumes runtime PM to be disabled. */
-	WARN_ON(pm_runtime_enabled(&pdev->dev));
+	WARN_ON(pm_runtime_enabled(device));
 
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(device, 1000);
+	pm_runtime_use_autosuspend(device);
+	pm_runtime_set_active(device);
 
 	if (dev->shared_with_punit)
-		pm_runtime_get_noresume(&pdev->dev);
+		pm_runtime_get_noresume(device);
 
-	pm_runtime_enable(&pdev->dev);
+	pm_runtime_enable(device);
 
 	ret = i2c_dw_probe(dev);
 	if (ret)
@@ -319,15 +316,16 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 static void dw_i2c_plat_remove(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	struct device *device = &pdev->dev;
 
-	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_get_sync(device);
 
 	i2c_del_adapter(&dev->adapter);
 
 	i2c_dw_disable(dev);
 
-	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(device);
+	pm_runtime_put_sync(device);
 	dw_i2c_plat_pm_cleanup(dev);
 
 	i2c_dw_remove_lock_support(dev);
-- 
2.39.5



