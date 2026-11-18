Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049172;
	b=JW4hy+QahQSDstRBSPe6lyFUTBkXir2TsOk/3qmQYtsi00nAGZL7ND80RHovjtkp73Cv
	 iJhi/tOg6qciwrnHG89WyYjURovcVJTAL8MUhjUqXOSg6vpB0eD7xxdMkKlTo3/v1l9n5
	 SYXDDJpqEM6FYrOh6BgrH1iKvR6abTPm2eWrXOEaaFIIRUadeJxB5GEs7zOib/+H8fYCQ
	 hGS/rGMr77U6CcwCUsuief4J6h0m+KrvMHglNBw+t41P5kj3vmbke7ew5yaimF/7v32Gq
	 d3jeCuWuJTy1p+u7EySoXhHf5fuO8OIFmfo1/d7lWrVssSRyC3X/C8H4iL7xaTeEFuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rTjYhDfgLfBwJMBFl+IX3sIJ99elru7cCMKwONvHE3c=;
	b=UdxqSU1OrRnGYJKOOhQGueoDYrbLKOb3/WGdRIIJKMKzzh3QLC1swZN6ZttYl0Q6nC75
	 ifm9f+VmrgvRGAq+aE8tAjKTBGGpVz0PloucUFZhNWM2wtHeNdjS9KToZ3GW2kkWsa8BN
	 iEafP55nTtINWPEz8dT8pL1kwkdNK36BTlTM9iozGJ0FqzClZ4fReUnI37IQodpBi3wI7
	 0i9tr7jaIJRO53lfJcNcP76oFN3tnVHlnsUIuQww1hp0q0/7c7G4pDgowB7krlcysu3hi
	 b34JRHj43TSUdYlnYA17HYtcT9MVKI0E3tx00PQp6zS966EJr0gopReJ51iVjyeKWBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNmEv5PY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D84606A31C;
	Thu, 19 Nov 2026 00:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNmEv5PY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2126B1F000C4;
	Thu, 19 Nov 2026 00:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049171;
	bh=rTjYhDfgLfBwJMBFl+IX3sIJ99elru7cCMKwONvHE3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNmEv5PYr+mtuzQ4s0zQMVmZ3eMjzPrIZsQYiQZaNXAmB6104lsKDdNYma5DPGV1S
	 zEyETC1Q0AoJ83LeWkfVvM/dy3+rJupsgetAR+J0AjDaw+p56/C19HnNJ5lLOBVJvI
	 QLda5LLsMhmLqGDKqN/4QHQKukP4rTnIREc3MfoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2256/2857] dmaengine: ste_dma40: Use managed resources
Date: Wed, 18 Nov 2026 15:54:50 +0100
Message-ID: <20261118150322.677967917@linuxfoundation.org>
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

[ Upstream commit 339f5041089a22646372d3ebdeec94c25e8d4e29 ]

This switches the DMA40 driver to use a bunch of managed
resources and strip down the errorpath.

