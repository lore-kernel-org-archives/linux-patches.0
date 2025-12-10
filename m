Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B082FB0BC
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408515; cv=none; b=MF2KhStoGH9qPO4e4mf6ULw3SRNMIeTK7PcGt2GsS5kLIO12qY8XUEsozq6o/E0nHgpidCIrflTPo8GvJ3c6E8/U6bgtHaKybMBrKKIrfKjllV4e80DE/JV7PndTPPGUzCphSyvOyMsVTz8uiiD/WPDQCl/W9Hnajm9+uhnUVp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408515; c=relaxed/simple;
	bh=O6qWvBa+YL0hQ3KuiKirbTj4qE8Sdyb3EdGGzT6U7ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOxms8Zy8P5izLvDX/2NnIljV9TM3UsIrhsgW7FMT5mGnWnaLNbTdJLd6fxEdiOrQwPVu/6Nmn/5YsqmzuXESKtNwi5kAFozTCSE0VdFxUSJ2C/FFV3QlOk299DwwGqSLUbPk/1HWor7Phb+vpONEwveNnSXq12TMhlSDnNW/b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mTFi5Q8/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTFi5Q8/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408506; x=1796944506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O6qWvBa+YL0hQ3KuiKirbTj4qE8Sdyb3EdGGzT6U7ss=;
  b=mTFi5Q8/VkK6YJmdQeBzqpjEy8b+of33LLWthY1+pyZRQtNItxkFOlMx
   6lUvNrwSlIvBsdXg0pVSJY9wOFWtZMgAl5rYasaXqwrVQj8q6WqLJonZl
   HystwV5S4iBjtStdGqYVfnXtTWz1jHrPaR8Bwfc2resnd77yHbj5U+qPm
   1pFd3bPd/ZSzw0LlLv2PaGF4yylJCvwCuKMthLFxwrhCdkurTWOrer/82
   kCzKfzjc1qngl7kLLMkxo9kegBoQOjCKiN0hgNV/sKynxJHvRk9sA2g8A
   eW5SrxMX6yVI/lbui1RresBXLmvAc9aobfTZ+mvOS//JWUWDifWQglEA+
   g==;
X-CSE-ConnectionGUID: etwdbWKwS1S8cMDkk9cJtw==
X-CSE-MsgGUID: Kw+nNmg2SdiZy4bOQG3t4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973639"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973639"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:37 -0800
X-CSE-ConnectionGUID: wgYJijVJTt+5BGNXZztISQ==
X-CSE-MsgGUID: MAul+G2dTGGP7HGyWYq63Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297111"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:37 -0800
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
Subject: [PATCH v16 20/32] x86/resctrl: Read telemetry events
Date: Wed, 10 Dec 2025 15:13:59 -0800
Message-ID: <20251210231413.59102-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce intel_aet_read_event() to read telemetry events for resource
RDT_RESOURCE_PERF_PKG. There may be multiple aggregators tracking each package,
so scan all of them and add up all counters. Aggregators may return an invalid
data indication if they have received no records for a given RMID. User will
see "Unavailable" if none of the aggregators on a package provide valid counts.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  5 +++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 51 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  4 ++
 fs/resctrl/monitor.c                    | 14 +++++++
 arch/x86/Kconfig                        |  2 +-
 5 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index f2e6e3577df0..10743f5d5fd4 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -225,9 +225,14 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 611c6b1fc08d..38985613d4be 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -11,11 +11,15 @@
 
 #define pr_fmt(fmt)   "resctrl: " fmt
 
+#include <linux/bits.h>
 #include <linux/compiler_types.h>
+#include <linux/container_of.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
@@ -236,3 +240,50 @@ void __exit intel_aet_exit(void)
 		}
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators on the
+ * domain). If an aggregator hasn't received any data for a specific RMID,
+ * the MMIO read indicates that data is not valid.  Return success if at
+ * least one aggregator has valid data.
+ */
+int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct event_group *e;
+	bool valid = false;
+	u64 total = 0;
+	u64 evtcount;
+	void *pevt0;
+	u32 idx;
+
+	pevt0 = pevt - pevt->idx;
+	e = container_of(pevt0, struct event_group, evts);
+	idx = rmid * e->num_events;
+	idx += pevt->idx;
+
+	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
+		pr_warn_once("MMIO index %u out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < e->pfg->count; i++) {
+		if (!e->pfg->regions[i].addr)
+			continue;
+		if (e->pfg->regions[i].plat_info.package_id != domid)
+			continue;
+		evtcount = readq(e->pfg->regions[i].addr + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			continue;
+		total += evtcount & DATA_BITS;
+		valid = true;
+	}
+
+	if (valid)
+		*val = total;
+
+	return valid ? 0 : -EINVAL;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 6929614ba6e6..e6a154240b8d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -251,6 +251,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
+
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, arch_priv, val);
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9af08b673e39..8a4c2ae72740 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -527,6 +527,20 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 			return __l3_mon_event_count(rdtgrp, rr);
 		else
 			return __l3_mon_event_count_sum(rdtgrp, rr);
+	case RDT_RESOURCE_PERF_PKG: {
+		u64 tval = 0;
+
+		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, rdtgrp->closid,
+						 rdtgrp->mon.rmid, rr->evt->evtid,
+						 rr->evt->arch_priv,
+						 &tval, rr->arch_mon_ctx);
+		if (rr->err)
+			return rr->err;
+
+		rr->val += tval;
+
+		return 0;
+	}
 	default:
 		rr->err = -EINVAL;
 		return -EINVAL;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52dda19d584d..4cf9de520baf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -540,7 +540,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.51.1

