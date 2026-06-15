Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA92315793
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547917; cv=none; b=q9m88cYzbNuZoGGRTGNnsnEmOv1pBCOHN9/2bnQsoSVbgWVT6oTbTod9iUQMg1FXHn5ORZDtqLlWyU3LdEGfKBgK2HsDaf3CbiWLW6GsK/OlpbRe2zaBmIFDj4tIriv7yaDisGUiCxpG2caLElAiyWPCX4s88O2sy9oFZBqFwj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547917; c=relaxed/simple;
	bh=/7aA8QlF0XwldwOMloEcg+E9c38a6zMUX+zdAt5H90A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tI9WiTWubIGTlQsMq2FiY8uupCqYcojK8VO+poTrOdPlXAnFvKlgEt0JBVfRhKcv/MLKT/OAZs7FWo31EeiriAUvb8qrbBkHX/eumWzMMOMgGKgbSdH41bdkxU3luDThyR5QJAUXRcx6RW/gyk4W32Et/KyNJFukL0tHTb/a59w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIayo5O5; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIayo5O5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547915; x=1813083915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/7aA8QlF0XwldwOMloEcg+E9c38a6zMUX+zdAt5H90A=;
  b=BIayo5O5EuQWGin01wo5M5QWXCpsFiOApqqJUaR4pyIXabKBiyD8uEOw
   gdOzQly1flcZUwq561p6Z6fG9VhBhYkmjTEO8Wmeo1DfuRbIKsYOrGYmb
   A1OLF7XopppgzVpdckaRNvcLg52kfAPVyu/29wzTj7HeRx/WD2IQxCHd5
   q+K7Sh+gRB7asQF6op70wLC/yWZ4eU41riQYc+Ra7JmiPRWw6gF6sPwvl
   c/Bz55ufPUc/CTOR+1DlpH+uGVX6g7GGwBnA5CCW3xF8WPv8/5GiiYhJh
   3+f/Np/0A/gOJv123IHNzQNRzq/ZccFEFYypWJaYGwli72lFrSCzm/j/t
   w==;
X-CSE-ConnectionGUID: ELMp+vBKQfW/nzTLgFrZlA==
X-CSE-MsgGUID: P/Gaosg4TjCErkUWLfwSbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790008"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790008"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:11 -0700
X-CSE-ConnectionGUID: n+1ZWMTTQQm3z+Qs1+OQyg==
X-CSE-MsgGUID: 5XMWle5TRV+Z3xwtpT0lXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620646"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:10 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 10/16] arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount
Date: Mon, 15 Jun 2026 11:24:51 -0700
Message-ID: <20260615182457.14725-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Application Energy Telemetry (AET) event enumeration takes place
asynchronously. Linux builds the pmt_telemetry module into the kernel to
kick off enumeration early enough that it completes before first mount of
the resctrl file system.

Allowing pmt_telemetry to be a loadable module means that it is possible
for different numbers of RMIDs to be supported on each mount, depending
on whether pmt_telemetry module is loaded.

For simplicity, calculate the maximum possible number of RMIDs and use
that value to allocate the rmid_ptrs[] array just once. Also use this
maximum RMID value when allocating rdt_l3_mon_domain::rmid_busy_llc
bitmap and rdt_l3_mon_domain::mbm_states.

