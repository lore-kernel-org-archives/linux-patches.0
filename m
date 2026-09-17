Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39E04ED185;
	Thu, 17 Sep 2026 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660791; cv=none; b=Ysh+NYX5BAvSke7zvct6icVE/B+He6pA7ZcRSI+pX6B8r6Xoc0suavSEKjbdzrdnBGFCBxXSoYe4XWgoeL1EjizoOHU6JhYHtXAy2HYtC05ijY5hQPLsAhaPKgv3cTrZWVEs4lZ6d1oqw8wWCoZXxjEypEUnFd98ydtFfgvmZdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660791; c=relaxed/simple;
	bh=jYFIdVZjViAsSdysHNVqy0UoiZqe+yMRuqCGMAALtmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHPg+fON/NS0xQe/Ms8X2nBIhh/Uc+RYecv7KeQ6RWxMJseX1IUoq8V1mA8gAO/QQ2+dCBn3bwue3qoZ/tY5Pugho6A6NF6MXqarDJJNtnDn1oh+XIbXmb2DwLN6kHLnsu5YBUA0tbA3ABvLapmMA6YsnUfqenGSwHIyUeh2neY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFVNJ7F6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFVNJ7F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23871F000FF;
	Thu, 17 Sep 2026 15:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660789;
	bh=Y+aMibLOkFdOfZBIsvMJh8vWqROk7HNL++qB+S25ZVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFVNJ7F6MGZCvUBvKfbPH/w+MLNCmn0ljgE5p0JRzspVWFQYzD2PBBeWPT8VbhG53
	 Jnc7qJ1oD/wTPtt3csoCqpl6a+ErF3btMYTht/gwPicvMRCD5MDphSlK4NgABXqrSi
	 KGxjJjASFXx0w7G9vhU1+IL1ahFfZhjCP2EsUbV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 711/733] i2c: designware: Global register definitions
Date: Thu, 17 Sep 2026 16:16:59 +0100
Message-ID: <20260917151410.612108901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 874ef9a6f2fc45d3f6021842d92fa5420fa4c825 ]

Moving the register definitions to a global header file
include/linux/designware_i2c.h. That removes the need to
duplicate them in the adaptation layers for this driver
outside of drivers/i2c/busses/. There is at least one of
those in drivers/gpu/drm/xe/xe_i2c.c.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260811121008.1493015-2-heikki.krogerus@linux.intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 2ab2fb31411a494e4579dfacda986a2672f80e65)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: f43fa4b8522b ("drm/xe/i2c: Fix the interrupt handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                                |    1 
 drivers/i2c/busses/i2c-designware-common.c |    2 
 drivers/i2c/busses/i2c-designware-core.h   |   85 -----------------------
 drivers/i2c/busses/i2c-designware-master.c |    2 
 drivers/i2c/busses/i2c-designware-slave.c  |    2 
 include/linux/designware_i2c.h             |  107 +++++++++++++++++++++++++++++
 6 files changed, 116 insertions(+), 83 deletions(-)
 create mode 100644 include/linux/designware_i2c.h

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26241,6 +26241,7 @@ R:	Andy Shevchenko <andriy.shevchenko@li
 L:	linux-i2c@vger.kernel.org
 S:	Supported
 F:	drivers/i2c/busses/i2c-designware-*
+F:	include/linux/designware_i2c.h
 
 SYNOPSYS DESIGNWARE I2C DRIVER - AMDISP
 M:	Nirujogi Pratap <pratap.nirujogi@amd.com>
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -33,6 +33,8 @@
 #include <linux/types.h>
 #include <linux/units.h>
 
+#include <linux/designware_i2c.h>
+
 #include "i2c-designware-core.h"
 
 #define DW_IC_DEFAULT_BUS_CAPACITANCE_pF	100
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -18,6 +18,8 @@
 #include <linux/regmap.h>
 #include <linux/types.h>
 
+#include <linux/designware_i2c.h>
+
 #define DW_IC_DEFAULT_FUNCTIONALITY		(I2C_FUNC_I2C | \
 						 I2C_FUNC_SMBUS_BYTE | \
 						 I2C_FUNC_SMBUS_BYTE_DATA | \
@@ -25,23 +27,6 @@
 						 I2C_FUNC_SMBUS_BLOCK_DATA | \
 						 I2C_FUNC_SMBUS_I2C_BLOCK)
 
