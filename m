Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A9C47CC62;
	Tue, 16 Jun 2026 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632302; cv=none; b=FN2iSoI0cyYqK9EZSwiAD6QFSYU3wo6derZDxzZx+qRC6wiJ4dpxG6Z/8UoAEQwCmalooxvuLXctBxu7tVat3PS9e9wNu5mgIxQIqOpYk7wm+OuEY54sxP3dY0qKK6a3fyojUbEZ/E6lImmvLsEY6nriopitLVgTLd4JPfMbqZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632302; c=relaxed/simple;
	bh=9LS/TpZ09f7adFiBBIY9Uib824e2HzVxOcZ/mhl70Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mlugspgmk4Xr0WnLS/gfQYGRC/gNrGF2iqMncsNxacLxhH68okea3zf11RhIPoodVOizYb3ktYftEASSYitTonSwjjXkR8/sIQg4SQVoBec8jxX0b+YLo4pUJ3N9RXO9oA/ttG25n3Gvu5u7SGdqvnq1sm4lghHvTp1dlMju3vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoi1xLRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoi1xLRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188651F000E9;
	Tue, 16 Jun 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632299;
	bh=oxYOFaXhLoQeGnEpFsB5Vf8yFPVZnTHnBe9swgsiFtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoi1xLRpusp6rPPqbjU3M9Vbix8z+E/JCVNqwQG7GVfi5VXEM/LHeO14YTaLiGjj+
	 SXWBoIkfRxv8Xo3WY5Zfv2RerbyykwMr3h8TZKfKCB1QEMh6R0dk2VvSyIbGJuSnBr
	 US7YoPE65/d1G/jTBOGxojkGbDKYuEMcaEqqPZ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 385/522] spi: Convert to SPI_CONTROLLER_HALF_DUPLEX
Date: Tue, 16 Jun 2026 20:28:52 +0530
Message-ID: <20260616145143.797421861@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7a2b552c8e0e5bb280558f6c120140f5f06323bc ]