The result is pretty neat and makes the driver way more
readable.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230417-ux500-dma40-cleanup-v3-6-60bfa6785968@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 7ca608cf6b84 ("dmaengine: ste_dma40: Fix probe IRQ leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 180 ++++++++++++++--------------------------
 1 file changed, 61 insertions(+), 119 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6afe700a8de82..7dfbdcff8684a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -554,8 +554,6 @@ struct d40_gen_dmac {
  * @virtbase: The virtual base address of the DMA's register.
  * @rev: silicon revision detected.
  * @clk: Pointer to the DMA clock structure.
- * @phy_start: Physical memory start of the DMA registers.
- * @phy_size: Size of the DMA register map.
  * @irq: The IRQ number.
  * @num_memcpy_chans: The number of channels used for memcpy (mem-to-mem
  * transfers).
@@ -599,8 +597,6 @@ struct d40_base {
 	void __iomem			 *virtbase;
 	u8				  rev:4;
 	struct clk			 *clk;
-	phys_addr_t			  phy_start;
-	resource_size_t			  phy_size;
 	int				  irq;
 	int				  num_memcpy_chans;
 	int				  num_phy_chans;
@@ -3172,65 +3168,58 @@ static int __init d40_phy_res_init(struct d40_base *base)
 	return num_phy_chans_avail;
 }
 
+/* Called from the registered devm action */
+static void d40_drop_kmem_cache_action(void *d)
+{
+	struct kmem_cache *desc_slab = d;
+
+	kmem_cache_destroy(desc_slab);
+}
+
 static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 {
 	struct stedma40_platform_data *plat_data = dev_get_platdata(&pdev->dev);
 	struct device *dev = &pdev->dev;
 	struct clk *clk;
 	void __iomem *virtbase;
-	struct resource *res;
 	struct d40_base *base;
 	int num_log_chans;
 	int num_phy_chans;
 	int num_memcpy_chans;
-	int clk_ret = -EINVAL;
 	int i;
 	u32 pid;
 	u32 cid;
 	u8 rev;
+	int ret;
 
-	clk = clk_get(dev, NULL);
-	if (IS_ERR(clk)) {
-		d40_err(dev, "No matching clock found\n");
-		goto check_prepare_enabled;
-	}
-
-	clk_ret = clk_prepare_enable(clk);
-	if (clk_ret) {
-		d40_err(dev, "Failed to prepare/enable clock\n");
-		goto disable_unprepare;
-	}
+	clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(clk))
+		return NULL;
 
 	/* Get IO for DMAC base address */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "base");
-	if (!res)
-		goto disable_unprepare;
-
-	if (request_mem_region(res->start, resource_size(res),
-			       D40_NAME " I/O base") == NULL)
-		goto release_region;
-
-	virtbase = ioremap(res->start, resource_size(res));
-	if (!virtbase)
-		goto release_region;
+	virtbase = devm_platform_ioremap_resource_byname(pdev, "base");
+	if (IS_ERR(virtbase)) {
+		dev_err(dev, "No IO base defined\n");
+		return NULL;
+	}
 
 	/* This is just a regular AMBA PrimeCell ID actually */
 	for (pid = 0, i = 0; i < 4; i++)
-		pid |= (readl(virtbase + resource_size(res) - 0x20 + 4 * i)
+		pid |= (readl(virtbase + SZ_4K - 0x20 + 4 * i)
 			& 255) << (i * 8);
 	for (cid = 0, i = 0; i < 4; i++)
-		cid |= (readl(virtbase + resource_size(res) - 0x10 + 4 * i)
+		cid |= (readl(virtbase + SZ_4K - 0x10 + 4 * i)
 			& 255) << (i * 8);
 
 	if (cid != AMBA_CID) {
 		d40_err(dev, "Unknown hardware! No PrimeCell ID\n");
-		goto unmap_io;
+		return NULL;
 	}
 	if (AMBA_MANF_BITS(pid) != AMBA_VENDOR_ST) {
 		d40_err(dev, "Unknown designer! Got %x wanted %x\n",
 			AMBA_MANF_BITS(pid),
 			AMBA_VENDOR_ST);
-		goto unmap_io;
+		return NULL;
 	}
 	/*
 	 * HW revision:
@@ -3244,7 +3233,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	rev = AMBA_REV_BITS(pid);
 	if (rev < 2) {
 		d40_err(dev, "hardware revision: %d is not supported", rev);
-		goto unmap_io;
+		return NULL;
 	}
 
 	/* The number of physical channels on this HW */
@@ -3262,23 +3251,22 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
 	dev_info(dev,
-		 "hardware rev: %d @ %pa with %d physical and %d logical channels\n",
-		 rev, &res->start, num_phy_chans, num_log_chans);
+		 "hardware rev: %d with %d physical and %d logical channels\n",
+		 rev, num_phy_chans, num_log_chans);
 
-	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
-		       (num_phy_chans + num_log_chans + num_memcpy_chans) *
-		       sizeof(struct d40_chan), GFP_KERNEL);
+	base = devm_kzalloc(dev,
+		ALIGN(sizeof(struct d40_base), 4) +
+		(num_phy_chans + num_log_chans + num_memcpy_chans) *
+		sizeof(struct d40_chan), GFP_KERNEL);
 
-	if (base == NULL)
-		goto unmap_io;
+	if (!base)
+		return NULL;
 
 	base->rev = rev;
 	base->clk = clk;
 	base->num_memcpy_chans = num_memcpy_chans;
 	base->num_phy_chans = num_phy_chans;
 	base->num_log_chans = num_log_chans;
-	base->phy_start = res->start;
-	base->phy_size = resource_size(res);
 	base->virtbase = virtbase;
 	base->plat_data = plat_data;
 	base->dev = dev;
@@ -3315,76 +3303,55 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		base->gen_dmac.init_reg_size = ARRAY_SIZE(dma_init_reg_v4a);
 	}
 
