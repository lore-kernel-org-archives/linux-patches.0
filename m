Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC444DDB26;
	Thu, 17 Sep 2026 18:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670574; cv=none; b=Nbipsj3MVeQGbFNU7IM/BakHPSIjd6ZbeRzasztk0AlO90UhFiptqW70wDRtY6jUsOSoJ/1+paaq2PYPBitKQMB3WwEuFlaHDMNAVJZB4hkdq5DOLd1fVh6tUrxgPkJ9Dh6MSnnToV8suovrjaXt86V8Czoq3d3EfGS7hSdepwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670574; c=relaxed/simple;
	bh=ZC/kj7jXR9bw+lmigc0cBxhJ59VJQkemfmjGd+7R3/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqY3adxEsaKhy4L1HurbwD3EDYdYbGj+1H5YAuaVeK1+QAb5vcubaEEpjEwyFDKlsdhQkD4rm7CyWarrnbpVNxxtVh9YgWYX8gMNiSTWRPGfPEVLlG3uufEQIX6zA4L6okiyhKhFbRlta+gp+fd6ngLh9m9bhLiE+JVYEG1IUxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXGJepto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXGJepto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2841F000FF;
	Thu, 17 Sep 2026 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670573;
	bh=0eZkdikCHVusf7C5byTIuzN+8Y0x4WVe/B1fgAgKOvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXGJeptoE6Wc2t0s32J+gu0M1DgMRCKlCjb52uQzo6GTDn/Ac9UIt9rVOQIW9koUh
	 I/QZdQ6q835mgMf8AJST9hwyxa6zfsOAwr9NCJQUcBn4giDUGZvHs8v+BGHCCDVKgu
	 ynVUn/8ObDqeygvHADBMaoNfGwD9IbMpXiWiwhMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0705/1102] hwmon: (ina2xx) Parameterize ina2xx_data in ina226_alert_read()
Date: Thu, 17 Sep 2026 16:10:48 +0100
Message-ID: <20260917151558.016203039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c504bb43a2ca3..ad21b67e69ea1 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -506,12 +506,12 @@ static int ina2xx_chip_read(struct device *dev, u32 attr, long *val)
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
 
@@ -546,9 +546,9 @@ static int ina2xx_in_read(struct device *dev, u32 attr, int channel, long *val)
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
@@ -605,7 +605,7 @@ static int ina2xx_power_read(struct device *dev, u32 attr, long *val)
 		return ina226_alert_limit_read(data, INA226_POWER_OVER_LIMIT_MASK,
 					       INA2XX_POWER, val);
 	case hwmon_power_crit_alarm:
-		return ina226_alert_read(data->regmap, INA226_POWER_OVER_LIMIT_MASK, val);
+		return ina226_alert_read(data, INA226_POWER_OVER_LIMIT_MASK, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -647,9 +647,9 @@ static int ina2xx_curr_read(struct device *dev, u32 attr, long *val)
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



