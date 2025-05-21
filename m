Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9C23A9AC
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867863; cv=none; b=Yfxh3Xg201QqDVzHQvwRUrd8skof9Gaii4Qeafb1Gq78qNl6qwdvBsbopb9yYXjV76pwo9latPB/y8nm2xFlmygrrzUrMhm059zdrwMODFfBTRraqFi0uHg28YqDgMR75nC8Jr1zDgt+1XLUh+SwIUTQyU8kRCenuYEnvliTWq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867863; c=relaxed/simple;
	bh=u4remCQ7yALVTBfJjdkLnvJkrC2xewpiTnEZzkuYuRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ1Id5vzGTwDJ4kA4IlTzCHc/12kWL8fWftv5UMJEv22UJ4483FZzSouKU6YnsrVPoO6JUJyUdsM2RhAwUskGaD4S8FQzuPtrteFgxUGKDdgdDKNGXpqzMOiNWaZcDSmFzXVI2OTBFSA2YahxZAB6HCNyz11/4wTx5CRj0uZkm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9jcnQaR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9jcnQaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867861; x=1779403861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u4remCQ7yALVTBfJjdkLnvJkrC2xewpiTnEZzkuYuRY=;
  b=X9jcnQaRcnj+LNkHgUwUi6H+k7+VreQY07QmxqbnQs8RGfNitkAJJcXD
   DPo5BLqS/7aODcencCkCp4p+fGPDnYpVhZirFqvpKx/Vu0D5T9BQtnmtt
   FCJq8UL6NBD45vdp/sUlBMV+l2Yts2ApaNWtVBwwpkNWf2EHAmoL6aXUH
   zAxmyva2sA5DKUUARvsz4wzXndvM8cQEXkVY58I7LAYckf4EvoXOTpLR2
   aSnMMLKC+rIKXD2s+msxwXQjMDUa4O2J48z1gAdsuU5rc8rEZl14JCZ//
   apKDKoR513pVXC+ydWfBYekLfMMyl2ukAlc6GdC/FhAkXbgFANInhej8v
   g==;
X-CSE-ConnectionGUID: uhhN6h3FSwid9LSyxMR0iQ==
X-CSE-MsgGUID: fXGDh6f8TC+rRhemahTX7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677650"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677650"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:57 -0700
X-CSE-ConnectionGUID: bM6/BJxpR3uJrpyA/7psjg==
X-CSE-MsgGUID: GXy8KqfiRCilRGKzDZc1AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352135"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:57 -0700
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
Subject: [PATCH v5 05/29] x86/rectrl: Fake OOBMSM interface
Date: Wed, 21 May 2025 15:50:23 -0700
Message-ID: <20250521225049.132551-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Real version is coming soon[1] ... this is here so the remaining parts
will build (and run ... assuming a 2 socket system that supports RDT
monitoring ... only missing part is that the event counters just
report fixed values).

Faked values are provided to exercise some special conditions:
1) Multiple counter aggregators for an event per-socket.
2) Different number of supported RMIDs for each group.

Just for ease of testing and RFC discussion.

[1]
Link: https://lore.kernel.org/all/20250430212106.369208-1-david.e.box@linux.intel.com/

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../cpu/resctrl/fake_intel_aet_features.h     | 73 ++++++++++++++
 .../cpu/resctrl/fake_intel_aet_features.c     | 97 +++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/Makefile          |  1 +
 3 files changed, 171 insertions(+)
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
index 000000000000..80f38f1ee3df
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
@@ -0,0 +1,97 @@
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
+ * Amount of memory for each fake MMIO space
+ * Magic numbers here match values for XML ID 0x26696143 and 0x26557651
+ * 576: Number of RMIDs
+ * 2: Energy events in 0x26557651
+ * 7: Perf events in 0x26696143
+ * 3: Qwords for status counters after the event counters
+ * 8: Bytes for each counter
+ */
+
+#define ENERGY_QWORDS	((576 * 2) + 3)
+#define ENERGY_SIZE	(ENERGY_QWORDS * 8)
+#define PERF_QWORDS	((576 * 7) + 3)
+#define PERF_SIZE	(PERF_QWORDS * 8)
+
+static long pg[4 * ENERGY_QWORDS + 2 * PERF_QWORDS];
+
+/*
+ * Fill the fake MMIO space with all different values,
+ * all with BIT(63) set to indicate valid entries.
+ */
+static int __init fill(void)
+{
+	u64 val = 0;
+
+	for (int i = 0; i < sizeof(pg); i += sizeof(val)) {
+		pg[i / sizeof(val)] = BIT_ULL(63) + val;
+		val++;
+	}
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
+	.count = 4,
+	.regions = {
+		PKG_REGION(0, 0x26696143, &pg[0 * ENERGY_QWORDS], ENERGY_SIZE, 0, 64),
+		PKG_REGION(1, 0x26696143, &pg[1 * ENERGY_QWORDS], ENERGY_SIZE, 0, 64),
+		PKG_REGION(2, 0x26696143, &pg[2 * ENERGY_QWORDS], ENERGY_SIZE, 1, 64),
+		PKG_REGION(3, 0x26696143, &pg[3 * ENERGY_QWORDS], ENERGY_SIZE, 1, 64)
+	}
+};
+
+/*
+ * Fake return for:
+ *   intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
+ */
+static struct pmt_feature_group fake_perf = {
+	.count = 2,
+	.regions = {
+		PKG_REGION(0, 0x26557651, &pg[4 * ENERGY_QWORDS + 0 * PERF_QWORDS], PERF_SIZE, 0, 576),
+		PKG_REGION(1, 0x26557651, &pg[4 * ENERGY_QWORDS + 1 * PERF_QWORDS], PERF_SIZE, 1, 576)
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