-#define DW_IC_CON_MASTER			BIT(0)
-#define DW_IC_CON_SPEED_STD			(1 << 1)
-#define DW_IC_CON_SPEED_FAST			(2 << 1)
-#define DW_IC_CON_SPEED_HIGH			(3 << 1)
-#define DW_IC_CON_SPEED_MASK			GENMASK(2, 1)
-#define DW_IC_CON_10BITADDR_SLAVE		BIT(3)
-#define DW_IC_CON_10BITADDR_MASTER		BIT(4)
-#define DW_IC_CON_RESTART_EN			BIT(5)
-#define DW_IC_CON_SLAVE_DISABLE			BIT(6)
-#define DW_IC_CON_STOP_DET_IFADDRESSED		BIT(7)
-#define DW_IC_CON_TX_EMPTY_CTRL			BIT(8)
-#define DW_IC_CON_RX_FIFO_FULL_HLD_CTRL		BIT(9)
-#define DW_IC_CON_BUS_CLEAR_CTRL		BIT(11)
-
-#define DW_IC_DATA_CMD_DAT			GENMASK(7, 0)
-#define DW_IC_DATA_CMD_FIRST_DATA_BYTE		BIT(11)
-
 /*
  * Register access parameters
  */
@@ -55,65 +40,9 @@
 #define DW_IC_FIFO_RX_FIELD			GENMASK(15, 8)
 #define DW_IC_FIFO_MIN_DEPTH			2
 
-/*
- * Registers offset
- */
-#define DW_IC_CON				0x00
-#define DW_IC_TAR				0x04
-#define DW_IC_SAR				0x08
-#define DW_IC_DATA_CMD				0x10
-#define DW_IC_SS_SCL_HCNT			0x14
-#define DW_IC_SS_SCL_LCNT			0x18
-#define DW_IC_FS_SCL_HCNT			0x1c
-#define DW_IC_FS_SCL_LCNT			0x20
-#define DW_IC_HS_SCL_HCNT			0x24
-#define DW_IC_HS_SCL_LCNT			0x28
-#define DW_IC_INTR_STAT				0x2c
-#define DW_IC_INTR_MASK				0x30
-#define DW_IC_RAW_INTR_STAT			0x34
-#define DW_IC_RX_TL				0x38
-#define DW_IC_TX_TL				0x3c
-#define DW_IC_CLR_INTR				0x40
-#define DW_IC_CLR_RX_UNDER			0x44
-#define DW_IC_CLR_RX_OVER			0x48
-#define DW_IC_CLR_TX_OVER			0x4c
-#define DW_IC_CLR_RD_REQ			0x50
-#define DW_IC_CLR_TX_ABRT			0x54
-#define DW_IC_CLR_RX_DONE			0x58
-#define DW_IC_CLR_ACTIVITY			0x5c
-#define DW_IC_CLR_STOP_DET			0x60
-#define DW_IC_CLR_START_DET			0x64
-#define DW_IC_CLR_GEN_CALL			0x68
-#define DW_IC_ENABLE				0x6c
-#define DW_IC_STATUS				0x70
-#define DW_IC_TXFLR				0x74
-#define DW_IC_RXFLR				0x78
-#define DW_IC_SDA_HOLD				0x7c
-#define DW_IC_TX_ABRT_SOURCE			0x80
-#define DW_IC_ENABLE_STATUS			0x9c
-#define DW_IC_CLR_RESTART_DET			0xa8
-#define DW_IC_SMBUS_INTR_MASK			0xcc
-#define DW_IC_COMP_PARAM_1			0xf4
-#define DW_IC_COMP_VERSION			0xf8
 #define DW_IC_SDA_HOLD_MIN_VERS			0x3131312A /* "111*" == v1.11* */
-#define DW_IC_COMP_TYPE				0xfc
 #define DW_IC_COMP_TYPE_VALUE			0x44570140 /* "DW" + 0x0140 */
 
