Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1029FEACE
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886852; cv=none; b=LaMfA+vKvtUcC7UX8pAooer0rAZsCj3q7VzYZGSC4f14c3+otoly/sXLqG4JOt2V7nOR5cAh1y+ve6YevtxaDD5GnrUb9/MXSdueYSnEmp7uGqM1MbWl8p6s3mzNyn800ulI+F4wsMKhoLYZfIlYjNi/EmZots8khnQ7yHqT3Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886852; c=relaxed/simple;
	bh=EQyc6s7B++el6cT3FsP6xRYTJ8Y7WawpLfITmmOcT+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyF3DWCtNo3MHYE/HbmkBogpSEwXLXTxembCo51xGPjf7W4EJCnJQrb+JA7CRsiEClZ2gGnIsDKBlFo+abvls5ClFEOCz3ml3okpUPZ5JRrYsTVYguMP6gsuDV0L4kAFOb0DgVh63Wm3k/+EI5hOGJ7Oi4XZig0zLlqGu5o36w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZnuljUOK; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZnuljUOK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886850; x=1777422850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EQyc6s7B++el6cT3FsP6xRYTJ8Y7WawpLfITmmOcT+Y=;
  b=ZnuljUOKnpydKipRlW/9X1bH/LzZhPbtr970jAQxvPxGQvLleGpOZL6n
   oc6I2H6xwjc1k7LidtrgKX/ahSK4CcBzc4ct183N20/vdVqLMQNeN4ZWO
   PaRcL0Up6Ppc6o5T4Efm3EIPFkd0aQMn8ssjGH7J6/P+FUIcAw0LEvFgs
   wScMxFr/e9VJV1Nwz0wlnXuCYvfjl9EZthlIq5hrLVs7ePlKx5VIytFby
   QViUO1RXetydtbVY4At6+MPLEmwoF3thjzpjhbsv8QpoDMKMVDNL8aO0q
   puvVPcnF4mgdzGtJd9by3EefLm3Zo03p/Dvbo34/80/WBkhabQmecBmT5
   g==;
X-CSE-ConnectionGUID: A/BJszOLQOSsD/miUSBQhg==
X-CSE-MsgGUID: 35W7BlEjSOunu0TUZjiz5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148044"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148044"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:08 -0700
X-CSE-ConnectionGUID: 8CbrfteYT4G40t00+yy5Mg==
X-CSE-MsgGUID: g4IC66NvQSyGkWpIOSNVOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393953"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:07 -0700
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
Subject: [PATCH v4 02/31] x86,fs/resctrl: Prepare for more monitor events
Date: Mon, 28 Apr 2025 17:33:28 -0700
Message-ID: <20250429003359.375508-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's a rule in computer programming that objects appear zero,
once, or many times. So code accordingly.

There are two MBM events and resctrl is coded with a lot of

        if (local)
                do one thing
        if (total)
                do a different thing

Change the rdt_ctrl_domain and rdt_hw_mon_domain structures to hold
arrays of pointers to per event data instead of explicit fields for
total and local bandwidth.

Simplify the code by coding for many events using loops on
which are enabled.

