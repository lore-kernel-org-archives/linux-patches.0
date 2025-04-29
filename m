Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233631C7006
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886860; cv=none; b=HeiSRw6OzDm3ijY9vwHyIhBRPr3kOyezcC7jejfWrpmS1ZDsDzm4UwbHNePTH4RlFAyQOXpFqUfUskHIkB7T4VUpBEtoKFSoFU7kZ2AhfJsEhCnggzzDXbxlov+OF6UQitAG9qurMJ6qwbT6JX+CXZN4K3lgOTe7gOrySFYJUDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886860; c=relaxed/simple;
	bh=77+SDgugQw2rk4X7Ptd9s/QsMQCAFnC4x+vpVxFtxDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb+kQdWvOJckZHc0KWjnPM+Jt8Z/GX79j3vkCPICbzbFLUhFA6LjcrX//cevnTSCehTgq+HEtcQ/R1x0AJEbWiBjFz/Rcg9gt9LmEJyWzo6OC5FkQc9XyECa41eyRxJs0gxK9zsMySWLI8brHoxb1cbD5QP7vu2SNQXO8yUPAiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6MbJRLG; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6MbJRLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886858; x=1777422858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=77+SDgugQw2rk4X7Ptd9s/QsMQCAFnC4x+vpVxFtxDQ=;
  b=B6MbJRLGKF6vgrvYOzyCnEfuhzQ9g0fkLyAW11hecScswSMlUfxyqcWt
   dgSApPAeLNdYkwM7YUo25oD4WPJpSr0H3UZdXR/zPJbC3VMj3JfmKkI7A
   b6re8OwH0gZHU8rdNi5RPWzm3hu+GnU1v+gY9WtN+fbvyKhaOEtVDKPpN
   uEX+nPUorh2OJg1wAiXvq+GEM3wWOFDAz+jGd9uRPGDV6ri33QSlZgKix
   5ITMiyHlySk10sBPO0XSKBuM03tqcf23FGTGURU1qVL5jEQ4Z02kkXKgJ
   j0quUL/eFvL2CrxLELdgRdlk0KWodqzSlyKVDVLfRBX8fcSbm0rGp/ixx
   g==;
X-CSE-ConnectionGUID: ULUTUI1cRt6sIZi/fhQQ0A==
X-CSE-MsgGUID: Lx/c2nK0RnixOXMj+2Rshg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148129"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148129"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:13 -0700
X-CSE-ConnectionGUID: lduUjL+XRhOXlb+ixdfLHw==
X-CSE-MsgGUID: fGbVgH+6TRi4psIm2LKKug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393991"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:12 -0700
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
Subject: [PATCH v4 10/31] x86/resctrl: Change generic monitor functions to use struct rdt_domain_hdr
Date: Mon, 28 Apr 2025 17:33:36 -0700
Message-ID: <20250429003359.375508-11-tony.luck@intel.com>
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

Functions that don't need the internal details of the rdt_mon_domain
can operate on just the rdt_domain_hdr.

Add sanity checks where container_of() is used to find the surrounding
domain structure that hdr has the expected type.

Simplify code that uses "d->hdr." to "hdr->" where possible.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  4 +-
 arch/x86/kernel/cpu/resctrl/core.c | 19 +++----
 fs/resctrl/rdtgroup.c              | 82 +++++++++++++++++++++---------
 3 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index e700f58b5af5..bb55c449adc4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -444,9 +444,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 			    u32 closid, enum resctrl_conf_type type);
 int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
-int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
+int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
 void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
-void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
+void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 525439029865..9c78828ae32f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -460,7 +460,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 			return;
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
 		if (r->cache.arch_has_per_cpu_cfg)
 			rdt_domain_reconfigure_cdp(r);
 		return;
@@ -524,7 +524,7 @@ static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct
 
 	list_add_tail_rcu(&d->hdr.list, add_pos);
 
-	err = resctrl_online_mon_domain(r, d);
+	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
@@ -537,7 +537,6 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
 	struct list_head *add_pos = NULL;
 	struct rdt_domain_hdr *hdr;
-	struct rdt_mon_domain *d;
 
 	lockdep_assert_held(&domain_list_lock);
 
