Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805C331FEC6
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830651; cv=none; b=sCrT1GeMJMwHsGCb9kVReNIbBggaCOFUDjMTsoCrAkddwq0Wvu+4dXWp18nwiMrXrUWwRuxG+Jf2R7H6OxtxCzpG3AeXA6Zn/gQmg5H3AnPqcQumWM9ioHxN3NphXoVmvsd5wJwCfeEIhmHJ52Wz/+SXilAdONUBwOwYR3BIgwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830651; c=relaxed/simple;
	bh=FPObs4p1qcJAZc1HDW4iYA7z4x0WaYocKRPFRWQhNXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezxSmu3F5HzbMAGSEPDAolBOaML4Dj2/WtmrrR1KYRamlIJT5dx22I3XoLf6wUC9My3Dn7zWzdym+RApCtUq85sN1GvkKy1n8Fye9/kMM87y/WhoGzGadCZD8K44WTEwuiaBcyby3lrtd/uEo4YA5T0AvpE9FEpXYcuS4vYB1Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nNPnC/hX; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nNPnC/hX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830649; x=1790366649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FPObs4p1qcJAZc1HDW4iYA7z4x0WaYocKRPFRWQhNXU=;
  b=nNPnC/hXx0veFz7l1x6bVZ5ANPNXkpVq8CpWH5lfJlHC4sPZGaO40T+n
   8otZr3r5oMoCPkdFQn5JgLyEI757V4L16+ibM0t3Ks0nnYcjTAlYQjFcA
   VstJySs0LJX+tL566weMCKOB6Ev4ETFWnSRvLcfwXhBmZdYmwVvtU/j6R
   P+24bUCSw1zyIIK+p0a2VMG4ftd4xdNxp4DlX7tPYYE5mNEA0PHFp5kPM
   +x6MxEMrbihmd1jVnoNmLF52C8utMJivuACBlD34WCyF9T99BJ5lGt3o5
   72qYVhADXcv0RPpKB69mfnfWneqOlx5JQ18mMy0Hb3vN/IlKTtdePIm8y
   w==;
X-CSE-ConnectionGUID: XTn9FzffQbSSyZnHh7U86g==
X-CSE-MsgGUID: kkZ1/NQkQK+QZcDU8WQiwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074186"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074186"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:07 -0700
X-CSE-ConnectionGUID: Pse5mOMFS4KbZTypY6jkvA==
X-CSE-MsgGUID: 0P9DsdCmTbWVajnIesL8TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003618"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:06 -0700
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
Subject: [PATCH v11 07/31] x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
Date: Thu, 25 Sep 2025 13:03:01 -0700
Message-ID: <20250925200328.64155-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The upcoming telemetry event monitoring are not tied to the L3
resource and will have a new domain structures.

Rename the L3 resource specific domain data structures to include
"l3_" in their names to avoid confusion between the different
resource specific domain structures:
rdt_mon_domain		-> rdt_l3_mon_domain
rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 20 ++++----
 arch/x86/kernel/cpu/resctrl/internal.h | 16 +++---
 fs/resctrl/internal.h                  |  8 +--
 arch/x86/kernel/cpu/resctrl/core.c     | 14 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c  | 36 +++++++-------
 fs/resctrl/ctrlmondata.c               |  2 +-
 fs/resctrl/monitor.c                   | 68 +++++++++++++-------------
 fs/resctrl/rdtgroup.c                  | 36 +++++++-------
 8 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0fef3045cac3..66569662efee 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -178,7 +178,7 @@ struct mbm_cntr_cfg {
 };
 
 /**
- * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
+ * struct rdt_l3_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
  * @ci_id:		cache info id for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
@@ -192,7 +192,7 @@ struct mbm_cntr_cfg {
  * @cntr_cfg:		array of assignable counters' configuration (indexed
  *			by counter ID)
  */
