Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065003;
	b=x154OdginyOeBUWe0XKIT3Pst9HaHWRDiDErWV5CkSKRQrAuGViz4zXNhssowLUDh8Nq
	 ZAz4jxjpMI0MmFVLZsPSoslCTHjkvJqsFxrDfpXlnO2YmIe+CiG6d35kBy0C1KSntBGYh
	 Hfsvv4YhijlPFnbtAEBbcMrAQtgiBiD/r4x9LT+UA5ogeEeGiFfOitYDtWlvvP47zX9IW
	 H3qxAlFroLAgAPNs/7jkgnE0Dq2MxT0eAQXED5APamjg6DXj42vvRTwCVjF84ysWJuxEN
	 LT4YfltRkiP5rT0i/38ga5gGx056v2dvJbgx+GtuFrXh0b4qUz2Kra8Ai0EpcyHvYtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPaJHldjgt6m4g13PmyQTsHiXgOo5U930gzh/1st9/c=;
	b=C47ZK0Lj152hHQEp/UNXlOKtDjHqAl97rWGP1AgQhG9+B4iUeg7NcsphbzfyMKqtWJOb
	 sCAAlQ5WkHLalfKlMYEGLhiLbGR2FaYctlIYwwl7NOQ+pL9+tR4Ivw8RdHP06fk4h91MW
	 NJ51f0LyiWofQEeKni3s7O+8W0RjHtQV24oOLMjx8Heb9m2M2nCgVNIVKebDXezfYJUqe
	 b5xMQVV+PjFAO3EC7s94ZqGsHs3apbZ/4r1sdgcsX/IfpFTUAy/EICUPr6pvxMgOdN1M4
	 BD0yIy0DJ9Zrz0BQacq0n7JH+CDr7XL7dtZqVIcAK9rOkFQ33m4msKzXQTVe85btBlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yKNRR+QM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94021606A333;
	Sat,  7 Nov 2026 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yKNRR+QM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422A31F0089F;
	Sat,  7 Nov 2026 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065003;
	bh=bPaJHldjgt6m4g13PmyQTsHiXgOo5U930gzh/1st9/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKNRR+QM1cWUvYr09Mc+Dp2K+TS3YHfRexqcM5HkiSWPXu3o+V/dV5bcxD/osm0hx
	 wXO2cxeV7HJdgKxedngeb9Fu4jHyN4nBGuESsDR7BNC7J+4BuHGK3myG84rQguwna3
	 Arb7G12IIm/hX9hiRhCAPw3Qf45VDMiMYgdZJbvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0871/1257] hwmon: (sht4x) Fix jiffies wraparound in heater-ready check
Date: Sat,  7 Nov 2026 08:52:47 -0500
Message-ID: <20261107135003.385348009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Verdonck <tom.verdonck@inspiral.be>

[ Upstream commit ce3ff350c4a3b9466bd67bfe2adb2e3bea732b9e ]

sht4x stores in ->heating_complete the jiffies deadline at which the
current heater pulse finishes. It is set once at probe (to jiffies) and
only updated when the heater is explicitly enabled via sysfs, so in the
common case where the heater is never used it stays frozen at its probe
value.

->heating_complete is an unsigned long compared with time_before(),
whose signed difference is only meaningful while the two values are
within LONG_MAX jiffies of each other. Because the deadline is frozen,
jiffies keeps advancing away from it, and after 2^31 jiffies the
difference flips sign. On a 32-bit HZ=100 kernel that happens ~248.5
days after boot. time_before() in sht4x_read_values() then wrongly
reports that heating is still in progress and the read path executes

	msleep(jiffies_to_msecs(data->heating_complete - curr_jiffies));

with a bogus, huge delta, blocking the temperature read for a very long
time instead of returning data. The heater_enable sysfs attributes are
affected the same way (spurious -EBUSY and "1" readback).

Store the deadline as a 64-bit jiffies value and compare it with
get_jiffies_64()/time_before64(), which does not wrap in any practical
uptime.

Fixes: 0eed6fc3d2b9 ("hwmon: (sht4x): add heater support")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Verdonck <tom.verdonck@inspiral.be>
Link: https://patch.msgid.link/7b2087ccb963e097cf3f6333efaec0c46549003b.1790358356.git.tom.verdonck@inspiral.be
[groeck: Squashed 'Fix torn read' patch into this one]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index a97dda9e92dc5..27fddff703542 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -67,7 +67,7 @@ DECLARE_CRC8_TABLE(sht4x_crc8_table);
  */
 struct sht4x_data {
 	struct i2c_client	*client;
-	unsigned long		heating_complete;	/* in jiffies */
+	u64			heating_complete;	/* in jiffies */
 	bool			data_pending;
 	u32			heater_power;	/* in milli-watts */
 	u32			heater_time;	/* in milli-seconds */
@@ -92,14 +92,14 @@ static int sht4x_read_values(struct sht4x_data *data)
 	u8 crc;
 	u8 cmd[SHT4X_CMD_LEN] = {SHT4X_CMD_MEASURE_HPM};
 	u8 raw_data[SHT4X_RESPONSE_LENGTH];
-	unsigned long curr_jiffies;
+	u64 curr_jiffies;
 
-	curr_jiffies = jiffies;
-	if (time_before(curr_jiffies, data->heating_complete))
+	curr_jiffies = get_jiffies_64();
+	if (time_before64(curr_jiffies, data->heating_complete))
 		msleep(jiffies_to_msecs(data->heating_complete - curr_jiffies));
 
 	if (data->data_pending &&
-	    time_before(jiffies, data->heating_complete + data->update_interval)) {
+	    time_before64(get_jiffies_64(), data->heating_complete + data->update_interval)) {
 		data->data_pending = false;
 	} else {
 		next_update = data->last_updated +
@@ -237,7 +237,9 @@ static ssize_t heater_enable_show(struct device *dev,
 {
 	struct sht4x_data *data = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%u\n", time_before(jiffies, data->heating_complete));
+	guard(hwmon_lock)(dev);
+
+	return sysfs_emit(buf, "%u\n", time_before64(get_jiffies_64(), data->heating_complete));
 }
 
 static ssize_t heater_enable_store(struct device *dev,
@@ -279,14 +281,14 @@ static ssize_t heater_enable_store(struct device *dev,
 
 	guard(hwmon_lock)(dev);
 
-	if (time_before(jiffies, data->heating_complete))
+	if (time_before64(get_jiffies_64(), data->heating_complete))
 		return -EBUSY;
 
 	ret = i2c_master_send(data->client, &cmd, SHT4X_CMD_LEN);
 	if (ret < 0)
 		return ret;
 
-	data->heating_complete = jiffies + msecs_to_jiffies(heating_time_bound);
+	data->heating_complete = get_jiffies_64() + msecs_to_jiffies(heating_time_bound);
 	data->data_pending = true;
 	return count;
 }
@@ -410,7 +412,7 @@ static int sht4x_probe(struct i2c_client *client)
 	data->client = client;
 	data->heater_power = 200;
 	data->heater_time = 1000;
-	data->heating_complete = jiffies;
+	data->heating_complete = get_jiffies_64();
 
 	crc8_populate_msb(sht4x_crc8_table, SHT4X_CRC8_POLYNOMIAL);
 
-- 
2.53.0



