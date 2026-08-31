Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E636547D47C
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198284; cv=none; b=u8RNaK4T9gtGXnqD17+cRr6XRkvwfGZ9eqyWMnYqtF/OhVdo/BZlQ5YtHXS5fMPRzTuoXCgRz0EYkUV8tuuJ6dQdKCOrr5JioKxLMhPALDCCGvrDaH/BHQKLhW3ZJJz8BJK+111XuCL5x4Vbewyq8Hv/VP1mYBCPh52rK8RozQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198284; c=relaxed/simple;
	bh=8Zk5veoV/sFAI0g0E7DIq3/UeJhkZVFCN70qs0ppwok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAjqQgWHSHIfrYK0gqaN50Uo822QURrdqwY6vY1EF/K8fuU3LqNhqswqTTvwOLuUGEhUF30tKyw15d7GIxfkT6byUjUy+4S6EjzyqQdwvuOsoiIkP6MTy7Lmyq5e8OnsDF+B0UreoZ1RStV4dKJ/l+aFGVw2BB2NwJRml5twY54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHAOKjbV; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHAOKjbV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198282; x=1819734282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Zk5veoV/sFAI0g0E7DIq3/UeJhkZVFCN70qs0ppwok=;
  b=gHAOKjbVKRbEOSa87GGQ1/bSk3RNawrVBhg8rei/3sY9JVMKikHUd93S
   /ZRstonCLLqZURuAzK6qVF4KdGHjfVDHWkVYhidQXobrFHNGdWwXNiBgF
   HOAAxuaAsCfQUkd+N5nwBYN+ee+UJpXYcgc9szcGTWKa7kVRAsZQKAoXy
   TT7yIrWmxquo6zn6jDKZDNkQaFXb+HNRqFiyIkrn18CC0tgnIdFn676ow
   j0+J6r24ynbKsPeaittI0KzUC+VXIMpEyicUxBQ62VPiFjuXseOwEsgvf
   CKp0nPXA7SR96QS/T1KmcKXbl2mCccGB/p9qb0w0rMMOUjcy//g05XQYp
   w==;
X-CSE-ConnectionGUID: 3n0OscLzQ52nrM+iGmnFvQ==
X-CSE-MsgGUID: 2Xz0FPteSqO0w40eeNy7KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480026"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480026"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:38 -0700
X-CSE-ConnectionGUID: FEbH2Js3S22MPI4drjEZsw==
X-CSE-MsgGUID: Ni6n5zOhSsm4s9yZYNleWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906989"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:37 -0700
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
Subject: [PATCH v11 12/23] arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount
Date: Mon, 31 Aug 2026 10:44:10 -0700
Message-ID: <20260831174421.13921-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
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
that value to allocate the rmid_ptrs[] array just once. Use this same
calculated value for all references to rmid_ptrs[] instead of calling
resctrl_arch_system_max_rmid_idx() in multiple places.

Add resctrl_arch_get_num_rmid_idx(r) to report the maximum RMID index
for a resource. Use it to allocate the rdt_l3_mon_domain::rmid_busy_llc
bitmap and rdt_l3_mon_domain::mbm_states and when operating on these
structures.

