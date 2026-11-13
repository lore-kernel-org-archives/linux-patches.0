Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590300;
	b=VftZmsy/AV8Yhc/9eKBXjn1PyUK3DdinzJWUlZrt6cyNaDja7xITHcJm2MddOPeIdshS
	 L81mo4gsUZIGE2Iff0vO9kMhNMGEDMmoneDUdJC3aTjLIKfh+8Rixj3Aj1fVHEDxSP7RK
	 eDncnvdN1ufaOjsz/MyV4l2NmSF0chBGIkOW2LLIGP3fpuWDpi74LWlpAhyP3DfS/LDm0
	 ZAC5CZ75RgsmV2PewUt8ZU3ZA2g29maDbbX4Uc7mpQI+Ffwnsf+tEB0ryTEApXu+cMcK4
	 pG98PwdFQ0Q8SLkkBTkeLfv9kqWT2tG3pjOn2dFR73Vcz3dchQrwo3TO8GLYR6y/cxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGh5/F+xw3kllEbMoAlmt85A6JOrVZoW03DgCMhODAQ=;
	b=ogTtAH3QoxMvCbxNhDd10N4frk7x5h/bqp5D5dNXD6hty07eYipfLFwRgPK6Y/pDOmiD
	 EN+xxjopW6AMV8W8UM7g2AEAai8zwfNx09PPHpUkP17l1/ezNb32FX8ZDf6xLdCWc7sqg
	 Ln0VqsXejpKohdCzCLqn94pAzXHv2kt6lwUmGTby8cYXj96t4jiUD3Tt/frfaX5GcwAxG
	 DprRhkSKgZAqRDPU3BkwFrn1+EabPrBB+I3yRyjvzeRDyAogj5oJSz4OEtRuU1+0jz0lA
	 C6yQR2o6S+qWMBCPaIgMBT3oOe/5wU8H6+D1T/7prpSa5dK//0wHuZwTsYL21ElKERg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ySyL4xY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B0A60A3809;
	Fri, 13 Nov 2026 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ySyL4xY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E751F000C4;
	Fri, 13 Nov 2026 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590299;
	bh=gGh5/F+xw3kllEbMoAlmt85A6JOrVZoW03DgCMhODAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySyL4xY4t0v9A3guTWTOpiVAePHCv7dNheXXZeunpK+d4J7wuJGjY82/4PW82+CTa
	 WPM8twRPW2hvYg+2AUMOSYCf/Awn60xcjvhFstxpzeNMbgoQ1+MODr9YL47GlJnQan
	 FOLXbJO/g6Rt95/vne9EdjhJVQf/ZpzLDkT+qFC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/686] hwmon: (pmbus) Check return value from pmbus_thermal_add_sensor()
Date: Fri, 13 Nov 2026 10:47:00 -0500
Message-ID: <20261113153830.709757570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 11dfbd835b17b75f7cc7a4a969f33ff702b1b081 ]

During PMBus device probe, if registering a temperature sensor with the
thermal subsystem fails, pmbus_add_sensor() silently ignores the error and
returns success.
When a valid temperature sensor is detected (class PSC_TEMPERATURE and type
"input"), pmbus_add_sensor() invokes pmbus_thermal_add_sensor() to hook it
into the kernel's thermal framework. However, the return value of this call
is completely discarded. If thermal registration fails, such as from an
-ENOMEM allocation failure or an invalid device tree configuration like a
malformed #thermal-sensor-cells property, no error is propagated.

Because the hardware monitor probe falsely succeeds despite the failure to
register the thermal zone, the system is left without thermal mitigation
for the affected PMBus device. This silently blinds the system to actual
PMIC temperatures, preventing the execution of necessary cooling mechanisms
or emergency shutdowns and risking localized overheating.

Pass the return value from pmbus_thermal_add_sensor() to the calling code
to fix the problem. To enable passing the actual error, change the error
return from pmbus_add_sensor() from NULL to ERR_PTR() and extract the error
from in the calling code.

