Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038521;
	b=mNCOCPcOgxMoKC85JTrBSAXpfeSoSLdPmytBtQ4vGMW2HjcxJjRub8QQtbY+NXQw5JQD
	 FVXqyXjS02d43nwELxmpg/RoV98ehXF2otK0jzxSLqIn2hjMgsuvCNnETez/OqX7vRi36
	 UvKogLuyOptM7LH9NPXvhBSOJNn+tdy9zhG2UzOt5oAovzQ79Jn3CN2tzObsw4MVlF6K6
	 uoedlH9AMmtIJFwoutv6eFE0FNjmPeUPTdjEKDa+Utt1+0B11jXBkATh9fuvsb6IJmAAq
	 PERz+srYPlW+uzX3N7OzXK5aktm/xYObcZMJxUUgpEeeP+8NlQr95jPkDIIQXSPqpuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+cxD1GYKGmeENzwWnSRF04xPOReC5I2O0VUgrBSneNc=;
	b=Z2ct+70593FbT17iib96KNuTlLpVYLJc7cnSkuadG7gwBDP/+c2gtqRJR9W3YleKJy6X
	 fM/YhZqq0W0YIJK9kzjKdGAHGmpnxFANUQOugreJuIAM0cqYAWY/IoPW06t7NleT1HCHI
	 fAHhaCoo7xGsCehddCTJ8eSgyDM/zDP92gM6XPXynpgDphF4kTdIlAOUsqK132F41Cucp
	 dJ3ncGS6rCY0Ro750e/1WarNQheZdp0SiQNu3A0uzYFPaMwAW4tB4UOhjQhJspuc9wlh8
	 gyepxjLc2zd9ebc5/SyoiAcv9iSAu/i43QSyXSjSjvZd0q7F16ZJ9vL8SCE1lqO5RGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpfXaBG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68CE606A330;
	Wed, 18 Nov 2026 21:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpfXaBG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478321F000C4;
	Wed, 18 Nov 2026 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038520;
	bh=+cxD1GYKGmeENzwWnSRF04xPOReC5I2O0VUgrBSneNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpfXaBG8TAergy8aTR1sCZnA+JlwB+YnQytMGcxguPZXoIWPPucIDOXBVDJpp63bb
	 PSFI1A9N3awMhhO89o2pb9i0l1OKdxY9nwSGdC82XmM034KcJV+CgEA7RwDSrpIPWY
	 f9fuIvIYijeprEqFSCg0SDmVlYOrFX3kcn/Ir5xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1771/3318] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Wed, 18 Nov 2026 15:39:53 +0100
Message-ID: <20261118150414.986123505@linuxfoundation.org>
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
[ sashal: adapted the power check from power_meter_read() to show_power() using resource instead of res ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index b772c076a5aed..1743467e65db9 100644
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



