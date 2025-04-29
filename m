Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A834D217F56
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886873; cv=none; b=i00y4K1X67kmT1c9rLsCahd/A9WO8nnCXrlMvyYxPr9qSvW/LG1qoHvJZVR9YpgYIUAkuruM71ng9/yq3yyTTAMLMDAZjAS8Y+x82+HpMDrsG9j9Pq/gucgpxt/7tFPqn6YrBf9Vlkx7y/iPfIyGwYS0u1UgN80EEl3f9oHy44w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886873; c=relaxed/simple;
	bh=Nc8PBuxU/Zr6RfO730ZadTnp1SP5khITKMe7nIqiyZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE6GjM9dYXY4razmXw/kX8Pz0aF+dMPQh5Z5c8nC7GA0/2zJplxaY3dV7xy4rh/XD22bQ4vzLkM9DM9DbBRh/aIVPoCePBBG7alh3WKLkDxq7VGtIkg9P062ME5ITNsUMMhZcdE1m3BvNSXkq7F2CBkFHudcqYe3fh7JwHqr+bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=juFr4hgJ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="juFr4hgJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886871; x=1777422871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nc8PBuxU/Zr6RfO730ZadTnp1SP5khITKMe7nIqiyZQ=;
  b=juFr4hgJiT8Peh/W6N4+H2AXZUd1MzK83LUrwvj0ITFBL+ibZeAxgyjJ
   HqwAbRaXrMO2whFCJT4I0OZ/XEQcWQ0Qy9p3VoO6UuhiOkRNXVCKOOfbP
   UJ5hxCmfXBVHkzftNnNiX6MOPAgWUwLqFkFLEK9Tz9yFXPkmKhAEPo5PZ
   z3/FLHum0q4v4qvMfJbDyox8AJYI/G2MfTayq07faew7qSMLmUDqty5D2
   Zk805cUUYHNJMweR6+NdZJOBZ/hrEeu+bxMwMFRjj/4FR1DX7YeCZcg24
   UPGkNrqYeTsphBhnTr/ILiFpS969lJ9yQXf+ckqBN5YdKikgTRcwmrfqv
   w==;
X-CSE-ConnectionGUID: vWi22xGXSCO4HmOJH3iORw==
X-CSE-MsgGUID: WPk2DvNCQqS38w0f2i4sTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148309"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148309"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:24 -0700
X-CSE-ConnectionGUID: y4vW/neFQ+eI0ludOzZs0g==
X-CSE-MsgGUID: qa12DkJOR5CnQIpQ93tjYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394082"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:23 -0700
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
Subject: [PATCH v4 28/31] x86,fs/resctrl: Fix RMID allocation for multiple monitor resources
Date: Mon, 28 Apr 2025 17:33:54 -0700
Message-ID: <20250429003359.375508-29-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
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
 fs/resctrl/internal.h              |  4 +--
 arch/x86/kernel/cpu/resctrl/core.c |  8 +++--
 fs/resctrl/monitor.c               | 48 +++++++++++++-----------------
 fs/resctrl/rdtgroup.c              | 13 ++++----
 4 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 623a9fadc18a..fb5ae8ba0c17 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -364,7 +364,7 @@ int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
 
-void resctrl_mon_resource_exit(void);
+void resctrl_dom_data_exit(void);
 
 void mon_event_count(void *info);
 
@@ -405,7 +405,7 @@ enum resctrl_event_id resctrl_get_mon_event_by_name(char *name);
 
 char *resctrl_mon_event_name(enum resctrl_event_id evt);
 
-void resctrl_init_mon_events(void);
+int resctrl_init_mon_events(void);
 
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index dc312e24ab87..d921f32a1b6c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -112,10 +112,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r;
+	int num_rmids = S32_MAX;
+
+	for_each_mon_capable_rdt_resource(r)
+		num_rmids = min(num_rmids, r->num_rmid);
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->num_rmid;
+	return num_rmids;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index f848325591b4..f7a5ffe9be25 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -762,7 +762,7 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
 }
 
-static int dom_data_init(struct rdt_resource *r)
+static int resctrl_dom_data_init(struct rdt_resource *r)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	u32 num_closid = resctrl_arch_get_num_closid(r);
@@ -770,7 +770,10 @@ static int dom_data_init(struct rdt_resource *r)
 	int err = 0, i;
 	u32 idx;
 
