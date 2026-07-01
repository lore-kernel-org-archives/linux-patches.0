Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B8C3BADB5
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941767; cv=none; b=QbjQCeXGhc7gK0NVI6TQpLGFh0eLP0b/rB3fQXarOoA1WDgoipUnltqylT1lEzxWXwhHghnCEw0ZwZ4ihymm2aY+irwy80lGXrvfwsyiIzJ7hLZ3vfJyFPsOOQReF+6Bv1RLlUVkmNEQ/aZZySnX3YhAKTAUhgaw8P8jaODkGrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941767; c=relaxed/simple;
	bh=05CkqEWJh0F/l4VEPl8JFEV0weJHVjQHEApHBgJ4jyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFRIW8u/Xu3NfBotWjwSiM0WlOyiKJPtl/wbxPLIroDyteCQUE717a1rC+xTXeTo6IDqAQe0JcTTrQbcDikhbRUAuWK1KuRAAMNmM/mTJqnVpBARo4CgHtFUBg55Sb/dasnIgTfgJxVEt1+YHsV2vG0DLzfbH+BEty37thtN0Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iOTs3lFA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iOTs3lFA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941766; x=1814477766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=05CkqEWJh0F/l4VEPl8JFEV0weJHVjQHEApHBgJ4jyM=;
  b=iOTs3lFAQwGpVgmH3Lel0RGJsRX3ZUA+ICUgBZtXOX6vnj2RkAg+wxUU
   cgiDQNMp6T+xJIhMRM2rWtC34ZrgF29liovJwBR0ODB33LPHxaZGoSkFS
   JQxuricbX6ZcxeQKBWCbACuoWuymj22SXIKzpf0HZkbo4iMWjrpH+hhON
   CuiicA5MkqXP61pLqE+w8UbhLOKhWv9io7LKMLFJZNtJENw9XDXU9d05F
   JWAbvLaMF/Me/lN2Bhs+dwFpihsSMH5U6hzPABnqsntMzGMhy1MRvJ50L
   yKyw/DaxbqlCHSp1RvtEC8aMahNyKNwQZ3hWYepxH4So5HLJWhyAUc9EA
   A==;
X-CSE-ConnectionGUID: hsS0snoFSViX7IBN9Ip20w==
X-CSE-MsgGUID: /d2hlh24QGeD0x14N2L5bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285796"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285796"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:04 -0700
X-CSE-ConnectionGUID: vWe3UErFRUaaDkVXkGS/iw==
X-CSE-MsgGUID: oUEQoq0PTz6U4Dun9btxgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242535"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:03 -0700
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
Subject: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount
Date: Wed,  1 Jul 2026 14:35:47 -0700
Message-ID: <20260701213553.15222-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
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
 include/linux/resctrl.h            |  5 +-
 arch/x86/kernel/cpu/resctrl/core.c | 14 ++++++
 drivers/resctrl/mpam_resctrl.c     |  5 ++
 fs/resctrl/monitor.c               | 76 +++++++++++++++++++-----------
 fs/resctrl/rdtgroup.c              |  6 +--
 5 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index a184500745f8..e1501ee72d28 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -183,10 +183,12 @@ struct mbm_cntr_cfg {
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
@@ -417,6 +419,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 /* The number of closid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
+u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 60d50ac79e7b..3169441a2d40 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -144,6 +144,20 @@ u32 resctrl_arch_system_num_rmid_idx(void)
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
index 5d5625e4e3b4..72b1a628488c 100644
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
 	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
 	void *arch_mon_ctx;
+	u32 max_idx_limit;
 	void *arch_priv;
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
@@ -197,9 +211,9 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_idx_limit = resctrl_arch_system_max_rmid_idx();
 
-	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
+	return find_first_bit(d->rmid_busy_llc, max_idx_limit) != max_idx_limit;
 }
 
 static struct rmid_entry *resctrl_find_free_rmid(u32 closid)
@@ -961,8 +975,8 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 
 int setup_rmid_lru_list(void)
 {
+	u32 max_idx_limit, min_idx_limit;
 	struct rmid_entry *entry = NULL;
-	u32 idx_limit;
 	u32 idx;
 	int i;
 
@@ -970,27 +984,29 @@ int setup_rmid_lru_list(void)
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
@@ -998,8 +1014,14 @@ int setup_rmid_lru_list(void)
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
@@ -1218,7 +1240,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_idx_limit = resctrl_arch_system_max_rmid_idx();
 	enum resctrl_event_id evt;
 	int idx;
 
@@ -1226,7 +1248,7 @@ static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_dom
 		if (!resctrl_is_mon_event_enabled(evt))
 			continue;
 		idx = MBM_STATE_IDX(evt);
-		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * idx_limit);
+		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * max_idx_limit);
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ac1a5af00bc5..763e4191d717 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4623,13 +4623,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
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
@@ -4638,7 +4638,7 @@ static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_d
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

