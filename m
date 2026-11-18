Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049169;
	b=Pf4m/3VxejmHP0+TyKBB+oP3PrZiT4HVhe/QQsHwoYQEIH3oOddCWeDPtNa/3mduMcT8
	 /NJmQZ+5zv1rZonoqNyl2h7eULYHcvrBWqxIqFO2bgcU2wOkxTLRLcfmYd40eHWAp3sRE
	 1TSuaSdZiiwsx4//Vzhj59DSkti/LeufNSfHz4Wpz27ucN61JAETIDaNzGS53Tk9b/22q
	 076v5gonJhAQfscchJz/ZOA5nx1uqH8Vsj+ZDChmJMzsLUmj/3sXIVLY8tqZCT+pWqpOC
	 cmMGEgh08tDl1yV55i8hdKOZF2ciw30iarmqByqz8+KvA9AE5EpArXGh9WKhRHtAq7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ely++BSMrf6mQhokk3eRki502Q/OpP2/PThwI1Q7xRI=;
	b=zroTBxmr+FHKecz9j/2R8sXPg9M076//o1Z6dkGVBFquQVr9n1/zvjWGxJpV06Y8In/v
	 aLMUDnbO6X9hO4LB8Kb5InBjJp0zt3LWxAEc66Lh4B1e/Qia7JDt6ecToBa5M+IULiEdP
	 S39deoNoUUm+VE2Ag34UK8U4GeY7OJXzX9BTM7bE1alPM9lD96jaKVGNj54+eUmm14KJg
	 meN6y4CBThw1Nm3qduJqEC337huLn9YyKCMDePr9tzGzhcB+rbfDlBuHDcY4DRR5N2cvK
	 ci0R5Uq9W7TApVZZvmAhr7vuJwAoL+al4Gi8OKILAGTWYj+uIu0xVuvBw8iHnENoiVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9Rjsskr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF61606A320;
	Thu, 19 Nov 2026 00:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9Rjsskr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452661F000C4;
	Thu, 19 Nov 2026 00:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049168;
	bh=ely++BSMrf6mQhokk3eRki502Q/OpP2/PThwI1Q7xRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9RjsskrbH4Hrr/4M4XW2OdYvCbb1WAFPiz6N08S6u658P+Y/UvBKoCWUID57r9qm
	 euPQmsR8dhtF7Neav0JK/faP+DcDxtSNydlgtLP2A7PEGm0EFcw5z0UT6dP8GAF3Zw
	 6sCrk7H7g06pLolZ7Nkppc5/Fq3YMhsXrxSuvAak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2255/2857] dmaengine: ste_dma40: Remove platform data
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150322.641380660@linuxfoundation.org>
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

[ Upstream commit 42ae6f1695beed57958e7a2554e6d52dddc56e43 ]

The Ux500 is device tree-only since ages. Delete the
platform data header and push it into or next to the driver
instead.

Drop the non-DT probe path since this will not happen.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230417-ux500-dma40-cleanup-v3-4-60bfa6785968@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 7ca608cf6b84 ("dmaengine: ste_dma40: Fix probe IRQ leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c                       |  56 ++++++----
 .../dma/ste_dma40.h                           | 101 +-----------------
 drivers/dma/ste_dma40_ll.c                    |   3 +-
 3 files changed, 41 insertions(+), 119 deletions(-)
 rename include/linux/platform_data/dma-ste-dma40.h => drivers/dma/ste_dma40.h (51%)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 63debc6af54e1..6afe700a8de82 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -23,11 +23,39 @@
 #include <linux/of_dma.h>
 #include <linux/amba/bus.h>
 #include <linux/regulator/consumer.h>
-#include <linux/platform_data/dma-ste-dma40.h>
 
 #include "dmaengine.h"
+#include "ste_dma40.h"
 #include "ste_dma40_ll.h"
 
+/**
+ * struct stedma40_platform_data - Configuration struct for the dma device.
+ *
+ * @dev_tx: mapping between destination event line and io address
+ * @dev_rx: mapping between source event line and io address
+ * @disabled_channels: A vector, ending with -1, that marks physical channels
+ * that are for different reasons not available for the driver.
+ * @soft_lli_chans: A vector, that marks physical channels will use LLI by SW
+ * which avoids HW bug that exists in some versions of the controller.
+ * SoftLLI introduces relink overhead that could impact performace for
+ * certain use cases.
+ * @num_of_soft_lli_chans: The number of channels that needs to be configured
+ * to use SoftLLI.
+ * @use_esram_lcla: flag for mapping the lcla into esram region
+ * @num_of_memcpy_chans: The number of channels reserved for memcpy.
+ * @num_of_phy_chans: The number of physical channels implemented in HW.
+ * 0 means reading the number of channels from DMA HW but this is only valid
+ * for 'multiple of 4' channels, like 8.
+ */
+struct stedma40_platform_data {
+	int				 disabled_channels[STEDMA40_MAX_PHYS];
+	int				*soft_lli_chans;
+	int				 num_of_soft_lli_chans;
+	bool				 use_esram_lcla;
+	int				 num_of_memcpy_chans;
+	int				 num_of_phy_chans;
+};
+
 #define D40_NAME "dma40"
 
 #define D40_PHY_CHAN -1
@@ -2307,7 +2335,7 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	return NULL;
 }
 
-bool stedma40_filter(struct dma_chan *chan, void *data)
+static bool stedma40_filter(struct dma_chan *chan, void *data)
 {
 	struct stedma40_chan_cfg *info = data;
 	struct d40_chan *d40c =
@@ -2326,7 +2354,6 @@ bool stedma40_filter(struct dma_chan *chan, void *data)
 
 	return err == 0;
 }
