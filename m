Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3DF23C51F
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867866; cv=none; b=m7u9kfsFIXVH77CFdFA/0yR+nyDsWaAlPSZYDQVSJ9woVSHR3sNCsM9oUlZm5ruiw0BepLpaPDy7W0ExjcD4x48l97U6v2Lj1AU63E6l0ypxR0MB0SUh0mRNXMEnIlk8XNWPC5EOF+Bm5eSqiU8PNtQi74MLf7ektaYm+XTjVa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867866; c=relaxed/simple;
	bh=SzbfmjWbTgU6gMZvn+iYunnqZycYnhJqvnGD32HC5NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ML7rgCWWG+pS1vSWqAJ/vVBKeotfkBfkHcBjtxNdDktdu2uGIoYbnq0ofNEJWJECBbEvhpxe74OR9hjH0sIbsdDLXQmNM2NH45FRKzJmJ9uPVKMUgf3nmnsItF3Y5AZHLHd+6ZER7wdD7bEGwzEAcOhVDwOfwjzEhRz4FSYGpR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S7iSrkDW; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S7iSrkDW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867864; x=1779403864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SzbfmjWbTgU6gMZvn+iYunnqZycYnhJqvnGD32HC5NY=;
  b=S7iSrkDWoekNZdBfs3Y5TehgNY1dND8rEm1eEQuFz1hUuPM6Nl3ONTBe
   4CVAnP6lBU+4lnAmuxQoT333VM/3IwMyk/yO97xD3sGrjbGf8gLTU3ea/
   0xI9TSK5mYHwMItqEDy6wyuSkVQef0E2DtCR1YrG4DmRv7SsTua/nJeKo
   mkRal3kYxMbkjFOLK1rE2uvYSpaPddC/BNojCjkiFmsrq7+F6R4iC+wZY
   WBDbsxj7wytsdU/VYDCkvQwhvxnslmCjTuEci/WYWx0ixwKSWECs4Mpr3
   P1Sa7RovdHwb9mNnHh4oxoUFMLBOu5LLVdV0jUkLb/5elpnAgmWgOtXcj
   g==;
X-CSE-ConnectionGUID: /BEhx9dkTkO0D2/KK1H9dw==
X-CSE-MsgGUID: Onz4ywDvRPuUuG9+v1XVVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677694"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677694"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
X-CSE-ConnectionGUID: Vzv7ETHMQru5DlJEBHptZA==
X-CSE-MsgGUID: Tho1t4pxQpCZQ1lu6aUXxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352151"
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
Subject: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to use struct rdt_domain_hdr
Date: Wed, 21 May 2025 15:50:28 -0700
Message-ID: <20250521225049.132551-11-tony.luck@intel.com>
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

Historically all monitoring events have been associated with the L3
resource and it made sense to use "struct rdt_mon_domain *" arguments
to functions manipulating domains. But the addition of monitor events
tied to other resources changes this assumption.

Some functionality like:
*) adding a CPU to an existing domain
*) removing a CPU that is not the last one from a domain
can be achieved with just access to the rdt_domain_hdr structure.

Change arguments from "rdt_*_domain" to rdt_domain_hdr so functions
can be used on domains from any resource.

Add sanity checks where container_of() is used to find the surrounding
domain structure that hdr has the expected type.

Simplify code that uses "d->hdr." to "hdr->" where possible.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  4 +-
 arch/x86/kernel/cpu/resctrl/core.c | 39 +++++++-------
 fs/resctrl/rdtgroup.c              | 83 +++++++++++++++++++++---------
 3 files changed, 79 insertions(+), 47 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d6b09952ef92..c02a4d59f3eb 100644
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
index e4125161ffbd..71b884f25475 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -458,9 +458,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	if (hdr) {
 		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 			return;
-		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
-
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
 		if (r->cache.arch_has_per_cpu_cfg)
 			rdt_domain_reconfigure_cdp(r);
 		return;
@@ -524,7 +522,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 
 	list_add_tail_rcu(&d->hdr.list, add_pos);
 
-	err = resctrl_online_mon_domain(r, d);
+	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
@@ -597,25 +595,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
+	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
-
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&hdr->list);
+	synchronize_rcu();
 
-		return;
-	}
+	/*
+	 * rdt_ctrl_domain "d" is going to be freed below, so clear
+	 * its pointer from pseudo_lock_region struct.
+	 */
+	if (d->plr)
+		d->plr->d = NULL;
+	ctrl_domain_free(hw_dom);
 }
 
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
@@ -651,8 +648,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
-		resctrl_offline_mon_domain(r, d);
-		list_del_rcu(&d->hdr.list);
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		l3_mon_domain_free(hw_dom);
 		break;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 828c743ec470..0213fb3a1113 100644
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
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
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
@@ -3054,7 +3063,14 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 	for (mevt = &mon_event_all[0]; mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
-		domid = do_sum ? d->ci->id : d->hdr.id;
+		if (r->rid == RDT_RESOURCE_L3) {
+			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+				return -EINVAL;
+			d = container_of(hdr, struct rdt_mon_domain, hdr);
+			domid = do_sum ? d->ci->id : d->hdr.id;
+		} else {
+			domid = hdr->id;
+		}
 		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
 		if (WARN_ON_ONCE(!priv))
 			return -EINVAL;
@@ -3063,18 +3079,19 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
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
@@ -3082,7 +3099,14 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
+	if (snc_mode) {
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+			return -EINVAL;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+	} else {
+		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	}
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3098,13 +3122,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
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
@@ -3115,7 +3139,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		if (ret)
 			goto out_destroy;
 
-		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3133,7 +3157,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
  * and "monitor" groups with given domain id.
  */
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
@@ -3141,12 +3165,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 
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
@@ -3155,14 +3179,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
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
@@ -4030,8 +4054,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
+	struct rdt_mon_domain *d;
+
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -4039,11 +4065,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d);
+		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
 	if (r->rid != RDT_RESOURCE_L3)
 		goto done;
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+		return;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4126,12 +4156,17 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 	return err;
 }
 
-int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	int err;
+	struct rdt_mon_domain *d;
+	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+		goto out_unlock;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4152,7 +4187,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		mkdir_mondata_subdir_allrdtgrp(r, d);
+		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-- 
2.49.0

