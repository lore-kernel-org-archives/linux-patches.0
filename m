Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8911D3081D6
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394851; cv=none; b=NwdFIJ23GuYc4UMJsNCW+uAx7MsNsaN3WdCkB66XUTLdovftvQPcRl0BySjwtYMe64I3aHeS1vHpQPTXqYwbk3VzEokNBbSAUy7ggmtDSZycNmH+zHUmep1ivnb1hy1ekxEnAKH3Y0ha+XqkS9wnMq7HJtzwHtQO3mrISwbIQhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394851; c=relaxed/simple;
	bh=LxxMT52dhXBc0DtALXF8ebHrPbrwNu3ATsUooz1QuRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/kVtzF0qBT0BKsLVPNh8jUq1kh+oy8DPBdcbsXUH0LntJCaCV8y0MvbdGUiOWs0vnunLAAPEGaOvACyKMg5KPEynUqBQW8m93z6DVNGWxyT7v6m8H3lYNRmBMVvUYlXTuCVk7kjrEZ4LXMcJSjzaP5zNFF3MHURNsXZVTzJUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ysb0V3ZD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ysb0V3ZD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394849; x=1791930849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LxxMT52dhXBc0DtALXF8ebHrPbrwNu3ATsUooz1QuRw=;
  b=Ysb0V3ZDBuMYtO6P26AhezyOMURbENFk2wnarJIsZFbtmdehXzK43tNa
   LInypTU+/UbUh98HwhvP5ctF+Sqefb1qYwXc87n+iHuw+/Zv2bk06apLf
   99VcvlvJUkSfM8t74xLH8WVI2gmKBwnUqH0ZqRYLK8aWxqRBoNonsCvlg
   ltQhsOM/jmzl/vXuLSp/ToDWjoTNGEldgk+o0boHigwuO/MYR9GVmd9gt
   J4nPxxl8e6UqVie43iRh7oyM6sE6iaQR6wvmdQidHEOOnplZPEMLCIZu/
   vTQkKvPXivj6JpiIhNl4wU/ZpT7iMhp5/YdAek+VQeGX5dl6retSHX/93
   A==;
X-CSE-ConnectionGUID: r7oyTF+zT2apXV6wddxLGg==
X-CSE-MsgGUID: gHbZiFCpQgm9xJ9Te6VkfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168844"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168844"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
X-CSE-ConnectionGUID: gy6YJWBlSImFncRCDnKgUQ==
X-CSE-MsgGUID: NvHw+f+6Tpm/M8qyRrsr6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145295"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:01 -0700
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
Subject: [PATCH v12 14/31] x86/resctrl: Discover hardware telemetry events
Date: Mon, 13 Oct 2025 15:33:28 -0700
Message-ID: <20251013223348.103390-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 140 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |  13 +++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 167 insertions(+)
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
index 57a328fdde59..9451bafde923 100644
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
index 000000000000..67e479bdbc93
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,140 @@
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
+/*
+ * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
+ * pmt_feature_group for a specific feature. If there is one, the returned
+ * structure has an array of telemetry_region structures, each element of
+ * the array describes one telemetry aggregator.
+ * A single pmt_feature_group may include multiple different guids.
+ * Try to use every telemetry aggregator with a known guid.
+ */
+static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
+			    unsigned int num_evg)
+{
+	struct pmt_feature_group *p;
+	struct event_group **peg;
+	bool ret = false;
+
+	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
+		p = intel_pmt_get_regions_by_feature(feature);
+		if (IS_ERR_OR_NULL(p))
+			return false;
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

