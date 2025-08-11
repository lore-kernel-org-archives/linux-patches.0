Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81132D6E42
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936271; cv=none; b=WRg/iDHTHdyRqLa+tyMXeVXGOQ9bQNTH7cxx6e/7VgdPngC4ET70qXlhHjf9G8+WB8+LTnMN5ZzlXnZWloD15+eWmiLPRy2zyQWYkg1J20YvqfM8V0lHDxciNk2VzEZ66gzNKRCel+4xJ8haxBBA3V5/fFjAr2fMXA78px8rh+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936271; c=relaxed/simple;
	bh=I7V5rvBsGe1JDp56MACDgj0Jg42lsEAPwGwQulYwT2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHGxpnIaDolY1uh9PMXFFTqyVOjpFuHgzJMruRhPHE6hk/N1DeFu1q4jWxc1Ugm4H2cfIuLjlU1fwXdRGRwaDe/11itl5/7xw8R6sylrOelkv4glb0PUx7SGPLVyCimDVfxnDR7x1GffmFVZIO7ErJupmgAJhuTuNeDlzTz25s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qq+XrbTy; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qq+XrbTy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936269; x=1786472269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I7V5rvBsGe1JDp56MACDgj0Jg42lsEAPwGwQulYwT2U=;
  b=Qq+XrbTyI4ULvinhNVb7S/6MUtnvYy7lmKTgY3+GykjSbS4KevXs1yjF
   JwICh50KbN3dDF59XzZuwDzfdBlRkCUT1doNt8pAoeiDWS3nw79f1eSEE
   hcX7IJTWWT1647euOOAOPOdjPhsqIIH0Q0Ey1M9nMMZTM/k7rS9fVTHrD
   qiB0K12DhlqnFmpY9kLTf/SOF6osalLv29Qpa1Obd7h9vtZe5EqSvlvnq
   xYjaZJDDQToQebBxWl6SLaKPzYkTW2nPnzy059w2jVTxtM500SnqdoEDx
   1e2mfVRGqy0yGCzVnYn6Ed3qDxhFzzBfNUpBzp7lcOTYDegbGRgsRu3g6
   g==;
X-CSE-ConnectionGUID: bqxWL49GRIOudONx0cHSmA==
X-CSE-MsgGUID: WTpaLyidQI6s6q44ZeFeIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277478"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277478"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: eqopBtCCTPeCb5A3nN0koA==
X-CSE-MsgGUID: 9y8tvfKYRo+KoAFXnSUS6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825698"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
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
Subject: [PATCH v8 25/32] x86/resctrl: Handle number of RMIDs supported by telemetry resources
Date: Mon, 11 Aug 2025 11:16:59 -0700
Message-ID: <20250811181709.6241-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
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

3) The number of "hardware counters" (this isn't a strictly accurate
description of how things work, but serves as a useful analogy that
does describe the limitations) feeding to those MMIO registers. This
is enumerated in telemetry_region::num_rmids returned from the call to
intel_pmt_get_regions_by_feature()

Event groups with insufficient "hardware counters" to track all RMIDs
are difficult for users to use, since the system may reassign "hardware
counters" at any time. This means that users cannot reliably collect
two consecutive event counts to compute the rate at which events are
occurring.

Use rdt_set_feature_disabled() to mark any under-resourced event groups
(those with telemetry_region::num_rmids < event_group::num_rmids) as
unusable.  Note that the rdt_options[] structure must now be writable
at run-time.  The request to disable will be overridden if the user
explicitly requests to enable using the "rdt=" Linux boot argument.

Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
resource "num_rmids" value to the smallest of these values as this value
will be used later to compare against the number of RMIDs supported by
other resources.

N.B. Changed type of rdt_resource::num_rmid to u32 to match type of
event_group::num_rmids so that min(r->num_rmid, e->num_rmids) won't
complain about mixing signed and unsigned types.  Print r->num_rmid as
unsigned value in rdt_num_rmids_show().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c      | 18 ++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 43 +++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                   |  2 +-
 5 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d729e988a475..c1cfba3c8422 100644
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
index e76b5e35351b..0e292c2d78a1 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -179,6 +179,8 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 bool rdt_is_feature_enabled(char *name);
 