-EXPORT_SYMBOL(stedma40_filter);
 
 static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 {
@@ -3561,16 +3588,9 @@ static int __init d40_probe(struct platform_device *pdev)
 	int num_reserved_chans;
 	u32 val;
 
-	if (!plat_data) {
-		if (np) {
-			if (d40_of_probe(pdev, np)) {
-				ret = -ENOMEM;
-				goto report_failure;
-			}
-		} else {
-			d40_err(dev, "No pdata or Device Tree provided\n");
-			goto report_failure;
-		}
+	if (d40_of_probe(pdev, np)) {
+		ret = -ENOMEM;
+		goto report_failure;
 	}
 
 	base = d40_hw_detect_init(pdev);
@@ -3702,11 +3722,11 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	d40_hw_init(base);
 
-	if (np) {
-		ret = of_dma_controller_register(np, d40_xlate, NULL);
-		if (ret)
-			dev_err(dev,
-				"could not register of_dma_controller\n");
+	ret = of_dma_controller_register(np, d40_xlate, NULL);
+	if (ret) {
+		dev_err(dev,
+			"could not register of_dma_controller\n");
+		goto destroy_cache;
 	}
 
 	dev_info(base->dev, "initialized\n");
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/drivers/dma/ste_dma40.h
similarity index 51%
rename from include/linux/platform_data/dma-ste-dma40.h
rename to drivers/dma/ste_dma40.h
index 10641633facc8..c697bfe16a017 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/drivers/dma/ste_dma40.h
@@ -1,19 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) ST-Ericsson SA 2007-2010
- * Author: Per Forlin <per.forlin@stericsson.com> for ST-Ericsson
- * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
- */
-
 
 #ifndef STE_DMA40_H
 #define STE_DMA40_H
 
-#include <linux/dmaengine.h>
-#include <linux/scatterlist.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-
 /*
  * Maxium size for a single dma descriptor
  * Size is limited to 16 bits.
@@ -118,92 +107,4 @@ struct stedma40_chan_cfg {
 	int					 phy_channel;
 };
 
-/**
- * struct stedma40_platform_data - Configuration struct for the dma device.
- *
- * @dev_tx: mapping between destination event line and io address
- * @dev_rx: mapping between source event line and io address
- * @disabled_channels: A vector, ending with -1, that marks physical channels
- * that are for different reasons not available for the driver.
- * @soft_lli_chans: A vector, that marks physical channels will use LLI by SW
- * which avoids HW bug that exists in some versions of the controller.
- * SoftLLI introduces relink overhead that could impact performace for
- * certain use cases.
- * @num_of_soft_lli_chans: The number of channels that needs to be configured
- * to use SoftLLI.
- * @use_esram_lcla: flag for mapping the lcla into esram region
- * @num_of_memcpy_chans: The number of channels reserved for memcpy.
- * @num_of_phy_chans: The number of physical channels implemented in HW.
- * 0 means reading the number of channels from DMA HW but this is only valid
- * for 'multiple of 4' channels, like 8.
- */
-struct stedma40_platform_data {
-	int				 disabled_channels[STEDMA40_MAX_PHYS];
-	int				*soft_lli_chans;
-	int				 num_of_soft_lli_chans;
-	bool				 use_esram_lcla;
-	int				 num_of_memcpy_chans;
-	int				 num_of_phy_chans;
-};
-
-#ifdef CONFIG_STE_DMA40
-
-/**
- * stedma40_filter() - Provides stedma40_chan_cfg to the
- * ste_dma40 dma driver via the dmaengine framework.
- * does some checking of what's provided.
- *
- * Never directly called by client. It used by dmaengine.
- * @chan: dmaengine handle.
- * @data: Must be of type: struct stedma40_chan_cfg and is
- * the configuration of the framework.
- *
- *
- */
-
-bool stedma40_filter(struct dma_chan *chan, void *data);
-
-/**
- * stedma40_slave_mem() - Transfers a raw data buffer to or from a slave
- * (=device)
- *
- * @chan: dmaengine handle
- * @addr: source or destination physicall address.
- * @size: bytes to transfer
- * @direction: direction of transfer
- * @flags: is actually enum dma_ctrl_flags. See dmaengine.h
- */
-
-static inline struct
-dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
-					    dma_addr_t addr,
-					    unsigned int size,
-					    enum dma_transfer_direction direction,
-					    unsigned long flags)
-{
-	struct scatterlist sg;
-	sg_init_table(&sg, 1);
-	sg.dma_address = addr;
-	sg.length = size;
-
-	return dmaengine_prep_slave_sg(chan, &sg, 1, direction, flags);
-}
-
-#else
-static inline bool stedma40_filter(struct dma_chan *chan, void *data)
-{
-	return false;
-}
-
-static inline struct
-dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
-					    dma_addr_t addr,
-					    unsigned int size,
-					    enum dma_transfer_direction direction,
-					    unsigned long flags)
-{
-	return NULL;
-}
-#endif
-
-#endif
+#endif /* STE_DMA40_H */
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index b5287c661eb7a..4c489b126cb27 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -6,8 +6,9 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/platform_data/dma-ste-dma40.h>
+#include <linux/dmaengine.h>
 
+#include "ste_dma40.h"
 #include "ste_dma40_ll.h"
 
 static u8 d40_width_to_bits(enum dma_slave_buswidth width)
-- 
2.53.0



