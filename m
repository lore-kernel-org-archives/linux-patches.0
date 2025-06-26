Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8DF2F2340
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956611; cv=none; b=JL3Yjl8L9x5j+nSaRA8IumogQTcgK4ewkXaJqKunV9o0FpAMHSSjHnBUlnQ5rzuanDQ7C5l5q1QFwQMTfGvm4K12GcTKdUYZq9ooteRXP22tbngCfioQ26LBZcww7m/AyC1rMGl/Hg8kbsKqiPDrlAEYJ1jX6mH0Zi1XD44/XaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956611; c=relaxed/simple;
	bh=YikFiNDb1sLidgNjOTzLL0h1wVveGVN8ygpUZOna8tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoePvAfF1SfprQALiE375VYebLmqY8gx52SQ2nGKcdhgP7Uf/K3io2o993iJLLlyrrEszAzx1Ci8esplt9jCnhGOWVn5eJeQDVAtHqctrp8gsKhkZ+BclXNLNwPLzgp//lu6tPwW5s1FtdiY4tPJh9scv46eTZgYul4AhyZaUmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CBv0Zo5G; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CBv0Zo5G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956610; x=1782492610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YikFiNDb1sLidgNjOTzLL0h1wVveGVN8ygpUZOna8tk=;
  b=CBv0Zo5Gp0ek0IdlbQWYTk3iPjXU7xT0KNCoez41Q7LYhwzzsXjzmNFL
   yi2qiJRYv3kAeWjfsk0bdMR72+XgmxVydo5SQRZdBSamPn2mrKbzuXBX1
   BUCWvq2lSkK+QJ30Rnuqmswk5Ksc09OsUahe7+7OSoLCbZ7ZjCGo9ndQk
   o37Uz6/wOqGKs208D25r4+/GHkiemi0AFhbIxYPqy0w7Tpr9YgfGqjX+K
   DMWy0rL5tf1kCPuuZwpxfBIn57YmAb1TMrsXXQNYTFm2PjX53BwEzB17O
   7LRCgC+Mg/ioR24kCorLR6nOw/MAW2lmgYqN7Ic9dMzTFin0mLyiqcXqq
   Q==;
X-CSE-ConnectionGUID: NZ6g8OYQRse65QO8W573ow==
X-CSE-MsgGUID: 05WJCiW7QVuexsY71iejbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136520"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136520"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:03 -0700
X-CSE-ConnectionGUID: O6dEzYqaQ6ydhXIWkxiYQg==
X-CSE-MsgGUID: JsUFu0wvQ7iu+NGTQyUqjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069318"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:02 -0700
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
Subject: [PATCH v6 25/30] x86/resctrl: Handle number of RMIDs supported by telemetry resources
Date: Thu, 26 Jun 2025 09:49:34 -0700
Message-ID: <20250626164941.106341-26-tony.luck@intel.com>
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

There are now three meanings for "number of RMIDs":

1) The number for legacy features enumerated by CPUID leaf 0xF. This
is the maximum number of distinct values that can be loaded into the
IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
will force scaling down the CPUID enumerated value by the number of SNC
nodes per L3-cache.

2) The number of registers in MMIO space for each event. This
is enumerated in the XML files and is the value initialized into
event_group::num_rmids. This will be overwritten with a lower
value if hardware does not support all these registers at the
same time (see next case).

3) The number of "h/w counters" (this isn't a strictly accurate
description of how things work, but serves as a useful analogy that
does describe the limitations) feeding to those MMIO registers. This
is enumerated in telemetry_region::num_rmids returned from the call to
intel_pmt_get_regions_by_feature()

Event groups with insufficient "h/w counter" to track all RMIDs are
difficult for users to use, since the system may reassign "h/w counters"
as any time. This means that users cannot reliably collect two consecutive
event counts to compute the rate at which events are occurring.

Ignore such under-resourced event groups unless the user explicitly
requests to enable them using the "rdt=" Linux boot argument.

Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
resource "num_rmids" value to the smallest of these values to ensure
that all resctrl groups have equal monitor capabilities.

