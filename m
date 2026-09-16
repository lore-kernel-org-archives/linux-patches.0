Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14004CA29A
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600427; cv=none; b=KTTwRgIgpsgIP7r8qDRvhmjftzMeSc1QL+EBOYTnLAylawNNm9JyCcggseJkUsbNmEEDNd8rZIyeysrMHPyPFsIUEBLnRkoiLp1ZqfIyks/fMbf5MSBi6Oaj6Hr+XGskW2yQk3/tMjF3rNg13+NqPLLeQtI6Z9kNgAwf/OPBDBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600427; c=relaxed/simple;
	bh=KxCx9yvhbpPkEYYZZKaBnBcf2ZVpf2zfr18lvf/o/qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqbXgt2MfQObZ8ru0pcBwE393xcoUjjmkfTJQTWqi9pfpE3+6CltqbLx/Hjvv3Tgs5nO2f6p/IfIy2oSUN3o4XX22k+lKwut50RNNcCDEy86q6aivMwMy/KYI3aB2LaZ6+NFd1WVqEZYWdzoS6EQFe15pV+NINSAKUxQNOC28Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzPs5Gbb; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzPs5Gbb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600424; x=1821136424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KxCx9yvhbpPkEYYZZKaBnBcf2ZVpf2zfr18lvf/o/qE=;
  b=UzPs5Gbb8NjJfJfi8G+Z5vuXvulzF7CuaYrUZTNwyEiFbY6dy3OsCcNT
   veYfEhAcsepbny69kiTVNklH/PNk7fhP+nnewSYhC1bvyRHEfrvAzYvft
   3RnAW+xZAT0jhUSaTVU7tjqtFsqwZjSdl5ZSqn8OIX9OsfBey1axnBjkp
   52t52LE1UFTINiUSX8GsF2EQmGXRSZFpCZyc40kcPJwV78tBncmnyF1sg
   EsSadT4wPsyjt8KGMDacd8KXmeUE8lIPG9bZBHjRXmtzNecmFeBGr6Nfj
   Knv879iDhTAqm9TWtgu+rSjcnznwl1ZMXsIEHJODGMu2VSbz1OB7yThYD
   w==;
X-CSE-ConnectionGUID: z5GDqjNcTeyIT9MJwMTYqw==
X-CSE-MsgGUID: zcYh9xocRKOSkinszbzxaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861434"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861434"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:36 -0700
X-CSE-ConnectionGUID: /6FQ/PLlT8mxSk45Zger7g==
X-CSE-MsgGUID: x/cTe8LjTF2zkyyUbE3fsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231468"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:36 -0700
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
Subject: [PATCH v12 13/25] arm,x86,fs/resctrl: Allocate right size for L3 monitor arrays
Date: Wed, 16 Sep 2026 16:13:08 -0700
Message-ID: <20260916231320.14502-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The number of RMIDs available may change from one mount to the next.
The sizes of the rdt_l3_mon_domain::rmid_busy_llc bitmap and the
rdt_l3_mon_domain::mbm_states array always depend on the number of
RMIDs supported by RDT_RESOURCE_L3.

Add resctrl_arch_get_num_rmid_idx(r) to report the maximum RMID index
for a resource. Use it to allocate the rdt_l3_mon_domain::rmid_busy_llc
bitmap and rdt_l3_mon_domain::mbm_states[] and when operating on these
structures.

The limbo code must deal with changes in the number of RMIDs from one
mount to the next because some RMIDs may still be "busy" when the file
system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
for the remount. In this case RMIDs that can be released are not put
onto the rmid_free_lru list.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	New patch. Split from patch 12.
---
 include/linux/resctrl.h            |  7 +++++--
 arch/x86/kernel/cpu/resctrl/core.c |  5 +++++
 drivers/resctrl/mpam_resctrl.c     |  5 +++++
 fs/resctrl/monitor.c               | 30 ++++++++++++++++++++++--------
 fs/resctrl/rdtgroup.c              |  6 +++---
 5 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 5535bde7b925..604ab7af7c2b 100644
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
index a9109f2bc43e..e633da548959 100644
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
index 0ffa25199f74..69c9e02d2f40 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -247,6 +247,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
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
index e8775e08aa18..b8bd59c52c62 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -115,10 +115,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
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
@@ -133,7 +141,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
 void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	struct rmid_entry *entry;
 	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
@@ -154,10 +162,15 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
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
-		idx = find_next_bit(d->rmid_busy_llc, idx_limit, cur_idx);
-		if (idx >= idx_limit)
+		idx = find_next_bit(d->rmid_busy_llc, l3_idx_limit, cur_idx);
+		if (idx >= l3_idx_limit)
 			break;
 
 		entry = __rmid_entry(idx);
@@ -197,9 +210,10 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	u32 l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 
-	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
+	return find_first_bit(d->rmid_busy_llc, l3_idx_limit) != l3_idx_limit;
 }
 
 static struct rmid_entry *resctrl_find_free_rmid(u32 closid)
@@ -1218,7 +1232,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	enum resctrl_event_id evt;
 	int idx;
 
@@ -1226,7 +1240,7 @@ static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_dom
 		if (!resctrl_is_mon_event_enabled(evt))
 			continue;
 		idx = MBM_STATE_IDX(evt);
-		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * idx_limit);
+		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * l3_idx_limit);
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c0b86ce05e50..0c9c29037667 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4621,13 +4621,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 l3_idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	size_t tsize = sizeof(*d->mbm_states[0]);
 	enum resctrl_event_id eventid;
 	int idx;
 
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
-		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
+		d->rmid_busy_llc = bitmap_zalloc(l3_idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
@@ -4636,7 +4636,7 @@ static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_d
 		if (!resctrl_is_mon_event_enabled(eventid))
 			continue;
 		idx = MBM_STATE_IDX(eventid);
-		d->mbm_states[idx] = kcalloc(idx_limit, tsize, GFP_KERNEL);
+		d->mbm_states[idx] = kcalloc(l3_idx_limit, tsize, GFP_KERNEL);
 		if (!d->mbm_states[idx])
 			goto cleanup;
 	}
-- 
2.55.0

