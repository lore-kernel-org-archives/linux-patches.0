Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ABC242913
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278051; cv=none; b=N4OuxDBa5CFbt4u8udSki8lFap5KukgmLsbjLapwP4pfZOlK3OemJpKCkEfTgEE6tU0q84sSO5e0mSwn6t21WM1lfepBQz3mEIFCH0XFKXtQmW8DQqbJdTZtADMGvFWuH2ndCTe5VPb83Iomi38OvZWIOFU5Z1lWTKZA9bT0Jds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278051; c=relaxed/simple;
	bh=fkpxh0C95+6Da6B8X7C55fRweCncfJwklz0h878nBRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5V2a3PG3HpHJh1D8963yj5kcyJZwl1MAwzHofEf7M5uHXLhydMjlX55DBPKBJJ+/Nzo237vryxHmwlmbvMJY0jS/7JCgHy9JpZF8e61r3hExemIEG5JUA0xUCMefTy0xjCv0emAU4J9Oi7hJ5trTAhpaY5jLNFVINvzMNR5YsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S2sVxueQ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S2sVxueQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278049; x=1783814049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fkpxh0C95+6Da6B8X7C55fRweCncfJwklz0h878nBRA=;
  b=S2sVxueQb99Xo1+1B+alE79Y7UF9gwBcPjYXzhvsGKVfibjDbPBw2I+t
   gRgStiYRftm3nHkjjQ6Le0UwQEkZs8hKh25TEH8Wfcva8qgVlgdgNJ6QU
   +1kvRvjLibA30tfbUuKuIarN1bxsyD43G6jEpBaWIHc8Hbw7pp8onIwRy
   a/JNp9QxTStzqAVglYoxhf+tfQ5lkGC4GUm6zQGrfo5nb1IjeOT7D8/KR
   LBajUgThODHLV5rI/wkQgawAKX+KGQ5l5gp3L7gmwB4IcWzisqsIGaHFO
   4LoDWOXzKU0iXKoK/DWkn+uU2BnDhnr/Sr8ZMSzVACIgmqGfykSRfrn7B
   g==;
X-CSE-ConnectionGUID: vNNciLxAR52shGjL6p2gIQ==
X-CSE-MsgGUID: XbdBzoOjRrmY/Mw112nVMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292778"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292778"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:05 -0700
X-CSE-ConnectionGUID: NrG1xr/pQuucf++Ksr42og==
X-CSE-MsgGUID: diTXGm0CRUemyIwX57rzEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902163"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:05 -0700
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
Subject: [PATCH v7 25/31] x86/resctrl: Handle number of RMIDs supported by telemetry resources
Date: Fri, 11 Jul 2025 16:53:32 -0700
Message-ID: <20250711235341.113933-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
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
at any time. This means that users cannot reliably collect two consecutive
event counts to compute the rate at which events are occurring.

Add a variable rdt_num_system_rmids which holds the number of RMIDs
supported by the system (including adjustments if Sub-NUMA Cluster
mode is enabled).

Use rdt_set_feature_disabled() to mark such under-resourced event groups
as unusable.  Note that the rdt_options[] structure must now be writable
at run-time.  The request to disable will be overridden if the user
explicitly requests to enable using the "rdt=" Linux boot argument.

Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
resource "num_rmids" value to the smallest of these values as this
value will be used later to compare against the number of RMIDs
supported by other resources.

N.B. Changed type of rdt_resource::num_rmid to u32 to match, and
print as unsigned value in rdt_num_rmids_show().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 +++
 arch/x86/kernel/cpu/resctrl/core.c      | 18 ++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 36 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
 fs/resctrl/rdtgroup.c                   |  2 +-
 6 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index da76e9c37b69..74cd2979549b 100644
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
index 83166dd0b9c8..a6c41068dc2f 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -18,6 +18,8 @@
 
 #define RMID_VAL_UNAVAIL		BIT_ULL(62)
 
