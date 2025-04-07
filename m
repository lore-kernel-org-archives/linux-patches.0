Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B9C22B5A1
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069254; cv=none; b=MXPPRCkPfygGjHEwM/2qFsdL1apIp7E4YZ8mZEsM2vgyCF7kjuqbSFeiqMen3qVDzbFQmSsR4VlkbSR16vcK2BX0sIqwOlwyxUPZ5zprjc2QlOqe7Ix5spj7gyD+s/AvdCB/kJcOYBRkxqlbptjHpSXU1XXm1ceCg0Kn+c8DuG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069254; c=relaxed/simple;
	bh=0SsHkzJ+rKfwiQhKtqjOmpxI83+lcGEhE7JmP2gJ82k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOG92I0mdf2Efd+lbSH9G3ZZYafcE0eA/vgh0Rkoo3PgQRJkrqd2LEKaGju8sn0QCjvQcpzKAHicic5PN4eBmphLCGcJK9ztcGRCprAbciZkOcg2o8jFPGfgUtg54K7AldP2pri91REVQ6+h2aKgAJiP3Ch+ciiHx0T8/OQKMFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MEuYezdm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MEuYezdm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069251; x=1775605251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0SsHkzJ+rKfwiQhKtqjOmpxI83+lcGEhE7JmP2gJ82k=;
  b=MEuYezdmwu/mG4LHLl5pnb/b/GHMC51qy+dhsKnyT0jIc+1e7be1J7Gx
   Sjsl30tekcLovx0XFq/vr8ADfVZCafR3wr7GCx1KpnkL72AZfyTW8cYOa
   4coX8CQd6xjowCmBAkLqHV9FgSvLxjwC/6rQJQRSNfocQA6zMjldGffMB
   1RaZEimNjmtTDMTl3PK7ziUtdqqfWRadv4gFzbnNqvIFvAhY0uo2FU5ck
   MSPPm4aIcQFzVc3fNFE1CeULo4J+7wykla7OkpAQRu7vKSmGkbbeow9X6
   L2pq95Rj30FKXTpTm3wqyaAQW93X2K8GvZZTFhgwUIQZL0dTGal2RrzBR
   Q==;
X-CSE-ConnectionGUID: CF66O8RKQTiysBOXRY6hzw==
X-CSE-MsgGUID: pispWIRzS5m1pdoXWBfjKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193123"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193123"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:45 -0700
X-CSE-ConnectionGUID: 9U8pZbmcR76OHq4QZV87sg==
X-CSE-MsgGUID: tXpnbrOETv22aTV6+5sc+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315447"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:44 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 02/26] fs-x86/resctrl: Prepare for more monitor events
Date: Mon,  7 Apr 2025 16:40:04 -0700
Message-ID: <20250407234032.241215-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
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

Simplify the code by coding for many events using loops on
which are enabled.

Make rdt_mon_features a bitmap to allow for expansion.

