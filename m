Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD4D2376F2
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278045; cv=none; b=Hs/bSQzilhhzxARRU5o8PUE+bn93PFLi0LnUG4LO5ib8dJZ2LmaQ1FvlxYrRbFM++OUsRJuXHlmz27RRCT3Ox3Q96UAM6/yYpLpDI24XJcpfb3uIKlHrS0xappfqxyIr95QQ7s9YMpodFk8irbxx1Qa4uWw4yBpSbIZivfxV/EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278045; c=relaxed/simple;
	bh=y2IWWBJDVHa721h8SD4SfjCT+yM4YgRx5AF9TwjxUFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixh412/h0JUN5ppxZdn3+ZJRdYrIK3XxA8cIqE7ScO/cjm37Tpm7YXRMdvTH4xVrISEYokQv3qbyObUOyKw+OtvHZBDjmcgz782PdiSKU+5gjDmPp8E0WDCBEPUaC1IXTFrmiTRTHWfMkmk1Qb6TI5Ht5Hl+AYvJdi4hzbkYC58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k53YPPdF; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k53YPPdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278043; x=1783814043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y2IWWBJDVHa721h8SD4SfjCT+yM4YgRx5AF9TwjxUFY=;
  b=k53YPPdFtGplE0BK1NsAYMR3lbLyKQPlLOJbaKADlPQFajthNYqJPFGD
   gjM2jFBW7zsNzlHbxR3oreHdNT6FN3QFq9VC2ulnppGAsjskVcmN9sVcU
   ttUmeSA1BKgvqdaND1EtHTMGmQ8Jl4HbOvlo3zZ2JmDUw0VCQaf20z/vB
   MBeZGlJKagNyqt4zJVxrDFqcZoK/oxjdvvxrcCSvrIbiM/I/fkk8k0Xmm
   pwsERup+Ru1E3jktlcxGQnTEcaXDrGgIJvBmaTtftbTghXHUN71E2RAvR
   VAdAfm2lkR4UuuKOzjaMoh3lCF/JQ0WASQaJQ39nGfGt3htzvud1825nt
   g==;
X-CSE-ConnectionGUID: o0mBrg3XTR6AotIzYkG7NQ==
X-CSE-MsgGUID: 8Wa9UoS8Sl+9SEHiksiyKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292709"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292709"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:00 -0700
X-CSE-ConnectionGUID: sOGmGe1gTXiqU3K9iOWzaw==
X-CSE-MsgGUID: tzhVrqbMRuGqv9tdnFDWNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902137"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:00 -0700
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
Subject: [PATCH v7 17/31] x86/resctrl: Discover hardware telemetry events
Date: Fri, 11 Jul 2025 16:53:24 -0700
Message-ID: <20250711235341.113933-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hardware has one or more telemetry event aggregators per package
for each group of telemetry events. Each aggregator provides access
to event counts in an array of 64-bit values in MMIO space. There
is a "guid" (in this case a unique 32-bit integer) which refers to
an XML file published in https://github.com/intel/Intel-PMT
that provides all the details about each aggregator.

The XML file provides the following information:
1) Which telemetry events are included in the group for this aggregator.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for this aggregator.

Each aggregator makes event counters available to Linux in
a region of MMIO memory. Enumeration of these regions is
done by the INTEL_PMT_DISCOVERY discovery driver.

Add a new Kconfig option CONFIG_X86_RESCTRL_CPU_INTEL_AET for the
Intel specific parts of telemetry code. This depends on the
INTEL_PMT_DISCOVERY driver being built-in to the kernel for
enumeration of telemetry features.

Call intel_pmt_get_regions_by_feature() for each pmt_feature_id
that indicates per-RMID telemetry.

Save the returned pmt_feature_group pointers with guids that are known
to resctrl for use at run time.

Those pointers are returned to the INTEL_PMT_DISCOVERY driver at
resctrl_arch_exit() time.

