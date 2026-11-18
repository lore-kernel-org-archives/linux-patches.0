Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060194;
	b=BuaOsB3oKhsGcdlfQUQVDDiclPRsjk3KlBH35WtaOSelCuUa633tXgeekg5aYIQPX3cQ
	 xLmrb+6UQ7ddoCCgmwEGXWuTuLjdgOHnt+Pk4ih0RPD9LrzuLzLutcsjPNN0uJH9gbN4+
	 vgMhqlsPWP/WNHYgIWpy/1Azmp91UobSLdDzPDmRBZbx+WAA9SJ1qxR7R5lQpDKw4OG3r
	 T3NWnqSONHAYMhTMI2mA4aD/mBbJexPbryYNInaMq+AMU+ABN7CwVg43Q1eYO5VsEeT+4
	 LURsMsFGdzIW51RWXNu1Dwkh5tt70ClPbf8T+yBjhd3naWJmAp5IDBEbBY9sj9TGEXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rZpYRDB0fVdO1wPNKzIf8OZ4r17zDJ/ZiEgU5PQhAwk=;
	b=2x3va2TbZsNeF88Njo4L8r5XL9ALOXhamApRqisk1R/kIT6MyTxHf//x7b9b7/XAHVHP
	 u+E/RHC5clM7+R3i2zOf+/Y8fjt7YIVDxeSsSQXYcBwj9AEirk2eNXpv5KeIk/EANWhCj
	 niLJ99gsXGMdhCx8d2pnx1CzDuKmSVZk6ARj+qfrBNon/5bVOO4+hlKcPqRbUdXEwdAw/
	 PBNEglEBryMtTCIpXBQpQJM5Z89Igbn/SBKmh5Pqz1ZOgoAHvPBNmxuajM4OTuDqxWn/d
	 RNLLOCvhWeiISFGAgTuNtmXtiJMmwggSvrzkD5IGRusRtbJC15SP9VBf4wjYz0ysQgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGUzgGZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E622B606A320;
	Thu, 19 Nov 2026 03:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGUzgGZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF1B1F000C4;
	Thu, 19 Nov 2026 03:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060193;
	bh=rZpYRDB0fVdO1wPNKzIf8OZ4r17zDJ/ZiEgU5PQhAwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGUzgGZjwMNFGYpB1TPQjXcj0KVzGBwKXXPzte9k1bdeR2vKKApuUCmh7303JCdCy
	 L4Ag/dz+eToFoX7m/Vow+8lV9xiLbLIxfihG/nYLRlaOq9Hy5bLI+Ch3x+/7vaYm5U
	 ZC9xMsPUzYU5MAKX6DYm6iC+Oqwj1tQdQk7zaIvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1069/1848] hwmon: (tmp108) Fix initial conversion delay and wait until ready
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150002.625537706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 7cd60538073e465310c94b2a2f0ea8d2f03768ef ]

In tmp108_common_probe(), the driver only adds the 30 ms conversion delay
(TMP108_CONVERSION_TIME_MS) to ready_time if the sensor was previously in
TMP108_MODE_SHUTDOWN. However, the TMP108 hardware defaults to continuous
conversion mode (TMP108_MODE_CONTINUOUS) upon power-on reset, including
immediately after enabling the vcc supply regulator during probe, while
the temperature register retains its power-on reset value of 0x0000 (0°C)
until the first conversion completes. Because the initial mode is not
shutdown, the delay is bypassed and early reads via thermal zone
registration or sysfs before the first conversion finishes return an
uninitialized 0°C reading.

In addition, returning -EAGAIN from tmp108_read() while waiting for a
conversion to complete after probe or resume can trigger an unnecessary
tight retry loop in callers or fail initial reads.

Unconditionally set ready_time to TMP108_CONVERSION_TIME_MS ahead in
tmp108_common_probe(), track ready_time as ktime_t, and wait for the
remaining conversion time in tmp108_read() using usleep_range() instead
of returning -EAGAIN.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 66e1c9171339 ("hwmon: Add Texas Instruments TMP108 temperature sensor driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: adapted tmp108_common_probe() changes to the existing tmp108_probe() function ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp108.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/tmp108.c b/drivers/hwmon/tmp108.c
index 4420774e6bff6..1c8614278e9fa 100644
--- a/drivers/hwmon/tmp108.c
+++ b/drivers/hwmon/tmp108.c
@@ -14,7 +14,7 @@
 #include <linux/of.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
-#include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
@@ -73,7 +73,7 @@
 struct tmp108 {
 	struct regmap *regmap;
 	u16 orig_config;
-	u64 ready_time;
+	ktime_t ready_time;
 };
 
 /* convert 12-bit TMP108 register value to milliCelsius */
@@ -94,6 +94,7 @@ static int tmp108_read(struct device *dev, enum hwmon_sensor_types type,
 	struct tmp108 *tmp108 = dev_get_drvdata(dev);
 	unsigned int regval;
 	int err, hyst;
+	s64 delay;
 
 	if (type == hwmon_chip) {
 		if (attr == hwmon_chip_update_interval) {
@@ -123,12 +124,10 @@ static int tmp108_read(struct device *dev, enum hwmon_sensor_types type,
 
 	switch (attr) {
 	case hwmon_temp_input:
-		/* Is it too early to return a conversion ? */
-		if (time_before64(get_jiffies_64(), tmp108->ready_time)) {
-			dev_dbg(dev, "%s: Conversion not ready yet..\n",
-				__func__);
-			return -EAGAIN;
-		}
+		/* Wait if it is too early to return a conversion */
+		delay = ktime_us_delta(tmp108->ready_time, ktime_get());
+		if (delay > 0)
+			usleep_range(delay, delay + 1000);
 		err = regmap_read(tmp108->regmap, TMP108_REG_TEMP, &regval);
 		if (err < 0)
 			return err;
@@ -371,11 +370,8 @@ static int tmp108_probe(struct i2c_client *client)
 		return err;
 	}
 
-	tmp108->ready_time = get_jiffies_64();
-	if ((tmp108->orig_config & TMP108_CONF_MODE_MASK) ==
-	    TMP108_MODE_SHUTDOWN)
-		tmp108->ready_time +=
-			msecs_to_jiffies(TMP108_CONVERSION_TIME_MS);
+	tmp108->ready_time = ktime_add_ms(ktime_get(),
+					  TMP108_CONVERSION_TIME_MS);
 
 	err = devm_add_action_or_reset(dev, tmp108_restore_config, tmp108);
 	if (err) {
@@ -405,8 +401,8 @@ static int __maybe_unused tmp108_resume(struct device *dev)
 
 	err = regmap_update_bits(tmp108->regmap, TMP108_REG_CONF,
 				 TMP108_CONF_MODE_MASK, TMP108_MODE_CONTINUOUS);
-	tmp108->ready_time = get_jiffies_64() +
-			     msecs_to_jiffies(TMP108_CONVERSION_TIME_MS);
+	tmp108->ready_time = ktime_add_ms(ktime_get(),
+					  TMP108_CONVERSION_TIME_MS);
 	return err;
 }
 
-- 
2.53.0



