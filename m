Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061168;
	b=C9ti/3HPJVlgM4/GjHlM+wpu/ucO7Dd3U1l7p/RNXq3Z0uGp1Lsh/wBXt0U9OLiOtXt7
	 we+KlU0hYvpAafTxOfRdmz9e3pgHoycWXthk4gWCG46UaWdc9kb/+Gpd3iAg++h81Euk2
	 5MsSiVZ3vuKXMPzQiFxfQP6aarsY7BqeUc6vuGYfUx7jNHDFJF9t0kPzCNP0qM4nN9toA
	 5DbuYwNojIiwN9pgysA9lhwIiSO/x7rlArikuzO0QYhb2ktpwKB4LZ6/aP9cWY0njymGr
	 UCyDryi2JgFN88gZIR/PGEO4RhThAuE9C8B6HNpXO2ZCJbftow2+wPM/rCntmeHcM4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Am1+XHbf7iKer7GEqzlVunFx+eXYt4Kj0THyrFmge8=;
	b=wGjp1sGbE6efTn5LUo2Y3q9R17uLDMtdovDIkFRr7Hq4xZdDrpt4lCylyPskpNyPgBWo
	 DU8ajyBERcbhHF0HjDt78IehTLKKQWLpzfp3bEDvwrH6FkVHQxEMgnonWJWaiSET8rEax
	 ojn1Guj9Ju1V2dEdslWDiEFM18H3CZ50XE+9mhUYHLoI3hhuwb5t9uiqsfn0ZomR3k4Rs
	 JJVxy3okPRr1EK8tl/KPmbuWtlCOE4n7kMU8o0pSk6aWEYFQXekOo99cu1Hh+grEAfnU1
	 t9y69LLxIN+pOWThOi/DX1gCWOdC0t1PKrRJdcOLit6b/TgIhlks8Ki0YdOQiEnu5JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdnlZn4E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E649606A325;
	Thu, 19 Nov 2026 04:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdnlZn4E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204001F000C4;
	Thu, 19 Nov 2026 04:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061167;
	bh=9Am1+XHbf7iKer7GEqzlVunFx+eXYt4Kj0THyrFmge8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdnlZn4EMpvrn1HdATsS19gjPc4WUlQZ9hgZlr3NsdzwCSm5p1PZ7Xsg62btWQVfi
	 hZeFndnMmrDGpB/ffzgXtA5RKFkEtmdN7jczIMkwbscsvPg+Kuuag9l4+IijkIZfvz
	 EDBCZRCC88zFb7xvha3eX1QJoJPTP8yKs3Y/oM6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Cooper <codekipper@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1455/1848] power: supply: ab8500: Use local helper
Date: Wed, 18 Nov 2026 15:58:13 +0100
Message-ID: <20261118150020.302090221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit ad89cb5f0a1ffad6ae9ba277f99fea830d135e7c ]

Use a local "dev" helper variable to make the probe()
code easier to read in the ab8500 subdrivers.

Drop out-of-memory messages as these should come from the
slab core.

Cc: Marcus Cooper <codekipper@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 1098c619ce75 ("power: supply: ab8500_charger: Handle detection errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c   | 37 +++++++++---------
 drivers/power/supply/ab8500_charger.c | 55 +++++++++++++--------------
 drivers/power/supply/ab8500_fg.c      | 39 +++++++++----------
 3 files changed, 64 insertions(+), 67 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 2fce437f04547..d818fd9714695 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -987,47 +987,46 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct abx500_bm_data *plat = pdev->dev.platform_data;
 	struct power_supply_config psy_cfg = {};
+	struct device *dev = &pdev->dev;
 	struct ab8500_btemp *di;
 	int irq, i, ret = 0;
 	u8 val;
 
-	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
+	di = devm_kzalloc(dev, sizeof(*di), GFP_KERNEL);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
-		dev_err(&pdev->dev, "no battery management data supplied\n");
+		dev_err(dev, "no battery management data supplied\n");
 		return -EINVAL;
 	}
 	di->bm = plat;
 
 	if (np) {
-		ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
+		ret = ab8500_bm_of_probe(dev, np, di->bm);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to get battery information\n");
+			dev_err(dev, "failed to get battery information\n");
 			return ret;
 		}
 	}
 
 	/* get parent data */
-	di->dev = &pdev->dev;
+	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 
 	/* Get ADC channels */
