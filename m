Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2402439022E
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346092; cv=none; b=GZ6EHIZn4eUJcb5pJ2R6XaoCbJwhR3rhRqe0CHgVqV7cob42pAdnolVq+GQBGwcnUnaGNfOZKCGdwp2Em1nH0/oyJvWjxOjGpVr+nyauobXY0H3h76uooNMWyS9M4gHuY+6dZdmy4Db4R60ywmAJ74FFmp6Ah5w4j8nAW0LmScI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346092; c=relaxed/simple;
	bh=6GjIEP/eHaHZk0u9xMTosavKayHwlA3GR4H6yFwQhr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsvxngaxnW70QNgAmt4R5MB63Hb7Fk2KlHeu3wq0xonEmIntfOMa7m0DPo6xe7OBgX+8yQHSiGyEE6yUB2qGmpSLWwL/eybshe5J6GepkQD7AJUjrwGcWiOfbLyEgcoNwUTMm7JZa/9tYXgRrgUjVi+Dbj40kg3GzY7qOqi9MKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hnzNaeGf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hnzNaeGf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346090; x=1816882090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6GjIEP/eHaHZk0u9xMTosavKayHwlA3GR4H6yFwQhr0=;
  b=hnzNaeGfoCNr0agyeZjHQ99oqftSDxMcr+NO+FpMv5oGZfn51Gy6e6/t
   aeWOlHuUUloo0pq8m6JeBMeUUKyaSMByac5UYBNSzc0XgBg/SoXXI5+YP
   1SQQWNipKNCcsBhygxDpvZkBZJkSE55+iD5GHRDHSHlWfAl2I8CB2sFdy
   lqegw09JRmDPPo6f/nTodmTavvIikvyZamVe814g4klm1cgSAXgyq/ddI
   hW/uDWuh0uCAAIwb1t7hNy66BftFhWjcB/6B98mtd6yhQai1VUD2weY3/
   etM7UPzjAqi5qcMrrQ7U1eAr5ELmlTlNP4pmdPYAyPqXUkTswr6sy/rOj
   w==;
X-CSE-ConnectionGUID: T38Of6qmSl2ZAVtR5wqDyA==
X-CSE-MsgGUID: a0dDboPcRmWBmvxADdvkAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473657"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473657"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:02 -0700
X-CSE-ConnectionGUID: +BjzaarMQYyklprfDifg2Q==
X-CSE-MsgGUID: SLqAyvRGRsOuoeUlxi42lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024602"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:02 -0700
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
Subject: [PATCH v10 11/17] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
Date: Wed, 29 Jul 2026 10:27:46 -0700
Message-ID: <20260729172752.11561-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
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

intel_aet_exit() was never called because resctrl is built into the kernel. All
cleanup is now handled in the unmount path. Remove intel_aet_exit().

Note that the Linux file system code does not serialize calls to
fs_context_operations::get_tree(), so there may be arbitrarily many parallel
calls if users invoke mount(2) multiple times.

Zero rdt_resource::resctrl_mon::num_rmid for RDT_RESOURCE_PERF_PKG so
that it will be re-computed next mount.

event_group::num_rmid may be reset (reduced) during enumeration. This is
not worth resetting on unmount because the same reduction would occur on
each subsequent mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	Add to commit that intel_aet_exit() wasn't called before.
	Introduce aet_register_lock mutex here where it is clear
	that it is needed to resolve module load/unload and resctrl
	mount/unmount races.
	Drop intel_aet_try_module_get()/intel_aet_module_put(). The
	generic versions handle NULL module arguments.
	Zero rdt_resource::resctrl_mon::num_rmid in unmount path.
	Pass status back from intel_aet_pre_mount() to resctrl_arch_pre_mount()

 include/linux/resctrl.h                 |  6 +++
 arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++--
 arch/x86/kernel/cpu/resctrl/core.c      | 25 ++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 61 ++++++++++++++++++++++---
 drivers/resctrl/mpam_resctrl.c          |  4 ++
 5 files changed, 90 insertions(+), 14 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index ec9bf1b09e3f..568a650c0224 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -581,6 +581,12 @@ void resctrl_offline_cpu(unsigned int cpu);
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
index 8e4f0bb91785..099356e4328a 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,17 +234,17 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
 void __init intel_aet_init(void);
-void __exit intel_aet_exit(void);
+bool intel_aet_pre_mount(void);
+void intel_aet_unmount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
 static inline void intel_aet_init(void) { }
-static inline void __exit intel_aet_exit(void) { }
+static inline bool intel_aet_pre_mount(void) { return false; }
+static inline void intel_aet_unmount(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2c938b97b147..e335a143f3e5 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -16,10 +16,12 @@
 
 #define pr_fmt(fmt)	"resctrl: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/cpuhotplug.h>
+#include <linux/mutex.h>
 
 #include <asm/cpu_device_id.h>
 #include <asm/cpuid/api.h>
@@ -810,7 +812,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
@@ -826,6 +828,25 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
+
+	if (!r->mon_capable)
+		return;
+
+	intel_aet_unmount();
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
@@ -1198,8 +1219,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 407c9aba5eea..65b70cc8d0a5 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpumask.h>
@@ -25,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -308,7 +310,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -317,14 +319,14 @@ bool intel_aet_get_events(void)
 
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
 
@@ -340,10 +342,22 @@ void __init intel_aet_init(void)
 		(*peg)->num_rmid = min(max_rmid, (*peg)->num_rmid);
 }
 
+/*
+ * Defend against races between module load/unload of the pmt_telemetry
+ * module and mount/unmount of the resctrl file system.
+ */
+static DEFINE_MUTEX(aet_register_lock);
+
+/*
+ * Track whether pmt_telemetry enumeration succeeded during mount for use during unmount.
+ */
+static bool pmt_in_use;
+
 void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p))
 {
+	guard(mutex)(&aet_register_lock);
 	get_feature = get;
 	put_feature = put;
 	pmt_module = module;
@@ -352,22 +366,55 @@ EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
 
 void intel_aet_unregister_enumeration(void)
 {
+	guard(mutex)(&aet_register_lock);
 	pmt_module = NULL;
 	get_feature = NULL;
 	put_feature = NULL;
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
-void __exit intel_aet_exit(void)
+bool intel_aet_pre_mount(void)
 {
+	guard(mutex)(&aet_register_lock);
+
+	if (!get_feature || !put_feature)
+		return false;
+
+	if (!try_module_get(pmt_module))
+		return false;
+
+	if (!aet_get_events()) {
+		module_put(pmt_module);
+		return false;
+	}
+
+	pmt_in_use = true;
+
+	return true;
+}
+
+void intel_aet_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
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
+			for (int i = 0; i < e->num_events; i++)
+				resctrl_disable_mon_event(e->evts[i].id);
+			put_feature(e->pfg);
+			e->pfg = NULL;
 		}
 	}
+	module_put(pmt_module);
+	pmt_in_use = false;
+	r->mon.num_rmid = 0;
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
2.55.0

