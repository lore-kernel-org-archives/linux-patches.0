Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4A43438AA
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547919; cv=none; b=mWmsbjonUv+45N492W5df5hXClVTCoPlb49R8peNom4upFT4D4jOGoZ1M5jU4bNhj6+z6ARrlT/epgLpX0PtVzOEowyaunssZOf0Lpv9VmXnHN4hxl4l5AlMRfMM8p8awIk4dBQ3drQUZ74EFFPRzgDpwIBcnRakNJfwlj2goZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547919; c=relaxed/simple;
	bh=pAWWzaipgrPxB0ZOrNRgiTDc9Pva08qS32lA3iAp3IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFFubjPBFzGlWq0POHpd2b03GfFPWaX/agELCO/aTYQZgcDKP/ziDFLZDmPWFjBD1zhdf/IMyLHm0jHR/uvr76czlMlAcKiilgvsM2EL/8Gu4Ulh4xSMoIsySWM0NdRQWgmWusYwc5nkqOKN+PvrZTRbliGHIyudiWqAQQYiVrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fYOlzoUH; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fYOlzoUH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547918; x=1813083918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pAWWzaipgrPxB0ZOrNRgiTDc9Pva08qS32lA3iAp3IQ=;
  b=fYOlzoUHa3jwC8hQKX11m5J03YjjDWaD0mjJePtp4g2dImYX3cYAE/cC
   JP3yms5Af4IBNHJk453lVWtFuf/hkqgrBWPmHr+5w06Z5TIs9wDxiBano
   jKXUHz1pGmNDrNvsQpWPS6l3bwKFCYEFnSo55NgAP0b4fJaAG87ztyPSh
   LxALuXECbMesQtJ7S/qSJyIMDJ3qgKPq/LHHPkLaook4eeuw0AoR9fhzu
   4TOWnM1UHKmC06scuM763yQJrD9AIuzwsfLRL40CHi6ZDKMRHCE3ZGT6p
   x/vhWg0LiiaFf84eIz19UgLxswmOWVgDLU5oPxnY3JV43P6xmed1/Gu50
   A==;
X-CSE-ConnectionGUID: 9Q3ZI7s0Tny/jGDV6tgFUQ==
X-CSE-MsgGUID: 2Jih5NgxRBa12fYFORpLmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790057"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790057"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:13 -0700
X-CSE-ConnectionGUID: 49apt+lpSNOkDI7zVa+ddQ==
X-CSE-MsgGUID: EbOF2gP5RMK+j/EobIcamA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620664"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:12 -0700
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
Subject: [PATCH v8 15/16] x86/resctrl: Simplify Kconfig options for resctrl
Date: Mon, 15 Jun 2026 11:24:56 -0700
Message-ID: <20260615182457.14725-16-tony.luck@intel.com>
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

Linus Torvalds complained[1] about Kconfig complexity making it too
hard for "random people to build their own kernels".

CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was
first added as it required other config options to be set to "built-in".

AET now resolves PMT symbols at runtime via the registration API,
so INTEL_PMT_TELEMETRY no longer needs to be built-in. This means
that AET can be included unconditionally as part of X86_CPU_RESCTRL.

CONFIG_X86_CPU_RESCTRL now depends on X86_64 because reading telemetry
data needs readq().

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # 1
---
 arch/x86/include/asm/resctrl.h         |  7 -------
 arch/x86/kernel/cpu/resctrl/internal.h | 13 -------------
 arch/x86/Kconfig                       | 15 +--------------
 arch/x86/kernel/cpu/resctrl/Makefile   |  2 +-
 4 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 48ad55bcda66..abb0790e4a4e 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -191,17 +191,10 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
-#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p));
 void intel_aet_unregister_enumeration(void);
-#else
-static inline void intel_aet_register_enumeration(struct module *module,
-						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
-						  void (*put)(struct pmt_feature_group *p)) { }
-static inline void intel_aet_unregister_enumeration(void) { }
-#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
 
 #else
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index a891017f69ec..b50faedede47 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -233,25 +233,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
-#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_pre_mount(void);
 void intel_aet_unmount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
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
 
 #ifdef CONFIG_INTEL_PMT_TELEMETRY_MODULE
 static inline bool intel_aet_try_module_get(struct module *mod)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..77fd5529542a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -515,7 +515,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
@@ -536,19 +536,6 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
-config X86_CPU_RESCTRL_INTEL_AET
-	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
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
index 273ddfa30836..97ceb4e44dfa 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
-obj-$(CONFIG_X86_CPU_RESCTRL_INTEL_AET)	+= intel_aet.o
+obj-$(CONFIG_X86_CPU_RESCTRL)		+= intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.54.0

