Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9013BC0E
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886855; cv=none; b=qNCeKGdWRBJc8u/VHvd4Xpm5DfcN79uX/35Uuj6D+j77NKde5D8e6SZGffuqtMfRggGeyBzPTsGChQ4bD0EUcaNH+sLbPDyPwo9Zyz792tGH+9ErXKqCzhZYYK87k4rJxsqKu6f1HwSLcu8dsxVDPjjZ0nFCRCFWXSFt+KdyIRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886855; c=relaxed/simple;
	bh=DXuP7E9E2VzfYvHSOVvcEpbDHa6++ujfagg1yqnmz3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jepwud+v1b0TVPXO66P5mTmb6sXWdikcOmkXJhmCA7+BxwkBZdwQB+r/CNKvkwOm/oxsllsCdsWtyhrkPa7A4FmAAHbrRgTvBzpwU4o7PITRaIF0S4ZF001+GH/n/+TJb7ej8p4trGcd8ZbzfcTB23rsL9fg+2PAJXGgKOcI2BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gVaQMlNU; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVaQMlNU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886853; x=1777422853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DXuP7E9E2VzfYvHSOVvcEpbDHa6++ujfagg1yqnmz3E=;
  b=gVaQMlNUI0r3F1aihQ2KxyNkAhPpwnIDqmp9uSgfj5yDGPzgo7hk9+MD
   bLgCVNsymDzsekBlPE5RZatj027e8j4qNTkWvPA97oB7j/T/NqxpSJzfV
   oXs+uI5VvBgXq+FDbl4HGm6kuoWdJAa/mgd3c509p8KEEWCUulmjoU/g0
   JgikI3mZU/Xs+eoRq4mbg78C2ZBzjpPGQ11dSMNJFd1SsQ42ujh77Kccv
   C0StNvDE2YgHLrDvLQKL1/sD9z3lhaOcSRbJ2bHzPEJa8WldlqqEOlc7r
   rOF1MIuZ2nvo0+J3pEo2+3F/ZmFHiZ69sqmP2hNPngpApJauw3xKhkF47
   Q==;
X-CSE-ConnectionGUID: mbmOFZ6+TQGHlfTs1GjceQ==
X-CSE-MsgGUID: zzxaLijfQRKMfz29gDjh9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148107"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148107"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:11 -0700
X-CSE-ConnectionGUID: g2/CXFh+S/e4IzNkvsvsog==
X-CSE-MsgGUID: 9Dfxd0bVTdSVw4ic/XwhvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393981"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:11 -0700
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
Subject: [PATCH v4 08/31] x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
Date: Mon, 28 Apr 2025 17:33:34 -0700
Message-ID: <20250429003359.375508-9-tony.luck@intel.com>
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

To prepare for additional types of monitoring domains, move all the
L3 specific initialization into a helper function.

Rename several functions to mark that they are specific to the L3 path.

arch_mon_domain_online	-> arch_l3_mon_domain_online
mon_domain_free		-> free_l3_mon_domain
arch_mon_domain_online	-> arch_l3_mon_domain_online
domain_setup_mon_state	-> domain_setup_l3_mon_state

resctrl_online_mon_domain() is going to share some code with new
reources, so keeps the same name, but include a check for
RDT_RESOURCE_L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c     | 69 +++++++++++++++-----------
 arch/x86/kernel/cpu/resctrl/monitor.c  |  2 +-
 fs/resctrl/rdtgroup.c                  | 11 ++--
 4 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 02b535c828f3..b563406b4996 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -122,7 +122,7 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
 
 extern struct rdt_hw_resource rdt_resources_all[];
 
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
+void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
 union cpuid_0x10_1_eax {
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index bdd4d08a3912..d48cdc85a86d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -362,7 +362,7 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 	kfree(hw_dom);
 }
 
-static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
+static void free_l3_mon_domain(struct rdt_hw_mon_domain *hw_dom)
 {
 	for (int i = 0; i < QOS_NUM_MBM_EVENTS; i++)
 		kfree(hw_dom->arch_mbm_states[i]);
@@ -493,33 +493,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	}
 }
 
-static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
 {
-	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct list_head *add_pos = NULL;
 	struct rdt_hw_mon_domain *hw_dom;
-	struct rdt_domain_hdr *hdr;
 	struct rdt_mon_domain *d;
 	int err;
 
-	lockdep_assert_held(&domain_list_lock);
-
-	if (id < 0) {
-		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
-			     cpu, r->mon_scope, r->name);
-		return;
-	}
-
-	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
-	if (hdr) {
-		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-		return;
-	}
-
 	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
 	if (!hw_dom)
 		return;
@@ -531,15 +510,15 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d->ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!d->ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
-		mon_domain_free(hw_dom);
+		free_l3_mon_domain(hw_dom);
 		return;
 	}
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
-	arch_mon_domain_online(r, d);
+	arch_l3_mon_domain_online(r, d);
 
 	if (arch_domain_mbm_alloc(r->num_rmid, hw_dom)) {
-		mon_domain_free(hw_dom);
+		free_l3_mon_domain(hw_dom);
 		return;
 	}
 
@@ -549,7 +528,41 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		free_l3_mon_domain(hw_dom);
+	}
+}
+
+static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+{
+	int id = get_domain_id_from_scope(cpu, r->mon_scope);
+	struct list_head *add_pos = NULL;
+	struct rdt_domain_hdr *hdr;
+	struct rdt_mon_domain *d;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	if (id < 0) {
+		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
+			     cpu, r->mon_scope, r->name);
+		return;
+	}
+
+	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
+	if (hdr) {
+		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
+			return;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+
+		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+		return;
+	}
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		setup_l3_mon_domain(cpu, id, r, add_pos);
+		break;
+	default:
+		WARN_ON_ONCE(1);
 	}
 }
 
@@ -640,7 +653,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		resctrl_offline_mon_domain(r, d);
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		free_l3_mon_domain(hw_dom);
 
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index bf7fde07846b..d1f659dd6109 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -271,7 +271,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
  * must adjust RMID counter numbers based on SNC node. See
  * logical_rmid_to_physical_rmid() for code that does this.
  */
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
+void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	if (snc_nodes_per_l3_cache > 1)
 		msr_clear_bit(MSR_RMID_SNC_CONFIG, 0);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index e66dc041be5f..a0d2be84832c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4063,7 +4063,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 }
 
 /**
- * domain_setup_mon_state() -  Initialise domain monitoring structures.
+ * domain_setup_l3_mon_state() -  Initialise domain monitoring structures.
  * @r:	The resource for the newly online domain.
  * @d:	The newly online domain.
  *
@@ -4075,7 +4075,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
  *
  * Returns 0 for success, or -ENOMEM.
  */
-static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
+static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(struct mbm_state);
@@ -4126,11 +4126,14 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 
 int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
-	int err;
+	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
 
-	err = domain_setup_mon_state(r, d);
+	if (r->rid != RDT_RESOURCE_L3)
+		goto out_unlock;
+
+	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
 
-- 
2.48.1

