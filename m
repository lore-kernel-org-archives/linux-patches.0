Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E243BD651
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941769; cv=none; b=Rm3ZbfP6FC/sw4NBOmfCD5W8oy7OGoJ0xyfJ8uOFWyTS0VqNcH1qTYtFQW4QCE73gkzO5BzvH6NDrNgCb6sEAfAyLtVJxpKSiQJIW08P4htkNChSM+DuzQ+aTlKIcKrOcsk03z/+fhjKG35iF8PjoloWNv4rRoC8f97IQ90eiTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941769; c=relaxed/simple;
	bh=F37m85hW8RG+a99sL0JXQH5ji6WJWLPmL4njF/Y2IX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA3UdtGXyZoKF/woNiKqe4BfMl2yCKNEJlLBA7gqfNI/Yc1WSiZT5dhYUlqKXsc+RAXE0Yh2ntNFQniontcxj8TvXU+EtN0J7sR2wJ09Aw83kGT8Vn6oeBck1y2CUm8PsoTsGrFXGyiqK2Z3LCOq96cJQQO/Q8rIsAt/PH5J6ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MoniiB+H; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MoniiB+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941768; x=1814477768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F37m85hW8RG+a99sL0JXQH5ji6WJWLPmL4njF/Y2IX8=;
  b=MoniiB+HECD1UWroLO2oGaEYZyKjjU2C/3Te4ECagMNPex26EC+JKLbH
   l7I+AZKrgxRBObfau2hqFI9tUvEfBn8uzGCt4zgD3XT3rLa/oe1qBg4gI
   H8kS/O/Aa1GHHhyJHdyxQRAu5ALZpm92b2JtA+w8OSVMrQZwQ7adv/1po
   QIRX+6U8YlBWjxhUbCXytS64G5pGMKx4Aw92HANavj3xjlhvzm10f6SfO
   4bOEbB3XrKumh16iFaaXZFI9Nu9QCoPHKAhgZN5PHz/HuOoLTVsXAm3uw
   xVdPt711BLfwq9fnCVsJQHrHzaxd4asASdQcqnCwEYrGIPDH91APTQXiZ
   A==;
X-CSE-ConnectionGUID: rO3CALlOT9imJIDhHSP3kg==
X-CSE-MsgGUID: s8JSneRYRXi5xQLSnBWBgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285823"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285823"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:05 -0700
X-CSE-ConnectionGUID: jcfBRf91R3m0JTtlsk2kmw==
X-CSE-MsgGUID: bmVoNay8Seil5NAfZn9Wyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242545"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:04 -0700
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
Subject: [PATCH v9 09/12] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
Date: Wed,  1 Jul 2026 14:35:50 -0700
Message-ID: <20260701213553.15222-10-tony.luck@intel.com>
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

Use "pmt_in_use" to detect nested mount attempts.

event_group::num_rmid may be reset (reduced) during enumeration. This is
not worth resetting on unmount because the same reduction would occur on
each subsequent mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
--
v9:
	Drop broken atomic ops introduced in v8
	Check pmt_in_use in intel_aet_pre_mount() to detect nested
	mount flow.
---
 include/linux/resctrl.h                 |  6 +++
 arch/x86/kernel/cpu/resctrl/internal.h  | 23 ++++++++--
 arch/x86/kernel/cpu/resctrl/core.c      | 25 +++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 +++++++++++++++++++++----
 drivers/resctrl/mpam_resctrl.c          |  4 ++
 5 files changed, 101 insertions(+), 15 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index e1501ee72d28..4dc41dc99dc2 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -564,6 +564,12 @@ void resctrl_offline_cpu(unsigned int cpu);
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
index 3169441a2d40..3ef620d8e0c8 100644
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
@@ -798,7 +800,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
@@ -814,6 +816,25 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
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
@@ -1187,8 +1208,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index c26bd813e057..c2e27ce52248 100644
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
 
@@ -359,16 +359,58 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
-void __exit intel_aet_exit(void)
+/*
+ * Track whether pmt_telemetry enumeration succeeded during mount to
+ * detect nested mount attempts and for use during unmount.
+ */
+static bool pmt_in_use;
+
+bool intel_aet_pre_mount(void)
+{
+	bool ret;
+
+	guard(mutex)(&aet_register_lock);
+
+	/* Nested mount attempt. File system code will return -EBUSY */
+	if (pmt_in_use)
+		return false;
+
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

