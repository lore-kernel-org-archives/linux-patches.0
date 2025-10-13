Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF793164C2;
	Mon, 13 Oct 2025 15:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369267; cv=none; b=ascHOBH7fgT31/ea9UyxqFwlE7NPxzpUMoWQnF9X3yyWUBKcikeGzGarkoSrRAazQfPFLGUstVDJ+kntSAv/ZfirLBRGmK7S4q7+EjqROt5gTp+Btjh1PefY2qrPuyjC54VDYPm+uRYjHuXYLiqQMV1Z4Tt1BAQE8y26ZtwDbuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369267; c=relaxed/simple;
	bh=GhhMGIOcf21g76oilWe7SEFYA2hWTo2WwSNVlbKxikQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tfp+sOD07uePRCZ49vlW2/T1othCfIBEv1S2UgwNWNYpMaD69THukHuYxMvYTarPtazR3kYZRchkwFAqPmMVW2JgukY1BPwhsiUrAF8AKim7pdQYAFG+aVPmImr2hv23zVkhCGXt6lIY7e0s5ufyVSrvEu6GRuWND9eONpLaPlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4N3qiRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4N3qiRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C74C116B1;
	Mon, 13 Oct 2025 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369267;
	bh=GhhMGIOcf21g76oilWe7SEFYA2hWTo2WwSNVlbKxikQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4N3qiREoK4R51rJ4rt5fnO2GwIhvSGy0QXq8/QFLpj/IJHA2e0WZWYy8A630gomZ
	 rZ/Ubt/iul7eTTdu7HLHZ9dc8G+UWSNxksX4qKeKgOS5KJsPmwfct0hdeDoZCHl4IH
	 uNI3DzXwJnqdB0NVB0YIjyarQY3dIXfIxlR+xMDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 186/563] power: supply: max77705_charger: refactoring: rename charger to chg
Date: Mon, 13 Oct 2025 16:40:47 +0200
Message-ID: <20251013144418.022220997@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit d84510db8c1414b67167cdc452103c1f429588cc ]

