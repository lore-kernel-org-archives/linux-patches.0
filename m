Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065035;
	b=nDZ/PAhNwpopdG/eaRE/K7LbSjahczIJNKyGCrdTmRusnd1i7wp6ZrL+nx9G+S6oDZS8
	 Hrg7DrhsrAEbtwlWP89IOVb2EqmYInVRbeQAwl36/3/1gxMdxojmCKewzVFFzMDiBHEim
	 JUHrt5Ba+0mfSZopPREbs0mVl7bc2BF0UfnYTWTehR6IiLqgYtbJYzZ0ZA4NWHyrh3+jJ
	 kvvklPrXTrqtZPkr50+iOCT5TygTX1XLSZpZgvgTiRz68N9ZCXrfivu2/tNd+fBOPP5Pf
	 +cch6KV8BZw6o+WvY0Oz0CGsF1IbucAeRbOHVplWdDDmBl5MtiijiwHpJ9NhRniqKaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GbXXplOBV1//sUZwYDKRC1gRmd5Bt+1tAZ5T4mNG3W4=;
	b=pyKINkZD5pXRYoxU9JXjyz0YILhAeMZwoTCpbJmMkBkunhbGX3vUCSrzsEgi6wkKjt1Y
	 FY7TKfLMk1xRyRQslnXyQuH9PDlv+/l6c9k6xlr9VXukgJ1MuakinRlkUz+C2Ko1rGjbR
	 JlYC2ExHs3IO9tWmGnXZfMYQmTHWoTzgNd7JJWI6TZp0cdPcHfuRGPYc/+Rxu9K9wd/WW
	 OXPTXZGxqcfhHmAJl7mrBalGk0ilPTzb1IHV+PJZg2VPPCMxa6S6bdi7pIZhEj+CUUGPe
	 GOfpgNGoaiDA0Nh/pRPoygWAv++8GBSDD4x5NhuDr/oFKdGm2OdLWOnwFJ5hfYbyCEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBscVlta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A60606A326;
	Sat,  7 Nov 2026 15:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBscVlta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4698D1F008A2;
	Sat,  7 Nov 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065035;
	bh=GbXXplOBV1//sUZwYDKRC1gRmd5Bt+1tAZ5T4mNG3W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBscVltaxtnPjdJLeu/U08BRRMpWbfED91lffCIVLCE9mju0kYNT8wa5Q8ji9Z9w9
	 eSmE17SdKKQcosUXHiRlSTUXfzv+U/zSc+IVpGO4AooqZO9Ad8lviXQRy2zTer+T9d
	 tJCIEQ64tQxGCimVfTgDAPqUs8ODZCH6geuqgKzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0892/1257] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Sat,  7 Nov 2026 08:53:08 -0500
Message-ID: <20261107135003.957355326@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 0b6eda22f9ab67ddb2a872b0c3fc578ad9f4e27e ]

The ACPI specification says:

"If an error occurs while obtaining the meter reading or if the value
is not available then an Integer with all bits set is returned"

This integer can also be 64-bit wide on ACPI 2.0 and later systems,
so we have to check for that too.

Compile-tested only.

Reported-by: Grant Slater <github@firefishy.com>
Closes: https://github.com/lm-sensors/lm-sensors/issues/460
Fixes: 1fefca6c57fb ("hwmon: (acpi_power_meter) Fix 4.29 MW bug")
Cc: stable@vger.kernel.org
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20261006234618.10943-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 8a539e8d1334b..d3886adddf40f 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -10,6 +10,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/jiffies.h>
+#include <linux/limits.h>
 #include <linux/mutex.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
@@ -30,7 +31,12 @@
 #define POWER_METER_CAN_NOTIFY	(1 << 3)
 #define POWER_METER_IS_BATTERY	(1 << 8)
 #define UNKNOWN_HYSTERESIS	0xFFFFFFFF
-#define UNKNOWN_POWER		0xFFFFFFFF
+/*
+ * ACPI integers can either be 32-bit or 64-bit wide, so
+ * we have to check for both values.
+ */
+#define UNKNOWN_POWER_32	U32_MAX
+#define UNKNOWN_POWER_64	U64_MAX
 
 #define METER_NOTIFY_CONFIG	0x80
 #define METER_NOTIFY_TRIP	0x81
@@ -452,7 +458,7 @@ static int power_meter_read(struct device *dev, enum hwmon_sensor_types type,
 		ret = update_meter(res);
 		if (ret)
 			return ret;
-		if (res->power == UNKNOWN_POWER)
+		if (res->power == UNKNOWN_POWER_32 || res->power == UNKNOWN_POWER_64)
 			return -ENODATA;
 		*val = res->power * 1000;
 		break;
-- 
2.53.0



