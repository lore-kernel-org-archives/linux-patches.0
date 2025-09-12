Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF75356901
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715081; cv=none; b=CdhcfrOCkwvJzh8eC+8jbGlvBCZCn3S6T86tHRHp0WOwv2dDwkTz7RfPi/d1/zFUcaazB6Te1aG909XpO6FnorGaMdpRObUjqheZr+BEYD1ltEVnKMI1WseahZoz07tZi8ucw944J2AoaNJNUIE6BrNyQe/uBy+6zzCggUlSJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715081; c=relaxed/simple;
	bh=VGc+Foopox6DjuQaFTBPVHLI0QZJD6Q7gSfBUVt6hiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UraiewZB9YEURuqpy0Jnn3MeLysT9unqJvRLibbPtChviQ7TSdEphUkNNvzbFWzbUcIXuQV4alLFXY6JJKUuMaUb+JgZPuVxjz5kQAjDsnQjbq+X9qm5OyFlBVJKK9uNLAwIoLEeOeW/6iNaP2Y8x0jEAtTCeYGiPgiXu+3GTJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bWSMuaiM; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bWSMuaiM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715079; x=1789251079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VGc+Foopox6DjuQaFTBPVHLI0QZJD6Q7gSfBUVt6hiU=;
  b=bWSMuaiMeDEpIjwB5p7++fuUtIbH2gdEHz9OyZcmcmXHOzreVQ5x5P5V
   2NAVNJVVTClCFphaZF7frIu6ltjLmkDtWN+E8H4i13budEHMP1BbQRn0V
   nXv0uNrSzyobFKr4dSpj5SeenSnZOWhgFTRxDxszfeibjcMZ2U3ycsnJJ
   iNPHzeWv+vOrS4xOT247fHeb1zA36KgKT3bUCdLmGyJ/jPRrWDBSrM18k
   lGHtdC5BfOo9OXDjL2Z6W7Q/s4sgalJKkCRGAwscCUTLzE/NoerWDXUky
   TcC9+FgShhJBqmlb+7nk/W3/FARQNcQJH9vsDiPA3ci2AlUnsMtmYd/p/
   g==;
X-CSE-ConnectionGUID: ElOL3dVlRZKOCM2P6y8TKg==
X-CSE-MsgGUID: NbCuWyoaSESf3P96GKfYhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002808"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002808"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:11 -0700
X-CSE-ConnectionGUID: YYuTJ0YwTniThXlTTtt0ZA==
X-CSE-MsgGUID: Mpf3eDw/ShqNDN9XHjIUIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265212"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:10 -0700
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
Subject: [PATCH v10 21/28] x86/resctrl: Handle number of RMIDs supported by telemetry resources
Date: Fri, 12 Sep 2025 15:10:42 -0700
Message-ID: <20250912221053.11349-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
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
event_group::num_rmids.

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

Introduce rdt_set_feature_disabled() to mark any under-resourced event
groups (those with telemetry_region::num_rmids < event_group::num_rmids)
as unusable.  Note that the rdt_options[] structure must now be writable
at run-time.  The request to disable will be overridden if the user
explicitly requests to enable using the "rdt=" Linux boot argument.
This will result in the available number of monitoring resource groups
being limited by the under-resourced event groups.

Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
resource "num_rmids" value to the smallest of these values as this value
will be used later to compare against the number of RMIDs supported
by other resources to determine how many monitoring resource groups
are supported.