+extern u32 rdt_num_system_rmids;
+
 /*
  * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
  * data to be returned. The counter width is discovered from the hardware
@@ -171,6 +173,8 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 bool rdt_is_feature_enabled(char *option);
 
+void rdt_set_feature_disabled(char *name);
+
 #ifdef CONFIG_X86_RESCTRL_CPU_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 83e046313600..31fb598482bf 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -807,7 +807,7 @@ struct rdt_options {
 	bool	force_off, force_on;
 };
 
-static struct rdt_options rdt_options[]  __ro_after_init = {
+static struct rdt_options rdt_options[] = {
 	RDT_OPT(RDT_FLAG_CMT,	    "cmt",	X86_FEATURE_CQM_OCCUP_LLC),
 	RDT_OPT(RDT_FLAG_MBM_TOTAL, "mbmtotal", X86_FEATURE_CQM_MBM_TOTAL),
 	RDT_OPT(RDT_FLAG_MBM_LOCAL, "mbmlocal", X86_FEATURE_CQM_MBM_LOCAL),
@@ -869,6 +869,22 @@ bool rdt_cpu_has(int flag)
 	return ret;
 }
 
+/*
+ * Can be called during feature enumeration if sanity check of
+ * a features parameters indicates problems with the feature.
+ */
+void rdt_set_feature_disabled(char *name)
+{
+	struct rdt_options *o;
+
+	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
+		if (!strcmp(name, o->name)) {
+			o->force_off = true;
+			return;
+		}
+	}
+}
+
 /*
  * Hardware features that do not have X86_FEATURE_* bits.
  * There is no "hardware does not support this at all" case.
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index e64a4630e95c..6958efbf7e81 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
+#include <linux/minmax.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -56,6 +57,9 @@ struct pmt_event {
  * @list:		List of active event groups.
  * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
  * @guid:		Unique number per XML description file.
+ * @num_rmids:		Number of RMIDS supported by this group. Adjusted downwards
+ *			if enumeration from intel_pmt_get_regions_by_feature() indicates
+ *			fewer RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
@@ -69,6 +73,7 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	u32				num_rmids;
 	size_t				mmio_size;
 	unsigned int			num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -86,6 +91,7 @@ static LIST_HEAD(active_event_groups);
 static struct event_group energy_0x26696143 = {
 	.name		= "energy",
 	.guid		= 0x26696143,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
 	.evts				= {
@@ -101,6 +107,7 @@ static struct event_group energy_0x26696143 = {
 static struct event_group perf_0x26557651 = {
 	.name		= "perf",
 	.guid		= 0x26557651,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
 	.evts				= {
@@ -143,6 +150,22 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
 	return false;
 }
 
+static bool check_rmid_count(struct event_group *e, struct pmt_feature_group *p)
+{
+	struct telemetry_region *tr;
+
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (skip_this_region(tr, e))
+			continue;
+
+		if (tr->num_rmids < rdt_num_system_rmids)
+			return false;
+	}
+
+	return true;
+}
+
 static void free_pkg_mmio_info(struct pkg_mmio_info **mmi)
 {
 	int num_pkgs = topology_max_packages();
@@ -165,12 +188,18 @@ DEFINE_FREE(pkg_mmio_info, struct pkg_mmio_info **, free_pkg_mmio_info(_T))
  */
 static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	struct pkg_mmio_info **pkginfo __free(pkg_mmio_info) = NULL;
 	int *pkgcounts __free(kfree) = NULL;
 	struct telemetry_region *tr;
 	struct pkg_mmio_info *mmi;
 	int num_pkgs;
 
+	/* Potentially disable feature if insufficient RMIDs */
+	if (!check_rmid_count(e, p))
+		rdt_set_feature_disabled(e->name);
+
+	/* User can override above disable from kernel command line */
 	if (!rdt_is_feature_enabled(e->name))
 		return -EINVAL;
 
@@ -182,6 +211,8 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 		if (skip_this_region(tr, e))
 			continue;
 
+		e->num_rmids = min(e->num_rmids, tr->num_rmids);
+
 		if (!pkgcounts) {
 			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
 			if (!pkgcounts)
@@ -228,6 +259,11 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 		resctrl_enable_mon_event(eventid, true, e->evts[i].bin_bits, &e->evts[i]);
 	}
 
+	if (r->num_rmid)
+		r->num_rmid = min(r->num_rmid, e->num_rmids);
+	else
+		r->num_rmid = e->num_rmids;
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 51d7d99336c6..aac7b7310d81 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -33,6 +33,7 @@ bool rdt_mon_capable;
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
+u32 rdt_num_system_rmids;
 static int snc_nodes_per_l3_cache = 1;
 
 /*
@@ -358,6 +359,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
 	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
+	rdt_num_system_rmids = r->num_rmid;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 11792e841525..9e4df213906f 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1135,7 +1135,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
-	seq_printf(seq, "%d\n", r->num_rmid);
+	seq_printf(seq, "%u\n", r->num_rmid);
 
 	return 0;
 }
-- 
2.50.0

