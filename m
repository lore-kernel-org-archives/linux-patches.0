Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53E01A4E78
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727982758; cv=none; b=oCq6FpePAD9HrSBQcPEze46kD69sXbq+6hGbOEjr3uO6030jhw/nZrnwt8ZaTVutMAYD2/3bT7TXgb5kWLH7j3p5zXMW+6KyC/8uBmGat4gbOOBG3vvNXQ0/lCjw18fcfUxSZwMbhYlL9ji7ggIvaEtPDFVHV8PsyMdnzXsDCMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727982758; c=relaxed/simple;
	bh=YTcnn9tY/T7LhH21dp3UNmpxTa0EEnAoZv8qsoiI0C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUCoGk9h6AD+ZIt3T9OrBaWXGKi2bTtz1jCTxFPOLlv5TzyWASiU5ZuyL3iIrp02WQ/ox1/9KRdDCgr4E1eg9ARsmzQDC8jHomo439lSl3L7J2nOh9xTCvikyv2VUiefBDlnbuSwnJIDAUPGw55d0mLKs/ud51+RRW5XhqEXE/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ckeidl+B; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ckeidl+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727982756; x=1759518756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YTcnn9tY/T7LhH21dp3UNmpxTa0EEnAoZv8qsoiI0C0=;
  b=Ckeidl+BPCGmCNLaNnflBufczzwBGHD5FjRqLi8KRNsBOhvbNR2lvotr
   rlJRMyijvbQs3aBbQ1bR0YyfGbhdc0tsZUwMyEp3HMrqLdnEgm2A7djz0
   3XLCjGUlA72m3eJOKd/k90+qXYGCmvDsT1qd/DuRs893bna4YaffVoXbU
   YM/jJAcbh3yVM3U/JuRzcH8draKZ15PMN9ltyABHTr9/LVwPtvRXlkLOo
   bqd0Ug/UrhsNV7wA6GDlUGvXnh7qm/OPoUU2lcC0XmynY/xoXKhsEDc+o
   GtAPc8OhY6FmfnfrtJRqe3sYXv2YqT1qnnai8QQzeRQ/judcuezJTjn0P
   g==;
X-CSE-ConnectionGUID: bAbJly9bTOmVzEuMR9qxtQ==
X-CSE-MsgGUID: N7b/S708QliaiTGfy8LSSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11214"; a="27287501"
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="27287501"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 12:12:36 -0700
X-CSE-ConnectionGUID: QX+V9hVRS46KeKq9Cxaijg==
X-CSE-MsgGUID: tXMSFAwWQhumEsQ4elPSUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="74031033"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 12:12:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 1/4] x86/resctrl: Make input event for MBA Software Controller configurable
Date: Thu,  3 Oct 2024 12:12:25 -0700
Message-ID: <20241003191228.67541-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241003191228.67541-1-tony.luck@intel.com>
References: <20241003191228.67541-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MBA Software Controller(mba_sc) is a feedback loop that uses
measurements of local memory bandwidth to adjust MBA throttling levels
to keep workloads in a resctrl group within a target bandwidth set in
the schemata file.

Users may want to use total memory bandwidth instead of local to handle
workloads that have poor NUMA localization.

