Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216928;
	b=y3DdcDHyQpGdkgMvPUXqUaGIO5JYJYIv2xmsRN8Df4nJvNYnqQLpUpyMLVx/4pGR8CX0
	 u1jqr/uwvNZmHWcQL4KFvHB8Z9Bdl0V0iuyjSaWenYJCls0nUbuzefZEwyv3FVnlsQeiY
	 dfQh0TaYU+kiMu0rV6jnNGULqd1598ccLQEed+CNdKlVK4H/3xBtyrLV/e0PSR7MFSbDY
	 TcVhxhLb+vD4uaCMzxTNrO0eyb2J6JHaMGyXp0XGKsOYkRSpgSsamdLZ6WMTQfYBmxptr
	 +SvMc+C6UJIZA+RMS4Wk3Q7M8oWSqHORN3UF7yivUsM/Eo9UkRC5nBmiZvdUxGfMtBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k217L9eDwpyRgFO4VdafZOC3pZNA7BeCAng6cFhBQFE=;
	b=NE2zOuqj3GHZUnK2vkfJeoTtDaO1jFvtO6St/9lOWDeJ6UHfUJcPoUpEj6bNEfr6lQcr
	 LmbCxJjRYsyjOBLdqt++2xmuaSLhY5ysbSGnTc4RK8VxQi3BDwRIHUfX+YJDMpNFAI/DH
	 +2SVwpsmc2qOiJYlLkdM8fO3DS8KJpuFL00woSamADLdidzhbLYzLArKqiEokl9+A9fSY
	 R+IZsVEOGHrcreEIGXpYRXsnS2KkyH1b7HHzOKMwr5LS9+wIx2mH6XL1KWBNp/XvjuGi0
	 MYCxrbac0m9xPT6lMEXA41WnwYTd/jNWzCT0vEgQ0Pn051bD/WxbVoOY5udZhgUXeTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAMBW+AT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E15D606A31C;
	Wed, 28 Oct 2026 19:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAMBW+AT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2FC1F01825;
	Wed, 28 Oct 2026 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216928;
	bh=k217L9eDwpyRgFO4VdafZOC3pZNA7BeCAng6cFhBQFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAMBW+ATNfmsPNYMzLCwHTbcloCJjKf2jwiXKi08ynOvw43nZDOT6y+qlMRiGMGfk
	 RVkFnT/eoOvX/7Jbjtd4aK7L9FQKGf+IJCgvKwdqxXBdMzSVIaBDkJlylotVsZh7Mm
	 +q2Hojo4Cm4+/jwnb8LVi4FnxE3LFN5nH2WKpEGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1727/1887] gpio: mxc: use lock guards for the generic GPIO chip lock
Date: Wed, 28 Oct 2026 18:03:43 +0100
Message-ID: <20261028170538.757024150@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ba441322c7aac4735d78fc6781e497a01fb8eac7 ]

Simplify the code by using lock guards for the bgpio_lock.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250702-gpio-mmio-rework-v2-2-6b77aab684d8@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: b7719c575dec ("gpio: mxc: fix both_edges bit operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 48 ++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 83f4958ea2364..b12d693cdd305 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -7,6 +7,7 @@
 // Authors: Daniel Mack, Juergen Beisert.
 // Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
 
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -160,7 +161,6 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct mxc_gpio_port *port = gc->private;
-	unsigned long flags;
 	u32 bit, val;
 	u32 gpio_idx = d->hwirq;
 	int edge;
@@ -199,41 +199,38 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 		return -EINVAL;
 	}
 
-	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+	scoped_guard(raw_spinlock_irqsave, &port->gc.bgpio_lock) {
+		if (GPIO_EDGE_SEL >= 0) {
+			val = readl(port->base + GPIO_EDGE_SEL);
+			if (edge == GPIO_INT_BOTH_EDGES)
+				writel(val | (1 << gpio_idx),
+				       port->base + GPIO_EDGE_SEL);
+			else
+				writel(val & ~(1 << gpio_idx),
+				       port->base + GPIO_EDGE_SEL);
+		}
 
-	if (GPIO_EDGE_SEL >= 0) {
-		val = readl(port->base + GPIO_EDGE_SEL);
-		if (edge == GPIO_INT_BOTH_EDGES)
-			writel(val | (1 << gpio_idx),
-				port->base + GPIO_EDGE_SEL);
-		else
-			writel(val & ~(1 << gpio_idx),
-				port->base + GPIO_EDGE_SEL);
-	}
+		if (edge != GPIO_INT_BOTH_EDGES) {
+			reg += GPIO_ICR1 + ((gpio_idx & 0x10) >> 2); /* lower or upper register */
+			bit = gpio_idx & 0xf;
+			val = readl(reg) & ~(0x3 << (bit << 1));
+			writel(val | (edge << (bit << 1)), reg);
+		}
 
-	if (edge != GPIO_INT_BOTH_EDGES) {
-		reg += GPIO_ICR1 + ((gpio_idx & 0x10) >> 2); /* lower or upper register */
-		bit = gpio_idx & 0xf;
-		val = readl(reg) & ~(0x3 << (bit << 1));
-		writel(val | (edge << (bit << 1)), reg);
+		writel(1 << gpio_idx, port->base + GPIO_ISR);
+		port->pad_type[gpio_idx] = type;
 	}
 
-	writel(1 << gpio_idx, port->base + GPIO_ISR);
-	port->pad_type[gpio_idx] = type;
-
-	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
-
 	return port->gc.direction_input(&port->gc, gpio_idx);
 }
 
 static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 {
 	void __iomem *reg = port->base;
-	unsigned long flags;
 	u32 bit, val;
 	int edge;
 
-	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+	guard(raw_spinlock_irqsave)(&port->gc.bgpio_lock);
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
@@ -249,12 +246,9 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 	} else {
 		pr_err("mxc: invalid configuration for GPIO %d: %x\n",
 		       gpio, edge);
-		goto unlock;
+		return;
 	}
 	writel(val | (edge << (bit << 1)), reg);
-
-unlock:
-	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 }
 
 /* handle 32 interrupts in one status register */
-- 
2.53.0



