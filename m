Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C556936492C
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346087; cv=none; b=kClNviJPVZMvJmb8buQGVwpONV4YBxhdmLociPHxF+gLtUbH4X9JHJP0P1MAHtGW/z+K8wewLGL8ZAJ0uRaRBg/GJO0/6ZIL/lhUxT5zbCdZnIgq0rUgN0r7cJmx942LXOrNPqjusdwlRuVhqOht1GX4Rcs/qZvMxW1GaZn2ypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346087; c=relaxed/simple;
	bh=ZGHc5BTSkHGoInv2Eo87XVUR+pWrErpdqPgJWIkiYvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBEL4f/pAMh6/o7ecVKzaNYnbdJIXmuxwhL9QicQ4Mw2wlKDW/ql4UlK5Rama+K3D1ON72XaY0lZ3SWuSTI2c1MoZWVdX2s9tlqy8sh28PghubUGGnSofKOzXsZcAGXozjtmyFpMAumYkvhNyEHKo3SsVYJmPJJWu2mipABpCQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZvJbYJCu; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZvJbYJCu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346085; x=1816882085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZGHc5BTSkHGoInv2Eo87XVUR+pWrErpdqPgJWIkiYvA=;
  b=ZvJbYJCulY8OqeIJXsGLir8Ka7swm85ghvWT3Wfcl2j3TYaQkSGG8Vja
   v5eeQwka72VkfOR7K1z8a1beJQ8UqBDpk5d4kyxWpyMreSIk5QSWEtynH
   5x4609bniLucp2cJdV1S7gpnGDDePG4qdhkcq2zwo7PSlNzV9ajCWAuA+
   NlG8sdvsML92GEdn+JF3B5x/Nz95YEiyBv1bSxXCRRjHfpk+Zzo/yGFju
   ctyD3D4OVtE6BjUlnLfCMNyNKrCU/OMmdzrsH37XPo/bPkgqIVsawBD83
   fisW2e2IZSFBUAKojWHBM2PJsByGW4IYYgZUkDKQtk1g4hw9IyILEWUGR
   Q==;
X-CSE-ConnectionGUID: GahoAVdLTMWWnh+nmvuLxA==
X-CSE-MsgGUID: 8cSmom5hTyObISUC2Iue2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473601"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473601"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:01 -0700
X-CSE-ConnectionGUID: VZ5ujk5HRYOuNJgz5KoWqw==
X-CSE-MsgGUID: W9eBfxSfRJm6qhHJbRAJeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024573"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 06/17] x86/resctrl: Drop global 'rdt_mon_capable' flag
Date: Wed, 29 Jul 2026 10:27:41 -0700
Message-ID: <20260729172752.11561-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

File system code calls resctrl_arch_mon_capable() to determine if the
system supports any monitoring features.

x86 architecture code sets a global flag to support implementation of
resctrl_arch_mon_capable() but the upcoming change to enumerate AET
(Application Energy Telemetry) features on each mount introduces a new
corner case.

Specifically when AET is the only monitoring feature, loading and
unloading the pmt_telemetry module between resctrl mounts may result
in monitoring support enabled on some mounts, but not on others.

Replace the global flag with a scan of resources to check if any are
marked mon_capable.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	Move declaration of resctrl_arch_mon_capable() to <linux/resctrl.h>
	and provide kerneldoc comment on usage.

 include/linux/arm_mpam.h              |  1 -
 include/linux/resctrl.h               | 17 +++++++++++++++++
 arch/x86/include/asm/resctrl.h        |  6 ------
 arch/x86/kernel/cpu/resctrl/core.c    | 19 ++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------
 5 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index f92a36187a52..b6e8683657c0 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -51,7 +51,6 @@ static inline int mpam_ris_create(struct mpam_msc *msc, u8 ris_idx,
 #endif
 
 bool resctrl_arch_alloc_capable(void);
-bool resctrl_arch_mon_capable(void);
 
 void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
 void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index a184500745f8..59ddedb27539 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -419,6 +419,23 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
+/**
+ * resctrl_arch_mon_capable() - Report whether monitor events are enabled
+ *
+ * Some monitor events may be enumerated or implemented in loadable modules.
+ * This means that available events may vary from one mount of the resctrl
+ * file system to another. If modules are not loaded at mount time there
+ * may be no monitor events at all.
+ *
+ * File system code may call it during mount after architecture enumeration is
+ * complete. Calls during domain add/remove operations must check resctrl_mounted
+ * before calling.
+ *
+ * Return:
+ * true if any monitor events are enabled in the current mount cycle.
+ */
+bool resctrl_arch_mon_capable(void);
+
 /**
  * resctrl_enable_mon_event() - Enable monitoring event
  * @eventid:	ID of the event
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 575f8408a9e7..923b188e11a7 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -43,7 +43,6 @@ struct resctrl_pqr_state {
 DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
-extern bool rdt_mon_capable;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -66,11 +65,6 @@ static inline void resctrl_arch_disable_alloc(void)
 	static_branch_dec_cpuslocked(&rdt_enable_key);
 }
 
-static inline bool resctrl_arch_mon_capable(void)
-{
-	return rdt_mon_capable;
-}
-
 static inline void resctrl_arch_enable_mon(void)
 {
 	static_branch_enable_cpuslocked(&rdt_mon_enable_key);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index e3544c99cff1..fb20a31d8c73 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -51,6 +51,21 @@ DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
  */
 bool rdt_alloc_capable;
 
+/*
+ * Some monitor events depend on whether the module(s) that enumerate them
+ * are loaded. So resctrl must re-evaluate whether monitoring is supported
+ * for each mount.
+ */
+bool resctrl_arch_mon_capable(void)
+{
+	struct rdt_resource *r;
+
+	for_each_mon_capable_rdt_resource(r)
+		return true;
+
+	return false;
+}
+
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
 static void mba_wrmsr_amd(struct msr_param *m);
@@ -780,7 +795,6 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
-	rdt_mon_capable = true;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
@@ -1014,9 +1028,8 @@ static __init void check_quirks(void)
 static __init bool get_rdt_resources(void)
 {
 	rdt_alloc_capable = get_rdt_alloc_resources();
-	rdt_mon_capable = get_rdt_mon_resources();
 
-	return (rdt_mon_capable || rdt_alloc_capable);
+	return get_rdt_mon_resources() || rdt_alloc_capable;
 }
 
 static __init void rdt_init_res_defs_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 430b8fae0b77..1fea893f2cc1 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -26,12 +26,6 @@
 
 #include "internal.h"
 
-/*
- * Global boolean for rdt_monitor which is true if any
- * resource monitoring is enabled.
- */
-bool rdt_mon_capable;
-
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
-- 
2.55.0

