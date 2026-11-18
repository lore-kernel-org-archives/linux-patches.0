Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040326;
	b=RJ3HeklFmWOCiYoUsbHvqcJ5v3Nr/NT2J+SXytJWAk1N7sWxD4Yy90pGdvRIM727IzeM
	 ZUoOYQiDBRmXK0XK2Awjs2Aqk/aFiSk5hm8KignUScxPw3CUTIfVHlHfpXpXkzZtooq2E
	 USSpan86s37DHnpZrp3+7gfll38QUsW0eduSYrsB7q9XV9U4Wq8UGGjb6gjLNhkeFAzwl
	 En+oc08b46biCuwtzym93jgpSrQ/AodAsS/NBAGVgAzMkCsEAFjSfxF547zuQB2Yza9qx
	 KkyHJbUuXDwmLrcT5lxBpvxKtsRItT/fvscLD1AtrpUnOAQ2+SOy2z6aIojCK1HiF4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WHeAvs90FH1p/k7FfGq0TivBJoqPOabH7/H3+8D+Z8c=;
	b=qULDegYr99529UcjCv6nJIMD33In39mzb0CSY40RV64wJ44CnEdRFK2jdwT72xaIDqei
	 oEResIO9bR1YqkovRhGzpqLYLhyHEBWBX9dKMy8KnXJrqIVpfsxdwCrLLtA2N56Le9aYg
	 GoXCUWejWkc1yf8ra4PIVJsPy/hevDySY3AdMqp1Kc3eAK1NDFWMjpdxw6QkwneI4nY5H
	 ROqDhzRp+W5WIzBeTFmu8GUvhy0Fp3yVbPVCZkr5Vst6bc6/V5BjueqZZF/V+CNiRd2Bw
	 xdenFcuZsMmvO5EemIBYwpEvdLbMs1cMnpJdBGbVm2vr9b7PlZWVQDb3Pr5SXXrJkAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTzTwtvE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5103606A325;
	Wed, 18 Nov 2026 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTzTwtvE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0332D1F000C4;
	Wed, 18 Nov 2026 22:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040326;
	bh=WHeAvs90FH1p/k7FfGq0TivBJoqPOabH7/H3+8D+Z8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTzTwtvEZ/KY+SKAfGZ5dwNTian5AIm41FTlX7C8j4MUhfS4NvJMIinbk1ec1Au3z
	 UHjE2OwplgzMQUs4OT4AS0oeaK4pRvfv5feWbDuiEo2ap+txl8wsTC6AJZGaRalrNl
	 fwo+eqgt97US2s3GwwCvCzcXyZitb5u5ot0FcihQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2418/3318] spi: rspi: Get rid of unused struct rspi_plat_data
Date: Wed, 18 Nov 2026 15:50:40 +0100
Message-ID: <20261118150434.022568805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a4f9a276cf56..77809e3a5dba7 100644
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
@@ -1296,7 +1291,6 @@ static int rspi_probe(struct platform_device *pdev)
 	struct spi_controller *ctlr;
 	struct rspi_data *rspi;
 	int ret;
-	const struct rspi_plat_data *rspi_pd;
 	const struct spi_ops *ops;
 	unsigned long clksrc;
 
@@ -1311,11 +1305,7 @@ static int rspi_probe(struct platform_device *pdev)
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



