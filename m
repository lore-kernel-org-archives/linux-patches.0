Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F07321F3B
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830657; cv=none; b=F2De/WlVVUl9sW5LQOy4LfAUHHIxl3LEKja6eMAVxJUfpMwNVSNqXCPJkXnWQZxhmlyiNsVEOa6/k+8ak1ZDZVJvu/jpDcumbvn1BpJpiypywZ/wiiej3/2Cur0qi9nfOvciMnspdQcZ+h7aGN5QXs43+nsDfk4ANZLfOaK8BwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830657; c=relaxed/simple;
	bh=fO4d2GWjJNklhnEan/lOkw7j2X8R9b5sXAboQ9tOI0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di3pxstUhPgqcL5/L6aiCSYTP+u0PlFTbecD2uuwVaAjj2RWWjcvLCclL7yCFHfcs82N/Kd60kOyJcvqxBRMbhx7dg40oIGfDuwrluBhCx7foFRwqLPtwNLNWhoa9N7GpNwSwuDeFOMMfT7FGXCqTVJfpVtFmiFv6oYk6i4fy5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mwp9p1dt; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mwp9p1dt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830656; x=1790366656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fO4d2GWjJNklhnEan/lOkw7j2X8R9b5sXAboQ9tOI0A=;
  b=mwp9p1dtBfE/wpACFxuIB5vF+AREv4xcqBv6Wq2cKOsTQ4Gd5bKjP4SH
   lwMu6h6Dhz/H5K2B9wQSqYoP6vDhE04/Dr8CI+FRjyHii6Q4g0FCxnJGe
   PTFh0BSTBfhfL68aE9NnDAyP5o8/W0B62Chg2SO9CJRT4DW3t/hLxtFb/
   m7J2GrPc4T5aDi6xXUqHXdvbW3ZDDiA/SI1R3G5naCMPrlGnK5GLUqUvm
   m1GSPjWB9Pan1snZTV6+gSVBicqeL/3+YC9BVhKjAvD0P0Qs5PLgrDBwM
   EDSUdm/IYAwFwmAoQZ+s9VLrJSN7MwWNGRENAjOxtucHq7J2HmSOER0e5
   A==;
X-CSE-ConnectionGUID: FXFd2ASxTwGakMicDRiVkQ==
X-CSE-MsgGUID: raujxFs0QFmVcIsg4Cug4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074256"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074256"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:10 -0700
X-CSE-ConnectionGUID: dShZAYevRpS6yg316E0VWQ==
X-CSE-MsgGUID: 8rDLNdkySkyVCnkEFsqIYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003651"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:09 -0700
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
Subject: [PATCH v11 15/31] x86,fs/resctrl: Fill in details of events for guid 0x26696143 and 0x26557651
Date: Thu, 25 Sep 2025 13:03:09 -0700
Message-ID: <20250925200328.64155-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Intel Clearwater Forest CPU supports two RMID-based PMT feature
groups documented in the xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
and xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml files in the Intel PMT
GIT repository [1].

The counter offsets in MMIO space are arranged in groups for each RMID.

E.g the "energy" counters for guid 0x26696143 are arranged like this:

        MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
        MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
        MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
        MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
        ...
        MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
        MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY

After all counters there are three status registers that provide
indications of how many times an aggregator was unable to process
event counts, the time stamp for the most recent loss of data, and
the time stamp of the most recent successful update.

	MMIO offset:0x2400 AGG_DATA_LOSS_COUNT
	MMIO offset:0x2408 AGG_DATA_LOSS_TIMESTAMP
	MMIO offset:0x2410 LAST_UPDATE_TIMESTAMP

Define these events in the file system code and add the events
to the event_group structures.

PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
format. File system code must output as floating point values.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://github.com/intel/Intel-PMT # [1]
---
 include/linux/resctrl_types.h           | 11 +++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 43 +++++++++++++++++++++++++
 fs/resctrl/monitor.c                    | 35 +++++++++++---------
 3 files changed, 74 insertions(+), 15 deletions(-)

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
index 966c840f0d6b..f9b5f6cd08f8 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/array_size.h>
 #include <linux/cleanup.h>
+#include <linux/compiler_types.h>
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -20,11 +21,27 @@
 #include <linux/intel_vsec.h>
 #include <linux/overflow.h>
 #include <linux/resctrl.h>
+#include <linux/resctrl_types.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 
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
  * struct event_group - All information about a group of telemetry events.
  * @pfg:		Points to the aggregated telemetry space information
@@ -34,6 +51,9 @@
  *			Valid if the system supports the event group.
  *			NULL otherwise.
  * @guid:		Unique number per XML description file.
+ * @mmio_size:		Number of bytes of MMIO registers for this group.
+ * @num_events:		Number of events in this group.
+ * @evts:		Array of event descriptors.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
@@ -41,14 +61,26 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	size_t				mmio_size;
+	unsigned int			num_events;
+	struct pmt_event		evts[] __counted_by(num_events);
 };
 
+#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status) \
+		      (((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
+
 /*
  * Link: https://github.com/intel/Intel-PMT
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
+	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
+	.num_events	= 2,
+	.evts		= {
+		EVT(PMT_EVENT_ENERGY, 0, 18),
+		EVT(PMT_EVENT_ACTIVITY, 1, 18),
+	}
 };
 
 /*
@@ -57,6 +89,17 @@ static struct event_group energy_0x26696143 = {
  */
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
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
 
 static struct event_group *known_energy_event_groups[] = {
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index e354f01df615..d44b764853bf 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -954,27 +954,32 @@ static void dom_data_exit(struct rdt_resource *r)
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
2.51.0