Move resctrl_is_mbm_event() to <linux/resctrl.h> so it
can be used more widely. Also provide a for_each_mbm_event()
helper macro.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 15 +++++---
 include/linux/resctrl_types.h          |  3 ++
 arch/x86/kernel/cpu/resctrl/internal.h |  6 ++--
 arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
 arch/x86/kernel/cpu/resctrl/monitor.c  | 33 ++++++++++--------
 fs/resctrl/monitor.c                   | 13 ++++---
 fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
 7 files changed, 84 insertions(+), 72 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 3c5d111aae65..cef9b0ed984c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -161,8 +161,7 @@ struct rdt_ctrl_domain {
  * @hdr:		common header for different domain types
  * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
- * @mbm_total:		saved state for MBM total bandwidth
- * @mbm_local:		saved state for MBM local bandwidth
+ * @mbm_states:		saved state for each QOS MBM event
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -172,8 +171,7 @@ struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
-	struct mbm_state		*mbm_total;
-	struct mbm_state		*mbm_local;
+	struct mbm_state		*mbm_states[QOS_NUM_MBM_EVENTS];
 	struct delayed_work		mbm_over;
 	struct delayed_work		cqm_limbo;
 	int				mbm_work_cpu;
@@ -376,6 +374,15 @@ void resctrl_enable_mon_event(enum resctrl_event_id evtid);
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
 
+static inline bool resctrl_is_mbm_event(int e)
+{
+	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
+		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
+}
+
+#define for_each_mbm_event(evt)	\
+	for (evt = QOS_L3_MBM_TOTAL_EVENT_ID; evt <= QOS_L3_MBM_LOCAL_EVENT_ID; evt++)
+
 /**
  * resctrl_arch_mon_event_config_write() - Write the config for an event.
  * @config_info: struct resctrl_mon_config_info describing the resource, domain
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index a25fb9c4070d..5ef14a24008c 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -47,4 +47,7 @@ enum resctrl_event_id {
 	QOS_NUM_EVENTS,
 };
 
+#define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
+#define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
+
 #endif /* __LINUX_RESCTRL_TYPES_H */
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 5e3c41b36437..02b535c828f3 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -54,15 +54,13 @@ struct rdt_hw_ctrl_domain {
  * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
  *			      a resource for a monitor function
  * @d_resctrl:	Properties exposed to the resctrl file system
- * @arch_mbm_total:	arch private state for MBM total bandwidth
- * @arch_mbm_local:	arch private state for MBM local bandwidth
+ * @arch_mbm_states:	arch private state for each MBM event
  *
  * Members of this structure are accessed via helpers that provide abstraction.
  */
 struct rdt_hw_mon_domain {
 	struct rdt_mon_domain		d_resctrl;
-	struct arch_mbm_state		*arch_mbm_total;
-	struct arch_mbm_state		*arch_mbm_local;
+	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_MBM_EVENTS];
 };
 
 static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctrl_domain *r)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 819bc7a09327..e5c91d21e8f7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -364,8 +364,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 
 static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
 {
-	kfree(hw_dom->arch_mbm_total);
-	kfree(hw_dom->arch_mbm_local);
+	for (int i = 0; i < QOS_NUM_MBM_EVENTS; i++)
+		kfree(hw_dom->arch_mbm_states[i]);
 	kfree(hw_dom);
 }
 
@@ -399,25 +399,27 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
  */
 static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
 {
-	size_t tsize;
-
-	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
-		tsize = sizeof(*hw_dom->arch_mbm_total);
-		hw_dom->arch_mbm_total = kcalloc(num_rmid, tsize, GFP_KERNEL);
-		if (!hw_dom->arch_mbm_total)
-			return -ENOMEM;
-	}
-	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
-		tsize = sizeof(*hw_dom->arch_mbm_local);
-		hw_dom->arch_mbm_local = kcalloc(num_rmid, tsize, GFP_KERNEL);
-		if (!hw_dom->arch_mbm_local) {
-			kfree(hw_dom->arch_mbm_total);
-			hw_dom->arch_mbm_total = NULL;
-			return -ENOMEM;
-		}
+	size_t tsize = sizeof(struct arch_mbm_state);
+	enum resctrl_event_id evt;
+	int idx;
+
+	for_each_mbm_event(evt) {
+		if (!resctrl_is_mon_event_enabled(evt))
+			continue;
+		idx = MBM_EVENT_IDX(evt);
+		hw_dom->arch_mbm_states[idx] = kcalloc(num_rmid, tsize, GFP_KERNEL);
+		if (!hw_dom->arch_mbm_states[idx])
+			goto cleanup;
 	}
 
 	return 0;
