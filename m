Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAA52848A2
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715066; cv=none; b=pDON8a/ZwLTe+XGX0bE9psMQ8odvqa2U7bhLMequFxQxDPmAQUACaxqjgOrNl1e+nADl+QPwNUz/tZYc0NE9uXc5v9UdCE2vNVppfqOI7QlmD8cIhPm1E4MvAllUz7v9i8LOQNnkWWFyoIYiKzXtM66Kp2wx3+5l9JwNJW8gTwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715066; c=relaxed/simple;
	bh=U6VY0jeiZG53gOBHCj1cj4bGl2zMnpSxzwS8BedPpOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=By+jf9SectA6P1DFj5+LqoG7l+4NNFxpwDO2/FJHI76XTIU6STaDEk8KK6/SV75ZUdMrh3t6ETSIb43F+7s9K80YMTZlBhYaYyjQ1U9sKNc4wuje37wAE+TfFleiahlu+KFNoVjPA5LIey9paJ336Zk8VToqJJfUkNsfjoz7MxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CQAuPdZq; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CQAuPdZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715064; x=1789251064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6VY0jeiZG53gOBHCj1cj4bGl2zMnpSxzwS8BedPpOQ=;
  b=CQAuPdZq24GNpsGIiwqPejPbByEWgHehQWhgu6U/cSO2bOsyB0VIaDlV
   2J27iZ3LisxroY2klvo8Q4pai84jdoutAvM4rXqQ8WuMDpuy9Z1eEJ9na
   6v392mRXM2vLwaXMd8W2XqBjyn3EM2FR+mOUUljbYVIxMPM1o8oSAabL+
   qg302pB3R3YZtWfTw+Z33lS3+HiSPpPrXYDOiaIrtI1jI6ItSFmOKdhzw
   nWz2aMZYhjX5hRoNWZnqW/SG0YMeK3gWlPl/GwQwYrPNkNspiYjY5010L
   RDvU37l4vxQW7CJ3Ve5fH1FJkzQRPLJ2g1Kn+QDH1l2QlipXgCQsiFw8P
   w==;
X-CSE-ConnectionGUID: epX5nNSFR425I1zKxQXbfg==
X-CSE-MsgGUID: xkhkAnHbRVSqJi4iYTXb+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002648"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002648"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:02 -0700
X-CSE-ConnectionGUID: hGkTNhSoS8CjeM0deMeAcA==
X-CSE-MsgGUID: vSzzZ6gCSDycKIuOaIL/nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265135"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:03 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 05/28] x86,fs/resctrl: Use struct rdt_domain_hdr instead of struct rdt_mon_domain
Date: Fri, 12 Sep 2025 15:10:26 -0700
Message-ID: <20250912221053.11349-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All monitoring events are associated with the L3 resource and it made
sense to use the L3 specific "struct rdt_mon_domain *" arguments to
functions manipulating domains.

Telemetry events will be tied to another resource. This requires the
functions that manipulate domains to not be L3 specific.

Change the calling sequence to use the generic struct rdt_domain_hdr for
domain addition and deletion to preserve as much common code as possible.
This will simplify enabling of enumeration of domains for events in
other resources.

Update kerneldoc for mon_data::sum to note that it is only used for
RDT_RESOURCE_L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
Note: To maintain bisectability this patch adds:

	d = container_of(hdr, struct rdt_mon_domain, hdr);

to mon_event_read() so that the chnages to the event reading code
can be cleanly deferred to the following patch. This doesn't need
a domain_header_is_valid() because RDT_RESOURCE_L3 is still the only
resource available at this point in the series. This call to
container_of() is removed in the next patch with the completion
of the conversion to using struct rdt_domain_hdr.
---
 include/linux/resctrl.h            |   4 +-
 fs/resctrl/internal.h              |   6 +-
 arch/x86/kernel/cpu/resctrl/core.c |   4 +-
 fs/resctrl/ctrlmondata.c           |  11 ++--
 fs/resctrl/rdtgroup.c              | 102 ++++++++++++++++++++---------
 5 files changed, 84 insertions(+), 43 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index dfc91c5e8483..0b55809af5d7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -504,9 +504,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
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
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 10b46cd9e394..6c78b1a4ca3a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -82,8 +82,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
  * @evtid:           Event id associated with the event file.
- * @sum:             Set when event must be summed across multiple
- *                   domains.
+ * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
+ *                   across multiple domains.
  * @domid:           When @sum is zero this is the domain to which
  *                   the event file belongs. When @sum is one this
  *                   is the id of the L3 cache that all domains to be
@@ -362,7 +362,7 @@ void mon_event_count(void *info);
 int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
