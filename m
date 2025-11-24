Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9BA324B2D
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010504; cv=none; b=BMLg0355BRLOy6CFDhYfPoj4bxiwu7FGmfBM7M/C9De+dT4m8HMeBiqQT40nQ449RzJa/1lwzyxI4D1CeXHHyeVzNUKMWnXG0zimGvAbycX7iMyMTmjnAm0apFFJsRQi9tBz6Z2n1jz5otpL/WurZWNVI3y3lB7QILsoNANIG18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010504; c=relaxed/simple;
	bh=1/7YjHVOswPHiSd8P5BTn0s80BzXAbC++aIrzSo0rdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9e58EgpF5X8ig05eGx2y9NYvQssgUJ/IrAR4ZtHz0KM38KPtLyG2i4fy9QzAVm6/Q4ush24hzJ4aYj2zDp++buN6kQGJbWx/Fv8Gvb53QMWRGzNGtVwkkCFw9f0Livs1B+H/JNANZg/kpW/RzjpTRS801cK7GZEYKKDiGeT0yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFADguZy; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFADguZy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010503; x=1795546503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1/7YjHVOswPHiSd8P5BTn0s80BzXAbC++aIrzSo0rdg=;
  b=kFADguZyXQiMmDvRuw3dDce8c3v8QdzHRIC4WtF8+raC4yio5w+ZwQqJ
   PUMFtyL2M7Fqf0I2QjbXyZzyI2iy0Iks43FUX0EtzLPpcW8PfMqPTTwnL
   /sgJC+gYmg7JnjrKgJK9DMNOgO3qbDlxmv8rWlSijcutMFQCRaFhP5OVg
   Z4r1El9/Qgy56P6gvSg4liVI9NSqU+Ds31l7qQ4++d285BnR2A4lL1Nvu
   isE3yzABx43yN0zh8un1gfyi/GzN+gq1ShcjxGQ26X1uFilyPa64bGHwe
   qBbhkvYU/SlWTeLz/GGWUcq33q2xRwcolRZBV3GrD/02F5FcMzUyQLJr+
   A==;
X-CSE-ConnectionGUID: +YPKL5kWQU61VISw5jGFCg==
X-CSE-MsgGUID: bDuYIEpfRfmjBdK12KDgXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636755"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636755"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:28 -0800
X-CSE-ConnectionGUID: 9zqU/LEfSzSb94AtyEst5g==
X-CSE-MsgGUID: 2CVvVsE3TLyeTG3ALRI5AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225008"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:28 -0800
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
Subject: [PATCH v14 19/32] x86/resctrl: Find and enable usable telemetry events
Date: Mon, 24 Nov 2025 10:53:56 -0800
Message-ID: <20251124185412.24155-20-tony.luck@intel.com>
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
region from where data for its events can be read.

Note that it is architecturally possible that some telemetry events are
only supported by a subset of the packages in the system. It is not expected
that systems will ever do this. If they do the user will see event files in
resctrl that always return "Unavailable".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 62 ++++++++++++++++++++++++-
 fs/resctrl/monitor.c                    | 10 ++--
 3 files changed, 67 insertions(+), 7 deletions(-)

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
index bb080bdde190..b6b50650e634 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -20,9 +20,11 @@
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/overflow.h>
+#include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include "internal.h"
@@ -117,12 +119,68 @@ static struct event_group *known_event_groups[] = {
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
+
+	return skipped_events < e->num_events;
+}
+
 /*
  * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
  * pmt_feature_group for each known feature. If there is one, the returned
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 4ef91fc09070..338a122dfcff 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -990,25 +990,27 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
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

