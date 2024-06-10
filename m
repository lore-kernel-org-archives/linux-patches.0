Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A0714F10E
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044546; cv=none; b=k+WSYt1ckThJiUH5rBg5/H9ns/bUYAJ/Xl0ms7cvTsir2hj5vGcB9LW6oRCLk4wN++nSC3Zktd2LRzAN/58iLixUs8SpnUmuxXmbFJpVQLCdXTtkQm4OgrPNNmPwkC/80bUfAqdRNS/usVhueJvTcx3YL7/YTd3mClon2dGHaJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044546; c=relaxed/simple;
	bh=t/+wi5aXo0hchSIFg9tTIykIO8cSw/PBndDjGzr5vMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhfUxvyZ57FCympRNs5XyiOUlTopBfOnZQU04qD4jyKW2Btj9d1kUFdS2ykIwLnkEFTBLeMphcIMMhDCgbJmRuPj0n2OWnO/LKwRfraqjLtX0+WgJBLIZbfj21pvbtM6lVYcabHUMbsOvYJusMkamfjriEBifp6OWbTTle0pSp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WLTNi0s5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WLTNi0s5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044544; x=1749580544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t/+wi5aXo0hchSIFg9tTIykIO8cSw/PBndDjGzr5vMI=;
  b=WLTNi0s57Mud2dwxFCoUkl0rC4cGlOnKfdVD1y6aPKeh9iiF2PIjI2GX
   mJrl05Q4kZsqhBf1GBC8LmTucibQj8/Oo9SVfSU+4e+REaxJJCZvnqJFw
   YV+ZQ+j6s2ESulvMPqg6gvlwQEaiCk+dchEEPcywbCFS9huFUQn4ukZBF
   8dVT2kEZQpbmuoSRRrvuSyhQnkHlL03snlCFkXzZAaafYa+Vo9towyxfO
   HA9lIO8UAn1DqedCcXLFcsTDOrHfUVB2lPq4RESj+Ieasq4gerFSHvLTz
   LPGP/eX9fJBgmXyVnbVF3xo5tfUoZqOVSBXn0BJVhhMw6up+81VeaRPjD
   A==;
X-CSE-ConnectionGUID: kJDSQH8QS9+X5Dk91Xn6ug==
X-CSE-MsgGUID: 3SXNKiJwTo2YYwOnyCERrQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004824"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004824"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: oZ1Ye8/wTPyFeapy71YcgQ==
X-CSE-MsgGUID: UvckYQpDRcKtIJLyOBuXBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576572"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
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
Subject: [PATCH v20 08/18] x86/resctrl: Prepare for new Sub-NUMA Cluster (SNC) monitor files
Date: Mon, 10 Jun 2024 11:35:18 -0700
Message-ID: <20240610183528.349198-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
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
 include/linux/resctrl.h                   | 2 ++
 arch/x86/kernel/cpu/resctrl/internal.h    | 1 +
 arch/x86/kernel/cpu/resctrl/core.c        | 7 ++++++-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 1 -
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 1 -
 5 files changed, 9 insertions(+), 3 deletions(-)

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
index 135190e0711c..99f601d05f3b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_RESCTRL_INTERNAL_H
 #define _ASM_X86_RESCTRL_INTERNAL_H
 
+#include <linux/cacheinfo.h>
 #include <linux/resctrl.h>
 #include <linux/sched.h>
 #include <linux/kernfs.h>
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
index 70f0069b87d8..e69489d48625 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -11,7 +11,6 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/debugfs.h>
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index a0a43dbe011b..869dd1973b5d 100644
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

