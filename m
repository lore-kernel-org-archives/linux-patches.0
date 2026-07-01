Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53023CF1F2
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941771; cv=none; b=H/H1YPlA8xZzwi4EtZtsD03g4VPENpxAOerUiuDqwNw/pcyOYdRMwF7JNzRjjRwpHqbA076MNlY6p2Ll9QBEDdI4YNmQiIPxYWDBX42jcjFafQ5FqGQMJtIN/OrFHqaBmI9fFyIvevpmvmLP3IHx/5RjSRAmXMOEGhwSwz1EaEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941771; c=relaxed/simple;
	bh=BT9NnKF8B8e46q9dyxqYBasEBbj6zNZciZIXExLHHPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1Kv/e/5Zoi7wtkC3dvVAY9T4VFmlQhw7M5oTs8j4fYF38PCgNkt2sOxLsO2Lnd81+fiJAheVQJUI2jPhFPKkqNpHPNKbIxb/ATGdUzBik0BBSw7eBuQOFdLbKarx7gX493yD8DsdTHPUPcDwHMLPO/Vv6FOyN2FihMdrIQoI+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKq+7/TY; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKq+7/TY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941770; x=1814477770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BT9NnKF8B8e46q9dyxqYBasEBbj6zNZciZIXExLHHPs=;
  b=oKq+7/TYuCYg3UtbfE0KNIxv5HTV7XBWQbxbzxNWYinT/MO4LNJ5ko1s
   IGTyZJxaMC772u1lma0NtPiWsDFRI581FGtn0zd401THmJHPH9o5DOvUv
   3JXwQ8HKvXgpzSE7QG4+HSEsxvRks1JuD+MxwKuQNk6TTk99de4ocqFEc
   tCejx8MOOaorwi/s6KRPIf+zp6558dQr0Tiw7opTLmKkFZ40kc6tfVJxJ
   nf3OfvE7+vyMbFXh+yTOjv9WAJZn/rdxuzjh5y9btACNBGvkiwCJ9bG7x
   EgRia77E/13kIe8rra0sL3jgcp9tpPrmxbIww0jfjgKRHjNN+DU1UDr83
   g==;
X-CSE-ConnectionGUID: SE7F+SQySVyV1Qc7eOP6wg==
X-CSE-MsgGUID: tnBW5mmDSVeFc+KVEP3v5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285841"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285841"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:06 -0700
X-CSE-ConnectionGUID: njNsginFR7e3dFCZb5u1Vg==
X-CSE-MsgGUID: JbeJT1CJQmCCNX1hBeGUcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242555"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:05 -0700
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
Subject: [PATCH v9 11/12] x86/resctrl: Simplify Kconfig options for resctrl
Date: Wed,  1 Jul 2026 14:35:52 -0700
Message-ID: <20260701213553.15222-12-tony.luck@intel.com>
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
index bdad90f210e4..ae6fb01e8865 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -514,7 +514,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
@@ -535,19 +535,6 @@ config X86_CPU_RESCTRL
 
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