N.B. Changed type of rdt_resource::num_rmids to u32 to match.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 ++++
 arch/x86/kernel/cpu/resctrl/core.c      | 20 +++++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
 5 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b9f2690bee1e..35ae24822493 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -288,7 +288,7 @@ struct rdt_resource {
 	int			rid;
 	bool			alloc_capable;
 	bool			mon_capable;
-	int			num_rmid;
+	u32			num_rmid;
 	enum resctrl_scope	ctrl_scope;
 	enum resctrl_scope	mon_scope;
 	struct resctrl_cache	cache;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index ee1c6204722e..11f25c225837 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -18,6 +18,8 @@
 
 #define RMID_VAL_UNAVAIL		BIT_ULL(62)
 
+extern int rdt_num_system_rmids;
+
 /*
  * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
  * data to be returned. The counter width is discovered from the hardware
@@ -171,6 +173,8 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 bool rdt_is_software_feature_enabled(char *option);
 
+bool rdt_is_software_feature_force_enabled(char *name);
+
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f9f3bc58290e..7fe4e8111773 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -895,6 +895,26 @@ bool rdt_is_software_feature_enabled(char *name)
 	return ret;
 }
 
+/*
+ * Similar to rdt_is_software_feature_enabled() but the test is whether
+ * the user has force enabled the feature on the kernel command line.
+ */
+bool rdt_is_software_feature_force_enabled(char *name)
+{
+	struct rdt_options *o;
+	bool ret = false;
+
+	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
+		if (!strcmp(name, o->name)) {
+			if (o->force_on)
+				ret = true;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
 {
 	if (!rdt_cpu_has(X86_FEATURE_BMEC))
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 1d2511984156..1d9edd409883 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
+#include <linux/minmax.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -55,6 +56,9 @@ struct pmt_event {
  *			telemetry regions.
  * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
  * @guid:		Unique number per XML description file.
+ * @num_rmids:		Number of RMIDS supported by this group. Adjusted downwards
+ *			if enumeration from intel_pmt_get_regions_by_feature() indicates
+ *			fewer RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
@@ -67,6 +71,7 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	u32				num_rmids;
 	size_t				mmio_size;
 	int				num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -82,6 +87,7 @@ struct event_group {
 static struct event_group energy_0x26696143 = {
 	.name		= "energy",
 	.guid		= 0x26696143,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
 	.evts				= {
@@ -97,6 +103,7 @@ static struct event_group energy_0x26696143 = {
 static struct event_group perf_0x26557651 = {
 	.name		= "perf",
 	.guid		= 0x26557651,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
 	.evts				= {
@@ -177,6 +184,17 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 			return -EINVAL;
 		}
 
+		/*
+		 * Ignore event group with fewer RMIDs than can be loaded
+		 * into the IA32_PQR_ASSOC MSR unless the user used
+		 * the rdt= boot option to specifically ask for it to
+		 * be enabled.
+		 */
+		if (tr->num_rmids < rdt_num_system_rmids &&
+		    !rdt_is_software_feature_force_enabled(e->name))
+			return -EINVAL;
+		e->num_rmids = min(e->num_rmids, tr->num_rmids);
+
 		if (!pkgcounts) {
 			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
 			if (!pkgcounts)
@@ -263,11 +281,22 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
  */
 bool intel_aet_get_events(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	struct event_group **eg;
 	bool ret1, ret2;
 
 	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
 	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
 
+	for (eg = &known_event_groups[0]; eg < &known_event_groups[NUM_KNOWN_GROUPS]; eg++) {
+		if (!(*eg)->pfg)
+			continue;
+		if (r->num_rmid)
+			r->num_rmid = min(r->num_rmid, (*eg)->num_rmids);
+		else
+			r->num_rmid = (*eg)->num_rmids;
+	}
+
 	return ret1 || ret2;
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 51d7d99336c6..b36634f1439b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -33,6 +33,7 @@ bool rdt_mon_capable;
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
+int rdt_num_system_rmids;
 static int snc_nodes_per_l3_cache = 1;
 
 /*
@@ -358,6 +359,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
 	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
+	rdt_num_system_rmids = r->num_rmid;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
-- 
2.49.0

