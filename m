Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056051;
	b=YmH8/mFn3T6oAiTtLYkoBVRiHrynHUty4GHcGJ6Xx4qzefT8WxlxeD0qRb87HT57ZSYe
	 4qWmtCN8Sh7ZVvU873GgW9HitNtRNqMHu0AcUyJ6AIuXKVWqRGONH8/VzeCoPm69gj6bt
	 2LuqAI38sDjrAh6rNCkQFVRw7PCvrDhrT5sAKjvgz9xW+d5YC0rwJUHavNqBNEVmlUZhu
	 wcWiERQKBAViSMsjYBRD0315j1CVPjllsQf0RST71I1YPWhfLRv5YB8/io+4sKCStYEGq
	 T0T17Y2kMvxJlTMxdQ+srC3U9/mocKAkawPNxhCP3VyTlSwYNba3bpA44pdm1npkZoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNaQ01scCHf4TTNzHI1D6BTF95JoJ8bcT5yKrCDw5W0=;
	b=tk8hQCMDFhj5rP0kEiuDN+g6qKp6HZuVcIiqXIHC1zQBEO3YwejCtYuIgA/V0BcMpQvo
	 bbVBYny/GuFJYGPB3oJvS+IUvsz4W3t+EmizTh9GsGEr9hGX3WEsDAcWtRSXDpoKDQ2Eu
	 JUbjqTST20fuB/iLGqftpVxRV5fA0niYpu6El5uAixLFBN4a/Jnj39pnFw1r9Z+LsuhRg
	 XiFINjNXzDeomJaSdpd4/zg1kqc/U+aiv3bl3cwxqkwwviGUpwB9dm3SxSv47IbMHvxly
	 0PXAllBEvWewxTZLZLYRguDWKHPjL0ETgUQ1uqrqbGtjEiDz2+IFSh9I+fzd11YaqgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I30W2cmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1934606A31C;
	Thu, 19 Nov 2026 02:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I30W2cmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA981F000C4;
	Thu, 19 Nov 2026 02:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056051;
	bh=oNaQ01scCHf4TTNzHI1D6BTF95JoJ8bcT5yKrCDw5W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I30W2cmt/NVjqZLMHZv5gW3QRovnHlq+CRGADbrbwsHLyoKHq8Up1uWlf7JQ9PCTd
	 AW9XCG0AwHMhUG0b9kSG2SDn0dXqgY9noR+47fGs4w53+E+eGMJf4dxHqJoJUj5dKj
	 2b5IEP6OP2y38a7XuBy9KZRLgnZEGbilfhd3Xi/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1849/2214] power: supply: generic-adc-battery: convert to managed resources
Date: Wed, 18 Nov 2026 15:58:45 +0100
Message-ID: <20261118150125.354232829@linuxfoundation.org>
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

From: Sebastian Reichel <sre@kernel.org>

[ Upstream commit 93297ef6920f071ed109cbdcf640edfc693d0456 ]

