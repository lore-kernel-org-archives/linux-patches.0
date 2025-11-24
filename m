Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10F73203AB
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010493; cv=none; b=E3ng4gAYmCBqyIEVDLCIWj8hA5KfZ+OQUC2+8RJKaqEZYBbtwZE2akZtcrtJZ9pc8XkUSYM4oyP7FsYlq5b9kvLf1H1vB3yZq3ORyiHje3tqZZf4RFB3cAz9XjQaf+Zz5rot47Zefp7GvrqT06kzSpVsyzGbhxAk2B2NcZIRO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010493; c=relaxed/simple;
	bh=1Lg9QO4b0dxS8GCGSgAmVs74S3fikL9rrwIzqra9kZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCHkOaeg36ihW5Yz2PDUbIZY9ihBZo6bYzZ7yDucboxuPi4Q7XdXqMdloi6t+6DWgMXSRccVhIj9ImQc8xcqUmB7D758eqK/BjKYGUU3oqoViAgYj7NcUQpOwZ6dnoysaTK2nlCU+pfrlbqb4KPZ4XMWj75BWjfTwSvUxaUGVIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XnkEmgnP; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XnkEmgnP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010492; x=1795546492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Lg9QO4b0dxS8GCGSgAmVs74S3fikL9rrwIzqra9kZM=;
  b=XnkEmgnPVWmsE0tg8bC0OjPXSCEl+s2oeHwzZloHUYe+r2aqtJNfPbD8
   Pn+L9gkhzwQiLTH0emr7li/iqyhEwg9sIxYhky7B/WwzwhnUx6HQO6gic
   iE1syulOk3iWf/hFELNcn+DwZJtlhBWzExhyAhebsU713BxpTxlQ8hTpe
   AG4NnStmguv1L+6JyK8dHKj9fby7fXqhCemSbOZMSk4tYIydVjUGsJqns
   vXWkOn3MWmFRhmtdrLdGJtfx7bJbVxoAHXj20a1nduFgD/UtftuIJfrUx
   LnmjQE4YkGfFYZQDbH4/+7IBvXqReTzvd8OgU9SMASrmroGKHorh+T83N
   Q==;
X-CSE-ConnectionGUID: uqn3TTSOS6mRov3l3avLvQ==
X-CSE-MsgGUID: 0U33Xk2kTOKWkkJn4eR2GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636580"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636580"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:25 -0800
X-CSE-ConnectionGUID: 7F19BqNoT2auQCwsXLSzIA==
X-CSE-MsgGUID: iBajUwzGQ9GLJ/DxtCWHqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224973"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:25 -0800
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
Subject: [PATCH v14 10/32] fs/resctrl: Make event details accessible to functions when reading events
Date: Mon, 24 Nov 2025 10:53:47 -0800
Message-ID: <20251124185412.24155-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
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
index 9768341aa21c..86cf38ab08a7 100644
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
index a3c734fe656e..7f9b2fed117a 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -552,7 +552,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    cpumask_t *cpumask, struct mon_evt *evt, int first)
 {
 	int cpu;
 
@@ -563,15 +563,15 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
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
@@ -592,14 +592,13 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
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
@@ -607,6 +606,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	int domid, cpu, ret = 0;
 	struct rdt_resource *r;
 	struct cacheinfo *ci;
+	struct mon_evt *evt;
 	struct mon_data *md;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
@@ -623,7 +623,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -641,7 +641,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 					continue;
 				rr.ci = ci;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &ci->shared_cpu_map, evtid, false);
+					       &ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -657,7 +657,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index cbd9dd5656af..9f78ea17c825 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -430,7 +430,7 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
 
 	if (rr->is_mbm_cntr) {
-		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
+		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
 		if (cntr_id < 0) {
 			rr->err = -ENOENT;
 			return -EINVAL;
@@ -439,10 +439,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 
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
@@ -453,10 +453,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		return -EINVAL;
 	if (rr->is_mbm_cntr)
 		rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
-						 rr->evtid, &tval);
+						 rr->evt->evtid, &tval);
 	else
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-						 rr->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 	if (rr->err)
 		return rr->err;
 
@@ -492,10 +492,10 @@ static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *r
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
@@ -545,7 +545,7 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-	m = get_mbm_state(d, closid, rmid, rr->evtid);
+	m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -719,11 +719,11 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 
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
@@ -741,7 +741,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 		mbm_bw_count(rdtgrp, &rr);
 
 	if (rr.arch_mon_ctx)
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+		resctrl_arch_mon_ctx_free(rr.r, evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index b57e1e78bbc2..771e40f02ba6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3103,7 +3103,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -3114,7 +3114,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3281,7 +3281,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.51.1

