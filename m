Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00DD24E4A8
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496043; cv=none; b=qMaFHDLDShXsh7+HDR7mBXtSCNLu5vQf5hV6EgLkBGWCOvpwm28A0+LHWODlVhAupT+rmogdxhmyrHsbTOIHnaqqm93DggZXs69VI8Hn6v5jpxBowXfJytv7xbgQMmX/ma0OHSYGA1cdCFkzXzBE3vdMipqCMP+rpm+KAOitoA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496043; c=relaxed/simple;
	bh=iNScpOgCpcncPEkK4F1vN/qtCWME/BMoIvfqM2E9s1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzV3F0FR1Hg390BnvsqAq5CuueHVStJiurVTydl+MZP8CMF/pRcuIwrc5bqgeNjdL1u9BA1rOxAcf9A3mAKBD1b5NHEkOdwk/PvYEUpgre65YbXYZWQvv3IGd7LlOnefaKMkk6GdCa1LvvLHi2ydEXs9g5IEgp4fMY+LUy7cWZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ia+O2qog; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ia+O2qog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496040; x=1788032040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iNScpOgCpcncPEkK4F1vN/qtCWME/BMoIvfqM2E9s1A=;
  b=ia+O2qogpS+o3zyVe9NVQWHhlM94/aOkzW3t69uT+DmD0DFx9HX6tX/p
   E+kHW9gTJBkkhSDPcuWH/jrNIPmhhLcB4Wdha8P1nzQBoQ4iTNsujv4j2
   ibkWIeHT8KGlO8Zht++CfFbpG3v/GJiKCntYC2NzLTN27lQO3MqU7r2Eg
   uXQ5kK6L0dlgY7JhJzCrkpoQnaoZb3B8rXo3nNDTZOHiOJYnmfXVlCAje
   ZbBjlopXQV+fTQvAwpYAkhdU+UOU5METCp1MUN6flaWCUch8rcldboNga
   txWr6/0wgaF9eiMzQn3qyYAYYPLAB3jGW3cyX+UBMySK2D5nKa716aQOg
   Q==;
X-CSE-ConnectionGUID: H3TqSs8FS/KJPefSyAEwyg==
X-CSE-MsgGUID: lNTNfapPTvmASOcyj+uFcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625226"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625226"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:54 -0700
X-CSE-ConnectionGUID: 6aMAKaFrQ7mKrT+mdeRfXg==
X-CSE-MsgGUID: t/VUPnm4SUqRAAFd0pDn+w==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:54 -0700
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
Subject: [PATCH v9 10/31] x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
Date: Fri, 29 Aug 2025 12:33:22 -0700
Message-ID: <20250829193346.31565-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All monitoring events are associated with the L3 resource.  The per L3
domain resctrl fs monitoring state is maintained in the generically
named struct rdt_mon_domain while the per L3 domain architecture
specific monitoring state is maintained in the generically named struct
rdt_hw_mon_domain.

Upcoming telemetry event monitoring will be tied to another resource
and requires new domain structures.

Rename the L3 resource specific domain data structures to include
"l3_" in their names to avoid confusion between the different
resource specific domain structures:
rdt_mon_domain		-> rdt_l3_mon_domain
rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 16 ++++++------
 arch/x86/kernel/cpu/resctrl/internal.h | 16 ++++++------
 fs/resctrl/internal.h                  |  8 +++---
 arch/x86/kernel/cpu/resctrl/core.c     | 14 +++++-----
 arch/x86/kernel/cpu/resctrl/monitor.c  | 20 +++++++-------
 fs/resctrl/ctrlmondata.c               |  2 +-
 fs/resctrl/monitor.c                   | 34 ++++++++++++------------
 fs/resctrl/rdtgroup.c                  | 36 +++++++++++++-------------
 8 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c8200626b91a..5788e1970d8c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -166,7 +166,7 @@ struct rdt_ctrl_domain {
 };
 
 /**
- * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
+ * struct rdt_l3_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
  * @ci_id:		cache info id for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
@@ -178,7 +178,7 @@ struct rdt_ctrl_domain {
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
  * @cqm_work_cpu:	worker CPU for CQM h/w counters
  */
