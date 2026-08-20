Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A246946D0BD;
	Thu, 20 Aug 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244097; cv=none; b=F8JKbWT8vkUs1seMfs3mg5kAM430cKt784eWVREhHH4+dg9yU5jK3GSBfpOwxx07pnM+vZUryw1cXesT43aVWNDeyhIrNQczTa7nrmQeTO5jXDhIns9JLRkqwGqqK69jJTxV9wJYISjUr1VmlAr8xVUqUx25iFYVg+MBhy0uxAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244097; c=relaxed/simple;
	bh=lw267wk7nvB+R4XUjIkxnRQ1KT5e/11OuZ2bFnak5hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4kXTnGaETxBmsXSGpY5kIyPeRo5q/LCzgQkqkR0vElcYfIhMyvva2Br6WpXw0PAwTaLe/RGIf03zWZxR6RFby/3RFkRcTaJ0rdwvtvhoC/21RvQOf+o31Opc3KDPgFEhH/Q78vewRnTO/fHVvEpOFXzfeYAL9CsFdNDORkkKUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjO4M5XC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjO4M5XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082BB1F000E9;
	Thu, 20 Aug 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244096;
	bh=BeWGl+iIWyxijlfNbcOEH40xDyNhzfoDVFr2Nroo1Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjO4M5XCHYmYp7FksDDb0ppp0PjJDoVgLAYbbeN8FKg80FHAYMQnG6HXyB9mVk7rX
	 pHP1rQb93KCBcvT6yxwV8aqzS3G8mdat8c4wVnKEZqcjtymIfSGadnkI0WS17+Wvs6
	 6MzGfmDRs8URJuPKF/hTRP7brj9P3XqWcqaW5/nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/235] i2c: smbus: Use device_*() functions instead of of_*()
Date: Thu, 20 Aug 2026 16:54:45 +0200
Message-ID: <20260820145217.920882236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit a263a84088f689bf0c1552a510b25d0bcc45fcae ]

Change of_*() functions to device_*() for firmware agnostic usage.
This allows to have the smbus_alert interrupt without any changes
in the controller drivers using the ACPI table.

Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 158efa411c57 ("i2c: core: fix adapter probe deferral loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c  |    2 +-
 drivers/i2c/i2c-core-smbus.c |   11 ++++++-----
 drivers/i2c/i2c-smbus.c      |    5 +++--
 include/linux/i2c-smbus.h    |    6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1478,7 +1478,7 @@ static int i2c_register_adapter(struct i
 		goto err_put_adap;
 	}
 
-	res = of_i2c_setup_smbus_alert(adap);
+	res = i2c_setup_smbus_alert(adap);
 	if (res)
 		goto out_reg;
 
--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/i2c-smbus.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #include "i2c-core.h"
@@ -699,13 +700,13 @@ struct i2c_client *i2c_new_smbus_alert_d
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
@@ -713,5 +714,5 @@ int of_i2c_setup_smbus_alert(struct i2c_
 
 	return PTR_ERR_OR_ZERO(i2c_new_smbus_alert_device(adapter, NULL));
 }
-EXPORT_SYMBOL_GPL(of_i2c_setup_smbus_alert);
+EXPORT_SYMBOL_GPL(i2c_setup_smbus_alert);
 #endif
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
 
@@ -178,7 +178,8 @@ static int smbalert_probe(struct i2c_cli
 	if (setup) {
 		irq = setup->irq;
 	} else {
-		irq = of_irq_get_byname(adapter->dev.of_node, "smbus_alert");
+		irq = fwnode_irq_get_byname(dev_fwnode(adapter->dev.parent),
+					    "smbus_alert");
 		if (irq <= 0)
 			return irq;
 	}
--- a/include/linux/i2c-smbus.h
+++ b/include/linux/i2c-smbus.h
@@ -30,10 +30,10 @@ struct i2c_client *i2c_new_smbus_alert_d
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


