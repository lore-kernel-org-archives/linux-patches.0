Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878CD3D34AD;
	Tue, 16 Jun 2026 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632273; cv=none; b=OgDgcy48wRBiCKVz0scSqJPc0pci2fkXUOWl0b8eUDjQEaXwvKfL1vkds6h4POhDKf2eFPepQiyILJ1u0Alm800BDnYeymLhuiT9Az8sl4NaIfHaj2e/TKk6SQeuwSIDKXCaFA3AGW7vzaNjNqSM5F9AwD8eciG8t4FDAdElAtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632273; c=relaxed/simple;
	bh=kfCvvjweq3uKcaSZ+CwfojzyuGq4BGT2LBKevM/1yUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7HWFA+Vxn9E11dD8w8V1VF5HT1L+ofAO8hqP84zk1Wg5Ptr27F832+A7qnQXwPVrWFEmu1JUnU45CcPdwR7Socu5BDJJ0SQxa+4Hdvr/7Dil/l/oKlfyuKRsQfj8ett2qAM/dnk3HRIfbHf8ExnigXV3onEYPYujwejjiATyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2L/lqJmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2L/lqJmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F8C1F000E9;
	Tue, 16 Jun 2026 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632272;
	bh=1cQ6U+vlrHKRSWaZlfko1h3j5mfyNl7vfU0TjnfzYo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2L/lqJmygN/9JO0X79TPMrseEZOjztJ19iSUndUi9rqZF4QiHsPjpEsjp2TdbZhTf
	 wdy+j7jj2pngJBRJc3y2XcfjnumZWXyEKLhxZzvlr1vf+3TGnH+Z1qR2+oNfKRDshu
	 CQys8IMCd62OAdiC5grweMNxm2OY4dsfLUn6fRxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/522] spi: synquacer: switch to use modern name
Date: Tue, 16 Jun 2026 20:28:47 +0530
Message-ID: <20260616145143.554029754@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3524d1b727a66712f02f92807219a3650e5cf910 ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://msgid.link/r/20231128093031.3707034-10-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 75d849c3452e ("spi: syncuacer: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-synquacer.c |   84 ++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -225,11 +225,11 @@ static int write_fifo(struct synquacer_s
 	return 0;
 }
 