Convert driver to use managed resources to simplify driver code.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Stable-dep-of: 36b0abe904ac ("power: supply: generic-adc-battery: Propagate charged GPIO errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 81 ++++++----------------
 1 file changed, 23 insertions(+), 58 deletions(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 33e151422d946..6cb697e24db0f 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -23,6 +23,7 @@
 #include <linux/iio/consumer.h>
 #include <linux/iio/types.h>
 #include <linux/power/generic-adc-battery.h>
+#include <linux/devm-helpers.h>
 
 #define JITTER_DEFAULT 10 /* hope 10ms is enough */
 
@@ -269,14 +270,13 @@ static int gab_probe(struct platform_device *pdev)
 	 * copying the static properties and allocating extra memory for holding
 	 * the extra configurable properties received from platform data.
 	 */
-	properties = kcalloc(ARRAY_SIZE(gab_props) +
-			     ARRAY_SIZE(gab_chan_name),
-			     sizeof(*properties),
-			     GFP_KERNEL);
-	if (!properties) {
-		ret = -ENOMEM;
-		goto first_mem_fail;
-	}
+	properties = devm_kcalloc(&pdev->dev,
+				  ARRAY_SIZE(gab_props) +
+				  ARRAY_SIZE(gab_chan_name),
+				  sizeof(*properties),
+				  GFP_KERNEL);
+	if (!properties)
+		return -ENOMEM;
 
 	memcpy(properties, gab_props, sizeof(gab_props));
 
@@ -285,12 +285,13 @@ static int gab_probe(struct platform_device *pdev)
 	 * based on the channel supported by consumer device.
 	 */
 	for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
-		adc_bat->channel[chan] = iio_channel_get(&pdev->dev,
-							 gab_chan_name[chan]);
+		adc_bat->channel[chan] = devm_iio_channel_get(&pdev->dev, gab_chan_name[chan]);
 		if (IS_ERR(adc_bat->channel[chan])) {
 			ret = PTR_ERR(adc_bat->channel[chan]);
+			if (ret != -ENODEV)
+				return dev_err_probe(&pdev->dev, ret, "Failed to get ADC channel %s\n", gab_chan_name[chan]);
 			adc_bat->channel[chan] = NULL;
-		} else {
+		} else if (adc_bat->channel[chan]) {
 			/* copying properties for supported channels only */
 			int index2;
 
@@ -305,10 +306,8 @@ static int gab_probe(struct platform_device *pdev)
 	}
 
 	/* none of the channels are supported so let's bail out */
-	if (!any) {
-		ret = -ENODEV;
-		goto second_mem_fail;
-	}
+	if (!any)
+		return dev_err_probe(&pdev->dev, -ENODEV, "Failed to get any ADC channel\n");
 
 	/*
 	 * Total number of properties is equal to static properties
@@ -319,25 +318,24 @@ static int gab_probe(struct platform_device *pdev)
 	psy_desc->properties = properties;
 	psy_desc->num_properties = index;
 
-	adc_bat->psy = power_supply_register(&pdev->dev, psy_desc, &psy_cfg);
-	if (IS_ERR(adc_bat->psy)) {
-		ret = PTR_ERR(adc_bat->psy);
-		goto err_reg_fail;
-	}
+	adc_bat->psy = devm_power_supply_register(&pdev->dev, psy_desc, &psy_cfg);
+	if (IS_ERR(adc_bat->psy))
+		return dev_err_probe(&pdev->dev, PTR_ERR(adc_bat->psy), "Failed to register power-supply device\n");
 
-	INIT_DELAYED_WORK(&adc_bat->bat_work, gab_work);
+	ret = devm_delayed_work_autocancel(&pdev->dev, &adc_bat->bat_work, gab_work);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "Failed to register delayed work\n");
 
-	adc_bat->charge_finished = devm_gpiod_get_optional(&pdev->dev,
-							   "charged", GPIOD_IN);
+	adc_bat->charge_finished = devm_gpiod_get_optional(&pdev->dev, "charged", GPIOD_IN);
 	if (adc_bat->charge_finished) {
 		int irq;
 
 		irq = gpiod_to_irq(adc_bat->charge_finished);
-		ret = request_any_context_irq(irq, gab_charged,
+		ret = devm_request_any_context_irq(&pdev->dev, irq, gab_charged,
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				"battery charged", adc_bat);
 		if (ret < 0)
-			goto gpio_req_fail;
+			return dev_err_probe(&pdev->dev, ret, "Failed to register irq\n");
 	}
 
 	platform_set_drvdata(pdev, adc_bat);
@@ -346,38 +344,6 @@ static int gab_probe(struct platform_device *pdev)
 	schedule_delayed_work(&adc_bat->bat_work,
 			msecs_to_jiffies(0));
 	return 0;
-
-gpio_req_fail:
-	power_supply_unregister(adc_bat->psy);
-err_reg_fail:
-	for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
-		if (adc_bat->channel[chan])
-			iio_channel_release(adc_bat->channel[chan]);
-	}
-second_mem_fail:
-	kfree(properties);
-first_mem_fail:
-	return ret;
-}
-
-static int gab_remove(struct platform_device *pdev)
-{
-	int chan;
-	struct gab *adc_bat = platform_get_drvdata(pdev);
-
-	power_supply_unregister(adc_bat->psy);
-
-	if (adc_bat->charge_finished)
-		free_irq(gpiod_to_irq(adc_bat->charge_finished), adc_bat);
-
-	for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
-		if (adc_bat->channel[chan])
-			iio_channel_release(adc_bat->channel[chan]);
-	}
-
-	kfree(adc_bat->psy_desc.properties);
-	cancel_delayed_work_sync(&adc_bat->bat_work);
-	return 0;
 }
 
 static int __maybe_unused gab_suspend(struct device *dev)
@@ -411,7 +377,6 @@ static struct platform_driver gab_driver = {
 		.pm	= &gab_pm_ops,
 	},
 	.probe		= gab_probe,
-	.remove		= gab_remove,
 };
 module_platform_driver(gab_driver);
 
-- 
2.53.0



