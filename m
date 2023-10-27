Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4D138BCE
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=9elements.com header.i=@9elements.com header.b="PmI6H042"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8C2C433C8
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=9elements.com header.i=@9elements.com header.b="PmI6H042"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 27 Oct 2023 17:27:45 +0100
Resent-Message-ID: <ZTvlASXadjOaxurH@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 27 Oct 2023 16:29:03 +0100
Received: from sin.source.kernel.org ([145.40.73.55])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=9QRE=GJ=9elements.com=naresh.solanki@kernel.org>)
	id 1qwOlg-00FfHH-Ri
	for broonie@sirena.co.uk; Fri, 27 Oct 2023 16:29:03 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 4E2EECE0AB6
	for <broonie@sirena.co.uk>; Fri, 27 Oct 2023 15:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 9406BC433C7; Fri, 27 Oct 2023 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D0A0C433CA
	for <broonie@kernel.org>; Fri, 27 Oct 2023 15:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 4D0A0C433CA
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=9elements.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=9elements.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2c4fe37f166so31116941fa.1
        for <broonie@kernel.org>; Fri, 27 Oct 2023 08:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=9elements.com; s=google; t=1698420515; x=1699025315; darn=kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GXUmekLw1GEFnBbnbx9xiufl4bE1wbCiB6K9UiIw9hY=;
        b=PmI6H0428fOFIXpakqdu3OCwZBF27ayC/YhUzG6BG9jXrbFEqvOOFSQHkeWFuaYKCA
         zUvj85Mh5tVC8vlC3y0yu+69/PZyzYKJA82OpHLoZsb2dh6sJMmaYeYzvE7KjQ7d4Idb
         AE+EFGg38UyTLI9HIgw6PlwWuYz+Xbkclkl0wQWzAaiuboG/kDGmHdSNfFXaZu3+NXXG
         4jZQjRMv30uDWikZQtkDkq+q88ThU9tDgHZrBXlTYlacwoWtFxf7amNYgkREKb6XyR2C
         mFSBViM3mS3rQet+jNJgKYixQ4d85bWoC0wRnYL87grISCX10Am3dwRSzPvdFQK5qouX
         EIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698420515; x=1699025315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GXUmekLw1GEFnBbnbx9xiufl4bE1wbCiB6K9UiIw9hY=;
        b=JiYiLnfYYO/xNw1QuzDRKpqC8tOuDUFYdmG6YlLQFrrhYAu1ZcrcpC91/WOgddUHLK
         dNoLwekDT1ljzYjtHINwpX5K+msHraewamXZD7tUO0RVGTdYeoLOdDGtwLdx7NQIcmMd
         53irMZIVptVeIJbHJQqcBjJ07qrh6rK8pLW5zxi8icfaKBDz5xaDtkDdmpx3xfTFOiOc
         0qfLKCjOIDanktEDvKd6PVa6H8FWH7fd0kBz7d1+/MgMzTfL3QrucQ0vFFBGOu18q+4b
         RdejL1TTd6I26SmOz3gWVvjXOdDtk/NtQIxE95ZqfJKrYV4z1JVP/QfRxBZZx5CKGRKU
         Mb0A==
X-Gm-Message-State: AOJu0YzMKucBtq8YEmnD3KzFb96cmBYzkI+Zqt2r54wf1BTVKrkMR/Ky
	WDC86RJLOKZPPFUbE9o6AzVZqw==
X-Google-Smtp-Source: AGHT+IFPPkTC206+yrjoVKX7YSoR1y3QWKxomFd5kE0Tx1waO2OJORc3Xr55GOT+zRwc9FpDwOYWxw==
X-Received: by 2002:a05:651c:b9f:b0:2c5:623:aa01 with SMTP id bg31-20020a05651c0b9f00b002c50623aa01mr2018337ljb.49.1698420514939;
        Fri, 27 Oct 2023 08:28:34 -0700 (PDT)
