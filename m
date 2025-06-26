Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F7B2F2350
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956612; cv=none; b=fYffevuUPDL/xolxwHAByQB7tT7EmdoXICnImw7qcNwRsW92DoURgORjyDF2u95gvGYLcK3wxly8pH8LDvRY0J5tQCnOVwQOyGVLfJ2dDVjmXa0kk7V82ouLIju6glzVJrrDQYkbcWFUXrw5+X7X518+9xq7dTg+fUlYzVJEzbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956612; c=relaxed/simple;
	bh=wvxX+F+XYAUy0wo6y93K5TpM8depi18EH4ekmmc2YBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmEhawN61BCxs283n3k48aVTn+t6rZNC25QtQK4ToHmvr/oqrbzMnepOG8VG+w+s90zPaKHE/nzWr6o7L665RXHdmRzX0pcEpZsyAZc6BsFIMePtwfwjAOTFwdwnFsyJjXwszmoHFiQjFaDFM5Bj8frOGhJJwXdW0gbkKkk34qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CRAoFzTl; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CRAoFzTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956611; x=1782492611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wvxX+F+XYAUy0wo6y93K5TpM8depi18EH4ekmmc2YBk=;
  b=CRAoFzTlHBPEe5AN24n4UaqOGcEwZL0+IH4V90hNiJ+l+TwqE9QeX8U3
   NJmE74kFKHyF128Ec7TSjlchVThYyzrnFewMLWAsdNFc+P/t/tfNxR0yF
   GCyCbKhgnVQk7v6JtkzXLBWK+EC/MuUG5jpZWTKMrzcB65kQU5At/fPKp
   noK7dG0JFyP7+eLbV35qa3b0FD1vBXwklOyALGH1p3lGBiOW2LvtFRiOF
   vtpMn5greqOr1MXyLDLv3Uunw/Xwy3H5s00cEgHYfm1AKKJvLsz0nKVTz
   ubFkvPs9oCr/Cijqa5swal4OkzWjflCsIp882qSYseSfpU3SILoR59TYm
   Q==;
X-CSE-ConnectionGUID: kwcVIBoyQ3umy+tv7KxbvQ==
X-CSE-MsgGUID: ayzR/PJZT46V4A2kQw0E8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136528"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136528"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:03 -0700
X-CSE-ConnectionGUID: r2iYyyKzS6eMtpI/v78DNQ==
X-CSE-MsgGUID: Q+E/K46uRdGQHgEHmhXKWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069335"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:02 -0700
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
Subject: [PATCH v6 26/30] x86,fs/resctrl: Move RMID initialization to first mount
Date: Thu, 26 Jun 2025 09:49:35 -0700
Message-ID: <20250626164941.106341-27-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
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
index 2126006075f3..4704ea7228ca 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -354,6 +354,8 @@ int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
 
+int resctrl_mon_dom_data_init(void);
+
 void resctrl_mon_resource_exit(void);
 
 void mon_event_count(void *info);
@@ -364,7 +366,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
-int resctrl_mon_resource_init(void);
+void resctrl_mon_l3_resource_init(void);
 
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7fe4e8111773..50de0c29704f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -112,10 +112,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 
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
index c4b092aec9f8..e877f5b97d18 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -796,15 +796,27 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
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
 
@@ -815,10 +827,8 @@ static int dom_data_init(struct rdt_resource *r)
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
@@ -829,8 +839,7 @@ static int dom_data_init(struct rdt_resource *r)
 			kfree(closid_num_dirty_rmid);
 			closid_num_dirty_rmid = NULL;
 		}
-		err = -ENOMEM;
-		goto out_unlock;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < idx_limit; i++) {
@@ -851,13 +860,10 @@ static int dom_data_init(struct rdt_resource *r)
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
 
@@ -932,28 +938,14 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
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
@@ -970,13 +962,11 @@ int resctrl_mon_resource_init(void)
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
index d9bb01edd582..3d87e6c4c600 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2585,6 +2585,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	unsigned long flags = RFTYPE_CTRL_BASE;
 	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
+	static bool once;
 	int ret;
 
 	resctrl_arch_pre_mount();
@@ -2599,6 +2600,13 @@ static int rdt_get_tree(struct fs_context *fc)
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
@@ -4298,9 +4306,7 @@ int resctrl_init(void)
 
 	thread_throttle_mode_init();
 
-	ret = resctrl_mon_resource_init();
-	if (ret)
-		return ret;
+	resctrl_mon_l3_resource_init();
 
 	ret = sysfs_create_mount_point(fs_kobj, "resctrl");
 	if (ret) {
-- 
2.49.0

