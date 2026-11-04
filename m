Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831234;
	b=ie5X78lLfuGqMjStjM8pO9p7O2ldodYxPOhntQGNGPMpovaYacoH+3ioN7tvC9TKxe7+
	 P5RH0ne6ZpNmWNmVx8U+jTdEEpGqyud1cmmx/8gAGYfGf92DtVOo8MDvOeofHY878wcao
	 R3rLRtdHbEv4of1rBbMW6dcvCXZ4i82Jqd+IrcL6WPG1HkH0lzpgbLvaZ6/+j5lv1/jOv
	 idornJWuijsBnHSZrO0rYOp/IDVNzeo0IWQLc7/B4CYmV6/xYD6dYw81frNO+XRUiRt6K
	 ARkg8gqyogAJRI5G5bHZ5+kLtc+f9g+cKyN4wm9qm7TLhABfjuj52QsyY+1ESbC48fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d+RoLUMkyXpMPlfMguA45a+183rh/VsqDozPJXpqRCc=;
	b=20+PFZqzSHuzZd9zPoLWQ2toIJbV7Tf+AIwYjWoyLSCV8VsXrNmCjP14cKNV7CRHxaUc
	 ZA3+FncQHgLMGEu/xrmuRn5thXeGH3W8iBZVqNSzg3t2tZrDdAM08derOEPLZxCKxd5kU
	 aObE7ciuM4vl8rIz0eCztpwLc7FPLvg1VmMFDf8k5IGNHdPAxnRjzUzQYbAe3x4PzXv7f
	 yUzelZNcg8CCeZSyOT6lv/AhsCclnYGCF3QYnpEwXY4X4PE3ZF5WaWsdPcM6blCpJTucF
	 XRmRSMzD/61kyK4SGNa9p4+Jk63AN7tV6WK9Xczdi1WVFeLIJffx06kMG+TgkGfzytw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d72YfN+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EDC606AB32;
	Wed,  4 Nov 2026 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d72YfN+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F92D1F000C1;
	Wed,  4 Nov 2026 22:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831233;
	bh=d+RoLUMkyXpMPlfMguA45a+183rh/VsqDozPJXpqRCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d72YfN+R4ZmbLkesx2+tYVxAWCqiDBy1O4VYIuTYNL3mF/8hS5qUXzLL0v46ot9h0
	 W4wiGYOkghbRHAgMT/xTGLRxjmqs7vvVLWVkeLX2bweiUSH7fZMk0yskEHoOF4/ciO
	 wd0K4yAG3qvPX96I9ZEWUSbtbAO2dHeHjm8CJ8O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arie Miller <renari@arimil.com>,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0579/1005] hwmon: (asus_rog_ryujin) Add per-device configuration
Date: Wed,  4 Nov 2026 16:05:12 -0500
Message-ID: <20261104211100.078347745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Arie Miller <renari@arimil.com>

[ Upstream commit b20ee9aee8779427d2f9de99cbb578b048bf7c04 ]

Move model-specific report offsets and capabilities into a device
information structure. This prepares the driver for coolers which use
a different report layout or do not include the external fan
controller, while preserving the existing Ryujin II 360 behavior.

Handles an issue reported by Sashiko where an id could
be missing driver_data.

Link: https://lore.kernel.org/r/5a817284-a9f4-48b2-9f0f-802c5dc6963c@roeck-us.net
Assisted-by: Codex:gpt-5.6-sol sparse
Signed-off-by: Arie Miller <renari@arimil.com>
Reviewed-by: Aleksa Savic <savicaleksa83@gmail.com>
Link: https://lore.kernel.org/r/20260812103532.395049-2-renari@arimil.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 8042312e73c5 ("hwmon: (asus_rog_ryujin) Validate HID report lengths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus_rog_ryujin.c | 75 +++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/hwmon/asus_rog_ryujin.c b/drivers/hwmon/asus_rog_ryujin.c
index 10a1f5aca988d..80563ce38519d 100644
--- a/drivers/hwmon/asus_rog_ryujin.c
+++ b/drivers/hwmon/asus_rog_ryujin.c
@@ -18,15 +18,25 @@
 #define USB_VENDOR_ID_ASUS_ROG		0x0b05
 #define USB_PRODUCT_ID_RYUJIN_AIO	0x1988	/* ASUS ROG RYUJIN II 360 */
 
+struct rog_ryujin_device_info {
+	u8 temp_offset;
+	u8 pump_speed_offset;
+	u8 fan_speed_offset;
+	u8 duty_channel;
+	bool has_controller;
+};
+
+static const struct rog_ryujin_device_info rog_ryujin_ii_360_info = {
+	.temp_offset = 3,
+	.pump_speed_offset = 5,
+	.fan_speed_offset = 7,
+	.duty_channel = 0,
+	.has_controller = true,
+};
+
 #define STATUS_VALIDITY		1500	/* ms */
 #define MAX_REPORT_LENGTH	65
 
-/* Cooler status report offsets */
-#define RYUJIN_TEMP_SENSOR_1		3
-#define RYUJIN_TEMP_SENSOR_2		4
-#define RYUJIN_PUMP_SPEED		5
-#define RYUJIN_INTERNAL_FAN_SPEED	7
-
 /* Cooler duty report offsets */
 #define RYUJIN_PUMP_DUTY		4
 #define RYUJIN_INTERNAL_FAN_DUTY	5
