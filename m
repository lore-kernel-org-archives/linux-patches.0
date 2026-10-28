Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212161;
	b=RsQYbjKjeYDvPtlOBDYEpZ8CCbBLSp8FPQWx1Uw8CoA7uwqIQkdxOaw0FoaAQWApUHGz
	 eQzVZhhCFnSnIkOk3idJ7EocVZ+aq8gecy/ArEoMonfc+PkruLo18puGGUgZ5T5z9TCJ/
	 iIdRw7i2NHfOnUH3bdjJg6b5WXV0Y8ulsGwUhnxjfK0+kn/jdeEJQWB3N686aycXKgfvu
	 +gbUZ/GCOk05gfGJtz7DhDBgojZTybRh2MmMuSOrleYsE6DZ2EQyMITs0F5f5/pe928JX
	 Wp3FxQ1K7UkoX8uwvGv/7wrTm0NM8D8QeI3tLG3YfPO1bYev9MV81IGqJPXZHsRUCUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=S05NU6KHxebhx38oxznqMAXh0itHJiVkrEWGJG1zYVE=;
	b=N1UyFlyeL+AamqC9G8SEDp/kwSALk2znd2dDF7EVpGJat3syI1Yq7YOcEE66Lmc7123t
	 Kro7mwDD/ctfg5tV5fFkOS3mdYm4azSO2woI+n6Q1rwEUnQu72mED0CFkv9R5pltYceSK
	 WlIgqVIMmnYY4Jq7UKvUWXWyF33D+SQCfvaoh1vmL2iNzytKkWw9FzJ/QihfWs36BFjM8
	 2IRCX4p1sRBr5h0YLoBUgWKyCsHiBMIytGGsgAobfFwLg2UGFQS4n50Ylifi/vhyN/Qc6
	 uKDOpXr1m4Xt3VCGEkdj8Z65hvlMzy1rOACNCXVLOcwdSXF/ZDoFXubBkdzZeKpjSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtpJJpjq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1385A606A31C;
	Wed, 28 Oct 2026 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtpJJpjq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622341F01828;
	Wed, 28 Oct 2026 18:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212160;
	bh=S05NU6KHxebhx38oxznqMAXh0itHJiVkrEWGJG1zYVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtpJJpjqJN+DzLGG74Vj0YeiR60vefOr3CUQUYHpoHDolKoiaeZozBgIkTEHqIwgP
	 wp5VzcQHxyRxb1T4qMkLSdq8V8BnO96tBihxA0AhAZDc1gaHBEFpdeEZSbHrAQE3Pi
	 /spFI3GDdVU+BDOSW27vCZA4vLN7U8mxg1x65f1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Titov <ilya.titov@wirenboard.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0057/1887] pinctrl: sunxi: keep a shadow copy of the data register output latches
Date: Wed, 28 Oct 2026 17:35:53 +0100
Message-ID: <20261028170500.525222514@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Titov <ilya.titov@wirenboard.com>

[ Upstream commit a13f7f5d14af9baf34eb12c25962f8d3542b281d ]

On Allwinner SoCs, reading a bank's data register returns the pin level,
not the output latch, for pins that are muxed as inputs.  Writing a GPIO
therefore corrupts the output latches of all input-muxed pins in the
same bank: the read-modify-write in sunxi_pinctrl_gpio_set() reads back
their pin levels and writes those into their latches.

This breaks emulated open-drain lines (e.g. a bit-banged I2C bus from
i2c-gpio).  Such a line is released high by muxing it as input and
letting the pull-up raise it, so any concurrent GPIO write in the same
bank stores 1 into its latch.  Driving the line low afterwards is a
non-atomic data-then-mux sequence in sunxi_pinctrl_gpio_direction_output();
if the poisoning write lands between the two steps, the pin actively
drives high (push-pull) instead of low.

Observed in practice as sporadic glitches on a T507 board bit-banging
I2C on port E while other PE GPIOs are toggled.  On a scope the failure
is unmistakable: on a clock pulse where SCL should fall to GND, the line
instead steps *above* its idle high level for the whole low phase — the
pad drives a strong push-pull 3.3 V high, higher than the level the
pull-up sustains on the loaded bus — before the next transition recovers
it.  The same can hit SDA, corrupting data instead of clocks.

Steps to reproduce on any sunxi board with a bit-banged (i2c-gpio) bus:

  # background: toggle any other GPIO of the same bank, e.g. line 21
  gpioset -c <chip> --toggle 100us 21=0 &

  # foreground: keep the bit-banged bus busy
  while :; do i2cdetect -y <bus> 0x50 0x57; done

  # watch SCL/SDA with a scope or logic analyzer: sporadic clock-low
  # phases driven high (above the pull-up level) instead of low

