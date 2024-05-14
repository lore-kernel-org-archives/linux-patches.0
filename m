Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB715A4C0;
	Tue, 14 May 2024 11:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686223; cv=none; b=OeT6tHFslMoAYB+aHDDD6hFVAH8aaxeRHftLc5QPG6TFoR1HHXiGhmHTcZoLTqt7EhSE14gqKe2Su0kpBJauN66+ea+oIFrxXa7c6g7eRkfVg7VkZdeVsbrlCzPtIox4FVTGt66c1M8GWj4wlu1D3cmFK+mBwZzOrvEXv+0+WHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686223; c=relaxed/simple;
	bh=z30xbV9l9rA60hoL4PPelj04ZxJpw11s2pgCHWXWurY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FybTRxRkDXQN2envsvJXMmvTwawebJVPOvwlIO9ku6YXv9Hdcmn309NYClmqMhWwQlnAz5Tn/ECQItmcQJcLj8YB4OK4OAqoe2OMu8SOogULnFLzydm2YeyEJY9rk2ThsSRlV/JbF9gNx9HYTLKoN7xTsa2+uEYAOnH24/J6XrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFM8SFQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFM8SFQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C54C2BD10;
	Tue, 14 May 2024 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686223;
	bh=z30xbV9l9rA60hoL4PPelj04ZxJpw11s2pgCHWXWurY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFM8SFQYxfbpCmDW9aE/1XTQh/gjXh/RuSr8pZHdBU0S1FYcntFWT/0TGunNkNLQV
	 gu3KMijw6YtJzn/dFwG9QhQVvMrmJZRtT2BHjMmmKM3LA+xAlHsXjH7Vpw7kfSn+hq
	 dNcgtSc3ZPsINYpzphJLW/ke2CB3w0QGnCqhRERw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/236] spi: spi-axi-spi-engine: switch to use modern name
Date: Tue, 14 May 2024 12:16:48 +0200
Message-ID: <20240514101022.092495038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