Received: from stroh80.sec.9e.network (ip-078-094-000-051.um19.pools.vodafone-ip.de. [78.94.0.51])
        by smtp.gmail.com with ESMTPSA id q17-20020a05600c46d100b0040836519dd9sm1902688wmo.25.2023.10.27.08.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 08:28:34 -0700 (PDT)
From: Naresh Solanki <naresh.solanki@9elements.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>
Cc: Naresh Solanki <naresh.solanki@9elements.com>,
	linux-kernel@vger.kernel.org,
	linux-hwmon@vger.kernel.org
Date: Fri, 27 Oct 2023 15:28:28 +0000
Message-ID: <20231027152830.1269895-1-naresh.solanki@9elements.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 145.40.73.55
X-SA-Exim-Mail-From: SRS0=9QRE=GJ=9elements.com=naresh.solanki@kernel.org
Subject: [PATCH v6 1/2] regulator (max5970): Add hwmon support
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: JxqEwwmTJX0D

Utilize the integrated 10-bit ADC in Max5970/Max5978 to enable voltage
and current monitoring. This feature is seamlessly integrated through
the hwmon subsystem.

Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>
---
Change in V6:
- Remove unrelated change
- Add necessary return value check
- Remove unneeded NULL check
Changes in V5:
- Simplify memory allocation for rdevs
Changes in V4:
- Use IS_REACHABLE
- Use rdevs array for hwmon ops.
- Remove duplicate i2c_set_clientdata
Changes in V3:
- Update signed-off
- Add break
- Update hwmon dev register name to max5970
- Remove changes in Kconfig.
Changes in V2:
- default case added for switch statement
- Add dependency on HWMON
---
 drivers/regulator/max5970-regulator.c | 144 +++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max5970-regulator.c b/drivers/regulator/max5970-regulator.c
index b56a174cde3d..56cc56ae63b7 100644
--- a/drivers/regulator/max5970-regulator.c
+++ b/drivers/regulator/max5970-regulator.c
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/hwmon.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -32,6 +33,132 @@ enum max597x_regulator_id {
 	MAX597X_SW1,
 };
 
