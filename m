Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6965217654
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886874; cv=none; b=PIAJpb7dQG1EZx9sljQ0JdzNBC+Fw4NAuALSSqt6Uxzd1vnpeSc0QeMF/LYmaRIMYUdMM9s+9grD1Fu39KM71T1nlFDNb7oUIBExAEgVmwf7lmIeFdc62TrOdKORvEemUyHtI52br5f1H8Y6wFNPbopLDsEKTysHj4RdxC2ce+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886874; c=relaxed/simple;
	bh=CbqfS32/zpFwALbJJC3W65D8XOQshA6SfI3V0NpHq2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRRlXpMINCGK7vX/p7XCfYUS4O6wmL9NqAuKC/d3PGbQdvEJIbtnoCDlP9eKtCl0JPukxGqydbouhvIYCik7zwe/jiV6OL/QWHEkxG0kVWTBV6E6vvJifCFy4MzLhX1Ltb8wBHW8R7AhjCsDGD/bBjvOw8kK8QixhvC/JETcv9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nftPDQcw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nftPDQcw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886871; x=1777422871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CbqfS32/zpFwALbJJC3W65D8XOQshA6SfI3V0NpHq2I=;
  b=nftPDQcwdCi7+legLEkZhVvs8W12UuYnqNa2AoJi99b6UJ+3vYl4eep6
   k/VFDJO7KoZ3LPGjpwTt20vx73ExIpM4zlsfdDVYZ+JF5JHCml2lPyLNp
   Jp4PW3z1ycPPNDklvjGlw5SvDhiNGnR9c3uZp/4Bz6BylSL769T2RRYRy
   dPI/0HViZxybLfM9etWSe72MpZyD/xjtFTv8XPeXU+VJp2prr9NqiiR4g
   UAG2CpmFxPLvWNhGoNgqorBFqDDB0MHuLmZvPuKVuxbJp/sCRTn7qUCnI
   Y+UdG4M/V6HA0BRW7zT1quy7lD40wcVI4QTtNCevGQ4Z//G+KCDUnxAST
   Q==;
X-CSE-ConnectionGUID: vf6V1c80TO2INgT7wlcTcA==
X-CSE-MsgGUID: kroj4UXTTY+nfo4tgyHTzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148299"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148299"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:23 -0700
X-CSE-ConnectionGUID: fxbYq1s9TZ6+Jii4BzZT+A==
X-CSE-MsgGUID: XXnqL8eWQ3+9g7ZicQ+i8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394077"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:23 -0700
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
Subject: [PATCH v4 27/31] x86/resctrl: Handle number of RMIDs supported by telemetry resources
Date: Mon, 28 Apr 2025 17:33:53 -0700
Message-ID: <20250429003359.375508-28-tony.luck@intel.com>
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

There are now three meanings for "number of RMIDs":

1) The number for legacy features enumerated by CPUID leaf 0xF. This
is the maximum number of distinct values that can be loaded into the
IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
will force scaling down the CPUID enumerated value by the number of SNC
nodes per L3-cache.

2) The number of registers in MMIO space for each event. This
is enumerated in the XML files and is the value placed into
event_group::num_rmids.

3) The number of "h/w counters" (this isn't a strictly accurate
description of how things work, but serves as a useful analogy that
does describe the limitations) feeding to those MMIO registers. This
is enumerated in telemetry_region::num_rmids returned from the call to
intel_pmt_get_regions_by_feature()

Event groups with insufficient "h/w counter" to track all RMIDs are
difficult for users to use, since the system may reassign "h/w counters"
as any time. This means that users cannot reliably collect two consecutive
event counts to compute the rate at which events are occurring.

Ignore such under-resourced event groups unless the user explicitly
requests to enable them using the "rdt=" Linux boot argument.

Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
resource "num_rmids" value to the smallest of these values to ensure
that all resctrl groups have equal monitor capabilities.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 25 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 92cbba9d82a8..31499bcd2065 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -18,6 +18,8 @@
 
 #define RMID_VAL_UNAVAIL		BIT_ULL(62)
 
+extern int rdt_num_system_rmids;
+
 /*
  * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
  * data to be returned. The counter width is discovered from the hardware
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index aacaedcc7b74..eec5eb625f13 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -14,6 +14,7 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/io.h>
+#include <linux/minmax.h>
 #include <linux/resctrl.h>
 
 /* Temporary - delete from final version */
@@ -51,6 +52,7 @@ struct pmt_event {
  * @pfg:		The pmt_feature_group for this event group
  * @name:		Name for this group
  * @guid:		Unique number per XML description file
+ * @num_rmids:		Number of RMIDS supported by this group
  * @mmio_size:		Number of bytes of mmio registers for this group
  * @pkginfo:		Per-package MMIO addresses
  * @num_events:		Number of events in this group
@@ -60,6 +62,7 @@ struct event_group {
 	struct pmt_feature_group	*pfg;
 	char				*name;
 	int				guid;
+	int				num_rmids;
 	int				mmio_size;
 	struct mmio_info		**pkginfo;
 	int				num_events;
@@ -70,6 +73,7 @@ struct event_group {
 static struct event_group energy_0x26696143 = {
 	.name		= "energy",
 	.guid		= 0x26696143,
+	.num_rmids	= 576,
 	.mmio_size	= (576 * 2 + 3) * 8,
 	.num_events	= 2,
 	.evts				= {
@@ -82,6 +86,7 @@ static struct event_group energy_0x26696143 = {
 static struct event_group perf_0x26557651 = {
 	.name		= "perf",
 	.guid		= 0x26557651,
+	.num_rmids	= 576,
 	.mmio_size	= (576 * 7 + 3) * 8,
 	.num_events	= 7,
 	.evts				= {
@@ -214,6 +219,15 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
 			if ((*peg)->guid == p->regions[i].guid) {
 				if (rdt_check_option((*peg)->name, false, true))
 					return false;
+				/*
+				 * Ignore event group with insufficient RMIDs unless the
+				 * user used the rdt= boot option to specifically ask
+				 * for it to be enabled.
+				 */
+				if (p->regions[i].num_rmids < rdt_num_system_rmids &&
+				    !rdt_check_option((*peg)->name, true, false))
+					return false;
+				(*peg)->num_rmids = p->regions[i].num_rmids;
 				ret = configure_events((*peg), p);
 				if (ret) {
 					(*peg)->pfg = no_free_ptr(p);
@@ -233,11 +247,22 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
  */
 bool intel_aet_get_events(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	struct event_group **eg;
 	bool ret1, ret2;
 
 	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
 	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
 
+	for (eg = &known_event_groups[0]; eg < &known_event_groups[NUM_KNOWN_GROUPS]; eg++) {
+		if (!(*eg)->pfg)
+			continue;
+		if (r->num_rmid)
+			r->num_rmid = min(r->num_rmid, (*eg)->num_rmids);
+		else
+			r->num_rmid = (*eg)->num_rmids;
+	}
+
 	return ret1 || ret2;
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 04214585824b..7e3a68058b90 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -32,6 +32,7 @@ bool rdt_mon_capable;
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
+int rdt_num_system_rmids;
 static int snc_nodes_per_l3_cache = 1;
 
 /*
@@ -354,6 +355,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
 	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
+	rdt_num_system_rmids = r->num_rmid;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
-- 
2.48.1

