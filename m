Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038549;
	b=W+dK8PZ7IpefxP/irZdC13QLe87eoonrj9/jGvoZPqbLkp3oVK2j2QcIFDZO/r/zceun
	 uceXHzvpz5fjNi0BQRNzhfRsVq4dchr+FlJMEP9S8QSw7+7ANzgvLtffd4M+RmtVG6IsJ
	 KC9Hk+zgLg68Lo7B1ILMOmQk4PTuw0Ho7Na6HjGf3moJwDnmGfJcd37eeEgs46xq7dUR4
	 5JQ1Xj0yl3l1sFexIlm/l8HoFTHBGRneDHjvoeaIY7WXNrmxcH81jqEGf9Ac7O2mUhUc2
	 I7fdDOF1LtqGAj7Gs1iJ/hfHMB3zX5hu3pinwqRYIFQwuU0zjJxbToOUNjghpuObCTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jk1ff8RuDbQ8GTbd4YMpeIe3Lsga8GJ4CMyGvowRzto=;
	b=C6xmychaoNzPoGVNndICP36XoWv4YGXe4E45IDdYgENNFapcpLj7IFq7v69B84EJ5nbZ
	 jVQpf9CmPS7XSP3y2d0WOUNqHPs1or3EaG2TdJ0JgPL5v3tbj6caMUUHvKVSWqvW8qAmx
	 6J30w/FBuuyR9/V1lsfMAH62VLU7NjBCf1vu8L8dldtHQ6/xMY395e2QuA9nNnICYDghR
	 tvxDO0ks6Mfo8KxwA48c6yGo8/JqkFTCaT/ZnPG9LjswqpWX6QcKl7RT2UspBCKyKGlgq
	 KeT0Yl8N9sooSvLyC1P92usFqiJf17HCD9UEJ8iZdXzGgOmR55bQlmswJE+rMsoHgLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOJTGrpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33743606A325;
	Wed, 18 Nov 2026 21:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOJTGrpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6761F000C4;
	Wed, 18 Nov 2026 21:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038548;
	bh=Jk1ff8RuDbQ8GTbd4YMpeIe3Lsga8GJ4CMyGvowRzto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOJTGrpimlsK9FxinQGdDRJRSsF/ZwW03zLM9uQu6DDUfF6fGQ8HOn4tDuIwaWHIZ
	 yoOJ1elbQ52/tkbj1sI+1pmmIKjDrMBRxYa8tXd/rgsWzjkOQq4Do95WPB+ykJcD4l
	 L2VaDRZA1AqDXrUUuVF3bkI8qEPnBe/vKQFHfjFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1780/3318] gpio: pca953x: Utilise temporary variable for struct gpio_chip
Date: Wed, 18 Nov 2026 15:40:02 +0100
Message-ID: <20261118150415.260407313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e13fac2132745..6384c0760e0ee 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -690,9 +690,7 @@ static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
-	struct gpio_chip *gc;
-
-	gc = &chip->gpio_chip;
+	struct gpio_chip *gc = &chip->gpio_chip;
 
 	gc->direction_input  = pca953x_gpio_direction_input;
 	gc->direction_output = pca953x_gpio_direction_output;
@@ -958,6 +956,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	struct device *dev = &client->dev;
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
+	struct gpio_chip *gc = &chip->gpio_chip;
 	struct gpio_irq_chip *girq;
 	int ret;
 
@@ -986,7 +985,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	 * this purpose.
 	 */
 	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
-	bitmap_and(chip->irq_stat, irq_stat, reg_direction, chip->gpio_chip.ngpio);
+	bitmap_and(chip->irq_stat, irq_stat, reg_direction, gc->ngpio);
 	mutex_init(&chip->irq_lock);
 
 	girq = &chip->gpio_chip.irq;
-- 
2.53.0