@@ -81,6 +91,7 @@ static const char *const rog_ryujin_speed_label[] = {
 struct rog_ryujin_data {
 	struct hid_device *hdev;
 	struct device *hwmon_dev;
+	const struct rog_ryujin_device_info *info;
 	/* For reinitializing the completions below */
 	spinlock_t status_report_request_lock;
 	struct completion cooler_status_received;
@@ -112,6 +123,8 @@ static int rog_ryujin_pwm_to_percent(long val)
 static umode_t rog_ryujin_is_visible(const void *data,
 				     enum hwmon_sensor_types type, u32 attr, int channel)
 {
+	const struct rog_ryujin_data *priv = data;
+
 	switch (type) {
 	case hwmon_temp:
 		switch (attr) {
@@ -123,6 +136,8 @@ static umode_t rog_ryujin_is_visible(const void *data,
 		}
 		break;
 	case hwmon_fan:
+		if (channel >= 2 && !priv->info->has_controller)
+			return 0;
 		switch (attr) {
 		case hwmon_fan_label:
 		case hwmon_fan_input:
@@ -132,6 +147,8 @@ static umode_t rog_ryujin_is_visible(const void *data,
 		}
 		break;
 	case hwmon_pwm:
+		if (channel >= 2 && !priv->info->has_controller)
+			return 0;
 		switch (attr) {
 		case hwmon_pwm_input:
 			return 0644;
@@ -198,12 +215,14 @@ static int rog_ryujin_get_status(struct rog_ryujin_data *priv)
 	if (ret < 0)
 		return ret;
 
-	/* Retrieve controller status (speeds) */
-	ret =
-	    rog_ryujin_execute_cmd(priv, get_controller_speed_cmd, GET_CMD_LENGTH,
-				   &priv->controller_status_received);
-	if (ret < 0)
-		return ret;
+	if (priv->info->has_controller) {
+		/* Retrieve controller status (speeds) */
+		ret = rog_ryujin_execute_cmd(priv, get_controller_speed_cmd,
+					     GET_CMD_LENGTH,
+					     &priv->controller_status_received);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Retrieve cooler duty */
 	ret =
@@ -212,12 +231,14 @@ static int rog_ryujin_get_status(struct rog_ryujin_data *priv)
 	if (ret < 0)
 		return ret;
 
-	/* Retrieve controller duty */
-	ret =
-	    rog_ryujin_execute_cmd(priv, get_controller_duty_cmd, GET_CMD_LENGTH,
-				   &priv->controller_duty_received);
-	if (ret < 0)
-		return ret;
+	if (priv->info->has_controller) {
+		/* Retrieve controller duty */
+		ret = rog_ryujin_execute_cmd(priv, get_controller_duty_cmd,
+					     GET_CMD_LENGTH,
+					     &priv->controller_duty_received);
+		if (ret < 0)
+			return ret;
+	}
 
 	priv->updated = jiffies;
 	return 0;
@@ -289,6 +310,7 @@ static int rog_ryujin_write_fixed_duty(struct rog_ryujin_data *priv, int channel
 			return ret;
 
 		memcpy(set_cmd, set_cooler_duty_cmd, SET_CMD_LENGTH);
+		set_cmd[2] = priv->info->duty_channel;
 
 		/* Cooler duties are set as 0-100% */
 		val = rog_ryujin_pwm_to_percent(val);
@@ -394,10 +416,12 @@ static int rog_ryujin_raw_event(struct hid_device *hdev, struct hid_report *repo
 
 	if (data[1] == RYUJIN_GET_COOLER_STATUS_CMD_RESPONSE) {
 		/* Received coolant temp and speeds of pump and internal fan */
-		priv->temp_input[0] =
-		    data[RYUJIN_TEMP_SENSOR_1] * 1000 + data[RYUJIN_TEMP_SENSOR_2] * 100;
-		priv->speed_input[0] = get_unaligned_le16(data + RYUJIN_PUMP_SPEED);
-		priv->speed_input[1] = get_unaligned_le16(data + RYUJIN_INTERNAL_FAN_SPEED);
+		priv->temp_input[0] = data[priv->info->temp_offset] * 1000 +
+			data[priv->info->temp_offset + 1] * 100;
+		priv->speed_input[0] =
+			get_unaligned_le16(data + priv->info->pump_speed_offset);
+		priv->speed_input[1] =
+			get_unaligned_le16(data + priv->info->fan_speed_offset);
 
 		if (!completion_done(&priv->cooler_status_received))
 			complete_all(&priv->cooler_status_received);
@@ -471,11 +495,15 @@ static int rog_ryujin_probe(struct hid_device *hdev, const struct hid_device_id
 	struct rog_ryujin_data *priv;
 	int ret;
 
+	if (!id->driver_data)
+		return -EINVAL;
+
 	priv = devm_kzalloc(&hdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->hdev = hdev;
+	priv->info = (const struct rog_ryujin_device_info *)id->driver_data;
 	hid_set_drvdata(hdev, priv);
 
 	/*
@@ -546,7 +574,8 @@ static void rog_ryujin_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id rog_ryujin_table[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS_ROG, USB_PRODUCT_ID_RYUJIN_AIO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS_ROG, USB_PRODUCT_ID_RYUJIN_AIO),
+	  .driver_data = (kernel_ulong_t)&rog_ryujin_ii_360_info },
 	{ }
 };
 
-- 
2.53.0



