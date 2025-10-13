Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940B03090C4
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394845; cv=none; b=Kvq3AqcR2TKEgFHtOMyqLLDW7JiF/xxO4GYfGSIhch/IeeYDJJAeYtQA8z9JwjftH94s6WYVGRDv/MI3G2Xwq+I9abf0rlLTYA6q1QjiRImQ8T8lzvWFSrhixFo7dSfDZ/ZrmqzaQp252BwBa4srlmk4nVOwsgWgs61kFs7NJZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394845; c=relaxed/simple;
	bh=9TBaRF0FFbXy6x1tuuLiMRzsVuZKpfqHuhXXIorq3lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeCgwZCAYWgsSCuO/vlftABBfl5n8AwJuTQVk9/fGKBAoCOM7+gBroUXsnHk1x5/ZCqXUAIyGCuuE8NhAqNFOI4RapEjWiRrc6meoOBVrak0ismdaCbVP1nPc9sFdV/7rWYXrBHT43tXRSbdGu1oxwfxeKX/kXmfuJDyHZZ30SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k0Y5kMtr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k0Y5kMtr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394844; x=1791930844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9TBaRF0FFbXy6x1tuuLiMRzsVuZKpfqHuhXXIorq3lc=;
  b=k0Y5kMtrvkGRyVbqN+T/12cssb3OR6UTcvHOqyh2KS3PD7adRCUnRIHE
   1qjEQdhcyAAUSuByHcMibJEQOLM7aK8IQpVZPbdYbZqOrX8fAOheOE9Y6
   Q+QC2qmwEWxGeVTkh00K86h5E3cRmOI4WIwbF42gb6LuzhZD47ZBVui+e
   9pEA/c3XsYH7wZm5Ro9Hi1S2KCdTGp5ghaOposgEj8CuScgNCejuA6E/1
   N3Qb8Agl7b/WTmkXWjHUjizIaNg5qn+q4JWiQ6UrFGwlCp/0wAsaB71Jl
   loNqqDPnSRKXOkrMHJxm1sTgQnK6T63XtKCRjuwUXtb8Z8qjPWhtWwoIj
   g==;
X-CSE-ConnectionGUID: C4b/4/1pS5ua2VV+F9w3OQ==
X-CSE-MsgGUID: ySGml20YT726aNxCTENI/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168793"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168793"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:01 -0700
X-CSE-ConnectionGUID: SPw3KlmURm2brBZOmKIedg==
X-CSE-MsgGUID: rGpsz6hNSQy98PKQi6UM1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145260"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:33:59 -0700
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
Subject: [PATCH v12 06/31] x86,fs/resctrl: Use struct rdt_domain_hdr when reading counters
Date: Mon, 13 Oct 2025 15:33:20 -0700
Message-ID: <20251013223348.103390-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct rmid_read contains data passed around to read event counts. Use the
generic domain header struct rdt_domain_hdr in struct rmid_read in order to
support other telemetry events' domains besides an L3 one. Adjust the code
interacting with it to the new struct layout.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               |  8 +++---
 fs/resctrl/internal.h                 | 18 +++++++------
 arch/x86/kernel/cpu/resctrl/monitor.c | 20 +++++++++++---
 fs/resctrl/ctrlmondata.c              |  9 +------
 fs/resctrl/monitor.c                  | 38 ++++++++++++++++++---------
 5 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0b55809af5d7..0fef3045cac3 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -514,7 +514,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
  * @r:			resource that the counter should be read from.
- * @d:			domain that the counter should be read from.
+ * @hdr:		Header of domain that the counter should be read from.
  * @closid:		closid that matches the rmid. Depending on the architecture, the
  *			counter may match traffic of both @closid and @rmid, or @rmid
  *			only.
@@ -535,7 +535,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *arch_mon_ctx);
 
@@ -630,7 +630,7 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
  *			      assigned to the RMID, event pair for this resource
  *			      and domain.
  * @r:		Resource that the counter should be read from.
- * @d:		Domain that the counter should be read from.
+ * @hdr:	Header of domain that the counter should be read from.
  * @closid:	CLOSID that matches the RMID.
  * @rmid:	The RMID to which @cntr_id is assigned.
  * @cntr_id:	The counter to read.
