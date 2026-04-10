Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ABA3939BA
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851545; cv=none; b=XrjpA3zEeF5SjzJ/5Oqpc1taEs21DKUpjGBLWTIJG6M5pFLplO38bJqHknAd1EJEGSm8TwgDj4ad3Na8L20oSRWIF9IcqdmWtyFGV/xUvi0Si9atObsoSoxhiTqh0wzJOq+viU8qgAG3+0f2dXNI+MrCVaGMvD6QgFY7PJepBsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851545; c=relaxed/simple;
	bh=M6g8GJVRdCE1i9P5NJ/YxLzsYmvfhI0q9YyUKzFv3EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUHMW0JKD0jfB3vzM5FRiJ9qoV4Gt8sVJj0yEIK7AP81uN0GBTcrhqiWHnRYPe9SZuzQk0wkdCLsFC/c3B6cymMMUtZ1obfByKIhc78wpdf9xZVZ6dK5Tl3S9UWLWC6VkQWpd8pYQs1J2lkbqJWV8a/CV0CnD9F4Fwrgzx42Nqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B76EdYcR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B76EdYcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851544; x=1807387544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M6g8GJVRdCE1i9P5NJ/YxLzsYmvfhI0q9YyUKzFv3EQ=;
  b=B76EdYcRc/REWRVwB1/TiaOo5eiCxW0zezPRd1AsTsxpF7R37uSwIILJ
   bO2+jlEmiwpB6D2HTbnfv2YCWcE5XaxPFqb25CICREcLlDygkEaLau0XO
   fWvFBj32eAsfdhcgnS65i6cGyhISbaQheXhId2G1Ca7+y0uOeluvgmwSh
   bhSSjSKKUwJH8VnpbbmyMSlHKtBaZVNvoZwOU+PKFRM8ONhUO2ba2xP9p
   caatpJY7BCRopJH67KMxHB1OHg0cKaIOAx/zStB08Lb2LUTwnM6o/3cv6
   JJqtbmhP5IquKr8Rm0llId3f2dY/4UMtRNTG5dRpPLYcHsP+O2Sw8n/xE
   Q==;
X-CSE-ConnectionGUID: 9cEttLQqRXGJFqvFyAjEvQ==
X-CSE-MsgGUID: +t97IeakTFyvHx2zETpeEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898098"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898098"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:41 -0700
X-CSE-ConnectionGUID: 7whBBn+PRIaUclIuuJsfYg==
X-CSE-MsgGUID: q/nRp+ZyQ3mzDw+P0a3rOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155023"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:40 -0700
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
Subject: [RFC PATCH v5 5/7] x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
Date: Fri, 10 Apr 2026 13:05:30 -0700
Message-ID: <20260410200532.58602-6-tony.luck@intel.com>
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

resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
logically independent and should be loadable modules.  Switch AET to use
the function-pointer registration API (introduced in the preceding patch)
instead of direct link-time references to PMT symbols.

Move AET enumeration into resctrl_arch_pre_mount() and cleanup into
resctrl_arch_unmount() so the PMT module can be unloaded whenever the
filesystem is not mounted.  Because all cleanup now happens in the unmount
path, intel_aet_exit() is no longer needed and is removed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  3 +++
 arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++++----
 arch/x86/kernel/cpu/resctrl/core.c      | 23 +++++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 26 +++++++++++++++++++------
 4 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index a8338656f836..f3eb6dfa61d4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -556,6 +556,9 @@ void resctrl_offline_cpu(unsigned int cpu);
  */
 void resctrl_arch_pre_mount(void);
 
+/* Called to report unmount. */
+void resctrl_arch_unmount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..14b8e7fd66db 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
-void __exit intel_aet_exit(void);
+bool intel_aet_pre_mount(void);
+void intel_aet_unmount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
-static inline void __exit intel_aet_exit(void) { }
+static inline bool intel_aet_pre_mount(void) { return false; }
+static inline void intel_aet_unmount(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..94a055719ea2 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -769,7 +769,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
@@ -786,6 +786,25 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
+
+	intel_aet_unmount();
+
+	if (!r->mon_capable)
+		return;
+
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	for_each_online_cpu(cpu)
+		domain_remove_cpu_mon(cpu, r);
+	r->mon_capable = false;
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
@@ -1160,8 +1179,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 2b3677783427..6e7458a722f9 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -25,8 +25,8 @@
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
-#include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -307,7 +307,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -316,14 +316,14 @@ bool intel_aet_get_events(void)
 
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
 
@@ -349,13 +349,27 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_GPL(intel_aet_unregister_enumeration);
 
-void __exit intel_aet_exit(void)
+bool intel_aet_pre_mount(void)
+{
+	guard(mutex)(&aet_register_lock);
+	if (!get_feature || !put_feature)
+		return false;
+
+	return aet_get_events();
+}
+
+void intel_aet_unmount(void)
 {
 	struct event_group **peg;
 
+	guard(mutex)(&aet_register_lock);
 	for_each_event_group(peg) {
 		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
+			struct event_group *e = *peg;
+
+			for (int j = 0; j < e->num_events; j++)
+				resctrl_disable_mon_event(e->evts[j].id);
+			put_feature((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
 	}
-- 
2.53.0