-	di->btemp_ball = devm_iio_channel_get(&pdev->dev, "btemp_ball");
+	di->btemp_ball = devm_iio_channel_get(dev, "btemp_ball");
 	if (IS_ERR(di->btemp_ball)) {
 		if (PTR_ERR(di->btemp_ball) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get BTEMP BALL ADC channel\n");
+		dev_err(dev, "failed to get BTEMP BALL ADC channel\n");
 		return PTR_ERR(di->btemp_ball);
 	}
-	di->bat_ctrl = devm_iio_channel_get(&pdev->dev, "bat_ctrl");
+	di->bat_ctrl = devm_iio_channel_get(dev, "bat_ctrl");
 	if (IS_ERR(di->bat_ctrl)) {
 		if (PTR_ERR(di->bat_ctrl) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get BAT CTRL ADC channel\n");
+		dev_err(dev, "failed to get BAT CTRL ADC channel\n");
 		return PTR_ERR(di->bat_ctrl);
 	}
 
@@ -1041,7 +1040,7 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	di->btemp_wq =
 		alloc_workqueue("ab8500_btemp_wq", WQ_MEM_RECLAIM, 0);
 	if (di->btemp_wq == NULL) {
-		dev_err(di->dev, "failed to create work queue\n");
+		dev_err(dev, "failed to create work queue\n");
 		return -ENOMEM;
 	}
 
@@ -1053,10 +1052,10 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
 	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
 
-	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+	ret = abx500_get_register_interruptible(dev, AB8500_CHARGER,
 		AB8500_BTEMP_HIGH_TH, &val);
 	if (ret < 0) {
-		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
+		dev_err(dev, "%s ab8500 read failed\n", __func__);
 		goto free_btemp_wq;
 	}
 	switch (val) {
@@ -1076,10 +1075,10 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	}
 
 	/* Register BTEMP power supply class */
-	di->btemp_psy = power_supply_register(di->dev, &ab8500_btemp_desc,
+	di->btemp_psy = power_supply_register(dev, &ab8500_btemp_desc,
 					      &psy_cfg);
 	if (IS_ERR(di->btemp_psy)) {
-		dev_err(di->dev, "failed to register BTEMP psy\n");
+		dev_err(dev, "failed to register BTEMP psy\n");
 		ret = PTR_ERR(di->btemp_psy);
 		goto free_btemp_wq;
 	}
@@ -1097,11 +1096,11 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 			ab8500_btemp_irq[i].name, di);
 
 		if (ret) {
-			dev_err(di->dev, "failed to request %s IRQ %d: %d\n"
+			dev_err(dev, "failed to request %s IRQ %d: %d\n"
 				, ab8500_btemp_irq[i].name, irq, ret);
 			goto free_irq;
 		}
-		dev_dbg(di->dev, "Requested %s IRQ %d: %d\n",
+		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
 			ab8500_btemp_irq[i].name, irq, ret);
 	}
 
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 3d627768ad7b2..1a46ec8986a94 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3370,23 +3370,22 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	struct power_supply_config ac_psy_cfg = {}, usb_psy_cfg = {};
 	struct ab8500_charger *di;
 	int irq, i, charger_status, ret = 0, ch_stat;
+	struct device *dev = &pdev->dev;
 
-	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_charger\n", __func__);
+	di = devm_kzalloc(dev, sizeof(*di), GFP_KERNEL);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
-		dev_err(&pdev->dev, "no battery management data supplied\n");
+		dev_err(dev, "no battery management data supplied\n");
 		return -EINVAL;
 	}
 	di->bm = plat;
 
 	if (np) {
-		ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
+		ret = ab8500_bm_of_probe(dev, np, di->bm);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to get battery information\n");
+			dev_err(dev, "failed to get battery information\n");
 			return ret;
 		}
 		di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
@@ -3394,39 +3393,39 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		di->autopower_cfg = false;
 
 	/* get parent data */
-	di->dev = &pdev->dev;
+	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 
 	/* Get ADC channels */
-	di->adc_main_charger_v = devm_iio_channel_get(&pdev->dev,
+	di->adc_main_charger_v = devm_iio_channel_get(dev,
 						      "main_charger_v");
 	if (IS_ERR(di->adc_main_charger_v)) {
 		if (PTR_ERR(di->adc_main_charger_v) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get ADC main charger voltage\n");
+		dev_err(dev, "failed to get ADC main charger voltage\n");
 		return PTR_ERR(di->adc_main_charger_v);
 	}
-	di->adc_main_charger_c = devm_iio_channel_get(&pdev->dev,
+	di->adc_main_charger_c = devm_iio_channel_get(dev,
 						      "main_charger_c");
 	if (IS_ERR(di->adc_main_charger_c)) {
 		if (PTR_ERR(di->adc_main_charger_c) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get ADC main charger current\n");
+		dev_err(dev, "failed to get ADC main charger current\n");
 		return PTR_ERR(di->adc_main_charger_c);
 	}
-	di->adc_vbus_v = devm_iio_channel_get(&pdev->dev, "vbus_v");
+	di->adc_vbus_v = devm_iio_channel_get(dev, "vbus_v");
 	if (IS_ERR(di->adc_vbus_v)) {
 		if (PTR_ERR(di->adc_vbus_v) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get ADC USB charger voltage\n");
+		dev_err(dev, "failed to get ADC USB charger voltage\n");
 		return PTR_ERR(di->adc_vbus_v);
 	}
-	di->adc_usb_charger_c = devm_iio_channel_get(&pdev->dev,
+	di->adc_usb_charger_c = devm_iio_channel_get(dev,
 						     "usb_charger_c");
 	if (IS_ERR(di->adc_usb_charger_c)) {
 		if (PTR_ERR(di->adc_usb_charger_c) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get ADC USB charger current\n");
+		dev_err(dev, "failed to get ADC USB charger current\n");
 		return PTR_ERR(di->adc_usb_charger_c);
 	}
 
@@ -3483,7 +3482,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->charger_wq = alloc_ordered_workqueue("ab8500_charger_wq",
 						 WQ_MEM_RECLAIM);
 	if (di->charger_wq == NULL) {
-		dev_err(di->dev, "failed to create work queue\n");
+		dev_err(dev, "failed to create work queue\n");
 		return -ENOMEM;
 	}
 
@@ -3542,10 +3541,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	 * is a charger connected to avoid erroneous BTEMP_HIGH/LOW
 	 * interrupts during charging
 	 */
-	di->regu = devm_regulator_get(di->dev, "vddadc");
+	di->regu = devm_regulator_get(dev, "vddadc");
 	if (IS_ERR(di->regu)) {
 		ret = PTR_ERR(di->regu);
-		dev_err(di->dev, "failed to get vddadc regulator\n");
+		dev_err(dev, "failed to get vddadc regulator\n");
 		goto free_charger_wq;
 	}
 
@@ -3553,17 +3552,17 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	/* Initialize OVV, and other registers */
 	ret = ab8500_charger_init_hw_registers(di);
 	if (ret) {
-		dev_err(di->dev, "failed to initialize ABB registers\n");
+		dev_err(dev, "failed to initialize ABB registers\n");
 		goto free_charger_wq;
 	}
 
 	/* Register AC charger class */
 	if (di->ac_chg.enabled) {
-		di->ac_chg.psy = power_supply_register(di->dev,
+		di->ac_chg.psy = power_supply_register(dev,
 						       &ab8500_ac_chg_desc,
 						       &ac_psy_cfg);
 		if (IS_ERR(di->ac_chg.psy)) {
-			dev_err(di->dev, "failed to register AC charger\n");
+			dev_err(dev, "failed to register AC charger\n");
 			ret = PTR_ERR(di->ac_chg.psy);
 			goto free_charger_wq;
 		}
@@ -3571,11 +3570,11 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	/* Register USB charger class */
 	if (di->usb_chg.enabled) {
-		di->usb_chg.psy = power_supply_register(di->dev,
+		di->usb_chg.psy = power_supply_register(dev,
 							&ab8500_usb_chg_desc,
 							&usb_psy_cfg);
 		if (IS_ERR(di->usb_chg.psy)) {
-			dev_err(di->dev, "failed to register USB charger\n");
+			dev_err(dev, "failed to register USB charger\n");
 			ret = PTR_ERR(di->usb_chg.psy);
 			goto free_ac;
 		}
@@ -3583,14 +3582,14 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	di->usb_phy = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(di->usb_phy)) {
-		dev_err(di->dev, "failed to get usb transceiver\n");
+		dev_err(dev, "failed to get usb transceiver\n");
 		ret = -EINVAL;
 		goto free_usb;
 	}
 	di->nb.notifier_call = ab8500_charger_usb_notifier_call;
 	ret = usb_register_notifier(di->usb_phy, &di->nb);
 	if (ret) {
-		dev_err(di->dev, "failed to register usb notifier\n");
+		dev_err(dev, "failed to register usb notifier\n");
 		goto put_usb_phy;
 	}
 
@@ -3623,11 +3622,11 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 			ab8500_charger_irq[i].name, di);
 
 		if (ret != 0) {
-			dev_err(di->dev, "failed to request %s IRQ %d: %d\n"
+			dev_err(dev, "failed to request %s IRQ %d: %d\n"
 				, ab8500_charger_irq[i].name, irq, ret);
 			goto free_irq;
 		}
-		dev_dbg(di->dev, "Requested %s IRQ %d: %d\n",
+		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
 			ab8500_charger_irq[i].name, irq, ret);
 	}
 
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 5218a0daf6c38..c7674eda8263e 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3044,26 +3044,25 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct abx500_bm_data *plat = pdev->dev.platform_data;
 	struct power_supply_config psy_cfg = {};
+	struct device *dev = &pdev->dev;
 	struct ab8500_fg *di;
 	int i, irq;
 	int ret = 0;
 
-	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
+	di = devm_kzalloc(dev, sizeof(*di), GFP_KERNEL);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
-		dev_err(&pdev->dev, "no battery management data supplied\n");
+		dev_err(dev, "no battery management data supplied\n");
 		return -EINVAL;
 	}
 	di->bm = plat;
 
 	if (np) {
-		ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
+		ret = ab8500_bm_of_probe(dev, np, di->bm);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to get battery information\n");
+			dev_err(dev, "failed to get battery information\n");
 			return ret;
 		}
 	}
@@ -3071,14 +3070,14 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	mutex_init(&di->cc_lock);
 
 	/* get parent data */
-	di->dev = &pdev->dev;
+	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 
-	di->main_bat_v = devm_iio_channel_get(&pdev->dev, "main_bat_v");
+	di->main_bat_v = devm_iio_channel_get(dev, "main_bat_v");
 	if (IS_ERR(di->main_bat_v)) {
 		if (PTR_ERR(di->main_bat_v) == -ENODEV)
 			return -EPROBE_DEFER;
-		dev_err(&pdev->dev, "failed to get main battery ADC channel\n");
+		dev_err(dev, "failed to get main battery ADC channel\n");
 		return PTR_ERR(di->main_bat_v);
 	}
 
@@ -3101,7 +3100,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	/* Create a work queue for running the FG algorithm */
 	di->fg_wq = alloc_ordered_workqueue("ab8500_fg_wq", WQ_MEM_RECLAIM);
 	if (di->fg_wq == NULL) {
-		dev_err(di->dev, "failed to create work queue\n");
+		dev_err(dev, "failed to create work queue\n");
 		return -ENOMEM;
 	}
 
@@ -3136,7 +3135,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	/* Initialize OVV, and other registers */
 	ret = ab8500_fg_init_hw_registers(di);
 	if (ret) {
-		dev_err(di->dev, "failed to initialize registers\n");
+		dev_err(dev, "failed to initialize registers\n");
 		goto free_inst_curr_wq;
 	}
 
@@ -3145,9 +3144,9 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	di->flags.batt_id_received = false;
 
 	/* Register FG power supply class */
-	di->fg_psy = power_supply_register(di->dev, &ab8500_fg_desc, &psy_cfg);
+	di->fg_psy = power_supply_register(dev, &ab8500_fg_desc, &psy_cfg);
 	if (IS_ERR(di->fg_psy)) {
-		dev_err(di->dev, "failed to register FG psy\n");
+		dev_err(dev, "failed to register FG psy\n");
 		ret = PTR_ERR(di->fg_psy);
 		goto free_inst_curr_wq;
 	}
@@ -3175,11 +3174,11 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 				  ab8500_fg_irq_th[i].name, di);
 
 		if (ret != 0) {
-			dev_err(di->dev, "failed to request %s IRQ %d: %d\n",
+			dev_err(dev, "failed to request %s IRQ %d: %d\n",
 				ab8500_fg_irq_th[i].name, irq, ret);
 			goto free_irq_th;
 		}
-		dev_dbg(di->dev, "Requested %s IRQ %d: %d\n",
+		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
 			ab8500_fg_irq_th[i].name, irq, ret);
 	}
 
@@ -3195,11 +3194,11 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 			ab8500_fg_irq_bh[0].name, di);
 
 	if (ret != 0) {
-		dev_err(di->dev, "failed to request %s IRQ %d: %d\n",
+		dev_err(dev, "failed to request %s IRQ %d: %d\n",
 			ab8500_fg_irq_bh[0].name, irq, ret);
 		goto free_irq_th;
 	}
-	dev_dbg(di->dev, "Requested %s IRQ %d: %d\n",
+	dev_dbg(dev, "Requested %s IRQ %d: %d\n",
 		ab8500_fg_irq_bh[0].name, irq, ret);
 
 	di->irq = platform_get_irq_byname(pdev, "CCEOC");
@@ -3210,13 +3209,13 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 
 	ret = ab8500_fg_sysfs_init(di);
 	if (ret) {
-		dev_err(di->dev, "failed to create sysfs entry\n");
+		dev_err(dev, "failed to create sysfs entry\n");
 		goto free_irq;
 	}
 
 	ret = ab8500_fg_sysfs_psy_create_attrs(di);
 	if (ret) {
-		dev_err(di->dev, "failed to create FG psy\n");
+		dev_err(dev, "failed to create FG psy\n");
 		ab8500_fg_sysfs_exit(di);
 		goto free_irq;
 	}
-- 
2.53.0