-struct rdt_mon_domain {
+struct rdt_l3_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	unsigned int			ci_id;
 	unsigned long			*rmid_busy_llc;
@@ -334,10 +334,10 @@ struct resctrl_cpu_defaults {
 };
 
 struct resctrl_mon_config_info {
-	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
-	u32			evtid;
-	u32			mon_config;
+	struct rdt_resource		*r;
+	struct rdt_l3_mon_domain	*d;
+	u32				evtid;
+	u32				mon_config;
 };
 
 /**
@@ -530,7 +530,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 closid, u32 rmid,
 			     enum resctrl_event_id eventid);
 
@@ -543,7 +543,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d);
+void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /**
  * resctrl_arch_reset_all_ctrls() - Reset the control for each CLOSID to its
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 58dca892a5df..684a1b830ced 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -51,17 +51,17 @@ struct rdt_hw_ctrl_domain {
 };
 
 /**
- * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
- *			      a resource for a monitor function
- * @d_resctrl:	Properties exposed to the resctrl file system
+ * struct rdt_hw_l3_mon_domain - Arch private attributes of a set of CPUs that share
+ *				 a resource for a monitor function
+ * @d_resctrl:		Properties exposed to the resctrl file system
  * @arch_mbm_states:	Per-event pointer to the MBM event's saved state.
  *			An MBM event's state is an array of struct arch_mbm_state
  *			indexed by RMID on x86.
  *
  * Members of this structure are accessed via helpers that provide abstraction.
  */
-struct rdt_hw_mon_domain {
-	struct rdt_mon_domain		d_resctrl;
+struct rdt_hw_l3_mon_domain {
+	struct rdt_l3_mon_domain	d_resctrl;
 	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_L3_MBM_EVENTS];
 };
 
@@ -70,9 +70,9 @@ static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctr
 	return container_of(r, struct rdt_hw_ctrl_domain, d_resctrl);
 }
 
-static inline struct rdt_hw_mon_domain *resctrl_to_arch_mon_dom(struct rdt_mon_domain *r)
+static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3_mon_domain *r)
 {
-	return container_of(r, struct rdt_hw_mon_domain, d_resctrl);
+	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
 }
 
 /**
@@ -124,7 +124,7 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
 
 extern struct rdt_hw_resource rdt_resources_all[];
 
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
+void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
 union cpuid_0x10_1_eax {
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index b19e974b7865..e4f06f700063 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -357,7 +357,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 
 int resctrl_mon_resource_init(void);
 
-void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
+void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
 
@@ -365,14 +365,14 @@ void mbm_handle_overflow(struct work_struct *work);
 
 bool is_mba_sc(struct rdt_resource *r);
 
-void cqm_setup_limbo_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void cqm_setup_limbo_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 			     int exclude_cpu);
 
 void cqm_handle_limbo(struct work_struct *work);
 
-bool has_busy_rmid(struct rdt_mon_domain *d);
+bool has_busy_rmid(struct rdt_l3_mon_domain *d);
 
-void __check_limbo(struct rdt_mon_domain *d, bool force_free);
+void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free);
 
 void resctrl_file_fflags_init(const char *config, unsigned long fflags);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 43d33810163c..10b05cab77b9 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -363,7 +363,7 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 	kfree(hw_dom);
 }
 
-static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
+static void mon_domain_free(struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	int idx;
 
@@ -400,7 +400,7 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
  * @num_rmid:	The size of the MBM counter array
  * @hw_dom:	The domain that owns the allocated arrays
  */
-static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
+static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	size_t tsize = sizeof(*hw_dom->arch_mbm_states[0]);
 	enum resctrl_event_id eventid;
@@ -498,8 +498,8 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
 {
-	struct rdt_hw_mon_domain *hw_dom;
-	struct rdt_mon_domain *d;
+	struct rdt_hw_l3_mon_domain *hw_dom;
+	struct rdt_l3_mon_domain *d;
 	struct cacheinfo *ci;
 	int err;
 
@@ -626,9 +626,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct rdt_hw_mon_domain *hw_dom;
+	struct rdt_hw_l3_mon_domain *hw_dom;
+	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
-	struct rdt_mon_domain *d;
 
 	lockdep_assert_held(&domain_list_lock);
 
@@ -654,7 +654,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return;
 
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index b31794c5dcd4..5c08732871eb 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -109,7 +109,7 @@ static inline u64 get_corrected_mbm_count(u32 rmid, unsigned long val)
  *
  * In RMID sharing mode there are fewer "logical RMID" values available
  * to accumulate data ("physical RMIDs" are divided evenly between SNC
- * nodes that share an L3 cache). Linux creates an rdt_mon_domain for
+ * nodes that share an L3 cache). Linux creates an rdt_l3_mon_domain for
  * each SNC node.
  *
  * The value loaded into IA32_PQR_ASSOC is the "logical RMID".
