Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16AE5038F4
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633753; cv=none; b=NqeMSj/moyYek9ui6M03gG+8sKlwq33oKOABW6bnKOMze9ePx15kY0dGiUV/EO1/mLIgiZxeDKeKDOJN6IT1Voo7F7AZEhUWTYLW5R75qpSp31f2Ul2pl/OcWqqyLs+KOJVaWhBRDXOvf1cOMwF8rZ0rg86A4DE76sYEVg3uhYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633753; c=relaxed/simple;
	bh=CrZns2872YAXZAGLZf8Ixtm78iyRWhipHBsf/gJfUR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXEaU/n3mX2HpdoeNvzP+3RkCPn55qLYiIFu1dt3Ckua8YUTF52yIqVaRVlCtTG5rqorsbh2VzECZlXjZ+tl242kA58uicnJ5Vwvc0TdPPzWOMb1VihY/cAY1HckKer6LGxWs8EbFumRkiSsTkJCHynVZMYOD21snyAmVzlmgTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpgLY+Bn; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpgLY+Bn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633750; x=1822169750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CrZns2872YAXZAGLZf8Ixtm78iyRWhipHBsf/gJfUR0=;
  b=bpgLY+BnWciHtx0HW70OOyK+Cnv0r6Fz7ql3ujA0aTfYBR1iixRkU2Sx
   Cbohc0d7GUsjcwiaZU42kk+zkWRAdv/NZrRw0lxUhiLEF1oRD/DW9bwyK
   hkO6I5O2fHf5k/y9pE6rlyg9L69GTX0oMAj1+tK45cTiwpIBux20Zpt/T
   PQcHEBchVFkQdRP0dVZ+ZMGJTsCbIRPXfECIC0mq+1r3vH12LRSTGJTyX
   xMuKQ3hvtloQcMm9I/F1uY8vVMbiLSkwonYFvmuhGLW8QwbrmjcGSIegK
   cAKTjOVVOrGQzCtZy7rSVT3AKWkByohsp3ErKQhzKELEW02nrQzX4AKbA
   g==;
X-CSE-ConnectionGUID: 8rsaqbSxSqWg8ergydiKwg==
X-CSE-MsgGUID: ihAMwzmeTwS/Jj9GQ76EGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387324"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387324"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
X-CSE-ConnectionGUID: jgSydQ6JTqCEHRIbxiYoLQ==
X-CSE-MsgGUID: 7ughns9VSpea1YYsElzxXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685525"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
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
Subject: [PATCH v13 18/25] x86/resctrl: Use registered function pointers for AET enumeration
Date: Mon, 28 Sep 2026 15:15:02 -0700
Message-ID: <20260928221509.68002-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pmt_telemetry driver registers enumeration functions with resctrl
Application Energy Telemetry (AET) code.

Use the function pointers instead of direct function calls in preparation
for the telemetry driver to be a loadable module.

The pmt_telemetry is forced to be built-in to the kernel, so it does not matter
at this point that there is no matching module_put() for the try_module_get()
in intel_aet_pre_mount(). This must be resolved with additions in the file
system unmount path before pmt_telemetry can be configured as a module.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Replace intel_pmt_put_feature_group() call in intel_aet_exit()
	with call via registered function pointer.

	Explain in commit comment that pmt_telemetry is built-in so the
	try_module_get() is a no-op.
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 +--
 arch/x86/kernel/cpu/resctrl/core.c      |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 37 ++++++++++++++++++++++---
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index c038b7d80ce3..8406addc05f5 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+bool intel_aet_pre_mount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline bool intel_aet_pre_mount(void) { return false; }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0262174df7ad..ac67b4523b2d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -795,7 +795,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 6c4f0bf3b876..fbe0a8761bb9 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpumask.h>
@@ -25,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -293,6 +295,13 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+/*
+ * Protects pmt_module, get_feature, put_feature against races between module
+ * load/unload of the pmt_telemetry module and mount/unmount of the resctrl
+ * file system.
+ */
+static DEFINE_MUTEX(aet_register_lock);
+
 static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
@@ -308,7 +317,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -317,14 +326,14 @@ bool intel_aet_get_events(void)
 
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
-		p = intel_pmt_get_regions_by_feature(pfid);
+		p = get_feature(pfid);
 		if (IS_ERR_OR_NULL(p))
 			continue;
 		if (enable_events(*peg, p)) {
 			(*peg)->pfg = p;
 			ret = true;
 		} else {
-			intel_pmt_put_feature_group(p);
+			put_feature(p);
 		}
 	}
 
@@ -335,6 +344,7 @@ void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p))
 {
+	guard(mutex)(&aet_register_lock);
 	get_feature = get;
 	put_feature = put;
 	pmt_module = module;
@@ -343,19 +353,38 @@ EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
 
 void intel_aet_unregister_enumeration(void)
 {
+	guard(mutex)(&aet_register_lock);
 	pmt_module = NULL;
 	get_feature = NULL;
 	put_feature = NULL;
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
+bool intel_aet_pre_mount(void)
+{
+	guard(mutex)(&aet_register_lock);
+
+	if (!get_feature || !put_feature)
+		return false;
+
+	if (!try_module_get(pmt_module))
+		return false;
+
+	if (!aet_get_events()) {
+		module_put(pmt_module);
+		return false;
+	}
+
+	return true;
+}
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
 
 	for_each_event_group(peg) {
 		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
+			put_feature((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
 	}
-- 
2.55.0

