Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055579;
	b=Pwjd6ib4KYf2vQFD+/XxL10TbuoxkxJ4EOhG75dceig+TFqHWlbDP03HEWyBZKlaQqjx
	 bdNypY1gLb8la0XxdehR6c8vgu5D4/7espHqjeWgvD11YSAFgwWVVbY7TpTuxETAeeyFO
	 Jo5xejZYb5dNTTjQovKnK9lGWflhCc1xAvHphjoNAi6ISMtXAyy5HCsUBtjc7zf/1564K
	 bZNZfIJXCEZKwOrPYLy7GB9sIxnXEQuq7PQnyMfYMFWMiCSZ2EsOyuj9i+rKkcWqBt2Bu
	 Ndo4a1zrmay4lYF62RWIdFkQFfpd3DzGfnLD3GldlUdQie1r7/xx5InH8Sks08j5W9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4DFnh/Hl2J7BRz1iY69ALbPE4N03Kl3V8sgyzWbQnpg=;
	b=KTtfjzyZiShhRCKypbQYjtzK8b+FNsIKN7qQe4LtWU8cCv2QA4v/fWArYL5xTkQK+3+j
	 TN9bkD32Toru8nnTz9ND9ICvCv+tGwJDuEVW+/WLc4RGCZaqAKPbRLlm4gUzQbO7cRbJH
	 3uw/qqItWIFHpRl0JiaeX3GfdzJ7iye1coEfPUmiBK1F/xgJ38jxz7VTnIYyEcv6qd/gb
	 W8EPXf2vLdKlPc9cgBYK4VDi+sylyWSjB9zgh6pZGTxMSdh3O61p/iH1nWth510rAPW2s
	 kmbQ9QSj4RQFBwAGAwfWunaBpVgV7cLQtA7gumMNrFBzepogphcn6OJD67a/QxhPgLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iY6Ie1/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889C606A332;
	Thu, 19 Nov 2026 02:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iY6Ie1/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1FD1F000C4;
	Thu, 19 Nov 2026 02:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055579;
	bh=4DFnh/Hl2J7BRz1iY69ALbPE4N03Kl3V8sgyzWbQnpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY6Ie1/orp7f6uhDyycGZl+FZWej6/ObpLoYLyYzF8DbudBfgnFISY2Qx41FiIfOZ
	 G90rmG2bkUsbV9QzePAxZSgXPpF1b+3HvX4ur3FPBWbeG/1I+WOyn584bJCrYX0LXz
	 49VSagwCzF6W0vGBAKmFr/ZFf7P1yrb5Fk+BB6eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1642/2214] spi: rspi: Get rid of unused struct rspi_plat_data
Date: Wed, 18 Nov 2026 15:55:18 +0100
Message-ID: <20261118150117.608286551@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit bdeef5dcea6b164f4bd614655821b1ef12ebec9a ]

No in-kernel users of struct rspi_plat_data. If required,
the software nodes should be used for such users. For now
just get rid of it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://msgid.link/r/20240325142118.3210915-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7b85114d47f6 ("spi: rspi: Fix DMA mode when the DMA controller is built as a module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c   | 12 +-----------
 include/linux/spi/rspi.h | 18 ------------------
 2 files changed, 1 insertion(+), 29 deletions(-)
 delete mode 100644 include/linux/spi/rspi.h

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 5d3c6fd09d903..ec5b98ac3a223 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -24,7 +24,6 @@
 #include <linux/reset.h>
 #include <linux/sh_dma.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/rspi.h>
 #include <linux/spinlock.h>
 
 #define RSPI_SPCR		0x00	/* Control Register */
@@ -1131,16 +1130,12 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 static int rspi_request_dma(struct device *dev, struct spi_controller *ctlr,
 			    const struct resource *res)
 {
-	const struct rspi_plat_data *rspi_pd = dev_get_platdata(dev);
 	unsigned int dma_tx_id, dma_rx_id;
 
 	if (dev->of_node) {
 		/* In the OF case we will get the slave IDs from the DT */
 		dma_tx_id = 0;
 		dma_rx_id = 0;
-	} else if (rspi_pd && rspi_pd->dma_tx_id && rspi_pd->dma_rx_id) {
-		dma_tx_id = rspi_pd->dma_tx_id;
-		dma_rx_id = rspi_pd->dma_rx_id;
 	} else {
 		/* The driver assumes no error. */
 		return 0;
@@ -1292,7 +1287,6 @@ static int rspi_probe(struct platform_device *pdev)
 	struct spi_controller *ctlr;
 	struct rspi_data *rspi;
 	int ret;
-	const struct rspi_plat_data *rspi_pd;
 	const struct spi_ops *ops;
 	unsigned long clksrc;
 
@@ -1307,11 +1301,7 @@ static int rspi_probe(struct platform_device *pdev)
 			goto error1;
 	} else {
 		ops = (struct spi_ops *)pdev->id_entry->driver_data;
-		rspi_pd = dev_get_platdata(&pdev->dev);
-		if (rspi_pd && rspi_pd->num_chipselect)
-			ctlr->num_chipselect = rspi_pd->num_chipselect;
-		else
-			ctlr->num_chipselect = 2; /* default */
+		ctlr->num_chipselect = 2; /* default */
 	}
 
 	rspi = spi_controller_get_devdata(ctlr);
diff --git a/include/linux/spi/rspi.h b/include/linux/spi/rspi.h
deleted file mode 100644
index dbdfcc7a3db22..0000000000000
--- a/include/linux/spi/rspi.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Renesas SPI driver
- *
- * Copyright (C) 2012  Renesas Solutions Corp.
- */
-
-#ifndef __LINUX_SPI_RENESAS_SPI_H__
-#define __LINUX_SPI_RENESAS_SPI_H__
-
-struct rspi_plat_data {
-	unsigned int dma_tx_id;
-	unsigned int dma_rx_id;
-
-	u16 num_chipselect;
-};
-
-#endif
-- 
2.53.0



