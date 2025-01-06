Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA6E1369B4;
	Mon,  6 Jan 2025 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178702; cv=none; b=gtY4mURuMNvyRftGf5hmVokSByLr7hy/IKPqqng4WvhqpoY2L9VPt2MBT/y8Z0egrLHCBQsk6t4czumqGQvp8iT1IKKkJwywvyNF0VL1lHzHEpW6q4lfZHDmIvSHOSkjCMC4Dkh2vxgJh3cd1VfMQsCDWKZxZNG+CwHPb8vmBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178702; c=relaxed/simple;
	bh=li+DC6fj0PD1oEj6AqUBtVb3hqZesOkdcP77xDImVKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSSVOfB8y2ENJMW7hc9dKMjcUELq7PhUxcwqr3KwJxT1glBZhdPdR1NDKAW8WL08zXrz+xtmrzwojqZg49z284HlHVCgSH/Bc+nf6upz04QHbX69yt/AMg++hjgT975rgEamBvMz9l8YCP16gygcI2WHOtZ0EIwACC28IQnYrcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fujBf1oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fujBf1oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEB3C4CED2;
	Mon,  6 Jan 2025 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178702;
	bh=li+DC6fj0PD1oEj6AqUBtVb3hqZesOkdcP77xDImVKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fujBf1oq69Xkx/pKMUeVwU/aSL2bSgyEBUEX5JsvO9ZJLop1Ro4ApmaeW+ejks7WB
	 6OrX3Q6bUrXQWM5Buu6ZBiwEhj4ge1m1zed3galUPdmB8hcZNPHvVfs1QqYMVRy5P+
	 MGyxG+VI+l6z6HB3n+X3f97OFy2dSXK5cb4bnfAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/168] hwmon: (tmp513) Use SI constants from units.h
Date: Mon,  6 Jan 2025 16:15:44 +0100
Message-ID: <20250106151139.827365975@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 53525d3a32a0..589982c92190 100644
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



