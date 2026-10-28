Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212266;
	b=PO9Ea4hxTPl4mWHyeW8fdhzewtKcaEGFkiXRyCNAmn0KjhOgH3w2HVhW89DLLOSP6qoV
	 OLMdaEBXWOZj/39Hfc4JetD8munePKar4bvgCCdXWaNVg/ivfdMRrLjkbkoCk030Z4MTG
	 HsSz38HQtwYRnIgg3Y0DVC68qd/Ig7V4SH7HxJZPMPqDdirffJkTsWP5DgFmV0yRIquhC
	 4jQDEEvEDZt+4e7DP+xuzpZATy0ZTys23AeLzp5gfxphdL6+2A40MgFjc/hlVWnP6y0yw
	 bP+06vXB4uQBLw+x6eaJUsv4o9T+2RI1RJc6sYAJTWoa4+PsR2DXvXi6m4TwpO0k5iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N2/5twB0unj2W920k+9rhy9q8u5TICKk0id6Y1OjkGc=;
	b=Wd2FKG4uh782oHpntKWfIFDLEpIYHAc6dt9CBQ3Fhb3kNqBBWUPD1twI/mojtc44YknM
	 EhKYrdUApUdk9VhjAqgJUf7nNJd1G1+tpd02gcsWaxVAqATKiBI90y8GsnJwjOt2JUkHH
	 aTh6d39lF7+Xwfh04dhHKam0glzokf3DrZYBhPGgoxnqCaiLmyErosbs7H82f3eYjxN+g
	 38lmNjCFk8k3XkC0cSv/cduaq0hDMJGeFPar15iKeh42vnTP+HeaTzQXJAa8vWU8bG0A2
	 4JVwUWDDOdotgyF37ynjA8Th8t2vaH3TSLrGHbpQB8t/8UKguK1rHPhF9ziwYlmxr4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wE5zLD5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F367606A31A;
	Wed, 28 Oct 2026 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wE5zLD5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EC31F01825;
	Wed, 28 Oct 2026 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212266;
	bh=N2/5twB0unj2W920k+9rhy9q8u5TICKk0id6Y1OjkGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wE5zLD5nTMF1DFM/b87pomjGZ2s3DW+40hlYgBOjC8yyQ36N3856s1jVWy4MnmQjR
	 CrOc/iExC2/EKGk+mSB+LesWgNEfwbkvijzzjKTZqA8jPj7wYf06PJDrda5WZ7c+ao
	 0f1koXO2TEc2ZUKLZPOIIigIk8SPlZnJNAUQRwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0095/1887] spi: bcm63xx: switch to use modern name
Date: Wed, 28 Oct 2026 17:36:31 +0100
Message-ID: <20261028170501.395562270@linuxfoundation.org>
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

