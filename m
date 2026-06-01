Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666183C1418
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343817; cv=none; b=NH4ZTFI0kmOQCPhxMLMstiQM1y5dwewcRyDdhFgnU58QanuPrCwtYpk2Kh+JxSFqxzJADLV4/UQqzKlgUXMm/euhkxddgCNNuhCBtZ4TEFsTVEVFFyS+lgzoTa4QyPIv13BaAxzXUoy5JZwxCz/nl8gUkmIg1ADyYhHpVItirtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343817; c=relaxed/simple;
	bh=aEK4q/sy4C3crg0Z5RSKSZ4FT1n1WD1XBObWZJvjRjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/UNpsR+nBd6mxEMaFfBT8M8+YgZzFqnshsK2BTco50PJMMpvIVnlZaRgjae/0RA8UpqqfW3RUZzIDyRICSJ5iIRDBcxz5liICXP3WXdYmrJXDB+a9C+/O91yExUxDE5Dd146LljKuW9bO+8RkKyRqqfZ4xKJGaSGouUWydCH50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IHnKtBwC; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IHnKtBwC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343816; x=1811879816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aEK4q/sy4C3crg0Z5RSKSZ4FT1n1WD1XBObWZJvjRjw=;
  b=IHnKtBwC+lCmcwUNT58abKCm5+YSfR9ae2pWvkSQvtM6/YXUG7esHCEU
   IrLaWYdPual+j3ZV/6GK4E5EGM/kaXa3mrAfccZ7hBhj/F8f1AVm5KZvu
   TGGEzSvrCWO0lxyobKHRG0xRGV87czkJIw6feV+roll/JxYRLsrtUCMhg
   zVU+VqG82yy1t+aDgs8/GXFMZ4dlAa+/thrND2/e+9CLHFsr/Syfe6f/Y
   nFmbaK+PhatNTRU4nw6xH2e3rRr03k5glDg0IfoPXpaeeEw+Qrby16PKS
   ZGSz2Ezr518LwGd2s5FflRRD5NrsoKqOW54jAcVZpcRfFrz8XszcQEXGk
   Q==;
X-CSE-ConnectionGUID: F9ZzOaADR2GomP9aeGHhmg==
X-CSE-MsgGUID: 1hL7v/r2ShqbhEKJxilJ2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011652"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011652"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:44 -0700
X-CSE-ConnectionGUID: 9F4AyOoUQE6+vppDgEqG3Q==
X-CSE-MsgGUID: BL9XtWbPSUKrOxUSupA4bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946526"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:43 -0700
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
Subject: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
Date: Mon,  1 Jun 2026 12:56:29 -0700
Message-ID: <20260601195632.15876-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
logically independent and should be loadable modules.  Switch AET to use
the function-pointer registration API (introduced in the preceding patch)
instead of direct link-time references to PMT symbols.

Prepare for the file system to call resctrl_arch_pre_mount() on every mount
by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
the filesystem is not mounted.

Remove intel_aet_exit because all cleanup now happens in the unmount path.

Note that the Linux file system code does not serialize calls to
fs_context_operations::get_tree(), so there may be arbitrarily many
parallel calls if users invoke mount(2) multiple times.

Add locking and state (resctrl_arch_mount_entries) to avoid repeated
enumeration on nested mount requests from file system code (which will be
failed with -EBUSY status).

event_group::num_rmid may be reset (reduced) during enumeration. This is
not worth resetting on unmount because the same reduction would occur on
each subsequent mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  3 ++
 arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++--
 arch/x86/kernel/cpu/resctrl/core.c      | 41 +++++++++++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 52 ++++++++++++++++++++++---
 drivers/resctrl/mpam_resctrl.c          |  4 ++
 5 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 3705f0214fa6..9534d42e0c57 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -557,6 +557,9 @@ void resctrl_offline_cpu(unsigned int cpu);
  */
 void resctrl_arch_pre_mount(void);
 
+/* Called to report unmount. */
+void resctrl_arch_unmount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 3b09cfe9a046..017a19143ec9 100644
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
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 934492c7e643..9336299b9647 100644
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
 #include <asm/msr.h>
@@ -776,12 +778,20 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+static DEFINE_MUTEX(resctrl_arch_mount_lock);
+static int resctrl_arch_mount_entries;
+
 void resctrl_arch_pre_mount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	guard(mutex)(&resctrl_arch_mount_lock);
+
+	if (++resctrl_arch_mount_entries > 1)
+		return;
+
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
@@ -798,6 +808,33 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
+
+	guard(mutex)(&resctrl_arch_mount_lock);
+
+	if (--resctrl_arch_mount_entries > 0)
+		return;
+
+	WARN_ON(resctrl_arch_mount_entries < 0);
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
+	rdt_mon_feature_count--;
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
@@ -1174,8 +1211,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index db671725acbb..74c34593876b 100644
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
@@ -308,7 +308,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -317,14 +317,14 @@ bool intel_aet_get_events(void)
 
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
 
@@ -353,16 +353,56 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
-void __exit intel_aet_exit(void)
+/*
+ * The pmt_telemetry module may not be loaded when the resctrl file system
+ * is mounted. Keep track of whether a hold was placed on the module to know
+ * whether to release it during unmount.
+ */
+static bool have_pmt_hold;
+
+bool intel_aet_pre_mount(void)
+{
+	bool ret;
+
+	guard(mutex)(&aet_register_lock);
+	if (!get_feature || !put_feature)
+		return false;
+
+	if (pmt_module) {
+		if (!try_module_get(pmt_module))
+			return false;
+		have_pmt_hold = true;
+	}
+
+	ret = aet_get_events();
+
+	if (!ret && pmt_module && have_pmt_hold) {
+		module_put(pmt_module);
+		have_pmt_hold = false;
+	}
+
+	return ret;
+}
+
+void intel_aet_unmount(void)
 {
 	struct event_group **peg;
 
+	guard(mutex)(&aet_register_lock);
 	for_each_event_group(peg) {
 		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
+			struct event_group *e = *peg;
+
+			for (int j = 0; j < e->num_events; j++)
+				resctrl_disable_mon_event(e->evts[j].id);
+			put_feature((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
 	}
+	if (have_pmt_hold && pmt_module) {
+		module_put(pmt_module);
+		have_pmt_hold = false;
+	}
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

