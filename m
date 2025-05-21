Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5203C2475C7
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867875; cv=none; b=eFpM9GloV7d809MLeCRbsmafBtfw8+6mmJ2GxwgqPGG2YvvNELR7mYTppAaK0C/WbYANiWAq2s2mAoNyD/zOo19XIfII8+pUzDtS4HWaHVuuO7SDs0KCvo3iI4l3Joe1FmoAMdZ5J59x5DG3xe3xlMskWRHmOOJOvbUUHP9NnRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867875; c=relaxed/simple;
	bh=Tf5Vr/3BaV/jZLBI9TGK8FQ85PWBU2b3anQXN/sHg2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqJHhHcC1szuwmFaed9KfLhaiSQowbRMPHU1qLF547FR2XbWvkO2PCNuKiTVc6rVeVaO1LyQ2CT2VPIbZVjTm0SJexbzCiKt6qTDHWEzz7Pur1dkcbtqvOiGf8/y1t4QE26TdwkQXdKYbk6KugK12VrilPl+CnMyfnEuQtqPNvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZgH2Htha; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZgH2Htha"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867873; x=1779403873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tf5Vr/3BaV/jZLBI9TGK8FQ85PWBU2b3anQXN/sHg2Y=;
  b=ZgH2HthaxfkvFWVkbZuN8nnd+wTXEojhUQqPPFeaIQkk1cVm5x11d4cj
   jfj92LANh9jF12ejWt33KrvqELBlpgvSuw491kywjr/ZTqVZoumMMaIAt
   CmfQCDhFysIIXQnMKIMbAg1Q3YAoXdi3uwe05U/VFVRhI0fljWE2Lmtvk
   QD3ioPi09d+tLltiHyVGRcnzNFgYWxjyIJvonfDc3cVbPq/n8aYD6dt2/
   QS2NvVlVI5Z1XeQwVvIrWQSCfxhXSbSzxrpvv9lQ2zVFRlawfQfqQhrXk
   drEDd0ona6L/i0Ecsbkif0s3lyOM9w0r51lNBgOJFbPldnkddWSjCh/MP
   A==;
X-CSE-ConnectionGUID: 6wjMnXccSH6Q0qQ/i2LNgA==
X-CSE-MsgGUID: LkQR8YH5QliHSzSkTCwaCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677797"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677797"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: o3JN4+EvTXqaiZDMpvXi7A==
X-CSE-MsgGUID: DENlstCJROiZqDbPH5xF7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352203"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
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
Subject: [PATCH v5 26/29] x86,fs/resctrl: Move RMID initialization to first mount
Date: Wed, 21 May 2025 15:50:44 -0700
Message-ID: <20250521225049.132551-27-tony.luck@intel.com>
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

The resctrl file system code assumed that the only monitor events were
tied to the RDT_RESOURCE_L3 resource. Also that the number of supported
RMIDs was enumerated during early initialization.

RDT_RESOURCE_PERF_PKG breaks both of those assumptions.

Delay the final enumeration of the number of RMIDs and subsequent
allocation of structures until first mount of the resctrl file system.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h              |  4 ++-
 arch/x86/kernel/cpu/resctrl/core.c |  8 +++--
 fs/resctrl/monitor.c               | 58 +++++++++++++-----------------
 fs/resctrl/rdtgroup.c              | 12 +++++--
 4 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 64c1c226d676..1f4800cfcd6a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -348,6 +348,8 @@ int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
 
+int resctrl_mon_dom_data_init(void);
+
 void resctrl_mon_resource_exit(void);
 
 void mon_event_count(void *info);
@@ -358,7 +360,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
-int resctrl_mon_resource_init(void);
+void resctrl_mon_l3_resource_init(void);
 
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b23309566500..8a9ceb03e252 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -111,10 +111,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 num_rmids = U32_MAX;
+	struct rdt_resource *r;
+
+	for_each_mon_capable_rdt_resource(r)
+		num_rmids = min(num_rmids, r->num_rmid);
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->num_rmid;
+	return num_rmids;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index f24a568f7b67..6041cb304624 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -775,15 +775,27 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
 }
 