-		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first);
 
 int resctrl_mon_resource_init(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c6ce72cba543..ffc154189abd 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -533,7 +533,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 
 	list_add_tail_rcu(&d->hdr.list, add_pos);
 
-	err = resctrl_online_mon_domain(r, d);
+	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
@@ -658,7 +658,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
-		resctrl_offline_mon_domain(r, d);
+		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index f248eaf50d3c..3bbfb5398e6f 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -547,11 +547,14 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 }
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
-		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
 {
+	struct rdt_mon_domain *d;
 	int cpu;
 
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
+
 	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
@@ -598,7 +601,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	enum resctrl_event_id evtid;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
-	struct rdt_mon_domain *d;
 	struct rdtgroup *rdtgrp;
 	int domid, cpu, ret = 0;
 	struct rdt_resource *r;
@@ -623,6 +625,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
+		struct rdt_mon_domain *d;
+
 		/*
 		 * This file requires summing across all domains that share
 		 * the L3 cache id that was provided in the "domid" field of the
@@ -653,8 +657,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ce4e716e6404..8f45763ff515 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3029,7 +3029,8 @@ static void rmdir_all_sub(void)
  * @rid:    The resource id for the event file being created.
  * @domid:  The domain id for the event file being created.
  * @mevt:   The type of event file being created.
- * @do_sum: Whether SNC summing monitors are being created.
+ * @do_sum: Whether SNC summing monitors are being created. Only set
+ *          when @rid == RDT_RESOURCE_L3.
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
@@ -3167,17 +3168,27 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
  * when last domain being summed is removed.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
+	int domid = hdr->id;
 	char subname[32];
-	bool snc_mode;
 	char name[32];
 
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+	if (r->rid == RDT_RESOURCE_L3) {
+		struct rdt_mon_domain *d;
+
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+
+		/* SNC mode? */
+		if (r->mon_scope == RESCTRL_L3_NODE) {
+			domid = d->ci_id;
+			sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
+		}
+	}
+	sprintf(name, "mon_%s_%02d", r->name, domid);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
@@ -3187,19 +3198,18 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
-static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
+static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			     struct rdt_resource *r, struct rdtgroup *prgrp,
-			     bool do_sum)
+			     int domid, bool do_sum)
 {
 	struct rmid_read rr = {0};
 	struct mon_data *priv;
 	struct mon_evt *mevt;
-	int ret, domid;
+	int ret;
 
 	for_each_mon_event(mevt) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
-		domid = do_sum ? d->ci_id : d->hdr.id;
 		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
 		if (WARN_ON_ONCE(!priv))
 			return -EINVAL;
@@ -3208,26 +3218,38 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		if (ret)
 			return ret;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
+		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
+			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
 	}
 
 	return 0;
 }
 
 static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
-				struct rdt_mon_domain *d,
+				struct rdt_domain_hdr *hdr,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
+	bool snc_mode = false;
+	int domid = hdr->id;
 	char name[32];
-	bool snc_mode;
 	int ret = 0;
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
+	if (r->rid == RDT_RESOURCE_L3) {
+		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
+		if (snc_mode) {
+			struct rdt_mon_domain *d;
+
+			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+				return -EINVAL;
+			d = container_of(hdr, struct rdt_mon_domain, hdr);
+			domid = d->ci_id;
+		}
+	}
+	sprintf(name, "mon_%s_%02d", r->name, domid);
+
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3243,13 +3265,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		ret = rdtgroup_kn_set_ugid(kn);
 		if (ret)
 			goto out_destroy;
-		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
+		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
 		if (ret)
 			goto out_destroy;
 	}
 
 	if (snc_mode) {
-		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
+		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
 		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
 		if (IS_ERR(ckn)) {
 			ret = -EINVAL;
@@ -3260,7 +3282,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		if (ret)
 			goto out_destroy;
 
-		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3278,7 +3300,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
  * and "monitor" groups with given domain id.
  */
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
@@ -3286,12 +3308,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 
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
@@ -3300,14 +3322,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
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
@@ -4190,8 +4212,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
+	struct rdt_mon_domain *d;
+
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -4199,8 +4223,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d);
+		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		goto out_unlock;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4217,7 +4245,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	}
 
 	domain_destroy_mon_state(d);
-
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
@@ -4290,12 +4318,20 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 	return err;
 }
 
-int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	int err;
+	struct rdt_mon_domain *d;
+	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto mkdir;
+
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		goto out_unlock;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	err = domain_setup_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4309,6 +4345,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
+mkdir:
+	err = 0;
 	/*
 	 * If the filesystem is not mounted then only the default resource group
 	 * exists. Creation of its directories is deferred until mount time
@@ -4316,7 +4354,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		mkdir_mondata_subdir_allrdtgrp(r, d);
+		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-- 
2.51.0

