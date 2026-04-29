Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3012341322B
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488569; cv=none; b=S7B/KJG9L828fkixtzve0+388jQ3bwgZ2uFh68zkofM22Oj70K5V4DdtmPUKANg5sqf1Ty1z6EdI16bL/XK5UdWxpK65nSgJlfsks9MjNwGRFlw+TUItBkpzagGhodbQM8TTMfv0iIl5I4jbI1jR5b3NwA1pLwcejqq9e6KqTNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488569; c=relaxed/simple;
	bh=gbzu/Tg6Qfnn/KJGxlI9TYfjD1D6N/Ew6k1PhVBRDT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqLnL1X9QwKUD373Eiq+zQXZPHM75WfUECeI+NlOxMr/hBcCd8jqjX/A9KZ926C1QtMvoX8+0jvpkibA7fmmF15V+n3bwQxMQR4GRsJ6s4ZnuYEJsv1mkxIoNUmwRw/P4T09KCFjYi/Ot14ERPpE8wlHjG1FyeSaulShvAJ57Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z9VeSSyf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z9VeSSyf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488564; x=1809024564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gbzu/Tg6Qfnn/KJGxlI9TYfjD1D6N/Ew6k1PhVBRDT0=;
  b=Z9VeSSyfMucBn3u05b+1qV7TU/NqMecrhPRicgJBaX2M5fchJP/oPBS9
   M3/cnp4t324zDQM6qVoYO07l7bEnuwG4ahCBXvywBmOfX2BgIsWFYwrZf
   L/PyzLD6E4jMcFIQhUYq8cGq9acDYIerT/RfWtZmy5iUqwt5t5xP7VyFl
   TzRaugh0ypcVhyXhHXyYxFNYV5ab5YExNuKqsiYEbTaSen8KXz1ySrNWn
   ul+kWMz9I6HKSvMFBl0GQQjjxjOhSf/cKz2CWdJOlHfdnVxOEpGUki+uy
   0p9kO38gtY+t/3yWpI4PfcescPfgLjM8ewCUtfqYgu60poZjILAHIOOne
   g==;
X-CSE-ConnectionGUID: Pfc7TBTBSZWWE9BJTmV+xQ==
X-CSE-MsgGUID: LfueajyZSRqw4D5EOxLzUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890766"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890766"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:09 -0700
X-CSE-ConnectionGUID: +3xF+w3QSBqKD1lSd2KSAA==
X-CSE-MsgGUID: ZQjy1OAPTAa6I59ol/zakg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238323048"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:09 -0700
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
Subject: [PATCH v6 09/10] x86/resctrl: Simplify Kconfig options for resctrl
Date: Wed, 29 Apr 2026 11:48:57 -0700
Message-ID: <20260429184858.36423-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429184858.36423-1-tony.luck@intel.com>
References: <20260429184858.36423-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus Torvalds complained[1] about Kconfig complexity making it too
hard for "random people to build their own kernels".

CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since
it was first added as it unnaturally required other config options
to be set to "built-in".

AET now resolves PMT symbols at runtime via the registration API,
so INTEL_PMT_TELEMETRY no longer needs to be built-in. This means
that AET can be included unconditionally as part of X86_CPU_RESCTRL.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # 1
---
 arch/x86/include/asm/resctrl.h         |  6 ------
 arch/x86/kernel/cpu/resctrl/internal.h | 13 -------------
 arch/x86/Kconfig                       | 16 ++--------------
 arch/x86/kernel/cpu/resctrl/Makefile   |  2 +-
 4 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 7c929b72098c..775b8edd891b 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -195,15 +195,9 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
-#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 void intel_aet_register_enumeration(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p));
 void intel_aet_unregister_enumeration(void);
-#else
-static inline void intel_aet_register_enumeration(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
-						  void (*put)(struct pmt_feature_group *p)) { }
-static inline void intel_aet_unregister_enumeration(void) { }
-#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
 
 #else
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 017a19143ec9..4a89f00aaa01 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -233,24 +233,11 @@ void __init intel_rdt_mbm_apply_quirk(void);
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
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..861985294547 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -515,8 +515,9 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
+	depends on (INTEL_PMT_TELEMETRY != n) || !CPU_SUP_INTEL
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
 	select RESCTRL_FS_PSEUDO_LOCK
@@ -536,19 +537,6 @@ config X86_CPU_RESCTRL
 
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
2.53.0

