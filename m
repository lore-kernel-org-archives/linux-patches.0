Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059822;
	b=jMSsP97g8vAxjQoPKhCbS7Px6klBUlDPey4puVmYRkbsJA9a1q9bwQX/suw0MOaz0dTF
	 WvKHHumbHSmW9JDtCKJuaMzzDxxvxGfIrKbWwkPnfhYbwELVQv10fZMQ3F1BgEYD1tIlJ
	 2/WKnHqKZzEBK+6HhimjEsvBc1DlNLxX0NdrwaJlGxPI6MMb60HWVSptYDVsJF8ewVMEQ
	 TWTQisVruBivL7syBhxYKsDCnYE2sw8m/8ziTiG/f8vZkWRIeiJ7jMUnAvybw9+Cm9MQ7
	 bMqMmjdTqAXRnXQrvuTA91/mItlwcEdUCMlpcSKQdwRB0XTcLV9AKd3QTQZdO9uDwjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QpPsUgVDg9MR7fNQ+V411MDOboH27t0R4oAs6neZmsc=;
	b=XmOW65Surwk+/T+c16vcW/6E2Wvl+tnQvHUwYUQ1MbZbVZvxE/vcv7ht/ECLnHIRqsKV
	 laQ3wapht3d4T/HyOtLVjLALmHOW0CbIIoNXf2gMkbTrUqxJB6M1QKOKmGpPaIT2r8FuQ
	 y5luMgK+5DNmT4KeMBrHb9uogkOGRUQPfai5l87wMG6HlBJY32m9TveoOgPFJdhnIVnfA
	 BWbGxUCXdiC19f3HkBKFK5JWYEm7OIriBCC/W2e/SHO9fxGapijLNRLxYleyWtJW+p135
	 c4gq0eIE2CHtKug1I7Yjv6fWaunCcJ7DYFeKxwhAjb2NHDS4qsl4zS2zz08SmY5UXww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gp0U+S8y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC40606A320;
	Thu, 19 Nov 2026 03:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gp0U+S8y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AAF1F000C4;
	Thu, 19 Nov 2026 03:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059822;
	bh=QpPsUgVDg9MR7fNQ+V411MDOboH27t0R4oAs6neZmsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gp0U+S8ydeYEDmbqIYMqJ7dRSB9AR47q8gpa019QV7FpcOPSdsIoCZ2BPJ0pHsSbZ
	 VL2UONMxJbpaGGkzDTx/b9RddtrPbpm6yKB7c48z9pWATgdE8qbABPXCS3dx0QUUJY
	 yqtA8GCvwPlMUkeUD5/X/+Br5b9blyYecosKAF9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0938/1848] gpio: pca953x: Utilise temporary variable for struct gpio_chip
Date: Wed, 18 Nov 2026 15:49:36 +0100
Message-ID: <20261118145956.135224933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9da0a75ea7ced4731b1f2c6c67dc409e40efb95a ]

We have a temporary variable to keep pointer to struct gpio_chip.
Utilise it where it makes sense.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: a0fe26929350 ("gpio: pca953x: Handle direction register read errors in IRQ paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ef69b7a01b585..5d71e453dc1c2 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -600,9 +600,7 @@ static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
-	struct gpio_chip *gc;
-
-	gc = &chip->gpio_chip;
+	struct gpio_chip *gc = &chip->gpio_chip;
 
 	gc->direction_input  = pca953x_gpio_direction_input;
 	gc->direction_output = pca953x_gpio_direction_output;
@@ -802,6 +800,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	struct irq_chip *irq_chip = &chip->irq_chip;
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
+	struct gpio_chip *gc = &chip->gpio_chip;
 	struct gpio_irq_chip *girq;
 	int ret;
 
@@ -830,7 +829,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	 * this purpose.
 	 */
 	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
-	bitmap_and(chip->irq_stat, irq_stat, reg_direction, chip->gpio_chip.ngpio);
+	bitmap_and(chip->irq_stat, irq_stat, reg_direction, gc->ngpio);
 	mutex_init(&chip->irq_lock);
 
 	irq_chip->name = dev_name(&client->dev);
-- 
2.53.0



