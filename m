Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B52303A0B
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881673; cv=none; b=QOVsO/Lr0yPqgT6cWymYk/Uw5Z0Y4LZMZfJScNBnyT9qi5g97GmtpoC81qhZkocmyTyGbKVBUvYvIqxbd/nwnjjB3IvAtaIHjJtsGF45JgTtH7fMgm2JltiDugoJkVSuoxeHWKZ87+QWHqDcHiQu67ypj6tV+jMnJvW86+Vo05w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881673; c=relaxed/simple;
	bh=/U9yTGGRBUnxvbwPaXARH6IngCroh561p528+aY2s2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMhYv1dQCuHfFv4H8wij3w4AycEEfAzjnIuZJH4VtaAyUZP0v8c6lxfyqIw6JWMxrRKERsDawSjCAY0c2LnC7xnBd0OPg5iI8nSanQNtNEFgbMP3JNN1QpVR11cfZWNwOZo3NVVM6DcKxNSbhzc0W4Co40QziiP+GfpW27FEXyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XddE0mwF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XddE0mwF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881669; x=1796417669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/U9yTGGRBUnxvbwPaXARH6IngCroh561p528+aY2s2g=;
  b=XddE0mwFu60v5jZJyQQXfYZS4HoiCnqQ5E59eRKWCjWFpghXgyainLEU
   bBjNG/KP9hhyE2MxjvrPwJZiZsRn2VCLFa9y9moZlKhUNZu6mEbvGk9xr
   5Iyd5bIzLSE3inkFeKKFPkojUQM5DK4rbrPM/nW9lCTjtI8bWu/fyt3GW
   cGfvD5/Qhmfvqi6A07mUgTVwr0hfZwxeqN7UBEoGstm42M9zU8kk/vHWs
   Yv5P5cT+3WYesUEeqOaoNScbDWWfkWABuaoRAvdOmEwNk7/A7W6tDacH3
   +Vm8nXyQUOhA+25bgtr0nq2RRBMRc2GzkvMm7Xv3ik4kCEvzFrMK53EE+
   g==;
X-CSE-ConnectionGUID: 5MwaCGbBR6Ws33RbEe9Rmw==
X-CSE-MsgGUID: 4zcWoRN6SP6woXAja2LDKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69510981"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69510981"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:23 -0800
X-CSE-ConnectionGUID: xYdWA4OXQxS4d5pdR8RSIA==
X-CSE-MsgGUID: ExMA0ClWToqRgM98KvqF7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752804"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:23 -0800
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
Subject: [PATCH v15 16/32] x86/resctrl: Discover hardware telemetry events
Date: Thu,  4 Dec 2025 12:53:46 -0800
Message-ID: <20251204205404.12763-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each CPU collects data for telemetry events that it sends to the nearest
telemetry event aggregator either when the value of MSR_IA32_PQR_ASSOC.RMID
changes, or when a two millisecond timer expires.

There is a feature type ("energy" or "perf"), guid, and MMIO region associated
with each aggregator. This combination links to an XML description of the
set of telemetry events tracked by the aggregator. XML files are published
by Intel in a GitHub repository [1].

The telemetry event aggregators maintain per-RMID per-event counts of the
total seen for all the CPUs. There may be multiple telemetry event aggregators
per package.

There are separate sets of aggregators for each feature type. Aggregators
in a set may have different guids. All aggregators with the same feature
type and guid are symmetric keeping counts for the same set of events for
the CPUs that provide data to them.

The XML file for each aggregator provides the following information:
0) Feature type of the events ("perf" or "energy")
1) Which telemetry events are tracked by the aggregator.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for an aggregator.

Introduce struct event_group that condenses the relevant information from
an XML file. Hereafter an "event group" refers to a group of events of a
particular feature type ("energy" or "perf") with a particular guid.

The event_group::pfname field is used to choose the parameter to pass
to intel_pmt_get_regions_by_feature(). It will later be used in console
messages and with the rdt= boot parameter.

