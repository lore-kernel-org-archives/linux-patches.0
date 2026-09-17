Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068D9377563;
	Thu, 17 Sep 2026 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659660; cv=none; b=Le6a+y2o1QRsjPsQkS/t2K29rOS3GaXNTOPX5sZTrFJ+wz9RdrbPzcC5lExZNcsxdiF/rtD0G5OniHgTswRX3SLIPyZzWjOF4CzFQlGFri+AJOfYMOKqhmaZpnx/HetcgjAN4EJ/vw1yJZ4zq+6qpQjhOxzo62gMTGuDcaBZTsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659660; c=relaxed/simple;
	bh=f/luQk1uu73aLr5GtNcJNcOgo/SE7fgMy3S5KTTOQbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+oqFcjUuZ32oIyLKqop4buqStnnHNroe0R80s1aWBWhk+v12SVWBXbkLZ0T/iEuq/9ih3F64E2PoGhT3MI2JWX+FxzRrpY8CNTAaOUEWwt38QfRDTl/DcX5uJPS7y+mQQTLevXpT7SsYCPd9kYtCNpoT+WF1Skvj5czKz1+eBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6oaKRuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6oaKRuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C582F1F000FF;
	Thu, 17 Sep 2026 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659652;
	bh=ytGZx6KAPt+WKPFKeA3YzJ/D6EmLxAuk/jJ5ObtKORQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6oaKRuc8xYlxkm9uVjOJhoaQgsW4PwixtV18EZxInkieIHMnohLil6v6+pwsB4Pr
	 AiW28iV56C7Pmy3xQdusN4/CMnw9cnn1zG3Au9SBC4uwlJvg3bbSzlfMN0Rx8QG44d
	 FC5EBaa9LnYeOJhYvuAeV6KHRelRk6KMaw9FdprM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 326/733] hwmon: (ina2xx) Parameterize ina2xx_data in ina226_alert_read()
Date: Thu, 17 Sep 2026 16:10:34 +0100
Message-ID: <20260917151359.630560498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 3d44ab826e0244a8b9eaf0f1f604f4cb8b890325 ]

Mirror ina226_alert_limit_read/write and use struct ina2xx_data instead
of struct regmap in ina226_alert_read's parameters.

Signed-off-by: Jared Kangas <jkangas@redhat.com>
Link: https://patch.msgid.link/20260820-upstream-ina2xx-in0-curr1-alarms-v2-2-fdce35abc41e@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 35760f5efd7b ("hwmon: (ina2xx) Decouple in0 and curr1 alarms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 8dfe5da13cae5..6175fab8728e0 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -483,12 +483,12 @@ static int ina2xx_chip_read(struct device *dev, u32 attr, long *val)
 	return 0;
 }
 
-static int ina226_alert_read(struct regmap *regmap, u32 mask, long *val)
+static int ina226_alert_read(struct ina2xx_data *data, u32 mask, long *val)
 {
 	unsigned int regval;
 	int ret;
 
-	ret = regmap_read_bypassed(regmap, INA226_MASK_ENABLE, &regval);
+	ret = regmap_read_bypassed(data->regmap, INA226_MASK_ENABLE, &regval);
 	if (ret)
 		return ret;
 
@@ -523,9 +523,9 @@ static int ina2xx_in_read(struct device *dev, u32 attr, int channel, long *val)
 		return ina226_alert_limit_read(data, over_voltage_mask,
 					       voltage_reg, val);
 	case hwmon_in_lcrit_alarm:
-		return ina226_alert_read(regmap, under_voltage_mask, val);
+		return ina226_alert_read(data, under_voltage_mask, val);
 	case hwmon_in_crit_alarm:
-		return ina226_alert_read(regmap, over_voltage_mask, val);
+		return ina226_alert_read(data, over_voltage_mask, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -582,7 +582,7 @@ static int ina2xx_power_read(struct device *dev, u32 attr, long *val)
 		return ina226_alert_limit_read(data, INA226_POWER_OVER_LIMIT_MASK,
 					       INA2XX_POWER, val);
 	case hwmon_power_crit_alarm:
-		return ina226_alert_read(data->regmap, INA226_POWER_OVER_LIMIT_MASK, val);
+		return ina226_alert_read(data, INA226_POWER_OVER_LIMIT_MASK, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -624,9 +624,9 @@ static int ina2xx_curr_read(struct device *dev, u32 attr, long *val)
 		return ina226_alert_limit_read(data, INA226_SHUNT_OVER_VOLTAGE_MASK,
 					       INA2XX_CURRENT, val);
 	case hwmon_curr_lcrit_alarm:
-		return ina226_alert_read(regmap, INA226_SHUNT_UNDER_VOLTAGE_MASK, val);
+		return ina226_alert_read(data, INA226_SHUNT_UNDER_VOLTAGE_MASK, val);
 	case hwmon_curr_crit_alarm:
-		return ina226_alert_read(regmap, INA226_SHUNT_OVER_VOLTAGE_MASK, val);
+		return ina226_alert_read(data, INA226_SHUNT_OVER_VOLTAGE_MASK, val);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.53.0



