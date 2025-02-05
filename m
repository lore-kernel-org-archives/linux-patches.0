Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA9F16DC12;
	Wed,  5 Feb 2025 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765316; cv=none; b=UbvNQOz/AP3fc37nDr4x5tKTbXX87WeCKbslhEsoxAXXT6OWP1sYUB3CQbMqPfBK0d3WzYunIRZR+MtTooHIXWeOsIXQwAzuO3ea8SDsNWS8bu0YQmVfuaZIchLpGQRfpyeTwJ12uuRLqEKz+2F/tENzOdjqqDrXoXAdV2uZUzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765316; c=relaxed/simple;
	bh=J28K5M2QXwE5tl6PcmY/Is99H6jIn4veHRlHj1+AeGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pgamr+mS56BN9/aa4Tnr2hlHa2L4s/QbSJ3qDWTUcIlYqi2kme/SRWgvCm6m9Til8Mtlb6jSGsD+QhjaEcqD5c8KNma5QXJux5XRU5S2SWReaxy66Xy+43I0Re3oBEv7xnEu23zQiA0UI1NejFgXfiHTBsgGFcoxgD7konVpbdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcE8/YxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcE8/YxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776B1C4CED1;
	Wed,  5 Feb 2025 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765316;
	bh=J28K5M2QXwE5tl6PcmY/Is99H6jIn4veHRlHj1+AeGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcE8/YxCFOQMEB9R1pDQPA9kgo5NQ8z/FKjmrsSyNCXtb2sMtINPC9McI4Pf0eF9K
	 xNZ5DSoGPb1w/RAjNajXBU4fw2b62YZo/9H1e5L8qNPWTPoq0nRo19epZnw6a4EfsE
	 x0vrtekra5xnEllPK6j39jfGvFI4J80SkUF6Z0lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/590] i2c: designware: Actually make use of the I2C_DW_COMMON and I2C_DW symbol namespaces
Date: Wed,  5 Feb 2025 14:39:24 +0100
Message-ID: <20250205134503.280098105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit f0a4e9fa656ceb3b2e4c296cf6226798d804fa22 ]

DEFAULT_SYMBOL_NAMESPACE must already be defined when <linux/export.h>
is included. So move the define above the include block.

Fixes: fd57a3325a77 ("i2c: designware: Move exports to I2C_DW namespaces")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-common.c | 5 +++--
 drivers/i2c/busses/i2c-designware-master.c | 5 +++--
 drivers/i2c/busses/i2c-designware-slave.c  | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 0e7771d21469d..b3282785523d4 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -8,6 +8,9 @@
  * Copyright (C) 2007 MontaVista Software Inc.
  * Copyright (C) 2009 Provigent Ltd.
  */
+
+#define DEFAULT_SYMBOL_NAMESPACE	"I2C_DW_COMMON"
+
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -29,8 +32,6 @@
 #include <linux/types.h>
 #include <linux/units.h>
 
-#define DEFAULT_SYMBOL_NAMESPACE	"I2C_DW_COMMON"
-
 #include "i2c-designware-core.h"
 
 static char *abort_sources[] = {
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index e23f93b8974e4..28188c6d0555e 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -8,6 +8,9 @@
  * Copyright (C) 2007 MontaVista Software Inc.
  * Copyright (C) 2009 Provigent Ltd.
  */
+
+#define DEFAULT_SYMBOL_NAMESPACE	"I2C_DW"
+
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -22,8 +25,6 @@
 #include <linux/regmap.h>
 #include <linux/reset.h>
 
-#define DEFAULT_SYMBOL_NAMESPACE	"I2C_DW"
-
 #include "i2c-designware-core.h"
 
 #define AMD_TIMEOUT_MIN_US	25
diff --git a/drivers/i2c/busses/i2c-designware-slave.c b/drivers/i2c/busses/i2c-designware-slave.c
index 0a76e10f77a2b..f0f0f1f2131d0 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -6,6 +6,9 @@
  *
  * Copyright (C) 2016 Synopsys Inc.
  */
+
+#define DEFAULT_SYMBOL_NAMESPACE	"I2C_DW"
+
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -16,8 +19,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 
-#define DEFAULT_SYMBOL_NAMESPACE	"I2C_DW"
-
 #include "i2c-designware-core.h"
 
 static void i2c_dw_configure_fifo_slave(struct dw_i2c_dev *dev)
-- 
2.39.5



