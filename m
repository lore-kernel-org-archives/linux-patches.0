Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038837;
	b=wzBD44smsqIXluWWSE2pei031VAI9wzMIXyQ3W7OSMYdGg13hWW79sUHoV2bh2nSuYny
	 34kRf/KFQIcP5cVORa/qR2XSxDRNAqUrxZZ+swWOGuAsKZWvoOZPmgFelJg9ucrYtZ4Ua
	 1Vesgo9AA4Qp7q8T96yOfCVGgdiHxMXvcyLXnDXT38hIIRCeWh0ZuIUimnH6vPVkf0lI4
	 h647PbPgTi46OEqHqR/WTS2TUl1YHtDdK8LcBQ34i7Nk3P0HUNbUD27DOEP8U9Y/+IAA9
	 k1X/xoFN9z2XIKiCSZhyXTbD15Skuo5SuKZf45Oi20Ruv8syksbTGASXpZTTtFE486A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LBX0Y3IDk10Abk9MhzQyh/3CJbjEgqKSo1Fpv68ldag=;
	b=ti+51+LjWiayTXQyD3JrbapV4Vgq8WvTbK5qgBq/+8j7ty5sQnF8+dk4dJW8xgNyXD1j
	 AgPOWtnj5CGQ9MK0RL3gdhp/4Dx85xTHYkpiOai8PXsAiHkDGoi8Ib2Hxqq0uXKYp/xQz
	 UW1uHG1dbTOWbAwJxdzvKSdRXzlWXOzlX0/Okg6uAJ1h45nckNMX60+hjVpya179cna9L
	 Z+vgCoxODXlRdD/f0MntKmtC5wAm4PJodZDIIrhNF5t8xcchAlxGHuowhc7q+QLDEIcFA
	 2UpOwpUNT0KHs690/m6JVVRGtwdBK8878YlVZpN/oExGJhIh0NJBSjFf457A9so/2FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5qUkCiI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD369606A32A;
	Wed, 18 Nov 2026 21:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5qUkCiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6F31F000C4;
	Wed, 18 Nov 2026 21:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038837;
	bh=LBX0Y3IDk10Abk9MhzQyh/3CJbjEgqKSo1Fpv68ldag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5qUkCiI1APBw433EcPNcA1A74/zZ9Thj5LHTXLZsBXVlaiuGtW2/OA/7oEoFB9Rn
	 UcVGvvoXUHHvHdMHiGjJyCe3SQZR7rNnf+5htFeYQWNpz0lRLs3SvQGlUevtNFhDhs
	 N0VAuUUs/P9grtB8DwHLXHcmbRXVnpdkz9QBWGAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1886/3318] hwmon: (pmbus) Check return value from pmbus_thermal_add_sensor()
Date: Wed, 18 Nov 2026 15:41:48 +0100
Message-ID: <20261118150418.572670918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted pmbus_add_sensor() calls for the missing writeonly argument and readonly/writeonly limit-attribute fields ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 42 ++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 5500f1827ae68..973ad91a3368b 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1374,10 +1374,11 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
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
@@ -1401,14 +1402,17 @@ static struct pmbus_sensor *pmbus_add_sensor(struct pmbus_data *data,
 			pmbus_show_sensor, pmbus_set_sensor, -1);
 
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
@@ -1509,8 +1513,8 @@ static int pmbus_add_limit_attrs(struct i2c_client *client,
 						page, 0xff, l->reg, attr->class,
 						attr->update || l->update,
 						false, true);
-			if (!curr)
-				return -ENOMEM;
+			if (IS_ERR(curr))
+				return PTR_ERR(curr);
 			if (l->sbit && (info->func[page] & attr->sfunc)) {
 				ret = pmbus_add_boolean(data, name,
 					l->alarm, index,
@@ -1549,8 +1553,8 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 	}
 	base = pmbus_add_sensor(data, name, "input", index, page, phase,
 				attr->reg, attr->class, true, true, true);
-	if (!base)
-		return -ENOMEM;
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 	/* No limit and alarm attributes for phase specific sensors */
 	if (attr->sfunc && phase == 0xff) {
 		ret = pmbus_add_limit_attrs(client, data, info, name,
@@ -2180,8 +2184,8 @@ static int pmbus_add_fan_ctrl(struct i2c_client *client,
 				  0xff, PMBUS_VIRT_FAN_TARGET_1 + id, PSC_FAN,
 				  false, false, true);
 
-	if (!sensor)
-		return -ENOMEM;
+	if (IS_ERR(sensor))
+		return PTR_ERR(sensor);
 
 	if (!((data->info->func[page] & PMBUS_HAVE_PWM12) ||
 			(data->info->func[page] & PMBUS_HAVE_PWM34)))
@@ -2191,15 +2195,15 @@ static int pmbus_add_fan_ctrl(struct i2c_client *client,
 				  0xff, PMBUS_VIRT_PWM_1 + id, PSC_PWM,
 				  false, false, true);
 
-	if (!sensor)
-		return -ENOMEM;
+	if (IS_ERR(sensor))
+		return PTR_ERR(sensor);
 
 	sensor = pmbus_add_sensor(data, "pwm", "enable", index, page,
 				  0xff, PMBUS_VIRT_PWM_ENABLE_1 + id, PSC_PWM,
 				  true, false, false);
 
-	if (!sensor)
-		return -ENOMEM;
+	if (IS_ERR(sensor))
+		return PTR_ERR(sensor);
 
 	return 0;
 }
@@ -2216,6 +2220,7 @@ static int pmbus_add_fan_attributes(struct i2c_client *client,
 		int f;
 
 		for (f = 0; f < ARRAY_SIZE(pmbus_fan_registers); f++) {
+			struct pmbus_sensor *sensor;
 			int regval;
 
 			if (!(info->func[page] & pmbus_fan_flags[f]))
@@ -2236,10 +2241,11 @@ static int pmbus_add_fan_attributes(struct i2c_client *client,
 			    (!(regval & (PB_FAN_1_INSTALLED >> ((f & 1) * 4)))))
 				continue;
 
-			if (pmbus_add_sensor(data, "fan", "input", index,
-					     page, 0xff, pmbus_fan_registers[f],
-					     PSC_FAN, true, true, true) == NULL)
-				return -ENOMEM;
+			sensor = pmbus_add_sensor(data, "fan", "input", index,
+						  page, 0xff, pmbus_fan_registers[f],
+						  PSC_FAN, true, true, true);
+			if (IS_ERR(sensor))
+				return PTR_ERR(sensor);
 
 			/* Fan control */
 			if (pmbus_check_word_register(client, page,
-- 
2.53.0



