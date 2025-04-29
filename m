Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43981D5149
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886861; cv=none; b=iiCaejkUof6y69pbdSH7ciBsRwsf9rXKI7+RRKP1QrMLLm9TkD6rbtxgUlKoXpRan8Pem4nXpLiJmqlguKZMDR+PG6VL1gE+V3A01Cpa3aTZru3eX5dt+Uaw1+p2iQXqSJTO71IsKPIl3FSAWGp2MnVwh0wTiKyMpOqTlWGEAS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886861; c=relaxed/simple;
	bh=IOdEcQP1Ea7d6dgzls/RDy48D4uzrPd4dk38VdRfPuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2o2qnyUKbYb1WerwPgsR433ie08W8UlHKqgGKQhiKDcZnb5cj0DmPmOxSQHgSJ28xRrSYMl31WFR2TjLUAca7+t2FMeo/Ism4C4k0LYI9laOG+F3nusPCjkGO84dej5kPgG9EDok374LH3LlMW5vb6oek4+VbN1rjKBwRIn95Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e306QvGq; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e306QvGq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886859; x=1777422859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IOdEcQP1Ea7d6dgzls/RDy48D4uzrPd4dk38VdRfPuE=;
  b=e306QvGqH7fchk8Qe8UUKtak+stp3RnUFWkQxCv3PE5bJexdgf44ODW8
   TuAaErq/KirbSR2JIdZavDhcCl23WZaLns2UiDlDYjg5e+MyUme3CO29o
   1v8TAt5eaczb+T0FwHZ1vtoW9HZv3aaJlQCIlChpu3YjtdWSlEREavJEw
   mz3FL2hEPr5zjU+Yqe/nzpAFWn0xgRuLCIBQTPO8xNlFPZ1S+iVtwOjz/
   QWroIAMBCKxhxxVzYbA8XKHaGI/1d/9SOIIE4R5oGlQGTTHNAVGExPcST
   LK35rNLY30zbdYOOI2HrkbU86OlFM14E84ET2Qz7bHyhA8BCVeuv2xqfL
   A==;
X-CSE-ConnectionGUID: FLY6orJUQi6vdOl8cyD3tQ==
X-CSE-MsgGUID: tNWZ9/zoS3G2uu1dWKCsWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148149"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148149"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:14 -0700
X-CSE-ConnectionGUID: EZDv7CbmSy2JIHG3YdGeVg==
X-CSE-MsgGUID: Pq4cjU7TSqinxcLztJjRnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394004"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:13 -0700
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
Subject: [PATCH v4 12/31] fs/resctrl: Improve handling for events that can be read from any CPU
Date: Mon, 28 Apr 2025 17:33:38 -0700
Message-ID: <20250429003359.375508-13-tony.luck@intel.com>
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

Resctrl file system code was built with the assumption that monitor
events can only be read from a CPU in the cpumast_t set for each
domain. This was true for x86 events accessed with an MSR interface,
but may not be true for other access methods such as MMIO.

Add a flag to each instance of struct mon_evt that can be set by
architecture code to indicate there is no restriction on which
CPU can read the event counter.

Change struct mon_data and struct rmid_read to have a pointer to
the struct mon_evt instead of the event id.

Add an extra argument to resctrl_enable_mon_event() so architecture
code can indicate which events can be read on any CPU when enabling
the event.

Bypass all the smp_call*() code for events that can be read on any CPU
and call mon_event_count() directly from mon_event_read().

Skip checks in __mon_event_count() that the read is being done from
a CPU in the correct domain or cache scope.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 +-
 fs/resctrl/internal.h              | 12 +++++++-----
 arch/x86/kernel/cpu/resctrl/core.c |  6 +++---
 fs/resctrl/ctrlmondata.c           | 24 +++++++++++++++---------
 fs/resctrl/monitor.c               | 26 ++++++++++++++------------
 fs/resctrl/rdtgroup.c              |  6 +++---
 6 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index cd7881313d4e..4af5e8d30193 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -379,7 +379,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id evtid);
+void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu);
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 759768e2a2a8..d8aa69b42c74 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -72,6 +72,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @name:		name of the event
  * @configurable:	true if the event is configurable
  * @enabled:		true if the event is enabled