+static int max5970_read_adc(struct regmap *regmap, int reg, long *val)
+{
+	u8 reg_data[2];
+	int ret;
+
+	ret = regmap_bulk_read(regmap, reg, &reg_data[0], 2);
+	if (ret < 0)
+		return ret;
+
+	*val = (reg_data[0] << 2) | (reg_data[1] & 3);
+
+	return 0;
+}
+
+static int max5970_read(struct device *dev, enum hwmon_sensor_types type,
+			u32 attr, int channel, long *val)
+{
+	struct regulator_dev **rdevs = dev_get_drvdata(dev);
+	struct max5970_regulator *ddata = rdev_get_drvdata(rdevs[channel]);
+	struct regmap *regmap = ddata->regmap;
+	int ret;
+
+	switch (type) {
+	case hwmon_curr:
+		switch (attr) {
+		case hwmon_curr_input:
+			ret = max5970_read_adc(regmap, MAX5970_REG_CURRENT_H(channel), val);
+			if (ret < 0)
+				return ret;
+			/*
+			 * Calculate current from ADC value, IRNG range & shunt resistor value.
+			 * ddata->irng holds the voltage corresponding to the maximum value the
+			 * 10-bit ADC can measure.
+			 * To obtain the output, multiply the ADC value by the IRNG range (in
+			 * millivolts) and then divide it by the maximum value of the 10-bit ADC.
+			 */
+			*val = (*val * ddata->irng) >> 10;
+			/* Convert the voltage meansurement across shunt resistor to current */
+			*val = (*val * 1000) / ddata->shunt_micro_ohms;
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+
+	case hwmon_in:
+		switch (attr) {
+		case hwmon_in_input:
+			ret = max5970_read_adc(regmap, MAX5970_REG_VOLTAGE_H(channel), val);
+			if (ret < 0)
+				return ret;
+			/*
+			 * Calculate voltage from ADC value and MON range.
+			 * ddata->mon_rng holds the voltage corresponding to the maximum value the
+			 * 10-bit ADC can measure.
+			 * To obtain the output, multiply the ADC value by the MON range (in
+			 * microvolts) and then divide it by the maximum value of the 10-bit ADC.
+			 */
+			*val = mul_u64_u32_shr(*val, ddata->mon_rng, 10);
+			/* uV to mV */
+			*val = *val / 1000;
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static umode_t max5970_is_visible(const void *data,
+				  enum hwmon_sensor_types type,
+				  u32 attr, int channel)
+{
+	struct regulator_dev **rdevs = (struct regulator_dev **)data;
+	struct max5970_regulator *ddata;
+
+	if (channel >= MAX5970_NUM_SWITCHES || !rdevs[channel])
+		return 0;
+
+	ddata = rdev_get_drvdata(rdevs[channel]);
+
+	if (channel >= ddata->num_switches)
+		return 0;
+
+	switch (type) {
+	case hwmon_in:
+		switch (attr) {
+		case hwmon_in_input:
+			return 0444;
+		default:
+			break;
+		}
+		break;
+	case hwmon_curr:
+		switch (attr) {
+		case hwmon_curr_input:
+			/* Current measurement requires knowledge of the shunt resistor value. */
+			if (ddata->shunt_micro_ohms)
+				return 0444;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static const struct hwmon_ops max5970_hwmon_ops = {
+	.is_visible = max5970_is_visible,
+	.read = max5970_read,
+};
+
+static const struct hwmon_channel_info *max5970_info[] = {
+	HWMON_CHANNEL_INFO(in, HWMON_I_INPUT, HWMON_I_INPUT),
+	HWMON_CHANNEL_INFO(curr, HWMON_C_INPUT, HWMON_C_INPUT),
+	NULL
+};
+
+static const struct hwmon_chip_info max5970_chip_info = {
+	.ops = &max5970_hwmon_ops,
+	.info = max5970_info,
+};
+
 static int max597x_uvp_ovp_check_mode(struct regulator_dev *rdev, int severity)
 {
 	int ret, reg;
@@ -431,7 +558,8 @@ static int max597x_regulator_probe(struct platform_device *pdev)
 	struct i2c_client *i2c = to_i2c_client(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
-	struct regulator_dev *rdevs[MAX5970_NUM_SWITCHES];
+	struct regulator_dev **rdevs = NULL;
+	struct device *hwmon_dev;
 	int num_switches;
 	int ret, i;
 
@@ -442,6 +570,11 @@ static int max597x_regulator_probe(struct platform_device *pdev)
 	if (!max597x)
 		return -ENOMEM;
 
+	rdevs = devm_kcalloc(&i2c->dev, MAX5970_NUM_SWITCHES, sizeof(struct regulator_dev *),
+			     GFP_KERNEL);
+	if (!rdevs)
+		return -ENOMEM;
+
 	i2c_set_clientdata(i2c, max597x);
 
 	if (of_device_is_compatible(i2c->dev.of_node, "maxim,max5978"))
@@ -485,6 +618,15 @@ static int max597x_regulator_probe(struct platform_device *pdev)
 		max597x->shunt_micro_ohms[i] = data->shunt_micro_ohms;
 	}
 
+	if (IS_REACHABLE(CONFIG_HWMON)) {
+		hwmon_dev = devm_hwmon_device_register_with_info(&i2c->dev, "max5970", rdevs,
+								 &max5970_chip_info, NULL);
+		if (IS_ERR(hwmon_dev)) {
+			return dev_err_probe(&i2c->dev, PTR_ERR(hwmon_dev),
+					     "Unable to register hwmon device\n");
+		}
+	}
+
 	if (i2c->irq) {
 		ret =
 		    max597x_setup_irq(&i2c->dev, i2c->irq, rdevs, num_switches,

base-commit: e95d9ba0eb4ef2f9f7fa0451c3ad4f77c685538d
-- 
2.41.0