The bank spinlock cannot help: the racing write is a perfectly valid
whole-register RMW that faithfully writes back what the hardware
returned.  There are no set/clear registers on this IP to write a single
bit atomically.

Fix it the same way gpio-mmio handles hardware whose data register read
does not return the output latch: keep a shadow copy of each bank's
latches, base the read-modify-write on the shadow, and only write the
register.  The shadow is seeded from the hardware at probe time so pins
left in output mode by the bootloader keep their state.  Pins that reach
output mode through the gpiolib paths write their value (and thereby
their shadow bit) before the mux switch in
sunxi_pinctrl_gpio_direction_output(); pins muxed to gpio_out directly
through a pinmux node bypass that path, so sunxi_pmx_set() refreshes
their shadow bit from the latch (readable once the pin is in output
mode) to keep them driving their pre-existing level.

Seeding the shadow reads the PIO registers at probe time, which requires
the bus clock to be enabled.  The clock was only requested at the very
end of probe, after devm_pinctrl_register() had already claimed the pin
hogs described in the device tree - which mux pins, and thus access
registers, with the clock still gated.  Move the request ahead of both.
Boards whose bootloader leaves the PIO clock running are unaffected,
which is why the pre-existing hog problem has gone unnoticed since
commit 950707c0eb5c ("pinctrl: sunxi: add clock support").

Fixes: df7b34f4c3d2 ("pinctrl: sunxi: Fix gpio_set behaviour")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Titov <ilya.titov@wirenboard.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 88 +++++++++++++++++++--------
 drivers/pinctrl/sunxi/pinctrl-sunxi.h |  7 +++
 2 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 508aa911c8d99..c7001f0eb6765 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -793,6 +793,21 @@ static void sunxi_pmx_set(struct pinctrl_dev *pctldev,
 	writel((readl(pctl->membase + reg) & ~mask) | config << shift,
 	       pctl->membase + reg);
 
+	/*
+	 * A pin muxed to gpio_out directly through a pinmux node bypasses
+	 * sunxi_pinctrl_gpio_set() and drives whatever its output latch
+	 * holds.  Now that the pin is in output mode the data register
+	 * reads back the latch, so refresh the shadow to keep such pins
+	 * driving their pre-existing level.
+	 */
+	if (config == SUN4I_FUNC_OUTPUT) {
+		u32 *shadow = &pctl->dat_shadow[pin / PINS_PER_BANK];
+
+		sunxi_data_reg(pctl, pin, &reg, &shift, &mask);
+		*shadow = (*shadow & ~mask) |
+			  (readl(pctl->membase + reg) & mask);
+	}
+
 	raw_spin_unlock_irqrestore(&pctl->lock, flags);
 }
 
@@ -946,21 +961,29 @@ static void sunxi_pinctrl_gpio_set(struct gpio_chip *chip,
 				unsigned offset, int value)
 {
 	struct sunxi_pinctrl *pctl = gpiochip_get_data(chip);
-	u32 reg, shift, mask, val;
+	u32 *shadow = &pctl->dat_shadow[offset / PINS_PER_BANK];
+	u32 reg, shift, mask;
 	unsigned long flags;
 
 	sunxi_data_reg(pctl, offset, &reg, &shift, &mask);
 
 	raw_spin_lock_irqsave(&pctl->lock, flags);
 
-	val = readl(pctl->membase + reg);
-
+	/*
+	 * Reading the data register returns the pin level, not the output
+	 * latch, for pins muxed as inputs.  A read-modify-write based on
+	 * the register would therefore corrupt the latches of input-muxed
+	 * pins in the same bank (e.g. an emulated open-drain I2C line
+	 * released high), making them drive the wrong level once switched
+	 * to output.  Base the read-modify-write on a shadow copy of the
+	 * latches instead.
+	 */
 	if (value)
-		val |= mask;
+		*shadow |= mask;
 	else
-		val &= ~mask;
+		*shadow &= ~mask;
 
-	writel(val, pctl->membase + reg);
+	writel(*shadow, pctl->membase + reg);
 
 	raw_spin_unlock_irqrestore(&pctl->lock, flags);
 }
@@ -1484,7 +1507,7 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	struct pinctrl_pin_desc *pins;
 	struct sunxi_pinctrl *pctl;
 	struct pinmux_ops *pmxops;
-	int i, ret, last_pin, pin_idx;
+	int i, ret, last_pin, pin_idx, nbanks;
 	struct clk *clk;
 
 	pctl = devm_kzalloc(&pdev->dev, sizeof(*pctl), GFP_KERNEL);