Move resctrl_is_mbm_event() to <asm/resctrl.h> as it gets used by core.c

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                |  6 +--
 include/linux/resctrl_types.h          |  8 +++
 arch/x86/include/asm/resctrl.h         |  8 +--
 arch/x86/kernel/cpu/resctrl/internal.h |  6 +--
 fs/resctrl/internal.h                  |  4 ++
 arch/x86/kernel/cpu/resctrl/core.c     | 45 +++++++++--------
 arch/x86/kernel/cpu/resctrl/monitor.c  | 33 ++++++------
 fs/resctrl/ctrlmondata.c               | 41 ++++-----------
 fs/resctrl/monitor.c                   | 70 ++++++++++++++++----------
 fs/resctrl/rdtgroup.c                  | 47 ++++++++---------
 10 files changed, 133 insertions(+), 135 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 5c7c8bf2c47f..d6a926b6fc0e 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -151,8 +151,7 @@ struct rdt_ctrl_domain {
  * @hdr:		common header for different domain types
  * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
- * @mbm_total:		saved state for MBM total bandwidth
- * @mbm_local:		saved state for MBM local bandwidth
+ * @mbm_states:		saved state for each QOS MBM event
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -162,8 +161,7 @@ struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
-	struct mbm_state		*mbm_total;
-	struct mbm_state		*mbm_local;
+	struct mbm_state		*mbm_states[QOS_NUM_MBM_EVENTS];
 	struct delayed_work		mbm_over;
 	struct delayed_work		cqm_limbo;
 	int				mbm_work_cpu;
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index a7faf2cd5406..898068a99ef7 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -55,5 +55,13 @@ enum resctrl_event_id {
 };
 
 #define QOS_NUM_EVENTS		(QOS_L3_MBM_LOCAL_EVENT_ID + 1)
+#define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
+#define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
+
+static inline bool resctrl_is_mbm_event(int e)
+{
+	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
+		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
+}
 
 #endif /* __LINUX_RESCTRL_TYPES_H */
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 6eb7d5c94c7a..4346de48eeab 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -42,7 +42,7 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
-extern unsigned int rdt_mon_features;
+extern DECLARE_BITMAP(rdt_mon_features, QOS_NUM_EVENTS);
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -84,17 +84,17 @@ static inline void resctrl_arch_disable_mon(void)
 
 static inline bool resctrl_arch_is_llc_occupancy_enabled(void)
 {
-	return (rdt_mon_features & (1 << QOS_L3_OCCUP_EVENT_ID));
+	return test_bit(QOS_L3_OCCUP_EVENT_ID, rdt_mon_features);
 }
 
 static inline bool resctrl_arch_is_mbm_total_enabled(void)
 {
-	return (rdt_mon_features & (1 << QOS_L3_MBM_TOTAL_EVENT_ID));
+	return test_bit(QOS_L3_MBM_TOTAL_EVENT_ID, rdt_mon_features);
 }
 
 static inline bool resctrl_arch_is_mbm_local_enabled(void)
 {
-	return (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID));
+	return test_bit(QOS_L3_MBM_LOCAL_EVENT_ID, rdt_mon_features);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 521db28efb3f..45eabc7919c6 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -59,15 +59,13 @@ struct rdt_hw_ctrl_domain {
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
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index e5976bd52a35..7a65ea02d442 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -386,6 +386,10 @@ bool closid_allocated(unsigned int closid);
 
 int resctrl_find_cleanest_closid(void);
 
+int rdt_lookup_evtid_by_name(char *name);
+
+char *rdt_event_name(enum resctrl_event_id evt);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6ed0d4f5d6a3..6f4a3bd02a42 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -366,8 +366,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 
 static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
 {
-	kfree(hw_dom->arch_mbm_total);
-	kfree(hw_dom->arch_mbm_local);
+	for (int i = 0; i < QOS_NUM_MBM_EVENTS; i++)
+		kfree(hw_dom->arch_mbm_states[i]);
 	kfree(hw_dom);
 }
 
@@ -401,25 +401,26 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
  */
 static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
 {
-	size_t tsize;
-
-	if (resctrl_arch_is_mbm_total_enabled()) {
-		tsize = sizeof(*hw_dom->arch_mbm_total);
-		hw_dom->arch_mbm_total = kcalloc(num_rmid, tsize, GFP_KERNEL);
-		if (!hw_dom->arch_mbm_total)
-			return -ENOMEM;
-	}
-	if (resctrl_arch_is_mbm_local_enabled()) {
-		tsize = sizeof(*hw_dom->arch_mbm_local);
-		hw_dom->arch_mbm_local = kcalloc(num_rmid, tsize, GFP_KERNEL);
-		if (!hw_dom->arch_mbm_local) {
-			kfree(hw_dom->arch_mbm_total);
-			hw_dom->arch_mbm_total = NULL;
-			return -ENOMEM;
-		}
+	size_t tsize = sizeof(struct arch_mbm_state);
+	int evt, idx;
+
+	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
+		if (!resctrl_is_mbm_event(evt))
+			continue;
+		idx = MBM_EVENT_IDX(evt);
+		hw_dom->arch_mbm_states[idx] = kcalloc(num_rmid, tsize, GFP_KERNEL);
+		if (!hw_dom->arch_mbm_states[idx])
+			goto cleanup;
 	}
 
 	return 0;
+cleanup:
+	for (idx = 0; idx < QOS_NUM_MBM_EVENTS; idx++) {
+		kfree(hw_dom->arch_mbm_states[idx]);
+		hw_dom->arch_mbm_states[idx] = NULL;
+	}
+
+	return -ENOMEM;
 }
 
 static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
@@ -864,13 +865,13 @@ static __init bool get_rdt_mon_resources(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
-		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
+		__set_bit(QOS_L3_OCCUP_EVENT_ID, rdt_mon_features);
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL))
-		rdt_mon_features |= (1 << QOS_L3_MBM_TOTAL_EVENT_ID);
+		__set_bit(QOS_L3_MBM_TOTAL_EVENT_ID, rdt_mon_features);
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
-		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
+		__set_bit(QOS_L3_MBM_LOCAL_EVENT_ID, rdt_mon_features);
 
-	if (!rdt_mon_features)
+	if (find_first_bit(rdt_mon_features, QOS_NUM_EVENTS) == QOS_NUM_EVENTS)
 		return false;
 
 	return !rdt_get_mon_l3_config(r);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 163174cc0d3e..06623d51d006 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -36,7 +36,7 @@ bool rdt_mon_capable;
 /*
  * Global to indicate which monitoring events are enabled.
  */
-unsigned int rdt_mon_features;
+DECLARE_BITMAP(rdt_mon_features, QOS_NUM_EVENTS);
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
@@ -168,19 +168,14 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
 {
-	switch (eventid) {
-	case QOS_L3_OCCUP_EVENT_ID:
+	struct arch_mbm_state *state;
+
+	if (!resctrl_is_mbm_event(eventid))
 		return NULL;
-	case QOS_L3_MBM_TOTAL_EVENT_ID:
-		return &hw_dom->arch_mbm_total[rmid];
-	case QOS_L3_MBM_LOCAL_EVENT_ID:
-		return &hw_dom->arch_mbm_local[rmid];
-	}
 
-	/* Never expect to get here */
-	WARN_ON_ONCE(1);
+	state = hw_dom->arch_mbm_states[MBM_EVENT_IDX(eventid)];
 
-	return NULL;
+	return state ? &state[rmid] : NULL;
 }
 
 void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
@@ -209,14 +204,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
 void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	int evt, idx;
+
+	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
+		idx = MBM_EVENT_IDX(evt);
+		if (!hw_dom->arch_mbm_states[idx])
+			continue;
+		memset(hw_dom->arch_mbm_states[idx], 0,
+		       sizeof(struct arch_mbm_state) * r->num_rmid);
+	}
 
