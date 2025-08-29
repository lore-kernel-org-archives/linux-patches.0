Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC1824A051
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496043; cv=none; b=Y6GrjL4ONuJgIJTtesk216Wx42u/5bcS5jNd0gY+wkDN/NhSg1LzztdDCmw7tcUHKftcGfUrPJsN2Tzr2pGwoafbaiCH/Nx9rS2ZrfiWApLNP5VJOMFlFuJxlQcYqdTbkTAjUaFBTJEKXcHo01vg0VH/zQQDqHfzUVptYkA8TXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496043; c=relaxed/simple;
	bh=1XTj9ZRu7irZKHCawZfnUdUBZrb/fpONELQWNT5ICzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ok5J1BHrRS4VuiPk/mM4SJ/HyR2xLAh+VkxYhWC0hV8CWpwn2oOul3eA19vyETFpyY+NGdVatPblOuGQB+laexZHtNfn4rDLEtPguuUdmLdH9rICe5AJ2FGTN0YNia+xU+D2IOm0h+3fcg4PzJHUVY5Nd4DkNs3I+42ztXU1vCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MS+rqU3Q; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MS+rqU3Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496040; x=1788032040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1XTj9ZRu7irZKHCawZfnUdUBZrb/fpONELQWNT5ICzA=;
  b=MS+rqU3QQsV4pq1kUSf+CP/fQ8bC/fqptlQZCopwu6tEqQjZBF1s1AtS
   OK/8wZK8WF2kPrFtKEEsHDLk/Bc1VMGRWReDX4M20NVT9S7OeFr1tqZ7O
   OYLH12M8TIrN7e1eMxpedKiQMgINShh3TCmhJVMtpwifeG9kxDZircFNK
   0WRop94v7JfPusvnpnsksQ6YJmn1HuyeoypjpZ8WAPvBYeeXCkPGK/4/U
   d6Ht6rfH1iIMlYWNmtn3y543BhJ6lcrBg+WuvpTLcjmn/ffq7nJUV3rPB
   qHFnsot13rbtqgsBM2cey/+Qu4wXywSbZJVHMBXZBGy7kmNAyy9UchtNA
   w==;
X-CSE-ConnectionGUID: /L7udjszT8iEMu0PtPPq1w==
X-CSE-MsgGUID: 5KG5vWPYQieAtIsrFUv4aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625205"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625205"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:53 -0700
X-CSE-ConnectionGUID: lg9gaY5eS3SQmvjZibNb+w==
X-CSE-MsgGUID: 5V3oOxkFRpiXchiMVI/U8A==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:54 -0700
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
Subject: [PATCH v9 09/31] x86,fs/resctrl: Use struct rdt_domain_hdr instead of struct rdt_mon_domain
Date: Fri, 29 Aug 2025 12:33:21 -0700
Message-ID: <20250829193346.31565-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
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

Make the same change to allow reading events in other resources. In
this case the code flow passes from mon_event_read() via smp_call*()
eventually to __mon_event_count() so replace the L3 specific domain
pointer rmid_read::d with rmid_read::hdr that points to the generic
domain header.

Update kerneldoc for mon_data::sum to note that it is only used for
RDT_RESOURCE_L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               |   8 +-
 fs/resctrl/internal.h                 |  14 ++--
 arch/x86/kernel/cpu/resctrl/core.c    |   4 +-
 arch/x86/kernel/cpu/resctrl/monitor.c |  18 ++++-
 fs/resctrl/ctrlmondata.c              |  14 ++--
 fs/resctrl/monitor.c                  |  30 +++++---
 fs/resctrl/rdtgroup.c                 | 103 ++++++++++++++++++--------
 7 files changed, 128 insertions(+), 63 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 091135eca2b8..c8200626b91a 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -452,9 +452,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
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
 
@@ -462,7 +462,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
  * @r:			resource that the counter should be read from.
- * @d:			domain that the counter should be read from.
+ * @hdr:		Header of domain that the counter should be read from.
  * @closid:		closid that matches the rmid. Depending on the architecture, the
  *			counter may match traffic of both @closid and @rmid, or @rmid
  *			only.
@@ -483,7 +483,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *arch_mon_ctx);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4f315b7e9ec0..b19e974b7865 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -77,8 +77,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
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
@@ -101,22 +101,22 @@ struct mon_data {
  *	   resource group then its event count is summed with the count from all
  *	   its child resource groups.
  * @r:	   Resource describing the properties of the event being read.
- * @d:	   Domain that the counter should be read from. If NULL then sum all
+ * @hdr:   Header of domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
- * @ci_id: Cacheinfo id for L3. Only set when @d is NULL. Used when summing domains.
+ * @ci_id: Cacheinfo id for L3. Only set when @hdr is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
  * @val:   Returned value of event counter. If @rgrp is a parent resource group,
  *	   @val includes the sum of event counts from its child resource groups.
- *	   If @d is NULL, @val includes the sum of all domains in @r sharing @ci.id,
+ *	   If @hdr is NULL, @val includes the sum of all domains in @r sharing @ci.id,
  *	   (summed across child resource groups if @rgrp is a parent resource group).
  * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
  */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
+	struct rdt_domain_hdr	*hdr;
 	enum resctrl_event_id	evtid;
 	bool			first;
 	unsigned int		ci_id;
@@ -352,7 +352,7 @@ void mon_event_count(void *info);
 int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
-		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first);
 
 int resctrl_mon_resource_init(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 44572973bcd4..43d33810163c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -529,7 +529,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 
 	list_add_tail_rcu(&d->hdr.list, add_pos);
 
-	err = resctrl_online_mon_domain(r, d);
+	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
@@ -656,7 +656,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
-		resctrl_offline_mon_domain(r, d);
+		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index f01db2034d08..b31794c5dcd4 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -217,20 +217,30 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 	return chunks >> shift;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *ignored)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
-	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
-	int cpu = cpumask_any(&d->hdr.cpu_mask);
+	int cpu = cpumask_any(&hdr->cpu_mask);
+	struct rdt_hw_mon_domain *hw_dom;
+	struct rdt_hw_resource *hw_res;
 	struct arch_mbm_state *am;
