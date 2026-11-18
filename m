Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059796;
	b=p+sCJAwEptReEiCe/QICdMzjiNdMlPIzcnp/Y5nehlKsawamwY34kpl7nnH4uO3UZQGT
	 t3WHUQKVy8GY826g6UTLVuYHGtX1ZIacRcgekBjvCRI8NUf8oaWialAzScuxwMrvmYGHG
	 C0NNd5CXcHAtp7G0loBxK/fEM4TZlp45PzEnSpf04sv0WOTW8C/Mk3czn+lERaGxhlKlx
	 faYUFwczRJ/lkVP0sNazjU7O+yMyEv/1PNhZjpF0XubmnjG9AZkbfMEy3bYtXRi7GZh4a
	 dUThncEpHeJg2hwa3+BYzRxbW/bKuDo4vk1HMLS/PNWLbXiHcW0BYv8mgWbjVIzccWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=207pTpIxauG7ew/WRBXlAMhl+We31TrgZwLB8jcB8EE=;
	b=r9FGAIluFpZDkILzfelVeYkaX2r0ZGvKX5FE0lRMV05j3WQlCr4Q+a+H41gDq8XnIt0m
	 v4uNskpDw91BywGESXDeBZXAGOvSQiA+NC4UWUG/LmUmaXyPociJfy3ee5eIwuFhsubBN
	 PynzedhWr/+Ff6LzdrMrxaF1MFlkcagPnI9RDBG8vZvzYHf+qhOCDhrPz3Hauo+4OGb2c
	 vp/k6InMoHGbkfDd0h1dqLmxItLxw+pI/eCNsZgWX7v6cLehvln8Za2INbW/mo08nzs2s
	 98L7DOeVhIttiWhHQk2Lbvm+08UgmyMFVzUESK1OFqdPvvCwMZ4z7DKdb9nTo6IEbBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjZNsdUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91E1606A32A;
	Thu, 19 Nov 2026 03:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjZNsdUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2C51F000C4;
	Thu, 19 Nov 2026 03:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059796;
	bh=207pTpIxauG7ew/WRBXlAMhl+We31TrgZwLB8jcB8EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjZNsdUG01MmNGOPYDgA6ZMG7PbIidhoNx9g/IJSop5ijN9flLXhdju6vmCGKQq9O
	 imIJwza5lTpVcFsql6obnu+S2oEuNAF1PsgMDwPH2dyvgoxzgYIbft9twGbEXToHkE
	 7V/oZ3bDQHQWoH3qXl7I3o9CsN3UA4f9ilGuOC08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Slater <github@firefishy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0933/1848] hwmon: (acpi_power_meter) Fix 18.45 TW bug
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118145955.813410053@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the power check to show_power() instead of power_meter_read() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 5794d44538e9c..94d6c3cef0f7d 100644
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
@@ -32,7 +33,12 @@ ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
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
@@ -344,7 +350,7 @@ static ssize_t show_power(struct device *dev,
 	update_meter(resource);
 	mutex_unlock(&resource->lock);
 
-	if (resource->power == UNKNOWN_POWER)
+	if (resource->power == UNKNOWN_POWER_32 || resource->power == UNKNOWN_POWER_64)
 		return -ENODATA;
 
 	return sprintf(buf, "%llu\n", resource->power * 1000);
-- 
2.53.0



