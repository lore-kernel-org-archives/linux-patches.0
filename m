Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C154313E899
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934822; cv=none; b=DUVlBHyZYn7l4JQXeSoNHKN68KlNzBwJ4Kaq4scre29Ur9KAE8gkTpy+F+CLKUbOxFHBLWHsikXN8tjeY0/YesXBQe/Lz0vSTse+IbeayrPuP1n1ILF87bsrDnVMzM/KszM2UCc/3GIv0BMAamxqPi+K3FdroDrx46o1p9xvmzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934822; c=relaxed/simple;
	bh=+d/CfgoQlj3LxBdTbrw5ws4sh4DgcSjzzP45sdvMehw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gtl3G/ar+dFKdN1pU35eKCsf6zZC5pNhLcrDiMYcQTuWkjWfuP/rhQx5RXXqEprrBuJ7UcVmDXN/yeHVao8EZKMehHyXKbpmm3a4qNeDCwkq42fCKgmXbqRuVuO9ZdAB4lVwSGdjqVHdHpINm+F6zriU4Q7T/PL+csgwj5UcFSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcF3Uk3V; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcF3Uk3V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934821; x=1748470821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+d/CfgoQlj3LxBdTbrw5ws4sh4DgcSjzzP45sdvMehw=;
  b=kcF3Uk3VcF/C/II39C9XpiB+duVtUMDET6yfGJ5r+3jQa0oeUylkF2ow
   1d4HVvAWlQyjZVkIDh6D/7FX6Yvx3kGNxwtWa/7euWbS+vk5vFSsGrQpv
   AjjuHyeMunPxbyjPiiX/BrNbHPn3ZeJV+SmS6wxTDnMkf9uyrPKJoNS9p
   HcUbECh4Xo9JRpWCj9oISV7FKT/jsDDp2YSMooa3vfkeJTUVWc9AzjMfP
   Lo/8RofeH4KcToB8rNuq+32w5ny2587qlmVoG4xXo9FHM+1MIhwqvu3wp
   VM+g/qzG4uJDCJTSNRbOQmDJOeHfE6ARXoJajzuXeeXGUSH9pQTeEmlB/
   Q==;
X-CSE-ConnectionGUID: 3FO3UCn4Tve5PhJMUqa7sA==
X-CSE-MsgGUID: V0tzXJ+BQHS27ukvbRVfnw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812191"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812191"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:17 -0700
X-CSE-ConnectionGUID: bPdrcfAJReCWsRhQlsr54g==
X-CSE-MsgGUID: 5jyXBg9KQYuzN2lhzM44Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090734"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v19 08/20] x86/resctrl: Prepare for new Sub-NUMA Cluster (SNC) monitor files
Date: Tue, 28 May 2024 15:19:53 -0700
Message-ID: <20240528222006.58283-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When SNC is enabled monitoring data is collected at the SNC node
granularity, but must be reported at L3-cache granularity for
backwards compatibility in addition to reporting at the node
level.

Add a "ci" field to the rdt_mon_domain structure to save the
cache information about the enclosing L3 cache for the domain.
This provides:

1) The cache id which is needed to compose the name of the legacy
monitoring directory, and to determine which domains should be
summed to provide L3-scoped data.

2) The shared_cpu_map which is needed to determine which CPUs can
be used to read the RMID counters with the MSR interface.

This is the first step to an eventual goal of monitor reporting files
like this (for a system with two SNC nodes per L3):

$ cd /sys/fs/resctrl/mon_data
$ tree mon_L3_00
mon_L3_00			<- 00 here is L3 cache id
├── llc_occupancy		\  These files provide legacy support
├── mbm_local_bytes		 > for non-SNC aware monitor apps
├── mbm_total_bytes		/  that expect data at L3 cache level
├── mon_sub_L3_00		<- 00 here is SNC node id
│   ├── llc_occupancy		\  These files are finer grained
│   ├── mbm_local_bytes		 > data from each SNC node
│   └── mbm_total_bytes		/
└── mon_sub_L3_01
    ├── llc_occupancy		\
    ├── mbm_local_bytes		 > As above, but for node 1.
    └── mbm_total_bytes		/

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                   |  2 ++
 arch/x86/kernel/cpu/resctrl/internal.h    | 21 +++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/core.c        |  7 ++++++-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  1 -
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 -
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 64b6ad1b22a1..d733e1f6485d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
 /**
  * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
+ * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
  * @mbm_total:		saved state for MBM total bandwidth
  * @mbm_local:		saved state for MBM local bandwidth
@@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
  */
 struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
+	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
 	struct mbm_state		*mbm_total;
 	struct mbm_state		*mbm_local;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 135190e0711c..eb70d3136ced 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_RESCTRL_INTERNAL_H
 #define _ASM_X86_RESCTRL_INTERNAL_H
 
+#include <linux/cacheinfo.h>
 #include <linux/resctrl.h>
 #include <linux/sched.h>
 #include <linux/kernfs.h>
@@ -509,6 +510,26 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
 
 int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
 
+/*
+ * Get the cacheinfo structure of the cache associated with @cpu at level @level.
+ * cpuhp lock must be held.
+ */
+static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
+{
+	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
+	int i;
+
+	for (i = 0; i < ci->num_leaves; i++) {
+		if (ci->info_list[i].level == level) {
+			if (ci->info_list[i].attributes & CACHE_ID)
+				return &ci->info_list[i];
+			break;
+		}
+	}
+
+	return NULL;
+}
+
 /*
  * To return the common struct rdt_resource, which is contained in struct
  * rdt_hw_resource, walk the resctrl member of struct rdt_hw_resource.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b86c525d0620..95ef8fe3cb50 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -19,7 +19,6 @@
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/cacheinfo.h>
 #include <linux/cpuhotplug.h>
 
 #include <asm/cpu_device_id.h>
@@ -608,6 +607,12 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
+	if (!d->ci) {
+		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
+		mon_domain_free(hw_dom);
+		return;
+	}
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
 	if (arch_domain_mbm_alloc(r->num_rmid, hw_dom)) {
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index abec0d6d9476..20dd9076f89f 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -11,7 +11,6 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/debugfs.h>
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 1cc4794d5a2e..13f93f2a55b3 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -12,7 +12,6 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/debugfs.h>
 #include <linux/fs.h>
-- 
2.45.0

