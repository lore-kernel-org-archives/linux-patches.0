Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B7630AD01
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394848; cv=none; b=pN8EOr4o+HMLl08f3oCH+wU52Zzt9qsdkjvc6AvUXw5f+9Fst6roqE/x+e7PoFnxxidve5TrgQ9ZtnVcwAexOJYWX9xXeCpjZmmKtCI2KBs0FQsmSVN4A04TS1ZGZAU/IaEUJZCP1efpMnCoKH/cGBc9WxhNiEwHzlGGWqZ7KT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394848; c=relaxed/simple;
	bh=NHBvqOjL4L+2puaa13tyvYc9tC0n/6VxwR6XMPl4ZWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8crABm02wSn9g+m+K4wrutWL4E+IgEL5hMWm9l1E3+rjMHUN6FBoENfsgap/1DqDmCOJio8P9imgsiebpQ29xvuT8Ra9LKxJM828EB1qLUoliROe5rScV0Rr6qqgsnBBH9w2k1aPeePwM3CrleETI51WizynCOQirVjjTYxmGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oAR6DbVV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oAR6DbVV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394847; x=1791930847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHBvqOjL4L+2puaa13tyvYc9tC0n/6VxwR6XMPl4ZWU=;
  b=oAR6DbVVWXFnwDJ7p9dBGRiVSn5XxNbCEnMHWduNz2vQ2NFJUyNkk5bd
   V7lNxyQe0s1LaITHcADGSv2f2CcvVj8QAdIYTLYc6OxylGcgJPMjPvi97
   VFD0Zxl4FiCxPo4Qhkb6w+4v4txzc///Dr8Pjdj1CiMsiXdxZRJLMjrn5
   A6Uzg8uI/vZmvQFkXX82oQB5y4r2e74P31QchUGZiDPF2wE+ZU4n9uKoi
   WYvtDCd/DpGLpF3kDT2wdQlouUGBfaHDjP4qD+OB9XTvFIPSQyQy1QYH7
   xeJCT9eAIn7KJVuIAnZLip3ta3lxK77a2NCBQA+jyanaZnBfPR2XRa5HR
   w==;
X-CSE-ConnectionGUID: ev9gzifESmGA+uAckc1fSw==
X-CSE-MsgGUID: /TSddf5ESEOi0Mgqn13Veg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168822"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168822"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:01 -0700
X-CSE-ConnectionGUID: +9pX6SP4ThGWuaq5cKcGhw==
X-CSE-MsgGUID: Hsv/icv0QLW2R3ogSH6ZHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145283"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v12 10/31] x86,fs/resctrl: Handle events that can be read from any CPU
Date: Mon, 13 Oct 2025 15:33:24 -0700
Message-ID: <20251013223348.103390-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that monitor events can only be read from a CPU in the
cpumask_t set of each domain.  This is true for x86 events accessed
with an MSR interface, but may not be true for other access methods such
as MMIO.

Introduce and use flag mon_evt::any_cpu, settable by architecture, that
indicates there are no restrictions on which CPU can read that event.

Refactor the CPU checking to avoid always calling smp_processor_id()
now that events can be read from preemptible context.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 +-
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c |  6 ++---
 fs/resctrl/ctrlmondata.c           |  6 +++++
 fs/resctrl/monitor.c               | 43 ++++++++++++++++++++++--------
 5 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 66569662efee..22edd8d131d8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -409,7 +409,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 12a2ab7e3c9b..40b76eaa33d0 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -61,6 +61,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  *			READS_TO_REMOTE_MEM) being tracked by @evtid.
  *			Only valid if @evtid is an MBM event.
  * @configurable:	true if the event is configurable
+ * @any_cpu:		true if the event can be read from any CPU
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -69,6 +70,7 @@ struct mon_evt {
 	char			*name;
 	u32			evt_cfg;
 	bool			configurable;
+	bool			any_cpu;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index a9fa506f09fa..1ee379014ef8 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -893,15 +893,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 77602563cb1f..fbf55e61445c 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -574,6 +574,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		}
 	}
 
+	if (evt->any_cpu) {
+		mon_event_count(rr);
+		goto out_ctx_free;
+	}
+
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
@@ -587,6 +592,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
+out_ctx_free:
 	if (rr->arch_mon_ctx)
 		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index c7f0af8a239e..7b7162c4f3f1 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -413,9 +413,33 @@ static void mbm_cntr_free(struct rdt_l3_mon_domain *d, int cntr_id)
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
+/*
+ * Called from preemptible context via a direct call of mon_event_count() for
+ * events that can be read on any CPU.
+ * Called from preemptible but non-migratable process context (mon_event_count()
+ * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
+ * smp_call_function_any()) for events that need to be read on a specific CPU.
+ */
+static bool cpu_on_correct_domain(struct rmid_read *rr)
+{
+	int cpu;
+
+	/* Any CPU is OK for this event */
+	if (rr->evt->any_cpu)
+		return true;
+
+	cpu = smp_processor_id();
+
+	/* Single domain. Must be on a CPU in that domain. */
+	if (rr->hdr)
+		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
+
+	/* Summing domains that share a cache, must be on a CPU for that cache. */
+	return cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map);
+}
+
 static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
-	int cpu = smp_processor_id();
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
 	struct rdt_l3_mon_domain *d;
@@ -424,6 +448,9 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	int err, ret;
 	u64 tval = 0;
 
+	if (!cpu_on_correct_domain(rr))
+		return -EINVAL;
+
 	if (rr->is_mbm_cntr) {
 		if (!rr->hdr || !domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
@@ -452,9 +479,6 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	}
 
 	if (rr->hdr) {
-		/* Reading a single domain, must be on a CPU in that domain. */
-		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
-			return -EINVAL;
 		if (rr->is_mbm_cntr)
 			rr->err = resctrl_arch_cntr_read(rr->r, rr->hdr, closid, rmid, cntr_id,
 							 rr->evt->evtid, &tval);
@@ -469,10 +493,6 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		return 0;
 	}
 
-	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
-		return -EINVAL;
-
 	/*
 	 * Legacy files must report the sum of an event across all
 	 * domains that share the same L3 cache instance.
@@ -961,7 +981,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
 		return;
@@ -970,6 +990,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 		return;
 	}
 
+	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].enabled = true;
 }
 
@@ -1795,9 +1816,9 @@ int resctrl_l3_mon_resource_init(void)
 
 	if (r->mon.mbm_cntr_assignable) {
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
 		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
 								   (READS_TO_LOCAL_MEM |
-- 
2.51.0

