Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053635;
	b=wSq30bKxvj7Pkm1VSpUSutRpq0xZDiOoxCo0UFffCpGNblOL9sgkktojuxi54khFO+VX
	 bJZTPcOD2ppc8MU8ywQCuU79G6vO8oZ3ojWjPipSm3yldYcEmqwYuWCPESpqt9M4PxNZB
	 B+0S4vmqoYvRmGOTSPTGNk03XbAYAPoQxRlOKoyWy7OXYoxHA6lzd8gPF8M3UKZay+2A+
	 Xj/KCoG0GYvSjKhluVEOxCltcnmXQmc7TsUCgMRifjUlJ23u1SfzwYyz2dQHIgYyYpWaW
	 idWUXE5Zbu6lCv0Y/AH0+PyElshpZpx2344krHmXC7vdpiqNlzpMr4rI8X+XtlNfysw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GGNw/Q5BZm4vcYqN+uxyw3HWZW8FHlkjYJG6LSzmaoo=;
	b=dz1mA8Jl9R/lqPSMbukKyf8Mp/uVePSHjj0V0PfMOTU8JMovpqemM9vqkrWlGu3Bht8K
	 j8Pq8sySH02C+BxckdBWwY7x9oo+mUdxj9+O3o1wAmCM8CBSw/MYd2rsfiqUevbNzooyf
	 K/pBY1jPOi6rLRVS/HaaXjP5ml62aKminvSM2iJIcOoVmgHvUZDEDQm5/1yzwnIDuKnS2
	 ESWe1x0AA4eu1T4cDBJxJ9tjd+M6Q0ov2Jfu3zOTA1qXTnPKoE6JiV9eTCAtbUyRe9mTE
	 pB3t7AQRN/L2kfdXTDmJ5XG0KybKqE98aZPK1Jt+PdOjKXu3bz+qe5yOdr8izSqib+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0C4x1dA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D0606A32A;
	Thu, 19 Nov 2026 02:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0C4x1dA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FE11F000C4;
	Thu, 19 Nov 2026 02:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053635;
	bh=GGNw/Q5BZm4vcYqN+uxyw3HWZW8FHlkjYJG6LSzmaoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0C4x1dA1AroDuQqpd1gEjq1bgx6k7z56M53brnzzgpxNasv0YwKrWIykIumzqyr/
	 Iv89bXGpGnEC5i30i5PBICuf/X95T5ykIdn388kcQPaQznM13BLmDsf7pp3PeoLGFG
	 bRPY/t+FUaJfF+C5n/KA335MJXih6p1aN+zM/PDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Verdonck <tom.verdonck@inspiral.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0990/2214] hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check
Date: Wed, 18 Nov 2026 15:44:26 +0100
Message-ID: <20261118150051.946173024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Verdonck <tom.verdonck@inspiral.be>

[ Upstream commit 56c1d32323e773b8b927316f8beeae9238576335 ]

tmp102 records a one-shot deadline in ->ready_time at probe (and resume)
and, on every temperature read, refuses the read with -EAGAIN while
time_before(jiffies, ready_time) is true, in order to skip the first
~35 ms conversion.

->ready_time is an unsigned long compared with time_before(), whose
signed difference is only meaningful while the two values are within
LONG_MAX jiffies of each other. Because ->ready_time is set once and
never refreshed, jiffies keeps advancing away from it, and after 2^31
jiffies the difference flips sign. On a 32-bit HZ=100 kernel that
happens ~248.5 days after boot: time_before() then permanently reports
"not ready" and the driver returns -EAGAIN on every read, without ever
touching the sensor, until the next reboot.

Store the deadline as a 64-bit jiffies value and compare it with
get_jiffies_64()/time_before64(), which does not wrap in any practical
uptime.

Fixes: 3d8f7a89a197 ("hwmon: (tmp102) Improve handling of initial read delay")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Verdonck <tom.verdonck@inspiral.be>
Link: https://patch.msgid.link/2952f070f82913aea96eec25d28008d3b9058656.1790358356.git.tom.verdonck@inspiral.be
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: adjusted context for the simpler tmp102 structure and tmp102_read() instead of tmp102_read_temp() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp102.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index e867a0c2e5399..181373cc1289a 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -54,7 +54,7 @@
 struct tmp102 {
 	struct regmap *regmap;
 	u16 config_orig;
-	unsigned long ready_time;
+	u64 ready_time;
 };
 
 /* convert left adjusted 13-bit TMP102 register value to milliCelsius */
@@ -79,7 +79,7 @@ static int tmp102_read(struct device *dev, enum hwmon_sensor_types type,
 	switch (attr) {
 	case hwmon_temp_input:
 		/* Is it too early to return a conversion ? */
-		if (time_before(jiffies, tmp102->ready_time)) {
+		if (time_before64(get_jiffies_64(), tmp102->ready_time)) {
 			dev_dbg(dev, "%s: Conversion not ready yet..\n", __func__);
 			return -EAGAIN;
 		}
@@ -245,7 +245,7 @@ static int tmp102_probe(struct i2c_client *client)
 	 * Mark that we are not ready with data until the first
 	 * conversion is complete
 	 */
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
 							 tmp102,
@@ -279,7 +279,7 @@ static int tmp102_resume(struct device *dev)
 	err = regmap_update_bits(tmp102->regmap, TMP102_CONF_REG,
 				 TMP102_CONF_SD, 0);
 
-	tmp102->ready_time = jiffies + msecs_to_jiffies(CONVERSION_TIME_MS);
+	tmp102->ready_time = get_jiffies_64() + msecs_to_jiffies(CONVERSION_TIME_MS);
 
 	return err;
 }
-- 
2.53.0



