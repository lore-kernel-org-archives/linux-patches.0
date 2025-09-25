Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E446C321F34
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830657; cv=none; b=KnrBOCN7/vuYIFBOVN/rveGUQW03cpi1s5x8GCcAshKrx3FToNgl/nrwgXw0KbJQITIxEaiegOfuBNhb9rrprHB4C/Kh0N0U+7WpajM/y53pXuWiNZA0DyoMPNQn9SfVHED8o4HyrUwCx/zWerwso32/YV65hxzfIFtyyE47PZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830657; c=relaxed/simple;
	bh=qH/GDjzlCQXAzpzL1YuJ9XPTstvOMwofyuGrPN9kIf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEWZwHFeI/CMVMxIQWSWNHhj4OhrPAhAxEhJXGl/HRJqJFuFON7rsoPn/3Sql5eeBP2v+w4JcryyA/7QGfsct/CSWIPhQQSprG3Oo9Vg8uF/ge6WoeWHDXVXnWpxaGcu4I/+xO/gi8OHabXEYk79bWGWMCKAXQfFdLgdK1Zm4oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jWgq8oTg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWgq8oTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830655; x=1790366655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qH/GDjzlCQXAzpzL1YuJ9XPTstvOMwofyuGrPN9kIf0=;
  b=jWgq8oTgiQ8DTrRBACRfTzSk3wd8uSYg9dCUBAi0MTBXmEJiOJ7e7OHD
   UtWik+jkx1uBGUGKuV0P4SCKeT/zU8z2mEWfj7WE90731igJB9o8GxTUV
   ZOvRztDwhPX7piccPp9pgI7/ZVPeA5AlAp7TrS6esXEsVbnkjV/BZN6Bh
   6v8DgRJ2/DmP76FsmuYN+al8s26LvCk+roMBgmJz+gpXTpu3V+pU64Pm5
   1on/yVpf6vj/6UQq+HzH8Hm4/LGVh/FAXZ4IKrNmVNbCGUiGsuYAQtgp3
   m0KK5ad5yEES19U4Go8ggMuLbsfmEN2RIukzlYHSccDXIR498Q6avu6IX
   w==;
X-CSE-ConnectionGUID: QHiD7sAxTlmO/aJ70yX4BQ==
X-CSE-MsgGUID: j8GBNKSHT1WEHJtV1eXTMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074248"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074248"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:09 -0700
X-CSE-ConnectionGUID: jVvXz877TDGPlM2UbkdY/g==
X-CSE-MsgGUID: nMBK5xPeS1qggIKXVQ9H+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003646"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
Date: Thu, 25 Sep 2025 13:03:08 -0700
Message-ID: <20250925200328.64155-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each CPU collects data for telemetry events that it sends to the nearest
telemetry event aggregator either when the value of IA32_PQR_ASSOC.RMID
changes, or when a two millisecond timer expires.

The telemetry event aggregators maintain per-RMID per-event counts of the
total seen for all the CPUs. There may be more than one set of telemetry
event aggregators per package.

There are separate sets of aggregators for each type of event, but all
aggregators for a given type are symmetric keeping counts for the same
set of events for the CPUs that provide data to them.

Each telemetry event aggregator is responsible for a specific group of
events. E.g. on the Intel Clearwater Forest CPU there are two types of
aggregators. One type tracks a pair of energy related events. The other
type tracks a subset of "perf" type events.

The event counts are made available to Linux in a region of MMIO space
for each aggregator. All details about the layout of counters in each
aggregator MMIO region are described in XML files published by Intel and
made available in a GitHub repository [1].

The key to matching a specific telemetry aggregator to the XML file that
describes the MMIO layout is a 32-bit value. The Linux telemetry subsystem
refers to this as a "guid" while the XML files call it a "uniqueid".

Each XML file provides the following information:
1) Which telemetry events are included in the group.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for an aggregator.

The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
This driver provides intel_pmt_get_regions_by_feature() to list all
available telemetry event aggregators. The list includes the "guid",
the base address in MMIO space for the region where the event counters
are exposed, and the package id where the all the CPUs that report to this
aggregator are located.

Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel
specific parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY
and INTEL_TPMI drivers being built-in to the kernel for enumeration of
telemetry features.

