Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0127E0FF;
	Mon, 23 Dec 2024 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970428; cv=none; b=IrnbIPJMSFAkAz85uOZwkoeT/sVYGy/NafA001Lm7sc8muDn0jHTtVfTJe/pkdI8lsDNbkm24yhkAXOKY5u68QfGJjTGJsJEm0VGzBO+FZLR6u1Gqh/gWuR1AExv6bhsNeW/l2xnqMoMRS6mfxpM+oslIEReGldR8HaVe16CPHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970428; c=relaxed/simple;
	bh=izyDHb1AShgHGkgvwExNYmmbCYEXSFQ5H2cuaxFJ3so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+dUJkttmZUKjWXWnSEHgbZWDPcvTjY0I6bB8AbbBwYLJ37HFiz8E0L4tFLjiHv3W2uxvvV0EP1EHnI8mZbvDSHBXW5ZEYHQYUZVof+Oj3CA3waMNN8ZcdwC5eO+RUwY1U1DEszjeeXEfNGECP7rjA6vcFHKVcmJSgKpEvniN6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acFg/A5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acFg/A5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918FBC4CED3;
	Mon, 23 Dec 2024 16:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970428;
	bh=izyDHb1AShgHGkgvwExNYmmbCYEXSFQ5H2cuaxFJ3so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acFg/A5i4muB46/gfZd9i7TfytY8MZhLoL8HOIJH17ZdaVloSwyJoLgfDtCiBM/l8
	 EXAFpnSK4to7zACkY93pN7YmEDAGzUClcY4iGJcp+EbSOifHekJh6gfqQfXYLTChGI
	 UKA+vR/C7si7bi2C8ckpOuUg6KyawYx2shk68G4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/116] hwmon: (tmp513) Use SI constants from units.h
Date: Mon, 23 Dec 2024 16:59:11 +0100
Message-ID: <20241223155402.720375566@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f07f9d2467f4a298d24e186ddee6f69724903067 ]

MILLI and MICRO may be used in the driver to make code more robust
against possible miscalculations.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231128180654.395692-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 74d7e038fd07 ("hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 67b13ac5512c..1e50ac680378 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -32,6 +32,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/units.h>
 
 // Common register definition
 #define TMP51X_SHUNT_CONFIG		0x00
@@ -104,8 +105,8 @@
 #define TMP51X_REMOTE_TEMP_LIMIT_2_POS		8
 #define TMP513_REMOTE_TEMP_LIMIT_3_POS		7
 
-#define TMP51X_VBUS_RANGE_32V		32000000
-#define TMP51X_VBUS_RANGE_16V		16000000
+#define TMP51X_VBUS_RANGE_32V		(32 * MICRO)
+#define TMP51X_VBUS_RANGE_16V		(16 * MICRO)
 
 // Max and Min value
 #define MAX_BUS_VOLTAGE_32_LIMIT	32764
@@ -200,7 +201,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 		 * on the pga gain setting. 1lsb = 10uV
 		 */
 		*val = sign_extend32(regval, 17 - tmp51x_get_pga_shift(data));
-		*val = DIV_ROUND_CLOSEST(*val * 10000, data->shunt_uohms);
+		*val = DIV_ROUND_CLOSEST(*val * 10 * MILLI, data->shunt_uohms);
 		break;
 	case TMP51X_BUS_VOLTAGE_RESULT:
 	case TMP51X_BUS_VOLTAGE_H_LIMIT:
@@ -216,7 +217,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 	case TMP51X_BUS_CURRENT_RESULT:
 		// Current = (ShuntVoltage * CalibrationRegister) / 4096
 		*val = sign_extend32(regval, 16) * data->curr_lsb_ua;
-		*val = DIV_ROUND_CLOSEST(*val, 1000);
+		*val = DIV_ROUND_CLOSEST(*val, MILLI);
 		break;
 	case TMP51X_LOCAL_TEMP_RESULT:
 	case TMP51X_REMOTE_TEMP_RESULT_1:
@@ -256,7 +257,7 @@ static int tmp51x_set_value(struct tmp51x_data *data, u8 reg, long val)
 		 * The user enter current value and we convert it to
 		 * voltage. 1lsb = 10uV
 		 */
-		val = DIV_ROUND_CLOSEST(val * data->shunt_uohms, 10000);
+		val = DIV_ROUND_CLOSEST(val * data->shunt_uohms, 10 * MILLI);
 		max_val = U16_MAX >> tmp51x_get_pga_shift(data);
 		regval = clamp_val(val, -max_val, max_val);
 		break;
@@ -546,18 +547,16 @@ static int tmp51x_calibrate(struct tmp51x_data *data)
 	if (data->shunt_uohms == 0)
 		return regmap_write(data->regmap, TMP51X_SHUNT_CALIBRATION, 0);
 
-	max_curr_ma = DIV_ROUND_CLOSEST_ULL(vshunt_max * 1000 * 1000,
-					    data->shunt_uohms);
+	max_curr_ma = DIV_ROUND_CLOSEST_ULL(vshunt_max * MICRO, data->shunt_uohms);
 
 	/*
 	 * Calculate the minimal bit resolution for the current and the power.
 	 * Those values will be used during register interpretation.
 	 */
-	data->curr_lsb_ua = DIV_ROUND_CLOSEST_ULL(max_curr_ma * 1000, 32767);
+	data->curr_lsb_ua = DIV_ROUND_CLOSEST_ULL(max_curr_ma * MILLI, 32767);
 	data->pwr_lsb_uw = 20 * data->curr_lsb_ua;
 
-	div = DIV_ROUND_CLOSEST_ULL(data->curr_lsb_ua * data->shunt_uohms,
-				    1000 * 1000);
+	div = DIV_ROUND_CLOSEST_ULL(data->curr_lsb_ua * data->shunt_uohms, MICRO);
 
 	return regmap_write(data->regmap, TMP51X_SHUNT_CALIBRATION,
 			    DIV_ROUND_CLOSEST(40960, div));
@@ -683,7 +682,7 @@ static int tmp51x_read_properties(struct device *dev, struct tmp51x_data *data)
 		memcpy(data->nfactor, nfactor, (data->id == tmp513) ? 3 : 2);
 
 	// Check if shunt value is compatible with pga-gain
-	if (data->shunt_uohms > data->pga_gain * 40 * 1000 * 1000) {
+	if (data->shunt_uohms > data->pga_gain * 40 * MICRO) {
 		return dev_err_probe(dev, -EINVAL,
 				     "shunt-resistor: %u too big for pga_gain: %u\n",
 				     data->shunt_uohms, data->pga_gain);
-- 
2.39.5



