Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5D634DCD8
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754895; cv=none; b=rUVVvM2rjG6ArCHt+c0JxGgt8BrSwefyAWgo9FCyr2+WrLRkHMkvbhvCNN4vOwsOvr+8h6QmrDDfSkqGvIO9b/OwdWI3e6kVG8gYeDkFkt3SlYT833OGBhyipnbvHi7P5fyYS9rxDEY1VAf3nhpfRazcAlrvvKFILP71Fdn5WLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754895; c=relaxed/simple;
	bh=bHh2bX+QnJ7M7NL8+xbHMFqK/RFLObhAiM69GE6Gxa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC9SKqB9TYaDXrrbvSh5zWI7naLj3CxcOfyWZ3MogbsfamM1y5m0Ex2z+o1PqkvzGcLO8aQjmczHKqL2juVFc+fkqagdBcx5ppwmdcgfV2cq+gUryWPZD1y8yY78TzGkyRoq4LelsbkkjOW4q7yu9iAQ77XgEeALfu+HAgRhNGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GrD8gPza; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GrD8gPza"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754893; x=1793290893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bHh2bX+QnJ7M7NL8+xbHMFqK/RFLObhAiM69GE6Gxa0=;
  b=GrD8gPza+K1ng2BZNIQJX85XD+WMNOQp2ezz6DhVD4RUkGnIsSj8UMwg
   ncMsu5tXXbAOIj3AIe3Q/iVnSr6/G/1Ih/+28DF+ycFJ6CFjmhfd04/nr
   g658JesE4D2K5Tkb9xHXaMDm5TnnqD9qYqjQ2JSTfmdAWOjpVvQAA9NlC
   4qyHeiEg/kb/lJCrRBas/E30b0M9yFWFnSgdKS1JZfVdX6XhuS9CJPeT/
   HGG0FZl1uXmZNkNxVsmjzjVPsgKSCeuB1yzF9IoQVPQwjTP8iuHM+akkU
   CRiikH7cC4VmNn8XyFPSye3fhVM5A4cqwilNDS54GreF4lL3ruUCkVzqk
   A==;
X-CSE-ConnectionGUID: ydELseyrQK+JzFI7mL4Rtw==
X-CSE-MsgGUID: VQ9apMg8Qaql79tqmkEefw==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481320"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481320"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:28 -0700
X-CSE-ConnectionGUID: qjU6eu5nQNuavkpR6zopug==
X-CSE-MsgGUID: rCyjfQD/SgyMs/7iPu0Ekg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901329"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:28 -0700
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
Subject: [PATCH v13 10/32] fs/resctrl: Make event details accessible to functions when reading events
Date: Wed, 29 Oct 2025 09:20:53 -0700
Message-ID: <20251029162118.40604-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reading monitoring event data from MMIO requires more context than the event id
to be able to read the correct memory location. struct mon_evt is the appropriate
place for this event specific context.

Prepare for addition of extra fields to struct mon_evt by changing the calling
conventions to pass a pointer to the mon_evt structure instead of just the
event id.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/internal.h    | 10 +++++-----
 fs/resctrl/ctrlmondata.c | 18 +++++++++---------
 fs/resctrl/monitor.c     | 24 ++++++++++++------------
 fs/resctrl/rdtgroup.c    |  6 +++---
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 88b4489b68e1..12a2ab7e3c9b 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -81,7 +81,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evt:             Event structure associated with the event file.
  * @sum:             Set when event must be summed across multiple
  *                   domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -95,7 +95,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 struct mon_data {
 	struct list_head	list;
 	enum resctrl_res_level	rid;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
 };
@@ -108,7 +108,7 @@ struct mon_data {
  * @r:	   Resource describing the properties of the event being read.
  * @hdr:   Header of domain that the counter should be read from. If NULL then
  *	   sum all domains in @r sharing L3 @ci.id
- * @evtid: Which monitor event to read.
+ * @evt:   Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @ci:    Cacheinfo for L3. Only set when @hdr is NULL. Used when summing
  *	   domains.
@@ -126,7 +126,7 @@ struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_domain_hdr	*hdr;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	bool			first;
 	struct cacheinfo	*ci;
 	bool			is_mbm_cntr;
@@ -367,7 +367,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index b74c69f2d54e..c3656812848b 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -548,7 +548,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    cpumask_t *cpumask, struct mon_evt *evt, int first)
 {
 	int cpu;
 
@@ -559,15 +559,15 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * Setup the parameters to pass to mon_event_count() to read the data.
 	 */
 	rr->rgrp = rdtgrp;
-	rr->evtid = evtid;
+	rr->evt = evt;
 	rr->r = r;
 	rr->hdr = hdr;
 	rr->first = first;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
-	    resctrl_is_mbm_event(evtid)) {
+	    resctrl_is_mbm_event(evt->evtid)) {
 		rr->is_mbm_cntr = true;
 	} else {
-		rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
+		rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evt->evtid);
 		if (IS_ERR(rr->arch_mon_ctx)) {
 			rr->err = -EINVAL;
 			return;
@@ -588,14 +588,13 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
 	if (rr->arch_mon_ctx)
-		resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
+		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
 	enum resctrl_res_level resid;
-	enum resctrl_event_id evtid;
 	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
@@ -603,6 +602,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	int domid, cpu, ret = 0;
 	struct rdt_resource *r;
 	struct cacheinfo *ci;
+	struct mon_evt *evt;
 	struct mon_data *md;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
@@ -619,7 +619,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -637,7 +637,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 					continue;
 				rr.ci = ci;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &ci->shared_cpu_map, evtid, false);
+					       &ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -653,7 +653,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 84e3d3ce66cf..5cf928e10eaf 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -425,7 +425,7 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr,
 	u64 tval = 0;
 
 	if (rr->is_mbm_cntr) {
-		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
+		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
 		if (cntr_id < 0) {
 			rr->err = -ENOENT;
 			return -EINVAL;
@@ -434,10 +434,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr,
 
 	if (rr->first) {
 		if (rr->is_mbm_cntr)
-			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
+			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evt->evtid);
 		else
-			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
-		m = get_mbm_state(d, closid, rmid, rr->evtid);
+			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
+		m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
@@ -449,10 +449,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr,
 			return -EINVAL;
 		if (rr->is_mbm_cntr)
 			rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
-							 rr->evtid, &tval);
+							 rr->evt->evtid, &tval);
 		else
 			rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-							 rr->evtid, &tval, rr->arch_mon_ctx);
+							 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -478,10 +478,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr,
 			continue;
 		if (rr->is_mbm_cntr)
 			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
-						     rr->evtid, &tval);
+						     rr->evt->evtid, &tval);
 		else
 			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-						     rr->evtid, &tval, rr->arch_mon_ctx);
+						     rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -539,7 +539,7 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-	m = get_mbm_state(d, closid, rmid, rr->evtid);
+	m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -713,11 +713,11 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 
 	rr.r = r;
 	rr.hdr = &d->hdr;
-	rr.evtid = evtid;
+	rr.evt = &mon_event_all[evtid];
 	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rr.is_mbm_cntr = true;
 	} else {
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evtid);
 		if (IS_ERR(rr.arch_mon_ctx)) {
 			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
 					    PTR_ERR(rr.arch_mon_ctx));
@@ -735,7 +735,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 		mbm_bw_count(rdtgrp, &rr);
 
 	if (rr.arch_mon_ctx)
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+		resctrl_arch_mon_ctx_free(rr.r, evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index f57775c40d14..e0eb766c5cf4 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3038,7 +3038,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -3049,7 +3049,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3216,7 +3216,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.51.0