The limbo code must deal with changes in the number of RMIDs from one
mount to the next because some RMIDs may still be "busy" when the file
system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
for the remount. In this case RMIDs that can be released are not put
onto the rmid_free_lru list.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v8:
	Pick arm,x86,fs/resctrl as standard tag syntax
	Update kerneldoc for rdt_l3_mon_domain::rmid_busy_llc and
	rdt_l3_mon_domain::mbm_states to say they are sized for max RMID.
	Rename local variable idx_limit. Use max_idx_limit when dealing with
	the maximum possible RMID value and min_idx_limit when dealing with
	the minimum value across resources for the current mount.
	Compute index of reserved RMID instead of assuming "0" in
	setup_rmid_lru_list()
	Update commit comment to provide overview of the change instead
	of details of the code change.

 include/linux/resctrl.h            |  5 +-
 arch/x86/kernel/cpu/resctrl/core.c | 14 ++++++
 drivers/resctrl/mpam_resctrl.c     |  5 ++
 fs/resctrl/monitor.c               | 76 +++++++++++++++++++-----------
 fs/resctrl/rdtgroup.c              |  6 +--
 5 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 138810ada049..8740dc52b0f7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -182,10 +182,12 @@ struct mbm_cntr_cfg {
  * struct rdt_l3_mon_domain - group of CPUs sharing RDT_RESOURCE_L3 monitoring
  * @hdr:		common header for different domain types
  * @ci_id:		cache info id for this domain
- * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
+ * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold. Sized for
+ *			resctrl_arch_system_max_rmid_idx() RMIDs
  * @mbm_states:		Per-event pointer to the MBM event's saved state.
  *			An MBM event's state is an array of struct mbm_state
  *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
+ *			Also sized for resctrl_arch_system_max_rmid_idx() RMIDs
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -412,6 +414,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 /* The number of closid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
+u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index fb6d52ea3406..08a229e25883 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -143,6 +143,20 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
+/**
+ * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
+ *
+ * Return: If L3 monitoring is supported, largest possible comes from L3 based
+ * on CPUID(0xf,0x0).EBX (scaled down on Sub-NUMA Cluster systems). Otherwise
+ * maximum from any other mon_capable resources.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+
+	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
+}
+
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
 	if (l >= RDT_NUM_RESOURCES)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 226ff6f532fa..7079870ca894 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -272,6 +272,11 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
 }
 
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
 {
 	return closid * (mpam_pmg_max + 1) + rmid;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 8178fc65318e..67cc99a9b582 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -115,10 +115,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
 static void limbo_release_entry(struct rmid_entry *entry)
 {
+	u32 min_idx_limit = resctrl_arch_system_num_rmid_idx();
+
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	rmid_limbo_count--;
-	list_add_tail(&entry->list, &rmid_free_lru);
+
+	/*
+	 * Limbo may be freeing an RMID from a previous mount where there
+	 * were more RMIDs available.
+	 */
+	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < min_idx_limit)
+		list_add_tail(&entry->list, &rmid_free_lru);
 
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
 		closid_num_dirty_rmid[entry->closid]--;
@@ -133,14 +141,20 @@ static void limbo_release_entry(struct rmid_entry *entry)
 void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	struct rmid_entry *entry;
 	u32 idx, cur_idx = 1;
 	void *arch_mon_ctx;
+	u32 max_idx_limit;
 	void *arch_priv;
 	bool rmid_dirty;
 	u64 val = 0;
 
