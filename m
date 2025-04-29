Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6234D1E3780
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886864; cv=none; b=ZLvcHMHDM/Itl+QRk5zUm2kIsVAr91tX4KnmDr2Ifudo2X/hfZ4ji5Z5rAzIny0HtWvzUyZ59rNnerbwpmXG5SYO8EojgBnebb2ByDSAlhFOvLXFdiagEq8WLw8MKyHWAbgjO4RfLM9iJQcw4LYgZiKpzlKSpCQ3wmFaj0727tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886864; c=relaxed/simple;
	bh=GG8x/BhJY+MTjnC/1g0Vw3bYYenFGszoMzSoFra/LLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMb2xy6OeXdVUa15WbKuHADrft8T550BXj66mFgT5bBRX9xnq+zvPp4rGALyV9g2Td5U/4KYf98Tx0emLSYn0kKJD7myZYk7ycGyWvzj4avaGraPnA9zuxfgojZag//kvQ4j4OUwIgtganK16Yj1EuzZ/n8VfVuKwQ25gSFGp8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hnCt27aD; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hnCt27aD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886862; x=1777422862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GG8x/BhJY+MTjnC/1g0Vw3bYYenFGszoMzSoFra/LLU=;
  b=hnCt27aDcU+QBY4RyVn/COAukuAjlRFKFlg/D7nyiB32YXjR9HiDgjFv
   oqgR0hDYcbfBw5VP1vGkM2QhadeA5TRQUKpZgvR0boCdNKs3cSlTCAV2K
   vg+TO0OP1z6NnkIGZcMvbhccyB3WAaiZJA/xvigL6Shmlr8H76FTlbTJm
   g2Yj7OTyGMJJApodtV0V+jdunBDrS32biuA16LAcA61qAUqW7KX+Dh64M
   LuQC1BHsNDD/MC/XBtw5n8RJT9+k00/iTe0cQ2kFMuh2eM4iR/1UDag+W
   tDdZ5bJlSGAao0aIFl7KQ0K/kQ374E8zospVf7JH1aTDJHv8T62bMgyxN
   A==;
X-CSE-ConnectionGUID: W5hiTYmVSaq09Tip5HwoKQ==
X-CSE-MsgGUID: FYIbV97pTdC3FmEXfV1PUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148186"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148186"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:16 -0700
X-CSE-ConnectionGUID: laoN1NPPR0GwbxNccwn2MQ==
X-CSE-MsgGUID: VqW6ZS5QSz2CJQkcxHX1LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394021"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 16/31] x86/resctrl: Add first part of telemetry event enumeration
Date: Mon, 28 Apr 2025 17:33:42 -0700
Message-ID: <20250429003359.375508-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The OOBMSM VSEC discovery driver enumerates many different types
of telemetry resources. Resctrl is only interested in the ones
that are tied to an RMID value in the IA32_PQR_ASSOC MSR.

Make a request for each of the FEATURE_PER_RMID_ENERGY_TELEM and
FEATURE_PER_RMID_PERF_TELEM feature groups and scan the list
of known event groups for matching guid values.

Configuration to follow in subsequent patches.

Hold onto references to any pmt_feature_groups that resctrl
uses until resctrl exit.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 113 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 4 files changed, 127 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 83b20e6b25d7..571db665eca6 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -167,4 +167,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
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
index 4d1556707c01..0103f577e4ca 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -724,6 +724,9 @@ void resctrl_arch_pre_mount(void)
 
 	if (atomic_cmpxchg(&only_once, 0, 1))
 		return;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1076,6 +1079,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..dda44baf75ae
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,113 @@
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
+#include <linux/cleanup.h>
+#include <linux/cpu.h>
+#include <linux/resctrl.h>
+
+/* Temporary - delete from final version */
+#include "fake_intel_aet_features.h"
+
+#include "internal.h"
+
+/**
+ * struct event_group - All information about a group of telemetry events.
+ *                      Some fields initialized with MMIO layout information
+ *                      gleaned from the XML files. Others are set from data
+ *                      retrieved from intel_pmt_get_regions_by_feature().
+ * @pfg:		The pmt_feature_group for this event group
+ * @guid:		Unique number per XML description file
+ */
+struct event_group {
+	struct pmt_feature_group	*pfg;
+	int				guid;
+};
+
+/* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
+static struct event_group energy_0x26696143 = {
+	.guid		= 0x26696143,
+};
+
+/* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-PERF *.xml */
+static struct event_group perf_0x26557651 = {
+	.guid		= 0x26557651,
+};
+
+static struct event_group *known_event_groups[] = {
+	&energy_0x26696143,
+	&perf_0x26557651,
+};
+
+#define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
+
+static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	return false;
+}
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
+	if (!IS_ERR_OR_NULL(_T))					\
+		intel_pmt_put_feature_group(_T))
+
+static bool get_pmt_feature(enum pmt_feature_id feature)
+{
+	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
+	struct event_group **peg;
+	bool ret;
+
+	p = intel_pmt_get_regions_by_feature(feature);
+
+	if (IS_ERR_OR_NULL(p))
+		return false;
+
+	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
+		for (int i = 0; i < p->count; i++) {
+			if ((*peg)->guid == p->regions[i].guid) {
+				ret = configure_events((*peg), p);
+				if (ret) {
+					(*peg)->pfg = no_free_ptr(p);
+					return true;
+				}
+				break;
+			}
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Ask OOBMSM discovery driver for all the RMID based telemetry groups
+ * that it supports.
+ */
+bool intel_aet_get_events(void)
+{
+	bool ret1, ret2;
+
+	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
+	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
+
+	return ret1 || ret2;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group **peg;
+
+	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
+		if ((*peg)->pfg) {
+			intel_pmt_put_feature_group((*peg)->pfg);
+			(*peg)->pfg = NULL;
+		}
+	}
+}
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 28ae1c88b2ac..8b4603cad783 100644
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

