Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47DE207A16
	for <patches@lists.linux.dev>; Tue, 27 May 2025 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748377560; cv=none; b=mdNQR4rbqYcCEPGDR5nCehGhLb4eIacNb/Sts859AjYOhcz7ivFAkfzwzxg550+4lNF7EmGeCb+91o2cD9PG3kQo2LsMtg/od0H4q3PT952Aa2/UyQVHNazKTpgMVF+XeXvgK20hJDySN5t4x8U9jx0ysVdth3B50ypgIvZkka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748377560; c=relaxed/simple;
	bh=espflf2gu6byP0BZ2KYo+PxUfLtakDGP47tYMYUtxJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWIv2n+M/2MbRhu4c2kQ8FHHb3/VKJdPpmopoGZ40p3aFt9H3mwZTv+X0yuOQPftZVEXnwQbExo7DBvl60BjCW+19wrXQK3S0iBNjsUrH86E6+nN2z2WfV8Akwi9Tu3Vm9u4XCul6FUjDF1/7v7m742UrBG3oSSImnuj8GAFIdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cgf46M7p; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cgf46M7p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748377559; x=1779913559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=espflf2gu6byP0BZ2KYo+PxUfLtakDGP47tYMYUtxJc=;
  b=Cgf46M7p7HTtJLGIe05G/FhpLApas/06d58wlLjHKhGrcdAdtUbVRDWw
   xBUcS5hFq6qfLBIQWCSBVaEe5S4ajOiJYyWE6qHuqM7cC2cKx3czUq18Z
   ZI7acaFwFtUcfkpIk1HwJ67/h7cinD4imSSeqfbmh2KOCF1+cxk//icXu
   QFsWcUtjgq8F/nBM5HdlW/+P+hiahNiWgSl0p9qr6pSr+BiMYKmu8pune
   hM8D0e6Gg5EOQ5pvLw+BX4RLGo7SXp9TRWJwykBmmAoHcp1qYth5UXy0d
   igLN/dGHOaJJEEKAfZkqcRQFn1ya3BxBZE5YZvo2fenfcLjsLelKACnvE
   w==;
X-CSE-ConnectionGUID: mWpJX/5TSvGrIptG3vUzYA==
X-CSE-MsgGUID: P3fQMSwCStew/UclCJq2qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="53011607"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="53011607"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 13:25:58 -0700
X-CSE-ConnectionGUID: tUnwNTZxRCSPXudM9GatjA==
X-CSE-MsgGUID: m0B2q3mwSCuvs1vgtCR+5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="147833385"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 13:25:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: reinette.chatre@intel.com
Cc: Dave.Martin@arm.com,
	anil.s.keshavamurthy@intel.com,
	babu.moger@amd.com,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	james.morse@arm.com,
	linux-kernel@vger.kernel.org,
	maciej.wieczor-retman@intel.com,
	patches@lists.linux.dev,
	peternewman@google.com,
	tony.luck@intel.com,
	x86@kernel.org,
	yu.c.chen@intel.com
Subject: [PATCH v5 05/29 UPDATED] x86/resctrl: Fake OOBMSM interface
Date: Tue, 27 May 2025 13:25:50 -0700
Message-ID: <20250527202550.162147-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <33aff696-21ce-4e84-b7cb-6f05cdef0402@intel.com>
References: <33aff696-21ce-4e84-b7cb-6f05cdef0402@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

=== Changes since original v5 version of this patch ===
1) Fix typo in Subject s/rectrl/resctrl/
2) Explain all constants used for fake pmt_feature_group structures
3) Explain difference between the number of RMIDs described by the
   XML files, and the number provided in telemetry_region::num_rmids.
4) Provide separate u64 arrays for each of the fake MMIO space regions
   and initialize so that event registers beyond the limit of number
   of hardware counters read as zero (i.e. without the DATA_VALID bit
   set).
===

Real version is coming soon[1]. This is here so the remaining parts
will build (and run: assuming a 2 socket system that supports RDT
monitoring).

Missing parts:

1) The event counters just report fixed values.
2) No emulation of most-recently-used for aggregators that have fewer
   hardware counters than RMID registers in MMIO space.

Faked values are provided to exercise some special conditions:
1) Multiple counter aggregators for an event per-socket.
2) Different number of hardware counters backing the RMIDs for each group.

Just for ease of testing and RFC discussion.

[1]
Link: https://lore.kernel.org/all/20250430212106.369208-1-david.e.box@linux.intel.com/

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../cpu/resctrl/fake_intel_aet_features.h     |  73 ++++++++
 .../cpu/resctrl/fake_intel_aet_features.c     | 158 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 3 files changed, 232 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c

diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
new file mode 100644
index 000000000000..c835c4108abc
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Bits stolen from OOBMSM VSEC discovery code */
+
+enum pmt_feature_id {
+	FEATURE_INVALID			= 0x0,
+	FEATURE_PER_CORE_PERF_TELEM	= 0x1,
+	FEATURE_PER_CORE_ENV_TELEM	= 0x2,
+	FEATURE_PER_RMID_PERF_TELEM	= 0x3,
+	FEATURE_ACCEL_TELEM		= 0x4,
+	FEATURE_UNCORE_TELEM		= 0x5,
+	FEATURE_CRASH_LOG		= 0x6,
+	FEATURE_PETE_LOG		= 0x7,
+	FEATURE_TPMI_CTRL		= 0x8,
+	FEATURE_RESERVED		= 0x9,
+	FEATURE_TRACING			= 0xA,
+	FEATURE_PER_RMID_ENERGY_TELEM	= 0xB,
+	FEATURE_MAX			= 0xB,
+};
+
+/**
+ * struct oobmsm_plat_info - Platform information for a device instance
+ * @cdie_mask:       Mask of all compute dies in the partition
+ * @package_id:      CPU Package id
+ * @partition:       Package partition id when multiple VSEC PCI devices per package
+ * @segment:         PCI segment ID
+ * @bus_number:      PCI bus number
+ * @device_number:   PCI device number
+ * @function_number: PCI function number
+ *
+ * Structure to store platform data for a OOBMSM device instance.
+ */
+struct oobmsm_plat_info {
+	u16 cdie_mask;
+	u8 package_id;
+	u8 partition;
+	u8 segment;
+	u8 bus_number;
+	u8 device_number;
+	u8 function_number;
+};
+
+enum oobmsm_supplier_type {
+	OOBMSM_SUP_PLAT_INFO,
+	OOBMSM_SUP_DISC_INFO,
+	OOBMSM_SUP_S3M_SIMICS,
+	OOBMSM_SUP_TYPE_MAX
+};
+
+struct oobmsm_mapping_supplier {
+	struct device *supplier_dev[OOBMSM_SUP_TYPE_MAX];
+	struct oobmsm_plat_info plat_info;
+	unsigned long features;
+};
+
+struct telemetry_region {
+	struct oobmsm_plat_info	plat_info;
+	void __iomem		*addr;
+	size_t			size;
+	u32			guid;
+	u32			num_rmids;
+};
+
+struct pmt_feature_group {
+	enum pmt_feature_id	id;
+	int			count;
+	struct kref		kref;
+	struct telemetry_region	regions[];
+};
+
+struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id id);
+
+void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group);
diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
new file mode 100644
index 000000000000..b2f1afee063d
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cleanup.h>
+#include <linux/minmax.h>
+#include <linux/slab.h>
+#include "fake_intel_aet_features.h"
+#include <linux/intel_vsec.h>
+#include <linux/resctrl.h>
+
+#include "internal.h"
+
+/*
+ * The following constants taken from Intel-PMT github repository at
+ * Link: https://github.com/intel/Intel-PMT
+ */
+
+/*
+ * XML file at xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
+ */
+#define ENERGY_GUID		0x26696143	/* Listed as "<TELI:uniqueid>" in XML */
+#define ENERGY_RMIDS		576		/* Register definitions run from 0 to 575 */
+#define ENERGY_NUM_EVENTS	2		/* CORE_ENERGY .. ACTIVITY */
+#define ENERGY_STATUS_REGS	3		/* Number of status registers at end of MMIO */
+
+/*
+ * XML file at xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
+ */
+#define PERF_GUID		0x26557651	/* Listed as "<TELI:uniqueid>" in XML */
+#define PERF_RMIDS		576		/* Register definitions run from 0 to 575 */
+#define PERF_NUM_EVENTS		7		/* STALLS_LLC_HIT .. UOPS_RETIRED_VALID */
+#define PERF_STATUS_REGS	3		/* Number of status registers at end of MMIO */
+
+/*
+ * Size of MMIO space in each telemetry aggregator for energy events.
+ */
+#define ENERGY_QWORDS	((ENERGY_RMIDS * ENERGY_NUM_EVENTS) + ENERGY_STATUS_REGS)
+#define ENERGY_SIZE	(ENERGY_QWORDS * sizeof(u64))
+
+/*
+ * Size of MMIO space in each telemetry aggregator for perf events.
+ */
+#define PERF_QWORDS	((PERF_RMIDS * PERF_NUM_EVENTS) + PERF_STATUS_REGS)
+#define PERF_SIZE	(PERF_QWORDS * sizeof(u64))
+
+/*
+ * These next numbers are made up out of thin air. Chosen to exercise
+ * various configurations (some present in the first implementation
+ * of telemetry events, others will appear in later implementations).
+ */
+#define ENERGY_TELEM_AGGREGATORS_PER_SOCKET	2
+#define PERF_TELEM_AGGREGATORS_PER_SOCKET	1
+#define	NUM_SOCKETS				2
+
+/*
+ * The number of implemented hardware counters for a telemetry
+ * aggregator may be smaller than the number of MMIO registers
+ * allocated. When this happens the hardware uses a most recently
+ * used algorithm to attach counters to MMIO registers.
+ * MMIO registers that are not backed by counters read with
+ * BIT(63) as zero. This fake code does not attempt to
+ * fully emulate the MRU algorithm. But it does provide return
+ * from intel_pmt_get_regions_by_feature() that indicates
+ * fewer hardware counters.
+ */
+#define ENERGY_NUM_HARDWARE_COUNTERS	64
+#define PERF_NUM_HARDWARE_COUNTERS	576
+
+
+/* Fake MMIO space of each fake energy aggregator */
+static u64 fake_energy_0[ENERGY_QWORDS];
+static u64 fake_energy_1[ENERGY_QWORDS];
+static u64 fake_energy_2[ENERGY_QWORDS];
+static u64 fake_energy_3[ENERGY_QWORDS];
+
+/* Fake MMIO space of each fake perf aggregator */
+static u64 fake_perf_0[PERF_QWORDS];
+static u64 fake_perf_1[PERF_QWORDS];
+
+/*
+ * Fill the each fake MMIO space with all different values,
+ * all with BIT(63) set to indicate valid entries.
+ */
+static int __init fill(void)
+{
+	u64 val = 0;
+	int i;
+
+	for (i = 0; i < ENERGY_NUM_HARDWARE_COUNTERS * ENERGY_NUM_EVENTS; i++)
+		fake_energy_0[i] = BIT_ULL(63) + val++;
+	for (i = 0; i < ENERGY_NUM_HARDWARE_COUNTERS * ENERGY_NUM_EVENTS; i++)
+		fake_energy_1[i] = BIT_ULL(63) + val++;
+	for (i = 0; i < ENERGY_NUM_HARDWARE_COUNTERS * ENERGY_NUM_EVENTS; i++)
+		fake_energy_2[i] = BIT_ULL(63) + val++;
+	for (i = 0; i < ENERGY_NUM_HARDWARE_COUNTERS * ENERGY_NUM_EVENTS; i++)
+		fake_energy_3[i] = BIT_ULL(63) + val++;
+
+	for (i = 0; i < PERF_QWORDS; i++)
+		fake_perf_0[i] = BIT_ULL(63) + val++;
+	for (i = 0; i < PERF_QWORDS; i++)
+		fake_perf_1[i] = BIT_ULL(63) + val++;
+
+	return 0;
+}
+device_initcall(fill);
+
+#define PKG_REGION(_entry, _guid, _addr, _size, _pkg, _num_rmids)	\
+	[_entry] = { .guid = _guid, .addr = (void __iomem *)_addr, \
+		     .num_rmids = _num_rmids, \
+		     .size = _size, .plat_info = { .package_id = _pkg }}
+
+/*
+ * Set up a fake return for call to:
+ *   intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
+ * Pretend there are two aggregators on each of the sockets to test
+ * the code that sums over multiple aggregators.
+ * Pretend this group only supports 64 RMIDs to exercise the code
+ * that reconciles support for different RMID counts.
+ */
+static struct pmt_feature_group fake_energy = {
+	.count = NUM_SOCKETS * ENERGY_TELEM_AGGREGATORS_PER_SOCKET,
+	.regions = {
+		PKG_REGION(0, ENERGY_GUID, fake_energy_0, ENERGY_SIZE, 0, ENERGY_NUM_HARDWARE_COUNTERS),
+		PKG_REGION(1, ENERGY_GUID, fake_energy_1, ENERGY_SIZE, 0, ENERGY_NUM_HARDWARE_COUNTERS),
+		PKG_REGION(2, ENERGY_GUID, fake_energy_2, ENERGY_SIZE, 1, ENERGY_NUM_HARDWARE_COUNTERS),
+		PKG_REGION(3, ENERGY_GUID, fake_energy_3, ENERGY_SIZE, 1, ENERGY_NUM_HARDWARE_COUNTERS)
+	}
+};
+
+/*
+ * Fake return for:
+ *   intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
+ */
+static struct pmt_feature_group fake_perf = {
+	.count = NUM_SOCKETS * PERF_TELEM_AGGREGATORS_PER_SOCKET,
+	.regions = {
+		PKG_REGION(0, PERF_GUID, fake_perf_0, PERF_SIZE, 0, PERF_NUM_HARDWARE_COUNTERS),
+		PKG_REGION(1, PERF_GUID, fake_perf_1, PERF_SIZE, 1, PERF_NUM_HARDWARE_COUNTERS)
+	}
+};
+
+struct pmt_feature_group *
+intel_pmt_get_regions_by_feature(enum pmt_feature_id id)
+{
+	switch (id) {
+	case FEATURE_PER_RMID_ENERGY_TELEM:
+		return &fake_energy;
+	case FEATURE_PER_RMID_PERF_TELEM:
+		return &fake_perf;
+	default:
+		return ERR_PTR(-ENOENT);
+	}
+}
+
+/*
+ * Nothing needed for the "put" function.
+ */
+void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
+{
+}
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index d8a04b195da2..cf4fac58d068 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_X86_CPU_RESCTRL)		+= fake_intel_aet_features.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.49.0

