Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA433AD50F;
	Fri,  7 Aug 2026 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113881; cv=none; b=kc9lB1SCZYQnvJNvWl94yYfKJoMAyhtuXTwYzxz/VW0GuDnx6voIrD6oktVZ6AbhCLYSsZlsrlnK9Q4jhvnVmwoIAeEubfXWOHc+FkTVdRVxuxX+AXEaLkGP7Nvp1Hp4GQTvteenbACD2uL8XxYf8hNG9K+pXkdMkSZjIn6CMK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113881; c=relaxed/simple;
	bh=rzxBNk7zrNu4rdzhn36OK+zv+d3k7SsEhXmk6neF9/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NzH4lkZJWFnXswTrMROgH+VbHq95sIdqzzlMq8SKFZRqQyCt7AiOhXOTJV96+ezr1yUrq3LH5h+49aAX/98b5EChJ4rRV7mPGkeaOu/WpvgBu8MZs/GmiqX2lcmtQC/79XUgsWAOLG3O+rNQKjru3Jzv7K5TuvGW5GYkCaeo0PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPR5dRBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPR5dRBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E2E1F00ACA;
	Fri,  7 Aug 2026 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113874;
	bh=AUVgOMRxh9YgJ8jjWdFui4fIZgv4No2OWB8Qv99MbuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPR5dRBCl7f0ucMfHbBc7uub3Nyy9+LzrTA2y9xi54mi/Y3bQex7UnI5W9s2qySO6
	 EXcMO5JpsMae2dKJKqv4ZHBOFdz212Sf/DqBAlkUGPF5GudAUysnQgz5un68qNEHt3
	 BJm+F7UUrGsYjR6HwB94EzCWjzP345yrlu43Mwfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jens Almer <bagawk@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>
Subject: [PATCH 6.12 064/337] hwmon: (ina2xx) Make it easier to add more devices
Date: Fri,  7 Aug 2026 16:34:27 +0200
Message-ID: <20260807143419.900134832@linuxfoundation.org>
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

[ Upstream commit f6e14b5bcabf4ee97a2d535c3c2d7e72c8da4c15 ]

* Make sysfs entries documentation easier to maintain.
* Use multi-line enum.
* Correct "has_power_average" comment.

Create a new "has_update_interval" member for chips which support
averaging.

Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Reviewed-by: Bence Csókás <bence98@sch.bme.hu> # v2
Tested-by: Jens Almer <bagawk@gmail.com>
Link: https://lore.kernel.org/r/20260220112024.97446-3-ian.ray@gehealthcare.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: e6c80061ca23 ("hwmon: (ina2xx) Fix various overflow issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/ina2xx.rst | 12 ++++++++++--
 drivers/hwmon/ina2xx.c         | 18 ++++++++++++++----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/ina2xx.rst b/Documentation/hwmon/ina2xx.rst
index a3860aae444c0..a4ddf4bd2b081 100644
--- a/Documentation/hwmon/ina2xx.rst
+++ b/Documentation/hwmon/ina2xx.rst
@@ -124,8 +124,16 @@ power1_input		Power(uW) measurement channel
 shunt_resistor		Shunt resistance(uOhm) channel (not for ina260)
 ======================= ===============================================
 
-Additional sysfs entries for ina226, ina230, ina231, ina260, and sy24655
-------------------------------------------------------------------------
+Additional sysfs entries
+------------------------
+
+Additional entries are available for the following chips:
+
+  * ina226
+  * ina230
+  * ina231
+  * ina260
+  * sy24655
 
 ======================= ====================================================
 curr1_lcrit		Critical low current
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 345fe7db9de94..97ec0e0218307 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -135,13 +135,19 @@ static const struct regmap_config ina2xx_regmap_config = {
 	.writeable_reg = ina2xx_writeable_reg,
 };
 
-enum ina2xx_ids { ina219, ina226, ina260, sy24655 };
+enum ina2xx_ids {
+	ina219,
+	ina226,
+	ina260,
+	sy24655
+};
 
 struct ina2xx_config {
 	u16 config_default;
 	bool has_alerts;	/* chip supports alerts and limits */
 	bool has_ishunt;	/* chip has internal shunt resistor */
-	bool has_power_average;	/* chip has internal shunt resistor */
+	bool has_power_average;	/* chip supports average power */
+	bool has_update_interval;
 	int calibration_value;
 	int shunt_div;
 	int bus_voltage_shift;
@@ -172,6 +178,7 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.has_alerts = false,
 		.has_ishunt = false,
 		.has_power_average = false,
+		.has_update_interval = false,
 	},
 	[ina226] = {
 		.config_default = INA226_CONFIG_DEFAULT,
@@ -183,6 +190,7 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.has_alerts = true,
 		.has_ishunt = false,
 		.has_power_average = false,
+		.has_update_interval = true,
 	},
 	[ina260] = {
 		.config_default = INA260_CONFIG_DEFAULT,
@@ -193,6 +201,7 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.has_alerts = true,
 		.has_ishunt = true,
 		.has_power_average = false,
+		.has_update_interval = true,
 	},
 	[sy24655] = {
 		.config_default = SY24655_CONFIG_DEFAULT,
@@ -204,6 +213,7 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.has_alerts = true,
 		.has_ishunt = false,
 		.has_power_average = true,
+		.has_update_interval = false,
 	},
 };
 
@@ -713,7 +723,7 @@ static umode_t ina2xx_is_visible(const void *_data, enum hwmon_sensor_types type
 	const struct ina2xx_data *data = _data;
 	bool has_alerts = data->config->has_alerts;
 	bool has_power_average = data->config->has_power_average;
-	enum ina2xx_ids chip = data->chip;
+	bool has_update_interval = data->config->has_update_interval;
 
 	switch (type) {
 	case hwmon_in:
@@ -775,7 +785,7 @@ static umode_t ina2xx_is_visible(const void *_data, enum hwmon_sensor_types type
 	case hwmon_chip:
 		switch (attr) {
 		case hwmon_chip_update_interval:
-			if (chip == ina226 || chip == ina260)
+			if (has_update_interval)
 				return 0644;
 			break;
 		default:
-- 
2.53.0