-static int synquacer_spi_config(struct spi_master *master,
+static int synquacer_spi_config(struct spi_controller *host,
 				struct spi_device *spi,
 				struct spi_transfer *xfer)
 {
-	struct synquacer_spi *sspi = spi_master_get_devdata(master);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 	unsigned int speed, mode, bpw, cs, bus_width, transfer_mode;
 	u32 rate, val, div;
 
@@ -263,7 +263,7 @@ static int synquacer_spi_config(struct s
 	}
 
 	sspi->transfer_mode = transfer_mode;
-	rate = master->max_speed_hz;
+	rate = host->max_speed_hz;
 
 	div = DIV_ROUND_UP(rate, speed);
 	if (div > 254) {
@@ -350,11 +350,11 @@ static int synquacer_spi_config(struct s
 	return 0;
 }
 
-static int synquacer_spi_transfer_one(struct spi_master *master,
+static int synquacer_spi_transfer_one(struct spi_controller *host,
 				      struct spi_device *spi,
 				      struct spi_transfer *xfer)
 {
-	struct synquacer_spi *sspi = spi_master_get_devdata(master);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 	int ret;
 	int status = 0;
 	u32 words;
@@ -378,7 +378,7 @@ static int synquacer_spi_transfer_one(st
 	if (bpw == 8 && !(xfer->len % 4) && !(spi->mode & SPI_LSB_FIRST))
 		xfer->bits_per_word = 32;
 
-	ret = synquacer_spi_config(master, spi, xfer);
+	ret = synquacer_spi_config(host, spi, xfer);
 
 	/* restore */
 	xfer->bits_per_word = bpw;
@@ -482,7 +482,7 @@ static int synquacer_spi_transfer_one(st
 
 static void synquacer_spi_set_cs(struct spi_device *spi, bool enable)
 {
-	struct synquacer_spi *sspi = spi_master_get_devdata(spi->master);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(spi->controller);
 	u32 val;
 
 	val = readl(sspi->regs + SYNQUACER_HSSPI_REG_DMSTART);
@@ -517,11 +517,11 @@ static int synquacer_spi_wait_status_upd
 	return -EBUSY;
 }
 
-static int synquacer_spi_enable(struct spi_master *master)
+static int synquacer_spi_enable(struct spi_controller *host)
 {
 	u32 val;
 	int status;
-	struct synquacer_spi *sspi = spi_master_get_devdata(master);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 
 	/* Disable module */
 	writel(0, sspi->regs + SYNQUACER_HSSPI_REG_MCTRL);
@@ -601,18 +601,18 @@ static irqreturn_t sq_spi_tx_handler(int
 static int synquacer_spi_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct synquacer_spi *sspi;
 	int ret;
 	int rx_irq, tx_irq;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*sspi));
-	if (!master)
+	host = spi_alloc_host(&pdev->dev, sizeof(*sspi));
+	if (!host)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, master);
+	platform_set_drvdata(pdev, host);
 
-	sspi = spi_master_get_devdata(master);
+	sspi = spi_controller_get_devdata(host);
 	sspi->dev = &pdev->dev;
 
 	init_completion(&sspi->transfer_done);
@@ -625,7 +625,7 @@ static int synquacer_spi_probe(struct pl
 
 	sspi->clk_src_type = SYNQUACER_HSSPI_CLOCK_SRC_IHCLK; /* Default */
 	device_property_read_u32(&pdev->dev, "socionext,ihclk-rate",
-				 &master->max_speed_hz); /* for ACPI */
+				 &host->max_speed_hz); /* for ACPI */
 
 	if (dev_of_node(&pdev->dev)) {
 		if (device_property_match_string(&pdev->dev,
@@ -655,21 +655,21 @@ static int synquacer_spi_probe(struct pl
 			goto put_spi;
 		}
 
-		master->max_speed_hz = clk_get_rate(sspi->clk);
+		host->max_speed_hz = clk_get_rate(sspi->clk);
 	}
 
-	if (!master->max_speed_hz) {
+	if (!host->max_speed_hz) {
 		dev_err(&pdev->dev, "missing clock source\n");
 		ret = -EINVAL;
 		goto disable_clk;
 	}
-	master->min_speed_hz = master->max_speed_hz / 254;
+	host->min_speed_hz = host->max_speed_hz / 254;
 
 	sspi->aces = device_property_read_bool(&pdev->dev,
 					       "socionext,set-aces");
 	sspi->rtm = device_property_read_bool(&pdev->dev, "socionext,use-rtm");
 
-	master->num_chipselect = SYNQUACER_HSSPI_NUM_CHIP_SELECT;
+	host->num_chipselect = SYNQUACER_HSSPI_NUM_CHIP_SELECT;
 
 	rx_irq = platform_get_irq(pdev, 0);
 	if (rx_irq <= 0) {
@@ -699,27 +699,27 @@ static int synquacer_spi_probe(struct pl
 		goto disable_clk;
 	}
 
-	master->dev.of_node = np;
-	master->dev.fwnode = pdev->dev.fwnode;
-	master->auto_runtime_pm = true;
-	master->bus_num = pdev->id;
-
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_TX_DUAL | SPI_RX_DUAL |
-			    SPI_TX_QUAD | SPI_RX_QUAD;
-	master->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(24) |
-				     SPI_BPW_MASK(16) | SPI_BPW_MASK(8);
+	host->dev.of_node = np;
+	host->dev.fwnode = pdev->dev.fwnode;
+	host->auto_runtime_pm = true;
+	host->bus_num = pdev->id;
+
+	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_TX_DUAL | SPI_RX_DUAL |
+			  SPI_TX_QUAD | SPI_RX_QUAD;
+	host->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(24) |
+				   SPI_BPW_MASK(16) | SPI_BPW_MASK(8);
 
-	master->set_cs = synquacer_spi_set_cs;
-	master->transfer_one = synquacer_spi_transfer_one;
+	host->set_cs = synquacer_spi_set_cs;
+	host->transfer_one = synquacer_spi_transfer_one;
 
-	ret = synquacer_spi_enable(master);
+	ret = synquacer_spi_enable(host);
 	if (ret)
 		goto disable_clk;
 
 	pm_runtime_set_active(sspi->dev);
 	pm_runtime_enable(sspi->dev);
 
-	ret = devm_spi_register_master(sspi->dev, master);
+	ret = devm_spi_register_controller(sspi->dev, host);
 	if (ret)
 		goto disable_pm;
 
@@ -730,15 +730,15 @@ disable_pm:
 disable_clk:
 	clk_disable_unprepare(sspi->clk);
 put_spi:
-	spi_master_put(master);
+	spi_controller_put(host);
 
 	return ret;
 }
 
 static void synquacer_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = platform_get_drvdata(pdev);
-	struct synquacer_spi *sspi = spi_master_get_devdata(master);
+	struct spi_controller *host = platform_get_drvdata(pdev);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 
 	pm_runtime_disable(sspi->dev);
 
@@ -747,11 +747,11 @@ static void synquacer_spi_remove(struct
 
 static int __maybe_unused synquacer_spi_suspend(struct device *dev)
 {
-	struct spi_master *master = dev_get_drvdata(dev);
-	struct synquacer_spi *sspi = spi_master_get_devdata(master);
+	struct spi_controller *host = dev_get_drvdata(dev);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 	int ret;
 
-	ret = spi_master_suspend(master);
+	ret = spi_controller_suspend(host);
 	if (ret)
 		return ret;
 
@@ -763,8 +763,8 @@ static int __maybe_unused synquacer_spi_
 
 static int __maybe_unused synquacer_spi_resume(struct device *dev)
 {
-	struct spi_master *master = dev_get_drvdata(dev);
-	struct synquacer_spi *sspi = spi_master_get_devdata(master);
+	struct spi_controller *host = dev_get_drvdata(dev);
+	struct synquacer_spi *sspi = spi_controller_get_devdata(host);
 	int ret;
 
 	if (!pm_runtime_suspended(dev)) {
@@ -778,7 +778,7 @@ static int __maybe_unused synquacer_spi_
 			return ret;
 		}
 
-		ret = synquacer_spi_enable(master);
+		ret = synquacer_spi_enable(host);
 		if (ret) {
 			clk_disable_unprepare(sspi->clk);
 			dev_err(dev, "failed to enable spi (%d)\n", ret);
@@ -786,7 +786,7 @@ static int __maybe_unused synquacer_spi_
 		}
 	}
 
-	ret = spi_master_resume(master);
+	ret = spi_controller_resume(host);
 	if (ret < 0)
 		clk_disable_unprepare(sspi->clk);
 


