Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9100A30C61C
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408522; cv=none; b=hdtyyILiRRdlTgjZT09JMX2jAeeaDxEXTsyO7TVtKqQQWLoLiC6Sb+CoGq05OnPoF6oF3RzXohBGpjEuq4KsU5sI+d14chUn30Ja/vXWxhtG8kM+atKZc48qSs5ewdorKTsyxaTHGnRI97FbEsXNDvpl5JoH5LgVsheCHRjvOH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408522; c=relaxed/simple;
	bh=jjJ9ZaQxJEbd5BORfDSxYTGzjlSKcmV3qib0G1ee5ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2eP0wfX4w8k3BwElyLFi4Ah2IVSxmjLEXbePHksbO6QxKQqT7/IQu1TGmtSIcla6jSA9HEw46KJ920k2aHzS6j2bPhqj3h8DRHttm2lRLuNWBIUsnWIXagOFkSb2ZNpgEWm83I4XZeIwL5RWnbpTjnUBbvxUtCA8lef1KqXDI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTaY5fqC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTaY5fqC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408516; x=1796944516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jjJ9ZaQxJEbd5BORfDSxYTGzjlSKcmV3qib0G1ee5ac=;
  b=DTaY5fqC8QgLNXAh73PSrNxiMVyWfARVIVloQ155iKYxK2l/6XTD3RyM
   E6C/ALJJpjSmrzua/DFBja+BjFGgKgETaw3m8NvrGVGe+QJt9EbMSh0ds
   H6kyHIBoRuDgb6xesDO99C3ViNCofKVolqILB1mGlrME/Mamxf1BVmU1E
   wMQ1y0ybkUvxRV2XRgEATn5EIq/6QkbXjm1zSHDmP8yFi6/mulreOgBS2
   S73DLKJG3A17avh18G1fy5eVEcvlWciZAZjVR6TagVmG/GyEM4TO2m1Jz
   RZ+wiwBS+rKO7cTHdSpS0S8UvvZ3Z46ya6XEnT+KhKdjG1wn28XEy06hc
   g==;
X-CSE-ConnectionGUID: 6BPNOg6mR5Oml7tLSJKXxg==
X-CSE-MsgGUID: AcsOV4eUTVWlHsSRDb9ucA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973682"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973682"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:41 -0800
X-CSE-ConnectionGUID: l6pVkQXIQkGHn0ydlBbjSQ==
X-CSE-MsgGUID: 8uUReQNURfCY9+Sl1NyBKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297134"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:40 -0800
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
Subject: [PATCH v16 25/32] x86/resctrl: Handle number of RMIDs supported by RDT_RESOURCE_PERF_PKG
Date: Wed, 10 Dec 2025 15:14:04 -0800
Message-ID: <20251210231413.59102-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are now three meanings for "number of RMIDs":

1) The number for legacy features enumerated by CPUID leaf 0xF. This is the
maximum number of distinct values that can be loaded into MSR_IA32_PQR_ASSOC.
Note that systems with Sub-NUMA Cluster mode enabled will force scaling down
the CPUID enumerated value by the number of SNC nodes per L3-cache.

2) The number of registers in MMIO space for each event. This is enumerated
in the XML files and is the value initialized into event_group::num_rmid.

3) The number of "hardware counters" (this isn't a strictly accurate
description of how things work, but serves as a useful analogy that does
describe the limitations) feeding to those MMIO registers. This is enumerated
in telemetry_region::num_rmids returned by intel_pmt_get_regions_by_feature()

Event groups with insufficient "hardware counters" to track all RMIDs are
difficult for users to use, since the system may reassign "hardware counters"
at any time. This means that users cannot reliably collect two consecutive
event counts to compute the rate at which events are occurring. Disable
such event groups by default. The user may override this with a command line
"rdt=" option. In this case limit an under-resourced event group's number of
possible monitor resource groups to the lowest number of "hardware counters".

Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG resource
"num_rmid" value to the smallest of these values as this value will be used
later to compare against the number of RMIDs supported by other resources
to determine how many monitoring resource groups are supported.