@@ -549,11 +548,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
 	if (hdr) {
-		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
 		return;
 	}
 
@@ -603,9 +598,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
 	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
+	if (cpumask_empty(&hdr->cpu_mask)) {
 		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
+		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 
 		/*
@@ -653,8 +648,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
-		resctrl_offline_mon_domain(r, d);
-		list_del_rcu(&d->hdr.list);
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		free_l3_mon_domain(hw_dom);
 		break;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a65f3e16bdab..0ec87db799b4 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3022,7 +3022,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
  * when last domain being summed is removed.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
 	char subname[32];
@@ -3030,9 +3030,17 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	char name[32];
 
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+	if (snc_mode) {
+		struct rdt_mon_domain *d;
+
+		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
+			return;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
+	} else {
+		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	}
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
@@ -3042,11 +3050,12 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
-static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
+static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			     struct rdt_resource *r, struct rdtgroup *prgrp,
 			     bool do_sum)
 {
 	struct rmid_read rr = {0};
+	struct rdt_mon_domain *d;
 	struct mon_data *priv;
 	struct mon_evt *mevt;
 	int ret, domid;
@@ -3054,8 +3063,16 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 	if (WARN_ON(list_empty(&r->evt_list)))
 		return -EPERM;
 
-	list_for_each_entry(mevt, &r->evt_list, list) {
+	if (r->rid == RDT_RESOURCE_L3) {
+		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
+			return -EINVAL;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
 		domid = do_sum ? d->ci->id : d->hdr.id;
+	} else {
+		domid = hdr->id;
+	}
+
+	list_for_each_entry(mevt, &r->evt_list, list) {
 		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
 		if (WARN_ON_ONCE(!priv))
 			return -EINVAL;
@@ -3064,18 +3081,19 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		if (ret)
 			return ret;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
+		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
+			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt->evtid, true);
 	}
 
 	return 0;
 }
 
 static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
-				struct rdt_mon_domain *d,
+				struct rdt_domain_hdr *hdr,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
+	struct rdt_mon_domain *d;
 	char name[32];
 	bool snc_mode;
 	int ret = 0;
@@ -3083,7 +3101,14 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
+	if (snc_mode) {
+		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
+			return -EINVAL;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+	} else {
+		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	}
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3099,13 +3124,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		ret = rdtgroup_kn_set_ugid(kn);
 		if (ret)
 			goto out_destroy;
-		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
+		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
 		if (ret)
 			goto out_destroy;
 	}
 
 	if (snc_mode) {
-		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
+		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
 		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
 		if (IS_ERR(ckn)) {
 			ret = -EINVAL;
@@ -3116,7 +3141,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		if (ret)
 			goto out_destroy;
 
-		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3134,7 +3159,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
  * and "monitor" groups with given domain id.
  */
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
@@ -3142,12 +3167,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		parent_kn = prgrp->mon.mon_data_kn;
-		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
+		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
 
 		head = &prgrp->mon.crdtgrp_list;
 		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
 			parent_kn = crgrp->mon.mon_data_kn;
-			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
+			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
 		}
 	}
 }
@@ -3156,14 +3181,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
 				       struct rdt_resource *r,
 				       struct rdtgroup *prgrp)
 {
-	struct rdt_mon_domain *dom;
+	struct rdt_domain_hdr *hdr;
 	int ret;
 
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
-		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
+	list_for_each_entry(hdr, &r->mon_domains, list) {
+		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
 		if (ret)
 			return ret;
 	}
@@ -4031,8 +4056,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
+	struct rdt_mon_domain *d;
+
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -4040,11 +4067,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d);
+		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
 	if (r->rid != RDT_RESOURCE_L3)
 		goto done;
 
+	if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
+		return;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4127,8 +4158,9 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 	return err;
 }
 
-int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
+	struct rdt_mon_domain *d;
 	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
@@ -4136,6 +4168,10 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	if (r->rid != RDT_RESOURCE_L3)
 		goto out_unlock;
 
+	if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
+		return err;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4156,7 +4192,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		mkdir_mondata_subdir_allrdtgrp(r, d);
+		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-- 
2.48.1

