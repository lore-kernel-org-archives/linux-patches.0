Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE9637F01B;
	Sat, 17 Oct 2026 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258695; cv=none; b=t9A09cyXMGesl+5zddjJMKGsARoA/Qk9a+/08vEIOBp/fiMIFV4Wzb8zwNPu2S0PMtFOdTKlguUCjN5n2x4M5jNVkILtNvRVDMGhWx4tlCNrDbIU3EarXZa7DEkc+3BYgWyDG7Fg1PNXbYM/bMJfm5XeDnX2YysFDR+PDryewSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258695; c=relaxed/simple;
	bh=DYAuml/jiq8Hqe2NTQ/4H8axVeTt3daX1FB3Pb7jXzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1C8vEtQUwUTKasanPZq1S/Lsgt1se//MTO5JcWfjPFpoI1yISgyRaweUjcqLJthpNeTUZhU3CVBMRpX7m2ukeNx1abyqybjo96tvdIB6rb9clZw/+LSsWvJbEelplM3+PJ4YVqL+h+CXSqK6tGTZbI5TEfLk4efWrAxXZb/U/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkLVKD7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkLVKD7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD1B1F000C4;
	Sat, 17 Oct 2026 17:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258694;
	bh=WsbcQLcpfOqnu6XHyzpatPHO/Zx/0P24p2CJF7ZFv50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkLVKD7bsxNdR59MFmf6y5PBZA2N8u6gBBidai3YPy5ONp7jMPWwmIMzzpM8TF5kG
	 jH9eFNXsCMxwu2vw5r5v+Tp8LE17fzGm863051QnxjIsF9xJou+lzRB2AAdHg17vT3
	 sKURadU5cejmw93hvzFk3XAHCC6Ftl8+wxqOhx04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0967/1674] spi: mpc52xx: switch to use modern name
