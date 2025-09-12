Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B5D35208A
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715079; cv=none; b=ulltIu22EhFYjhLOC1kaOQvzGd9UouTU1lcigJJfZSNlHizFfQp4SUtfSPGT5tbmFNjQHaQgpzj2ApevWiG4k4m7OpXzxXBlgDX8VGbjTaDAVqNjp76a76bfGHNri5A2cErEWT9brRs0Zwv/L73VRyzr/Zpa2Q/mv4g5fhKzJMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715079; c=relaxed/simple;
	bh=+Ps12KIhIkqqdYMGvu+JzHRPADhxCXiDTr9YjLb5mOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pleNVOGXSq0UEGJ2KWdsPlFT2v0F4X02eiAaJMJPt9zbFS0L12sYZ4zF5YKNk/XaV8WdGC5pqS9Cg8y2jCNaOsdTOpzHbieCcb2GxTgAx3VOtzrOBVx1qU9Tx4nbunIyuve8QCmD3I270HBw/XfoiVvjOUF/XAjrzz1IfowEKrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTzlep4U; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTzlep4U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715077; x=1789251077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Ps12KIhIkqqdYMGvu+JzHRPADhxCXiDTr9YjLb5mOM=;
  b=TTzlep4UAsAOm/m9jD9xeia6UAIDeRisVbySfRjoYrtzaLGHXcMqFESB
   0AAIvNdUYc+a3MqZtVA7HM6qUOae5W9btxnhM20CWb8aLRm0JashVaiOb
   hG4yfKS58SZjjfIUSUyQeoaGEI/l6oyvGK6bam5n3KEWYhAc8OZ1oS76I
   4ne7QrlqhjyesJ9EvUoEXwRuvtPa/7eC9B1Hs6xxWrYQl4MIBdDanRE9i
   wlv4LMYBwOod/UoVVCwPdzF5KWsZxWJRS8/v0enttOSWWbj6hGMjqd+WH
   rRzKq3UaEfig+o2xrvNuID+Us8bGDSlGvWKmn4eCit+5EWFDsbp3O8FeP
   A==;
X-CSE-ConnectionGUID: 6nnTAImfSoKtWGqdjh7CPQ==
X-CSE-MsgGUID: oWcuME3gQ02y+KVgIawHnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002792"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002792"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:10 -0700
X-CSE-ConnectionGUID: GViNg/TwRf+sWhpXds0Orw==
X-CSE-MsgGUID: LxMmUs9sRPyKiKdJjGB2tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265203"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:09 -0700
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
Subject: [PATCH v10 19/28] x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
Date: Fri, 12 Sep 2025 15:10:40 -0700
Message-ID: <20250912221053.11349-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
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
Allocate and initialize the rdt_perf_pkg_mon_domain structure when the
first CPU of a domain comes online and do necessary cleanup when the
last CPU of a domain goes offline.

Add WARN checks to code that sums domains for Sub-NUMA cluster to
confirm the the resource ID is RDT_RESOURCE_L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 13 +++++++++++
 arch/x86/kernel/cpu/resctrl/core.c      | 12 ++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
 fs/resctrl/ctrlmondata.c                |  5 +++++
 fs/resctrl/rdtgroup.c                   |  6 +++++
 5 files changed, 65 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 4ad8e34444de..592c7cf8e354 100644
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
index 43f43940ffe3..f493f9a2fdf5 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -576,6 +576,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		l3_mon_domain_setup(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		intel_aet_mon_domain_setup(cpu, id, r, add_pos);
+		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
@@ -673,6 +676,15 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		synchronize_rcu();
 		l3_mon_domain_free(hw_dom);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_PERF_PKG))
+			return;
+
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
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
index c19d87fa96ec..bb59f4a495b8 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3044,6 +3044,9 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
+	if (WARN_ON_ONCE(do_sum && rid != RDT_RESOURCE_L3))
+		return NULL;
+
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
 		    priv->sum == do_sum && priv->evt == mevt)
@@ -4229,6 +4232,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto out_unlock;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
-- 
2.51.0