Convert the users under SPI subsystem to SPI_CONTROLLER_HALF_DUPLEX.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230710154932.68377-15-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0c18a1bacbb1 ("spi: ti-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-amd.c             |    2 +-
 drivers/spi/spi-cavium-thunderx.c |    2 +-
 drivers/spi/spi-falcon.c          |    2 +-
 drivers/spi/spi-lp8841-rtc.c      |    2 +-
 drivers/spi/spi-mxs.c             |    2 +-
 drivers/spi/spi-omap-uwire.c      |    2 +-
 drivers/spi/spi-pic32-sqi.c       |    2 +-
 drivers/spi/spi-qcom-qspi.c       |    2 +-
 drivers/spi/spi-rockchip-sfc.c    |    2 +-
 drivers/spi/spi-sprd-adi.c        |    2 +-
 drivers/spi/spi-ti-qspi.c         |    2 +-
 drivers/spi/spi-xcomm.c           |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -404,7 +404,7 @@ static int amd_spi_probe(struct platform
 	master->bus_num = 0;
 	master->num_chipselect = 4;
 	master->mode_bits = 0;
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->max_speed_hz = AMD_SPI_MAX_HZ;
 	master->min_speed_hz = AMD_SPI_MIN_HZ;
 	master->setup = amd_spi_master_setup;
--- a/drivers/spi/spi-cavium-thunderx.c
+++ b/drivers/spi/spi-cavium-thunderx.c
@@ -64,7 +64,7 @@ static int thunderx_spi_probe(struct pci
 		p->sys_freq = SYS_FREQ_DEFAULT;
 	dev_info(dev, "Set system clock to %u\n", p->sys_freq);
 
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->num_chipselect = 4;
 	master->mode_bits = SPI_CPHA | SPI_CPOL | SPI_CS_HIGH |
 			    SPI_LSB_FIRST | SPI_3WIRE;
--- a/drivers/spi/spi-falcon.c
+++ b/drivers/spi/spi-falcon.c
@@ -401,7 +401,7 @@ static int falcon_sflash_probe(struct pl
 	priv->master = master;
 
 	master->mode_bits = SPI_MODE_3;
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->setup = falcon_sflash_setup;
 	master->transfer_one_message = falcon_sflash_xfer_one;
 	master->dev.of_node = pdev->dev.of_node;
--- a/drivers/spi/spi-lp8841-rtc.c
+++ b/drivers/spi/spi-lp8841-rtc.c
@@ -191,7 +191,7 @@ spi_lp8841_rtc_probe(struct platform_dev
 		return -ENOMEM;
 	platform_set_drvdata(pdev, master);
 
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->mode_bits = SPI_CS_HIGH | SPI_3WIRE | SPI_LSB_FIRST;
 
 	master->bus_num = pdev->id;
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -573,7 +573,7 @@ static int mxs_spi_probe(struct platform
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
 	master->num_chipselect = 3;
 	master->dev.of_node = np;
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->auto_runtime_pm = true;
 
 	spi = spi_master_get_devdata(master);
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -491,7 +491,7 @@ static int uwire_probe(struct platform_d
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(1, 16);
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 
 	master->bus_num = 2;	/* "official" */
 	master->num_chipselect = 4;
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -648,7 +648,7 @@ static int pic32_sqi_probe(struct platfo
 	master->dev.of_node	= pdev->dev.of_node;
 	master->mode_bits	= SPI_MODE_3 | SPI_MODE_0 | SPI_TX_DUAL |
 				  SPI_RX_DUAL | SPI_TX_QUAD | SPI_RX_QUAD;
-	master->flags		= SPI_MASTER_HALF_DUPLEX;
+	master->flags		= SPI_CONTROLLER_HALF_DUPLEX;
 	master->can_dma		= pic32_sqi_can_dma;
 	master->bits_per_word_mask	= SPI_BPW_RANGE_MASK(8, 32);
 	master->transfer_one_message	= pic32_sqi_one_message;
--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -523,7 +523,7 @@ static int qcom_qspi_probe(struct platfo
 	master->mode_bits = SPI_MODE_0 |
 			    SPI_TX_DUAL | SPI_RX_DUAL |
 			    SPI_TX_QUAD | SPI_RX_QUAD;
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->prepare_message = qcom_qspi_prepare_message;
 	master->transfer_one = qcom_qspi_transfer_one;
 	master->handle_err = qcom_qspi_handle_err;
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -566,7 +566,7 @@ static int rockchip_sfc_probe(struct pla
 	if (!master)
 		return -ENOMEM;
 
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->mem_ops = &rockchip_sfc_mem_ops;
 	master->dev.of_node = pdev->dev.of_node;
 	master->mode_bits = SPI_TX_QUAD | SPI_TX_DUAL | SPI_RX_QUAD | SPI_RX_DUAL;
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -570,7 +570,7 @@ static int sprd_adi_probe(struct platfor
 	ctlr->dev.of_node = pdev->dev.of_node;
 	ctlr->bus_num = pdev->id;
 	ctlr->num_chipselect = num_chipselect;
-	ctlr->flags = SPI_MASTER_HALF_DUPLEX;
+	ctlr->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	ctlr->bits_per_word_mask = 0;
 	ctlr->transfer_one = sprd_adi_transfer_one;
 
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -770,7 +770,7 @@ static int ti_qspi_probe(struct platform
 
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD;
 
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->setup = ti_qspi_setup;
 	master->auto_runtime_pm = true;
 	master->transfer_one_message = ti_qspi_start_transfer_one;
--- a/drivers/spi/spi-xcomm.c
+++ b/drivers/spi/spi-xcomm.c
@@ -219,7 +219,7 @@ static int spi_xcomm_probe(struct i2c_cl
 	master->num_chipselect = 16;
 	master->mode_bits = SPI_CPHA | SPI_CPOL | SPI_3WIRE;
 	master->bits_per_word_mask = SPI_BPW_MASK(8);
-	master->flags = SPI_MASTER_HALF_DUPLEX;
+	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
 	master->transfer_one_message = spi_xcomm_transfer_one;
 	master->dev.of_node = i2c->dev.of_node;
 	i2c_set_clientdata(i2c, master);


