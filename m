Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CE082D9C;
	Mon,  8 Apr 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582994; cv=none; b=bZRXpNM7/SM3adfjB0aDmb1z9AI/s22InH/+pBlriFUVeENxccYIGw6KPkb48LuLh+gHXMpCMVZ+gj1w9D/SRHOXc+/G/biqzUC4thWeiIsofE0QIBXPT0xAiZsm6KtOOsLfOGFNBXSM2gDXr+3lsvpz21OHUSA2mIK6hy/KWF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582994; c=relaxed/simple;
	bh=YECSl9yjNEQQSFtgpWO4JItJ7HmT6rJ9krvL5A+dU/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FapMavyGyNQVdIOQy3CAjgdkxbxqAE235pOn9yjGSsKAtI/cAFUTlOcPHlLgzexGzkbZqgSqwR+fuqrf890YlZm97iDHYZTAIkxbXKx+S/gWQHziaVoM1Q117MVldjENx4YqOlbDlxQ7JT+AtLLe1by2a1RV5gZb4zetTi/IeFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz2rGlrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz2rGlrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7824BC433C7;
	Mon,  8 Apr 2024 13:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582993;
	bh=YECSl9yjNEQQSFtgpWO4JItJ7HmT6rJ9krvL5A+dU/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oz2rGlrNlQL/rC0UvFpwqBevhiYkhZXbDUQMYV6iXyFlrBEH2ObGyG/rC6NhrWlq9
	 /k533V8Gfy3Dn0v0BO+/XUCPxBYy63wOO4aXPKpDs1RFuKs7FWA4VlYxbwvnRdyz43
	 jbJsRS2XfRfHthqenb+4zyuytG8S9By3Saw/6QMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 146/252] i40e: Split i40e_osdep.h
Date: Mon,  8 Apr 2024 14:57:25 +0200
Message-ID: <20240408125311.184656956@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 5dfd37c37a44ba47c35ff8e6eaff14c226141111 ]

Header i40e_osdep.h contains only IO primitives and couple of debug
printing macros. Split this header file to i40e_io.h and i40e_debug.h
and move i40e_debug_mask enum to i40e_debug.h

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_debug.h  | 47 +++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    |  1 -
 drivers/net/ethernet/intel/i40e/i40e_io.h     | 16 +++++++
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |  1 -
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  | 40 ----------------
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  1 +
 drivers/net/ethernet/intel/i40e/i40e_type.h   | 31 ++----------
 8 files changed, 68 insertions(+), 71 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_debug.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_io.h
 delete mode 100644 drivers/net/ethernet/intel/i40e/i40e_osdep.h

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.h b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
index 1c3d2bc5c3f79..80125bea80a2a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
@@ -4,8 +4,8 @@
 #ifndef _I40E_ADMINQ_H_
 #define _I40E_ADMINQ_H_
 
+#include <linux/mutex.h>
 #include "i40e_alloc.h"
