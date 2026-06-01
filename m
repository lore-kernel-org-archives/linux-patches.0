Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06D33C063E
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343816; cv=none; b=Gd9aeKkY0GOBt46y/c6sS5ja8OQ0Y9BZdMPpijWc0dB2HJKaA0T0F73TVW6q+gb7UkJqgNPf0N/OifteezPecXLIQT/0jEQKHxzAEIE+klX4H9teSAiMBWh/OumViDRivUwhAHjz0MgBUKrzCuUExizKb3/H1no5z9SHk1XaRdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343816; c=relaxed/simple;
	bh=OSgWP4UuE9mXdfXnJ5+20fMkWBkqKVlxn+C7zA/elbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQxt7IH1qfY/3T4zbbnxZVSDL8ZTiWhUBPucHp7bRg0wXk2JZ1UeSGJRicswn2M9tinDItoCLNdiJ9Bn3uKVOZ8ejaLmMKEySl6zXeHzQNfEsxUWOhqwJEv6ueV71NJkWnQgE3YxVCXwOfBuTTn+WTO9XGW7Ji82lJ/SEhHOZA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EVjdjhsM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EVjdjhsM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343807; x=1811879807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSgWP4UuE9mXdfXnJ5+20fMkWBkqKVlxn+C7zA/elbE=;
  b=EVjdjhsMGs2hXxqS9BfZ7A9BS5AatgvhuzMnlIcIBtmo33FFWiNWL/gW
   7eowUYzuFeLq2iUXyzmzscXB8EVvFFKeatD5/0LOI/iK36BoctvLTPXdL
   n/anoikg+qWSx6OcLSLqNjp97vvbSAyqFHcx5BjvPM2T66CMZNtzgFP9h
   OQN8N4GQUbV/xWx1LhIR7YTrBqwoMoFlLbec33qYt8ffXyJL5xUxjXXcp
   6sLV0L16SZXVD33jqFpSpkEaOr37TMrv6a551npbEdg2GSB3OE9ntWKSM
   OZNyvawzMd/dziZ6rq+GOglPTlYByLOPoVYpkmerkB8hGErefrf6+Tv+o
   g==;
X-CSE-ConnectionGUID: D7o4ddU2SN2+s9NzCQpUbQ==
X-CSE-MsgGUID: RpR8+7BcQxahVOMT0PnkKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011634"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011634"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:44 -0700
X-CSE-ConnectionGUID: i4ZnBhQ+TkioMETWFmVQRA==
X-CSE-MsgGUID: qx6SYmdnQoyQDdFazmfhBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946519"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:42 -0700
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
Subject: [PATCH v7 09/14] x86/resctrl: Add PMT registration API for AET enumeration callbacks
Date: Mon,  1 Jun 2026 12:56:27 -0700
Message-ID: <20260601195632.15876-10-tony.luck@intel.com>
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

resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
export, register/unregister functions so the PMT module can supply/clear
enumeration callback functions when loaded/unloaded.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/resctrl.h          | 22 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 30 +++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 1e50c7dc3fe3..c23d9c56a337 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -4,6 +4,8 @@
 
 #ifdef CONFIG_X86_CPU_RESCTRL
 
+#include <linux/intel_pmt_features.h>
+#include <linux/intel_vsec.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 #include <linux/resctrl_types.h>
@@ -193,11 +195,31 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 
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
index e2af700bca04..db671725acbb 100644
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
@@ -289,6 +293,10 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct module *pmt_module;
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -323,6 +331,28 @@ bool intel_aet_get_events(void)
 	return ret;
 }
 
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

