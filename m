Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705038;
	b=RDatXUkGc1YTKI9Tr8oRReBS9SnBe1n7Uj0INqcvyad8ba0MZUJWqpICO5gOLOjVsWoL
	 dnaDpmMreEDmXSnLkyUTlUqHIrQbava4Ky8pAwrOxgBUlc/oX94eE/8AnT/7/F520KceX
	 P8/26WgOn6iS1OJaBrYqZFaeeGD4V5MYm+vCdvNsKJq71ec1qpiffOi/hF8LReFHyrbIu
	 27y/QiGa+0NldlojxUDlWILEC6Y8ePE4Y9mhaYhHfdyE5NePP1JqZgz6U5m2rtcfurNzM
	 jc+ns7kLoPocZksbQPShWj/1FN147uItLFTM/9kyW/jkFZ+LYDXxBUSRN4H1ku/JluA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMnygYLLrWamwf/HzqLgk1R90IBnGKgaMyXSrF924h0=;
	b=ATLeL9jNE34PPdtgADZc727kmbl+FIZFCWOSj5Ycm1olNpuytQC4LSTShHOk4PjnX/An
	 8Xg/BZiImIrYrSKqoPZiwAR8JaA9Se9TmNrP6YiutH2RXGvMialdUMcVwZ27HWjy2Vryi
	 XFkiEZOJwSN8clpJwPrOBLDExCzkE3fRJXkqdZ8dk1T8LbTABVOrBG9qk3yoW7jpSPI24
	 pS8rd4ygNGc1fglkMHAh72OJD9dRYv13LpX6U8VwDmhCJJEiB/dUHkLId0RYWdET8ZJoo
	 3JA+2UpiISRj6kHeORhecNk2fWn1sO2XNVrTFHXApiwtSwZO/E4KiekY9b7a4uoai7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+TzwxGh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB9606A321;
	Thu, 26 Nov 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+TzwxGh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338841F000C4;
	Thu, 26 Nov 2026 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705037;
	bh=aMnygYLLrWamwf/HzqLgk1R90IBnGKgaMyXSrF924h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+TzwxGhw0TS90DQGl3KyoA153Zklhk5SxrEWHCNhN7GwD1X8TbIOBu+Tva7wpx1v
	 PMg1t0/gZnW/1CEgZS6wUQLOoXNqeEZlw1g+5B9wA3sJB+FajfzO+ztse6Z13r1Gcp
	 btBpDW1x4QjM4mY9KvePa63lhqioheNj1Bs2oP1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/319] gpio: mpc8xxx: use a helper variable to store the address of pdev->dev
Date: Thu, 26 Nov 2026 15:37:09 +0100
Message-ID: <20261126144008.115368585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 2707a028c9b9c54a6dff22c9dcfebf3083ea095e ]

Instead of repeatedly dereferencing pdev, just store the address of the
embedded struct device in a local variable and use it instead for
improved readability.

