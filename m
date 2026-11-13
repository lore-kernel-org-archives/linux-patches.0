Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591541;
	b=zOJfVfGc98XKslKro2punniTlpVtxq3VTlca+lvsqjdLnMXDdLBQt9p0ICQKg4RUTR4T
	 KmeTIMFOBFReJtyv6pMIDIeXkcVKksco2mfhPQhU6MG5wq1GRdXRT2W9hVrPrIT+z5N40
	 nea/AVdGWuJoU3LLgZ3BMuiAViOUrDdEw1k5mVBFKL/UL6uI239Mr5Bnf2pViay6zews0
	 WGrbUjcrqR8x/xaUWeeT2SYM02sdeKJuNN9EXs4pHhWzeKl5Bz9e36cAi9cEOabciM+yj
	 kdZdn9Po+dWp7PrZoBwnWKUY1jqVAbM4DKXngOMEMeLNNCUiYBb88Z0JQ4EYhIwKWWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lHWzbZvcCj7jXHVamj2qjQHkBH2GWAibRxKEsw8t0n0=;
	b=xFKOVP8xufiZ0o0T/BO0L0mSW3HTpEG8tY/QrF9Zpr9Dsu0aKqePVfqVHzCTfr5HbeGX
	 RodpX2NSf5/ZlIfFH+JUQp3OrcY9Ljhysn1ef5vvMLq81POJU6KDn5vfH83ViUJjl9Ie4
	 GL0iZ+9o7Jm1eMrjss2DkyMsGdpDY7Kx72wwywMkaOqbP4U56JZzZA1w+JSUAWp0Q7Ee9
	 grBo4icC+R7dhyum/YZs6ZvMFbzY+dg+OZySpsNfMOIwaGMOQ97ztjyHY0huIYpuG5hRV
	 b2GKCbFipMjPMPwcXT/8pYTcCDACrp834n04LMwHto8aqGZV/g5shPcQ3kjf9+bdtRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wpf7YBm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E38606D4B5;
	Fri, 13 Nov 2026 17:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wpf7YBm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0741F000C4;
	Fri, 13 Nov 2026 17:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591541;
	bh=lHWzbZvcCj7jXHVamj2qjQHkBH2GWAibRxKEsw8t0n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wpf7YBm08wWgXL6O/UCf3J4o/LMxu2Cy35NRlm5GhD82eDl7JumLQghG39aV0V2gm
	 QttT0TZ/XwgwsswdI5ryWXKrA3WFo45aKzk/51YKPx6yJDxggT8Lib5GayjlzJCQok
	 122L1HEGugSbKLM8wW7hrH4tp8ABQdvbuKdUu3iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 595/670] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Fri, 13 Nov 2026 10:52:39 -0500
Message-ID: <20261113153831.994853215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adapted the power_meter_read() change to show_power() using its existing resource variable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 6c8a9c863528e..eedcfc9d96c6c 100644
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
@@ -31,7 +32,12 @@
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
@@ -349,7 +355,7 @@ static ssize_t show_power(struct device *dev,
 	update_meter(resource);
 	mutex_unlock(&resource->lock);
 
-	if (resource->power == UNKNOWN_POWER)
+	if (resource->power == UNKNOWN_POWER_32 || resource->power == UNKNOWN_POWER_64)
 		return -ENODATA;
 
 	return sprintf(buf, "%llu\n", resource->power * 1000);
-- 
2.53.0



