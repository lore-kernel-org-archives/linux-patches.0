Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037787;
	b=oTyrzkoy41DM3blf5LaUgscSNPv57w/oD3VyNxeWp33cd6FhM7Ouqd5llT/abScvrtYK
	 f1ASNcx5Thln3+DzP5xZDPEdyW36Qnc6HNexDOd2nyBuZ7L7nBxjlCPXlWfXJ+lTbliVR
	 sDNI/zVW80Yfzro2sKm3HcwhXJ/+aFDvUI3HxPZuBsA4N9Jpnhu1HWZdJxr2VaTrO1i4p
	 KLUEbWzy9iGhnw6+VBbmIy1tsRx7znN1E9XU8LC2Pn5rAgpvCOm9HVOCsM6iwv/KmFSrN
	 k3X+GJk5WZvkV4rJ6CTWXRrzGAY957UlOqOgdRpY6QhMvlt+5UQh69Rnxk7oHfWkZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CeGB8UZBWz/2VGFOa7cxBbw9NOx8ECV6oDBF+MFhxaU=;
	b=FegengxztaPBu3QEz6CALm5sZxfOESH2qmMUWC5/lFpL3NUO8bZOYMFXJkzgslMyULkD
	 nwLxzoQWNnuNCSJb4uLDxY+J6N8GCyrl4UhiB60w88VyvI6ZA57PBzgZl+YsWFNmWnwKp
	 dXpfdOmGJ8DHNhRs3u2nP64kEGxQ82uVRZWN6aW4NCG6G8ZlU39YhwolwZN/Iuqo/lbyP
	 t0FNWSm67+/ABP1RSctH9I81tNqBJ0c5MsVA3aB2aQpp+BDidh8hFDkRGJbnVC3Uf+OLg
	 GYlLOOIBcLfZfBRwmKqBuqZk3at3wfrdyKvvB5gaE6AVs6M7hLcldxLjbxwALCtO3kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bU5zQAEI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1486606A325;
	Wed, 18 Nov 2026 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bU5zQAEI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8395B1F000C4;
	Wed, 18 Nov 2026 21:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037786;
	bh=CeGB8UZBWz/2VGFOa7cxBbw9NOx8ECV6oDBF+MFhxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bU5zQAEI+h6rein3EtlM3qSFYIv08eGflhrIBTQm3+7vwkeMyyKVpvocqnppnnxdB
	 U12lQx+N9wyQqL9S0XiaSQjS+0O29RUuteD+4tzLYWdpCR1kkNX2PqR3X6T6anWUcf
	 4941v+MRqp4GQdXZFoLN3nCBXHeIiT+xS3zgRsRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vas Zayarskiy <contact@vasily.cc>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1467/3318] hwmon: (aquacomputer_d5next) Avoid truncating scaled sensor readings
Date: Wed, 18 Nov 2026 15:34:49 +0100
Message-ID: <20261118150404.900982678@linuxfoundation.org>
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

From: Vas Zayarskiy <contact@vasily.cc>

[ Upstream commit c221091f7e30c64280e4cbfa27dc4c05edc96d0c ]

High Flow Next power is reported in watts. Multiplying the 16-bit value
by one million can overflow both the signed intermediate and the u32
cache. Store power in long, perform the conversion in u64, and clamp to
LONG_MAX. The other existing power conversions fit in a signed 32-bit
value. Return -ENODATA for unavailable power instead of exposing the
stored error as a reading.

The power cache is updated by HID reports without the hwmon read mutex.
Read it once with READ_ONCE() and use that snapshot for both the
availability check and the returned value. Mark the corresponding
updates with WRITE_ONCE() so that the shared accesses are explicit.

Widen the shared current cache to u32. The Aquastream XT conversion to
milliamperes can exceed 65535 mA; clamp its negative conversion results
to zero before assigning to the unsigned cache. This also permits devices
with scaled aggregate currents to store milliamperes directly.

