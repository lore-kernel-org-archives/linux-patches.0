Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF02502D6A
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633747; cv=none; b=ZymMvfQhqcOpp9VbXQoOubUH/mPvph4ub7Ak2mebcC7I4dzUxCsDgbs0AqsK3A3r2QZOVVemO/E7uAwQ+hvaeDsbP1RwZRsVfQ0NZmzASgK3vy9jvjFTFTIvQcbQ9EsWsIsYD/BFbR2HRFcf2tsD2ALAVoiDaPpx21dEjpBtKI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633747; c=relaxed/simple;
	bh=2J8iTrNKSvv/HRjweSzaESZc1PTX3stgtE1N3YGBWB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0W0via3Ro0s7FBT3Kxo8lD8C7nBE7/2Qv73wlroPLq1sn8sEOBzydZtWAKIsuliG/qbVaPWa6D383IZP67h2DAcTg8BRceNP6wM6F3daYNu1voHwr6pbHB5HFc3dDE3YEyJjxIj+/ixU4PmKcaaAiIvDTBp7GJ66I4CbTleifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mjhKS7WL; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mjhKS7WL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633738; x=1822169738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2J8iTrNKSvv/HRjweSzaESZc1PTX3stgtE1N3YGBWB4=;
  b=mjhKS7WLg+UfJyYreaukchxaEm/Qk8HhuuNS0rdqsKb/1JEKiy4LKY9I
   0+gL+iELIZyD7reaGuX52kuOVMOv7MahvTSum4GTmHUubBZSum0GOGnKn
   2JsTyOjA1dg7lE6OCtYe+HupPQb5npiOsIj6MEfp3d3UK4BPtb+y414mv
   amKxzRcVZNUndFroqG2zgit3zody8WymOsT3Na01X+DlaWWeSUMLxFM6V
   rbvOhVKbNdT5wMHybz4F89dxmfUi9bCkSBmzq3gewDNVNgVia63e98Aqf
   IEVVyBoLQNSVeJke3ouH+42zsc/uH0/Ftu7/vLi6fTcUFJQjSIfgq5YEk
   A==;
X-CSE-ConnectionGUID: 1yE+8Tt4RRu728/hLf2+Rw==
X-CSE-MsgGUID: 3O4nrOI2SpuzmqJzyy9FLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387274"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387274"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
X-CSE-ConnectionGUID: jCHpcthUQ26++n19LyXt2g==
X-CSE-MsgGUID: DPtR66M7RvikXGUOn3NC2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685509"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:18 -0700
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
Subject: [PATCH v13 14/25] arm,x86,fs/resctrl: Use right size for L3 monitor data structures
Date: Mon, 28 Sep 2026 15:14:58 -0700
Message-ID: <20260928221509.68002-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The number of RMIDs available for use is computed as the minimum value across
all enabled monitoring resources. This value does not currently change from
one mount to the next. But when changes are made to allow configuration
of the pmt_telemetry driver as a module the Application Energy Telemetry
events will only be enabled if the module is loaded at the point when the
file system is mounted. This may result in the available number of RMIDs
changing from one mount to the next.

The RDT_RESOURCE_L3 allocates some data structures sized by the
number of RMIDs:
* rdt_l3_mon_domain::rmid_busy_llc is a bitmap tracking which RMIDs
  have active L3 cache occupancy counts.
* rdt_l3_mon_domain::mbm_states[] tracks memory bandwidth for the
  "mba_MBps" software controller.
* rdt_hw_l3_mon_domain::arch_mbm_states[] keeps total count of memory
  traffic (handling overflow of hardware counters).

These structures must be allocated and manipulated based on the number
of RMIDs supported by the L3 (this will not change from mount to mount).

The limbo code must be prepared to deal with changes in the number of RMIDs
from one mount to the next because some RMIDs may still be "busy" when the
file system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
for the remount. In this case RMIDs that can be released are not put onto
the rmid_free_lru list.

Use the L3 rdt_resource::mon.num_rmid to allocate and operate on these
data structures.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Drop rename of local "idx_limit" to "l3_idx_limit"
	Re-wrote commit message.
---
 include/linux/resctrl.h            |  7 +++++--
 arch/x86/kernel/cpu/resctrl/core.c |  5 +++++
 drivers/resctrl/mpam_resctrl.c     |  5 +++++
 fs/resctrl/monitor.c               | 22 ++++++++++++++++++----
 fs/resctrl/rdtgroup.c              |  2 +-
 5 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 7afeb3bd55d9..c77e24c0d8b6 100644
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
@@ -444,8 +446,9 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 	return WARN_ON_ONCE(1);
 }
 
-/* The number of closid supported by this resource regardless of CDP */
+/* The number of closid/rmid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8702a6da2374..b32fa143283e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -380,6 +380,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r)
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
index 52726f7fd03f..360a50eb0cd3 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -252,6 +252,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
 	return mpam_partid_max + 1;
 }
 
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *ignored)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
 	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index ccfb1548fea1..1d55f138e2f6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -120,10 +120,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
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
@@ -138,7 +146,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
 void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	struct rmid_entry *entry;
 	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
@@ -159,6 +167,11 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	 * are marked as busy for occupancy < threshold. If the occupancy
 	 * is less than the threshold decrement the busy counter of the
 	 * RMID and move it to the free list when the counter reaches 0.
+	 *
+	 * RMIDs will keep counts of allocated LLC entries after the resctrl
+	 * file system is unmounted. So check all possible RMIDs since a
+	 * previous mount cycle may have used more than are available in
+	 * this mount cycle.
 	 */
 	for (;;) {
 		idx = find_next_bit(d->rmid_busy_llc, idx_limit, cur_idx);
@@ -202,7 +215,8 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 
 	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
 }
@@ -1238,7 +1252,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	enum resctrl_event_id evt;
 	int idx;
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 7cf809380c53..79d4ddc3d64d 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4619,7 +4619,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	size_t tsize = sizeof(*d->mbm_states[0]);
 	enum resctrl_event_id eventid;
 	int idx;
-- 
2.55.0

