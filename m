Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F271A5BB0
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886861; cv=none; b=Qt5/F3SpAq8jp/uah5V57s81KX6NxuXSvpnDOedbVFHdMBez8dm8oaeFHqpWVIY5STX8KLYN6RXx35H8CwY397BuuZ2ZOn0SNwaDZFN6L8KJAI/Vd+XkC4OP07JDytcAvtH3znmhnsC2JsYex/uXztfCUiXpkARwlxOqujZSkaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886861; c=relaxed/simple;
	bh=hMRGabSCoP2Mt8bNaVEGnebNCxb8RE3JYqwt6KkURyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvmBbg2b/1hXNQfhiLadem6okhkqZWe9/KWUpfrJyasM4BndZS5dqqoh9/U+HpsC4nL93QmcAQfIVfoVRfmLVFVtb68kKAgp5TaqEJozHvxg32FoDnX0QcpmxiXpDkuUJ1gUEnkaZNiCAKGYUZ4FFkaoGaQ2MhzTF6JQ3qGozLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSt90bOy; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSt90bOy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886859; x=1777422859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hMRGabSCoP2Mt8bNaVEGnebNCxb8RE3JYqwt6KkURyA=;
  b=CSt90bOyim6FkFcygFTKwpumLQybcVZf6rmVzacNV3BnCraMOSiRNdJG
   LTrnLSGw0rOCsaQHG4Tg6LNKIgKuaiyjDXZjBamZVqrx1XVuH8/mFP6Uv
   heeSzStvzUNlNd25foBqI/FeEDWZiq/AM3a9LfLE+ZUSZuodS1XwRQEtZ
   3I/ByHapO+ZhcCFo5dPI+lDxisyyP1LpQI7Fh1iT/SMp5d7EUkvTcjcCO
   4RPfiNcgOSM1LEHaYszTW17zBGKgUAEPlNudephWKJ3ltF5Ac0b6FzqwB
   PH0+3GHLfYuK5O2u0UA8sM6QsfsRHe1nBb9L8zy/qvWwltOWbEG+jb9KB
   g==;
X-CSE-ConnectionGUID: mJLy4k4WR7GCexk/ZLi0LQ==
X-CSE-MsgGUID: UIXSTDxISQ23zdoUD/Fyqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148138"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148138"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:13 -0700
X-CSE-ConnectionGUID: MI8gAi0nT1mHyn1cvrlvbw==
X-CSE-MsgGUID: Jh1iZbYiRo2hmM8lLDJCvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393999"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:13 -0700
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
Subject: [PATCH v4 11/31] x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
Date: Mon, 28 Apr 2025 17:33:37 -0700
Message-ID: <20250429003359.375508-12-tony.luck@intel.com>
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

These structures have generic names, but are only used for L3 monitor
events.

Rename:
rdt_mon_domain		-> rdt_l3_mon_domain
rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 12 ++++----
 arch/x86/kernel/cpu/resctrl/internal.h | 12 ++++----
 fs/resctrl/internal.h                  | 12 ++++----
 arch/x86/kernel/cpu/resctrl/core.c     | 14 ++++-----
 arch/x86/kernel/cpu/resctrl/monitor.c  | 18 ++++++------
 fs/resctrl/ctrlmondata.c               |  6 ++--
 fs/resctrl/monitor.c                   | 28 +++++++++---------
 fs/resctrl/rdtgroup.c                  | 40 +++++++++++++-------------
 8 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index bb55c449adc4..cd7881313d4e 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -166,7 +166,7 @@ struct rdt_ctrl_domain {
 };
 
 /**
- * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
+ * struct rdt_l3_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
  * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
@@ -176,7 +176,7 @@ struct rdt_ctrl_domain {
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
  * @cqm_work_cpu:	worker CPU for CQM h/w counters
  */
-struct rdt_mon_domain {
+struct rdt_l3_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
@@ -335,7 +335,7 @@ struct resctrl_cpu_defaults {
 
 struct resctrl_mon_config_info {
 	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
+	struct rdt_l3_mon_domain	*d;
 	u32			evtid;
 	u32			mon_config;
 };
@@ -475,7 +475,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *arch_mon_ctx);
 
@@ -522,7 +522,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 closid, u32 rmid,
 			     enum resctrl_event_id eventid);
 
@@ -535,7 +535,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d);
+void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /**
  * resctrl_arch_reset_all_ctrls() - Reset the control for each CLOSID to its
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index b563406b4996..83b20e6b25d7 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -51,15 +51,15 @@ struct rdt_hw_ctrl_domain {
 };
 
 /**
- * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
+ * struct rdt_hw_l3_mon_domain - Arch private attributes of a set of CPUs that share
  *			      a resource for a monitor function
  * @d_resctrl:	Properties exposed to the resctrl file system
  * @arch_mbm_states:	arch private state for each MBM event
  *
  * Members of this structure are accessed via helpers that provide abstraction.
  */
