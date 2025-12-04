Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3030EF7F
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881675; cv=none; b=q1IkNyNusfG/nHJqZ20xu+QuXYRy2J6OL4IxDpbN8FhXzlQjFhmZt+yIXEA37aOHNqYco9gnbxlxXcWNciRAfs+F2VxJyctawInwqbyEWAG1KhN98jP/dI6IyWcErRhOG8skjMpVqgBCySngYaR6XPitN4tk5SPCqey3HsJbqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881675; c=relaxed/simple;
	bh=1Fiy1Jt3SNN4uJBIF4OP/XRClRrKLBBagZLLc2DJoZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6qmadkf0o53ooH61OQwAh604JBIVmQ9a1ZaN4XJkboCxtZpA8f6VG4GbZVlPdvb24HQygM2beNqulsRZKFgTYXKfn0WdtV3DtizsVV8BzYMaJPYTpQ3wtjKlO+nR5Wh7mz2tFWd4zCk6ijq7IxQM74IxBs59X8LJ1LlYIK7nwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UXzolnrX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UXzolnrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881673; x=1796417673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Fiy1Jt3SNN4uJBIF4OP/XRClRrKLBBagZLLc2DJoZg=;
  b=UXzolnrXK7029si90WhEHVxvQx9oVHjkJAFck30YXPrIfU1yBC7HAlm9
   MX+u/NKLxPkd5+aoJZOvTyVGdr+tVrNIJq7dvPapoQpr23LwCHZe7lk+m
   zfcXgKg6uHP5zKLQenyCojmQUxvUAXApXZOXzTH8nP4cwrrI7xDfiXal1
   HPyGYvc2f+9IgOzrwPioBwm7YCCuR8rBm9mw4xdDw1ExSF/Wpb2tqXE+C
   2XBy72JQWnNBtlRg1TIWaoGMwa80Ba4IjEHBRgW588xFUPn4Eu9dCATPd
   kMcFOaZfUR+dZf59MppFlWUInNXsNJkdzfcFK9FKosMKsiUcOX/9Zoy9Y
   g==;
X-CSE-ConnectionGUID: 80eMxdvvQ6WL1dhU1AqrYw==
X-CSE-MsgGUID: rNBuWP7yRzWONzc9VbM7yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511010"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511010"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:26 -0800
X-CSE-ConnectionGUID: YadT9JUOSvWmo8UHEJhICA==
X-CSE-MsgGUID: 2yAnRPGeTOOzgIAO3k8oVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752823"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:25 -0800
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
Subject: [PATCH v15 19/32] x86/resctrl: Find and enable usable telemetry events
Date: Thu,  4 Dec 2025 12:53:49 -0800
Message-ID: <20251204205404.12763-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every event group has a private copy of the data of all telemetry event
aggregators (aka "telemetry regions") tracking its feature type. Included
may be regions that have the same feature type but tracking different guid
from the event group's.

Traverse the event group's telemetry region data and mark all regions that
are not usable by the event group as unusable by clearing those regions'
MMIO addresses. A region is considered unusable if:
1) guid does not match the guid of the event group.
2) Package ID is invalid.
3) The enumerated size of the MMIO region does not match the expected
   value from the XML description file.

Hereafter any telemetry region with an MMIO address is considered valid for
the event group it is associated with.

Enable all the event group's events as long as there is at least one usable
region from where data for its events can be read. Enabling of events
can fail. Warn the user if none of the events in an event group can be enabled.

Note that it is architecturally possible that some telemetry events are
only supported by a subset of the packages in the system. It is not expected
that systems will ever do this. If they do the user will see event files in
resctrl that always return "Unavailable".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 67 ++++++++++++++++++++++++-
 fs/resctrl/monitor.c                    | 10 ++--
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b30f99335bbe..14126d228e61 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -414,7 +414,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 33b7bb180582..bc42df4498f8 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -16,9 +16,11 @@
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
+#include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include "internal.h"
@@ -111,12 +113,73 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
-/* Stub for now */
-static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+/*
+ * Clear the address field of regions that did not pass the checks in
+ * skip_telem_region() so they will not be used by intel_aet_read_event().
+ * This is safe to do because intel_pmt_get_regions_by_feature() allocates
+ * a new pmt_feature_group structure to return to each caller and only makes
+ * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
+ * returns the structure.
+ */
+static void mark_telem_region_unusable(struct telemetry_region *tr)
 {
+	tr->addr = NULL;
+}
+
+static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
+{
+	if (tr->guid != e->guid)
+		return true;
+	if (tr->plat_info.package_id >= topology_max_packages()) {
+		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
+			tr->guid);
+		return true;
+	}
+	if (tr->size != e->mmio_size) {
+		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
+			tr->size, e->guid, e->mmio_size);
+		return true;
+	}
+
 	return false;
 }
 
+static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_group *p)
+{
+	bool usable_regions = false;
+
+	for (int i = 0; i < p->count; i++) {
+		if (skip_telem_region(&p->regions[i], e)) {
+			mark_telem_region_unusable(&p->regions[i]);
+			continue;
+		}
+		usable_regions = true;
+	}
+
+	return usable_regions;
+}
+
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int skipped_events = 0;
+
+	if (!group_has_usable_regions(e, p))
+		return false;
+
+	for (int j = 0; j < e->num_events; j++) {
+		if (!resctrl_enable_mon_event(e->evts[j].id, true,
+					      e->evts[j].bin_bits, &e->evts[j]))
+			skipped_events++;
+	}
+	if (e->num_events == skipped_events) {
+		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->pfname, e->guid);
+		return false;
+	}
+
+	return skipped_events < e->num_events;
+}
+
 static enum pmt_feature_id lookup_pfid(const char *pfname)
 {
 	if (!strcmp(pfname, "energy"))
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 251dd573ed5f..83652130a8a6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -998,25 +998,27 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
 			 binary_bits > MAX_BINARY_BITS))
-		return;
+		return false;
 	if (mon_event_all[eventid].enabled) {
 		pr_warn("Duplicate enable for event %d\n", eventid);
-		return;
+		return false;
 	}
 	if (binary_bits && !mon_event_all[eventid].is_floating_point) {
 		pr_warn("Event %d may not be floating point\n", eventid);
-		return;
+		return false;
 	}
 
 	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].binary_bits = binary_bits;
 	mon_event_all[eventid].arch_priv = arch_priv;
 	mon_event_all[eventid].enabled = true;
+
+	return true;
 }
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
-- 
2.51.1

