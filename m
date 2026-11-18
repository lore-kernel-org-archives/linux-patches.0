Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047610;
	b=BSTckytjjquPgO8dvh7uuTNBcN25c7ZFT5YmY+fqvzEkcZzdgrxbGLSKYgxz24oAT+7v
	 KKcZ+ekilZ0Gmjh8QrWAd/cLFia/EtzUCp27TtS/TslT/5h5PdWA4WQV/Qn1yIvstx0af
	 ojFuKA6QWDzw45s5oSM7lvn7HD2rMSz4OCbwgY695/q/dFy56TFlYYgbhz+K8umWpBlgA
	 UPztoPTgEWGn2I99oyGr6aak4/e/dfDiUs1AnICtO1fAQVpJzsZ7qf+P2yYHGWVehAGfE
	 uiYyR6A+TLaTghjhcAXU0KIU4XRVzWWzmGBr0RsTsPCCkmo6V3L7HG439PrJ+e4d6/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7lrExduf+0zDnWpYOmCJZan3cZqSjqhVbkF1x+BMStg=;
	b=08LqWbOH+zSFSoCnTpOUsqYsu6oeNNT7vm4/xF18JkBfMVkxExuS9bTNyzImJKCFQi2V
	 vlKuiimPrxxhSc5Hp4Z9IFsNg2lDas2xqBQjj9HZW8WX9TF8Dq3uqxQQ7FT7SXmnqJw6K
	 xuUCDp47LEAN+MopELobvKyWtjaVqZXHYA2qJSxMHNcvuyMf4M0bbtOULQc45V0hLPr8W
	 yl3tX103uDB2bnEk2UpLTprVb3L6lbmO+9Evp1UTQrNlIUceOKFCjOrWPujBZcGEfxWPQ
	 te7RsZsxS8l79piS7lpcoBGi1HqWLqqWZwukRyPCVu17UHgHUzd3DcXxjfBaTiygzrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDfu9ku6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A16606A325;
	Thu, 19 Nov 2026 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDfu9ku6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A48C1F000C4;
	Thu, 19 Nov 2026 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047610;
	bh=7lrExduf+0zDnWpYOmCJZan3cZqSjqhVbkF1x+BMStg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDfu9ku6kyXLehUJjMmgS/TkaE8LFq2yvWbKCXge7/3JvKzWPWcg4uck5Xo7JXk/l
	 nRWn+4aDk6ak4nnYxo1GZ6tUaP3M9HLoCQfE+TPqRc9SwLJvvo/h8vgQvjexVqHlzP
	 iqOvysl84pW+8FfZo41yvTXlM91hIiHN0u2YOLFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vas Zayarskiy <contact@vasily.cc>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1683/2857] hwmon: (aquacomputer_d5next) Avoid truncating scaled sensor readings
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118150301.931425152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced priv->fan_structure->power with the existing AQC_FAN_POWER_OFFSET constant. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index f192919fa3643..876900f829ec3 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -17,6 +17,7 @@
 #include <linux/hwmon.h>
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
@@ -312,9 +313,9 @@ struct aqc_data {
 	/* Sensor values */
 	s32 temp_input[20];	/* Max 4 physical and 16 virtual */
 	u16 speed_input[8];
-	u32 power_input[8];
+	long power_input[8];
 	u16 voltage_input[8];
-	u16 current_input[8];
+	u32 current_input[8];
 
 	/* Label values */
 	const char *const *temp_label;
@@ -525,6 +526,7 @@ static umode_t aqc_is_visible(const void *data, enum hwmon_sensor_types type, u3
 static int aqc_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		    int channel, long *val)
 {
+	long power;
 	int ret;
 	struct aqc_data *priv = dev_get_drvdata(dev);
 
@@ -542,7 +544,10 @@ static int aqc_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		*val = priv->speed_input[channel];
 		break;
 	case hwmon_power:
-		*val = priv->power_input[channel];
+		power = READ_ONCE(priv->power_input[channel]);
+		if (power == -ENODATA)
+			return -ENODATA;
+		*val = power;
 		break;
 	case hwmon_pwm:
 		if (priv->fan_ctrl_offsets) {
@@ -755,9 +760,9 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 	for (i = 0; i < priv->num_fans; i++) {
 		priv->speed_input[i] =
 		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] + AQC_FAN_SPEED_OFFSET);
-		priv->power_input[i] =
-		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
-				       AQC_FAN_POWER_OFFSET) * 10000;
+		WRITE_ONCE(priv->power_input[i],
+			   get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
+					      AQC_FAN_POWER_OFFSET) * 10000);
 		priv->voltage_input[i] =
 		    get_unaligned_be16(data + priv->fan_sensor_offsets[i] +
 				       AQC_FAN_VOLTAGE_OFFSET) * 10;
@@ -780,10 +785,11 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
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