While at it: rearrange variable declarations.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20241009162910.33477-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 9e4b35c95fed ("gpio: mpc8xxx: Fix potential use-after-free of IRQ domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 48 +++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index de8ff2057d70f..b4701fd0ea63b 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -304,14 +304,15 @@ static const struct of_device_id mpc8xxx_gpio_ids[] = {
 
 static int mpc8xxx_probe(struct platform_device *pdev)
 {
+	const struct mpc8xxx_gpio_devtype *devtype = NULL;
 	struct device_node *np = pdev->dev.of_node;
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc;
-	struct gpio_chip	*gc;
-	const struct mpc8xxx_gpio_devtype *devtype = NULL;
+	struct device *dev = &pdev->dev;
 	struct fwnode_handle *fwnode;
+	struct gpio_chip *gc;
 	int ret;
 
-	mpc8xxx_gc = devm_kzalloc(&pdev->dev, sizeof(*mpc8xxx_gc), GFP_KERNEL);
+	mpc8xxx_gc = devm_kzalloc(dev, sizeof(*mpc8xxx_gc), GFP_KERNEL);
 	if (!mpc8xxx_gc)
 		return -ENOMEM;
 
@@ -324,32 +325,28 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 		return PTR_ERR(mpc8xxx_gc->regs);
 
 	gc = &mpc8xxx_gc->gc;
-	gc->parent = &pdev->dev;
-
-	if (device_property_read_bool(&pdev->dev, "little-endian")) {
-		ret = bgpio_init(gc, &pdev->dev, 4,
-				 mpc8xxx_gc->regs + GPIO_DAT,
-				 NULL, NULL,
-				 mpc8xxx_gc->regs + GPIO_DIR, NULL,
-				 BGPIOF_BIG_ENDIAN);
+	gc->parent = dev;
+
+	if (device_property_read_bool(dev, "little-endian")) {
+		ret = bgpio_init(gc, dev, 4, mpc8xxx_gc->regs + GPIO_DAT,
+				 NULL, NULL, mpc8xxx_gc->regs + GPIO_DIR,
+				 NULL, BGPIOF_BIG_ENDIAN);
 		if (ret)
 			return ret;
-		dev_dbg(&pdev->dev, "GPIO registers are LITTLE endian\n");
+		dev_dbg(dev, "GPIO registers are LITTLE endian\n");
 	} else {
-		ret = bgpio_init(gc, &pdev->dev, 4,
-				 mpc8xxx_gc->regs + GPIO_DAT,
-				 NULL, NULL,
-				 mpc8xxx_gc->regs + GPIO_DIR, NULL,
-				 BGPIOF_BIG_ENDIAN
+		ret = bgpio_init(gc, dev, 4, mpc8xxx_gc->regs + GPIO_DAT,
+				 NULL, NULL, mpc8xxx_gc->regs + GPIO_DIR,
+				 NULL, BGPIOF_BIG_ENDIAN
 				 | BGPIOF_BIG_ENDIAN_BYTE_ORDER);
 		if (ret)
 			return ret;
-		dev_dbg(&pdev->dev, "GPIO registers are BIG endian\n");
+		dev_dbg(dev, "GPIO registers are BIG endian\n");
 	}
 
 	mpc8xxx_gc->direction_output = gc->direction_output;
 
-	devtype = device_get_match_data(&pdev->dev);
+	devtype = device_get_match_data(dev);
 	if (!devtype)
 		devtype = &mpc8xxx_gpio_devtype_default;
 
@@ -374,16 +371,16 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	 * associated input enable must be set (GPIOxGPIE[IEn]=1) to propagate
 	 * the port value to the GPIO Data Register.
 	 */
-	fwnode = dev_fwnode(&pdev->dev);
+	fwnode = dev_fwnode(dev);
 	if (of_device_is_compatible(np, "fsl,qoriq-gpio") ||
 	    of_device_is_compatible(np, "fsl,ls1028a-gpio") ||
 	    of_device_is_compatible(np, "fsl,ls1088a-gpio") ||
 	    is_acpi_node(fwnode))
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_IBE, 0xffffffff);
 
-	ret = devm_gpiochip_add_data(&pdev->dev, gc, mpc8xxx_gc);
+	ret = devm_gpiochip_add_data(dev, gc, mpc8xxx_gc);
 	if (ret) {
-		dev_err(&pdev->dev,
+		dev_err(dev,
 			"GPIO chip registration failed with status %d\n", ret);
 		return ret;
 	}
@@ -404,18 +401,17 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	gc->write_reg(mpc8xxx_gc->regs + GPIO_IER, 0xffffffff);
 	gc->write_reg(mpc8xxx_gc->regs + GPIO_IMR, 0);
 
-	ret = devm_request_irq(&pdev->dev, mpc8xxx_gc->irqn,
+	ret = devm_request_irq(dev, mpc8xxx_gc->irqn,
 			       mpc8xxx_gpio_irq_cascade,
 			       IRQF_NO_THREAD | IRQF_SHARED, "gpio-cascade",
 			       mpc8xxx_gc);
 	if (ret) {
-		dev_err(&pdev->dev,
-			"failed to devm_request_irq(%d), ret = %d\n",
+		dev_err(dev, "failed to devm_request_irq(%d), ret = %d\n",
 			mpc8xxx_gc->irqn, ret);
 		goto err;
 	}
 
-	device_init_wakeup(&pdev->dev, true);
+	device_init_wakeup(dev, true);
 
 	return 0;
 err:
-- 
2.53.0



