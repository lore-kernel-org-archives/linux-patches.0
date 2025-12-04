Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0519329361
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881678; cv=none; b=hqTHhkeqLWU3KNIwp/p3VW0oXIMlTN4jweqngXyJrINma/GE25kkrohieZZ4fFjFncTzwZnCaoumsC4+/USWwq8UYzILrRhkCBSxZYjp4BtQsQODEUPuqi5FvGWTLbhwxIyWsiuzr53cTLYnEzZ/jldcGGPqkw7F5mbk6TAscLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881678; c=relaxed/simple;
	bh=AFFNg9aOyG6Er+cjCYljr0X19y2MaV9WG5onQ9ip9uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKE6C3m90Qp2VhIsir4MX7hU2wP78QPOA11h4wpdteY+JY8FsVmZGL6K0GBQgHOcy/Ke4XOmmV88lBekKkdX9G06V/0VTGQ1IkvJFU2gPUC8Bn6AAbBucxwIVn6RezaM3gjtmr2rMfqIiMR0mzkf7gPU7TlRmctdOBBUcUbtoR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hx6hSDmh; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hx6hSDmh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881676; x=1796417676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AFFNg9aOyG6Er+cjCYljr0X19y2MaV9WG5onQ9ip9uA=;
  b=hx6hSDmhPWjw2pxg0+W5tX4Ero5QNem193Atcum5iy7Iz9ChRn89qIEq
   zldHB3odWF4xQ78UOWIanZZH2SOLypJDUtc/nnpnlculhqCWJUrDIvHG9
   vKeSL7uUwdtLPVuR+Z4tTzT178ntdcfSoebMh9UoDaqu6pI/8QfPNCAsI
   D8EJug+NMPXSV8hKb2rnYB/YKdAmtxHolar2k3binCYTR9qznQ2vh7i65
   UuYnKReGfmzcHTLW+sp44aHmkc4pNMhBYw0kfwXLgIQw5g4mtNsWccPBa
   QFJE7hMGYswJjb23whznlYYNLCIMz4YWFdkqUY3wgZ093YJAnVwnxB1KH
   w==;
X-CSE-ConnectionGUID: C/qSW+H4TTaHY0gkRoacCQ==
X-CSE-MsgGUID: Nvy9mOYUTuixAjj7aOXZXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511045"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511045"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:28 -0800
X-CSE-ConnectionGUID: PyLkiFihTJaJfuXxV3G8hg==
X-CSE-MsgGUID: 7Nfv18a+RnyYMAuP6P3usA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752847"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:28 -0800
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
Subject: [PATCH v15 23/32] x86,fs/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
Date: Thu,  4 Dec 2025 12:53:53 -0800
Message-ID: <20251204205404.12763-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
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

Define a new rdt_perf_pkg_mon_domain structure which just consists of the
standard rdt_domain_hdr to keep track of domain id and CPU mask.

Update resctrl_online_mon_domain() for RDT_RESOURCE_PERF_PKG. The only action
needed for this resource is to create and populate domain directories if a
domain is added while resctrl is mounted.

Similarly resctrl_offline_mon_domain() only needs to remove domain directories.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 13 +++++++++++
 arch/x86/kernel/cpu/resctrl/core.c      | 17 +++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                   | 17 ++++++++++-----
 4 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 10743f5d5fd4..3b228b241fb2 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -87,6 +87,14 @@ static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3
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
@@ -226,6 +234,8 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
+void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -233,6 +243,9 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
 {
 	return -EINVAL;
 }
+
+static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+					      struct list_head *add_pos) { }
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 3c6946a5ff1b..283d653002a2 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -580,6 +580,10 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
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
@@ -679,6 +683,19 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		l3_mon_domain_free(hw_dom);
 		break;
 	}
+	case RDT_RESOURCE_PERF_PKG: {
+		struct rdt_perf_pkg_mon_domain *pkgd;
+
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_PERF_PKG))
+			return;
+
+		pkgd = container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr);
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(pkgd);
+		break;
+	}
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 85ca24e42ec1..8fcd72fca81f 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -14,15 +14,20 @@
 #include <linux/bits.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
+#include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/gfp_types.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/printk.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
+#include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/topology.h>
 #include <linux/types.h>
@@ -288,3 +293,27 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 
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
+	d->hdr.rid = RDT_RESOURCE_PERF_PKG;
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
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 679247c43b1a..ac3c6e44b7c5 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4307,11 +4307,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 
 	mutex_lock(&rdtgroup_mutex);
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		goto out_unlock;
-
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-
 	/*
 	 * If resctrl is mounted, remove all the
 	 * per domain monitor data directories.
@@ -4319,6 +4314,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto out_unlock;
+
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		goto out_unlock;
+
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4415,6 +4417,9 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 
 	mutex_lock(&rdtgroup_mutex);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto mkdir;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
@@ -4432,6 +4437,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
+mkdir:
+	err = 0;
 	/*
 	 * If the filesystem is not mounted then only the default resource group
 	 * exists. Creation of its directories is deferred until mount time
-- 
2.51.1

