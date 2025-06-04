Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F99E21C190
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 21:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072140; cv=none; b=LItjUt1F7l6+10ZCLbF6yjwPUu9k7jO5kgn7sIXVhG/37cgecRhhDVp+PHEvLtO/8AsRr2ANjgs6zsx56/g+CF6aF4eIz6qFo6mg4nqNgL6V9aj8AW1RYAtchh2hiDIMeaRiIenv7evGdHltVuXC9nQ9V3FYeF4p+KoqTnwdDXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072140; c=relaxed/simple;
	bh=CPqNXOtS5x3av3658c+mXymxlY+uGP6E3aqM8g3/wZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8gwnkJ8HsO+iJfpryCEf6Ci1Y0eG+cuJ7EJqIF4nhziQIKassqWjgKedKkMGhRgJOvqpnLzk2Xe7lRdPA1jBnPwQb1M0v9pJc3GSRoGgPzKAKNvYqvpjAYhNIuMAFoMNVt6y29wFKb9U+akJVL2Xe1rEq3pgNrgegwqpLCGsus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CDYKQvES; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CDYKQvES"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749072139; x=1780608139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CPqNXOtS5x3av3658c+mXymxlY+uGP6E3aqM8g3/wZg=;
  b=CDYKQvESE1RM6dQuqYquA10Tr3Acq9loK19RoIyoWlScU+JXgDYJJJKa
   o0486VcAmvdmcgsyMN+sZMCfA8EbCTZftN73HiqN4MYVifsRCVIvNEOMy
   T0HBN8IzEMi68O3O9I09BaZ01bmDD5kZ5kA42CWxrx7dYOyUw/GlpoP2K
   5lIzKk70G6ePACjET8vg0QAgBPZza2eNj9485XPCqJfNUUw52kG2I+M7y
   TxEb/FRr+UMqcDHY6iPw+74dyDdqdmBixCbrLt5nivxu3VjcWtJDdCAcW
   fk6YpT1OX9+uOiKa1Rm0YQRHyKtwip3huNnMpbY12QFvQcKyl7KLHVCQ3
   Q==;
X-CSE-ConnectionGUID: 64zXzSY5TKSMUjGV3JSNew==
X-CSE-MsgGUID: Q7hfODdFQdiHCZEvc8bUHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="76572771"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="76572771"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 14:22:15 -0700
X-CSE-ConnectionGUID: GzSWHOCzSJO+M9yHYMvHkA==
X-CSE-MsgGUID: h2637UetS2+lv/ZDi3NcKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="150094202"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 14:22:15 -0700
From: Tony Luck <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 4/4 UPDATED] x86,fs/resctrl: Prepare for more monitor events
Date: Wed,  4 Jun 2025 14:22:08 -0700
Message-ID: <20250604212208.49080-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250604212208.49080-1-tony.luck@intel.com>
References: <20250604212208.49080-1-tony.luck@intel.com>
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

Change the rdt_mon_domain and rdt_hw_mon_domain structures to hold arrays
of pointers to per event data instead of explicit fields for total and
local bandwidth.

Simplify by coding for many events using loops on which are enabled.

Move resctrl_is_mbm_event() to <linux/resctrl.h> so it can be used more
widely. Also provide a for_each_mbm_event_id() helper macro.

