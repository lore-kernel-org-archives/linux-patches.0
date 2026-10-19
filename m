Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443073;
	b=eCW8735Ax4fYMRJTCknP15D4eKfR8YQ4MKwqQlrWEcGMvz5TmF6VpDHAwnQ+0qgECt4e
	 7HUlrVRZ0YE4TroDnQD81htcjIdFlXpjmOO5b2j74pgmGM4iT21/Ga4G3Hq3N+baVhbMj
	 Syjvy5eW6wIJQhmO/gB68DlV9tGeYwVVorXwk1ww2+FwU2zkd5JZj1hPP5cBH0kS+7iKh
	 y4ODQ7/ZxO5jZZh+Wkx7eanptfcCUHiS7TQ0rEYAjohbwfhxRxvP1MlKjvtVXoGmQN2G7
	 T4P+83XzPbxQqHWAzV3/9acWt082+0BLqUsGQUCZEO7CO2EsDKdNb8/7cIwA+13xpZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443073;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T5UGc5XRI9F+nGzBEUtFMSbfXeUyhqHAQe3h1/hRtdI=;
	b=hAJ0Sv/WS5Ha9ZNisE/u88it3bSXtlb/7Qun/5+L38Tfm8dZmfX/15N5R07VJvqBA/iR
	 AvxwKrW6Nxu2X4W6WOMsjLBOqWFS+W4OtZkEVL36gKDLusXokQsdlcZmuoCA4vDHryaDS
	 vRQfzSNFOUF7hIM7vlGlWSkWivMI4J89t7SjPwJc9fU0M/2E69OfIOMUbD3kNQ3KN0mX3
	 FHUBeBmeHpmpqSwUIZaD+HJmqzc+GOHhK5clpoDLKROwwLRI6xUSQdP1/C9koOcowNpiv
	 6s/gXIL5vxjMQMWKB9dUiVSbAIQHCjywkVkI2JEZlINbp5pzVDx4HdnZbBPXVVmJzhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kw2p7gn3;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0B360A4AEA
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:51:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B0B360A4AEA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kw2p7gn3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443072; x=1823979072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nBjAVOphmICmzaPcp22xu1pMTFFTD4HgbRSHVgNltJA=;
  b=Kw2p7gn3PO41EUGg3RkU33BS1apW7cUYvJevO1AXQlER0Q/9sKn5FX5l
   iw0tB0JPwyHBSDJP/lZOUzUuMzhTFNcfQ0y4aATHkc8lxTbkJNBY8LIye
   GdmhJpAqHZ6eWzHaTuSz/bGsp3bOrYlbTldgRgkY8ipAaKj4ONl4TLP84
   STfcPnhGo1lbfK7L9e+f9JNhPeK6+M6H2j06xELBTZyLQR96tADxAY2fg
   lMVCDhMyoYgVrvfXeUroCL5HxE6Ob8LPWwNxBeq8pvrw9Ikwx051xQCF0
   Jx8goYRue/ON+SioCx/JdW7cEF9XxivIJB+2ka01/KaXmpFlA7timD9p4
   w==;
X-CSE-ConnectionGUID: Yic1Ix8NRBOmPOPxPf9NaA==
X-CSE-MsgGUID: jPW2RogpT7GJiJlmMcxswA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131310"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131310"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
X-CSE-ConnectionGUID: K5esgNNaSpKebSCleSXYng==
X-CSE-MsgGUID: 4ZN31XhVRsmocjPCUOn1eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008710"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
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
Subject: [PATCH v14 23/24] x86/resctrl: Simplify Kconfig options for resctrl
Date: Mon, 19 Oct 2026 13:50:30 -0700
Message-ID: <20261019205031.16977-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Application Energy Telemetry (AET) support in resctrl is selected by
CONFIG_X86_CPU_RESCTRL_INTEL_AET, which requires the pmt_telemetry and
TPMI drivers to be built in. Kernels that build those drivers as modules,
as distributions commonly do, cannot enable AET, and enabling it forces
the drivers to be built in.

resctrl now obtains the telemetry enumeration functions from
pmt_telemetry when that module loads and enumerates AET on every mount,
so the built-in requirement is no longer needed. Keeping a separate
option with relaxed dependencies would still add to the Kconfig
complexity that Linus Torvalds objected to [1].

Drop CONFIG_X86_CPU_RESCTRL_INTEL_AET and always build AET support as
part of x86 resctrl. AET remains inactive unless the pmt_telemetry driver
registers with resctrl.

With AET no longer an optional Intel-specific component, rename its
x86-internal functions from the intel_ prefix to the rdt_ prefix used by
the other functions in internal.h. The functions exported to
pmt_telemetry keep their names.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # [1]
---
v14:
	New commit message.
---
 include/linux/intel_vsec.h              |  4 ++--
 arch/x86/kernel/cpu/resctrl/internal.h  | 25 ++++++-------------------
 arch/x86/kernel/cpu/resctrl/core.c      |  8 ++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 14 +++++++-------
 arch/x86/kernel/cpu/resctrl/monitor.c   |  2 +-
 arch/x86/Kconfig                        | 13 -------------
 arch/x86/kernel/cpu/resctrl/Makefile    |  3 +--
 7 files changed, 21 insertions(+), 48 deletions(-)

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
index 1f080aad1b67..10432f51949a 100644
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
-				struct list_head *add_pos);
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
+bool rdt_aet_pre_mount(void);
+void rdt_aet_unmount(void);
+int rdt_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
+void rdt_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+			      struct list_head *add_pos);
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
index 3facb852f22b..49e2caed6f45 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -173,7 +173,7 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
-bool intel_handle_aet_option(bool force_off, char *tok)
+bool rdt_handle_aet_option(bool force_off, char *tok)
 {
 	struct event_group **peg;
 	bool ret = false;
@@ -228,7 +228,7 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
 		if (skip_telem_region(&p->regions[i], e)) {
 			/*
 			 * Clear the address field of regions that did not pass the checks in
-			 * skip_telem_region() so they will not be used by intel_aet_read_event().
+			 * skip_telem_region() so they will not be used by rdt_aet_read_event().
 			 * This is safe to do because intel_pmt_get_regions_by_feature() allocates
 			 * a new pmt_feature_group structure to return to each caller and only makes
 			 * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
@@ -441,7 +441,7 @@ void intel_aet_invalidate(u8 package_id)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
 
-bool intel_aet_pre_mount(void)
+bool rdt_aet_pre_mount(void)
 {
 	struct pmt_feature_group *(*get)(enum pmt_feature_id id);
 	void (*put)(struct pmt_feature_group *p);
@@ -473,7 +473,7 @@ bool intel_aet_pre_mount(void)
 	return true;
 }
 
-void intel_aet_unmount(void)
+void rdt_aet_unmount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	struct event_group **peg;
@@ -506,7 +506,7 @@ void intel_aet_unmount(void)
  * the MMIO read indicates that data is not valid.  Return success if at
  * least one aggregator has valid data.
  */
-int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
+int rdt_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	struct pmt_event *pevt = arch_priv;
 	struct event_group *e;
@@ -546,8 +546,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	return valid ? 0 : -EINVAL;
 }
 
-void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
-				struct list_head *add_pos)
+void rdt_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
+			      struct list_head *add_pos)
 {
 	struct rdt_perf_pkg_mon_domain *d;
 	int err;
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
2.56.0

