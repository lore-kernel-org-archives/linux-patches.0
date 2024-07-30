Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185F1FBA;
	Tue, 30 Jul 2024 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358835; cv=none; b=T51OAt2Ykw0Rp3NbNCRwTKGmrOOS9c8a6ARPxnY9/nL8UIiCfgcdMoExYzn5s6PmVMunWkqnT6oh6j/K0g6EfNJUrX+shk9CcL0pEveZDOyxmRjQqmuEGsjr3AmEniUcWylsrbmb8rYven281MfGOo1U5aIrh3kEk4t5jP2F8uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358835; c=relaxed/simple;
	bh=pRFalLbTsRcTYPSA+9JV4ednTrFG0cSC0r79l9x3GeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvLdBe2XVyNN9TM06J80ARcFkfrSnGHvYC6fLtv7rKi9tZZV2I66fr+mFAKW9udlZWA+j2pyEub8gK+HjLbTJunRUh6MJ2rj15QIOYtYcFytz2O3Ux8wRYlM/G+7BYKcMFxd3I9ricmjGze9+LsH2Ra7mlRCS03pBz9QOJrIWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWmtJJUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWmtJJUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBC4C32782;
	Tue, 30 Jul 2024 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358834;
	bh=pRFalLbTsRcTYPSA+9JV4ednTrFG0cSC0r79l9x3GeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWmtJJUoIxbYLy2HgcdSbk61Ad/SyQGvF6pp2u1ekmj3rUZoZHJnGUHhaTL9iiX8x
	 KU14P6AprCPWBH6LBJNwP1pfWDBLf0sw0z3/ngTHEag8T4aPIAHsSLCCZryZLDrbMO
	 W1pRhOLizcvQL0kRkA5vCLgBgmVK+xVL2tmFC2U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 426/440] spi: microchip-core: switch to use modern name
Date: Tue, 30 Jul 2024 17:50:59 +0200
Message-ID: <20240730151632.420261782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8f8bf52ed5b76fc7958b0fbe3131540aecdff8ac ]

