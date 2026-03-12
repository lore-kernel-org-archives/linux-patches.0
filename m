Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D5359A8B;
	Thu, 12 Mar 2026 20:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346964; cv=none; b=JDfesO/iU1UL54lUJtylOFNH7motikQlgjoIGOlVgzLwGLu3KV0iXATn5vrWyRVLvI7bOi9Kaud2uKZQ2D88TcTXgjGSrxJai44haL+nMWEN+cV9FPj6/bHopAli6bPL3iFIt1utvXwOcgzckTGud9rZaYIGlDuzbreCF8D4Klk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346964; c=relaxed/simple;
	bh=9jdjT0yIecj7mXWAW0C5eOBDEoxe+lXkifpgrjv+rFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCESoo4yWRFlGzB5OZEl/MCBnbckvcX7e1vRYL2ixB1/9zP0ybE5u0LnJnEVsmSfgk6UGtF27c/3mBVvHWs1IYbYdWKNQfltlYtcPdS01/425VYMEXDOI96pn5+glFpBA6FurYO0pzbDICj4ie3d2xYJczqoONd3u1dbhR/OoqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPBU6Lay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPBU6Lay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA51C4CEF7;
	Thu, 12 Mar 2026 20:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346964;
	bh=9jdjT0yIecj7mXWAW0C5eOBDEoxe+lXkifpgrjv+rFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPBU6Lay3ulKzxNQCvtRXjvtkfLZ2bY7HqHVqmgpomaCC1MVGLSl4asb/wv5SrxTN
	 T4vdcooTNWC6nM7TOGm0U/X33WG6vv+e9hg9da6jZXYLAwHmQ55Rl+J5Cyxq15kMJJ
	 Xvd4rbhXA4TBenW6z3CsEPoRcg5xGFUZPyosiCTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/265] hwmon: (aht10) Add support for dht20
Date: Thu, 12 Mar 2026 21:09:16 +0100
Message-ID: <20260312201024.384358900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhilesh Patil <akhilesh@ee.iitb.ac.in>

[ Upstream commit 3eaf1b631506e8de2cb37c278d5bc042521e82c1 ]

Add support for dht20 temperature and humidity sensor from Aosong.
Modify aht10 driver to handle different init command for dht20 sensor by
adding init_cmd entry in the driver data. dht20 sensor is compatible with
aht10 hwmon driver with this change.

Tested on TI am62x SK board with dht20 sensor connected at i2c-2 port.

Signed-off-by: Akhilesh Patil <akhilesh@ee.iitb.ac.in>
Link: https://lore.kernel.org/r/2025112-94320-906858@bhairav-test.ee.iitb.ac.in
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: b7497b5a99f5 ("hwmon: (aht10) Fix initialization commands for AHT20")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/aht10.rst | 10 +++++++++-
 drivers/hwmon/Kconfig         |  6 +++---
 drivers/hwmon/aht10.c         | 19 ++++++++++++++++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/Documentation/hwmon/aht10.rst b/Documentation/hwmon/aht10.rst
index 213644b4ecba6..7903b6434326d 100644
--- a/Documentation/hwmon/aht10.rst
+++ b/Documentation/hwmon/aht10.rst
@@ -20,6 +20,14 @@ Supported chips:
 
       English: http://www.aosong.com/userfiles/files/media/Data%20Sheet%20AHT20.pdf
 
+  * Aosong DHT20
+
+    Prefix: 'dht20'
+
+    Addresses scanned: None
+
+    Datasheet: https://www.digikey.co.nz/en/htmldatasheets/production/9184855/0/0/1/101020932
+
 Author: Johannes Cornelis Draaijer <jcdra1@gmail.com>
 
 
@@ -33,7 +41,7 @@ The address of this i2c device may only be 0x38
 Special Features
 ----------------
 
-AHT20 has additional CRC8 support which is sent as the last byte of the sensor
+AHT20, DHT20 has additional CRC8 support which is sent as the last byte of the sensor
 values.
 
 Usage Notes
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 58480a3f4683f..19622dd6ec93a 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -245,12 +245,12 @@ config SENSORS_ADT7475
 	  will be called adt7475.
 
 config SENSORS_AHT10
-	tristate "Aosong AHT10, AHT20"
+	tristate "Aosong AHT10, AHT20, DHT20"
 	depends on I2C
 	select CRC8
 	help
-	  If you say yes here, you get support for the Aosong AHT10 and AHT20
-	  temperature and humidity sensors
+	  If you say yes here, you get support for the Aosong AHT10, AHT20 and
+	  DHT20 temperature and humidity sensors
 
 	  This driver can also be built as a module. If so, the module
 	  will be called aht10.
diff --git a/drivers/hwmon/aht10.c b/drivers/hwmon/aht10.c
index 312ef3e987540..231aba885beaa 100644
--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -37,6 +37,8 @@
 #define AHT10_CMD_MEAS	0b10101100
 #define AHT10_CMD_RST	0b10111010
 
+#define DHT20_CMD_INIT	0x71
+
 /*
  * Flags in the answer byte/command
  */
@@ -48,11 +50,12 @@
 
 #define AHT10_MAX_POLL_INTERVAL_LEN	30
 
-enum aht10_variant { aht10, aht20 };
+enum aht10_variant { aht10, aht20, dht20};
 
 static const struct i2c_device_id aht10_id[] = {
 	{ "aht10", aht10 },
 	{ "aht20", aht20 },
+	{ "dht20", dht20 },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, aht10_id);
@@ -77,6 +80,7 @@ MODULE_DEVICE_TABLE(i2c, aht10_id);
  *              AHT10/AHT20
  *   @crc8: crc8 support flag
  *   @meas_size: measurements data size
+ *   @init_cmd: Initialization command
  */
 
 struct aht10_data {
@@ -92,6 +96,7 @@ struct aht10_data {
 	int humidity;
 	bool crc8;
 	unsigned int meas_size;
+	u8 init_cmd;
 };
 
 /**
@@ -101,13 +106,13 @@ struct aht10_data {
  */
 static int aht10_init(struct aht10_data *data)
 {
-	const u8 cmd_init[] = {AHT10_CMD_INIT, AHT10_CAL_ENABLED | AHT10_MODE_CYC,
+	const u8 cmd_init[] = {data->init_cmd, AHT10_CAL_ENABLED | AHT10_MODE_CYC,
 			       0x00};
 	int res;
 	u8 status;
 	struct i2c_client *client = data->client;
 
-	res = i2c_master_send(client, cmd_init, 3);
+	res = i2c_master_send(client, cmd_init, sizeof(cmd_init));
 	if (res < 0)
 		return res;
 
@@ -352,9 +357,17 @@ static int aht10_probe(struct i2c_client *client)
 		data->meas_size = AHT20_MEAS_SIZE;
 		data->crc8 = true;
 		crc8_populate_msb(crc8_table, AHT20_CRC8_POLY);
+		data->init_cmd = AHT10_CMD_INIT;
+		break;
+	case dht20:
+		data->meas_size = AHT20_MEAS_SIZE;
+		data->crc8 = true;
+		crc8_populate_msb(crc8_table, AHT20_CRC8_POLY);
+		data->init_cmd = DHT20_CMD_INIT;
 		break;
 	default:
 		data->meas_size = AHT10_MEAS_SIZE;
+		data->init_cmd = AHT10_CMD_INIT;
 		break;
 	}
 
-- 
2.51.0