-struct rdt_hw_mon_domain {
-	struct rdt_mon_domain		d_resctrl;
+struct rdt_hw_l3_mon_domain {
+	struct rdt_l3_mon_domain		d_resctrl;
 	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_MBM_EVENTS];
 };
 
@@ -68,9 +68,9 @@ static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctr
 	return container_of(r, struct rdt_hw_ctrl_domain, d_resctrl);
 }
 
-static inline struct rdt_hw_mon_domain *resctrl_to_arch_mon_dom(struct rdt_mon_domain *r)
+static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3_mon_domain *r)
 {
-	return container_of(r, struct rdt_hw_mon_domain, d_resctrl);
+	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
 }
 
 /**
@@ -122,7 +122,7 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
 
 extern struct rdt_hw_resource rdt_resources_all[];
 
-void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
+void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
 union cpuid_0x10_1_eax {
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index b69170760316..759768e2a2a8 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -129,7 +129,7 @@ struct mon_data {
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
+	struct rdt_l3_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
 	struct cacheinfo	*ci;
@@ -365,12 +365,12 @@ void mon_event_count(void *info);
 int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
-		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first);
 
 int resctrl_mon_resource_init(void);
 
-void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
+void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
 
@@ -378,14 +378,14 @@ void mbm_handle_overflow(struct work_struct *work);
 
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
index 9c78828ae32f..01843dd0b8b7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -362,7 +362,7 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 	kfree(hw_dom);
 }
 
-static void free_l3_mon_domain(struct rdt_hw_mon_domain *hw_dom)
+static void free_l3_mon_domain(struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	for (int i = 0; i < QOS_NUM_MBM_EVENTS; i++)
 		kfree(hw_dom->arch_mbm_states[i]);
@@ -397,7 +397,7 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
  * @num_rmid:	The size of the MBM counter array
  * @hw_dom:	The domain that owns the allocated arrays
  */
-static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
+static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	size_t tsize = sizeof(struct arch_mbm_state);
 	enum resctrl_event_id evt;
@@ -495,8 +495,8 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
 {
-	struct rdt_hw_mon_domain *hw_dom;
-	struct rdt_mon_domain *d;
+	struct rdt_hw_l3_mon_domain *hw_dom;
+	struct rdt_l3_mon_domain *d;
 	int err;
 
 	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
@@ -618,9 +618,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct rdt_hw_mon_domain *hw_dom;
+	struct rdt_hw_l3_mon_domain *hw_dom;
 	struct rdt_domain_hdr *hdr;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	lockdep_assert_held(&domain_list_lock);
 
@@ -646,7 +646,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 
 	switch (r->rid) {
 	case RDT_RESOURCE_L3:
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index d1f659dd6109..8d8ec86929fa 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -108,7 +108,7 @@ static inline u64 get_corrected_mbm_count(u32 rmid, unsigned long val)
  *
  * In RMID sharing mode there are fewer "logical RMID" values available
  * to accumulate data ("physical RMIDs" are divided evenly between SNC
- * nodes that share an L3 cache). Linux creates an rdt_mon_domain for
+ * nodes that share an L3 cache). Linux creates an rdt_l3_mon_domain for
  * each SNC node.
  *
  * The value loaded into IA32_PQR_ASSOC is the "logical RMID".
@@ -156,7 +156,7 @@ static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
 	return 0;
 }
 
-static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_dom,
+static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_l3_mon_domain *hw_dom,
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
 {
@@ -177,11 +177,11 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
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
@@ -200,9 +200,9 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
  * Assumes that hardware counters are also reset and thus that there is
  * no need to record initial non-zero counts.
  */
-void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
+void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	enum resctrl_event_id evt;
 	int idx;
 
@@ -223,11 +223,11 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 	return chunks >> shift;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *ignored)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	struct arch_mbm_state *am;
@@ -271,7 +271,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
  * must adjust RMID counter numbers based on SNC node. See
  * logical_rmid_to_physical_rmid() for code that does this.
  */
-void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
+void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	if (snc_nodes_per_l3_cache > 1)
 		msr_clear_bit(MSR_RMID_SNC_CONFIG, 0);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 3cbacfe52430..8c0f6d229130 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -526,7 +526,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 }
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
-		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+		    struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
 {
 	int cpu;
@@ -569,7 +569,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	struct kernfs_open_file *of = m->private;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	u32 resid, evtid, domid;
 	struct rdtgroup *rdtgrp;
 	struct rdt_resource *r;
@@ -620,7 +620,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
 	}
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index a5a523f73249..19cba29452b7 100644
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
 	struct mbm_state *m;
 	int err, ret;
 	u64 tval = 0;
@@ -532,7 +532,7 @@ static struct rdt_ctrl_domain *get_ctrl_domain_from_cpu(int cpu,
  * throttle MSRs already have low percentage values.  To avoid
  * unnecessarily restricting such rdtgroups, we also increase the bandwidth.
  */
-static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
+static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_mbm)
 {
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
@@ -600,7 +600,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
 }
 
