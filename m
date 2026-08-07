Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484BA385D86;
	Fri,  7 Aug 2026 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113884; cv=none; b=ViCl3hD45PhIl0vz0kvk9T+q2X0rWK9NbZ61cipQvU85rpVu368gJGXlduolHqTfgR06yOETbLjHUIoxrtnF2aip8sYQc3wXGb/lvN5TlHO3IbUDAZ7fElAn/F8+GrX1+2hRwRVbqsdOr5a4tcF9QRkrdyWevOZAleQagtlj/xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113884; c=relaxed/simple;
	bh=oRpNXkeBghZkTQo9BQhv/z0Thz2t9pRkyTekKwlASYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4NZ4gZ7X8fxu6hWSMA7KZP40ujhJspeRk/xAetz4BAKQmF2do9ApInTkWjCEaBZ8U1d8Vq7ynqSScBdsmgaS6kPVT67bz8NvziYqgJodUyJUBNv0PmTaOPh0JWiE+4tsIIRUaEha9adi3l0OglTWJ1tcIam8J/meUosCEXZaJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRNXpUm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRNXpUm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB371F00A3D;
	Fri,  7 Aug 2026 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113877;
	bh=IHAnmiib5WgPkRYFQBtfpzFkApHF15SoY1on+fqqyOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRNXpUm6AV+CcQGs2Uol78HSOc4HkwYaUuS0n7K50rX0/BC5yPErRwHgNo28LUZW0
	 xoFlZBA1ABGeygp8nCfz2sNvAqvxOzCaAU9YiEcpX7Q7s8Fo4I1xzEAmKcRIte5iPR
	 iUvtWufN+vhPKFMjUgc4UCnWeYBZMdcPjC8zz+2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jens Almer <bagawk@gmail.com>,
	Jonas Rebmann <jre@pengutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>
Subject: [PATCH 6.12 065/337] hwmon: (ina2xx) Add support for INA234
Date: Fri,  7 Aug 2026 16:34:28 +0200
Message-ID: <20260807143419.921997115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit 88a928eebccdc5445d874ddcbf1683b76c9f1431 ]

INA234 is register compatible to INA226 (excepting manufacturer and die
or device id registers) but has different scaling.

Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Reviewed-by: Bence Csókás <bence98@sch.bme.hu> # v2
Tested-by: Jens Almer <bagawk@gmail.com>
Tested-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://lore.kernel.org/r/20260220112024.97446-4-ian.ray@gehealthcare.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: e6c80061ca23 ("hwmon: (ina2xx) Fix various overflow issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/ina2xx.rst | 13 ++++++++++++-
 drivers/hwmon/Kconfig          |  2 +-
 drivers/hwmon/ina2xx.c         | 18 ++++++++++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/hwmon/ina2xx.rst b/Documentation/hwmon/ina2xx.rst
index a4ddf4bd2b081..d64e7af46a124 100644
--- a/Documentation/hwmon/ina2xx.rst
+++ b/Documentation/hwmon/ina2xx.rst
@@ -74,6 +74,16 @@ Supported chips:
 	       https://us1.silergy.com/
 
 
+  * Texas Instruments INA234
+
+    Prefix: 'ina234'
+
+    Addresses: I2C 0x40 - 0x43
+
+    Datasheet: Publicly available at the Texas Instruments website
+
+	       https://www.ti.com/
+
 Author: Lothar Felten <lothar.felten@gmail.com>
 
 Description
@@ -89,7 +99,7 @@ interface. The INA220 monitors both shunt drop and supply voltage.
 The INA226 is a current shunt and power monitor with an I2C interface.
 The INA226 monitors both a shunt voltage drop and bus supply voltage.
 
-INA230 and INA231 are high or low side current shunt and power monitors
+INA230, INA231, and INA234 are high or low side current shunt and power monitors
 with an I2C interface. The chips monitor both a shunt voltage drop and
 bus supply voltage.
 
@@ -132,6 +142,7 @@ Additional entries are available for the following chips:
   * ina226
   * ina230
   * ina231
+  * ina234
   * ina260
   * sy24655
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 195c7b505a853..848b9cfcb1d87 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -2170,7 +2170,7 @@ config SENSORS_INA2XX
 	select REGMAP_I2C
 	help
 	  If you say yes here you get support for INA219, INA220, INA226,
-	  INA230, INA231, INA260, and SY24655 power monitor chips.
+	  INA230, INA231, INA234, INA260, and SY24655 power monitor chips.
 
 	  The INA2xx driver is configured for the default configuration of
 	  the part as described in the datasheet.
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 97ec0e0218307..be6e214fae21f 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -138,6 +138,7 @@ static const struct regmap_config ina2xx_regmap_config = {
 enum ina2xx_ids {
 	ina219,
 	ina226,
+	ina234,
 	ina260,
 	sy24655
 };
@@ -192,6 +193,18 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.has_power_average = false,
 		.has_update_interval = true,
 	},
+	[ina234] = {
+		.config_default = INA226_CONFIG_DEFAULT,
+		.calibration_value = 2048,
+		.shunt_div = 400, /* 2.5 µV/LSB raw ADC reading from INA2XX_SHUNT_VOLTAGE */
+		.bus_voltage_shift = 4,
+		.bus_voltage_lsb = 25600,
+		.power_lsb_factor = 32,
+		.has_alerts = true,
+		.has_ishunt = false,
+		.has_power_average = false,
+		.has_update_interval = true,
+	},
 	[ina260] = {
 		.config_default = INA260_CONFIG_DEFAULT,
 		.shunt_div = 400,
@@ -996,6 +1009,7 @@ static const struct i2c_device_id ina2xx_id[] = {
 	{ "ina226", ina226 },
 	{ "ina230", ina226 },
 	{ "ina231", ina226 },
+	{ "ina234", ina234 },
 	{ "ina260", ina260 },
 	{ "sy24655", sy24655 },
 	{ }
@@ -1027,6 +1041,10 @@ static const struct of_device_id __maybe_unused ina2xx_of_match[] = {
 		.compatible = "ti,ina231",
 		.data = (void *)ina226
 	},
+	{
+		.compatible = "ti,ina234",
+		.data = (void *)ina234
+	},
 	{
 		.compatible = "ti,ina260",
 		.data = (void *)ina260
-- 
2.53.0