Change legacy name master/slave to modern name host/target or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230823033003.3407403-7-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3a5e76283672 ("spi: microchip-core: fix init function not setting the master and motorola modes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 74 ++++++++++++++++----------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index 13de3095ef817..a5173d820ac2e 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -257,7 +257,7 @@ static inline void mchp_corespi_set_framesize(struct mchp_corespi *spi, int bt)
 static void mchp_corespi_set_cs(struct spi_device *spi, bool disable)
 {
 	u32 reg;
-	struct mchp_corespi *corespi = spi_master_get_devdata(spi->master);
+	struct mchp_corespi *corespi = spi_controller_get_devdata(spi->controller);
 
 	reg = mchp_corespi_read(corespi, REG_SLAVE_SELECT);
 	reg &= ~BIT(spi->chip_select);
@@ -268,11 +268,11 @@ static void mchp_corespi_set_cs(struct spi_device *spi, bool disable)
 
 static int mchp_corespi_setup(struct spi_device *spi)
 {
-	struct mchp_corespi *corespi = spi_master_get_devdata(spi->master);
+	struct mchp_corespi *corespi = spi_controller_get_devdata(spi->controller);
 	u32 reg;
 
 	/*
-	 * Active high slaves need to be specifically set to their inactive
+	 * Active high targets need to be specifically set to their inactive
 	 * states during probe by adding them to the "control group" & thus
 	 * driving their select line low.
 	 */
@@ -284,7 +284,7 @@ static int mchp_corespi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static void mchp_corespi_init(struct spi_master *master, struct mchp_corespi *spi)
+static void mchp_corespi_init(struct spi_controller *host, struct mchp_corespi *spi)
 {
 	unsigned long clk_hz;
 	u32 control = mchp_corespi_read(spi, REG_CONTROL);
@@ -298,7 +298,7 @@ static void mchp_corespi_init(struct spi_master *master, struct mchp_corespi *sp
 
 	/* max. possible spi clock rate is the apb clock rate */
 	clk_hz = clk_get_rate(spi->clk);
-	master->max_speed_hz = clk_hz;
+	host->max_speed_hz = clk_hz;
 
 	/*
 	 * The controller must be configured so that it doesn't remove Chip
@@ -318,7 +318,7 @@ static void mchp_corespi_init(struct spi_master *master, struct mchp_corespi *sp
 	/*
 	 * It is required to enable direct mode, otherwise control over the chip
 	 * select is relinquished to the hardware. SSELOUT is enabled too so we
-	 * can deal with active high slaves.
+	 * can deal with active high targets.
 	 */
 	mchp_corespi_write(spi, REG_SLAVE_SELECT, SSELOUT | SSEL_DIRECT);
 
@@ -383,8 +383,8 @@ static inline void mchp_corespi_set_mode(struct mchp_corespi *spi, unsigned int
 
 static irqreturn_t mchp_corespi_interrupt(int irq, void *dev_id)
 {
-	struct spi_master *master = dev_id;
-	struct mchp_corespi *spi = spi_master_get_devdata(master);
+	struct spi_controller *host = dev_id;
+	struct mchp_corespi *spi = spi_controller_get_devdata(host);
 	u32 intfield = mchp_corespi_read(spi, REG_MIS) & 0xf;
 	bool finalise = false;
 
@@ -408,7 +408,7 @@ static irqreturn_t mchp_corespi_interrupt(int irq, void *dev_id)
 	if (intfield & INT_RX_CHANNEL_OVERFLOW) {
 		mchp_corespi_write(spi, REG_INT_CLEAR, INT_RX_CHANNEL_OVERFLOW);
 		finalise = true;
-		dev_err(&master->dev,
+		dev_err(&host->dev,
 			"%s: RX OVERFLOW: rxlen: %d, txlen: %d\n", __func__,
 			spi->rx_len, spi->tx_len);
 	}
@@ -416,13 +416,13 @@ static irqreturn_t mchp_corespi_interrupt(int irq, void *dev_id)
 	if (intfield & INT_TX_CHANNEL_UNDERRUN) {
 		mchp_corespi_write(spi, REG_INT_CLEAR, INT_TX_CHANNEL_UNDERRUN);
 		finalise = true;
-		dev_err(&master->dev,
+		dev_err(&host->dev,
 			"%s: TX UNDERFLOW: rxlen: %d, txlen: %d\n", __func__,
 			spi->rx_len, spi->tx_len);
 	}
 
 	if (finalise)
-		spi_finalize_current_transfer(master);
+		spi_finalize_current_transfer(host);
 
 	return IRQ_HANDLED;
 }
@@ -464,16 +464,16 @@ static int mchp_corespi_calculate_clkgen(struct mchp_corespi *spi,
 	return 0;
 }
 
-static int mchp_corespi_transfer_one(struct spi_master *master,
+static int mchp_corespi_transfer_one(struct spi_controller *host,
 				     struct spi_device *spi_dev,
 				     struct spi_transfer *xfer)
 {
-	struct mchp_corespi *spi = spi_master_get_devdata(master);
+	struct mchp_corespi *spi = spi_controller_get_devdata(host);
 	int ret;
 
 	ret = mchp_corespi_calculate_clkgen(spi, (unsigned long)xfer->speed_hz);
 	if (ret) {
-		dev_err(&master->dev, "failed to set clk_gen for target %u Hz\n", xfer->speed_hz);
+		dev_err(&host->dev, "failed to set clk_gen for target %u Hz\n", xfer->speed_hz);
 		return ret;
 	}
 
@@ -494,11 +494,11 @@ static int mchp_corespi_transfer_one(struct spi_master *master,
 	return 1;
 }
 
-static int mchp_corespi_prepare_message(struct spi_master *master,
+static int mchp_corespi_prepare_message(struct spi_controller *host,
 					struct spi_message *msg)
 {
 	struct spi_device *spi_dev = msg->spi;
-	struct mchp_corespi *spi = spi_master_get_devdata(master);
+	struct mchp_corespi *spi = spi_controller_get_devdata(host);
 
 	mchp_corespi_set_framesize(spi, DEFAULT_FRAMESIZE);
 	mchp_corespi_set_mode(spi, spi_dev->mode);
@@ -508,32 +508,32 @@ static int mchp_corespi_prepare_message(struct spi_master *master,
 
 static int mchp_corespi_probe(struct platform_device *pdev)
 {
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct mchp_corespi *spi;
 	struct resource *res;
 	u32 num_cs;
 	int ret = 0;
 
-	master = devm_spi_alloc_master(&pdev->dev, sizeof(*spi));
-	if (!master)
+	host = devm_spi_alloc_host(&pdev->dev, sizeof(*spi));
+	if (!host)
 		return dev_err_probe(&pdev->dev, -ENOMEM,
-				     "unable to allocate master for SPI controller\n");
+				     "unable to allocate host for SPI controller\n");
 
-	platform_set_drvdata(pdev, master);
+	platform_set_drvdata(pdev, host);
 
 	if (of_property_read_u32(pdev->dev.of_node, "num-cs", &num_cs))
 		num_cs = MAX_CS;
 
-	master->num_chipselect = num_cs;
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
-	master->setup = mchp_corespi_setup;
-	master->bits_per_word_mask = SPI_BPW_MASK(8);
-	master->transfer_one = mchp_corespi_transfer_one;
-	master->prepare_message = mchp_corespi_prepare_message;
-	master->set_cs = mchp_corespi_set_cs;
-	master->dev.of_node = pdev->dev.of_node;
+	host->num_chipselect = num_cs;
+	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+	host->setup = mchp_corespi_setup;
+	host->bits_per_word_mask = SPI_BPW_MASK(8);
+	host->transfer_one = mchp_corespi_transfer_one;
+	host->prepare_message = mchp_corespi_prepare_message;
+	host->set_cs = mchp_corespi_set_cs;
+	host->dev.of_node = pdev->dev.of_node;
 
-	spi = spi_master_get_devdata(master);
+	spi = spi_controller_get_devdata(host);
 
 	spi->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(spi->regs))
@@ -546,7 +546,7 @@ static int mchp_corespi_probe(struct platform_device *pdev)
 				     spi->irq);
 
 	ret = devm_request_irq(&pdev->dev, spi->irq, mchp_corespi_interrupt,
-			       IRQF_SHARED, dev_name(&pdev->dev), master);
+			       IRQF_SHARED, dev_name(&pdev->dev), host);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "could not request irq\n");
@@ -561,25 +561,25 @@ static int mchp_corespi_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret,
 				     "failed to enable clock\n");
 
-	mchp_corespi_init(master, spi);
+	mchp_corespi_init(host, spi);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = devm_spi_register_controller(&pdev->dev, host);
 	if (ret) {
 		mchp_corespi_disable(spi);
 		clk_disable_unprepare(spi->clk);
 		return dev_err_probe(&pdev->dev, ret,
-				     "unable to register master for SPI controller\n");
+				     "unable to register host for SPI controller\n");
 	}
 
-	dev_info(&pdev->dev, "Registered SPI controller %d\n", master->bus_num);
+	dev_info(&pdev->dev, "Registered SPI controller %d\n", host->bus_num);
 
 	return 0;
 }
 
 static int mchp_corespi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master  = platform_get_drvdata(pdev);
-	struct mchp_corespi *spi = spi_master_get_devdata(master);
+	struct spi_controller *host  = platform_get_drvdata(pdev);
+	struct mchp_corespi *spi = spi_controller_get_devdata(host);
 
 	mchp_corespi_disable_ints(spi);
 	clk_disable_unprepare(spi->clk);
-- 
2.43.0



