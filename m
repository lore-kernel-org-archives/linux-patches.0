Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060966;
	b=AkpwyaYPmscYRYLMyOgcB1Y3yoFhddnM1x8TSGFm3wyhANCtkcgETBeltiUivKhUhPd7
	 96sZbtDIlJbIFAuubXCyOkB96236p9aDoEJvoe2SNsxgSCW26IpCohQvQSCLIoNRg/Koo
	 Y9I+17GAJAnVcpKctYEhl8ssPgyER5mn5HJx16717UupM4mv0vcvC2nFFBNJWZ5UtHPYc
	 fzma+GnVq2nybx7YqnfBEgOzirJJJ/QN/ZzCtuRPbTMMaCDNkwnAbvJ1RQFnX7cxMllur
	 Y1YbnXSNg1YjGFz6BvWnxmeL8G8wgC61gGFUJ34+7RFTaDOIuNU6Lt4Cbf+Wa5UcmlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=10EmiWWNbj4VSO4YhbT2n1VHCZONBJ51pnKS1MVqMDc=;
	b=mFYzc8vWZTCgOa7ooH+frEZ0mzWgteVJQR2X4DL87r3U0duW8B0iManTR65TsaUkJvZ6
	 4Kw6r7J0+R3zEG4IFiHigWVaZbR+fIZ8qpikVet9k4XT2sTDScvJ1LFggRDFQNJAhOQr1
	 h/QNy+jFGHHTNatFCnZVKtzP+NmfXtb0QXAi/vR+TTKYRaZN9fRV7YNbpMqp8AlElL9y1
	 T75YmMlHW0D/MM3TuoPXM0GEx0x445IXfH2+QhGxdGbwinTy6+tP1y6nuw77/LjsAYj+e
	 ZhtmHygB+NDu0jSo748aD4Nc+OX8/MiCIZidNbMAYJ9RUW679GrrQP6flXubnYhwUAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhtQDMZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B6C606A32F;
	Thu, 19 Nov 2026 04:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhtQDMZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78A01F000C4;
	Thu, 19 Nov 2026 04:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060966;
	bh=10EmiWWNbj4VSO4YhbT2n1VHCZONBJ51pnKS1MVqMDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhtQDMZTm3wVYESe85KJPbzAUTgE29eLSZT+uxDKsmRyV3nllssr5Li11O5nM9zAg
	 tDQH5Yld/bLTh3pi9i+mQb7JjP0mL07tU7jMJo6gBSyc8eV2wW8Kl+RyWDhmtzcAcQ
	 dFnSs/OjPa/V8oZBa45o2Rf+Pne7nHbLs+39Qe28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1389/1848] spi: rspi: Get rid of unused struct rspi_plat_data
Date: Wed, 18 Nov 2026 15:57:07 +0100
Message-ID: <20261118150017.599918827@linuxfoundation.org>
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
index 7ff89313cae5b..13895d7a6eebd 100644
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



