Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FA2238D5F
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069262; cv=none; b=Bm42efap4QgmCWv6jy4Ey2KmliH1MTyQej7gXSp+vsn2Y4ZhXuesPkjGncv5JGM63hn7Z9qlpUteOwLFLpZm0GFnD2Y5aEIFM6hhtsQKpSeBDmf9La+Uut0eeDKaVDkC6YxHgipOvy17xYoHwpJDal0b8BHirTR9iMQjyK46r6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069262; c=relaxed/simple;
	bh=D+/doTh4X9NPl3WJ6EQtZZeiH6Fnf/tvGghmhvlFsHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUQU7zSgnvrsJ0o3r1sPDdYnmILbu8O+k1+xpLklcdZP0JJKKtwaXbjgQwiYEKOLubozNrmR0b8zCNbd2Rp7KnyH2np03efB3+9vAe75VlcUHW8evLGqb3yT2hvrSdCsF7s/fwIo49gza1tWYqBEXAs0wimXv3O8fq42Yi1O+x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrxA6AYP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrxA6AYP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069261; x=1775605261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D+/doTh4X9NPl3WJ6EQtZZeiH6Fnf/tvGghmhvlFsHA=;
  b=TrxA6AYP8i+lx9ZAIb0jZnNuIM4n0CI/TQ9E33G8ujYM/hMs6N3MiDCL
   zvlYfFUR2qqQZlYlCOV4Pte6JpPxD1DrlbXPegNc7tzO6ar5NqkYiGLw0
   yZovRNbJUrAAG2yjx+82caK8jC+VpTocH46LreJHZM/MNlSiWfmlVZuN4
   a05JphNqRpO/wvH9r9EumlpFCds82ZrdWpe80hICYkROzhR2qZzJqmOJ8
   L7q3IbXeIkUgx1ftvcfZEX/2McJMcdtn2iXP3nBv3zNPSjbQfjoZGTR3f
   Cw+04/6yfTj3qXuXafPEy+KdgIIllXI4M49ozinZVHwSdPoyUMHw2WoXh
   g==;
X-CSE-ConnectionGUID: 2D+zxwbEQXG6Plbd91O9UQ==
X-CSE-MsgGUID: q4XF3Gx/SXavRhGpyiE1fA==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193219"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193219"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:52 -0700
X-CSE-ConnectionGUID: rlirKGB4RkqHYn8NPUQh8A==
X-CSE-MsgGUID: 20i26qUzTcSQGTPXoIylSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315491"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:51 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 14/26] x86/resctrl: Add first part of telemetry event enumeration
Date: Mon,  7 Apr 2025 16:40:16 -0700
Message-ID: <20250407234032.241215-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The OOBMSM driver provides an interface to discover any RMID
based events for "energy" and "perf" classes.

Hold onto references to any pmt_feature_groups that resctrl
uses until resctrl exit.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++++
 arch/x86/kernel/cpu/resctrl/core.c      |  5 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 62 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/Makefile    |  1 +
 4 files changed, 76 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 45eabc7919c6..70b63bbc429d 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -172,4 +172,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+#ifdef CONFIG_INTEL_AET_RESCTRL
+bool intel_aet_get_events(void);
+void __exit intel_aet_exit(void);
+#else
+static inline bool intel_aet_get_events(void) { return false; }
+static inline void intel_aet_exit(void) { };
+#endif
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index a066a9c54a1f..f0f256a5ac66 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -718,6 +718,9 @@ void resctrl_arch_mount(void)
 	if (only_once)
 		return;
 	only_once = true;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1063,6 +1066,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..8e531ad279b5
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Resource Director Technology(RDT)
+ * - Intel Application Energy Telemetry
+ *
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Author:
+ *    Tony Luck <tony.luck@intel.com>
+ */
+
+#define pr_fmt(fmt)   "resctrl: " fmt
+
+#include <linux/cpu.h>
+#include <linux/cleanup.h>
+#include "fake_intel_aet_features.h"
+#include <linux/intel_vsec.h>
+#include <linux/resctrl.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+static struct pmt_feature_group *feat_energy;
+static struct pmt_feature_group *feat_perf;
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
+	if (!IS_ERR_OR_NULL(_T))					\
+		intel_pmt_put_feature_group(_T))
+
+/*
+ * Ask OOBMSM discovery driver for all the RMID based telemetry groups
+ * that it supports.
+ */
+bool intel_aet_get_events(void)
+{
+	struct pmt_feature_group *p1 __free(intel_pmt_put_feature_group) = NULL;
+	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
+	bool use_p1, use_p2;
+
+	p1 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
+	p2 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
+	use_p1 = !IS_ERR_OR_NULL(p1);
+	use_p2 = !IS_ERR_OR_NULL(p2);
+
+	if (!use_p1 && !use_p2)
+		return false;
+
+	if (use_p1)
+		feat_energy = no_free_ptr(p1);
+	if (use_p2)
+		feat_perf = no_free_ptr(p2);
+
+	return true;
+}
+
+void __exit intel_aet_exit(void)
+{
+	if (feat_energy)
+		intel_pmt_put_feature_group(feat_energy);
+	if (feat_perf)
+		intel_pmt_put_feature_group(feat_perf);
+}
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index c56d3acf8ac7..74c3b2333dde 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_INTEL_AET_RESCTRL)		+= intel_aet.o
 obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
-- 
2.48.1

