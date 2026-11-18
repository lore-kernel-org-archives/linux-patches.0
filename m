Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039007;
	b=NarMVsjt/2cX6LQC4pQ9v91/Q4+C5x+eVtBo6OfShvdr1tzuJw+kpI3ID+T3sfPjErmQ
	 GYxLM/Oeny4VnNcwhs+RtxrTEzaXUCkXVATDnU3KaTXcQnEyLt36ZV8Cd3XYNAOGATRb0
	 wQVbyDnmB6DACtK1t4RvKOcFRdJ3FBpMCJH+MxKpmjzOamJcT6IbmpRt2BVV4j83FIz3W
	 44nxNAZltC2FYxdnjaw3z0nPmefHyYwkKFQG8hHVdIoyDx8pbUaxF6PohW9TZGSZXwtAJ
	 ZovZ6zLuXyek2AVlwqatNa4ZLgk2Uc0LdydvhCtH/c3XR2TBzKIJGexK4Ga36LOvjCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p94YIdowHxle1sWHTV36W3GVMQWqypJsIZO/CflfNhc=;
	b=P08YnwCTp9P6D6o3Q1jB8T+JSJNFcxdXwqPb50I20WEdaKGaUueQKC8Q1IIN7WMOvrdA
	 Ony6QQdcaFREnBVxacAK5HCeq9w87OiP94ke4Se3OqwtZyecy0jYNGqHNetSpDFXdsQss
	 Vp9ZaDFet78vw+gwdCDMPG8AWGG11RML96mEptBjE7wCh0a7PqmWlVFz45fNc1XuaQj1/
	 GWHnl6pMJADsSje3PjAZArkGEy20L9U9oLDieQgn65puvqrqqNo4sOZhrFufyaVw3S9ML
	 GL5+x5E8HdV51NWivUOYwri2cWg80fn6XmnnCOa3RloQtWO5FEJk5SIKFHmoA2t/uJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSPVz024;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1057606A31C;
	Wed, 18 Nov 2026 21:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSPVz024
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDDA1F000C4;
	Wed, 18 Nov 2026 21:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039006;
	bh=p94YIdowHxle1sWHTV36W3GVMQWqypJsIZO/CflfNhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSPVz024OyUtPl2vJ2DiEXl+Qf5r7qB+0Txx0sa7HcdSFVsGfCSm8wDLrDDobOGPX
	 PcZ78ToW1qiA0j1+aLqRuH9SPmzhwhWmCLTm3XVdb7Hfo0s5/zouHLDeVwhxtODXNh
	 3oA/RMdpKIJ2A2aByk+NatnN5IfCzPP+g5ENT/fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1945/3318] hwmon: (aquacomputer_d5next) reject short status reports
Date: Wed, 18 Nov 2026 15:42:47 +0100
Message-ID: <20261118150420.406692022@linuxfoundation.org>
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
[ sashal: Adjusted patch context to account for the missing OCTO_FLOW_SENSOR_OFFSET definition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index 6efbe94110a80..98612a6a63595 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -129,6 +129,7 @@ static u8 aquaero_secondary_ctrl_report[] = {
 #define AQUAERO_FAN_CURRENT_OFFSET		0x06
 #define AQUAERO_FAN_POWER_OFFSET		0x08
 #define AQUAERO_FAN_SPEED_OFFSET		0x00
+#define AQUAERO_MIN_STATUS_REPORT_SIZE		(0x18B + AQUAERO_FAN_POWER_OFFSET + sizeof(u16))
 static u16 aquaero_sensor_fan_offsets[] = { 0x167, 0x173, 0x17f, 0x18B };
 
 /* Control report offsets for the Aquaero fan controllers */
@@ -152,6 +153,8 @@ static u16 aquaero_ctrl_fan_offsets[] = { 0x20c, 0x220, 0x234, 0x248 };
 #define D5NEXT_5V_VOLTAGE		0x39
 #define D5NEXT_12V_VOLTAGE		0x37
 #define D5NEXT_VIRTUAL_SENSORS_START	0x3f
+#define D5NEXT_MIN_STATUS_REPORT_SIZE	(D5NEXT_PUMP_OFFSET + AQC_FAN_SPEED_OFFSET + \
+					 sizeof(u16))
 static u16 d5next_sensor_fan_offsets[] = { D5NEXT_PUMP_OFFSET, D5NEXT_FAN_OFFSET };
 
 /* Control report offsets for the D5 Next pump */
@@ -176,11 +179,14 @@ static u16 d5next_ctrl_fan_offsets[] = { 0x97, 0x42 };	/* Pump and fan speed (fr
 #define AQUASTREAMULT_FAN_CURRENT_OFFSET	0x00
 #define AQUASTREAMULT_FAN_POWER_OFFSET		0x04
 #define AQUASTREAMULT_FAN_SPEED_OFFSET		0x06
+#define AQUASTREAMULT_MIN_STATUS_REPORT_SIZE	(AQUASTREAMULT_PRESSURE_OFFSET + sizeof(u16))
 static u16 aquastreamult_sensor_fan_offsets[] = { AQUASTREAMULT_FAN_OFFSET };
 
 /* Spec and sensor report offset for the Farbwerk RGB controller */
 #define FARBWERK_NUM_SENSORS		4
 #define FARBWERK_SENSOR_START		0x2f
+#define FARBWERK_MIN_STATUS_REPORT_SIZE	(FARBWERK_SENSOR_START + \
+					 FARBWERK_NUM_SENSORS * AQC_SENSOR_SIZE)
 
 /* Specs of the Farbwerk 360 RGB controller */
 #define FARBWERK360_NUM_SENSORS			4
