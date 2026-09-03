Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393E4EA37A
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454643; cv=none; b=bBomwbFFoIqyjjw6l0iVsOJXgraBZoC8oRLKNykxfewf5zUS+J/rPUn2niw3lRvkjL+qUYFpkR0ZWenzft6twlJWfLnJ71HhUxuJX9NjNScbZehNmNJguA1othQy7D7Bxeucey//9z+yjFyC52rjK8Dma3nyPwoyIRPZJreJomQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454643; c=relaxed/simple;
	bh=dM/MsDp/E2+2zD4gGKazTa3hI3cKZgdFwZlWuhra2Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehSwXluHzDbLkcIofee1qRlOgFEWb0c6QjfN6evhNFuplVDCyvukwi87donKAO4hh83MEi63MylzZap/prB8pFr61eDpVO1NJKRQ+t1rj68ePSK6BjMAnUsoXCmJyBFKUetXDiHPIsQLgszWlvdWDoKnY/J9n6HMDn2GKoS80fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UsNEnYaf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UsNEnYaf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788454641; x=1819990641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dM/MsDp/E2+2zD4gGKazTa3hI3cKZgdFwZlWuhra2Kg=;
  b=UsNEnYafbqF0nYAlt3oVOWT3hq2Vgl1wM0CkdHHlUD90VFzJw/yXCryi
   yVU83MRp5sQ6OYZ/4QLRqhsV7kBMrUvmFdvMq6ft+CpxG3RcSP0J1oSTg
   nKwziqghyFgbSnoEZvfRSxEt9oFup1Fkk+ctkZAHYNFcgS4Vtl4oxJw9v
   m7UuKBx7pJu14cdv1zFIfSk8Yv4AJ5Afi10pdVb+CWPketeIAqnJzzxLA
   CUVuBDU4Adba1gwi+fN7sVtyTBdixxuoZmLy9Nwjj9TtDSOyoV7o2lzWJ
   rFzuXuAyEFcuVByXT4zlLXXSS9C/LwXWULOxahtrqax5ieyHmVIsEfp5T
   w==;
X-CSE-ConnectionGUID: 5dU7T79GTBu7KgcFSHkEMw==
X-CSE-MsgGUID: MtDveBwYTaO/JC3AIofnRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100103990"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="100103990"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:14 -0700
X-CSE-ConnectionGUID: zqmVtFvfTkWnKu87AMFezg==
X-CSE-MsgGUID: LhXV8K6pRb2px4qayvOo1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="273554220"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:13 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH 3/5] x86,fs/resctrl: Make MSR_IA32_L{2,3}_QOS_CFG scope architecture specific
Date: Thu,  3 Sep 2026 09:57:05 -0700
Message-ID: <523b1b373a4cf579231c346502c61762b3cb7fb9.1788452481.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788452481.git.reinette.chatre@intel.com>
References: <cover.1788452481.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The architecture specific cache bitmap control property
resctrl_cache::arch_has_per_cpu_cfg reflects whether the x86 cache
configuration registers MSR_IA32_L{2,3}_QOS_CFG have scope that is per-CPU
or matches the associated cache. This property is maintained, but never
used, by the resctrl filesystem.

Each cache resource only supports one control. In preparation for resources
supporting multiple controls it is no longer appropriate to place the x86
architecture cache resource property with the cache control properties
since that would result in the resource property being duplicated among
all its controls. Additionally, the scope of the x86 MSR_IA32_L{2,3}_QOS_CFG
registers is x86 architecture specific - the resctrl filesystem does not
use it at all and should therefore not need to maintain it.

Make the scope of MSR_IA32_L{2,3}_QOS_CFG an x86 hardware resource
specific property with a direct name of qos_cfg_has_cpu_scope.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v1:
- Remove stray ";" in kernel-doc comment.

Changes since RFC v2:
- Rewrite changelog, shorten subject.
- Rework comment instead of copy&paste the original.
- Rename property to be more specific now that it does not need to aim
  for generic resctrl filesystem support.