@@ -157,7 +157,7 @@ static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
 	return 0;
 }
 
-static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_dom,
+static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_l3_mon_domain *hw_dom,
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
 {
@@ -171,11 +171,11 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
 	return state ? &state[rmid] : NULL;
 }
 
-void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 unused, u32 rmid,
 			     enum resctrl_event_id eventid)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	struct arch_mbm_state *am;
 	u32 prmid;
@@ -194,9 +194,9 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
  * Assumes that hardware counters are also reset and thus that there is
  * no need to record initial non-zero counts.
  */
-void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
+void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	enum resctrl_event_id eventid;
 	int idx;
 
@@ -222,10 +222,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u64 *val, void *ignored)
 {
 	int cpu = cpumask_any(&hdr->cpu_mask);
-	struct rdt_hw_mon_domain *hw_dom;
+	struct rdt_hw_l3_mon_domain *hw_dom;
 	struct rdt_hw_resource *hw_res;
+	struct rdt_l3_mon_domain *d;
 	struct arch_mbm_state *am;
-	struct rdt_mon_domain *d;
 	u64 msr_val, chunks;
 	u32 prmid;
 	int ret;
@@ -238,7 +238,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	hw_dom = resctrl_to_arch_mon_dom(d);
 	hw_res = resctrl_to_arch_res(r);
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
@@ -275,7 +275,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
  * must adjust RMID counter numbers based on SNC node. See
  * logical_rmid_to_physical_rmid() for code that does this.
  */
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
+void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	if (snc_nodes_per_l3_cache > 1)
 		msr_clear_bit(MSR_RMID_SNC_CONFIG, 0);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 1c1c0e7bbc11..1d7086509bfa 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -616,7 +616,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
-		struct rdt_mon_domain *d;
+		struct rdt_l3_mon_domain *d;
 
 		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
 			ret = -EIO;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 713396cbda32..8d4e3adc1fe8 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -130,7 +130,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
  * decrement the count. If the busy count gets to zero on an RMID, we
  * free the RMID
  */
-void __check_limbo(struct rdt_mon_domain *d, bool force_free)
+void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
@@ -188,7 +188,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
 	resctrl_arch_mon_ctx_free(r, QOS_L3_OCCUP_EVENT_ID, arch_mon_ctx);
 }
 
-bool has_busy_rmid(struct rdt_mon_domain *d)
+bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 
@@ -289,7 +289,7 @@ int alloc_rmid(u32 closid)
 static void add_rmid_to_limbo(struct rmid_entry *entry)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	u32 idx;
 
 	lockdep_assert_held(&rdtgroup_mutex);
@@ -342,7 +342,7 @@ void free_rmid(u32 closid, u32 rmid)
 		list_add_tail(&entry->list, &rmid_free_lru);
 }
 