-	if (resctrl_arch_is_mbm_total_enabled())
-		memset(hw_dom->arch_mbm_total, 0,
-		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
-
-	if (resctrl_arch_is_mbm_local_enabled())
-		memset(hw_dom->arch_mbm_local, 0,
-		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
 }
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d56b78450a99..ce02e961a6c3 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -458,7 +458,7 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 				      char *buf, size_t nbytes, loff_t off)
 {
 	struct rdtgroup *rdtgrp;
-	int ret = 0;
+	int ret;
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n')
@@ -472,26 +472,15 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
-	if (!strcmp(buf, "mbm_local_bytes")) {
-		if (resctrl_arch_is_mbm_local_enabled())
-			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
-		else
-			ret = -EINVAL;
-	} else if (!strcmp(buf, "mbm_total_bytes")) {
-		if (resctrl_arch_is_mbm_total_enabled())
-			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
-		else
-			ret = -EINVAL;
-	} else {
-		ret = -EINVAL;
-	}
-
-	if (ret)
+	ret = rdt_lookup_evtid_by_name(buf);
+	if (ret < 0)
 		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
+	else
+		rdtgrp->mba_mbps_event = ret;
 
 	rdtgroup_kn_unlock(of->kn);
 
-	return ret ?: nbytes;
+	return ret < 0 ? ret : nbytes;
 }
 
 int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
@@ -502,22 +491,10 @@ int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 
-	if (rdtgrp) {
-		switch (rdtgrp->mba_mbps_event) {
-		case QOS_L3_MBM_LOCAL_EVENT_ID:
-			seq_puts(s, "mbm_local_bytes\n");
-			break;
-		case QOS_L3_MBM_TOTAL_EVENT_ID:
-			seq_puts(s, "mbm_total_bytes\n");
-			break;
-		default:
-			pr_warn_once("Bad event %d\n", rdtgrp->mba_mbps_event);
-			ret = -EINVAL;
-			break;
-		}
-	} else {
+	if (rdtgrp)
+		seq_printf(s, "%s\n", rdt_event_name(rdtgrp->mba_mbps_event));
+	else
 		ret = -ENOENT;
-	}
 
 	rdtgroup_kn_unlock(of->kn);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 3fe21dcf0fde..66e613906f3e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -347,15 +347,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
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
@@ -843,20 +842,40 @@ static void dom_data_exit(struct rdt_resource *r)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static struct mon_evt llc_occupancy_event = {
-	.name		= "llc_occupancy",
-	.evtid		= QOS_L3_OCCUP_EVENT_ID,
+static struct mon_evt all_events[QOS_NUM_EVENTS] = {
+	[QOS_L3_OCCUP_EVENT_ID] = {
+		.name	= "llc_occupancy",
+		.evtid	= QOS_L3_OCCUP_EVENT_ID,
+	},
+	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
+		.name	= "mbm_total_bytes",
+		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
+	},
+	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
+		.name	= "mbm_local_bytes",
+		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
+	},
 };
 