-	mutex_lock(&rdtgroup_mutex);
+	/* Are there any mon_capable resources? */
+	if (idx_limit == S32_MAX)
+		return 0;
+
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
 		u32 *tmp;
 
@@ -783,7 +786,7 @@ static int dom_data_init(struct rdt_resource *r)
 		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
 		if (!tmp) {
 			err = -ENOMEM;
-			goto out_unlock;
+			goto out;
 		}
 
 		closid_num_dirty_rmid = tmp;
@@ -796,7 +799,7 @@ static int dom_data_init(struct rdt_resource *r)
 			closid_num_dirty_rmid = NULL;
 		}
 		err = -ENOMEM;
-		goto out_unlock;
+		goto out;
 	}
 
 	for (i = 0; i < idx_limit; i++) {
@@ -817,14 +820,15 @@ static int dom_data_init(struct rdt_resource *r)
 	entry = __rmid_entry(idx);
 	list_del(&entry->list);
 
-out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
+out:
 
 	return err;
 }
 
-static void dom_data_exit(struct rdt_resource *r)
+void resctrl_dom_data_exit(void)
 {
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
 	mutex_lock(&rdtgroup_mutex);
 
 	if (!r->mon_capable)
@@ -954,16 +958,21 @@ char *resctrl_mon_event_name(enum resctrl_event_id evt)
  * events have been enumerated. Only needs to build the per-resource
  * event lists once.
  */
-void resctrl_init_mon_events(void)
+int resctrl_init_mon_events(void)
 {
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	enum resctrl_event_id evt;
-	struct rdt_resource *r;
 	static bool only_once;
+	int ret;
 
 	if (only_once)
-		return;
+		return 0;
 	only_once = true;
 
+	ret = resctrl_dom_data_init(r);
+	if (ret)
+		return ret;
+
 	for_each_mon_capable_rdt_resource(r)
 		INIT_LIST_HEAD(&r->evt_list);
 
@@ -973,6 +982,8 @@ void resctrl_init_mon_events(void)
 		r = resctrl_arch_get_resource(mon_event_all[evt].rid);
 		list_add_tail(&mon_event_all[evt].list, &r->evt_list);
 	}
+
+	return ret;
 }
 
 /**
@@ -989,16 +1000,6 @@ void resctrl_init_mon_events(void)
  */
 int resctrl_mon_resource_init(void)
 {
-	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	int ret;
-
-	if (!r->mon_capable)
-		return 0;
-
-	ret = dom_data_init(r);
-	if (ret)
-		return ret;
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
@@ -1017,10 +1018,3 @@ int resctrl_mon_resource_init(void)
 
 	return 0;
 }
-
-void resctrl_mon_resource_exit(void)
-{
-	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-
-	dom_data_exit(r);
-}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 544fa721e067..195e41eb73fb 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2595,7 +2595,9 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
-	resctrl_init_mon_events();
+	ret = resctrl_init_mon_events();
+	if (ret)
+		goto out;
 
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
@@ -4300,10 +4302,8 @@ int resctrl_init(void)
 		return ret;
 
 	ret = sysfs_create_mount_point(fs_kobj, "resctrl");
-	if (ret) {
-		resctrl_mon_resource_exit();
+	if (ret)
 		return ret;
-	}
 
 	ret = register_filesystem(&rdt_fs_type);
 	if (ret)
@@ -4336,7 +4336,6 @@ int resctrl_init(void)
 
 cleanup_mountpoint:
 	sysfs_remove_mount_point(fs_kobj, "resctrl");
-	resctrl_mon_resource_exit();
 
 	return ret;
 }
@@ -4363,7 +4362,7 @@ static bool resctrl_online_domains_exist(void)
  * When called by the architecture code, all CPUs and resctrl domains must be
  * offline. This ensures the limbo and overflow handlers are not scheduled to
  * run, meaning the data structures they access can be freed by
- * resctrl_mon_resource_exit().
+ * resctrl_dom_data_exit().
  *
  * After this function has returned, the architecture code should return an
  * from all resctrl_arch_ functions that can do this.
@@ -4390,5 +4389,5 @@ void resctrl_exit(void)
 	 * it can be used to umount resctrl.
 	 */
 
-	resctrl_mon_resource_exit();
+	resctrl_dom_data_exit();
 }
-- 
2.48.1

