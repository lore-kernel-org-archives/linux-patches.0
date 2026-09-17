Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E94EB86F;
	Thu, 17 Sep 2026 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665848; cv=none; b=M9rqBFSyXLrCCTn1Yjt662EHVDL2ch0LF30/7dWDywzUmPMGIHnV+++60qLihp08SeBrCRIW6QxfpSUhFKjSm+3FKT34K2KMDkvR62e+0HMvchU9m4JLCU5o0PU8vV/qY6Pkyj0jtEFAp322bWJcRDkxxIDEyRIzrGMXioDxlHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665848; c=relaxed/simple;
	bh=2zWBIJ4qPVKylT1JHcbK1hN/3PFSVGXC1npZGb2uoEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu9atoa/cKmI6vJKhFZ9uLTQojM+/k9W37qs77KSiq9SXhdm2if/+qyfZWxb+bTIVcKyh+qpUtsYOB8VoT0dEMpPeMvXzuq1eJL5+TaDb6l38/Gv1slhUEh4g/RxdmPCdO2C5a0ynvXvHETHtHH4ErXzVOgJ4HRXLLNsvM+s+PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvU7yXji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvU7yXji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B071F000FF;
	Thu, 17 Sep 2026 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665847;
	bh=ptldcpVBzna+QR2p0J7Q1ZeKMs+22gi01gKM1HAB16g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvU7yXjiEwAGbxSllJZTAILf/js/TEEwCxbnDcl+tklnRMpngqP3mWz2y6FIdaqC7
	 wKsuGnLAeCShKyVrFx3SYJlOpzoCIisT0lR0oFolLjc4QLhjsVxxUW4Vw0es19GedF
	 /byEh91LsKFvi+j0nhgFSqNhQwCSWZ8xK+jrMCPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0840/1250] hwmon: (ina2xx) Parameterize ina2xx_data in ina226_alert_read()
Date: Thu, 17 Sep 2026 16:10:35 +0100
Message-ID: <20260917151614.719492066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e9fb2a90a11c1..ce4f79745a115 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -499,12 +499,12 @@ static int ina2xx_chip_read(struct device *dev, u32 attr, long *val)
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
 
@@ -539,9 +539,9 @@ static int ina2xx_in_read(struct device *dev, u32 attr, int channel, long *val)
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
@@ -598,7 +598,7 @@ static int ina2xx_power_read(struct device *dev, u32 attr, long *val)
 		return ina226_alert_limit_read(data, INA226_POWER_OVER_LIMIT_MASK,
 					       INA2XX_POWER, val);
 	case hwmon_power_crit_alarm:
-		return ina226_alert_read(data->regmap, INA226_POWER_OVER_LIMIT_MASK, val);
+		return ina226_alert_read(data, INA226_POWER_OVER_LIMIT_MASK, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -640,9 +640,9 @@ static int ina2xx_curr_read(struct device *dev, u32 attr, long *val)
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



