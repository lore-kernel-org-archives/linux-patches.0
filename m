Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ADB14B975
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044542; cv=none; b=YxeW2jlS1b5etWuDfikN5xQ8EWi9pbD/2fwieRyDKHJPj35Bj7U3c8zeaH7hMon1jJMiyuGKYOEJBE0McV/veQKdDks/BDVqV1jbiglHB3WEbCo+4sKgTQMrJ5KGUSDbN+MhzpkwAS6S7Gp07jKzX85H8sDlKupNAvYTmy0/AZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044542; c=relaxed/simple;
	bh=1H/SxvUGe6n7mV9skcaEWc12O6amQQ48zJ8Xk9OW/BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzWV0a4+qwN91LutJ3o6OvUpZvTvYUZ7Gasu5M4mzjIKU4Waqg4YOLiB6tpgmMXtRvs4Js8x4bUHXW7eCwdZQc7bEcunnfugIGULOqFmYkQsKXOEdtsaHVTkIUriptony3e0ThrdmLIK2fshzU4/olg3kIXAd7j7ZpoYc+kKI6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aL58NDGC; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aL58NDGC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044541; x=1749580541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1H/SxvUGe6n7mV9skcaEWc12O6amQQ48zJ8Xk9OW/BQ=;
  b=aL58NDGC6P5NvAhw5ur8iD7dCOvDC/fy/Z7LBg/lNxSawuH015tgRnKS
   QWK6fYUcoba9qYdpwdHaaw+GuGhf0vdCLCw1MGwyKtNfWwSCG7h2Diol4
   yvH+TNvVPGi9CmOk9OEmCihzLaInu7WxjmcLBnoMfLltyXTh8hkt1pDy1
   QSCkbB5oD4e8cEI4f4jf3wtUvfiw/rKH0vuieHntUtRkKn+f+8eNIBn7/
   ph/F2QumNT1xGORJisEQVm7HmWtw/VboPpkB2IIArQkSHASdZR/cw2k6g
   J3JX6XtZOpOEBKrDsrMTNlURiwhUT7OPDBBdO5DIC5S+89fv31Nr7NoKf
   w==;
X-CSE-ConnectionGUID: 3UJ0U45pSDqLMs9H2kfPOQ==
X-CSE-MsgGUID: CMWLrvNWTOeZsXHOsQQCzg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004781"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004781"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:37 -0700
X-CSE-ConnectionGUID: E7GdUGRlQ6uPxbNmW7GoJw==
X-CSE-MsgGUID: /VhDWuXRQ0moD1iiUjsniA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576553"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v20 02/18] x86/resctrl: Prepare to split rdt_domain structure
Date: Mon, 10 Jun 2024 11:35:12 -0700
Message-ID: <20240610183528.349198-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rdt_domain structure is used for both control and monitor features.
It is about to be split into separate structures for these two usages
because the scope for control and monitoring features for a resource
will be different for future resources.

