Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388E2E2836
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936261; cv=none; b=nx+v9RNS6HYNPcHQf5JUhjPHrD2B+F67U3+A5o5t9Ltytl9RrgKGfnAtYcYHlgPKf3g8MJzsaGcX8rHdqkAnmehMY/DnrVeblBVkB3OV17HFMdk4XFVzg7JSzla4lYMSa4hwgLSPnpV7otMGrENPzwYYZl7utOwu7vKLLgRzK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936261; c=relaxed/simple;
	bh=X3qMAegbrvvVKnCTh2BttCuhvKkOq9VZBu9Q+n+xwJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+UPmLIPM3RBfrqz7ZLpooP+RiFojrtuHVEsWNM31t6zDrRk2ybFWj0RRI+9OFRsDWk+TRbT2ITTQKFV9ycHb30R4SeqXNW35xk9+4aUBLlUx5fLgtM0kViRCNgG+IfHBE4IYA4JZ6gLk8pvOQqGgll3qTT0yULT8FIHBwcWllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GAHAm7px; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GAHAm7px"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936259; x=1786472259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X3qMAegbrvvVKnCTh2BttCuhvKkOq9VZBu9Q+n+xwJQ=;
  b=GAHAm7pxq6SSNQcFjPDWTBnLoklrJ0bSoO6XtSkXfDgK46PIWg8pz5RT
   K6O+l+/noZkb+38aZgTRYCeyJFej55qpDGSic//sXQzSSzt5GX2VIgqpn
   jY1OfQeHkeKATMmlF8u3FCSPo6AG1M5TeV/FNslqnYzPJczD3PDWe3DbB
   d4tZhbJ8f4KadoTzqKFnu+Sci3ayaQJZwvHBDRCuQwzb9Dp2f4dA6xotV
   CivrbK2DXkG+el6KPRdIrldDG1punOhhSNJkB7YE4xR9OwYcoE1beO2/T
   WR8jy9fa0jmSBxWTA4sE3FAtsCqgGSX7Gwl7E/uWY7cfMwKLngMeBWugC
   g==;
X-CSE-ConnectionGUID: woZCKhMMRuaBsE+PBhM6gA==
X-CSE-MsgGUID: rcnYjIQyQNK/CbRW9cgB0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277396"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277396"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: VNtOV2rgQXan13cNsEpj4Q==
X-CSE-MsgGUID: emH1XCyrSeuMbUQVF6yOMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825650"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:24 -0700
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
Subject: [PATCH v8 12/32] fs/resctrl: Make event details accessible to functions when reading events
Date: Mon, 11 Aug 2025 11:16:46 -0700
Message-ID: <20250811181709.6241-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All details about a monitor event are kept in the mon_evt structure.

Upper levels of code only provide the event id to lower levels.

But those lower levels need more than just the event id, they need
the attributes of the event too.

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
index baab3c87f323..eb45cf746c5c 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -76,7 +76,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evt:             Event structure associated with the event file.
  * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
  *                   across multiple domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -90,7 +90,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 struct mon_data {
 	struct list_head	list;
 	enum resctrl_res_level	rid;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
 };
@@ -103,7 +103,7 @@ struct mon_data {
  * @r:	   Resource describing the properties of the event being read.
  * @hdr:   Header of domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
- * @evtid: Which monitor event to read.
+ * @evt:   Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @ci_id: Cacheinfo id for L3. Only set when @hdr is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
@@ -117,7 +117,7 @@ struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_domain_hdr	*hdr;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	bool			first;
 	unsigned int		ci_id;
 	int			err;
@@ -355,7 +355,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 1d7086509bfa..a99903ac5d27 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -548,7 +548,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
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
 	rr->hdr = hdr;
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
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
 	struct rdtgroup *rdtgrp;
 	int domid, cpu, ret = 0;
 	struct rdt_resource *r;
 	struct cacheinfo *ci;
+	struct mon_evt *evt;
 	struct mon_data *md;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
@@ -612,7 +612,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -636,7 +636,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 				if (!ci)
 					continue;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &ci->shared_cpu_map, evtid, false);
+					       &ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -652,7 +652,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 59d72c3ad579..c3f697da612b 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -369,8 +369,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
 		d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
-		m = get_mbm_state(d, closid, rmid, rr->evtid);
+		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
+		m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
@@ -381,7 +381,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
 			return -EINVAL;
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-						 rr->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -410,7 +410,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (d->ci_id != rr->ci_id)
 			continue;
 		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-					     rr->evtid, &tval, rr->arch_mon_ctx);
+					     rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -444,7 +444,7 @@ static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-	m = get_mbm_state(d, closid, rmid, rr->evtid);
+	m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -615,12 +615,13 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_m
 static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
+	struct mon_evt *evt = &mon_event_all[evtid];
 	struct rmid_read rr = {0};
 
 	rr.r = r;
 	rr.hdr = &d->hdr;
-	rr.evtid = evtid;
-	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+	rr.evt = evt;
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evt->evtid);
 	if (IS_ERR(rr.arch_mon_ctx)) {
 		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
 				    PTR_ERR(rr.arch_mon_ctx));
@@ -636,7 +637,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 	if (is_mba_sc(NULL))
 		mbm_bw_count(closid, rmid, &rr);
 
-	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+	resctrl_arch_mon_ctx_free(rr.r, evt->evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index db63da7f3152..b917d48a806a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2903,7 +2903,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -2914,7 +2914,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3079,7 +3079,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.50.1