N.B. Change type of rdt_resource::num_rmid to u32 to match type of
event_group::num_rmids so that min(r->num_rmid, e->num_rmids) won't
complain about mixing signed and unsigned types.  Print r->num_rmid as
unsigned value in rdt_num_rmids_show().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c      | 18 +++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 48 +++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                   |  2 +-
 5 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 111c8f1dc77e..c7b5e56d25bb 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -292,7 +292,7 @@ enum resctrl_schema_fmt {
  *			events of monitor groups created via mkdir.
  */
 struct resctrl_mon {
-	int			num_rmid;
+	u32			num_rmid;
 	unsigned int		mbm_cfg_mask;
 	int			num_mbm_cntrs;
 	bool			mbm_cntr_assignable;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index db71ce336af3..2239d7010ff9 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -227,6 +227,8 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 bool rdt_is_feature_enabled(char *name);
 
+void rdt_set_feature_disabled(char *name);
+
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2f789d8bd970..8487449558c6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -782,7 +782,7 @@ struct rdt_options {
 	bool	force_off, force_on;
 };
 
-static struct rdt_options rdt_options[]  __ro_after_init = {
+static struct rdt_options rdt_options[] = {
 	RDT_OPT(RDT_FLAG_CMT,	    "cmt",	X86_FEATURE_CQM_OCCUP_LLC),
 	RDT_OPT(RDT_FLAG_MBM_TOTAL, "mbmtotal", X86_FEATURE_CQM_MBM_TOTAL),
 	RDT_OPT(RDT_FLAG_MBM_LOCAL, "mbmlocal", X86_FEATURE_CQM_MBM_LOCAL),
@@ -845,6 +845,22 @@ bool rdt_cpu_has(int flag)
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
  * Hardware features that do not have X86_FEATURE_* bits. There is no
  * "hardware does not support this at all" case. Assume that the caller
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index dc0d16af66be..039e63d8c2e7 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -25,6 +25,7 @@
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
+#include <linux/minmax.h>
 #include <linux/overflow.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
@@ -55,6 +56,7 @@ struct pmt_event {
 
 /**
  * struct event_group - All information about a group of telemetry events.
+ * @name:		Name for this group (used by boot rdt= option)
  * @pfg:		Points to the aggregated telemetry space information
  *			returned by the intel_pmt_get_regions_by_feature()
  *			call to the INTEL_PMT_TELEMETRY driver that contains
@@ -62,16 +64,22 @@ struct pmt_event {
  *			Valid if the system supports the event group.
  *			NULL otherwise.
  * @guid:		Unique number per XML description file.
+ * @num_rmids:		Number of RMIDs supported by this group. May be
+ *			adjusted downwards if enumeration from
+ *			intel_pmt_get_regions_by_feature() indicates fewer
+ *			RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
+	char				*name;
 	struct pmt_feature_group	*pfg;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	u32				num_rmids;
 	size_t				mmio_size;
 	unsigned int			num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -85,7 +93,9 @@ struct event_group {
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
+	.name		= "energy",
 	.guid		= 0x26696143,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
 	.evts		= {
@@ -99,7 +109,9 @@ static struct event_group energy_0x26696143 = {
  * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
  */
 static struct event_group perf_0x26557651 = {
+	.name		= "perf",
 	.guid		= 0x26557651,
+	.num_rmids	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
 	.evts		= {
@@ -156,21 +168,57 @@ static void mark_telem_region_unusable(struct telemetry_region *tr)
 	tr->addr = NULL;
 }
 
+static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
+{
+	struct telemetry_region *tr;
+
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (skip_telem_region(tr, e))
+			continue;
+
+		if (tr->num_rmids < e->num_rmids)
+			return false;
+	}
+
+	return true;
+}
+
 static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	bool usable_events = false;
 
+	/* Disable feature if insufficient RMIDs */
+	if (!all_regions_have_sufficient_rmid(e, p))
+		rdt_set_feature_disabled(e->name);
+
+	/* User can override above disable from kernel command line */
+	if (!rdt_is_feature_enabled(e->name))
+		return false;
+
 	for (int i = 0; i < p->count; i++) {
 		if (skip_telem_region(&p->regions[i], e)) {
 			mark_telem_region_unusable(&p->regions[i]);
 			continue;
 		}
+
+		/*
+		 * e->num_rmids only adjusted lower if user forces an unusable
+		 * region to be usable
+		 */
+		e->num_rmids = min(e->num_rmids, p->regions[i].num_rmids);
 		usable_events = true;
 	}
 
 	if (!usable_events)
 		return false;
 
+	if (r->mon.num_rmid)
+		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmids);
+	else
+		r->mon.num_rmid = e->num_rmids;
+
 	for (int j = 0; j < e->num_events; j++)
 		resctrl_enable_mon_event(e->evts[j].id, true,
 					 e->evts[j].bin_bits, &e->evts[j]);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index bb59f4a495b8..5052ddb6a7a6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1135,7 +1135,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
-	seq_printf(seq, "%d\n", r->mon.num_rmid);
+	seq_printf(seq, "%u\n", r->mon.num_rmid);
 
 	return 0;
 }
-- 
2.51.0