-static int dom_data_init(struct rdt_resource *r)
+/*
+ * resctrl_dom_data_init() - Initialise global monitoring structures.
+ *
+ * Allocate and initialise global monitor resources that do not belong to a
+ * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
+ * Called once during boot after the struct rdt_resource's have been configured
+ * but before the filesystem is mounted.
+ * Resctrl's cpuhp callbacks may be called before this point to bring a domain
+ * online.
+ *
+ * Returns 0 for success, or -ENOMEM.
+ */
+int resctrl_mon_dom_data_init(void)
 {
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	u32 num_closid = resctrl_arch_get_num_closid(r);
 	struct rmid_entry *entry = NULL;
-	int err = 0, i;
 	u32 idx;
+	int i;
 
-	mutex_lock(&rdtgroup_mutex);
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
 		u32 *tmp;
 
@@ -794,10 +806,8 @@ static int dom_data_init(struct rdt_resource *r)
 		 * use.
 		 */
 		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
-		if (!tmp) {
-			err = -ENOMEM;
-			goto out_unlock;
-		}
+		if (!tmp)
+			return -ENOMEM;
 
 		closid_num_dirty_rmid = tmp;
 	}
@@ -808,8 +818,7 @@ static int dom_data_init(struct rdt_resource *r)
 			kfree(closid_num_dirty_rmid);
 			closid_num_dirty_rmid = NULL;
 		}
-		err = -ENOMEM;
-		goto out_unlock;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < idx_limit; i++) {
@@ -830,13 +839,10 @@ static int dom_data_init(struct rdt_resource *r)
 	entry = __rmid_entry(idx);
 	list_del(&entry->list);
 
-out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-
-	return err;
+	return 0;
 }
 
-static void dom_data_exit(struct rdt_resource *r)
+static void resctrl_mon_dom_data_exit(struct rdt_resource *r)
 {
 	mutex_lock(&rdtgroup_mutex);
 
@@ -943,28 +949,14 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id evtid)
 }
 
 /**
- * resctrl_mon_resource_init() - Initialise global monitoring structures.
- *
- * Allocate and initialise global monitor resources that do not belong to a
- * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
- * Called once during boot after the struct rdt_resource's have been configured
- * but before the filesystem is mounted.
- * Resctrl's cpuhp callbacks may be called before this point to bring a domain
- * online.
- *
- * Returns 0 for success, or -ENOMEM.
+ * resctrl_mon_l3_resource_init() - Initialise L3 configuration options.
  */
-int resctrl_mon_resource_init(void)
+void resctrl_mon_l3_resource_init(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	int ret;
 
 	if (!r->mon_capable)
-		return 0;
-
-	ret = dom_data_init(r);
-	if (ret)
-		return ret;
+		return;
 
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
@@ -981,13 +973,11 @@ int resctrl_mon_resource_init(void)
 		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
 	else if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
 		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
-
-	return 0;
 }
 
 void resctrl_mon_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
-	dom_data_exit(r);
+	resctrl_mon_dom_data_exit(r);
 }
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 6078cdd5cad0..e212e46e0780 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2583,6 +2583,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	unsigned long flags = RFTYPE_CTRL_BASE;
 	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
+	static bool once;
 	int ret;
 
 	resctrl_arch_pre_mount();
@@ -2597,6 +2598,13 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	if (resctrl_arch_mon_capable() && !once) {
+		ret = resctrl_mon_dom_data_init();
+		if (ret)
+			goto out;
+		once = true;
+	}
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
@@ -4290,9 +4298,7 @@ int resctrl_init(void)
 
 	thread_throttle_mode_init();
 
-	ret = resctrl_mon_resource_init();
-	if (ret)
-		return ret;
+	resctrl_mon_l3_resource_init();
 
 	ret = sysfs_create_mount_point(fs_kobj, "resctrl");
 	if (ret) {
-- 
2.49.0

