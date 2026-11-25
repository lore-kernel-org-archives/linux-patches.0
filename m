Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621649;
	b=29jT6JIvYhJxLv70U+OpOGVP20NuO1V5fOsMOuwH2UC7QgXhMmELbmbPX2QcWx4YNx+i
	 0gSQvzJ2ViKgHpkqaR3F+hnpGNhriLVgURmyUktdfkcmM8R5mdFb0PGW0LsO/brEfD5y1
	 5fX8L9Dk6lHqq2ap9FQxB2DChDhOSPms4NuA7OwpTHQSBJd3ZyvEFCMP8r8//pEW50+2e
	 ntXOmLqbNfb61EZclb14TFDNJ8iMxDTv4kidL1ct3GAHelszkqYRGouw2uF6oAD82mp28
	 siqqH23Q1ps1iEuhu7T8jyFcZ+jCR4HyJLKVRBMOlx9ztoQ06pSf+NdG9TzBFgPSTOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0OU1rQBVoz+tZjFFFjYt58hguJAWpYK0RxzjZzzsVT8=;
	b=NNuc+JV2RUpApQw9WmBhdpGt189eWOHgMKn6pSJkAP+g34atCj4E8DxEUGu8JtGBw3wz
	 RDhlDFXyOx3Ypslo/+cHSePE0LJFR8rY0vscednTj2/7FVY/3tQaLj+S+Y9hq68wWOETZ
	 jBQiGv2ioXIfAhliSGCJOcbaO/M9OaKUhWSy8NdkxZOCthEplq/nA0HeObiStrehwSGor
	 94JiyMs510APc7ywpmbkcR5S2HGNaKNvlnmYJGpvt9tytjp1zADhE+Om2wD8rf4u914LL
	 XN911jgZiDujSIsnRZlEsnhN8E8E8ra19M9vQjsAZZAclJ36/x7H4yitnLSuA8ZhjlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0t+zNru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6AA606A339;
	Wed, 25 Nov 2026 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0t+zNru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152971F000C6;
	Wed, 25 Nov 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621648;
	bh=0OU1rQBVoz+tZjFFFjYt58hguJAWpYK0RxzjZzzsVT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0t+zNruz6RMXSFr0h1EUlqQfnpzns+ktVYBIlasuCsEwzKSSM/jqOzmcpEJUAjns
	 bTwOiae7EN1CRwvB8yMRxRZsTWPz2ujlKnYFmwKhQQYRqRIRWUsJgJiEZbCowQqfS4
	 JXU1Rsv1DfAIIBe/WNW5ULg4VQGAvaTAo4917+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@riscstar.com>,
	Linus Walleij <linusw@kernel.org>,
	Michael Walle <mwalle@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/990] gpio: regmap: Support sparsed fixed direction
Date: Wed, 25 Nov 2026 15:27:38 +0100
Message-ID: <20261125143828.905097040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 68d801eabda5219dcc25c9de98d3bbdb5b51b0a5 ]

On some regmapped GPIOs apparently only a sparser selection of the lines
(not all) are actually fixed direction.

Support this situation by adding an optional bitmap indicating which
GPIOs are actually fixed direction and which are not.

