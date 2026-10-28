Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216925;
	b=X0YYtBuqfAnsGGGazGDZZZnnuwGWdHLC//H/rEXpu2QbllKiSChFXqF6BMVNzmmWgkPP
	 U6BSDHsGi8kZsbB2XIpbmYIK5vGCo0WVU47e1EFhuNsROf1CEvnSedD/UaRxutTojP6z1
	 HMtNdtZrwwvbtBMlH/NdxFs0ufzgduc6u0X2TlHRrGePDfVggmzQL9HAZ7JvRHxd0eeHY
	 vo5YASe7TZrFV/lSyFPLTIwyRI8jo+2jvjQJfhVOufEkJIn8FQVhOSWOEFU2Bx/NmGiRx
	 6Hxl2wZ8i/zQnraSUmsPqUl6eWeqd4okrxX0mHRo3gx4cI58zgQ4WeKwjGyh80CmBwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1iJ86U1N26+wUlzslEL80Nr5f9cdmN3WNxeT9HTtkAs=;
	b=yXSqgxI0xh2wRD2b9CxOwXRfGhc3p9e8EObqUmExxy9rHZvFnmcyiQqOqunuJi3X+pVQ
	 uJiI8TlNZWoZSLqy+fbLSb9Rre8QHPYYdrMX90HEkIkqgsQ3jNgqqfD2HX5EwjYhRd6Dl
	 +kSB4n6W84Zsec8WZUoH4ma03gew3uxlZ8WoSAOUtGUde5IBEc+W/s5+bHyrn2Vse1W/3
	 DS/nkXzrNNTZIQmM64FavTH9+qdHMT3L828LD0vfw5DKJHpu9TNhy7FEFIaxzCItYymQD
	 P11TFpT3unGf/YKqjnc72UL4M0Aa/TX3yAZc3l/AyltN+iaOJF050jgXYhaW+a5Vp1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dq3Ol70X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D761606A31C;
	Wed, 28 Oct 2026 19:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dq3Ol70X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7101F01825;
	Wed, 28 Oct 2026 19:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216925;
	bh=1iJ86U1N26+wUlzslEL80Nr5f9cdmN3WNxeT9HTtkAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dq3Ol70XHjCf4cTb9ePNDZEqRyniVtCXf45G4HtxoBjYNga2jhd2pfMXOvxUhGbWg
	 eTj+k1iluwYqR7OjvTyxHW4Wt0vebSiPkLBnIGV0lzIg9fM/85wSJH6yr1f2VQm1bv
	 Gq58m1j4c/2Wp0xLAraGI4VzkmQBZdWk2uzqrBQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1726/1887] gpio: mxc: enable pad wakeup on i.MX8x platforms
Date: Wed, 28 Oct 2026 18:03:42 +0100
Message-ID: <20261028170538.735356067@linuxfoundation.org>
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

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit f60c9eac54af28d7b5651fe49944bfd5098550e6 ]

On i.MX8QM/QXP/DXL SoCs, even a GPIO is selected as the wakeup source,
the GPIO block will be powered off when system enters into suspend
state. This can greatly reduce the power consumption of suspend state
because the whole partition can be shutdown. This is called PAD wakeup
feature on i.MX8x platform.

This patch adds the noirq suspend/resume hooks and uses the pad wakeup
feature as the default wakeup method for GPIO modules on
i.MX8QM/QXP/DXL platforms.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20221027130859.1444412-6-shenwei.wang@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: b7719c575dec ("gpio: mxc: fix both_edges bit operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 92 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index d456077c74f2f..83f4958ea2364 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -25,6 +25,12 @@
 #include <linux/of_device.h>
 #include <linux/bug.h>
 
+#define IMX_SCU_WAKEUP_OFF		0
+#define IMX_SCU_WAKEUP_LOW_LVL		4
+#define IMX_SCU_WAKEUP_FALL_EDGE	5
+#define IMX_SCU_WAKEUP_RISE_EDGE	6
+#define IMX_SCU_WAKEUP_HIGH_LVL		7
+
 /* device type dependent stuff */
 struct mxc_gpio_hwdata {
 	unsigned dr_reg;
@@ -62,6 +68,9 @@ struct mxc_gpio_port {
 	u32 both_edges;
 	struct mxc_gpio_reg_saved gpio_saved_reg;
 	bool power_off;
+	u32 wakeup_pads;
+	bool is_pad_wakeup;
+	u32 pad_type[32];
 	const struct mxc_gpio_hwdata *hwdata;
 };
 
@@ -131,6 +140,9 @@ static const struct of_device_id mxc_gpio_dt_ids[] = {
 	{ .compatible = "fsl,imx31-gpio", .data = &imx31_gpio_hwdata },
 	{ .compatible = "fsl,imx35-gpio", .data = &imx35_gpio_hwdata },
 	{ .compatible = "fsl,imx7d-gpio", .data = &imx35_gpio_hwdata },
+	{ .compatible = "fsl,imx8dxl-gpio", .data = &imx35_gpio_hwdata },
+	{ .compatible = "fsl,imx8qm-gpio", .data = &imx35_gpio_hwdata },
+	{ .compatible = "fsl,imx8qxp-gpio", .data = &imx35_gpio_hwdata },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mxc_gpio_dt_ids);
@@ -207,6 +219,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 	}
 
 	writel(1 << gpio_idx, port->base + GPIO_ISR);
+	port->pad_type[gpio_idx] = type;
 
 	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 
@@ -266,6 +279,9 @@ static void mx3_gpio_irq_handler(struct irq_desc *desc)
 	struct mxc_gpio_port *port = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 
+	if (port->is_pad_wakeup)
+		return;
+
 	chained_irq_enter(chip, desc);
 
 	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
@@ -318,11 +334,13 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 			ret = enable_irq_wake(port->irq_high);
 		else
 			ret = enable_irq_wake(port->irq);
+		port->wakeup_pads |= (1 << gpio_idx);
 	} else {
 		if (port->irq_high && (gpio_idx >= 16))
 			ret = disable_irq_wake(port->irq_high);
 		else
 			ret = disable_irq_wake(port->irq);
+		port->wakeup_pads &= ~(1 << gpio_idx);
 	}
 
 	return ret;