-#define DW_IC_INTR_RX_UNDER			BIT(0)
-#define DW_IC_INTR_RX_OVER			BIT(1)
-#define DW_IC_INTR_RX_FULL			BIT(2)
-#define DW_IC_INTR_TX_OVER			BIT(3)
-#define DW_IC_INTR_TX_EMPTY			BIT(4)
-#define DW_IC_INTR_RD_REQ			BIT(5)
-#define DW_IC_INTR_TX_ABRT			BIT(6)
-#define DW_IC_INTR_RX_DONE			BIT(7)
-#define DW_IC_INTR_ACTIVITY			BIT(8)
-#define DW_IC_INTR_STOP_DET			BIT(9)
-#define DW_IC_INTR_START_DET			BIT(10)
-#define DW_IC_INTR_GEN_CALL			BIT(11)
-#define DW_IC_INTR_RESTART_DET			BIT(12)
-#define DW_IC_INTR_MST_ON_HOLD			BIT(13)
-
 #define DW_IC_INTR_DEFAULT_MASK			(DW_IC_INTR_RX_FULL | \
 						 DW_IC_INTR_TX_ABRT | \
 						 DW_IC_INTR_STOP_DET)
@@ -123,16 +52,6 @@
 						 DW_IC_INTR_RX_UNDER | \
 						 DW_IC_INTR_RD_REQ)
 
-#define DW_IC_ENABLE_ENABLE			BIT(0)
-#define DW_IC_ENABLE_ABORT			BIT(1)
-
-#define DW_IC_STATUS_ACTIVITY			BIT(0)
-#define DW_IC_STATUS_TFE			BIT(2)
-#define DW_IC_STATUS_RFNE			BIT(3)
-#define DW_IC_STATUS_MASTER_ACTIVITY		BIT(5)
-#define DW_IC_STATUS_SLAVE_ACTIVITY		BIT(6)
-#define DW_IC_STATUS_MASTER_HOLD_TX_FIFO_EMPTY	BIT(7)
-
 #define DW_IC_SDA_HOLD_RX_SHIFT			16
 #define DW_IC_SDA_HOLD_RX_MASK			GENMASK(23, 16)
 
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -25,6 +25,8 @@
 #include <linux/regmap.h>
 #include <linux/reset.h>
 
+#include <linux/designware_i2c.h>
+
 #include "i2c-designware-core.h"
 
 #define AMD_TIMEOUT_MIN_US	25
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -19,6 +19,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 
+#include <linux/designware_i2c.h>
+
 #include "i2c-designware-core.h"
 
 int i2c_dw_reg_slave(struct i2c_client *slave)