-static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
+static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
 				       u32 rmid, enum resctrl_event_id evtid)
 {
 	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
@@ -359,7 +359,7 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct cacheinfo *ci;
 	struct mbm_state *m;
 	int err, ret;
@@ -368,7 +368,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	if (rr->r->rid == RDT_RESOURCE_L3 && rr->first) {
 		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
-		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+		d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
 		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
 		m = get_mbm_state(d, closid, rmid, rr->evtid);
 		if (m)
@@ -438,12 +438,12 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
 	u64 cur_bw, bytes, cur_bytes;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct mbm_state *m;
 
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
-	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
 	m = get_mbm_state(d, closid, rmid, rr->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
@@ -544,7 +544,7 @@ static struct rdt_ctrl_domain *get_ctrl_domain_from_cpu(int cpu,
  * throttle MSRs already have low percentage values.  To avoid
  * unnecessarily restricting such rdtgroups, we also increase the bandwidth.
  */
-static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
+static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_mbm)
 {
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
@@ -612,7 +612,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
 }
 
-static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
 	struct rmid_read rr = {0};
@@ -639,7 +639,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
 }
 
-static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 		       u32 closid, u32 rmid)
 {
 	/*
@@ -660,12 +660,12 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
 void cqm_handle_limbo(struct work_struct *work)
 {
 	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
-	d = container_of(work, struct rdt_mon_domain, cqm_limbo.work);
+	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
 
 	__check_limbo(d, false);
 
@@ -688,7 +688,7 @@ void cqm_handle_limbo(struct work_struct *work)
  * @exclude_cpu:   Which CPU the handler should not run on,
  *		   RESCTRL_PICK_ANY_CPU to pick any CPU.
  */
-void cqm_setup_limbo_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void cqm_setup_limbo_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 			     int exclude_cpu)
 {
 	unsigned long delay = msecs_to_jiffies(delay_ms);
@@ -705,7 +705,7 @@ void mbm_handle_overflow(struct work_struct *work)
 {
 	unsigned long delay = msecs_to_jiffies(MBM_OVERFLOW_INTERVAL);
 	struct rdtgroup *prgrp, *crgrp;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct list_head *head;
 	struct rdt_resource *r;
 
@@ -720,7 +720,7 @@ void mbm_handle_overflow(struct work_struct *work)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	d = container_of(work, struct rdt_mon_domain, mbm_over.work);
+	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp->closid, prgrp->mon.rmid);
@@ -754,7 +754,7 @@ void mbm_handle_overflow(struct work_struct *work)
  * @exclude_cpu:   Which CPU the handler should not run on,
  *		   RESCTRL_PICK_ANY_CPU to pick any CPU.
  */
-void mbm_setup_overflow_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 				int exclude_cpu)
 {
 	unsigned long delay = msecs_to_jiffies(delay_ms);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 2cff82208327..9f295cd8f0e5 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1617,7 +1617,7 @@ static void mondata_config_read(struct resctrl_mon_config_info *mon_info)
 static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid)
 {
 	struct resctrl_mon_config_info mon_info;
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 
 	cpus_read_lock();
@@ -1665,7 +1665,7 @@ static int mbm_local_bytes_config_show(struct kernfs_open_file *of,
 }
 
 static void mbm_config_write_domain(struct rdt_resource *r,
-				    struct rdt_mon_domain *d, u32 evtid, u32 val)
+				    struct rdt_l3_mon_domain *d, u32 evtid, u32 val)
 {
 	struct resctrl_mon_config_info mon_info = {0};
 
@@ -1706,8 +1706,8 @@ static void mbm_config_write_domain(struct rdt_resource *r,
 static int mon_config_write(struct rdt_resource *r, char *tok, u32 evtid)
 {
 	char *dom_str = NULL, *id_str;
+	struct rdt_l3_mon_domain *d;
 	unsigned long dom_id, val;
-	struct rdt_mon_domain *d;
 
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
@@ -2581,7 +2581,7 @@ static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	unsigned long flags = RFTYPE_CTRL_BASE;
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
 	int ret;
 
@@ -3036,11 +3036,11 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	char name[32];
 
 	if (r->rid == RDT_RESOURCE_L3) {
-		struct rdt_mon_domain *d;
+		struct rdt_l3_mon_domain *d;
 
 		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 
 		/* SNC mode? */
 		if (r->mon_scope == RESCTRL_L3_NODE) {
@@ -3100,11 +3100,11 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (r->rid == RDT_RESOURCE_L3) {
 		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
 		if (snc_mode) {
-			struct rdt_mon_domain *d;
+			struct rdt_l3_mon_domain *d;
 
 			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 				return -EINVAL;
-			d = container_of(hdr, struct rdt_mon_domain, hdr);
+			d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 			domid = d->ci_id;
 		}
 	}
@@ -4040,7 +4040,7 @@ static void rdtgroup_setup_default(void)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static void domain_destroy_mon_state(struct rdt_mon_domain *d)
+static void domain_destroy_mon_state(struct rdt_l3_mon_domain *d)
 {
 	int idx;
 
@@ -4063,7 +4063,7 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 
 void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	mutex_lock(&rdtgroup_mutex);
 
@@ -4080,7 +4080,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4114,7 +4114,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  *
  * Returns 0 for success, or -ENOMEM.
  */
-static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
+static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(*d->mbm_states[0]);
@@ -4165,7 +4165,7 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 
 int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
@@ -4176,7 +4176,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	err = domain_setup_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4225,10 +4225,10 @@ static void clear_childcpus(struct rdtgroup *r, unsigned int cpu)
 	}
 }
 
-static struct rdt_mon_domain *get_mon_domain_from_cpu(int cpu,
-						      struct rdt_resource *r)
+static struct rdt_l3_mon_domain *get_mon_domain_from_cpu(int cpu,
+							 struct rdt_resource *r)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	lockdep_assert_cpus_held();
 
@@ -4244,7 +4244,7 @@ static struct rdt_mon_domain *get_mon_domain_from_cpu(int cpu,
 void resctrl_offline_cpu(unsigned int cpu)
 {
 	struct rdt_resource *l3 = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct rdtgroup *rdtgrp;
 
 	mutex_lock(&rdtgroup_mutex);
-- 
2.50.1

