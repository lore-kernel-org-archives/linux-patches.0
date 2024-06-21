Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC32B16F297
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009556; cv=none; b=dCMY6Usl3/rh39/FVRWteE/RCeJgSpMX/t2mBo1uNyOLh4RFcqNALGn2aSoBYLvO0hxMkkrFM/EZa4a+MpMkqGrO+rL8RxWW/DEzmjdkz6cCzvdVpNCZkne2Rwmn1Vv/jGDUSONaskLzK8kL7CY4FyLDs/aOz00024I8wm42IWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009556; c=relaxed/simple;
	bh=HpN0fZNgjLZmcSihQeKSECqN5OpJxfxDgnhxOxN+MP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdiqJa04DEMgX2l9/knzwTCm1qeN3Hh/FljSdqG9JMp8ihBUr8SHFoW6ZXNeZEBwj5UUMFOwBBqKUr+HUG+Ou6ceOiuW51ulrmr7wQt//Y6wxzCFsNpORnWDMWKP/xBZnmQYCxvwddY5QKYFVkaDxATPpzolL0FQZidLMSp8UZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfNFsGV+; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfNFsGV+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009554; x=1750545554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HpN0fZNgjLZmcSihQeKSECqN5OpJxfxDgnhxOxN+MP4=;
  b=DfNFsGV+Kar4e3TGzqw7DNcv6ftZNVmNxJ1OzIgyiRsV5PJOp3BcmVgL
   otil3WvS5MABsIDJQa45uIP9c5cPzbLKQGyxl6AQZo8L3QvXkn083Y8Dy
   sZWyRRPRyyRVa7pZ/o/Z0ZsPByOyEkDgt/DxnkYu8SdTS2i+DBYxEuara
   t5LSUYrWH4LX0DLVYEcteHmeMz63hHvAi+Johq3aM+GWFqsuFFd09/Pdh
   cZcekn1C0T9eQek3bC0EANl1Sks13JzGt9CWX4wz8AuhHQy2+m90Cu9WA
   wB75oRNXxjgs6XIHAYzpSbpo979pboJloE18u6n3JK0c7uoQ2BhlmjDyR
   A==;
X-CSE-ConnectionGUID: iG6BbhpvQq6vfXvpnKfQHw==
X-CSE-MsgGUID: 7MCtPv5bQhKL5PIqHsrtuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691306"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691306"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
X-CSE-ConnectionGUID: yFNospDXSu+nThV+XC5SMA==
X-CSE-MsgGUID: yzN3/Y+GSoeJPCWk+/CSNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935662"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
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
Subject: [PATCH v21 08/18] x86/resctrl: Prepare for new Sub-NUMA Cluster (SNC) monitor files
Date: Fri, 21 Jun 2024 15:38:49 -0700
Message-ID: <20240621223859.43471-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
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
 include/linux/resctrl.h                   | 3 +++
 arch/x86/kernel/cpu/resctrl/core.c        | 7 ++++++-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 1 -
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 1 -
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 64b6ad1b22a1..b0875b99e811 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -2,6 +2,7 @@
 #ifndef _RESCTRL_H
 #define _RESCTRL_H
 
+#include <linux/cacheinfo.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/pid.h>
@@ -96,6 +97,7 @@ struct rdt_ctrl_domain {
 /**
  * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
+ * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
  * @mbm_total:		saved state for MBM total bandwidth
  * @mbm_local:		saved state for MBM local bandwidth
@@ -106,6 +108,7 @@ struct rdt_ctrl_domain {
  */
 struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
+	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
 	struct mbm_state		*mbm_total;
 	struct mbm_state		*mbm_local;
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
index d3b0fa958266..70d41a8fd788 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -12,7 +12,6 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/debugfs.h>
 #include <linux/fs.h>
-- 
2.45.2

