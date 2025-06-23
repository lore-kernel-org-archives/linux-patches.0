Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846912475E3;
	Mon, 23 Jun 2025 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686210; cv=none; b=a2RPjMMguBoWmtb6G8O2rLN7nJBhjCfCDCQLdizn93m2c62f/BN2037VZiAWSHPSyctpmA0JEV6SXELVzTI1G7gHzDbQ5YyG6ZbwxKnjFTOljFUVDmAW8MrQ/ANLey5O+WqNqZiULBQ2q8LWRCWx7HtqsBPbNJVYB4urL7yWXl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686210; c=relaxed/simple;
	bh=6vnQ4/hhvZVkU0Ta6Y+rIt45ZPaBlXR0e6/pgVc0E10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqRChawf6bOCsK0baNt62nlXLHnkckNKAmBUGygLAPliMpIhNiWSKCi78bdVOThS5IoRwOhJR7+u5sCiBtNAguzxcp/bHBIg39aSonfoKbtdwBaNhFE2iNG7eox0gu7ajJZNJRLtPTHWPh6ZZjEbBFc26FlvZ41rfLrSQuz/cJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNCZBW70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNCZBW70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19896C4CEEA;
	Mon, 23 Jun 2025 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686210;
	bh=6vnQ4/hhvZVkU0Ta6Y+rIt45ZPaBlXR0e6/pgVc0E10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNCZBW70PTKegEqKyEbnsPifJ4gR1CKAIYM1sNBBXuA5cq6FwcDJ4SoU2YWIhTypT
	 ga7B9CeJsVIgTXUeUgrhI1SkTjtTAZQw3HNQZrD65c022ayfZJPGhcrbxtOShad7Kj
	 koZJfDnuZBmpEMgEof13+d6XrXggqrE/ww0EfGKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haren Myneni <haren@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/355] powerpc/vas: Move VAS API to book3s common platform
Date: Mon, 23 Jun 2025 15:05:22 +0200
Message-ID: <20250623130630.391372217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit 413d6ed3eac387a2876893c337174f0c5b99d01d ]

