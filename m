Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ECF2EFDB2
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956607; cv=none; b=JhAKcfDFa42/iYbS8TPN55NeLsqSC10v9Ovh4qPvSJ5EtjHIGy1iYOXvINlhQZfGoyML5M5E/LuNWOiXdPUCIL6m36IiNhzaux0H29tqfvwmHr04+Zxg5MuouT9cmRaZqdl9i4pIcEmcW8nH4qRdgVWK5yRewK6kzQGfUbGmkeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956607; c=relaxed/simple;
	bh=4xr2U3sYnm63ho2dRJ6aqdktQ8/1P/BpGhAPyv7nEJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaxGI8/QG4BNYpN579cTAYD3pTXpzAB431lwGQv9745mkWNAcN849v9ICnQk7ijVJBvyP452HDYgiUR+w5K89GriodXcaOfm1ojvH5LmmBF14M0wN7oX4DxGQpzFWNeSDd+amDfDJwpt9G9sK18+660OszSqnnxEKLvOdUiuzvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R3UENJD3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3UENJD3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956606; x=1782492606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4xr2U3sYnm63ho2dRJ6aqdktQ8/1P/BpGhAPyv7nEJs=;
  b=R3UENJD3LIQ+IevJCyTbGpYiCgz3P9RVy+gJmqnpskInCaGK+PzIyHrc
   qouE5qgzuBLGmBAhxm0++aclY7sLXVwPpgq6+A7XSYsyqzNZqe2DvXecP
   9QNx14gXkooqRpqL97t99Tsctz3OCQWAhr8ZdyQrBDow6xeMZkCl/pPgf
   FtrracWMKkZvES4bOMtLBcsbim9gH4Q0+alOExpD/Jg8epMj7xEutqZHu
   alvFScfKtevr7uTkzxD0vT19noci4cD/DFwe/lUGl1EIygdt1mFp33wDW
   wL4RDnc9QvNjaBxfJvC7sD23H2grCO2lCjg1xqmtjXBV0ZysdD2z77PTG
   Q==;
X-CSE-ConnectionGUID: AGDkb/jbRaKib3lgMXzQZw==
X-CSE-MsgGUID: Yme3Y7h/SGiCOIQiJYYSZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136479"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136479"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:00 -0700
X-CSE-ConnectionGUID: x+DAiFY5T02d+ZujbYyuSQ==
X-CSE-MsgGUID: JdOieTUpRBSkFBpIl+4wiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069268"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:59 -0700
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
Subject: [PATCH v6 20/30] x86,fs/resctrl: Fill in details of Clearwater Forest events
Date: Thu, 26 Jun 2025 09:49:29 -0700
Message-ID: <20250626164941.106341-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clearwater Forest supports two energy related telemetry events
and seven perf style events. The counters are arranged in per-RMID
blocks like this:

	MMIO offset:0x00 Counter for RMID 0 Event 0
	MMIO offset:0x08 Counter for RMID 0 Event 1
	MMIO offset:0x10 Counter for RMID 0 Event 2
	MMIO offset:0x18 Counter for RMID 1 Event 0
	MMIO offset:0x20 Counter for RMID 1 Event 1
	MMIO offset:0x28 Counter for RMID 1 Event 2
	...

Define these events in the file system code and add the events
to the event_group structures.

PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
format. File system code must output as floating point values.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl_types.h           | 11 ++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 33 +++++++++++++++++++++++
 fs/resctrl/monitor.c                    | 35 ++++++++++++++-----------
 3 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index d98351663c2c..6838b02d5ca3 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -47,6 +47,17 @@ enum resctrl_event_id {
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
index c770039b2525..f9b2959693a0 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -32,6 +32,20 @@ struct mmio_info {
 	void __iomem	*addrs[] __counted_by(num_regions);
 };
 
+/**
+ * struct pmt_event - Telemetry event.
+ * @id:		Resctrl event id.
+ * @idx:	Counter index within each per-RMID block of counters.
+ * @bin_bits:	Zero for integer valued events, else number bits in fixed-point.
+ */
+struct pmt_event {
+	enum resctrl_event_id	id;
+	int			idx;
+	int			bin_bits;
+};
+
+#define EVT(_id, _idx, _bits) { .id = _id, .idx = _idx, .bin_bits = _bits }
+
 /**
  * struct event_group - All information about a group of telemetry events.
  * @pfg:		Points to the aggregated telemetry space information
@@ -40,6 +54,8 @@ struct mmio_info {
  * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
+ * @num_events:		Number of events in this group.
+ * @evts:		Array of event descriptors.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
@@ -49,6 +65,8 @@ struct event_group {
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
 	size_t				mmio_size;
+	int				num_events;
+	struct pmt_event		evts[] __counted_by(num_events);
 };
 
 #define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status)	\
@@ -61,6 +79,11 @@ struct event_group {
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
+	.num_events	= 2,
+	.evts				= {
+		EVT(PMT_EVENT_ENERGY, 0, 18),
+		EVT(PMT_EVENT_ACTIVITY, 1, 18),
+	}
 };
 
 /*
@@ -70,6 +93,16 @@ static struct event_group energy_0x26696143 = {
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
+	.num_events	= 7,
+	.evts				= {
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
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 076c0cc6e53a..cff8af3a263e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -874,27 +874,32 @@ static void dom_data_exit(struct rdt_resource *r)
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
 
 void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits)
-- 
2.49.0