The limbo code must deal with changes in the number of RMIDs from one
mount to the next because some RMIDs may still be "busy" when the file
system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
for the remount. In this case RMIDs that can be released are not put
onto the rmid_free_lru list.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Add resctrl_arch_get_num_rmid_idx(r) and use it for allocating
	an operating on L3 per-domain dynamically allocated structures.
	Update kernel doc comment for max_idx_limit.
	Update comment to explain why all RMIDs need to be checked
	for LLC cache occupancy.

 include/linux/resctrl.h            |  8 ++-
 arch/x86/kernel/cpu/resctrl/core.c | 30 +++++++++++
 drivers/resctrl/mpam_resctrl.c     | 14 +++++
 fs/resctrl/monitor.c               | 87 +++++++++++++++++++++---------
 fs/resctrl/rdtgroup.c              |  6 +--
 5 files changed, 114 insertions(+), 31 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index e9094d886ba7..4fb06d434c85 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -183,10 +183,12 @@ struct mbm_cntr_cfg {
  * struct rdt_l3_mon_domain - group of CPUs sharing RDT_RESOURCE_L3 monitoring
  * @hdr:		common header for different domain types
  * @ci_id:		cache info id for this domain
- * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
+ * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold. Sized for
+ *			maximum supported RMIDs in L3 resource.
  * @mbm_states:		Per-event pointer to the MBM event's saved state.
  *			An MBM event's state is an array of struct mbm_state
  *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
+ *			Sized same as @rmid_busy_llc.
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -440,9 +442,11 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 	return WARN_ON_ONCE(1);
 }
 
-/* The number of closid supported by this resource regardless of CDP */
+/* The number of closid/rmid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
+u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index e851da431dd9..ef37fbb586d3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -124,6 +124,31 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
+/**
+ * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
+ *
+ * Return: Maximum possible number of RMIDs used for boot time allocations.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 ret;
+
+	/* CPUID enumerates maximum value that can be written to IA32_PQR_ASSOC.RMID */
+	ret = cpuid_ebx(0xf) + 1;
+
+	/*
+	 * If the system is capable of L3 monitoring the maximum RMID value may
+	 * be lower than the system maximum. Either because the L3 monitoring
+	 * feature supports fewer RMIDs, or because SNC (Sub-NUMA Cluster)
+	 * is enabled and divides RMIDs per cluster.
+	 */
+	if (r->mon_capable)
+		ret = r->mon.num_rmid;
+
+	return ret;
+}
+
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
 	if (l >= RDT_NUM_RESOURCES)
@@ -360,6 +385,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r)
 	return resctrl_to_arch_res(r)->num_closid;
 }
 
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r)
+{
+	return r->mon.num_rmid;
+}
+
 void rdt_ctrl_update(void *arg)
 {
 	struct rdt_hw_resource *hw_res;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 0db62dd2a71c..a117aa98ae90 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -247,11 +247,25 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
 	return mpam_partid_max + 1;
 }
 
+/*
+ * File system calls this for one-time allocation of structures
+ * during initialization. Return the largest possible value.
+ */
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *ignored)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
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
index 2a28fe04284b..5340c764bf7f 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
  */
 static struct rmid_entry	*rmid_ptrs;
 
+/*
+ * @max_idx_limit - The number of elements in rmid_ptrs[].
+ */
+static u32 max_idx_limit;
+
 /*
  * This is the threshold cache occupancy in bytes at which we will consider an
  * RMID available for re-allocation.
@@ -115,10 +120,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
 static void limbo_release_entry(struct rmid_entry *entry)
 {
+	u32 cur_idx_limit = resctrl_arch_system_num_rmid_idx();
+
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	rmid_limbo_count--;
-	list_add_tail(&entry->list, &rmid_free_lru);
+
+	/*
+	 * Limbo may be freeing an RMID from a previous mount where there
+	 * were more RMIDs available.
+	 */
+	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < cur_idx_limit)
+		list_add_tail(&entry->list, &rmid_free_lru);
 
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
 		closid_num_dirty_rmid[entry->closid]--;
@@ -133,7 +146,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
 void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	struct rmid_entry *entry;
 	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
