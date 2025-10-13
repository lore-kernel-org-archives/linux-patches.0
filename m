Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F36430BB82
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394851; cv=none; b=mSXMw4jZpT1szJ7PZ7gQBrBOwnozdwSv9grIl7MN4mHdmva8XzoaGCElcfqaMOyuleguWvc+5cfuN7S5FjVkyOM+OITNYMVp0BZXm3RzocuW4Mbeeu2Otcmbdgox5Iduy/YM0vEG+beWiGBYvQwmmBRGhVPEKKdOJ8bg/iICc8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394851; c=relaxed/simple;
	bh=G+eW5DGdyabpiSV/2EyeKCzKTRP21tCMTwkC8pfR/eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrppeVOuqS9G+istyMOMvBgPhned9K3ayk8A5pHWAQTpPQexHcasMrUQnxcCI6wWwuy/RhB3b+93+6vY1sSxvkO1jOIs2+GuHRow/z3ZQpW8Rcp0rZr/FnBYdLPBkZgGKamQ2vBPaGOdaL2R5wbCV2txugME8BhkycMQ7axR7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJgVK7o8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJgVK7o8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394849; x=1791930849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G+eW5DGdyabpiSV/2EyeKCzKTRP21tCMTwkC8pfR/eQ=;
  b=oJgVK7o8CHveAjEkgkH+EB0ELY4Vy3OkpDpGe0LIhqJOJ2bi0Txa4q6L
   qi05Ov8BGDxgz4UPw5opBKw2Pdi8ZMFpOKPisSMdsn43t70FJENdvZBRI
   DQwSGEsgfOUTS4vpKoo5FqwDsaupQj6vKa+C+D3GK4HoFj8TCEVwE0u5Z
   +BrCHPtZ7Zq/MPjo5zzHD/oEbxOvmcnZVF7wnAttVW06kd8p7TCLMPv7k
   7Izf8HvW9wPyjH7lF50OZr9kO/hw2ytIiYGTghZBFymOXQDPLyyUpi9XY
   s621Fg5feoNTXjsuUyu8yKb2fowDcSmVgfmBeWSUnYH4s0n2M3z7U4hVM
   w==;
X-CSE-ConnectionGUID: gHJzw+RKRQS+iuVAnbdcQA==
X-CSE-MsgGUID: tlobW7DsRcqRGLVSblvo/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168852"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168852"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
X-CSE-ConnectionGUID: m0UP4olhRDCh6GwC37Gabw==
X-CSE-MsgGUID: 3voRg0Y3QlGYigQfLw27wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145301"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:01 -0700
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
Subject: [PATCH v12 16/31] x86,fs/resctrl: Add architectural event pointer
Date: Mon, 13 Oct 2025 15:33:30 -0700
Message-ID: <20251013223348.103390-17-tony.luck@intel.com>
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

The resctrl file system layer passes the domain, RMID, and event id to the
architecture to fetch an event counter.

Fetching a telemetry event counter requires additional information that is
private to the architecture, for example, the offset into MMIO space from
where the counter should be read.

Add mon_evt::arch_priv that architecture can use for any private data
related to the event. resctrl filesystem initializes mon_evt::arch_priv
when the architecture enables the event and passes it back to architecture
when needing to fetch an event counter.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               |  7 +++++--
 fs/resctrl/internal.h                 |  4 ++++
 arch/x86/kernel/cpu/resctrl/core.c    |  6 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c |  2 +-
 fs/resctrl/monitor.c                  | 18 ++++++++++++------
 5 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index ff67224b80c8..111c8f1dc77e 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -412,7 +412,7 @@ u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
-			      unsigned int binary_bits);
+			      unsigned int binary_bits, void *arch_priv);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
@@ -529,6 +529,9 @@ void resctrl_arch_pre_mount(void);
  *			only.
  * @rmid:		rmid of the counter to read.
  * @eventid:		eventid to read, e.g. L3 occupancy.
+ * @arch_priv:		Architecture private data for this event.
+ *			The @arch_priv provided by the architecture via
+ *			resctrl_enable_mon_event().
  * @val:		result of the counter read in bytes.
  * @arch_mon_ctx:	An architecture specific value from
  *			resctrl_arch_mon_ctx_alloc(), for MPAM this identifies
@@ -546,7 +549,7 @@ void resctrl_arch_pre_mount(void);
  */
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *arch_mon_ctx);
+			   void *arch_priv, u64 *val, void *arch_mon_ctx);
 
 /**
  * resctrl_arch_rmid_read_context_check()  - warn about invalid contexts
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 39bdaf45fa2a..46fd648a2961 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -66,6 +66,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @binary_bits:	number of fixed-point binary bits from architecture,
  *			only valid if @is_floating_point is true
  * @enabled:		true if the event is enabled
+ * @arch_priv:		Architecture private data for this event.
+ *			The @arch_priv provided by the architecture via
+ *			resctrl_enable_mon_event().
  */
 struct mon_evt {
 	enum resctrl_event_id	evtid;
@@ -77,6 +80,7 @@ struct mon_evt {
 	bool			is_floating_point;
 	unsigned int		binary_bits;
 	bool			enabled;
+	void			*arch_priv;
 };
 
 extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9451bafde923..6584461d4cb3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -915,15 +915,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 8f9a2ec3bd04..5565a8752266 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -240,7 +240,7 @@ static u64 get_corrected_val(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+			   void *arch_priv, u64 *val, void *ignored)
 {
 	struct rdt_hw_l3_mon_domain *hw_dom;
 	struct arch_mbm_state *am;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 6ee7011cb948..895cf5b0f524 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -137,9 +137,11 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	struct rmid_entry *entry;
 	u32 idx, cur_idx = 1;
 	void *arch_mon_ctx;
+	void *arch_priv;
 	bool rmid_dirty;
 	u64 val = 0;
 
+	arch_priv = mon_event_all[QOS_L3_OCCUP_EVENT_ID].arch_priv;
 	arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, QOS_L3_OCCUP_EVENT_ID);
 	if (IS_ERR(arch_mon_ctx)) {
 		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
@@ -160,7 +162,7 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 		entry = __rmid_entry(idx);
 		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
-					   QOS_L3_OCCUP_EVENT_ID, &val,
+					   QOS_L3_OCCUP_EVENT_ID, arch_priv, &val,
 					   arch_mon_ctx)) {
 			rmid_dirty = true;
 		} else {
@@ -484,7 +486,8 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 							 rr->evt->evtid, &tval);
 		else
 			rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-							 rr->evt->evtid, &tval, rr->arch_mon_ctx);
+							 rr->evt->evtid, rr->evt->arch_priv,
+							 &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -512,7 +515,8 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 						     rr->evt->evtid, &tval);
 		else
 			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-						     rr->evt->evtid, &tval, rr->arch_mon_ctx);
+						     rr->evt->evtid, rr->evt->arch_priv,
+						     &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -989,7 +993,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      unsigned int binary_bits, void *arch_priv)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
 			 binary_bits > MAX_BINARY_BITS))
@@ -1005,6 +1010,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsig
 
 	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].binary_bits = binary_bits;
+	mon_event_all[eventid].arch_priv = arch_priv;
 	mon_event_all[eventid].enabled = true;
 }
 
@@ -1830,9 +1836,9 @@ int resctrl_l3_mon_resource_init(void)
 
 	if (r->mon.mbm_cntr_assignable) {
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
+			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
+			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
 		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
 								   (READS_TO_LOCAL_MEM |
-- 
2.51.0