N.B. Change type of resctrl_mon::num_rmid to u32 to match its usage and
the type of event_group::num_rmid so that min(r->num_rmid, e->num_rmid)
won't complain about mixing signed and unsigned types.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 54 ++++++++++++++++++++++++-
 fs/resctrl/rdtgroup.c                   |  2 +-
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 14126d228e61..8623e450619a 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -295,7 +295,7 @@ enum resctrl_schema_fmt {
  *			events of monitor groups created via mkdir.
  */
 struct resctrl_mon {
-	int			num_rmid;
+	u32			num_rmid;
 	unsigned int		mbm_cfg_mask;
 	int			num_mbm_cntrs;
 	bool			mbm_cntr_assignable;
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index df91e1ea4a7b..34f882df1243 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -22,6 +22,7 @@
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
+#include <linux/minmax.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -60,10 +61,14 @@ struct pmt_event {
  *			Valid if the system supports the event group,
  *			NULL otherwise.
  * @force_off:		True when "rdt" command line or architecture code disables
- *			this event group.
+ *			this event group due to insufficient RMIDs.
  * @force_on:		True when "rdt" command line overrides disable of this
  *			event group.
  * @guid:		Unique number per XML description file.
+ * @num_rmid:		Number of RMIDs supported by this group. May be
+ *			adjusted downwards if enumeration from
+ *			intel_pmt_get_regions_by_feature() indicates fewer
+ *			RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
@@ -76,6 +81,7 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	u32				num_rmid;
 	size_t				mmio_size;
 	unsigned int			num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -90,6 +96,7 @@ struct event_group {
 static struct event_group energy_0x26696143 = {
 	.pfname		= "energy",
 	.guid		= 0x26696143,
+	.num_rmid	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
 	.evts		= {
@@ -104,6 +111,7 @@ static struct event_group energy_0x26696143 = {
 static struct event_group perf_0x26557651 = {
 	.pfname		= "perf",
 	.guid		= 0x26557651,
+	.num_rmid	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
 	.evts		= {
@@ -202,6 +210,24 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
 	return usable_regions;
 }
 
+static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
+{
+	struct telemetry_region *tr;
+	bool ret = true;
+
+	for (int i = 0; i < p->count; i++) {
+		if (!p->regions[i].addr)
+			continue;
+		tr = &p->regions[i];
+		if (tr->num_rmids < e->num_rmid) {
+			e->force_off = true;
+			return false;
+		}
+	}
+
+	return ret;
+}
+
 static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
@@ -213,6 +239,27 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	if (!group_has_usable_regions(e, p))
 		return false;
 
+	/*
+	 * Only enable event group with insufficient RMIDs if the user requested
+	 * it from the kernel command line.
+	 */
+	if (!all_regions_have_sufficient_rmid(e, p) && !e->force_on) {
+		pr_info("%s %s:0x%x monitoring not enabled due to insufficient RMIDs\n",
+			r->name, e->pfname, e->guid);
+		return false;
+	}
+
+	for (int i = 0; i < p->count; i++) {
+		if (!p->regions[i].addr)
+			continue;
+		/*
+		 * e->num_rmid only adjusted lower if user (via rdt= kernel
+		 * parameter) forces an event group with insufficient RMID
+		 * to be enabled.
+		 */
+		e->num_rmid = min(e->num_rmid, p->regions[i].num_rmids);
+	}
+
 	for (int j = 0; j < e->num_events; j++) {
 		if (!resctrl_enable_mon_event(e->evts[j].id, true,
 					      e->evts[j].bin_bits, &e->evts[j]))
@@ -223,6 +270,11 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 		return false;
 	}
 
+	if (r->mon.num_rmid)
+		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmid);
+	else
+		r->mon.num_rmid = e->num_rmid;
+
 	return true;
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ac3c6e44b7c5..60ce2390723e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1157,7 +1157,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
-	seq_printf(seq, "%d\n", r->mon.num_rmid);
+	seq_printf(seq, "%u\n", r->mon.num_rmid);
 
 	return 0;
 }
-- 
2.51.1

