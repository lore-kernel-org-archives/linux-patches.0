Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049152;
	b=bWHjQldFMSvhGiX/cjYp5Pe6JZRJVHuEogadnboiWHfN/cack8/K8WbzsHcc6P+3JM4z
	 PwG+V0CvKGFhMmJWNgo3SzdnQGGnh0LW77A3jES0BXXofK5HZJbwegwxPt6LiUNxFx427
	 D6C84IhWQOUrqm1gs9nP+ORoxXHXVqUurn/Q1RBp9/SGQTtA+LC4kx8uNaitUV4uCskLK
	 p0vaOK8+Dvs0SdbgJnQrX2BpEG5hVixW8ywWDeBZAonXOxoxPUJl5T80zJJsPz9fXKgkZ
	 FgZrGHAxk81t1UALByFo9+HGFo8NHOo0NzcIJNZ4Dd0YM9rYX7U75rKXGP8jqR4UgFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNQrcEgtYv1id69mHQHo+WcnUKiP9zvaKAOHyZ2hD5U=;
	b=SEf8L3Act+16oGDWeX4ngrIEAk9b8nn3y/1WvX72mCTgtIrpdXoIHDMLkA9/eI33KAMm
	 uG96H/7gcyqA0rbFQuzhPrIxPsfhT2u1B9LORiULhAAbjl5SGaOpkc6TgAPzOByKYHqnI
	 e2QbJeQSa/56l0PpY1hLevPyXL2bbaVLR7sV/5pEs9nYXxnmusu7+ym7MG/ksCUHbvBwK
	 /Fc3bISM6rG+ZlzdFCY+EzuMyuSTIvj/P2IrAG1QY4nYe9/qxSIkJJxE2zu7FpDA+trwH
	 snnvU2Y8wz7x/sOVUvikyPXRtDeqdtoP2QWrGdFvr++Yn53WttJCOwBJ6HSxLMnf40g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieeTRJJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B96606A31C;
	Thu, 19 Nov 2026 00:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieeTRJJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFE81F000C7;
	Thu, 19 Nov 2026 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049152;
	bh=dNQrcEgtYv1id69mHQHo+WcnUKiP9zvaKAOHyZ2hD5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieeTRJJyHRsGGo0XaVn4UUDtTObcF1JDOmJ7KC/y3HwkUy/Ez7oDYp8TBnrJKPmRE
	 g30b3q8dXvkaz4sBO19ZMr1oJys9FwrRX4Uh8t3PRkTn2/2RsQzIpYHns5VmO79NL1
	 hGRx5/iwjoaGAqN5kGu8SAnDjcSGX0JoEKADcQbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2249/2857] dmaengine: ste_dma40: Add dev helper variable
Date: Wed, 18 Nov 2026 15:54:43 +0100
Message-ID: <20261118150322.419411733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit fb85a8c51784f46b4ddd8bdad3c6bcacd0e5ad2b ]

