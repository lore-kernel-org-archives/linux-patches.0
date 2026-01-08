Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AB62F6900
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894184; cv=none; b=rhsRpDiFhFUt0GqiJzEnbquZdOmxwep7KzHiASsv5QBi31rCedbQf32smJNvdOARypzVUadmNterH3oz+/0a19HEnoaUhwd5D3s2bDEbtyDDjZlLuXJHqHMqMzsZJz3gytshZs+N2uBOphDIAtJkeZL7OsL/TQT3GRO7Z7T39Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894184; c=relaxed/simple;
	bh=+DBCcIJlVy0hWzgLDzger/W573MtECHXhKRmxs4SSt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTIM5SNuTKXvRDpnCvxWyuPv3uWeHYJjDg07bgOaIMXaWtlgEkPKb6U5GeIztijtC4EkkKuuvMTsLnrlxFiETRdMmjVmszUmXWJttROabTsdHsOBMZByUzwK+uKHD3tmU82QVNsB4Xk4DFPTiAufQr36hHe/yTAKKwwweLD2O2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wy/eiV1n; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wy/eiV1n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767894178; x=1799430178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+DBCcIJlVy0hWzgLDzger/W573MtECHXhKRmxs4SSt0=;
  b=Wy/eiV1nKLDRxYkR/VTsed2hELeLNDYlFk1DdYYfiYgvhCrhl3ptN630
   Md9ESnvmBJS8gYULJa5CIWHFgvWQ/Mhj6ZitoC9CARnp7ZcKSqIPQEnFI
   D6gaP8q4KzfmqPsFU5UQC/qx+W285UJSwaL6r9+c4wtTYhnv28O7puec6
   C4m9Ply1Y9+deWpK+Yh0BOp5jUKtVdDByp5Fz/o06zNu/fvYxvcTJsc3h
   P+8JeeNg7eEvlt039J0BD+lHr+xPysbWbcGnZRgTUQuxTklqJmxoG8uMF
   F/vFmtJNlWkep7ATxAbtTbZSkh2YBL/dfEpNoFai5mm1RsAVyPjNGI4Oe
   w==;
X-CSE-ConnectionGUID: EGOKxf33RbCnrYYkz3Qqpg==
X-CSE-MsgGUID: 9RqyP9rjQKWMIhNtGP5a2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79999008"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="79999008"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:48 -0800
X-CSE-ConnectionGUID: RRqYg4kcQQKJBi8cBUprVg==
X-CSE-MsgGUID: +lQ16C3IRqitLmIoKpWSjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="240751113"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.16])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 16/32] x86/resctrl: Discover hardware telemetry events
Date: Thu,  8 Jan 2026 09:42:26 -0800
Message-ID: <20260108174227.11307-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108174227.11307-1-tony.luck@intel.com>
References: <20260108174227.11307-1-tony.luck@intel.com>
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
particular feature type (event_group::pfname set to "energy" or "perf") with
a particular guid.

Use event_group::pfname to determine the feature id needed to obtain the
aggregator details. It will later be used in console messages and with the
rdt= boot parameter.

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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   4 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 109 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 135 insertions(+)
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
index f3d7e2263630..595f7eae9294 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -738,6 +738,8 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
 void resctrl_arch_pre_mount(void)
 {
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1099,6 +1101,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..6e0d063cfc80
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,109 @@
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
+ * @pfname:		PMT feature name ("energy" or "perf") of this event group.
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
index 80527299f859..0d874a92daed 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -540,6 +540,19 @@ config X86_CPU_RESCTRL
 
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
2.52.0

