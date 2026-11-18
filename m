Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047699;
	b=WtkQx3ORdPYgQHOALKt/W8ZrhPC9UnqXsnIJPZKgmeMfocfefJ5PuqLZV0Q+1CCm9+kE
	 7oxZvdg8TcPXmwIvQPxWU+7scrjaESjqxJ7GSlov+WOEXBfoyZpPEGDIt+IeD97KJLbe1
	 73qfmSYJzvKzV4hdDNZoT31Q0E/wd20tKSXWG+94y4+iZlfstMs68qz/itU1O0U/Padum
	 4KQEfqnW6MNz5sKS0tS+ZC9pilwpWK/pwTPDx1YOK1gt8UJO149gI4nsKrd+Byty1Q4ZQ
	 rfmYFGEzMP50PA6dKNKrSdcJfbnj9iyhKLVOWX0Q7xt1FKw7h5xDtYaVB1DbD5uoxPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1oaN3RNmBS4DE+LBfB54N0l44S+a/dC3h9+lZiu48g=;
	b=I8aFr6hOPrrgd+B9Q9J0AQjoGA4FJEkboqT00GC0+kZobMSJ0u2aw1ixgWszEqo7vMRE
	 IhyYc3K63p0AKA52OOkbh0k4garBykVMO4L/wL0Bou3jU0DDLdqLcDPc0S6YEMae6FXjv
	 4/SOhxhHtzwSwOVlADEnotNLvsFarCuKCDhrD+PZhTNt3ZekTIa15FqAxi4ozjrikrT8C
	 Wtmz4niK+zJOqLKVo0IPzS7nEn6SsAMZkbZm1Qhw09+kdANt9yQhSHVB+AKdVnDNbSlrK
	 N47/hQoYU/yfyGsykZxN6a8H/TP8/pLloIMTMB3yomuFCNQM61ZDpMPc0XnoBmxkrxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKWQBwvA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28C606A320;
	Thu, 19 Nov 2026 00:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKWQBwvA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E5B1F000CC;
	Thu, 19 Nov 2026 00:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047699;
	bh=U1oaN3RNmBS4DE+LBfB54N0l44S+a/dC3h9+lZiu48g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKWQBwvAoKE+2DGgiWeMMaTnf+RnbAKHrnoQdadovhEddugcgcR6QYQFhaNjvIiY/
	 imJobVnl1lZfeXd/2R1kWADg82I5tcfzr9nc+Q5WCA9YlGn96HMKC8saNMqfLWRMbF
	 95rsjjEwlyIP3qhzR4/UahuJ/lnlE/fC3i9UOSKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1681/2857] hwmon: (aquacomputer_d5next) reject short status reports
Date: Wed, 18 Nov 2026 15:45:15 +0100
Message-ID: <20261118150301.855644307@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit cf8f81babd2e96087dedbb74985bc1781c98f73d ]

The HID raw_event callback runs before HID core validates the received
report length. aqc_raw_event() reads device-specific status fields at fixed
offsets, including multi-byte values, without first ensuring that the
received buffer contains every field. A truncated report can therefore
cause out-of-bounds reads and update hwmon state with unrelated data.

The required length differs between supported devices and cannot be
derived from the HID report descriptor. Define the minimum length needed
by each asynchronous status format, select it while configuring the
device, and reject reports that do not contain the last field accessed by
that format. Keep the published length zero until probe configuration is
complete, which also excludes legacy devices whose status is retrieved
through feature reports.

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 0e35f63f7f4e ("hwmon: add driver for Aquacomputer D5 Next")
Fixes: 19692f17cd13 ("hwmon: (aquacomputer_d5next) Add support for Aquacomputer Aquastream XT")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261021120408.48495-1-yaojiale02@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: adapted report-size configuration to the supported devices and existing AQC_TEMP_SENSOR_SIZE macro ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index 8c7796d3fdd2d..f192919fa3643 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -84,6 +84,8 @@ static u8 secondary_ctrl_report[] = {
 #define D5NEXT_5V_VOLTAGE		0x39
 #define D5NEXT_12V_VOLTAGE		0x37
 #define D5NEXT_CTRL_REPORT_SIZE		0x329
+#define D5NEXT_MIN_STATUS_REPORT_SIZE	(D5NEXT_PUMP_OFFSET + AQC_FAN_SPEED_OFFSET + \
+					 sizeof(u16))
 static u8 d5next_sensor_fan_offsets[] = { D5NEXT_PUMP_OFFSET, D5NEXT_FAN_OFFSET };
 
 /* Pump and fan speed registers in D5 Next control report (from 0-100%) */
@@ -92,12 +94,16 @@ static u16 d5next_ctrl_fan_offsets[] = { 0x97, 0x42 };
 /* Register offsets for the Farbwerk RGB controller */
 #define FARBWERK_NUM_SENSORS		4
 #define FARBWERK_SENSOR_START		0x2f
+#define FARBWERK_MIN_STATUS_REPORT_SIZE	(FARBWERK_SENSOR_START + \
+					 FARBWERK_NUM_SENSORS * AQC_TEMP_SENSOR_SIZE)
 
 /* Register offsets for the Farbwerk 360 RGB controller */
 #define FARBWERK360_NUM_SENSORS			4
 #define FARBWERK360_SENSOR_START		0x32
 #define FARBWERK360_NUM_VIRTUAL_SENSORS		16
 #define FARBWERK360_VIRTUAL_SENSORS_START	0x3a
