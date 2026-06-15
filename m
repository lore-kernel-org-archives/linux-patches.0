Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD2B317170
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547919; cv=none; b=kGUt3kiBpQ88OeVn3QkNGiwMqb9wHsE6G+zySZl3eKEO1XIDO/n8HtD3QxkHiUs8ZBl02+FK14QzcaiehAhLmY+pB8tD1eONJ2fefIMheNPzwQoUlzSrXCXrb9nK8pJhwvthLGLqG+j6PDMIi0IsmZxbuGyRFQgxTTNEjRl2fn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547919; c=relaxed/simple;
	bh=MQWbJOZCaoBJeZRGiNL6pLEmGrFCHZ2YMuR3myGYkB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKUTG1w47JdeXpm0u8iwzvj0yamgXgZE6CJHgQn+zwJ5SlyNeT6l8AULYJQ9npeycd2/5bCvROH6ZOa0mgCmsnj4boSILtT2AtmunOV55BL43sizTPZdET3c+3aO9YkQW7fmulcHnWQTf/tRhmeDgRcZE6/GLyjEA0/njGT+Lus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHIhG0FX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHIhG0FX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547918; x=1813083918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MQWbJOZCaoBJeZRGiNL6pLEmGrFCHZ2YMuR3myGYkB8=;
  b=SHIhG0FXCwBfxqYnMpC+ukKhRfQeajL6hh6WOSA/iPfETRC+XbEEUhOT
   9oFpzXAc3No7ZnEdOg2JhHG+6i6HX6d92zx0m0iNqkkkhfM6Job6Q6fDY
   R6wo7WKXP9kr4v/8end0+I2fZkkevwYkqGrNFgTDe64Kri1P6tB8QdqHM
   2Ifa9YmYhhZEHkOOY15xAuSJeA68+O4mwK4IWgs9gt3eeyqMLJ4Ge2HjY
   F3ssea9PFVcEI4z34CrBwDbYUbz0s58Vyk/xnDRfKs4EUN5+GJWZ5VTQc
   +XZpmLM932gV0JWJIIsGwynDBd+c7HlNvcVOD5dhoVygI7dXqtp8aKRvD
   Q==;
X-CSE-ConnectionGUID: Krue6yY2S7mpKhR1UcOQxA==
X-CSE-MsgGUID: sVDIRaVDS0uYCwirT0rE+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790038"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790038"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:12 -0700
X-CSE-ConnectionGUID: rKSB93vYTjmjeE66I2ke4A==
X-CSE-MsgGUID: tEtw8Q+uRhGcu9HNu38IVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620657"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:11 -0700
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
Subject: [PATCH v8 13/16] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
Date: Mon, 15 Jun 2026 11:24:54 -0700
Message-ID: <20260615182457.14725-14-tony.luck@intel.com>
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

resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
logically independent and should be loadable modules.  Switch AET to use the
function-pointer registration API instead of direct link-time references to
PMT symbols.

Prepare for the file system to call resctrl_arch_pre_mount() on every mount
by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
the filesystem is not mounted.

Remove intel_aet_exit because all cleanup now happens in the unmount path.

Note that the Linux file system code does not serialize calls to
fs_context_operations::get_tree(), so there may be arbitrarily many parallel
calls if users invoke mount(2) multiple times.

Use an atomic counter to detect and ignore nested mount attempts. AET doesn't
need to do anything for these. File system will fail them with an -EBUSY
error code.

event_group::num_rmid may be reset (reduced) during enumeration. This is
not worth resetting on unmount because the same reduction would occur on
each subsequent mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v8:
	Drop reference to preceding patch in commit
	Drop resctrl_arch_mount_lock and replace with atomic ops
	Fix comment about "have_pmt_hold" in intel_aet_pre_mount()
	Rename have_pmt_hold to pmt_in_use and simplify mount/unmount
	Add intel_aet_try_module_get() and intel_aet_module_put() helpers with
	stubs for the CONFIG_INTEL_PMT_TELEMETRY=y case.

 include/linux/resctrl.h                 |  6 +++
 arch/x86/kernel/cpu/resctrl/internal.h  | 23 +++++++++--
 arch/x86/kernel/cpu/resctrl/core.c      | 37 +++++++++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 +++++++++++++++++++++----
 drivers/resctrl/mpam_resctrl.c          |  4 ++
 5 files changed, 108 insertions(+), 15 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 8740dc52b0f7..ace41847da46 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -559,6 +559,12 @@ void resctrl_offline_cpu(unsigned int cpu);
  */
 void resctrl_arch_pre_mount(void);
 
