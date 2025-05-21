Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCAD24467C
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867872; cv=none; b=ObivxqqsDjMTFrIZyaNQmi+76FE/GLGmyOHq1PwGuN+GftxXlmoxjTjywVCs4SDMdEhB/w5KLLeXnKuGt0M2cDgpE1UrnCSE01McfiriogZHTQBZwhqlkm5yDBx47Bu+mhFfKun9Dg1sFpxrejTOl301V2VxUILeypNHXKgWgYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867872; c=relaxed/simple;
	bh=HdxDZ5f2ywmXFv5AWkW81eQVoVUNGgR0kjdBK51/DYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zm5JeXVQ1ADS+gTeHR/SiqymYMN/1OkhxW7mk9fhzpa+BBlaSyr9jZnocNZBo6F23jFUe76YDFjHDzR1klk9f7ilKwYkhqGgwcDOAdgMq5iaQ0PzGwCpurIap7FEhJltIch8/dDSLSRyTHeo/xkWKiYrC0g+U7oE/neBopEHMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FTW9TqKl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FTW9TqKl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867870; x=1779403870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HdxDZ5f2ywmXFv5AWkW81eQVoVUNGgR0kjdBK51/DYI=;
  b=FTW9TqKlNM+NmFLTxGDtvK/Yg+glRoQCaF8sUS/2mIa5AXAwsgCKS7lv
   lLRT+Dg6Ath2xnxrOJQPcYIoP1gHTvHLLBI1qkaTbH9pSmguin8rQEixt
   FHocpF1YuRWsoNm/Up9kmN6ZH9mFME+bLMITYGB3WAJYcZhnAa/+lGx+T
   ai01oAn175u7SEgeaLX7Bv6JNDWD01rz4xpuHvukFQO+hpjxvv1dijkpn
   zL5TStEtOQc9jfrxK0glHyAJ3Z0AQedgpOn8PsGVDy75ZTyfdAMgMCvqS
   D/Fiv4LmEjEtamLESGbRkyQD8u8VzueZz+p6ISnXefSyEXcRSXJVM8i+B
   g==;
X-CSE-ConnectionGUID: xKEgrWOlTx+KFvj2qpsOUw==
X-CSE-MsgGUID: JJIDuTGrTO668jdRzwCsDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677760"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677760"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: uITqucr5Rau9AKYUs98qjQ==
X-CSE-MsgGUID: cmvKq3H6Q5mJu67fFhVRhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352183"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
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
Subject: [PATCH v5 20/29] x86,fs/resctrl: Fill in details of Clearwater Forest events
Date: Wed, 21 May 2025 15:50:38 -0700
Message-ID: <20250521225049.132551-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
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
 include/linux/resctrl_types.h           | 11 ++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 33 ++++++++++++++++++
 fs/resctrl/monitor.c                    | 45 +++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index b468bfbab9ea..455b29a0a9b9 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -43,6 +43,17 @@ enum resctrl_event_id {
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
index 2316198eb69e..bf8e2a6126d2 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -34,6 +34,20 @@ struct mmio_info {
 	void __iomem	*addrs[] __counted_by(count);
 };
 
+/**
+ * struct pmt_event - Telemetry event.
+ * @evtid:	Resctrl event id
+ * @evt_idx:	Counter index within each per-RMID block of counters
+ * @bin_bits:	Zero for integer valued events, else number bits in fixed-point
+ */
+struct pmt_event {
+	enum resctrl_event_id	evtid;
+	int			evt_idx;
+	int			bin_bits;
+};
+
+#define EVT(id, idx, bits) { .evtid = id, .evt_idx = idx, .bin_bits = bits }
+
 /**
  * struct event_group - All information about a group of telemetry events.
  * @pfg:		Points to the aggregated telemetry space information
@@ -42,6 +56,8 @@ struct mmio_info {
  * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
+ * @num_events:		Number of events in this group.
+ * @evts:		Array of event descriptors.
  */
 struct event_group {
 	/* Data fields used by this code. */
@@ -51,6 +67,8 @@ struct event_group {
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
 	size_t				mmio_size;
+	int				num_events;
+	struct pmt_event		evts[] __counted_by(num_events);
 };
 
 /*
@@ -60,6 +78,11 @@ struct event_group {
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
 	.mmio_size	= (576 * 2 + 3) * 8,
+	.num_events	= 2,
+	.evts				= {
+		EVT(PMT_EVENT_ENERGY, 0, 18),
+		EVT(PMT_EVENT_ACTIVITY, 1, 18),
+	}
 };
 
 /*
@@ -69,6 +92,16 @@ static struct event_group energy_0x26696143 = {
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
 	.mmio_size	= (576 * 7 + 3) * 8,
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
index f554d7933739..f24a568f7b67 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -876,6 +876,51 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
 		.rid	= RDT_RESOURCE_L3,
 	},
+	[PMT_EVENT_ENERGY] = {
+		.name		= "core_energy",
+		.evtid		= PMT_EVENT_ENERGY,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_ACTIVITY] = {
+		.name		= "activity",
+		.evtid		= PMT_EVENT_ACTIVITY,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_STALLS_LLC_HIT] = {
+		.name		= "stalls_llc_hit",
+		.evtid		= PMT_EVENT_STALLS_LLC_HIT,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_C1_RES] = {
+		.name		= "c1_res",
+		.evtid		= PMT_EVENT_C1_RES,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_UNHALTED_CORE_CYCLES] = {
+		.name		= "unhalted_core_cycles",
+		.evtid		= PMT_EVENT_UNHALTED_CORE_CYCLES,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_STALLS_LLC_MISS] = {
+		.name		= "stalls_llc_miss",
+		.evtid		= PMT_EVENT_STALLS_LLC_MISS,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_AUTO_C6_RES] = {
+		.name		= "c6_res",
+		.evtid		= PMT_EVENT_AUTO_C6_RES,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_UNHALTED_REF_CYCLES] = {
+		.name		= "unhalted_ref_cycles",
+		.evtid		= PMT_EVENT_UNHALTED_REF_CYCLES,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_UOPS_RETIRED] = {
+		.name		= "uops_retired",
+		.evtid		= PMT_EVENT_UOPS_RETIRED,
+		.rid		= RDT_RESOURCE_PERF_PKG,
+	},
 };
 
 void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu, u32 binary_bits)
-- 
2.49.0

