Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624283;
	b=f28TB73rtWLOt0YtH+mn4jr0KuExkayxh2BGeNOAdt/8cG0R7jMcyoZeFfqzQklECV5L
	 donZ3wKIWBGeuxL6zWM4fOqLSt4imrkdLQ9nsE8A0qx/cH2I/1QPsk8ogckvVP6jE1ovb
	 12JcX3bjS0voInr0jp/hLgVI2qmoBEaK3M0TPpXiNOK5ob+hmyD542vhJfrzsIJcy0lwR
	 zgHDia36jKV2VYfBATQjSzP03iwrdjNmJMdAzkvOtV+74ADJgDg1czPbibOOvIaNFTJvo
	 7xmQXJZM2woL8qJk4a+RJtmk7Cg5EXLZ5xHV9aPRn+euyWchaQ2d3UnCEfGGIXlQf1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J9A5rS2atXL5p2aEGwu3TGGkDJYlwLNxt0BsySazGos=;
	b=hwTudxthVXKGCpI10Inujoe6pnGVZRWAPyfIQ1nzm5gylIlcB2qBwVJDTtgH4hfzvKZP
	 1Ov6Qmf/Uls3Z822jpI1h+p7a0NZJS3Wv06VjkyXi9Fr2OKIXCMctew47Sey87jl0fZxg
	 IVorOjxDdJYqWH6MzKwJIrJ7h5jRYrZ9UdIgCu+LHJREExksH10idSa3Bl9xZKRXXu0TB
	 Y288M7XOm8wcAcExdu9FsTjyMO1zi9idjMF7eiy1JKLZNjUidHd9Y/qL+aXt1jZeAar1t
	 f7izrpKWOY1dG54heXnTXF/nltVS4cfLVtB7n8B8ulbe4HsFQKh8JASXmndeNF/uwOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0QGfTMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E660606A685;
	Wed, 25 Nov 2026 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0QGfTMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAFA1F000E6;
	Wed, 25 Nov 2026 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624283;
	bh=J9A5rS2atXL5p2aEGwu3TGGkDJYlwLNxt0BsySazGos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0QGfTMMBZ7BqlNd1c2QFSshMJpwiE/wLNYHtbnLGwUo0/EELr1FzkQY6BhDv2VOK
	 kogou3h0mMhqljCRAvFqfvXrwkpZzSSGhxD1hw5jfeIytGmXihHKN0PLIooWS4RxY3
	 gcf5A1JZIZfdSJN3NwIGpzTXARk0NwRYlffnV7bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/816] gpio: mpc8xxx: use a helper variable to store the address of pdev->dev
Date: Wed, 25 Nov 2026 15:28:12 +0100
Message-ID: <20261125143852.533259100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 685ec31db409d..30f36f94ba1b8 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -300,14 +300,15 @@ static const struct of_device_id mpc8xxx_gpio_ids[] = {
 
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
 
@@ -320,32 +321,28 @@ static int mpc8xxx_probe(struct platform_device *pdev)
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
 
@@ -370,7 +367,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	 * associated input enable must be set (GPIOxGPIE[IEn]=1) to propagate
 	 * the port value to the GPIO Data Register.
 	 */
-	fwnode = dev_fwnode(&pdev->dev);
+	fwnode = dev_fwnode(dev);
 	if (of_device_is_compatible(np, "fsl,qoriq-gpio") ||
 	    of_device_is_compatible(np, "fsl,ls1028a-gpio") ||
 	    of_device_is_compatible(np, "fsl,ls1088a-gpio") ||
@@ -381,9 +378,9 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 			gc->read_reg(mpc8xxx_gc->regs + GPIO_DIR);
 	}
 
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



