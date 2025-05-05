Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA7E26F46F
	for <patches@lists.linux.dev>; Mon,  5 May 2025 17:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746466716; cv=none; b=rxGvCSVylF1CkKVTWKbGhnuWHFisQGFY8CQx9VkO7nY1bGNrteSvUdZS643htWu8WZSfLtyuXNR682ivO8z7CFIH6ppug1aZv56EJZ3K26ELoEzQ125vvXXc+62QzmEio9sbLWC11PBJ3G4PiQmqHoUpeUc3crSePKWm7L1ulzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746466716; c=relaxed/simple;
	bh=41mM4CeORGI8LL+e/0a3kHADBGZX0dr9szgl004zu90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMkjXH6jE9sPU9+hkPnC7WDt3nN+AS3B0fqIQnzm7OtVY0mq0X8O6K786GKFJJigfscd4xjs3PwztuFFKI3ZfPRPr0VRc2g67ALocrgKYbkiX4McyNOAptLDFB0QP2g2Wu9bHrmxUkh6zq5ENp5l0eKA3tSI/FC7nSLw5CnX/jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LqHwnqCG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LqHwnqCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746466714; x=1778002714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=41mM4CeORGI8LL+e/0a3kHADBGZX0dr9szgl004zu90=;
  b=LqHwnqCG/JfPpSATFVibJjhfKz4vml2JmLdfIzjA97cCJEPJSr3m7qPh
   nhdtIyxcln5QsEx1fgiDXgwpL6bfrZUru2qPp1HnDIAHEmtEYWYlPzJNx
   2li/jm6FsfSruc//qhNrdciSHiaYlyUD9rygTDYaW2igyFao/2QYMEWXi
   mQ9Vz1HEWpyDj326GpVhEvdP1gQH43IuuHa+G8nDAQY0aHVuWD+ojsGEf
   FMEOwaLnXg4CgAp9J+k1/xwct5WyVAt5CLVbiEr0WJcvJWg88CcTAqfr8
   so/RlBjv5aoeqGu3dPCKgJuiYyXybSxFy57e57XT74bOK89664XZjzFGS
   w==;
X-CSE-ConnectionGUID: 7Hnn+LrwR2uYlj2RqWGyog==
X-CSE-MsgGUID: xsaUcjbBR1GuPQ+9Fq326Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="47991514"
X-IronPort-AV: E=Sophos;i="6.15,264,1739865600"; 
   d="scan'208";a="47991514"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 10:38:27 -0700
X-CSE-ConnectionGUID: ZzpzMPuURhmahaMeavlM8g==
X-CSE-MsgGUID: X733MOeWTcGpLVCis5/v0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,264,1739865600"; 
   d="scan'208";a="140092226"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 10:38:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael@kernel.org
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 1/3] ACPI/MRRM: Minimal parse of ACPI MRRM table
Date: Mon,  5 May 2025 10:38:17 -0700
Message-ID: <20250505173819.419271-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250505173819.419271-1-tony.luck@intel.com>
References: <20250505173819.419271-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl file system code needs to know how many region tags
are supported. Parse the ACPI MRRM table and save the max_mem_region
value.

Provide a function for resctrl to collect that value.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/acpi.h     |  9 +++++++++
 drivers/acpi/acpi_mrrm.c | 42 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig         |  1 +
 drivers/acpi/Kconfig     |  3 +++
 drivers/acpi/Makefile    |  1 +
 5 files changed, 56 insertions(+)
 create mode 100644 drivers/acpi/acpi_mrrm.c

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index fc372bbaa547..f2d8579de539 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -772,6 +772,10 @@ int acpi_get_local_u64_address(acpi_handle handle, u64 *addr);
 int acpi_get_local_address(acpi_handle handle, u32 *addr);
 const char *acpi_get_subsystem_id(acpi_handle handle);
 
+#ifdef CONFIG_ACPI_MRRM
+int acpi_mrrm_max_mem_region(void);
+#endif
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -1092,6 +1096,11 @@ static inline acpi_handle acpi_get_processor_handle(int cpu)
 	return NULL;
 }
 
+static inline int acpi_mrrm_max_mem_region(void)
+{
+	return -ENOENT;
+}
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_HMAT
diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
new file mode 100644
index 000000000000..ab8022e58da5
--- /dev/null
+++ b/drivers/acpi/acpi_mrrm.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025, Intel Corporation.
+ *
+ * Memory Range and Region Mapping (MRRM) structure
+ */
+
+#define pr_fmt(fmt) "acpi/mrrm: " fmt
+
+#include <linux/acpi.h>
+#include <linux/init.h>
+
+static int max_mem_region = -ENOENT;
+
+/* Access for use by resctrl file system */
+int acpi_mrrm_max_mem_region(void)
+{
+	return max_mem_region;
+}
+
+static __init int acpi_parse_mrrm(struct acpi_table_header *table)
+{
+	struct acpi_table_mrrm *mrrm;
+
+	mrrm = (struct acpi_table_mrrm *)table;
+	if (!mrrm)
+		return -ENODEV;
+
+	max_mem_region = mrrm->max_mem_region;
+
+	return 0;
+}
+
+static __init int mrrm_init(void)
+{
+	int ret;
+
+	ret = acpi_table_parse(ACPI_SIG_MRRM, acpi_parse_mrrm);
+
+	return ret;
+}
+device_initcall(mrrm_init);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4b9f378e05f6..0e43069082df 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -38,6 +38,7 @@ config X86_64
 	select ARCH_HAS_ELFCORE_COMPAT
 	select ZONE_DMA32
 	select EXECMEM if DYNAMIC_FTRACE
+	select ACPI_MRRM if ACPI
 
 config FORCE_DYNAMIC_FTRACE
 	def_bool y
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7f10aa38269d..7bc40c2735ac 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -576,6 +576,9 @@ config ACPI_FFH
 	  Enable this feature if you want to set up and install the FFH Address
 	  Space handler to handle FFH OpRegion in the firmware.
 
+config ACPI_MRRM
+	bool
+
 source "drivers/acpi/pmic/Kconfig"
 
 config ACPI_VIOT
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 797070fc9a3f..d1b0affb844f 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -66,6 +66,7 @@ acpi-$(CONFIG_ACPI_WATCHDOG)	+= acpi_watchdog.o
 acpi-$(CONFIG_ACPI_PRMT)	+= prmt.o
 acpi-$(CONFIG_ACPI_PCC)		+= acpi_pcc.o
 acpi-$(CONFIG_ACPI_FFH)		+= acpi_ffh.o
+acpi-$(CONFIG_ACPI_MRRM)	+= acpi_mrrm.o
 
 # Address translation
 acpi-$(CONFIG_ACPI_ADXL)	+= acpi_adxl.o
-- 
2.48.1