To allow for common code that scans a list of domains looking for a
specific domain id, move all the common fields ("list", "id", "cpu_mask")
into their own structure within the rdt_domain structure.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                   | 16 ++++--
 arch/x86/kernel/cpu/resctrl/core.c        | 26 +++++-----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 24 ++++-----
 arch/x86/kernel/cpu/resctrl/monitor.c     | 14 +++---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 14 +++---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 60 +++++++++++------------
 6 files changed, 81 insertions(+), 73 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index ed693bfe474d..f63fcf17a3bc 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -59,10 +59,20 @@ struct resctrl_staged_config {
 };
 
 /**
- * struct rdt_domain - group of CPUs sharing a resctrl resource
+ * struct rdt_domain_hdr - common header for different domain types
  * @list:		all instances of this resource
  * @id:			unique id for this instance
  * @cpu_mask:		which CPUs share this resource
+ */
+struct rdt_domain_hdr {
+	struct list_head		list;
+	int				id;
+	struct cpumask			cpu_mask;
+};
+
+/**
+ * struct rdt_domain - group of CPUs sharing a resctrl resource
+ * @hdr:		common header for different domain types
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
  * @mbm_total:		saved state for MBM total bandwidth
  * @mbm_local:		saved state for MBM local bandwidth
@@ -77,9 +87,7 @@ struct resctrl_staged_config {
  *			by closid
  */
 struct rdt_domain {
-	struct list_head		list;
-	int				id;
-	struct cpumask			cpu_mask;
+	struct rdt_domain_hdr		hdr;
 	unsigned long			*rmid_busy_llc;
 	struct mbm_state		*mbm_total;
 	struct mbm_state		*mbm_local;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f85b2ff40eef..96fff44f9d03 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -355,9 +355,9 @@ struct rdt_domain *get_domain_from_cpu(int cpu, struct rdt_resource *r)
 
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(d, &r->domains, list) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
 		/* Find the domain that contains this CPU */
-		if (cpumask_test_cpu(cpu, &d->cpu_mask))
+		if (cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
 			return d;
 	}
 
@@ -393,12 +393,12 @@ struct rdt_domain *rdt_find_domain(struct rdt_resource *r, int id,
 	struct list_head *l;
 
 	list_for_each(l, &r->domains) {
-		d = list_entry(l, struct rdt_domain, list);
+		d = list_entry(l, struct rdt_domain, hdr.list);
 		/* When id is found, return its domain. */
-		if (id == d->id)
+		if (id == d->hdr.id)
 			return d;
 		/* Stop searching when finding id's position in sorted list. */
-		if (id < d->id)
+		if (id < d->hdr.id)
 			break;
 	}
 
@@ -526,7 +526,7 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	d = rdt_find_domain(r, id, &add_pos);
 
 	if (d) {
-		cpumask_set_cpu(cpu, &d->cpu_mask);
+		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 		if (r->cache.arch_has_per_cpu_cfg)
 			rdt_domain_reconfigure_cdp(r);
 		return;
@@ -537,8 +537,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 		return;
 
 	d = &hw_dom->d_resctrl;
-	d->id = id;
-	cpumask_set_cpu(cpu, &d->cpu_mask);
+	d->hdr.id = id;
+	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
 	rdt_domain_reconfigure_cdp(r);
 
@@ -552,11 +552,11 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	list_add_tail_rcu(&d->list, add_pos);
+	list_add_tail_rcu(&d->hdr.list, add_pos);
 
 	err = resctrl_online_domain(r, d);
 	if (err) {
-		list_del_rcu(&d->list);
+		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
 		domain_free(hw_dom);
 	}
@@ -583,10 +583,10 @@ static void domain_remove_cpu(int cpu, struct rdt_resource *r)
 	}
 	hw_dom = resctrl_to_arch_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->cpu_mask);
-	if (cpumask_empty(&d->cpu_mask)) {
+	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
+	if (cpumask_empty(&d->hdr.cpu_mask)) {
 		resctrl_offline_domain(r, d);
-		list_del_rcu(&d->list);
+		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
 
 		/*
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 2bf021d42500..6246f48b0449 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -69,7 +69,7 @@ int parse_bw(struct rdt_parse_data *data, struct resctrl_schema *s,
 
 	cfg = &d->staged_config[s->conf_type];
 	if (cfg->have_new_ctrl) {
-		rdt_last_cmd_printf("Duplicate domain %d\n", d->id);
+		rdt_last_cmd_printf("Duplicate domain %d\n", d->hdr.id);
 		return -EINVAL;
 	}
 
@@ -148,7 +148,7 @@ int parse_cbm(struct rdt_parse_data *data, struct resctrl_schema *s,
 
 	cfg = &d->staged_config[s->conf_type];
 	if (cfg->have_new_ctrl) {
-		rdt_last_cmd_printf("Duplicate domain %d\n", d->id);
+		rdt_last_cmd_printf("Duplicate domain %d\n", d->hdr.id);
 		return -EINVAL;
 	}
 
@@ -231,8 +231,8 @@ static int parse_line(char *line, struct resctrl_schema *s,
 		return -EINVAL;
 	}
 	dom = strim(dom);
-	list_for_each_entry(d, &r->domains, list) {
-		if (d->id == dom_id) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
+		if (d->hdr.id == dom_id) {
 			data.buf = dom;
 			data.rdtgrp = rdtgrp;
 			if (r->parse_ctrlval(&data, s, d))
@@ -280,7 +280,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_domain *d,
 	u32 idx = get_config_index(closid, t);
 	struct msr_param msr_param;
 
-	if (!cpumask_test_cpu(smp_processor_id(), &d->cpu_mask))
+	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
 		return -EINVAL;
 
 	hw_dom->ctrl_val[idx] = cfg_val;
@@ -306,7 +306,7 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(d, &r->domains, list) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
 		hw_dom = resctrl_to_arch_dom(d);
 		msr_param.res = NULL;
 		for (t = 0; t < CDP_NUM_TYPES; t++) {
@@ -330,7 +330,7 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
 			}
 		}
 		if (msr_param.res)
-			smp_call_function_any(&d->cpu_mask, rdt_ctrl_update, &msr_param, 1);
+			smp_call_function_any(&d->hdr.cpu_mask, rdt_ctrl_update, &msr_param, 1);
 	}
 
 	return 0;
@@ -450,7 +450,7 @@ static void show_doms(struct seq_file *s, struct resctrl_schema *schema, int clo
 	lockdep_assert_cpus_held();
 
 	seq_printf(s, "%*s:", max_name_width, schema->name);
-	list_for_each_entry(dom, &r->domains, list) {
+	list_for_each_entry(dom, &r->domains, hdr.list) {
 		if (sep)
 			seq_puts(s, ";");
 
@@ -460,7 +460,7 @@ static void show_doms(struct seq_file *s, struct resctrl_schema *schema, int clo
 			ctrl_val = resctrl_arch_get_config(r, dom, closid,
 							   schema->conf_type);
 
-		seq_printf(s, r->format_str, dom->id, max_data_width,
+		seq_printf(s, r->format_str, dom->hdr.id, max_data_width,
 			   ctrl_val);
 		sep = true;
 	}
@@ -489,7 +489,7 @@ int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			} else {
 				seq_printf(s, "%s:%d=%x\n",
 					   rdtgrp->plr->s->res->name,
-					   rdtgrp->plr->d->id,
+					   rdtgrp->plr->d->hdr.id,
 					   rdtgrp->plr->cbm);
 			}
 		} else {
@@ -537,7 +537,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		return;
 	}
 
-	cpu = cpumask_any_housekeeping(&d->cpu_mask, RESCTRL_PICK_ANY_CPU);
+	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
 
 	/*
 	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
@@ -546,7 +546,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * counters on some platforms if its called in IRQ context.
 	 */
 	if (tick_nohz_full_cpu(cpu))
-		smp_call_function_any(&d->cpu_mask, mon_event_count, rr, 1);
+		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 2345e6836593..ab8a198d88b3 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -281,7 +281,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain *d,
 
 	resctrl_arch_rmid_read_context_check();
 
-	if (!cpumask_test_cpu(smp_processor_id(), &d->cpu_mask))
+	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
 		return -EINVAL;
 
 	ret = __rmid_read(rmid, eventid, &msr_val);
@@ -364,7 +364,7 @@ void __check_limbo(struct rdt_domain *d, bool force_free)
 			 * CLOSID and RMID because there may be dependencies between them
 			 * on some architectures.
 			 */
-			trace_mon_llc_occupancy_limbo(entry->closid, entry->rmid, d->id, val);
+			trace_mon_llc_occupancy_limbo(entry->closid, entry->rmid, d->hdr.id, val);
 		}
 
 		if (force_free || !rmid_dirty) {
@@ -490,7 +490,7 @@ static void add_rmid_to_limbo(struct rmid_entry *entry)
 	idx = resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid);
 
 	entry->busy = 0;
-	list_for_each_entry(d, &r->domains, list) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
 		/*
 		 * For the first limbo RMID in the domain,
 		 * setup up the limbo worker.
@@ -801,7 +801,7 @@ void cqm_handle_limbo(struct work_struct *work)
 	__check_limbo(d, false);
 
 	if (has_busy_rmid(d)) {
-		d->cqm_work_cpu = cpumask_any_housekeeping(&d->cpu_mask,
+		d->cqm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
 							   RESCTRL_PICK_ANY_CPU);
 		schedule_delayed_work_on(d->cqm_work_cpu, &d->cqm_limbo,
 					 delay);
@@ -825,7 +825,7 @@ void cqm_setup_limbo_handler(struct rdt_domain *dom, unsigned long delay_ms,
 	unsigned long delay = msecs_to_jiffies(delay_ms);
 	int cpu;
 
-	cpu = cpumask_any_housekeeping(&dom->cpu_mask, exclude_cpu);
+	cpu = cpumask_any_housekeeping(&dom->hdr.cpu_mask, exclude_cpu);
 	dom->cqm_work_cpu = cpu;
 
 	if (cpu < nr_cpu_ids)
@@ -868,7 +868,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * Re-check for housekeeping CPUs. This allows the overflow handler to
 	 * move off a nohz_full CPU quickly.
 	 */
-	d->mbm_work_cpu = cpumask_any_housekeeping(&d->cpu_mask,
+	d->mbm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
 						   RESCTRL_PICK_ANY_CPU);
 	schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);
 
@@ -897,7 +897,7 @@ void mbm_setup_overflow_handler(struct rdt_domain *dom, unsigned long delay_ms,
 	 */
 	if (!resctrl_mounted || !resctrl_arch_mon_capable())
 		return;
-	cpu = cpumask_any_housekeeping(&dom->cpu_mask, exclude_cpu);
+	cpu = cpumask_any_housekeeping(&dom->hdr.cpu_mask, exclude_cpu);
 	dom->mbm_work_cpu = cpu;
 
 	if (cpu < nr_cpu_ids)
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 201011f0ed0b..df45c839a58f 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -221,7 +221,7 @@ static int pseudo_lock_cstates_constrain(struct pseudo_lock_region *plr)
 	int cpu;
 	int ret;
 
-	for_each_cpu(cpu, &plr->d->cpu_mask) {
+	for_each_cpu(cpu, &plr->d->hdr.cpu_mask) {
 		pm_req = kzalloc(sizeof(*pm_req), GFP_KERNEL);
 		if (!pm_req) {
 			rdt_last_cmd_puts("Failure to allocate memory for PM QoS\n");
@@ -300,7 +300,7 @@ static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 		return -ENODEV;
 
 	/* Pick the first cpu we find that is associated with the cache. */
-	plr->cpu = cpumask_first(&plr->d->cpu_mask);
+	plr->cpu = cpumask_first(&plr->d->hdr.cpu_mask);
 
 	if (!cpu_online(plr->cpu)) {
 		rdt_last_cmd_printf("CPU %u associated with cache not online\n",
@@ -854,10 +854,10 @@ bool rdtgroup_pseudo_locked_in_hierarchy(struct rdt_domain *d)
 	 * associated with them.
 	 */
 	for_each_alloc_capable_rdt_resource(r) {
-		list_for_each_entry(d_i, &r->domains, list) {
+		list_for_each_entry(d_i, &r->domains, hdr.list) {
 			if (d_i->plr)
 				cpumask_or(cpu_with_psl, cpu_with_psl,
-					   &d_i->cpu_mask);
+					   &d_i->hdr.cpu_mask);
 		}
 	}
 
@@ -865,7 +865,7 @@ bool rdtgroup_pseudo_locked_in_hierarchy(struct rdt_domain *d)
 	 * Next test if new pseudo-locked region would intersect with
 	 * existing region.
 	 */
-	if (cpumask_intersects(&d->cpu_mask, cpu_with_psl))
+	if (cpumask_intersects(&d->hdr.cpu_mask, cpu_with_psl))
 		ret = true;
 
 	free_cpumask_var(cpu_with_psl);
@@ -1197,7 +1197,7 @@ static int pseudo_lock_measure_cycles(struct rdtgroup *rdtgrp, int sel)
 	}
 
 	plr->thread_done = 0;
-	cpu = cpumask_first(&plr->d->cpu_mask);
+	cpu = cpumask_first(&plr->d->hdr.cpu_mask);
 	if (!cpu_online(cpu)) {
 		ret = -ENODEV;
 		goto out;
@@ -1527,7 +1527,7 @@ static int pseudo_lock_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 	 * may be scheduled elsewhere and invalidate entries in the
 	 * pseudo-locked region.
 	 */
-	if (!cpumask_subset(current->cpus_ptr, &plr->d->cpu_mask)) {
+	if (!cpumask_subset(current->cpus_ptr, &plr->d->hdr.cpu_mask)) {
 		mutex_unlock(&rdtgroup_mutex);
 		return -EINVAL;
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 50f5876a3020..b6ba77cdf0e8 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -98,7 +98,7 @@ void rdt_staged_configs_clear(void)
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	for_each_alloc_capable_rdt_resource(r) {
-		list_for_each_entry(dom, &r->domains, list)
+		list_for_each_entry(dom, &r->domains, hdr.list)
 			memset(dom->staged_config, 0, sizeof(dom->staged_config));
 	}
 }
@@ -317,7 +317,7 @@ static int rdtgroup_cpus_show(struct kernfs_open_file *of,
 				rdt_last_cmd_puts("Cache domain offline\n");
 				ret = -ENODEV;
 			} else {
-				mask = &rdtgrp->plr->d->cpu_mask;
+				mask = &rdtgrp->plr->d->hdr.cpu_mask;
 				seq_printf(s, is_cpu_list(of) ?
 					   "%*pbl\n" : "%*pb\n",
 					   cpumask_pr_args(mask));
@@ -1021,12 +1021,12 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	hw_shareable = r->cache.shareable_bits;
-	list_for_each_entry(dom, &r->domains, list) {
+	list_for_each_entry(dom, &r->domains, hdr.list) {
 		if (sep)
 			seq_putc(seq, ';');
 		sw_shareable = 0;
 		exclusive = 0;
-		seq_printf(seq, "%d=", dom->id);
+		seq_printf(seq, "%d=", dom->hdr.id);
 		for (i = 0; i < closids_supported(); i++) {
 			if (!closid_allocated(i))
 				continue;
@@ -1343,7 +1343,7 @@ static bool rdtgroup_mode_test_exclusive(struct rdtgroup *rdtgrp)
 		if (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_SMBA)
 			continue;
 		has_cache = true;
-		list_for_each_entry(d, &r->domains, list) {
+		list_for_each_entry(d, &r->domains, hdr.list) {
 			ctrl = resctrl_arch_get_config(r, d, closid,
 						       s->conf_type);
 			if (rdtgroup_cbm_overlaps(s, d, ctrl, closid, false)) {
@@ -1458,7 +1458,7 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 		return size;
 
 	num_b = bitmap_weight(&cbm, r->cache.cbm_len);
-	ci = get_cpu_cacheinfo_level(cpumask_any(&d->cpu_mask), r->scope);
+	ci = get_cpu_cacheinfo_level(cpumask_any(&d->hdr.cpu_mask), r->scope);
 	if (ci)
 		size = ci->size / r->cache.cbm_len * num_b;
 
@@ -1502,7 +1502,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 			size = rdtgroup_cbm_to_size(rdtgrp->plr->s->res,
 						    rdtgrp->plr->d,
 						    rdtgrp->plr->cbm);
-			seq_printf(s, "%d=%u\n", rdtgrp->plr->d->id, size);
+			seq_printf(s, "%d=%u\n", rdtgrp->plr->d->hdr.id, size);
 		}
 		goto out;
 	}
@@ -1514,7 +1514,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 		type = schema->conf_type;
 		sep = false;
 		seq_printf(s, "%*s:", max_name_width, schema->name);
-		list_for_each_entry(d, &r->domains, list) {
+		list_for_each_entry(d, &r->domains, hdr.list) {
 			if (sep)
 				seq_putc(s, ';');
 			if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
@@ -1532,7 +1532,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 				else
 					size = rdtgroup_cbm_to_size(r, d, ctrl);
 			}
-			seq_printf(s, "%d=%u", d->id, size);
+			seq_printf(s, "%d=%u", d->hdr.id, size);
 			sep = true;
 		}
 		seq_putc(s, '\n');
@@ -1592,7 +1592,7 @@ static void mon_event_config_read(void *info)
 
 static void mondata_config_read(struct rdt_domain *d, struct mon_config_info *mon_info)
 {
-	smp_call_function_any(&d->cpu_mask, mon_event_config_read, mon_info, 1);
+	smp_call_function_any(&d->hdr.cpu_mask, mon_event_config_read, mon_info, 1);
 }
 
 static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid)
@@ -1604,7 +1604,7 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
-	list_for_each_entry(dom, &r->domains, list) {
+	list_for_each_entry(dom, &r->domains, hdr.list) {
 		if (sep)
 			seq_puts(s, ";");
 
@@ -1612,7 +1612,7 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
 		mon_info.evtid = evtid;
 		mondata_config_read(dom, &mon_info);
 
-		seq_printf(s, "%d=0x%02x", dom->id, mon_info.mon_config);
+		seq_printf(s, "%d=0x%02x", dom->hdr.id, mon_info.mon_config);
 		sep = true;
 	}
 	seq_puts(s, "\n");
@@ -1678,7 +1678,7 @@ static void mbm_config_write_domain(struct rdt_resource *r,
 	 * are scoped at the domain level. Writing any of these MSRs
 	 * on one CPU is observed by all the CPUs in the domain.
 	 */
-	smp_call_function_any(&d->cpu_mask, mon_event_config_write,
+	smp_call_function_any(&d->hdr.cpu_mask, mon_event_config_write,
 			      &mon_info, 1);
 
 	/*
@@ -1728,8 +1728,8 @@ static int mon_config_write(struct rdt_resource *r, char *tok, u32 evtid)
 		return -EINVAL;
 	}
 
-	list_for_each_entry(d, &r->domains, list) {
-		if (d->id == dom_id) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
+		if (d->hdr.id == dom_id) {
 			mbm_config_write_domain(r, d, evtid, val);
 			goto next;
 		}
@@ -2276,14 +2276,14 @@ static int set_cache_qos_cfg(int level, bool enable)
 		return -ENOMEM;
 
 	r_l = &rdt_resources_all[level].r_resctrl;
-	list_for_each_entry(d, &r_l->domains, list) {
+	list_for_each_entry(d, &r_l->domains, hdr.list) {
 		if (r_l->cache.arch_has_per_cpu_cfg)
 			/* Pick all the CPUs in the domain instance */
-			for_each_cpu(cpu, &d->cpu_mask)
+			for_each_cpu(cpu, &d->hdr.cpu_mask)
 				cpumask_set_cpu(cpu, cpu_mask);
 		else
 			/* Pick one CPU from each domain instance to update MSR */
-			cpumask_set_cpu(cpumask_any(&d->cpu_mask), cpu_mask);
+			cpumask_set_cpu(cpumask_any(&d->hdr.cpu_mask), cpu_mask);
 	}
 
 	/* Update QOS_CFG MSR on all the CPUs in cpu_mask */
@@ -2312,7 +2312,7 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r)
 static int mba_sc_domain_allocate(struct rdt_resource *r, struct rdt_domain *d)
 {
 	u32 num_closid = resctrl_arch_get_num_closid(r);
-	int cpu = cpumask_any(&d->cpu_mask);
+	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	int i;
 
 	d->mbps_val = kcalloc_node(num_closid, sizeof(*d->mbps_val),
@@ -2361,7 +2361,7 @@ static int set_mba_sc(bool mba_sc)
 
 	r->membw.mba_sc = mba_sc;
 
-	list_for_each_entry(d, &r->domains, list) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
 		for (i = 0; i < num_closid; i++)
 			d->mbps_val[i] = MBA_MAX_MBPS;
 	}
@@ -2700,7 +2700,7 @@ static int rdt_get_tree(struct fs_context *fc)
 
 	if (is_mbm_enabled()) {
 		r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-		list_for_each_entry(dom, &r->domains, list)
+		list_for_each_entry(dom, &r->domains, hdr.list)
 			mbm_setup_overflow_handler(dom, MBM_OVERFLOW_INTERVAL,
 						   RESCTRL_PICK_ANY_CPU);
 	}
@@ -2827,13 +2827,13 @@ static int reset_all_ctrls(struct rdt_resource *r)
 	 * CBMs in all domains to the maximum mask value. Pick one CPU
 	 * from each domain to update the MSRs below.
 	 */
-	list_for_each_entry(d, &r->domains, list) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
 		hw_dom = resctrl_to_arch_dom(d);
 
 		for (i = 0; i < hw_res->num_closid; i++)
 			hw_dom->ctrl_val[i] = r->default_ctrl;
 		msr_param.dom = d;
-		smp_call_function_any(&d->cpu_mask, rdt_ctrl_update, &msr_param, 1);
+		smp_call_function_any(&d->hdr.cpu_mask, rdt_ctrl_update, &msr_param, 1);
 	}
 
 	return 0;
@@ -3031,7 +3031,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	char name[32];
 	int ret;
 
-	sprintf(name, "mon_%s_%02d", r->name, d->id);
+	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
 	/* create the directory */
 	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
 	if (IS_ERR(kn))
@@ -3047,7 +3047,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	}
 
 	priv.u.rid = r->rid;
-	priv.u.domid = d->id;
+	priv.u.domid = d->hdr.id;
 	list_for_each_entry(mevt, &r->evt_list, list) {
 		priv.u.evtid = mevt->evtid;
 		ret = mon_addfile(kn, mevt->name, priv.priv);
@@ -3098,7 +3098,7 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(dom, &r->domains, list) {
+	list_for_each_entry(dom, &r->domains, hdr.list) {
 		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
 		if (ret)
 			return ret;
@@ -3257,7 +3257,7 @@ static int __init_one_rdt_domain(struct rdt_domain *d, struct resctrl_schema *s,
 	 */
 	tmp_cbm = cfg->new_ctrl;
 	if (bitmap_weight(&tmp_cbm, r->cache.cbm_len) < r->cache.min_cbm_bits) {
-		rdt_last_cmd_printf("No space on %s:%d\n", s->name, d->id);
+		rdt_last_cmd_printf("No space on %s:%d\n", s->name, d->hdr.id);
 		return -ENOSPC;
 	}
 	cfg->have_new_ctrl = true;
@@ -3280,7 +3280,7 @@ static int rdtgroup_init_cat(struct resctrl_schema *s, u32 closid)
 	struct rdt_domain *d;
 	int ret;
 
-	list_for_each_entry(d, &s->res->domains, list) {
+	list_for_each_entry(d, &s->res->domains, hdr.list) {
 		ret = __init_one_rdt_domain(d, s, closid);
 		if (ret < 0)
 			return ret;
@@ -3295,7 +3295,7 @@ static void rdtgroup_init_mba(struct rdt_resource *r, u32 closid)
 	struct resctrl_staged_config *cfg;
 	struct rdt_domain *d;
 
-	list_for_each_entry(d, &r->domains, list) {
+	list_for_each_entry(d, &r->domains, hdr.list) {
 		if (is_mba_sc(r)) {
 			d->mbps_val[closid] = MBA_MAX_MBPS;
 			continue;
@@ -3941,7 +3941,7 @@ void resctrl_offline_domain(struct rdt_resource *r, struct rdt_domain *d)
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->id);
+		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.45.0

