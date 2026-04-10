Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC68D38F931
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851544; cv=none; b=nfMB3ZguWcawcJJCXc6IcaUzb/X3uuYf3tFESAfVzH+iA08fB/ApwHZk6WnSZYUphFcB7iJ8icyPaeqLi7tHFZ9xsMK0iWU+PEh9gKvjo+C9QcBYNM/m/8+9c6JF4v8lPdomGRQH0M26YIPhN5U+3Ano7eAqLaYfQaje/aK3QN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851544; c=relaxed/simple;
	bh=5Y+Hl8XUznNXOIiGmrYMs3h89O8MnhL1SwAGZMoxg1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdOjC7X7AtaJsINvVpRCNYA26mf4VPs7D7CKhERf33A1qqkPTZi3CNTH5hPq8yhT4BVB+xdReZnYNIFBSZJ3NHZGTdBIMIpP4Dv2JDZfv4VSLN3kEHxTLRwSR4Q+/AGU0uAjQglp7A1o2jQugktJoXoUEKQO68he8v4n1aY1OIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Edsqseky; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Edsqseky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851542; x=1807387542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Y+Hl8XUznNXOIiGmrYMs3h89O8MnhL1SwAGZMoxg1s=;
  b=EdsqsekymdPEJj7LFX8aM+e0zDcbeJYDxBSicYJyWZPLXp3wV21TdsbU
   BI/TmgVXIrv4s8dbmR22QZH3ubEq7H/QxiGr5J1vjeBbpMOl73IdHnR06
   k7RAVH1e3ZZ1E2/RcuVArVZKJT1byoXZfBsGlSxcltMtqznptAj6ayosO
   yIhUIdNee6Lqm02RLq/LYyDwPXN4UMnrptAcPRNWeCDMTgMo5Ln2xjlS+
   VsZJtyzD0nBamqzJ8euh6h0jJxXhyXIuR2ystcMFYZT/WKAtzIcLVOhAT
   Mli+BHbIb3rTTAMmbARp1QlT5S6RWzV0FrX/7Uh27tiXTu3b/RN8vuRSD
   A==;
X-CSE-ConnectionGUID: +JmOUEYfQRWKAtbMJ7ZgoA==
X-CSE-MsgGUID: 7pbPptvpRSCpQZD661DObQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898080"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898080"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:40 -0700
X-CSE-ConnectionGUID: RH4q9cwOR7STZ+ICBVlgIQ==
X-CSE-MsgGUID: eYyWKV9SRk61n51Fu4KZgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155012"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:39 -0700
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
Subject: [RFC PATCH v5 3/7] x86/resctrl: x86/resctrl: Add PMT registration API for AET enumeration callbacks
Date: Fri, 10 Apr 2026 13:05:28 -0700
Message-ID: <20260410200532.58602-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410200532.58602-1-tony.luck@intel.com>
References: <20260410200532.58602-1-tony.luck@intel.com>
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
 arch/x86/include/asm/resctrl.h          | 19 ++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 35 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 575f8408a9e7..b5fa54c4637c 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -4,6 +4,8 @@
 
 #ifdef CONFIG_X86_CPU_RESCTRL
 
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 #include <linux/resctrl_types.h>
@@ -193,11 +195,28 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
+#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+void intel_aet_register_enumeration(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+				    void (*put)(struct pmt_feature_group *p));
+void intel_aet_unregister_enumeration(void);
 #else
+static inline void intel_aet_register_enumeration(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
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
 
+static inline void intel_aet_register_enumeration(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+						  void (*put)(struct pmt_feature_group *p)) { }
+static inline void intel_aet_unregister_enumeration(void) { }
+
 #endif /* CONFIG_X86_CPU_RESCTRL */
 
 #endif /* _ASM_X86_RESCTRL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index e2af700bca04..2b3677783427 100644
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
@@ -289,6 +293,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -323,6 +330,25 @@ bool intel_aet_get_events(void)
 	return ret;
 }
 
+static DEFINE_MUTEX(aet_register_lock);
+
+void intel_aet_register_enumeration(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+				    void (*put)(struct pmt_feature_group *p))
+{
+	guard(mutex)(&aet_register_lock);
+	get_feature = get;
+	put_feature = put;
+}
+EXPORT_SYMBOL_GPL(intel_aet_register_enumeration);
+
+void intel_aet_unregister_enumeration(void)
+{
+	guard(mutex)(&aet_register_lock);
+	get_feature = NULL;
+	put_feature = NULL;
+}
+EXPORT_SYMBOL_GPL(intel_aet_unregister_enumeration);
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
@@ -405,3 +431,12 @@ void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 		kfree(d);
 	}
 }
+
+static int __init intel_aet_init(void)
+{
+	request_module("pmt_telemetry");
+
+	return 0;
+}
+
+late_initcall(intel_aet_init);
-- 
2.53.0

