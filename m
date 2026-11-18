Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061261;
	b=JNsccV6TKXpMv3aY2ARxkHV3gTVquTFRcB+vPnurPojin6EETLbI41G9Quesa6KN3MPj
	 9bpxwbllgxR/90EaY5hwEKBcZZ+ZWgCox88P9Xno95KSalyW/WFrxiThGtIlKPPzjApH6
	 wzGMLGz9djmwSb8qfvL8mxTmQl2tD70EFpAlqcUhsxHKcidyFWtxukqyWO/fITxrNjg6M
	 Oy1cTVoqq85WABsYIAAebfWlfN5h4BVbqX9OzaMLSpqna1rsnmValHvSdxH760GzQfgUq
	 AmUjwwih5BVLJqFDKs47UDj2hqWwX3nYfYZKGaBuGYuem1+a8JQd4AXik9MpAH2AhNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9qIrI/r09B+FinlEz34IIYh6EYT0GqGVV/qwMMKe9fU=;
	b=PvBM2SBGhwSwSSaR7X/JMGFt6DQtON9q5vYB7pHhXpOb9mKX2JVRP8r3d1EbdfPkJ8Rl
	 iX7NSLx+phJQqPSVbjMGMYlm0/4ju2OrrNqOzmk74Y7HHySEN2RNpSpj3MVMZxCP6ttrU
	 Lj0UmveQafXRQTWNICyw8tVYxK37RscdwSaCVH1MtqcmxVyozPPKWGZWgryzkWTUa/nkW
	 0khkRpqmeCSnzo5p7dO+UAiQKknh274UCGdlfPDhCdp9sdLFyjWPEsAbhGbx2qJHsjks5
	 tIaJXfwqoMRRt7dY33dkdgYr4wuZ0bO2cq+WFkjziHQNfEbunkZMVAIAlADtzbpOAfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOlj7Fzr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2028E606A326;
	Thu, 19 Nov 2026 04:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOlj7Fzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CAA1F000C8;
	Thu, 19 Nov 2026 04:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061260;
	bh=9qIrI/r09B+FinlEz34IIYh6EYT0GqGVV/qwMMKe9fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOlj7Fzrr4P/LB4EqtZO/WISdRxIUa5tpMcAqUf7EU51ZWet1nDweRNULiy6DNUDb
	 7pedKYCJNLg7jshju4F+2mURJEi0inKPdmj7rlwZsQroX9pmB/RGJPyeZ1nyymgcF+
	 tBfP1G340EjA4MDw7qjnebQMGyBbzq4V8FR+HxCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1489/1848] dmaengine: ste_dma40: Remove platform data
Date: Wed, 18 Nov 2026 15:58:47 +0100
Message-ID: <20261118150021.567993943@linuxfoundation.org>
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
index d5bb481b0f6f0..cd21e638dbad4 100644
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
@@ -2308,7 +2336,7 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	return NULL;
 }
 
-bool stedma40_filter(struct dma_chan *chan, void *data)
+static bool stedma40_filter(struct dma_chan *chan, void *data)
 {
 	struct stedma40_chan_cfg *info = data;
 	struct d40_chan *d40c =
@@ -2327,7 +2355,6 @@ bool stedma40_filter(struct dma_chan *chan, void *data)
 
 	return err == 0;
 }
-EXPORT_SYMBOL(stedma40_filter);
 
 static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 {
@@ -3562,16 +3589,9 @@ static int __init d40_probe(struct platform_device *pdev)
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
@@ -3703,11 +3723,11 @@ static int __init d40_probe(struct platform_device *pdev)
 
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



