Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6475214230
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886869; cv=none; b=LCCwXwnlnyi8W7Bxf4RT8ObMxZD7AswlAIRzVEle93BhyPLC+D7PN2iY6CTcGaWGZGOPzzbF8B24PU1HBBhHo5tj1z408Z2B1I52Z6Lc74nQ/lAZWOFdhLqSd7CD8FRlWgCtwltWCbpPZkDIIK1FK29CF1B6gGqakQCBnRApYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886869; c=relaxed/simple;
	bh=g3YsS9Ba5gWLVPZVGSbNAWbF90rXvwt3rICU9VNcUdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCbzhuOV6Bo9SWwLFb1fvR4V1TACpGs39ZF5nGCGRaQDwARCc8F6g7PHPvzEtT8JmyTErjjS45LmKLa/0CfmeQgie7wSlVpwKNxm6rqALYrZzIO0lgk5a8VCF3e7s4HgU4uW3XPAuBw8hhtjF5Mr58PNZLo8PQyVZlk0NzVOWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dJWFqNjz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dJWFqNjz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886867; x=1777422867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g3YsS9Ba5gWLVPZVGSbNAWbF90rXvwt3rICU9VNcUdM=;
  b=dJWFqNjzqj2fxeLizNdJinAtX5Eu0bs++Y2mpyQxb5af4sI5bRxnblx/
   nRN0WMwvt8n3HSfvqIZ9CEbth+8nj/4BNXTRIOfiBl9xMtPkbHhBsmQYl
   GFKQtkm5nHzp3T3hz3u6bOFzee4LWXjTLt33wtIYCa6ap+yVxoVm4mCyl
   33qVb3oFLk+T14h8Oc5yMJhSWliLpoLWFjY0NlcANl+8TiIx+Kj5ClYIc
   2XRxJNbZyhK7JvCJeGbTCj6ZWce3FfTcvipgmSIatvZstH/GVudE6O3Jy
   WfD4BSWbUWUKs7eAeZdbVqKdB+/lvoviVI/R3o7F7jBgXw5TETksQ08FC
   A==;
X-CSE-ConnectionGUID: cIhbEE/qQ1q+9aabfTQS9w==
X-CSE-MsgGUID: 2M8OWb3dRUCxTCZeDqc/yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148244"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148244"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:20 -0700
X-CSE-ConnectionGUID: +6bIUJcYQWeJfw0FKNCM8A==
X-CSE-MsgGUID: L7bfGbOBSSS8PG7+BavF/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394047"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:19 -0700
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
Subject: [PATCH v4 22/31] x86/resctrl: Read core telemetry events
Date: Mon, 28 Apr 2025 17:33:48 -0700
Message-ID: <20250429003359.375508-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl file system passes requests to read event monitor files to
the architecture resctrl_arch_rmid_read() function to collect values
from hardware counters.

Use the resctrl resource to differentiate between calls to read legacy
L3 events from the new telemetry events (which are attached to
RDT_RESOURCE_PERF_PKG).

There may be multiple devices tracking each package, so scan all of them
and add up all counters.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  5 ++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  3 +++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 571db665eca6..dd5fe8a98304 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -170,9 +170,14 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 #ifdef CONFIG_INTEL_AET_RESCTRL
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void intel_aet_exit(void) { };
+static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index e1cb6bd4788d..0bbf991da981 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
+#include <linux/io.h>
 #include <linux/resctrl.h>
 
 /* Temporary - delete from final version */
@@ -246,3 +247,36 @@ void __exit intel_aet_exit(void)
 		free_mmio_info((*peg)->pkginfo);
 	}
 }
+
+#define VALID_BIT	BIT_ULL(63)
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
+	if (idx * sizeof(u64) > info->event_group->mmio_size) {
+		pr_warn_once("MMIO index %d out of range\n", idx);
+		return -EINVAL;
+	}
+
+	for (int i = 0; i < mmi->count; i++) {
+		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
+		if (!(evtcount & VALID_BIT))
+			return -EINVAL;
+		*val += evtcount & DATA_BITS;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 8d8ec86929fa..04214585824b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -237,6 +237,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(d->hdr.id, rmid, eventid, val);
+
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 	if (ret)
-- 
2.48.1

