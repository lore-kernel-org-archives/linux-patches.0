Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C565956C63E
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600438; cv=none; b=k4x6hsYI6w9iRsnjMWUYURFiWhk8WiZVexRW4QC+Y/5zw8njLzSMCe7WrCPpOVAkpb881hclGsmFflMecGbwo+l8V2eC0Vabp4rdpHMy02VDIyas8rX+9KlvzuVSS0tDl0OQHsniDec4wTIcJrBf7vsRIGErDcWt8PGhwdMC+Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600438; c=relaxed/simple;
	bh=hTr11v7wHlQ5Hv/kNGVDfeuTKIxCaC8hCsKMiFNheOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh3741Unp9fBcRgNiaXpSft/VUPDeSrsViC9wsimuqEP78tcywTfGRyR0ObaP3yC883UmVQ10EC+4e3JgOPHeM4wi3orYvpg66dC4rsheHRYKFgLXqQPg2f4rq7J7EqJ4Nqzrc4lceC+pD4ZtaBDNf/5XDkDyVLQDK2Jo+mvXco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FuvbRf4s; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FuvbRf4s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600436; x=1821136436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTr11v7wHlQ5Hv/kNGVDfeuTKIxCaC8hCsKMiFNheOQ=;
  b=FuvbRf4s5akGcHLTJ6roQXrULHCmbEozCf3DNHa1jszcv1lqfKWALLew
   yFZPRbK54m3bMOcF49MZTshcICIvuxdp3F+0fFqqUWFUhlNqz8X7/WOVx
   zbP9tGKdUY9nRn5/JK50Dapiw+5HjHOH44TlsXhXQc+3Vi+Iu/Sk8cC7z
   fjM/ma5sXHpeMxJjbLALaAbf9loOdXKMNl3AOOdNn7U7RGt+Jz1TVLP9i
   gwlCOZxjcq5kt7NZeSyB1Z/pQ1mja2YjeHuOq6BW2BsEDiyyKEOSHq2u5
   NDmqhze6CZeRW/Y7ArUWXmF4WZB/8zyf1jubCEjsuo4P7Q5FRCiO6a9g7
   A==;
X-CSE-ConnectionGUID: IFxWYxViS72J3UV2hCq9pA==
X-CSE-MsgGUID: j+TdJGscSSukJ6KJsToCUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861540"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861540"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:41 -0700
X-CSE-ConnectionGUID: NKId3sCRR6Kn2XU+lB1PBw==
X-CSE-MsgGUID: L3XQfS0IQBizwhh6dsrPbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231508"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:41 -0700
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
Subject: [PATCH v12 24/25] x86/resctrl: Simplify Kconfig options for resctrl
Date: Wed, 16 Sep 2026 16:13:19 -0700
Message-ID: <20260916231320.14502-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
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

Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # [1]
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Added [] around "1" in Link tag.
	In resctrl Makefile add intel_aet.o to ctrlmondata.o line.
	Rewrite commit using imperative.
---
 include/linux/intel_vsec.h             |  4 ++--
 arch/x86/kernel/cpu/resctrl/internal.h | 13 -------------
 arch/x86/Kconfig                       | 13 -------------
 arch/x86/kernel/cpu/resctrl/Makefile   |  3 +--
 4 files changed, 3 insertions(+), 30 deletions(-)

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
index 5e71dd758624..93d36fa8c638 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -233,24 +233,11 @@ bool rdt_cpu_has(int flag);
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

