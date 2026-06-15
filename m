Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0AE3438AA
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547917; cv=none; b=W4IimIJLCb10xcaYeBCF3ZwQL3J2EsvZEcYKIMjZMvU9FnuypUxj70HBgNkGTmAGtAEaCvW4idKzxF2u8SVTVzsezMXahN2MTOlsNsLAy/O151enJCst+ETsnsGr0PmAT4rMUaWQgUrd+OaCmFLuMu2KWQx47LTbpJSOHUyUjPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547917; c=relaxed/simple;
	bh=CTdMZ9ztIS52XlqYUMlXC+yz0GzvZLZHgwZikZ4Mj4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iElrkaPmaVAo7qdNASsRtLl0apVQXmo0ASpaCsrLOcRND7NCH01qUJh8Kqyig3rQEfyiK4ad1iQkmr83dqKcPAg6XLqLQYzlWeaOoeY1OPzdQ4JrtR7M9Cjrv84sa6V4cvxg4pOCoiZ+fEMeqw2W4pbGfNb3BOywFRkImr6hp4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WOAwd8aO; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WOAwd8aO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547916; x=1813083916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CTdMZ9ztIS52XlqYUMlXC+yz0GzvZLZHgwZikZ4Mj4A=;
  b=WOAwd8aOcdHCyVc6uvYLQ5P8uRbPtOtwdJzexlfJzVU7OZr/6iO+95Qq
   IIjGkkcR9lelPCqApJwrL99ZczK1c4QTYIjxa+jRyVybgHTkT+o3oZ2ck
   ns7a9vhTymOO+g81JJ1SIIYKj9aYhrWzZj/LJdcIN7UfZYEK0Y3PvaOrj
   cHdnfnhsB+uQbMw/tNM/63GMsSvOfADwPt7V7DwaeXpm+VVVHztTJHwtP
   NUSr6fxiFQBetgRFtS1qGKnwcznb60Cr8/usxpyuxkn5mplzqkttrDZZS
   64nu39M5GaMejfdA3SgfLoK+WXjy4ibyKTkMcW24EkTJPLYTfOy+laO14
   Q==;
X-CSE-ConnectionGUID: 51pgIUpbTGaIcWaOY8OULQ==
X-CSE-MsgGUID: RCSk5klsRGOa02KEIKBq2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790017"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790017"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:11 -0700
X-CSE-ConnectionGUID: itkrOfPPRYeDMu4QnPUEQA==
X-CSE-MsgGUID: MKkxin7qSAaZKlpY16dwTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620649"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:10 -0700
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
Subject: [PATCH v8 11/16] x86/resctrl: Add PMT registration API for AET enumeration callbacks
Date: Mon, 15 Jun 2026 11:24:52 -0700
Message-ID: <20260615182457.14725-12-tony.luck@intel.com>
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

resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
export, register/unregister functions so the PMT module can supply/clear
enumeration callback functions when loaded/unloaded.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v8:
	Add comment for what aet_register_lock will protect

 arch/x86/include/asm/resctrl.h          | 22 ++++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index a9f481b7a8ed..48ad55bcda66 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -4,6 +4,8 @@
 
 #ifdef CONFIG_X86_CPU_RESCTRL
 
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 #include <linux/resctrl_types.h>
@@ -189,11 +191,31 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
+#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+void intel_aet_register_enumeration(struct module *module,
+				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+				    void (*put)(struct pmt_feature_group *p));
+void intel_aet_unregister_enumeration(void);
 #else
+static inline void intel_aet_register_enumeration(struct module *module,
+						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+						  void (*put)(struct pmt_feature_group *p)) { }
+static inline void intel_aet_unregister_enumeration(void) { }
+#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
+
+#else
+
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
 
 static inline void resctrl_arch_sched_in(struct task_struct *tsk) {}
 static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
 
+static inline void intel_aet_register_enumeration(struct module *module,
+						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+						  void (*put)(struct pmt_feature_group *p)) { }
+static inline void intel_aet_unregister_enumeration(void) { }
+
 #endif /* CONFIG_X86_CPU_RESCTRL */
 
 #endif /* _ASM_X86_RESCTRL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 07e9d6d4959e..bc15cf37a7d0 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,17 +12,21 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/gfp_types.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -291,6 +295,10 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct module *pmt_module;
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -325,6 +333,32 @@ bool intel_aet_get_events(void)
 	return ret;
 }
 
+/*
+ * Defend against races between pmt_telemetry register/unregister and
+ * resctrl file system mount/unmount.
+ */
+static DEFINE_MUTEX(aet_register_lock);
+
+void intel_aet_register_enumeration(struct module *module,
+				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+				    void (*put)(struct pmt_feature_group *p))
+{
+	guard(mutex)(&aet_register_lock);
+	get_feature = get;
+	put_feature = put;
+	pmt_module = module;
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
+
+void intel_aet_unregister_enumeration(void)
+{
+	guard(mutex)(&aet_register_lock);
+	pmt_module = NULL;
+	get_feature = NULL;
+	put_feature = NULL;
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
-- 
2.54.0