Date: Sat, 17 Oct 2026 17:53:59 +0200
Message-ID: <20261017160455.944610226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d6503d1192491bb9d38916b70f87e77ce93c3bb6 ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230823033003.3407403-10-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0f997fdae819 ("spi: mpc52xx: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 56 +++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 16ab333af0090..2da5e19eaade9 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -62,7 +62,7 @@ MODULE_LICENSE("GPL");
 
 /* Driver internal data */
 struct mpc52xx_spi {
-	struct spi_master *master;
+	struct spi_controller *host;
 	void __iomem *regs;
 	int irq0;	/* MODF irq */
 	int irq1;	/* SPIF irq */
@@ -152,7 +152,7 @@ mpc52xx_spi_fsmstate_idle(int irq, struct mpc52xx_spi *ms, u8 status, u8 data)
 	u8 ctrl1;
 
 	if (status && irq)
-		dev_err(&ms->master->dev, "spurious irq, status=0x%.2x\n",
+		dev_err(&ms->host->dev, "spurious irq, status=0x%.2x\n",
 			status);
 
 	/* Check if there is another transfer waiting. */
@@ -235,7 +235,7 @@ static int mpc52xx_spi_fsmstate_transfer(int irq, struct mpc52xx_spi *ms,
 		return FSM_CONTINUE;
 	} else if (status & SPI_STATUS_MODF) {
 		ms->modf_count++;
-		dev_err(&ms->master->dev, "mode fault\n");
+		dev_err(&ms->host->dev, "mode fault\n");
 		mpc52xx_spi_chipsel(ms, 0);
 		ms->message->status = -EIO;
 		if (ms->message->complete)
@@ -280,7 +280,7 @@ static int
 mpc52xx_spi_fsmstate_wait(int irq, struct mpc52xx_spi *ms, u8 status, u8 data)
 {
 	if (status && irq)
-		dev_err(&ms->master->dev, "spurious irq, status=0x%.2x\n",
+		dev_err(&ms->host->dev, "spurious irq, status=0x%.2x\n",
 			status);
 
 	if (((int)mftb()) - ms->timestamp < 0)
@@ -361,12 +361,12 @@ static void mpc52xx_spi_wq(struct work_struct *work)
 }
 
 /*
- * spi_master ops
+ * spi_controller ops
  */
 
 static int mpc52xx_spi_transfer(struct spi_device *spi, struct spi_message *m)
 {
-	struct mpc52xx_spi *ms = spi_master_get_devdata(spi->master);
+	struct mpc52xx_spi *ms = spi_controller_get_devdata(spi->controller);
 	unsigned long flags;
 
 	m->actual_length = 0;
@@ -385,7 +385,7 @@ static int mpc52xx_spi_transfer(struct spi_device *spi, struct spi_message *m)
  */
 static int mpc52xx_spi_probe(struct platform_device *op)
 {
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct mpc52xx_spi *ms;
 	struct gpio_desc *gpio_cs;
 	void __iomem *regs;
@@ -406,7 +406,7 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 	out_8(regs + SPI_PORTDATA, 0x8);	/* Deassert /SS signal */
 
 	/* Clear the status register and re-read it to check for a MODF
-	 * failure.  This driver cannot currently handle multiple masters
+	 * failure.  This driver cannot currently handle multiple hosts
 	 * on the SPI bus.  This fault will also occur if the SPI signals
 	 * are not connected to any pins (port_config setting) */
 	in_8(regs + SPI_STATUS);
@@ -419,22 +419,22 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 		goto err_init;
 	}
 
-	dev_dbg(&op->dev, "allocating spi_master struct\n");
-	master = spi_alloc_master(&op->dev, sizeof(*ms));
-	if (!master) {
+	dev_dbg(&op->dev, "allocating spi_controller struct\n");
+	host = spi_alloc_host(&op->dev, sizeof(*ms));
+	if (!host) {
 		rc = -ENOMEM;
 		goto err_alloc;
 	}
 
-	master->transfer = mpc52xx_spi_transfer;
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
-	master->bits_per_word_mask = SPI_BPW_MASK(8);
-	master->dev.of_node = op->dev.of_node;
+	host->transfer = mpc52xx_spi_transfer;
+	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
+	host->bits_per_word_mask = SPI_BPW_MASK(8);
+	host->dev.of_node = op->dev.of_node;
 
-	platform_set_drvdata(op, master);
+	platform_set_drvdata(op, host);
 
-	ms = spi_master_get_devdata(master);
-	ms->master = master;
+	ms = spi_controller_get_devdata(host);
+	ms->host = host;
 	ms->regs = regs;
 	ms->irq0 = irq_of_parse_and_map(op->dev.of_node, 0);
 	ms->irq1 = irq_of_parse_and_map(op->dev.of_node, 1);
@@ -442,7 +442,7 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 	ms->ipb_freq = mpc5xxx_get_bus_frequency(&op->dev);
 	ms->gpio_cs_count = gpiod_count(&op->dev, NULL);
 	if (ms->gpio_cs_count > 0) {
-		master->num_chipselect = ms->gpio_cs_count;
+		host->num_chipselect = ms->gpio_cs_count;
 		ms->gpio_cs = kmalloc_array(ms->gpio_cs_count,
 					    sizeof(*ms->gpio_cs),
 					    GFP_KERNEL);
@@ -489,24 +489,24 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 	if (!ms->irq0)
 		dev_info(&op->dev, "using polled mode\n");
 
-	dev_dbg(&op->dev, "registering spi_master struct\n");
-	rc = spi_register_master(master);
+	dev_dbg(&op->dev, "registering spi_controller struct\n");
+	rc = spi_register_controller(host);
 	if (rc)
 		goto err_register;
 
-	dev_info(&ms->master->dev, "registered MPC5200 SPI bus\n");
+	dev_info(&ms->host->dev, "registered MPC5200 SPI bus\n");
 
 	return rc;
 
  err_register:
-	dev_err(&ms->master->dev, "initialization failed\n");
+	dev_err(&ms->host->dev, "initialization failed\n");
  err_gpio:
 	while (i-- > 0)
 		gpiod_put(ms->gpio_cs[i]);
 
 	kfree(ms->gpio_cs);
  err_alloc_gpio:
-	spi_master_put(master);
+	spi_controller_put(host);
  err_alloc:
  err_init:
 	iounmap(regs);
@@ -515,8 +515,8 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 
 static void mpc52xx_spi_remove(struct platform_device *op)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(op));
-	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
+	struct spi_controller *host = spi_controller_get(platform_get_drvdata(op));
+	struct mpc52xx_spi *ms = spi_controller_get_devdata(host);
 	int i;
 
 	free_irq(ms->irq0, ms);
@@ -528,9 +528,9 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 		gpiod_put(ms->gpio_cs[i]);
 
 	kfree(ms->gpio_cs);
-	spi_unregister_master(master);
+	spi_unregister_controller(host);
 	iounmap(ms->regs);
-	spi_master_put(master);
+	spi_controller_put(host);
 }
 
 static const struct of_device_id mpc52xx_spi_match[] = {
-- 
2.53.0



