Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028629;
	b=kbXq0TdlMlbIIO354cH3ZpA55wgUa+f3t/tB6Y9enzUKtHxuqCtQWpK/hi7KXdvfeoO/
	 H/r15Tco6OQStTvD0/zcLdRQnjm8LPC6T9Q2I4N2JEoqGqd3XwngUHgTMpBOEx3zhm9bt
	 avwCj3g+3pCsPvsOo1hEk7h5iUG8lhXCID+4Tb30cIibknbsJXCNMB8urxLd1ZIsBHp0f
	 eTU+aKnnnJXe6A693VM1UzSiZcmbo/mmSAN9CdGjz3VOLy14SWmjWVyeeZzwUT51Tdx0P
	 vOEzHLYbH8hZcvm4e3m1ayoIdyoAPWeHkOKW2W+XPodUmrDwCrM/8ta189AvYQfph4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSj6JftcuxopaybhQUk+irMAriNxZu9vR4VJAU3mS88=;
	b=f7gP3BLS+W+u7/s139R9pMFkvofqZ0GtDNdMAz/UZVj42SlKHmPyXAVJazfGHbZH8JxT
	 tv9If0Rss/0m2udVcB5WRIwGR9aZnVmLDDBHSLBh4N2xtYLb9xjczzpIZhZALgdGEcG6G
	 5T8cg0swYkO9Wo3tAFJZeq0vueeMQ3yvPOK6U8ov7wZwPufPs2M12qr/6QTQOYDPdnNyC
	 v3n6yPazmqmmmz8Dfwu4FhGZyRpTwHAlK5etzL4uWsbMUD26+9BTA+7QvaHYiJ2orMPoR
	 mHl3m4mOdU7+/MywJJA/5KyH2oX57vPj15G/Sqfl8Bgvwd4wb7nw5/2fz8GTIa6D1+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWk4Kl0a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136DA606A325;
	Wed, 18 Nov 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWk4Kl0a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BAC1F000C4;
	Wed, 18 Nov 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028628;
	bh=pSj6JftcuxopaybhQUk+irMAriNxZu9vR4VJAU3mS88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWk4Kl0ansRGS7LpD4Lv09Stoy8VKSWqset/Y4Zm3uh+KSK6YSsCxAbgveYPRJyjp
	 /CtRYU8Oz/Ltx02aBbM0yGQmMuRfJnFKm/hgI5ce1LaUKnQ0QCoM30VsBjSEllGRJX
	 SFtfnMFcmbd3kiyOD0EVI4Zvuuwelk2qaDPQ2egU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0061/1756] hwmon: (chipcap2) Drop unnecessary include files
Date: Wed, 18 Nov 2026 15:36:28 +0100
Message-ID: <20261118150010.785837518@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4c8d758d4ebff3780d09599f2c8db5d6af3ca2af ]

The driver does not perform any locking, does not execute or use any sleep
related functionality, and does not allocate memory. Drop the unnecessary
include files.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: bed5f0c075eb ("hwmon: chipcap2: serialize access to the alarm indicators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 2572710fb2384..4a9c51c792aed 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -82,7 +82,6 @@ struct cc2_data {
 	struct completion complete;
 	struct device *hwmon;
 	struct i2c_client *client;
-	struct mutex dev_access_lock; /* device access lock */
 	struct regulator *regulator;
 	const char *name;
 	int irq_ready;
@@ -575,8 +574,6 @@ static int cc2_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 {
 	struct cc2_data *data = dev_get_drvdata(dev);
 
-	guard(mutex)(&data->dev_access_lock);
-
 	switch (type) {
 	case hwmon_temp:
 		return cc2_measurement(data, type, val);
@@ -617,8 +614,6 @@ static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	if (val < 0 || val > CC2_RH_MAX)
 		return -EINVAL;
 
-	guard(mutex)(&data->dev_access_lock);
-
 	switch (attr) {
 	case hwmon_humidity_min:
 		cmd = CC2_W_ALARM_L_ON;
@@ -712,8 +707,6 @@ static int cc2_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, data);
 
-	mutex_init(&data->dev_access_lock);
-
 	data->client = client;
 
 	data->regulator = devm_regulator_get_exclusive(dev, "vdd");
-- 
2.53.0



