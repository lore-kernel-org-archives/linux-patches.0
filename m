Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF225421F10
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488559; cv=none; b=RSFcHO9MmS5Vx1E7oa1pvSPOgMyuyZQ5B9nDhQJbdWzWxJgB0g62ks8i9gWCPxwX4gNY0Uggcxhq0AfKoMdkq8cE0fZ+BwxWmKLFFQrfJMijcxTCsoKYupIumn1jArLAZa19+uhlivue0cO/7tgCqbjpy1w56B7spDSfeKb/zrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488559; c=relaxed/simple;
	bh=rLOc77ldRdvLglDGNCsB9ndiaT8ZnPgCqg2WC/lIc0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muWXIsXMyz05NJl3+fBIQ/+pWsGrpvW9wCmLBYD06MzTyc2ZBmNe0BHwv38eVuyXZoaeqRCJ1EP1wLoYblKGDWXn8+1BCSPqA4Te62/o5tFpkcIwxlNhY7sdwpB2Q/GUHWVZUe2CyGshRdnVt2D2sjZx1iidlncTVNAuQlTmyqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KRO/Z6Vj; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KRO/Z6Vj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488556; x=1809024556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rLOc77ldRdvLglDGNCsB9ndiaT8ZnPgCqg2WC/lIc0w=;
  b=KRO/Z6VjeLcYKfBXc3D27zXT/StIjgqsJ9e4mW+Np+k9rHYe1fBSNiYE
   PB1LjGqm06v/rRBQdDWRZOV3W7iZaV+HrdaEHHBWuU4K+C+1oYIMAczcR
   gmiO+ZFUZU7OjJd6O15NTZ9exHLplSWIXo5rK7TWP49i5gDdUycgSu9X2
   zDr0dBVnHgHgiqnFzr4dPzRveC29w/TSeHvZBGONS7Y519HKLLfwVf5oP
   LpN52vCZDqHTAGPqdBy3dWUVHx0B8eWThSray4fV2G3XAKKXOmnux7uaU
   G/ofDqUbaZCcO2A4zW0DRF+Gch0/B1gdt1gWAi80WvVjjAqTwW5Yz1HzN
   Q==;
X-CSE-ConnectionGUID: D7AHA2o0QfaQa7uRBEIxlw==
X-CSE-MsgGUID: ZSzKDeaGSA6YRBtpnrcMnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890722"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890722"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:07 -0700
X-CSE-ConnectionGUID: ZnOoNTSWRNmglTbLjBW6xQ==
X-CSE-MsgGUID: xUIhFUB7Sce2NHHU8EdMWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238323014"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:07 -0700
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
Subject: [PATCH v6 05/10] x86/resctrl: x86/resctrl: Add PMT registration API for AET enumeration callbacks
Date: Wed, 29 Apr 2026 11:48:53 -0700
Message-ID: <20260429184858.36423-6-tony.luck@intel.com>
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
index 1e50c7dc3fe3..7c929b72098c 100644
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