-struct rdt_mon_domain {
+struct rdt_l3_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	unsigned int			ci_id;
 	unsigned long			*rmid_busy_llc;
@@ -364,10 +364,10 @@ struct resctrl_cpu_defaults {
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
@@ -582,7 +582,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 closid, u32 rmid,
 			     enum resctrl_event_id eventid);
 
@@ -595,7 +595,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d);
+void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /**
  * resctrl_arch_reset_all_ctrls() - Reset the control for each CLOSID to its
@@ -621,7 +621,7 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			      enum resctrl_event_id evtid, u32 rmid, u32 closid,
 			      u32 cntr_id, bool assign);
 
@@ -659,7 +659,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
  *
  * This can be called from any CPU.
  */
-void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 closid, u32 rmid, int cntr_id,
 			     enum resctrl_event_id eventid);
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 9f4c2f0aaf5c..6eca3d522fcc 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -60,17 +60,17 @@ struct rdt_hw_ctrl_domain {
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
 
@@ -79,9 +79,9 @@ static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctr
 	return container_of(r, struct rdt_hw_ctrl_domain, d_resctrl);
 }
 
-static inline struct rdt_hw_mon_domain *resctrl_to_arch_mon_dom(struct rdt_mon_domain *r)
+static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3_mon_domain *r)
 {
-	return container_of(r, struct rdt_hw_mon_domain, d_resctrl);
+	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
 }
 
 /**
@@ -135,7 +135,7 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
 
 extern struct rdt_hw_resource rdt_resources_all[];
 
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
+void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
 union cpuid_0x10_1_eax {
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 698ed84fd073..d9e291d94926 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -369,7 +369,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 
 int resctrl_mon_resource_init(void);
 
-void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
+void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
 
@@ -377,14 +377,14 @@ void mbm_handle_overflow(struct work_struct *work);
 
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
index 2d93387b9251..42f4f702eeec 100644
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
 
@@ -625,9 +625,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct rdt_hw_mon_domain *hw_dom;
+	struct rdt_hw_l3_mon_domain *hw_dom;
+	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
-	struct rdt_mon_domain *d;
 
 	lockdep_assert_held(&domain_list_lock);
 
@@ -653,7 +653,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return;
 
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index cee1cd7fbdce..b448e6816fe7 100644
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
 
@@ -217,10 +217,10 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 	return chunks >> shift;
 }
 
-static u64 get_corrected_val(struct rdt_resource *r, struct rdt_mon_domain *d,
+static u64 get_corrected_val(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 rmid, enum resctrl_event_id eventid, u64 msr_val)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	struct arch_mbm_state *am;
 	u64 chunks;
@@ -242,7 +242,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *ignored)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	u64 msr_val;
 	u32 prmid;
 	int cpu;
@@ -253,7 +253,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	cpu = cpumask_any(&hdr->cpu_mask);
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
@@ -302,11 +302,11 @@ static int __cntr_id_read(u32 cntr_id, u64 *val)
 	return 0;
 }
 
-void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			     u32 unused, u32 rmid, int cntr_id,
 			     enum resctrl_event_id eventid)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct arch_mbm_state *am;
 
 	am = get_arch_mbm_state(hw_dom, rmid, eventid);
@@ -322,14 +322,14 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, int cntr_id,
 			   enum resctrl_event_id eventid, u64 *val)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	u64 msr_val;
 	int ret;
 
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	ret = __cntr_id_read(cntr_id, &msr_val);
 	if (ret)
 		return ret;
@@ -353,7 +353,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
  * must adjust RMID counter numbers based on SNC node. See
  * logical_rmid_to_physical_rmid() for code that does this.
  */
-void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
+void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	if (snc_nodes_per_l3_cache > 1)
 		msr_clear_bit(MSR_RMID_SNC_CONFIG, 0);
@@ -505,7 +505,7 @@ static void resctrl_abmc_set_one_amd(void *arg)
  */
 static void _resctrl_abmc_enable(struct rdt_resource *r, bool enable)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	lockdep_assert_cpus_held();
 
