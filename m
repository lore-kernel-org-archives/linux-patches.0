Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214346;
	b=H/1bfmvlUDCpWyijIj2VmCLii43UkWxay7sNiT+NDK10cU0YhAD78aGg5R67NHprbHIq
	 g4MQPwPX2gzhBEXAXBsZNiExeG6Rk645+0BnNPJ04bmrylFiZZKbG0Fw4IEx/S7K2y5qJ
	 pTkp58cwlYb8KLIesXbQloQN2JaUSOa/o/HO6pJFwhuiYZe947xa/dO7oJEunJ6UG/OUu
	 u44PfwppGoHqB9t23CZ55PUd68kW6DII+YsGvqr56QyFda8Ppz5dXTIz16qrf1xVR0KRy
	 KOzYVyH03gpmNXSv3LtR8em4MqdPgcDrbP5Jd0VPz+HNjmyOcbv3/hkHaIQ5y8/3EwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BMaHI817346fguy4Vsxf3eo/9Tain7zc+OXjN8Prfpo=;
	b=vYR3Hcry3IWNvgEBJgcNj4UeIem8klJ4KYgEnWEPwLMdfDdCecvt4AVIzHtEyYpczJeC
	 jJzTym4MayCf0z71MQxPmPpP7uvEpniy9UZEMm4+RDu6fmQ8z4dY6WLRhYsM5TDlOkcqi
	 CrMDMs2ts1ZOs88LF96L6C38BTt2hLBj4nYDP6k2NN2cIoKb1oGscNtbqJ8DTrkwZX70o
	 heve3yAFH24YFlaA+dEHwKQ92862ByrkrOunPD0Z13L3qQ9K9EbjtyBok4TCXvHw8Bum7
	 Q4LIf5zmv3Uuaj8FsJIM15AWUmrBNugnrKo72SduoAU8y6nKm3hhkZkrxgupfPn6S2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAbOGFZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9B9606BFBC;
	Wed, 28 Oct 2026 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAbOGFZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CD91F01825;
	Wed, 28 Oct 2026 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214345;
	bh=BMaHI817346fguy4Vsxf3eo/9Tain7zc+OXjN8Prfpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAbOGFZBMJVXa2M9GOaUU/nnz5ZXENL1uMs0pF0F+uPlvWXSG4pcBW4KR02mrxxz0
	 wjWM1rY8OQStw/wLHm/sRB9DCP3qvk8UDuZMofO2TfaPfA8Y20n+LnyGGHUwLgqWXy
	 s3Kq2aA01B1W6NMiU7nRT7qVe+MYltFdaC42beCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0809/1887] iio: st_sensors: core and lsm9ds0 switch to devm_regulator_bulk_get_enable()
Date: Wed, 28 Oct 2026 17:48:25 +0100
Message-ID: <20261028170517.838662277@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 9e855d77b1ec57704d23e25761a97e6e64abed66 ]

These drivers only turns the power on at probe and off via a custom
devm_add_action_or_reset() callback. The two regulators were handled
separately so also switch to bulk registration.
The new devm_regulator_bulk_get_enable() replaces all this boilerplate
code.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20221016163409.320197-8-jic23@kernel.org
Stable-dep-of: 9f92e93e257b ("iio: common: st_sensors: Fix use of uninitialize device structs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iio/common/st_sensors/st_sensors_core.c   | 39 ++---------
 drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c  | 65 ++-----------------
 include/linux/iio/common/st_sensors.h         |  4 --
 3 files changed, 14 insertions(+), 94 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index dcc032f687403..6c3705f3838d1 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -219,47 +219,22 @@ int st_sensors_set_axis_enable(struct iio_dev *indio_dev, u8 axis_enable)
 }
 EXPORT_SYMBOL_NS(st_sensors_set_axis_enable, IIO_ST_SENSORS);
 
-static void st_reg_disable(void *reg)
-{
-	regulator_disable(reg);
-}
 
 int st_sensors_power_enable(struct iio_dev *indio_dev)
 {
-	struct st_sensor_data *pdata = iio_priv(indio_dev);
+	static const char * const regulator_names[] = { "vdd", "vddio" };
 	struct device *parent = indio_dev->dev.parent;
 	int err;
 
 	/* Regulators not mandatory, but if requested we should enable them. */
-	pdata->vdd = devm_regulator_get(parent, "vdd");
-	if (IS_ERR(pdata->vdd))
-		return dev_err_probe(&indio_dev->dev, PTR_ERR(pdata->vdd),
-				     "unable to get Vdd supply\n");
-
-	err = regulator_enable(pdata->vdd);
-	if (err != 0) {
-		dev_warn(&indio_dev->dev,
-			 "Failed to enable specified Vdd supply\n");
-		return err;
-	}
-
-	err = devm_add_action_or_reset(parent, st_reg_disable, pdata->vdd);
+	err = devm_regulator_bulk_get_enable(parent,
+					     ARRAY_SIZE(regulator_names),
+					     regulator_names);
 	if (err)
-		return err;
+		return dev_err_probe(&indio_dev->dev, err,
+				     "unable to enable supplies\n");
 
-	pdata->vdd_io = devm_regulator_get(parent, "vddio");
-	if (IS_ERR(pdata->vdd_io))
-		return dev_err_probe(&indio_dev->dev, PTR_ERR(pdata->vdd_io),
-				     "unable to get Vdd_IO supply\n");
-
-	err = regulator_enable(pdata->vdd_io);
-	if (err != 0) {
-		dev_warn(&indio_dev->dev,
-			 "Failed to enable specified Vdd_IO supply\n");
-		return err;
-	}
-
-	return devm_add_action_or_reset(parent, st_reg_disable, pdata->vdd_io);
+	return 0;
 }
 EXPORT_SYMBOL_NS(st_sensors_power_enable, IIO_ST_SENSORS);
 