-#include "i40e_osdep.h"
 #include "i40e_adminq_cmd.h"
 
 #define I40E_ADMINQ_DESC(R, i)   \
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debug.h b/drivers/net/ethernet/intel/i40e/i40e_debug.h
new file mode 100644
index 0000000000000..27ebc72d8bfe5
--- /dev/null
+++ b/drivers/net/ethernet/intel/i40e/i40e_debug.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Intel Corporation. */
+
+#ifndef _I40E_DEBUG_H_
+#define _I40E_DEBUG_H_
+
+#include <linux/dev_printk.h>
+
+/* debug masks - set these bits in hw->debug_mask to control output */
+enum i40e_debug_mask {
+	I40E_DEBUG_INIT			= 0x00000001,
+	I40E_DEBUG_RELEASE		= 0x00000002,
+
+	I40E_DEBUG_LINK			= 0x00000010,
+	I40E_DEBUG_PHY			= 0x00000020,
+	I40E_DEBUG_HMC			= 0x00000040,
+	I40E_DEBUG_NVM			= 0x00000080,
+	I40E_DEBUG_LAN			= 0x00000100,
+	I40E_DEBUG_FLOW			= 0x00000200,
+	I40E_DEBUG_DCB			= 0x00000400,
+	I40E_DEBUG_DIAG			= 0x00000800,
+	I40E_DEBUG_FD			= 0x00001000,
+	I40E_DEBUG_PACKAGE		= 0x00002000,
+	I40E_DEBUG_IWARP		= 0x00F00000,
+	I40E_DEBUG_AQ_MESSAGE		= 0x01000000,
+	I40E_DEBUG_AQ_DESCRIPTOR	= 0x02000000,
+	I40E_DEBUG_AQ_DESC_BUFFER	= 0x04000000,
+	I40E_DEBUG_AQ_COMMAND		= 0x06000000,
+	I40E_DEBUG_AQ			= 0x0F000000,
+
+	I40E_DEBUG_USER			= 0xF0000000,
+
+	I40E_DEBUG_ALL			= 0xFFFFFFFF
+};
+
+struct i40e_hw;
+struct device *i40e_hw_to_dev(struct i40e_hw *hw);
+
+#define hw_dbg(hw, S, A...) dev_dbg(i40e_hw_to_dev(hw), S, ##A)
+
+#define i40e_debug(h, m, s, ...)				\
+do {								\
+	if (((m) & (h)->debug_mask))				\
+		dev_info(i40e_hw_to_dev(hw), s, ##__VA_ARGS__);	\
+} while (0)
+
+#endif /* _I40E_DEBUG_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
index 7451d346ae83f..b383aea652f3e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
@@ -2,7 +2,6 @@
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
 #include "i40e.h"
-#include "i40e_osdep.h"
 #include "i40e_register.h"
 #include "i40e_alloc.h"
 #include "i40e_hmc.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_io.h b/drivers/net/ethernet/intel/i40e/i40e_io.h
new file mode 100644
index 0000000000000..2a2ed9a1d476b
--- /dev/null
+++ b/drivers/net/ethernet/intel/i40e/i40e_io.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Intel Corporation. */
+
+#ifndef _I40E_IO_H_
+#define _I40E_IO_H_
+
+/* get readq/writeq support for 32 bit kernels, use the low-first version */
+#include <linux/io-64-nonatomic-lo-hi.h>
+
+#define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
+#define rd32(a, reg)		readl((a)->hw_addr + (reg))
+
+#define rd64(a, reg)		readq((a)->hw_addr + (reg))
+#define i40e_flush(a)		readl((a)->hw_addr + I40E_GLGEN_STAT)
+
+#endif /* _I40E_IO_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
index 474365bf06480..830f1de254ef4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
@@ -2,7 +2,6 @@
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
 #include "i40e.h"
-#include "i40e_osdep.h"
 #include "i40e_register.h"
 #include "i40e_type.h"
 #include "i40e_hmc.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
deleted file mode 100644
index fd18895cfb56b..0000000000000
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
-
-#ifndef _I40E_OSDEP_H_
-#define _I40E_OSDEP_H_
-
-#include <linux/types.h>
-#include <linux/if_ether.h>
-#include <linux/if_vlan.h>
-#include <linux/tcp.h>
-#include <linux/pci.h>
-#include <linux/highuid.h>
-
-/* get readq/writeq support for 32 bit kernels, use the low-first version */
-#include <linux/io-64-nonatomic-lo-hi.h>
-
-/* File to be the magic between shared code and
- * actual OS primitives
- */
-
-struct i40e_hw;
-struct device *i40e_hw_to_dev(struct i40e_hw *hw);
-
-#define hw_dbg(hw, S, A...) dev_dbg(i40e_hw_to_dev(hw), S, ##A)
-
-#define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
-#define rd32(a, reg)		readl((a)->hw_addr + (reg))
-
-#define rd64(a, reg)		readq((a)->hw_addr + (reg))
-#define i40e_flush(a)		readl((a)->hw_addr + I40E_GLGEN_STAT)
-
-#define i40e_debug(h, m, s, ...)				\
-do {								\
-	if (((m) & (h)->debug_mask))				\
-		pr_info("i40e %02x:%02x.%x " s,			\
-			(h)->bus.bus_id, (h)->bus.device,	\
-			(h)->bus.func, ##__VA_ARGS__);		\
-} while (0)
-
-#endif /* _I40E_OSDEP_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 3eeee224f1fb2..9c9234c0706f0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -6,6 +6,7 @@
 
 #include "i40e_type.h"
 #include "i40e_alloc.h"
+#include "i40e_debug.h"
 #include <linux/avf/virtchnl.h>
 
 /* Prototypes for shared code functions that are not in
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index d4c6afe84fdd2..44cea0f4f908d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -4,7 +4,9 @@
 #ifndef _I40E_TYPE_H_
 #define _I40E_TYPE_H_
 
-#include "i40e_osdep.h"
+#include <linux/delay.h>
+#include <linux/if_ether.h>
+#include "i40e_io.h"
 #include "i40e_register.h"
 #include "i40e_adminq.h"
 #include "i40e_hmc.h"
@@ -43,33 +45,6 @@ typedef void (*I40E_ADMINQ_CALLBACK)(struct i40e_hw *, struct i40e_aq_desc *);
 #define I40E_QTX_CTL_VM_QUEUE	0x1
 #define I40E_QTX_CTL_PF_QUEUE	0x2
 
-/* debug masks - set these bits in hw->debug_mask to control output */
-enum i40e_debug_mask {
-	I40E_DEBUG_INIT			= 0x00000001,
-	I40E_DEBUG_RELEASE		= 0x00000002,
-
-	I40E_DEBUG_LINK			= 0x00000010,
-	I40E_DEBUG_PHY			= 0x00000020,
-	I40E_DEBUG_HMC			= 0x00000040,
-	I40E_DEBUG_NVM			= 0x00000080,
-	I40E_DEBUG_LAN			= 0x00000100,
-	I40E_DEBUG_FLOW			= 0x00000200,
-	I40E_DEBUG_DCB			= 0x00000400,
-	I40E_DEBUG_DIAG			= 0x00000800,
-	I40E_DEBUG_FD			= 0x00001000,
-	I40E_DEBUG_PACKAGE		= 0x00002000,
-	I40E_DEBUG_IWARP		= 0x00F00000,
-	I40E_DEBUG_AQ_MESSAGE		= 0x01000000,
-	I40E_DEBUG_AQ_DESCRIPTOR	= 0x02000000,
-	I40E_DEBUG_AQ_DESC_BUFFER	= 0x04000000,
-	I40E_DEBUG_AQ_COMMAND		= 0x06000000,
-	I40E_DEBUG_AQ			= 0x0F000000,
-
-	I40E_DEBUG_USER			= 0xF0000000,
-
-	I40E_DEBUG_ALL			= 0xFFFFFFFF
-};
-
 #define I40E_MDIO_CLAUSE22_STCODE_MASK		I40E_GLGEN_MSCA_STCODE_MASK
 #define I40E_MDIO_CLAUSE22_OPCODE_WRITE_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(1)
 #define I40E_MDIO_CLAUSE22_OPCODE_READ_MASK	I40E_GLGEN_MSCA_OPCODE_MASK(2)
-- 
2.43.0



