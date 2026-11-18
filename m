Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029571;
	b=W4ENE0RUa8a2eZADs8KZc1QZ9Va8TA77i0y4xEJXXTkrKIxOI4B89qAKjlPCyTvtl6YN
	 9z3ylaG41lIY29oeHir3v8Wfy8LhVJKudiRYNqbDRG1MeHKfaex9hI+V1kDmKvG/qq4CM
	 SaRnhYiVRKMccKBj9YGDUUmB8F80eqmG/qyV/O/QAAoCZsGHDBFrNaMV1LcUIFBKzHY4P
	 QnzSDRWKTJRCHCsWcKTx8wMk58QDvwhM6lahNFrTTKotIkR0mLAVZFvWz4iA537JdKliE
	 tfwHtzwHIRhG6JREGOvLzkRvpBunlKGLFhneFgTSqxl2ppMKkkdjB6T1wgIXKXudU4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JgKSOBK+aJIU9KY4jU2EjZYo+/mXx6czoXmFC/9YsS0=;
	b=qUkdQYwXqXrXYGZ6XIDvzDl3KnGAyPRySB2chU9lyjdaUIdzL7s2Txs8NYhmkODS+cA9
	 6m3E3JLzKPBF2IazTN/99XSh8T1SrLBcxX5O8lHqOA35Mej6cKS/TZ1aHkHAXSsPK1i6U
	 j4byAjPmCTuB8loxxmVaPtIzCXMDCKwfjkUWM3Mk3Buroggxo6Kaf1Sb50Cgzsy0cwYJQ
	 iLHfM+w0hz4ocGKcPLrhKbIrk6qvnv3r8Z1r6SEHDqV1vEpgwLClvf/IJdRnpoWpdNqg3
	 M4ifSXGxoWTw3w88nIPIs2E8V52swUuGXh0j7UvRMfYyaL1I76lugfHTcq84H5iLYBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CpzqoL6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9E1606A31C;
	Wed, 18 Nov 2026 19:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CpzqoL6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B44B1F000C4;
	Wed, 18 Nov 2026 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029570;
	bh=JgKSOBK+aJIU9KY4jU2EjZYo+/mXx6czoXmFC/9YsS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpzqoL6qJiNpi5XgKI/FD9Eisb1lxqRzDU2Qvi/CjCh0sfyZd+bOLW1Qpk7Oq3Ncl
	 9j1pitilLgXbIj8qgEBjsXTb/3wlTe+Gc2XCN5xnwYm+osNQ7t97H7GfO2bN+oS/dg
	 +T1QXMLMcniOzb6+opSAXfdY98U00xV9drigEkWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0397/1756] pinctrl: amd: Dont access irq_datas hwirq member directly
Date: Wed, 18 Nov 2026 15:42:04 +0100
Message-ID: <20261118150024.568746465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 7a399ce67e981f5f28afc1ff50772acd1f4e7bbf ]

There is an irqd_to_hwirq() intended to get the hwirq number. Switch
all use to it.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250821144942.2463014-1-superm1@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 44c232e80adc ("pinctrl: amd: add timeout to irq-enable readback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 40 ++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index d48b9ec6ad7c9..d2e8c78a9a0b5 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -375,14 +375,15 @@ static void amd_gpio_irq_enable(struct irq_data *d)
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
-	gpiochip_enable_irq(gc, d->hwirq);
+	gpiochip_enable_irq(gc, hwirq);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
+	pin_reg = readl(gpio_dev->base + hwirq * 4);
 	pin_reg |= BIT(INTERRUPT_ENABLE_OFF);
 	pin_reg |= BIT(INTERRUPT_MASK_OFF);
-	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
+	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 }
 
@@ -392,15 +393,16 @@ static void amd_gpio_irq_disable(struct irq_data *d)
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
+	pin_reg = readl(gpio_dev->base + hwirq * 4);
 	pin_reg &= ~BIT(INTERRUPT_ENABLE_OFF);
 	pin_reg &= ~BIT(INTERRUPT_MASK_OFF);
-	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
+	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
-	gpiochip_disable_irq(gc, d->hwirq);
+	gpiochip_disable_irq(gc, hwirq);
 }
 
 static void amd_gpio_irq_mask(struct irq_data *d)
@@ -409,11 +411,12 @@ static void amd_gpio_irq_mask(struct irq_data *d)
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
+	pin_reg = readl(gpio_dev->base + hwirq * 4);
 	pin_reg &= ~BIT(INTERRUPT_MASK_OFF);
-	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
+	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 }
 
@@ -423,11 +426,12 @@ static void amd_gpio_irq_unmask(struct irq_data *d)
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
+	pin_reg = readl(gpio_dev->base + hwirq * 4);
 	pin_reg |= BIT(INTERRUPT_MASK_OFF);
-	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
+	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 }
 
@@ -438,20 +442,21 @@ static int amd_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
 	u32 wake_mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	int err;
 
 	pm_pr_dbg("Setting wake for GPIO %lu to %s\n",
-		   d->hwirq, str_enable_disable(on));
+		   hwirq, str_enable_disable(on));
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
+	pin_reg = readl(gpio_dev->base + hwirq * 4);
 
 	if (on)
 		pin_reg |= wake_mask;
 	else
 		pin_reg &= ~wake_mask;
 
-	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
+	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
 	if (on)
@@ -487,9 +492,10 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
+	pin_reg = readl(gpio_dev->base + hwirq * 4);
 
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -555,10 +561,10 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	pin_reg_irq_en = pin_reg;
 	pin_reg_irq_en |= mask;
 	pin_reg_irq_en &= ~BIT(INTERRUPT_MASK_OFF);
-	writel(pin_reg_irq_en, gpio_dev->base + (d->hwirq)*4);
-	while ((readl(gpio_dev->base + (d->hwirq)*4) & mask) != mask)
+	writel(pin_reg_irq_en, gpio_dev->base + hwirq * 4);
+	while ((readl(gpio_dev->base + hwirq * 4) & mask) != mask)
 		continue;
-	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
+	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
 	return ret;
-- 
2.53.0



