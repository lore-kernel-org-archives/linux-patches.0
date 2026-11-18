Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061241;
	b=WA3GmQuYioVYxgw8XhswtWfaluLW9yECGgzVJAm9ntTvKQyGWHm/FD10elbRB4VLWYo4
	 gDBQoFPVPPN44a9c6BeOHBNu98wS3aa0DtfavImqAJ5c5W+99LVBvMVt3pBzazblw7fDO
	 f3Y3kf8AJd2sAYdVz0pfwMjQBUvwlpbwcynzYzoGwvFJ5HoCVV/kPve4wkXT4gCwbvjFV
	 KgGs0521pt49QR1UBNrYRNe1Sgo3NR2yeZ82XdTDPFhi+FUIL6mNrXSobI8LIL8xkyWaY
	 lsSMiKr6lC4m8fygJBXZUnB3WxrXtBSxQ/vGE4fHhL7RCw4cJvORgi5apu1qp2qULMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4NT2CmFDOIFyILwaMJYH4lQ8NsXVigxD9M5NiXTe+I8=;
	b=Rgf41SpDrmm5XOwZxeK9+yIchAh2/t2qfT6OQ9jzYe3mimsurK1FtiAQ1cLYjEO8Bkex
	 dv5WW80lon3q6WKpqB9j3v9ivldn/5X6fG6pRZbmp7xe/gH9OsYwoaXjgINTayWQnG9MQ
	 p0l7efU04T5BLTCNucc12yQ1evsYTctjeeJlMV7GvuaWyztalcdDRdnvaizuMuO2AA+55
	 LrupSSqR6gYCZVCZTukQIzoqZVSNr5S6I3Bh+MLzKEq9NclnJzl2xVidcE3ugpYpP4M7S
	 qSHzVqElWT4rDmSkohJM5+Nd+ux1JwYLeSbBQDqO3a/azzuH4BtFTu3AdaucadL7hag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGLaaFyn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B0E606A331;
	Thu, 19 Nov 2026 04:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGLaaFyn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF46E1F000C5;
	Thu, 19 Nov 2026 04:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061241;
	bh=4NT2CmFDOIFyILwaMJYH4lQ8NsXVigxD9M5NiXTe+I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGLaaFyn9+Iz+MzusfVaPd07QpM5ohu8WWeGDgVZaCGjF8bKsyVKxN66vWwC7Vlkc
	 1SLtETJjx4yynuy2O+2PncJkWdAB3DHQhCCXhPanTYO9HNGU2OA2Zv2Kq2RnHphkgH
	 eB70kL5U/MGqmV602CF4ycCIdeuusnBvkt/5p/iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1482/1848] dmaengine: ste_dma40: Get LCPA SRAM from SRAM node
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150021.308911676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 5a1a3b9c19ddeddc6b0c2ea1da7fbe6624c04c7e ]

Instead of passing the reserved SRAM as a "reg" field
look for a phandle to the LCPA SRAM memory so we can
use the proper SRAM device tree bindings for the SRAM.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230417-ux500-dma40-cleanup-v3-2-60bfa6785968@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c6809b381e34 ("dmaengine: ste_dma40: Fix probe runtime PM disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig     |  1 +
 drivers/dma/ste_dma40.c | 47 +++++++++++++++++++++--------------------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 02b98f979479a..d53b64005564a 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -523,6 +523,7 @@ config STE_DMA40
 	bool "ST-Ericsson DMA40 support"
 	depends on ARCH_U8500
 	select DMA_ENGINE
+	select SRAM
 	help
 	  Support for ST-Ericsson DMA40 controller
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4513cfdd66aca..f1e675e018017 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -19,6 +19,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_dma.h>
 #include <linux/amba/bus.h>
 #include <linux/regulator/consumer.h>
@@ -3516,9 +3517,11 @@ static int __init d40_probe(struct platform_device *pdev)
 {
 	struct stedma40_platform_data *plat_data = dev_get_platdata(&pdev->dev);
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *np_lcpa;
 	int ret = -ENOENT;
 	struct d40_base *base;
 	struct resource *res;
+	struct resource res_lcpa;
 	int num_reserved_chans;
 	u32 val;
 
@@ -3545,37 +3548,37 @@ static int __init d40_probe(struct platform_device *pdev)
 	spin_lock_init(&base->interrupt_lock);
 	spin_lock_init(&base->execmd_lock);
 
-	/* Get IO for logical channel parameter address */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lcpa");
-	if (!res) {
-		ret = -ENOENT;
-		d40_err(&pdev->dev, "No \"lcpa\" memory resource\n");
-		goto destroy_cache;
+	/* Get IO for logical channel parameter address (LCPA) */
+	np_lcpa = of_parse_phandle(np, "sram", 0);
+	if (!np_lcpa) {
+		dev_err(&pdev->dev, "no LCPA SRAM node\n");
+		goto report_failure;
 	}
-	base->lcpa_size = resource_size(res);
-	base->phy_lcpa = res->start;
-
-	if (request_mem_region(res->start, resource_size(res),
-			       D40_NAME " I/O lcpa") == NULL) {
-		ret = -EBUSY;
-		d40_err(&pdev->dev, "Failed to request LCPA region %pR\n", res);
-		goto destroy_cache;
+	/* This is no device so read the address directly from the node */
+	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	if (ret) {
+		dev_err(&pdev->dev, "no LCPA SRAM resource\n");
+		goto report_failure;
 	}
+	base->lcpa_size = resource_size(&res_lcpa);
+	base->phy_lcpa = res_lcpa.start;
+	dev_info(&pdev->dev, "found LCPA SRAM at 0x%08x, size 0x%08x\n",
+		 (u32)base->phy_lcpa, base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);
-	if (res->start != val && val != 0) {
+	if (base->phy_lcpa != val && val != 0) {
 		dev_warn(&pdev->dev,
-			 "[%s] Mismatch LCPA dma 0x%x, def %pa\n",
-			 __func__, val, &res->start);
+			 "[%s] Mismatch LCPA dma 0x%x, def %08x\n",
+			 __func__, val, (u32)base->phy_lcpa);
 	} else
-		writel(res->start, base->virtbase + D40_DREG_LCPA);
+		writel(base->phy_lcpa, base->virtbase + D40_DREG_LCPA);
 
-	base->lcpa_base = ioremap(res->start, resource_size(res));
+	base->lcpa_base = ioremap(base->phy_lcpa, base->lcpa_size);
 	if (!base->lcpa_base) {
 		ret = -ENOMEM;
 		d40_err(&pdev->dev, "Failed to ioremap LCPA region\n");
-		goto destroy_cache;
+		goto release_base;
 	}
 	/* If lcla has to be located in ESRAM we don't need to allocate */
 	if (base->plat_data->use_esram_lcla) {
@@ -3692,9 +3695,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (base->lcpa_base)
 		iounmap(base->lcpa_base);
 
-	if (base->phy_lcpa)
-		release_mem_region(base->phy_lcpa,
-				   base->lcpa_size);
+release_base:
 	if (base->phy_start)
 		release_mem_region(base->phy_start,
 				   base->phy_size);
-- 
2.53.0



