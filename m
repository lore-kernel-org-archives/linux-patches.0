Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC843932C4
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346097; cv=none; b=Nr0F/1YYdmYtNx4dQTnoy7qLGX+/NEdYnmTjnBvzllkGSLOamI52AtIFHT1CBb3Fv6giI+KLupJUzpzAw4H5kw6jDHcze0QsXUGGLBh1acc3O4SLGXh5l1nk3NlYvJvLSjur+Abqrj7dI8UUnYpxDCE//jakxxnuMgyzt4sYe88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346097; c=relaxed/simple;
	bh=sceXbE/Qw2wlrLV2qqCUKveYZ6M2mqFHZR3faypK7vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV6RGyBbwITwwDfsvkPWSERG4993TU3L8uZ20ZyP6YMORaQIcIIYr8FBA6Acvqmwb0S+Xz6mkqZeA8IYKxs4N11Brp/FyDv0oJPKGnY3sv0Hp4PWpXey6ft0qrgVsB7TbiRTZYJW7aI74L8l+KMzJDE/R8CYQsOHU1FAp/s6Ab0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gQCWG03s; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gQCWG03s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346094; x=1816882094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sceXbE/Qw2wlrLV2qqCUKveYZ6M2mqFHZR3faypK7vk=;
  b=gQCWG03sSOp/QFf04lDxcMgaxwm0dfnhiyOizSL90TwXVmn0HHeZXRr9
   6PsPHyckV5+BhID2/3c1JEey6NMnQX+5+xHkzZibZe5CyUjGarUcpGVYm
   3F9tYTe+ZxDWqD5Q0fKLWy/6U1MAyvw2DJWIsHUv/VgzFPpuScVkcIS8c
   96X1XHRdd3iWzdNqnrrvDAAlxs+syZEy7fAB5ny9W8X/me6a8T8Y1LX1i
   AIWOho0Asin7a/NoJCikAs4vwTxuNAmx1YmtOAlmb0Br+8hZBjCRuetfH
   3r2J8LpkW4WtoCFEprqhB8knbDRU6XssbhKgGi40r1krm7kCE99cnzs7Y
   w==;
X-CSE-ConnectionGUID: knue8xwPRI2o5Np/VAAF9Q==
X-CSE-MsgGUID: Lh5KEWxgScmMfiFon+jsbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473703"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473703"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
X-CSE-ConnectionGUID: sgWCigJ/SK+6GaJZpCj9Lw==
X-CSE-MsgGUID: GzFMNvPZQ2yFKmTKA21nXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024623"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
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
Subject: [PATCH v10 16/17] x86/resctrl: Simplify Kconfig options for resctrl
Date: Wed, 29 Jul 2026 10:27:51 -0700
Message-ID: <20260729172752.11561-17-tony.luck@intel.com>
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

Linus Torvalds complained[1] about Kconfig complexity making it too
hard for "random people to build their own kernels".

CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was
first added as it required other config options to be set to "built-in".

AET now resolves PMT symbols at runtime via the registration API,
so INTEL_PMT_TELEMETRY no longer needs to be built-in. This means
that AET can be included unconditionally as part of X86_CPU_RESCTRL.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # 1
---
v10:
	Dependency on X86_64 moved to separate patch

 include/linux/intel_vsec.h             |  4 ++--
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 arch/x86/Kconfig                       | 13 -------------
 arch/x86/kernel/cpu/resctrl/Makefile   |  2 +-
 4 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index 4da15ec03d20..64c30b2f3a6d 100644
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
 static inline void intel_aet_invalidate(u64 pkgmask) { }
-#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
+#endif /* CONFIG_X86_CPU_RESCTRL */
 
 #endif
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 099356e4328a..2215d257566e 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -233,7 +233,7 @@ void __init intel_rdt_mbm_apply_quirk(void);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
-#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+#ifdef CONFIG_X86_CPU_RESCTRL
 void __init intel_aet_init(void);
 bool intel_aet_pre_mount(void);
 void intel_aet_unmount(void);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6685e120cff3..ae6fb01e8865 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -535,19 +535,6 @@ config X86_CPU_RESCTRL
 
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
2.55.0

