Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7371BF323
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941915; cv=none; b=HnU+5JXMewhDQjIDKhS2amYE3FYQL2dJ4rdOgF23p68yRLe5ViuQUUZsHFTskQNuZI7WskI6gpzlcu6wxkSgJwSHn7q7hL4TFrHAteb2QhmZt3HjSs26v8R4FpHvbgfFLeAazRypLGWHXohhQFVw3/wRqRSCi7T1qlVetVCN+og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941915; c=relaxed/simple;
	bh=8K66SPJ02TBdZrgo9xAqznHP69oXc5WaQk2Cg8Tgt2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaJsN5MCvQtW8RLLrIYZ2aANl+X31X/z8vZfIpEzWuD2tdEfG/s1y+xQmAgHbrHcsu5q8BHO/1IyzoFsSvdETmDmuyFWbwif6dSnDEAks+22AdVIF1cdF5B3dFiGmWYbv2C/Sssy91RHdnDcJCbbU1bSyAvPbTDTLyzkj2spFRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oIj9rdPa; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oIj9rdPa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719941911; x=1751477911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8K66SPJ02TBdZrgo9xAqznHP69oXc5WaQk2Cg8Tgt2k=;
  b=oIj9rdPar8lgR2r1fL65jFJrAuYJ92g2rSnT0aGKty86aSRxPYztqV54
   F/Rh79bRgM0f0+UheO/au6gQjgzKe+/7YyB+A8AhIKbooICiCRfY4GmBG
   Gi7Q4HA90MQNBMv3QtARGv0If+pJGSyWtbsFEByxU9PMDUx3NZ/6Ox2bV
   tYL+OHFeRqw+s1rmDzbAnmUJ+B0maRMif4mTQGkW8mlwF728WOoSX3chs
   rXknE3owEeVOM5dEH8MI7fTmtE8xzCI7VXgDr9xWoLgODwXkDnGcpM8Kx
   QNmhcCrxI3zXB1Ecbe0P8eirbUbQvCmBc9dwYqUAiLklYDhDTV7o0m+Qf
   g==;
X-CSE-ConnectionGUID: kytFOD9GSjmKlEhnj6HLrg==
X-CSE-MsgGUID: tkXxAXW+TlKlKTI/rAvCdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="20035393"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="20035393"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 10:38:28 -0700
X-CSE-ConnectionGUID: holEedPlRVey0pq+jMBbsw==
X-CSE-MsgGUID: nDz1Uc2vToeob781E03FVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="45836600"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 10:38:27 -0700
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
Subject: [PATCH 17/19] x86/resctrl: Enable shared RMID mode on Sub-NUMA Cluster (SNC) systems
Date: Tue,  2 Jul 2024 10:38:20 -0700
Message-ID: <20240702173820.90368-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702173820.90368-1-tony.luck@intel.com>
References: <20240702173820.90368-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hardware has two RMID configuration options for SNC systems. The default
mode divides RMID counters between SNC nodes. E.g. with 200 RMIDs and
two SNC nodes per L3 cache RMIDs 0..99 are used on node 0, and 100..199
on node 1. This isn't compatible with Linux resctrl usage. On this
example system a process using RMID 5 would only update monitor counters
while running on SNC node 0.

The other mode is "RMID Sharing Mode". This is enabled by clearing bit
0 of the RMID_SNC_CONFIG (0xCA0) model specific register. In this mode
the number of logical RMIDs is the number of physical RMIDs (from CPUID
leaf 0xF) divided by the number of SNC nodes per L3 cache instance. A
process can use the same RMID across different SNC nodes.

See the "Intel Resource Director Technology Architecture Specification"
for additional details.

When SNC is enabled, update the MSR when a monitor domain is marked
online. Technically this is overkill. It only needs to be done once
per L3 cache instance rather than per SNC domain. But there is no harm
in doing it more than once, and this is not in a critical path.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/include/asm/msr-index.h       |  1 +
 arch/x86/kernel/cpu/resctrl/internal.h |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c     |  2 ++
 arch/x86/kernel/cpu/resctrl/monitor.c  | 20 ++++++++++++++++++++
 4 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e022e6eb766c..3cb8dd6311c3 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1164,6 +1164,7 @@
 #define MSR_IA32_QM_CTR			0xc8e
 #define MSR_IA32_PQR_ASSOC		0xc8f
 #define MSR_IA32_L3_CBM_BASE		0xc90
+#define MSR_RMID_SNC_CONFIG		0xca0
 #define MSR_IA32_L2_CBM_BASE		0xd10
 #define MSR_IA32_MBA_THRTL_BASE		0xd50
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 16982d1baf99..955999aecfca 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -534,6 +534,8 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
 
 int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
 
+void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
+
 /*
  * To return the common struct rdt_resource, which is contained in struct
  * rdt_hw_resource, walk the resctrl member of struct rdt_hw_resource.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 95ef8fe3cb50..1930fce9dfe9 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -615,6 +615,8 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	}
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
+	arch_mon_domain_online(r, d);
+
 	if (arch_domain_mbm_alloc(r->num_rmid, hw_dom)) {
 		mon_domain_free(hw_dom);
 		return;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ca486d00541e..16b7bf5a048d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -1090,6 +1090,26 @@ static void l3_mon_evt_init(struct rdt_resource *r)
 		list_add_tail(&mbm_local_event.list, &r->evt_list);
 }
 
+/*
+ * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
+ * which indicates that RMIDs are configured in legacy mode.
+ * This mode is incompatible with Linux resctrl semantics
+ * as RMIDs are partitioned between SNC nodes, which requires
+ * a user to know which RMID is allocated to a task.
+ * Clearing bit 0 reconfigures the RMID counters for use
+ * in RMID sharing mode. This mode is better for Linux.
+ * The RMID space is divided between all SNC nodes with the
+ * RMIDs renumbered to start from zero in each node when
+ * counting operations from tasks. Code to read the counters
+ * must adjust RMID counter numbers based on SNC node. See
+ * logical_rmid_to_physical_rmid() for code that does this.
+ */
+void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
+{
+	if (snc_nodes_per_l3_cache > 1)
+		msr_clear_bit(MSR_RMID_SNC_CONFIG, 0);
+}
+
 int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
-- 
2.45.2

