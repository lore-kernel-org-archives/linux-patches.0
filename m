Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215009;
	b=qF0RybdHHVMsq3tTAwfA8p2IJ4X22So2+xWAx2ze77XrL6/FY/ww0YcFZot/XSXwmI8k
	 SCc3HzuupXddW4STr7DcBdn6tjpgnV5SoezTdIfZwIMuzQLpiewzdaQNh9FVnnno7F3S1
	 SNxE5E20ZjKA28eyEc3ksh+pZ/MtAdYMPpfMa6YgeHg9NFt2p4vtsvIzTCs+zno5vbgv9
	 F3lAU1+WMIINb3s/XLO69+fnMEwHlQ7TmT3yvfWN2WdVNSsK4KtL2uEU5rDlDa0yLo6Rc
	 DrtJvGJkeviK2kM8ciy6CLxJOxMUnLd6VAwdCFD8eE3l/CSn/pPGjljxAVV9tA8oWBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wm43cq+BKmcRlxy7FYSzC9itVwfnBTgbGOyTvVeyISA=;
	b=NDJ4c4ulcHgT7juBDo5y+6FGLGw7QHhosq8+RDhVD/6lHk5jqrZI9n/NcYegXL3oHjbs
	 67ukDzTTsiSOVgp6vIGrww5cSTXLuruqruNDGoj6UBmmSRC82RsebhwvkzbBZd00IiB6D
	 QGIJEPffjb8J4HOjO68eql4dzcB1wKB49zlJCoqKCP7+7cqdKpMraKFVrZbD4Dv3JGFby
	 tDH0VmLmcjif6MfyK/Ln/0ilGOwfnpNu1UUj0+rDI9otjK8ngPNcoF3AI/C8LJhYYJnbF
	 aie6WYsl0XvwYk27RuE+TwZ9aG4ILGWV/oTes2HWhodPZlISpiZ2H82XEs/FBfg4UIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJlbDHcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B08606A31A;
	Wed, 28 Oct 2026 19:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJlbDHcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4201F01825;
	Wed, 28 Oct 2026 19:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215009;
	bh=wm43cq+BKmcRlxy7FYSzC9itVwfnBTgbGOyTvVeyISA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJlbDHccQDb+Jd3OK7vOVpXrr7cS+RVevWK6cLH3i1nN9CNppZRUu2P5bnYCofofg
	 /MBl4Eut08SJuZOYFQH56aThYyvOKSFtCX/decWQ7NmQouGON8aG4yBgKaZlICtaDt
	 y1ocxJRWryFYnTE+N3M0t5OXOJKMowt4xuKNybvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1060/1887] spi: fsl-spi: switch to use modern name
Date: Wed, 28 Oct 2026 17:52:36 +0100
Message-ID: <20261028170523.527638633@linuxfoundation.org>
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

