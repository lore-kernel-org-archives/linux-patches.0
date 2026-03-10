Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DCE3876D0;
	Tue, 10 Mar 2026 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142120; cv=none; b=t0KkbaF/AtB45P6v9T5yq/UVK1Izdvlxi1wIv4B2QRJD5exdbC2Fnn5tYmeKvbA3yl2OkXaOzBhelP2IdMNFpz0x3BR2aDaRj/ikCpDwTbsq6ve66Eiazu/r+AZUgQaykgrkxrayceVSLmDkHLXfm9uGJwpS0RPkVTBrOXk6UFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142120; c=relaxed/simple;
	bh=GwlRp6wpc5xvGDsv14OXVgROznCR5FRMP9G2lpwq/U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiBHK81zHgQhCPVZCGWj3+xfZOauWImSFo6Wv0VlsUb2RfM2kgDbYLiYMBG6ZLmCaITtBYInCDzYUqzTA1GvqNmxbZSjwzf5dRlrwfObBebeMLq/rJD6Rix3PsNtC2BkEA3BFkrpQfKAR/lxksuQWD74Hai/NQMWBn+tfcXarRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ux4NE8+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ux4NE8+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51049C19423;
	Tue, 10 Mar 2026 11:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142119;
	bh=GwlRp6wpc5xvGDsv14OXVgROznCR5FRMP9G2lpwq/U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ux4NE8+xtzMVfR3w+P9l7qDyzuJjnQWIMY2g/tvGPChxhwhZCDf9Y4lJyl+5osO2G
	 xR9FhugS9GtvI11x7Zpi6egJN3YTkq3paDsCiznaUjKwCb+SDShw8F+HsN9SZ4eKtZ
	 YBbmet8WtTZjyo5lrvji4mYPddvFFkOy2JH8gCMb4D/5MPbCkE+vzC8JrZBh1pM+fA
	 g86hcO4waEZUerC35lKsXaWD8kY7CkBv4chv3tFLVqHSvVz/LtlgQjKMGYkqcxrGpy
	 4iSapJEAi76VBlFkm0p78swSlIcv5DiDYittB9dmGr18uFgHUL8kC4ghxuO52HeRKx
	 hsz+T8MzNB6Mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Eckert <fe@dev.tdt.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/314] pinctrl: equilibrium: rename irq_chip function callbacks
Date: Tue, 10 Mar 2026 07:17:47 -0400
Message-ID: <7cddfccf97b5bb702b2ccd52968b62bed0bb0963.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 48b55c5bf8d4f..49c8232b525a9 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -23,7 +23,7 @@
 #define PIN_NAME_LEN	10
 #define PAD_REG_OFF	0x100
 
-static void eqbr_gpio_disable_irq(struct irq_data *d)
+static void eqbr_irq_mask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -36,7 +36,7 @@ static void eqbr_gpio_disable_irq(struct irq_data *d)
 	gpiochip_disable_irq(gc, offset);
 }
 
-static void eqbr_gpio_enable_irq(struct irq_data *d)
+static void eqbr_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -50,7 +50,7 @@ static void eqbr_gpio_enable_irq(struct irq_data *d)
 	raw_spin_unlock_irqrestore(&gctrl->lock, flags);
 }
 
-static void eqbr_gpio_ack_irq(struct irq_data *d)
+static void eqbr_irq_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -62,10 +62,10 @@ static void eqbr_gpio_ack_irq(struct irq_data *d)
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
@@ -92,7 +92,7 @@ static int eqbr_irq_type_cfg(struct gpio_irq_type *type,
 	return 0;
 }
 
-static int eqbr_gpio_set_irq_type(struct irq_data *d, unsigned int type)
+static int eqbr_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
@@ -166,11 +166,11 @@ static void eqbr_irq_handler(struct irq_desc *desc)
 
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

