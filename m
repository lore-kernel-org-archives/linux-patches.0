Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC5A346AD1
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992132; cv=none; b=AhX5x5EQHLg1MAvFU50AoEGqmxZmUUGWWFUPlSaQvz/3edmqMDjqcl7nKA481oKfqC3WuK8EdCZUJf22zrMX/CK9VqjCLU63gG74dwpWrl9PUvLtWXCiEe7uY4cKPHhYj7I5YDLFm3Eaa17efdYDh/Y3SJ+HmNbUCMRzacoNxmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992132; c=relaxed/simple;
	bh=w/evQdJKdtQj5a5B5iiiPmNURss9kEFQa1UDiwYaNv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEx+KGCmoTf41YrCt0STrqz1GjNOizWHVclxsu7h8ItkjIwXJu3dkpUx2YEwW+xtN2LMRdvvD9CIYlZHwcuI17NsNgYe4uNs9WnHZ7MxtZMPwtiOFT0GvlU6D6fZKopl7qH9y1TMBejhWwUv7QLGy+3o3wi+E5ghCaXKImc8/6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AJCkbP9J; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AJCkbP9J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992126; x=1797528126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w/evQdJKdtQj5a5B5iiiPmNURss9kEFQa1UDiwYaNv0=;
  b=AJCkbP9JWwXI+ZA3ZpWxMSeT/OqLjmOI//Bericg9UVbRIKn/56gBb9f
   Ldh/qanQUamllvD21ZNzqhXFcCv8vLfHf6kC2bgFkBR67Lo0bSiy/9yuR
   cakJGGC05XJjsJVNNB6uEtgVtnjzo5aFuddI2OZ2CK8Le0eb2mIe0mb+Z
   u7mkjfrSp9E1AhDEtCgHZoAbvTKXQS8PJKsHmuBsMN742TA+JjME9aIRA
   rnR87Htd0UQyvd1O+V0fjn0BNwmdQjFCq6lxWCmd+8t6R9S0Ys2ubvfKc
   I+2wAHkypKNKBD8P4b2cghobM1LD7R39rpXCELGgFG19Utcv8KN6o9O8E
   w==;
X-CSE-ConnectionGUID: qK/lQWEsS4+oky65ng8pTg==
X-CSE-MsgGUID: S4bhzjV7TA2wIaaW3YEdwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594751"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594751"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:35 -0800
X-CSE-ConnectionGUID: 5o6Gkz4eQT6cM0NDlerFIQ==
X-CSE-MsgGUID: DoATwRO/Snu/GslwrU8fiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748221"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:34 -0800
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
Subject: [PATCH v17 17/32] x86,fs/resctrl: Fill in details of events for guid 0x26696143 and 0x26557651
Date: Wed, 17 Dec 2025 09:21:04 -0800
Message-ID: <20251217172121.12030-18-tony.luck@intel.com>
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

The telemetry event aggregators of the Intel Clearwater Forest CPU support
two RMID-based feature types: "energy" with guid 0x26696143 [1], and "perf"
with guid 0x26557651 [2].

The event counter offsets in an aggregator's MMIO space are arranged in
groups for each RMID.

E.g the "energy" counters for guid 0x26696143 are arranged like this:

        MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
        MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
        MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
        MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
        ...
        MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
        MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY

After all counters there are three status registers that provide indications
of how many times an aggregator was unable to process event counts, the time
stamp for the most recent loss of data, and the time stamp of the most recent
successful update.

	MMIO offset:0x2400 AGG_DATA_LOSS_COUNT
	MMIO offset:0x2408 AGG_DATA_LOSS_TIMESTAMP
	MMIO offset:0x2410 LAST_UPDATE_TIMESTAMP

Define event_group structures for both of these aggregator types and define the
events tracked by the aggregators in the file system code.

PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
format. File system code must output as floating point values.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml # [1]
Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml # [2]
---
 include/linux/resctrl_types.h           | 11 +++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 66 +++++++++++++++++++++++++
 fs/resctrl/monitor.c                    | 35 +++++++------
 3 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index acfe07860b34..a5f56faa18d2 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -50,6 +50,17 @@ enum resctrl_event_id {
 	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
 	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
 
+	/* Intel Telemetry Events */
+	PMT_EVENT_ENERGY,
+	PMT_EVENT_ACTIVITY,
+	PMT_EVENT_STALLS_LLC_HIT,
+	PMT_EVENT_C1_RES,
+	PMT_EVENT_UNHALTED_CORE_CYCLES,
+	PMT_EVENT_STALLS_LLC_MISS,
+	PMT_EVENT_AUTO_C6_RES,
+	PMT_EVENT_UNHALTED_REF_CYCLES,
+	PMT_EVENT_UOPS_RETIRED,
+
 	/* Must be the last */
 	QOS_NUM_EVENTS,
 };
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 6e0d063cfc80..c7d08eb26395 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -11,15 +11,33 @@
 
 #define pr_fmt(fmt)   "resctrl: " fmt
 
