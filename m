Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0F714387A
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934830; cv=none; b=MIXZvQz8yBfiUbcEcQRl1H/EMekWFTYidvYYV4x7maTDvikGBWOm3PgY4n2gSAjJ3r07+9lKk4I4r6u8aTsuNYEDnb+UTwRcM5Wsu2HNkEDM1X/ssvHvkEqTv+ZiJsaHeBVxQW/ohhD5IhJqoIOhCls78yF/tKHukllYIh86zhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934830; c=relaxed/simple;
	bh=U/FAikBS3HIFP4hXSxgNs+s+WZEIA9TL/WVzdp6SVyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXt4wyw34mQdJ0AIoe+f4UJ1qU2ULyx/2hEXBWnMbKqngngaYv+/vDyoGbsVdj7qFyh9PwLqWDAyNK7skCVOf5J7+jhzqQsncVL3Z4dQ9aUGgHyAZ71X5ErU+z2YRGraPvEVXS/9NejkB+IFqIgR58vjEKxZQcR5FtEtlWm1KrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mkfOQ81r; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mkfOQ81r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934829; x=1748470829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U/FAikBS3HIFP4hXSxgNs+s+WZEIA9TL/WVzdp6SVyw=;
  b=mkfOQ81rvKaCPIN/l2BELx49qM59So+FlXHON2A0IzZ1/nR4x7NHVlq2
   nAY8zH3qH/0K8K6AjZbRvYXizhfKU96quj4lq06G1tui6K0+O3UQGHDly
   k0NnSVqVXt8BEXjmTKDOl+FB58UY10KKRmdz0XCYl0T5kv5sIWwCq+Ypm
   sFAeJsddv0o5evyxjiRoTvn+Mt/1Gl3y88tz2w6qEaqfgDqDOIVboxnqu
   8Twq6wmOfmVxvi9oCmP8Yh2NA7Wtw/GTNE3uEk/TbEYL0rwKPKqNNkGSV
   UGRHSdbq2vFiEPepkRpH42FhOoUi5JXcqtTPCW/yJVmWADK2OwzoNXhJS
   Q==;
X-CSE-ConnectionGUID: +w9BUnuFT/6AfTv0Ry801Q==
X-CSE-MsgGUID: mVHOuP6QR36QNX63GXke8Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812269"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812269"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:20 -0700
X-CSE-ConnectionGUID: cy0GYZ9QRe61jPOC1hVxbg==
X-CSE-MsgGUID: 3spDZ/YyScyOBcsfGegt8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090788"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:20 -0700
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
Subject: [PATCH v19 19/20] x86/resctrl: Sub-NUMA Cluster (SNC) detection and enabling
Date: Tue, 28 May 2024 15:20:04 -0700
Message-ID: <20240528222006.58283-20-tony.luck@intel.com>
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

There isn't a simple hardware bit that indicates whether a CPU is
running in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing
number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
the same NUMA node as CPU0.

If SNC mode is detected, print a single informational message to the
console.

Add the missing definition of pr_fmt() to monitor.c. This wasn't
noticed before as there are only "can't happen" console messages
from this file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 59 +++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c7559735e33a..1c5162a68461 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -15,6 +15,8 @@
  * Software Developer Manual June 2016, volume 3, section 17.17.
  */
 
+#define pr_fmt(fmt)	"resctrl: " fmt
+
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -1095,6 +1097,61 @@ void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
 	wrmsrl(MSR_RMID_SNC_CONFIG, val);
 }
 
+/* CPU models that support MSR_RMID_SNC_CONFIG */
+static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
+	X86_MATCH_VFM(INTEL_ICELAKE_X, 0),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, 0),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X, 0),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X, 0),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X, 0),
+	{}
+};
+
+/*
+ * There isn't a simple hardware bit that indicates whether a CPU is running
+ * in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing the
+ * number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
+ * the same NUMA node as CPU0.
+ * It is not possible to accurately determine SNC state if the system is
+ * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
+ * to L3 caches. It will be OK if system is booted with hyperthreading
+ * disabled (since this doesn't affect the ratio).
+ */
+static __init int snc_get_config(void)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(0, RESCTRL_L3_CACHE);
+	const cpumask_t	*node0_cpumask;
+	int ret;
+
+	if (!x86_match_cpu(snc_cpu_ids) || !ci)
+		return 1;
+
+	cpus_read_lock();
+	if (num_online_cpus() != num_present_cpus())
+		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
+	cpus_read_unlock();
+
+	node0_cpumask = cpumask_of_node(cpu_to_node(0));
+
+	ret = cpumask_weight(&ci->shared_cpu_map) / cpumask_weight(node0_cpumask);
+
+	/* sanity check: Only valid results are 1, 2, 3, 4 */
+	switch (ret) {
+	case 1:
+		break;
+	case 2 ... 4:
+		pr_info("Sub-NUMA Cluster mode detected with %d nodes per L3 cache\n", ret);
+		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_L3_NODE;
+		break;
+	default:
+		pr_warn("Ignore improbable SNC node count %d\n", ret);
+		ret = 1;
+		break;
+	}
+
+	return ret;
+}
+
 int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
@@ -1102,6 +1159,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	unsigned int threshold;
 	int ret;
 
+	snc_nodes_per_l3_cache = snc_get_config();
+
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
 	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
-- 
2.45.0

