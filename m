Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0AF4E430C
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600418; cv=none; b=GIJdnhfmdoFA/8z2Wx1dVdsk6xnW8bXyGL8H7PJpmY7IFuB29JAkn8knCAPp0Xkz/jH9lowAet8qS4NbaI+V5BUTV317cDDCqomTHRvyyK9hr7p6tjgHM62cadZRZxic46zwj17pQqZnP4bqos1hGi/b2HVCgYmzf7Mz+CPGYOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600418; c=relaxed/simple;
	bh=qDlEJEGlP/OlBALubimGeO2TbFoCqhbq2JGqKI4msQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzwySejeQxTxOMvJHMvqKfVitZTCVtq+7DjCVWGqgbWWR5sDbE1arJAd10VlGEG3vZHsLtr3wCPW+JS3WueMHhE7mxkhiDk6R2I9GAQH4wikHFPbji87nuJ6sPPfB7W5895XdvtuRdRM4CBfwfSxD6nQFkViTXj26PFaz/tQrh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KbM6VGZe; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KbM6VGZe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600415; x=1821136415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qDlEJEGlP/OlBALubimGeO2TbFoCqhbq2JGqKI4msQM=;
  b=KbM6VGZet4sJeYDFFf5tB93Qx5g1E3aP/RkC68PP99s4f4JzrXkyz489
   Tgm1Wcp2gM+K2AT7HEqcnKRO0mOczWFf475woq/tkUWuDbRHlXU9Uzivu
   wCjeA+jqs/vk9NkBmnwOTFE0WRu5ORusSJwahXIVfuCbaO3G6XeV+dyTz
   DXQpgsd01pnlt/gNhBuxumMQfZalpe77++AFlRzBgnmpwYt5Oio1yplX0
   5j4JsJGOIyNK0LL9Cf3OO1pBAfB/9/tahKlMZVCtkY7BitPoDw2wsXPv9
   rYSx/U7LQ4kfTP6LZ+kqeO9svRH1dAfpRIZx8xOpRO8KzvzriBumEtGXk
   Q==;
X-CSE-ConnectionGUID: eyDaeJ4kSvmoqFYmHZkfzQ==
X-CSE-MsgGUID: +1LKZKcNT5KT1kdOcHnzCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861364"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861364"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:33 -0700
X-CSE-ConnectionGUID: tpe6RBUwTC21cEsbJoIBaA==
X-CSE-MsgGUID: dh4ogFmxRP6rn13MPAPnVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231443"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:32 -0700
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
Subject: [PATCH v12 06/25] arm,x86,fs/resctrl: Replace architecture resctrl_arch_{alloc,mon}_capable()
Date: Wed, 16 Sep 2026 16:13:01 -0700
Message-ID: <20260916231320.14502-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the information to determine whether a system is alloc, or mon,
capable is available to the file system. Architecture helpers are not
needed.

Define generic resctrl_alloc_capable() and resctrl_mon_capable() and
replace all architecture versions.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	In each of resctrl_alloc_capable() and resctrl_mon_capable()
	- Header comment is a question, end with "?" instead of period.
	- Add { } around multi-line for-loop.
	- s/(r)/r/
	- Add blank line before final return.
---
 include/linux/arm_mpam.h       |  3 ---
 include/linux/resctrl.h        | 30 +++++++++++++++++++++++++++
 arch/x86/include/asm/resctrl.h | 10 ---------
 drivers/resctrl/mpam_resctrl.c | 26 ++---------------------
 fs/resctrl/monitor.c           | 10 ++++-----
 fs/resctrl/pseudo_lock.c       |  6 +++---
 fs/resctrl/rdtgroup.c          | 38 +++++++++++++++++-----------------
 7 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index f92a36187a52..ba4131048260 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -50,9 +50,6 @@ static inline int mpam_ris_create(struct mpam_msc *msc, u8 ris_idx,
 }
 #endif
 
-bool resctrl_arch_alloc_capable(void);
-bool resctrl_arch_mon_capable(void);
-
 void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
 void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
 void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index dd09c2ce9a0f..6b07ac2c8675 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -346,6 +346,36 @@ struct rdt_resource {
  */
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l);
 