@@ -377,7 +395,6 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	port->dev = &pdev->dev;
-
 	port->hwdata = device_get_match_data(&pdev->dev);
 
 	port->base = devm_platform_ioremap_resource(pdev, 0);
@@ -509,6 +526,78 @@ static void mxc_gpio_restore_regs(struct mxc_gpio_port *port)
 	writel(port->gpio_saved_reg.dr, port->base + GPIO_DR);
 }
 
+static bool mxc_gpio_generic_config(struct mxc_gpio_port *port,
+		unsigned int offset, unsigned long conf)
+{
+	struct device_node *np = port->dev->of_node;
+
+	if (of_device_is_compatible(np, "fsl,imx8dxl-gpio") ||
+	    of_device_is_compatible(np, "fsl,imx8qxp-gpio") ||
+	    of_device_is_compatible(np, "fsl,imx8qm-gpio"))
+		return (gpiochip_generic_config(&port->gc, offset, conf) == 0);
+
+	return false;
+}
+
+static bool mxc_gpio_set_pad_wakeup(struct mxc_gpio_port *port, bool enable)
+{
+	unsigned long config;
+	bool ret = false;
+	int i, type;
+
+	static const u32 pad_type_map[] = {
+		IMX_SCU_WAKEUP_OFF,		/* 0 */
+		IMX_SCU_WAKEUP_RISE_EDGE,	/* IRQ_TYPE_EDGE_RISING */
+		IMX_SCU_WAKEUP_FALL_EDGE,	/* IRQ_TYPE_EDGE_FALLING */
+		IMX_SCU_WAKEUP_FALL_EDGE,	/* IRQ_TYPE_EDGE_BOTH */
+		IMX_SCU_WAKEUP_HIGH_LVL,	/* IRQ_TYPE_LEVEL_HIGH */
+		IMX_SCU_WAKEUP_OFF,		/* 5 */
+		IMX_SCU_WAKEUP_OFF,		/* 6 */
+		IMX_SCU_WAKEUP_OFF,		/* 7 */
+		IMX_SCU_WAKEUP_LOW_LVL,		/* IRQ_TYPE_LEVEL_LOW */
+	};
+
+	for (i = 0; i < 32; i++) {
+		if ((port->wakeup_pads & (1 << i))) {
+			type = port->pad_type[i];
+			if (enable)
+				config = pad_type_map[type];
+			else
+				config = IMX_SCU_WAKEUP_OFF;
+			ret |= mxc_gpio_generic_config(port, i, config);
+		}
+	}
+
+	return ret;
+}
+
+static int __maybe_unused mxc_gpio_noirq_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mxc_gpio_port *port = platform_get_drvdata(pdev);
+
+	if (port->wakeup_pads > 0)
+		port->is_pad_wakeup = mxc_gpio_set_pad_wakeup(port, true);
+
+	return 0;
+}
+
+static int __maybe_unused mxc_gpio_noirq_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mxc_gpio_port *port = platform_get_drvdata(pdev);
+
+	if (port->wakeup_pads > 0)
+		mxc_gpio_set_pad_wakeup(port, false);
+	port->is_pad_wakeup = false;
+
+	return 0;
+}
+
+static const struct dev_pm_ops mxc_gpio_dev_pm_ops = {
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(mxc_gpio_noirq_suspend, mxc_gpio_noirq_resume)
+};
+
 static int mxc_gpio_syscore_suspend(void)
 {
 	struct mxc_gpio_port *port;
@@ -548,6 +637,7 @@ static struct platform_driver mxc_gpio_driver = {
 		.name	= "gpio-mxc",
 		.of_match_table = mxc_gpio_dt_ids,
 		.suppress_bind_attrs = true,
+		.pm = &mxc_gpio_dev_pm_ops,
 	},
 	.probe		= mxc_gpio_probe,
 };
-- 
2.53.0



