Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E10A145354
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611801; cv=none; b=O2N3Q1M6uXjbFaOjea0fO49j42hMlgR79egJmRNrqfiowjhRs3jE74x9vZio6lcZzh8tjvHDyVxheY+w4eUlu6pgWbL4EWnTSlGWXCd8fdzIgqkXrv+iL32OYG8Wafg91BAl6bIxepxBHw7Wv9J3BVxN7EwYGsTaWUvpB4BeQ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611801; c=relaxed/simple;
	bh=vM+3tzSSnqnmtLQ7I5Kq1E3nWSgcu98rwL7vm2afEB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIUk6aXC0e4choiCpfcjeuQ/imEakzlwy6lBG3OzFC+TbMwBNP0nnQOe2PC8PW+JxV6Z7atwkfEuou+xSe+hK88vEqr37Cdw6cYTAHP+gjbMLeuIpbtgFQ1qel+s/mAbHXkrMFYAT4qncKj6AxsaEWz2YSfOuJjRTTDEIVn/FfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5dgGk4B; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5dgGk4B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611800; x=1751147800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vM+3tzSSnqnmtLQ7I5Kq1E3nWSgcu98rwL7vm2afEB0=;
  b=e5dgGk4BzA0SrBhJ057Ux4dCJ5a5Hfyk8IPw4dcj8XlZkRfN/gv1XTXa
   pDy1nMkMFURvgoGImc1bEP1A+jZqickZGNPoj436i2XSZcJ4V5XirzjKO
   +uJiUkR2PaQ/a+Rdoo3MTzEfKz2rqmeXN1IpUVdkeRZRkGFKcPVaFxuh1
   4IaSi1f8EM/YcNcRDBR4zhDm2JZUEJA+nMyK6+lNOmqnVqVHn7+JkyEkW
   N4RtrfUWTuvHABOoTpYhTXw+lj7HDuGtpu0KOyVeqPrfOSxJw6pT2C/h9
   YIvEPzJSCq2f862UqQxlP9hyjFVIm06Hgrd4prWMKAGYk0jz34zOAbzPk
   A==;
X-CSE-ConnectionGUID: kTbfuxYQSO2k330b54ASsw==
X-CSE-MsgGUID: EYS14mpQTEGZmOtzDl8Vzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16762649"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16762649"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
X-CSE-ConnectionGUID: sF9rm35ZSFKs+kWpC2pfSg==
X-CSE-MsgGUID: KNyP2hV6QsKe/rV0XLBPZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="68065687"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
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
Subject: [PATCH v23 18/19] x86/resctrl: Sub-NUMA Cluster (SNC) detection
Date: Fri, 28 Jun 2024 14:56:18 -0700
Message-ID: <20240628215619.76401-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628215619.76401-1-tony.luck@intel.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There isn't a simple hardware bit that indicates whether a CPU is
running in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing
the number of CPUs sharing the L3 cache with CPU0 to the number of CPUs in
the same NUMA node as CPU0.

If SNC mode is detected, print a single informational message to the
console.

Add the missing definition of pr_fmt() to monitor.c. This wasn't
noticed before as there are only "can't happen" console messages
from this file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 66 +++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 2d9b0bad678d..00e5c0e5424f 100644
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
@@ -1116,6 +1118,68 @@ void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
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
+ * number of CPUs sharing the L3 cache with CPU0 to the number of CPUs in
+ * the same NUMA node as CPU0.
+ * It is not possible to accurately determine SNC state if the system is
+ * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
+ * to L3 caches. It will be OK if system is booted with hyperthreading
+ * disabled (since this doesn't affect the ratio).
+ */
+static __init int snc_get_config(void)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(0, RESCTRL_L3_CACHE);
+	const cpumask_t *node0_cpumask;
+	int cpus_per_node, cpus_per_l3;
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
+	cpus_per_node = cpumask_weight(node0_cpumask);
+	cpus_per_l3 = cpumask_weight(&ci->shared_cpu_map);
+
+	if (!cpus_per_node || !cpus_per_l3)
+		return 1;
+
+	ret = cpus_per_l3 / cpus_per_node;
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
@@ -1123,6 +1187,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	unsigned int threshold;
 	int ret;
 
+	snc_nodes_per_l3_cache = snc_get_config();
+
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
 	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
-- 
2.45.2