@@ -544,11 +544,11 @@ static void resctrl_abmc_config_one_amd(void *info)
 /*
  * Send an IPI to the domain to assign the counter to RMID, event pair.
  */
-void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			      enum resctrl_event_id evtid, u32 rmid, u32 closid,
 			      u32 cntr_id, bool assign)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct rdt_hw_l3_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	union l3_qos_abmc_cfg abmc_cfg = { 0 };
 	struct arch_mbm_state *am;
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 7b9fc5d3bdc8..c95f8eb8e731 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -622,7 +622,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
-		struct rdt_mon_domain *d;
+		struct rdt_l3_mon_domain *d;
 
 		/*
 		 * This file requires summing across all domains that share
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 32116361a5f6..88b990e939ea 100644
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
@@ -362,7 +362,7 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
  * Return:
  * Valid counter ID on success, or -ENOENT on failure.
  */
-static int mbm_cntr_get(struct rdt_resource *r, struct rdt_mon_domain *d,
+static int mbm_cntr_get(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			struct rdtgroup *rdtgrp, enum resctrl_event_id evtid)
 {
 	int cntr_id;
@@ -389,7 +389,7 @@ static int mbm_cntr_get(struct rdt_resource *r, struct rdt_mon_domain *d,
  * Return:
  * Valid counter ID on success, or -ENOSPC on failure.
  */
-static int mbm_cntr_alloc(struct rdt_resource *r, struct rdt_mon_domain *d,
+static int mbm_cntr_alloc(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			  struct rdtgroup *rdtgrp, enum resctrl_event_id evtid)
 {
 	int cntr_id;
@@ -408,7 +408,7 @@ static int mbm_cntr_alloc(struct rdt_resource *r, struct rdt_mon_domain *d,
 /*
  * mbm_cntr_free() - Clear the counter ID configuration details in the domain @d.
  */
-static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
+static void mbm_cntr_free(struct rdt_l3_mon_domain *d, int cntr_id)
 {
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
@@ -418,7 +418,7 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	int cpu = smp_processor_id();
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	int cntr_id = -ENOENT;
 	struct mbm_state *m;
 	int err, ret;
@@ -426,7 +426,7 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
-	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
 
 	if (rr->is_mbm_cntr) {
 		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
@@ -515,12 +515,12 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	u64 cur_bw, bytes, cur_bytes;
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
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
@@ -620,7 +620,7 @@ static struct rdt_ctrl_domain *get_ctrl_domain_from_cpu(int cpu,
  * throttle MSRs already have low percentage values.  To avoid
  * unnecessarily restricting such rdtgroups, we also increase the bandwidth.
  */
-static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
+static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_mbm)
 {
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
@@ -688,7 +688,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
 }
 
-static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 struct rdtgroup *rdtgrp, enum resctrl_event_id evtid)
 {
 	struct rmid_read rr = {0};
@@ -720,7 +720,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
 }
 
-static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 		       struct rdtgroup *rdtgrp)
 {
 	/*
@@ -741,12 +741,12 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
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
 
@@ -769,7 +769,7 @@ void cqm_handle_limbo(struct work_struct *work)
  * @exclude_cpu:   Which CPU the handler should not run on,
  *		   RESCTRL_PICK_ANY_CPU to pick any CPU.
  */
-void cqm_setup_limbo_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void cqm_setup_limbo_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 			     int exclude_cpu)
 {
 	unsigned long delay = msecs_to_jiffies(delay_ms);
@@ -786,7 +786,7 @@ void mbm_handle_overflow(struct work_struct *work)
 {
 	unsigned long delay = msecs_to_jiffies(MBM_OVERFLOW_INTERVAL);
 	struct rdtgroup *prgrp, *crgrp;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct list_head *head;
 	struct rdt_resource *r;
 
@@ -801,7 +801,7 @@ void mbm_handle_overflow(struct work_struct *work)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	d = container_of(work, struct rdt_mon_domain, mbm_over.work);
+	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp);
@@ -835,7 +835,7 @@ void mbm_handle_overflow(struct work_struct *work)
  * @exclude_cpu:   Which CPU the handler should not run on,
  *		   RESCTRL_PICK_ANY_CPU to pick any CPU.
  */
-void mbm_setup_overflow_handler(struct rdt_mon_domain *dom, unsigned long delay_ms,
+void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_ms,
 				int exclude_cpu)
 {
 	unsigned long delay = msecs_to_jiffies(delay_ms);
@@ -1090,7 +1090,7 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
  * mbm_cntr_free_all() - Clear all the counter ID configuration details in the
  *			 domain @d. Called when mbm_assign_mode is changed.
  */
-static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_mon_domain *d)
+static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	memset(d->cntr_cfg, 0, sizeof(*d->cntr_cfg) * r->mon.num_mbm_cntrs);
 }
@@ -1099,7 +1099,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_mon_domain *d)
  * resctrl_reset_rmid_all() - Reset all non-architecture states for all the
  *			      supported RMIDs.
  */
-static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
+static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	enum resctrl_event_id evt;
@@ -1120,7 +1120,7 @@ static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain
  * Assign the counter if @assign is true else unassign the counter. Reset the
  * associated non-architectural state.
  */
-static void rdtgroup_assign_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void rdtgroup_assign_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 enum resctrl_event_id evtid, u32 rmid, u32 closid,
 				 u32 cntr_id, bool assign)
 {
@@ -1140,7 +1140,7 @@ static void rdtgroup_assign_cntr(struct rdt_resource *r, struct rdt_mon_domain *
  * Return:
  * 0 on success, < 0 on failure.
  */
-static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				      struct rdtgroup *rdtgrp, struct mon_evt *mevt)
 {
 	int cntr_id;
@@ -1175,7 +1175,7 @@ static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_mon_dom
  * Return:
  * 0 on success, < 0 on failure.
  */
-static int rdtgroup_assign_cntr_event(struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
 				      struct mon_evt *mevt)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(mevt->rid);
@@ -1225,7 +1225,7 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
  * rdtgroup_free_unassign_cntr() - Unassign and reset the counter ID configuration
  * for the event pointed to by @mevt within the domain @d and resctrl group @rdtgrp.
  */
-static void rdtgroup_free_unassign_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+static void rdtgroup_free_unassign_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 					struct rdtgroup *rdtgrp, struct mon_evt *mevt)
 {
 	int cntr_id;
@@ -1246,7 +1246,7 @@ static void rdtgroup_free_unassign_cntr(struct rdt_resource *r, struct rdt_mon_d
  * the event structure @mevt from the domain @d and the group @rdtgrp. Unassign
  * the counters from all the domains if @d is NULL else unassign from @d.
  */
-static void rdtgroup_unassign_cntr_event(struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+static void rdtgroup_unassign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
 					 struct mon_evt *mevt)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(mevt->rid);
@@ -1321,7 +1321,7 @@ static int resctrl_parse_mem_transactions(char *tok, u32 *val)
 static void rdtgroup_update_cntr_event(struct rdt_resource *r, struct rdtgroup *rdtgrp,
 				       enum resctrl_event_id evtid)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	int cntr_id;
 
 	list_for_each_entry(d, &r->mon_domains, hdr.list) {
@@ -1427,7 +1427,7 @@ ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
 				      size_t nbytes, loff_t off)
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	int ret = 0;
 	bool enable;
 
@@ -1500,7 +1500,7 @@ int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
 			       struct seq_file *s, void *v)
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 
 	cpus_read_lock();
@@ -1524,7 +1524,7 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
 				     struct seq_file *s, void *v)
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 	u32 cntrs, i;
 	int ret = 0;
@@ -1565,7 +1565,7 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
 int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, void *v)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct rdtgroup *rdtgrp;
 	struct mon_evt *mevt;
 	int ret = 0;
@@ -1628,7 +1628,7 @@ static struct mon_evt *mbm_get_mon_event_by_name(struct rdt_resource *r, char *n
 	return NULL;
 }
 
-static int rdtgroup_modify_assign_state(char *assign, struct rdt_mon_domain *d,
+static int rdtgroup_modify_assign_state(char *assign, struct rdt_l3_mon_domain *d,
 					struct rdtgroup *rdtgrp, struct mon_evt *mevt)
 {
 	int ret = 0;
@@ -1654,7 +1654,7 @@ static int rdtgroup_modify_assign_state(char *assign, struct rdt_mon_domain *d,
 static int resctrl_parse_mbm_assignment(struct rdt_resource *r, struct rdtgroup *rdtgrp,
 					char *event, char *tok)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	unsigned long dom_id = 0;
 	char *dom_str, *id_str;
 	struct mon_evt *mevt;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index e3b83e48f2d9..1b4f4bd63143 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1618,7 +1618,7 @@ static void mondata_config_read(struct resctrl_mon_config_info *mon_info)
 static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid)
 {
 	struct resctrl_mon_config_info mon_info;
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 
 	cpus_read_lock();
@@ -1666,7 +1666,7 @@ static int mbm_local_bytes_config_show(struct kernfs_open_file *of,
 }
 
 static void mbm_config_write_domain(struct rdt_resource *r,
-				    struct rdt_mon_domain *d, u32 evtid, u32 val)
+				    struct rdt_l3_mon_domain *d, u32 evtid, u32 val)
 {
 	struct resctrl_mon_config_info mon_info = {0};
 
@@ -1707,8 +1707,8 @@ static void mbm_config_write_domain(struct rdt_resource *r,
 static int mon_config_write(struct rdt_resource *r, char *tok, u32 evtid)
 {
 	char *dom_str = NULL, *id_str;
+	struct rdt_l3_mon_domain *d;
 	unsigned long dom_id, val;
-	struct rdt_mon_domain *d;
 
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
@@ -2716,7 +2716,7 @@ static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	unsigned long flags = RFTYPE_CTRL_BASE;
-	struct rdt_mon_domain *dom;
+	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
 	int ret;
 
@@ -3167,7 +3167,7 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 					   struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	char subname[32];
 	bool snc_mode;
 	char name[32];
@@ -3175,7 +3175,7 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
 	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
 	if (snc_mode)
@@ -3221,7 +3221,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	char name[32];
 	bool snc_mode;
 	int ret = 0;
@@ -3231,7 +3231,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
 	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
 	kn = kernfs_find_and_get(parent_kn, name);
@@ -4174,7 +4174,7 @@ static void rdtgroup_setup_default(void)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static void domain_destroy_mon_state(struct rdt_mon_domain *d)
+static void domain_destroy_mon_state(struct rdt_l3_mon_domain *d)
 {
 	int idx;
 
@@ -4198,7 +4198,7 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 
 void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 
 	mutex_lock(&rdtgroup_mutex);
 
@@ -4212,7 +4212,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4246,7 +4246,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  *
  * Returns 0 for success, or -ENOMEM.
  */
-static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
+static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(*d->mbm_states[0]);
@@ -4304,7 +4304,7 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 
 int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	int err = -EINVAL;
 
 	mutex_lock(&rdtgroup_mutex);
@@ -4312,7 +4312,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		goto out_unlock;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	err = domain_setup_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4360,10 +4360,10 @@ static void clear_childcpus(struct rdtgroup *r, unsigned int cpu)
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
 
@@ -4379,7 +4379,7 @@ static struct rdt_mon_domain *get_mon_domain_from_cpu(int cpu,
 void resctrl_offline_cpu(unsigned int cpu)
 {
 	struct rdt_resource *l3 = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	struct rdt_mon_domain *d;
+	struct rdt_l3_mon_domain *d;
 	struct rdtgroup *rdtgrp;
 
 	mutex_lock(&rdtgroup_mutex);
-- 
2.51.0

