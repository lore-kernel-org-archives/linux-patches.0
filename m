Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1681B6CE0
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598982; cv=none; b=o5Qv7eds3wYNfVdytxQpM/q8EcpSpQ7oSmCJL6csRknbuaDF1SOK9AwWJlK7KyZNfM0IBtXk0L+2g/vBVNHZ7f2Yd36HTOG5POaj8leAbmPZRdw25S7qW24I/8vo35BNIKckwwWH5mFxeGBoaZWKUifEiqy7edeG9xT0v0Egmvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598982; c=relaxed/simple;
	bh=tYZ1FbeM8OZ/TWZgv1s5cxOJKU9ePb/qzpnBJ1zSw5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mudGGWp/FimxbfMO/KJf381Q0KWNekM7hEDJip9AzcMsnKVKfjFi7E1lXRzO9d3+XRv4tJiFjJiJurzStDSNKSPfgQjaQUVKjxpPBUM/DWKISkS+VfcXI+2NgBVt7rD9sQvNItKw4K+P4TR0EAUsEO6Bkh3BkdWuDHHYUkDD3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cFhkGAmX; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cFhkGAmX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598981; x=1774134981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tYZ1FbeM8OZ/TWZgv1s5cxOJKU9ePb/qzpnBJ1zSw5g=;
  b=cFhkGAmXLVpbDhzJluLQU3SuWAm+fh5bTl/q1O3UfZAuNXFRMtxLFo26
   QGj2yqy3eVo/Ci0seZYsHt1lK9XRWKgaTlJf8ekgAGl7fJT2GFQ2Xx0CU
   KLEttNNYuPMJhC5pFzqquoVF1FNIGv3g94FZI/SKRQ7wPHxQMNHuWWlVC
   oZeoGvBSyEDQCatxR9yyFuEdi/6s+mDdCkK1/jE2zqlZQIpJdBAzCnpO5
   WcLoyGHtAhurNYzbnOIEYubloUTmFXYzh6fBbZZcuVkfPw2A/OXWETRN9
   ZvaqFak5nfdlNLRWx9R/1DGJXPL+Om4VMinJ9y1maTIl1QtfmquyV//jn
   w==;
X-CSE-ConnectionGUID: RgzqvGOhQNSIwnJYj58d2Q==
X-CSE-MsgGUID: JY+oV6B9TGSe8Njey/3gVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604547"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604547"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:19 -0700
X-CSE-ConnectionGUID: E6qkJL7+ThKDKg8hccO/1Q==
X-CSE-MsgGUID: vTQN5B0xT0aP+RutRW4EFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354289"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 01/16] x86/rectrl: Fake OOBMSM interface
Date: Fri, 21 Mar 2025 16:15:51 -0700
Message-ID: <20250321231609.57418-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Real version is coming soon ... this is here so the remaining parts
will build (and run ... assuming a 2 socket system that supports RDT
monitoring ... only missing part is that the event counters just
report fixed values).

Real version of this would just add the INTEL_AET_RESCTRL Kconfig
option with dependency checks on
  INTEL_VSEC=y && INTEL_AET_TELEMETRY=y && INTEL_AET_DISCOVERY=y

Just for RFC discussion.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../cpu/resctrl/fake_intel_aet_features.h     | 73 +++++++++++++++++++
 .../cpu/resctrl/fake_intel_aet_features.c     | 65 +++++++++++++++++
 arch/x86/Kconfig                              |  1 +
 arch/x86/kernel/cpu/resctrl/Makefile          |  1 +
 drivers/platform/x86/intel/pmt/Kconfig        |  3 +
 5 files changed, 143 insertions(+)
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
index 000000000000..b537068d99fb
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
@@ -0,0 +1,65 @@
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
+#define ENERGY_QWORDS	((576 * 2) + 3)
+#define PERF_QWORDS	((576 * 7) + 3)
+
+static long pg[4 * ENERGY_QWORDS + 2 * PERF_QWORDS];
+
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
+#define PKG_REGION(_entry, _guid, _addr, _pkg)	\
+	[_entry] = { .guid = _guid, .addr = (void __iomem *)_addr, .plat_info = { .package_id = _pkg }}
+
+static struct pmt_feature_group fake_energy = {
+	.count = 4,
+	.regions = {
+		PKG_REGION(0, 0x26696143, &pg[0 * ENERGY_QWORDS], 0),
+		PKG_REGION(1, 0x26696143, &pg[1 * ENERGY_QWORDS], 0),
+		PKG_REGION(2, 0x26696143, &pg[2 * ENERGY_QWORDS], 1),
+		PKG_REGION(3, 0x26696143, &pg[3 * ENERGY_QWORDS], 1)
+	}
+};
+
+static struct pmt_feature_group fake_perf = {
+	.count = 2,
+	.regions = {
+		PKG_REGION(0, 0x26557651, &pg[4 * ENERGY_QWORDS + 0 * PERF_QWORDS], 0),
+		PKG_REGION(1, 0x26557651, &pg[4 * ENERGY_QWORDS + 1 * PERF_QWORDS], 1)
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
+	return ERR_PTR(-ENOENT);
+}
+
+void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
+{
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ea29d22a621f..6112cb6cad05 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -504,6 +504,7 @@ config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
+	select INTEL_AET_RESCTRL	if X86_64
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
 	select RESCTRL_FS_PSEUDO_LOCK
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 909be78ec6da..2c3b09f95127 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
+obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
 
 # To allow define_trace.h's recursive include:
 CFLAGS_pseudo_lock.o = -I$(src)
diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
index e916fc966221..6d3b1f64efe9 100644
--- a/drivers/platform/x86/intel/pmt/Kconfig
+++ b/drivers/platform/x86/intel/pmt/Kconfig
@@ -38,3 +38,6 @@ config INTEL_PMT_CRASHLOG
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called intel_pmt_crashlog.
+
+config INTEL_AET_RESCTRL
+	bool
-- 
2.48.1