@@ -190,6 +196,8 @@ static u16 aquastreamult_sensor_fan_offsets[] = { AQUASTREAMULT_FAN_OFFSET };
 /* Sensor report offsets for the Farbwerk 360 */
 #define FARBWERK360_SENSOR_START		0x32
 #define FARBWERK360_VIRTUAL_SENSORS_START	0x3a
+#define FARBWERK360_MIN_STATUS_REPORT_SIZE	(FARBWERK360_VIRTUAL_SENSORS_START + \
+					 FARBWERK360_NUM_VIRTUAL_SENSORS * AQC_SENSOR_SIZE)
 
 /* Control report offsets for the Farbwerk 360 */
 #define FARBWERK360_TEMP_CTRL_OFFSET		0x8
@@ -204,6 +212,7 @@ static u16 aquastreamult_sensor_fan_offsets[] = { AQUASTREAMULT_FAN_OFFSET };
 #define OCTO_POWER_CYCLES		0x18
 #define OCTO_SENSOR_START		0x3D
 #define OCTO_VIRTUAL_SENSORS_START	0x45
+#define OCTO_MIN_STATUS_REPORT_SIZE	(0xD8 + AQC_FAN_SPEED_OFFSET + sizeof(u16))
 static u16 octo_sensor_fan_offsets[] = { 0x7D, 0x8A, 0x97, 0xA4, 0xB1, 0xBE, 0xCB, 0xD8 };
 
 /* Control report offsets for the Octo */