Cleanup variable names in functions touched to consistently use
"eventid" for those with type enum resctrl_event_id.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 18 +++++++---
 include/linux/resctrl_types.h          |  3 ++
 arch/x86/kernel/cpu/resctrl/internal.h |  9 ++---
 arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
 arch/x86/kernel/cpu/resctrl/monitor.c  | 36 +++++++++----------
 fs/resctrl/monitor.c                   | 13 ++++---
 fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
 7 files changed, 88 insertions(+), 77 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 8404089f18ad..ee2090ef2936 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -161,8 +161,9 @@ struct rdt_ctrl_domain {
  * @hdr:		common header for different domain types
  * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
- * @mbm_total:		saved state for MBM total bandwidth
- * @mbm_local:		saved state for MBM local bandwidth
+ * @mbm_states:		Per-event pointer to the MBM event's saved state.
+ *			An MBM event's state is an array of struct mbm_state
+ *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -172,8 +173,7 @@ struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
-	struct mbm_state		*mbm_total;
-	struct mbm_state		*mbm_local;
+	struct mbm_state		*mbm_states[QOS_NUM_L3_MBM_EVENTS];
 	struct delayed_work		mbm_over;
 	struct delayed_work		cqm_limbo;
 	int				mbm_work_cpu;
@@ -376,6 +376,16 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
 
+static inline bool resctrl_is_mbm_event(enum resctrl_event_id eventid)
+{
+	return (eventid >= QOS_L3_MBM_TOTAL_EVENT_ID &&
+		eventid <= QOS_L3_MBM_LOCAL_EVENT_ID);
+}
+
+#define for_each_mbm_event_id(eventid)				\
+	for (eventid = QOS_L3_MBM_TOTAL_EVENT_ID;		\
+	     eventid <= QOS_L3_MBM_LOCAL_EVENT_ID; eventid++)
+
 /**
  * resctrl_arch_mon_event_config_write() - Write the config for an event.
  * @config_info: struct resctrl_mon_config_info describing the resource, domain
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index 2dadbc54e4b3..d98351663c2c 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -51,4 +51,7 @@ enum resctrl_event_id {
 	QOS_NUM_EVENTS,
 };
 
+#define QOS_NUM_L3_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
+#define MBM_STATE_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
+
 #endif /* __LINUX_RESCTRL_TYPES_H */
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 5e3c41b36437..44ef0d94131e 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -54,15 +54,16 @@ struct rdt_hw_ctrl_domain {
  * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
  *			      a resource for a monitor function
  * @d_resctrl:	Properties exposed to the resctrl file system
- * @arch_mbm_total:	arch private state for MBM total bandwidth
- * @arch_mbm_local:	arch private state for MBM local bandwidth
+ * @arch_mbm_states:	arch private state for each MBM event
+ * @arch_mbm_states:	Per-event pointer to the MBM event's saved state.
+ *			An MBM event's state is an array of struct arch_mbm_state
+ *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
  *
  * Members of this structure are accessed via helpers that provide abstraction.
  */
 struct rdt_hw_mon_domain {
 	struct rdt_mon_domain		d_resctrl;
-	struct arch_mbm_state		*arch_mbm_total;
-	struct arch_mbm_state		*arch_mbm_local;
+	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_L3_MBM_EVENTS];
 };
 
 static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctrl_domain *r)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8ff76b9bd09b..18fabbbed090 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -365,8 +365,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 
 static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
 {
-	kfree(hw_dom->arch_mbm_total);
-	kfree(hw_dom->arch_mbm_local);
+	for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++)
+		kfree(hw_dom->arch_mbm_states[i]);
 	kfree(hw_dom);
 }
 
@@ -400,25 +400,27 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
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
+	size_t tsize = sizeof(*hw_dom->arch_mbm_states[0]);
+	enum resctrl_event_id eventid;
+	int idx;
+
+	for_each_mbm_event_id(eventid) {
+		if (!resctrl_is_mon_event_enabled(eventid))
+			continue;
+		idx = MBM_STATE_IDX(eventid);
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
index 07f8ab097cbe..0add57b29a4d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -161,18 +161,14 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
 {
-	switch (eventid) {
-	case QOS_L3_OCCUP_EVENT_ID:
-		return NULL;
-	case QOS_L3_MBM_TOTAL_EVENT_ID:
-		return &hw_dom->arch_mbm_total[rmid];
-	case QOS_L3_MBM_LOCAL_EVENT_ID:
-		return &hw_dom->arch_mbm_local[rmid];
-	default:
-		/* Never expect to get here */
-		WARN_ON_ONCE(1);
+	struct arch_mbm_state *state;
+
+	if (!resctrl_is_mbm_event(eventid))
 		return NULL;
-	}
+
+	state = hw_dom->arch_mbm_states[MBM_STATE_IDX(eventid)];
+
+	return state ? &state[rmid] : NULL;
 }
 
 void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
@@ -201,14 +197,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
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
+	enum resctrl_event_id eventid;
+	int idx;
+
+	for_each_mbm_event_id(eventid) {
+		if (!resctrl_is_mon_event_enabled(eventid))
+			continue;
+		idx = MBM_STATE_IDX(eventid);
+		memset(hw_dom->arch_mbm_states[idx], 0,
+		       sizeof(struct arch_mbm_state) * r->num_rmid);
+	}
 }
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 73328cfbadc6..d4d211b7b5d3 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -346,15 +346,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
 				       u32 rmid, enum resctrl_event_id evtid)
 {
 	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
+	struct mbm_state *state;
 
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
+	state = d->mbm_states[MBM_STATE_IDX(evtid)];
+
+	return state ? &state[idx] : NULL;
 }
 
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 73d16e96cc3b..fbc23bfae46a 100644
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
@@ -4020,8 +4014,10 @@ static void rdtgroup_setup_default(void)
 static void domain_destroy_mon_state(struct rdt_mon_domain *d)
 {
 	bitmap_free(d->rmid_busy_llc);
-	kfree(d->mbm_total);
-	kfree(d->mbm_local);
+	for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++) {
+		kfree(d->mbm_states[i]);
+		d->mbm_states[i] = NULL;
+	}
 }
 
 void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
@@ -4081,32 +4077,34 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
-	size_t tsize;
+	size_t tsize = sizeof(*d->mbm_states[0]);
+	enum resctrl_event_id eventid;
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
+	for_each_mbm_event_id(eventid) {
+		if (!resctrl_is_mon_event_enabled(eventid))
+			continue;
+		idx = MBM_STATE_IDX(eventid);
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
2.49.0