+#define FARBWERK360_MIN_STATUS_REPORT_SIZE	(FARBWERK360_VIRTUAL_SENSORS_START + \
+					 FARBWERK360_NUM_VIRTUAL_SENSORS * AQC_TEMP_SENSOR_SIZE)
 
 /* Register offsets for the Octo fan controller */
 #define OCTO_POWER_CYCLES		0x18
@@ -107,6 +113,7 @@ static u16 d5next_ctrl_fan_offsets[] = { 0x97, 0x42 };
 #define OCTO_NUM_VIRTUAL_SENSORS	16
 #define OCTO_VIRTUAL_SENSORS_START	0x45
 #define OCTO_CTRL_REPORT_SIZE		0x65F
+#define OCTO_MIN_STATUS_REPORT_SIZE	(0xD8 + AQC_FAN_SPEED_OFFSET + sizeof(u16))
 static u8 octo_sensor_fan_offsets[] = { 0x7D, 0x8A, 0x97, 0xA4, 0xB1, 0xBE, 0xCB, 0xD8 };
 
 /* Fan speed registers in Octo control report (from 0-100%) */
@@ -121,6 +128,7 @@ static u16 octo_ctrl_fan_offsets[] = { 0x5B, 0xB0, 0x105, 0x15A, 0x1AF, 0x204, 0
 #define QUADRO_VIRTUAL_SENSORS_START	0x3c
 #define QUADRO_CTRL_REPORT_SIZE		0x3c1
 #define QUADRO_FLOW_SENSOR_OFFSET	0x6e
+#define QUADRO_MIN_STATUS_REPORT_SIZE	(0x97 + AQC_FAN_SPEED_OFFSET + sizeof(u16))
 static u8 quadro_sensor_fan_offsets[] = { 0x70, 0x7D, 0x8A, 0x97 };
 
 /* Fan speed registers in Quadro control report (from 0-100%) */
@@ -135,6 +143,7 @@ static u16 quadro_ctrl_fan_offsets[] = { 0x37, 0x8c, 0xe1, 0x136 };
 #define HIGHFLOWNEXT_CONDUCTIVITY	95
 #define HIGHFLOWNEXT_5V_VOLTAGE		97
 #define HIGHFLOWNEXT_5V_VOLTAGE_USB	99
+#define HIGHFLOWNEXT_MIN_STATUS_REPORT_SIZE	(HIGHFLOWNEXT_5V_VOLTAGE_USB + sizeof(u16))
 
 /* Labels for D5 Next */
 static const char *const label_d5next_temp[] = {
@@ -273,6 +282,7 @@ struct aqc_data {
 	enum kinds kind;
 	const char *name;
 
+	u16 min_report_size;
 	ktime_t last_ctrl_report_op;
 	int ctrl_report_delay;	/* Delay between two ctrl report operations, in ms */
 
@@ -710,6 +720,8 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		return 0;
 
 	priv = hid_get_drvdata(hdev);
+	if (!priv->min_report_size || size < priv->min_report_size)
+		return 0;
 
 	/* Info provided with every report */
 	priv->serial_number[0] = get_unaligned_be16(data + SERIAL_FIRST_PART);
@@ -848,6 +860,7 @@ static void aqc_debugfs_init(struct aqc_data *priv)
 static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct aqc_data *priv;
+	u16 min_report_size = 0;
 	int ret;
 
 	priv = devm_kzalloc(&hdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -892,6 +905,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_d5next_power;
 		priv->voltage_label = label_d5next_voltages;
 		priv->current_label = label_d5next_current;
+		min_report_size = D5NEXT_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_FARBWERK:
 		priv->kind = farbwerk;
@@ -900,6 +914,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->num_temp_sensors = FARBWERK_NUM_SENSORS;
 		priv->temp_sensor_start_offset = FARBWERK_SENSOR_START;
 		priv->temp_label = label_temp_sensors;
+		min_report_size = FARBWERK_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_FARBWERK360:
 		priv->kind = farbwerk360;
@@ -912,6 +927,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 		priv->temp_label = label_temp_sensors;
 		priv->virtual_temp_label = label_virtual_temp_sensors;
+		min_report_size = FARBWERK360_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_OCTO:
 		priv->kind = octo;
@@ -933,6 +949,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_fan_power;
 		priv->voltage_label = label_fan_voltage;
 		priv->current_label = label_fan_current;
+		min_report_size = OCTO_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_QUADRO:
 		priv->kind = quadro;
@@ -955,6 +972,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_fan_power;
 		priv->voltage_label = label_fan_voltage;
 		priv->current_label = label_fan_current;
+		min_report_size = QUADRO_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_HIGHFLOWNEXT:
 		priv->kind = highflownext;
@@ -968,11 +986,14 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->speed_label = label_highflownext_fan_speed;
 		priv->power_label = label_highflownext_power;
 		priv->voltage_label = label_highflownext_voltage;
+		min_report_size = HIGHFLOWNEXT_MIN_STATUS_REPORT_SIZE;
 		break;
 	default:
 		break;
 	}
 
+	priv->min_report_size = min_report_size;
+
 	if (priv->buffer_size != 0) {
 		priv->checksum_start = 0x01;
 		priv->checksum_length = priv->buffer_size - 3;
-- 
2.53.0



