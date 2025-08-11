Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9D12E2DC9
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936263; cv=none; b=g34Z7UJj3CisT3kjvHyUEp3DceT1QHZL+l0Q3GW6dAm3JxAjI2ck3/Sc7aMDcmu0g7veL8eaLg9aOlVPF5dsoOwuFFb6Xh2QN8iL72Q+l2n1VufyX3xxfLzBIoGdYHnk5nHk/trzpowyiAXogpzWUKiOiBWopbeMQYC0Kz8tN10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936263; c=relaxed/simple;
	bh=ZmeQeFg8lywN223cH0bKDo/2rtDccmyi41nxp+QJit4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXsOASohfTElOMbv+TEmqNcp1IEbNYBK/1MZtZ8ZHl1RRRaYxIKB+0p/zXeLFL+jExlzNQGzFRSbehm3pD6wJn8TqzM41XLRrD/UEbaojQnTs4ash8iQoI6/eyMYZVqdSPH630kSXkRbkmzd73Z76lEUG/TSVIHwcR0S67nfaPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TiGGwW9f; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TiGGwW9f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936261; x=1786472261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZmeQeFg8lywN223cH0bKDo/2rtDccmyi41nxp+QJit4=;
  b=TiGGwW9fDqN46MKJG7YbHCwiKoawCZZl0CWXW4HrUsqPlgvG92+Qj9Tm
   dOLbjYAJo/u9GKpedT58attwtlE6HwxGkXkAjPHub8M0m5cWcvqgZXq5w
   ojEnzSA6Kfsvx9vK5/nlvRp/HXPyWudxTWMhUk+2WdWXTQuGPAnt0jnNh
   4gjef4qYtlOdMkDa/kk/6NBiHNzvArUTcBZScNJPCQf0vNzDyNLqT+GhH
   YBJLR4kLtRr2UoLX/0tZjHZCNEME224vAs0pOWdmGymulmCXLaonSg8mb
   kjUMwmljZ+y7q8DU8LBEPIAs3/Bu40mx6gHh3SPMCd9x+CdmT9uLgIcuu
   A==;
X-CSE-ConnectionGUID: LSoQ87ZvSnmjHOwJv2vJXQ==
X-CSE-MsgGUID: +RLfu8XWQe+qBh7fVGswQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277400"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277400"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: gGOMIKmjSyO+70k20ogRmg==
X-CSE-MsgGUID: SmYEEH8kSFuaOuUO1NhTYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825654"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 13/32] x86,fs/resctrl: Handle events that can be read from any CPU
Date: Mon, 11 Aug 2025 11:16:47 -0700
Message-ID: <20250811181709.6241-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that monitor events can only be read from a CPU in the
cpumask_t set of each domain.

This is true for x86 events accessed with an MSR interface, but may
not be true for other access methods such as MMIO.

Add a flag to struct mon_evt to indicate if the event can be read on
any CPU.

Architecture uses resctrl_enable_mon_event() to enable an event and
set the flag appropriately.

Bypass all the smp_call*() code for events that can be read on any CPU
and call mon_event_count() directly from mon_event_read().

Add a test for events that can be read from any domain to skip checks
in __mon_event_count() that the read is being done from a CPU in the
correct domain or cache scope.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 +-
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c |  6 ++--
 fs/resctrl/ctrlmondata.c           |  7 +++-
 fs/resctrl/monitor.c               | 53 ++++++++++++++++++++++--------
 5 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 5788e1970d8c..17a21f193a3d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -379,7 +379,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index eb45cf746c5c..45a81be7f241 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -57,6 +57,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @rid:		resource id for this event
  * @name:		name of the event
  * @configurable:	true if the event is configurable
+ * @any_cpu:		true if the event can be read from any CPU
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -64,6 +65,7 @@ struct mon_evt {
 	enum resctrl_res_level	rid;
 	char			*name;
 	bool			configurable;
+	bool			any_cpu;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index fe8af1c69c24..a1c1d6b9e64a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -888,15 +888,15 @@ static __init bool get_rdt_mon_resources(void)
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
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index a99903ac5d27..2e65fddc3408 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -569,6 +569,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		return;
 	}
 
+	if (evt->any_cpu) {
+		mon_event_count(rr);
+		goto out_ctx_free;
+	}
+
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
@@ -581,7 +586,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		smp_call_function_any(cpumask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
-
+out_ctx_free:
 	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index c3f697da612b..d6585f7d1c9e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -356,15 +356,47 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
 	return state ? &state[idx] : NULL;
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
+	struct cacheinfo *ci;
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
+	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
+		return -EINVAL;
+
+	/* Summing domains that share a cache, must be on a CPU for that cache. */
+	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
+
+	return ci && ci->id == rr->ci_id;
+}
+
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
-	int cpu = smp_processor_id();
 	struct rdt_l3_mon_domain *d;
-	struct cacheinfo *ci;
 	struct mbm_state *m;
 	int err, ret;
 	u64 tval = 0;
 
+	if (!cpu_on_correct_domain(rr))
+		return -EINVAL;
+
 	if (rr->r->rid == RDT_RESOURCE_L3 && rr->first) {
 		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
@@ -377,9 +409,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	}
 
 	if (rr->hdr) {
-		/* Reading a single domain, must be on a CPU in that domain. */
-		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
-			return -EINVAL;
+		/* Single domain. */
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
 						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
@@ -390,15 +420,9 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		return 0;
 	}
 
-	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
-		return -EINVAL;
-
-	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
-	if (!ci || ci->id != rr->ci_id)
-		return -EINVAL;
-
 	/*
+	 * Sum across multiple domains.
+	 *
 	 * Legacy files must report the sum of an event across all
 	 * domains that share the same L3 cache instance.
 	 * Report success if a read from any domain succeeds, -EINVAL
@@ -877,7 +901,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
 		return;
@@ -886,6 +910,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 		return;
 	}
 
+	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].enabled = true;
 }
 
-- 
2.50.1