Use INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() with
each per-RMID telemetry feature id to obtain a private copy of
struct pmt_feature_group that contains all discovered/enumerated
telemetry aggregator data for all event groups (known and unknown
to resctrl) of that feature id. Further processing on this structure
will enable all supported events in resctrl. Return the structure to
INTEL_PMT_TELEMETRY at resctrl exit time.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://github.com/intel/Intel-PMT # [1]
---
Note that checkpatch complains about this:

DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
		if (!IS_ERR_OR_NULL(_T))
			intel_pmt_put_feature_group(_T))
with:
CHECK: Alignment should match open parenthesis

But if the alignment is fixed, it then complains:
WARNING: Statements should start on a tabstop
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 144 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 171 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 14fadcff0d2b..886261a82b81 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -217,4 +217,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
+#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+bool intel_aet_get_events(void);
+void __exit intel_aet_exit(void);
+#else
+static inline bool intel_aet_get_events(void) { return false; }
+static inline void __exit intel_aet_exit(void) { }
+#endif
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 64c6f507b7bc..9003a6344410 100644
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
@@ -1091,6 +1094,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..966c840f0d6b
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,144 @@
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
+#include <linux/array_size.h>
+#include <linux/cleanup.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
+#include <linux/overflow.h>
+#include <linux/resctrl.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+#include "internal.h"
+
+/**
+ * struct event_group - All information about a group of telemetry events.
+ * @pfg:		Points to the aggregated telemetry space information
+ *			returned by the intel_pmt_get_regions_by_feature()
+ *			call to the INTEL_PMT_TELEMETRY driver that contains
+ *			data for all telemetry regions of a specific type.
+ *			Valid if the system supports the event group.
+ *			NULL otherwise.
+ * @guid:		Unique number per XML description file.
+ */
+struct event_group {
+	/* Data fields for additional structures to manage this group. */
+	struct pmt_feature_group	*pfg;
+
+	/* Remaining fields initialized from XML file. */
+	u32				guid;
+};
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
+static struct event_group *known_perf_event_groups[] = {
+	&perf_0x26557651,
+};
+
+#define for_each_enabled_event_group(_peg, _grp)			\
+	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
+		if ((*_peg)->pfg)
+
+/* Stub for now */
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	return false;
+}
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
+		if (!IS_ERR_OR_NULL(_T))
+			intel_pmt_put_feature_group(_T))
+
+/*
+ * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
+ * pmt_feature_group for a specific feature. If there is one, the returned
+ * structure has an array of telemetry_region structures. Each describes
+ * one telemetry aggregator.
+ * Try to use every telemetry aggregator with a known guid.
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
+		ret = enable_events(*peg, p);
+		if (ret) {
+			(*peg)->pfg = no_free_ptr(p);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Ask INTEL_PMT_TELEMETRY driver for all the RMID based telemetry groups
+ * that it supports.
+ */
+bool intel_aet_get_events(void)
+{
+	bool ret1, ret2;
+
+	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
+			       known_energy_event_groups,
+			       ARRAY_SIZE(known_energy_event_groups));
+	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
+			       known_perf_event_groups,
+			       ARRAY_SIZE(known_perf_event_groups));
+
+	return ret1 || ret2;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group **peg;
+
+	for_each_enabled_event_group(peg, known_energy_event_groups) {
+		intel_pmt_put_feature_group((*peg)->pfg);
+		(*peg)->pfg = NULL;
+	}
+	for_each_enabled_event_group(peg, known_perf_event_groups) {
+		intel_pmt_put_feature_group((*peg)->pfg);
+		(*peg)->pfg = NULL;
+	}
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52c8910ba2ef..ce9d086625c1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -525,6 +525,19 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
+config X86_CPU_RESCTRL_INTEL_AET
+	bool "Intel Application Energy Telemetry"
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	help
+	  Enable per-RMID telemetry events in resctrl.
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
index d8a04b195da2..273ddfa30836 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_X86_CPU_RESCTRL_INTEL_AET)	+= intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.51.0