-	base->phy_res = kcalloc(num_phy_chans,
-				sizeof(*base->phy_res),
-				GFP_KERNEL);
+	base->phy_res = devm_kcalloc(dev, num_phy_chans,
+				     sizeof(*base->phy_res),
+				     GFP_KERNEL);
 	if (!base->phy_res)
-		goto free_base;
+		return NULL;
 
-	base->lookup_phy_chans = kcalloc(num_phy_chans,
-					 sizeof(*base->lookup_phy_chans),
-					 GFP_KERNEL);
+	base->lookup_phy_chans = devm_kcalloc(dev, num_phy_chans,
+					      sizeof(*base->lookup_phy_chans),
+					      GFP_KERNEL);
 	if (!base->lookup_phy_chans)
-		goto free_phy_res;
+		return NULL;
 
-	base->lookup_log_chans = kcalloc(num_log_chans,
-					 sizeof(*base->lookup_log_chans),
-					 GFP_KERNEL);
+	base->lookup_log_chans = devm_kcalloc(dev, num_log_chans,
+					      sizeof(*base->lookup_log_chans),
+					      GFP_KERNEL);
 	if (!base->lookup_log_chans)
-		goto free_phy_chans;
+		return NULL;
 
-	base->reg_val_backup_chan = kmalloc_array(base->num_phy_chans,
+	base->reg_val_backup_chan = devm_kmalloc_array(dev, base->num_phy_chans,
 						  sizeof(d40_backup_regs_chan),
 						  GFP_KERNEL);
 	if (!base->reg_val_backup_chan)
-		goto free_log_chans;
+		return NULL;
 
-	base->lcla_pool.alloc_map = kcalloc(num_phy_chans
+	base->lcla_pool.alloc_map = devm_kcalloc(dev, num_phy_chans
 					    * D40_LCLA_LINK_PER_EVENT_GRP,
 					    sizeof(*base->lcla_pool.alloc_map),
 					    GFP_KERNEL);
 	if (!base->lcla_pool.alloc_map)
-		goto free_backup_chan;
+		return NULL;
 
-	base->regs_interrupt = kmalloc_array(base->gen_dmac.il_size,
+	base->regs_interrupt = devm_kmalloc_array(dev, base->gen_dmac.il_size,
 					     sizeof(*base->regs_interrupt),
 					     GFP_KERNEL);
 	if (!base->regs_interrupt)
-		goto free_map;
+		return NULL;
 
 	base->desc_slab = kmem_cache_create(D40_NAME, sizeof(struct d40_desc),
 					    0, SLAB_HWCACHE_ALIGN,
 					    NULL);
-	if (base->desc_slab == NULL)
-		goto free_regs;
+	if (!base->desc_slab)
+		return NULL;
 
+	ret = devm_add_action_or_reset(dev, d40_drop_kmem_cache_action,
+				       base->desc_slab);
+	if (ret)
+		return NULL;
 
 	return base;
- free_regs:
-	kfree(base->regs_interrupt);
- free_map:
-	kfree(base->lcla_pool.alloc_map);
- free_backup_chan:
-	kfree(base->reg_val_backup_chan);
- free_log_chans:
-	kfree(base->lookup_log_chans);
- free_phy_chans:
-	kfree(base->lookup_phy_chans);
- free_phy_res:
-	kfree(base->phy_res);
- free_base:
-	kfree(base);
- unmap_io:
-	iounmap(virtbase);
- release_region:
-	release_mem_region(res->start, resource_size(res));
- check_prepare_enabled:
-	if (!clk_ret)
- disable_unprepare:
-		clk_disable_unprepare(clk);
-	if (!IS_ERR(clk))
-		clk_put(clk);
-	return NULL;
 }
 
 static void __init d40_hw_init(struct d40_base *base)
@@ -3630,11 +3597,11 @@ static int __init d40_probe(struct platform_device *pdev)
 	} else
 		writel(base->phy_lcpa, base->virtbase + D40_DREG_LCPA);
 
-	base->lcpa_base = ioremap(base->phy_lcpa, base->lcpa_size);
+	base->lcpa_base = devm_ioremap(dev, base->phy_lcpa, base->lcpa_size);
 	if (!base->lcpa_base) {
 		ret = -ENOMEM;
 		d40_err(dev, "Failed to ioremap LCPA region\n");
-		goto release_base;
+		goto report_failure;
 	}
 	/* If lcla has to be located in ESRAM we don't need to allocate */
 	if (base->plat_data->use_esram_lcla) {
@@ -3644,14 +3611,14 @@ static int __init d40_probe(struct platform_device *pdev)
 			ret = -ENOENT;
 			d40_err(dev,
 				"No \"lcla_esram\" memory resource\n");
-			goto destroy_cache;
+			goto report_failure;
 		}
-		base->lcla_pool.base = ioremap(res->start,
-						resource_size(res));
+		base->lcla_pool.base = devm_ioremap(dev, res->start,
+						    resource_size(res));
 		if (!base->lcla_pool.base) {
 			ret = -ENOMEM;
 			d40_err(dev, "Failed to ioremap LCLA region\n");
-			goto destroy_cache;
+			goto report_failure;
 		}
 		writel(res->start, base->virtbase + D40_DREG_LCLA);
 
@@ -3731,16 +3698,8 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	dev_info(base->dev, "initialized\n");
 	return 0;
- destroy_cache:
-	kmem_cache_destroy(base->desc_slab);
-	if (base->virtbase)
-		iounmap(base->virtbase);
-
-	if (base->lcla_pool.base && base->plat_data->use_esram_lcla) {
-		iounmap(base->lcla_pool.base);
-		base->lcla_pool.base = NULL;
-	}
 
+ destroy_cache:
 	if (base->lcla_pool.dma_addr)
 		dma_unmap_single(base->dev, base->lcla_pool.dma_addr,
 				 SZ_1K * base->num_phy_chans,
@@ -3752,28 +3711,11 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	kfree(base->lcla_pool.base_unaligned);
 
-	if (base->lcpa_base)
-		iounmap(base->lcpa_base);
-
-release_base:
-	if (base->phy_start)
-		release_mem_region(base->phy_start,
-				   base->phy_size);
-	if (base->clk) {
-		clk_disable_unprepare(base->clk);
-		clk_put(base->clk);
-	}
-
 	if (base->lcpa_regulator) {
 		regulator_disable(base->lcpa_regulator);
 		regulator_put(base->lcpa_regulator);
 	}
 
-	kfree(base->lcla_pool.alloc_map);
-	kfree(base->lookup_log_chans);
-	kfree(base->lookup_phy_chans);
-	kfree(base->phy_res);
-	kfree(base);
  report_failure:
 	d40_err(dev, "probe failed\n");
 	return ret;
-- 
2.53.0



