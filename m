Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE82123C509
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278048; cv=none; b=KxJJQTRW3GRa7c7TiEGXlvBQE+TXXfRrHt/XJ0LkGi7C1jVlMEMKAW/ur+ge5GrWHVgZZqEhnU4iV1IlNDAlFxRRPhB3pi3NggahPUS+AxkNjj5g9gagrz3UCTRUUXlu7DrhatRGeR5Il/H2RzlcKRLls2qSGSuqEe77RpvJDMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278048; c=relaxed/simple;
	bh=1BJxdxRM5E7eYy6oH8MzvYHvZ2X4J26o/NzUcRbO/XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZKkZrwrHd5vUrPVP4Gc1rfAcp/DXyu02btUALx8d6fyJTH287I7ScIFwsfSxbXfskpd6RwgKevqpN2SXeHEDPgp20H+jTbtrgyMV54GgjuyTmlywq9b1o5bn4tEU1RehzAnP2nsNfsqyrWIn2qtg7PFAZkJ07/uacNq2AqNHgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdFXvqSh; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdFXvqSh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278045; x=1783814045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1BJxdxRM5E7eYy6oH8MzvYHvZ2X4J26o/NzUcRbO/XQ=;
  b=SdFXvqShMgUzkfG/Y06oNJxBI0OEdvqthavczDJLVvqCqrLiF7NoEkrn
   tJclfkQZSyIcy5KEYjsEzjnUYXc4CLY3govsVuXdFYrsX9RhrKbb6BM7c
   Zm++vgnHPy0Woj4EPUJ1L4SFbZNKenxwQGwJe/mqvYvcgU+g/A/7TJf99
   ocMKrEBiXnFKfoghVfJFpMupCCsf9IeEOLEe6At5VVxa+9zhfWDqjI8QF
   RhJIWG9ZyUBsN11G9y0fI59pzcztebsnLXNgU1eQbuztfx7aGX++V0ljB
   QRahdeUbn0CY747XEmcfXUtZ2nE79l2hsH3JS2cO8J8louo+GhLre5oBD
   g==;
X-CSE-ConnectionGUID: u0ikqxVBSK2ge0E/E5NHfA==
X-CSE-MsgGUID: eoSWONqASESGAq+VINLKEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292742"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292742"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:03 -0700
X-CSE-ConnectionGUID: QMUIy22BRhSxz53QhoJQDQ==
X-CSE-MsgGUID: MCQ45f3bTEWfdoa6xpoNew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902150"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:03 -0700
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
Subject: [PATCH v7 21/31] x86,fs/resctrl: Add architectural event pointer
Date: Fri, 11 Jul 2025 16:53:28 -0700
Message-ID: <20250711235341.113933-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl file system layer passed the domain, rmid, and event id to
resctrl_arch_rmid_read() to fetch an event counter.

For some resources this may not be enough information to efficiently
access the counter.

Add mon_evt::arch_priv void pointer. Architecture code can initialize
this when marking each event enabled.

File system code passes this pointer to resctrl_arch_rmid_read().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               |  8 ++++++--
 fs/resctrl/internal.h                 |  4 ++++
 arch/x86/kernel/cpu/resctrl/core.c    |  6 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c |  2 +-
 fs/resctrl/monitor.c                  | 14 ++++++++++----
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d89378346044..da76e9c37b69 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -383,7 +383,8 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 #define MAX_BINARY_BITS	27
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      unsigned int binary_bits, void *arch_priv);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
@@ -478,6 +479,9 @@ void resctrl_arch_pre_mount(void);
  *			only.
  * @rmid:		rmid of the counter to read.
  * @eventid:		eventid to read, e.g. L3 occupancy.
+ * @arch_priv:		Architecture private data for this event.
+ *			The @arch_priv provided by the architecture via
+ *			resctrl_enable_mon_event().
  * @val:		result of the counter read in bytes.
  * @arch_mon_ctx:	An architecture specific value from
  *			resctrl_arch_mon_ctx_alloc(), for MPAM this identifies
@@ -495,7 +499,7 @@ void resctrl_arch_pre_mount(void);
  */
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *arch_mon_ctx);
+			   void *arch_priv, u64 *val, void *arch_mon_ctx);
 
 /**
  * resctrl_arch_rmid_read_context_check()  - warn about invalid contexts
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index b0bacadd9786..56fdccb39375 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @binary_bits:	number of fixed-point binary bits from architecture,
  *			only valid if @is_floating_point is true
  * @enabled:		true if the event is enabled
+ * @arch_priv:		Architecture private data for this event.
+ *			The @arch_priv provided by the architecture via
+ *			resctrl_enable_mon_event().
  */
 struct mon_evt {
 	enum resctrl_event_id	evtid;
@@ -72,6 +75,7 @@ struct mon_evt {
 	bool			is_floating_point;
 	unsigned int		binary_bits;
 	bool			enabled;
+	void			*arch_priv;
 };
 
 extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b8288f5d4aff..63baab53821a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -909,15 +909,15 @@ static __init bool get_rdt_mon_resources(void)
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
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 043f777378a6..185b203f6321 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -219,7 +219,7 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+			   void *arch_priv, u64 *val, void *ignored)
 {
 	int cpu = cpumask_any(&hdr->cpu_mask);
 	struct rdt_hw_l3_mon_domain *hw_dom;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index fa1cd649b0f0..92798e1fb5b0 100644
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
@@ -408,7 +410,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	if (rr->hdr) {
 		/* Single domain. */
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, rr->evt->arch_priv,
+						 &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -434,7 +437,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (d->ci_id != rr->ci_id)
 			continue;
 		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-					     rr->evt->evtid, &tval, rr->arch_mon_ctx);
+					     rr->evt->evtid, rr->evt->arch_priv,
+					     &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -906,7 +910,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      unsigned int binary_bits, void *arch_priv)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
 			 binary_bits > MAX_BINARY_BITS))
@@ -922,6 +927,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsig
 
 	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].binary_bits = binary_bits;
+	mon_event_all[eventid].arch_priv = arch_priv;
 	mon_event_all[eventid].enabled = true;
 }
 
-- 
2.50.0

