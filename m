Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9573546EC
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754901; cv=none; b=IHUm1e/K+jyrl0x4wo1+lzzGUpjW2dLCVh8xaG7rmYPTGp8JJ7CWdKn2lyRKk4UyNNykj3AhcS2JZsbivk+ZryrIdB9YIQmtOHLq5sBa8VCV3mz4If2sH6hifR7HEeVJxyHXwKVJb7JsWE0WnuRMBD23OJUlL/Ai7RBcMNqng9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754901; c=relaxed/simple;
	bh=Fhmqveej+sTnixe7gQlxIlzkj9iMk6qzhxCejx8NWjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOfHUwP4citjeE3JYYsNXuR6+nb3J5sgfWFWzNZVG2Jtf/wOZOrzUD6FwiIEzc07W4Fm83NPddSIgnkWg/tX6CUtfAPZivRS2zOWl5NAOc+caj7q8NaluGtTH3gD1+c2c0rVsxR6QyCEOymNO6lWKY6jpLYjnXHHDU6XclHMR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2pSkLhF; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2pSkLhF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754899; x=1793290899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fhmqveej+sTnixe7gQlxIlzkj9iMk6qzhxCejx8NWjE=;
  b=n2pSkLhFCsreKeh4OPw8yzFf1qV6VhbBTuycbuwFEpRjaiF+MMUfJZn2
   2ziY8F5etlZDCMq8X5l3bUAzvJaJrhqK7jEF8VpkIOzJE2ZqfEH9wl/7b
   RJEoVWMgq3fmRFz77a4x+JjoUIsixD3WYBEL2XWwHC/EGkfL9AHjpPX5o
   p+xICFDUjiiw5tqlbvJZCp6mJI+3+nDuF8RRGd08r0kfng5PSsa1Ymgc1
   GdJtbTnPPNqPdN+HYt5nf1CQn0p1vdBEj4YFjykVQ+NT7UyBpdgAgjOTr
   JJAhhDfUobjwaMM4g0D9drjlI3z5W82TCF9KtZhuaxKAgtj0ClfQOnpnj
   A==;
X-CSE-ConnectionGUID: WXi6wACQRA6Gb5zMXePQ5g==
X-CSE-MsgGUID: O/10EKJ/SuWK0TRxLkz4bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481328"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481328"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:31 -0700
X-CSE-ConnectionGUID: QvUDI22wTx24ufpEvu3ljg==
X-CSE-MsgGUID: 3Yl5ywAeTQuQbzzzlzGiBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901366"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:30 -0700
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
Subject: [PATCH v13 16/32] x86/resctrl: Discover hardware telemetry events
Date: Wed, 29 Oct 2025 09:20:59 -0700
Message-ID: <20251029162118.40604-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
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

There is a guid and an MMIO region associated with each aggregator. The
combination of the guid and the size of the MMIO region link to an XML description
of the set of telemetry events tracked by the aggregator. XML files are published
by Intel in a GitHub repository [1].

The telemetry event aggregators maintain per-RMID per-event counts of the
total seen for all the CPUs. There may be multiple telemetry
event aggregators per package.

There are separate sets of aggregators for each type of event, but all
aggregators with the same guid are symmetric keeping counts for the same
set of events for the CPUs that provide data to them.

The XML file for each aggregator provides the following information:
1) Which telemetry events are included in the group.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for an aggregator.

The resctrl implementation condenses the relevant information from the
XML file into some of the fields of struct event_group.

The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.  This
driver provides intel_pmt_get_regions_by_feature() to list all available telemetry
event aggregators of a given enum pmt_feature_id type. The list includes the
"guid", the base address in MMIO space for the region where the event counters
are exposed, and the package id where the all the CPUs that report to this
aggregator are located.

A theoretical example struct pmt_feature_group returned from the INTEL_PMT_TELEMETRY
driver for events of type FEATURE_PER_RMID_PERF_TELEM could look like this:

 +-------------------------------+
 | count = 6                     |
 +-------------------------------+
 | [0] guid_1 size_1 pkg1 addr_1 |
 +-------------------------------+
 | [1] guid_1 size_1 pkg2 addr_2 |
 +-------------------------------+
 | [2] guid_2 size_2 pkg1 addr_3 |
 +-------------------------------+
 | [3] guid_2 size_2 pkg1 addr_4 |
 +-------------------------------+
 | [4] guid_2 size_2 pkg2 addr_5 |
 +-------------------------------+
 | [5] guid_2 size_2 pkg2 addr_6 |
 +-------------------------------+

This provides details for "perf" aggregators with two guids. If resctrl
has an event_group for both of these guids it will get two copies of this
struct pmt_feature_group by calling intel_pmt_get_regions_by_feature()
once for each. event_group::pfg will point to the copy acquired from
each call.

On the call for guid1 it will see there is just one aggregator per package for
guid_1. So resctrl can read event counts from the MMIO addr_1 on package 1 and
addr_2 on package 2.

There are two aggregators listed on each package for guid_2. So resctrl must
read counters from addr_3 and addr_4 and sum them to provide result for package
1. Similarly addr_5 and addr_6 must be read and summed for event counts on
package 2.

resctrl will silently ignore unknown guid values.

Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel specific
parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY and INTEL_TPMI
drivers being built-in to the kernel for enumeration of telemetry features.

Call INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() for each guid
known to resctrl (using the appropriate enum pmt_feature_id argument for that
guid) to obtain a private copy of struct pmt_feature_group that contains all
discovered/enumerated telemetry aggregator data for all event groups (known and
unknown to resctrl) of that pmt_feature_id. Further processing on this structure
will enable all supported events in resctrl.

Return the struct pmt_feature_group to INTEL_PMT_TELEMETRY at resctrl exit time.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://github.com/intel/Intel-PMT # [1]
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 122 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 149 insertions(+)
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
index af555dadf024..648f44cff52c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -738,6 +738,9 @@ void resctrl_arch_pre_mount(void)
 
 	if (!atomic_try_cmpxchg(&only_once, &old, 1))
 		return;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1095,6 +1098,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..02bbe7872fcf
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,122 @@
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
+ * @feature:		Argument to intel_pmt_get_regions_by_feature() to
+ *			discover if this event_group is supported.
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
+	enum pmt_feature_id		feature;
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
+	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
+	.guid		= 0x26696143,
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
+ */
+static struct event_group perf_0x26557651 = {
+	.feature	= FEATURE_PER_RMID_PERF_TELEM,
+	.guid		= 0x26557651,
+};
+
+static struct event_group *known_event_groups[] = {
+	&energy_0x26696143,
+	&perf_0x26557651,
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
+/*
+ * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
+ * pmt_feature_group for each known feature. If there is one, the returned
+ * structure has an array of telemetry_region structures, each element of
+ * the array describes one telemetry aggregator.
+ * A single pmt_feature_group may include multiple different guids.
+ * Try to use every telemetry aggregator with a known guid.
+ */
+bool intel_aet_get_events(void)
+{
+	struct pmt_feature_group *p;
+	struct event_group **peg;
+	bool ret = false;
+
+	for_each_event_group(peg) {
+		p = intel_pmt_get_regions_by_feature((*peg)->feature);
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
index fa3b616af03a..da5775056ec8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -536,6 +536,19 @@ config X86_CPU_RESCTRL
 
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

