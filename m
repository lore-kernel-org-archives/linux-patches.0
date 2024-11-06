Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B211DF252;
	Wed,  6 Nov 2024 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895452; cv=none; b=Jo5UV1X4mgDdMjhjlf5ghei4vkSmaFOVaAxAQSGjShxIis/pgs2MkHUPYdpAoE2wHM4t1VM3ZqCIj+ZN4TNICUsof7G0sWICsoGs1SxS9KFqACjjgzqIeM76qzlCUcufAid/AVUpOi7pVkI+DllLuMg3XXLdRGNiIcEz/DMcark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895452; c=relaxed/simple;
	bh=RpE9gRaJN+QMhwC5/Sjvuwz7Tvdmk69di+Zzo6DJGxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mH7uSvs+airHpsNa/G9tpKgELWGG8uubjS0SzC81INVe+W+3CMzlYmDVwUxOEmKyVJCoJr6wpSa7xZHD3wnqXaNkLu0DSzE2g1hKawcD4YMQqYvDu+aEHkKJBCzi91amS9ETg+3LNEAjW8792JGah8Lg6yp93Wqoz1kB7f/02ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beMWqVZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beMWqVZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834A2C4CED2;
	Wed,  6 Nov 2024 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895450;
	bh=RpE9gRaJN+QMhwC5/Sjvuwz7Tvdmk69di+Zzo6DJGxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beMWqVZtXy92MCmtYZcyTp28Aj1T4x4EpxZ390WqmLhEFhtnxOsSyilrWMnz37svd
	 uqTLXo+ortAWHk/ThKa6f3jA1oYPz4iNcLDOkyAZeBpqP6arJhA7oxl5OwrXGCN6r6
	 slzLdTXUpNXpxxRWLzRtararr4YvaE+VjyOBWNj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 223/350] rtc: at91sam9: drop platform_data support
Date: Wed,  6 Nov 2024 13:02:31 +0100
Message-ID: <20241106120326.506804314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 1a76a77c8800a50b98bd38b7b1ffec32fe107bc1 ]

ARCH_AT91 is DT only for a while, drop platform data support.

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 73580e2ee6ad ("rtc: at91sam9: fix OF node leak in probe() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig        |  2 +-
 drivers/rtc/rtc-at91sam9.c | 44 +++++++-------------------------------
 2 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 199cc39459198..6dedba21683f5 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1404,7 +1404,7 @@ config RTC_DRV_AT91RM9200
 config RTC_DRV_AT91SAM9
 	tristate "AT91SAM9 RTT as RTC"
 	depends on ARCH_AT91 || COMPILE_TEST
-	depends on HAS_IOMEM
+	depends on OF && HAS_IOMEM
 	select MFD_SYSCON
 	help
 	  Some AT91SAM9 SoCs provide an RTT (Real Time Timer) block which
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index ee71e647fd433..1c8bdf77f6edd 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -348,13 +348,6 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
 };
 
-static const struct regmap_config gpbr_regmap_config = {
-	.name = "gpbr",
-	.reg_bits = 32,
-	.val_bits = 32,
-	.reg_stride = 4,
-};
-
 /*
  * Initialize and install RTC driver
  */
@@ -365,6 +358,7 @@ static int at91_rtc_probe(struct platform_device *pdev)
 	int		ret, irq;
 	u32		mr;
 	unsigned int	sclk_rate;
+	struct of_phandle_args args;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -390,34 +384,14 @@ static int at91_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(rtc->rtt))
 		return PTR_ERR(rtc->rtt);
 
-	if (!pdev->dev.of_node) {
-		/*
-		 * TODO: Remove this code chunk when removing non DT board
-		 * support. Remember to remove the gpbr_regmap_config
-		 * variable too.
-		 */
-		void __iomem *gpbr;
-
-		r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		gpbr = devm_ioremap_resource(&pdev->dev, r);
-		if (IS_ERR(gpbr))
-			return PTR_ERR(gpbr);
-
-		rtc->gpbr = regmap_init_mmio(NULL, gpbr,
-					     &gpbr_regmap_config);
-	} else {
-		struct of_phandle_args args;
-
-		ret = of_parse_phandle_with_fixed_args(pdev->dev.of_node,
-						"atmel,rtt-rtc-time-reg", 1, 0,
-						&args);
-		if (ret)
-			return ret;
-
-		rtc->gpbr = syscon_node_to_regmap(args.np);
-		rtc->gpbr_offset = args.args[0];
-	}
+	ret = of_parse_phandle_with_fixed_args(pdev->dev.of_node,
+					"atmel,rtt-rtc-time-reg", 1, 0,
+					&args);
+	if (ret)
+		return ret;
 
+	rtc->gpbr = syscon_node_to_regmap(args.np);
+	rtc->gpbr_offset = args.args[0];
 	if (IS_ERR(rtc->gpbr)) {
 		dev_err(&pdev->dev, "failed to retrieve gpbr regmap, aborting.\n");
 		return -ENOMEM;
@@ -569,13 +543,11 @@ static int at91_rtc_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
-#ifdef CONFIG_OF
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{ .compatible = "atmel,at91sam9260-rtt" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
-#endif
 
 static struct platform_driver at91_rtc_driver = {
 	.probe		= at91_rtc_probe,
-- 
2.43.0



