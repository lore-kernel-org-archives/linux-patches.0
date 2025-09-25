Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C55323417
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830662; cv=none; b=HzIuI7o8qSQY9HLZ416XsXEPwtVwXyhjxHsghkDjE6XeYCIH4JPRy24sJj/ssnj2/3FwxxbQ36iwHCLkCRDoTWyPQMo2/xY+WlaVdykQWJfunHL95sFkiWJgPJoRKWFcJsfBJkfNP26I0qkGQ725x01fqADEcweCVoUJdvxTw+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830662; c=relaxed/simple;
	bh=NYZq+e/7j/QeJaD8gSC2nHl3bHirqNZYGb8Xy8peETc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WusJJVBmlMPzUtOgj+RW/HsVDD5i3QeLgiZfqrgFUS11Wxa5mrvQiZw6uaP3mCWVsnP3DKgxcorr44jka8C5hYcQkcYs+h6CvvEiIBG8nUtGJlawiaFT7DQ/kcyl/le5O6KQpBifr1K99z8Wdiqx7a4rXt1WTP5YVdchCFwg/tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JKsgED/Y; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JKsgED/Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830661; x=1790366661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NYZq+e/7j/QeJaD8gSC2nHl3bHirqNZYGb8Xy8peETc=;
  b=JKsgED/Y358g7yzT6w1jqAQZnWTVWLMNudYh8tQVGQqoEg6jHzbZsKxZ
   E10VcYjaxl9b0JVZ1yHfjvy8kkJAZqTh0RgCnympvK9HhYETsbsSyYcLn
   iMhsAnzV2cf5ZMFTicOjGTivc9Mi1zGao6IKP4I+WN+tYSKOi9xRtQyyT
   xqO74lWHs/Bg21CXVsOA/pKMMv/Qj4J/geJQt27ISeOWJKRh5Uw7SXOGK
   nBuh/EnwhfEIpdHrmCrOeIfsUJgFcy17y6zAwiuZ+TW+9kMDNTzTVZUCH
   DJkWOBs0dOMRjjro+DzOFSZDgjDkcSKUs5L8WCwWuYAqFvhtXWukrGKh/
   A==;
X-CSE-ConnectionGUID: 2R82kI5oTU6IDdjwcGPpmw==
X-CSE-MsgGUID: eQRK7h2PTOG5md69XFgcOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074315"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074315"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:12 -0700
X-CSE-ConnectionGUID: BooRzUWiRWO9uY9wfgrW8w==
X-CSE-MsgGUID: UwvtG2ajSxuRbBNBL7v9/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003674"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:12 -0700
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
Subject: [PATCH v11 21/31] x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
Date: Thu, 25 Sep 2025 13:03:15 -0700
Message-ID: <20250925200328.64155-22-tony.luck@intel.com>
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

The L3 resource has several requirements for domains. There are per-domain
structures that hold the 64-bit values of counters, and elements to keep
track of the overflow and limbo threads.

None of these are needed for the PERF_PKG resource. The hardware counters
are wide enough that they do not wrap around for decades.

Define a new rdt_perf_pkg_mon_domain structure which just consists of
the standard rdt_domain_hdr to keep track of domain id and CPU mask.

Support the PERF_PKG resource in the CPU online/offline handlers.

Add WARN checks to code that sums domains for Sub-NUMA cluster to
confirm the resource ID is RDT_RESOURCE_L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 13 +++++++++++
 arch/x86/kernel/cpu/resctrl/core.c      | 15 +++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
 fs/resctrl/ctrlmondata.c                |  5 +++++
 fs/resctrl/rdtgroup.c                   | 10 +++++++++
 5 files changed, 72 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 97616c81682b..b920f54f8736 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -84,6 +84,14 @@ static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3
 	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
 }
 
+/**
+ * struct rdt_perf_pkg_mon_domain - CPUs sharing an package scoped resctrl monitor resource
+ * @hdr:	common header for different domain types
+ */
+struct rdt_perf_pkg_mon_domain {
+	struct rdt_domain_hdr	hdr;
+};
+
 /**
  * struct msr_param - set a range of MSRs from a domain
  * @res:       The resource to use
@@ -222,6 +230,8 @@ bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id evtid,
 			 void *arch_priv, u64 *val);
+void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -230,6 +240,9 @@ static inline int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_i
 {
 	return -EINVAL;
 }
+
+static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+					      struct list_head *add_pos) { }
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 588de539a739..5dff83e763a5 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -573,6 +573,10 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 		if (!hdr)
 			l3_mon_domain_setup(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		if (!hdr)
+			intel_aet_mon_domain_setup(cpu, id, r, add_pos);
+		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
@@ -635,6 +639,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
+	struct rdt_perf_pkg_mon_domain *pkgd;
 	struct rdt_hw_l3_mon_domain *hw_dom;
 	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
@@ -670,6 +675,16 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		synchronize_rcu();
 		l3_mon_domain_free(hw_dom);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_PERF_PKG))
+			return;
+
+		pkgd = container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr);
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(pkgd);
+		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index d53211ac6204..dc0d16af66be 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -17,16 +17,21 @@
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/gfp_types.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/overflow.h>
 #include <linux/printk.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
+#include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/topology.h>
 #include <linux/types.h>
@@ -282,3 +287,27 @@ int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id eventid,
 
 	return valid ? 0 : -EINVAL;
 }
+
+void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos)
+{
+	struct rdt_perf_pkg_mon_domain *d;
+	int err;
+
+	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
+	if (!d)
+		return;
+
+	d->hdr.id = id;
+	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.rid = r->rid;
+	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+	list_add_tail_rcu(&d->hdr.list, add_pos);
+
+	err = resctrl_online_mon_domain(r, &d->hdr);
+	if (err) {
+		list_del_rcu(&d->hdr.list);
+		synchronize_rcu();
+		kfree(d);
+	}
+}
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index ae43e09fa5e5..f7fbfc4d258d 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -712,6 +712,11 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	if (md->sum) {
 		struct rdt_l3_mon_domain *d;
 
+		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		/*
 		 * This file requires summing across all domains that share
 		 * the L3 cache id that was provided in the "domid" field of the
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index cab5cb9e6c93..fa6dfebea6b2 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3040,6 +3040,9 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
+	if (WARN_ON_ONCE(do_sum && rid != RDT_RESOURCE_L3))
+		return NULL;
+
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
 		    priv->sum == do_sum && priv->evt == mevt)
@@ -4227,6 +4230,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto out_unlock;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
@@ -4327,6 +4333,9 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 
 	mutex_lock(&rdtgroup_mutex);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto mkdir;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
@@ -4344,6 +4353,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
+mkdir:
 	err = 0;
 	/*
 	 * If the filesystem is not mounted then only the default resource group
-- 
2.51.0