Rename struct max77705_charger_data variable to chg for consistency.

Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 12a1185a06e3 ("power: supply: max77705_charger: rework interrupts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max77705_charger.c | 80 ++++++++++++-------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/power/supply/max77705_charger.c b/drivers/power/supply/max77705_charger.c
index 3b75c82b9b9ea..7855f890e0a9f 100644
--- a/drivers/power/supply/max77705_charger.c
+++ b/drivers/power/supply/max77705_charger.c
@@ -42,9 +42,9 @@ static enum power_supply_property max77705_charger_props[] = {
 
 static int max77705_chgin_irq(void *irq_drv_data)
 {
-	struct max77705_charger_data *charger = irq_drv_data;
+	struct max77705_charger_data *chg = irq_drv_data;
 
-	queue_work(charger->wqueue, &charger->chgin_work);
+	queue_work(chg->wqueue, &chg->chgin_work);
 
 	return 0;
 }
@@ -109,19 +109,19 @@ static int max77705_get_online(struct regmap *regmap, int *val)
 	return 0;
 }
 
-static int max77705_check_battery(struct max77705_charger_data *charger, int *val)
+static int max77705_check_battery(struct max77705_charger_data *chg, int *val)
 {
 	unsigned int reg_data;
 	unsigned int reg_data2;
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 
 	regmap_read(regmap, MAX77705_CHG_REG_INT_OK, &reg_data);
 
-	dev_dbg(charger->dev, "CHG_INT_OK(0x%x)\n", reg_data);
+	dev_dbg(chg->dev, "CHG_INT_OK(0x%x)\n", reg_data);
 
 	regmap_read(regmap, MAX77705_CHG_REG_DETAILS_00, &reg_data2);
 
-	dev_dbg(charger->dev, "CHG_DETAILS00(0x%x)\n", reg_data2);
+	dev_dbg(chg->dev, "CHG_DETAILS00(0x%x)\n", reg_data2);
 
 	if ((reg_data & MAX77705_BATP_OK) || !(reg_data2 & MAX77705_BATP_DTLS))
 		*val = true;
@@ -131,9 +131,9 @@ static int max77705_check_battery(struct max77705_charger_data *charger, int *va
 	return 0;
 }
 
-static int max77705_get_charge_type(struct max77705_charger_data *charger, int *val)
+static int max77705_get_charge_type(struct max77705_charger_data *chg, int *val)
 {
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 	unsigned int reg_data;
 
 	regmap_read(regmap, MAX77705_CHG_REG_CNFG_09, &reg_data);
@@ -159,9 +159,9 @@ static int max77705_get_charge_type(struct max77705_charger_data *charger, int *
 	return 0;
 }
 
-static int max77705_get_status(struct max77705_charger_data *charger, int *val)
+static int max77705_get_status(struct max77705_charger_data *chg, int *val)
 {
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 	unsigned int reg_data;
 
 	regmap_read(regmap, MAX77705_CHG_REG_CNFG_09, &reg_data);
@@ -234,10 +234,10 @@ static int max77705_get_vbus_state(struct regmap *regmap, int *value)
 	return 0;
 }
 
-static int max77705_get_battery_health(struct max77705_charger_data *charger,
+static int max77705_get_battery_health(struct max77705_charger_data *chg,
 					int *value)
 {
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 	unsigned int bat_dtls;
 
 	regmap_read(regmap, MAX77705_CHG_REG_DETAILS_01, &bat_dtls);
@@ -245,16 +245,16 @@ static int max77705_get_battery_health(struct max77705_charger_data *charger,
 
 	switch (bat_dtls) {
 	case MAX77705_BATTERY_NOBAT:
-		dev_dbg(charger->dev, "%s: No battery and the charger is suspended\n",
+		dev_dbg(chg->dev, "%s: No battery and the chg is suspended\n",
 			__func__);
 		*value = POWER_SUPPLY_HEALTH_NO_BATTERY;
 		break;
 	case MAX77705_BATTERY_PREQUALIFICATION:
-		dev_dbg(charger->dev, "%s: battery is okay but its voltage is low(~VPQLB)\n",
+		dev_dbg(chg->dev, "%s: battery is okay but its voltage is low(~VPQLB)\n",
 			__func__);
 		break;
 	case MAX77705_BATTERY_DEAD:
-		dev_dbg(charger->dev, "%s: battery dead\n", __func__);
+		dev_dbg(chg->dev, "%s: battery dead\n", __func__);
 		*value = POWER_SUPPLY_HEALTH_DEAD;
 		break;
 	case MAX77705_BATTERY_GOOD:
@@ -262,11 +262,11 @@ static int max77705_get_battery_health(struct max77705_charger_data *charger,
 		*value = POWER_SUPPLY_HEALTH_GOOD;
 		break;
 	case MAX77705_BATTERY_OVERVOLTAGE:
-		dev_dbg(charger->dev, "%s: battery ovp\n", __func__);
+		dev_dbg(chg->dev, "%s: battery ovp\n", __func__);
 		*value = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		break;
 	default:
-		dev_dbg(charger->dev, "%s: battery unknown\n", __func__);
+		dev_dbg(chg->dev, "%s: battery unknown\n", __func__);
 		*value = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
 		break;
 	}
@@ -274,9 +274,9 @@ static int max77705_get_battery_health(struct max77705_charger_data *charger,
 	return 0;
 }
 
-static int max77705_get_health(struct max77705_charger_data *charger, int *val)
+static int max77705_get_health(struct max77705_charger_data *chg, int *val)
 {
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 	int ret, is_online = 0;
 
 	ret = max77705_get_online(regmap, &is_online);
@@ -287,15 +287,15 @@ static int max77705_get_health(struct max77705_charger_data *charger, int *val)
 		if (ret || (*val != POWER_SUPPLY_HEALTH_GOOD))
 			return ret;
 	}
-	return max77705_get_battery_health(charger, val);
+	return max77705_get_battery_health(chg, val);
 }
 
-static int max77705_get_input_current(struct max77705_charger_data *charger,
+static int max77705_get_input_current(struct max77705_charger_data *chg,
 					int *val)
 {
 	unsigned int reg_data;
 	int get_current = 0;
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 
 	regmap_read(regmap, MAX77705_CHG_REG_CNFG_09, &reg_data);
 
@@ -313,11 +313,11 @@ static int max77705_get_input_current(struct max77705_charger_data *charger,
 	return 0;
 }
 
-static int max77705_get_charge_current(struct max77705_charger_data *charger,
+static int max77705_get_charge_current(struct max77705_charger_data *chg,
 					int *val)
 {
 	unsigned int reg_data;
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 
 	regmap_read(regmap, MAX77705_CHG_REG_CNFG_02, &reg_data);
 	reg_data &= MAX77705_CHG_CC;
@@ -327,12 +327,12 @@ static int max77705_get_charge_current(struct max77705_charger_data *charger,
 	return 0;
 }
 
-static int max77705_set_float_voltage(struct max77705_charger_data *charger,
+static int max77705_set_float_voltage(struct max77705_charger_data *chg,
 					int float_voltage)
 {
 	int float_voltage_mv;
 	unsigned int reg_data = 0;
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 
 	float_voltage_mv = float_voltage / 1000;
 	reg_data = float_voltage_mv <= 4000 ? 0x0 :
@@ -345,12 +345,12 @@ static int max77705_set_float_voltage(struct max77705_charger_data *charger,
 				(reg_data << MAX77705_CHG_CV_PRM_SHIFT));
 }
 
-static int max77705_get_float_voltage(struct max77705_charger_data *charger,
+static int max77705_get_float_voltage(struct max77705_charger_data *chg,
 					int *val)
 {
 	unsigned int reg_data = 0;
 	int voltage_mv;
-	struct regmap *regmap = charger->regmap;
+	struct regmap *regmap = chg->regmap;
 
 	regmap_read(regmap, MAX77705_CHG_REG_CNFG_04, &reg_data);
 	reg_data &= MAX77705_CHG_PRM_MASK;
@@ -365,28 +365,28 @@ static int max77705_chg_get_property(struct power_supply *psy,
 					enum power_supply_property psp,
 					union power_supply_propval *val)
 {
-	struct max77705_charger_data *charger = power_supply_get_drvdata(psy);
-	struct regmap *regmap = charger->regmap;
+	struct max77705_charger_data *chg = power_supply_get_drvdata(psy);
+	struct regmap *regmap = chg->regmap;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		return max77705_get_online(regmap, &val->intval);
 	case POWER_SUPPLY_PROP_PRESENT:
-		return max77705_check_battery(charger, &val->intval);
+		return max77705_check_battery(chg, &val->intval);
 	case POWER_SUPPLY_PROP_STATUS:
-		return max77705_get_status(charger, &val->intval);
+		return max77705_get_status(chg, &val->intval);
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
-		return max77705_get_charge_type(charger, &val->intval);
+		return max77705_get_charge_type(chg, &val->intval);
 	case POWER_SUPPLY_PROP_HEALTH:
-		return max77705_get_health(charger, &val->intval);
+		return max77705_get_health(chg, &val->intval);
 	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
-		return max77705_get_input_current(charger, &val->intval);
+		return max77705_get_input_current(chg, &val->intval);
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
-		return max77705_get_charge_current(charger, &val->intval);
+		return max77705_get_charge_current(chg, &val->intval);
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
-		return max77705_get_float_voltage(charger, &val->intval);
+		return max77705_get_float_voltage(chg, &val->intval);
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		val->intval = charger->bat_info->voltage_max_design_uv;
+		val->intval = chg->bat_info->voltage_max_design_uv;
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = max77705_charger_model;
@@ -410,10 +410,10 @@ static const struct power_supply_desc max77705_charger_psy_desc = {
 
 static void max77705_chgin_isr_work(struct work_struct *work)
 {
-	struct max77705_charger_data *charger =
+	struct max77705_charger_data *chg =
 		container_of(work, struct max77705_charger_data, chgin_work);
 
-	power_supply_changed(charger->psy_chg);
+	power_supply_changed(chg->psy_chg);
 }
 
 static void max77705_charger_initialize(struct max77705_charger_data *chg)
-- 
2.51.0