-static struct mon_evt mbm_total_event = {
-	.name		= "mbm_total_bytes",
-	.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
-};
+int rdt_lookup_evtid_by_name(char *name)
+{
+	int evt;
 
-static struct mon_evt mbm_local_event = {
-	.name		= "mbm_local_bytes",
-	.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
-};
+	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
+		if (!strcmp(name, all_events[evt].name))
+			return evt;
+	}
+
+	return -EINVAL;
+}
+
+char *rdt_event_name(enum resctrl_event_id evt)
+{
+	if (!test_bit(evt, rdt_mon_features))
+		return "unknown";
+
+	return all_events[evt].name;
+}
 
 /*
  * Initialize the event list for the resource.
@@ -870,14 +889,13 @@ static struct mon_evt mbm_local_event = {
  */
 static void l3_mon_evt_init(struct rdt_resource *r)
 {
+	int evt;
+
 	INIT_LIST_HEAD(&r->evt_list);
 
-	if (resctrl_arch_is_llc_occupancy_enabled())
-		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
-	if (resctrl_arch_is_mbm_total_enabled())
-		list_add_tail(&mbm_total_event.list, &r->evt_list);
-	if (resctrl_arch_is_mbm_local_enabled())
-		list_add_tail(&mbm_local_event.list, &r->evt_list);
+	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
+		list_add_tail(&all_events[evt].list, &r->evt_list);
+	}
 }
 
 /**
@@ -907,12 +925,12 @@ int resctrl_mon_resource_init(void)
 	l3_mon_evt_init(r);
 
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
-		mbm_total_event.configurable = true;
+		all_events[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_LOCAL_EVENT_ID)) {
-		mbm_local_event.configurable = true;
+		all_events[QOS_L3_MBM_LOCAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_local_bytes_config",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 338b70c7d302..8d15d53fae76 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -125,12 +125,6 @@ static bool resctrl_is_mbm_enabled(void)
 		resctrl_arch_is_mbm_local_enabled());
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
@@ -3970,8 +3964,10 @@ static void rdtgroup_setup_default(void)
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
@@ -4031,32 +4027,33 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
-	size_t tsize;
+	size_t tsize = sizeof(struct mbm_state);
+	int evt, idx;
 
 	if (resctrl_arch_is_llc_occupancy_enabled()) {
 		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
-	if (resctrl_arch_is_mbm_total_enabled()) {
-		tsize = sizeof(*d->mbm_total);
-		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
-		if (!d->mbm_total) {
-			bitmap_free(d->rmid_busy_llc);
-			return -ENOMEM;
-		}
-	}
-	if (resctrl_arch_is_mbm_local_enabled()) {
-		tsize = sizeof(*d->mbm_local);
-		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
-		if (!d->mbm_local) {
-			bitmap_free(d->rmid_busy_llc);
-			kfree(d->mbm_total);
-			return -ENOMEM;
-		}
+
+	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
+		if (!resctrl_is_mbm_event(evt))
+			continue;
+		idx = MBM_EVENT_IDX(evt);
+		d->mbm_states[idx] = kcalloc(idx_limit, tsize, GFP_KERNEL);
+		if (!d->mbm_states[idx])
+			goto cleanup;
 	}
 
 	return 0;
+cleanup:
+	bitmap_free(d->rmid_busy_llc);
+	for (idx = 0; idx < QOS_NUM_MBM_EVENTS; idx++) {
+		kfree(d->mbm_states[idx]);
+		d->mbm_states[idx] = NULL;
+	}
+
+	return -ENOMEM;
 }
 
 int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
-- 
2.48.1

