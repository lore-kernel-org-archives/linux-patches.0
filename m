Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213881;
	b=tDXYqQb5o94pBxmJrPjpdGv5ekwClwND5oKJxsRL4U7e83v242wQdHTZtt/0olOh82QS
	 bKDykRlEQHfv2iTOz1tqbSW3v8xF+P/NekIiR1KHPL/yY94rXKBxEIC6GKQYd83TOUPp8
	 9WrzT5Whw/BlxbNidnss0WetFDY/cgNoUY3i8k0qIVa/A+OlYWvwmYzEt5+gawSuCAXr+
	 WcPTuzU6EoWJrFpvlXKJN0Uq9iYhvHbls8uheDGd8wp7TI/liBSgPSGN8GhLgq7vwYHcR
	 7nlZXvujT5xeGC3WLCEHNsqtg53n4rA50BMMEYKac1372eW4uM4RcTvAB6Pg4z16fyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cZEAx8K5MRPPnPbPy32ngLqSFz/1+K6LGN2/ItjHJ5c=;
	b=NqS+9CZ5Oxxipsn3XshZ3YYf+OgFpM9Bhyualeaua6x9FlzyQ10SozCAswGdH/SKADq8
	 gC1x5vHJJe5zrEnnjt9hBYUUJc4z+Y0iu1aL8wPobSAuLQonjGJS1fhbbYx3UqT2lqUgi
	 pYRLbIqhu6jTNsOY2/H+KGt87sv5kP5s6xUQ5iGJMxGpSN/zA3taI+rPu1iEYDZZJivi8
	 o73gtUCJpYBd7NoyWh/obBB7c9KB6k0SyHKK+3bzXJ+R+PE/VW1uC4TKapdc6877fupZk
	 InXkT4SmpAN+d/lXju2kPBPwRpc+bRhIkqreEcGreIeWVZNisiCABDtWvhHWh0f7DYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjijxnBP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13509606A31A;
	Wed, 28 Oct 2026 18:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjijxnBP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A891F01825;
	Wed, 28 Oct 2026 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213880;
	bh=cZEAx8K5MRPPnPbPy32ngLqSFz/1+K6LGN2/ItjHJ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjijxnBPoKqOGrqBEvixhdYiRNVxuxcq8zvmEJ+U8sqE+N02R+JVLf9+Eif+4J7d3
	 9FX3AX+a31aYuTtjZZa06hg5X2oNjgfRQzXG3qP/mT+ScNJFXuhyYL9VW/+lA7uPEi
	 fGNRw4/dEQs+OJhlWVs3PKcng+lBjQ1j/mgm2P/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0661/1887] spi: hisi-kunpeng: switch to use modern name
Date: Wed, 28 Oct 2026 17:45:57 +0100
Message-ID: <20261028170514.453901890@linuxfoundation.org>
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

[ Upstream commit 9f5890466e93a7392c618e50de53cdd3a0dd1fd5 ]