Link: https://lore.kernel.org/linux-gpio/20260501155421.3329862-10-elder@riscstar.com/
Tested-by: Alex Elder <elder@riscstar.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260511-regmap-gpio-sparse-fixed-dir-v3-1-1429ec453be7@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Stable-dep-of: 80415a6ff295 ("gpio: regmap: free the irqchip if adding the irq domain fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-regmap.c  | 37 +++++++++++++++++++++++++++++++++----
 include/linux/gpio/regmap.h |  7 +++++++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-regmap.c b/drivers/gpio/gpio-regmap.c
index c64805dcb9f88..4f83027ab2032 100644
--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -31,6 +31,7 @@ struct gpio_regmap {
 	unsigned int reg_clr_base;
 	unsigned int reg_dir_in_base;
 	unsigned int reg_dir_out_base;
+	unsigned long *fixed_direction_mask;
 	unsigned long *fixed_direction_output;
 
 #ifdef CONFIG_REGMAP_IRQ
@@ -128,6 +129,20 @@ static int gpio_regmap_set_with_clear(struct gpio_chip *chip,
 	return regmap_write(gpio->regmap, reg, mask);
 }
 
+static bool gpio_regmap_fixed_direction(struct gpio_regmap *gpio,
+					unsigned int offset)
+{
+	if (!gpio->fixed_direction_output)
+		return false;
+
+	/* In this case only some GPIOs are fixed as input/output */
+	if (gpio->fixed_direction_mask &&
+	    !test_bit(offset, gpio->fixed_direction_mask))
+		return false;
+
+	return true;
+}
+
 static int gpio_regmap_get_direction(struct gpio_chip *chip,
 				     unsigned int offset)
 {
@@ -135,7 +150,7 @@ static int gpio_regmap_get_direction(struct gpio_chip *chip,
 	unsigned int base, val, reg, mask;
 	int invert, ret;
 
-	if (gpio->fixed_direction_output) {
+	if (gpio_regmap_fixed_direction(gpio, offset)) {
 		if (test_bit(offset, gpio->fixed_direction_output))
 			return GPIO_LINE_DIRECTION_OUT;
 		else
@@ -292,12 +307,23 @@ struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config
 			goto err_free_gpio;
 	}
 
+	if (config->fixed_direction_mask) {
+		gpio->fixed_direction_mask = bitmap_alloc(chip->ngpio,
+							    GFP_KERNEL);
+		if (!gpio->fixed_direction_mask) {
+			ret = -ENOMEM;
+			goto err_free_gpio;
+		}
+		bitmap_copy(gpio->fixed_direction_mask,
+			    config->fixed_direction_mask, chip->ngpio);
+	}
+
 	if (config->fixed_direction_output) {
 		gpio->fixed_direction_output = bitmap_alloc(chip->ngpio,
 							    GFP_KERNEL);
 		if (!gpio->fixed_direction_output) {
 			ret = -ENOMEM;
-			goto err_free_gpio;
+			goto err_free_bitmap_dirmask;
 		}
 		bitmap_copy(gpio->fixed_direction_output,
 			    config->fixed_direction_output, chip->ngpio);
@@ -319,7 +345,7 @@ struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config
 
 	ret = gpiochip_add_data(chip, gpio);
 	if (ret < 0)
-		goto err_free_bitmap;
+		goto err_free_bitmap_output;
 
 #ifdef CONFIG_REGMAP_IRQ
 	if (config->regmap_irq_chip) {
@@ -345,8 +371,10 @@ struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config
 
 err_remove_gpiochip:
 	gpiochip_remove(chip);
-err_free_bitmap:
+err_free_bitmap_output:
 	bitmap_free(gpio->fixed_direction_output);
+err_free_bitmap_dirmask:
+	bitmap_free(gpio->fixed_direction_mask);
 err_free_gpio:
 	kfree(gpio);
 	return ERR_PTR(ret);
@@ -366,6 +394,7 @@ void gpio_regmap_unregister(struct gpio_regmap *gpio)
 
 	gpiochip_remove(&gpio->gpio_chip);
 	bitmap_free(gpio->fixed_direction_output);
+	bitmap_free(gpio->fixed_direction_mask);
 	kfree(gpio);
 }
 EXPORT_SYMBOL_GPL(gpio_regmap_unregister);
diff --git a/include/linux/gpio/regmap.h b/include/linux/gpio/regmap.h
index 87983a5f3681e..a23e1c2b933a1 100644
--- a/include/linux/gpio/regmap.h
+++ b/include/linux/gpio/regmap.h
@@ -38,6 +38,12 @@ struct regmap;
  *			offset to a register/bitmask pair. If not
  *			given the default gpio_regmap_simple_xlate()
  *			is used.
+ * @fixed_direction_mask:
+ *			(Optional) Bitmap representing the GPIO lines that
+ *			make use of the @fixed_direction_output list to
+ *			enforce direction of the GPIO. If this is NULL
+ *			and @fixed_direction_output is defined, ALL GPIOs
+ *			are assumed to be fixed direction (out or in).
  * @fixed_direction_output:
  *			(Optional) Bitmap representing the fixed direction of
  *			the GPIO lines. Useful when there are GPIO lines with a
@@ -89,6 +95,7 @@ struct gpio_regmap_config {
 	int reg_stride;
 	int ngpio_per_reg;
 	struct irq_domain *irq_domain;
+	unsigned long *fixed_direction_mask;
 	unsigned long *fixed_direction_output;
 
 #ifdef CONFIG_REGMAP_IRQ
-- 
2.53.0



