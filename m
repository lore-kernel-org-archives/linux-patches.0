Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7DE369215;
	Thu, 12 Mar 2026 20:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346972; cv=none; b=p4w3vnrxswMKwWD3Ks9FMLlcYbUh57O6TZN7CkNAWsNpzz4ki1mb9HGWa2FGq3KdJOxgG3xbydNtR3/OD7pXKdQgTly8Ivi7v3n5DZ1EVHpMO1mBfnV/FxUDh72/sUPikUipZvZQUllEYYfpE5Ex1v+0FeqFTb9aRmN+zWGLYzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346972; c=relaxed/simple;
	bh=JqPn2xnMbM9iueFMUdBsN4PZjrydkP/BgP9b1DF71x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msDjJDW/VTR5C7gyvmJBcXKI2FpYqIQ+C6UEYcSKpCi8BrS5twZxpAZ6MAhCiFuAUP1ivE7SilcLfEIoBr0cQAVwjGXv5gZuiKDcPCeoMiNagg+82ussHNGb0xYw3QQsj9yoYGiHSsCvCa7ypDP0KWZ9CyYvCO/OmKII+LZLF5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnopqyA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnopqyA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83350C4CEF7;
	Thu, 12 Mar 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346971;
	bh=JqPn2xnMbM9iueFMUdBsN4PZjrydkP/BgP9b1DF71x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnopqyA7jx8REd23eBDorCWe3IfeEEp378MZ3bLVXERiI3VRZDwHPpHF57GKB6NkD
	 WU4j0ee9YLlqVkHh3aWAitCBfvTqXVxnc0x6i6l8e34mrH2iYUX5YQX9m180Pk3ndq
	 BQisnnzFY5Y1UeYufStlWOjXynuusFd3Xp6rXzD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/265] pinctrl: equilibrium: rename irq_chip function callbacks
Date: Thu, 12 Mar 2026 21:09:18 +0100
Message-ID: <20260312201024.457073253@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit 1f96b84835eafb3e6f366dc3a66c0e69504cec9d ]

Renaming of the irq_chip callback functions to improve clarity.

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Stable-dep-of: 3e00b1b332e5 ("pinctrl: equilibrium: fix warning trace on load")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-equilibrium.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index c82491da2cc9f..e8b2efc7b41a0 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -22,7 +22,7 @@
 #define PIN_NAME_LEN	10
 #define PAD_REG_OFF	0x100
 
-static void eqbr_gpio_disable_irq(struct irq_data *d)
+static void eqbr_irq_mask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -35,7 +35,7 @@ static void eqbr_gpio_disable_irq(struct irq_data *d)
 	gpiochip_disable_irq(gc, offset);
 }
 
-static void eqbr_gpio_enable_irq(struct irq_data *d)
+static void eqbr_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -49,7 +49,7 @@ static void eqbr_gpio_enable_irq(struct irq_data *d)
 	raw_spin_unlock_irqrestore(&gctrl->lock, flags);
 }
 
-static void eqbr_gpio_ack_irq(struct irq_data *d)
+static void eqbr_irq_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -61,10 +61,10 @@ static void eqbr_gpio_ack_irq(struct irq_data *d)
 	raw_spin_unlock_irqrestore(&gctrl->lock, flags);
 }
 
-static void eqbr_gpio_mask_ack_irq(struct irq_data *d)
+static void eqbr_irq_mask_ack(struct irq_data *d)
 {
-	eqbr_gpio_disable_irq(d);
-	eqbr_gpio_ack_irq(d);
+	eqbr_irq_mask(d);
+	eqbr_irq_ack(d);
 }
 
 static inline void eqbr_cfg_bit(void __iomem *addr,
@@ -91,7 +91,7 @@ static int eqbr_irq_type_cfg(struct gpio_irq_type *type,
 	return 0;
 }
 
-static int eqbr_gpio_set_irq_type(struct irq_data *d, unsigned int type)
+static int eqbr_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -165,11 +165,11 @@ static void eqbr_irq_handler(struct irq_desc *desc)
 
 static const struct irq_chip eqbr_irq_chip = {
 	.name = "gpio_irq",
-	.irq_mask = eqbr_gpio_disable_irq,
-	.irq_unmask = eqbr_gpio_enable_irq,
-	.irq_ack = eqbr_gpio_ack_irq,
-	.irq_mask_ack = eqbr_gpio_mask_ack_irq,
-	.irq_set_type = eqbr_gpio_set_irq_type,
+	.irq_ack = eqbr_irq_ack,
+	.irq_mask = eqbr_irq_mask,
+	.irq_mask_ack = eqbr_irq_mask_ack,
+	.irq_unmask = eqbr_irq_unmask,
+	.irq_set_type = eqbr_irq_set_type,
 	.flags = IRQCHIP_IMMUTABLE,
 	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
-- 
2.51.0