@@ -1518,6 +1541,37 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	if (!pctl->irq_array)
 		return -ENOMEM;
 
+	/*
+	 * The bus clock has to be enabled before the pinctrl device
+	 * registers, as the pin hogs claimed from there access registers.
+	 */
+	ret = of_clk_get_parent_count(node);
+	clk = devm_clk_get_enabled(&pdev->dev, ret == 1 ? NULL : "apb");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	/*
+	 * Seed the output latch shadow from the hardware so pins the
+	 * bootloader left in output mode keep their state; see
+	 * sunxi_pinctrl_gpio_set() for why a shadow is needed.  This must
+	 * happen before the pinctrl device registers, as pin hogs can mux
+	 * pins to gpio_out and thereby update the shadow.
+	 */
+	last_pin = pctl->desc->pins[pctl->desc->npins - 1].pin.number;
+	nbanks = DIV_ROUND_UP(last_pin + 1 - pctl->desc->pin_base,
+			      PINS_PER_BANK);
+	pctl->dat_shadow = devm_kcalloc(&pdev->dev, nbanks,
+					sizeof(*pctl->dat_shadow), GFP_KERNEL);
+	if (!pctl->dat_shadow)
+		return -ENOMEM;
+
+	for (i = 0; i < nbanks; i++) {
+		u32 reg, shift, mask;
+
+		sunxi_data_reg(pctl, i * PINS_PER_BANK, &reg, &shift, &mask);
+		pctl->dat_shadow[i] = readl(pctl->membase + reg);
+	}
+
 	ret = sunxi_pinctrl_build_state(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "dt probe failed: %d\n", ret);
@@ -1572,7 +1626,6 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	if (!pctl->chip)
 		return -ENOMEM;
 
-	last_pin = pctl->desc->pins[pctl->desc->npins - 1].pin.number;
 	pctl->chip->owner = THIS_MODULE;
 	pctl->chip->request = gpiochip_generic_request;
 	pctl->chip->free = gpiochip_generic_free;
@@ -1605,31 +1658,20 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 			goto gpiochip_error;
 	}
 
-	ret = of_clk_get_parent_count(node);
-	clk = devm_clk_get(&pdev->dev, ret == 1 ? NULL : "apb");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		goto gpiochip_error;
-	}
-
-	ret = clk_prepare_enable(clk);
-	if (ret)
-		goto gpiochip_error;
-
 	pctl->irq = devm_kcalloc(&pdev->dev,
 				 pctl->desc->irq_banks,
 				 sizeof(*pctl->irq),
 				 GFP_KERNEL);
 	if (!pctl->irq) {
 		ret = -ENOMEM;
-		goto clk_error;
+		goto gpiochip_error;
 	}
 
 	for (i = 0; i < pctl->desc->irq_banks; i++) {
 		pctl->irq[i] = platform_get_irq(pdev, i);
 		if (pctl->irq[i] < 0) {
 			ret = pctl->irq[i];
-			goto clk_error;
+			goto gpiochip_error;
 		}
 	}
 
@@ -1640,7 +1682,7 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	if (!pctl->domain) {
 		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
 		ret = -ENOMEM;
-		goto clk_error;
+		goto gpiochip_error;
 	}
 
 	for (i = 0; i < (pctl->desc->irq_banks * IRQ_PER_BANK); i++) {
@@ -1672,8 +1714,6 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 
 	return 0;
 
-clk_error:
-	clk_disable_unprepare(clk);
 gpiochip_error:
 	gpiochip_remove(pctl->chip);
 	return ret;
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index a87a2f944d609..244b0039480a0 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -80,6 +80,7 @@
 #define IO_BIAS_MASK		GENMASK(3, 0)
 
 #define SUN4I_FUNC_INPUT	0
+#define SUN4I_FUNC_OUTPUT	1
 #define SUN4I_FUNC_IRQ		6
 
 #define PINCTRL_SUN5I_A10S	BIT(1)
@@ -173,6 +174,12 @@ struct sunxi_pinctrl {
 	int				*irq;
 	unsigned			*irq_array;
 	raw_spinlock_t			lock;
+	/*
+	 * Output latch shadow, one word per bank.  Seeded lockless at
+	 * probe before the pinctrl device registers, protected by @lock
+	 * afterwards.
+	 */
+	u32				*dat_shadow;
 	struct pinctrl_dev		*pctl_dev;
 	unsigned long			variant;
 	u32				bank_mem_size;
-- 
2.53.0



