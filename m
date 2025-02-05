Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E3E155756;
	Wed,  5 Feb 2025 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766014; cv=none; b=LhY4DDrDkSzJukiEiRddC0l7VLZB+oyrCadgp0xh72eIB32SoXHZenYa5mmBums2akcJyZ4UbIcY3sSfkb4bT3Jcuzk7tpjsR8QJW2+8tsQVjjXvJz/OR5ss3n2n36uBJt7HHHNfXHgmIb3weXEBDyBMiQ3jbAqrBRg0qQ/qyYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766014; c=relaxed/simple;
	bh=CYraQN8jaMBYQml7wsD7pl60+9lJzgL+MCL4MiT6IQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0ZKIGjdpu/QPLXjntCP14+iBjcE1wNuJIIBxCout0QgYrNffZvIPSZrKL4sqEZ/dBmUtIxt5ee9JxsxZuInHnLVJXtXEeRu5YeEmvJalNSKiNEJ9g0G4NzYD6R+0cllIdIDBftaH0Q07xquslVpVGHwZU5r30BFsssJrX6PSYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEDAJW4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEDAJW4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3761C4CED1;
	Wed,  5 Feb 2025 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766014;
	bh=CYraQN8jaMBYQml7wsD7pl60+9lJzgL+MCL4MiT6IQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEDAJW4S07iECbXeonrUxqAfaOsOGxVQ2u0qMzLQ8COaWdk1rCjzQOsqGPxWTb66h
	 CzVM6svkzkDcdX45rbFLFHL4n1RXm9dGYUxUSfOomXmijtuTd4TUFEENCKkVyYVXQw
	 Qd/2b8Wz7jQHa2ObzmZJ0l3XhXeu9dFlx9DJlmqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 215/623] i2c: designware: Actually make use of the I2C_DW_COMMON and I2C_DW symbol namespaces
Date: Wed,  5 Feb 2025 14:39:17 +0100
Message-ID: <20250205134504.451526595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 183a35038eef9..8eb7bd640f8d3 100644
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
 
 static const char *const abort_sources[] = {
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index c8cbe5b1aeb19..2569bf1a72e0e 100644
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
index dc2b788eac5bd..5cd4a5f7a472e 100644
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