Fixes: 3aa74796cfd0 ("hwmon: (pmbus) Register with thermal for PSC_TEMPERATURE")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 42 ++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index aa578d2723f22..08702ee8105f4 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1420,10 +1420,11 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 {
 	struct sensor_device_attribute *a;
 	struct pmbus_sensor *sensor;
+	int err;
 
 	sensor = devm_kzalloc(data->dev, sizeof(*sensor), GFP_KERNEL);
 	if (!sensor)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	a = &sensor->attribute;
 
 	if (type)
@@ -1448,14 +1449,17 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 			pmbus_set_sensor, -1);
 
 	if (pmbus_add_attribute(data, &a->dev_attr.attr))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	sensor->next = data->sensors;
 	data->sensors = sensor;
 
 	/* temperature sensors with _input values are registered with thermal */
-	if (class == PSC_TEMPERATURE && strcmp(type, "input") == 0)
-		pmbus_thermal_add_sensor(data, sensor, seq);
+	if (class == PSC_TEMPERATURE && strcmp(type, "input") == 0) {
+		err = pmbus_thermal_add_sensor(data, sensor, seq);
+		if (err)
+			return ERR_PTR(err);
+	}
 
 	return sensor;
 }
@@ -1556,8 +1560,8 @@ static int pmbus_add_limit_attrs(struct i2c_client *client,
 						page, 0xff, l->reg, attr->class,
 						attr->update || l->update,
 						l->readonly, l->writeonly, true);
-			if (!curr)
-				return -ENOMEM;
+			if (IS_ERR(curr))
+				return PTR_ERR(curr);
 			if (l->sbit && (info->func[page] & attr->sfunc)) {
 				ret = pmbus_add_boolean(data, name,
 					l->alarm, index,
@@ -1596,8 +1600,8 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 	}
 	base = pmbus_add_sensor(data, name, "input", index, page, phase,
 				attr->reg, attr->class, true, true, false, true);
-	if (!base)
-		return -ENOMEM;
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 	/* No limit and alarm attributes for phase specific sensors */
 	if (attr->sfunc && phase == 0xff) {
 		ret = pmbus_add_limit_attrs(client, data, info, name,
@@ -2270,8 +2274,8 @@ static int pmbus_add_fan_ctrl(struct i2c_client *client,
 				  0xff, PMBUS_VIRT_FAN_TARGET_1 + id, PSC_FAN,
 				  false, false, false, true);
 
-	if (!sensor)
-		return -ENOMEM;
+	if (IS_ERR(sensor))
+		return PTR_ERR(sensor);
 
 	if (!((data->info->func[page] & PMBUS_HAVE_PWM12) ||
 	      (data->info->func[page] & PMBUS_HAVE_PWM34)))
@@ -2281,15 +2285,15 @@ static int pmbus_add_fan_ctrl(struct i2c_client *client,
 				  0xff, PMBUS_VIRT_PWM_1 + id, PSC_PWM,
 				  false, false, false, true);
 
-	if (!sensor)
-		return -ENOMEM;
+	if (IS_ERR(sensor))
+		return PTR_ERR(sensor);
 
 	sensor = pmbus_add_sensor(data, "pwm", "enable", index, page,
 				  0xff, PMBUS_VIRT_PWM_ENABLE_1 + id, PSC_PWM,
 				  true, false, false, false);
 
-	if (!sensor)
-		return -ENOMEM;
+	if (IS_ERR(sensor))
+		return PTR_ERR(sensor);
 
 	return 0;
 }
@@ -2306,6 +2310,7 @@ static int pmbus_add_fan_attributes(struct i2c_client *client,
 		int f;
 
 		for (f = 0; f < ARRAY_SIZE(pmbus_fan_registers); f++) {
+			struct pmbus_sensor *sensor;
 			int regval;
 
 			if (!(info->func[page] & pmbus_fan_flags[f]))
@@ -2326,10 +2331,11 @@ static int pmbus_add_fan_attributes(struct i2c_client *client,
 			    (!(regval & (PB_FAN_1_INSTALLED >> ((f & 1) * 4)))))
 				continue;
 
-			if (pmbus_add_sensor(data, "fan", "input", index,
-					     page, 0xff, pmbus_fan_registers[f],
-					     PSC_FAN, true, true, false, true) == NULL)
-				return -ENOMEM;
+			sensor = pmbus_add_sensor(data, "fan", "input", index,
+						  page, 0xff, pmbus_fan_registers[f],
+						  PSC_FAN, true, true, false, true);
+			if (IS_ERR(sensor))
+				return PTR_ERR(sensor);
 
 			/* Fan control */
 			if (pmbus_check_word_register(client, page,
-- 
2.53.0