--- /dev/null
+++ b/include/linux/designware_i2c.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Synopsys DesignWare I2C register definitions
+ *
+ * Copyright (C) 2026, Intel Corporation
+ */
+
+#ifndef __LINUX_DESIGNWARE_I2C_H
+#define __LINUX_DESIGNWARE_I2C_H
+
+#include <linux/bits.h>
+
+/*
+ * Registers offset
+ */
+#define DW_IC_CON				0x00
+#define DW_IC_TAR				0x04
+#define DW_IC_SAR				0x08
+#define DW_IC_DATA_CMD				0x10
+#define DW_IC_SS_SCL_HCNT			0x14
+#define DW_IC_SS_SCL_LCNT			0x18
+#define DW_IC_FS_SCL_HCNT			0x1c
+#define DW_IC_FS_SCL_LCNT			0x20
+#define DW_IC_HS_SCL_HCNT			0x24
+#define DW_IC_HS_SCL_LCNT			0x28
+#define DW_IC_INTR_STAT				0x2c
+#define DW_IC_INTR_MASK				0x30
+#define DW_IC_RAW_INTR_STAT			0x34
+#define DW_IC_RX_TL				0x38
+#define DW_IC_TX_TL				0x3c
+#define DW_IC_CLR_INTR				0x40
+#define DW_IC_CLR_RX_UNDER			0x44
+#define DW_IC_CLR_RX_OVER			0x48
+#define DW_IC_CLR_TX_OVER			0x4c
+#define DW_IC_CLR_RD_REQ			0x50
+#define DW_IC_CLR_TX_ABRT			0x54
+#define DW_IC_CLR_RX_DONE			0x58
+#define DW_IC_CLR_ACTIVITY			0x5c
+#define DW_IC_CLR_STOP_DET			0x60
+#define DW_IC_CLR_START_DET			0x64
+#define DW_IC_CLR_GEN_CALL			0x68
+#define DW_IC_ENABLE				0x6c
+#define DW_IC_STATUS				0x70
+#define DW_IC_TXFLR				0x74
+#define DW_IC_RXFLR				0x78
+#define DW_IC_SDA_HOLD				0x7c
+#define DW_IC_TX_ABRT_SOURCE			0x80
+#define DW_IC_ENABLE_STATUS			0x9c
+#define DW_IC_CLR_RESTART_DET			0xa8
+#define DW_IC_SMBUS_INTR_STAT			0xc8
+#define DW_IC_SMBUS_INTR_MASK			0xcc
+#define DW_IC_CLR_SMBUS_INTR			0xd4
+#define DW_IC_COMP_PARAM_1			0xf4
+#define DW_IC_COMP_VERSION			0xf8
+#define DW_IC_COMP_TYPE				0xfc
+
+/* DW_IC_CON bits */
+#define DW_IC_CON_MASTER			BIT(0)
+#define DW_IC_CON_SPEED_STD			(1 << 1)
+#define DW_IC_CON_SPEED_FAST			(2 << 1)
+#define DW_IC_CON_SPEED_HIGH			(3 << 1)
+#define DW_IC_CON_SPEED_MASK			GENMASK(2, 1)
+#define DW_IC_CON_10BITADDR_SLAVE		BIT(3)
+#define DW_IC_CON_10BITADDR_MASTER		BIT(4)
+#define DW_IC_CON_RESTART_EN			BIT(5)
+#define DW_IC_CON_SLAVE_DISABLE			BIT(6)
+#define DW_IC_CON_STOP_DET_IFADDRESSED		BIT(7)
+#define DW_IC_CON_TX_EMPTY_CTRL			BIT(8)
+#define DW_IC_CON_RX_FIFO_FULL_HLD_CTRL		BIT(9)
+#define DW_IC_CON_BUS_CLEAR_CTRL		BIT(11)
+
+/* DW_IC_DATA_CMD bits */
+#define DW_IC_DATA_CMD_DAT			GENMASK(7, 0)
+#define DW_IC_DATA_CMD_FIRST_DATA_BYTE		BIT(11)
+
+/* DW_IC_INTR_* bits */
+#define DW_IC_INTR_RX_UNDER			BIT(0)
+#define DW_IC_INTR_RX_OVER			BIT(1)
+#define DW_IC_INTR_RX_FULL			BIT(2)
+#define DW_IC_INTR_TX_OVER			BIT(3)
+#define DW_IC_INTR_TX_EMPTY			BIT(4)
+#define DW_IC_INTR_RD_REQ			BIT(5)
+#define DW_IC_INTR_TX_ABRT			BIT(6)
+#define DW_IC_INTR_RX_DONE			BIT(7)
+#define DW_IC_INTR_ACTIVITY			BIT(8)
+#define DW_IC_INTR_STOP_DET			BIT(9)
+#define DW_IC_INTR_START_DET			BIT(10)
+#define DW_IC_INTR_GEN_CALL			BIT(11)
+#define DW_IC_INTR_RESTART_DET			BIT(12)
+#define DW_IC_INTR_MST_ON_HOLD			BIT(13)
+
+/* DW_IC_ENABLE bits */
+#define DW_IC_ENABLE_ENABLE			BIT(0)
+#define DW_IC_ENABLE_ABORT			BIT(1)
+
+/* DW_IC_STATUS bits */
+#define DW_IC_STATUS_ACTIVITY			BIT(0)
+#define DW_IC_STATUS_TFE			BIT(2)
+#define DW_IC_STATUS_RFNE			BIT(3)
+#define DW_IC_STATUS_MASTER_ACTIVITY		BIT(5)
+#define DW_IC_STATUS_SLAVE_ACTIVITY		BIT(6)
+#define DW_IC_STATUS_MASTER_HOLD_TX_FIFO_EMPTY	BIT(7)
+
+/* DW_IC_SMBUS_INTR_* bits */
+#define DW_IC_SMBUS_INTR_ALERT			BIT(10)
+
+#endif /* __LINUX_DESIGNWARE_I2C_H */