Note that checkpatch complains about the alignment of additional
lines in the definition of the intel_pmt_put_feature_group
cleanup helper. I didn't find a way to appease conflicting
requirements from checkpatch.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 133 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 160 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 684a1b830ced..36a2072c19c7 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -169,4 +169,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+#ifdef CONFIG_X86_RESCTRL_CPU_INTEL_AET
+bool intel_aet_get_events(void);
+void __exit intel_aet_exit(void);
+#else
+static inline bool intel_aet_get_events(void) { return false; }
+static inline void __exit intel_aet_exit(void) { }
+#endif
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2b2f76c76d73..b8288f5d4aff 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -734,6 +734,9 @@ void resctrl_arch_pre_mount(void)
 
 	if (!atomic_try_cmpxchg(&only_once, &old, 1))
 		return;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1086,6 +1089,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..d177e5aa1f6a
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,133 @@
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
+#include <linux/intel_vsec.h>
+#include <linux/resctrl.h>
+
+#include "internal.h"
+
+/**
+ * struct event_group - All information about a group of telemetry events.
+ * @pfg:		Points to the aggregated telemetry space information
+ *			within the OOBMSM driver that contains data for all
+ *			telemetry regions.
+ * @list:		List of active event groups.
+ * @guid:		Unique number per XML description file.
+ */
+struct event_group {
+	/* Data fields for additional structures to manage this group. */
+	struct pmt_feature_group	*pfg;
+	struct list_head		list;
+
+	/* Remaining fields initialized from XML file. */
+	u32				guid;
+};
+
+static LIST_HEAD(active_event_groups);
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
+ */
+static struct event_group energy_0x26696143 = {
+	.guid		= 0x26696143,
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
+ */
+static struct event_group perf_0x26557651 = {
+	.guid		= 0x26557651,
+};
+
+static struct event_group *known_energy_event_groups[] = {
+	&energy_0x26696143,
+};
+
+#define NUM_KNOWN_ENERGY_GROUPS ARRAY_SIZE(known_energy_event_groups)
+
+static struct event_group *known_perf_event_groups[] = {
+	&perf_0x26557651,
+};
+
+#define NUM_KNOWN_PERF_GROUPS ARRAY_SIZE(known_perf_event_groups)
+
+/* Stub for now */
+static int discover_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	return -EINVAL;
+}
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
+		if (!IS_ERR_OR_NULL(_T))
+			intel_pmt_put_feature_group(_T))
+
+/*
+ * Make a request to the INTEL_PMT_DISCOVERY driver for the
+ * pmt_feature_group for a specific feature. If there is
+ * one the returned structure has an array of telemetry_region
+ * structures. Each describes one telemetry aggregator.
+ * Try to use any with a known matching guid.
+ */
+static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
+			    unsigned int num_evg)
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
+	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
+		ret = discover_events(*peg, p);
+		if (!ret) {
+			(*peg)->pfg = no_free_ptr(p);
+			return true;
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
+	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
+			       known_energy_event_groups, NUM_KNOWN_ENERGY_GROUPS);
+	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
+			       known_perf_event_groups, NUM_KNOWN_PERF_GROUPS);
+
+	return ret1 || ret2;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group *evg, *tmp;
+
+	list_for_each_entry_safe(evg, tmp, &active_event_groups, list) {
+		intel_pmt_put_feature_group(evg->pfg);
+		evg->pfg = NULL;
+		list_del(&evg->list);
+	}
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 340e5468980e..21c2d1022b15 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -528,6 +528,19 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
+config X86_RESCTRL_CPU_INTEL_AET
+	bool "Intel Application Energy Telemetry" if INTEL_PMT_DISCOVERY=y
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
+	help
+	  Enable per-RMID telemetry events in resctrl
+
+	  Intel feature that collects per-RMID execution data
+	  about energy consumption, measure of frequency independent
+	  activity and other performance metrics. Data is aggregated
+	  per package.
+
+	  Say N if unsure.
+
 config X86_FRED
 	bool "Flexible Return and Event Delivery"
 	depends on X86_64
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index d8a04b195da2..c86df4b23993 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_X86_RESCTRL_CPU_INTEL_AET)	+= intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.50.0