Fixes: aed80bb91de8 ("hwmon: (aquacomputer_d5next) Add support for Aquacomputer High Flow Next")
Cc: stable@vger.kernel.org
Signed-off-by: Vas Zayarskiy <contact@vasily.cc>
Link: https://patch.msgid.link/20260927191316.4137752-2-contact@vasily.cc
[groeck: Dropped obsolete 'Assisted-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index e9207cd6063ee..6efbe94110a80 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -18,6 +18,7 @@
 #include <linux/hwmon.h>
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
@@ -571,9 +572,9 @@ struct aqc_data {
 	u32 speed_input_min[1];
 	u32 speed_input_target[1];
 	u32 speed_input_max[1];
-	u32 power_input[8];
+	long power_input[8];
 	u16 voltage_input[8];
-	u16 current_input[8];
+	u32 current_input[8];
 
 	/* Label values */
 	const char *const *temp_label;
@@ -954,7 +955,7 @@ static int aqc_legacy_read(struct aqc_data *priv)
 
 		/* Calculation derived from linear regression */
 		sensor_value = get_unaligned_le16(priv->buffer + AQUASTREAMXT_PUMP_CURR_OFFSET);
-		priv->current_input[0] = DIV_ROUND_CLOSEST(sensor_value * 176, 100) - 52;
+		priv->current_input[0] = max(DIV_ROUND_CLOSEST(sensor_value * 176, 100) - 52, 0);
 
 		sensor_value = get_unaligned_le16(priv->buffer + AQUASTREAMXT_PUMP_VOLTAGE_OFFSET);
 		priv->voltage_input[0] = DIV_ROUND_CLOSEST(sensor_value * 1000, 61);
@@ -976,6 +977,7 @@ static int aqc_legacy_read(struct aqc_data *priv)
 static int aqc_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		    int channel, long *val)
 {
+	long power;
 	int ret;
 	struct aqc_data *priv = dev_get_drvdata(dev);
 
@@ -1040,7 +1042,10 @@ static int aqc_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		}
 		break;
 	case hwmon_power:
-		*val = priv->power_input[channel];
+		power = READ_ONCE(priv->power_input[channel]);
+		if (power == -ENODATA)
+			return -ENODATA;
+		*val = power;
 		break;
 	case hwmon_pwm:
 		switch (priv->kind) {
@@ -1337,9 +1342,9 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		priv->speed_input[i] =
 		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
 				       priv->fan_structure->speed);
-		priv->power_input[i] =
-		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
-				       priv->fan_structure->power) * 10000;
+		WRITE_ONCE(priv->power_input[i],
+			   get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
+					      priv->fan_structure->power) * 10000);
 		priv->voltage_input[i] =
 		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
 				       priv->fan_structure->voltage) * 10;
@@ -1379,7 +1384,8 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		priv->speed_input[2] = get_unaligned_be16(data + AQUASTREAMULT_PRESSURE_OFFSET);
 		priv->speed_input[3] = get_unaligned_be16(data + AQUASTREAMULT_FLOW_SENSOR_OFFSET);
 
-		priv->power_input[1] = get_unaligned_be16(data + AQUASTREAMULT_PUMP_POWER) * 10000;
+		WRITE_ONCE(priv->power_input[1],
+			   get_unaligned_be16(data + AQUASTREAMULT_PUMP_POWER) * 10000);
 
 		priv->voltage_input[1] = get_unaligned_be16(data + AQUASTREAMULT_PUMP_VOLTAGE) * 10;
 
@@ -1392,10 +1398,11 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 	case highflownext:
 		/* If external temp sensor is not connected, its power reading is also N/A */
 		if (priv->temp_input[1] == -ENODATA)
-			priv->power_input[0] = -ENODATA;
+			WRITE_ONCE(priv->power_input[0], -ENODATA);
 		else
-			priv->power_input[0] =
-			    get_unaligned_be16(data + HIGHFLOWNEXT_POWER) * 1000000;
+			WRITE_ONCE(priv->power_input[0],
+				   min_t(u64, get_unaligned_be16(data + HIGHFLOWNEXT_POWER) *
+					 1000000ULL, LONG_MAX));
 
 		priv->voltage_input[0] = get_unaligned_be16(data + HIGHFLOWNEXT_5V_VOLTAGE) * 10;
 		priv->voltage_input[1] =
-- 
2.53.0



