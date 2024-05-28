Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8213E05E
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934821; cv=none; b=g146Xdd9jGw2OwrkxCqTpYStu8qwm22u8QML8575ve4xnnYB649RGP1eliAyPJlsktWCFRhQFMoe9p/TwjcoLQDH6GoHDYRpVjkZEjTxUujnNNCop4S0JJ7i/6hcPA9zipM6zU+5i1ro8CDX7EOxSe0o8kQ9X1kIwOlXW9pSyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934821; c=relaxed/simple;
	bh=gG4r96r2lntBDsHt+9wxOd7VjzgcPxv496sdhJQghAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGpBFxEdpZfqndDrJwnO05rbbSXRj2eJdcR7LSI6cUq0u/Q9I3jBCN7IISFN7MEjp/QTGVogtv7bLzhFPkXIoiX+G0kDb4qzzStqv4j7KekXUwgU6n6EJKIFuRsnMo+Qxi/uYtrQuIm8jGQ+5IbuqTZ6w8kUUnHZVNrKL9yvVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QczGyt+n; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QczGyt+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934820; x=1748470820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gG4r96r2lntBDsHt+9wxOd7VjzgcPxv496sdhJQghAY=;
  b=QczGyt+nMw0A9QHyll7sEaeEzMct4fXdm9FiXmWHqzrYBjmx6lLZx/+i
   S8ROHh8DjCAmtzoUhscNvcWQm0KF3g4wjPsjz3/96e9NUTLj0twT0GdnC
   kNrJ3uun6pJA2unYwUU2upcbBpQi/mA1c7z/uFL7qEa9JXUI0D/1oBmB0
   x8x2VQzxGR+w49c4Nw3DisAjJP8ngYcfYYcjlU7SE5+moan1lMhD7dSsd
   SiEd528Uln1cyLYiieSFwSBHG7ZPaBnFLUvII9DoBmBIEvJYuebCFQtyb
   YPo8aB8gMagz1BXVl4FbDI0aHGm7EH9uX0/bTVxpJp9RnnQw8P7d375x7
   g==;
X-CSE-ConnectionGUID: 3teplRgtTbCzqVFatQpc2A==
X-CSE-MsgGUID: eyrm7yHcRJivPQZEPfbG3g==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812175"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812175"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:17 -0700
X-CSE-ConnectionGUID: /SZ2HQi1T4O9BV/wX228hg==
X-CSE-MsgGUID: X7OhId77RWeXx0xELZWnyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090728"
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
Subject: [PATCH v19 06/20] x86/resctrl: Introduce snc_nodes_per_l3_cache
Date: Tue, 28 May 2024 15:19:51 -0700
Message-ID: <20240528222006.58283-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
and memory controllers on a socket into two or more groups. These are
presented to the operating system as NUMA nodes.

This may enable some workloads to have slightly lower latency to memory
as the memory controller(s) in an SNC node are electrically closer to the
CPU cores on that SNC node. This cost may be offset by lower bandwidth
since the memory accesses for each core can only be interleaved between
the memory controllers on the same SNC node.

Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
to track L3 cache occupancy and memory bandwidth. There is an MSR that
controls how the RMIDs are shared between SNC nodes.

The default mode divides them numerically. E.g. when there are two SNC
nodes on a socket the lower number half of the RMIDs are given to the
first node, the remainder to the second node. This would be difficult
to use with the Linux resctrl interface as specific RMID values assigned
to resctrl groups are not visible to users.

The other mode divides the RMIDs and renumbers the ones on the second
SNC node to start from zero.

Even with this renumbering SNC mode requires several changes in resctrl
behavior for correct operation.

Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
how many SNC domains share an L3 cache instance.  Initialize this to
"1". Runtime detection of SNC mode will adjust this value.

Update all places to take appropriate action when SNC mode is enabled:
1) The number of logical RMIDs per L3 cache available for use is the
   number of physical RMIDs divided by the number of SNC nodes.
2) Likewise the "mon_scale" value must be divided by the number of SNC
   nodes.
3) Add a function to convert from logical RMID values (assigned to
   tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
   to physical RMID values to load into IA32_QM_EVTSEL MSR when
   reading counters on each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 37 ++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 89d7e6fcbaa1..b9b4d2b5ca82 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
+static int snc_nodes_per_l3_cache = 1;
+
 /*
  * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
  * If rmid > rmid threshold, MBM total and local values should be multiplied
@@ -185,10 +187,37 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 	return entry;
 }
 
-static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
+/*
+ * When Sub-NUMA Cluster (SNC) mode is not enabled, the physical RMID
+ * is the same as the logical RMID.
+ *
+ * When SNC mode is enabled the physical RMIDs are distributed across
+ * the SNC nodes. E.g. with two SNC nodes per L3 cache and 200 physical
+ * RMIDs are divided with 0..99 on the first node and 100..199 on
+ * the second node. Compute the value of the physical RMID to pass to
+ * resctrl_arch_rmid_read().
+ *
+ * Caller is responsible to make sure execution running on a CPU in
+ * the domain to be read.
+ */
+static int logical_rmid_to_physical_rmid(int lrmid)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	int cpu = smp_processor_id();
+
+	if (snc_nodes_per_l3_cache  == 1)
+		return lrmid;
+
+	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
+}
+
+static int __rmid_read(u32 lrmid,
+		       enum resctrl_event_id eventid, u64 *val)
 {
 	u64 msr_val;
+	int prmid;
 
+	prmid = logical_rmid_to_physical_rmid(lrmid);
 	/*
 	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
 	 * with a valid event code for supported resource type and the bits
@@ -197,7 +226,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
 	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
 	 * are error bits.
 	 */
-	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
+	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
 	rdmsrl(MSR_IA32_QM_CTR, msr_val);
 
 	if (msr_val & RMID_VAL_ERROR)
@@ -1022,8 +1051,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	int ret;
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
-	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
-	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
+	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
+	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
-- 
2.45.0

