Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AE4326D4D
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010509; cv=none; b=BtZ7bleK9e5FfOa95G3tFeQblEFlhYKXTqBGB+MY0b8oy+FouM5G27/m/KvuPro3KN02VrNYTEu88E3oVWANxypVKJXD6dCmiY+cNXB+yXdwFfO0zGzHZww4CG34jS/i4Mhe46a3Q/YLkeuvjXQwx1lzCZ88GaugZk3Z+aUFua8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010509; c=relaxed/simple;
	bh=h3Wi7QH7rdtDrArQ1z7cd2FkqfhhsltJzE5lLsizdB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7HFvAYvUmtaeku0ok2KqpVxY25vaIpPish49/td6n5rx7TcwnTZi3kJynI8zBhtoW7OLdGuLNOrdtVhDx9jfyAxe9eHAVsjDABWEgihLSjX2OaG44Bf8Ois184SI2mq2RHSVNBB5iGTnhiX6fzsNNU5yuMatyQCdEqIrC4mxHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eRAZlz+O; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eRAZlz+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010508; x=1795546508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h3Wi7QH7rdtDrArQ1z7cd2FkqfhhsltJzE5lLsizdB0=;
  b=eRAZlz+OXBUH2rKI+3BtHdoQEhS9t6dUSqAVsXgEmD3VNosnOKvo0kHZ
   3EzOXjsgEVHXCMxagf+lN7slQMkBOqGFYZm/4J1472GpRiUaWP4IRr5ld
   KlSfvM+6bK/glqZicp8Wc6ZX1Rwjq85MTJSYGuk4rDjxVfaKSnveIYecu
   OSJ6o5K3x6vPelSQ7RuqDRte9pI8YnPG1JJB/RQ8HII+DL4DIqU4hoCSM
   8jHTIUSrCjniNlFEKbtD+/KAZHPUX8lPbuXtFw0RQHTiYmOvhlv2tWdGY
   m3z+qsO+4QcXkEaNhWvM0zPBog5fAYQ3wb7oCrQ5/KdOxQm/DrLoojnNW
   A==;
X-CSE-ConnectionGUID: kYve2b00RWyTDEeIQAp7KQ==
X-CSE-MsgGUID: ykjLnd8LRjKH0rYa6SeYpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636860"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636860"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:30 -0800
X-CSE-ConnectionGUID: P0uo7BHkTPKQb/QJjCtAfQ==
X-CSE-MsgGUID: A2Z1u6jmSlCOvu8lMnDc3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225029"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:30 -0800
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
Subject: [PATCH v14 25/32] x86/resctrl: Handle number of RMIDs supported by RDT_RESOURCE_PERF_PKG
Date: Mon, 24 Nov 2025 10:54:02 -0800
Message-ID: <20251124185412.24155-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are now three meanings for "number of RMIDs":

1) The number for legacy features enumerated by CPUID leaf 0xF. This
is the maximum number of distinct values that can be loaded into
MSR_IA32_PQR_ASSOC. Note that systems with Sub-NUMA Cluster mode enabled
will force scaling down the CPUID enumerated value by the number of SNC
nodes per L3-cache.

2) The number of registers in MMIO space for each event. This is enumerated
in the XML files and is the value initialized into event_group::num_rmid.

3) The number of "hardware counters" (this isn't a strictly accurate
description of how things work, but serves as a useful analogy that
does describe the limitations) feeding to those MMIO registers. This
is enumerated in telemetry_region::num_rmids returned from the call to
intel_pmt_get_regions_by_feature()

Event groups with insufficient "hardware counters" to track all RMIDs are
difficult for users to use, since the system may reassign "hardware counters"
at any time. This means that users cannot reliably collect two consecutive
event counts to compute the rate at which events are occurring.

Limit an under-resourced event group's number of possible monitor resource
groups to the lowest number of "hardware counters" if the user explicitly
requests to enable it.

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
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 ++++++++++++++++++++++++-
 fs/resctrl/rdtgroup.c                   |  2 +-
 3 files changed, 59 insertions(+), 3 deletions(-)

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
index 50c8b4c50790..6eff606541ad 100644
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
@@ -68,6 +69,10 @@ struct pmt_event {
  * @force_on:		True when "rdt" command line overrides disable of
  *			this @guid due to insufficient @num_rmid.
  * @guid:		Unique number per XML description file.
+ * @num_rmid:		Number of RMIDs supported by this group. May be
+ *			adjusted downwards if enumeration from
+ *			intel_pmt_get_regions_by_feature() indicates fewer
+ *			RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
@@ -81,6 +86,7 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	u32				num_rmid;
 	size_t				mmio_size;
 	unsigned int			num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -97,6 +103,7 @@ static struct event_group energy_0x26696143 = {
 	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
 	.name		= "energy",
 	.guid		= 0x26696143,
+	.num_rmid	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
 	.evts		= {
@@ -113,6 +120,7 @@ static struct event_group perf_0x26557651 = {
 	.feature	= FEATURE_PER_RMID_PERF_TELEM,
 	.name		= "perf",
 	.guid		= 0x26557651,
+	.num_rmid	= 576,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
 	.evts		= {
@@ -208,8 +216,25 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
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
+		if (tr->num_rmids < e->num_rmid)
+			ret = false;
+	}
+
+	return ret;
+}
+
 static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
 	if (e->force_off)
@@ -218,13 +243,44 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	if (!group_has_usable_regions(e, p))
 		return false;
 
+	/*
+	 * Only enable feature with insufficient RMIDs if the user
+	 * requested it from the kernel command line.
+	 */
+	if (!all_regions_have_sufficient_rmid(e, p) && !e->force_on) {
+		pr_info("Feature %s:0x%x not enabled due to insufficient RMIDs\n",
+			e->name, e->guid);
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
 			skipped_events++;
 	}
 
-	return skipped_events < e->num_events;
+	if (e->num_events == skipped_events) {
+		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->name, e->guid);
+		return false;
+	}
+
+	if (r->mon.num_rmid)
+		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmid);
+	else
+		r->mon.num_rmid = e->num_rmid;
+
+	return true;
 }
 
 /*
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

