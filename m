Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CB233F8BD
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992148; cv=none; b=fzCQfB5xOABBsyHRstX8ZEukgaXp3RFdKPPk1ywQAB3OG50JEM7zdQa3kwPGepHdZnsk60xEwO+zdTR6ciNXqWY8dCaTAHBPdAzl2EQ2OK5sJxP1zw+2cPP57uWe/VaSLVdB45zaFxbBsTFDaNdkA+DYROlwRNJNzehu3wEg+b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992148; c=relaxed/simple;
	bh=1jxoi05cH1HHif+sAFabHeszfFDP1r7UGa7EBuh2HpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKOh30jRU85RpS0MAUySZPgBM8uC9WcLI2NgUEh5mTgFZw00BIJjILlR7gzRoMcZB+oJOnSG1PBzJaDZz3pdZ34L7MfD6DsjTBcTlGuRF4mOo/+E4quGCCqf71469OC1xqyVLS4By/vaAU50eOcehMnOXkfTt0NOPF0+MjIWnWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/OtwZoS; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/OtwZoS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992141; x=1797528141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1jxoi05cH1HHif+sAFabHeszfFDP1r7UGa7EBuh2HpQ=;
  b=B/OtwZoStuh/SSuDjxGjeG5d+h74tinOu3hsWPyvQpwaFf5gN0lMFtZu
   mpxtfPdVeyxCorTi9L22Jn9qnI2uLdFLfZPUjAceDY+3dJXhgQRWC5qCB
   Kr7UbqU1sbi/2Mop5/IyuxbZ4O5bJ7nXJMLVZfKz9eg6Du6v744O6hFv8
   CjGU/+R1uQ54Vshm0gPnXq+/9WHLK5HWrm6sHJfjZC+2Li57mFFR76WJM
   lLWxAXWE7uC8OtXwvv1C9JPhaGTWeKn5BJkEkmKlTR+uYVMLCo3c1RVgW
   QJ/x05LN2Oh8vea1smqi75A12McLtb6eXAAW8JFyrcxFThtOia35jB1qf
   w==;
X-CSE-ConnectionGUID: SVLyJyJxSJe6DpcA3Znqrg==
X-CSE-MsgGUID: t0/DjJFjQB6QcBODPinDwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594823"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594823"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:37 -0800
X-CSE-ConnectionGUID: lK+rs5jwQDOvOuguH8y37w==
X-CSE-MsgGUID: KlgALe3HRc2aKkUl137CaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748251"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:35 -0800
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
Subject: [PATCH v17 25/32] x86/resctrl: Handle number of RMIDs supported by RDT_RESOURCE_PERF_PKG
Date: Wed, 17 Dec 2025 09:21:12 -0800
Message-ID: <20251217172121.12030-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 ++++++++++++++++++++++++-
 fs/resctrl/rdtgroup.c                   |  2 +-
 3 files changed, 54 insertions(+), 3 deletions(-)

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
index df91e1ea4a7b..e50c04afc8eb 100644
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
@@ -202,6 +210,23 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
 	return usable_regions;
 }
 
+static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
+{
+	struct telemetry_region *tr;
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
+	return true;
+}
+
 static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
@@ -213,6 +238,27 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
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
@@ -223,6 +269,11 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
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
2.52.0

