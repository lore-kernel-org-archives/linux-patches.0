Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028626;
	b=kn41NkenlEhvrYPWb5ozTe1jkw/KBgMo0NfnunQeeAeQujAepsgiujXL/VrtX9QSDd79
	 sGOkWFMEeidBB+Yaewq8PpfFdM6JFo1oyEaZHWKsTWMTSev0Oqraebfim5d0UES8yONCZ
	 dKxI8Z34BBXIprU1/B6zQPVFopOJC8nGUTiXXKA82ZvGxfRZ8ROZTAdIVMCPEBiqLbEqn
	 zHGIwk6T6YWq5gC2BXKSH44usTcisOZZTdmzILpfvxr5wdH1nnVbcNJ6Uvk2/Cq2AdqsX
	 Q8djdRRe3xYoXRQxvucn041fjxF96FttzQi/Jl/+J++sbbjdznPxs6iImELf70lvM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OLYVu5fqs2h7Vn/R/KCo4/wYy6udOfZ7NSFawYrlTks=;
	b=RpcG6/1ho2+crR5Bz/D8K12euM2t9/Gc78ATGBbtUyKcD0zCKxkj9m3fKVmhB8L+0VwH
	 1wk2T5UnWM/M+SDe8pmEQ4ZZWG1DBUNDoKllpfAme08saAf5f1GvHIItNFFjX8U3Ozfaa
	 H7jFJ8sDqw8LzgGm/oSZBadJoK1EXaCA3jDiUsZyGhyANlReO1hRmpla3yjOyjRHu9GCd
	 sPB2Kg9LPDhxtegLvabHKkeViascVX1y0oAw3Z7Du4SyfZkjR2sjLJ8WZI0wBghiSg8n6
	 u7vH882tYO04FtBKLXz77TLpmMvHJmdIVfgNaMylxuLypwk/8iwnuW+GYoQq1mtzRwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fg+tcuy1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3D606A32F;
	Wed, 18 Nov 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fg+tcuy1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AFC1F000C4;
	Wed, 18 Nov 2026 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028626;
	bh=OLYVu5fqs2h7Vn/R/KCo4/wYy6udOfZ7NSFawYrlTks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fg+tcuy1vKYfczHqpi088YIh/rWnCCxLUkZqSsGFmEBz8E9imht/pqaGcGoQo2Zap
	 TBYOZsrCa0aEFUh2SZzk9UbI6wlnJZ4Cu2CwUKb6WZ03WwXSutrBze/E1Z855sIt6v
	 DRAcmrHm7a0qBhmIZPLTPT/EszVmaYq01MPXS8yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0060/1756] hwmon: (chipcap2) Switch to guard() for mutext handling
Date: Wed, 18 Nov 2026 15:36:27 +0100
Message-ID: <20261118150010.750048180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 232ba88182083b4410df41cf310c9a16b84e547e ]

Switch to guard() for mutex handling to simplify the code, getting rid
of the 'ret = x, break; return ret;' construct and return the result
of the operation instead.

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: bed5f0c075eb ("hwmon: chipcap2: serialize access to the alarm indicators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 63 ++++++++++++----------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 6a69c7699594b..2572710fb2384 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -13,6 +13,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/hwmon.h>
@@ -573,55 +574,40 @@ static int cc2_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		    int channel, long *val)
 {
 	struct cc2_data *data = dev_get_drvdata(dev);
-	int ret = 0;
 
-	mutex_lock(&data->dev_access_lock);
+	guard(mutex)(&data->dev_access_lock);
 
 	switch (type) {
 	case hwmon_temp:
-		ret = cc2_measurement(data, type, val);
-		break;
+		return cc2_measurement(data, type, val);
 	case hwmon_humidity:
 		switch (attr) {
 		case hwmon_humidity_input:
-			ret = cc2_measurement(data, type, val);
-			break;
+			return cc2_measurement(data, type, val);
 		case hwmon_humidity_min:
-			ret = cc2_get_reg_val(data, CC2_R_ALARM_L_ON, val);
-			break;
+			return cc2_get_reg_val(data, CC2_R_ALARM_L_ON, val);
 		case hwmon_humidity_min_hyst:
-			ret = cc2_get_reg_val(data, CC2_R_ALARM_L_OFF, val);
-			break;
+			return cc2_get_reg_val(data, CC2_R_ALARM_L_OFF, val);
 		case hwmon_humidity_max:
-			ret = cc2_get_reg_val(data, CC2_R_ALARM_H_ON, val);
-			break;
+			return cc2_get_reg_val(data, CC2_R_ALARM_H_ON, val);
 		case hwmon_humidity_max_hyst:
-			ret = cc2_get_reg_val(data, CC2_R_ALARM_H_OFF, val);
-			break;
+			return cc2_get_reg_val(data, CC2_R_ALARM_H_OFF, val);
 		case hwmon_humidity_min_alarm:
-			ret = cc2_humidity_min_alarm_status(data, val);
-			break;
+			return cc2_humidity_min_alarm_status(data, val);
 		case hwmon_humidity_max_alarm:
-			ret = cc2_humidity_max_alarm_status(data, val);
-			break;
+			return cc2_humidity_max_alarm_status(data, val);
 		default:
-			ret = -EOPNOTSUPP;
+			return -EOPNOTSUPP;
 		}
-		break;
 	default:
-		ret = -EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
-
-	mutex_unlock(&data->dev_access_lock);
-
-	return ret;
 }
 
 static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 		     int channel, long val)
 {
 	struct cc2_data *data = dev_get_drvdata(dev);
-	int ret;
 	u16 arg;
 	u8 cmd;
 
@@ -631,41 +617,28 @@ static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	if (val < 0 || val > CC2_RH_MAX)
 		return -EINVAL;
 
-	mutex_lock(&data->dev_access_lock);
+	guard(mutex)(&data->dev_access_lock);
 
 	switch (attr) {
 	case hwmon_humidity_min:
 		cmd = CC2_W_ALARM_L_ON;
 		arg = cc2_rh_to_reg(val);
-		ret = cc2_write_reg(data, cmd, arg);
-		break;
-
+		return cc2_write_reg(data, cmd, arg);
 	case hwmon_humidity_min_hyst:
 		cmd = CC2_W_ALARM_L_OFF;
 		arg = cc2_rh_to_reg(val);
-		ret = cc2_write_reg(data, cmd, arg);
-		break;
-
+		return cc2_write_reg(data, cmd, arg);
 	case hwmon_humidity_max:
 		cmd = CC2_W_ALARM_H_ON;
 		arg = cc2_rh_to_reg(val);
-		ret = cc2_write_reg(data, cmd, arg);
-		break;
-
+		return cc2_write_reg(data, cmd, arg);
 	case hwmon_humidity_max_hyst:
 		cmd = CC2_W_ALARM_H_OFF;
 		arg = cc2_rh_to_reg(val);
-		ret = cc2_write_reg(data, cmd, arg);
-		break;
-
+		return cc2_write_reg(data, cmd, arg);
 	default:
-		ret = -EOPNOTSUPP;
-		break;
+		return -EOPNOTSUPP;
 	}
-
-	mutex_unlock(&data->dev_access_lock);
-
-	return ret;
 }
 
 static int cc2_get_irqs(struct cc2_data *data, struct device *dev)
-- 
2.53.0



