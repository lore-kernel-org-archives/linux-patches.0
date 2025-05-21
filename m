Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6D524337D
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867872; cv=none; b=phHDJYe++W+RKcZBPaiCKQpd12YCIw7+7MNHgA026RqS0SU2bggZwkvI0r8YQvUcCbBJ6f6s2KLylpuHdhkBNAceWk6z+ZM7aWuo4995cc4HrcjcFvaYUtvQW1VPCa1kzuKGw55VxMCuigq35YdHD5NbE08JauM/bzh9aSuARxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867872; c=relaxed/simple;
	bh=cQ0nMrQ6c2gQCxZp3p2gu7oAjsNdkQuELZWDf8DPdCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArTwCXC+/4jot+xq4pqysCCEEXBofJTzIgBfhSuc5TqwYs06HPrtVNSjVLzEzMh0lDt71B63jwhJF1UiQc6p6TzmJxfgtInC+hX9he3XGFuNRc2i5LLBDURunbrsnf4yC4ZGsy6q4TT5++jXT2fx89GlPXo9b0biB+tDz83lzyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7l6cSZM; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7l6cSZM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867870; x=1779403870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cQ0nMrQ6c2gQCxZp3p2gu7oAjsNdkQuELZWDf8DPdCU=;
  b=M7l6cSZMlNdUHhZVTUsSyUGg1RZ3V67570G67tztC46TjF9/4p5Jxj4X
   w4XAVlawhNvCQ2d5IHBY7Mevr06lxexqWmqd4K5saNUdXP1VPBssRTvkt
   yw/t9GXTgjXQjs15M2d8E0P0cZI1LG1I92O2tc31uw9K8o6GWgofvGiwD
   EXsEGS50nxs/Tl1OlvaQ/PmET2dTImQOMze2vVMsShAoYy7coujM7BRpu
   yqSbg5x0rvkKUMYVmBKQNxvMjOh6t7QTkRdkoDUWjxWmOTQhsiSc+XyYL
   msoZMvuPdZATSVhwSO5c0+XLgVWuQljVX3M4Jh3Py7v3Wgue6+qSyiUWr
   Q==;
X-CSE-ConnectionGUID: CU/rfptiQv6gfIFdQVuygQ==
X-CSE-MsgGUID: UrR9EvxMRrWNinObz6aGwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677761"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677761"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: 2OrNL80PTlGdcCgCsPo8Lw==
X-CSE-MsgGUID: 9uT2xy+8QU6vS7oemHAQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352186"
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
Subject: [PATCH v5 21/29] x86/resctrl: x86/resctrl: Read core telemetry events
Date: Wed, 21 May 2025 15:50:39 -0700
Message-ID: <20250521225049.132551-22-tony.luck@intel.com>
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

The resctrl file system passes requests to read event monitor files to
the architecture resctrl_arch_rmid_read() to collect values
from hardware counters.

Use the resctrl resource to differentiate between calls to read legacy
L3 events from the new telemetry events (which are attached to
RDT_RESOURCE_PERF_PKG).

There may be multiple aggregators tracking each package, so scan all of
them and add up all counters.

At run time when a user reads an event file the file system code
provides the enum resctrl_event_id for the event.

Create a lookup table indexed by event id to provide the telem_entry
structure and the event index into MMIO space.

Enable the events marked as readable from any CPU.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  1 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  6 +++
 arch/x86/Kconfig                        |  2 +-
 4 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 2b2d4b5a4643..42da0a222c7c 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -169,5 +169,6 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index bf8e2a6126d2..be52c9302a80 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
+#include <linux/io.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -128,6 +129,16 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
 	return false;
 }
 
+/**
+ * struct evtinfo - lookup table from resctrl_event_id to useful information
+ * @event_group:	Pointer to the telem_entry structure for this event
+ * @idx:		Counter index within each per-RMID block of counters
+ */
+static struct evtinfo {
+	struct event_group	*event_group;
+	int			idx;
+} evtinfo[QOS_NUM_EVENTS];
+
 static void free_mmio_info(struct mmio_info **mmi)
 {
 	int num_pkgs = topology_max_packages();
@@ -199,6 +210,15 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 	}
 	e->pkginfo = no_free_ptr(pkginfo);
 
+	for (int i = 0; i < e->num_events; i++) {
+		enum resctrl_event_id evt;
+
+		evt = e->evts[i].evtid;
+		evtinfo[evt].event_group = e;
+		evtinfo[evt].idx = e->evts[i].evt_idx;
+		resctrl_enable_mon_event(evt, true, e->evts[i].bin_bits);
+	}
+
 	return 0;
 }
 
@@ -266,3 +286,36 @@ void __exit intel_aet_exit(void)
 		free_mmio_info((*peg)->pkginfo);
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain).
+ */
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val)
+{
+	struct evtinfo *info = &evtinfo[evtid];
+	struct mmio_info *mmi;
+	u64 evtcount;
+	int idx;
+
+	idx = rmid * info->event_group->num_events;
+	idx += info->idx;
+	mmi = info->event_group->pkginfo[domid];
+
+	if (idx * sizeof(u64) + sizeof(u64) > info->event_group->mmio_size) {
+		pr_warn_once("MMIO index %d out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < mmi->count; i++) {
+		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			return -EINVAL;
+		*val += evtcount & DATA_BITS;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 1f6dc253112f..c99aa9dacfd8 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -230,6 +230,12 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(d->hdr.id, rmid, eventid, val);
+
+	if (r->rid != RDT_RESOURCE_L3)
+		return -EIO;
+
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 	if (ret)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52cfb69c343f..24df3f04a115 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -506,7 +506,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
-- 
2.49.0