+	/*
+	 * Need to check all possible RMIDs, not just the range available
+	 * in this mount cycle.
+	 */
+	max_idx_limit = resctrl_arch_system_max_rmid_idx();
+
 	arch_priv = mon_event_all[QOS_L3_OCCUP_EVENT_ID].arch_priv;
 	arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, QOS_L3_OCCUP_EVENT_ID);
 	if (IS_ERR(arch_mon_ctx)) {
@@ -156,8 +170,8 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	 * RMID and move it to the free list when the counter reaches 0.
 	 */
 	for (;;) {
-		idx = find_next_bit(d->rmid_busy_llc, idx_limit, cur_idx);
-		if (idx >= idx_limit)
+		idx = find_next_bit(d->rmid_busy_llc, max_idx_limit, cur_idx);
+		if (idx >= max_idx_limit)
 			break;
 
 		entry = __rmid_entry(idx);
@@ -192,9 +206,9 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_idx_limit = resctrl_arch_system_max_rmid_idx();
 
-	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
+	return find_first_bit(d->rmid_busy_llc, max_idx_limit) != max_idx_limit;
 }
 
 static struct rmid_entry *resctrl_find_free_rmid(u32 closid)
@@ -907,8 +921,8 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 
 int setup_rmid_lru_list(void)
 {
+	u32 max_idx_limit, min_idx_limit;
 	struct rmid_entry *entry = NULL;
-	u32 idx_limit;
 	u32 idx;
 	int i;
 
@@ -916,27 +930,29 @@ int setup_rmid_lru_list(void)
 		return 0;
 
 	/*
-	 * Called on every mount, but the number of RMIDs cannot change
-	 * after the first mount, so keep using the same set of rmid_ptrs[]
-	 * until resctrl_exit(). Note that the limbo handler continues to
-	 * access rmid_ptrs[] after resctrl is unmounted.
+	 * Allocate the largest number of RMIDs that this system will ever
+	 * need. These cannot be freed until resctrl_exit() because the limbo
+	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
 	 */
-	if (rmid_ptrs)
-		return 0;
-
-	idx_limit = resctrl_arch_system_num_rmid_idx();
-	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
-	if (!rmid_ptrs)
-		return -ENOMEM;
+	if (!rmid_ptrs) {
+		max_idx_limit = resctrl_arch_system_max_rmid_idx();
+		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
+		if (!rmid_ptrs)
+			return -ENOMEM;
 
-	for (i = 0; i < idx_limit; i++) {
-		entry = &rmid_ptrs[i];
-		INIT_LIST_HEAD(&entry->list);
+		for (i = 0; i < max_idx_limit; i++) {
+			entry = &rmid_ptrs[i];
+			INIT_LIST_HEAD(&entry->list);
 
-		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
-		list_add_tail(&entry->list, &rmid_free_lru);
+			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
+		}
 	}
 
+	/* Find how many RMIDs are needed for this mount */
+	min_idx_limit = resctrl_arch_system_num_rmid_idx();
+
+	INIT_LIST_HEAD(&rmid_free_lru);
+
 	/*
 	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
 	 * are always allocated. These are used for the rdtgroup_default
@@ -944,8 +960,14 @@ int setup_rmid_lru_list(void)
 	 */
 	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
 					   RESCTRL_RESERVED_RMID);
-	entry = __rmid_entry(idx);
-	list_del(&entry->list);
+
+	for (i = 0; i < min_idx_limit; i++) {
+		entry = &rmid_ptrs[i];
+		/* Don't add reserved or busy entries to free list */
+		if (i == idx || entry->busy)
+			continue;
+		list_add_tail(&entry->list, &rmid_free_lru);
+	}
 
 	return 0;
 }
@@ -1159,7 +1181,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_idx_limit = resctrl_arch_system_max_rmid_idx();
 	enum resctrl_event_id evt;
 	int idx;
 
@@ -1167,7 +1189,7 @@ static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_dom
 		if (!resctrl_is_mon_event_enabled(evt))
 			continue;
 		idx = MBM_STATE_IDX(evt);
-		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * idx_limit);
+		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * max_idx_limit);
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c671644f1e12..ee948787f9db 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4417,13 +4417,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_idx_limit = resctrl_arch_system_max_rmid_idx();
 	size_t tsize = sizeof(*d->mbm_states[0]);
 	enum resctrl_event_id eventid;
 	int idx;
 
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
-		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
+		d->rmid_busy_llc = bitmap_zalloc(max_idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
@@ -4432,7 +4432,7 @@ static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_d
 		if (!resctrl_is_mon_event_enabled(eventid))
 			continue;
 		idx = MBM_STATE_IDX(eventid);
-		d->mbm_states[idx] = kcalloc(idx_limit, tsize, GFP_KERNEL);
+		d->mbm_states[idx] = kcalloc(max_idx_limit, tsize, GFP_KERNEL);
 		if (!d->mbm_states[idx])
 			goto cleanup;
 	}
-- 
2.54.0

