Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047204;
	b=bGY+YoZThPLaoNSthoLYlyhTbkcdnXa85idWCE5T+jw+WYTaWkjtEH5SngNPfpSu0cWS
	 bW6KQE22fX/EmWdEwtJJiWX2NYc6WKzTDEZ0+Adpw491ILTu2gcjhhb8X6RVzaN9tneBQ
	 jsNcLRdPIeRcM6JpmIw4QcGtVqjkagiRUtqTgsovbPIQc+uOEIWkvRBRNdWcWUY2vPSgL
	 sFcYcYRlnekZX9pUEEx6KTmVu/r2Sz29w5sZqfH8qad+tj+KYD4fLuZqgMjaPX4+3nb74
	 cIJRVJ+DRaeSjklQxv2MozKH8cj8zmZoivFQnBNq5A1/9cpM2Jh1bbnyKonkZfKhQqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yfZmtx5XEcgZlcHAs+55jmAfjmDxxBUEH1dy2PlFsPE=;
	b=f7PZ+J//j44epeYb0za1YoyFaoFpzxpMlfy9xeEdLZCujyS8O+0VHbH89d4RvssxADym
	 vcwZ3u74DCrYaF3tGPDky031P4ZjHPfzPbfvLtDFEnvTL1Qgc8e/+SU1Auzi/0RQAEbV/
	 Qc+ccWBnWHGYZQ2jQkqLRnTlHmd6EOvcjVqOhJBAsQ1t1tpzTE77a1IW0XJhquInIikBX
	 z1S8YtCNGltjhrzxg9m3vrm1QBR0VdHSLUhExvoAt52Pok9otke2gIFYONNKEFkf4DE6N
	 ik1s6V67nkGy5wzn1sl8tiGXf4U3yaaAqElWbNOlmTg/XNiihc1AUNKC2mAzM6wQBDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV7Wgu9F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5B260A2601;
	Thu, 19 Nov 2026 00:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV7Wgu9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B01F000C4;
	Thu, 19 Nov 2026 00:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047203;
	bh=yfZmtx5XEcgZlcHAs+55jmAfjmDxxBUEH1dy2PlFsPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NV7Wgu9FZj/xVqO4WGdx5Nu8L6aABuPE+EzxAyzNUovUgxWcfOboWmTb75Xt2+v3X
	 GSvSAiXlsYzQL3QqKCMMFVIxPuEBjXTzszcDnRPce4CNaxqJTTLBHHxhdfe3VGJ3cX
	 Gh5BkqBogbaZ/hvJBVoyozSihIpXXBdAUuf/eFQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1515/2857] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118150255.878036046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2147afb725581..30872b62d7639 100644
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



