Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A483246E0
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010502; cv=none; b=BfiFNrCThzar1sC6Ou3YDIlS8qOCSozSTgh8+GwJib+jh+EifsBbb/7Lk/uQdjHhhUA3Xw7CBOFnjGX3nJbsYHmDsXGQrdTs2cGbxD9+v4JnQabX+aZ5uyUYR394PJ5xcQZhCGSjjqIBxHwOVIyz2I1f1cMFFBxU+yGgsHw/6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010502; c=relaxed/simple;
	bh=6GrPylPFisdcurseo1AGNjm1a3TuTazSYkfuPBSGenw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqfA2a0GAQ543cg+I3fuqYm64oJ8HFPCbx8/TTQPWt5PtnOdmEgZEba4LgM+On1hCk8ExPHsSX682IXWr2N10Trmz7GlvI+/paAma7kM5JhCBO7pZ7hQqJSOOjvyo/To9+LEVWj3k0VC1pY5YlwRHTQd8kqu1BNPBAThMwjink0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G9LJ2L60; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G9LJ2L60"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010500; x=1795546500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6GrPylPFisdcurseo1AGNjm1a3TuTazSYkfuPBSGenw=;
  b=G9LJ2L60znsDBcg3qDfyS52Ox1ca/gl9MP/SPpvRWh6doLdEQ+yZxVqW
   TCxEBij0YhHvh+luAOVukAc9N3Qowo8L5amIGWcEQglCQ1WuH43rccXZ6
   w0sMinnW7bExEpshnzDGhduFo8rwHIozFKEJlSyqkuj3PzBY8UIwWCtsy
   AmPGKvBK+abonGyF3uiuU//QWW+rLOEvd1+rmRsvoeO1LaiJyNz7OOML8
   l5GmkT/l+revqrwxCi5BaxgzxNZshfFpUp6+0A/gJYPfo0tXl54go4qoa
   XKvcYIBlqlNHLH0QI5bSoS8p9iHTXpx4BfA/kJXjQ6A2GNl7cfB3b70UY
   w==;
X-CSE-ConnectionGUID: Wh3qEt0lQfCIHeqk8V3R6w==
X-CSE-MsgGUID: 5oU7lpCzSWexmnnDd1BZhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636736"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636736"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:28 -0800
X-CSE-ConnectionGUID: Hxvd4eSxTvaq0u3TRnQK/A==
X-CSE-MsgGUID: RePiIoMERhiGEQvTSeujng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225003"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:28 -0800
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
Subject: [PATCH v14 18/32] x86,fs/resctrl: Add architectural event pointer
Date: Mon, 24 Nov 2025 10:53:55 -0800
Message-ID: <20251124185412.24155-19-tony.luck@intel.com>
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

The resctrl file system layer passes the domain, RMID, and event id to the
architecture to fetch an event counter.

Fetching a telemetry event counter requires additional information that is
private to the architecture, for example, the offset into MMIO space from
where the counter should be read.

Add mon_evt::arch_priv that architecture can use for any private data related
to the event. resctrl filesystem initializes mon_evt::arch_priv when the
architecture enables the event and passes it back to architecture when
needing to fetch an event counter.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h               |  7 +++++--
 fs/resctrl/internal.h                 |  4 ++++
 arch/x86/kernel/cpu/resctrl/core.c    |  6 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c |  2 +-
 fs/resctrl/monitor.c                  | 14 ++++++++++----
 5 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 2a3613f27274..b30f99335bbe 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -415,7 +415,7 @@ u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
-			      unsigned int binary_bits);
+			      unsigned int binary_bits, void *arch_priv);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
@@ -532,6 +532,9 @@ void resctrl_arch_pre_mount(void);
  *			only.
  * @rmid:		rmid of the counter to read.
  * @eventid:		eventid to read, e.g. L3 occupancy.
+ * @arch_priv:		Architecture private data for this event.
+ *			The @arch_priv provided by the architecture via
+ *			resctrl_enable_mon_event().
  * @val:		result of the counter read in bytes.
  * @arch_mon_ctx:	An architecture specific value from
  *			resctrl_arch_mon_ctx_alloc(), for MPAM this identifies
@@ -549,7 +552,7 @@ void resctrl_arch_pre_mount(void);
  */
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *arch_mon_ctx);
+			   void *arch_priv, u64 *val, void *arch_mon_ctx);
 
 /**
  * resctrl_arch_rmid_read_context_check()  - warn about invalid contexts
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 50d88e91e0da..399f625be67d 100644
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
index 88be77d5d20d..3c6946a5ff1b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -924,15 +924,15 @@ static __init bool get_rdt_mon_resources(void)
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
index 20605212656c..6929614ba6e6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -240,7 +240,7 @@ static u64 get_corrected_val(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+			   void *arch_priv, u64 *val, void *ignored)
 {
 	struct rdt_hw_l3_mon_domain *hw_dom;
 	struct rdt_l3_mon_domain *d;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index df80eac48be6..4ef91fc09070 100644
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
@@ -456,7 +458,8 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 						 rr->evt->evtid, &tval);
 	else
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, rr->evt->arch_priv,
+						 &tval, rr->arch_mon_ctx);
 	if (rr->err)
 		return rr->err;
 
@@ -495,7 +498,8 @@ static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *r
 						     rr->evt->evtid, &tval);
 		else
 			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-						     rr->evt->evtid, &tval, rr->arch_mon_ctx);
+						     rr->evt->evtid, rr->evt->arch_priv,
+						     &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -986,7 +990,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      unsigned int binary_bits, void *arch_priv)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
 			 binary_bits > MAX_BINARY_BITS))
@@ -1002,6 +1007,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsig
 
 	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].binary_bits = binary_bits;
+	mon_event_all[eventid].arch_priv = arch_priv;
 	mon_event_all[eventid].enabled = true;
 }
 
-- 
2.51.1

