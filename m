Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049508;
	b=EUMJX5cc99+G8aamfy5VTOHWQas8sS23TSEsIrMfzF6LWgU+jvHZfITMuW+RgLH0WcHR
	 KJybMkXj+DTz0RbaZUsKjpANxWDTWXbRYTj7NtNbW9a0s+BEXq3By7QPMr9OKyb87H85l
	 qgSHkJ0887MuXQ0C5ODZoRVSkfi79s6uvDVzlXNFa1+4CuBiqLtVGG0B938aqN5aez1vc
	 5i9b43Na/sXuZ5B+eGyIvun9qX2H+Fw/o0bzpttj3+QOeeF/8jSaq4Zy4dC/icYxE3QfO
	 UhEwHR47jPU5rH/+59sfHyIel+7JzAWf9SLv0Hn0KtGjoBpFShBkxx1xPoEYXkv11oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vhhssy9dkHaTmBpThnJyZ9KzOTqlvFHMxIAAWffqrSE=;
	b=t3SamgRTRZunBnTeFPsWWvHEoCnsi4wKBBs6Bj84yGLSPONz+QaI+38Ri1BOHCbT64IO
	 0fmKpqNGuEWCh74wVdXwP+vxPuSILEgkzUfLNsjvKxu9KZSVHMx1D5tBSJWbDs+fk4i1y
	 +Jw2qwsOVXMagwGZfG4KJbnEtsYOEyh+YV8qUF7eyVrC5/OuZnOJWmqhvYLWb70KsuqCc
	 xeVPEII662B6dFBcVmhPoEZfhudjk8nmNWAjCjsZ49OqEdt2/U0zJ+c25s6Xtjy04pgmd
	 jyDL3phTkJetPSgDhz83FcZWbi0MFWKeDIzUK7WLWvctN5Jd/OXn6VtDQX4ZZrly3DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI0hjMbV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F5606A331;
	Thu, 19 Nov 2026 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI0hjMbV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488F71F000C4;
	Thu, 19 Nov 2026 00:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049507;
	bh=vhhssy9dkHaTmBpThnJyZ9KzOTqlvFHMxIAAWffqrSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OI0hjMbV6F3tzYFiI+7XTnr9+3EoGamSY2eBd81nvyNHRSxOXRB5IObtK0AhCy53u
	 0RnW2adBC0RtplzmB0cul2GdtD/XNQW5xB7QIza4Vmj/r+xDHFwlP/abkYgUIR23H5
	 0lozfHyVFvhUFoqdrMAFsiRRTbRF8PfSkRHLz0mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2377/2857] power: supply: generic-adc-battery: convert to managed resources
Date: Wed, 18 Nov 2026 15:56:51 +0100
Message-ID: <20261118150327.109588648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



