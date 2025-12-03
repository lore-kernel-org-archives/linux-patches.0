Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02367329C6A;
	Wed,  3 Dec 2025 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776987; cv=none; b=c78dcTE1Yp3kOgaPlI+IfkeGjVDNn1Ys9MKfw28ZY27fI530FLkzqkoNl3eZ24KRs9UeZE9o5UUkjb1bDMxoQeH041UpbZorCUkvUYzPu8G3JJFJwxK1M21Vrej4WkCFeJ8DqB+PYwrU+/NjTjtVGZx6QkVZTo8+jV4HAta78Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776987; c=relaxed/simple;
	bh=v++SD5BVDK2m22Ie9wLoTS8D9HK2Xc8aOgyPYk58Tvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdHf9YTXXqEHgJGK6fWZTJbi7KZKPE5TeNGJGhwkdo2Nnw6wUqsV7oR6WDXsZaLXLInFwJRgAMB44PFG7rPEU9/ic3nfZIwWV7k334ofMVrm+2YMglkGN9E4ChiTUY+uGcBUv5Kj0lmKUBdluoJ4aWL7LzuKONPU1zzOGgd1LaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edOqgkHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edOqgkHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A792C116B1;
	Wed,  3 Dec 2025 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776986;
	bh=v++SD5BVDK2m22Ie9wLoTS8D9HK2Xc8aOgyPYk58Tvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edOqgkHWvptuJiMZhU1Si/99x9svK97RqeNysoOjVJ8UBK3ry9dCXNeXRWjQs0WOw
	 qhoEVMcZta0KifUte/XpUHpRFhpGdhduFiofuq8wISHIBzWP3RKEKZ4Qrc2gEBxCWL
	 wBe+wdOwRNmSm44pw0k784/b+amYLu8XCO9TjLiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/146] spi: nxp-fspi: Propagate fwnode in ACPI case as well
Date: Wed,  3 Dec 2025 16:27:06 +0100
Message-ID: <20251203152348.231540168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 40ad64ac25bb736740f895d99a4aebbda9b80991 ]

Propagate fwnode of the ACPI device to the SPI controller Linux device.
Currently only OF case propagates fwnode to the controller.

While at it, replace several calls to dev_fwnode() with a single one
cached in a local variable, and unify checks for fwnode type by using
is_*_node() APIs.

Fixes: 55ab8487e01d ("spi: spi-nxp-fspi: Add ACPI support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20251126202501.2319679-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index fcf10be66d391..f96638cae1d94 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1270,7 +1270,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct resource *res;
 	struct nxp_fspi *f;
 	int ret, irq;
@@ -1292,7 +1292,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, f);
 
 	/* find the resources - configuration register address space */
-	if (is_acpi_node(dev_fwnode(f->dev)))
+	if (is_acpi_node(fwnode))
 		f->iobase = devm_platform_ioremap_resource(pdev, 0);
 	else
 		f->iobase = devm_platform_ioremap_resource_byname(pdev, "fspi_base");
@@ -1300,7 +1300,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		return PTR_ERR(f->iobase);
 
 	/* find the resources - controller memory mapped space */
-	if (is_acpi_node(dev_fwnode(f->dev)))
+	if (is_acpi_node(fwnode))
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	else
 		res = platform_get_resource_byname(pdev,
@@ -1313,7 +1313,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	f->memmap_phy_size = resource_size(res);
 
 	/* find the clocks */
-	if (dev_of_node(&pdev->dev)) {
+	if (is_of_node(fwnode)) {
 		f->clk_en = devm_clk_get(dev, "fspi_en");
 		if (IS_ERR(f->clk_en))
 			return PTR_ERR(f->clk_en);
@@ -1366,7 +1366,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	else
 		ctlr->mem_caps = &nxp_fspi_mem_caps;
 
-	ctlr->dev.of_node = np;
+	device_set_node(&ctlr->dev, fwnode);
 
 	ret = devm_add_action_or_reset(dev, nxp_fspi_cleanup, f);
 	if (ret)
-- 
2.51.0