@@ -644,7 +644,7 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, int cntr_id,
 			   enum resctrl_event_id eventid, u64 *val);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 22fdb3a9b6f4..698ed84fd073 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -106,24 +106,26 @@ struct mon_data {
  *	   resource group then its event count is summed with the count from all
  *	   its child resource groups.
  * @r:	   Resource describing the properties of the event being read.
- * @d:	   Domain that the counter should be read from. If NULL then sum all
- *	   domains in @r sharing L3 @ci.id
+ * @hdr:   Header of domain that the counter should be read from. If NULL then
+ *	   sum all domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
- * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
+ * @ci:    Cacheinfo for L3. Only set when @hdr is NULL. Used when summing
+ *	   domains.
  * @is_mbm_cntr: true if "mbm_event" counter assignment mode is enabled and it
  *	   is an MBM event.
  * @err:   Error encountered when reading counter.
- * @val:   Returned value of event counter. If @rgrp is a parent resource group,
- *	   @val includes the sum of event counts from its child resource groups.
- *	   If @d is NULL, @val includes the sum of all domains in @r sharing @ci.id,
- *	   (summed across child resource groups if @rgrp is a parent resource group).
+ * @val:   Returned value of event counter. If @rgrp is a parent resource
+ *	   group, @val includes the sum of event counts from its child
+ *	   resource groups.  If @hdr is NULL, @val includes the sum of all
+ *	   domains in @r sharing @ci.id, (summed across child resource groups
+ *	   if @rgrp is a parent resource group).
  * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
  */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
+	struct rdt_domain_hdr	*hdr;
 	enum resctrl_event_id	evtid;
 	bool			first;
 	struct cacheinfo	*ci;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 2cd25a0d4637..1f47844b5246 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -238,19 +238,26 @@ static u64 get_corrected_val(struct rdt_resource *r, struct rdt_mon_domain *d,
 	return chunks * hw_res->mon_scale;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *ignored)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
-	int cpu = cpumask_any(&d->hdr.cpu_mask);
+	struct rdt_hw_mon_domain *hw_dom;
 	struct arch_mbm_state *am;
+	struct rdt_mon_domain *d;
 	u64 msr_val;
 	u32 prmid;
+	int cpu;
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return -EINVAL;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	hw_dom = resctrl_to_arch_mon_dom(d);
+	cpu = cpumask_any(&hdr->cpu_mask);
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 
@@ -318,13 +325,18 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
 	}
 }
 
-int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, int cntr_id,
 			   enum resctrl_event_id eventid, u64 *val)
 {
+	struct rdt_mon_domain *d;
 	u64 msr_val;
 	int ret;
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return -EINVAL;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	ret = __cntr_id_read(cntr_id, &msr_val);
 	if (ret)
 		return ret;
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 8c07a9810706..7b9fc5d3bdc8 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -550,15 +550,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
 {
-	struct rdt_mon_domain *d = NULL;
 	int cpu;
 
-	if (hdr) {
-		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-	}
-
 	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
@@ -568,7 +561,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	rr->rgrp = rdtgrp;
 	rr->evtid = evtid;
 	rr->r = r;
-	rr->d = d;
+	rr->hdr = hdr;
 	rr->first = first;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
 	    resctrl_is_mbm_event(evtid)) {
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 4076336fbba6..521f78f42f07 100644
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
@@ -425,7 +425,11 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	u64 tval = 0;
 
 	if (rr->is_mbm_cntr) {
-		cntr_id = mbm_cntr_get(rr->r, rr->d, rdtgrp, rr->evtid);
+		if (!rr->hdr || !domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return -EINVAL;
+		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+
+		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
 		if (cntr_id < 0) {
 			rr->err = -ENOENT;
 			return -EINVAL;
@@ -433,25 +437,29 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	}
 
 	if (rr->first) {
+		if (!rr->hdr || !domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return -EINVAL;
+		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+
 		if (rr->is_mbm_cntr)
-			resctrl_arch_reset_cntr(rr->r, rr->d, closid, rmid, cntr_id, rr->evtid);
+			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
 		else
-			resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
-		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
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
 		if (rr->is_mbm_cntr)
-			rr->err = resctrl_arch_cntr_read(rr->r, rr->d, closid, rmid, cntr_id,
+			rr->err = resctrl_arch_cntr_read(rr->r, rr->hdr, closid, rmid, cntr_id,
 							 rr->evtid, &tval);
 		else
-			rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
+			rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
 							 rr->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
@@ -477,10 +485,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		if (d->ci_id != rr->ci->id)
 			continue;
 		if (rr->is_mbm_cntr)
-			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
+			err = resctrl_arch_cntr_read(rr->r, &d->hdr, closid, rmid, cntr_id,
 						     rr->evtid, &tval);
 		else
-			err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
+			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
 						     rr->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
@@ -511,9 +519,13 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	u64 cur_bw, bytes, cur_bytes;
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
+	struct rdt_mon_domain *d;
 	struct mbm_state *m;
 
-	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return;
+	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+	m = get_mbm_state(d, closid, rmid, rr->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -686,7 +698,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	struct rmid_read rr = {0};
 
 	rr.r = r;
-	rr.d = d;
+	rr.hdr = &d->hdr;
 	rr.evtid = evtid;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rr.is_mbm_cntr = true;
-- 
2.51.0

