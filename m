Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054024;
	b=y9DS10XtPQrjruIyFrO01V5fPR0Z4XhVdoxW1ZvAXNR7f8eOSx/HWtwe5Cqa1q+kLoaF
	 ZakiJCEmBGesTitkD6iVEvWbCnDq/Uj3NPXoLUhS3jeniSJmv252npSrComcXLRogfKOm
	 Qfh88sGaOhs3fX/LIsgfYkos326JyNlsM9zLUi4c+T/H1qxnrfIagvQeLYlDeuxJxFfxO
	 9jy7+cUCS2g9U8fxxiRFAEe7O4fho973JjJceRdaq4+IGzB+auxxG4MuSHmtpXIdK5YbC
	 zqpo5wVG8Z61IVWQCvJ+tztLweVra9sTbUnTlYDMiqbagcArMVyEgZDryk2uk83Ee/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oXG3eBK6YzkjaUsn+jDhkATiKn1OT97ouRzqLP2S7qg=;
	b=ek/scN6uVm7Qr+nEcRhMJMzPv3JRZWsoDCagp2bDQCRAonUYqTn3VrR5Z4KKnjPz7ySX
	 6LY50npL2rhaQLJGITSxFbvy2J7HbELadOOwJ0z7tRWj7L6bdLgA63cBts5NCEp7ckgYq
	 NVnAnSzp8VSDIRu/AOjdNVPb+ptS8Lzh05TPmx6Zyb0XE643eO4yfa9duqVd4fai8T3St
	 xvlYbyBcHQmdweu9LWOL+sjyNmeKxEPGB2hfkcNMyIhB5g/dNNdY0Plenv3V9WTDJ8R5j
	 oYx89RR4xwEhSV9B9zmNDDOhuYLHzMyIfNR/UMvpH/XfBXhbk2uehpQllQrUnxU4oHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtKRrxh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB12606A31C;
	Thu, 19 Nov 2026 02:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtKRrxh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0521F000C4;
	Thu, 19 Nov 2026 02:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054024;
	bh=oXG3eBK6YzkjaUsn+jDhkATiKn1OT97ouRzqLP2S7qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtKRrxh6E4yNspbNm3QIIWahtjMPE7ltL/ybuyceNpbxTg0S1kd5uCP/0JHNPe0SC
	 Ma11Qyh+MUg+u1EYb1GibD7D0uubBSEV2UtEaiCg0zGymIS3mYVjLglGvHc9cFZd/8
	 +LoX+lfeBhYBpBAfD8xfsV4nC8gk28IneBfqXjoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1111/2214] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Wed, 18 Nov 2026 15:46:27 +0100
Message-ID: <20261118150056.585803666@linuxfoundation.org>
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
[ sashal: adapted the unknown-power check from power_meter_read() to show_power() using resource->power instead of res->power ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 1336f77106177..874de8b82adc0 100644
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