Update the once-per-second polling code to pick a chosen event (local
or total memory bandwidth).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                |  2 +
 arch/x86/kernel/cpu/resctrl/monitor.c  | 80 ++++++++++++--------------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +
 3 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d94abba1c716..ccb0f50dc18c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -161,6 +161,7 @@ enum membw_throttle_mode {
  * @throttle_mode:	Bandwidth throttling mode when threads request
  *			different memory bandwidths
  * @mba_sc:		True if MBA software controller(mba_sc) is enabled
+ * @mba_mbps_event:	Monitoring event guiding feedback loop when @mba_sc is true
  * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
  */
 struct resctrl_membw {
@@ -170,6 +171,7 @@ struct resctrl_membw {
 	bool				arch_needs_linear;
 	enum membw_throttle_mode	throttle_mode;
 	bool				mba_sc;
+	enum resctrl_event_id		mba_mbps_event;
 	u32				*mb_map;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 851b561850e0..2692ce7f708e 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -663,10 +663,11 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
  */
 static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
-	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
-	struct mbm_state *m = &rr->d->mbm_local[idx];
 	u64 cur_bw, bytes, cur_bytes;
+	struct mbm_state *m;
 
+	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	WARN_ON(!m);
 	cur_bytes = rr->val;
 	bytes = cur_bytes - m->prev_bw_bytes;
 	m->prev_bw_bytes = cur_bytes;
@@ -752,20 +753,22 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
 	struct rdt_ctrl_domain *dom_mba;
+	enum resctrl_event_id evt_id;
 	struct rdt_resource *r_mba;
-	u32 cur_bw, user_bw, idx;
 	struct list_head *head;
 	struct rdtgroup *entry;
+	u32 cur_bw, user_bw;
 
-	if (!is_mbm_local_enabled())
+	if (!is_mbm_enabled())
 		return;
 
 	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
+	evt_id = r_mba->membw.mba_mbps_event;
 
 	closid = rgrp->closid;
 	rmid = rgrp->mon.rmid;
-	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
-	pmbm_data = &dom_mbm->mbm_local[idx];
+	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
+	WARN_ON(!pmbm_data);
 
 	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
@@ -784,7 +787,8 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	 */
 	head = &rgrp->mon.crdtgrp_list;
 	list_for_each_entry(entry, head, mon.crdtgrp_list) {
-		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
+		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
+		WARN_ON(!cmbm_data);
 		cur_bw += cmbm_data->prev_bw;
 	}
 
@@ -813,54 +817,42 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
 }
 
-static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
-		       u32 closid, u32 rmid)
+static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
+				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
+	struct rdt_resource *rmba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 	struct rmid_read rr = {0};
 
 	rr.r = r;
 	rr.d = d;
+	rr.evtid = evtid;
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+	if (IS_ERR(rr.arch_mon_ctx)) {
+		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
+				    PTR_ERR(rr.arch_mon_ctx));
+		return;
+	}
 
+	__mon_event_count(closid, rmid, &rr);
+
+	if (is_mba_sc(NULL) && rr.evtid == rmba->membw.mba_mbps_event)
+		mbm_bw_count(closid, rmid, &rr);
+
+	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+}
+
+static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+		       u32 closid, u32 rmid)
+{
 	/*
 	 * This is protected from concurrent reads from user
 	 * as both the user and we hold the global mutex.
 	 */
-	if (is_mbm_total_enabled()) {
-		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
-		rr.val = 0;
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
-			return;
-		}
-
-		__mon_event_count(closid, rmid, &rr);
-
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
-	}
-	if (is_mbm_local_enabled()) {
-		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
-		rr.val = 0;
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
-			return;
-		}
-
-		__mon_event_count(closid, rmid, &rr);
-
-		/*
-		 * Call the MBA software controller only for the
-		 * control groups and when user has enabled
-		 * the software controller explicitly.
-		 */
-		if (is_mba_sc(NULL))
-			mbm_bw_count(closid, rmid, &rr);
+	if (is_mbm_total_enabled())
+		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
 
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
-	}
+	if (is_mbm_local_enabled())
+		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index d7163b764c62..aedb30120d50 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2505,6 +2505,7 @@ static void rdt_disable_ctx(void)
 
 static int rdt_enable_ctx(struct rdt_fs_context *ctx)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 	int ret = 0;
 
 	if (ctx->enable_cdpl2) {
@@ -2520,6 +2521,7 @@ static int rdt_enable_ctx(struct rdt_fs_context *ctx)
 	}
 
 	if (ctx->enable_mba_mbps) {
+		r->membw.mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
 		ret = set_mba_sc(true);
 		if (ret)
 			goto out_cdpl3;
-- 
2.46.1