[ Upstream commit 1a9e76190f72e4e3aaf7eb89da22876846ff9b3d ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230728093221.3312026-9-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2b62c2c134fa ("spi: bcm63xx: disable clock on resume failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 68 +++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index e57e1f75cd9f9..80a88d38ec00d 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -196,7 +196,7 @@ static const unsigned int bcm63xx_spi_freq_table[SPI_CLK_MASK][2] = {
 static void bcm63xx_spi_setup_transfer(struct spi_device *spi,
 				      struct spi_transfer *t)
 {
-	struct bcm63xx_spi *bs = spi_master_get_devdata(spi->master);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(spi->controller);
 	u8 clk_cfg, reg;
 	int i;
 
@@ -227,7 +227,7 @@ static void bcm63xx_spi_setup_transfer(struct spi_device *spi,
 static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 				unsigned int num_transfers)
 {
-	struct bcm63xx_spi *bs = spi_master_get_devdata(spi->master);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(spi->controller);
 	u16 msg_ctl;
 	u16 cmd;
 	unsigned int i, timeout = 0, prepend_len = 0, len = 0;
@@ -336,10 +336,10 @@ static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 	return 0;
 }
 
-static int bcm63xx_spi_transfer_one(struct spi_master *master,
+static int bcm63xx_spi_transfer_one(struct spi_controller *host,
 					struct spi_message *m)
 {
-	struct bcm63xx_spi *bs = spi_master_get_devdata(master);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
 	struct spi_transfer *t, *first = NULL;
 	struct spi_device *spi = m->spi;
 	int status = 0;
@@ -409,18 +409,18 @@ static int bcm63xx_spi_transfer_one(struct spi_master *master,
 	}
 exit:
 	m->status = status;
-	spi_finalize_current_message(master);
+	spi_finalize_current_message(host);
 
 	return 0;
 }
 
-/* This driver supports single master mode only. Hence
+/* This driver supports single host mode only. Hence
  * CMD_DONE is the only interrupt we care about
  */
 static irqreturn_t bcm63xx_spi_interrupt(int irq, void *dev_id)
 {
-	struct spi_master *master = (struct spi_master *)dev_id;
-	struct bcm63xx_spi *bs = spi_master_get_devdata(master);
+	struct spi_controller *host = (struct spi_controller *)dev_id;
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
 	u8 intr;
 
 	/* Read interupts and clear them immediately */
@@ -437,7 +437,7 @@ static irqreturn_t bcm63xx_spi_interrupt(int irq, void *dev_id)
 
 static size_t bcm63xx_spi_max_length(struct spi_device *spi)
 {
-	struct bcm63xx_spi *bs = spi_master_get_devdata(spi->master);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(spi->controller);
 
 	return bs->fifo_size;
 }
@@ -505,7 +505,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 	const unsigned long *bcm63xx_spireg;
 	struct device *dev = &pdev->dev;
 	int irq, bus_num;
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct clk *clk;
 	struct bcm63xx_spi *bs;
 	int ret;
@@ -551,16 +551,16 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-	master = spi_alloc_master(dev, sizeof(*bs));
-	if (!master) {
+	host = spi_alloc_host(dev, sizeof(*bs));
+	if (!host) {
 		dev_err(dev, "out of memory\n");
 		return -ENOMEM;
 	}
 
-	bs = spi_master_get_devdata(master);
+	bs = spi_controller_get_devdata(host);
 	init_completion(&bs->done);
 
-	platform_set_drvdata(pdev, master);
+	platform_set_drvdata(pdev, host);
 	bs->pdev = pdev;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -576,21 +576,21 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 	bs->fifo_size = bs->reg_offsets[SPI_MSG_DATA_SIZE];
 
 	ret = devm_request_irq(&pdev->dev, irq, bcm63xx_spi_interrupt, 0,
-							pdev->name, master);
+			       pdev->name, host);
 	if (ret) {
 		dev_err(dev, "unable to request irq\n");
 		goto out_err;
 	}
 
-	master->dev.of_node = dev->of_node;
-	master->bus_num = bus_num;
-	master->num_chipselect = num_cs;
-	master->transfer_one_message = bcm63xx_spi_transfer_one;
-	master->mode_bits = MODEBITS;
-	master->bits_per_word_mask = SPI_BPW_MASK(8);
-	master->max_transfer_size = bcm63xx_spi_max_length;
-	master->max_message_size = bcm63xx_spi_max_length;
-	master->auto_runtime_pm = true;
+	host->dev.of_node = dev->of_node;
+	host->bus_num = bus_num;
+	host->num_chipselect = num_cs;
+	host->transfer_one_message = bcm63xx_spi_transfer_one;
+	host->mode_bits = MODEBITS;
+	host->bits_per_word_mask = SPI_BPW_MASK(8);
+	host->max_transfer_size = bcm63xx_spi_max_length;
+	host->max_message_size = bcm63xx_spi_max_length;
+	host->auto_runtime_pm = true;
 	bs->msg_type_shift = bs->reg_offsets[SPI_MSG_TYPE_SHIFT];
 	bs->msg_ctl_width = bs->reg_offsets[SPI_MSG_CTL_WIDTH];
 	bs->tx_io = (u8 *)(bs->regs + bs->reg_offsets[SPI_MSG_DATA]);
@@ -614,7 +614,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 		goto out_clk_disable;
 
 	/* register and we are done */
-	ret = devm_spi_register_master(dev, master);
+	ret = devm_spi_register_controller(dev, host);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
 		goto out_clk_disable;
@@ -628,14 +628,14 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 out_clk_disable:
 	clk_disable_unprepare(clk);
 out_err:
-	spi_master_put(master);
+	spi_controller_put(host);
 	return ret;
 }
 
 static int bcm63xx_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = platform_get_drvdata(pdev);
-	struct bcm63xx_spi *bs = spi_master_get_devdata(master);
+	struct spi_controller *host = platform_get_drvdata(pdev);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
 
 	/* reset spi block */
 	bcm_spi_writeb(bs, 0, SPI_INT_MASK);
@@ -649,10 +649,10 @@ static int bcm63xx_spi_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int bcm63xx_spi_suspend(struct device *dev)
 {
-	struct spi_master *master = dev_get_drvdata(dev);
-	struct bcm63xx_spi *bs = spi_master_get_devdata(master);
+	struct spi_controller *host = dev_get_drvdata(dev);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
 
-	spi_master_suspend(master);
+	spi_controller_suspend(host);
 
 	clk_disable_unprepare(bs->clk);
 
@@ -661,15 +661,15 @@ static int bcm63xx_spi_suspend(struct device *dev)
 
 static int bcm63xx_spi_resume(struct device *dev)
 {
-	struct spi_master *master = dev_get_drvdata(dev);
-	struct bcm63xx_spi *bs = spi_master_get_devdata(master);
+	struct spi_controller *host = dev_get_drvdata(dev);
+	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
 	int ret;
 
 	ret = clk_prepare_enable(bs->clk);
 	if (ret)
 		return ret;
 
-	spi_master_resume(master);
+	spi_controller_resume(host);
 
 	return 0;
 }
-- 
2.53.0