@@ -156,8 +169,14 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	 * RMID and move it to the free list when the counter reaches 0.
 	 */
 	for (;;) {
-		idx = find_next_bit(d->rmid_busy_llc, idx_limit, cur_idx);
-		if (idx >= idx_limit)
+		/*
+		 * RMIDs will keep counts of allocated LLC entries after the
+		 * resctrl file system is unmounted. So check all possible
+		 * RMIDs since a previous mount cycle may have used more
+		 * than are available in this mount cycle.
+		 */
+		idx = find_next_bit(d->rmid_busy_llc, max_l3_idx_limit, cur_idx);
+		if (idx >= max_l3_idx_limit)
 			break;
 
 		entry = __rmid_entry(idx);
@@ -197,9 +216,10 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	u32 max_l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 
-	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
+	return find_first_bit(d->rmid_busy_llc, max_l3_idx_limit) != max_l3_idx_limit;
 }
 
 static struct rmid_entry *resctrl_find_free_rmid(u32 closid)
@@ -962,7 +982,7 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 int setup_rmid_lru_list(void)
 {
 	struct rmid_entry *entry = NULL;
-	u32 idx_limit;
+	u32 cur_idx_limit;
 	u32 idx;
 	int i;
 
@@ -970,27 +990,36 @@ int setup_rmid_lru_list(void)
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
+	if (!rmid_ptrs) {
+		max_idx_limit = resctrl_arch_system_max_rmid_idx();
+		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
+		if (!rmid_ptrs) {
+			max_idx_limit = 0;
+			return -ENOMEM;
+		}
 
-	idx_limit = resctrl_arch_system_num_rmid_idx();
-	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
-	if (!rmid_ptrs)
-		return -ENOMEM;
+		for (i = 0; i < max_idx_limit; i++) {
+			entry = &rmid_ptrs[i];
+			INIT_LIST_HEAD(&entry->list);
 
-	for (i = 0; i < idx_limit; i++) {
-		entry = &rmid_ptrs[i];
-		INIT_LIST_HEAD(&entry->list);
+			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
+		}
+	}
 
-		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
-		list_add_tail(&entry->list, &rmid_free_lru);
+	/* Find how many RMIDs are needed for this mount */
+	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
+	if (cur_idx_limit > max_idx_limit) {
+		pr_warn_once("RMID count %u exceeds allocated %u; capping\n",
+			     cur_idx_limit, max_idx_limit);
+		cur_idx_limit = max_idx_limit;
 	}
 
+	INIT_LIST_HEAD(&rmid_free_lru);
+
 	/*
 	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
 	 * are always allocated. These are used for the rdtgroup_default
@@ -998,8 +1027,14 @@ int setup_rmid_lru_list(void)
 	 */
 	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
 					   RESCTRL_RESERVED_RMID);
-	entry = __rmid_entry(idx);
-	list_del(&entry->list);
+
+	for (i = 0; i < cur_idx_limit; i++) {
+		entry = &rmid_ptrs[i];
+		/* Don't add reserved or busy entries to free list */
+		if (i == idx || entry->busy)
+			continue;
+		list_add_tail(&entry->list, &rmid_free_lru);
+	}
 
 	return 0;
 }
@@ -1218,7 +1253,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	enum resctrl_event_id evt;
 	int idx;
 
@@ -1226,7 +1261,7 @@ static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_dom
 		if (!resctrl_is_mon_event_enabled(evt))
 			continue;
 		idx = MBM_STATE_IDX(evt);
-		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * idx_limit);
+		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * max_l3_idx_limit);
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 4f8a510be8ec..de07ccdffdb2 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4621,13 +4621,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 max_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	size_t tsize = sizeof(*d->mbm_states[0]);
 	enum resctrl_event_id eventid;
 	int idx;
 
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
-		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
+		d->rmid_busy_llc = bitmap_zalloc(max_idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
@@ -4636,7 +4636,7 @@ static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_d
 		if (!resctrl_is_mon_event_enabled(eventid))
 			continue;
 		idx = MBM_STATE_IDX(eventid);
-		d->mbm_states[idx] = kcalloc(idx_limit, tsize, GFP_KERNEL);
+		d->mbm_states[idx] = kcalloc(max_idx_limit, tsize, GFP_KERNEL);
 		if (!d->mbm_states[idx])
 			goto cleanup;
 	}
-- 
2.55.0