+/*
+ * resctrl_alloc_capable - Are any allocation resources enabled?
+ */
+static inline bool resctrl_alloc_capable(void)
+{
+	struct rdt_resource *r;
+
+	for_each_rdt_resource(r) {
+		if (r->alloc_capable)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * resctrl_mon_capable - Are any monitor resources enabled?
+ */
+static inline bool resctrl_mon_capable(void)
+{
+	struct rdt_resource *r;
+
+	for_each_rdt_resource(r) {
+		if (r->mon_capable)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * struct resctrl_schema - configuration abilities of a resource presented to
  *			   user-space
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index ab7f6ccd149e..fb6cfff82e2f 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -50,11 +50,6 @@ DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_key);
 
-static inline bool resctrl_arch_alloc_capable(void)
-{
-	return rdt_alloc_capable;
-}
-
 static inline void resctrl_arch_enable_alloc(void)
 {
 	static_branch_enable_cpuslocked(&rdt_alloc_enable_key);
@@ -67,11 +62,6 @@ static inline void resctrl_arch_disable_alloc(void)
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
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 9d223057953a..0db62dd2a71c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -75,28 +75,6 @@ static DECLARE_WAIT_QUEUE_HEAD(wait_cacheinfo_ready);
  */
 static bool resctrl_enabled;
 
-bool resctrl_arch_alloc_capable(void)
-{
-	struct mpam_resctrl_res *res;
-	enum resctrl_res_level rid;
-
-	for_each_mpam_resctrl_control(res, rid) {
-		if (res->resctrl_res.alloc_capable)
-			return true;
-	}
-
-	return false;
-}
-
-bool resctrl_arch_mon_capable(void)
-{
-	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
-	struct rdt_resource *l3 = &res->resctrl_res;
-
-	/* All monitors are presented as being on the L3 cache */
-	return l3->mon_capable;
-}
-
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
 {
 	return false;
@@ -1897,9 +1875,9 @@ int mpam_resctrl_setup(void)
 
 	cpus_read_unlock();
 
-	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {
+	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
 		pr_debug("No alloc(%u) or monitor(%u) found - resctrl not supported\n",
-			 resctrl_arch_alloc_capable(), resctrl_arch_mon_capable());
+			 resctrl_alloc_capable(), resctrl_mon_capable());
 		return -EOPNOTSUPP;
 	}
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 73413cb128ea..362737e13cd3 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -338,7 +338,7 @@ void free_rmid(u32 closid, u32 rmid)
 	 * allows architectures that ignore the closid parameter to avoid an
 	 * unnecessary check.
 	 */
-	if (!resctrl_arch_mon_capable() ||
+	if (!resctrl_mon_capable() ||
 	    idx == resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
 						RESCTRL_RESERVED_RMID))
 		return;
@@ -888,7 +888,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * If the filesystem has been unmounted this work no longer needs to
 	 * run.
 	 */
-	if (!resctrl_mounted || !resctrl_arch_mon_capable())
+	if (!resctrl_mounted || !resctrl_mon_capable())
 		goto out_unlock;
 
 	/*
@@ -950,7 +950,7 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 	 * When a domain comes online there is no guarantee the filesystem is
 	 * mounted. If not, there is no need to catch counter overflow.
 	 */
-	if (!resctrl_mounted || !resctrl_arch_mon_capable())
+	if (!resctrl_mounted || !resctrl_mon_capable())
 		return;
 	cpu = cpumask_any_housekeeping(&dom->hdr.cpu_mask, exclude_cpu);
 	dom->mbm_work_cpu = cpu;
@@ -966,7 +966,7 @@ int setup_rmid_lru_list(void)
 	u32 idx;
 	int i;
 
-	if (!resctrl_arch_mon_capable())
+	if (!resctrl_mon_capable())
 		return 0;
 
 	/*
@@ -1006,7 +1006,7 @@ int setup_rmid_lru_list(void)
 
 void free_rmid_lru_list(void)
 {
-	if (!resctrl_arch_mon_capable())
+	if (!resctrl_mon_capable())
 		return;
 
 	mutex_lock(&rdtgroup_mutex);
diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index dea2b4bf966f..04b69c0e37f2 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -383,7 +383,7 @@ static int rdtgroup_locksetup_user_restrict(struct rdtgroup *rdtgrp)
 	if (ret)
 		goto err_cpus;
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		ret = rdtgroup_kn_mode_restrict(rdtgrp, "mon_groups");
 		if (ret)
 			goto err_cpus_list;
@@ -430,7 +430,7 @@ static int rdtgroup_locksetup_user_restore(struct rdtgroup *rdtgrp)
 	if (ret)
 		goto err_cpus;
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		ret = rdtgroup_kn_mode_restore(rdtgrp, "mon_groups", 0777);
 		if (ret)
 			goto err_cpus_list;
@@ -577,7 +577,7 @@ int rdtgroup_locksetup_exit(struct rdtgroup *rdtgrp)
 {
 	int ret;
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		ret = alloc_rmid(rdtgrp->closid);
 		if (ret < 0) {
 			rdt_last_cmd_puts("Out of RMIDs\n");
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dcbb0a964e8..79977200b1a0 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -685,13 +685,13 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (resctrl_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 
 static bool is_rmid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_mon_capable() && (r->type == RDTMON_GROUP) &&
+	return (resctrl_mon_capable() && (r->type == RDTMON_GROUP) &&
 		resctrl_arch_match_rmid(t, r->mon.parent->closid,
 					r->mon.rmid));
 }
@@ -3159,9 +3159,9 @@ static void resctrl_unmount(void)
 		resctrl_arch_reset_all_ctrls(r);
 
 	resctrl_fs_teardown();
-	if (resctrl_arch_alloc_capable())
+	if (resctrl_alloc_capable())
 		resctrl_arch_disable_alloc();
-	if (resctrl_arch_mon_capable())
+	if (resctrl_mon_capable())
 		resctrl_arch_disable_mon();
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
@@ -3215,7 +3215,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_schemata_free;
 
-	if (resctrl_arch_mon_capable())
+	if (resctrl_mon_capable())
 		flags |= RFTYPE_MON;
 
 	ret = rdtgroup_add_files(rdtgroup_default.kn, flags);
@@ -3228,7 +3228,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret < 0)
 		goto out_closid_exit;
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		ret = mongroup_create_dir(rdtgroup_default.kn,
 					  &rdtgroup_default, "mon_groups",
 					  &kn_mongrp);
@@ -3248,12 +3248,12 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	if (resctrl_arch_alloc_capable())
+	if (resctrl_alloc_capable())
 		resctrl_arch_enable_alloc();
-	if (resctrl_arch_mon_capable())
+	if (resctrl_mon_capable())
 		resctrl_arch_enable_mon();
 
-	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
+	if (resctrl_alloc_capable() || resctrl_mon_capable())
 		resctrl_mounted = true;
 
 	if (resctrl_is_mbm_enabled()) {
@@ -3296,10 +3296,10 @@ static int rdt_get_tree(struct fs_context *fc)
 	return ret;
 
 out_mondata:
-	if (resctrl_arch_mon_capable())
+	if (resctrl_mon_capable())
 		kernfs_remove(kn_mondata);
 out_mongrp:
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
@@ -3888,7 +3888,7 @@ static int mkdir_rdt_prepare_rmid_alloc(struct rdtgroup *rdtgrp)
 {
 	int ret;
 
-	if (!resctrl_arch_mon_capable())
+	if (!resctrl_mon_capable())
 		return 0;
 
 	ret = alloc_rmid(rdtgrp->closid);
@@ -3913,7 +3913,7 @@ static int mkdir_rdt_prepare_rmid_alloc(struct rdtgroup *rdtgrp)
 
 static void mkdir_rdt_prepare_rmid_free(struct rdtgroup *rgrp)
 {
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		rdtgroup_unassign_cntrs(rgrp);
 		free_rmid(rgrp->closid, rgrp->mon.rmid);
 	}
@@ -4004,7 +4004,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 
 	if (rtype == RDTCTRL_GROUP) {
 		files = RFTYPE_BASE | RFTYPE_CTRL;
-		if (resctrl_arch_mon_capable())
+		if (resctrl_mon_capable())
 			files |= RFTYPE_MON;
 	} else {
 		files = RFTYPE_BASE | RFTYPE_MON;
@@ -4113,7 +4113,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 
 	list_add(&rdtgrp->rdtgroup_list, &rdt_all_groups);
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		/*
 		 * Create an empty mon_groups directory to hold the subset
 		 * of tasks and cpus to monitor.
@@ -4154,11 +4154,11 @@ static int rdtgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	 * allocation is supported, add a control and monitoring
 	 * subdirectory
 	 */
-	if (resctrl_arch_alloc_capable() && parent_kn == rdtgroup_default.kn)
+	if (resctrl_alloc_capable() && parent_kn == rdtgroup_default.kn)
 		return rdtgroup_mkdir_ctrl_mon(parent_kn, name, mode);
 
 	/* Else, attempt to add a monitoring subdirectory. */
-	if (resctrl_arch_mon_capable())
+	if (resctrl_mon_capable())
 		return rdtgroup_mkdir_mon(parent_kn, name, mode);
 
 	return -EPERM;
@@ -4573,7 +4573,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	 * If resctrl is mounted, remove all the
 	 * per domain monitor data directories.
 	 */
-	if (resctrl_mounted && resctrl_arch_mon_capable())
+	if (resctrl_mounted && resctrl_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
 	if (r->rid != RDT_RESOURCE_L3)
@@ -4710,7 +4710,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	 * by rdt_get_tree() calling mkdir_mondata_all().
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
-	if (resctrl_mounted && resctrl_arch_mon_capable())
+	if (resctrl_mounted && resctrl_mon_capable())
 		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
-- 
2.55.0