Change legacy name master to modern name host.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230728093221.3312026-21-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5127c42c77de ("spi: hisi-kunpeng: Add verification for the max_frequency provided by the firmware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 84 +++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 2cfc820c8adcc..d5cb4bb709748 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -162,10 +162,10 @@ static int hisi_spi_debugfs_init(struct hisi_spi *hs)
 {
 	char name[32];
 
-	struct spi_controller *master;
+	struct spi_controller *host;
 
-	master = container_of(hs->dev, struct spi_controller, dev);
-	snprintf(name, 32, "hisi_spi%d", master->bus_num);
+	host = container_of(hs->dev, struct spi_controller, dev);
+	snprintf(name, 32, "hisi_spi%d", host->bus_num);
 	hs->debugfs = debugfs_create_dir(name, NULL);
 	if (!hs->debugfs)
 		return -ENOMEM;
@@ -299,18 +299,18 @@ static void __hisi_calc_div_reg(struct hisi_chip_data *chip)
 	chip->div_post = (chip->clk_div / chip->div_pre) - 1;
 }
 
-static u32 hisi_calc_effective_speed(struct spi_controller *master,
+static u32 hisi_calc_effective_speed(struct spi_controller *host,
 			struct hisi_chip_data *chip, u32 speed_hz)
 {
 	u32 effective_speed;
 
 	/* Note clock divider doesn't support odd numbers */
-	chip->clk_div = DIV_ROUND_UP(master->max_speed_hz, speed_hz) + 1;
+	chip->clk_div = DIV_ROUND_UP(host->max_speed_hz, speed_hz) + 1;
 	chip->clk_div &= 0xfffe;
 	if (chip->clk_div > CLK_DIV_MAX)
 		chip->clk_div = CLK_DIV_MAX;
 
-	effective_speed = master->max_speed_hz / chip->clk_div;
+	effective_speed = host->max_speed_hz / chip->clk_div;
 	if (chip->speed_hz != effective_speed) {
 		__hisi_calc_div_reg(chip);
 		chip->speed_hz = effective_speed;
@@ -344,20 +344,20 @@ static void hisi_spi_hw_init(struct hisi_spi *hs)
 
 static irqreturn_t hisi_spi_irq(int irq, void *dev_id)
 {
-	struct spi_controller *master = dev_id;
-	struct hisi_spi *hs = spi_controller_get_devdata(master);
+	struct spi_controller *host = dev_id;
+	struct hisi_spi *hs = spi_controller_get_devdata(host);
 	u32 irq_status = readl(hs->regs + HISI_SPI_ISR) & ISR_MASK;
 
 	if (!irq_status)
 		return IRQ_NONE;
 
-	if (!master->cur_msg)
+	if (!host->cur_msg)
 		return IRQ_HANDLED;
 
 	/* Error handling */
 	if (irq_status & ISR_RXOF) {
 		dev_err(hs->dev, "interrupt_transfer: fifo overflow\n");
-		master->cur_msg->status = -EIO;
+		host->cur_msg->status = -EIO;
 		goto finalize_transfer;
 	}
 
@@ -377,20 +377,20 @@ static irqreturn_t hisi_spi_irq(int irq, void *dev_id)
 
 finalize_transfer:
 	hisi_spi_disable(hs);
-	spi_finalize_current_transfer(master);
+	spi_finalize_current_transfer(host);
 	return IRQ_HANDLED;
 }
 
-static int hisi_spi_transfer_one(struct spi_controller *master,
+static int hisi_spi_transfer_one(struct spi_controller *host,
 		struct spi_device *spi, struct spi_transfer *transfer)
 {
-	struct hisi_spi *hs = spi_controller_get_devdata(master);
+	struct hisi_spi *hs = spi_controller_get_devdata(host);
 	struct hisi_chip_data *chip = spi_get_ctldata(spi);
 	u32 cr = chip->cr;
 
 	/* Update per transfer options for speed and bpw */
 	transfer->effective_speed_hz =
-		hisi_calc_effective_speed(master, chip, transfer->speed_hz);
+		hisi_calc_effective_speed(host, chip, transfer->speed_hz);
 	cr |= FIELD_PREP(CR_DIV_PRE_MASK, chip->div_pre);
 	cr |= FIELD_PREP(CR_DIV_POST_MASK, chip->div_post);
 	cr |= FIELD_PREP(CR_BPW_MASK, transfer->bits_per_word - 1);
@@ -417,10 +417,10 @@ static int hisi_spi_transfer_one(struct spi_controller *master,
 	return 1;
 }
 
-static void hisi_spi_handle_err(struct spi_controller *master,
+static void hisi_spi_handle_err(struct spi_controller *host,
 		struct spi_message *msg)
 {
-	struct hisi_spi *hs = spi_controller_get_devdata(master);
+	struct hisi_spi *hs = spi_controller_get_devdata(host);
 
 	hisi_spi_disable(hs);
 
@@ -460,7 +460,7 @@ static void hisi_spi_cleanup(struct spi_device *spi)
 static int hisi_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct spi_controller *master;
+	struct spi_controller *host;
 	struct hisi_spi *hs;
 	int ret, irq;
 
@@ -468,13 +468,13 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	master = devm_spi_alloc_master(dev, sizeof(*hs));
-	if (!master)
+	host = devm_spi_alloc_host(dev, sizeof(*hs));
+	if (!host)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, master);
+	platform_set_drvdata(pdev, host);
 
-	hs = spi_controller_get_devdata(master);
+	hs = spi_controller_get_devdata(host);
 	hs->dev = dev;
 	hs->irq = irq;
 
@@ -482,9 +482,9 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	if (IS_ERR(hs->regs))
 		return PTR_ERR(hs->regs);
 
-	/* Specify maximum SPI clocking speed (master only) by firmware */
+	/* Specify maximum SPI clocking speed (host only) by firmware */
 	ret = device_property_read_u32(dev, "spi-max-frequency",
-					&master->max_speed_hz);
+					&host->max_speed_hz);
 	if (ret) {
 		dev_err(dev, "failed to get max SPI clocking speed, ret=%d\n",
 			ret);
@@ -492,32 +492,32 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	}
 
 	ret = device_property_read_u16(dev, "num-cs",
-					&master->num_chipselect);
+					&host->num_chipselect);
 	if (ret)
-		master->num_chipselect = DEFAULT_NUM_CS;
-
-	master->use_gpio_descriptors = true;
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
-	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
-	master->bus_num = pdev->id;
-	master->setup = hisi_spi_setup;
-	master->cleanup = hisi_spi_cleanup;
-	master->transfer_one = hisi_spi_transfer_one;
-	master->handle_err = hisi_spi_handle_err;
-	master->dev.fwnode = dev->fwnode;
+		host->num_chipselect = DEFAULT_NUM_CS;
+
+	host->use_gpio_descriptors = true;
+	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
+	host->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
+	host->bus_num = pdev->id;
+	host->setup = hisi_spi_setup;
+	host->cleanup = hisi_spi_cleanup;
+	host->transfer_one = hisi_spi_transfer_one;
+	host->handle_err = hisi_spi_handle_err;
+	host->dev.fwnode = dev->fwnode;
 
 	hisi_spi_hw_init(hs);
 
 	ret = devm_request_irq(dev, hs->irq, hisi_spi_irq, 0, dev_name(dev),
-			master);
+			       host);
 	if (ret < 0) {
 		dev_err(dev, "failed to get IRQ=%d, ret=%d\n", hs->irq, ret);
 		return ret;
 	}
 
-	ret = spi_register_controller(master);
+	ret = spi_register_controller(host);
 	if (ret) {
-		dev_err(dev, "failed to register spi master, ret=%d\n", ret);
+		dev_err(dev, "failed to register spi host, ret=%d\n", ret);
 		return ret;
 	}
 
@@ -526,18 +526,18 @@ static int hisi_spi_probe(struct platform_device *pdev)
 
 	dev_info(dev, "hw version:0x%x max-freq:%u kHz\n",
 		readl(hs->regs + HISI_SPI_VERSION),
-		master->max_speed_hz / 1000);
+		host->max_speed_hz / 1000);
 
 	return 0;
 }
 
 static void hisi_spi_remove(struct platform_device *pdev)
 {
-	struct spi_controller *master = platform_get_drvdata(pdev);
-	struct hisi_spi *hs = spi_controller_get_devdata(master);
+	struct spi_controller *host = platform_get_drvdata(pdev);
+	struct hisi_spi *hs = spi_controller_get_devdata(host);
 
 	debugfs_remove_recursive(hs->debugfs);
-	spi_unregister_controller(master);
+	spi_unregister_controller(host);
 }
 
 static const struct acpi_device_id hisi_spi_acpi_match[] = {
-- 
2.53.0



