Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214984;
	b=2dHcdL87BCFsPIf52bkeQ24yC4ThRJHV9lr6S40lGKq9zn++NvDtPqg7elNUVXCUWa/Q
	 maik0nkD4K2TuAtc6zxpMFSrQLBTAjYe70ii9vR/9C8JRFBoYJxkRT976AF4b9MYNfp3A
	 EpSVz/kno1m9OacZJGIHPLGGYchpUdo6vZPNV7HzziZvjTkXQq2rB407D2gzJimbM5Bo8
	 ZFrI/qCNLEwuQNpykXmJ2Qr3LT0EaXVqcEN6yiAEwGuUhpEpG2JR/VwmSi71+kYmLZOUb
	 FP7Catndn3eBGLrsQEJSvUEA3Z7Ft9SYOiXDlxQuVFk3UpmQ9g3MqcOO5lqfG9hIByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RyuT0pLnDShJKrmVvt0LmOwtGrZr02BnI08QqrzCbAk=;
	b=FUdALqXM8Rc1V4JgQ93a5sgv7HBCAcNG9RC3U7n/atmCB4bHAOpg8SWsDgBjGdODcOiJ
	 QONOefOTEjEa1LbnBnX4IlhxVaFKX9WMPe5hEpXji4OBVXVb/36KOzZGX5VDtRBj1Spyy
	 B8HgO/TJ/CQw55T04kP2sj+Jdhhli7XSnVu3glv3DXKOsGNGNcKldHH3Cyy0w/S9flet0
	 yRQkaYtM0yOPtJSqjszES+gm0GuOWbKr8OY4oQxt78FpEg0rb/wj4bV0+NbQFaePsxbIW
	 DB+m1oDsJMj4BjFTSNtWdFW1lfuiOW1QnSuRp1vLrRcR/bCduKXZ76EnPKT1g0dP75Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyhEvEH4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AA7606A31C;
	Wed, 28 Oct 2026 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyhEvEH4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FC11F01825;
	Wed, 28 Oct 2026 19:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214983;
	bh=RyuT0pLnDShJKrmVvt0LmOwtGrZr02BnI08QqrzCbAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyhEvEH4LnC0vv7w6mBK0xs2TZhxqYu0J8rnYvnARBnNUV+IE29BIVuzXgcoxzzbZ
	 5yFEgGEVvqxXPY20iaL9IMe9QbyRrK1TJII6oLetvkHli77izvfd9s9eOk+KnX88ek
	 ldJ/8/whkxLFW6x1io2hLToDjPOx1lSxJqJyljL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1052/1887] spi: mpc52xx: switch to use modern name
Date: Wed, 28 Oct 2026 17:52:28 +0100
Message-ID: <20261028170523.348691024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index f49859632d663..1f329dd60c16d 100644
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