---
 arch/x86/kernel/cpu/resctrl/core.c     | 7 ++++---
 arch/x86/kernel/cpu/resctrl/internal.h | 3 +++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
 include/linux/resctrl.h                | 3 ---
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0e34a1c541b9..a251ba657ab7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -441,6 +441,7 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 
 static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 {
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	int id = get_domain_id_from_scope(cpu, r->ctrl_scope);
 	struct rdt_hw_ctrl_domain *hw_dom;
 	struct list_head *add_pos = NULL;
@@ -463,7 +464,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
 		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-		if (r->cache.arch_has_per_cpu_cfg)
+		if (hw_res->qos_cfg_has_cpu_scope)
 			rdt_domain_reconfigure_cdp(r);
 		return;
 	}
@@ -998,7 +999,7 @@ static __init void rdt_init_res_defs_intel(void)
 
 		if (r->rid == RDT_RESOURCE_L3 ||
 		    r->rid == RDT_RESOURCE_L2) {
-			r->cache.arch_has_per_cpu_cfg = false;
+			hw_res->qos_cfg_has_cpu_scope = false;
 			r->cache.min_cbm_bits = 1;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_THRTL_BASE;
@@ -1017,8 +1018,8 @@ static __init void rdt_init_res_defs_amd(void)
 
 		if (r->rid == RDT_RESOURCE_L3 ||
 		    r->rid == RDT_RESOURCE_L2) {
+			hw_res->qos_cfg_has_cpu_scope = true;
 			r->cache.arch_has_sparse_bitmasks = true;
-			r->cache.arch_has_per_cpu_cfg = true;
 			r->cache.min_cbm_bits = 0;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..861151f008fa 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -125,6 +125,8 @@ struct msr_param {
  * @mon_scale:		cqm counter * mon_scale = occupancy in bytes
  * @mbm_width:		Monitor width, to detect and correct for overflow.
  * @cdp_enabled:	CDP state of this resource
+ * @qos_cfg_has_cpu_scope:	True if MSR_IA32_L{2,3}_QOS_CFG has CPU scope,
+ *				false if the scope matches the associated cache.
  * @mbm_cntr_assign_enabled:	ABMC feature is enabled
  * @sdciae_enabled:	SDCIAE feature (backing "io_alloc") is enabled.
  *
@@ -140,6 +142,7 @@ struct rdt_hw_resource {
 	unsigned int		mon_scale;
 	unsigned int		mbm_width;
 	bool			cdp_enabled;
+	bool			qos_cfg_has_cpu_scope;
 	bool			mbm_cntr_assign_enabled;
 	bool			sdciae_enabled;
 };
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5ffa39fa86fa..6e4eeccd4891 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -131,6 +131,7 @@ static void l2_qos_cfg_update(void *arg)
 
 static int set_cache_qos_cfg(int level, bool enable)
 {
+	struct rdt_hw_resource *hw_res;
 	void (*update)(void *arg);
 	struct rdt_ctrl_domain *d;
 	struct rdt_resource *r_l;
@@ -151,8 +152,9 @@ static int set_cache_qos_cfg(int level, bool enable)
 		return -ENOMEM;
 
 	r_l = &rdt_resources_all[level].r_resctrl;
+	hw_res = resctrl_to_arch_res(r_l);
 	list_for_each_entry_rcu(d, &r_l->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
-		if (r_l->cache.arch_has_per_cpu_cfg)
+		if (hw_res->qos_cfg_has_cpu_scope)
 			/* Pick all the CPUs in the domain instance */
 			for_each_cpu(cpu, &d->hdr.cpu_mask)
 				cpumask_set_cpu(cpu, cpu_mask);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 66dc9813c888..b6b4519a5190 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -215,8 +215,6 @@ struct rdt_l3_mon_domain {
  * @shareable_bits:	Bitmask of shareable resource with other
  *			executing entities
  * @arch_has_sparse_bitmasks:	True if a bitmask like f00f is valid.
- * @arch_has_per_cpu_cfg:	True if QOS_CFG register for this cache
- *				level has CPU scope.
  * @io_alloc_capable:	True if portion of the cache can be configured
  *			for I/O traffic.
  */
@@ -225,7 +223,6 @@ struct resctrl_cache {
 	unsigned int	min_cbm_bits;
 	unsigned int	shareable_bits;
 	bool		arch_has_sparse_bitmasks;
-	bool		arch_has_per_cpu_cfg;
 	bool		io_alloc_capable;
 };
 
-- 
2.55.0

