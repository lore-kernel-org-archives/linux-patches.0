Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F938735E;
	Tue, 10 Mar 2026 11:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141180; cv=none; b=QD4h75y/8bFgb05eeNzNtjwYriN6rqYljpN8VfRtj5WxaX5mS+eOiRSpI6l112BiHMoyMy3E5MBysyw3KvXjOz1rOBqKwvDW/5YU/MbMastY/I1Rqe5GLGOFVjuR9E2PlD4OMDa62ecVbKhLhcSYdsk6SnwV0rE0uNuSYVpKLHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141180; c=relaxed/simple;
	bh=GwlRp6wpc5xvGDsv14OXVgROznCR5FRMP9G2lpwq/U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEmqKFInh1K/DTaJ8ah8aIY9u3hceVe3BEWV54+BKOc9mGVRqPcjo0rHrGWxPlUabuqkj2FtsnkL8r6NGCSmToemOxnNKMlcbJdcyZh6kkm4H7eX4Pp4buQpYJw4ji6BVxoLPL67WzXGujDme1ZYzP6GUAFAEl6mekbC4NAEHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdiaYuuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdiaYuuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F3CC2BC86;
	Tue, 10 Mar 2026 11:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141180;
	bh=GwlRp6wpc5xvGDsv14OXVgROznCR5FRMP9G2lpwq/U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdiaYuuGjDqRh8UMf2TXEFAQvGiDHOnzR7C/lzadTHI7ATk551R2n3eMnvivCLk/0
	 Wg4bFuwETniFsCT9aaE0ItRMIONYtykP93GiqX9Fi2EGbC0RUzxE498pXAleSo6M6l
	 VupNfXFcR9hCzkHMz9vbfvwr6AKtwm1gllZLKsswImfwv5OaaDIzmx12cPvoJ2ZseD
	 k42X6Ch0Pw3H3twH8Y9ehIj3SDwiIaeO82cqF1EHqN69uVBpYv+4jk5V9UFO0MQzn1
	 3CZdIVY4AmOfiyEs/pnA2XnWwqa/vD1h5qZnHfr861hfRLqsiHc7VnevfsQaiOc7fY
	 zEN53BSxFnG+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Eckert <fe@dev.tdt.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 181/311] pinctrl: equilibrium: rename irq_chip function callbacks
Date: Tue, 10 Mar 2026 07:03:48 -0400
Message-ID: <421600c4826b8382bb2204e8f0e28cde06bc1cc1.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

