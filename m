Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6396A421EFE
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488558; cv=none; b=Gzj//59RS/viTBqCTtMcjnCBsQ9Dwlss6W3U/P+B4+GCwDaPENRIW+wF+JI4oZ1TdSjlllq03laLJHkPkZ5tkprJnz/X1Dt4JYLkiSTvMDV/z5rNq842l7DV5QsD6p9eNCMswl/1QYS5o2R8gh2M6SOSuf/0w6wevJYzwermhWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488558; c=relaxed/simple;
	bh=uter/gm8jUnZpY+z3CK6LuRCuje9VP1rSqbu2Gu5G6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmw48REJfcYKlPftsT10DDQY5BAo+LPWjIdaFC40BzX1h8A1U5HcFx8fyHcKAzwWnApCwFSO82r96pyK22kOCRi/zo7gFiXPWSlQy4bCUHH+aIpm60Qigf/t72o7/fSJvObOBiG99yETILl/Fzun0bHGkNPuZh+33uxcoMVCBjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RP6Cz4iQ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RP6Cz4iQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488553; x=1809024553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uter/gm8jUnZpY+z3CK6LuRCuje9VP1rSqbu2Gu5G6E=;
  b=RP6Cz4iQ6TtBq9RQNMc1GoKWxf5lIoZvKWFML5WmcXcq6n0YZY8y8FXu
   mRpgr/RKwtCj+oKHd1/AbG2ECfvsH5ISvTUZm6E1o7BLcerqD4yUIMQ6V
   S4bRD/h9w62xZGQM9KcmgTJ/7hpu0slhp9pKEP7gqQ1LyrkNVdrLxmHbH
   w/Dy/bU+CwA3+cM5iacWPOKVK0b1/yRXuYFjKNoeIWAowJWgS4u759z8L
   XQ96ZQaIc/94MdWNpylbpPBu6u3hAMJJheqEBxQpMVqnYUXGoJj1nUYCz
   9MHpeRZjpYjVcbnUSjZsuIhwK3XTCuPHCsERJDBfW9AJlW5cwy2DsvxV8
   A==;
X-CSE-ConnectionGUID: C04Lny7zS8ihNAQi/L+9Qg==
X-CSE-MsgGUID: hA1eWyvRTrmcNqGBNTRPEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890704"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890704"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:06 -0700
X-CSE-ConnectionGUID: cZqh32tMToi1oIY5pqGp0A==
X-CSE-MsgGUID: JDgcvwKpQDqPJZeo3nbFpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238323000"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:06 -0700
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
Subject: [PATCH v6 03/10] x86/resctrl: Maintain a count of enabled monitor features
Date: Wed, 29 Apr 2026 11:48:51 -0700
Message-ID: <20260429184858.36423-4-tony.luck@intel.com>
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
2.53.0

