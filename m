Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB9623E324
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278049; cv=none; b=QiRwTItFqe86XY7OkGxLJwITlSTcL2P6t30duv7wJBfXTgfRC2dEVtn8yG2dhG5rkpON/FoGKCU/MdhZ1G2EXuVOKsDkiv8cisNWKPiCA7celSUNZLnlrWkhzq06IjkvhrFNCkPqDT9NLznet7yd+n4Va6b3Iw2co90P6ryskCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278049; c=relaxed/simple;
	bh=XU2pP6ae/cniapa1Sz2PaiM0UHpWKJ2gkO0D9MEcsng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckX0uh6gNBFqDDmXHlkIAS9D+9b91wCouDukkzeNm22he0oLwDvuFhKcvFafSAQPViq2S3r3vEO6rIEl5vGJKXJ+H6YoiAEy9tLmgko3M2K6SUNsQ5eh17b/dT5eqRQzsFahZVk+aWL+1/MBOYYQyGN+XdtB2bFxIu+0AAtV2xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XbHViIue; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XbHViIue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278047; x=1783814047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XU2pP6ae/cniapa1Sz2PaiM0UHpWKJ2gkO0D9MEcsng=;
  b=XbHViIueOBB3VeNbIn5zliog+dqT5lfeugig6IY5/WSW8h+y+Z1A4oNn
   4jfIBtaMLxMu9ftGRuFy/3qUOAYkiY6RlEmSdHghluBngIQKAX0nNoE9w
   cLQ+EBV/Rkie+W4kMWN8zoqcMEf4ASGV+RRbOQM1zJNAhhNsu/dVhj4t7
   TA0fguyxcLuazKfXWPzl4xl2+L4w1Q9nDpIt/fX1kjKOCf/feu6+qfNcg
   GterpffNWCEtncuJz79oG3LxxfU6x0Qh/YI7qtOLfcuZf43Q/Y+ycES2s
   L4rvBnlyLdf+weNeqws6vYn/xXimEcvczcegEJLbcWZsHhThINGYybRz+
   w==;
X-CSE-ConnectionGUID: 15dEXIpWTeCG6LmAtByWJg==
X-CSE-MsgGUID: J5iuY7BWTImCrkbGvDfhBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292750"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292750"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:03 -0700
X-CSE-ConnectionGUID: 1bP0pyA4Qk+7iLgnU3Q6Gw==
X-CSE-MsgGUID: Zc0DmJRHRX69I64m9D6HVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902154"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:04 -0700
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
Subject: [PATCH v7 22/31] x86/resctrl: Read telemetry events
Date: Fri, 11 Jul 2025 16:53:29 -0700
Message-ID: <20250711235341.113933-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
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

Enable the events marked as readable from any CPU providing an
mon_evt::arch_priv pointer to the struct pmt_event for each
event.

At run time when a user reads an event file the file system code
provides the enum resctrl_event_id for the event and the arch_priv
pointer that was supplied when the event was enabled.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  7 ++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 46 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
 arch/x86/Kconfig                        |  2 +-
 4 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 36a2072c19c7..0081fb5a4420 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -172,9 +172,16 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 #ifdef CONFIG_X86_RESCTRL_CPU_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+			 void *arch_priv, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+				       void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index f4bf0f2ccf26..bd6011a95d12 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -14,6 +14,7 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -213,6 +214,13 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 
 	list_add(&e->list, &active_event_groups);
 
+	for (int i = 0; i < e->num_events; i++) {
+		enum resctrl_event_id eventid;
+
+		eventid = e->evts[i].id;
+		resctrl_enable_mon_event(eventid, true, e->evts[i].bin_bits, &e->evts[i]);
+	}
+
 	return 0;
 }
 
@@ -279,3 +287,41 @@ void __exit intel_aet_exit(void)
 		list_del(&evg->list);
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
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
+			 void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct pkg_mmio_info *mmi;
+	struct event_group *e;
+	u64 evtcount;
+	void *pevt0;
+	int idx;
+
+	pevt0 = pevt - pevt->idx;
+	e = container_of(pevt0, struct event_group, evts);
+	idx = rmid * e->num_events;
+	idx += pevt->idx;
+	mmi = e->pkginfo[domid];
+
+	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
+		pr_warn_once("MMIO index %d out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < mmi->num_regions; i++) {
+		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			return -EINVAL;
+		*val += evtcount & DATA_BITS;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 185b203f6321..51d7d99336c6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -232,6 +232,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
+
 	if (r->rid != RDT_RESOURCE_L3)
 		return -EINVAL;
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 21c2d1022b15..512286ef6d71 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -530,7 +530,7 @@ config X86_CPU_RESCTRL
 
 config X86_RESCTRL_CPU_INTEL_AET
 	bool "Intel Application Energy Telemetry" if INTEL_PMT_DISCOVERY=y
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL
 	help
 	  Enable per-RMID telemetry events in resctrl
 
-- 
2.50.0