+/*
+ * Architecture hook called when mount fails, or on unmount.
+ * No locks are held.
+ */
+void resctrl_arch_unmount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..a891017f69ec 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
-void __exit intel_aet_exit(void);
+bool intel_aet_pre_mount(void);
+void intel_aet_unmount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
-static inline void __exit intel_aet_exit(void) { }
+static inline bool intel_aet_pre_mount(void) { return false; }
+static inline void intel_aet_unmount(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
@@ -253,4 +253,19 @@ static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resour
 static inline bool intel_handle_aet_option(bool force_off, char *tok) { return false; }
 #endif
 
+#ifdef CONFIG_INTEL_PMT_TELEMETRY_MODULE
+static inline bool intel_aet_try_module_get(struct module *mod)
+{
+	return try_module_get(mod);
+}
+
+static inline void intel_aet_module_put(struct module *mod)
+{
+	module_put(mod);
+}
+#else
+static inline bool intel_aet_try_module_get(struct module *mod) { return true; }
+static inline void intel_aet_module_put(struct module *mod) { }
+#endif
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 08a229e25883..371d3dfcb506 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -16,10 +16,13 @@
 
 #define pr_fmt(fmt)	"resctrl: " fmt
 
+#include <linux/atomic.h>
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/cpuhotplug.h>
+#include <linux/mutex.h>
 
 #include <asm/cpu_device_id.h>
 #include <asm/msr.h>
@@ -792,12 +795,17 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+static atomic_t resctrl_arch_mount_entries;
+
 void resctrl_arch_pre_mount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (atomic_inc_return(&resctrl_arch_mount_entries) > 1)
+		return;
+
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
@@ -813,6 +821,31 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int n = atomic_dec_return(&resctrl_arch_mount_entries);
+	int cpu;
+
+	if (n > 0)
+		return;
+
+	WARN_ON_ONCE(n < 0);
+
+	intel_aet_unmount();
+
+	if (!r->mon_capable)
+		return;
+
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	for_each_online_cpu(cpu)
+		domain_remove_cpu_mon(cpu, r);
+	r->mon_capable = false;
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
@@ -1186,8 +1219,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index bc15cf37a7d0..57b19cf8920c 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -25,8 +25,8 @@
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
-#include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -310,7 +310,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -319,14 +319,14 @@ bool intel_aet_get_events(void)
 
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
-		p = intel_pmt_get_regions_by_feature(pfid);
+		p = get_feature(pfid);
 		if (IS_ERR_OR_NULL(p))
 			continue;
 		if (enable_events(*peg, p)) {
 			(*peg)->pfg = p;
 			ret = true;
 		} else {
-			intel_pmt_put_feature_group(p);
+			put_feature(p);
 		}
 	}
 
@@ -359,16 +359,53 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
-void __exit intel_aet_exit(void)
+/*
+ * Track whether pmt_telemetry enumeration succeeded during mount for use
+ * during unmount.
+ */
+static bool pmt_in_use;
+
+bool intel_aet_pre_mount(void)
+{
+	bool ret;
+
+	guard(mutex)(&aet_register_lock);
+	if (!get_feature || !put_feature)
+		return false;
+
+	if (!intel_aet_try_module_get(pmt_module))
+		return false;
+
+	ret = aet_get_events();
+
+	if (!ret)
+		intel_aet_module_put(pmt_module);
+	else
+		pmt_in_use = true;
+
+	return ret;
+}
+
+void intel_aet_unmount(void)
 {
 	struct event_group **peg;
 
+	guard(mutex)(&aet_register_lock);
+	if (!pmt_in_use)
+		return;
+
 	for_each_event_group(peg) {
-		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
-			(*peg)->pfg = NULL;
+		struct event_group *e = *peg;
+
+		if (e->pfg) {
+			for (int j = 0; j < e->num_events; j++)
+				resctrl_disable_mon_event(e->evts[j].id);
+			put_feature(e->pfg);
+			e->pfg = NULL;
 		}
 	}
+	intel_aet_module_put(pmt_module);
+	pmt_in_use = false;
 }
 
 #define DATA_VALID	BIT_ULL(63)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 7079870ca894..5859cc0f5e37 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -162,6 +162,10 @@ void resctrl_arch_pre_mount(void)
 {
 }
 
+void resctrl_arch_unmount(void)
+{
+}
+
 bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
 {
 	return mpam_resctrl_controls[rid].cdp_enabled;
-- 
2.54.0