The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
This driver provides intel_pmt_get_regions_by_feature() to list all available
telemetry event aggregators of a given feature type. The list includes the
"guid", the base address in MMIO space for the region where the event counters
are exposed, and the package id where the all the CPUs that report to this
aggregator are located.

Call INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() for each event
group to obtain a private copy of that event group's aggregator data. Duplicate
the aggregator data between event groups that have the same feature type
but different guid. Further processing on this private copy will be unique
to the event group.

Return the aggregator data to INTEL_PMT_TELEMETRY at resctrl exit time.

resctrl will silently ignore unknown guid values.

Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel specific
parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY and INTEL_TPMI
drivers being built-in to the kernel for enumeration of telemetry features.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://github.com/intel/Intel-PMT # [1]
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 110 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 137 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 11d06995810e..f2e6e3577df0 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -222,4 +222,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
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
index 986b1303efb9..88be77d5d20d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -743,6 +743,9 @@ void resctrl_arch_pre_mount(void)
 
 	if (!atomic_try_cmpxchg(&only_once, &old, 1))
 		return;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1104,6 +1107,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..3cb79e30d284
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,110 @@
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
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
+#include <linux/resctrl.h>
+#include <linux/stddef.h>
+
+#include "internal.h"
+
+/**
+ * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
+ * @pfname:		PMT feature name (energy or perf) of this event group
+ *			used by boot rdt= option.
+ * @pfg:		Points to the aggregated telemetry space information
+ *			returned by the intel_pmt_get_regions_by_feature()
+ *			call to the INTEL_PMT_TELEMETRY driver that contains
+ *			data for all telemetry regions of type @pfname.
+ *			Valid if the system supports the event group,
+ *			NULL otherwise.
+ */
+struct event_group {
+	/* Data fields for additional structures to manage this group. */
+	const char			*pfname;
+	struct pmt_feature_group	*pfg;
+};
+
+static struct event_group *known_event_groups[] = {
+};
+
+#define for_each_event_group(_peg)						\
+	for (_peg = known_event_groups;						\
+	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
+	     _peg++)
+
+/* Stub for now */
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	return false;
+}
+
+static enum pmt_feature_id lookup_pfid(const char *pfname)
+{
+	if (!strcmp(pfname, "energy"))
+		return FEATURE_PER_RMID_ENERGY_TELEM;
+	else if (!strcmp(pfname, "perf"))
+		return FEATURE_PER_RMID_PERF_TELEM;
+
+	pr_warn("Unknown PMT feature name '%s'\n", pfname);
+
+	return FEATURE_INVALID;
+}
+
+/*
+ * Request a copy of struct pmt_feature_group for each event group. If there is
+ * one, the returned structure has an array of telemetry_region structures,
+ * each element of the array describes one telemetry aggregator. The
+ * telemetry aggregators may have different guids so obtain duplicate struct
+ * pmt_feature_group for event groups with same feature type but different
+ * guid. Post-processing ensures an event group can only use the telemetry
+ * aggregators that match its guid. An event group keeps a pointer to its
+ * struct pmt_feature_group to indicate that its events are successfully
+ * enabled.
+ */
+bool intel_aet_get_events(void)
+{
+	struct pmt_feature_group *p;
+	enum pmt_feature_id pfid;
+	struct event_group **peg;
+	bool ret = false;
+
+	for_each_event_group(peg) {
+		pfid = lookup_pfid((*peg)->pfname);
+		p = intel_pmt_get_regions_by_feature(pfid);
+		if (IS_ERR_OR_NULL(p))
+			continue;
+		if (enable_events(*peg, p)) {
+			(*peg)->pfg = p;
+			ret = true;
+		} else {
+			intel_pmt_put_feature_group(p);
+		}
+	}
+
+	return ret;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group **peg;
+
+	for_each_event_group(peg) {
+		if ((*peg)->pfg) {
+			intel_pmt_put_feature_group((*peg)->pfg);
+			(*peg)->pfg = NULL;
+		}
+	}
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 34fb46d5341b..52dda19d584d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -538,6 +538,19 @@ config X86_CPU_RESCTRL
 
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
2.51.1

