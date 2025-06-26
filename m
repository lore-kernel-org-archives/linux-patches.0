Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC502EF9A0
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956605; cv=none; b=oAhNleK3uT1lU4H8H0VF4DdiBnU5dqulxJ2pI6PPl50ZxrNiSxxA1qbDNnplTNMl4vLuWzzss6VShL+p8vrW+l47xR8F3B1htubvsi6DnxEGOWmjjIhrEUARr9aDVknGRVTFsptjySPHqAOw30mviu8sgeRJbS+d8dRxcv0k4Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956605; c=relaxed/simple;
	bh=7biPcEnJAj9OHprYSK1TT3pcgkvA7O+za+kQrNc5lkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8hIS+OXdJmw3QxMga89c7Dpd/B4Yc+qRetwXa/2IsXiypbOtU7qspJvzwNMm6dyc1bNVRu0Qh35hSNeoB45K95EKhmdTUXDbw30p9eNwgwWf1+Fu0GuIbBXoSE/LnI9TrbQ4SsP381LjLrr/WSpwqKEyrScWsSmU+FJ4JLgbKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgzn6tcz; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgzn6tcz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956604; x=1782492604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7biPcEnJAj9OHprYSK1TT3pcgkvA7O+za+kQrNc5lkU=;
  b=cgzn6tcz6OdMfD6gikjlo11+Nh+oD2mqejkhiyk1n5K5KMy1SQHr+Lzl
   CPyDuQcLqNbU+tcGwxlGdZ3r5Hn4uIku1lM+7aYi3gN9nyLeCUExqpQ+T
   HCUNshRwDhQYufYSglHS6x7Uh43mImsJxd2IoMdyaAfGfgY5BZ/WhZtiU
   Lfr2SGpcUDgPhmdGa9xu7sFYI5tbM6xpMIWDsPg91DBD0bBCCn+129t9y
   7y7B3Aia10xgFZ2eDkqK6DOC7klzuzn2iqVM1hWIlhc785C5+49D+cOFO
   Rp2BmJQGXV05u1X5WJnQDzzDoD/rTziI7af0bWDCLcMEjGFhWxLyJaP7S
   w==;
X-CSE-ConnectionGUID: 0RVavtWSR32j2DZwCewWWg==
X-CSE-MsgGUID: WerL4b/wQWWnCYfR3cJYCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136454"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136454"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:59 -0700
X-CSE-ConnectionGUID: BcPwSVbxQHKwmPKWVorxbg==
X-CSE-MsgGUID: tAjvsF6XTGifWFSKeUoQTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069254"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:58 -0700
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
Subject: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
Date: Thu, 26 Jun 2025 09:49:26 -0700
Message-ID: <20250626164941.106341-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
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
an XML file published in the https://github.com/intel/Intel-PMT
that provides all the details about each aggregator.

The XML files provide the following information:
1) Which telemetry events are included in the group for this aggregator.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for this aggregator.

Add select of X86_PLATFORM_DEVICES, INTEL_VSEC and
INTEL_PMT_TELEMETRY to CONFIG_X86_CPU_RESCTRL to enable use of the
discovery driver that enumerate all aggregators on the system with
intel_pmt_get_regions_by_feature(). Call this for each pmt_feature_id
that indicates per-RMID telemetry.

Save the returned pmt_feature_group pointers with guids that are known
to resctrl for use at run time.

Those pointers are returned to the INTEL_PMT_DISCOVERY driver at
resctrl_arch_exit() time.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   3 +
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 122 ++++++++++++++++++++++++
 arch/x86/Kconfig                        |   3 +
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 5 files changed, 134 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 224b71730cc3..e93b15bf6aab 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -169,4 +169,7 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+bool intel_aet_get_events(void);
+void __exit intel_aet_exit(void);
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index a5f01cac2363..9144766da836 100644
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
index 000000000000..b09044b093dd
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
+static struct event_group *known_event_groups[] = {
+	&energy_0x26696143,
+	&perf_0x26557651,
+};
+
+#define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
+
+/* Stub for now */
+static int configure_events(struct event_group *e, struct pmt_feature_group *p)
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
+ * Try to configure any with a known matching guid.
+ */
+static bool get_pmt_feature(enum pmt_feature_id feature)
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
+	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
+		ret = configure_events(*peg, p);
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
+	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
+	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
+
+	return ret1 || ret2;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group **peg;
+
+	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
+		if ((*peg)->pfg) {
+			intel_pmt_put_feature_group((*peg)->pfg);
+			(*peg)->pfg = NULL;
+		}
+	}
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 71019b3b54ea..8eb68d2230be 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -512,6 +512,9 @@ config X86_CPU_RESCTRL
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
 	select RESCTRL_FS_PSEUDO_LOCK
+	select X86_PLATFORM_DEVICES
+	select INTEL_VSEC
+	select INTEL_PMT_TELEMETRY
 	help
 	  Enable x86 CPU resource control support.
 
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index d8a04b195da2..97ceb4e44dfa 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_X86_CPU_RESCTRL)		+= intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.49.0