+void rdt_set_feature_disabled(char *name);
+
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d151aabe2b93..2b011f9efc73 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -776,7 +776,7 @@ struct rdt_options {
 	bool	force_off, force_on;
 };
 
-static struct rdt_options rdt_options[]  __ro_after_init = {
+static struct rdt_options rdt_options[] = {
 	RDT_OPT(RDT_FLAG_CMT,	    "cmt",	X86_FEATURE_CQM_OCCUP_LLC),
 	RDT_OPT(RDT_FLAG_MBM_TOTAL, "mbmtotal", X86_FEATURE_CQM_MBM_TOTAL),
 	RDT_OPT(RDT_FLAG_MBM_LOCAL, "mbmlocal", X86_FEATURE_CQM_MBM_LOCAL),
@@ -838,6 +838,22 @@ bool rdt_cpu_has(int flag)
 	return ret;
 }
 
+/*
+ * Can be called during feature enumeration if sanity check of
+ * a feature's parameters indicates problems with the feature.
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
index 7db03e24d4b2..96c454748320 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
+#include <linux/minmax.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -50,24 +51,30 @@ struct pmt_event {
 
 /**
  * struct event_group - All information about a group of telemetry events.
+ * @name:		Name for this group (used by boot rdt= option)
  * @pfg:		Points to the aggregated telemetry space information
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
  * @list:		Member of active_event_groups.
  * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
  * @guid:		Unique number per XML description file.
+ * @num_rmids:		Number of RMIDS supported by this group. Adjusted downwards
+ *			if enumeration from intel_pmt_get_regions_by_feature() indicates
+ *			fewer RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
+	char				*name;
 	struct pmt_feature_group	*pfg;
 	struct list_head		list;
 	struct pkg_mmio_info		**pkginfo;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	u32				num_rmids;
 	size_t				mmio_size;
 	unsigned int			num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -84,7 +91,9 @@ static LIST_HEAD(active_event_groups);
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
+	.name		= "energy",
 	.guid		= 0x26696143,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
 	.evts				= {
@@ -98,7 +107,9 @@ static struct event_group energy_0x26696143 = {
  * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
  */
 static struct event_group perf_0x26557651 = {
+	.name		= "perf",
 	.guid		= 0x26557651,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
 	.evts				= {
@@ -137,6 +148,22 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
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
+		if (tr->num_rmids < e->num_rmids)
+			return false;
+	}
+
+	return true;
+}
+
 static void free_pkg_mmio_info(struct pkg_mmio_info **mmi)
 {
 	int num_pkgs = topology_max_packages();
@@ -159,12 +186,21 @@ DEFINE_FREE(pkg_mmio_info, struct pkg_mmio_info **, free_pkg_mmio_info(_T))
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
+	if (!rdt_is_feature_enabled(e->name))
+		return -EINVAL;
+
 	num_pkgs = topology_max_packages();
 
 	/* Get per-package counts of telemetry regions for this event group */
@@ -173,6 +209,8 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 		if (skip_this_region(tr, e))
 			continue;
 
+		e->num_rmids = min(e->num_rmids, tr->num_rmids);
+
 		if (!pkgcounts) {
 			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
 			if (!pkgcounts)
@@ -215,6 +253,11 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 	for (int i = 0; i < e->num_events; i++)
 		resctrl_enable_mon_event(e->evts[i].id, true, e->evts[i].bin_bits, &e->evts[i]);
 
+	if (r->num_rmid)
+		r->num_rmid = min(r->num_rmid, e->num_rmids);
+	else
+		r->num_rmid = e->num_rmids;
+
 	return 0;
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 26928ad0a35a..55ad99bd77d2 100644
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
2.50.1

