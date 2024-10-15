Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A131D4154;
	Tue, 15 Oct 2024 12:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994007; cv=none; b=KzvZbSm75q0wX+lMQc6+JYwD3yqQIdM+nsPwTU3ysU1LEXZSOS+v5hcrrwPOpB6YH9rHmPvfiOi4iWHxGi5otqIyIvCR4Rx0zCjFJxURA+bXBun5W/LE9/Z6SJfjQjlHNgHRkEIgQLwN25TeVQSX0Lmx5DQQK/0tXn7Q3UIDI+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994007; c=relaxed/simple;
	bh=RMc9hGRG/VHKqsU8JZhxHagkNbvKIN7sp6Ts+VoUATc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byN8z3xMd3BMe/PTbstLsX50+kLbuaoOt3vAGmI0S33a7ebQrEkyK2cAWOmi4VtFwhzYIZRRJRHq/0AyK12oDdCV4yg6Xm17IpQUE6XA1bC6YjWQo9qc5yFEp9A/3C+oZ8Z4CFQr4oxLFIPPoKwlf2L4yexTy7KVa2CZLf6i6Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4FLTwBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4FLTwBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10022C4CEC6;
	Tue, 15 Oct 2024 12:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994007;
	bh=RMc9hGRG/VHKqsU8JZhxHagkNbvKIN7sp6Ts+VoUATc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4FLTwBsv97HTC17zFUHVUZ61qKL3dEd/nqB5qiHTEuKG/w5aybbokBzR+Mb34h10
	 IBXgMiPqjNT+NeCSK2bXr+TiT9OfLEZtn4gDV0e3LFNaj1h9j5v4Ne9S7buyefE5GA
	 i3sPv9ApCfY8gfLXLpTW/7e7B3KUEy3/WJuTYlvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/691] i2c: smbus: Use device_*() functions instead of of_*()
Date: Tue, 15 Oct 2024 13:28:20 +0200
Message-ID: <20241015112502.250131313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit a263a84088f689bf0c1552a510b25d0bcc45fcae ]

Change of_*() functions to device_*() for firmware agnostic usage.
This allows to have the smbus_alert interrupt without any changes
in the controller drivers using the ACPI table.

Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 8d3cefaf6592 ("i2c: core: Lock address during client device instantiation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c  |  2 +-
 drivers/i2c/i2c-core-smbus.c | 11 ++++++-----
 drivers/i2c/i2c-smbus.c      |  5 +++--
 include/linux/i2c-smbus.h    |  6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index b163ef91aabab..c8cb6f44a0f88 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1526,7 +1526,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 		goto out_list;
 	}
 
-	res = of_i2c_setup_smbus_alert(adap);
+	res = i2c_setup_smbus_alert(adap);
 	if (res)
 		goto out_reg;
 
diff --git a/drivers/i2c/i2c-core-smbus.c b/drivers/i2c/i2c-core-smbus.c
index e5b2d1465e7ed..304c2c8fee68e 100644
--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/i2c-smbus.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #include "i2c-core.h"
@@ -701,13 +702,13 @@ struct i2c_client *i2c_new_smbus_alert_device(struct i2c_adapter *adapter,
 }
 EXPORT_SYMBOL_GPL(i2c_new_smbus_alert_device);
 
-#if IS_ENABLED(CONFIG_I2C_SMBUS) && IS_ENABLED(CONFIG_OF)
-int of_i2c_setup_smbus_alert(struct i2c_adapter *adapter)
+#if IS_ENABLED(CONFIG_I2C_SMBUS)
+int i2c_setup_smbus_alert(struct i2c_adapter *adapter)
 {
 	int irq;
 
-	irq = of_property_match_string(adapter->dev.of_node, "interrupt-names",
-				       "smbus_alert");
+	irq = device_property_match_string(adapter->dev.parent, "interrupt-names",
+					   "smbus_alert");
 	if (irq == -EINVAL || irq == -ENODATA)
 		return 0;
 	else if (irq < 0)
@@ -715,5 +716,5 @@ int of_i2c_setup_smbus_alert(struct i2c_adapter *adapter)
 
 	return PTR_ERR_OR_ZERO(i2c_new_smbus_alert_device(adapter, NULL));
 }
-EXPORT_SYMBOL_GPL(of_i2c_setup_smbus_alert);
+EXPORT_SYMBOL_GPL(i2c_setup_smbus_alert);
 #endif
diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 44582cf29e162..cacdadb9415c5 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -13,7 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of_irq.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
@@ -178,7 +178,8 @@ static int smbalert_probe(struct i2c_client *ara,
 	if (setup) {
 		irq = setup->irq;
 	} else {
-		irq = of_irq_get_byname(adapter->dev.of_node, "smbus_alert");
+		irq = fwnode_irq_get_byname(dev_fwnode(adapter->dev.parent),
+					    "smbus_alert");
 		if (irq <= 0)
 			return irq;
 	}
diff --git a/include/linux/i2c-smbus.h b/include/linux/i2c-smbus.h
index 1ef421818d3a8..95cf902e0bdae 100644
--- a/include/linux/i2c-smbus.h
+++ b/include/linux/i2c-smbus.h
@@ -30,10 +30,10 @@ struct i2c_client *i2c_new_smbus_alert_device(struct i2c_adapter *adapter,
 					      struct i2c_smbus_alert_setup *setup);
 int i2c_handle_smbus_alert(struct i2c_client *ara);
 
-#if IS_ENABLED(CONFIG_I2C_SMBUS) && IS_ENABLED(CONFIG_OF)
-int of_i2c_setup_smbus_alert(struct i2c_adapter *adap);
+#if IS_ENABLED(CONFIG_I2C_SMBUS)
+int i2c_setup_smbus_alert(struct i2c_adapter *adap);
 #else
-static inline int of_i2c_setup_smbus_alert(struct i2c_adapter *adap)
+static inline int i2c_setup_smbus_alert(struct i2c_adapter *adap)
 {
 	return 0;
 }
-- 
2.43.0