+	struct rdt_mon_domain *d;
 	u64 msr_val, chunks;
 	u32 prmid;
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid != RDT_RESOURCE_L3)
+		return -EINVAL;
+
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return -EINVAL;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	hw_dom = resctrl_to_arch_mon_dom(d);
+	hw_res = resctrl_to_arch_res(r);
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 	if (ret)
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index a7d60e74a29d..1c1c0e7bbc11 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -547,7 +547,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 }
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
-		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
 {
 	int cpu;
@@ -561,7 +561,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	rr->rgrp = rdtgrp;
 	rr->evtid = evtid;
 	rr->r = r;
-	rr->d = d;
+	rr->hdr = hdr;
 	rr->first = first;
 	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
 	if (IS_ERR(rr->arch_mon_ctx)) {
@@ -592,7 +592,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	enum resctrl_event_id evtid;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
-	struct rdt_mon_domain *d;
 	struct rdtgroup *rdtgrp;
 	int domid, cpu, ret = 0;
 	struct rdt_resource *r;
@@ -617,6 +616,12 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
+		struct rdt_mon_domain *d;
+
+		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
+			ret = -EIO;
+			goto out;
+		}
 		/*
 		 * This file requires summing across all domains that share
 		 * the L3 cache id that was provided in the "domid" field of the
@@ -647,8 +652,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index dcc6c00eb362..713396cbda32 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
 			break;
 
 		entry = __rmid_entry(idx);
-		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
+		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
 					   QOS_L3_OCCUP_EVENT_ID, &val,
 					   arch_mon_ctx)) {
 			rmid_dirty = true;
@@ -365,19 +365,22 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	int err, ret;
 	u64 tval = 0;
 
-	if (rr->first) {
-		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
-		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	if (rr->r->rid == RDT_RESOURCE_L3 && rr->first) {
+		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return -EINVAL;
+		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
+		m = get_mbm_state(d, closid, rmid, rr->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
 	}
 
-	if (rr->d) {
+	if (rr->hdr) {
 		/* Reading a single domain, must be on a CPU in that domain. */
-		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
+		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
 			return -EINVAL;
-		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
+		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
 						 rr->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
@@ -387,6 +390,9 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		return 0;
 	}
 
+	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
+		return -EINVAL;
+
 	/* Summing domains that share a cache, must be on a CPU for that cache. */
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci || ci->id != rr->ci_id)
@@ -403,7 +409,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
 		if (d->ci_id != rr->ci_id)
 			continue;
-		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
+		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
 					     rr->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
@@ -432,9 +438,13 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
 	u64 cur_bw, bytes, cur_bytes;
+	struct rdt_mon_domain *d;
 	struct mbm_state *m;
 
-	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return;
+	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+	m = get_mbm_state(d, closid, rmid, rr->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -608,7 +618,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	struct rmid_read rr = {0};
 
 	rr.r = r;
-	rr.d = d;
+	rr.hdr = &d->hdr;
 	rr.evtid = evtid;
 	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
 	if (IS_ERR(rr.arch_mon_ctx)) {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 05438e15e2ca..2cff82208327 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2887,7 +2887,8 @@ static void rmdir_all_sub(void)
  * @rid:    The resource id for the event file being created.
  * @domid:  The domain id for the event file being created.
  * @mevt:   The type of event file being created.
- * @do_sum: Whether SNC summing monitors are being created.
+ * @do_sum: Whether SNC summing monitors are being created. Only set
+ *          when @rid == RDT_RESOURCE_L3.
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
@@ -2897,6 +2898,9 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
+	if (WARN_ON_ONCE(do_sum && rid != RDT_RESOURCE_L3))
+		return NULL;
+
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
 		    priv->sum == do_sum && priv->evtid == mevt->evtid)
@@ -3024,17 +3028,27 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
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
@@ -3044,19 +3058,18 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
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
@@ -3065,26 +3078,38 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
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
@@ -3100,13 +3125,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
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
@@ -3117,7 +3142,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		if (ret)
 			goto out_destroy;
 
-		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3135,7 +3160,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
  * and "monitor" groups with given domain id.
  */
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
@@ -3143,12 +3168,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 
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
@@ -3157,14 +3182,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
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
@@ -4036,8 +4061,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
+	struct rdt_mon_domain *d;
+
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -4045,11 +4072,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d);
+		rmdir_mondata_subdir_allrdtgrp(r, hdr);
 
 	if (r->rid != RDT_RESOURCE_L3)
 		goto out_unlock;
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		goto out_unlock;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4132,12 +4163,20 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
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
@@ -4151,6 +4190,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
+mkdir:
+	err = 0;
 	/*
 	 * If the filesystem is not mounted then only the default resource group
 	 * exists. Creation of its directories is deferred until mount time
@@ -4158,7 +4199,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		mkdir_mondata_subdir_allrdtgrp(r, d);
+		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-- 
2.50.1