[ Upstream commit d32382ca5614614df0cbb91a1b7fab9c47bfef9b ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230807124105.3429709-11-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9b7abfed4c37 ("spi: fsl: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 76 +++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 6775f13e121d7..c63e20ae956da 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -88,7 +88,7 @@ static int fsl_spi_get_type(struct device *dev)
 
 static void fsl_spi_change_mode(struct spi_device *spi)
 {
-	struct mpc8xxx_spi *mspi = spi_master_get_devdata(spi->master);
+	struct mpc8xxx_spi *mspi = spi_controller_get_devdata(spi->controller);
 	struct spi_mpc8xxx_cs *cs = spi->controller_state;
 	struct fsl_spi_reg __iomem *reg_base = mspi->reg_base;
 	__be32 __iomem *mode = &reg_base->mode;
@@ -186,7 +186,7 @@ static int fsl_spi_setup_transfer(struct spi_device *spi,
 	u32 hz = 0;
 	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
 
-	mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	mpc8xxx_spi = spi_controller_get_devdata(spi->controller);
 
 	if (t) {
 		bits_per_word = t->bits_per_word;
@@ -260,7 +260,7 @@ static int fsl_spi_cpu_bufs(struct mpc8xxx_spi *mspi,
 static int fsl_spi_bufs(struct spi_device *spi, struct spi_transfer *t,
 			    bool is_dma_mapped)
 {
-	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(spi->controller);
 	struct fsl_spi_reg __iomem *reg_base;
 	unsigned int len = t->len;
 	u8 bits_per_word;
@@ -401,7 +401,7 @@ static int fsl_spi_setup(struct spi_device *spi)
 		spi_set_ctldata(spi, cs);
 		initial_setup = true;
 	}
-	mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	mpc8xxx_spi = spi_controller_get_devdata(spi->controller);
 
 	reg_base = mpc8xxx_spi->reg_base;
 
@@ -495,7 +495,7 @@ static irqreturn_t fsl_spi_irq(s32 irq, void *context_data)
 
 static void fsl_spi_grlib_cs_control(struct spi_device *spi, bool on)
 {
-	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(spi->controller);
 	struct fsl_spi_reg __iomem *reg_base = mpc8xxx_spi->reg_base;
 	u32 slvsel;
 	u16 cs = spi->chip_select;
@@ -509,8 +509,8 @@ static void fsl_spi_grlib_cs_control(struct spi_device *spi, bool on)
 
 static void fsl_spi_grlib_probe(struct device *dev)
 {
-	struct spi_master *master = dev_get_drvdata(dev);
-	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
+	struct spi_controller *host = dev_get_drvdata(dev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 	struct fsl_spi_reg __iomem *reg_base = mpc8xxx_spi->reg_base;
 	int mbits;
 	u32 capabilities;
@@ -527,8 +527,8 @@ static void fsl_spi_grlib_probe(struct device *dev)
 		mpc8xxx_spi->native_chipselects = SPCAP_SSSZ(capabilities);
 		mpc8xxx_spi_write_reg(&reg_base->slvsel, 0xffffffff);
 	}
-	master->num_chipselect = mpc8xxx_spi->native_chipselects;
-	master->set_cs = fsl_spi_grlib_cs_control;
+	host->num_chipselect = mpc8xxx_spi->native_chipselects;
+	host->set_cs = fsl_spi_grlib_cs_control;
 }
 
 static void fsl_spi_cs_control(struct spi_device *spi, bool on)
@@ -542,35 +542,35 @@ static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 	iowrite32be(on ? 0 : SPI_BOOT_SEL_BIT, pinfo->immr_spi_cs);
 }
 
-static struct spi_master *fsl_spi_probe(struct device *dev,
+static struct spi_controller *fsl_spi_probe(struct device *dev,
 		struct resource *mem, unsigned int irq)
 {
 	struct fsl_spi_platform_data *pdata = dev_get_platdata(dev);
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct mpc8xxx_spi *mpc8xxx_spi;
 	struct fsl_spi_reg __iomem *reg_base;
 	u32 regval;
 	int ret = 0;
 
-	master = spi_alloc_master(dev, sizeof(struct mpc8xxx_spi));
-	if (master == NULL) {
+	host = spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
+	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	dev_set_drvdata(dev, master);
+	dev_set_drvdata(dev, host);
 
 	mpc8xxx_spi_probe(dev, mem, irq);
 
-	master->setup = fsl_spi_setup;
-	master->cleanup = fsl_spi_cleanup;
-	master->prepare_message = fsl_spi_prepare_message;
-	master->transfer_one = fsl_spi_transfer_one;
-	master->unprepare_message = fsl_spi_unprepare_message;
-	master->use_gpio_descriptors = true;
-	master->set_cs = fsl_spi_cs_control;
+	host->setup = fsl_spi_setup;
+	host->cleanup = fsl_spi_cleanup;
+	host->prepare_message = fsl_spi_prepare_message;
+	host->transfer_one = fsl_spi_transfer_one;
+	host->unprepare_message = fsl_spi_unprepare_message;
+	host->use_gpio_descriptors = true;
+	host->set_cs = fsl_spi_cs_control;
 
-	mpc8xxx_spi = spi_master_get_devdata(master);
+	mpc8xxx_spi = spi_controller_get_devdata(host);
 	mpc8xxx_spi->max_bits_per_word = 32;
 	mpc8xxx_spi->type = fsl_spi_get_type(dev);
 
@@ -588,13 +588,13 @@ static struct spi_master *fsl_spi_probe(struct device *dev,
 		fsl_spi_grlib_probe(dev);
 
 	if (mpc8xxx_spi->flags & SPI_CPM_MODE)
-		master->bits_per_word_mask =
+		host->bits_per_word_mask =
 			(SPI_BPW_RANGE_MASK(4, 8) | SPI_BPW_MASK(16) | SPI_BPW_MASK(32));
 	else
-		master->bits_per_word_mask =
+		host->bits_per_word_mask =
 			(SPI_BPW_RANGE_MASK(4, 16) | SPI_BPW_MASK(32));
 
-	master->bits_per_word_mask &=
+	host->bits_per_word_mask &=
 		SPI_BPW_RANGE_MASK(1, mpc8xxx_spi->max_bits_per_word);
 
 	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE)
@@ -631,19 +631,19 @@ static struct spi_master *fsl_spi_probe(struct device *dev,
 
 	mpc8xxx_spi_write_reg(&reg_base->mode, regval);
 
-	ret = devm_spi_register_master(dev, master);
+	ret = devm_spi_register_controller(dev, host);
 	if (ret < 0)
 		goto err_probe;
 
 	dev_info(dev, "at 0x%p (irq = %d), %s mode\n", reg_base,
 		 mpc8xxx_spi->irq, mpc8xxx_spi_strmode(mpc8xxx_spi->flags));
 
-	return master;
+	return host;
 
 err_probe:
 	fsl_spi_cpm_free(mpc8xxx_spi);
 err_cpm_init:
-	spi_master_put(master);
+	spi_controller_put(host);
 err:
 	return ERR_PTR(ret);
 }
@@ -652,7 +652,7 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
-	struct spi_master *master;
+	struct spi_controller *host;
 	struct resource mem;
 	int irq, type;
 	int ret;
@@ -705,9 +705,9 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 		goto unmap_out;
 	}
 
-	master = fsl_spi_probe(dev, &mem, irq);
+	host = fsl_spi_probe(dev, &mem, irq);
 
-	return PTR_ERR_OR_ZERO(master);
+	return PTR_ERR_OR_ZERO(host);
 
 unmap_out:
 #if IS_ENABLED(CONFIG_FSL_SOC)
@@ -719,8 +719,8 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 
 static void of_fsl_spi_remove(struct platform_device *ofdev)
 {
-	struct spi_master *master = platform_get_drvdata(ofdev);
-	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
+	struct spi_controller *host = platform_get_drvdata(ofdev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
 }
@@ -746,7 +746,7 @@ static int plat_mpc8xxx_spi_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int irq;
-	struct spi_master *master;
+	struct spi_controller *host;
 
 	if (!dev_get_platdata(&pdev->dev))
 		return -EINVAL;
@@ -759,14 +759,14 @@ static int plat_mpc8xxx_spi_probe(struct platform_device *pdev)
 	if (irq <= 0)
 		return -EINVAL;
 
-	master = fsl_spi_probe(&pdev->dev, mem, irq);
-	return PTR_ERR_OR_ZERO(master);
+	host = fsl_spi_probe(&pdev->dev, mem, irq);
+	return PTR_ERR_OR_ZERO(host);
 }
 
 static void plat_mpc8xxx_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = platform_get_drvdata(pdev);
-	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
+	struct spi_controller *host = platform_get_drvdata(pdev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
 }
-- 
2.53.0



