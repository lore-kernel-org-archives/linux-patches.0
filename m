Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DE93A3815
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343806; cv=none; b=f2ds6mVULYR9M9nTYUKWSMDoRzF/gnKZwxI9vane/y36yo5F8UIq8Htg1z7bF82Hz381FSf8tpcBcApGkU364vBrm1DhfehZ561p8cYoJc5NPMwM8hxk0JVetXhIuj3Vthv7twcO07VrBuMaqvMZ8yFHiRkd8d2y9/o0OVtiOFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343806; c=relaxed/simple;
	bh=5woIoOc43z2dzYZgi/fPqVTgZV6nkyOwMkU2OHyiCx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSPZ1V4AA2aRpmcQXq8qlAppELCK7Jsj0d7fqkCLXtw7Ucocw1MkUhz6tConHGDDvYm5MLebs4E1JsC2ikvw2ko2RHEYXccfD5q2SrDBhs+eLP82nn99Qh7dD6TRvVPfLrOOfS8VoAIDgFgSVB7G6pGo5SFqBrpi3wVBU61/JsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nrGl9hzz; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nrGl9hzz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343805; x=1811879805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5woIoOc43z2dzYZgi/fPqVTgZV6nkyOwMkU2OHyiCx0=;
  b=nrGl9hzzeQ3X896jS5WtvYXE9Q/j6A1pPL8oERvt8F7bxt47uHC4hRhH
   NH6De1joZjwYocbqrjVadRPzFnisrqew5DPBeWFAFr6TD0pqp2xKkiTee
   1KBWVI4gL8V29IRbZ8LboDPv2bg7pHFn6GoJonei4mDOD2BAeIqZ2s2Ir
   uGRhucxX0byZbpML8mF8w56kcutbxYnui1vXkEavxwFsGBUeAs9tFQnDT
   B5iOg6FJwnYI0hT3nx0gcLhawfmrRv9FxDoAS31Qq+rfTayIs4mZvouNG
   B/vzKUUS2skbVjFBXw2AXUb/iJsa8Gzbp6ITxlWGnsnVc03Tcn6mN2ekZ
   A==;
X-CSE-ConnectionGUID: XgTiiktSS+GaWpYydepxLg==
X-CSE-MsgGUID: E6xtN8WIQFGikrwNlQ/qeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011616"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011616"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:43 -0700
X-CSE-ConnectionGUID: wXWD48CBS5+gnTBjaV2KlQ==
X-CSE-MsgGUID: w5wqfjKYSKi/ShwzlBy54w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946511"
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
Subject: [PATCH v7 07/14] x86/resctrl: Maintain a count of enabled monitor features
Date: Mon,  1 Jun 2026 12:56:25 -0700
Message-ID: <20260601195632.15876-8-tony.luck@intel.com>
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

AET (Application Energy Telemetry) may be enabled/disabled from one mount
to the next depending on whether the pmt_telemetry module is loaded. If
AET is the only monitoring feature supported on a system and it is enabled
in one mount, but disabled in a subsequent mount this will result in empty
mon_data directories.

Change from a boolean to a count of enabled monitor features inside
architecture code. File system code only needs to know if any monitor
features are enabled so resctrl_arch_mon_capable() can still return
boolean.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/resctrl.h         |  4 ++--
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c     | 24 +++++++++++++-----------
 arch/x86/kernel/cpu/resctrl/monitor.c  | 11 +++--------
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 575f8408a9e7..1e50c7dc3fe3 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -43,7 +43,7 @@ struct resctrl_pqr_state {
 DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
-extern bool rdt_mon_capable;
+extern int rdt_mon_feature_count;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -68,7 +68,7 @@ static inline void resctrl_arch_disable_alloc(void)
 
 static inline bool resctrl_arch_mon_capable(void)
 {
-	return rdt_mon_capable;
+	return !!rdt_mon_feature_count;
 }
 
 static inline void resctrl_arch_enable_mon(void)
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..3b09cfe9a046 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -224,7 +224,7 @@ union l3_qos_abmc_cfg {
 
 void rdt_ctrl_update(void *arg);
 
-int rdt_get_l3_mon_config(struct rdt_resource *r);
+void rdt_get_l3_mon_config(struct rdt_resource *r);
 
 bool rdt_cpu_has(int flag);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..1af8f965fdd0 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -779,7 +779,7 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
-	rdt_mon_capable = true;
+	rdt_mon_feature_count++;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
@@ -959,30 +959,32 @@ static __init bool get_rdt_alloc_resources(void)
 	return ret;
 }
 
-static __init bool get_rdt_mon_resources(void)
+static __init int get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-	bool ret = false;
+	int ret = 0;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
-		ret = true;
+		ret++;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+		ret++;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+		ret++;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
-		ret = true;
+		ret++;
 
 	if (!ret)
-		return false;
+		return 0;
 
-	return !rdt_get_l3_mon_config(r);
+	rdt_get_l3_mon_config(r);
+
+	return ret;
 }
 
 static __init void __check_quirks_intel(void)
@@ -1013,9 +1015,9 @@ static __init void check_quirks(void)
 static __init bool get_rdt_resources(void)
 {
 	rdt_alloc_capable = get_rdt_alloc_resources();
-	rdt_mon_capable = get_rdt_mon_resources();
+	rdt_mon_feature_count = get_rdt_mon_resources();
 
-	return (rdt_mon_capable || rdt_alloc_capable);
+	return (rdt_mon_feature_count || rdt_alloc_capable);
 }
 
 static __init void rdt_init_res_defs_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 9bd87bae4983..497cc57ac135 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -25,11 +25,8 @@
 
 #include "internal.h"
 
-/*
- * Global boolean for rdt_monitor which is true if any
- * resource monitoring is enabled.
- */
-bool rdt_mon_capable;
+/* Global count of number of resource monitor functions that are enabled. */
+int rdt_mon_feature_count;
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
@@ -402,7 +399,7 @@ static __init int snc_get_config(void)
 	return ret;
 }
 
-int __init rdt_get_l3_mon_config(struct rdt_resource *r)
+void __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
@@ -460,8 +457,6 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 	}
 
 	r->mon_capable = true;
-
-	return 0;
 }
 
 void __init intel_rdt_mbm_apply_quirk(void)
-- 
2.54.0

