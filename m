Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443053;
	b=3adWRzGs4Fzo9fllJChdJQmc80Od0bLlIuF57Frze6jjzJkDRaxFZYiOXhd3fqU187pE
	 NtbEW17JYBbNt6wXvfRP/ttsuaLxX/sFWmtyb04qlDCrPCGlFa3yfbsBpqXZFfxTWl8Ri
	 LknxzlGas3f4tBdQwM2wYbSVTBy5lKZqVjF7G0sJDyJOHL695GlQaDFVLIo0Uxlgpv6Pv
	 jwIG5o7u9IdtMg0u0hjte8Jt/MEZfJw/VhGfUGHEuF0rWu0L57Xb0RoESmISc7ysJ+ij8
	 mzKjLeGspNotruEOCoOC71T8VpAJBn2avIB4VfG2DQPDVOJ2Cd76Jwbw059Svfu3K+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443053;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hfW18tdDZNg5fPHF7xiQZnOZgxMqIKe3n+K/gSGYoQ4=;
	b=bQW0gfjqTVX85edtV98e6DeKCBpH1CEfU6R3caL9ZAlpyY9pL/tZiVJYJXfuG+CQdDOy
	 hF2+lnPgsPcqrEmw5ioTY7J16+z2IM2z5/e3lrDh46IqYmF6FGe/dg4AwyxRku2vQlPoV
	 FijLc35Wlin1FVprBJsDjiXltfAK+kEsg9Xa6fOgVIOvd767WH6JCZwtBJxPYphWKFm+R
	 taSCfK/kc2mBZRqHW33kn3pisuhTsMl0zfXYHKeNPKenmwTIJYPUwBUDgdj6JIi7UHWhY
	 dCOZVsr+QaXfaJufpJ1oGoGVjKie3JUXbYwQL6yj0ltTPxmfbLkE2A+t7RJpRlNksoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bLJUmur7;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075BB606A333
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 075BB606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bLJUmur7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443053; x=1823979053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6LncGlXWqtLY2ckl/xyCVwhh6UTBUXGXWCitmRC3Zx8=;
  b=bLJUmur7nmiepw8C8Cumf3wVrKab9GtJu6nQ2yZ/bo44wkV5Ftsp3ole
   XW/W6AGxJi/vQNZHZ73lQwdgtUWprdJTYTMpzxRWqle3uMR6Q85yTafKA
   DvB/55LKurvyudFZCZok6yH8OCHc/nJekRiBusiC8W6fEyrANHFuF5P0O
   /pjT4YynDlFkik7wZqkkPji4FKsg15vIf5hmGmra3P6OXBT4qsUzmTA3p
   sUAfnxBuMgUNQc7W0gWXPMI8qSSc+o9Xi0AyjAtDIFzXRZYzc5OS9W361
   NmRuXmqjiU7aB4OgwCR+JBTmq8w4pPeYfrxWbBqYiCB2eXv7kjSilREr+
   Q==;
X-CSE-ConnectionGUID: Re/I7ZP8SDucWwDHNz3t6Q==
X-CSE-MsgGUID: MJ/1z6HiSYSWS+ip5Bxhqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131153"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131153"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:49 -0700
X-CSE-ConnectionGUID: OdWCpW7sS5CajO5M5fzGsA==
X-CSE-MsgGUID: WvQybZZxQ/yYx8niPVx6KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008635"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:49 -0700
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
Subject: [PATCH v14 06/24] arm,x86,fs/resctrl: Replace architecture capability helpers with generic versions
Date: Mon, 19 Oct 2026 13:50:13 -0700
Message-ID: <20261019205031.16977-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl supports allocation or monitoring if any resource is capable of
it. Each architecture answers this via resctrl_arch_alloc_capable() and
resctrl_arch_mon_capable(). x86 maintains global flags for this in
addition to the per-resource flags and must keep both in sync. MPAM
derives the answer from its per-resource flags.

The per-resource flags are part of the resource description that the file
system already has, so the architecture helpers duplicate information
available to the file system.

Define resctrl_alloc_capable() and resctrl_mon_capable() in the file system
based on the per-resource flags and remove the architecture helpers, in
preparation for removing the x86 global flags. The result is unchanged for
MPAM, which presents all monitors on the L3 resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New Subject: without {alloc,mon}
	New commit message in context, problem, solution format
	Did not apply Reinette RB tag because of commit message rewrite.
