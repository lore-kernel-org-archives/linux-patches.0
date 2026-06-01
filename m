Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C823DA5AA
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343819; cv=none; b=qOyKlWxxX0I273QWNE2UCHAwdNerGu1gR7aV8XpUsLbJsn6dLtCfQHWqOpmf65g1CdnQCyT/yTMOD0UDrrCxhZjJF9iUdawOuEeYZMtvwzteK1jmVsghqpmVuGPZqLHWnhBMpO8LMPBbYUVhjSAjw7cXKjy4ASHiN+GMiz/QpF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343819; c=relaxed/simple;
	bh=HaCy2UcOAtXgMRHDUcRnuReWIZTKPx2CtYe4rvcCsRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcQLndoSTFn+Gb3xoJgGK47PCyBS8zUOAyKsPC5CwzypV5dAbP6e/baiLYdReSnApLGMw1MVQpv/23+sQytf3IfBjvR0bwT5T9JS1N3vyVl7nV1qvBgfuh9mIcLzotYBTdV1xdTJGlpjmtovh6kJQLOzDIaz+FRJ6bpLIlqdqGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OYOyudDz; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OYOyudDz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343817; x=1811879817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HaCy2UcOAtXgMRHDUcRnuReWIZTKPx2CtYe4rvcCsRk=;
  b=OYOyudDz6ODwMjDpI2cqvNoj28xmUxTvtxxco+znySUYLBjr5qL3kAHS
   BbX/ZiwCFoKiun0nQ/po8BfZa2uEAkI5JWS85Mlr+poA7XbAfOoAFI+bq
   P5rX6CgEmQTCI28kyLkblkL1DWLBQBV63inST/AFQy8joLEOo4tFc9I4x
   ijLLWV4VzvL0ay5NqQ7M5VjQKP1vA1Rx2mIWoqIh57pSkhyC7419BcVoA
   shWyaMxxoZp1+5pvOsReplce0wX8kHlHshchIGu80nuF8Wm1MZ0E4jgH2
   7Dhb7HTJfITQq6dTJAlBs6MNXwzC4Ujom8I/yjG0hESILZA/3NsChlvsQ
   A==;
X-CSE-ConnectionGUID: vTSg2J4mTxG0bAduEHALLw==
X-CSE-MsgGUID: PuunwHchT0CJboxzxrHZ3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011670"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011670"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:45 -0700
X-CSE-ConnectionGUID: bSlny4kXTlGSDAGXigF5VA==
X-CSE-MsgGUID: j1VPjJdeTpWeF0tZDSuvPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946532"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:44 -0700
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
Subject: [PATCH v7 13/14] x86/resctrl: Simplify Kconfig options for resctrl
Date: Mon,  1 Jun 2026 12:56:31 -0700
Message-ID: <20260601195632.15876-14-tony.luck@intel.com>
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

Linus Torvalds complained[1] about Kconfig complexity making it too
hard for "random people to build their own kernels".

CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since
it was first added as it unnaturally required other config options
to be set to "built-in".

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
index c23d9c56a337..5a61d0b0955d 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -195,17 +195,10 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 
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

