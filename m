Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C1B439F71;
	Mon, 17 Aug 2026 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978561; cv=none; b=A4+MteunV4qj7kElO+VtKl3q9a3AmEyn4xgWo/V9P7+zeChnVK+cVLLC1UzDA0ncc8MdWiZXIChdiFfGFXrv53SAgSZJfxvzklklmqFh7XVPat/kx54ubGaGUCfxwMBRqK+7qoi2lqJmRar3swFUyjjfZphoh+zz2Fq04nndYek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978561; c=relaxed/simple;
	bh=82Csk9UCd4ZEYCKu6nJSLJpfLBQ0Os/FZlJNHaqdupQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx3jskXF/dIsPLHABdLBcqJ2OYtfO/WMqgqw+70is7IZZk3KY9qlWr2eWOu5xmefNzVUvVsOnRIbXB99d/FXW0Y9DTwY6FjWsynrPdM0qds51TMAcPYdScQSrO06cTpKwrZmf1Z4V71nrovpqOcWjxFdQKicu/ouUrVVoUPGgjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbdIYJtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbdIYJtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE001F000E9;
	Mon, 17 Aug 2026 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978559;
	bh=Bdd8VyEdUkZsCCZu22z4IJYhoK2DHdfgPDDjpUThvnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbdIYJtnuqojweyWrbjV+jcRHFI6nRYhswEpu+ZpV9agIpSjM42nMnh+wZghhBpl0
	 vghPLDEdckTZR8vi2IveXjWOXYUBfkT+NZ5uc2a7Om6hiTbhv0dry/U2MtjAAU/Cpb
	 9rA//PoMsyuOnxERBk6uIWMuJvPpVLECtEOC6WFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/156] hwmon: (lm25066) Use i2c_get_match_data()
Date: Mon, 17 Aug 2026 15:32:54 +0200
Message-ID: <20260817132536.178231118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 929fa6d34efdc..3a20df5a43ec8 100644
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



