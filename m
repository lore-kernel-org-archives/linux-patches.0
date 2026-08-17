Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489C43D7D70;
	Mon, 17 Aug 2026 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980272; cv=none; b=MRqqFbAaZXTS/JAxJWR5wzvHBkbwuyFUF9j0ybb8yHXfDwwpRLRQdmzopMLr73HxUub+iakmHwfESYjMAT24mxjRRas5cHPJAUfTG0k+VzRWi+4Hyrk1RC5976PNfO8BWoZzPcFCmOG2j1vVe8+Fvjx8eTfDY0it+N+xi2m0QY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980272; c=relaxed/simple;
	bh=rsUUUEbWNFoYIJ5EioV8hJgF6RhdlxrdG5uDiIXLjCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQlWy+GNFM68zvI6n5vQPm9qjZk8DTT/D+RShQnX9S026TDuf1/IAAZ2mpUQCnPAe/2elU/V525thyWlQQ60xeiBpIqAar1FUDYKPy/dg6Fa+cZ/fISdd4hQrtUZvL9KvyBW31WAHz6iYsrJ5CdFo6uLBlmRq7tUEEW26P2vDyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5o0xIP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5o0xIP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E511F000E9;
	Mon, 17 Aug 2026 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980271;
	bh=jp4f1YsFvnsIZa3opA0x2KSROs+nDVr5xxulIaMYdv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5o0xIP2ZmnGwF+/o9rAHWpTyQlIIsqaqLg6hr8ronke+RcGD5iNG/a8aMuMB6G5b
	 fi+r0zkr0+KqKxKBi8u8NDUBaqdmuYNTp9HEAJW+tagjXAsW7Z8nyinLcLjfJHKLSC
	 7810cD8fGrTqTw+4CdZEgIg8r5r5vHqPQOfmOmbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 514/609] hwmon: (lm25066) Use i2c_get_match_data()
Date: Mon, 17 Aug 2026 15:33:30 +0200
Message-ID: <20260817132601.045258840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit ac0c26bae662138eac9b49215e505b402f7e80e3 ]

Use preferred i2c_get_match_data() instead of of_match_device() and
i2c_match_id() to get the driver match data. With this, adjust the
includes to explicitly include the correct headers.

Adjust the 'chips' enum to not use 0, so that no match data can be
distinguished from a valid enum value.

Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20231115205703.3730448-3-robh@kernel.org
[groeck: Use double cast for enum chips assignment to make compiler happy]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 0dabe8a56f77 ("hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/lm25066.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index 09792cd03d9fd..a99f073c2d0b9 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -14,10 +14,10 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 #include "pmbus.h"
 
-enum chips { lm25056, lm25066, lm5064, lm5066, lm5066i };
+enum chips { lm25056 = 1, lm25066, lm5064, lm5066, lm5066i };
 
 #define LM25066_READ_VAUX		0xd0
 #define LM25066_MFR_READ_IIN		0xd1
@@ -468,8 +468,6 @@ static int lm25066_probe(struct i2c_client *client)
 	struct lm25066_data *data;
 	struct pmbus_driver_info *info;
 	const struct __coeff *coeff;
-	const struct of_device_id *of_id;
-	const struct i2c_device_id *i2c_id;
 
 	if (!i2c_check_functionality(client->adapter,
 				     I2C_FUNC_SMBUS_READ_BYTE_DATA))
@@ -484,14 +482,8 @@ static int lm25066_probe(struct i2c_client *client)
 	if (config < 0)
 		return config;
 
-	i2c_id = i2c_match_id(lm25066_id, client);
+	data->id = (enum chips)(unsigned long)i2c_get_match_data(client);
 
-	of_id = of_match_device(lm25066_of_match, &client->dev);
-	if (of_id && (unsigned long)of_id->data != i2c_id->driver_data)
-		dev_notice(&client->dev, "Device mismatch: %s in device tree, %s detected\n",
-			   of_id->name, i2c_id->name);
-
-	data->id = i2c_id->driver_data;
 	info = &data->info;
 
 	info->pages = 1;
-- 
2.53.0