The pseries platform will share vas and nx code and interfaces
with the PowerNV platform, so create the
arch/powerpc/platforms/book3s/ directory and move VAS API code
there. Functionality is not changed.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/e05c8db17b9eabe3545b902d034238e4c6c08180.camel@linux.ibm.com
Stable-dep-of: 0d67f0dee6c9 ("powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/vas.h                    |  3 +++
 arch/powerpc/platforms/Kconfig                    |  1 +
 arch/powerpc/platforms/Makefile                   |  1 +
 arch/powerpc/platforms/book3s/Kconfig             | 15 +++++++++++++++
 arch/powerpc/platforms/book3s/Makefile            |  2 ++
 .../platforms/{powernv => book3s}/vas-api.c       |  2 +-
 arch/powerpc/platforms/powernv/Kconfig            | 14 --------------
 arch/powerpc/platforms/powernv/Makefile           |  2 +-
 arch/powerpc/platforms/powernv/vas.h              |  2 --
 9 files changed, 24 insertions(+), 18 deletions(-)
 create mode 100644 arch/powerpc/platforms/book3s/Kconfig
 create mode 100644 arch/powerpc/platforms/book3s/Makefile
 rename arch/powerpc/platforms/{powernv => book3s}/vas-api.c (99%)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index 47062b4570490..c6df6fefbe8c2 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -162,6 +162,9 @@ int vas_copy_crb(void *crb, int offset);
  */
 int vas_paste_crb(struct vas_window *win, int offset, bool re);
 
+void vas_win_paste_addr(struct vas_window *window, u64 *addr,
+			int *len);
+
 /*
  * Register / unregister coprocessor type to VAS API which will be exported
  * to user space. Applications can use this API to open / close window
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 7a5e8f4541e3f..594544a65b024 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -20,6 +20,7 @@ source "arch/powerpc/platforms/embedded6xx/Kconfig"
 source "arch/powerpc/platforms/44x/Kconfig"
 source "arch/powerpc/platforms/40x/Kconfig"
 source "arch/powerpc/platforms/amigaone/Kconfig"
+source "arch/powerpc/platforms/book3s/Kconfig"
 
 config KVM_GUEST
 	bool "KVM Guest support"
diff --git a/arch/powerpc/platforms/Makefile b/arch/powerpc/platforms/Makefile
index 143d4417f6ccc..0e75d7df387bb 100644
--- a/arch/powerpc/platforms/Makefile
+++ b/arch/powerpc/platforms/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_PPC_CELL)		+= cell/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_EMBEDDED6xx)	+= embedded6xx/
 obj-$(CONFIG_AMIGAONE)		+= amigaone/
+obj-$(CONFIG_PPC_BOOK3S)	+= book3s/
diff --git a/arch/powerpc/platforms/book3s/Kconfig b/arch/powerpc/platforms/book3s/Kconfig
new file mode 100644
index 0000000000000..34c931592ef01
--- /dev/null
+++ b/arch/powerpc/platforms/book3s/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+config PPC_VAS
+	bool "IBM Virtual Accelerator Switchboard (VAS)"
+	depends on (PPC_POWERNV || PPC_PSERIES) && PPC_64K_PAGES
+	default y
+	help
+	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
+
+	  VAS devices are found in POWER9-based and later systems, they
+	  provide access to accelerator coprocessors such as NX-GZIP and
+	  NX-842. This config allows the kernel to use NX-842 accelerators,
+	  and user-mode APIs for the NX-GZIP accelerator on POWER9 PowerNV
+	  and POWER10 PowerVM platforms.
+
+	  If unsure, say "N".
diff --git a/arch/powerpc/platforms/book3s/Makefile b/arch/powerpc/platforms/book3s/Makefile
new file mode 100644
index 0000000000000..e790f1910f617
--- /dev/null
+++ b/arch/powerpc/platforms/book3s/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PPC_VAS)	+= vas-api.o
diff --git a/arch/powerpc/platforms/powernv/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
similarity index 99%
rename from arch/powerpc/platforms/powernv/vas-api.c
rename to arch/powerpc/platforms/book3s/vas-api.c
index 98ed5d8c5441a..cfc9d7dd65abc 100644
--- a/arch/powerpc/platforms/powernv/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -10,9 +10,9 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/vas.h>
 #include <uapi/asm/vas-api.h>
-#include "vas.h"
 
 /*
  * The driver creates the device node that can be used as follows:
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 938803eab0ad4..b3cb3d0c51c76 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -33,20 +33,6 @@ config PPC_MEMTRACE
 	  Enabling this option allows for the removal of memory (RAM)
 	  from the kernel mappings to be used for hardware tracing.
 
-config PPC_VAS
-	bool "IBM Virtual Accelerator Switchboard (VAS)"
-	depends on PPC_POWERNV && PPC_64K_PAGES
-	default y
-	help
-	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
-
-	  VAS allows accelerators in co-processors like NX-GZIP and NX-842
-	  to be accessible to kernel subsystems and user processes.
-
-	  VAS adapters are found in POWER9 based systems.
-
-	  If unsure, say N.
-
 config SCOM_DEBUGFS
 	bool "Expose SCOM controllers via debugfs"
 	depends on DEBUG_FS
diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
index 2eb6ae150d1fd..c747a1f1d25b7 100644
--- a/arch/powerpc/platforms/powernv/Makefile
+++ b/arch/powerpc/platforms/powernv/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_MEMORY_FAILURE)	+= opal-memory-errors.o
 obj-$(CONFIG_OPAL_PRD)	+= opal-prd.o
 obj-$(CONFIG_PERF_EVENTS) += opal-imc.o
 obj-$(CONFIG_PPC_MEMTRACE)	+= memtrace.o
-obj-$(CONFIG_PPC_VAS)	+= vas.o vas-window.o vas-debug.o vas-fault.o vas-api.o
+obj-$(CONFIG_PPC_VAS)	+= vas.o vas-window.o vas-debug.o vas-fault.o
 obj-$(CONFIG_OCXL_BASE)	+= ocxl.o
 obj-$(CONFIG_SCOM_DEBUGFS) += opal-xscom.o
 obj-$(CONFIG_PPC_SECURE_BOOT) += opal-secvar.o
diff --git a/arch/powerpc/platforms/powernv/vas.h b/arch/powerpc/platforms/powernv/vas.h
index 1f6e73809205e..032b04d4d3d45 100644
--- a/arch/powerpc/platforms/powernv/vas.h
+++ b/arch/powerpc/platforms/powernv/vas.h
@@ -437,8 +437,6 @@ extern irqreturn_t vas_fault_handler(int irq, void *dev_id);
 extern void vas_return_credit(struct vas_window *window, bool tx);
 extern struct vas_window *vas_pswid_to_window(struct vas_instance *vinst,
 						uint32_t pswid);
-extern void vas_win_paste_addr(struct vas_window *window, u64 *addr,
-					int *len);
 
 static inline int vas_window_pid(struct vas_window *window)
 {
-- 
2.39.5



