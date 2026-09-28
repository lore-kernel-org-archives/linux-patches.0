Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDEC503BF5
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633757; cv=none; b=OmPlB4JvuDTpYg/dPaSEenYqLXuRWmtCmgutWH9ywf7an9VcuR3Zx//iKycVD9ZsBOL4RW86/agzrVhM7fpWyaYpoWeu7SYa3cl/yLyKbgQMQ6fljb9y+uEcs6bmIvTzvuJDh6TXHSWtbw1487GTc3UiBrCTuRugw+93RkpT3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633757; c=relaxed/simple;
	bh=4IctVXL1E+kMZwc5PF4TxRNIonBxCY1QyX2L9Q7T0NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh9xAKqinVpSGToOVOs4rCOI99zMDCLmAIyG8wwjG2jF7B92DqBCDbtiQ/HORMqFYbWdgR1/qmMDvsSF9yuo2IiQ8GdzjbVrTR69TGIDCVNygrKtlZfOgem8EVsQ/OjqTbc1185Qcd2uBkse5tzTAUPQYZh+SySAiXfPcLEgAZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=On8KKsWV; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="On8KKsWV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633755; x=1822169755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4IctVXL1E+kMZwc5PF4TxRNIonBxCY1QyX2L9Q7T0NM=;
  b=On8KKsWV+D8NqhMvQU9u1cOYs5CfrP4X2OMPONYCMAfbh1rXtKYqnEvs
   pUDYuAzQ7Dw+NFGfZ5Il/6FKiEANoiB2/mhEPQpnZhiCEEKLUdX5fuXX5
   9eOf7U3HwvehW5J06RVKBOZDpkVphCmhIBluN2UlBYQCzvyNw2QTFJy3p
   o+RSGE2N0nx7BRcla2FR84lREFlpd/DKdQr4+lmCwcFJuMklSaehKAhGu
   QNkPfHE638LnYLTYyOIgqyiLSWWkV43Eb2+0ZVnswPOSSgREYbR236YYZ
   hC8oQ7y3BSX7MQl74K4/bkoSYBEQEH6BU1vx++M0O4z2LPydR6goU8C/p
   Q==;
X-CSE-ConnectionGUID: KB+9oRj1RnSxDMZgOCedxg==
X-CSE-MsgGUID: 1GPjaka2SjKXwcLukd9PtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387380"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387380"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:21 -0700
X-CSE-ConnectionGUID: 3tBJ1BwRRcGQV1Ayz5UqUQ==
X-CSE-MsgGUID: L9NYwh1vRWarA3kPqkixAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685550"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
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
Subject: [PATCH v13 24/25] x86/resctrl: Simplify Kconfig options for resctrl
Date: Mon, 28 Sep 2026 15:15:08 -0700
Message-ID: <20260928221509.68002-25-tony.luck@intel.com>
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

Linus Torvalds complained[1] about Kconfig complexity making it too
hard for "random people to build their own kernels".

CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was first
added as it required other config options to be set to "built-in".  There is
no longer a requirement that INTEL_PMT_TELEMETRY or INTEL_TPMI be built-in.

Drop CONFIG_X86_CPU_RESCTRL_INTEL_AET and unconditionally include
AET (Application Energy Telemetry) as part of X86_CPU_RESCTRL.

Now that AET is unconditionally part of x86 resctrl the "intel_"
prefix on these function names is no longer appropriate. Switch
to "rdt_" to match other names in "internal.h":

intel_aet_pre_mount()		-> rdt_aet_pre_mount()
intel_aet_unmount()		-> rdt_aet_unmount()
intel_aet_read_event()		-> rdt_aet_read_event()
intel_aet_mon_domain_setup()	-> rdt_aet_mon_domain_setup()
intel_handle_aet_option()	-> rdt_handle_aet_option()

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # [1]
---
v13:
	Re-order tags.
	Swap "intel_" prefix to "rdt_".
---
 include/linux/intel_vsec.h              |  4 ++--
 arch/x86/kernel/cpu/resctrl/internal.h  | 23 +++++------------------
 arch/x86/kernel/cpu/resctrl/core.c      |  8 ++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 12 ++++++------
 arch/x86/kernel/cpu/resctrl/monitor.c   |  2 +-
 arch/x86/Kconfig                        | 13 -------------
 arch/x86/kernel/cpu/resctrl/Makefile    |  3 +--
 7 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index bcbf4937c71c..885f8e3ab057 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -257,7 +257,7 @@ static inline void
 intel_pmt_put_feature_group(struct pmt_feature_group *feature_group) {}
 #endif
 
-#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+#ifdef CONFIG_X86_CPU_RESCTRL
 void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p));
@@ -269,6 +269,6 @@ static inline void intel_aet_register_enumeration(struct module *module,
 						  void (*put)(struct pmt_feature_group *p)) { }
 static inline void intel_aet_unregister_enumeration(void) { }
 static inline void intel_aet_invalidate(u8 package_id) { }