-static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
 	struct rmid_read rr = {0};
@@ -627,7 +627,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
 }
 
-static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 		       u32 closid, u32 rmid)
 {
 	/*
@@ -648,12 +648,12 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
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
 
@@ -676,7 +676,7 @@ void cqm_handle_limbo(struct work_struct *work)
  * @exclude_cpu:   Which CPU the handler should not run on,
  *		   RESCTRL_PICK_ANY_CPU to pick any CPU.
  */
-void cqm_setup_limbo_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void cqm_setup_limbo_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 			     int exclude_cpu)
 {
 	unsigned long delay = msecs_to_jiffies(delay_ms);
@@ -693,7 +693,7 @@ void mbm_handle_overflow(struct work_struct *work)
 {
 	unsigned long delay = msecs_to_jiffies(MBM_OVERFLOW_INTERVAL);
 	struct rdtgroup *prgrp, *crgrp;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct list_head *head;
 	struct rdt_resource *r;
 
@@ -708,7 +708,7 @@ void mbm_handle_overflow(struct work_struct *work)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	d = container_of(work, struct rdt_mon_domain, mbm_over.work);
+	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp->closid, prgrp->mon.rmid);
@@ -742,7 +742,7 @@ void mbm_handle_overflow(struct work_struct *work)
  * @exclude_cpu:   Which CPU the handler should not run on,
  *		   RESCTRL_PICK_ANY_CPU to pick any CPU.
  */
-void mbm_setup_overflow_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 				int exclude_cpu)
 {
 	unsigned long delay = msecs_to_jiffies(delay_ms);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0ec87db799b4..d2f9361694b6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1613,7 +1613,7 @@ static void mondata_config_read(struct resctrl_mon_config_info *mon_info)
 static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid)
 {
 	struct resctrl_mon_config_info mon_info;
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 
 	cpus_read_lock();
@@ -1661,7 +1661,7 @@ static int mbm_local_bytes_config_show(struct kernfs_open_file *of,
 }
 
 static void mbm_config_write_domain(struct rdt_resource *r,
-				    struct rdt_mon_domain *d, u32 evtid, u32 val)
+				    struct rdt_l3_mon_domain *d, u32 evtid, u32 val)
 {
 	struct resctrl_mon_config_info mon_info = {0};
 
@@ -1703,7 +1703,7 @@ static int mon_config_write(struct rdt_resource *r, char *tok, u32 evtid)
 {
 	char *dom_str = NULL, *id_str;
 	unsigned long dom_id, val;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
@@ -2577,7 +2577,7 @@ static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	unsigned long flags = RFTYPE_CTRL_BASE;
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
 	int ret;
 
@@ -3031,11 +3031,11 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
 	if (snc_mode) {
-		struct rdt_mon_domain *d;
+		struct rdt_l3_mon_domain *d;
 
 		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
 			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
 		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
 	} else {
@@ -3055,7 +3055,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			     bool do_sum)
 {
 	struct rmid_read rr = {0};
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct mon_data *priv;
 	struct mon_evt *mevt;
 	int ret, domid;
@@ -3066,7 +3066,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 	if (r->rid == RDT_RESOURCE_L3) {
 		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
 			return -EINVAL;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		domid = do_sum ? d->ci->id : d->hdr.id;
 	} else {
 		domid = hdr->id;
@@ -3093,7 +3093,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	char name[32];
 	bool snc_mode;
 	int ret = 0;
@@ -3104,7 +3104,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (snc_mode) {
 		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
 			return -EINVAL;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
 	} else {
 		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
@@ -4037,7 +4037,7 @@ static void rdtgroup_setup_default(void)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static void domain_destroy_mon_state(struct rdt_mon_domain *d)
+static void domain_destroy_mon_state(struct rdt_l3_mon_domain *d)
 {
 	bitmap_free(d->rmid_busy_llc);
 	for (int i = 0; i < QOS_NUM_MBM_EVENTS; i++) {
@@ -4058,7 +4058,7 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 
 void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	mutex_lock(&rdtgroup_mutex);
 
@@ -4075,7 +4075,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4109,7 +4109,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  *
  * Returns 0 for success, or -ENOMEM.
  */
-static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
+static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(struct mbm_state);
@@ -4160,7 +4160,7 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 
 int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
@@ -4171,7 +4171,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return err;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4218,10 +4218,10 @@ static void clear_childcpus(struct rdtgroup *r, unsigned int cpu)
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
 
@@ -4237,7 +4237,7 @@ static struct rdt_mon_domain *get_mon_domain_from_cpu(int cpu,
 void resctrl_offline_cpu(unsigned int cpu)
 {
 	struct rdt_resource *l3 = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct rdtgroup *rdtgrp;
 
 	mutex_lock(&rdtgroup_mutex);
-- 
2.48.1