+cleanup:
+	while (--idx >= 0) {
+		kfree(hw_dom->arch_mbm_states[idx]);
+		hw_dom->arch_mbm_states[idx] = NULL;
+	}
+
+	return -ENOMEM;
 }
 
 static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index fda579251dba..bf7fde07846b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -160,18 +160,21 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
 {
+	struct arch_mbm_state *state;
+
 	switch (eventid) {
-	case QOS_L3_OCCUP_EVENT_ID:
-		return NULL;
-	case QOS_L3_MBM_TOTAL_EVENT_ID:
-		return &hw_dom->arch_mbm_total[rmid];
-	case QOS_L3_MBM_LOCAL_EVENT_ID:
-		return &hw_dom->arch_mbm_local[rmid];
 	default:
 		/* Never expect to get here */
 		WARN_ON_ONCE(1);
+		fallthrough;
+	case QOS_L3_OCCUP_EVENT_ID:
 		return NULL;
+	case QOS_L3_MBM_TOTAL_EVENT_ID:
+	case QOS_L3_MBM_LOCAL_EVENT_ID:
+		state = hw_dom->arch_mbm_states[MBM_EVENT_IDX(eventid)];
 	}
+
+	return state ? &state[rmid] : NULL;
 }
 
 void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
@@ -200,14 +203,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
 void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
-
-	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-		memset(hw_dom->arch_mbm_total, 0,
-		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
-
-	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-		memset(hw_dom->arch_mbm_local, 0,
-		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
+	enum resctrl_event_id evt;
+	int idx;
+
+	for_each_mbm_event(evt) {
+		idx = MBM_EVENT_IDX(evt);
+		if (!hw_dom->arch_mbm_states[idx])
+			continue;
+		memset(hw_dom->arch_mbm_states[idx], 0,
+		       sizeof(struct arch_mbm_state) * r->num_rmid);
+	}
 }
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 7de4e219dba3..ef33970166af 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -346,15 +346,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
 				       u32 rmid, enum resctrl_event_id evtid)
 {
 	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
+	struct mbm_state *states;
 
-	switch (evtid) {
-	case QOS_L3_MBM_TOTAL_EVENT_ID:
-		return &d->mbm_total[idx];
-	case QOS_L3_MBM_LOCAL_EVENT_ID:
-		return &d->mbm_local[idx];
-	default:
+	if (!resctrl_is_mbm_event(evtid))
 		return NULL;
-	}
+
+	states = d->mbm_states[MBM_EVENT_IDX(evtid)];
+
+	return states ? &states[idx] : NULL;
 }
 
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 4a092c305255..c06752dfcb7c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -127,12 +127,6 @@ static bool resctrl_is_mbm_enabled(void)
 		resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID));
 }
 
-static bool resctrl_is_mbm_event(int e)
-{
-	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
-		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
-}
-
 /*
  * Trivial allocator for CLOSIDs. Use BITMAP APIs to manipulate a bitmap
  * of free CLOSIDs.
@@ -4019,8 +4013,10 @@ static void rdtgroup_setup_default(void)
 static void domain_destroy_mon_state(struct rdt_mon_domain *d)
 {
 	bitmap_free(d->rmid_busy_llc);
-	kfree(d->mbm_total);
-	kfree(d->mbm_local);
+	for (int i = 0; i < QOS_NUM_MBM_EVENTS; i++) {
+		kfree(d->mbm_states[i]);
+		d->mbm_states[i] = NULL;
+	}
 }
 
 void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
@@ -4080,32 +4076,34 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
-	size_t tsize;
+	size_t tsize = sizeof(struct mbm_state);
+	enum resctrl_event_id evt;
+	int idx;
 
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
 		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
-	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
-		tsize = sizeof(*d->mbm_total);
-		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
-		if (!d->mbm_total) {
-			bitmap_free(d->rmid_busy_llc);
-			return -ENOMEM;
-		}
-	}
-	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
-		tsize = sizeof(*d->mbm_local);
-		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
-		if (!d->mbm_local) {
-			bitmap_free(d->rmid_busy_llc);
-			kfree(d->mbm_total);
-			return -ENOMEM;
-		}
+
+	for_each_mbm_event(evt) {
+		if (!resctrl_is_mon_event_enabled(evt))
+			continue;
+		idx = MBM_EVENT_IDX(evt);
+		d->mbm_states[idx] = kcalloc(idx_limit, tsize, GFP_KERNEL);
+		if (!d->mbm_states[idx])
+			goto cleanup;
 	}
 
 	return 0;
+cleanup:
+	bitmap_free(d->rmid_busy_llc);
+	while (--idx >= 0) {
+		kfree(d->mbm_states[idx]);
+		d->mbm_states[idx] = NULL;
+	}
+
+	return -ENOMEM;
 }
 
 int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
-- 
2.48.1