The &pdev->dev device pointer is used so many times in the
probe() and d40_hw_detect_init() functions that a local *dev
variable makes the code way easier to read.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230417-ux500-dma40-cleanup-v3-3-60bfa6785968@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c6809b381e34 ("dmaengine: ste_dma40: Fix probe runtime PM disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 50 +++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6fe255cc7a108..c321aadf5680d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3113,6 +3113,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
 static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 {
 	struct stedma40_platform_data *plat_data = dev_get_platdata(&pdev->dev);
+	struct device *dev = &pdev->dev;
 	struct clk *clk;
 	void __iomem *virtbase;
 	struct resource *res;
@@ -3126,15 +3127,15 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	u32 cid;
 	u8 rev;
 
-	clk = clk_get(&pdev->dev, NULL);
+	clk = clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
-		d40_err(&pdev->dev, "No matching clock found\n");
+		d40_err(dev, "No matching clock found\n");
 		goto check_prepare_enabled;
 	}
 
 	clk_ret = clk_prepare_enable(clk);
 	if (clk_ret) {
-		d40_err(&pdev->dev, "Failed to prepare/enable clock\n");
+		d40_err(dev, "Failed to prepare/enable clock\n");
 		goto disable_unprepare;
 	}
 
@@ -3160,11 +3161,11 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 			& 255) << (i * 8);
 
 	if (cid != AMBA_CID) {
-		d40_err(&pdev->dev, "Unknown hardware! No PrimeCell ID\n");
+		d40_err(dev, "Unknown hardware! No PrimeCell ID\n");
 		goto unmap_io;
 	}
 	if (AMBA_MANF_BITS(pid) != AMBA_VENDOR_ST) {
-		d40_err(&pdev->dev, "Unknown designer! Got %x wanted %x\n",
+		d40_err(dev, "Unknown designer! Got %x wanted %x\n",
 			AMBA_MANF_BITS(pid),
 			AMBA_VENDOR_ST);
 		goto unmap_io;
@@ -3180,7 +3181,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	 */
 	rev = AMBA_REV_BITS(pid);
 	if (rev < 2) {
-		d40_err(&pdev->dev, "hardware revision: %d is not supported", rev);
+		d40_err(dev, "hardware revision: %d is not supported", rev);
 		goto unmap_io;
 	}
 
@@ -3198,7 +3199,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
-	dev_info(&pdev->dev,
+	dev_info(dev,
 		 "hardware rev: %d @ %pa with %d physical and %d logical channels\n",
 		 rev, &res->start, num_phy_chans, num_log_chans);
 
@@ -3218,7 +3219,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	base->phy_size = resource_size(res);
 	base->virtbase = virtbase;
 	base->plat_data = plat_data;
-	base->dev = &pdev->dev;
+	base->dev = dev;
 	base->phy_chans = ((void *)base) + ALIGN(sizeof(struct d40_base), 4);
 	base->log_chans = &base->phy_chans[num_phy_chans];
 
@@ -3514,7 +3515,8 @@ static int __init d40_of_probe(struct platform_device *pdev,
 
 static int __init d40_probe(struct platform_device *pdev)
 {
-	struct stedma40_platform_data *plat_data = dev_get_platdata(&pdev->dev);
+	struct device *dev = &pdev->dev;
+	struct stedma40_platform_data *plat_data = dev_get_platdata(dev);
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *np_lcpa;
 	int ret = -ENOENT;
@@ -3531,7 +3533,7 @@ static int __init d40_probe(struct platform_device *pdev)
 				goto report_failure;
 			}
 		} else {
-			d40_err(&pdev->dev, "No pdata or Device Tree provided\n");
+			d40_err(dev, "No pdata or Device Tree provided\n");
 			goto report_failure;
 		}
 	}
@@ -3550,24 +3552,24 @@ static int __init d40_probe(struct platform_device *pdev)
 	/* Get IO for logical channel parameter address (LCPA) */
 	np_lcpa = of_parse_phandle(np, "sram", 0);
 	if (!np_lcpa) {
-		dev_err(&pdev->dev, "no LCPA SRAM node\n");
+		dev_err(dev, "no LCPA SRAM node\n");
 		goto report_failure;
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
 	if (ret) {
-		dev_err(&pdev->dev, "no LCPA SRAM resource\n");
+		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(&pdev->dev, "found LCPA SRAM at 0x%08x, size 0x%08x\n",
+	dev_info(dev, "found LCPA SRAM at 0x%08x, size 0x%08x\n",
 		 (u32)base->phy_lcpa, base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);
 	if (base->phy_lcpa != val && val != 0) {
-		dev_warn(&pdev->dev,
+		dev_warn(dev,
 			 "[%s] Mismatch LCPA dma 0x%x, def %08x\n",
 			 __func__, val, (u32)base->phy_lcpa);
 	} else
@@ -3576,7 +3578,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	base->lcpa_base = ioremap(base->phy_lcpa, base->lcpa_size);
 	if (!base->lcpa_base) {
 		ret = -ENOMEM;
-		d40_err(&pdev->dev, "Failed to ioremap LCPA region\n");
+		d40_err(dev, "Failed to ioremap LCPA region\n");
 		goto release_base;
 	}
 	/* If lcla has to be located in ESRAM we don't need to allocate */
@@ -3585,7 +3587,7 @@ static int __init d40_probe(struct platform_device *pdev)
 							"lcla_esram");
 		if (!res) {
 			ret = -ENOENT;
-			d40_err(&pdev->dev,
+			d40_err(dev,
 				"No \"lcla_esram\" memory resource\n");
 			goto destroy_cache;
 		}
@@ -3593,7 +3595,7 @@ static int __init d40_probe(struct platform_device *pdev)
 						resource_size(res));
 		if (!base->lcla_pool.base) {
 			ret = -ENOMEM;
-			d40_err(&pdev->dev, "Failed to ioremap LCLA region\n");
+			d40_err(dev, "Failed to ioremap LCLA region\n");
 			goto destroy_cache;
 		}
 		writel(res->start, base->virtbase + D40_DREG_LCLA);
@@ -3601,7 +3603,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	} else {
 		ret = d40_lcla_allocate(base);
 		if (ret) {
-			d40_err(&pdev->dev, "Failed to allocate LCLA area\n");
+			d40_err(dev, "Failed to allocate LCLA area\n");
 			goto destroy_cache;
 		}
 	}
@@ -3616,7 +3618,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
 	if (ret) {
-		d40_err(&pdev->dev, "No IRQ defined\n");
+		d40_err(dev, "No IRQ defined\n");
 		goto destroy_cache;
 	}
 
@@ -3624,7 +3626,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 		base->lcpa_regulator = regulator_get(base->dev, "lcla_esram");
 		if (IS_ERR(base->lcpa_regulator)) {
-			d40_err(&pdev->dev, "Failed to get lcpa_regulator\n");
+			d40_err(dev, "Failed to get lcpa_regulator\n");
 			ret = PTR_ERR(base->lcpa_regulator);
 			base->lcpa_regulator = NULL;
 			goto destroy_cache;
@@ -3632,7 +3634,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 		ret = regulator_enable(base->lcpa_regulator);
 		if (ret) {
-			d40_err(&pdev->dev,
+			d40_err(dev,
 				"Failed to enable lcpa_regulator\n");
 			regulator_put(base->lcpa_regulator);
 			base->lcpa_regulator = NULL;
@@ -3655,7 +3657,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	ret = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
 	if (ret) {
-		d40_err(&pdev->dev, "Failed to set dma max seg size\n");
+		d40_err(dev, "Failed to set dma max seg size\n");
 		goto destroy_cache;
 	}
 
@@ -3664,7 +3666,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (np) {
 		ret = of_dma_controller_register(np, d40_xlate, NULL);
 		if (ret)
-			dev_err(&pdev->dev,
+			dev_err(dev,
 				"could not register of_dma_controller\n");
 	}
 
@@ -3715,7 +3717,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	kfree(base->phy_res);
 	kfree(base);
  report_failure:
-	d40_err(&pdev->dev, "probe failed\n");
+	d40_err(dev, "probe failed\n");
 	return ret;
 }
 
-- 
2.53.0