+ * @any_cpu:		true if the event can be read from any CPU
  * @list:		entry in &rdt_resource->evt_list
  */
 struct mon_evt {
@@ -80,6 +81,7 @@ struct mon_evt {
 	char			*name;
 	bool			configurable;
 	bool			enabled;
+	bool			any_cpu;
 	struct list_head	list;
 };
 
@@ -89,7 +91,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evt:             Event associated with the event file.
  * @sum:             Set when event must be summed across multiple
  *                   domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -103,7 +105,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 struct mon_data {
 	struct list_head	list;
 	enum resctrl_res_level	rid;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
 };
@@ -116,7 +118,7 @@ struct mon_data {
  * @r:	   Resource describing the properties of the event being read.
  * @d:	   Domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
- * @evtid: Which monitor event to read.
+ * @evt:   Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
@@ -130,7 +132,7 @@ struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_l3_mon_domain	*d;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	bool			first;
 	struct cacheinfo	*ci;
 	int			err;
@@ -366,7 +368,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
 int resctrl_mon_resource_init(void);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 01843dd0b8b7..58bc218070e2 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -877,15 +877,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
 		ret = true;
 	}
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 8c0f6d229130..7a2957b9c13e 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -527,7 +527,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    cpumask_t *cpumask, struct mon_evt *evt, int first)
 {
 	int cpu;
 
@@ -538,16 +538,21 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * Setup the parameters to pass to mon_event_count() to read the data.
 	 */
 	rr->rgrp = rdtgrp;
-	rr->evtid = evtid;
+	rr->evt = evt;
 	rr->r = r;
 	rr->d = d;
 	rr->first = first;
-	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
+	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evt->evtid);
 	if (IS_ERR(rr->arch_mon_ctx)) {
 		rr->err = -EINVAL;
 		return;
 	}
 
+	if (evt->any_cpu) {
+		mon_event_count(rr);
+		goto done;
+	}
+
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
@@ -560,8 +565,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		smp_call_function_any(cpumask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
-
-	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
+done:
+	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
@@ -570,7 +575,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
 	struct rdt_l3_mon_domain *d;
-	u32 resid, evtid, domid;
+	struct mon_evt *evt;
+	u32 resid, domid;
 	struct rdtgroup *rdtgrp;
 	struct rdt_resource *r;
 	struct mon_data *md;
@@ -590,7 +596,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -604,7 +610,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			if (d->ci->id == domid) {
 				rr.ci = d->ci;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &d->ci->shared_cpu_map, evtid, false);
+					       &d->ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -621,7 +627,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			goto out;
 		}
 		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
+		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 19cba29452b7..e903d3c076ee 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -365,19 +365,19 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	u64 tval = 0;
 
 	if (rr->first) {
-		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
-		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evt->evtid);
+		m = get_mbm_state(rr->d, closid, rmid, rr->evt->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
 	}
 
 	if (rr->d) {
-		/* Reading a single domain, must be on a CPU in that domain. */
-		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
+		/* Reading a single domain, must usually be on a CPU in that domain. */
+		if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
 			return -EINVAL;
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
-						 rr->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -387,7 +387,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	}
 
 	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
+	if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
 		return -EINVAL;
 
 	/*
@@ -402,7 +402,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (d->ci->id != rr->ci->id)
 			continue;
 		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
-					     rr->evtid, &tval, rr->arch_mon_ctx);
+					     rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -432,7 +432,7 @@ static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	u64 cur_bw, bytes, cur_bytes;
 	struct mbm_state *m;
 
-	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	m = get_mbm_state(rr->d, closid, rmid, rr->evt->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -603,12 +603,13 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_m
 static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
+	struct mon_evt *evt = &mon_event_all[evtid];
 	struct rmid_read rr = {0};
 
 	rr.r = r;
 	rr.d = d;
-	rr.evtid = evtid;
-	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+	rr.evt = evt;
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evtid);
 	if (IS_ERR(rr.arch_mon_ctx)) {
 		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
 				    PTR_ERR(rr.arch_mon_ctx));
@@ -624,7 +625,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 	if (is_mba_sc(NULL))
 		mbm_bw_count(closid, rmid, &rr);
 
-	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+	resctrl_arch_mon_ctx_free(rr.r, evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
@@ -859,12 +860,13 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id evtid)
+void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)
 {
 	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS))
 		return;
 
 	mon_event_all[evtid].enabled = true;
+	mon_event_all[evtid].any_cpu = any_cpu;
 }
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id evtid)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index d2f9361694b6..d16bb05fafe8 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2897,7 +2897,7 @@ static struct mon_data *mon_get_kn_priv(int rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -2908,7 +2908,7 @@ static struct mon_data *mon_get_kn_priv(int rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3082,7 +3082,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.48.1

