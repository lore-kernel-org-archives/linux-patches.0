Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063509;
	b=tLX01GX1wmorhDKfyLsg6GaZTklkhVSp+OpxaKjix5tJllI8k5enMHYOULoTrTJhyR5S
	 Xp6hoaqKwxJTBpctiB3tv1w45TL4oEXMnCqG5HSf8GjisyiczmXwdSfdlLPDbtpCjUot8
	 SiItZC4iFg2HZz+ZruRa+xlqWFxGM+xBPRPLR1JBttBBAI7rVdrW/9r2TRd69k4Gdbx1c
	 hSleCUeUvKzANIbrPYxtd66RbrlWEtpkJYqcmS9tt8EaxwFhvs6mPTyuTwluu+eXmc9t4
	 M6S4mlit0ybjRcA7sE0SrAz4xFiOEFT/CRYr2n+l0tOC6KXgp6/dY3AQ9P0JbBzfQ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQZujWiG/x43ba+/zquF2saJHYn7pinXF1lCeHDATJ8=;
	b=ZzunOoUcNyxsSmO5pNpzty+PEm6OPzu+aUU1wngTzuDej/8x8a2j+pdPElYrpkgfB0IH
	 M2xLn5LRC/LPSzO9L0aSaAdnLL3zd0c0RPgz9LmK6PTvM6hWp3IWZiozs8vqHehVX7zc7
	 FPvlb3eX1Ida4YJWvq0FwpNyl+k9RIm/XMQ5Zr4G4I42gcrHZCB5eD9DndLp2/x1yRGaT
	 Gv0vjjwPb6Fvpcr4PiwZ/G4QK31CQ86ZJYVzurL0ei3eGpNON4hbBv4QyFvHYesO5uFZU
	 IjRAG3s4wILw+xW5LYF8od5zt0gK4f2bCTFbV8oL4HfmHRo3kZRTVP0bqrCNKwdaQ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7mq225K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5434B606B8AF;
	Sat,  7 Nov 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7mq225K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D1A1F008A4;
	Sat,  7 Nov 2026 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063509;
	bh=nQZujWiG/x43ba+/zquF2saJHYn7pinXF1lCeHDATJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7mq225K806P28Sb3S/fKvRr39Sqi8wqdqhuWiS4rx+oqd012IXvhqvuyMoKQSa8R
	 DaW4af7hRlIOyBG3TH+Z/4GMiPc6s2V2enFHiH2NjqYoHbSlV+2oFosukGrCxM9QAx
	 ebRmb3HCZRgganeFffUzlvub2/Vh3Ir0qildVj7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 653/869] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Sat,  7 Nov 2026 08:55:35 -0500
Message-ID: <20261107134915.200424701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index de408df0c4d78..667dffde33015 100644
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
@@ -454,7 +460,7 @@ static int power_meter_read(struct device *dev, enum hwmon_sensor_types type,
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



