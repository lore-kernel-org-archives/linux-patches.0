Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D5C411FBE
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407221; cv=none; b=BS5Y1NB9lI1ihTyQTtQhYve2dHs09b6AwbqHBhGg3/UzMCEB34b754n9v4qPTi8g5JskjC+GtlJZIR45bxflJoi7wEdnTg3X1ReH/+XDSJwx+QkuBBQ2kGz/G8fPx5UttpEPbR3yyXt9XawjHV6j4ybxExS5II5Y8kQj4D4uLzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407221; c=relaxed/simple;
	bh=0e6cU2OQhRHhItQ9RF39pFteWYF7gZvw3RLLsx+K2RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeOpam5vp5AuE2Qpn0dHd1i7M04YE3bNGcYLPwJmDnZT81rt4i/jk5y43CKsOCMT14pjLSGLfu9LXq0w/sJp2efpF5xpioSgQx058xUpVffM//qEiUe3S/lCGRxSP2VCiBhM3k9xukwMohF9uMG0TQ2WoYdFVeCABdJWjueW/mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INA9u0D6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INA9u0D6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791407220; x=1822943220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0e6cU2OQhRHhItQ9RF39pFteWYF7gZvw3RLLsx+K2RA=;
  b=INA9u0D6JeQp4GpmrUMbRAqZtJzdur3VIjBZJDxdYkZU4fVLAB482V+F
   HXMMs1NKfLdtbemj4e7VpCueIIx5YTAmpZ+BPs3CyLvnBlR6DQGZ0O7/Z
   h7knwyWM5qCbye4frc/pSdDf/qzKs+6ReypLL1eBexiZn39KVaXLAdvyI
   VAkXHQY306J4nlorbMkNwSFausaMyghXV2iQD2Yi8YbhKFgnliU+U1Rw5
   bVCW19/0ZZH3vvOAQQ9z4VxP0ADsGPSttNEiLuGQYVLliEtxcpSW+PUUx
   f7zziArhX2XGp7e0cDN6dbwKLb/HW+fvGCuW0PzE6kdtIbOL10DyXMNeB
   Q==;
X-CSE-ConnectionGUID: NbTaexVUTcqkzZYf5No5DQ==
X-CSE-MsgGUID: gjQ/mBTDTgmJ+MVGdVW+aQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="289410"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="289410"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:57 -0700
X-CSE-ConnectionGUID: rAuF4s8qTpS/aflp+UvW1Q==
X-CSE-MsgGUID: t/An+oNnTxOxgcY3i32sMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="282359658"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:56 -0700
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
Subject: [PATCH v2 3/5] x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG scope property to x86 resource
Date: Wed,  7 Oct 2026 14:06:45 -0700
Message-ID: <c873c62e78f335df6f7b99cb0cf0ccbcdd62b09e.1791406459.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791406459.git.reinette.chatre@intel.com>
References: <cover.1791406459.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MSR_IA32_L{2,3}_QOS_CFG enable code and data prioritization on x86. On
Intel the registers have the scope of the associated cache while on AMD
they have CPU scope. The scope is recorded as a property of the cache
resource's control, of which each cache resource currently supports only
one.

The scope of MSR_IA32_L{2,3}_QOS_CFG is only relevant to x86. Even so, the
property is found among the resctrl filesystem's cache properties while only
x86 code sets and reads it. Keeping the property with the cache control
properties would also duplicate it across all controls of a resource when
resources support multiple controls.

Make the scope of MSR_IA32_L{2,3}_QOS_CFG a property of the x86 hardware
resource and name it for the registers it describes now that it no longer
needs to be generic.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v1:
- Remove stray ";" in kernel-doc comment.

Changes since RFC v2:
- Rewrite changelog, shorten subject.
- Rework comment instead of copy&paste the original.
- Rename property to be more specific now that it does not need to aim
  for generic resctrl filesystem support.

Changes since v1:
- Update kernel-doc to make clear property is only relevant to cache
  resources.
- Rewrite changelog.
---
 arch/x86/kernel/cpu/resctrl/core.c     | 7 ++++---
 arch/x86/kernel/cpu/resctrl/internal.h | 4 ++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
 include/linux/resctrl.h                | 3 ---
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f96f7cf255d0..e647c3aa065a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -444,6 +444,7 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 
 static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 {
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	int id = get_domain_id_from_scope(cpu, r->ctrl_scope);
 	struct rdt_hw_ctrl_domain *hw_dom;
 	struct list_head *add_pos = NULL;
@@ -466,7 +467,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
 		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-		if (r->cache.arch_has_per_cpu_cfg)
+		if (hw_res->qos_cfg_has_cpu_scope)
 			rdt_domain_reconfigure_cdp(r);
 		return;
 	}
@@ -1001,7 +1002,7 @@ static __init void rdt_init_res_defs_intel(void)
 
 		if (r->rid == RDT_RESOURCE_L3 ||
 		    r->rid == RDT_RESOURCE_L2) {
-			r->cache.arch_has_per_cpu_cfg = false;
+			hw_res->qos_cfg_has_cpu_scope = false;
 			r->cache.min_cbm_bits = 1;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_THRTL_BASE;
@@ -1020,8 +1021,8 @@ static __init void rdt_init_res_defs_amd(void)
 
 		if (r->rid == RDT_RESOURCE_L3 ||
 		    r->rid == RDT_RESOURCE_L2) {
+			hw_res->qos_cfg_has_cpu_scope = true;
 			r->cache.arch_has_sparse_bitmasks = true;
-			r->cache.arch_has_per_cpu_cfg = true;
 			r->cache.min_cbm_bits = 0;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..670ce9272b51 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -125,6 +125,9 @@ struct msr_param {
  * @mon_scale:		cqm counter * mon_scale = occupancy in bytes
  * @mbm_width:		Monitor width, to detect and correct for overflow.
  * @cdp_enabled:	CDP state of this resource
+ * @qos_cfg_has_cpu_scope:	Only for the L2 and L3 resources: true if
+ *				MSR_IA32_L{2,3}_QOS_CFG has CPU scope, false if
+ *				the scope matches the associated cache.
  * @mbm_cntr_assign_enabled:	ABMC feature is enabled
  * @sdciae_enabled:	SDCIAE feature (backing "io_alloc") is enabled.
  *
@@ -140,6 +143,7 @@ struct rdt_hw_resource {
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

