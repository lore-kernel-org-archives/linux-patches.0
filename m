Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B123C4EA
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867865; cv=none; b=bqtfVGlHKUntgjJUd9VF5Jrt/m4Efix6DRFd0+JKRhTNi4WE5fdIwU6/N8wjsqGMBoFu1IbPIQbnK/0uT+vPPAKifK3XiTmKDHzszcELtdjQ95gkCtIlWzNjUTnHk7A9qYx7oD+Fj+UDVo3lLXw1Cy7Q31xz2w5Sn7ISKYfZnas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867865; c=relaxed/simple;
	bh=RHtFrgfRLs7QN22cgd5bl7QEOXwgCvO4cbIQoDsFohU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMyjKFDfiXJPqM6JJ44D1s4ckhK51401rp2oQSdPYjNkY1Ohf3hMc8GuK3YRfC627MDOI9I9iNW8Th8AfPYLP3RKd4GqK32xt1Mfv5tzL0LCuVHhbS0rNPYPs08OJHSmy2K2abMkZRY+gnavk8iePUS+RMnGf55lgjxo7DSRSgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mp1zGm08; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mp1zGm08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867863; x=1779403863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RHtFrgfRLs7QN22cgd5bl7QEOXwgCvO4cbIQoDsFohU=;
  b=Mp1zGm083qjwlNsKwDMSK95W/8IJeuhkNSeduI/qiXPrCYd0QztBxq8p
   Wfwv7IcPbclZ7U2Ri9y9pgXXRKgu1ng2jTVJv+NIlojQzyMBinpNgqgqg
   egpxNjagzr1mIxOyRLaDQvT9SAuGTgdgHvmXExA3ZsRJPMmo9KVEGrroO
   KC0o1mdF5mZgtDMPiqzmDrWO7gXqyHFCz/l94zyLdYt5Kl0l98qC/TEFc
   Y59Q+GUnL5gJEvgDYGAFDi6Y7vmCB5EqDyFdZD4LtSg2WNML82/4VFLal
   RUrR33wF5yostNocEdRid+cjPUuWeyDaSLxnfuuIxpxZkVbbfkcSbPgOC
   Q==;
X-CSE-ConnectionGUID: X2OFTo+BSWeH2CRXj0YoyQ==
X-CSE-MsgGUID: QUCep/Q6SjG+MFaeNMk0+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677701"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677701"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
X-CSE-ConnectionGUID: 9dHqkLrHSkqYZHdaeQJkYQ==
X-CSE-MsgGUID: Z9rqHpDhSFuEMmkdpeV6UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352157"
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
Subject: [PATCH v5 12/29] fs/resctrl: Make event details accessible to functions when reading events
Date: Wed, 21 May 2025 15:50:30 -0700
Message-ID: <20250521225049.132551-13-tony.luck@intel.com>
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

All details about a monitor event are kept in the mon_evt structure.
Upper levels of code only provide the event id to lower levels.
This will become a problem when new attributes are added to the
mon_evt structure.

Change the mon_data and rmid_read structures to hold a pointer
to the mon_evt structure instead of just taking a copy of the
event id.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h    | 10 +++++-----
 fs/resctrl/ctrlmondata.c | 16 ++++++++--------
 fs/resctrl/monitor.c     | 17 +++++++++--------
 fs/resctrl/rdtgroup.c    |  6 +++---
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 8659ee33b76f..085a2ee1922f 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -73,7 +73,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evt:             Event associated with the event file.
  * @sum:             Set when event must be summed across multiple
  *                   domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -87,7 +87,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 struct mon_data {
 	struct list_head	list;
 	enum resctrl_res_level	rid;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
 };
@@ -100,7 +100,7 @@ struct mon_data {
  * @r:	   Resource describing the properties of the event being read.
  * @d:	   Domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
- * @evtid: Which monitor event to read.
+ * @evt:   Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
@@ -114,7 +114,7 @@ struct rmid_read {
 	struct rdtgroup			*rgrp;
 	struct rdt_resource		*r;
 	struct rdt_l3_mon_domain	*d;
-	enum resctrl_event_id		evtid;
+	struct mon_evt			*evt;
 	bool				first;
 	struct cacheinfo		*ci;
 	int				err;
@@ -350,7 +350,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
 int resctrl_mon_resource_init(void);
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 6db24f7a3de5..dcde27f6f2ec 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -548,7 +548,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    cpumask_t *cpumask, struct mon_evt *evt, int first)
 {
 	int cpu;
 
@@ -559,11 +559,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
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
@@ -582,20 +582,20 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
-	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
+	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
 	enum resctrl_res_level resid;
-	enum resctrl_event_id evtid;
 	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
 	struct rdtgroup *rdtgrp;
 	struct rdt_resource *r;
 	struct mon_data *md;
+	struct mon_evt *evt;
 	int domid, ret = 0;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
@@ -612,7 +612,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -626,7 +626,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			if (d->ci->id == domid) {
 				rr.ci = d->ci;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &d->ci->shared_cpu_map, evtid, false);
+					       &d->ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -643,7 +643,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			goto out;
 		}
 		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
+		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index c1d248a7fdbc..3cfd1bf1845e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -365,8 +365,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	u64 tval = 0;
 
 	if (rr->first) {
-		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
-		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evt->evtid);
+		m = get_mbm_state(rr->d, closid, rmid, rr->evt->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
@@ -377,7 +377,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
 			return -EINVAL;
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
-						 rr->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
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
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evt->evtid);
 	if (IS_ERR(rr.arch_mon_ctx)) {
 		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
 				    PTR_ERR(rr.arch_mon_ctx));
@@ -624,7 +625,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 	if (is_mba_sc(NULL))
 		mbm_bw_count(closid, rmid, &rr);
 
-	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+	resctrl_arch_mon_ctx_free(rr.r, evt->evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 39e046fba60a..67482f1110b3 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2897,7 +2897,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -2908,7 +2908,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3080,7 +3080,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.49.0

