Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DD5478E53;
	Tue, 16 Jun 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632314; cv=none; b=PrqvcFlGwTmTVlk0Lt3J7IdzikwKcmqmHuLlfJjLjkgpMNpfsKrcAjjlhrAtHJC/RJcFeJlDoJzHIGgOuew+o/K5wNWGT6PzDJKw3AcAbe4Aq1EWcatfrZ/fl80tyGuhcrkQO1LzNFS0SZx0GNBRRzPUrG+zm80nLHM3tuNYvJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632314; c=relaxed/simple;
	bh=CXSEUOusNmPETEY8PVEfgXVIhHzp7uTu231O3Ojgn70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adPENYp/pRueZDEtBEEvLjNA9SLJvTjw/kKE9FabBvkq2MSDc2UkxAMc6Hiwd6KBmSUjw7FMFwo89IyDe/kWAOhX5uJPnLJMaqHacYsgZfkekpOue/PXynCEoCwKHIpzU4Zkfp4BRkjMFHCqpR4OR/BMqrOQ6705TJn5YisHxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXD9bKjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXD9bKjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0A81F00A3A;
	Tue, 16 Jun 2026 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632310;
	bh=N1aH2MkRxsMi9GnDwvnbmAC9PvfqHq44Wp5uVrOGtI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXD9bKjLOI17Zh83PmLBMVdb3RO+T6AhuKyPLzRHqsX76O0SB7LfOWSTuWasnny08
	 MrsrbSMKI5f43Ki58p9sE5pIsZIDP0bcKtibzWDZcTBXY7W31VD2cxShaCfaOS4c/T
	 sIfbsOVj9VVRCH3cZTPh2udB/zFY4jqcVAxpVvU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 387/522] spi: spi-ti-qspi: switch to use modern name
Date: Tue, 16 Jun 2026 20:28:54 +0530
Message-ID: <20260616145143.903234192@linuxfoundation.org>
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