[ Upstream commit 9d5920b37ab4a970f658a6a30b54cc6d6a7d2d3d ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230728093221.3312026-4-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0064db9ce4aa ("spi: axi-spi-engine: fix version format string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 58 ++++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index c5a3a31891642..e10c70cb87c97 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -356,8 +356,8 @@ static bool spi_engine_read_rx_fifo(struct spi_engine *spi_engine)
 
 static irqreturn_t spi_engine_irq(int irq, void *devid)
 {
-	struct spi_master *master = devid;
-	struct spi_engine *spi_engine = spi_master_get_devdata(master);
+	struct spi_controller *host = devid;
+	struct spi_engine *spi_engine = spi_controller_get_devdata(host);
 	unsigned int disable_int = 0;
 	unsigned int pending;
 
@@ -396,7 +396,7 @@ static irqreturn_t spi_engine_irq(int irq, void *devid)
 			msg->status = 0;
 			msg->actual_length = msg->frame_length;
 			spi_engine->msg = NULL;
-			spi_finalize_current_message(master);
+			spi_finalize_current_message(host);
 			disable_int |= SPI_ENGINE_INT_SYNC;
 		}
 	}
@@ -412,11 +412,11 @@ static irqreturn_t spi_engine_irq(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
-static int spi_engine_transfer_one_message(struct spi_master *master,
+static int spi_engine_transfer_one_message(struct spi_controller *host,
 	struct spi_message *msg)
 {
 	struct spi_engine_program p_dry, *p;
-	struct spi_engine *spi_engine = spi_master_get_devdata(master);
+	struct spi_engine *spi_engine = spi_controller_get_devdata(host);
 	unsigned int int_enable = 0;
 	unsigned long flags;
 	size_t size;
@@ -464,7 +464,7 @@ static int spi_engine_transfer_one_message(struct spi_master *master,
 static int spi_engine_probe(struct platform_device *pdev)
 {
 	struct spi_engine *spi_engine;
-	struct spi_master *master;
+	struct spi_controller *host;
 	unsigned int version;
 	int irq;
 	int ret;
@@ -477,29 +477,29 @@ static int spi_engine_probe(struct platform_device *pdev)
 	if (!spi_engine)
 		return -ENOMEM;
 
-	master = spi_alloc_master(&pdev->dev, 0);
-	if (!master)
+	host = spi_alloc_host(&pdev->dev, 0);
+	if (!host)
 		return -ENOMEM;
 
-	spi_master_set_devdata(master, spi_engine);
+	spi_controller_set_devdata(host, spi_engine);
 
 	spin_lock_init(&spi_engine->lock);
 
 	spi_engine->clk = devm_clk_get(&pdev->dev, "s_axi_aclk");
 	if (IS_ERR(spi_engine->clk)) {
 		ret = PTR_ERR(spi_engine->clk);
-		goto err_put_master;
+		goto err_put_host;
 	}
 
 	spi_engine->ref_clk = devm_clk_get(&pdev->dev, "spi_clk");
 	if (IS_ERR(spi_engine->ref_clk)) {
 		ret = PTR_ERR(spi_engine->ref_clk);
-		goto err_put_master;
+		goto err_put_host;
 	}
 
 	ret = clk_prepare_enable(spi_engine->clk);
 	if (ret)
-		goto err_put_master;
+		goto err_put_host;
 
 	ret = clk_prepare_enable(spi_engine->ref_clk);
 	if (ret)
@@ -525,46 +525,46 @@ static int spi_engine_probe(struct platform_device *pdev)
 	writel_relaxed(0xff, spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
 	writel_relaxed(0x00, spi_engine->base + SPI_ENGINE_REG_INT_ENABLE);
 
-	ret = request_irq(irq, spi_engine_irq, 0, pdev->name, master);
+	ret = request_irq(irq, spi_engine_irq, 0, pdev->name, host);
 	if (ret)
 		goto err_ref_clk_disable;
 
-	master->dev.of_node = pdev->dev.of_node;
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_3WIRE;
-	master->bits_per_word_mask = SPI_BPW_MASK(8);
-	master->max_speed_hz = clk_get_rate(spi_engine->ref_clk) / 2;
-	master->transfer_one_message = spi_engine_transfer_one_message;
-	master->num_chipselect = 8;
+	host->dev.of_node = pdev->dev.of_node;
+	host->mode_bits = SPI_CPOL | SPI_CPHA | SPI_3WIRE;
+	host->bits_per_word_mask = SPI_BPW_MASK(8);
+	host->max_speed_hz = clk_get_rate(spi_engine->ref_clk) / 2;
+	host->transfer_one_message = spi_engine_transfer_one_message;
+	host->num_chipselect = 8;
 
-	ret = spi_register_master(master);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto err_free_irq;
 
-	platform_set_drvdata(pdev, master);
+	platform_set_drvdata(pdev, host);
 
 	return 0;
 err_free_irq:
-	free_irq(irq, master);
+	free_irq(irq, host);
 err_ref_clk_disable:
 	clk_disable_unprepare(spi_engine->ref_clk);
 err_clk_disable:
 	clk_disable_unprepare(spi_engine->clk);
-err_put_master:
-	spi_master_put(master);
+err_put_host:
+	spi_controller_put(host);
 	return ret;
 }
 
 static void spi_engine_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
-	struct spi_engine *spi_engine = spi_master_get_devdata(master);
+	struct spi_controller *host = spi_controller_get(platform_get_drvdata(pdev));
+	struct spi_engine *spi_engine = spi_controller_get_devdata(host);
 	int irq = platform_get_irq(pdev, 0);
 
-	spi_unregister_master(master);
+	spi_unregister_controller(host);
 
-	free_irq(irq, master);
+	free_irq(irq, host);
 
-	spi_master_put(master);
+	spi_controller_put(host);
 
 	writel_relaxed(0xff, spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
 	writel_relaxed(0x00, spi_engine->base + SPI_ENGINE_REG_INT_ENABLE);
-- 
2.43.0



