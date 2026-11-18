Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054113;
	b=1nGIt4PaDy6Ryn3RP9QVdOdNRLsdwUH3qYziO4Oc+C+XbJk7VxO7ElHTUHHsm5+kPkE/
	 ZPzHG95y4+edriWqYlDhsFsJ7aozzpMKHnOE7J0ARagqWvcFDyOYQpPvJeUE0YuZoVWmM
	 72d94b75hI7/uoF2ESminbDcT9Nr77jWUsw6EneONvvZozJMX2RH4ZK2RSbhuLEB2CvB1
	 pKeHLUqYF8T9q8ykg8H1kmQJuvTcaHwPLGCbutkOTyy+15idgxcKpvwlAN9U1VPEDk7QQ
	 3xItCGmkv64QuQZ930vaP3t3814QI7rU6SVJNkhXWAPH68bOp9DAn/iPVmlashu7paw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=izJpGj3Lf3N4ETq8UArviyP5Wwv4bVVS+iseFV9s708=;
	b=unLZT7qgtWQDpiSeLUcM3VSr+d3sJUumMlR32aj+hwGb8ZiebCRHlWZWXWwYQDDjj7Wt
	 4P6GKEQfjdyehdeyJ1vf2Xms/3c6s6CSs4v2T8oMBsh3GTmkWbsUdP1BVwadjqllEKEHC
	 6/44Yvdh+vaYM8rcpc7BYtkNfD40CS4xcTTz63iQVWjmN+lzfFfffVLAGLwfQC0Lhg7PX
	 NwN1M8O8Wy270mxMGRogjl7Tw04HLKMa1TBxoPRA8g6r1GBBK6qJzzEOOg54KkiVa92cg
	 Az6qRHOYX2YYJRZKuvq5MHW8zwnSlOZWWr7e6t20Q5u4G+A7QqkAZvu2isRI2XvLi8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lWthA4/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F53606A31C;
	Thu, 19 Nov 2026 02:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWthA4/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D97E1F000C4;
	Thu, 19 Nov 2026 02:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054113;
	bh=izJpGj3Lf3N4ETq8UArviyP5Wwv4bVVS+iseFV9s708=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWthA4/vJD0ctGtyVwNHhRHCnsaQMI7k2urj8l4kg2zcdHy8XYEn9HDVpKxaokLuU
	 0yPiLT3IyXlVRBHqE2WXRHnuuIx9C6KsMhHEvRfJ1CTeM4b/dKtklCaCLSbvoAQMWK
	 97NnR32hMRfWG7uXE93o2oM8kH8Nj5I3eRgSgO88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1116/2214] gpio: pca953x: Utilise temporary variable for struct gpio_chip
Date: Wed, 18 Nov 2026 15:46:32 +0100
Message-ID: <20261118150056.766036782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 95a09a8daa687..d6ee35492721d 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -601,9 +601,7 @@ static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
 
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
-	struct gpio_chip *gc;
-
-	gc = &chip->gpio_chip;
+	struct gpio_chip *gc = &chip->gpio_chip;
 
 	gc->direction_input  = pca953x_gpio_direction_input;
 	gc->direction_output = pca953x_gpio_direction_output;
@@ -803,6 +801,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	struct irq_chip *irq_chip = &chip->irq_chip;
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
+	struct gpio_chip *gc = &chip->gpio_chip;
 	struct gpio_irq_chip *girq;
 	int ret;
 
@@ -831,7 +830,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	 * this purpose.
 	 */
 	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
-	bitmap_and(chip->irq_stat, irq_stat, reg_direction, chip->gpio_chip.ngpio);
+	bitmap_and(chip->irq_stat, irq_stat, reg_direction, gc->ngpio);
 	mutex_init(&chip->irq_lock);
 
 	irq_chip->name = dev_name(&client->dev);
-- 
2.53.0