[ Upstream commit 9d93c8d97b4cdb5edddb4c5530881c90eecb7e44 ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://msgid.link/r/20231128093031.3707034-16-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0c18a1bacbb1 ("spi: ti-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |   88 +++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -41,7 +41,7 @@ struct ti_qspi {
 	/* list synchronization */
 	struct mutex            list_lock;
 
-	struct spi_master	*master;
+	struct spi_controller	*host;
 	void __iomem            *base;
 	void __iomem            *mmap_base;
 	size_t			mmap_size;
@@ -138,20 +138,20 @@ static inline void ti_qspi_write(struct
 
 static int ti_qspi_setup(struct spi_device *spi)
 {
-	struct ti_qspi	*qspi = spi_master_get_devdata(spi->master);
+	struct ti_qspi	*qspi = spi_controller_get_devdata(spi->controller);
 	int ret;
 
-	if (spi->master->busy) {
-		dev_dbg(qspi->dev, "master busy doing other transfers\n");
+	if (spi->controller->busy) {
+		dev_dbg(qspi->dev, "host busy doing other transfers\n");
 		return -EBUSY;
 	}
 
-	if (!qspi->master->max_speed_hz) {
+	if (!qspi->host->max_speed_hz) {
 		dev_err(qspi->dev, "spi max frequency not defined\n");
 		return -EINVAL;
 	}
 
-	spi->max_speed_hz = min(spi->max_speed_hz, qspi->master->max_speed_hz);
+	spi->max_speed_hz = min(spi->max_speed_hz, qspi->host->max_speed_hz);
 
 	ret = pm_runtime_resume_and_get(qspi->dev);
 	if (ret < 0) {
@@ -527,7 +527,7 @@ static int ti_qspi_dma_xfer_sg(struct ti
 
 static void ti_qspi_enable_memory_map(struct spi_device *spi)
 {
-	struct ti_qspi  *qspi = spi_master_get_devdata(spi->master);
+	struct ti_qspi  *qspi = spi_controller_get_devdata(spi->controller);
 
 	ti_qspi_write(qspi, MM_SWITCH, QSPI_SPI_SWITCH_REG);
 	if (qspi->ctrl_base) {
@@ -541,7 +541,7 @@ static void ti_qspi_enable_memory_map(st
 
 static void ti_qspi_disable_memory_map(struct spi_device *spi)
 {
-	struct ti_qspi  *qspi = spi_master_get_devdata(spi->master);
+	struct ti_qspi  *qspi = spi_controller_get_devdata(spi->controller);
 
 	ti_qspi_write(qspi, 0, QSPI_SPI_SWITCH_REG);
 	if (qspi->ctrl_base)
@@ -555,7 +555,7 @@ static void ti_qspi_setup_mmap_read(stru
 				    u8 data_nbits, u8 addr_width,
 				    u8 dummy_bytes)
 {
-	struct ti_qspi  *qspi = spi_master_get_devdata(spi->master);
+	struct ti_qspi  *qspi = spi_controller_get_devdata(spi->controller);
 	u32 memval = opcode;
 
 	switch (data_nbits) {
@@ -577,7 +577,7 @@ static void ti_qspi_setup_mmap_read(stru
 
 static int ti_qspi_adjust_op_size(struct spi_mem *mem, struct spi_mem_op *op)
 {
-	struct ti_qspi *qspi = spi_controller_get_devdata(mem->spi->master);
+	struct ti_qspi *qspi = spi_controller_get_devdata(mem->spi->controller);
 	size_t max_len;
 
 	if (op->data.dir == SPI_MEM_DATA_IN) {
@@ -607,7 +607,7 @@ static int ti_qspi_adjust_op_size(struct
 static int ti_qspi_exec_mem_op(struct spi_mem *mem,
 			       const struct spi_mem_op *op)
 {
-	struct ti_qspi *qspi = spi_master_get_devdata(mem->spi->master);
+	struct ti_qspi *qspi = spi_controller_get_devdata(mem->spi->controller);
 	u32 from = 0;
 	int ret = 0;
 
@@ -634,10 +634,10 @@ static int ti_qspi_exec_mem_op(struct sp
 		struct sg_table sgt;
 
 		if (virt_addr_valid(op->data.buf.in) &&
-		    !spi_controller_dma_map_mem_op_data(mem->spi->master, op,
+		    !spi_controller_dma_map_mem_op_data(mem->spi->controller, op,
 							&sgt)) {
 			ret = ti_qspi_dma_xfer_sg(qspi, sgt, from);
-			spi_controller_dma_unmap_mem_op_data(mem->spi->master,
+			spi_controller_dma_unmap_mem_op_data(mem->spi->controller,
 							     op, &sgt);
 		} else {
 			ret = ti_qspi_dma_bounce_buffer(qspi, from,
@@ -659,10 +659,10 @@ static const struct spi_controller_mem_o
 	.adjust_op_size = ti_qspi_adjust_op_size,
 };
 
-static int ti_qspi_start_transfer_one(struct spi_master *master,
+static int ti_qspi_start_transfer_one(struct spi_controller *host,
 		struct spi_message *m)
 {
-	struct ti_qspi *qspi = spi_master_get_devdata(master);
+	struct ti_qspi *qspi = spi_controller_get_devdata(host);
 	struct spi_device *spi = m->spi;
 	struct spi_transfer *t;
 	int status = 0, ret;
@@ -721,7 +721,7 @@ static int ti_qspi_start_transfer_one(st
 
 	ti_qspi_write(qspi, qspi->cmd | QSPI_INVAL, QSPI_SPI_CMD_REG);
 	m->status = status;
-	spi_finalize_current_message(master);
+	spi_finalize_current_message(host);
 
 	return status;
 }
@@ -757,33 +757,33 @@ MODULE_DEVICE_TABLE(of, ti_qspi_match);
 static int ti_qspi_probe(struct platform_device *pdev)
 {
 	struct  ti_qspi *qspi;
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct resource         *r, *res_mmap;
 	struct device_node *np = pdev->dev.of_node;
 	u32 max_freq;
 	int ret = 0, num_cs, irq;
 	dma_cap_mask_t mask;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*qspi));
-	if (!master)
+	host = spi_alloc_host(&pdev->dev, sizeof(*qspi));
+	if (!host)
 		return -ENOMEM;
 
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD;
+	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD;
 
-	master->flags = SPI_CONTROLLER_HALF_DUPLEX;
-	master->setup = ti_qspi_setup;
-	master->auto_runtime_pm = true;
-	master->transfer_one_message = ti_qspi_start_transfer_one;
-	master->dev.of_node = pdev->dev.of_node;
-	master->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(16) |
-				     SPI_BPW_MASK(8);
-	master->mem_ops = &ti_qspi_mem_ops;
+	host->flags = SPI_CONTROLLER_HALF_DUPLEX;
+	host->setup = ti_qspi_setup;
+	host->auto_runtime_pm = true;
+	host->transfer_one_message = ti_qspi_start_transfer_one;
+	host->dev.of_node = pdev->dev.of_node;
+	host->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(16) |
+				   SPI_BPW_MASK(8);
+	host->mem_ops = &ti_qspi_mem_ops;
 
 	if (!of_property_read_u32(np, "num-cs", &num_cs))
-		master->num_chipselect = num_cs;
+		host->num_chipselect = num_cs;
 
-	qspi = spi_master_get_devdata(master);
-	qspi->master = master;
+	qspi = spi_controller_get_devdata(host);
+	qspi->host = host;
 	qspi->dev = &pdev->dev;
 	platform_set_drvdata(pdev, qspi);
 
@@ -793,7 +793,7 @@ static int ti_qspi_probe(struct platform
 		if (r == NULL) {
 			dev_err(&pdev->dev, "missing platform data\n");
 			ret = -ENODEV;
-			goto free_master;
+			goto free_host;
 		}
 	}
 
@@ -813,7 +813,7 @@ static int ti_qspi_probe(struct platform
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = irq;
-		goto free_master;
+		goto free_host;
 	}
 
 	mutex_init(&qspi->list_lock);
@@ -821,7 +821,7 @@ static int ti_qspi_probe(struct platform
 	qspi->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(qspi->base)) {
 		ret = PTR_ERR(qspi->base);
-		goto free_master;
+		goto free_host;
 	}
 
 
@@ -831,7 +831,7 @@ static int ti_qspi_probe(struct platform
 						"syscon-chipselects");
 		if (IS_ERR(qspi->ctrl_base)) {
 			ret = PTR_ERR(qspi->ctrl_base);
-			goto free_master;
+			goto free_host;
 		}
 		ret = of_property_read_u32_index(np,
 						 "syscon-chipselects",
@@ -839,7 +839,7 @@ static int ti_qspi_probe(struct platform
 		if (ret) {
 			dev_err(&pdev->dev,
 				"couldn't get ctrl_mod reg index\n");
-			goto free_master;
+			goto free_host;
 		}
 	}
 
@@ -854,7 +854,7 @@ static int ti_qspi_probe(struct platform
 	pm_runtime_enable(&pdev->dev);
 
 	if (!of_property_read_u32(np, "spi-max-frequency", &max_freq))
-		master->max_speed_hz = max_freq;
+		host->max_speed_hz = max_freq;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_MEMCPY, mask);
@@ -878,7 +878,7 @@ static int ti_qspi_probe(struct platform
 		qspi->rx_chan = NULL;
 		goto no_dma;
 	}
-	master->dma_rx = qspi->rx_chan;
+	host->dma_rx = qspi->rx_chan;
 	init_completion(&qspi->transfer_complete);
 	if (res_mmap)
 		qspi->mmap_phys_base = (dma_addr_t)res_mmap->start;
@@ -891,21 +891,21 @@ no_dma:
 				 "mmap failed with error %ld using PIO mode\n",
 				 PTR_ERR(qspi->mmap_base));
 			qspi->mmap_base = NULL;
-			master->mem_ops = NULL;
+			host->mem_ops = NULL;
 		}
 	}
 	qspi->mmap_enabled = false;
 	qspi->current_cs = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = devm_spi_register_controller(&pdev->dev, host);
 	if (!ret)
 		return 0;
 
 	ti_qspi_dma_cleanup(qspi);
 
 	pm_runtime_disable(&pdev->dev);
-free_master:
-	spi_master_put(master);
+free_host:
+	spi_controller_put(host);
 	return ret;
 }
 
@@ -914,9 +914,9 @@ static void ti_qspi_remove(struct platfo
 	struct ti_qspi *qspi = platform_get_drvdata(pdev);
 	int rc;
 
-	rc = spi_master_suspend(qspi->master);
+	rc = spi_controller_suspend(qspi->host);
 	if (rc) {
-		dev_alert(&pdev->dev, "spi_master_suspend() failed (%pe)\n",
+		dev_alert(&pdev->dev, "spi_controller_suspend() failed (%pe)\n",
 			  ERR_PTR(rc));
 		return;
 	}


