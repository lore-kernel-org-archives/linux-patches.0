Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0943123BCE2
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867863; cv=none; b=oS+2JtC45XVbQ/iGxwvXv1lSQV3FNtJ7EjYkmvRAmRpgaI7WrHgDc8tJhEEW+OwZPwmomO3eiPFI6PmZJ13pR7HNCP4uTunoATzOjwJD8ho6SHEkTyB8nTMJKoIjPNiYreYt4xtHL3IcorG4W5vnp5X6KXqmPIylh+ufhL6EhHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867863; c=relaxed/simple;
	bh=bxm0GFpFfi1yDG0odbhafAGnb4KiXJUTK0G7cRb0SGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQbFgC6l0wb0fIjcNOxbdVosm38P4JocOl/w/H+2/Z4rEW/EQ4rDfNylfPRkq6ypiDG5zNXrK8c6sdY/KUsmx10897DVXuokcz0ycq/No4Eio67/S/7XhRoxLo4+NQJd1OtymafmaJ1k2WtlBMPlR8acs/1v0S0aT1J1ZNWOOPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cV0yFdBZ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cV0yFdBZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867862; x=1779403862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bxm0GFpFfi1yDG0odbhafAGnb4KiXJUTK0G7cRb0SGA=;
  b=cV0yFdBZzgVm2TROpkDMOYVuzy33pjzqVTeTrWapQt+JXq8w+/hdJC5U
   valKgYW9ddVtESG5QGAVhrImaIP9oTRM8zgo2mmjcA0uT3ByPGZ4aVbUB
   8u1mCzs79crgPkW/ejF06WwisEW7kXIahdEoXa6W4/xOSQZHT7QVYd9TU
   aDwq8gJf2qviFTY9qRgYiO8uXwuR60beNkMlOURSiFIlF9EwuofEH37+z
   os9l2Fedu2Nn51D+zrd8aHaUXF9Xs5FARk4OCjNdKw9FmIj+5BtD84Fp7
   111IoYAiqGrfoPMMh3NilKh+2+aYjQNHjsX3zYtsv+lsQKW42sCT+Trhn
   A==;
X-CSE-ConnectionGUID: doeCm51DTAaIcfCTwuTH8A==
X-CSE-MsgGUID: +OGIIx87QRe7rZyr0nqsEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677674"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677674"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:57 -0700
X-CSE-ConnectionGUID: I/VhpvHjQwqhGato0zTXTw==
X-CSE-MsgGUID: Ppc3bJ/dTDO/R3A+SUx5cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352141"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:57 -0700
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
Subject: [PATCH v5 07/29] x86,fs/resctrl: Rename some L3 specific functions
Date: Wed, 21 May 2025 15:50:25 -0700
Message-ID: <20250521225049.132551-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All monitor events used to be connected to the L3 resource so
it was OK for function names to be generic. But this will cause
confusion with additional events tied to other resources.

Rename functions that are only used for L3 features:

arch_mon_domain_online()	-> arch_l3_mon_domain_online()
mon_domain_free()		-> l3_mon_domain_free()
domain_setup_mon_state()	-> domain_setup_l3_mon_state

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c     | 12 ++++++------
 arch/x86/kernel/cpu/resctrl/monitor.c  |  2 +-
 fs/resctrl/rdtgroup.c                  |  6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index ea185b4d0d59..038c888dcdcf 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -122,7 +122,7 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
 
 extern struct rdt_hw_resource rdt_resources_all[];
 
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
+void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
 union cpuid_0x10_1_eax {
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 4983f6f81218..c721d1712e97 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -362,7 +362,7 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 	kfree(hw_dom);
 }
 
-static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
+static void l3_mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
 {
 	for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++)
 		kfree(hw_dom->arch_mbm_states[i]);
@@ -531,15 +531,15 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d->ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!d->ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 		return;
 	}
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
-	arch_mon_domain_online(r, d);
+	arch_l3_mon_domain_online(r, d);
 
 	if (arch_domain_mbm_alloc(r->num_rmid, hw_dom)) {
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 		return;
 	}
 
@@ -549,7 +549,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 	}
 }
 
@@ -640,7 +640,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		resctrl_offline_mon_domain(r, d);
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 85526e5540f2..659265330783 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -264,7 +264,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
  * must adjust RMID counter numbers based on SNC node. See
  * logical_rmid_to_physical_rmid() for code that does this.
  */
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
+void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	if (snc_nodes_per_l3_cache > 1)
 		msr_clear_bit(MSR_RMID_SNC_CONFIG, 0);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8649b89d7bfd..8aa9a7e68a59 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4062,7 +4062,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 }
 
 /**
- * domain_setup_mon_state() -  Initialise domain monitoring structures.
+ * domain_setup_l3_mon_state() -  Initialise domain monitoring structures.
  * @r:	The resource for the newly online domain.
  * @d:	The newly online domain.
  *
@@ -4074,7 +4074,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
  *
  * Returns 0 for success, or -ENOMEM.
  */
-static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
+static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(struct mbm_state);
@@ -4129,7 +4129,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 
 	mutex_lock(&rdtgroup_mutex);
 
-	err = domain_setup_mon_state(r, d);
+	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
 
-- 
2.49.0