+#include <linux/compiler_types.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/resctrl.h>
+#include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/types.h>
 
 #include "internal.h"
 
+/**
+ * struct pmt_event - Telemetry event.
+ * @id:		Resctrl event id.
+ * @idx:	Counter index within each per-RMID block of counters.
+ * @bin_bits:	Zero for integer valued events, else number bits in fraction
+ *		part of fixed-point.
+ */
+struct pmt_event {
+	enum resctrl_event_id	id;
+	unsigned int		idx;
+	unsigned int		bin_bits;
+};
+
+#define EVT(_id, _idx, _bits) { .id = _id, .idx = _idx, .bin_bits = _bits }
+
 /**
  * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
  * @pfname:		PMT feature name ("energy" or "perf") of this event group.
@@ -29,14 +47,62 @@
  *			data for all telemetry regions of type @pfname.
  *			Valid if the system supports the event group,
  *			NULL otherwise.
+ * @guid:		Unique number per XML description file.
+ * @mmio_size:		Number of bytes of MMIO registers for this group.
+ * @num_events:		Number of events in this group.
+ * @evts:		Array of event descriptors.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
 	const char			*pfname;
 	struct pmt_feature_group	*pfg;
+
+	/* Remaining fields initialized from XML file. */
+	u32				guid;
+	size_t				mmio_size;
+	unsigned int			num_events;
+	struct pmt_event		evts[] __counted_by(num_events);
+};
+
+#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status) \
+		      (((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
+
+/*
+ * Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
+ */
+static struct event_group energy_0x26696143 = {
+	.pfname		= "energy",
+	.guid		= 0x26696143,
+	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
+	.num_events	= 2,
+	.evts		= {
+		EVT(PMT_EVENT_ENERGY, 0, 18),
+		EVT(PMT_EVENT_ACTIVITY, 1, 18),
+	}
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
+ */
+static struct event_group perf_0x26557651 = {
+	.pfname		= "perf",
+	.guid		= 0x26557651,
+	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
+	.num_events	= 7,
+	.evts		= {
+		EVT(PMT_EVENT_STALLS_LLC_HIT, 0, 0),
+		EVT(PMT_EVENT_C1_RES, 1, 0),
+		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 2, 0),
+		EVT(PMT_EVENT_STALLS_LLC_MISS, 3, 0),
+		EVT(PMT_EVENT_AUTO_C6_RES, 4, 0),
+		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 5, 0),
+		EVT(PMT_EVENT_UOPS_RETIRED, 6, 0),
+	}
 };
 
 static struct event_group *known_event_groups[] = {
+	&energy_0x26696143,
+	&perf_0x26557651,
 };
 
 #define for_each_event_group(_peg)						\
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 844cf6875f60..9729acacdc19 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -965,27 +965,32 @@ static void dom_data_exit(struct rdt_resource *r)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
+#define MON_EVENT(_eventid, _name, _res, _fp)	\
+	[_eventid] = {				\
+	.name			= _name,	\
+	.evtid			= _eventid,	\
+	.rid			= _res,		\
+	.is_floating_point	= _fp,		\
+}
+
 /*
  * All available events. Architecture code marks the ones that
  * are supported by a system using resctrl_enable_mon_event()
  * to set .enabled.
  */
 struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
-	[QOS_L3_OCCUP_EVENT_ID] = {
-		.name	= "llc_occupancy",
-		.evtid	= QOS_L3_OCCUP_EVENT_ID,
-		.rid	= RDT_RESOURCE_L3,
-	},
-	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
-		.name	= "mbm_total_bytes",
-		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
-		.rid	= RDT_RESOURCE_L3,
-	},
-	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
-		.name	= "mbm_local_bytes",
-		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
-		.rid	= RDT_RESOURCE_L3,
-	},
+	MON_EVENT(QOS_L3_OCCUP_EVENT_ID,		"llc_occupancy",	RDT_RESOURCE_L3,	false),
+	MON_EVENT(QOS_L3_MBM_TOTAL_EVENT_ID,		"mbm_total_bytes",	RDT_RESOURCE_L3,	false),
+	MON_EVENT(QOS_L3_MBM_LOCAL_EVENT_ID,		"mbm_local_bytes",	RDT_RESOURCE_L3,	false),
+	MON_EVENT(PMT_EVENT_ENERGY,			"core_energy",		RDT_RESOURCE_PERF_PKG,	true),
+	MON_EVENT(PMT_EVENT_ACTIVITY,			"activity",		RDT_RESOURCE_PERF_PKG,	true),
+	MON_EVENT(PMT_EVENT_STALLS_LLC_HIT,		"stalls_llc_hit",	RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_C1_RES,			"c1_res",		RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_UNHALTED_CORE_CYCLES,	"unhalted_core_cycles",	RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_STALLS_LLC_MISS,		"stalls_llc_miss",	RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_AUTO_C6_RES,		"c6_res",		RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_UNHALTED_REF_CYCLES,	"unhalted_ref_cycles",	RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
 void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits)
-- 
2.52.0

