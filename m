Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71402356C8
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044890; cv=none; b=shGHiu9NcuGt6/P673ZWe9oMbfR8oXADzFc3LjFapdDyXI4qOEHkYi+FZEOc3nMCXmdNDYo8ldYzgqxbFd3wJ6yraALEosuXFqsxfXhqlCcQ9mJ58MUphbGjX1tYellZm3VhwV82pWn8b5xVIxKJSiZQX51YuSy/PiRiNbbinHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044890; c=relaxed/simple;
	bh=uvN0CFicBAuI2wa5AZA2m8GAenZkKcAknc7QVhdTpqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4WiyT0+sDppA8E922HG4NDxKtKTDNW5pOHR9uwi49/hjqx3EyJsV0D59ygVkaWqRKsnI/epT8W/bQdWHFdAAuwh+GGZQVLCGvnqH28/Uc3J7izvLzruMGifwwDtTjpjCyBgrBoMK9HID9I4zMaR2jg1vS5LaAk1ozb8iHHRxI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c+vH40u2; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+vH40u2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044889; x=1772580889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uvN0CFicBAuI2wa5AZA2m8GAenZkKcAknc7QVhdTpqM=;
  b=c+vH40u2JN7C4avGGbXLNkx6Ezb3Fk5oBUC4BxF6rsOxZcuuCITGXayH
   lvyQ+qtpEBaSbc9lcq6oIHMfIOfvR6GgTuguBVfWcFPPxyTmpLmZblpIa
   jA2CyUAh5m7oevJ6pFbxGOaI2vIlrgfsk8M1W+j0Lvs7UJ5cbGOS9tTpl
   c6Sp03u+0b+Iyl/HvFtEulLZt6jD6EplGjnMCKZ4LGK80tu2j544wIuZd
   s1L45hT2XTW8isUCq4r3h86pYHkJKWi2xnSaNMeutFaW+iK2am/6nVacH
   Zz1FLLKJwYmFuiq3tUQ9Mi3bTSCtI+9C2gbzgtF0LyR8khRuNjx5MShq0
   g==;
X-CSE-ConnectionGUID: 1Iu0Z2oeSFCTxPY0lELHwg==
X-CSE-MsgGUID: tk8tf0nnRH+KyngxeM5E6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835908"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835908"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:46 -0800
X-CSE-ConnectionGUID: WxlDdYqrTIucBT13ZhgrkQ==
X-CSE-MsgGUID: 1S8qf5VrSWqc6TIvt7YUZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982280"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:50 -0800
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
Subject: [RFC PATCH 01/17] x86/rectrl: Fake OOBMSM interface
Date: Mon,  3 Mar 2025 15:33:21 -0800
Message-ID: <20250303233340.333743-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
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

Real version of this would just add the INTEL_PMT_RESCTRL Kconfig
option with dependency checks on
  INTEL_VSEC=y && INTEL_PMT_TELEMETRY=y && INTEL_PMT_DISCOVERY=y

Just for RFC discussion.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../cpu/resctrl/fake_intel_pmt_features.h     | 72 +++++++++++++++++++
 .../cpu/resctrl/fake_intel_pmt_features.c     | 64 +++++++++++++++++
 arch/x86/Kconfig                              |  1 +
 arch/x86/kernel/cpu/resctrl/Makefile          |  1 +
 drivers/platform/x86/intel/pmt/Kconfig        |  3 +
 5 files changed, 141 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.c

diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.h b/arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.h
new file mode 100644
index 000000000000..52fdd04e5094
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.h
@@ -0,0 +1,72 @@
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
diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.c b/arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.c
new file mode 100644
index 000000000000..6d27cf1a151b
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.c
@@ -0,0 +1,64 @@
+#include <linux/cleanup.h>
+#include <linux/minmax.h>
+#include <linux/slab.h>
+#include "fake_intel_pmt_features.h"
+#include <linux/intel_vsec.h>
+#include <asm/resctrl.h>
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
+	[_entry] = { .guid = _guid, .addr = _addr, .plat_info = { .package_id = _pkg }}
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
index be2c311f5118..ec6a7b996e09 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -505,6 +505,7 @@ config X86_CPU_RESCTRL
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	select KERNFS
 	select PROC_CPU_RESCTRL		if PROC_FS
+	select INTEL_PMT_RESCTRL
 	help
 	  Enable x86 CPU resource control support.
 
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 4a06c37b9cf1..72621ea6cd6a 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)	+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)	+= ctrlmondata.o pseudo_lock.o
+obj-$(CONFIG_INTEL_PMT_RESCTRL)	+= fake_intel_pmt_features.o
 CFLAGS_pseudo_lock.o = -I$(src)
diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
index e916fc966221..4cbfd8a42252 100644
--- a/drivers/platform/x86/intel/pmt/Kconfig
+++ b/drivers/platform/x86/intel/pmt/Kconfig
@@ -38,3 +38,6 @@ config INTEL_PMT_CRASHLOG
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called intel_pmt_crashlog.
+
+config INTEL_PMT_RESCTRL
+	bool
-- 
2.48.1