---
 include/linux/arm_mpam.h       |  3 ---
 include/linux/resctrl.h        | 30 ++++++++++++++++++++++++++++
 arch/x86/include/asm/resctrl.h | 10 ----------
 drivers/resctrl/mpam_resctrl.c | 26 ++----------------------
 fs/resctrl/monitor.c           | 10 +++++-----
 fs/resctrl/pseudo_lock.c       |  6 +++---
 fs/resctrl/rdtgroup.c          | 36 +++++++++++++++++-----------------
 7 files changed, 58 insertions(+), 63 deletions(-)

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
index 10dfdca7f4bf..0e7fce070fde 100644
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
index 2031b30ff25b..9c44a7766631 100644
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
index f2c651e9f6ea..7ddee8f5162f 100644
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
@@ -1902,9 +1880,9 @@ int mpam_resctrl_setup(void)
 
 	cpus_read_unlock();
 
-	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {
+	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
 		pr_debug("No alloc(%u) or monitor(%u) found - resctrl not supported\n",
-			 resctrl_arch_alloc_capable(), resctrl_arch_mon_capable());
+			 resctrl_alloc_capable(), resctrl_mon_capable());
 		return -EOPNOTSUPP;
 	}
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 04e4ea612b7c..cb34d3637ee5 100644
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
index 56ab63f19bad..3d831227a42f 100644
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
index 57ab090072c2..96a4978ce6b6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -691,7 +691,7 @@ static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 
 static bool is_rmid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_mon_capable() && (r->type == RDTMON_GROUP) &&
+	return (resctrl_mon_capable() && (r->type == RDTMON_GROUP) &&
 		resctrl_arch_match_rmid(t, r->mon.parent->closid,
 					r->mon.rmid));
 }
@@ -3157,9 +3157,9 @@ static void resctrl_unmount(void)
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
@@ -3213,7 +3213,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_schemata_free;
 
-	if (resctrl_arch_mon_capable())
+	if (resctrl_mon_capable())
 		flags |= RFTYPE_MON;
 
 	ret = rdtgroup_add_files(rdtgroup_default.kn, flags);
@@ -3226,7 +3226,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret < 0)
 		goto out_closid_exit;
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		ret = mongroup_create_dir(rdtgroup_default.kn,
 					  &rdtgroup_default, "mon_groups",
 					  &kn_mongrp);
@@ -3246,12 +3246,12 @@ static int rdt_get_tree(struct fs_context *fc)
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
@@ -3294,10 +3294,10 @@ static int rdt_get_tree(struct fs_context *fc)
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
@@ -3886,7 +3886,7 @@ static int mkdir_rdt_prepare_rmid_alloc(struct rdtgroup *rdtgrp)
 {
 	int ret;
 
-	if (!resctrl_arch_mon_capable())
+	if (!resctrl_mon_capable())
 		return 0;
 
 	ret = alloc_rmid(rdtgrp->closid);
@@ -3911,7 +3911,7 @@ static int mkdir_rdt_prepare_rmid_alloc(struct rdtgroup *rdtgrp)
 
 static void mkdir_rdt_prepare_rmid_free(struct rdtgroup *rgrp)
 {
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		rdtgroup_unassign_cntrs(rgrp);
 		free_rmid(rgrp->closid, rgrp->mon.rmid);
 	}
@@ -4002,7 +4002,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 
 	if (rtype == RDTCTRL_GROUP) {
 		files = RFTYPE_BASE | RFTYPE_CTRL;
-		if (resctrl_arch_mon_capable())
+		if (resctrl_mon_capable())
 			files |= RFTYPE_MON;
 	} else {
 		files = RFTYPE_BASE | RFTYPE_MON;
@@ -4111,7 +4111,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 
 	list_add(&rdtgrp->rdtgroup_list, &rdt_all_groups);
 
-	if (resctrl_arch_mon_capable()) {
+	if (resctrl_mon_capable()) {
 		/*
 		 * Create an empty mon_groups directory to hold the subset
 		 * of tasks and cpus to monitor.
@@ -4152,11 +4152,11 @@ static int rdtgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
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
@@ -4571,7 +4571,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	 * If resctrl is mounted, remove all the
 	 * per domain monitor data directories.
 	 */
-	if (resctrl_mounted && resctrl_arch_mon_capable())
+	if (resctrl_mounted && resctrl_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
 	if (r->rid != RDT_RESOURCE_L3)
@@ -4708,7 +4708,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	 * by rdt_get_tree() calling mkdir_mondata_all().
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
-	if (resctrl_mounted && resctrl_arch_mon_capable())
+	if (resctrl_mounted && resctrl_mon_capable())
 		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
-- 
2.56.0