-#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
+#endif /* CONFIG_X86_CPU_RESCTRL */
 
 #endif
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 1f080aad1b67..2a987cfc4b1b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -235,24 +235,11 @@ bool rdt_cpu_has(int flag);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
-#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_pre_mount(void);
-void intel_aet_unmount(void);
-int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
-void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+bool rdt_aet_pre_mount(void);
+void rdt_aet_unmount(void);
+int rdt_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
+void rdt_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
-bool intel_handle_aet_option(bool force_off, char *tok);
-#else
-static inline bool intel_aet_pre_mount(void) { return false; }
-static inline void intel_aet_unmount(void) { }
-static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
-{
-	return -EINVAL;
-}
-
-static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
-					      struct list_head *add_pos) { }
-static inline bool intel_handle_aet_option(bool force_off, char *tok) { return false; }
-#endif
+bool rdt_handle_aet_option(bool force_off, char *tok);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 689b9e31fe7a..78cb1e8cd747 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -616,7 +616,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 		break;
 	case RDT_RESOURCE_PERF_PKG:
 		if (!hdr)
-			intel_aet_mon_domain_setup(cpu, id, r, add_pos);
+			rdt_aet_mon_domain_setup(cpu, id, r, add_pos);
 		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
@@ -795,7 +795,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_pre_mount())
+	if (!rdt_aet_pre_mount())
 		return;
 
 	/*
@@ -819,7 +819,7 @@ void resctrl_arch_unmount(void)
 	if (!r->mon_capable)
 		return;
 
-	intel_aet_unmount();
+	rdt_aet_unmount();
 
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
@@ -885,7 +885,7 @@ static int __init set_rdt_options(char *str)
 		force_off = *tok == '!';
 		if (force_off)
 			tok++;
-		if (intel_handle_aet_option(force_off, tok))
+		if (rdt_handle_aet_option(force_off, tok))
 			continue;
 		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
 			if (strcmp(tok, o->name) == 0) {
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 59066e1c6333..5dd47b65823b 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -139,7 +139,7 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
-bool intel_handle_aet_option(bool force_off, char *tok)
+bool rdt_handle_aet_option(bool force_off, char *tok)
 {
 	struct event_group **peg;
 	bool ret = false;
@@ -194,7 +194,7 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
 		if (skip_telem_region(&p->regions[i], e)) {
 			/*
 			 * Clear the address field of regions that did not pass the checks in
-			 * skip_telem_region() so they will not be used by intel_aet_read_event().
+			 * skip_telem_region() so they will not be used by rdt_aet_read_event().
 			 * This is safe to do because intel_pmt_get_regions_by_feature() allocates
 			 * a new pmt_feature_group structure to return to each caller and only makes
 			 * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
@@ -398,7 +398,7 @@ void intel_aet_invalidate(u8 package_id)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
 
-bool intel_aet_pre_mount(void)
+bool rdt_aet_pre_mount(void)
 {
 	guard(mutex)(&aet_register_lock);
 
@@ -418,7 +418,7 @@ bool intel_aet_pre_mount(void)
 	return true;
 }
 
-void intel_aet_unmount(void)
+void rdt_aet_unmount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	struct event_group **peg;
@@ -452,7 +452,7 @@ void intel_aet_unmount(void)
  * the MMIO read indicates that data is not valid.  Return success if at
  * least one aggregator has valid data.
  */
-int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
+int rdt_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	struct pmt_event *pevt = arch_priv;
 	struct event_group *e;
@@ -492,7 +492,7 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	return valid ? 0 : -EINVAL;
 }
 
-void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+void rdt_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos)
 {
 	struct rdt_perf_pkg_mon_domain *d;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index bd45d72d1d05..0701ec3ef4e0 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -255,7 +255,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	resctrl_arch_rmid_read_context_check();
 
 	if (r->rid == RDT_RESOURCE_PERF_PKG)
-		return intel_aet_read_event(hdr->id, rmid, arch_priv, val);
+		return rdt_aet_read_event(hdr->id, rmid, arch_priv, val);
 
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 06b5d0c4633e..47f92613434e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -539,19 +539,6 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
-config X86_CPU_RESCTRL_INTEL_AET
-	bool "Intel Application Energy Telemetry"
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
-	help
-	  Enable per-RMID telemetry events in resctrl.
-
-	  Intel feature that collects per-RMID execution data
-	  about energy consumption, measure of frequency independent
-	  activity and other performance metrics. Data is aggregated
-	  per package.
-
-	  Say N if unsure.
-
 config X86_FRED
 	bool "Flexible Return and Event Delivery"
 	depends on X86_64
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 273ddfa30836..9daf1c0abb80 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
-obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
-obj-$(CONFIG_X86_CPU_RESCTRL_INTEL_AET)	+= intel_aet.o
+obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.55.0