diff --git a/drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c b/drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c
index ae7bc815382fb..e887b45cdbcd7 100644
--- a/drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c
+++ b/drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c
@@ -18,58 +18,6 @@
 
 #include "st_lsm9ds0.h"
 
-static int st_lsm9ds0_power_enable(struct device *dev, struct st_lsm9ds0 *lsm9ds0)
-{
-	int ret;
-
-	/* Regulators not mandatory, but if requested we should enable them. */
-	lsm9ds0->vdd = devm_regulator_get(dev, "vdd");
-	if (IS_ERR(lsm9ds0->vdd))
-		return dev_err_probe(dev, PTR_ERR(lsm9ds0->vdd),
-				     "unable to get Vdd supply\n");
-
-	ret = regulator_enable(lsm9ds0->vdd);
-	if (ret) {
-		dev_warn(dev, "Failed to enable specified Vdd supply\n");
-		return ret;
-	}
-
-	lsm9ds0->vdd_io = devm_regulator_get(dev, "vddio");
-	if (IS_ERR(lsm9ds0->vdd_io)) {
-		regulator_disable(lsm9ds0->vdd);
-		return dev_err_probe(dev, PTR_ERR(lsm9ds0->vdd_io),
-				     "unable to get Vdd_IO supply\n");
-	}
-	ret = regulator_enable(lsm9ds0->vdd_io);
-	if (ret) {
-		dev_warn(dev, "Failed to enable specified Vdd_IO supply\n");
-		regulator_disable(lsm9ds0->vdd);
-		return ret;
-	}
-
-	return 0;
-}
-
-static void st_lsm9ds0_power_disable(void *data)
-{
-	struct st_lsm9ds0 *lsm9ds0 = data;
-
-	regulator_disable(lsm9ds0->vdd_io);
-	regulator_disable(lsm9ds0->vdd);
-}
-
-static int devm_st_lsm9ds0_power_enable(struct st_lsm9ds0 *lsm9ds0)
-{
-	struct device *dev = lsm9ds0->dev;
-	int ret;
-
-	ret = st_lsm9ds0_power_enable(dev, lsm9ds0);
-	if (ret)
-		return ret;
-
-	return devm_add_action_or_reset(dev, st_lsm9ds0_power_disable, lsm9ds0);
-}
-
 static int st_lsm9ds0_probe_accel(struct st_lsm9ds0 *lsm9ds0, struct regmap *regmap)
 {
 	const struct st_sensor_settings *settings;
@@ -92,8 +40,6 @@ static int st_lsm9ds0_probe_accel(struct st_lsm9ds0 *lsm9ds0, struct regmap *reg
 	data->sensor_settings = (struct st_sensor_settings *)settings;
 	data->irq = lsm9ds0->irq;
 	data->regmap = regmap;
-	data->vdd = lsm9ds0->vdd;
-	data->vdd_io = lsm9ds0->vdd_io;
 
 	return st_accel_common_probe(lsm9ds0->accel);
 }
@@ -120,19 +66,22 @@ static int st_lsm9ds0_probe_magn(struct st_lsm9ds0 *lsm9ds0, struct regmap *regm
 	data->sensor_settings = (struct st_sensor_settings *)settings;
 	data->irq = lsm9ds0->irq;
 	data->regmap = regmap;
-	data->vdd = lsm9ds0->vdd;
-	data->vdd_io = lsm9ds0->vdd_io;
 
 	return st_magn_common_probe(lsm9ds0->magn);
 }
 
 int st_lsm9ds0_probe(struct st_lsm9ds0 *lsm9ds0, struct regmap *regmap)
 {
+	struct device *dev = lsm9ds0->dev;
+	static const char * const regulator_names[] = { "vdd", "vddio" };
 	int ret;
 
-	ret = devm_st_lsm9ds0_power_enable(lsm9ds0);
+	/* Regulators not mandatory, but if requested we should enable them. */
+	ret = devm_regulator_bulk_get_enable(dev, ARRAY_SIZE(regulator_names),
+					     regulator_names);
 	if (ret)
-		return ret;
+		return dev_err_probe(dev, ret,
+				     "unable to enable Vdd supply\n");
 
 	/* Setup accelerometer device */
 	ret = st_lsm9ds0_probe_accel(lsm9ds0, regmap);
diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
index c34e648f07e28..ae8b755955358 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -224,8 +224,6 @@ struct st_sensor_settings {
  * @mount_matrix: The mounting matrix of the sensor.
  * @sensor_settings: Pointer to the specific sensor settings in use.
  * @current_fullscale: Maximum range of measure by the sensor.
- * @vdd: Pointer to sensor's Vdd power supply
- * @vdd_io: Pointer to sensor's Vdd-IO power supply
  * @regmap: Pointer to specific sensor regmap configuration.
  * @enabled: Status of the sensor (false->off, true->on).
  * @odr: Output data rate of the sensor [Hz].
@@ -244,8 +242,6 @@ struct st_sensor_data {
 	struct iio_mount_matrix mount_matrix;
 	struct st_sensor_settings *sensor_settings;
 	struct st_sensor_fullscale_avl *current_fullscale;
-	struct regulator *vdd;
-	struct regulator *vdd_io;
 	struct regmap *regmap;
 
 	bool enabled;
-- 
2.53.0



