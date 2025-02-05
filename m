Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3637113C9C4;
	Wed,  5 Feb 2025 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763573; cv=none; b=eB+zwyWmEoVkMZCdEPH/LTMq6sIPXmSfOE1KHOsBaIUsrrEtjfKi2NDWvWt6Y/t9CTLXASJf1IvCN9XwtG/P3J76uxFdv7jOCYRKgVw+MtbKbXP/71sKPYErrX+CYj6MkoIsSVB8+UBfmULMbONw3Z6FYOwOeiDCpWSusjSb8oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763573; c=relaxed/simple;
	bh=PR9M1J7d5kBvyD+62HfBZVegOeWpcFrfEzoBHbcEGRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etKJ39hObFpN6skG8tJDWZfIqP8gZ+kaQzUfAYHMmubmB9DnjAc0+zTl/i8r04zp1Y2NMzQ2g3gu7JCQLybS6VSvEuYOcieTog+50YhvFMd4aV4kq1sW7RVnbHOL10db3xoLubr34/bCkjj0f4sg/Zz5l8xohKuZP0HVNVNajZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TelXgU1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TelXgU1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D23C4CEE2;
	Wed,  5 Feb 2025 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763573;
	bh=PR9M1J7d5kBvyD+62HfBZVegOeWpcFrfEzoBHbcEGRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TelXgU1xxnzkTHfBvwFjCrDJnN+9duoTesP3YAenaxGdKsbnf8hzvOmwvkWyu91so
	 q5cWyyq9EUIpvVYlXjOkIARlZakZ92YmsvxYBbU2JtuHyMDEjBLGI+L+hA2xhsi6NK
	 kAOd7j1xoK9zxhMVRgd1dDiOPPYMnn880OtDo9+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/393] gpio: pca953x: Drop unused fields in struct pca953x_platform_data
Date: Wed,  5 Feb 2025 14:40:02 +0100
Message-ID: <20250205134423.469522813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2f4d3e293392571e02b106c8b431b638bd029276 ]

New code should solely use firmware nodes for the specifics and
not any callbacks.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 7cef813a91c4 ("gpio: pca953x: log an error when failing to get the reset GPIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c           | 37 ++++++---------------------
 include/linux/platform_data/pca953x.h | 13 ----------
 2 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ce9a94e332801..b52548822ecc3 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -211,7 +211,6 @@ struct pca953x_chip {
 
 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
-	const char *const *names;
 	unsigned long driver_data;
 	struct regulator *regulator;
 
@@ -712,7 +711,6 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 	gc->label = dev_name(&chip->client->dev);
 	gc->parent = &chip->client->dev;
 	gc->owner = THIS_MODULE;
-	gc->names = chip->names;
 }
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
@@ -1000,7 +998,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 }
 #endif
 
-static int device_pca95xx_init(struct pca953x_chip *chip, u32 invert)
+static int device_pca95xx_init(struct pca953x_chip *chip)
 {
 	DECLARE_BITMAP(val, MAX_LINE);
 	u8 regaddr;
@@ -1018,24 +1016,21 @@ static int device_pca95xx_init(struct pca953x_chip *chip, u32 invert)
 	if (ret)
 		goto out;
 
-	/* set platform specific polarity inversion */
-	if (invert)
-		bitmap_fill(val, MAX_LINE);
-	else
-		bitmap_zero(val, MAX_LINE);
+	/* clear polarity inversion */
+	bitmap_zero(val, MAX_LINE);
 
 	ret = pca953x_write_regs(chip, chip->regs->invert, val);
 out:
 	return ret;
 }
 
-static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
+static int device_pca957x_init(struct pca953x_chip *chip)
 {
 	DECLARE_BITMAP(val, MAX_LINE);
 	unsigned int i;
 	int ret;
 
-	ret = device_pca95xx_init(chip, invert);
+	ret = device_pca95xx_init(chip);
 	if (ret)
 		goto out;
 
@@ -1056,9 +1051,8 @@ static int pca953x_probe(struct i2c_client *client)
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int irq_base = 0;
+	int irq_base;
 	int ret;
-	u32 invert = 0;
 	struct regulator *reg;
 	const struct regmap_config *regmap_config;
 
@@ -1070,8 +1064,6 @@ static int pca953x_probe(struct i2c_client *client)
 	if (pdata) {
 		irq_base = pdata->irq_base;
 		chip->gpio_start = pdata->gpio_base;
-		invert = pdata->invert;
-		chip->names = pdata->names;
 	} else {
 		struct gpio_desc *reset_gpio;
 
@@ -1160,10 +1152,10 @@ static int pca953x_probe(struct i2c_client *client)
 	 */
 	if (PCA_CHIP_TYPE(chip->driver_data) == PCA957X_TYPE) {
 		chip->regs = &pca957x_regs;
-		ret = device_pca957x_init(chip, invert);
+		ret = device_pca957x_init(chip);
 	} else {
 		chip->regs = &pca953x_regs;
-		ret = device_pca95xx_init(chip, invert);
+		ret = device_pca95xx_init(chip);
 	}
 	if (ret)
 		goto err_exit;
@@ -1176,13 +1168,6 @@ static int pca953x_probe(struct i2c_client *client)
 	if (ret)
 		goto err_exit;
 
-	if (pdata && pdata->setup) {
-		ret = pdata->setup(client, chip->gpio_chip.base,
-				   chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0)
-			dev_warn(&client->dev, "setup failed, %d\n", ret);
-	}
-
 	return 0;
 
 err_exit:
@@ -1192,14 +1177,8 @@ static int pca953x_probe(struct i2c_client *client)
 
 static void pca953x_remove(struct i2c_client *client)
 {
-	struct pca953x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct pca953x_chip *chip = i2c_get_clientdata(client);
 
-	if (pdata && pdata->teardown) {
-		pdata->teardown(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
-	}
-
 	regulator_disable(chip->regulator);
 }
 
diff --git a/include/linux/platform_data/pca953x.h b/include/linux/platform_data/pca953x.h
index 96c1a14ab3657..3c3787c4d96ca 100644
--- a/include/linux/platform_data/pca953x.h
+++ b/include/linux/platform_data/pca953x.h
@@ -11,21 +11,8 @@ struct pca953x_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
 
-	/* initial polarity inversion setting */
-	u32		invert;
-
 	/* interrupt base */
 	int		irq_base;
-
-	void		*context;	/* param to setup/teardown */
-
-	int		(*setup)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
-				void *context);
-	void		(*teardown)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
-				void *context);
-	const char	*const *names;
 };
 
 #endif /* _LINUX_PCA953X_H */
-- 
2.39.5



