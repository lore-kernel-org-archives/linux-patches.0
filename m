Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055787;
	b=RYHIqAOQfTqNd4dKy0LBvzUiHhVZ43djHqEudtOW/KPSdh5VyAEbKbCIbSWp8G3a08TH
	 dqRdu6zJaC23RjdBWBKK4NpEIquR1TKUUQ9375UNXrYS0EVY7O7rX8aRRR5O7WMfKXvsM
	 xNnNQ3uvWQZnZqZJM1IzkndjuPfMA8g/U+cGOB0ZqwL67+Nmvv9YiVanELOTsaDlFO0S9
	 owww1rbMsyyx9a9ksCcDFS8EgvPgDE+0h5Gw2RRzOgUqB602UBUmgjAjF6G5i7oi5nUjw
	 Nv+8vXGpKYaNt9wFN8D38Tka2i1wXYfJ2aykhYIctpiThaqpDVdiVfM9JNM/4iM7Y6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iIty8f4MD9tEAVqRqh+qgbSFEGQ6eEYkPF4x1/wWPXY=;
	b=QYbC3XIZBBifIQzacx4rKBKv3PgGRoS5FAHQgH8P7z69oDHbvVNuTk6rNSodXueQ9Y60
	 MaNAVrmijm6J1L0bWrz2xIllp4nVikCP1DC5LlaJiRqeG9pD9blQKu/d8ChlJlmATYf7a
	 pAzZeiqDfrgZKiGR9nPFa2vMLp6ZffQsQQeqrs8U4Gw0GPixomXK4X8Avjpz5YgZ1G3LL
	 DXm4oFvljlLAoGs/1AAQVny38fe9esVGoz3wLuwF+Iq+lWssX53+/voJkPMlLpNnEFIqx
	 ZLK3Cq8oMye8YYxCG3WQ52vVU+BfaQiF9Oc9q8VBJZKai8zsjqEljllVx2B0UhJW7yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmpsSunr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A548606A325;
	Thu, 19 Nov 2026 02:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmpsSunr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02CC1F000C5;
	Thu, 19 Nov 2026 02:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055787;
	bh=iIty8f4MD9tEAVqRqh+qgbSFEGQ6eEYkPF4x1/wWPXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmpsSunrXQ22nFLI7c/37MOJOZ328UNyxUZzkyloWi8q0lATg84YtGESc8RYih6Be
	 hBKz3z8b+yjzm7K+TFR3trhQRqkl34nERGa+YfZzCWat5QijPwjsn9NSrfTU4RrQlh
	 8BZ2z8Pz7QSmwc+nJUHe3GPVHk/jCsXd2HsajyAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1755/2214] dmaengine: ste_dma40: Add dev helper variable
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150121.775826608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b25225c480fa7..191e2e506be18 100644
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