@@ -223,6 +232,7 @@ static u16 octo_ctrl_fan_offsets[] = { 0x5B, 0xB0, 0x105, 0x15A, 0x1AF, 0x204, 0
 #define QUADRO_SENSOR_START		0x34
 #define QUADRO_VIRTUAL_SENSORS_START	0x3c
 #define QUADRO_FLOW_SENSOR_OFFSET	0x6e
+#define QUADRO_MIN_STATUS_REPORT_SIZE	(0x97 + AQC_FAN_SPEED_OFFSET + sizeof(u16))
 static u16 quadro_sensor_fan_offsets[] = { 0x70, 0x7D, 0x8A, 0x97 };
 
 /* Control report offsets for the Quadro */
@@ -242,6 +252,7 @@ static u16 quadro_ctrl_fan_offsets[] = { 0x37, 0x8c, 0xe1, 0x136 }; /* Fan speed
 #define HIGHFLOWNEXT_CONDUCTIVITY	95
 #define HIGHFLOWNEXT_5V_VOLTAGE		97
 #define HIGHFLOWNEXT_5V_VOLTAGE_USB	99
+#define HIGHFLOWNEXT_MIN_STATUS_REPORT_SIZE	(HIGHFLOWNEXT_5V_VOLTAGE_USB + sizeof(u16))
 
 /* Specs of the Leakshield */
 #define LEAKSHIELD_NUM_SENSORS		2
@@ -257,6 +268,7 @@ static u16 quadro_ctrl_fan_offsets[] = { 0x37, 0x8c, 0xe1, 0x136 }; /* Fan speed
 #define LEAKSHIELD_FLOW_IN		111
 #define LEAKSHIELD_RESERVOIR_VOLUME	313
 #define LEAKSHIELD_RESERVOIR_FILLED	311
+#define LEAKSHIELD_MIN_STATUS_REPORT_SIZE	(LEAKSHIELD_RESERVOIR_VOLUME + sizeof(u16))
 
 /* Specs of the Aquastream XT pump */
 #define AQUASTREAMXT_SERIAL_START		0x3a
@@ -527,6 +539,7 @@ struct aqc_data {
 	const char *name;
 
 	int status_report_id;	/* Used for legacy devices, report is stored in buffer */
+	u16 min_report_size;
 	int ctrl_report_id;
 	int secondary_ctrl_report_id;
 	int secondary_ctrl_report_size;
@@ -1307,6 +1320,8 @@ static int aqc_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		return 0;
 
 	priv = hid_get_drvdata(hdev);
+	if (!priv->min_report_size || size < priv->min_report_size)
+		return 0;
 
 	/* Info provided with every report */
 	priv->serial_number[0] = get_unaligned_be16(data + priv->serial_number_start_offset);
@@ -1504,6 +1519,7 @@ static void aqc_debugfs_init(struct aqc_data *priv)
 static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct aqc_data *priv;
+	u16 min_report_size = 0;
 	int ret;
 
 	priv = devm_kzalloc(&hdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -1571,6 +1587,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_fan_power;
 		priv->voltage_label = label_fan_voltage;
 		priv->current_label = label_fan_current;
+		min_report_size = AQUAERO_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_D5NEXT:
 		priv->kind = d5next;
@@ -1596,6 +1613,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_d5next_power;
 		priv->voltage_label = label_d5next_voltages;
 		priv->current_label = label_d5next_current;
+		min_report_size = D5NEXT_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_FARBWERK:
 		priv->kind = farbwerk;
@@ -1606,6 +1624,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->temp_sensor_start_offset = FARBWERK_SENSOR_START;
 
 		priv->temp_label = label_temp_sensors;
+		min_report_size = FARBWERK_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_FARBWERK360:
 		priv->kind = farbwerk360;
@@ -1622,6 +1641,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 		priv->temp_label = label_temp_sensors;
 		priv->virtual_temp_label = label_virtual_temp_sensors;
+		min_report_size = FARBWERK360_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_OCTO:
 		priv->kind = octo;
@@ -1647,6 +1667,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_fan_power;
 		priv->voltage_label = label_fan_voltage;
 		priv->current_label = label_fan_current;
+		min_report_size = OCTO_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_QUADRO:
 		priv->kind = quadro;
@@ -1676,6 +1697,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_fan_power;
 		priv->voltage_label = label_fan_voltage;
 		priv->current_label = label_fan_current;
+		min_report_size = QUADRO_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_HIGHFLOWNEXT:
 		priv->kind = highflownext;
@@ -1693,6 +1715,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->speed_label = label_highflownext_fan_speed;
 		priv->power_label = label_highflownext_power;
 		priv->voltage_label = label_highflownext_voltage;
+		min_report_size = HIGHFLOWNEXT_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_LEAKSHIELD:
 		/*
@@ -1712,6 +1735,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 		priv->temp_label = label_leakshield_temp_sensors;
 		priv->speed_label = label_leakshield_fan_speed;
+		min_report_size = LEAKSHIELD_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_AQUASTREAMXT:
 		priv->kind = aquastreamxt;
@@ -1742,6 +1766,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		priv->power_label = label_aquastreamult_power;
 		priv->voltage_label = label_aquastreamult_voltages;
 		priv->current_label = label_aquastreamult_current;
+		min_report_size = AQUASTREAMULT_MIN_STATUS_REPORT_SIZE;
 		break;
 	case USB_PRODUCT_ID_POWERADJUST3:
 		priv->kind = poweradjust3;
@@ -1795,6 +1820,8 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		break;
 	}
 
+	priv->min_report_size = min_report_size;
+
 	if (priv->buffer_size != 0) {
 		priv->checksum_start = 0x01;
 		priv->checksum_length = priv->buffer_size - 3;
-- 
2.53.0



